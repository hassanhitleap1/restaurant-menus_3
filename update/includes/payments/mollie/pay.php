<?php
header("Pragma: no-cache");
header("Cache-Control: no-cache");
header("Expires: 0");

if (!checkloggedin()) {
    header("Location: " . $link['LOGIN']);
    exit();
}

if (isset($_SESSION['quickad'][$access_token]['payment_type'])) {
    $currency = filter_var($config['currency_code'], FILTER_SANITIZE_STRING);

    if ($currency != 'EUR') {
        error($lang['MOLLIE_ACCEPTS_EURO_ONLY'], __LINE__, __FILE__, 1);
        exit();
    }

    $title = filter_var($_SESSION['quickad'][$access_token]['name'], FILTER_SANITIZE_STRING);
    $amount = filter_var($_SESSION['quickad'][$access_token]['amount'], FILTER_SANITIZE_STRING);


    try {
        include_once 'Mollie/API/Autoloader.php';
        $api = new \Mollie_API_Client();
        $api->setApiKey(filter_var(get_option('mollie_api_key'), FILTER_SANITIZE_STRING));

        $mollie_payment = $api->payments->create(array(
            'amount' => $amount,
            'description' => $title,
            'redirectUrl' => $link['IPN'] . "/?access_token=" . $access_token . "&i=mollie",
            'metadata' => array('access_token' => $access_token),
            'issuer' => null
        ));
        if ($mollie_payment->isOpen()) {
            $_SESSION['quickad'][$access_token]['mollie_id'] = $mollie_payment->id;
            header('Location: ' . $mollie_payment->getPaymentUrl());
            exit;
        } else {

            payment_fail_save_detail($access_token);
            email($config['admin_email'], $config['site_title'] . ' Admin', 'Mollie error in ' . $config['site_title'], 'Mollie error in ' . $config['site_title']);

            payment_error("error", $lang['MOLLIE_ERROR'], $access_token);
            exit();
        }

    } catch (\Exception $e) {
        payment_fail_save_detail($access_token);
        echo $error_msg = $e->getMessage();

        email($config['admin_email'], $config['site_title'] . ' Admin', 'Mollie error in ' . $config['site_title'], 'Mollie error in ' . $config['site_title'] . '. Error Message: ' . $error_msg);

        payment_error("error", $error_msg, $access_token);
        exit();
    }

} else {
    error($lang['INVALID_TRANSACTION'], __LINE__, __FILE__, 1);
    exit();
}