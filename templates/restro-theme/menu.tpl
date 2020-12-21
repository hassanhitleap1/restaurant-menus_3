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
                            <li class="active"><a href="{LINK_MENU}"><i class="icon-feather-menu"></i> {LANG_MENU}</a></li>
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
                <h3>{LANG_MANAGE_MENU}</h3>
                <div class="headline-right">
                    <a href="#" class="button ripple-effect button-sliding-icon margin-left-auto add-cat">{LANG_ADD_CATEGORY}<i class="icon-feather-plus"></i></a>
                </div>
            </div>

            <!-- Row -->
            <div class="row">
                {LOOP: CATEGORY}
                <!-- Dashboard Box -->
                <div class="col-xl-12 margin-bottom-15">
                    <div class="dashboard-box margin-top-0">

                        <!-- Headline -->
                        <div class="headline">
                            <h3><i class="icon-feather-folder-plus"></i> <span class="category-display-name">{CATEGORY.name}</span></h3>
                            <div class="margin-left-auto">
                                <a href="#"  data-catid="{CATEGORY.id}" class="button ripple-effect btn-sm add_menu_item" title="{LANG_ADD_MENU}" data-tippy-placement="top"><i class="icon-feather-plus"></i></a>
                                <a href="#" data-catid="{CATEGORY.id}" class="button ripple-effect btn-sm edit-cat" title="{LANG_EDIT_CATEGORY}" data-tippy-placement="top"><i class="icon-feather-edit"></i></a>
                                <a href="#" data-catid="{CATEGORY.id}" class="popup-with-zoom-anim button red ripple-effect btn-sm delete-cat" title="{LANG_DELETE_CATEGORY}" data-tippy-placement="top"><i class="icon-feather-trash-2"></i></a>
                            </div>
                        </div>

                        <div class="content with-padding padding-bottom-10">
                            <div class="row">
                                {CATEGORY.menu}
                            </div>
                        </div>
                    </div>
                </div>
                {/LOOP: CATEGORY}
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


<!-- Add Category Popup / End -->
<div id="add-category" class="zoom-anim-dialog mfp-hide dialog-with-tabs">
    <!--Tabs -->
    <div class="sign-in-form">
        <ul class="popup-tabs-nav">
            <li><a>{LANG_ADD_CATEGORY}</a></li>
        </ul>

        <div class="popup-tabs-container">
            <!-- Tab -->
            <div class="popup-tab-content">
                <div id="category-status" class="notification error" style="display:none"></div>
                <div class="submit-field">
                    <input type="text" class="with-border" placeholder="{LANG_ADD_CATEGORY}" id="category_name">
                    <input type="hidden" name="id" id="cat-edit-id" value="">
                </div>
                <!-- Button -->
                <button class="margin-top-15 button button-sliding-icon ripple-effect" type="submit" id="save-category">{LANG_SAVE} <i class="icon-material-outline-arrow-right-alt"></i></button>
            </div>

        </div>
    </div>
</div>

<!-- Add Category Popup / End -->

<!-- Add Item Popup / End -->

