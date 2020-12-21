<?php
header("Pragma: no-cache");
header("Cache-Control: no-cache");
header("Expires: 0");

include('Crypto.php');

error_reporting(0);

if(!checkloggedin()){
    header("Location: ".$link['LOGIN']);
    exit();
}

/**
 * Execute purchase product after successful payment
 */
function responseReturn()
{
    global $config;
    $error = '';
    $access_token = $_GET["access_token"];

    if ($_POST["RESPCODE"] == 01 && isset($_GET["access_token"])) {
        $working_key='B5FF824CA9E4232ED185D9B05D2E2CCB';		//Working Key should be provided here.
        $encResponse=$_POST["encResp"];			//This is the response sent by the CCAvenue Server
        $rcvdString=decrypt($encResponse,$working_key);		//Crypto Decryption used as per the specified working key.
        $order_status="";
        $decryptValues=explode('&', $rcvdString);
        $dataSize=sizeof($decryptValues);
        echo "<center>";

        for($i = 0; $i < $dataSize; $i++)
        {
            $information=explode('=',$decryptValues[$i]);
            if($i==3)	$order_status=$information[1];
        }

        if($order_status==="Success")
        {
            echo "<br>Thank you for shopping with us. Your credit card has been charged and your transaction is successful. We will be shipping your order to you soon.";

        }
        else if($order_status==="Aborted")
        {
            echo "<br>Thank you for shopping with us.We will keep you posted regarding the status of your order through e-mail";

        }
        else if($order_status==="Failure")
        {
            echo "<br>Thank you for shopping with us.However,the transaction has been declined.";
        }
        else
        {
            echo "<br>Security Error. Illegal access detected";

        }

        echo "<br><br>";

        echo "<table cellspacing=4 cellpadding=4>";
        for($i = 0; $i < $dataSize; $i++)
        {
            $information=explode('=',$decryptValues[$i]);
            echo '<tr><td>'.$information[0].'</td><td>'.$information[1].'</td></tr>';
        }

        echo "</table><br>";
        echo "</center>";
        exit();
    } else {
        // the transaction was not successful, do not deliver value'
        // print_r($result);  //uncomment this line to inspect the result, to check why it failed.

        payment_fail_save_detail($access_token);
        mail($config['admin_email'],'Paystack error in '.$config['site_title'],'Paystack error in '.$config['site_title'].', status from Paystack');

        $error_msg = "Transaction was not successful: Last gateway response was: ".$_POST["RESPMSG"];
        payment_error("error",$error_msg,$access_token);
        exit();
    }
}

// manually set action for paytm payments
if (isset($_REQUEST['access_token']) && isset($_REQUEST['i']) && $_REQUEST['i'] == 'ccavenue') {
    responseReturn();
}

if (isset($_SESSION['quickad'][$access_token]['payment_type'])) {
    $currency = $config['currency_code'];
    $title = $_SESSION['quickad'][$access_token]['name'];
    $amount = $_SESSION['quickad'][$access_token]['amount'];

    $_SESSION['quickad'][$access_token]['merchantOrderId'] = $access_token;

    //URL
    $merchant_id='245802';//Shared by CCAVENUES
    $access_code='AVMB90HB37AM42BMMA';//Shared by CCAVENUES
    $working_key='B5FF824CA9E4232ED185D9B05D2E2CCB';//Shared by CCAVENUES

    $_POST['tid'] = uniqid();
    $_POST['merchant_id'] = $merchant_id;
    $_POST['order_id'] = uniqid();
    $_POST['amount'] = $amount;
    $_POST['currency'] = 'INR';
    $_POST['redirect_url'] = $link['PAYMENT']."/?access_token=".$access_token."&i=ccavenue";
    $_POST['cancel_url'] = $link['PAYMENT']."/?access_token=".$access_token."&status=cancel";
    $_POST['language'] = 'EN';

    $merchant_data='';

    foreach ($_POST as $key => $value){
        $merchant_data.=$key.'='.$value.'&';
    }

    $encrypted_data=encrypt($merchant_data,$working_key); // Method for encrypting the data.

    $production_url='https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction&encRequest='.$encrypted_data.'&access_code='.$access_code;

    ?>
    <html>
    <head>
        <title>Redirecting...</title>
    </head>
    <body>
    <p>Please do not refresh this page...</p>
    <form method="post" name="redirect" action="https://secure.ccavenue.com/transaction/transaction.do?command=initiateTransaction">
        <?php
        echo "<input type=hidden name=encRequest value=$encrypted_data>";
        echo "<input type=hidden name=access_code value=$access_code>";
        ?>
    </form>
    <script language='javascript'>document.redirect.submit();</script>
    </body>
    </html>
    <?php
    exit;
}
else {
    error($lang['INVALID_TRANSACTION'], __LINE__, __FILE__, 1);
    exit();
}

?>


<?php





?>