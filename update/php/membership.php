<?php
require_once("includes/lib/curl/curl.php");
require_once("includes/lib/curl/CurlResponse.php");

if($config['purchase_type'] != 'pro'){
    error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);
}

if(checkloggedin())
{
    if(isset($_POST['upgrade']))
    {
        $user_id = $_SESSION['user']['id'];
        $plan_taxes = array();
        $price_without_inclusive = 0;
        $tax_ids = array();

        if($_POST['upgrade'] == 'trial'){
            if(get_user_option($user_id,'package_trial_done')){
                error($lang['TRIAL_DONE_ERROR'], __LINE__, __FILE__, 1);
                exit();
            }
            $plan = json_decode(get_option('trial_membership_plan'), true);
            $price = 0;
            $term = $plan['days'];
        }else{
            $plan = ORM::for_table($config['db']['pre'].'plans')
                ->where('id', $_POST['upgrade'])
                ->find_one();

            switch ($_POST['billed-type']){
                case 'monthly':
                    $price = $plan['monthly_price'];
                    $term = 'MONTHLY';
                    break;
                case 'yearly':
                    $price = $plan['annual_price'];
                    $term = 'YEARLY';
                    break;
                case 'lifetime':
                    $price = $plan['lifetime_price'];
                    $term = 'LIFETIME';
                    break;
            }

            $base_amount = $price;

            if(!empty($plan['taxes_ids'])){
                $taxes = ORM::for_table($config['db']['pre'].'taxes')
                    ->where_id_in(explode(',', $plan['taxes_ids']))
                    ->find_many();

                $inclusive_tax = $exclusive_tax = 0;

                foreach ($taxes as $tax){

                    /* filter plan taxes */

                    /* Type */
                    if (
                        $tax['billing_type'] != get_user_option($_SESSION['user']['id'], 'billing_details_type') &&
                        $tax['billing_type'] != 'both'
                    ) {
                        continue;
                    }

                    /* Countries */
                    if (
                        $tax['countries'] &&
                        !in_array(get_user_option($_SESSION['user']['id'], 'billing_country'), explode(',', $tax['countries']))
                    ) {
                        continue;
                    }

                    /* Create variable */
                    $plan_taxes[$tax['id']]['id'] = $tax['id'];
                    $plan_taxes[$tax['id']]['name'] = $tax['name'];
                    $plan_taxes[$tax['id']]['description'] = $tax['description'];
                    $plan_taxes[$tax['id']]['type'] = $tax['type'] == 'inclusive' ? $lang['INCLUSIVE'] : $lang['EXCLUSIVE'];
                    $plan_taxes[$tax['id']]['value_formatted'] = $tax['value_type'] == 'percentage' ? (float) $tax['value'] .'%' : price_format($tax['value'], $config['currency_code']);

                    /* calculate inclusive taxes */
                    if($tax['type'] == 'inclusive'){
                        $inclusive_tax += $tax['value_type'] == 'percentage' ? $price * ($tax['value'] / 100) : $tax['value'];
                    }

                    $tax_ids[] = $tax['id'];
                }

                $price_without_inclusive = $price - $inclusive_tax;

                /* calculate exclusive taxes */
                foreach ($taxes as $tax){
                    /* filter plan taxes */

                    /* Type */
                    if (
                        $tax['billing_type'] != get_user_option($_SESSION['user']['id'], 'billing_details_type') &&
                        $tax['billing_type'] != 'both'
                    ) {
                        continue;
                    }

                    /* Countries */
                    if (
                        $tax['countries'] &&
                        !in_array(get_user_option($_SESSION['user']['id'], 'billing_country'), explode(',', $tax['countries']))
                    ) {
                        continue;
                    }

                    if($tax['type'] == 'exclusive'){
                        $exclusive_tax += $tax['value_type'] == 'percentage' ? $price_without_inclusive * ($tax['value'] / 100) : $tax['value'];
                    }
                }
                /* total price */
                $price += $exclusive_tax;
            }
        }

        $title = $plan['name'];
        $amount = price_format($price,$config['currency_code']);

        $payment_type = "subscr";

        if(isset($_POST['payment_method_id']))
        {
            if($_POST['upgrade'] == 'trial'){
                if(get_user_option($user_id,'package_trial_done')){
                    error($lang['TRIAL_DONE_ERROR'], __LINE__, __FILE__, 1);
                    exit();
                }

                ORM::for_table($config['db']['pre'].'upgrades')
                    ->where_equal('user_id', $user_id)
                    ->delete_many();

                $upgrades_insert = ORM::for_table($config['db']['pre'].'upgrades')->create();
                $upgrades_insert->sub_id = $_POST['upgrade'];
                $upgrades_insert->user_id = $user_id;
                $upgrades_insert->upgrade_lasttime = time();
                $upgrades_insert->upgrade_expires = time() + $plan['days'] * 86400;
                $upgrades_insert->status = 'Active';
                $upgrades_insert->save();

                $person = ORM::for_table($config['db']['pre'].'user')->find_one($user_id);
                $person->group_id = $_POST['upgrade'];
                $person->save();

                update_user_option($user_id, 'package_trial_done',1);
                message($lang['SUCCESS'],$lang['PAYMENTSUCCESS'],$link['MEMBERSHIP']);
                exit();
            } else {
                $access_token = uniqid();
                $_SESSION['quickad'][$access_token]['name'] = $title . " " . $lang['MEMBERSHIPPLAN'];
                $_SESSION['quickad'][$access_token]['amount'] = $price;
                $_SESSION['quickad'][$access_token]['base_amount'] = $base_amount;
                $_SESSION['quickad'][$access_token]['payment_type'] = $payment_type;
                $_SESSION['quickad'][$access_token]['sub_id'] = $_POST['upgrade'];
                $_SESSION['quickad'][$access_token]['plan_interval'] = $term;
                $_SESSION['quickad'][$access_token]['taxes_ids'] = implode(',',$tax_ids);

                $info = ORM::for_table($config['db']['pre'] . 'payments')
                    ->where(array(
                        'payment_id' => $_POST['payment_method_id'],
                        'payment_install' => '1'
                    ))
                    ->find_one();

                $folder = $info['payment_folder'];

                if ($folder == "2checkout") {
                    $_SESSION['quickad'][$access_token]['firstname'] = $_POST['checkoutCardFirstName'];
                    $_SESSION['quickad'][$access_token]['lastname'] = $_POST['checkoutCardLastName'];
                    $_SESSION['quickad'][$access_token]['BillingAddress'] = $_POST['checkoutBillingAddress'];
                    $_SESSION['quickad'][$access_token]['BillingCity'] = $_POST['checkoutBillingCity'];
                    $_SESSION['quickad'][$access_token]['BillingState'] = $_POST['checkoutBillingState'];
                    $_SESSION['quickad'][$access_token]['BillingZipcode'] = $_POST['checkoutBillingZipcode'];
                    $_SESSION['quickad'][$access_token]['BillingCountry'] = $_POST['checkoutBillingCountry'];
                }

                $_SESSION['quickad'][$access_token]['payment_mode'] = !empty($_POST['payment_mode']) ? $_POST['payment_mode'] : 'one_time';
                if($folder == 'paypal' || $folder == 'stripe'){
                    $payment_mode = get_option($folder.'_payment_mode');
                    if($payment_mode == 'both'){
                        $_SESSION['quickad'][$access_token]['payment_mode'] = !empty($_POST['payment_mode']) ? $_POST['payment_mode'] : 'one_time';
                    }else{
                        $_SESSION['quickad'][$access_token]['payment_mode'] = $payment_mode;
                    }
                }

                $_SESSION['quickad'][$access_token]['folder'] = $folder;
                if (file_exists('includes/payments/' . $folder . '/pay.php')) {
                    require_once('includes/payments/' . $folder . '/pay.php');
                } else {
                    error($lang['PAYMENT_METHOD_DISABLED'], __LINE__, __FILE__, 1);
                    exit();
                }
            }
        }
        else
        {
            $payment_types = array();
            $rows = ORM::for_table($config['db']['pre'].'payments')
                ->where('payment_install', '1')
                ->find_many();

            $num_rows = count($rows);
            foreach ($rows as $info)
            {
                $payment_types[$info['payment_id']]['id'] = $info['payment_id'];
                $payment_types[$info['payment_id']]['title'] = $info['payment_title'];
                $payment_types[$info['payment_id']]['folder'] = $info['payment_folder'];
                $payment_types[$info['payment_id']]['desc'] = $info['payment_desc'];
            }

            $period = 0;
            if($_POST['upgrade'] == 'trial'){
                $period = (int) $plan['days'] * 86400;
            }else{
                if($_POST['billed-type'] == "monthly") {
                    $period = 2678400;
                }
                elseif($_POST['billed-type'] == "yearly") {
                    $period = 31536000;
                }
            }

            $expires = (time()+$period);
            $start_date = date("d-m-Y",time());
            $expiry_date = $period ? date("d-m-Y",$expires) : $lang['LIFETIME'];

            // assign posted variables to local variables
            $bank_information = nl2br(get_option('company_bank_info'));
            $userdata = get_user_data($_SESSION['user']['username']);
            $email = $userdata['email'];

            $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/membership_payment.tpl');
            $page->SetParameter ('OVERALL_HEADER', create_header($lang['UPGRADE']));
            $page->SetLoop ('PAYMENT_TYPES', $payment_types);
            $page->SetParameter ('UPGRADE', $_POST['upgrade']);
            $page->SetParameter ('BILLED_TYPE', $_POST['billed-type']);
            $page->SetParameter ('PAYMENT_METHOD_COUNT', $num_rows);
            $page->SetParameter ('PLAN_ID', $_POST['upgrade']);
            $page->SetParameter ('BANK_INFO', $bank_information);
            $page->SetParameter ('START_DATE', $start_date);
            $page->SetParameter ('EXPIRY_DATE', $expiry_date);
            $page->SetParameter ('ORDER_TITLE', $title);
            $page->SetParameter ('AMOUNT', $amount);
            $page->SetParameter ('PRICE', $price);
            $page->SetParameter ('PRICE_WITHOUT_INCLUSIVE', price_format($price_without_inclusive, $config['currency_code']));
            $page->SetParameter ('EMAIL', $email);
            $page->SetParameter ('COUNTRY_CODE', strtoupper(check_user_country()));
            $page->SetParameter ('SHOW_TAXES', (int) !empty($plan_taxes));
            $page->SetLoop ('TAXES', $plan_taxes);
            $page->SetParameter ('OVERALL_FOOTER', create_footer());
            $page->CreatePageEcho();
        }
    }
	else
	{
		$upgrades = array();

		if(isset($_GET['change_plan']) && $_GET['change_plan'] == "changeplan")
		{
            
            check_validation_for_subscribePlan();
            $sub_info = get_user_membership_detail($_SESSION['user']['id']);

            // custom settings
            $plan_custom = ORM::for_table($config['db']['pre'].'plan_options')
                ->where('active', 1)
                ->order_by_asc('position')
                ->find_many();

            $sub_types = array();

            $plan = json_decode(get_option('free_membership_plan'), true);
            if($plan['status']){
                if($plan['id'] == $sub_info['id']) {
                    $sub_types[$plan['id']]['Selected'] = 1;
                } else {
                    $sub_types[$plan['id']]['Selected'] = 0;
                }

                $sub_types[$plan['id']]['id'] = $plan['id'];
                $sub_types[$plan['id']]['title'] = $plan['name'];
                $sub_types[$plan['id']]['monthly_price'] = price_format(0,$config['currency_code']);
                $sub_types[$plan['id']]['annual_price'] = price_format(0,$config['currency_code']);
                $sub_types[$plan['id']]['lifetime_price'] = price_format(0,$config['currency_code']);

                $settings = $plan['settings'];
                $sub_types[$plan['id']]['category_limit'] = ($settings['category_limit'] == "999")? $lang['UNLIMITED']: $settings['category_limit'];
                $sub_types[$plan['id']]['menu_limit'] = ($settings['menu_limit'] == "999")? $lang['UNLIMITED']: $settings['menu_limit'];
                $sub_types[$plan['id']]['scan_limit'] = ($settings['scan_limit'] == "999")? $lang['UNLIMITED']: $settings['scan_limit'];
                $sub_types[$plan['id']]['allow_ordering'] = $settings['allow_ordering'];

                $sub_types[$plan['id']]['custom_settings'] = '';
                if(!empty($plan_custom)) {
                    foreach ($plan_custom as $custom) {
                        if(!empty($custom['title']) && trim($custom['title']) != '') {
                            $tpl = '<li><span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';

                            if (isset($settings['custom'][$custom['id']]) && $settings['custom'][$custom['id']] == '1') {
                                $tpl = '<li><span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';
                            }
                            $sub_types[$plan['id']]['custom_settings'] .= $tpl;
                        }
                    }
                }
            }

            $plan = json_decode(get_option('trial_membership_plan'), true);
            if($plan['status']){
                if($plan['id'] == $sub_info['id']) {
                    $sub_types[$plan['id']]['Selected'] = 1;
                } else {
                    $sub_types[$plan['id']]['Selected'] = 0;
                }

                $sub_types[$plan['id']]['id'] = $plan['id'];
                $sub_types[$plan['id']]['title'] = $plan['name'];
                $sub_types[$plan['id']]['monthly_price'] = price_format(0,$config['currency_code']);
                $sub_types[$plan['id']]['annual_price'] = price_format(0,$config['currency_code']);
                $sub_types[$plan['id']]['lifetime_price'] = price_format(0,$config['currency_code']);;

                $settings = $plan['settings'];
                $sub_types[$plan['id']]['category_limit'] = ($settings['category_limit'] == "999")? $lang['UNLIMITED']: $settings['category_limit'];
                $sub_types[$plan['id']]['menu_limit'] = ($settings['menu_limit'] == "999")? $lang['UNLIMITED']: $settings['menu_limit'];
                $sub_types[$plan['id']]['scan_limit'] = ($settings['scan_limit'] == "999")? $lang['UNLIMITED']: $settings['scan_limit'];
                $sub_types[$plan['id']]['allow_ordering'] = $settings['allow_ordering'];

                $sub_types[$plan['id']]['custom_settings'] = '';
                if(!empty($plan_custom)) {
                    foreach ($plan_custom as $custom) {
                        if(!empty($custom['title']) && trim($custom['title']) != '') {
                            $tpl = '<li><span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';

                            if (isset($settings['custom'][$custom['id']]) && $settings['custom'][$custom['id']] == '1') {
                                $tpl = '<li><span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';
                            }
                            $sub_types[$plan['id']]['custom_settings'] .= $tpl;
                        }
                    }
                }
            }

            $total_monthly = $total_annual = $total_lifetime = 0;

            $rows = ORM::for_table($config['db']['pre'].'plans')
                ->where('status', '1')
                ->find_many();

            foreach ($rows as $plan)
            {
                if($plan['id'] == $sub_info['id']) {
                    $sub_types[$plan['id']]['Selected'] = 1;
                } else {
                    $sub_types[$plan['id']]['Selected'] = 0;
                }

                $sub_types[$plan['id']]['id'] = $plan['id'];
                $sub_types[$plan['id']]['title'] = $plan['name'];
                $sub_types[$plan['id']]['recommended'] = $plan['recommended'];

                $total_monthly += $plan['monthly_price'];
                $total_annual += $plan['annual_price'];
                $total_lifetime += $plan['lifetime_price'];

                $sub_types[$plan['id']]['monthly_price'] = price_format($plan['monthly_price'],$config['currency_code']);
                $sub_types[$plan['id']]['annual_price'] = price_format($plan['annual_price'],$config['currency_code']);
                $sub_types[$plan['id']]['lifetime_price'] = price_format($plan['lifetime_price'],$config['currency_code']);

                $settings = json_decode($plan['settings'], true);
                $sub_types[$plan['id']]['category_limit'] = ($settings['category_limit'] == "999")? $lang['UNLIMITED']: $settings['category_limit'];
                $sub_types[$plan['id']]['menu_limit'] = ($settings['menu_limit'] == "999")? $lang['UNLIMITED']: $settings['menu_limit'];
                $sub_types[$plan['id']]['scan_limit'] = ($settings['scan_limit'] == "999")? $lang['UNLIMITED']: $settings['scan_limit'];
                $sub_types[$plan['id']]['allow_ordering'] = $settings['allow_ordering'];

                $sub_types[$plan['id']]['custom_settings'] = '';
                if(!empty($plan_custom)) {
                    foreach ($plan_custom as $custom) {
                        if(!empty($custom['title']) && trim($custom['title']) != '') {
                            $tpl = '<li><span class="icon-text no"><i class="icon-feather-x-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';

                            if (isset($settings['custom'][$custom['id']]) && $settings['custom'][$custom['id']] == '1') {
                                $tpl = '<li><span class="icon-text yes"><i class="icon-feather-check-circle margin-right-2"></i></span> ' . $custom['title'] . '</li>';
                            }
                            $sub_types[$plan['id']]['custom_settings'] .= $tpl;
                        }
                    }
                }
            }

            $page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/membership_plan.tpl');
            $page->SetParameter ('OVERALL_HEADER', create_header($lang['UPGRADE']));
            $page->SetLoop ('SUB_TYPES', $sub_types);
            $page->SetParameter('TOTAL_MONTHLY', $total_monthly);
            $page->SetParameter('TOTAL_ANNUAL', $total_annual);
            $page->SetParameter('TOTAL_LIFETIME', $total_lifetime);
            $page->SetParameter ('OVERALL_FOOTER', create_footer());
            $page->CreatePageEcho();

			exit;
		}
        else if(isset($_GET['action']) && $_GET['action'] == "cancel_auto_renew")
        {
            $action = $_GET['action'];

            $sub_info = get_user_membership_detail($_SESSION['user']['id']);

            if ( isset($sub_info['id'])) {

                $subscription = ORM::for_table($config['db']['pre'].'upgrades')
                    ->where('user_id', $_SESSION['user']['id'])
                    ->find_one();


                if ( $info['pay_mode'] == 'recurring' ) {
                    try {
                        cancel_recurring_payment($_SESSION['user']['id']);
                    } catch (\Exception $exception) {
                        error_log($exception->getCode());
                        error_log($exception->getMessage());
                    }
                }
                transfer($link['MEMBERSHIP'],$lang['SETTING_SAVED_SUCCESS'],$lang['SETTING_SAVED_SUCCESS']);
                exit;
            }
        }
		else
		{
            $info = ORM::for_table($config['db']['pre'].'upgrades')
                ->where('user_id', $_SESSION['user']['id'])
                ->find_one();

            $show_cancel_button = 0;
            $payment_mode = 'one_time';
            if(!isset($info['sub_id'])){
                $sub_info = json_decode(get_option('free_membership_plan'), true);
                $price = 0;
                $upgrades_term = $upgrades_start_date = $upgrades_expiry_date = '-';
            }else{
                if($info['sub_id'] == 'trial'){
                    $sub_info = json_decode(get_option('trial_membership_plan'), true);
                    $price = 0;
                    $upgrades_term = '-';
                }else{
                    $sub_info = ORM::for_table($config['db']['pre'].'plans')
                        ->where('id', $info['sub_id'])
                        ->find_one();
                    $price = $sub_info['monthly_price'];
                    $payment_mode = $info['pay_mode'];
                    $show_cancel_button = (int) ($payment_mode == 'recurring');
                }
                $upgrades_start_date = date("d-m-Y",$info['upgrade_lasttime']);
                $upgrades_expiry_date = date("d-m-Y",$info['upgrade_expires']);
            }

            $upgrades_title = $sub_info['name'];
            $upgrades_cost = price_format($price,$config['currency_code']);

			$page = new HtmlTemplate ('templates/' . $config['tpl_name'] . '/membership_current.tpl');
			$page->SetParameter ('OVERALL_HEADER', create_header($lang['UPGRADE']));
            $page->SetParameter ('UPGRADE_TITLE', $upgrades_title);
            $page->SetParameter ('UPGRADE_START_DATE', $upgrades_start_date);
            $page->SetParameter ('UPGRADE_EXPIRY_DATE', $upgrades_expiry_date);
            $page->SetParameter ('PAYMENT_MODE', $payment_mode);
            $page->SetParameter ('SHOW_CANCEL_BUTTON', $show_cancel_button);
			$page->SetParameter ('OVERALL_FOOTER', create_footer());
			$page->CreatePageEcho();
			exit;
		}
	}
}
else
{
    headerRedirect($link['LOGIN']);
}