<div id="add_menu_item_dialog" class="zoom-anim-dialog mfp-hide dialog-with-tabs">
    <!--Tabs -->
    <div class="sign-in-form">
        <ul class="popup-tabs-nav">
            <li><a>{LANG_ADD_NEW_ITEM}</a></li>
        </ul>
        <div class="popup-tabs-container">
            <form id="add-item-form" method="post" action="#" enctype="multipart/form-data">
                <!-- Tab -->
                <div class="popup-tab-content">
                    <div id="add-item-status" class="notification error" style="display:none"></div>
                    <div class="submit-field">
                        <input name="title" type="text" class="with-border" id="menu-item-name" placeholder="{LANG_ITEM_TITLE}">
                    </div>

                    <div class="submit-field">
                        <textarea name="description" cols="10" rows="2" class="with-border" id="menu-item-description" placeholder="{LANG_ITEM_DETAIL}"></textarea>
                    </div>
                    <div class="submit-field">
                        <input name="price" type="text" class="with-border" id="menu-item-price" placeholder="{LANG_ITEM_PRICE}">
                    </div>
                    <div class="submit-field">
                        <select name="type" class="selectpicker with-border" id="menu-item-type">
                            <option value="veg">{LANG_VEG}</option>
                            <option value="nonveg">{LANG_NON_VEG}</option>
                        </select>
                    </div>
                    <div class="submit-field">
                        <h5>{LANG_ITEM_IMAGE}</h5>
                        <div class="input-file">
                            <img src="{SITE_URL}storage/menu/default.png" id="menu-item-image" alt="">
                        </div>
                        <div class="uploadButton margin-top-30">
                            <input class="uploadButton-input" type="file" accept="image/*"  onchange="readImageURL(this,'menu-item-image')" id="image_upload" name="main_image"/>
                            <label class="uploadButton-button ripple-effect" for="image_upload">{LANG_UPLOAD_IMAGE}</label>
                        </div>
                    </div>
                    <div class="submit-field">
                        <label class="switch padding-left-40">
                            <input name="active" id="menu-item-available" value="1" type="checkbox" checked>
                            <span class="switch-button"></span> {LANG_AVAILABLE}
                        </label>
                    </div>
                    <input name="cat_id" id="cat_id" value="" type="hidden"/>
                    <input name="id" id="menu-id" value="" type="hidden"/>
                    <!-- Button -->
                    <button id="add-item-button" class="margin-top-15 button button-sliding-icon ripple-effect" type="submit">{LANG_SAVE} <i class="icon-material-outline-arrow-right-alt"></i></button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Add Item Popup / End -->



