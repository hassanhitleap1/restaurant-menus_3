<?php

if (!empty($_GET['access_token'])) {
    $access_token = filter_var($_GET['access_token'], FILTER_SANITIZE_STRING);
    if (!empty($_SESSION['quickad'][$access_token]['mollie_id'])) {
        $mollie_id = filter_var($_SESSION['quickad'][$access_token]['mollie_id'], FILTER_SANITIZE_STRING);
        include_once 'Mollie/API/Autoloader.php';
        $api = new \Mollie_API_Client();
        $api->setApiKey(get_option('mollie_api_key'));
        $mollie_payment = $api->payments->get($mollie_id);

        if ($mollie_payment->isOpen() || $mollie_payment->isPending() || $mollie_payment->isPaid()) {
            payment_success_save_detail($access_token);
        }
    }
    payment_fail_save_detail($access_token);
    $error_msg = $lang['TRANSACTIONS_NOT_SUCCESSFUL'];
    payment_error("error", $error_msg, $access_token);
    exit();
}
error($lang['PAGE_NOT_FOUND'], __LINE__, __FILE__, 1);