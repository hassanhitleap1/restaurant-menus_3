<div id="footer">
    <div class="footer-middle-section">
        <div class="container">
            <div class="row">
                <div class="col-xl-5 col-lg-5 col-md-12">
                    <div class="footer-logo">
                        <img src="{SITE_URL}storage/logo/{SITE_LOGO_FOOTER}" alt="">
                    </div>
                    <p>{FOOTER_TEXT}</p>
                </div>
                <div class="col-xl-1 col-lg-1">
                </div>
                <div class="col-xl-2 col-lg-2 col-md-4">
                    <div class="footer-links">
                        <h3>{LANG_MY_ACCOUNT}</h3>
                        <ul>
                            IF({LOGGED_IN}){
                            <li><a href="{LINK_DASHBOARD}">{LANG_DASHBOARD}</a></li>
                            <li><a href="{LINK_ADD_RESTAURANT}">{LANG_RESTAURANT}</a></li>
                            <li><a href="{LINK_MENU}">{LANG_MENU}</a></li>
                            <li><a href="{LINK_ACCOUNT_SETTING}">{LANG_ACCOUNT_SETTING}</a></li>
                            {ELSE}
                            <li><a href="{LINK_LOGIN}">{LANG_LOGIN}</a></li>
                            <li><a href="{LINK_SIGNUP}">{LANG_REGISTER}</a></li>
                            {:IF}
                        </ul>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-2 col-md-4">
                    <div class="footer-links">
                        <h3>{LANG_HELPFUL_LINKS}</h3>
                        <ul>
                            <li><a href="{LINK_FAQ}">{LANG_FAQ}</a></li>
                            <li><a href="{LINK_FEEDBACK}">{LANG_FEEDBACK}</a></li>
                            <li><a href="{LINK_REPORT}">{LANG_REPORT}</a></li>
                            <li><a href="{LINK_CONTACT}">{LANG_CONTACT}</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-xl-2 col-lg-2 col-md-4">
                    <div class="footer-links">
                        <h3>{LANG_INFORMATION}</h3>
                        <ul>
                            IF({BLOG_ENABLE}){
                            <li><a href="{LINK_BLOG}">{LANG_BLOG}</a></li>
                            {:IF}
                            IF({TESTIMONIALS_ENABLE}){
                            <li><a href="{LINK_TESTIMONIALS}">{LANG_TESTIMONIALS}</a></li>
                            {:IF}
                            {LOOP: HTMLPAGE}
                                <li><a href="{HTMLPAGE.link}">{HTMLPAGE.title}</a></li>
                            {/LOOP: HTMLPAGE}
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="footer-bottom-section">
        <div class="container">
            <div class="row">
                <div class="col-xl-12">
                    <div class="footer-rows-left">
                        <div class="footer-row">
                            <span class="footer-copyright-text">{COPYRIGHT_TEXT}</span>
                        </div>
                    </div>
                    <div class="footer-rows-right">
                        <div class="footer-row">
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
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</div>

</div>


IF({COOKIE_CONSENT}){
<!-- Cookie constent -->
<div class="cookieConsentContainer">
    <div class="cookieTitle">
        <h3>{LANG_COOKIES}</h3>
    </div>
    <div class="cookieDesc">
        <p>{LANG_COOKIES_MESSAGE}
            IF('{COOKIE_LINK}' != ''){
            <a href="{COOKIE_LINK}">{LANG_COOKIE_POLICY}</a>
            {:IF}
        </p>
    </div>
    <div class="cookieButton">
        <a href="javascript:void(0)" class="button cookieAcceptButton">{LANG_COOKIES_ACCEPT}</a>
    </div>
</div>
{:IF}

IF(!{LOGGED_IN}){
<!-- Sign In Popup -->
<div id="sign-in-dialog" class="zoom-anim-dialog mfp-hide dialog-with-tabs popup-dialog">
    <ul class="popup-tabs-nav">
        <li><a href="#login">{LANG_LOGIN}</a></li>
    </ul>
    <div class="popup-tabs-container">
        <div class="popup-tab-content" id="login">
            <div class="welcome-text">
                <h3>{LANG_WELCOME_BACK}</h3>
                <span>{LANG_DONT_HAVE_ACCOUNT} <a href="{LINK_SIGNUP}">{LANG_SIGNUP_NOW}</a></span>
            </div>
            IF('{FACEBOOK_APP_ID}'!='' || '{GOOGLE_APP_ID}'!=''){
            <div class="social-login-buttons">
                IF('{FACEBOOK_APP_ID}'!=''){
                <button class="facebook-login ripple-effect" onclick="fblogin()"><i
                            class="fa fa-facebook"></i> {LANG_LOGIN_VIA_FACEBOOK}</button>
                {:IF}

                IF('{GOOGLE_APP_ID}'!=''){
                <button class="google-login ripple-effect" onclick="gmlogin()"><i
                            class="fa fa-google"></i> {LANG_LOGIN_VIA_GOOGLE}</button>
                {:IF}
            </div>
            <div class="social-login-separator"><span>{LANG_OR}</span></div>
            {:IF}
            <form id="login-form" method="post" action="{SITE_URL}login?ref={REF_URL}">
                <div id="login-status" class="notification error" style="display:none"></div>
                <div class="input-with-icon-left">
                    <i class="la la-user"></i>
                    <input type="text" class="input-text with-border" name="username" id="username"
                           placeholder="{LANG_USERNAME} / {LANG_EMAIL}" required/>
                </div>

                <div class="input-with-icon-left">
                    <i class="la la-unlock"></i>
                    <input type="password" class="input-text with-border" name="password" id="password"
                           placeholder="{LANG_PASSWORD}" required/>
                </div>
                <a href="{LINK_LOGIN}?fstart=1" class="forgot-password">{LANG_FORGOT_PASSWORD}</a>
                <button id="login-button" class="button full-width button-sliding-icon ripple-effect" type="submit"
                        name="submit">{LANG_LOGIN} <i class="icon-feather-arrow-right"></i></button>
            </form>
        </div>

    </div>
</div>
{:IF}

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
    var LANG_SHOW = "{LANG_SHOW}";
    var LANG_HIDE = "{LANG_HIDE}";
    var LANG_HIDDEN = "{LANG_HIDDEN}";

    var LANG_TYPE_A_MESSAGE = "{LANG_TYPE_A_MESSAGE}";
    var LANG_ADD_FILES_TEXT = "{LANG_ADD_FILES_TEXT}";
    var LANG_JUST_NOW = "{LANG_JUST_NOW}";
    var LANG_PREVIEW = "{LANG_PREVIEW}";
    var LANG_SEND = "{LANG_SEND}";
    var LANG_FILENAME = "{LANG_FILENAME}";
    var LANG_STATUS = "{LANG_STATUS}";
    var LANG_SIZE = "{LANG_SIZE}";
    var LANG_DRAG_FILES_HERE = "{LANG_DRAG_FILES_HERE}";
    var LANG_STOP_UPLOAD = "{LANG_STOP_UPLOAD}";
    var LANG_ADD_FILES = "{LANG_ADD_FILES}";
</script>
<!-- Scripts
================================================== -->
<script type="text/javascript" src="{SITE_URL}templates/{TPL_NAME}/js/chosen.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery.lazyload.min.js"></script>
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
                $.cookie('Quick_lang', lang, {path: '/'});
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
