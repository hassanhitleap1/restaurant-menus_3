<!DOCTYPE html>
<html lang="{LANG_CODE}" dir="{LANGUAGE_DIRECTION}">
<head>
    <title>IF("{PAGE_TITLE}"!=""){ {PAGE_TITLE} - {:IF}{SITE_TITLE}</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="author" content="{SITE_TITLE}">
    <meta name="keywords" content="{PAGE_META_KEYWORDS}">
    <meta name="description" content="{PAGE_META_DESCRIPTION}">

    <link rel="dns-prefetch" href="//fonts.googleapis.com">
    <link rel="dns-prefetch" href="//google.com">
    <link rel="dns-prefetch" href="//apis.google.com">
    <link rel="dns-prefetch" href="//ajax.googleapis.com">
    <link rel="dns-prefetch" href="//www.google-analytics.com">
    <link rel="dns-prefetch" href="//pagead2.googlesyndication.com">
    <link rel="dns-prefetch" href="//gstatic.com">
    <link rel="dns-prefetch" href="//oss.maxcdn.com">

    <link rel="shortcut icon" href="{SITE_URL}storage/logo/{SITE_FAVICON}">
    <script async>
        var themecolor = '{THEME_COLOR}';
        var mapcolor = '{MAP_COLOR}';
        var siteurl = '{SITE_URL}';
        var template_name = '{TPL_NAME}';
        var ajaxurl = "{SITE_URL}php/{QUICKAD_USER_SECRET_FILE}.php";
    </script>
    <style>
        :root{{LOOP: COLORS}--theme-color-{COLORS.id}: {COLORS.value};{/LOOP: COLORS}}
    </style>

    <link rel="stylesheet" href="{SITE_URL}includes/assets/css/icons.css">
    <link rel="stylesheet" href="{SITE_URL}templates/{TPL_NAME}/css/color-picker.min.css?ver={VERSION}">
    <link rel="stylesheet" href="{SITE_URL}templates/{TPL_NAME}/css/style.css?ver={VERSION}">
    <link rel="stylesheet" href="{SITE_URL}templates/{TPL_NAME}/css/color.css?ver={VERSION}">
    <script src="{SITE_URL}templates/{TPL_NAME}/js/jquery-3.4.1.min.js"></script>

    IF("{LANGUAGE_DIRECTION}"=="rtl"){
    <link rel="stylesheet" href="{SITE_URL}templates/{TPL_NAME}/css/rtl.css?ver={VERSION}">
    {:IF}

</head>
<body class="{LANGUAGE_DIRECTION}">
<!--[if lt IE 8]>
<p class="browserupgrade">
    You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade
    your browser</a> to improve your experience.
</p>
<![endif]-->
<div class="single-page-header restaurant-header detail-header" data-background-image="{SITE_URL}storage/restaurant/cover/{COVER_IMAGE}">
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <div class="single-page-header-inner">
                    <div class="left-side">
                        <div class="header-image"><img class="lazy-load" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC"  data-original="{SITE_URL}storage/restaurant/logo/{MAIN_IMAGE}" alt=""></div>
                        <div class="header-details">
                            <h3>{NAME}<span>{SUB_TITLE}</span></h3>
                            <ul>
                                IF('{TIMING}'!=""){ <li><i class="icon-feather-watch"></i> {TIMING}</li>{:IF}
                                <li><i class="icon-feather-map margin-right-5"></i><a target="_blank" href="https://www.google.com/maps/search/?api=1&amp;query={ADDRESS}">{ADDRESS}</a></li>
                                IF('{PHONE}'!=''){ <li><i class="icon-feather-phone margin-right-5"></i><a href="tel:{PHONE}">{PHONE}</a></li>{:IF}
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <div class="row">

        <!-- Content -->
        <div class="col-xl-12 content-right-offset">

            <!-- Page Content -->
            <div class="single-page-section">
                <h3 class="margin-bottom-25">{LANG_ABOUT_ME}</h3>
                <p>{DESCRIPTION}</p>
            </div>

            <div class="gallery-section">
                <div class="row-filter margin-bottom-20">
                    <!-- filter -->
                    <div class="filter-gallery">
                        <button data-filter="gallery-show-all" class="filter-button active">{LANG_ALL_CATEGORIES}</button>
                        {LOOP: CATEGORY}
                        <button data-filter="{CATEGORY.name}" class="filter-button" data-catid="{CATEGORY.id}">{CATEGORY.name}</button>
                        {/LOOP: CATEGORY}
                    </div>
                </div>
                {LOOP: CAT_MENU}
                    <!-- Boxed List -->
                    <div class="boxed-list" data-category-image="{CAT_MENU.name}">
                        <div class="boxed-list-headline">
                            <h3><i class="icon-material-outline-restaurant"></i> {CAT_MENU.name}
                                IF("{MENU_LAYOUT}"=="both"){
                                <div class="float-right">
                                    <a href="#" class="menu-filter" data-filter="grid"><span class="icon-feather-grid"></span></a>
                                    <a href="#" class="menu-filter active" data-filter="list"><span class="icon-feather-list"></span></a>
                                </div>
                                {:IF}
                            </h3>
                        </div>
                        <div class="box-item">
                            <div class="row">
                                {CAT_MENU.menu}
                            </div>
                        </div>
                    </div>
                    <!-- Boxed List / End -->
                {/LOOP: CAT_MENU}
            </div>
        </div>
    </div>
</div>
<!-- Spacer -->
<div class="margin-top-15"></div>
<!-- Spacer / End-->

<div id="view-order-wrapper">
    <button id="view-order-button" class="button ripple-effect">{LANG_VIEW_ORDER}</button>
</div>

<div id="your-order" class="zoom-anim-dialog mfp-hide dialog-with-tabs popup-dialog">
    <!--Tabs -->
    <div class="sign-in-form">
        <ul class="popup-tabs-nav">
            <li><a class="menu_title">{LANG_MY_ORDER}</a></li>
        </ul>
        <div class="popup-tabs-container">
            <!-- Tab -->
            <div class="popup-tab-content">
                <div class="your-order-content">
                    <div class="your-order-items"></div>
                    <div class="menu_detail order-total margin-bottom-20">
                        <h4 class="menu_post">
                            <span class="menu_title">{LANG_TOTAL}</span>
                            <span class="menu_price">{LANG_ADD} IF('{CURRENCY_LEFT}'=="1"){ {CURRENCY_SIGN} {:IF}<span class="your-order-price"></span>IF('{CURRENCY_LEFT}'=="0"){ {CURRENCY_SIGN}{:IF}</span>
                        </h4>
                    </div>
                    <form type="post" data-id="{RESTRO_ID}" id="send-order-form">
                        <input type="text" class="with-border" name="name" placeholder="{LANG_YOUR_NAME}" required>
                        <input type="number" class="with-border" name="table" placeholder="{LANG_TABLE_NUMBER}" required>
                        <textarea  class="with-border" name="message" placeholder="{LANG_MESSAGE}" rows="1"></textarea>
                        <small class="form-error"></small>
                        <button type="submit" class="button ripple-effect margin-top-0"><i class="icon-feather-send"></i> {LANG_SEND_ORDER}</button>
                    </form>
                </div>
                <div class="order-success-message" style="display: none">
                    <i class="icon-feather-check qr-success-icon"></i>
                    <h4>{LANG_SENT_SUCCESSFULLY}</h4>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add Extras Popup / End -->
<div id="add-extras" class="zoom-anim-dialog mfp-hide dialog-with-tabs popup-dialog">
    <!--Tabs -->
    <div class="sign-in-form">
        <ul class="popup-tabs-nav">
            <li><a class="menu_title"></a></li>
        </ul>
        <div class="popup-tabs-container">
            <!-- Tab -->
            <div class="popup-tab-content">
                <div class="menu_detail">
                    <h4 class="menu_post">
                        <span class="menu_title"></span>
                        <span class="menu_dots"></span>
                        <span class="menu_price"></span>
                    </h4>
                    <div class="menu_excerpt menu_desc margin-top-20"></div>
                </div>
                <div class="menu-data menu-extra-wrapper">
                    <div class="section-headline margin-bottom-12">
                        <h5>{LANG_EXTRAS}</h5>
                    </div>
                    <div id="menu-extra-items">
                    </div>
                </div>
                <div class="menu-data">
                    <div class="d-flex">
                        <div class="qr-input-number">
                            <span role="button" class="qr-input-number__decrease is-disabled ripple-effect ripple-effect-dark" id="menu-order-quantity-decrease">-</span>
                            <div class="qr-input">
                                <input type="text" class="qr-input__inner with-border" value="1" id="menu-order-quantity" readonly>
                            </div>
                            <span role="button" class="qr-input-number__increase ripple-effect ripple-effect-dark" id="menu-order-quantity-increase">+</span>
                        </div>
                        <button id="add-order-button" class="button ripple-effect">{LANG_ADD} IF('{CURRENCY_LEFT}'=="1"){ {CURRENCY_SIGN} {:IF}<span id="order-price"></span>IF('{CURRENCY_LEFT}'=="0"){ {CURRENCY_SIGN}{:IF}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Add Extras Popup / End -->
<div id="footer">
    <div class="footer-bottom-section">
        <div class="container">
            <div class="footer-rows-left">
                <div class="footer-row padding-top-0">
                    <span class="footer-copyright-text">{COPYRIGHT_TEXT}</span>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
<script>
    var TOTAL_MENUS = {TOTAL_MENUS};
    var CURRENCY_SIGN = '{CURRENCY_SIGN}';
    var CURRENCY_LEFT = {CURRENCY_LEFT};

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
<script src="{SITE_URL}templates/{TPL_NAME}/js/jquery.cookie.min.js"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/user-ajax.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/custom.js?ver={VERSION}"></script>
<script src="{SITE_URL}templates/{TPL_NAME}/js/restaurant.js?ver={VERSION}"></script>
</body>
</html>