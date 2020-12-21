<?php
if (checkloggedin()) {
    $ses_userdata = get_user_data($_SESSION['user']['username']);
    $currency = !empty($ses_userdata['currency']) ? $ses_userdata['currency'] : get_option('currency_code');

    if(!isset($_GET['page']))
        $page = 1;
    else
        $page = $_GET['page'];

    $limit = 25;
    $offset = ($page - 1) * $limit;
    $total_orders = 0;

    $orders_data = array();
    $restaurant = ORM::for_table($config['db']['pre'] . 'restaurant')
        ->where('user_id', $_SESSION['user']['id'])
        ->find_one();

    if (isset($restaurant['user_id'])) {
        // get orders
        $orders_query = ORM::for_table($config['db']['pre'] . 'orders')
            ->where(array(
                'restaurant_id' => $restaurant['id']
            ))
            ->order_by_desc('id');

        $total_orders = $orders_query->count();

        $orders = $orders_query
            ->limit($limit)
            ->offset($offset)
            ->find_many();

        foreach ($orders as $order) {
            $orders_data[$order['id']]['id'] = $order['id'];
            $orders_data[$order['id']]['customer_name'] = $order['customer_name'];
            $orders_data[$order['id']]['table_number'] = $order['table_number'];
            $orders_data[$order['id']]['status'] = $order['status'];
            $orders_data[$order['id']]['message'] = $order['message'];
            $orders_data[$order['id']]['created_at'] = date('d M Y h:i A',strtotime($order['created_at']));

            // get order items
            $order_items = ORM::for_table($config['db']['pre'] . 'order_items')
                ->table_alias('oi')
                ->select_many('oi.*', 'm.name', 'm.price')
                ->where(array(
                    'order_id' => $order['id']
                ))
                ->join($config['db']['pre'] . 'menu', array('oi.item_id', '=', 'm.id'), 'm')
                ->order_by_desc('id')
                ->find_many();

            $orders_data[$order['id']]['items_tpl'] = '';
            $price = 0;
            foreach ($order_items as $order_item) {
                $tpl = '<div class="order-table-item">';
                $tpl .= '<strong><i class="icon-material-outline-restaurant"></i> '.$order_item['name'].'</strong>';
                if($order_item['quantity'] > 1){
                    $tpl .= ' &times; '.$order_item['quantity'];
                }
                $price += $order_item['price'] * $order_item['quantity'];

                // get order extras
                $order_item_extras = ORM::for_table($config['db']['pre'] . 'order_item_extras')
                    ->table_alias('oie')
                    ->select_many('oie.*', 'me.title', 'me.price')
                    ->where(array(
                        'order_item_id' => $order_item['id']
                    ))
                    ->join($config['db']['pre'] . 'menu_extras', array('oie.extra_id', '=', 'me.id'), 'me')
                    ->order_by_desc('id')
                    ->find_many();
                if($order_item_extras->count()) {
                    $tpl .= '<div  class="padding-left-10">';
                    foreach ($order_item_extras as $order_item_extra) {
                        $price += $order_item_extra['price'] * $order_item['quantity'];
                        $tpl .= '<div><i class="icon-feather-plus"></i> ' . $order_item_extra['title'].'</div>';
                    }
                    $tpl .= '</div>';
                }
                $tpl .= '</div>';
                $orders_data[$order['id']]['items_tpl'] .= $tpl;
                $orders_data[$order['id']]['price'] = price_format($price,$currency);
            }

            $orders = ORM::for_table($config['db']['pre'] . 'orders')->find_one($order['id']);
            $orders->seen = 1;
            $orders->save();
        }
    }

    $paging = pagenav($total_orders, $page, $limit, $link['ORDER']);
    $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/orders.tpl');
    $page->SetParameter('OVERALL_HEADER', create_header($lang['ORDERS']));
    $page->SetParameter('ORDERS_FOUND', (int)(count($orders_data) > 0));
    $page->SetLoop('ORDERS', $orders_data);
    $page->SetLoop('PAGES', $paging);
    $page->SetParameter('SHOW_PAGING', (int)($total_orders > $limit));
    $page->SetParameter('OVERALL_FOOTER', create_footer());
    $page->CreatePageEcho();
} else {
    headerRedirect($link['LOGIN']);
}