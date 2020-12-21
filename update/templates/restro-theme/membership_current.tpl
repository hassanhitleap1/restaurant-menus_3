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
                            <li class="active"><a href="{LINK_MEMBERSHIP}"><i class="icon-feather-gift"></i> {LANG_MEMBERSHIP}</a></li>
                            <li><a href="{LINK_QRBUILDER}"><i class="icon-material-outline-dashboard"></i> {LANG_QRBUILDER}</a></li>
                        </ul>

                        <ul data-submenu-title="{LANG_ACCOUNT}">
                            <li><a href="{LINK_TRANSACTION}"><i class="icon-material-outline-description"></i> {LANG_TRANSACTIONS}</a></li>
                            <li><a href="{LINK_ACCOUNT_SETTING}"><i class="icon-material-outline-settings"></i> {LANG_ACCOUNT_SETTING}</a></li>
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
                <h3>{LANG_CURRENT_PLAN}</h3>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs" class="dark">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li>{LANG_MEMBERSHIP}</li>
                    </ul>
                </nav>
            </div>
            <!-- Row -->
            <div class="row">
                <!-- Dashboard Box -->
                <div class="col-xl-12">
                    <div class="dashboard-box">
                        <div class="headline">
                            <h3><i class="icon-material-baseline-notifications-none"></i> {LANG_CURRENT_PLAN}</h3>
                        </div>
                        <div class="content">
                            <div class="content with-padding">
                                <div class="table-responsive">
                                    <table id="js-table-list" class="basic-table dashboard-box-list">
                                        <tr>
                                            <th>{LANG_MEMBERSHIP}</th>
                                            <th>{LANG_PAYMENT_MODE}</th>
                                            <th>{LANG_START_DATE}</th>
                                            <th>{LANG_EXPIRY_DATE}</th>
                                            IF("{SHOW_CANCEL_BUTTON}"=="1"){ <th>{LANG_CANCEL}</th>{:IF}
                                        </tr>
                                        <tr>
                                            <td>{UPGRADE_TITLE}</td>
                                            <td>
                                                IF("{PAYMENT_MODE}"=="one_time"){ {LANG_ONE_TIME} {ELSE} {LANG_RECURRING} {:IF}
                                            </td>
                                            <td>{UPGRADE_START_DATE}</td>
                                            <td>{UPGRADE_EXPIRY_DATE}</td>
                                            IF("{SHOW_CANCEL_BUTTON}"=="1"){
                                            <td><a href="{LINK_MEMBERSHIP}/?action=cancel_auto_renew"><i class="fa fa-remove"></i> {LANG_CANCEL}</a></td>
                                            {:IF}
                                        </tr>
                                        <tr>
                                            <td align="right" colspan="7"><button type="button" class="button" onClick="window.location.href='{LINK_MEMBERSHIP}/changeplan'">{LANG_CHANGE_PLAN}</button></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
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


<!-- Footer Code -->

<script>
    var session_uname = "{USERNAME}";
    var session_uid = "{USER_ID}";
    var session_img = "{USERPIC}";
    // Language Var
    var LANG_ERROR_TRY_AGAIN = "{LANG_ERROR_TRY_AGAIN}";
    var LANG_LOGGED_IN_SUCCESS = "{LANG_LOGGED_IN_SUCCESS}";
    var LANG_ERROR = "{LANG_ERROR}";
    var LANG_CANCEL = "{LANG_CANCEL}";
    var LANG_DELETED = "{LANG_DELETED}";
    var LANG_ARE_YOU_SURE = "{LANG_ARE_YOU_SURE}";
    var LANG_YOU_WANT_DELETE = "{LANG_YOU_WANT_DELETE}";
    var LANG_YES_DELETE = "{LANG_YES_DELETE}";
    var LANG_PROJECT_DELETED = "{LANG_PROJECT_DELETED}";
    var LANG_RESUME_DELETED = "{LANG_RESUME_DELETED}";
    var LANG_EXPERIENCE_DELETED = "{LANG_EXPERIENCE_DELETED}";
    var LANG_COMPANY_DELETED = "{LANG_COMPANY_DELETED}";
    var LANG_SHOW = "{LANG_SHOW}";
    var LANG_HIDE = "{LANG_HIDE}";
    var LANG_HIDDEN = "{LANG_HIDDEN}";
    var LANG_TYPE_A_MESSAGE = "{LANG_TYPE_A_MESSAGE}";
    var LANG_ADD_FILES_TEXT = "{LANG_ADD_FILES_TEXT}";
    var LANG_ENABLE_CHAT_YOURSELF = "{LANG_ENABLE_CHAT_YOURSELF}";
    var LANG_JUST_NOW = "{LANG_JUST_NOW}";
    var LANG_PREVIEW = "{LANG_PREVIEW}";
    var LANG_SEND = "{LANG_SEND}";
    var LANG_FILENAME = "{LANG_FILENAME}";
    var LANG_STATUS = "{LANG_STATUS}";
    var LANG_SIZE = "{LANG_SIZE}";
    var LANG_DRAG_FILES_HERE = "{LANG_DRAG_FILES_HERE}";
    var LANG_STOP_UPLOAD = "{LANG_STOP_UPLOAD}";
    var LANG_ADD_FILES = "{LANG_ADD_FILES}";
    var LANG_CHATS = "{LANG_CHATS}";
    var LANG_NO_MSG_FOUND = "{LANG_NO_MSG_FOUND}";
    var LANG_ONLINE = "{LANG_ONLINE}";
    var LANG_OFFLINE = "{LANG_OFFLINE}";
    var LANG_TYPING = "{LANG_TYPING}";
    var LANG_GOT_MESSAGE = "{LANG_GOT_MESSAGE}";
</script>
<!-- Scripts
================================================== -->
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery.lazyload.min.js"></script>
<script type="text/javascript" src="{SITE_URL}templates/{TPL_NAME}/js/chosen.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/tippy.all.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/simplebar.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/bootstrap-slider.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/bootstrap-select.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/snackbar.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/counterup.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/magnific-popup.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/slick.min.js"></script>
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
