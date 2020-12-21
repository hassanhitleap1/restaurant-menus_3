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
                            <li class="active"><a href="{LINK_QRBUILDER}"><i class="icon-material-outline-dashboard"></i> {LANG_QRBUILDER}</a></li>
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
                <h3>{LANG_QRBUILDER}</h3>
                <!-- Breadcrumbs -->
                <nav id="breadcrumbs" class="dark">
                    <ul>
                        <li><a href="{LINK_INDEX}">{LANG_HOME}</a></li>
                        <li>{LANG_QRBUILDER}</li>
                    </ul>
                </nav>
            </div>
            <!-- Row -->
            <div class="row">
                <div class="col-md-4">
                    <div class="dashboard-box">
                        <div class="headline">
                            <h3><i class="icon-feather-settings"></i> {LANG_QRCODE_GENERATOR}</h3>
                        </div>
                        <div class="content with-padding">
                            <form method="post" action="#" enctype="multipart/form-data">
                            <div class="d-flex align-items-center submit-field">
                                <div class="flex-grow-1">
                                    <h5 class="margin-bottom-0">{LANG_FORGROUND_COLOR}</h5></div>
                                <div>
                                    <div class="qr-fg-color-wrapper">
                                        <button class="bm-color-picker"></button>
                                        <input type="hidden" class="color-input" name="qr_fg_color" value="{QR_FG_COLOR}">
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center submit-field">
                                <div class="flex-grow-1">
                                    <h5 class="margin-bottom-0">{LANG_BACKGROUND_COLOR}</h5></div>
                                <div>
                                    <div class="qr-bg-color-wrapper">
                                        <button class="bm-color-picker"></button>
                                        <input type="hidden" class="color-input" name="qr_bg_color" value="{QR_BG_COLOR}">
                                    </div>
                                </div>
                            </div>
                            <div class="submit-field">
                                <h5>{LANG_PADDING}</h5>
                                <input class="range-slider-single" id="qr-padding" name="qr_padding" type="text" data-slider-min="0" data-slider-max="5" data-slider-step="1" data-slider-value="{QR_PADDING}" value="{QR_PADDING}">
                            </div>
                            <div class="submit-field">
                                <h5>{LANG_CORNER_RADIUS}</h5>
                                <input class="range-slider-single" id="qr-radius" name="qr_radius" type="text" data-slider-min="0" data-slider-max="50" data-slider-step="10" data-slider-value="{QR_RADIUS}" value="{QR_RADIUS}">
                            </div>
                            <div class="submit-field">
                                <h5>{LANG_MODE}</h5>
                                <select id="qr-mode" name="qr_mode" class="with-border selectpicker">
                                    <option value="0" IF("{QR_MODE}" == "0"){ selected {:IF}>{LANG_NORMAL}</option>
                                    <option value="2" IF("{QR_MODE}" == "2"){ selected {:IF}>{LANG_TEXT}</option>
                                    <option value="4" IF("{QR_MODE}" == "4"){ selected {:IF}>{LANG_IMAGE}</option>
                                </select>
                            </div>
                            <div id="qr-mode-customization">
                                <div id="qr-mode-label">
                                    <div class="submit-field">
                                        <h5>{LANG_TEXT}</h5>
                                        <input id="qr-text" class="with-border" name="qr_text" type="text" value="{QR_TEXT}">
                                    </div>
                                    <div class="d-flex align-items-center submit-field">
                                        <div class="flex-grow-1">
                                            <h5 class="margin-bottom-0">{LANG_TEXT_COLOR}</h5></div>
                                        <div>
                                            <div class="qr-text-color-wrapper">
                                                <button class="bm-color-picker"></button>
                                                <input type="hidden" class="color-input" name="qr_text_color"
                                                       value="{QR_TEXT_COLOR}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div id="qr-mode-image">
                                    <div class="submit-field">
                                        <h5>{LANG_IMAGE}</h5>
                                        <div class="uploadButton">
                                            <input class="uploadButton-input" type="file" accept="image/*" id="qr-image"
                                                   name="qr_image"/>
                                            <img id="img-buffer" src="{QR_IMAGE}" class="d-none">
                                            <label class="uploadButton-button ripple-effect" for="qr-image">{LANG_UPLOAD_IMAGE}</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="submit-field">
                                    <h5>{LANG_SIZE}</h5>
                                    <input class="range-slider-single" name="qr_mode_size" id="qr-mode-size" type="text" data-slider-min="1"
                                           data-slider-max="15" data-slider-step="1" data-slider-value="{QR_MODE_SIZE}" value="{QR_MODE_SIZE}">
                                </div>
                                <div class="submit-field">
                                    <h5>{LANG_POSITION_X}</h5>
                                    <input class="range-slider-single" name="qr_position_x" id="qr-position-x" type="text"
                                           data-slider-min="0" data-slider-max="100" data-slider-step="1"
                                           data-slider-value="{QR_POSITION_X}" value="{QR_POSITION_X}">
                                </div>
                                <div class="submit-field">
                                    <h5>{LANG_POSITION_Y}</h5>
                                    <input class="range-slider-single" name="qr_position_y" id="qr-position-y" type="text"
                                           data-slider-min="0" data-slider-max="100" data-slider-step="1"
                                           data-slider-value="{QR_POSITION_Y}" value="{QR_POSITION_Y}">
                                </div>
                            </div>
                            <button name="submit" type="submit" class="button">{LANG_SAVE_SETTINGS}</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 sticky-sidebar">
                    <div class="dashboard-box">
                        <div class="headline">
                            <h3><i class="icon-feather-grid"></i> {LANG_QRCODE}</h3>
                        </div>
                        <div class="content with-padding">
                            <div id="qr-code-wrapper" class="margin-bottom-20" data-url="{SCAN_URL}"></div>
                            <button class="button ripple-effect" id="qr-code-downloader"><i class="icon-feather-download"></i> {LANG_DOWNLOAD_IMAGE}</button>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="dashboard-box">
                        <div class="headline">
                            <h3><i class="icon-feather-image"></i> {LANG_QR_TEMPLATES}</h3>
                        </div>
                        <div class="content with-padding">
                            <div class="single-carousel margin-bottom-20">
                                <div><img src="{SITE_URL}storage/qr-templates/template-1.png" alt=""></div>
                                <div><img src="{SITE_URL}storage/qr-templates/template-2.png" alt=""></div>
                                <div><img src="{SITE_URL}storage/qr-templates/template-3.png" alt=""></div>
                            </div>
                            <a href="{SITE_URL}storage/qr-templates/qr-templates.zip" class="button ripple-effect" download=""><i class="icon-feather-download"></i> {LANG_DOWNLOAD_TEMPLATES}</a>
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
<script src="{SITE_URL}templates/{TPL_NAME}/js/color-picker.es5.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/sticky-sidebar.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery-qrcode.min.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/script.js?ver={VERSION}"></script>
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
