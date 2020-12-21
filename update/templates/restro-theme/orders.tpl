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
                            <li class="active"><a href="{LINK_ORDER}"><i class="icon-feather-activity"></i> {LANG_ORDERS}</a></li>
                            IF("{PURCHASE_TYPE}"=="pro"){
                            <li><a href="{LINK_MEMBERSHIP}"><i class="icon-feather-gift"></i> {LANG_MEMBERSHIP}</a></li>
                            {:IF}
                            <li><a href="{LINK_QRBUILDER}"><i class="icon-material-outline-dashboard"></i> {LANG_QRBUILDER}</a></li>
                        </ul>

                        <ul data-submenu-title="{LANG_ACCOUNT}">
                            IF("{PURCHASE_TYPE}"=="pro"){
                            <li><a href="{LINK_TRANSACTION}"><i class="icon-material-outline-description"></i> {LANG_TRANSACTIONS}</a></li>
                            {:IF}
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
                <h3>{LANG_ORDERS}</h3>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs" class="dark">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li>{LANG_ORDERS}</li>
                    </ul>
                </nav>
            </div>

            <!-- Dashboard Box -->
            <div class="dashboard-box main-box-in-row">
                <div class="headline">
                    <h3><i class="icon-feather-activity"></i> {LANG_ORDERS}</h3>
                    <a href="javascript:void(0)" class="margin-left-auto order-notification-sound" data-tippy-placement="top" title="{LANG_NOTIFICATION_SOUND}"><i class="icon-feather-volume-2"></i></a>
                </div>
                <div class="content with-padding">
                    <div class="dataTables_wrapper">
                        <table class="basic-table dashboard-box-list" id="qr-orders-table">
                            <thead>
                            <tr>
                                <th class="w-100">{LANG_TABLE_NO}</th>
                                <th>{LANG_MENU}</th>
                                <th>{LANG_CUSTOMER}</th>
                                <th>{LANG_PRICE}</th>
                                <th>{LANG_STATUS}</th>
                                <th>{LANG_TIME}</th>
                                <th></th>
                            </tr>
                            </thead>
                            IF("{ORDERS_FOUND}"=="0"){
                            <tbody>
                            <tr class="no-order-found">
                                <td colspan="8" class="text-center">{LANG_NO_RESULT_FOUND}</td>
                            </tr>
                            </tbody>
                            {ELSE}
                            <tbody>
                            {LOOP: ORDERS}
                                <tr>
                                    <td data-label="{LANG_TABLE_NO}">{ORDERS.table_number}</td>
                                    <td data-label="{LANG_MENU}">
                                        {ORDERS.items_tpl}
                                    </td>
                                    <td data-label="{LANG_CUSTOMER}">
                                        <div class="d-flex align-items-center">
                                        <span>{ORDERS.customer_name}</span>
                                        IF("{ORDERS.message}"!=""){
                                        <span class="button gray ico margin-left-5" data-tippy-placement="top" title="{ORDERS.message}"><i class="icon-feather-message-square"></i></span>
                                        {:IF}
                                        </div>
                                    </td>
                                    <td data-label="{LANG_PRICE}">
                                        <span class="small-label margin-left-0">
                                            {ORDERS.price}
                                        </span>
                                    </td>
                                    <td data-label="{LANG_STATUS}">
                                        IF("{ORDERS.status}"=="pending"){
                                        <span class="button gray ico order-status" data-tippy-placement="top" title="{LANG_PENDING}"><i class="icon-feather-clock"></i></span>
                                        {ELSE}
                                        <span class="button green ico order-status" data-tippy-placement="top" title="{LANG_COMPLETED}"><i class="icon-feather-check"></i></span>
                                        {:IF}
                                    </td>
                                    <td data-label="{LANG_TIME}"><small>{ORDERS.created_at}</small></td>
                                    <td>
                                        IF("{ORDERS.status}"=="pending"){
                                        <button class="button ico qr-complete-order" data-tippy-placement="top" title="{LANG_COMPLETE}" data-id="{ORDERS.id}"><i class="icon-feather-check"></i></button>
                                        {:IF}
                                        <button class="button red ico qr-delete-order" data-tippy-placement="top" title="{LANG_DELETE}" data-id="{ORDERS.id}"><i class="icon-feather-trash-2"></i></button>
                                    </td>
                                </tr>
                            {/LOOP: ORDERS}
                            </tbody>
                            {:IF}
                        </table>
                    </div>
                    IF({SHOW_PAGING}){
                    <div class="pagination-container margin-top-20">
                        <nav class="pagination">
                            <ul>
                                {LOOP: PAGES}
                                    IF("{PAGES.current}"=="0"){
                                    <li><a href="{PAGES.link}">{PAGES.title}</a></li>
                                {ELSE}
                                    <li><a href="#" class="current-page">{PAGES.title}</a></li>
                                {:IF}
                                {/LOOP: PAGES}
                            </ul>
                        </nav>
                    </div>
                    {:IF}
                </div>
            </div>
            <!-- Dashboard Box / End -->

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

    var LANG_COMPLETE = "{LANG_COMPLETE}";
    var LANG_PENDING = "{LANG_PENDING}";
    var LANG_DELETE = "{LANG_DELETE}";
    var LANG_TABLE_NO = "{LANG_TABLE_NO}";
    var LANG_MENU = "{LANG_MENU}";
    var LANG_CUSTOMER = "{LANG_CUSTOMER}";
    var LANG_PRICE = "{LANG_PRICE}";
    var LANG_TIME = "{LANG_TIME}";
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
<script src="{SITE_URL}templates/{TPL_NAME}/js/orders.js?ver={VERSION}"></script>

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
        $("#header-container").addClass('dashboard-header not-sticky');

        var lang = $.cookie('Quick_lang');
        if (lang != null) {
            var res = lang.substr(0, 2);
            $('#selected_lang').html(res);
        }
    });
</script>
</body>
</html>