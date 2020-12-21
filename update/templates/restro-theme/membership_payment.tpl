{OVERALL_HEADER}
<div id="titlebar">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h2>{LANG_UPGRADE}</h2>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li>{LANG_UPGRADE}</li>
                    </ul>
                </nav>

            </div>
        </div>
    </div>
</div>
<div class="container">
    <div class="row">
        <div class="col-xl-8 col-lg-8 content-right-offset">
            <form id="subscribeForm" method="POST" novalidate="novalidate">
                <h3>{LANG_PAYMENT_METHOD}</h3>
                <div class="payment margin-top-30">
                    IF("{PLAN_ID}"=="trial"){
                    <div class="payment-tab payment-tab-active">
                        <div class="payment-tab-trigger">
                            <input checked id="trial" name="payment_method_id" type="radio" value="trial"
                                   data-name="trial">
                            <label for="trial">{LANG_START_TRIAL}</label>
                        </div>
                    </div>
                    {ELSE}
                    {LOOP: PAYMENT_TYPES}
                        IF("{PAYMENT_TYPES.folder}"=="paypal"){
                        <div class="payment-tab payment-tab-active">
                            <div class="payment-tab-trigger">
                                <input checked id="{PAYMENT_TYPES.folder}" class="payment_method_id" name="payment_method_id" type="radio"
                                       value="{PAYMENT_TYPES.id}" data-name="paypal">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png"
                                     alt="{PAYMENT_TYPES.title}">
                            </div>
                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_PAYPAL}</p>
                                IF("{PAYPAL_PAYMENT_MODE}"=="both"){
                                <h4 class="margin-bottom-10">{LANG_PAYMENT_TYPE}</h4>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="radio">
                                            <input id="one-time" name="payment_mode" type="radio" value="one_time" checked="">
                                            <label for="one-time"><span class="radio-label"></span> {LANG_ONE_TIME_PAYMENT}</label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="radio">
                                            <input id="recurring" name="payment_mode" type="radio" value="recurring">
                                            <label for="recurring"><span class="radio-label"></span> {LANG_RECURRING_PAYMENT}</label>
                                        </div>
                                    </div>
                                </div>
                                {:IF}
                            </div>
                        </div>
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="paytm" && "{COUNTRY_CODE}"=="IN"){
                        <!-- paytm-->
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="paytm">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>

                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_PAYTM}</p>
                            </div>
                        </div>
                        <!-- paytm -->
                    {:IF}

                        IF("{PAYMENT_TYPES.folder}"=="ccavenue" && "{COUNTRY_CODE}"=="IN"){
                        <!-- ccavenue-->
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="ccavenue">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>

                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_CCAVENUE}</p>
                            </div>
                        </div>
                        <!-- ccavenue -->
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="payumoney"){
                        <!-- Payumoney -->
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="payumoney">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>

                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_PAYUMONEY}</p>
                            </div>
                        </div>
                        <!-- Payumoney -->
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="paystack"){
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="paystack">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>
                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_PAYSTACK}</p>
                            </div>
                        </div>
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="stripe"){
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="creditCart" type="radio"
                                       value="{PAYMENT_TYPES.id}" data-name="stripe">
                                <label for="creditCart">{LANG_CREDIT_DEBIT_CARD}</label>
                                <img class="payment-logo"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>

                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_STRIPE}</p>
                                IF("{STRIPE_PAYMENT_MODE}"=="both"){
                                <h4 class="margin-bottom-10">{LANG_PAYMENT_TYPE}</h4>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="radio">
                                            <input id="one-time-stripe" name="payment_mode" type="radio" value="one_time" checked="">
                                            <label for="one-time-stripe"><span class="radio-label"></span> {LANG_ONE_TIME_PAYMENT}</label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="radio">
                                            <input id="recurring-stripe" name="payment_mode" type="radio" value="recurring">
                                            <label for="recurring-stripe"><span class="radio-label"></span> {LANG_RECURRING_PAYMENT}</label>
                                        </div>
                                    </div>
                                </div>
                                {:IF}
                            </div>
                        </div>
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="2checkout"){
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="2checkout">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>
                            <div class="payment-tab-content">
                                <!-- CREDIT CARD FORM STARTS HERE -->
                                <div class="row payment-form-row">
                                    <div class="col-12">
                                        <div class="card-label form-group">
                                            <input type="text" class="form-control" name="checkoutCardNumber"
                                                   placeholder="{LANG_CARD_NUMBER}" autocomplete="cc-number" autofocus/>
                                        </div>
                                    </div>
                                    <div class="col-7">
                                        <div class="card-label form-group">
                                            <input type="tel" class="form-control" name="checkoutCardExpiry"
                                                   placeholder="MM / YYYY" autocomplete="cc-exp" aria-required="true"
                                                   aria-invalid="false">
                                        </div>
                                    </div>
                                    <div class="col-5 pull-right">
                                        <div class="card-label form-group">
                                            <input type="tel" class="form-control" name="checkoutCardCVC"
                                                   placeholder="CVV" autocomplete="cc-csc"/>
                                        </div>
                                    </div>
                                    <div class="col-7">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutCardFirstName"
                                                    placeholder="{LANG_FIRST_NAME}"

                                            />
                                        </div>
                                    </div>
                                    <div class="col-5 pull-right">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutCardLastName"
                                                    placeholder="{LANG_LAST_NAME}"

                                            />
                                        </div>
                                    </div>
                                    <div class="col-7">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutBillingAddress"
                                                    placeholder="{LANG_ADDRESS}"

                                            />
                                        </div>
                                    </div>
                                    <div class="col-5 pull-right">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutBillingCity"
                                                    placeholder="{LANG_CITY}"

                                            />
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutBillingState"
                                                    placeholder="{LANG_STATE}"

                                            />
                                        </div>
                                    </div>
                                    <div class="col-4 pull-right">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutBillingZipcode"
                                                    placeholder="{LANG_ZIPCODE}"

                                            />
                                        </div>
                                    </div>
                                    <div class="col-4 pull-right">
                                        <div class="card-label form-group">
                                            <input
                                                    type="text"
                                                    class="form-control"
                                                    name="checkoutBillingCountry"
                                                    placeholder="{LANG_COUNTRY}"

                                            />
                                        </div>
                                    </div>

                                    <div id="checkoutPaymentErrors" class="text-danger" style="display:none;">
                                        <div class="col-12">
                                            <p class="payment-errors"></p>
                                        </div>
                                    </div>
                                </div>
                                <!-- CREDIT CARD FORM ENDS HERE -->

                            </div>

                        </div>
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="wire_transfer"){
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="offlinepayment">
                                <label for="{PAYMENT_TYPES.folder}">{LANG_BANK_DEPOST_OFF_PAY}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png" alt="">
                            </div>

                            <div class="payment-tab-content">
                                <div class="quickad-template">
                                    <table class="default-table table-alt-row PaymentMethod-infoTable">
                                        <tbody>
                                        <tr>
                                            <td>
                                                <h4 class="PaymentMethod-heading">
                                                    <strong>{LANG_BANK_ACCOUNT_DETAILS}</strong></h4>
                                                <span class="PaymentMethod-info">{BANK_INFO}</span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <h4 class="PaymentMethod-heading"><strong>{LANG_REFERENCE}</strong></h4>
                                                <span class="PaymentMethod-info">
                                                    {LANG_MEMBERSHIPPLAN} : {ORDER_TITLE}<br>
                                                    {LANG_USERNAME}: {USERNAME}<br>
                                                    <em><small>{LANG_OFFLINE_CREDIT_NOTE}</small></em>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <h4 class="PaymentMethod-heading"><strong>{LANG_AMOUNT_TO_SEND}</strong>
                                                </h4>
                                                <span class="PaymentMethod-info">{AMOUNT}</span>
                                            </td>
                                        </tr>
                                        </tbody>
                                    </table>

                                </div>

                            </div>
                        </div>
                    {:IF}
                        IF("{PAYMENT_TYPES.folder}"=="mollie"){
                        <div class="payment-tab">
                            <div class="payment-tab-trigger">
                                <input name="payment_method_id" class="payment_method_id" id="{PAYMENT_TYPES.folder}"
                                       type="radio" value="{PAYMENT_TYPES.id}" data-name="mollie">
                                <label for="{PAYMENT_TYPES.folder}">{PAYMENT_TYPES.title}</label>
                                <img class="payment-logo {PAYMENT_TYPES.folder}"
                                     src="{SITE_URL}includes/payments/{PAYMENT_TYPES.folder}/logo/logo.png"
                                     alt="mollie">
                            </div>
                            <div class="payment-tab-content">
                                <p>{LANG_REDIRECT_MOLLIE}</p>
                            </div>
                        </div>
                    {:IF}
                    {/LOOP: PAYMENT_TYPES}
                    {:IF}
                </div>
                <input type="hidden" name="token" value="{TOKEN}"/>
                <input type="hidden" name="upgrade" value="{UPGRADE}"/>
                <input type="hidden" name="billed-type" value="{BILLED_TYPE}"/>
                <button type="submit" name="Submit"
                        class="button big ripple-effect margin-top-40 margin-bottom-65 subscribeNow"
                        id="subscribeNow">{LANG_SUBMIT}</button>
            </form>
        </div>
        <div class="col-xl-4 col-lg-4 margin-top-0 margin-bottom-60">
            <div class="boxed-widget summary margin-top-0">
                <div class="boxed-widget-headline">
                    <h3>{LANG_PACKAGE_SUMMARY}</h3>
                </div>
                <div class="boxed-widget-inner">
                    <ul>
                        <li>{LANG_MEMBERSHIP} <span>{ORDER_TITLE}</span></li>
                        <li>{LANG_START_DATE} <span>{START_DATE}</span></li>
                        <li>{LANG_EXPIRY_DATE} <span>{EXPIRY_DATE}</span></li>
                        IF({SHOW_TAXES}){
                        <li class="total-costs"></li>
                        <li>{LANG_PLAN_FEE} <span>{PRICE_WITHOUT_INCLUSIVE}</span></li>
                        {LOOP: TAXES}
                            <li>
                                {TAXES.name} <i class="fa fa-question-circle" title="{TAXES.description}" data-tippy-placement="top"></i>
                                <span>+ {TAXES.value_formatted}</span>
                                <small class="d-block">{TAXES.type}</small>
                            </li>
                        {/LOOP: TAXES}
                        {:IF}
                        <li class="total-costs">{LANG_TOTAL_COST} <span>{AMOUNT}</span></li>
                    </ul>
                </div>
            </div>
        </div>

    </div>
</div>

<script type="text/javascript" src="{SITE_URL}templates/{TPL_NAME}/js/jquery.validate.min.js"></script>
<script type="text/javascript" src="{SITE_URL}templates/{TPL_NAME}/js/jquery.payment.min.js"></script>

<!-- payment js -->
<script src="https://js.paystack.co/v1/inline.js"></script>
<script src="https://www.2checkout.com/checkout/api/2co.min.js"></script>
<script src="https://js.stripe.com/v2/"></script>

<script>
    var packagePrice = 1;
    var LANG_CONFIRM_PAY = "{LANG_CONFIRM_PAY}";
    var LANG_PROCCESSING = "{LANG_PROCCESSING}";
    var LANG_VALIDATING = "{LANG_VALIDATING}";
    var LANG_TRY_AGAIN = "{LANG_ERROR_TRY_AGAIN}";
    var LANG_INV_EXP_DATE = "{LANG_INV_EXP_DATE}";
    var LANG_INV_CVV = "{LANG_INV_CVV}";
    var LANG_FIELD_REQ = "{LANG_FIELD_REQ}";
    var LANG_CODE = "{LANG_CODE}";

    $(document).ready(function () {
        /* Show price & Payment Methods */
        var paymentMethod = $('input[name="payment_method_id"]:checked').data("name");

        /* Select a Payment Method */
        $('.payment_method_id').on('change', function () {
            paymentMethod = $(this).data('name');
            var $payment_tab_content = $(this).closest('.payment-tab').find('.payment-tab-content');
            $payment_tab_content.find('[name="payment_mode"]').first().prop('checked',true);
        });

        $('.payment_method_id').first().prop('checked',true).trigger('change');

        /* Fancy restrictive input formatting via jQuery.payment library */
        $('input[name=checkoutCardNumber]').payment('formatCardNumber');
        $('input[name=checkoutCardCVC]').payment('formatCardCVC');
        $('input[name=checkoutCardExpiry]').payment('formatCardExpiry');

        $('input[name=stripeCardNumber]').payment('formatCardNumber');
        $('input[name=stripeCardCVC]').payment('formatCardCVC');
        $('input[name=stripeCardExpiry]').payment('formatCardExpiry');

        /* Pull in the public encryption key for our environment (2Checkout) */
        TCO.loadPubKey('{2CHECKOUT_SANDBOX_MODE}');

        /* Form Default Submission */
        $('#subscribeNow').on('click', function (e) {
            e.preventDefault();

            paymentMethod = $('input[name="payment_method_id"]:checked').data("name");
            var $form = $('#subscribeForm');

            if (packagePrice <= 0) {
                $form.submit();
            }

            switch (paymentMethod) {
                case 'offlinepayment':
                case 'paypal':
                case 'ccavenue':
                case 'paytm':
                case 'payumoney':
                case 'mollie':
                case 'stripe':
                case 'trial':
                    $form.submit();
                    break;
                case 'paystack':
                    payWithPaystack();
                    break;
                case '2checkout':
                    if (ccFormValidationForCheckout()) {
                        payWithCheckout();
                    }
                    break;
                /*case 'stripe':
                    payWithStripe();
                    break;*/
            }

            return false;
        });

        function payWithPaystack() {
            var amount = '{PRICE}';
            amount = 100 * amount;
            var $form = $('#subscribeForm');
            $form.find('#subscribeNow').html(LANG_PROCCESSING + ' <i class="fa fa-spinner fa-pulse"></i>');

            var handler = PaystackPop.setup({
                    key: '{PAYSTACK_PUBLIC_KEY}',
                    email: '{EMAIL}',
                    amount: amount,
                    currency: '{CURRENCY_CODE}',
                    metadata: {
                        custom_fields: [
                            {
                                display_name: "Blank",
                                product_id: "Blank",
                                value: "Blank"
                            }
                        ]
                    }
                    ,
                    callback: function (response) {
                        var paystackReference = response.reference;
                        /* Insert the token into the form so it gets submitted to the server */
                        $form.append($('<input type="hidden" name="paystackReference" />').val(paystackReference));
                        $form.submit();
                    }
                    ,
                    onClose: function () {
                        $form.find('#subscribeNow').html(LANG_CONFIRM_PAY);
                    }
                }
                )
            ;
            handler.openIframe();
        }

        function ccFormValidationForCheckout() {
            var $form = $('#subscribeForm');

            /* Form validation */
            /*jQuery.validator.addMethod('checkoutCardExpiry', function(value, element) {
             *//* Regular expression to match Credit Card expiration date *//*
             var reg = new RegExp('^(0[1-9]|1[0-2])\\s?\/\\s?([0-9]|[0-9])$');
             return this.optional(element) || reg.test(value);
             }, "Invalid expiration date");*/

            jQuery.validator.addMethod(
                "checkoutCardExpiry",
                function (value, element, params) {
                    var minMonth = new Date().getMonth() + 1;
                    var minYear = new Date().getFullYear();

                    var checkoutCardExpiry = $('input[name=checkoutCardExpiry]').val().split('/');
                    var $month = (0 in checkoutCardExpiry) ? checkoutCardExpiry[0].replace(/\s/g, '') : '';
                    var $year = (1 in checkoutCardExpiry) ? checkoutCardExpiry[1].replace(/\s/g, '') : '';

                    var month = parseInt($month, 10);
                    var year = parseInt($year, 10);

                    return ((year > minYear) || ((year === minYear) && (month >= minMonth)));
                }
                ,
                LANG_INV_EXP_DATE);

            jQuery.validator.addMethod('checkoutCardCVC', function (value, element) {
                /* Regular expression matching a 3 or 4 digit CVC (or CVV) of a Credit Card */
                var reg = new RegExp('^[0-9]{3,4}$');
                return this.optional(element) || reg.test(value);
            }, LANG_INV_CVV);

            var validator = $form.validate({
                lang: '{LANG_CODE}',
                rules: {
                    checkoutCardNumber: {
                        required: true
                    },
                    checkoutCardExpiry: {
                        required: true,
                        checkoutCardExpiry: true
                    },
                    checkoutCardCVC: {
                        required: true,
                        checkoutCardCVC: true
                    },
                    checkoutCardHolderFirstName: {
                        required: true
                    },
                    checkoutCardHolderLastName: {
                        required: true
                    },
                    checkoutBillingAddress: {
                        required: true
                    },
                    checkoutBillingCity: {
                        required: true
                    },
                    checkoutBillingState: {
                        required: true
                    },
                    checkoutBillingZipcode: {
                        required: true
                    },
                    checkoutBillingCountry: {
                        required: true
                    }
                },
                highlight: function (element) {
                    $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
                },
                unhighlight: function (element) {
                    $(element).closest('.form-group').removeClass('has-error').addClass('has-success');
                },
                errorPlacement: function (error, element) {
                    $(element).closest('.form-group').append(error);
                }
            });

            /* Abort if invalid form data */
            return validator.form();
        }

        function payWithCheckout() {
            var $form = $('#subscribeForm');

            /* Visual feedback */
            $form.find('#subscribeNow').html(LANG_VALIDATING + ' <i class="fa fa-spinner fa-pulse"></i>').prop('disabled', true);

            /* Setup token request arguments */
            var checkoutCardExpiry = $('input[name=checkoutCardExpiry]').val().split('/');

            var args = {
                sellerId: "{CHECKOUT_ACCOUNT_NUMBER}",
                publishableKey: "{CHECKOUT_PUBLIC_KEY}",
                ccNo: $('input[name=checkoutCardNumber]').val().replace(/\s/g, ''),
                cvv: $('input[name=checkoutCardCVC]').val(),
                expMonth: (0 in checkoutCardExpiry) ? checkoutCardExpiry[0].replace(/\s/g, '') : '',
                expYear: (1 in checkoutCardExpiry) ? checkoutCardExpiry[1].replace(/\s/g, '') : ''
            };

            /* Make the token request */
            TCO.requestToken(function (data) {
                /* Visual feedback */
                $form.find('#subscribeNow').html(LANG_PROCCESSING + ' <i class="fa fa-spinner fa-pulse"></i>');

                /* Hide Stripe errors on the form */
                $form.find('#checkoutPaymentErrors').hide();
                $form.find('#checkoutPaymentErrors').find('.payment-errors').text('');

                /* Set the token as the value for the token input */
                var checkoutToken = data.response.token.token;
                $form.append($('<input type="hidden" name="2checkoutToken" />').val(checkoutToken));

                /* IMPORTANT: Here we call `submit()` on the form element directly instead of using jQuery to prevent and infinite token request loop. */
                $form.submit();

            }, function (data) {
                if (data.errorCode === 200) {
                    tokenRequest();
                } else {
                    /* Visual feedback */
                    $form.find('#subscribeNow').html(LANG_TRY_AGAIN).prop('disabled', false);

                    /* Show errors on the form */
                    $form.find('#checkoutPaymentErrors').find('.payment-errors').text(data.errorMsg);
                    $form.find('#checkoutPaymentErrors').show();
                }
            }, args);
        }


        function payWithStripe() {
            var $form = $('#subscribeForm');

            /* Visual feedback */
            $form.find('#subscribeNow').html(LANG_VALIDATING + ' <i class="fa fa-spinner fa-pulse"></i>').prop('disabled', true);

            var PublishableKey = '{STRIPE_PUBLISHABLE_KEY}';
            Stripe.setPublishableKey(PublishableKey);

            /* Create token */
            var expiry = $form.find('[name=stripeCardExpiry]').payment('cardExpiryVal');
            var ccData = {
                number: $form.find('[name=stripeCardNumber]').val().replace(/\s/g, ''),
                cvc: $form.find('[name=stripeCardCVC]').val(),
                exp_month: expiry.month,
                exp_year: expiry.year
            };

            Stripe.card.createToken(ccData, function stripeResponseHandler(status, response) {
                if (response.error) {
                    /* Visual feedback */
                    $form.find('#subscribeNow').html(LANG_TRY_AGAIN).prop('disabled', false);

                    /* Show errors on the form */
                    $form.find('#stripePaymentErrors').find('.payment-errors').text(response.error.message);
                    $form.find('#stripePaymentErrors').show();
                } else {
                    /* Visual feedback */
                    $form.find('#subscribeNow').html(LANG_PROCCESSING + ' <i class="fa fa-spinner fa-pulse"></i>');

                    /* Hide Stripe errors on the form */
                    $form.find('#stripePaymentErrors').hide();
                    $form.find('#stripePaymentErrors').find('.payment-errors').text('');

                    /* Response contains id and card, which contains additional card details */
                    var stripeToken = response.id;
                    /* Insert the token into the form so it gets submitted to the server */
                    $form.append($('<input type="hidden" name="stripeToken" />').val(stripeToken));
                    $form.append($('<input type="hidden" name="exp_month" />').val(response.card.exp_month));
                    $form.append($('<input type="hidden" name="exp_year" />').val(response.card.exp_year));

                    /* and submit */
                    $form.submit();
                }
            });
        }
    });

</script>
{OVERALL_FOOTER}