{OVERALL_HEADER}

<!-- Dashboard Container -->
<div class="dashboard-container">

    <div class="dashboard-sidebar">
        <div class="dashboard-sidebar-inner" data-simplebar>
            <div class="dashboard-nav-container">
                <!-- Responsive Navigation Trigger -->
                <a href="#" class="dashboard-responsive-nav-trigger">
					<span class="hamburger hamburger--collapse">
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
                            <li class="active"><a href="{LINK_MENU}"><i class="icon-feather-menu"></i> {LANG_MENU}</a></li>
                            <li><a href="{LINK_ORDER}"><i class="icon-feather-activity"></i> {LANG_ORDERS}</a></li>
                            IF("{PURCHASE_TYPE}"=="pro"){
                            <li><a href="{LINK_MEMBERSHIP}"><i class="icon-feather-gift"></i> {LANG_MEMBERSHIP}</a></li>
                            {:IF}
                            <li><a href="{LINK_QRBUILDER}"><i class="icon-material-outline-dashboard"></i> {LANG_QRBUILDER}</a></li>
                        </ul>
                        <ul data-submenu-title="{LANG_ACCOUNT}">
                            IF("{PURCHASE_TYPE}"=="pro"){
                            <li><a href="{LINK_TRANSACTION}"><i
                                            class="icon-material-outline-description"></i> {LANG_TRANSACTIONS}</a></li>
                            {:IF}
                            <li><a href="{LINK_ACCOUNT_SETTING}"><i
                                            class="icon-material-outline-settings"></i> {LANG_ACCOUNT_SETTING}</a></li>
                            <li><a href="{LINK_LOGOUT}"><i
                                            class="icon-material-outline-power-settings-new"></i> {LANG_LOGOUT}</a></li>
                        </ul>
                    </div>
                </div>
                <!-- Navigation / End -->

            </div>
        </div>
    </div>
    <!-- Dashboard Sidebar / End -->
    <!-- Dashboard Content-->
    <div class="dashboard-content-container" data-simplebar>
        <div class="dashboard-content-inner">
            <!-- Dashboard Headline -->
            <div class="dashboard-headline">
                <h3>{MENU_NAME} - {LANG_EXTRAS}</h3>
                <div class="headline-right">
                    <a href="#add-extras"
                       class="popup-with-zoom-anim button ripple-effect button-sliding-icon margin-left-auto add-menu-extras">{LANG_ADD_EXTRAS}
                        <i class="icon-feather-plus"></i></a>
                </div>
            </div>

            <!-- Row -->
            <div class="row">
                <div class="col-xl-12 js-accordion">
                    {LOOP: EXTRAS}
                        <div class="dashboard-box js-accordion-item margin-top-0 margin-bottom-30 extra-{EXTRAS.id}">
                            <!-- Headline -->
                            <div class="headline js-accordion-header">
                                <h3><i class="icon-feather-plus"></i> <span class="extra-display-name">{EXTRAS.title}</span></h3>
                                <div class="margin-left-auto">
                                    <a href="#" data-id="{EXTRAS.id}"
                                       class="button red ripple-effect btn-sm delete-menu-extras" title="{LANG_DELETE}"
                                       data-tippy-placement="top"><i class="icon-feather-trash-2"></i></a>
                                </div>
                            </div>
                            <div class="content with-padding padding-bottom-10 js-accordion-body">
                                <form class="menu-extras-form" method="post" action="#" data-id="{EXTRAS.id}">
                                    <div class="notification error" style="display:none"></div>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="submit-field">
                                                <h5>{LANG_TITLE}</h5>
                                                <input type="text" class="with-border extra-title" name="title"
                                                       value="{EXTRAS.title}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="submit-field">
                                                <h5>{LANG_PRICE}</h5>
                                                <input type="text" class="with-border" name="price"
                                                       value="{EXTRAS.price}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="submit-field">
                                                <label class="switch padding-left-40">
                                                    <input name="active" value="1" type="checkbox" IF("{EXTRAS.active}"=="1"){ checked {:IF}>
                                                    <span class="switch-button"></span> {LANG_AVAILABLE}
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="submit-field">
                                        <button type="submit" name="submit"
                                                class="button ripple-effect">{LANG_SAVE}</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    {/LOOP: EXTRAS}

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

<div id="add-extras" class="zoom-anim-dialog mfp-hide dialog-with-tabs" data-menu-id="{MENU_ID}">
    <div class="sign-in-form">
        <ul class="popup-tabs-nav">
            <li><a>{LANG_ADD_EXTRAS}</a></li>
        </ul>
        <div class="popup-tabs-container">
            <!-- Tab -->
            <div class="popup-tab-content">
                <div id="extras-status" class="notification error" style="display:none"></div>
                <div class="submit-field">
                    <input type="text" class="with-border" id="add_extra_title" name="extra_title"
                           placeholder="{LANG_TITLE}">
                </div>
                <div class="submit-field">
                    <input type="text" class="with-border" id="add_extra_price" name="extra_price"
                           placeholder="{LANG_PRICE}">
                </div>
                <!-- Button -->
                <button class="margin-top-15 button button-sliding-icon ripple-effect" type="submit" id="save-menu-extras">{LANG_SAVE} <i class="icon-material-outline-arrow-right-alt"></i></button>
            </div>

        </div>
    </div>
</div>

<script>
    var session_uname = "{USERNAME}";
    var session_uid = "{USER_ID}";
    var SITE_URL = "{SITE_URL}";
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

<script src="{SITE_URL}templates/{TPL_NAME}/js/chosen.min.js?ver={VERSION}"></script>
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

        $("#header-container").addClass('dashboard-header not-sticky');
    });

    $(function () {
        $("#save-menu-extras").on('click',function (e) {
            e.stopPropagation();
            e.preventDefault();

            var form_data = {
                action: 'addMenuExtra',
                title: $("#add_extra_title").val(),
                price: $("#add_extra_price").val(),
                menu_id: $("#add-extras").data('menu-id')
            };

            $('#save-menu-extras').addClass('button-progress').prop('disabled', true);
            $.ajax({
                type: "POST",
                url: ajaxurl,
                data: form_data,
                dataType: 'json',
                success: function (response) {
                    if(response.success){
                        $("#extras-status").addClass('success').removeClass('error').html('<p>'+response.message+'</p>').slideDown();
                        location.reload();
                    }
                    else {
                        $("#extras-status").removeClass('success').addClass('error').html('<p>'+response.message+'</p>').slideDown();
                    }
                    $('#save-menu-extras').removeClass('button-progress').prop('disabled', false);
                }
            });
            return false;
        });

        $(".delete-menu-extras").on('click',function (e) {
            e.preventDefault();
            e.stopPropagation();

            var id = $(this).data('id'),
                $this = $(this);

            if(confirm(LANG_ARE_YOU_SURE)) {
                $this.addClass('button-progress').prop('disabled', true);
                $.ajax({
                    type: "POST",
                    url: ajaxurl,
                    data: {
                        action: 'deleteMenuExtra',
                        id: id
                    },
                    dataType: 'json',
                    success: function (response) {
                        if (response.success) {
                            $this.closest('.extra-'+id).remove();
                        }
                        Snackbar.show({
                            text: response.message,
                            pos: 'bottom-center',
                            showAction: false,
                            actionText: "Dismiss",
                            duration: 3000,
                            textColor: '#fff',
                            backgroundColor: '#383838'
                        });
                    }
                });
            }
        });

        $(".menu-extras-form").on('submit',function (e) {
            e.stopPropagation();
            e.preventDefault();

            var $form = $(this),
                form_data = $form.serializeArray(),
                id = $form.data('id'),
                $btn = $form.find('button'),
                $status = $form.find('.notification');
            form_data.push({
                name: 'id',
                value: id
            });
            form_data.push({
                name: 'action',
                value: 'editMenuExtra'
            });


            $btn.addClass('button-progress').prop('disabled', true);
            $.ajax({
                type: "POST",
                url: ajaxurl,
                data: form_data,
                dataType: 'json',
                success: function (response) {
                    if(response.success){
                        $status.slideUp();
                        $('.extra-'+id).find('.extra-display-name').html($form.find('.extra-title').val());
                        Snackbar.show({
                            text: response.message,
                            pos: 'bottom-center',
                            showAction: false,
                            actionText: "Dismiss",
                            duration: 3000,
                            textColor: '#fff',
                            backgroundColor: '#383838'
                        });
                    }
                    else {
                        $status.removeClass('success').addClass('error').html('<p>'+response.message+'</p>').slideDown();
                    }
                    $btn.removeClass('button-progress').prop('disabled', false);
                }
            });
            return false;
        });
    });
</script>
</body>
</html>