<script>
    $(document).ready(function () {
        $("#header-container").addClass('dashboard-header not-sticky');
    });

    $(document).on('click', ".add-cat" ,function(e){
        e.preventDefault();

        $('#cat-edit-id').val('');
        $('#category_name').val('');

        $.magnificPopup.open({
            items: {
                src: '#add-category',
                type: 'inline',
                fixedContentPos: false,
                fixedBgPos: true,
                overflowY: 'auto',
                closeBtnInside: true,
                preloader: false,
                midClick: true,
                removalDelay: 300,
                mainClass: 'my-mfp-zoom-in'
            }
        });
    });

    $(document).on('click', ".edit-cat" ,function(e){
        e.preventDefault();

        $('#cat-edit-id').val($(this).data('catid'));
        $('#category_name').val($(this).closest('.dashboard-box').find('.category-display-name').text());

        $.magnificPopup.open({
            items: {
                src: '#add-category',
                type: 'inline',
                fixedContentPos: false,
                fixedBgPos: true,
                overflowY: 'auto',
                closeBtnInside: true,
                preloader: false,
                midClick: true,
                removalDelay: 300,
                mainClass: 'my-mfp-zoom-in'
            }
        });
    });

    $("#save-category").on('click',function (e) {
        e.stopPropagation();
        e.preventDefault();

        var id = $("#cat-edit-id").val();

        var form_data = {
            action: 'addNewCat',
            name: $("#category_name").val()
        };

        if(id){
            form_data['id'] = id;
            form_data['action'] = 'editCat';
        }

        $('#save-category').addClass('button-progress').prop('disabled', true);
        $.ajax({
            type: "POST",
            url: ajaxurl,
            data: form_data,
            dataType: 'json',
            success: function (response) {
                if(response.success){
                    $("#category-status").addClass('success').removeClass('error').html('<p>'+response.message+'</p>').slideDown();
                    location.reload();
                }
                else {
                    $("#category-status").removeClass('success').addClass('error').html('<p>'+response.message+'</p>').slideDown();
                }
                $('#save-category').removeClass('button-progress').prop('disabled', false);
            }
        });
        return false;
    });

    $(document).on('click', ".edit_menu_item" ,function(e){
        e.preventDefault();
        var id = $(this).data('id'),
            $this = $(this);

        $('#cat_id').val($(this).data('catid'));

        $this.addClass('button-progress').prop('disabled', true);
        $.ajax({
            type: "POST",
            url: ajaxurl+'?action=get_item&id='+id,
            dataType: 'json',
            success: function (response) {
                if(response.success) {
                    $('#menu-id').val(id);
                    $('#menu-item-name').val(response.name);
                    $('#menu-item-description').val(response.description);
                    $('#menu-item-price').val(response.price);
                    $('#menu-item-type').val(response.type).trigger('change');
                    $('#menu-item-image').attr('src', response.image);
                    $('#menu-item-available').prop('checked',response.active == 1);

                    $.magnificPopup.open({
                        items: {
                            src: '#add_menu_item_dialog',
                            type: 'inline',
                            fixedContentPos: false,
                            fixedBgPos: true,
                            overflowY: 'auto',
                            closeBtnInside: true,
                            preloader: false,
                            midClick: true,
                            removalDelay: 300,
                            mainClass: 'my-mfp-zoom-in'
                        }
                    });
                }
                $this.removeClass('button-progress').prop('disabled', false);
            }
        });
    });

    $(document).on('click', ".add_menu_item" ,function(e){
        e.stopPropagation();
        e.preventDefault();

        $('#cat_id').val($(this).data('catid'));
        $('#menu-id').val('');
        $('#menu-item-name').val('');
        $('#menu-item-description').val('');
        $('#menu-item-price').val('');
        $('#menu-item-type').val('veg').trigger('change');
        $('#menu-item-image').attr('src', SITE_URL+'storage/restaurant/logo/default.png');
        $('#menu-item-available').prop('checked',true);

        $.magnificPopup.open({
            items: {
                src: '#add_menu_item_dialog',
                type: 'inline',
                fixedContentPos: false,
                fixedBgPos: true,
                overflowY: 'auto',
                closeBtnInside: true,
                preloader: false,
                midClick: true,
                removalDelay: 300,
                mainClass: 'my-mfp-zoom-in'
            }
        });
    });

    $(document).on('click', ".delete_menu_item" ,function(e){
        e.preventDefault();
        var id = $(this).data('id'),
            $this = $(this);

        if(confirm(LANG_ARE_YOU_SURE)) {
            $this.addClass('button-progress').prop('disabled', true);
            $.ajax({
                type: "POST",
                url: ajaxurl + '?action=delete_item&id=' + id,
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        $this.closest('.col-lg-4').remove();
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

    $(document).on('click', ".delete-cat" ,function(e){
        e.preventDefault();
        var id = $(this).data('catid'),
            $this = $(this);

        if(confirm(LANG_ARE_YOU_SURE)) {
            $this.addClass('button-progress').prop('disabled', true);
            $.ajax({
                type: "POST",
                url: ajaxurl,
                data: {
                    action: 'deleteCat',
                    id: id
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        $this.closest('.col-xl-12').remove();
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

    $("#add-item-form").on('submit',function (e) {
        e.preventDefault();
        var data = new FormData(this);
        var action = 'add_item';

        $('#add-item-button').addClass('button-progress').prop('disabled', true);
        $.ajax({
            type: "POST",
            url: ajaxurl+'?action='+action,
            data: data,
            cache:false,
            contentType: false,
            processData: false,
            dataType: 'json',
            success: function (response) {
                if(response.success){
                    $("#add-item-status").addClass('success').removeClass('error').html('<p>'+response.message+'</p>').slideDown();
                    location.reload();
                }
                else {
                    $("#add-item-status").removeClass('success').addClass('error').html('<p>'+response.message+'</p>').slideDown();
                }
                $('#add-item-button').removeClass('button-progress').prop('disabled', false);
            }
        });
        return false;
    });
</script>


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
