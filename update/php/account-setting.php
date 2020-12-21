<?php
if(checkloggedin())
{
    update_lastactive();
    $ses_userdata = get_user_data($_SESSION['user']['username']);

    $author_image = $ses_userdata['image'];
    $author_lastactive = $ses_userdata['lastactive'];

    $errors = 0;
    $username_error = '';
    $email_error = '';
    $password_error = '';

    if(isset($_POST['submit']))
    {
        // Check if this is an Username availability check from signup page using ajax
        if($_POST["username"] != $_SESSION['user']['username'])
        {
            if(empty($_POST["username"]))
            {
                $errors++;
                $username_error = $lang['ENTERUNAME'];
                $username_error = "<span class='status-not-available'> ".$username_error."</span>";
            }
            elseif(preg_match('/[^A-Za-z0-9]/',$_POST['username']))
            {
                $errors++;
                $username_error = $lang['USERALPHA'];
                $username_error = "<span class='status-not-available'> ".$username_error." [A-Z,a-z,0-9]</span>";
            }
            elseif( (strlen($_POST['username']) < 4) OR (strlen($_POST['username']) > 16) )
            {
                $errors++;
                $username_error = $lang['USERLEN'];
                $username_error = "<span class='status-not-available'> ".$username_error.".</span>";
            }
            else{
                $user_count = check_username_exists($_POST["username"]);
                if($user_count>0) {
                    $errors++;
                    $username_error = $lang['USERUNAV'];
                    $username_error = "<span class='status-not-available'>".$username_error."</span>";
                }
            }
        }

        // Check if this is an Email availability check from signup page using ajax
        if(is_null($_POST["email"])) {
            $errors++;
            $email_error = $lang['ENTEREMAIL'];
            $email_error = "<span class='status-not-available'> ".$email_error."</span>";
        }
        elseif($_POST["email"] != $ses_userdata['email'])
        {
            $regex = '/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$/';

            if (!preg_match($regex, $_POST['email'])) {
                $errors++;
                $email_error = $lang['EMAILINV'];
                $email_error = "<span class='status-not-available'> " . $email_error . ".</span>";
            } else {
                $user_count = check_account_exists($_POST["email"]);
                if ($user_count > 0) {
                    $errors++;
                    $email_error = $lang['ACCAEXIST'];
                    $email_error = "<span class='status-not-available'>" . $email_error . "</span>";
                }
            }
        }

        // Check if this is an Password availability check from signup page using ajax
        if(!empty($_POST["password"]))
        {
            if( (strlen($_POST['password']) < 5) OR (strlen($_POST['password']) > 21) )
            {
                $errors++;
                $password_error = $lang['PASSLENG'];
                $password_error = "<span class='status-not-available'> ".$password_error.".</span>";
            }
        }

        if($errors == 0)
        {
            $queryVar = "";

            $person = ORM::for_table($config['db']['pre'].'user')->find_one($_SESSION['user']['id']);
            $person->set('username', $_POST["username"]);
            $person->set('email', $_POST["email"]);
            $person->set('phone', $_POST["phone"]);
            $person->set('currency', $_POST["currency"]);
            $person->set('menu_layout', $_POST["menu_layout"]);
            $person->set_expr('updated_at', 'NOW()');

            if(!empty($_POST["password"]))
            {
                $password = $_POST["password"];
                $pass_hash = password_hash($password, PASSWORD_DEFAULT, ['cost' => 13]);

                $person->set('password_hash', $pass_hash);
            }
            $person->save();

            //Updating Session Values
            $loggedin = get_user_data("",$_SESSION['user']['id']);
            create_user_session($loggedin['id'],$loggedin['username'],$loggedin['password']);

            transfer($link['ACCOUNT_SETTING'],$lang['SETTING_SAVED_SUCCESS'],$lang['SETTING_SAVED_SUCCESS']);
            exit;
        }
    }

    $billing_error = 0;
    if(isset($_POST['billing-submit']))
    {

        if (
            (empty($_POST["billing_details_type"]) || trim($_POST["billing_details_type"]) == '') ||
            (empty($_POST["billing_name"]) || trim($_POST["billing_name"]) == '') ||
            (empty($_POST["billing_address"]) || trim($_POST["billing_address"]) == '') ||
            (empty($_POST["billing_city"]) || trim($_POST["billing_city"]) == '') ||
            (empty($_POST["billing_state"]) || trim($_POST["billing_state"]) == '') ||
            (empty($_POST["billing_zipcode"]) || trim($_POST["billing_zipcode"]) == '') ||
            (empty($_POST["billing_country"]) || trim($_POST["billing_country"]) == '')
        ) {
            $billing_error = 1;
        }else {
            update_user_option($_SESSION['user']['id'],'billing_details_type', validate_input($_POST['billing_details_type']));
            update_user_option($_SESSION['user']['id'],'billing_tax_id', validate_input($_POST['billing_tax_id']));
            update_user_option($_SESSION['user']['id'],'billing_name', validate_input($_POST['billing_name']));
            update_user_option($_SESSION['user']['id'],'billing_address', validate_input($_POST['billing_address']));
            update_user_option($_SESSION['user']['id'],'billing_city', validate_input($_POST['billing_city']));
            update_user_option($_SESSION['user']['id'],'billing_state', validate_input($_POST['billing_state']));
            update_user_option($_SESSION['user']['id'],'billing_zipcode', validate_input($_POST['billing_zipcode']));
            update_user_option($_SESSION['user']['id'],'billing_country', validate_input($_POST['billing_country']));

            transfer($link['ACCOUNT_SETTING'],$lang['SETTING_SAVED_SUCCESS'],$lang['SETTING_SAVED_SUCCESS']);
            exit;
        }
    }

    $page = new HtmlTemplate ("templates/" . $config['tpl_name'] . "/account-setting.tpl");
    $page->SetParameter ('OVERALL_HEADER', create_header($lang['ACCOUNT_SETTING']));
    if(isset($_POST['submit']))
    {
        $page->SetParameter ('EMAIL_FIELD', $ses_userdata['email']);
        $page->SetParameter ('USERNAME_FIELD', $_SESSION['user']['username']);

        $page->SetParameter ('USERNAME_ERROR', $username_error);
        $page->SetParameter ('EMAIL_ERROR', $email_error);
        $page->SetParameter ('PASSWORD_ERROR', $password_error);
    }
    else
    {
        $page->SetParameter ('EMAIL_FIELD', $ses_userdata['email']);
        $page->SetParameter ('USERNAME_FIELD', $_SESSION['user']['username']);


        $page->SetParameter ('USERNAME_ERROR', '');
        $page->SetParameter ('EMAIL_ERROR', '');
        $page->SetParameter ('PASSWORD_ERROR', '');

    }

    $currency = !empty($ses_userdata['currency'])?$ses_userdata['currency']:get_option('currency_code');


    $page->SetParameter ('AUTHORUNAME', ucfirst($ses_userdata['username']));
    $page->SetParameter ('AUTHORNAME', ucfirst($ses_userdata['name']));
    $page->SetParameter ('PHONE', $ses_userdata['phone']);
    $page->SetParameter ('AUTHORIMG', $author_image);
    $page->SetParameter ('LASTACTIVE', $author_lastactive);
    $page->SetParameter ('MENU_LAYOUT', $ses_userdata['menu_layout']);
    $page->SetParameter ('BILLING_ERROR', $billing_error);
    $page->SetParameter ('BILLING_DETAILS_TYPE', get_user_option($_SESSION['user']['id'],'billing_details_type'));
    $page->SetParameter ('BILLING_TAX_ID', get_user_option($_SESSION['user']['id'],'billing_tax_id'));
    $page->SetParameter ('BILLING_NAME', get_user_option($_SESSION['user']['id'],'billing_name'));
    $page->SetParameter ('BILLING_ADDRESS', get_user_option($_SESSION['user']['id'],'billing_address'));
    $page->SetParameter ('BILLING_CITY', get_user_option($_SESSION['user']['id'],'billing_city'));
    $page->SetParameter ('BILLING_STATE', get_user_option($_SESSION['user']['id'],'billing_state'));
    $page->SetParameter ('BILLING_ZIPCODE', get_user_option($_SESSION['user']['id'],'billing_zipcode'));
    $page->SetParameter ('BILLING_COUNTRY', get_user_option($_SESSION['user']['id'],'billing_country'));
    $page->SetLoop ('HTMLPAGE', get_html_pages());
    $page->SetLoop ('CURRENCY', get_currency_list($currency));
    $page->SetLoop ('COUNTRIES', get_country_list(get_user_option($_SESSION['user']['id'],'billing_country')));
    $page->SetParameter('COPYRIGHT_TEXT', get_option("copyright_text"));
    $page->SetParameter ('OVERALL_FOOTER', create_footer());
    $page->CreatePageEcho();
}
else{
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
    exit();
}
?>