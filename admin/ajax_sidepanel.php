<?php
/*
Copyright (c) 2020 Bylancer.com
*/

require_once('../includes/config.php');
require_once('../includes/sql_builder/idiorm.php');
require_once('../includes/db.php');
require_once('../includes/classes/class.template_engine.php');
require_once('../includes/classes/class.country.php');
require_once('../includes/lib/HTMLPurifier/HTMLPurifier.standalone.php');
require_once('../includes/functions/func.global.php');
require_once('../includes/functions/func.admin.php');
require_once('../includes/functions/func.sqlquery.php');
require_once('../includes/functions/func.users.php');
require_once('../includes/classes/GoogleTranslate.php');
require_once('../includes/lang/lang_'.$config['lang'].'.php');

admin_session_start();
checkloggedadmin();

if (!isset($_SESSION['admin']['id'])) {
    exit('Access Denied.');
}

require_once('../includes/seo-url.php');


//SidePanel Ajax Function
if(isset($_GET['action'])){
    if(!check_allow()){
        $status = "Sorry:";
        $message = "permission denied for demo.";
        echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
        die();
    }

    if ($_GET['action'] == "addAdmin") { addAdmin(); }
    if ($_GET['action'] == "editAdmin") { editAdmin(); }
    if ($_GET['action'] == "addUser") { addUser(); }
    if ($_GET['action'] == "editUser") { editUser(); }

    if ($_GET['action'] == "addCurrency") { addCurrency(); }
    if ($_GET['action'] == "editCurrency") { editCurrency(); }
    if ($_GET['action'] == "addTimezone") { addTimezone(); }
    if ($_GET['action'] == "editTimezone") { editTimezone(); }
    if ($_GET['action'] == "addLanguage") { addLanguage(); }
    if ($_GET['action'] == "editLanguage") { editLanguage(); }

    if ($_GET['action'] == "addMembershipPlan") { addMembershipPlan(); }
    if ($_GET['action'] == "editMembershipPlan") { editMembershipPlan(); }
    if ($_GET['action'] == "addMembershipPackage") { addMembershipPackage(); }
    if ($_GET['action'] == "editMembershipPackage") { editMembershipPackage(); }

    if ($_GET['action'] == "addTax") { addTax(); }
    if ($_GET['action'] == "editTax") { editTax(); }

    if ($_GET['action'] == "addStaticPage") { addStaticPage(); }
    if ($_GET['action'] == "editStaticPage") { editStaticPage(); }
    if ($_GET['action'] == "addFAQentry") { addFAQentry(); }
    if ($_GET['action'] == "editFAQentry") { editFAQentry(); }

    if ($_GET['action'] == "transactionEdit") { transactionEdit(); }
    if ($_GET['action'] == "paymentEdit") { paymentEdit(); }

    if ($_GET['action'] == "SaveSettings") { SaveSettings(); }
    if ($_GET['action'] == "saveEmailTemplate") { saveEmailTemplate(); }
    if ($_GET['action'] == "testEmailTemplate") { testEmailTemplate(); }

    if ($_GET['action'] == "addTestimonial") { addTestimonial(); }
    if ($_GET['action'] == "editTestimonial") { editTestimonial(); }

}


function addTestimonial(){
    global $lang,$config;

    $title = validate_input($_POST['name']);
    $designation = validate_input($_POST['designation']);
    $image = null;
    $description = validate_input($_POST['content']);
    $error = array();

    if(empty($title)){
        $error[] = "Name is required.";
    }
    if(empty($designation)){
        $error[] = "Designation is required.";
    }
    if(empty($description)){
        $error[] = "Content is required.";
    }

    if(empty($error)){
        if(!empty($_FILES['image'])){
            $file = $_FILES['image'];
            // Valid formats
            $valid_formats = array("jpeg", "jpg", "png");
            $filename = $file['name'];
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            if (!empty($filename)) {
                //File extension check
                if (in_array($ext, $valid_formats)) {
                    $main_path = "../storage/testimonials/";
                    $filename = uniqid(time()).'.'.$ext;
                    if(move_uploaded_file($file['tmp_name'], $main_path.$filename)){
                        $image = $filename;
                        resizeImage(100,$main_path.$filename,$main_path.$filename);
                    }else{
                        $error[] = 'Unexpected error, please try again.';
                    }
                } else {
                    $error[] = 'Only jpeg, jpg & png files allowed.';
                }
            }
        }
    }

    if (empty($error)) {
        $test = ORM::for_table($config['db']['pre'].'testimonials')->create();
        $test->name = $title;
        $test->designation = $designation;
        $test->image = $image;
        $test->content = $description;
        $test->save();

        $status = "success";
        $message = $lang['SAVED_SUCCESS'];

        echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
        die();
    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }
    $json = '{"status" : "' . $status . '","message" : "' . $message . '","errors" : ' . json_encode($error, JSON_UNESCAPED_SLASHES) . '}';
    echo $json;
    die();
}

function editTestimonial(){
    global $lang,$config;

    $title = validate_input($_POST['name']);
    $designation = validate_input($_POST['designation']);
    $image = null;
    $description = validate_input($_POST['content']);
    $error = array();

    if(empty($title)){
        $error[] = "Name is required.";
    }
    if(empty($designation)){
        $error[] = "Designation is required.";
    }
    if(empty($description)){
        $error[] = "Content is required.";
    }

    if(empty($error)){
        if(!empty($_FILES['image'])){
            $file = $_FILES['image'];
            // Valid formats
            $valid_formats = array("jpeg", "jpg", "png");
            $filename = $file['name'];
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            if (!empty($filename)) {
                //File extension check
                if (in_array($ext, $valid_formats)) {
                    $main_path = "../storage/testimonials/";
                    $filename = uniqid(time()).'.'.$ext;
                    if(move_uploaded_file($file['tmp_name'], $main_path.$filename)){
                        $image = $filename;
                        resizeImage(100,$main_path.$filename,$main_path.$filename);

                        // remove old image
                        $info = ORM::for_table($config['db']['pre'].'testimonials')
                            ->select('image')
                            ->find_one($_POST['id']);

                        if($info['image'] != "default.png"){
                            if(file_exists($main_path.$info['image'])){
                                unlink($main_path.$info['image']);
                            }
                        }
                    }else{
                        $error[] = 'Unexpected error, please try again.';
                    }
                } else {
                    $error[] = 'Only jpeg, jpg & png files allowed.';
                }
            }
        }
    }

    if (empty($error)) {
        $test = ORM::for_table($config['db']['pre'].'testimonials')->find_one($_POST['id']);
        $test->name = $title;
        $test->designation = $designation;
        if($image){
            $test->image = $image;
        }
        $test->content = $description;
        $test->save();

        $status = "success";
        $message = $lang['SAVED_SUCCESS'];

        echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
        die();
    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }
    $json = '{"status" : "' . $status . '","message" : "' . $message . '","errors" : ' . json_encode($error, JSON_UNESCAPED_SLASHES) . '}';
    echo $json;
    die();
}

function change_config_file_settings($filePath, $newSettings,$lang)
{
    // Update $fileSettings with any new values
    $fileSettings = array_merge($lang, $newSettings);
    // Build the new file as a string
    $newFileStr = "<?php\n";
    foreach ($fileSettings as $name => $val) {
        // Using var_export() allows you to set complex values such as arrays and also
        // ensures types will be correct
        $newFileStr .= "\$lang['$name'] = " . var_export($val, true) . ";\n";
    }
    // Closing tag intentionally omitted, you can add one if you want

    // Write it back to the file
    file_put_contents($filePath, $newFileStr);

}

