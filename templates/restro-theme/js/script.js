(function ($) {
    var $qr_wrapper = $('#qr-code-wrapper'),
        $qr_downloader = $('#qr-code-downloader'),
        $fb_color_input = $('.qr-fg-color-wrapper .color-input'),
        $bg_color_input = $('.qr-bg-color-wrapper .color-input'),
        $padding_input = $('#qr-padding'),
        $radius_input = $('#qr-radius'),
        $qr_mode = $('#qr-mode'),
        $qr_label = $('#qr-text'),
        $qr_label_color_input = $('.qr-text-color-wrapper .color-input'),
        $qr_image = $('#qr-image'),
        $qr_mode_size = $('#qr-mode-size'),
        $qr_position_x = $('#qr-position-x'),
        $qr_position_y = $('#qr-position-y'),
        $qr_mode_customization = $('#qr-mode-customization'),
        $qr_mode_label = $('#qr-mode-label'),
        $qr_mode_image = $('#qr-mode-image');

    // downlaod qr
    $qr_downloader.on('click', function () {
        downloadQR();
    });

    // on color change
    $('input, select').on('input change', function () {
        createQRCode();
    });

    // on mode change
    $qr_mode.on('change', function () {
        var val = $(this).val();
        if(val == 0){
            $qr_mode_customization.slideUp();
        }else if(val == 1 || val == 2){
            $qr_mode_customization.slideDown();
            $qr_mode_label.slideDown();
            $qr_mode_image.slideUp();
        } else if(val == 3 || val == 4){
            $qr_mode_customization.slideDown();
            $qr_mode_label.slideUp();
            $qr_mode_image.slideDown();
        }
    }).trigger('change');

    $qr_image.on('change', function () {
        var e, t = $qr_image[0];
        t.files && t.files[0] && ((e = new window.FileReader).onload = function (e) {
            $("#img-buffer").attr("src", e.target.result);
            setTimeout(createQRCode, 250)
        }, e.readAsDataURL(t.files[0]))
    });


    initColorPicker('.qr-fg-color-wrapper');
    initColorPicker('.qr-bg-color-wrapper');
    initColorPicker('.qr-text-color-wrapper');

    function createQRCode() {
        $qr_wrapper.empty().qrcode({
            text: $qr_wrapper.data('url'),
            fill: $fb_color_input.val(),
            background: $bg_color_input.val(),
            quiet: parseInt($padding_input.val(), 10),
            radius: .01 * parseInt($radius_input.val(), 10),
            mode: parseInt($qr_mode.val(), 10),
            label: $qr_label.val(),
            fontcolor: $qr_label_color_input.val(),
            image: $("#img-buffer")[0],
            mSize: .01 * parseInt($qr_mode_size.val(), 10),
            mPosX: .01 * parseInt($qr_position_x.val(), 10),
            mPosY: .01 * parseInt($qr_position_y.val(), 10),
            render: 'image',
            fontname: 'Nunito',
            size: 1000,
            ecLevel: 'H',
            minVersion: 3,
        });
    }

    // generate qr
    createQRCode();

    function downloadQR() {
        var imgsrc = $qr_wrapper.find('img').attr('src');
        var image = new Image();
        image.src = imgsrc;
        image.onload = function () {
            var canvas = document.createElement('canvas');
            canvas.width = image.width;
            canvas.height = image.height;
            var canvasCtx = canvas.getContext('2d');
            canvasCtx.drawImage(image, 0, 0);
            var imgData = canvas.toDataURL('image/png');

            var a = document.createElement("a");
            a.download = "qr-code.png";
            a.href = imgData;
            a.click();
        };
    }

    function initColorPicker(container) {
        var $element = container + ' .bm-color-picker';
        var $input = jQuery($element).siblings('.color-input');
        var picker = Pickr.create({
            container: container,
            el: $element,
            theme: 'monolith',
            comparison: false,
            closeOnScroll: true,
            position: 'bottom-start',
            default: $input.val() || '#333333',
            components: {
                preview: false,
                opacity: false,
                hue: true,
                interaction: {
                    input: true
                }
            }
        });
        picker.on('change', function (color, instance) {
            $input.val(color.toHEXA().toString()).trigger('change');
        });
    }
    $(window).on('load', function f() {
        $('.sticky-sidebar').theiaStickySidebar({
            'additionalMarginTop': -12,
            'additionalMarginBottom': 10,
            'containerScroll': '.simplebar-scroll-content'
        });
    });


})(jQuery);