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

    <meta property="fb:app_id" content="{FACEBOOK_APP_ID}"/>
    <meta property="og:site_name" content="{SITE_TITLE}"/>
    <meta property="og:locale" content="en_US"/>
    <meta property="og:url" content="{PAGE_LINK}"/>
    <meta property="og:title" content="IF("{PAGE_TITLE}"!=""){ {PAGE_TITLE} - {:IF}{SITE_TITLE}" />
    <meta property="og:description" content="{PAGE_META_DESCRIPTION}"/>
    <meta property="og:type" content="{META_CONTENT}"/>
    IF("{META_CONTENT}"=="article"){
    <meta property="article:author" content="#"/>
    <meta property="article:publisher" content="#"/>
    <meta property="og:image" content="{META_IMAGE}"/>
    {:IF}
    IF("{META_CONTENT}"=="website"){
    <meta property="og:image" content="{META_IMAGE}"/>
    {:IF}
    <meta property="twitter:card" content="summary">
    <meta property="twitter:title" content="{PAGE_TITLE} - {SITE_TITLE}">
    <meta property="twitter:description" content="{PAGE_META_DESCRIPTION}">
    <meta property="twitter:domain" content="{SITE_URL}">
    <meta name="twitter:image:src" content="{META_IMAGE}"/>
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

    <!-- ===External Code=== -->
    {EXTERNAL_CODE}
    <!-- ===/External Code=== -->
</head>
<body class="{LANGUAGE_DIRECTION}">
    <!--[if lt IE 8]>
    <p class="browserupgrade">
        You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade
        your browser</a> to improve your experience.
    </p>
    <![endif]-->
    <!-- Wrapper -->
    <div id="wrapper" class="">
        <header id="header-container" class="fullwidth">
            <!-- Header -->
            <div id="header">
                <div class="container">
                    <!-- Left Side Content -->
                    <div class="left-side">
                        <!-- Logo -->
                        <div id="logo">
                            <a href="{LINK_INDEX}"><img src="{SITE_URL}storage/logo/{SITE_LOGO}" alt="{SITE_TITLE}"></a>
                        </div>
                    </div>
                    <!-- Left Side Content / End -->
                    <!-- Right Side Content / End -->
                    <div class="right-side">
                        <!-- User Menu -->
                        <div class="header-widget">

                            IF('{USERNAME}'==""){
                            <a href="#sign-in-dialog" class="popup-with-zoom-anim button ripple-effect">{LANG_JOIN_NOW}</a>
                            {ELSE}
                            <div class="header-notifications user-menu">
                                <div class="header-notifications-trigger">
                                    <a href="#"><div class="user-avatar"><img src="{SITE_URL}storage/profile/{USERPIC}" alt="{USERNAME}"></div></a>
                                </div>
                                <!-- Dropdown -->
                                <div class="header-notifications-dropdown">
                                    <ul class="user-menu-small-nav">
                                        <li><a href="{LINK_DASHBOARD}"><i class="icon-material-outline-dashboard"></i> {LANG_DASHBOARD}</a></li>
                                        <li><a href="{LINK_ORDER}"><i class="icon-feather-activity"></i> {LANG_ORDERS}</a></li>
                                        <li><a href="{LINK_ADD_RESTAURANT}"><i class="icon-material-outline-restaurant"></i> {LANG_RESTAURANT}</a></li>
                                        <li><a href="{LINK_MENU}"><i class="icon-feather-menu"></i> {LANG_MENU}</a></li>
                                        <li><a href="{LINK_ACCOUNT_SETTING}"><i class="icon-material-outline-settings"></i> {LANG_ACCOUNT_SETTING}</a></li>
                                        IF("{PURCHASE_TYPE}"=="pro"){
                                        <li><a href="{LINK_MEMBERSHIP}"><i class="icon-feather-gift"></i> {LANG_MEMBERSHIP}</a></li>
                                        {:IF}
                                        <li><a href="{LINK_LOGOUT}"><i class="icon-material-outline-power-settings-new"></i> {LANG_LOGOUT}</a></li>
                                    </ul>
                                </div>
                            </div>
                            {:IF}
                        </div>
                        IF({LANG_SEL}){
                        <div class="header-widget">
                            <div class="btn-group bootstrap-select language-switcher">
                                <button type="button" class="btn dropdown-toggle btn-default" data-toggle="dropdown"
                                        title="English">
                                    <span class="filter-option pull-left" id="selected_lang">EN</span>&nbsp;
                                    <span class="caret"></span>
                                </button>
                                <div class="dropdown-menu scrollable-menu open">
                                    <ul class="dropdown-menu inner">
                                        {LOOP: LANGS}
                                            <li data-lang="{LANGS.file_name}">
                                                <a role="menuitem" tabindex="-1" rel="alternate"
                                                   href="{LINK_HOME}/{LANGS.code}">{LANGS.name}</a>
                                            </li>
                                        {/LOOP: LANGS}
                                    </ul>
                                </div>
                            </div>
                        </div>
                        {:IF}
                    </div>
                    <!-- Right Side Content / End -->
                </div>
            </div>
            <!-- Header / End -->
            <!-- Header Container / End -->
            IF("{USERSTATUS}"=="0" && "{NON_ACTIVE_MSG}"=="1"){
            <div class="user-status-message">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8">
                            <i class="icon-lock text-18"></i>
                            <span>{LANG_WELCOME} <strong>{USERNAME}</strong>, {LANG_GOTO_UR_EMAIL} <strong>{USEREMAIL}</strong>  {LANG_VERIFY_EMAIL_ADDRESS}</span>
                        </div>
                        <div class="col-lg-4">
                            <a class="button ripple-effect" rel="nofollow" target="_blank" role="button" href="http://{EMAILDOMAIN}/">{LANG_GOTO_UR_EMAIL}</a>
                            <a class="button ripple-effect gray resend_buttons{USER_ID} resend" href='javascript:void(0);' id="{USER_ID}">{LANG_RESEND_EMAIL}</a>
                            <span class='resend_count' id='resend_count{USER_ID}'></span>
                        </div>
                    </div>
                </div>
            </div>
            {:IF}
        </header>
        <div class="clearfix"></div>
