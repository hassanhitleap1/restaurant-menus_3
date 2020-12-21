<?php
if(isset($_GET['id'])){
    $restaurant = ORM::for_table($config['db']['pre'].'restaurant')->find_one($_GET['id']);
    if(isset($restaurant['name'])){

        // Get usergroup details
        $user_info = ORM::for_table($config['db']['pre'].'user')
            ->select('group_id')
            ->find_one($restaurant['user_id']);

        $group_id = isset($user_info['group_id'])? $user_info['group_id'] : 0;

        // Get membership details
        switch ($group_id){
            case 'free':
                $plan = json_decode(get_option('free_membership_plan'), true);
                $settings = $plan['settings'];
                $limit = $settings['scan_limit'];
                break;
            case 'trial':
                $plan = json_decode(get_option('trial_membership_plan'), true);
                $settings = $plan['settings'];
                $limit = $settings['scan_limit'];
                break;
            default:
                $plan = ORM::for_table($config['db']['pre'] . 'plans')
                    ->select('settings')
                    ->where('id', $group_id)
                    ->find_one();
                if(!isset($plan['settings'])){
                    $plan = json_decode(get_option('free_membership_plan'), true);
                    $settings = $plan['settings'];
                    $limit = $settings['scan_limit'];
                }else{
                    $settings = json_decode($plan['settings'],true);
                    $limit = $settings['scan_limit'];
                }
                break;
        }

        // check for url
        if(!empty($_GET['qr-id'])){
            $qr_id = quick_xor_decrypt(urldecode($_GET['qr-id']),'quick-qr');
            if($_GET['id'] == $qr_id){

                if($limit != "999"){
                    $start = date('Y-m-01');
                    $end = date('Y-m-t');

                    $total = ORM::for_table($config['db']['pre'].'restaurant_view')
                        ->where('restaurant_id', $_GET['id'])
                        ->where_raw("`date` BETWEEN '$start' AND '$end'")
                        ->count();

                    if($total >= $limit){
                        message($lang['NOTIFY'], $lang['SCAN_LIMIT_EXCEED']);
                        exit();
                    }
                }

                $add_view = ORM::for_table($config['db']['pre'].'restaurant_view')->create();
                $add_view->restaurant_id = $_GET['id'];
                $add_view->ip = get_client_ip();
                $add_view->date = date('Y-m-d H:i:s');
                $add_view->save();

                headerRedirect($link['RESTAURANT'].'/'.$restaurant['id'].'/'.create_slug($restaurant['name']));
            }
        }

        $restro_id = $restaurant['id'];
        $name = $restaurant['name'];
        $sub_title = $restaurant['sub_title'];
        $timing = $restaurant['timing'];
        $description = nl2br(stripcslashes($restaurant['description']));
        $address = $restaurant['address'];
        $mapLat = $restaurant['latitude'];
        $mapLong = $restaurant['longitude'];
        $main_image = $restaurant['main_image'];
        $cover_image = $restaurant['cover_image'];

        $userdata = get_user_data(null, $restaurant['user_id']);

        $restaurant_template = get_restaurant_option($restro_id,'restaurant_template','classic-theme');

        $category = array();
        $cat = array();

        $currency = !empty($userdata['currency'])?$userdata['currency']:get_option('currency_code');
        $currency_data = get_currency_by_code($currency);

        $menu_layout = !empty($userdata['menu_layout'])?$userdata['menu_layout']:'both';
        if($menu_layout == 'grid'){
            $grid_layout = 'style="display:block"';
            $list_layout = 'style="display:none"';
        }else if($menu_layout == 'list'){
            $grid_layout = 'style="display:none"';
            $list_layout = 'style="display:block"';
        }else{
            $grid_layout = 'style="display:none"';
            $list_layout = 'style="display:block"';
        }

        $total_menus = array();
        $result = ORM::for_table($config['db']['pre'].'catagory_main')
            ->where('user_id', $restaurant['user_id'])
            ->order_by_desc('cat_id')
            ->find_many();
        $count = 0;
        foreach ($result as $info) {
            if($settings['category_limit'] != "999" && $count >= $settings['category_limit']){
                break;
            }

            $category[$count]['id'] = $info['cat_id'];
            $category[$count]['name'] = ucfirst($info['cat_name']);

            $cat[$count]['id'] = $info['cat_id'];
            $cat[$count]['name'] = ucfirst($info['cat_name']);

            $count_menu = ORM::for_table($config['db']['pre'].'menu')
                ->where(array(
                    'cat_id' => $info['cat_id'],
                    'active' => '1'
                ))
                ->count();

            $cat[$count]['menu_count'] = $count_menu;

            if($count_menu){
                $menu_tpl = '';
                $menu = ORM::for_table($config['db']['pre'].'menu')
                    ->where(array(
                        'cat_id' => $info['cat_id'],
                        'active' => '1'
                    ))
                    ->order_by_desc('id')
                    ->find_many();
                $menu_count = 0;
                foreach ($menu as $info2) {
                    if($settings['menu_limit'] != "999" && $menu_count >= $settings['menu_limit']){
                        break;
                    }
                    $menuId = $info2['id'];
                    $menuName = ucfirst($info2['name']);
                    $menuDesc = $info2['description'];
                    $menuType = $info2['type'];
                    $menuPrice = price_format($info2['price'],$currency);
                    $menuImage = $info2['image'];

                    $extras_data = ORM::for_table($config['db']['pre'] . 'menu_extras')
                        ->where(array(
                            'menu_id' => $menuId,
                            'active' => 1
                        ))
                        ->order_by_desc('position')
                        ->find_many();


                    $extras = array();
                    foreach ($extras_data as $info) {
                        $data = array();
                        $data['id'] = $info['id'];
                        $data['title'] = htmlentities( (string) $info['title'], ENT_QUOTES, 'UTF-8' );
                        $data['price'] = $info['price'];
                        $extras[$info['id']] = $data;
                    }

                    $menu_data_array = array();
                    $menu_data_array['id'] = $menuId;
                    $menu_data_array['title'] = htmlentities( (string) $menuName, ENT_QUOTES, 'UTF-8' );
                    $menu_data_array['price'] = $info2['price'];
                    $menu_data_array['type'] = $menuType;
                    $menu_data_array['description'] = htmlentities( (string) $menuDesc, ENT_QUOTES, 'UTF-8' );
                    $menu_data_array['extras'] = $extras;
                    $total_menus[$menuId] = $menu_data_array;

                    $menuDescLimit = strlimiter($menuDesc,50);

                    if($restaurant_template == 'classic-theme') {
                        $menu_tpl .= '
                            <div class="col-xl-3 col-lg-6 col-md-6 col-sm-6 ajax-item-listing menu-grid-view" ' . $grid_layout . ' data-id="' . $menuId . '" data-name="' . $menuName . '" data-price="' . $menuPrice . '" data-amount="' . $info2['price'] . '" data-description="' . $menuDesc . '" data-image-url="' . $config['site_url'] . 'storage/menu/' . $menuImage . '">
                                <div class="menu_item">
                                    <figure>
                                        <a href="#" class="add-extras"><img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="' . $config['site_url'] . 'storage/menu/' . $menuImage . '" alt="' . $menuName . '"></a>
                                    </figure>
                                    <div class="menu_detail">
                                        <h4 class="menu_post">
                                            <a href="#" class="add-extras"><span class="menu_title">' . $menuName . '</span></a>
                                            <span class="menu_price">' . $menuPrice . '</span>
                                        </h4>
                                        <div class="menu_excerpt"><div>' . $menuDesc . '</div><div class="margin-left-auto padding-left-10"><button type="button" class="button add-item-button add-extras">' . $lang['ADD'] . '</button></div></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-6 col-md-6 col-sm-6 ajax-item-listing menu-list-view" ' . $list_layout . ' data-id="' . $menuId . '" data-name="' . $menuName . '" data-price="' . $menuPrice . '" data-amount="' . $info2['price'] . '" data-description="' . $menuDesc . '" data-image-url="' . $config['site_url'] . 'storage/menu/' . $menuImage . '">
                                <div class="menu_detail add-extras">
                                    <h4 class="menu_post">
                                        <span class="menu_title">' . $menuName . '</span>
                                        <span class="menu_dots"></span>
                                        <span class="menu_price">' . $menuPrice . '</span>
                                    </h4>
                                    <div class="menu_excerpt"><div>' . $menuDesc . '</div><div class="margin-left-auto padding-left-10"><button type="button" class="button add-item-button">' . $lang['ADD'] . '</button></div></div>
                                </div>
                            </div>';
                    }else{
                        $menu_tpl .= '<div class="section-menu" data-id="' . $menuId . '" data-name="' . $menuName . '" data-price="' . $menuPrice . '" data-amount="' . $info2['price'] . '" data-description="' . $menuDesc . '" data-image-url="' . $config['site_url'] . 'storage/menu/' . $menuImage . '">
                        <div class="menu-item list">
                        '.
                            (!empty($menuImage != 'default.png') ?
                                '<div class="menu-image">
                                    <img src="' . $config['site_url'] . 'storage/menu/' . $menuImage . '">
                                    <div class="badge abs ' . $menuType . '"><i class="fa fa-circle"></i></div>
                                </div>' :
                                '<div class="badge ' . $menuType . ' only"><i class="fa fa-circle"></i></div>')
                            .' 
                            <div class="menu-content">
                                <div class="menu-detail">
                                    <div class="menu-title">
                                        <h4>' . $menuName . '</h4>
                                        <div class="menu-price">' . $menuPrice . '</div>
                                    </div>
                                    <div class="add-menu">
                                        <div class="add-btn add-item-to-order">
                                            <span>' . $lang['ADD'] . '</span>
                                            <i class="icon-feather-plus"></i>
                                        </div>
                            '.
                            (!empty($extras)?'<span class="customize">' . $lang['CUSTOMIZABLE'] . '</span>':'')
                            .'        </div>
                                </div>
                                <div class="menu-recipe">' . $menuDescLimit . '</div>
                            </div>
                        </div>
                    </div>';
                    }

                    $cat[$count]['menu'] = $menu_tpl;
                    $menu_count++;
                }
            }else{
                if($restaurant_template == 'classic-theme') {
                    $cat[$count]['menu'] = '<div class="col-lg-12 margin-bottom-30 text-center">' . $lang['MENU_NOT_AVAILABLE'] . '</div>';
                }else{
                    $cat[$count]['menu'] = '';
                }
            }
            $count++;
        }
        $allow_order = $settings['allow_ordering'] ? get_restaurant_option($restro_id,'restaurant_send_order',1) : 0;

        $page = new HtmlTemplate ('restaurant-templates/' . $restaurant_template . '/index.tpl');
        $page->SetParameter ('OVERALL_HEADER', create_header($lang['RESTAURANT']));
        $page->SetParameter ('SITE_TITLE', $config['site_title']);
        $page->SetParameter ('RESTAURANT_TEMPLATE', $restaurant_template);
        $page->SetParameter ('RESTAURANT_SEND_ORDER', $allow_order);
        $page->SetLoop('CATEGORY', $category);
        $page->SetLoop('CAT_MENU', $cat);
        $page->SetParameter('RESTRO_ID', $restro_id);
        $page->SetParameter('NAME', $name);
        $page->SetParameter('SUB_TITLE', $sub_title);
        $page->SetParameter('TIMING', $timing);
        $page->SetParameter('DESCRIPTION', $description);
        $page->SetParameter('ADDRESS', $address);
        $page->SetParameter('PHONE', $userdata['phone']);
        $page->SetParameter('MAIN_IMAGE', $main_image);
        $page->SetParameter('COVER_IMAGE', $cover_image);
        $page->SetParameter('LATITUDE', $mapLat);
        $page->SetParameter('LONGITUDE', $mapLong);
        $page->SetParameter('MAP_COLOR', $config['map_color']);
        $page->SetParameter('ZOOM', $config['home_map_zoom']);
        $page->SetParameter('CURRENCY_SIGN', $currency_data['html_entity']);
        $page->SetParameter('CURRENCY_LEFT', $currency_data['in_left']);
        $page->SetParameter('CURRENCY_DECIMAL_PLACES', $currency_data['decimal_places']);
        $page->SetParameter('CURRENCY_DECIMAL_SEPARATOR', $currency_data['decimal_separator']);
        $page->SetParameter('CURRENCY_THOUSAND_SEPARATOR', $currency_data['thousand_separator']);
        $page->SetParameter('MENU_LAYOUT', $menu_layout);
        $page->SetParameter('TOTAL_MENUS', json_encode($total_menus));
        $page->SetParameter('PAGE_TITLE', $name);
        $page->SetParameter('PAGE_LINK', (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http") . "://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]");
        $page->SetParameter('PAGE_META_KEYWORDS', $config['meta_keywords']);
        $page->SetParameter('PAGE_META_DESCRIPTION', $config['meta_description']);
        $page->SetParameter('LANGUAGE_DIRECTION', get_current_lang_direction());

        $themecolor = $config['theme_color'];
        $colors = array();
        list($r, $g, $b) = sscanf($themecolor, "#%02x%02x%02x");
        $i = 0.01;
        while($i <= 1){
            $colors["$i"]['id'] = str_replace('.','_',$i);
            $colors["$i"]['value'] = "rgba($r,$g,$b,$i)";
            $i += 0.01;
        }
        $colors[1]['id'] = 1;
        $colors[1]['value'] = "rgba($r,$g,$b,1)";
        $page->SetLoop ('COLORS',$colors);
        $page->SetParameter ('OVERALL_FOOTER', create_footer());
        $page->CreatePageEcho();
    }else{
        error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
        exit();
    }
}
else{
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
    exit();
}
?>