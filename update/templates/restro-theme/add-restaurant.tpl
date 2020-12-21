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
                            <li class="active"><a href="{LINK_ADD_RESTAURANT}"><i class="icon-material-outline-restaurant"></i> {LANG_RESTAURANT}</a></li>
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
                <h3>{LANG_MANAGE_RESTAURANT}</h3>
            </div>

            <!-- Row -->
            <div class="row">
                <form name="restaurent_form" method="post" action="#" enctype="multipart/form-data">
                    <!-- Dashboard Box -->
                    <div class="col-xl-12">
                        <div class="dashboard-box margin-top-0">
                            <!-- Headline -->
                            <div class="headline">
                                <h3><i class="icon-feather-folder-plus"></i>{LANG_RESTAURANT_INFO}</h3>
                                <a href="{RESTRO_LINK}" class="button dark ripple-effect button-sliding-icon margin-left-auto live-preview-button">{LANG_LIVE_PREVIEW}<i class="icon-feather-arrow-right"></i></a>
                            </div>
                            {LOOP: ERRORS}
                                <div class="notification error"><p>! {ERRORS.message}</p></div>
                            {/LOOP: ERRORS}
                            <div class="content with-padding padding-bottom-10">
                                <div class="row">

                                    <div class="col-xl-12">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_NAME}</h5>
                                            <input type="text" class="with-border" name="name" value="{NAME}">
                                        </div>
                                    </div>
                                    <div class="col-xl-6">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_SUBTITLE}</h5>
                                            <input type="text" class="with-border" name="sub_title" value="{SUB_TITLE}">
                                        </div>
                                    </div>
                                    <div class="col-xl-6">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_TIMING}</h5>
                                            <input type="text" class="with-border" name="timing" value="{TIMING}">
                                        </div>
                                    </div>
                                    <div class="col-xl-12">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_DESC}</h5>
                                            <textarea class="with-border text-editor" name="description">{DESCRIPTION}</textarea>
                                        </div>
                                    </div>
                                    <div class="col-xl-12">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_LOCATION}</h5>
                                            <div class="input-with-icon">
                                                <div id="autocomplete-container" data-autocomplete-tip="{LANG_TYPE_ENTER}">
                                                    <input class="with-border" type="text" placeholder="{LANG_ADDRESS}" name="address" id="address-autocomplete" value="{ADDRESS}">
                                                </div>
                                                <div class="geo-location"><i class="fa fa-crosshairs"></i></div>
                                            </div>
                                            <div class="map shadow" id="singleListingMap" data-latitude="{LATITUDE}" data-longitude="{LONGITUDE}"  style="height: 200px"></div>
                                            IF("{MAP_TYPE}"=="google"){ <small>{LANG_DRAG_MAP_MARKER}</small>{:IF}
                                        </div>
                                    </div>
                                    <input type="hidden" id="latitude" name="latitude"  value="{LATITUDE}"/>
                                    <input type="hidden" id="longitude" name="longitude" value="{LONGITUDE}"/>
                                    <div class="col-xl-6">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_IMAGE}<i class="help-icon" data-tippy-placement="right" title="{LANG_RESTAURANT_IMAGE}"></i></h5>
                                            <div class="input-file">
                                                <img src="{SITE_URL}storage/restaurant/logo/{MAIN_IMAGE}" id="restro_image">
                                            </div>

                                            <div class="uploadButton margin-top-30">
                                                <input class="uploadButton-input" type="file" accept="image/*"  onchange="readImageURL(this,'restro_image')" id="image_upload" name="main_image"/>
                                                <label class="uploadButton-button ripple-effect" for="image_upload">{LANG_UPLOAD_RESTAURANT_IMAGE}</label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-xl-6">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_COVER_IMAGE}<i class="help-icon" data-tippy-placement="right" title="{LANG_RESTAURANT_COVER_IMAGE}"></i></h5>
                                            <div class="input-file">
                                                <img src="{SITE_URL}storage/restaurant/cover/{COVER_IMAGE}" id="restro_cover_image">
                                            </div>
                                            <div class="uploadButton margin-top-30">
                                                <input class="uploadButton-input" type="file" accept="image/*" onchange="readImageURL(this,'restro_cover_image')" id="cover_upload" name="cover_image"/>
                                                <label class="uploadButton-button ripple-effect" for="cover_upload">{LANG_UPLOAD_COVER_IMAGE}</label>
                                            </div>
                                        </div>
                                    </div>
                                    IF("{ALLOW_ORDERING}" == "1"){
                                    <div class="col-xl-6">
                                        <div class="submit-field">
                                            <h5>{LANG_ALLOW_CUSTOMER_SEND_ORDER}</h5>
                                            <select class="selectpicker with-border" name="restaurant_send_order">
                                                <option value="1" IF("{RESTAURANT_SEND_ORDER}" == "1"){ selected {:IF}>{LANG_YES}</option>
                                                <option value="0" IF("{RESTAURANT_SEND_ORDER}" == "0"){ selected {:IF}>{LANG_NO}</option>
                                            </select>
                                        </div>
                                    </div>
                                    {:IF}
                                    <div class="col-xl-12">
                                        <div class="submit-field">
                                            <h5>{LANG_RESTAURANT_TEMPLATE}</h5>
                                            <div class="account-type row template-chooser">
                                                {LOOP: RESTAURANT_TEMPLATES}
                                                <div class="col-md-3 margin-right-0">
                                                    <input type="radio" name="restaurant_template" value="{RESTAURANT_TEMPLATES.folder}" id="{RESTAURANT_TEMPLATES.folder}" class="account-type-radio" IF("{RESTAURANT_TEMPLATE}" == "{RESTAURANT_TEMPLATES.folder}"){ checked {:IF}>
                                                    <label for="{RESTAURANT_TEMPLATES.folder}" class="ripple-effect-dark">
                                                        <img src="{SITE_URL}/restaurant-templates/{RESTAURANT_TEMPLATES.folder}/screenshot.png">
                                                        <strong>{RESTAURANT_TEMPLATES.name}</strong>
                                                    </label>
                                                </div>
                                                {/LOOP: RESTAURANT_TEMPLATES}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-12">
                        <button type="submit" name="submit" class="button ripple-effect margin-top-30">{LANG_SAVE}</button>
                    </div>
                </form>
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

    $('.live-preview-button').on('click',function (e) {
        e.preventDefault();
        window.open($(this).attr('href'), "live-preview-button", 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no,display=popup, width=380, height=' + screen.height + ', top=0, left=0');
    });
</script>

IF("{MAP_TYPE}"=="google"){
<link href="{SITE_URL}includes/assets/plugins/map/google/map-marker.css" type="text/css" rel="stylesheet">
<script type='text/javascript' src='{SITE_URL}includes/assets/plugins/map/google/jquery-migrate-1.2.1.min.js'></script>
<script type='text/javascript' src='//maps.google.com/maps/api/js?key={GMAP_API_KEY}&#038;libraries=places%2Cgeometry&#038;ver=2.2.1'></script>
<script type='text/javascript' src='{SITE_URL}includes/assets/plugins/map/google/richmarker-compiled.js'></script>
<script type='text/javascript' src='{SITE_URL}includes/assets/plugins/map/google/markerclusterer_packed.js'></script>
<script type='text/javascript' src='{SITE_URL}includes/assets/plugins/map/google/gmapAdBox.js'></script>
<script type='text/javascript' src='{SITE_URL}includes/assets/plugins/map/google/maps.js'></script>
<script>
    var _latitude = '{LATITUDE}';
    var _longitude = '{LONGITUDE}';
    var element = "singleListingMap";
    var path = '{SITE_URL}';
    var getCity = false;
    var getCountry = 'all';
    var color = '{MAP_COLOR}';
    var site_url = '{SITE_URL}';
    simpleMap(_latitude, _longitude, element);
</script>
{ELSE}
<script>
    var openstreet_access_token = '{OPENSTREET_ACCESS_TOKEN}';
</script>
<link rel="stylesheet" href="{SITE_URL}includes/assets/plugins/map/openstreet/css/style.css">
<!-- Leaflet // Docs: https://leafletjs.com/ -->
<script src="{SITE_URL}includes/assets/plugins/map/openstreet/leaflet.min.js"></script>

<!-- Leaflet Maps Scripts (locations are stored in leaflet-quick.js) -->
<script src="{SITE_URL}includes/assets/plugins/map/openstreet/leaflet-markercluster.min.js"></script>
<script src="{SITE_URL}includes/assets/plugins/map/openstreet/leaflet-gesture-handling.min.js"></script>
<script src="{SITE_URL}includes/assets/plugins/map/openstreet/leaflet-quick.js"></script>

<!-- Leaflet Geocoder + Search Autocomplete // Docs: https://github.com/perliedman/leaflet-control-geocoder -->
<script src="{SITE_URL}includes/assets/plugins/map/openstreet/leaflet-autocomplete.js"></script>
<script src="{SITE_URL}includes/assets/plugins/map/openstreet/leaflet-control-geocoder.js"></script>
{:IF}

IF("{RESTAURANT_TEXT_EDITOR}"=="1"){
<link media="all" rel="stylesheet" type="text/css"
      href="{SITE_URL}includes/assets/plugins/simditor/styles/simditor.css"/>
<script src="{SITE_URL}includes/assets/plugins/simditor/scripts/mobilecheck.js"></script>
<script src="{SITE_URL}includes/assets/plugins/simditor/scripts/module.js"></script>
<script src="{SITE_URL}includes/assets/plugins/simditor/scripts/uploader.js"></script>
<script src="{SITE_URL}includes/assets/plugins/simditor/scripts/hotkeys.js"></script>
<script src="{SITE_URL}includes/assets/plugins/simditor/scripts/simditor.js"></script>
<script>
    (function () {
        $(function () {
            var $preview, editor, mobileToolbar, toolbar, allowedTags;
            Simditor.locale = 'en-US';
            toolbar = ['title', 'bold','italic','underline','|','ol','ul','blockquote','table','link','|','image','hr','indent','outdent','alignment'];
            mobileToolbar = ["bold", "italic", "underline", "ul", "ol"];
            if (mobilecheck()) {
                toolbar = mobileToolbar;
            }
            allowedTags = ['br', 'span', 'a', 'img', 'b', 'strong', 'i', 'strike', 'u', 'font', 'p', 'ul', 'ol', 'li', 'blockquote', 'pre',  'h2', 'h3', 'h4', 'hr', 'table'];
            editor = new Simditor({
                textarea: $('.text-editor'),
                placeholder: '',
                toolbar: toolbar,
                pasteImage: false,
                toolbarFloat: false,
                defaultImage: '{SITE_URL}includes/assets/plugins/simditor/images/image.png',
                upload: false,
                allowedTags: allowedTags
            });
            $preview = $('#preview');
            if ($preview.length > 0) {
                return editor.on('valuechanged', function (e) {
                    return $preview.html(editor.getValue());
                });
            }
        });
    }).call(this);
</script>
{:IF}

</body>
</html>