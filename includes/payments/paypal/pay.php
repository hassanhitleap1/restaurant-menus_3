<?php
header("Pragma: no-cache");
header("Cache-Control: no-cache");
header("Expires: 0");

if(!checkloggedin()){
    header("Location: ".$link['LOGIN']);
    exit();
}

include 'paypal-sdk/autoload.php';

$action = isset($_POST['action']) ? $_POST['action'] : (isset($_GET['action']) ? $_GET['action'] : '');


// manually set action for paypal payments
if (empty($action) && isset($_REQUEST['token']) && isset($_REQUEST['PayerID'])) {
    $action = 'paypal_ipn';
}
else if ( empty($action) ) {
    $action = 'paypal_payment';
}

$currency = $config['currency_code'];
$user_id = $_SESSION['user']['id'];

if(isset($access_token)){
    $title = $_SESSION['quickad'][$access_token]['name'];
    $total = $_SESSION['quickad'][$access_token]['amount'];
    $base_amount = $_SESSION['quickad'][$access_token]['base_amount'];
    $plan_interval = $_SESSION['quickad'][$access_token]['plan_interval'];
    $payment_mode = $_SESSION['quickad'][$access_token]['payment_mode'];
    $package_id = $_SESSION['quickad'][$access_token]['sub_id'];
    $taxes_ids = isset($_SESSION['quickad'][$access_token]['taxes_ids'])? $_SESSION['quickad'][$access_token]['taxes_ids'] : null;

    /* Lifetime */
    if($plan_interval == 'LIFETIME') {
        $payment_mode = 'one_time';
    }
}

$plan_interval_count = 1;
$enable_trial = 0;
$trial_days = 7;

