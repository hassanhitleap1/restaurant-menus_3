<?php
if (checkloggedin()) {
    $ses_userdata = get_user_data($_SESSION['user']['username']);
    $currency = !empty($ses_userdata['currency'])?$ses_userdata['currency']:get_option('currency_code');
    $currency_data = get_currency_by_code($currency);

    $menu = ORM::for_table($config['db']['pre'] . 'menu')
        ->where(array(
            'id' => $_GET['id']
        ))
        ->find_one();

    if(!empty($menu['id'])) {
        $menuId = $menu['id'];
        $menuName = $menu['name'];
        $menuPrice = $currency_data['html_entity'] . $menu['price'];
        $menuImage = !empty($menu['image']) ? $menu['image'] : 'default.png';

        $extras_data = ORM::for_table($config['db']['pre'] . 'menu_extras')
            ->where(array(
                'menu_id' => $menuId
            ))
            ->order_by_desc('position')
            ->find_many();

        $extra = array();
        foreach ($extras_data as $info) {
            $extra[$info['id']]['id'] = $info['id'];
            $extra[$info['id']]['title'] = $info['title'];
            $extra[$info['id']]['price'] = $info['price'];
            $extra[$info['id']]['active'] = $info['active'];
        }

        $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/menu-edit.tpl');
        $page->SetParameter('OVERALL_HEADER', create_header($lang['MANAGE_MENU']));
        $page->SetParameter('MENU_ID', $menuId);
        $page->SetParameter('MENU_NAME', $menuName);
        $page->SetParameter('MENU_PRICE', $menuPrice);
        $page->SetParameter('MENU_IMAGE', $menuImage);
        $page->SetLoop('EXTRAS', $extra);
        $page->SetParameter('OVERALL_FOOTER', create_footer());
        $page->CreatePageEcho();
    }else{
        // 404 page
        error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
    }
} else {
    headerRedirect($link['LOGIN']);
}