function addAdmin(){
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $valid_formats = array("jpg","jpeg","png"); // Valid image formats

        if ($_FILES['file']['name'] != "") {

            $filename = stripslashes($_FILES['file']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = '../storage/profile/';
                $original_filename = $_FILES['file']['name'];
                $random1 = rand(9999, 100000);
                $random2 = rand(9999, 200000);
                $random3 = $random1 . $random2;
                $extensions = explode(".", $original_filename);
                $extension = $extensions[count($extensions) - 1];
                $uniqueName = $random3 . "." . $extension;
                $uploadfile = $uploaddir . $uniqueName;

                $file_type = "file";

                if ($extension == "jpg" || $extension == "jpeg" || $extension == "gif" || $extension == "png") {
                    $file_type = "image";

                    $size = filesize($_FILES['file']['tmp_name']);

                    $image = $_FILES["file"]["name"];
                    $uploadedfile = $_FILES['file']['tmp_name'];

                    if ($image) {
                        if ($extension == "jpg" || $extension == "jpeg") {
                            $uploadedfile = $_FILES['file']['tmp_name'];
                            $src = imagecreatefromjpeg($uploadedfile);
                        } else if ($extension == "png") {
                            $uploadedfile = $_FILES['file']['tmp_name'];
                            $src = imagecreatefrompng($uploadedfile);
                        } else {
                            $src = imagecreatefromgif($uploadedfile);
                        }

                        list($width, $height) = getimagesize($uploadedfile);

                        $newwidth = 225;
                        $newheight = 225;
                        //$newheight = ($height / $width) * $newwidth;
                        $tmp = imagecreatetruecolor($newwidth, $newheight);

                        imagecopyresampled($tmp, $src, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);

                        $filename = $uploaddir . "small" . $uniqueName;

                        imagejpeg($tmp, $filename, 100);

                        imagedestroy($src);
                        imagedestroy($tmp);
                    }


                }
                //else if it's not bigger then 0, then it's available '
                //and we send 1 to the ajax request
                if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)) {
                    //$time = date('Y-m-d H:i:s', time());
                    $password = $_POST["password"];
                    $pass_hash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 13]);

                    $admins = ORM::for_table($config['db']['pre'].'admins')->create();
                    $admins->username = $_POST['username'];
                    $admins->password_hash = $pass_hash;
                    $admins->name = $_POST['name'];
                    $admins->email = $_POST['email'];
                    $admins->image = $uniqueName;
                    $admins->save();

                    if ($admins->id()) {
                        $status = "success";
                        $message = $lang['SAVED_SUCCESS'];
                    } else{
                        $status = "error";
                        $message = $lang['ERROR_TRY_AGAIN'];
                    }
                }
            }
            else {
                $error = "Only allowed jpg, jpeg png";
                $status = "error";
                $message = $error;
            }

        } else {
            $error = "Profile Picture Required";
            $status = "error";
            $message = $error;
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editAdmin(){
    global $config,$lang;

    if (isset($_POST['id'])) {
        $password = $_POST["newPassword"];

        if(isset($_FILES['file']['name']) && $_FILES['file']['name'] != "")
        {
            $valid_formats = array("jpg","jpeg","png"); // Valid image formats
            $filename = stripslashes($_FILES['file']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = '../storage/profile/';
                $original_filename = $_FILES['file']['name'];
                $random1 = rand(9999,100000);
                $random2 = rand(9999,200000);
                $random3 = $random1.$random2;
                $extensions = explode(".", $original_filename);
                $extension = $extensions[count($extensions) - 1];
                $uniqueName =  $random3 . "." . $extension;
                $uploadfile = $uploaddir . $uniqueName;

                $file_type = "file";

                if ($extension == "jpg" || $extension == "jpeg" || $extension == "gif" || $extension == "png") {
                    $file_type = "image";

                    $size = filesize($_FILES['file']['tmp_name']);

                    $image = $_FILES["file"]["name"];
                    $uploadedfile = $_FILES['file']['tmp_name'];

                    if ($image) {
                        if ($extension == "jpg" || $extension == "jpeg") {
                            $uploadedfile = $_FILES['file']['tmp_name'];
                            $src = imagecreatefromjpeg($uploadedfile);
                        } else if ($extension == "png") {
                            $uploadedfile = $_FILES['file']['tmp_name'];
                            $src = imagecreatefrompng($uploadedfile);
                        } else {
                            $src = imagecreatefromgif($uploadedfile);
                        }

                        list($width, $height) = getimagesize($uploadedfile);

                        $newwidth = 225;
                        $newheight = 225;
                        //$newheight = ($height / $width) * $newwidth;
                        $tmp = imagecreatetruecolor($newwidth, $newheight);

                        imagecopyresampled($tmp, $src, 0, 0, 0, 0, $newwidth, $newheight, $width, $height);

                        $filename = $uploaddir . "small" . $uniqueName;

                        imagejpeg($tmp, $filename, 100);

                        imagedestroy($src);
                        imagedestroy($tmp);
                    }


                }
                //else if it's not bigger then 0, then it's available '
                //and we send 1 to the ajax request
                if (move_uploaded_file($_FILES['file']['tmp_name'], $uploadfile)) {

                    $info = ORM::for_table($config['db']['pre'].'admins')
                        ->select('image')
                        ->find_one($_POST['id']);

                    if($info['image'] != "default_user.png"){
                        if(file_exists($uploaddir.$info['image'])){
                            unlink($uploaddir.$info['image']);
                            unlink($uploaddir."small".$info['image']);
                        }
                    }
                    if(!empty($password)){
                        $pass_hash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 13]);

                        $admins = ORM::for_table($config['db']['pre'].'admins')->find_one($_POST['id']);
                        $admins->name = $_POST['name'];
                        $admins->password_hash = $pass_hash;
                        $admins->image = $uniqueName;
                        $admins->save();
                    }else{
                        $admins = ORM::for_table($config['db']['pre'].'admins')->find_one($_POST['id']);
                        $admins->name = $_POST['name'];
                        $admins->image = $uniqueName;
                        $admins->save();
                    }

                    if (!$admins) {
                        $status = "error";
                        $message = $lang['ERROR_TRY_AGAIN'];
                    } else{
                        $status = "success";
                        $message = $lang['SAVED_SUCCESS'];
                    }
                }
            }
            else {
                $error = "Only allowed jpg, jpeg png";
                $status = "error";
                $message = $error;
            }

        }
        else{
            if(!empty($password)){
                $pass_hash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 13]);

                $admins = ORM::for_table($config['db']['pre'].'admins')->find_one($_POST['id']);
                $admins->name = validate_input($_POST['name']);
                $admins->password_hash = $pass_hash;
                $admins->username = $_POST["username"];
                $admins->save();

            }else{

                $admins = ORM::for_table($config['db']['pre'].'admins')->find_one($_POST['id']);
                $admins->name = validate_input($_POST['name']);
                $admins->username = $_POST["username"];
                $admins->save();
            }


            if (!$admins) {
                $status = "error";
                $message = $lang['ERROR_TRY_AGAIN'];
            } else{
                $status = "success";
                $message = $lang['SAVED_SUCCESS'];
            }
        }


    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addUser(){
    global $config,$lang;

    if (isset($_POST['submit'])) {
        $image_name = 'default_user.png';
        $status = 'success';
        if(isset($_FILES['file']['name']))
        {
            $valid_formats = array("jpg","jpeg","png"); // Valid image formats
            $filename = stripslashes($_FILES['file']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = '../storage/profile/';
                $original_filename = $_FILES['file']['name'];
                $random1 = rand(9999,100000);
                $random2 = rand(9999,200000);
                $random3 = $random1.$random2;
                $username = $_POST['username'];
                $image_name = $username.'_'.$random1.$random2.'.'.$ext;
                $image_name1 = 'small_'.$username.'_'.$random1.$random2.'.'.$ext;

                $filename = $uploaddir . $image_name;
                $filename1 = $uploaddir . $image_name1;

                $uploadedfile = $_FILES['file']['tmp_name'];

                //else if it's not bigger then 0, then it's available '
                //and we send 1 to the ajax request
                if (resizeImage(500, $filename, $uploadedfile)) {
                    resize_crop_image(200, 200, $filename1, $uploadedfile);
                    //$time = date('Y-m-d H:i:s', time());
                    $status = 'success';
                }else{
                    $error = "Image not uploaded.";
                    $status = "error";
                    $message = $error;
                }
            }
            else {
                $error = "Only allowed jpg, jpeg png";
                $status = "error";
                $message = $error;
            }

        }

        if($status != "error") {
            $password = $_POST["password"];
            $pass_hash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 13]);
            $now = date("Y-m-d H:i:s");

            $insert_user = ORM::for_table($config['db']['pre'] . 'user')->create();
            $insert_user->status = '0';
            $insert_user->name = $_POST['name'];
            $insert_user->username = $_POST['username'];
            $insert_user->password_hash = $pass_hash;
            $insert_user->email = $_POST['email'];
            $insert_user->sex = $_POST['sex'];
            $insert_user->description = $_POST['sex'];
            $insert_user->country = $_POST['country'];
            $insert_user->image = $image_name;
            $insert_user->created_at = $now;
            $insert_user->updated_at = $now;
            $insert_user->save();

            if ($insert_user->id()) {
                $status = "success";
                $message = $lang['SAVED_SUCCESS'];
            } else {
                $status = "error";
                $message = $lang['ERROR_TRY_AGAIN'];
            }
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editUser(){
    global $config,$lang;

    if (isset($_POST['id'])) {
        $password = $_POST["password"];
        $status = 'success';
        $now = date("Y-m-d H:i:s");
        $user_update = ORM::for_table($config['db']['pre'].'user')->find_one($_POST['id']);

        /* Update Password */
        if(!empty($password)){
            $pass_hash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 13]);
            $user_update->set('password_hash', $pass_hash);
        }

        /* Update Image */
        if(isset($_FILES['file']['name']) && $_FILES['file']['name'] != "")
        {
            $valid_formats = array("jpg","jpeg","png"); // Valid image formats
            $filename = stripslashes($_FILES['file']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = '../storage/profile/';
                $original_filename = $_FILES['file']['name'];
                $random1 = rand(9999,100000);
                $random2 = rand(9999,200000);

                $image_name = $random1.$random2.'.'.$ext;
                $image_name1 = 'small_'.$random1.$random2.'.'.$ext;

                $filename = $uploaddir . $image_name;
                $filename1 = $uploaddir . $image_name1;

                $uploadedfile = $_FILES['file']['tmp_name'];

                //else if it's not bigger then 0, then it's available '
                //and we send 1 to the ajax request
                if (resizeImage(500, $filename, $uploadedfile)) {
                    resize_crop_image(200, 200, $filename1, $uploadedfile);

                    if($user_update['image'] != "default_user.png"){
                        if(file_exists($uploaddir.$user_update['image'])){
                            unlink($uploaddir.$user_update['image']);
                            unlink($uploaddir."small_".$user_update['image']);
                        }
                    }

                    $user_update->set('image', $image_name);
                    $status = 'success';
                }
            } else {
                $error = "Only allowed jpg, jpeg png";
                $status = "error";
                $message = $error;
            }
        }

        if($status != "error") {
            /* Update plan */
            if($_POST['current_plan'] != 'free'){
                $subsc_check = ORM::for_table($config['db']['pre'].'upgrades')
                    ->where('user_id', $_POST['id'])
                    ->count();
                $expires = strtotime($_POST['plan_expiration_date']);
                if($subsc_check == 1){
                    $pdo = ORM::get_db();

                    $query = "UPDATE `".$config['db']['pre']."upgrades` SET 
                    `sub_id` = '".validate_input($_POST['current_plan'])."',
                    `upgrade_expires` = '".validate_input($expires)."' 
                    WHERE `user_id` = '".validate_input($_POST['id'])."' LIMIT 1 ";
                    $pdo->query($query);
                }else{
                    $upgrades_insert = ORM::for_table($config['db']['pre'].'upgrades')->create();
                    $upgrades_insert->sub_id = $_POST['current_plan'];
                    $upgrades_insert->user_id = $_POST['id'];
                    $upgrades_insert->upgrade_lasttime = time();
                    $upgrades_insert->upgrade_expires = $expires;
                    $upgrades_insert->status = "Active";
                    $upgrades_insert->save();
                }
            }

            $user_update->set('name', validate_input($_POST['name']));
            $user_update->set('group_id', $_POST['current_plan']);
            $user_update->set('username', $_POST['username']);
            $user_update->set('email', $_POST['email']);
            $user_update->set('status', $_POST['status']);
            $user_update->set('description', validate_input($_POST['about']));
            $user_update->set('sex', $_POST['sex']);
            $user_update->set('country', $_POST['country']);
            $user_update->set('updated_at', $now);
            $user_update->save();

            /* Update trial done */
            update_user_option($_POST['id'], 'package_trial_done', (int) $_POST['plan_trial_done']);

            if ($user_update) {
                $status = "success";
                $message = $lang['SAVED_SUCCESS'];
            } else{
                $status = "error";
                $message = $lang['ERROR_TRY_AGAIN'];
            }
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addCurrency()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $in_left = isset($_POST['in_left']) ? '1' : '0';

        $insert_currency = ORM::for_table($config['db']['pre'].'currencies')->create();
        $insert_currency->name = $_POST['name'];
        $insert_currency->code = $_POST['code'];
        $insert_currency->html_entity = $_POST['html_entity'];
        $insert_currency->font_arial = $_POST['font_arial'];
        $insert_currency->font_code2000 = $_POST['font_code2000'];
        $insert_currency->unicode_decimal = $_POST['unicode_decimal'];
        $insert_currency->unicode_hex = $_POST['unicode_hex'];
        $insert_currency->decimal_places = $_POST['decimal_places'];
        $insert_currency->decimal_separator = $_POST['decimal_separator'];
        $insert_currency->thousand_separator = $_POST['thousand_separator'];
        $insert_currency->in_left = $in_left;
        $insert_currency->save();

        if ($insert_currency->id()) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }
    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editCurrency()
{
    global $config,$lang;

    if (isset($_POST['id'])) {
        $in_left = isset($_POST['in_left']) ? '1' : '0';

        $update_currency = ORM::for_table($config['db']['pre'].'currencies')->find_one($_POST['id']);
        $update_currency->set('name', $_POST['name']);
        $update_currency->set('code', $_POST['code']);
        $update_currency->set('html_entity', $_POST['html_entity']);
        $update_currency->set('font_arial', $_POST['font_arial']);
        $update_currency->set('font_code2000', $_POST['font_code2000']);
        $update_currency->set('unicode_decimal', $_POST['unicode_decimal']);
        $update_currency->set('unicode_hex', $_POST['unicode_hex']);
        $update_currency->set('decimal_places', $_POST['decimal_places']);
        $update_currency->set('decimal_separator', $_POST['decimal_separator']);
        $update_currency->set('thousand_separator', $_POST['thousand_separator']);
        $update_currency->set('in_left', $in_left);
        $update_currency->save();

        if ($update_currency) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addTimezone()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $insert_timezone = ORM::for_table($config['db']['pre'].'time_zones')->create();
        $insert_timezone->country_code = $_POST['country_code'];
        $insert_timezone->time_zone_id = $_POST['time_zone_id'];
        $insert_timezone->gmt = $_POST['gmt'];
        $insert_timezone->dst = $_POST['dst'];
        $insert_timezone->raw = $_POST['raw'];
        $insert_timezone->save();

        if ($insert_timezone->id()) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editTimezone()
{
    global $config,$lang;

    if (isset($_POST['id'])) {

        $update_timezone = ORM::for_table($config['db']['pre'].'time_zones')->find_one($_POST['id']);
        $update_timezone->set('country_code', $_POST['country_code']);
        $update_timezone->set('time_zone_id', $_POST['time_zone_id']);
        $update_timezone->set('gmt', $_POST['gmt']);
        $update_timezone->set('dst', $_POST['dst']);
        $update_timezone->set('raw', $_POST['raw']);
        $update_timezone->save();

        if ($update_timezone) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}


function addMembershipPlan()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $recommended = isset($_POST['recommended']) ? "yes" : "no";
        $active = isset($_POST['active']) ? 1 : 0;

        $settings = array(
            'category_limit' => (int) $_POST['category_limit'],
            'menu_limit' => (int) $_POST['menu_limit'],
            'scan_limit' =>(int) $_POST['scan_limit'],
            'allow_ordering' => (int) isset($_POST['allow_ordering']),
            'custom' => array()
        );

        $plan_custom = ORM::for_table($config['db']['pre'].'plan_options')
            ->where('active', 1)
            ->order_by_asc('position')
            ->find_many();
        foreach ($plan_custom as $custom){
            if(!empty($custom['title']) && trim($custom['title']) != '' && !empty($_POST['custom_'.$custom['id']])) {
                $settings['custom'][$custom['id']] = 1;
            }
        }

        $insert_subscription = ORM::for_table($config['db']['pre'].'plans')->create();
        $insert_subscription->name = validate_input($_POST['name']);
        $insert_subscription->badge = $_POST['badge'];
        $insert_subscription->monthly_price = $_POST['monthly_price'];
        $insert_subscription->annual_price = $_POST['annual_price'];
        $insert_subscription->lifetime_price = $_POST['lifetime_price'];
        $insert_subscription->settings = json_encode($settings);
        $insert_subscription->taxes_ids = isset($_POST['taxes'])? validate_input(implode(',',$_POST['taxes'])) : null;
        $insert_subscription->status = $active;
        $insert_subscription->recommended = $recommended;
        $insert_subscription->date = date('Y-m-d H:i:s');
        $insert_subscription->save();

        if ($insert_subscription->id()) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editMembershipPlan()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {
        $active = isset($_POST['active']) ? 1 : 0;

        $settings = array(
            'category_limit' => (int) $_POST['category_limit'],
            'menu_limit' => (int) $_POST['menu_limit'],
            'scan_limit' =>(int) $_POST['scan_limit'],
            'allow_ordering' => (int) isset($_POST['allow_ordering']),
            'custom' => array()
        );

        $plan_custom = ORM::for_table($config['db']['pre'].'plan_options')
            ->where('active', 1)
            ->order_by_asc('position')
            ->find_many();
        foreach ($plan_custom as $custom){
            if(!empty($custom['title']) && trim($custom['title']) != '' && !empty($_POST['custom_'.$custom['id']])) {
                $settings['custom'][$custom['id']] = 1;
            }
        }

        switch ($_POST['id']){
            case 'free':
                $plan = json_encode(array(
                    'id' => 'free',
                    'name' => $_POST['name'],
                    'badge' => $_POST['badge'],
                    'settings' => $settings,
                    'status' => $active
                ));
                update_option('free_membership_plan', $plan);
                break;
            case 'trial':
                $plan = json_encode(array(
                    'id' => 'trial',
                    'name' => $_POST['name'],
                    'badge' => $_POST['badge'],
                    'days' => (int) $_POST['days'],
                    'settings' => $settings,
                    'status' => $active
                ));
                update_option('trial_membership_plan', $plan);
                break;
            default:
                $recommended = isset($_POST['recommended']) ? "yes" : "no";

                $insert_subscription = ORM::for_table($config['db']['pre'].'plans')->find_one($_POST['id']);
                $insert_subscription->name = validate_input($_POST['name']);
                $insert_subscription->badge = $_POST['badge'];
                $insert_subscription->monthly_price = $_POST['monthly_price'];
                $insert_subscription->annual_price = $_POST['annual_price'];
                $insert_subscription->lifetime_price = $_POST['lifetime_price'];
                $insert_subscription->settings = json_encode($settings);
                $insert_subscription->taxes_ids = isset($_POST['taxes'])? validate_input(implode(',',$_POST['taxes'])) : null;
                $insert_subscription->status = $active;
                $insert_subscription->recommended = $recommended;
                $insert_subscription->date = date('Y-m-d H:i:s');
                $insert_subscription->save();
                break;
        }

        $status = "success";
        $message = $lang['SAVED_SUCCESS'];

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addMembershipPackage()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $removable = isset($_POST['group_removable']) ? $_POST['group_removable'] : 0;

        $category_limit = isset($_POST['category_limit']) ? $_POST['category_limit'] : 0;
        $menu_limit = isset($_POST['menu_limit']) ? $_POST['menu_limit'] : 0;
        $scan_limit = isset($_POST['scan_limit']) ? $_POST['scan_limit'] : 0;

        $insert_usergroup = ORM::for_table($config['db']['pre'].'usergroups')->create();
        $insert_usergroup->group_name = $_POST['group_name'];
        $insert_usergroup->category_limit = $category_limit;
        $insert_usergroup->menu_limit = $menu_limit;
        $insert_usergroup->scan_limit = $scan_limit;
        $insert_usergroup->group_removable = $removable;
        $insert_usergroup->save();

        if ($insert_usergroup->id()) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editMembershipPackage()
{
    global $config,$lang;

    if (isset($_POST['id'])) {
        $removable = isset($_POST['group_removable']) ? $_POST['group_removable'] : 0;

        $category_limit = isset($_POST['category_limit']) ? $_POST['category_limit'] : 0;
        $menu_limit = isset($_POST['menu_limit']) ? $_POST['menu_limit'] : 0;
        $scan_limit = isset($_POST['scan_limit']) ? $_POST['scan_limit'] : 0;

        $pdo = ORM::get_db();
        $query = "UPDATE `".$config['db']['pre']."usergroups` SET
        `group_name` = '" . validate_input($_POST['group_name']) . "',
        `group_removable` = '" . validate_input($removable) . "',
        `category_limit` = '" . validate_input($category_limit) . "',
        `menu_limit` = '" . validate_input($menu_limit) . "',
        `scan_limit` = '" . validate_input($scan_limit) . "'
        WHERE `group_id` = '".validate_input($_POST['id'])."' LIMIT 1 ";

        $query_result = $pdo->query($query);

        if ($query_result) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addTax()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $insert_tax = ORM::for_table($config['db']['pre'].'taxes')->create();
        $insert_tax->internal_name = validate_input($_POST['internal_name']);
        $insert_tax->name = validate_input($_POST['name']);
        $insert_tax->description = validate_input($_POST['description']);
        $insert_tax->value = validate_input($_POST['value']);
        $insert_tax->value_type = validate_input($_POST['value_type']);
        $insert_tax->type = validate_input($_POST['type']);
        $insert_tax->billing_type = validate_input($_POST['billing_type']);
        $insert_tax->countries = isset($_POST['countries'])? validate_input(implode(',',$_POST['countries'])) : null;
        $insert_tax->datetime = date('Y-m-d H:i:s');
        $insert_tax->save();

        if ($insert_tax->id()) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editTax()
{
    global $config,$lang;

    if (isset($_POST['submit'])) {

        $insert_tax = ORM::for_table($config['db']['pre'].'taxes')->find_one($_POST['id']);
        $insert_tax->internal_name = validate_input($_POST['internal_name']);
        $insert_tax->name = validate_input($_POST['name']);
        $insert_tax->description = validate_input($_POST['description']);
        $insert_tax->value = validate_input($_POST['value']);
        $insert_tax->value_type = validate_input($_POST['value_type']);
        $insert_tax->type = validate_input($_POST['type']);
        $insert_tax->billing_type = validate_input($_POST['billing_type']);
        $insert_tax->countries = isset($_POST['countries'])? validate_input(implode(',',$_POST['countries'])) : null;
        $insert_tax->save();

        if ($insert_tax->id()) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addLanguage()
{
    global $config,$lang;
    if (isset($_POST['submit'])) {
        if(isset($_POST['name']) && $_POST['name'] != ""){

            $post_langname = str_replace(' ', '', strtolower($_POST['name']));

            $filePath = '../includes/lang/lang_'.$post_langname.'.php';
            if (!file_exists($filePath)) {
                $source = 'en';
                $target = $_POST['code'];
                $auto_translate = isset($_POST['auto_tran']) ? '1' : '0';
                $active = isset($_POST['active']) ? '1' : '0';

                $trans = new GoogleTranslate();
                $newLangArray = array();
                foreach ($lang as $key => $value)
                {
                    if($auto_translate == 1){
                        $result = $trans->translate($source, $target, $value);
                        $result = !empty($result)?$result:$value;
                    }else{
                        $result = $value;
                    }

                    $newLangArray[$key] = $result;
                }
                fopen($filePath, "w");
                change_config_file_settings($filePath, $newLangArray,$lang);

                $lang_filename = $post_langname;

                $insert_language = ORM::for_table($config['db']['pre'].'languages')->create();
                $insert_language->code = $_POST['code'];
                $insert_language->name = $post_langname;
                $insert_language->direction = $_POST['direction'];
                $insert_language->file_name = $lang_filename;
                $insert_language->active = $active;
                $insert_language->save();

                if ($insert_language->id()) {
                    $status = "success";
                    $message = $lang['SAVED_SUCCESS'];
                } else{
                    $status = "error";
                    $message = $lang['ERROR_TRY_AGAIN'];
                }


            } else {
                $message = "Same language file is exist. Change language name.";
                echo $json = '{"status" : "error","message" : "' . $message . '"}';
                die();
            }
        }else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editLanguage()
{
    global $config,$lang;

    if (isset($_POST['id'])) {

        $active = isset($_POST['active']) ? '1' : '0';
        $lang_filename = strtolower($_POST['name']);

        $update_language = ORM::for_table($config['db']['pre'].'languages')->find_one($_POST['id']);
        $update_language->set('code', $_POST['code']);
        $update_language->set('name', $_POST['name']);
        $update_language->set('direction', $_POST['direction']);
        $update_language->set('file_name', $lang_filename);
        $update_language->set('active', $active);
        $update_language->save();

        if ($update_language) {
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        } else{
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }


    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function addStaticPage()
{
    global $config,$lang;
    $errors = array();
    $response = array();

    if (isset($_POST['submit'])) {

        if (empty($_POST['name'])) {
            $errors[]['message'] = 'Page name required.';
        }
        if (empty($_POST['title'])) {
            $errors[]['message'] = 'Page title required.';
        }
        if (empty($_POST['content'])) {
            $errors[]['message'] = 'Page content required.';
        }
        if (!count($errors) > 0) {
            if (empty($_POST['slug']))
                $slug = create_slug($_POST['name']);
            else
                $slug = create_slug($_POST['slug']);
                $active = isset($_POST['active']) ? '1' : '0';

            $insert_page = ORM::for_table($config['db']['pre'].'pages')->create();
            $insert_page->translation_lang = 'en';
            $insert_page->name = $_POST['name'];
            $insert_page->title = $_POST['title'];
            $insert_page->content = $_POST['content'];
            $insert_page->slug = $slug;
            $insert_page->type = $_POST['type'];
            $insert_page->active = $active;
            $insert_page->save();

            $id = $insert_page->id();

            $update_page = ORM::for_table($config['db']['pre'].'pages')->find_one($id);
            $update_page->set('translation_of', $id);
            $update_page->set('parent_id', $id);
            $update_page->save();

            $rows = ORM::for_table($config['db']['pre'].'languages')
                ->select_many('code','name')
                ->where('active', '1')
                ->where_not_equal('code', 'en')
                ->find_many();

            foreach ($rows as $fetch){
                $insert_page = ORM::for_table($config['db']['pre'].'pages')->create();
                $insert_page->translation_lang = $fetch['code'];
                $insert_page->translation_of = $id;
                $insert_page->parent_id = $id;
                $insert_page->name = $_POST['name'];
                $insert_page->title = $_POST['title'];
                $insert_page->content = $_POST['content'];
                $insert_page->slug = $slug;
                $insert_page->type = $_POST['type'];
                $insert_page->active = $active;
                $insert_page->save();

            }

            $status = "success";
            $message = 'Page added successfully.';

            echo $json = '{"id" : "' . $id . '","status" : "' . $status . '","message" : "' . $message . '"}';
            die();
        }else {
            $status = "error";
            $message = $lang['ERROR'];
        }
    } else {
        $status = "error";
        $message = $lang['UNKNOWN_ERROR'];
    }

    $json = '{"status" : "' . $status . '","message" : "' . $message . '","errors" : ' . json_encode($errors, JSON_UNESCAPED_SLASHES) . '}';
    echo $json;
    die();
}

function editStaticPage()
{
    global $config,$lang;
    $errors = array();
    $response = array();

    if (isset($_POST['id'])) {

        if (empty($_POST['name'])) {
            $errors[]['message'] = $lang['PAGENAME_REQ'];
        }
        if (empty($_POST['title'])) {
            $errors[]['message'] = $lang['PAGETITLE_REQ'];
        }
        if (empty($_POST['content'])) {
            $errors[]['message'] = $lang['PAGECONTENT_REQ'];
        }
        if (!count($errors) > 0) {
            if (empty($_POST['slug']))
                $slug = create_slug($_POST['name']);
            else
                $slug = create_slug($_POST['slug']);
            $active = isset($_POST['active']) ? '1' : '0';

            $update_page = ORM::for_table($config['db']['pre'].'pages')->find_one($_POST['id']);
            $update_page->set('name', $_POST['name']);
            $update_page->set('title', $_POST['title']);
            $update_page->set('content', $_POST['content']);
            $update_page->set('slug', $slug);
            $update_page->set('type', $_POST['type']);
            $update_page->set('active', $active);
            $update_page->save();

            $status = "success";
            $message = 'Page edited successfully.';

            echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
            die();
        }else {
            $status = "error";
            $message = $lang['ERROR'];
        }
    } else {
        $status = "error";
        $message = $lang['UNKNOWN_ERROR'];
    }

    $json = '{"status" : "' . $status . '","message" : "' . $message . '","errors" : ' . json_encode($errors, JSON_UNESCAPED_SLASHES) . '}';
    echo $json;
    die();
}

function addFAQentry()
{
    global $config,$lang;
    $errors = array();

    if (isset($_POST['submit'])) {

        if (empty($_POST['title'])) {
            $errors[]['message'] = $lang['FAQTITLE_REQ'];
        }
        if (empty($_POST['content'])) {
            $errors[]['message'] = $lang['FAQCONTENT_REQ'];
        }
        if (!count($errors) > 0) {
            $active = isset($_POST['active']) ? '1' : '0';

            $insert_faq = ORM::for_table($config['db']['pre'].'faq_entries')->create();
            $insert_faq->translation_lang = 'en';
            $insert_faq->faq_title = $_POST['title'];
            $insert_faq->faq_content = $_POST['content'];
            $insert_faq->active = $active;
            $insert_faq->save();

            $id = $insert_faq->id();

            $pdo = ORM::get_db();
            $query = "UPDATE `".$config['db']['pre']."faq_entries` SET
                `translation_of` = '".validate_input($id)."',
                `parent_id` = '".validate_input($id)."'
                 WHERE `faq_id` = '".validate_input($id)."' LIMIT 1 ";
            $query_result = $pdo->query($query);

            $rows = ORM::for_table($config['db']['pre'].'languages')
                ->select_many('code','name')
                ->where('active', '1')
                ->where_not_equal('code', 'en')
                ->find_many();

            foreach ($rows as $fetch){
                $insert_faq = ORM::for_table($config['db']['pre'].'faq_entries')->create();
                $insert_faq->translation_lang = $fetch['code'];
                $insert_faq->translation_of = $id;
                $insert_faq->parent_id = $id;
                $insert_faq->faq_title = $_POST['title'];
                $insert_faq->faq_content = $_POST['content'];
                $insert_faq->active = $active;
                $insert_faq->save();
            }

            $status = "success";
            $message = $lang['SAVED_SUCCESS'];

            echo $json = '{"id" : "' . $id . '","status" : "' . $status . '","message" : "' . $message . '"}';
            die();
        }else {
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }
    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    $json = '{"status" : "' . $status . '","message" : "' . $message . '","errors" : ' . json_encode($errors, JSON_UNESCAPED_SLASHES) . '}';
    echo $json;
    die();
}

function editFAQentry()
{
    global $config,$lang;
    $errors = array();
    $response = array();

    if (isset($_POST['id'])) {

        if (empty($_POST['title'])) {
            $errors[]['message'] = $lang['FAQTITLE_REQ'];
        }
        if (empty($_POST['content'])) {
            $errors[]['message'] = $lang['FAQCONTENT_REQ'];
        }
        if (!count($errors) > 0) {
            $active = isset($_POST['active']) ? '1' : '0';

            $pdo = ORM::get_db();
            $query = "UPDATE `".$config['db']['pre']."faq_entries` SET
                `faq_title` = '" . validate_input($_POST['title']) . "',
                `faq_content` = '" . addslashes($_POST['content']) . "',
                 `active` = '" . validate_input($active) . "'
                 WHERE `faq_id` = '".$_POST['id']."' LIMIT 1 ";
            $query_result = $pdo->query($query);

            $status = "success";
            $message = 'FAQ edited Successfully';

            echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
            die();
        }else {
            $status = "error";
            $message = $lang['ERROR'];
        }
    } else {
        $status = "error";
        $message = $lang['UNKNOWN_ERROR'];
    }

    $json = '{"status" : "' . $status . '","message" : "' . $message . '","errors" : ' . json_encode($errors, JSON_UNESCAPED_SLASHES) . '}';
    echo $json;
    die();
}

function transactionEdit()
{
    global $config,$lang;
    $errors = array();
    $response = array();

    if (isset($_POST['id'])) {

        if (isset($_POST['status'])) {

            if($_POST['status'] == "success"){
                $transaction_id = $_POST['id'];
                transaction_success($transaction_id);
            }else{
                $transaction = ORM::for_table($config['db']['pre'].'transaction')->find_one($_POST['id']);
                $transaction->status = $_POST['status'];
                $transaction->save();
            }
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];


        }else {
            $status = "error";
            $message = $lang['ERROR_TRY_AGAIN'];
        }
    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function editAdvertise()
{
    global $config,$lang;

    if (isset($_POST['id'])) {

        $status = isset($_POST['status']) ? '1' : '0';

        $update_adsense = ORM::for_table($config['db']['pre'].'adsense')->find_one($_POST['id']);
        $update_adsense->set('provider_name', $_POST['provider_name']);
        $update_adsense->set('status', $status);
        $update_adsense->set('large_track_code', $_POST['large_track_code']);
        $update_adsense->set('tablet_track_code', $_POST['tablet_track_code']);
        $update_adsense->set('phone_track_code', $_POST['phone_track_code']);
        $update_adsense->save();

        $status = "success";
        $message = $lang['SAVED_SUCCESS'];

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function paymentEdit()
{
    global $config,$lang;

    if (isset($_POST['id'])) {

        $pdo = ORM::get_db();
        $query = "UPDATE `".$config['db']['pre']."payments` SET
            `payment_title` = '" . validate_input($_POST['title']) . "',
            `payment_install` = '" . validate_input($_POST['install']) . "'
            WHERE `payment_id` = '".$_POST['id']."' LIMIT 1 ";
        $query_result = $pdo->query($query);

        if(isset($_POST['paypal_sandbox_mode'])){
            update_option("paypal_sandbox_mode",isset($_POST['paypal_sandbox_mode'])? $_POST['paypal_sandbox_mode'] : "");
            update_option("paypal_payment_mode",isset($_POST['paypal_payment_mode'])? $_POST['paypal_payment_mode'] : "");
            update_option("paypal_api_client_id",isset($_POST['paypal_api_client_id'])? $_POST['paypal_api_client_id'] : "");
            update_option("paypal_api_secret",isset($_POST['paypal_api_secret'])? $_POST['paypal_api_secret'] : "");
        }

        if(isset($_POST['stripe_secret_key'])){
            update_option("stripe_payment_mode",$_POST['stripe_payment_mode']);
            update_option("stripe_publishable_key",$_POST['stripe_publishable_key']);
            update_option("stripe_secret_key",$_POST['stripe_secret_key']);
            update_option("stripe_webhook_secret",$_POST['stripe_webhook_secret']);
        }

        if(isset($_POST['paystack_public_key'])){
            update_option("paystack_public_key",$_POST['paystack_public_key']);
            update_option("paystack_secret_key",$_POST['paystack_secret_key']);
        }

        if(isset($_POST['payumoney_merchant_key'])){
            update_option("payumoney_sandbox_mode",$_POST['payumoney_sandbox_mode']);
            update_option("payumoney_merchant_key",$_POST['payumoney_merchant_key']);
            update_option("payumoney_merchant_salt",$_POST['payumoney_merchant_salt']);
            update_option("payumoney_merchant_id",$_POST['payumoney_merchant_id']);
        }

        if(isset($_POST['checkout_account_number'])){
            update_option("2checkout_sandbox_mode",$_POST['2checkout_sandbox_mode']);
            update_option("checkout_account_number",$_POST['checkout_account_number']);
            update_option("checkout_public_key",$_POST['checkout_public_key']);
            update_option("checkout_private_key",$_POST['checkout_private_key']);
        }

        if(isset($_POST['company_bank_info'])){
            update_option("company_bank_info",$_POST['company_bank_info']);
        }

        if(isset($_POST['company_cheque_info'])){
            update_option("company_cheque_info",$_POST['company_cheque_info']);
            update_option("cheque_payable_to",$_POST['cheque_payable_to']);
        }

        if(isset($_POST['skrill_merchant_id'])){
            update_option("skrill_merchant_id",$_POST['skrill_merchant_id']);
        }

        if(isset($_POST['nochex_merchant_id'])){
            update_option("nochex_merchant_id",$_POST['nochex_merchant_id']);
        }

        if(isset($_POST['CCAVENUE_MERCHANT_KEY'])){
            update_option("CCAVENUE_MERCHANT_KEY",$_POST['CCAVENUE_MERCHANT_KEY']);
            update_option("CCAVENUE_ACCESS_CODE",$_POST['CCAVENUE_ACCESS_CODE']);
            update_option("CCAVENUE_WORKING_KEY",$_POST['CCAVENUE_WORKING_KEY']);
        }

        if(isset($_POST['PAYTM_ENVIRONMENT'])){
            update_option("PAYTM_ENVIRONMENT",$_POST['PAYTM_ENVIRONMENT']);
            update_option("PAYTM_MERCHANT_KEY",$_POST['PAYTM_MERCHANT_KEY']);
            update_option("PAYTM_MERCHANT_MID",$_POST['PAYTM_MERCHANT_MID']);
            update_option("PAYTM_MERCHANT_WEBSITE",$_POST['PAYTM_MERCHANT_WEBSITE']);
        }

        if(isset($_POST['mollie_api_key'])){
            update_option("mollie_api_key",$_POST['mollie_api_key']);
        }
        $status = "success";
        $message = $lang['SAVED_SUCCESS'];

    } else {
        $status = "error";
        $message = $lang['ERROR_TRY_AGAIN'];
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function SaveSettings(){

    global $config,$lang,$link;
    $status = "";
    if (isset($_POST['logo_watermark'])) {
        $valid_formats = array("jpg","jpeg","png"); // Valid image formats
        if (isset($_FILES['banner']) && $_FILES['banner']['tmp_name'] != "") {
            $filename = stripslashes($_FILES['banner']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = "../storage/banner/"; //Image upload directory
                $bannername = stripslashes($_FILES['banner']['name']);
                $size = filesize($_FILES['banner']['tmp_name']);
                //Convert extension into a lower case format

                $ext = getExtension($bannername);
                $ext = strtolower($ext);
                $banner_name = "bg" . '.' . $ext;
                $newBgname = $uploaddir . $banner_name;
                //Moving file to uploads folder
                if(file_exists($newBgname)){
                    unlink($newBgname);
                }
                if (move_uploaded_file($_FILES['banner']['tmp_name'], $newBgname)) {

                    update_option("home_banner",$banner_name);
                    $status = "success";
                    $message = ' Banner updated Successfully ';

                } else {
                    $status = "error";
                    $message = 'Error in uploading Banner';
                }
            }
            else {
                $status = "error";
                $message = 'Only allowed jpg, jpeg png';
            }

        }

        if (isset($_FILES['favicon']) && $_FILES['favicon']['tmp_name'] != "") {
            $filename = stripslashes($_FILES['favicon']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = "../storage/logo/"; //Image upload directory
                $filename = stripslashes($_FILES['favicon']['name']);
                $size = filesize($_FILES['favicon']['tmp_name']);
                //Convert extension into a lower case format

                $ext = getExtension($filename);
                $ext = strtolower($ext);
                $image_name = "favicon" . '.' . $ext;
                $newLogo = $uploaddir . $image_name;
                if(file_exists($newLogo)){
                    unlink($newLogo);
                }
                //Moving file to uploads folder
                if (move_uploaded_file($_FILES['favicon']['tmp_name'], $newLogo)) {

                    update_option("site_favicon",$image_name);
                    $status = "success";
                    $message = ' Site Favicon icon updated Successfully ';
                } else {
                    $status = "error";
                    $message = 'Error in uploading Favicon';
                }
            }
            else {
                $status = "error";
                $message = 'Only allowed jpg, jpeg png';
            }

        }

        if (isset($_FILES['file']) && $_FILES['file']['tmp_name'] != "") {
            $filename = stripslashes($_FILES['file']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = "../storage/logo/"; //Image upload directory
                $filename = stripslashes($_FILES['file']['name']);
                $size = filesize($_FILES['file']['tmp_name']);
                //Convert extension into a lower case format

                $ext = getExtension($filename);
                $ext = strtolower($ext);
                $image_name = $config['tpl_name']."_logo" . '.' . $ext;
                $newLogo = $uploaddir . $image_name;
                if(file_exists($newLogo)){
                    unlink($newLogo);
                }
                //Moving file to uploads folder
                if (move_uploaded_file($_FILES['file']['tmp_name'], $newLogo)) {

                    update_option("site_logo",$image_name);
                    $status = "success";
                    $message = ' Site Logo updated Successfully ';
                } else {
                    $status = "error";
                    $message = 'Error in uploading Logo';
                }
            }
            else {
                $status = "error";
                $message = 'Only allowed jpg, jpeg png';
            }

        }

        if (isset($_FILES['footer_logo']) && $_FILES['footer_logo']['tmp_name'] != "") {
            $filename = stripslashes($_FILES['footer_logo']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = "../storage/logo/"; //Image upload directory
                $filename = stripslashes($_FILES['footer_logo']['name']);
                $size = filesize($_FILES['footer_logo']['tmp_name']);
                //Convert extension into a lower case format

                $ext = getExtension($filename);
                $ext = strtolower($ext);
                $image_name = $config['tpl_name']."_footer_logo" . '.' . $ext;
                $newLogo = $uploaddir . $image_name;
                if(file_exists($newLogo)){
                    unlink($newLogo);
                }
                //Moving file to uploads folder
                if (move_uploaded_file($_FILES['footer_logo']['tmp_name'], $newLogo)) {

                    update_option("site_logo_footer",$image_name);
                    $status = "success";
                    $message = ' Site Logo updated Successfully ';
                } else {
                    $status = "error";
                    $message = 'Error in uploading Logo';
                }
            }
            else {
                $status = "error";
                $message = 'Only allowed jpg, jpeg png';
            }

        }

        if (isset($_FILES['adminlogo']) && $_FILES['adminlogo']['tmp_name'] != "") {
            $filename = stripslashes($_FILES['adminlogo']['name']);
            $ext = getExtension($filename);
            $ext = strtolower($ext);
            //File extension check
            if (in_array($ext, $valid_formats)) {
                $uploaddir = "../storage/logo/"; //Image upload directory
                $filename = stripslashes($_FILES['adminlogo']['name']);
                $size = filesize($_FILES['adminlogo']['tmp_name']);
                //Convert extension into a lower case format

                $ext = getExtension($filename);
                $ext = strtolower($ext);
                $adminlogo_name = "adminlogo" . '.' . $ext;
                $adminlogo = $uploaddir . $adminlogo_name;
                if(file_exists($adminlogo)){
                    unlink($adminlogo);
                }
                //Moving file to uploads folder
                if (move_uploaded_file($_FILES['adminlogo']['tmp_name'], $adminlogo)) {
                    update_option("site_admin_logo",$adminlogo_name);
                    $status = "success";
                    $message = ' Adminlogo Logo updated Successfully ';
                } else {
                    $status = "error";
                    $message = 'Error in uploading adminlogo';
                }
            }
            else {
                $status = "error";
                $message = 'Only allowed jpg, jpeg png';
            }

        }

        if($status == ""){
            $status = "success";
            $message = $lang['SAVED_SUCCESS'];
        }
    }

    if (isset($_POST['general_setting'])) {
        update_option("site_url",$_POST['site_url']);
        update_option("site_title",$_POST['site_title']);
        update_option("non_active_msg",$_POST['non_active_msg']);
        update_option("restaurant_text_editor", $_POST['restaurant_text_editor']);
        update_option("cron_exec_time",validate_input($_POST['cron_exec_time']));
        update_option("userlangsel",$_POST['userlangsel']);
        update_option("termcondition_link",validate_input($_POST['termcondition_link']));
        update_option("privacy_link",validate_input($_POST['privacy_link']));
        update_option("cookie_link",validate_input($_POST['cookie_link']));
        update_option("cookie_consent",$_POST['cookie_consent']);
        update_option("quickad_debug",$_POST['quickad_debug']);
        $status = "success";
        $message = 'General setting updated Successfully';
    }

    if (isset($_POST['quick_map'])) {
        update_option("map_type",validate_input($_POST['map_type']));
        update_option("openstreet_access_token",validate_input($_POST['openstreet_access_token']));
        update_option("gmap_api_key",validate_input($_POST['gmap_api_key']));
        update_option("map_color",validate_input($_POST['map_color']));
        update_option("home_map_latitude",validate_input($_POST['home_map_latitude']));
        update_option("home_map_longitude",validate_input($_POST['home_map_longitude']));
        update_option("contact_latitude",validate_input($_POST['contact_latitude']));
        update_option("contact_longitude",validate_input($_POST['contact_longitude']));
        $status = "success";
        $message = 'Setting updated Successfully';
    }

    if (isset($_POST['international'])) {

        if(isset($_POST['currency']))
        {
            $info = ORM::for_table($config['db']['pre'].'currencies')->find_one($_POST['currency']);

            $currency_sign = $info['html_entity'];
            $currency_code = $info['code'];
            $currency_pos = $info['in_left'];
        }
        update_option("specific_country",$_POST['specific_country']);
        update_option("lang",$_POST['lang']);
        update_option("timezone",$_POST['timezone']);
        update_option("currency_sign",$currency_sign);
        update_option("currency_code",$currency_code);
        update_option("currency_pos",$currency_pos);
        $status = "success";
        $message = 'International setting updated Successfully';
    }

    if (isset($_POST['email_setting'])) {

        update_option("admin_email",$_POST['admin_email']);
        update_option("email_template",$_POST['email_template']);
        update_option("email_engine",$_POST['email_engine']);
        update_option("email_type",$_POST['email_type']);

        update_option("smtp_host",$_POST['smtp_host']);
        update_option("smtp_port",$_POST['smtp_port']);
        update_option("smtp_username",$_POST['smtp_username']);
        update_option("smtp_password",$_POST['smtp_password']);
        update_option("smtp_secure",$_POST['smtp_secure']);
        update_option("smtp_auth",$_POST['smtp_auth']);

        update_option("aws_host",$_POST['aws_host']);
        update_option("aws_access_key",$_POST['aws_access_key']);
        update_option("aws_secret_key",$_POST['aws_secret_key']);

        update_option("mandrill_user",$_POST['mandrill_user']);
        update_option("mandrill_key",$_POST['mandrill_key']);

        update_option("sendgrid_user",$_POST['sendgrid_user']);
        update_option("sendgrid_pass",$_POST['sendgrid_pass']);



        $status = "success";
        $message = 'Email setting updated Successfully';
    }

    if (isset($_POST['theme_setting'])) {
        update_option("theme_color",validate_input($_POST['theme_color']));
        update_option("meta_keywords",validate_input($_POST['meta_keywords']));
        update_option("meta_description",validate_input($_POST['meta_description']));
        update_option("contact_address",validate_input($_POST['contact_address']));
        update_option("contact_phone",validate_input($_POST['contact_phone']));
        update_option("contact_email",validate_input($_POST['contact_email']));
        update_option("footer_text",validate_input($_POST['footer_text']));
        update_option("copyright_text",validate_input($_POST['copyright_text']));
        update_option("facebook_link",validate_input($_POST['facebook_link']));
        update_option("twitter_link",validate_input($_POST['twitter_link']));
        update_option("instagram_link",validate_input($_POST['instagram_link']));
        update_option("linkedin_link",validate_input($_POST['linkedin_link']));
        update_option("pinterest_link",validate_input($_POST['pinterest_link']));
        update_option("youtube_link",validate_input($_POST['youtube_link']));
        update_option("external_code",$_POST['external_code']);
        $status = "success";
        $message = ' Theme Setting updated Successfully';
    }

    if (isset($_POST['billing_details'])) {
        update_option("invoice_nr_prefix", validate_input($_POST['invoice_nr_prefix']));
        update_option("invoice_admin_name", validate_input($_POST['invoice_admin_name']));
        update_option("invoice_admin_email", validate_input($_POST['invoice_admin_email']));
        update_option("invoice_admin_phone", validate_input($_POST['invoice_admin_phone']));
        update_option("invoice_admin_address", validate_input($_POST['invoice_admin_address']));
        update_option("invoice_admin_city", validate_input($_POST['invoice_admin_city']));
        update_option("invoice_admin_state", validate_input($_POST['invoice_admin_state']));
        update_option("invoice_admin_zipcode", validate_input($_POST['invoice_admin_zipcode']));
        update_option("invoice_admin_country", validate_input($_POST['invoice_admin_country']));
        update_option("invoice_admin_tax_type", validate_input($_POST['invoice_admin_tax_type']));
        update_option("invoice_admin_tax_id", validate_input($_POST['invoice_admin_tax_id']));
        update_option("invoice_admin_custom_name_1", validate_input($_POST['invoice_admin_custom_name_1']));
        update_option("invoice_admin_custom_value_1", validate_input($_POST['invoice_admin_custom_value_1']));
        update_option("invoice_admin_custom_name_2", validate_input($_POST['invoice_admin_custom_name_2']));
        update_option("invoice_admin_custom_value_2", validate_input($_POST['invoice_admin_custom_value_2']));
        $status = "success";
        $message = 'Setting updated Successfully';
    }

    if (isset($_POST['social_login_setting'])) {
        update_option("facebook_app_id",validate_input($_POST['facebook_app_id']));
        update_option("facebook_app_secret",validate_input($_POST['facebook_app_secret']));
        update_option("google_app_id",validate_input($_POST['google_app_id']));
        update_option("google_app_secret",validate_input($_POST['google_app_secret']));
        $status = "success";
        $message = ' Social Login setting updated Successfully';
    }

    if (isset($_POST['recaptcha_setting'])) {

        update_option("recaptcha_mode",validate_input($_POST['recaptcha_mode']));
        update_option("recaptcha_public_key",validate_input($_POST['recaptcha_public_key']));
        update_option("recaptcha_private_key",validate_input($_POST['recaptcha_private_key']));
        $status = "success";
        $message = 'reCAPTCHA setting updated Successfully';
    }

    if (isset($_POST['blog_setting'])) {

        update_option("blog_enable",validate_input($_POST['blog_enable']));
        update_option("blog_banner",validate_input($_POST['blog_banner']));
        update_option("show_blog_home",validate_input($_POST['show_blog_home']));
        update_option("blog_comment_enable",validate_input($_POST['blog_comment_enable']));
        update_option("blog_comment_approval",validate_input($_POST['blog_comment_approval']));
        update_option("blog_comment_user",validate_input($_POST['blog_comment_user']));
        $status = "success";
        $message = 'Blog setting updated Successfully';
    }

    if (isset($_POST['testimonials_setting'])) {

        update_option("testimonials_enable",validate_input($_POST['testimonials_enable']));
        update_option("show_testimonials_blog",validate_input($_POST['show_testimonials_blog']));
        update_option("show_testimonials_home",validate_input($_POST['show_testimonials_home']));
        $status = "success";
        $message = 'Testimonials setting updated Successfully';
    }

    if (isset($_POST['valid_purchase_setting'])) {

        // Set API Key
        $code = $_POST['purchase_key'];
        $buyer_email = (isset($_POST['buyer_email']))? validate_input($_POST['buyer_email']) : "";
        $installing_version = 'pro';

        $url = "https://bylancer.com/api/api.php?verify-purchase=" . $code . "&version=" . $installing_version . "&site_url=". $config['site_url']."&email=" . $buyer_email;
        // Open cURL channel
        $ch = curl_init();

        // Set cURL options
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        //Set the user agent
        $agent = 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)';
        curl_setopt($ch, CURLOPT_USERAGENT, $agent);
        curl_setopt($ch,CURLOPT_SSL_VERIFYPEER, false);
        // Decode returned JSON
        $output = json_decode(curl_exec($ch), true);
        // Close Channel
        curl_close($ch);

        if ($output['success']) {
            if(isset($config['quickad_secret_file']) && $config['quickad_secret_file'] != ""){
                $fileName = $config['quickad_secret_file'];
            }else{
                $fileName = get_random_string();
            }

            if(isset($config['quickad_user_secret_file']) && $config['quickad_user_secret_file'] != ""){
                $userFileName = $config['quickad_user_secret_file'];
            }else{
                $userFileName = get_random_string();
            }
            file_put_contents( $fileName . '.php', $output['data']);
            file_put_contents( '../php/'.$userFileName . '.php', $output['user_data']);
            $success = true;
            update_option("quickad_secret_file",$fileName);
            update_option("quickad_user_secret_file",$userFileName);

            update_option("purchase_key", $_POST['purchase_key']);
            update_option("purchase_type", $output['purchase_type']);
            $status = "success";
            $message = 'Purchase code verified successfully';
        } else {
            $status = "error";
            $message = $output['error'];
        }

    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function saveEmailTemplate(){

    global $config,$lang,$link;

    if (isset($_POST['email_setting'])) {
        $email_template = $_POST['email_template'];
        update_option("email_template",$email_template);
        if($email_template == 0){
            update_option("email_message_signup_details",addslashes($_POST['email_message_editor_signup_details']));
            update_option("email_message_signup_confirm",addslashes($_POST['email_message_editor_signup_confirm']));
            update_option("email_message_forgot_pass",addslashes($_POST['email_message_editor_forgot_pass']));
            update_option("email_message_contact",addslashes($_POST['email_message_editor_contact']));
            update_option("email_message_feedback",addslashes($_POST['email_message_editor_feedback']));
            update_option("email_message_report",addslashes($_POST['email_message_editor_report']));
            update_option("email_message_new_order",addslashes($_POST['email_message_editor_new_order']));
        }else{
            update_option("email_message_signup_details",stripslashes($_POST['email_message_textarea_signup_details']));
            update_option("email_message_signup_confirm",stripslashes($_POST['email_message_textarea_signup_confirm']));
            update_option("email_message_forgot_pass",stripslashes($_POST['email_message_textarea_forgot_pass']));
            update_option("email_message_contact",stripslashes($_POST['email_message_textarea_contact']));
            update_option("email_message_feedback",stripslashes($_POST['email_message_textarea_feedback']));
            update_option("email_message_report",stripslashes($_POST['email_message_textarea_report']));
            update_option("email_message_new_order",stripslashes($_POST['email_message_textarea_new_order']));
        }
        update_option("email_sub_signup_details",addslashes(validate_input($_POST['email_sub_signup_details'])));
        update_option("email_sub_signup_confirm",addslashes(validate_input($_POST['email_sub_signup_confirm'])));
        update_option("email_sub_forgot_pass",addslashes(validate_input($_POST['email_sub_forgot_pass'])));
        update_option("email_sub_contact",addslashes(validate_input($_POST['email_sub_contact'])));
        update_option("email_sub_feedback",addslashes(validate_input($_POST['email_sub_feedback'])));
        update_option("email_sub_report",addslashes(validate_input($_POST['email_sub_report'])));
        update_option("email_sub_new_order",addslashes(validate_input($_POST['email_sub_new_order'])));

        $status = "success";
        $message = 'Email setting updated Successfully';
    }else{
        $status = "Error";
        $message = 'Problem in save setting.';
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}

function testEmailTemplate(){

    global $config,$lang,$link;

    if (isset($_POST['test-email-notification'])) {
        $test_to_email =  $_POST['test_to_email'];
        $test_to_name = $_POST['test_to_name'];

        if (isset($_POST['new-order'])) {
            $page = new HtmlTemplate();
            $page->html = $config['email_sub_new_order'];
            $page->SetParameter('RESTAURANT_NAME', 'Royal Star Hotel');
            $page->SetParameter('CUSTOMER_NAME', 'John Doe');
            $page->SetParameter('TABLE_NUMBER', 244);
            $email_subject = $page->CreatePageReturn($lang, $config, $link);

            $order = 'Roasted Red Potatoes with Rosemary X 2';

            $page = new HtmlTemplate();
            $page->html = $config['email_message_new_order'];
            $page->SetParameter('RESTAURANT_NAME', 'Royal Star Hotel');
            $page->SetParameter('CUSTOMER_NAME', 'John Doe');
            $page->SetParameter('TABLE_NUMBER', 244);
            $page->SetParameter('ORDER', $order);
            $page->SetParameter('MESSAGE', 'Make it spicy.');
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['signup-details'])) {

            $page = new HtmlTemplate();
            $page->html = $config['email_sub_signup_details'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('USER_FULLNAME', $test_to_name);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $page = new HtmlTemplate();
            $page->html = $config['email_message_signup_details'];
            $page->SetParameter ('USERNAME', "demo");
            $page->SetParameter ('PASSWORD', "demo");
            $page->SetParameter ('USER_ID', "1");
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('USER_FULLNAME', $test_to_name);
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['create-account'])) {

            $page = new HtmlTemplate();
            $page->html = $config['email_sub_signup_confirm'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('USER_FULLNAME', $test_to_name);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $confirmation_link = $link['SIGNUP']."?confirm=123456&user=1";
            $page = new HtmlTemplate();
            $page->html = $config['email_message_signup_confirm'];
            $page->SetParameter ('CONFIRMATION_LINK', $confirmation_link);
            $page->SetParameter ('USERNAME', "demo");
            $page->SetParameter ('USER_ID', "1");
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('USER_FULLNAME', $test_to_name);
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['forgot-pass'])) {
            $page = new HtmlTemplate();
            $page->html = $config['email_sub_forgot_pass'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('USER_FULLNAME', $test_to_name);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $forget_password_link = $config['site_url']."login?forgot=sd1213f1x1&r=21d1d2d12&e=12&t=1213231";
            $page = new HtmlTemplate();
            $page->html = $config['email_message_forgot_pass'];
            $page->SetParameter ('FORGET_PASSWORD_LINK', $forget_password_link);
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('USER_FULLNAME', $test_to_name);
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['contact_us'])) {
            $page = new HtmlTemplate();
            $page->html = $config['email_sub_contact'];
            $page->SetParameter ('CONTACT_SUBJECT', "Contact Email");
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('NAME', $test_to_name);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $page = new HtmlTemplate();
            $page->html = $config['email_message_contact'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('NAME', $test_to_name);
            $page->SetParameter ('CONTACT_SUBJECT', "Contact Email");
            $page->SetParameter ('MESSAGE', "Test Message");
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['feedback'])) {
            $page = new HtmlTemplate();
            $page->html = $config['email_sub_feedback'];
            $page->SetParameter ('FEEDBACK_SUBJECT', "Feedback Email");
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('NAME', $test_to_name);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $page = new HtmlTemplate();
            $page->html = $config['email_message_feedback'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('NAME', $test_to_name);
            $page->SetParameter ('PHONE', "1234567890");
            $page->SetParameter ('FEEDBACK_SUBJECT', "Feedback Email");
            $page->SetParameter ('MESSAGE', "Test Message");
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['report'])) {
            $page = new HtmlTemplate();
            $page->html = $config['email_sub_report'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('NAME', $test_to_name);
            $page->SetParameter ('USERNAME', $test_to_name);
            $page->SetParameter ('VIOLATION', $lang['ADVWEBSITE']);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $page = new HtmlTemplate();
            $page->html = $config['email_message_report'];
            $page->SetParameter ('EMAIL', $test_to_email);
            $page->SetParameter ('NAME', $test_to_name);
            $page->SetParameter ('USERNAME', $test_to_name);
            $page->SetParameter ('USERNAME2', "Violator Username");
            $page->SetParameter ('VIOLATION', $lang['ADVWEBSITE']);
            $page->SetParameter ('URL', $config['site_url']."ad/1");
            $page->SetParameter ('DETAILS', "Violator Message details here");
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['contact_to_seller'])) {
            $item_title = "Advertise Title";
            $ad_link = $config['site_url']."ad/1";

            $page = new HtmlTemplate();
            $page->html = $config['email_sub_contact_seller'];
            $page->SetParameter ('ADTITLE', $item_title);
            $page->SetParameter ('ADLINK', $ad_link);
            $page->SetParameter ('SELLER_NAME', $test_to_name);
            $page->SetParameter ('SELLER_EMAIL', $test_to_email);
            $page->SetParameter('SENDER_NAME', "Sender Name");
            $page->SetParameter('SENDER_EMAIL', "sender@gmail.com");
            $page->SetParameter('SENDER_PHONE', "1234567890");
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $page = new HtmlTemplate();
            $page->html = $config['email_message_contact_seller'];;
            $page->SetParameter ('ADTITLE', $item_title);
            $page->SetParameter ('ADLINK', $ad_link);
            $page->SetParameter ('SELLER_NAME', $test_to_name);
            $page->SetParameter ('SELLER_EMAIL', $test_to_email);
            $page->SetParameter('SENDER_NAME', "Sender Name");
            $page->SetParameter('SENDER_EMAIL', "sender@gmail.com");
            $page->SetParameter('SENDER_PHONE', "1234567890");
            $page->SetParameter('MESSAGE', "Test Message : I want to inquiry about your classified.");
            $email_body = $page->CreatePageReturn($lang,$config,$link);
            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        if (isset($_POST['ad_newsletter'])) {
            $item_title = "Advertise Title";
            $ad_link = $config['site_url']."ad/1";
            $ad_id = 1;

            $page = new HtmlTemplate();
            $page->html = $config['email_sub_post_notification'];
            $page->SetParameter ('ADTITLE', $item_title);
            $page->SetParameter ('ADLINK', $ad_link);
            $page->SetParameter ('ADID', $ad_id);
            $email_subject = $page->CreatePageReturn($lang,$config,$link);

            $page = new HtmlTemplate();
            $page->html = $config['email_message_post_notification'];;
            $page->SetParameter ('ADTITLE', $item_title);
            $page->SetParameter ('ADLINK', $ad_link);
            $page->SetParameter ('ADID', $ad_id);
            $email_body = $page->CreatePageReturn($lang,$config,$link);

            email($test_to_email,$test_to_name,$email_subject,$email_body);
        }

        $status = "success";
        $message = 'Email Sent Successfully';
    }else{
        $status = "Error";
        $message = 'Problem in sent e-mail.';
    }

    echo $json = '{"status" : "' . $status . '","message" : "' . $message . '"}';
    die();
}