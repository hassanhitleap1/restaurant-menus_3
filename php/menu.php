<?php
if (checkloggedin()) {
    $errors = array();
    $cat = array();

    $ses_userdata = get_user_data($_SESSION['user']['username']);
    $currency = !empty($ses_userdata['currency'])?$ses_userdata['currency']:get_option('currency_code');

    $result = ORM::for_table($config['db']['pre'] . 'catagory_main')
        ->where('user_id', $_SESSION['user']['id'])
        ->order_by_desc('cat_id')
        ->find_many();
    $count = 0;
    foreach ($result as $info) {
        $cat[$count]['id'] = $info['cat_id'];
        $cat[$count]['name'] = $info['cat_name'];

        $count_menu = ORM::for_table($config['db']['pre'] . 'menu')
            ->where(array(
                'cat_id' => $info['cat_id']
            ))
            ->count();
        $cat[$count]['menu_count'] = $count_menu;
        if ($count_menu) {
            $menu_tpl = '';
            $menu = ORM::for_table($config['db']['pre'] . 'menu')
                ->where(array(
                    'cat_id' => $info['cat_id']
                ))
                ->order_by_desc('id')
                ->find_many();
            foreach ($menu as $info2) {
                $menuId = $info2['id'];
                $menuName = $info2['name'];
                $menuDesc = $info2['description'];
                $menuPrice = price_format($info2['price'],$currency);
                $menuImage = !empty($info2['image'])?$info2['image']:'default.png';

                $menu_tpl .= '
                <div class="col-lg-4 margin-bottom-30">
                    <div class="card">
                        <img class="card-img-top"  src="' . $config['site_url'] . 'storage/menu/' . $menuImage . '" alt="' . $menuName . '">
                        <div class="card-body">
                            <h3 class="card-title">' . $menuName . '</h3>
                            <p class="card-text">' . $menuDesc . '</p>
                            <div class="d-flex align-items-center">
                                <span class="small-label margin-left-0">' . $menuPrice . '</span>
                                <div class="margin-left-auto">
                                    <a href="#" data-id="' . $menuId . '" data-catid="' . $info['cat_id'] . '" class="button ripple-effect btn-sm edit_menu_item" title="'.$lang['EDIT_MENU'].'" data-tippy-placement="top"><i class="icon-feather-edit"></i></a>
                                    <a href="'.$link['MENU'].'/'.$menuId.'" class="button ripple-effect btn-sm" title="'.$lang['EXTRAS'].'" data-tippy-placement="top"><i class="icon-feather-layers"></i></a>
                                    <a href="#" data-id="' . $menuId . '" class="popup-with-zoom-anim button red ripple-effect btn-sm delete_menu_item" title="'.$lang['DELETE_MENU'].'" data-tippy-placement="top"><i class="icon-feather-trash-2"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                ';

                $cat[$count]['menu'] = $menu_tpl;
            }
        } else {
            $cat[$count]['menu'] = '<div class="col-lg-12 margin-bottom-30 text-center">' . $lang['MENU_NOT_AVAILABLE'] . '</div>';
        }
        $count++;
    }

    $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/menu.tpl');
    $page->SetParameter('OVERALL_HEADER', create_header($lang['MANAGE_MENU']));
    $page->SetLoop('CATEGORY', $cat);
    if (count($errors) > 0) {
        $page->SetLoop('ERRORS', $errors);
    } else {
        $page->SetLoop('ERRORS', "");
    }
    $page->SetParameter('OVERALL_FOOTER', create_footer());
    $page->CreatePageEcho();
} else {
    headerRedirect($link['LOGIN']);
}
?>