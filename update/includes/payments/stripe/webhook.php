<?php
include 'stripe-php/init.php';

/* Initiate Stripe */
\Stripe\Stripe::setApiKey(get_option('stripe_secret_key'));

$payload = @file_get_contents('php://input');
$sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];
$event = null;
$currency = $config['currency_code'];

try {
    $event = \Stripe\Webhook::constructEvent(
        $payload, $sig_header, get_option('stripe_webhook_secret')
    );

    if(!in_array($event->type, ['invoice.payment_succeeded', 'checkout.session.completed'])) {
        die();
    }

    $session = $event->data->object;

    $payment_id = $session->id;
    $payer_id = $session->customer;
    $payer_object = \Stripe\Customer::retrieve($payer_id);
    $payer_email = $payer_object->email;
    $payer_name = $payer_object->name;

    switch($event->type) {
        /* Handling recurring payments */
        case 'invoice.payment_succeeded':

            $payment_total = in_array($currency, ['MGA', 'BIF', 'CLP', 'PYG', 'DJF', 'RWF', 'GNF', 'UGX', 'JPY', 'VND', 'VUV', 'XAF', 'KMF', 'KRW', 'XOF', 'XPF']) ? $session->amount_paid : $session->amount_paid / 100;
            $payment_currency = strtoupper($session->currency);

            /* Process meta data */
            $metadata = $session->lines->data[0]->metadata;

            $user_id = (int) $metadata->user_id;
            $package_id = (int) $metadata->package_id;
            $payment_frequency = $metadata->payment_frequency;
            $base_amount = $metadata->base_amount;
            $taxes_ids = $metadata->taxes_ids;

            /* Vars */
            $payment_type = $session->subscription ? 'recurring' : 'one_time';
            $payment_subscription_id =  $payment_type == 'recurring' ? 'stripe###' . $session->subscription : '';

            break;

        /* Handling one time payments */
        case 'checkout.session.completed':

            /* Exit when the webhook comes for recurring payments as the invoice.payment_succeeded event will handle it */
            if($session->subscription) {
                die();
            }

            $payment_total = in_array($currency, ['MGA', 'BIF', 'CLP', 'PYG', 'DJF', 'RWF', 'GNF', 'UGX', 'JPY', 'VND', 'VUV', 'XAF', 'KMF', 'KRW', 'XOF', 'XPF']) ? $session->display_items[0]->amount : $session->display_items[0]->amount / 100;
            $payment_currency = strtoupper($session->display_items[0]->currency);

            /* Process meta data */
            $metadata = $session->metadata;

            $user_id = (int) $metadata->user_id;
            $package_id = (int) $metadata->package_id;
            $payment_frequency = $metadata->payment_frequency;
            $base_amount = $metadata->base_amount;
            $taxes_ids = $metadata->taxes_ids;

            /* Vars */
            $payment_type = $session->subscription ? 'recurring' : 'one_time';
            $payment_subscription_id = $payment_type == 'recurring' ? 'stripe###' . $session->subscription : '';


            break;
    }

    /* Get the package details */
    $package = ORM::for_table($config['db']['pre'].'plans')
        ->where('id', $package_id)
        ->find_one();

    /* Just make sure the package is still existing */
    if(!isset($package['id'])) {
        http_response_code(400);
        die();
    }

    /* Make sure the transaction is not already existing */
    if(ORM::for_table($config['db']['pre'].'transaction')
        ->where('payment_id', $payment_id)
        ->where('transaction_gatway', 'stripe')
        ->count()) {
        http_response_code(400);
        die();
    }

    /* Make sure the account still exists */
    $user = ORM::for_table($config['db']['pre'].'user')
        ->where('id', $user_id)
        ->find_one();

    if(!isset($user['id'])) {
        http_response_code(400);
        die();
    }

    /* Unsubscribe from the previous plan if needed */
    $subsc_check = ORM::for_table($config['db']['pre'].'upgrades')
        ->where('user_id', $user_id)
        ->find_one();
    if(isset($subsc_check['user_id']))
    {
        $txn_type = 'subscr_update';

        if($subsc_check['unique_id'] != $payment_subscription_id) {
            try {
                cancel_recurring_payment($user_id);
            } catch (\Exception $exception) {
                error_log($exception->getCode());
                error_log($exception->getMessage());
            }
        }
    }
    else
    {
        $txn_type = 'subscr_signup';
    }

    /* Update the user with the new package */
    $term = 0;
    switch($payment_frequency) {
        case 'MONTHLY':
            $term = 2678400;
            break;

        case 'YEARLY':
            $term = 31536000;
            break;

        case 'LIFETIME':
            $term = 3153600000;
            break;
    }



    // Add time to their subscription
    $expires = (time()+$term);

    if($txn_type == 'subscr_update')
    {

        $query = "UPDATE `".$config['db']['pre']."upgrades` SET 
            `sub_id` = '".validate_input($package_id)."',
            `upgrade_expires` = '".validate_input($expires)."', 
            `pay_mode` = '$payment_type', 
            `unique_id` = '".validate_input($payment_subscription_id)."', 
            `upgrade_lasttime` = '".time()."' 
        WHERE `user_id` = '".validate_input($user_id)."' LIMIT 1";
        $pdo->query($query);

        // update user data
        $user->group_id = $package_id;
        $user->save();

    }
    elseif($txn_type == 'subscr_signup')
    {
        $subscription_status = "Active";

        $upgrades_insert = ORM::for_table($config['db']['pre'].'upgrades')->create();
        $upgrades_insert->sub_id = $package_id;
        $upgrades_insert->user_id = $user_id;
        $upgrades_insert->upgrade_lasttime = time();
        $upgrades_insert->upgrade_expires = $expires;
        $upgrades_insert->pay_mode = $payment_type;
        $upgrades_insert->unique_id = $payment_subscription_id;
        $upgrades_insert->status = $subscription_status;
        $upgrades_insert->save();

        $user->group_id = $package_id;
        $user->save();
    }

    //Update Amount in balance table
    $balance = ORM::for_table($config['db']['pre'].'balance')->find_one(1);
    $current_amount=$balance['current_balance'];
    $total_earning=$balance['total_earning'];

    $updated_amount=($payment_total+$current_amount);
    $total_earning=($payment_total+$total_earning);

    $balance->current_balance = $updated_amount;
    $balance->total_earning = $total_earning;
    $balance->save();

    $billing = array(
        'type' => get_user_option($user_id,'billing_details_type'),
        'tax_id' => get_user_option($user_id,'billing_tax_id'),
        'name' => get_user_option($user_id,'billing_name'),
        'address' => get_user_option($user_id,'billing_address'),
        'city' => get_user_option($user_id,'billing_city'),
        'state' => get_user_option($user_id,'billing_state'),
        'zipcode' => get_user_option($user_id,'billing_zipcode'),
        'country' => get_user_option($user_id,'billing_country')
    );

    $ip = encode_ip($_SERVER, $_ENV);
    $trans_insert = ORM::for_table($config['db']['pre'].'transaction')->create();
    $trans_insert->product_name = $package['name'];
    $trans_insert->product_id = $package_id;
    $trans_insert->seller_id = $user_id;
    $trans_insert->status = 'success';
    $trans_insert->base_amount = $base_amount;
    $trans_insert->amount = $payment_total;
    $trans_insert->transaction_gatway = 'stripe';
    $trans_insert->transaction_ip = $ip;
    $trans_insert->transaction_time = time();
    $trans_insert->transaction_description = $package['name'];
    $trans_insert->payment_id = $payment_id;
    $trans_insert->transaction_method = 'Subscription';
    $trans_insert->frequency = $payment_frequency;
    $trans_insert->billing = json_encode($billing);
    $trans_insert->taxes_ids = $taxes_ids;
    $trans_insert->save();

    // send success
    echo 'successful';

} catch(\UnexpectedValueException $e) {

    // Invalid payload
    http_response_code(400);
    exit();

} catch(\Stripe\Exception\SignatureVerificationException $e) {

    // Invalid signature
    http_response_code(400);
    exit();

}

die();