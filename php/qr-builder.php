<?php
if(checkloggedin())
{
    $restaurant = ORM::for_table($config['db']['pre'].'restaurant')
        ->where('user_id', $_SESSION['user']['id'])
        ->find_one();

    $MainFileName = null;
    $main_imageName = get_restaurant_option($restaurant['id'],'qr_image');

    if(isset($_POST['submit'])){
        if(isset($_FILES['qr_image'])) {
            $valid_formats = array("jpeg", "jpg", "png");
            $file = $_FILES['qr_image'];
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
                        if ($main_imageName && file_exists($main_path . $main_imageName)) {
                            unlink($main_path . $main_imageName);
                        }
                    } else {
                        $errors[]['message'] = $lang['ERROR_MAIN_IMAGE'];
                    }
                } else {
                    $errors[]['message'] = $lang['ONLY_JPG_ALLOW'];
                }
            }
        }

        if($MainFileName){
            update_restaurant_option($restaurant['id'],'qr_image',$MainFileName);
        }
        update_restaurant_option($restaurant['id'],'qr_fg_color',$_POST['qr_fg_color']);
        update_restaurant_option($restaurant['id'],'qr_bg_color',$_POST['qr_bg_color']);
        update_restaurant_option($restaurant['id'],'qr_padding',$_POST['qr_padding']);
        update_restaurant_option($restaurant['id'],'qr_radius',$_POST['qr_radius']);
        update_restaurant_option($restaurant['id'],'qr_mode',$_POST['qr_mode']);
        update_restaurant_option($restaurant['id'],'qr_text',$_POST['qr_text']);
        update_restaurant_option($restaurant['id'],'qr_text_color',$_POST['qr_text_color']);
        update_restaurant_option($restaurant['id'],'qr_mode_size',$_POST['qr_mode_size']);
        update_restaurant_option($restaurant['id'],'qr_position_x',$_POST['qr_position_x']);
        update_restaurant_option($restaurant['id'],'qr_position_y',$_POST['qr_position_y']);

        transfer($link['QRBUILDER'],$lang['SAVED_SUCCESS'],$lang['SAVED_SUCCESS']);
        exit;
    }

    if(isset($restaurant['user_id'])){
        $url = $link['RESTAURANT'];
        $id = $restaurant['id'];
        $name = $restaurant['name'];
        $url = $url.'/'.$id.'?qr-id='.urlencode(quick_xor_encrypt($id,'quick-qr'));
    }else{
        $url = $config['site_url'];
    }
    $qr_image = $config['site_url']. "storage/logo/".$config['site_logo'];
    if($image_name = get_restaurant_option($restaurant['id'],'qr_image')){
        $qr_image = $config['site_url']. "storage/restaurant/logo/".$image_name;
    }

    $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/qr_builder.tpl');
    $page->SetParameter ('OVERALL_HEADER', create_header($lang['QRBUILDER']));
    $page->SetParameter ('SCAN_URL', $url);
    $page->SetParameter ('QR_FG_COLOR', get_restaurant_option($restaurant['id'],'qr_fg_color','#000000'));
    $page->SetParameter ('QR_BG_COLOR', get_restaurant_option($restaurant['id'],'qr_bg_color','#ffffff'));
    $page->SetParameter ('QR_PADDING', get_restaurant_option($restaurant['id'],'qr_padding','2'));
    $page->SetParameter ('QR_RADIUS', get_restaurant_option($restaurant['id'],'qr_radius','50'));
    $page->SetParameter ('QR_MODE', get_restaurant_option($restaurant['id'],'qr_mode','2'));
    $page->SetParameter ('QR_IMAGE', $qr_image);
    $page->SetParameter ('QR_TEXT', get_restaurant_option($restaurant['id'],'qr_text',$restaurant['name']));
    $page->SetParameter ('QR_TEXT_COLOR', get_restaurant_option($restaurant['id'],'qr_text_color', $config['theme_color']));
    $page->SetParameter ('QR_MODE_SIZE', get_restaurant_option($restaurant['id'],'qr_mode_size','10'));
    $page->SetParameter ('QR_POSITION_X', get_restaurant_option($restaurant['id'],'qr_position_x','50'));
    $page->SetParameter ('QR_POSITION_Y', get_restaurant_option($restaurant['id'],'qr_position_y','50'));
    $page->SetParameter ('OVERALL_FOOTER', create_footer());
    $page->CreatePageEcho();
}
else{
    headerRedirect($link['LOGIN']);
}
?>