if ( !empty($action) ) {

    switch ($action) {
        case 'paypal_payment':

            /* Initiate paypal */
            $paypal = new \PayPal\Rest\ApiContext(new \PayPal\Auth\OAuthTokenCredential(get_option('paypal_api_client_id'), get_option('paypal_api_secret')));
            $paypal->setConfig(array(
                    'mode' => (get_option('paypal_sandbox_mode') == 'Yes') ?
                        'sandbox' :
                        'live')
            );

            /* Make sure the price is right depending on the currency */
            $price = in_array($currency, ['JPY', 'TWD', 'HUF']) ? number_format($total, 0, '.', '') : number_format($total, 2, '.', '');

            switch($payment_mode) {
                case 'one_time':

                    /* Payment experience */
                    $flowConfig = new \PayPal\Api\FlowConfig();
                    $flowConfig->setLandingPageType('Billing');
                    $flowConfig->setUserAction('commit');
                    $flowConfig->setReturnUriHttpMethod('GET');

                    $presentation = new \PayPal\Api\Presentation();
                    $presentation->setBrandName('');

                    $inputFields = new \PayPal\Api\InputFields();
                    $inputFields->setAllowNote(true)
                        ->setNoShipping(1)
                        ->setAddressOverride(0);

                    $webProfile = new \PayPal\Api\WebProfile();
                    $webProfile->setName(uniqid())
                        ->setFlowConfig($flowConfig)
                        ->setPresentation($presentation)
                        ->setInputFields($inputFields)
                        ->setTemporary(true);

                    /* Create the experience profile */
                    try {
                        $createdProfileResponse = $webProfile->create($paypal);
                    } catch (Exception $exception) {
                        payment_fail_save_detail($access_token);

                        payment_error("error",$exception->getMessage(),$access_token);
                    }

                    $payer = new \PayPal\Api\Payer();
                    $payer->setPaymentMethod('paypal');

                    $item = new \PayPal\Api\Item();
                    $item->setName($title)
                        ->setCurrency($currency)
                        ->setQuantity(1)
                        ->setPrice($price);

                    $itemList = new \PayPal\Api\ItemList();
                    $itemList->setItems([$item]);

                    $amount = new \PayPal\Api\Amount();
                    $amount->setCurrency($currency)
                        ->setTotal($price);

                    $transaction = new \PayPal\Api\Transaction();
                    $transaction->setAmount($amount)
                        ->setItemList($itemList)
                        ->setInvoiceNumber(uniqid());

                    $redirectUrls = new \PayPal\Api\RedirectUrls();
                    $redirectUrls->setReturnUrl($link['PAYMENT']."/?access_token=".$access_token."&i=paypal&payment_mode=one_time")
                        ->setCancelUrl($link['PAYMENT']."/?access_token=".$access_token."&status=cancel");

                    $payment = new \PayPal\Api\Payment();
                    $payment->setIntent('sale')
                        ->setPayer($payer)
                        ->setRedirectUrls($redirectUrls)
                        ->setTransactions([$transaction])
                        ->setExperienceProfileId($createdProfileResponse->getId());

                    try {
                        $payment->create($paypal);
                    } catch (Exception $exception) {
                        payment_fail_save_detail($access_token);

                        payment_error("error",$exception->getMessage(),$access_token);
                    }

                    $payment_url = $payment->getApprovalLink();

                    header('Location: ' . $payment_url);

                    break;

                case 'recurring':

                    $plan = new \PayPal\Api\Plan();
                    $plan->setName($title)
                        ->setDescription($title)
                        ->setType('fixed');

                    /* Set billing plan definitions */
                    $payment_definition = new \PayPal\Api\PaymentDefinition();
                    $payment_definition->setName('Regular Payments')
                        ->setType('REGULAR')
                        ->setFrequency($plan_interval == 'MONTHLY' ? 'Month' : 'Year')
                        ->setFrequencyInterval('1')
                        ->setCycles($plan_interval == 'MONTHLY' ? '12' : '5')
                        ->setAmount(new \PayPal\Api\Currency(array('value' => $price, 'currency' => $currency)));


                    /* Set merchant preferences */
                    $merchant_preferences = new \PayPal\Api\MerchantPreferences();
                    $merchant_preferences->setReturnUrl($link['PAYMENT']."/?access_token=".$access_token."&i=paypal&payment_mode=recurring")
                        ->setCancelUrl($link['PAYMENT']."/?access_token=".$access_token."&status=cancel")
                        ->setAutoBillAmount('yes')
                        ->setInitialFailAmountAction('CONTINUE')
                        ->setMaxFailAttempts('0')
                        ->setSetupFee(new \PayPal\Api\Currency(array('value' => $price, 'currency' => $currency)));

                    $plan->setPaymentDefinitions([$payment_definition]);
                    $plan->setMerchantPreferences($merchant_preferences);

                    /* Create the plan */
                    try {
                        $plan = $plan->create($paypal);
                    } catch (Exception $exception) {
                        payment_fail_save_detail($access_token);

                        payment_error("error",$exception->getMessage(),$access_token);
                    }

                    /* Make sure to activate the plan */
                    try {
                        $patch = new \PayPal\Api\Patch();
                        $value = new \PayPal\Common\PayPalModel('{"state":"ACTIVE"}');
                        $patch->setOp('replace')
                            ->setPath('/')
                            ->setValue($value);
                        $patchRequest = new \PayPal\Api\PatchRequest();
                        $patchRequest->addPatch($patch);
                        $plan->update($patchRequest, $paypal);
                        $plan = \PayPal\Api\Plan::get($plan->getId(), $paypal);
                    } catch (Exception $exception) {
                        payment_fail_save_detail($access_token);

                        payment_error("error",$exception->getMessage(),$access_token);
                    }



                    /* Start creating the agreement */
                    $agreement = new \PayPal\Api\Agreement();
                    $agreement->setName($title)
                        ->setDescription($user_id . '###' . $package_id . '###' . $plan_interval . '###' . $base_amount . '###' . $taxes_ids . '###' . time())
                        ->setStartDate((new \DateTime())->modify($plan_interval == 'MONTHLY' ? '+30 days' : '+1 year')->format(DATE_ISO8601));

                    /* Set the plan id to the agreement */
                    $agreement_plan = new \PayPal\Api\Plan();
                    $agreement_plan->setId($plan->getId());
                    $agreement->setPlan($agreement_plan);

                    /* Add Payer */
                    $payer = new \PayPal\Api\Payer();
                    $payer->setPaymentMethod('paypal');
                    $agreement->setPayer($payer);

                    /* Create the agreement */
                    try {
                        $agreement = $agreement->create($paypal);
                    } catch (Exception $exception) {
                        payment_fail_save_detail($access_token);

                        payment_error("error",$exception->getMessage(),$access_token);
                    }

                    $payment_url = $agreement->getApprovalLink();

                    header('Location: ' . $payment_url);

                    break;
            }
            break;

/***********************************************************************************************************************/

        case 'paypal_ipn':

            /* Initiate paypal */
            $paypal = new \PayPal\Rest\ApiContext(new \PayPal\Auth\OAuthTokenCredential(get_option('paypal_api_client_id'), get_option('paypal_api_secret')));
            $paypal->setConfig(array(
                    'mode' => (get_option('paypal_sandbox_mode') == 'Yes') ?
                        'sandbox' :
                        'live')
            );

            /* Return confirmation processing one time payment */
            if($_GET['payment_mode'] == 'one_time') {
                $payment_id = $_GET['paymentId'];
                $payer_id = $_GET['PayerID'];
                $payment_type = 'one_time';

                $subscription_id = '';
                $payment_subscription_id =  '';

                try {
                    $payment = \PayPal\Api\Payment::get($payment_id, $paypal);

                    $payer_info = $payment->getPayer()->getPayerInfo();
                    $payer_email = $payer_info->getEmail();
                    $payer_name = $payer_info->getFirstName() . ' ' . $payer_info->getLastName();

                    $payment_total = $payment->getTransactions()[0]->getAmount()->getTotal();
                    $payment_currency = $payment->getTransactions()[0]->getAmount()->getCurrency();

                    /* Execute the payment */
                    $execute = new \PayPal\Api\PaymentExecution();
                    $execute->setPayerId($payer_id);

                    $result = $payment->execute($execute, $paypal);

                    /* Get status after execution */
                    $payment_status = $payment->getState();

                } catch (Exception $exception) {
                    payment_fail_save_detail($access_token);
                    payment_error("error",$exception->getMessage(),$access_token);
                }

                /* Make sure the transaction is not already existing */
                if(ORM::for_table($config['db']['pre'].'transaction')
                    ->where('payment_id', $payment_id)
                    ->where('transaction_gatway', 'paypal')
                    ->count()) {
                    payment_fail_save_detail($access_token);
                    payment_error("error", $lang['INVALID_TRANSACTION'],$access_token);
                }

                /* Make sure the payment is approved */
                if($payment_status != 'approved') {
                    payment_fail_save_detail($access_token);
                    payment_error("error", $lang['INVALID_TRANSACTION'],$access_token);
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

                /*Success*/
                payment_success_save_detail($access_token);
            }
            /* Return confirmation processing recurring payment */
            elseif($_GET['payment_mode'] == 'recurring') {

                $token = $_GET['token'];
                $agreement = new \PayPal\Api\Agreement();
                $payment_type = 'recurring';

                try {
                    $agreement->execute($token, $paypal);
                } catch (Exception $exception) {
                    payment_fail_save_detail($access_token);
                    payment_error("error", $exception->getMessage(),$access_token);
                }

                /* Get details about the executed agreement */
                try {
                    $agreement = \PayPal\Api\Agreement::get($agreement->getId(), $paypal);
                } catch (Exception $exception) {
                    payment_fail_save_detail($access_token);
                    payment_error("error", $exception->getMessage(),$access_token);
                }

                /* Get the needed details from the agreement */
                $agreement_status = $agreement->getState();

                /* Make sure the payment is approved */
                if($agreement_status != 'Active' && $agreement_status != 'Pending') {
                    payment_fail_save_detail($access_token);
                    payment_error("error", $lang['INVALID_TRANSACTION'],$access_token);
                }

                /* Success message and redirect */
                unset($_SESSION['quickad'][$access_token]);
                message($lang['SUCCESS'], $lang['PAYMENTSUCCESS'], $link['TRANSACTION']);
                exit();
            }
            break;

    }
}
