{OVERALL_HEADER}
<!-- Dashboard Container -->
<div class="dashboard-container">

    <!-- Dashboard Sidebar
    ================================================== -->
    <div class="dashboard-sidebar">
        <div class="dashboard-sidebar-inner" data-simplebar>
            <div class="dashboard-nav-container">

                <!-- Responsive Navigation Trigger -->
                <a href="#" class="dashboard-responsive-nav-trigger">
					<span class="hamburger hamburger--collapse" >
						<span class="hamburger-box">
							<span class="hamburger-inner"></span>
						</span>
					</span>
                    <span class="trigger-title">{LANG_DASH_NAVIGATION}</span>
                </a>

                <!-- Navigation -->
                <div class="dashboard-nav">
                    <div class="dashboard-nav-inner">

                        <ul data-submenu-title="{LANG_MANAGEMENT}">
                            <li><a href="{LINK_DASHBOARD}"><i class="icon-feather-grid"></i> {LANG_DASHBOARD}</a></li>
                            <li><a href="{LINK_ADD_RESTAURANT}"><i class="icon-material-outline-restaurant"></i> {LANG_RESTAURANT}</a></li>
                            <li><a href="{LINK_MENU}"><i class="icon-feather-menu"></i> {LANG_MENU}</a></li>
                            <li><a href="{LINK_ORDER}"><i class="icon-feather-activity"></i> {LANG_ORDERS}</a></li>
                            IF("{PURCHASE_TYPE}"=="pro"){
                            <li><a href="{LINK_MEMBERSHIP}"><i class="icon-feather-gift"></i> {LANG_MEMBERSHIP}</a></li>
                            {:IF}
                            <li><a href="{LINK_QRBUILDER}"><i class="icon-material-outline-dashboard"></i> {LANG_QRBUILDER}</a></li>
                        </ul>

                        <ul data-submenu-title="{LANG_ACCOUNT}">
                            IF("{PURCHASE_TYPE}"=="pro"){
                            <li><a href="{LINK_TRANSACTION}"><i class="icon-material-outline-description"></i> {LANG_TRANSACTIONS}</a></li>
                            {:IF}
                            <li class="active"><a href="{LINK_ACCOUNT_SETTING}"><i class="icon-material-outline-settings"></i> {LANG_ACCOUNT_SETTING}</a></li>
                            <li><a href="{LINK_LOGOUT}"><i class="icon-material-outline-power-settings-new"></i> {LANG_LOGOUT}</a></li>
                        </ul>

                    </div>
                </div>
                <!-- Navigation / End -->

            </div>
        </div>
    </div>
    <!-- Dashboard Sidebar / End -->


    <!-- Dashboard Content
    ================================================== -->
    <div class="dashboard-content-container" data-simplebar>
        <div class="dashboard-content-inner" >

            <!-- Dashboard Headline -->
            <div class="dashboard-headline">
                <h3>{LANG_ACCOUNT_SETTING}</h3>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs" class="dark">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li>{LANG_ACCOUNT_SETTING}</li>
                    </ul>
                </nav>
            </div>

            <!-- Row -->
            <div class="row">
                <!-- Dashboard Box -->
                <div class="col-xl-12">
                    <div class="dashboard-box">
                        <div class="headline">
                            <h3><i class="icon-material-baseline-notifications-none"></i> {LANG_ACCOUNT_SETTING}</h3>
                        </div>
                        <div class="content">
                            <div class="content with-padding">
                                <form method="post" accept-charset="UTF-8">
                                    <div class="row">
                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_USERNAME} *</h5>
                                                <div class="input-with-icon-left">
                                                    <i class="la la-user"></i>
                                                    <input type="text" class="with-border" id="username" name="username" value="{USERNAME}" onBlur="checkAvailabilityUsername()">
                                                </div>
                                                <span id="user-availability-status">IF("{USERNAME_ERROR}"!=""){ {USERNAME_ERROR} {:IF}</span>
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_EMAIL} *</h5>
                                                <div class="input-with-icon-left">
                                                    <i class="la la-envelope"></i>
                                                    <input type="text" class="with-border" id="email" name="email" value="{EMAIL_FIELD}" onBlur="checkAvailabilityEmail()">
                                                </div>
                                                <span id="email-availability-status">IF("{EMAIL_ERROR}"!=""){ {EMAIL_ERROR} {:IF}</span>
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_NEW_PASSWORD}</h5>
                                                <input type="password" id="password" name="password" class="with-border" onkeyup="checkAvailabilityPassword()">
                                            </div>
                                        </div>

                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_CONPASS}</h5>
                                                <input type="password" id="re_password" name="re_password" class="with-border" onkeyup="checkRePassword()">
                                            </div>
                                        </div>
                                    </div>
                                    <span id="password-availability-status">IF("{PASSWORD_ERROR}"!=""){ {PASSWORD_ERROR} {:IF}</span>
                                    <div class="row">
                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_PHONE}</h5>
                                                <input type="text" id="phone" name="phone" class="with-border" value="{PHONE}">
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_CURRENCY}</h5>
                                                <select name="currency" id="currency"  class="with-border selectpicker" data-live-search="true">
                                                    {LOOP: CURRENCY}
                                                    <option value="{CURRENCY.code}" {CURRENCY.selected}>{CURRENCY.code} ({CURRENCY.html_entity})</option>
                                                    {/LOOP: CURRENCY}
                                                </select>
                                                <small>{LANG_USER_CURRENCY_HINT}</small>
                                            </div>
                                        </div>
                                        <div class="col-xl-6 col-md-12">
                                            <div class="submit-field">
                                                <h5>{LANG_MENU_LAYOUT}</h5>
                                                <select name="menu_layout" id="menu_layout"  class="with-border selectpicker">
                                                    <option value="both" IF("{MENU_LAYOUT}"=="both"){ selected {:IF}>{LANG_BOTH_LAYOUTS}</option>
                                                    <option value="grid" IF("{MENU_LAYOUT}"=="grid"){ selected {:IF}>{LANG_GRID_LAYOUT}</option>
                                                    <option value="list" IF("{MENU_LAYOUT}"=="list"){ selected {:IF}>{LANG_LIST_LAYOUT}</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <button type="submit" name="submit" class="button ripple-effect">{LANG_SAVE_CHANGES}</button>
                                </form>

                            </div>
                        </div>
                    </div>
                    IF("{PURCHASE_TYPE}"=="pro"){
                    <div class="dashboard-box">
                        <div class="headline">
                            <h3><i class="icon-material-outline-description"></i> {LANG_BILLING_DETAILS}</h3>
                        </div>
                        <div class="content">
                            <div class="content with-padding">
                                <div class="notification notice">{LANG_BILLING_DETAILS_NOTES}</div>
                                IF("{BILLING_ERROR}"=="1"){
                                <div class="notification error">{LANG_ALL_FIELDS_REQ}</div>
                                {:IF}
                                <form method="post" accept-charset="UTF-8">
                                    <div class="submit-field">
                                        <h5>{LANG_TYPE}</h5>
                                        <select name="billing_details_type" id="billing_details_type"  class="with-border selectpicker" required>
                                            <option value="personal" IF("{BILLING_DETAILS_TYPE}"=="personal"){ selected {:IF}>{LANG_PERSONAL}</option>
                                            <option value="business" IF("{BILLING_DETAILS_TYPE}"=="business"){ selected {:IF}>{LANG_BUSINESS}</option>
                                        </select>
                                    </div>
                                    <div class="submit-field billing-tax-id">
                                        <h5>IF("{INVOICE_ADMIN_TAX_TYPE}"!=""){ {INVOICE_ADMIN_TAX_TYPE} {ELSE} {LANG_TAX_ID}{:IF}</h5>
                                        <input type="text" id="billing_tax_id" name="billing_tax_id" class="with-border" value="{BILLING_TAX_ID}">
                                    </div>
                                    <div class="submit-field">
                                        <h5>{LANG_NAME} *</h5>
                                        <input type="text" id="billing_name" name="billing_name" class="with-border" value="{BILLING_NAME}" required>
                                    </div>
                                    <div class="submit-field">
                                        <h5>{LANG_ADDRESS} *</h5>
                                        <input type="text" id="billing_address" name="billing_address" class="with-border" value="{BILLING_ADDRESS}" required>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="submit-field">
                                                <h5>{LANG_CITY} *</h5>
                                                <input type="text" id="billing_city" name="billing_city" class="with-border" value="{BILLING_CITY}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="submit-field">
                                                <h5>{LANG_STATE} *</h5>
                                                <input type="text" id="billing_state" name="billing_state" class="with-border" value="{BILLING_STATE}" required>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="submit-field">
                                                <h5>{LANG_ZIPCODE} *</h5>
                                                <input type="text" id="billing_zipcode" name="billing_zipcode" class="with-border" value="{BILLING_ZIPCODE}" required>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="submit-field">
                                        <h5>{LANG_COUNTRY} *</h5>
                                        <select name="billing_country" id="billing_country" class="with-border selectpicker" data-live-search="true" required>
                                            {LOOP: COUNTRIES}
                                                <option value="{COUNTRIES.code}" {COUNTRIES.selected}>{COUNTRIES.asciiname}</option>
                                            {/LOOP: COUNTRIES}
                                        </select>
                                    </div>
                                    <button type="submit" name="billing-submit" class="button ripple-effect">{LANG_SAVE_CHANGES}</button>
                                </form>

                            </div>
                        </div>
                    </div>
                    {:IF}
                </div>
            </div>
            <!-- Row / End -->

            <!-- Footer -->
            <div class="dashboard-footer-spacer"></div>
            <div class="small-footer margin-top-15">
                <div class="small-footer-copyrights">
                    {COPYRIGHT_TEXT}
                </div>
                <ul class="footer-social-links">
                    IF('{FACEBOOK_LINK}'!=""){
                    <li>
                        <a href="{FACEBOOK_LINK}" target="_blank" rel="nofollow">
                            <i class="fa fa-facebook"></i>
                        </a>
                    </li>
                    {:IF}
                    IF('{TWITTER_LINK}'!=""){
                    <li>
                        <a href="{TWITTER_LINK}" target="_blank" rel="nofollow">
                            <i class="fa fa-twitter"></i>
                        </a>
                    </li>
                    {:IF}
                    IF('{INSTAGRAM_LINK}'!=""){
                    <li>
                        <a href="{INSTAGRAM_LINK}" target="_blank" rel="nofollow">
                            <i class="fa fa-instagram"></i>
                        </a>
                    </li>
                    {:IF}
                    IF('{LINKEDIN_LINK}'!=""){
                    <li>
                        <a href="{LINKEDIN_LINK}" target="_blank" rel="nofollow">
                            <i class="fa fa-linkedin"></i>
                        </a>
                    </li>
                    {:IF}
                    IF('{PINTEREST_LINK}'!=""){
                    <li>
                        <a href="{PINTEREST_LINK}" target="_blank" rel="nofollow">
                            <i class="fa fa-pinterest-p"></i>
                        </a>
                    </li>
                    {:IF}
                    IF('{YOUTUBE_LINK}'!=""){
                    <li>
                        <a href="{YOUTUBE_LINK}" target="_blank" rel="nofollow">
                            <i class="fa fa-youtube-play"></i>
                        </a>
                    </li>
                    {:IF}
                </ul>
                <div class="clearfix"></div>
            </div>
            <!-- Footer / End -->

        </div>
    </div>
    <!-- Dashboard Content / End -->

</div>
<!-- Dashboard Container / End -->
</div>
<!-- Wrapper / End -->
<script>
    $(document).ready(function () {
        $("#header-container").addClass('dashboard-header not-sticky');
    });
</script>

<script>
    var error = "";
    function checkAvailabilityUsername() {
        jQuery.ajax({
            url: "{APP_URL}check_availability.php",
            data: 'username=' + $("#username").val(),
            type: "POST",
            success: function (data) {
                if (data != "success") {
                    error = 1;
                    $("#user-availability-status").html(data);
                }
                else {
                    error = 0;
                    $("#user-availability-status").html("");
                }
            },
            error: function () {
            }
        });
    }
    function checkAvailabilityEmail() {
        jQuery.ajax({
            url: "{APP_URL}check_availability.php",
            data: 'email=' + $("#email").val(),
            type: "POST",
            success: function (data) {
                if (data != "success") {
                    error = 1;
                    $("#email-availability-status").html(data);
                }
                else {
                    error = 0;
                    $("#email-availability-status").html("");
                }
                $("#loaderIcon").hide();
            },
            error: function () {
            }
        });
    }
    function checkAvailabilityPassword() {
        var length = $('#password').val().length;
        if (length != 0) {
            var PASSLENG = "{LANG_PASSLENG}";
            if (length < 5 || length > 21) {
                $("#password-availability-status").html("<span class='status-not-available'>" + PASSLENG + "</span>");
            }
            else {
                $("#password-availability-status").html("");
            }
        }

    }
    function checkRePassword(){
        if($('#password').val() != $('#re_password').val()){
            var PASS = "{LANG_PASSNOMATCH}";
            $("#password-availability-status").html("<span class='status-not-available'>" + PASS + "</span>");
        }else{
            $("#password-availability-status").html("");
        }
    }
    jQuery(window).on('load',function () {
        jQuery('#password').val("");
    });
</script>
<!-- Footer Code -->

<script>
    var session_uname = "{USERNAME}";
    var session_uid = "{USER_ID}";
    // Language Var
    var LANG_ERROR_TRY_AGAIN = "{LANG_ERROR_TRY_AGAIN}";
    var LANG_LOGGED_IN_SUCCESS = "{LANG_LOGGED_IN_SUCCESS}";
    var LANG_ERROR = "{LANG_ERROR}";
    var LANG_CANCEL = "{LANG_CANCEL}";
    var LANG_DELETED = "{LANG_DELETED}";
    var LANG_ARE_YOU_SURE = "{LANG_ARE_YOU_SURE}";
    var LANG_YES_DELETE = "{LANG_YES_DELETE}";
    var LANG_SHOW = "{LANG_SHOW}";
    var LANG_HIDE = "{LANG_HIDE}";
    var LANG_HIDDEN = "{LANG_HIDDEN}";
    var LANG_TYPE_A_MESSAGE = "{LANG_TYPE_A_MESSAGE}";
    var LANG_JUST_NOW = "{LANG_JUST_NOW}";
    var LANG_PREVIEW = "{LANG_PREVIEW}";
    var LANG_SEND = "{LANG_SEND}";
    var LANG_STATUS = "{LANG_STATUS}";
    var LANG_SIZE = "{LANG_SIZE}";
    var LANG_NO_MSG_FOUND = "{LANG_NO_MSG_FOUND}";
    var LANG_ONLINE = "{LANG_ONLINE}";
    var LANG_OFFLINE = "{LANG_OFFLINE}";
    var LANG_GOT_MESSAGE = "{LANG_GOT_MESSAGE}";
</script>

<script type="text/javascript" src="{SITE_URL}templates/{TPL_NAME}/js/chosen.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery.lazyload.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/tippy.all.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/simplebar.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/bootstrap-slider.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/bootstrap-select.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/snackbar.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/counterup.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/magnific-popup.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/slick.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery.cookie.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/user-ajax.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/custom.js?ver={VERSION}"></script>

<script>
    /* THIS PORTION OF CODE IS ONLY EXECUTED WHEN THE USER THE LANGUAGE(CLIENT-SIDE) */
    $(function () {
        $('.language-switcher').on('click', '.dropdown-menu li', function (e) {
            e.preventDefault();
            var lang = $(this).data('lang');
            if (lang != null) {
                var res = lang.substr(0, 2);
                $('#selected_lang').html(res);
                $.cookie('Quick_lang', lang,{ path: '/' });
                location.reload();
            }
        });
    });
    $(document).ready(function () {
        var lang = $.cookie('Quick_lang');
        if (lang != null) {
            var res = lang.substr(0, 2);
            $('#selected_lang').html(res);
        }
    });
</script>
</body>
</html>