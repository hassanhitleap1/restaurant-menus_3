<?php

if($config['purchase_type'] != 'pro'){
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
}

if(!isset($_GET['page']))
    $_GET['page'] = 1;

$limit = 4;

if(checkloggedin()) {
    $ses_userdata = get_user_data($_SESSION['user']['username']);

    $author_image = $ses_userdata['image'];
    $transactions = array();
    $count = 0;

    $rows = ORM::for_table($config['db']['pre'].'transaction')
        ->where('seller_id',$_SESSION['user']['id'])
        ->order_by_desc('id')
        ->find_many();
    $total_item = count($rows);

    $currency = get_option('currency_code');
    foreach ($rows as $row)
    {
        $transactions[$count]['id'] = $row['id'];
        $transactions[$count]['product_id'] = $row['product_id'];
        $transactions[$count]['product_name'] = $row['product_name'];
        $transactions[$count]['amount'] = price_format($row['amount'],$currency);
        $transactions[$count]['payment_by'] = $row['transaction_gatway'];
        $transactions[$count]['time'] = date('d M Y h:i A', $row['transaction_time']);

        $pro_url = create_slug($row['product_name']);
        $product_link = $config['site_url'].'job/' . $row['product_id'] . '/'.$pro_url;
        $transactions[$count]['product_link'] = $product_link;

        $premium = '';
        if($row['transaction_method'] == 'Subscription'){
            $premium = '<span class="badge blue">'.$lang['MEMBERSHIP'].'</span>';
        }


        $t_status = $row['status'];
        $status = '';
        if ($t_status == "success") {
            $status = '<span class="badge green">'.$lang['SUCCESS'].'</span>';
        } elseif ($t_status == "pending") {
            $status = '<span class="badge blue">'.$lang['PENDING'].'</span>';
        } elseif ($t_status == "failed") {
            $status = '<span class="badge red">'.$lang['FAILED'].'</span>';
        }else{
            $status = '<span class="badge yellow">'.$lang['CANCEL'].'</span>';
        }

        $transactions[$count]['premium'] = $premium;
        $transactions[$count]['status'] = $status;
        $transactions[$count]['invoice'] = $t_status == "success" ? $link['INVOICE'].'/'.$row['id']:'';

        $count++;
    }
    // Output to template
    $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/transaction.tpl');
    $page->SetParameter ('OVERALL_HEADER', create_header($lang['TRANSACTIONS']));
    $page->SetLoop ('TRANSACTIONS', $transactions);
    $page->SetLoop ('PAGES', pagenav($total_item,$_GET['page'],20,$link['TRANSACTION'] ,0));
    $page->SetParameter ('TOTALITEM', $total_item);
    $page->SetLoop ('HTMLPAGE', get_html_pages());
    $page->SetParameter('COPYRIGHT_TEXT', get_option("copyright_text"));
    $page->SetParameter ('AUTHORUNAME', ucfirst($ses_userdata['username']));
    $page->SetParameter ('AUTHORNAME', ucfirst($ses_userdata['name']));
    $page->SetParameter ('AUTHORIMG', $author_image);
    $page->SetParameter ('OVERALL_FOOTER', create_footer());

    $page->CreatePageEcho();
}
else{
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
    exit();
}
?>
