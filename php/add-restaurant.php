<?php
if(checkloggedin())
{
    $restaurant = ORM::for_table($config['db']['pre'].'restaurant')
        ->where('user_id', $_SESSION['user']['id'])
        ->find_one();

    $errors = array();
    if(isset($_POST['submit'])){

        if (empty($_POST['name'])) {
            $errors[]['message'] = $lang['RESTRO_NAME_REQ'];
        }
        if (empty($_POST['description'])) {
            $errors[]['message'] = $lang['RESTRO_DESC_REQ'];
        }
        if (empty($_POST['address'])) {
            $errors[]['message'] = $lang['RESTRO_ADDRESS_REQ'];
        }
        $MainFileName = null;
        $CoverFileName = null;

        if(isset($restaurant['main_image'])){
            $main_imageName = $restaurant['main_image'];
        }else{
            $main_imageName = '';
        }

        if(isset($restaurant['main_image'])){
            $cover_imageName = $restaurant['cover_image'];
        }else{
            $cover_imageName = '';
        }
        // Valid formats
        $valid_formats = array("jpeg", "jpg", "png");

        if(!count($errors) > 0)
        {
            /*Start Restaurant Logo Image Uploading*/
            $file = $_FILES['main_image'];
            $filename = $file['name'];
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            if (!empty($filename)) {
                //File extension check
                if (in_array($ext, $valid_formats)) {
                    $main_path = ROOTPATH . "/storage/restaurant/logo/";
                    $filename = uniqid(time()) . '.' . $ext;
                    if (move_uploaded_file($file['tmp_name'], $main_path . $filename)) {
                        $MainFileName = $filename;
                        resizeImage(300, $main_path . $filename, $main_path . $filename);
                        resizeImage(60, $main_path . 'small_' . $filename, $main_path . $filename);
                        if (file_exists($main_path . $main_imageName) && $main_imageName != 'default.png') {
                            unlink($main_path . $main_imageName);
                            unlink($main_path . 'small_' . $main_imageName);
                        }
                    } else {
                        $errors[]['message'] = $lang['ERROR_MAIN_IMAGE'];
                    }
                } else {
                    $errors[]['message'] = $lang['ONLY_JPG_ALLOW'];
                }
            }
            /*End Restaurant Logo Image Uploading*/

            /*Start Restaurant Cover Image Uploading*/
            $cover_file = $_FILES['cover_image'];
            // Valid formats
            $valid_formats = array("jpeg", "jpg", "png");

            $cover_filename = $cover_file['name'];
            $ext = getExtension($cover_filename);
            $ext = strtolower($ext);
            if (!empty($cover_filename)) {
                //File extension check
                if (in_array($ext, $valid_formats)) {
                    $cover_path = ROOTPATH . "/storage/restaurant/cover/";
                    $cover_filename = uniqid(time()) . '.' . $ext;
                    if (move_uploaded_file($cover_file['tmp_name'], $cover_path . $cover_filename)) {
                        $CoverFileName = $cover_filename;
                        resizeImage(300, $cover_path . $cover_filename, $cover_path . $cover_filename);
                        resizeImage(60, $cover_path . 'small_' . $cover_filename, $cover_path . $cover_filename);
                        if (file_exists($cover_path . $cover_imageName) && $cover_imageName != 'default.png') {
                            unlink($cover_path . $cover_imageName);
                            unlink($cover_path . 'small_' . $cover_imageName);
                        }
                    } else {
                        $errors[]['message'] = $lang['ERROR_COVER_IMAGE'];
                    }
                } else {
                    $errors[]['message'] = $lang['ONLY_JPG_ALLOW'];
                }
            }
            /*End Restaurant Cover Image Uploading*/

        }

        if(count($errors) == 0)
        {
            $now = date("Y-m-d H:i:s");
            if(isset($restaurant['user_id'])){

                if($config['restaurant_text_editor'] == 1)
                    $description = addslashes(validate_input($_POST['description'],true));
                else
                    $description = validate_input($_POST['description']);

                $restaurant_update = ORM::for_table($config['db']['pre'].'restaurant')
                    ->where('user_id', $_SESSION['user']['id'])
                    ->find_one();
                $restaurant_id = $restaurant_update['id'];
                $restaurant_update->set('name', validate_input($_POST['name']));
                $restaurant_update->set('sub_title', validate_input($_POST['sub_title']));
                $restaurant_update->set('timing', validate_input($_POST['timing']));
                $restaurant_update->set('description', $description);
                $restaurant_update->set('address', validate_input($_POST['address']));
                $restaurant_update->set('latitude', validate_input($_POST['latitude']));
                $restaurant_update->set('longitude', validate_input($_POST['longitude']));
                if ($MainFileName) {
                    $restaurant_update->set('main_image', $MainFileName);
                }
                if ($CoverFileName) {
                    $restaurant_update->set('cover_image', $CoverFileName);
                }
                $restaurant_update->save();

            }else{
                $insert_restaurant = ORM::for_table($config['db']['pre'].'restaurant')->create();
                $insert_restaurant->user_id = validate_input($_SESSION['user']['id']);
                $insert_restaurant->name = validate_input($_POST['name']);
                $insert_restaurant->sub_title = validate_input($_POST['sub_title']);
                $insert_restaurant->timing = validate_input($_POST['timing']);
                $insert_restaurant->description = validate_input($_POST['description']);
                $insert_restaurant->address = validate_input($_POST['address']);
                $insert_restaurant->latitude = validate_input($_POST['latitude']);
                $insert_restaurant->longitude = validate_input($_POST['longitude']);
                $insert_restaurant->created_at = $now;
                if ($MainFileName) {
                    $insert_restaurant->main_image = $MainFileName;
                }
                if ($CoverFileName) {
                    $insert_restaurant->cover_image = $CoverFileName;
                }
                $insert_restaurant->save();

                $restaurant_id = $insert_restaurant->id();
            }
            if(isset($_POST['restaurant_template'])){
                update_restaurant_option($restaurant_id,'restaurant_template',$_POST['restaurant_template']);
            }
            if(isset($_POST['restaurant_send_order'])){
                update_restaurant_option($restaurant_id,'restaurant_send_order',$_POST['restaurant_send_order']);
            }

            transfer($link['ADD_RESTAURANT'],$lang['SAVED_SUCCESS'],$lang['SAVED_SUCCESS']);
            exit;
        }
    }


    if(isset($restaurant['user_id'])){
        $restro_id = $restaurant['id'];
        $name = $restaurant['name'];
        $sub_title = $restaurant['sub_title'];
        $timing = $restaurant['timing'];
        $description = stripcslashes(nl2br($restaurant['description']));
        $address = $restaurant['address'];
        $mapLat = $restaurant['latitude'];
        $mapLong = $restaurant['longitude'];
        $main_image = $restaurant['main_image'];
        $cover_image = $restaurant['cover_image'];
        $restaurant_link = $link['RESTAURANT'].'/'.$restro_id.'/'.create_slug($name);
    }else{
        $restro_id = '';
        $name = '';
        $sub_title = '';
        $timing = '';
        $description = '';
        $address = '';
        $mapLat     =  get_option("home_map_latitude");
        $mapLong    =  get_option("home_map_longitude");
        $main_image = 'default.png';
        $cover_image = 'default.png';
        $restaurant_link = '#';
    }

    $restaurant_templates = array();

    if ($handle = opendir('restaurant-templates/'))
    {
        while (false !== ($folder = readdir($handle)))
        {
            if ($folder != "." && $folder != "..")
            {
                $filepath = "restaurant-templates/" . $folder . "/theme-info.txt";
                if(file_exists($filepath)){
                    $themefile = fopen($filepath,"r");

                    $themeinfo = array();
                    while(! feof($themefile)) {
                        $lineRead = fgets($themefile);
                        if (strpos($lineRead, ':') !== false) {
                            $line = explode(':',$lineRead);
                            $key = trim($line[0]);
                            $value = trim($line[1]);
                            $themeinfo[$key] = $value;
                        }
                    }
                    $restaurant_templates[$folder]['folder'] = $folder;
                    $restaurant_templates[$folder]['name'] = $themeinfo['Theme Name'];
                    fclose($themefile);
                }
            }
        }
        closedir($handle);
    }

    // Get usergroup details
    $group_id = get_user_group();
    // Get membership details
    switch ($group_id){
        case 'free':
            $plan = json_decode(get_option('free_membership_plan'), true);
            $settings = $plan['settings'];
            $allow_order = $settings['allow_ordering'];
            break;
        case 'trial':
            $plan = json_decode(get_option('trial_membership_plan'), true);
            $settings = $plan['settings'];
            $allow_order = $settings['allow_ordering'];
            break;
        default:
            $plan = ORM::for_table($config['db']['pre'] . 'plans')
                ->select('settings')
                ->where('id', $group_id)
                ->find_one();
            if(!isset($plan['settings'])){
                $plan = json_decode(get_option('free_membership_plan'), true);
                $settings = $plan['settings'];
                $allow_order = $settings['allow_ordering'];
            }else{
                $settings = json_decode($plan['settings'],true);
                $allow_order = $settings['allow_ordering'];
            }
            break;
    }

    $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/add-restaurant.tpl');
    $page->SetParameter ('OVERALL_HEADER', create_header($lang['MANAGE_RESTAURANT']));
    $page->SetParameter ('SITE_TITLE', $config['site_title']);
    if(count($errors) > 0){
        $page->SetLoop('ERRORS', $errors);
    }else{
        $page->SetLoop('ERRORS', "");
    }

    $page->SetLoop('RESTAURANT_TEMPLATES', $restaurant_templates);
    $page->SetParameter('RESTAURANT_TEMPLATE', get_restaurant_option($restro_id,'restaurant_template','classic-theme'));
    $page->SetParameter ('RESTAURANT_SEND_ORDER', get_restaurant_option($restro_id,'restaurant_send_order',1));
    $page->SetParameter ('ALLOW_ORDERING', $allow_order);
    $page->SetParameter('RESTRO_LINK', $restaurant_link);
    $page->SetParameter('RESTRO_ID', $restro_id);
    $page->SetParameter('NAME', $name);
    $page->SetParameter('SUB_TITLE', $sub_title);
    $page->SetParameter('TIMING', $timing);
    $page->SetParameter('DESCRIPTION', $description);
    $page->SetParameter('ADDRESS', $address);
    $page->SetParameter('MAIN_IMAGE', $main_image);
    $page->SetParameter('COVER_IMAGE', $cover_image);
    $page->SetParameter('LATITUDE', $mapLat);
    $page->SetParameter('LONGITUDE', $mapLong);
    $page->SetParameter('MAP_COLOR', $config['map_color']);
    $page->SetParameter('ZOOM', $config['home_map_zoom']);
    $page->SetParameter ('OVERALL_FOOTER', create_footer());
    $page->CreatePageEcho();
}
else{
    headerRedirect($link['LOGIN']);
}
?>