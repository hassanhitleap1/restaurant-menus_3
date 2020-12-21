(function ($) {
    "use strict";

    // remove old localstorage data
    localStorage.setItem('quickqr_order','{}');

    /* GALLERY - FILTERING FUCTION */
    $(".filter-button").on("click", function () {
        var value = $(this).data('filter');

        if (value == "gallery-show-all") {
            $('.boxed-list').removeClass("gallery-hidden");
        } else {
            $('.boxed-list:not([data-category-image*="' + value + '"]').addClass("gallery-hidden");
            $('.boxed-list[data-category-image*="' + value + '"]').removeClass("gallery-hidden");
        }
    });

    $('.filter-gallery .filter-button').on("click", function () {
        $('.filter-gallery').find('.filter-button.active').removeClass('active');
        $(this).addClass('active');
    });

    $(".menu-filter").on("click", function (e) {
        e.preventDefault();
        $('.menu-filter.active').removeClass('active');
        $(this).addClass('active');
        var $container = $(this).closest('.boxed-list');
        if ($(this).data('filter') == 'grid') {
            $container.find('.menu-grid-view').show();
            $container.find('.menu-list-view').hide();
        } else {
            $container.find('.menu-list-view').show();
            $container.find('.menu-grid-view').hide();
        }

    });

    /*
    * Add Order and Extras
    */
    $(document).on('click', ".add-extras", function (e) {
        e.preventDefault();

        var $item = $(this).closest('.ajax-item-listing'),
            item_id = $item.data('id'),
            name = $item.data('name'),
            description = $item.data('description'),
            price = $item.data('price'),
            amount = $item.data('amount'),
            order_price = Number(amount);

        $('#add-extras .menu_title').html(name);
        $('#add-extras .menu_desc').html(description);
        $('#add-extras .menu_price').html(price);
        $('#order-price').html(formatPrice(amount));
        $('#menu-order-quantity').val(1);

        var $extra_wrapper = $('#menu-extra-items');
        $extra_wrapper.html('');
        var extras = TOTAL_MENUS[item_id].extras || [];

        if (extras.length == 0) {
            $('.menu-extra-wrapper').hide();
        } else {
            $('.menu-extra-wrapper').show();
        }
        for (var i in extras) {
            if (extras.hasOwnProperty(i)) {
                var $extra_tpl = $(
                    '<div class="d-flex menu-extra-item">' +
                    '<div class="checkbox">' +
                    '<input type="checkbox" id="chekcbox1">' +
                    '<label for="chekcbox1">' +
                    '<span class="checkbox-icon"></span> <span class="extra-item-title"></span>' +
                    '</label>' +
                    '</div>' +
                    '<strong class="margin-left-auto extra-item-price"></strong>' +
                    '</div>');

                $extra_tpl.find('.checkbox input').attr('id', 'checkbox' + extras[i].id);
                $extra_tpl.find('label').attr('for', 'checkbox' + extras[i].id);
                $extra_tpl.find('.extra-item-title').html(extras[i].title);
                $extra_tpl.find('.extra-item-price').html(formatPrice(extras[i].price));
                $extra_tpl.data('price', extras[i].price);
                $extra_tpl.data('id', extras[i].id);

                $extra_tpl.find('.checkbox input').on('change',function () {
                    $('#menu-order-quantity').val(1);
                    calculateOrderPrice(order_price);
                });
                $extra_wrapper.append($extra_tpl);
            }
        }

        $('#menu-order-quantity-decrease').off().on('click', function (e) {
            var quatity = Number($('#menu-order-quantity').val()) - 1;
            if(quatity == 0){
                quatity = 1;
            }
            $('#menu-order-quantity').val(quatity);
            calculateOrderPrice(order_price);
        });
        $('#menu-order-quantity-increase').off().on('click', function (e) {
            $('#menu-order-quantity').val(Number($('#menu-order-quantity').val()) + 1);
            calculateOrderPrice(order_price);
        });

        $('#add-order-button').off().on('click', function (e) {
            calculateOrderPrice(order_price);
            var price = $('#order-price').html();
            var order_data = JSON.parse(localStorage.getItem('quickqr_order'));

            // this order's extras
            var extras = {};
            $('.menu-extra-item').each(function () {
                if($(this).find('.checkbox input').is(':checked')){
                    extras[randomId(10)] = {
                        'id': $(this).data('id'),
                        'name': $(this).find('.extra-item-title').html(),
                        'price': $(this).data('price')
                    };
                }
            });

            order_data[randomId(10)] = {
                'id': item_id,
                'order_price': price,
                'item_name': name,
                'item_price': amount,
                'extras': extras,
                'quantity': $('#menu-order-quantity').val()
            };

            localStorage.setItem('quickqr_order', JSON.stringify(order_data));
            $('#view-order-wrapper').show();
            $.magnificPopup.close();
        });

        $.magnificPopup.open({
            items: {
                src: '#add-extras',
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

    /*
    * View Order
    */
    $('#view-order-button').on('click', function (e) {
        var order_data = JSON.parse(localStorage.getItem('quickqr_order'));
        var $order_items_wrapper = $('.your-order-items'),
            $order_total_selector = $('.order-total').find('.your-order-price'),
            order_total = 0;

        $('.your-order-content').show();
        $('.order-success-message').hide();

        function generateViewOrder() {
            var order_total = 0;
            $order_items_wrapper.html('');
            for (var i in order_data) {
                if (order_data.hasOwnProperty(i)) {
                    var order = order_data[i],
                        price = Number(order.item_price),
                        quantity = Number(order.quantity),
                        extras = order.extras,
                        extra_total = 0;

                    var $order_tpl = $('<div class="your-order-item">' +
                        '<div class="menu_detail">' +
                        '<h4 class="menu_post">' +
                        '<a href="javascript:void(0)" class="item-delete"><i class="icon-feather-trash-2 margin-right-5"></i></a>' +
                        '<span class="menu_title"></span>' +
                        '<span class="menu_price"></span>' +
                        '</h4>' +
                        '</div>' +
                        '<div class="menu-data menu-extra-wrapper">' +
                        '</div>' +
                        '</div>');

                    var title = order.item_name + (quantity > 1 ? ' &times; ' + quantity : '');

                    $order_tpl.data('cart_id', i);
                    $order_tpl.find('.menu_title').html(title);
                    $order_tpl.find('.menu_price').html(formatPrice(price * quantity));

                    for (var j in extras) {
                        if (extras.hasOwnProperty(j)) {
                            var extra = extras[j],
                                extra_price = Number(extra.price);

                            var $extra_tpl = $('<div class="d-flex menu-extra-item">' +
                                '<a href="javascript:void(0)" class="item-extra-delete"><i class="icon-feather-trash-2 margin-right-5"></i></a>' +
                                '<span class="extra-item-title"></span>' +
                                '<strong class="margin-left-auto extra-item-price"></strong>' +
                                '</div>');

                            $extra_tpl.data('extra_cart_id',j);
                            $extra_tpl.find('.extra-item-title').html(extra.name);
                            $extra_tpl.find('.extra-item-price').html(formatPrice(extra_price * quantity));

                            var $extra_delete = $extra_tpl.find('.item-extra-delete');
                            $extra_delete.data('price', extra_price * quantity);
                            $extra_delete.data('key', j);

                            $extra_delete.on('click', function () {
                                var cart_key = $(this).closest('.your-order-item').data('cart_id');
                                var extra_cart_key = $(this).closest('.menu-extra-item').data('extra_cart_id');
                                delete order_data[cart_key]['extras'][extra_cart_key];

                                localStorage.setItem('quickqr_order', JSON.stringify(order_data));
                                generateViewOrder();

                            });

                            extra_total += extra_price;
                            $order_tpl.find('.menu-extra-wrapper').append($extra_tpl);
                        }
                    }
                    var this_item_total = (extra_total + price) * quantity;
                    order_total += this_item_total;

                    var $delete = $order_tpl.find('.item-delete');
                    $delete.on('click', function () {
                        var cart_key = $(this).closest('.your-order-item').data('cart_id');
                        delete order_data[cart_key];

                        localStorage.setItem('quickqr_order', JSON.stringify(order_data));
                        generateViewOrder();

                    });
                    $order_items_wrapper.append($order_tpl);

                }
            }

            $order_total_selector.html(formatPrice(order_total));
            if(order_total == 0){
                $('#view-order-wrapper').hide();
                $.magnificPopup.close();
            }
        }
        generateViewOrder();
        $.magnificPopup.open({
            items: {
                src: '#your-order',
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

    /*
    * Send Order
    */
    $("#send-order-form").on("submit", function (e) {
        e.preventDefault();
        var order_data = JSON.parse(localStorage.getItem('quickqr_order')),
            items = [],
            $form = $(this),
            $btn = $form.find('button'),
            $form_error = $form.find('.form-error'),
            $data = $form.serializeArray();

        for (var i in order_data) {
            if (order_data.hasOwnProperty(i)) {
                items.push(order_data[i]);
            }
        }
        $data.push({name: 'action', value: 'sendRestaurantOrder'});
        $data.push({name: 'items', value: JSON.stringify(items)});
        $data.push({name: 'restaurant', value: $form.data('id')});

        $form_error.slideUp();
        $btn.addClass('button-progress').prop('disabled', true);
        $.ajax({
            type: "POST",
            url: ajaxurl,
            data: $data,
            dataType: 'json',
            success: function (response) {
                $btn.removeClass('button-progress').prop('disabled', false);
                if(response.success){
                    // clear order data
                    localStorage.setItem('quickqr_order','{}');
                    $('#view-order-wrapper').hide();
                    //$form.find('input').val('');

                    $('.your-order-content').slideUp();
                    $('.order-success-message').slideDown();
                }else{
                    $form.find('.form-error').html(response.message).slideDown();
                }
            }
        });
    });

    function calculateOrderPrice(amount) {
        var extra = 0;
        $('.menu-extra-item').each(function () {
            if($(this).find('.checkbox input').is(':checked')){
                extra += Number($(this).data('price'));
            }
        });
        $('#order-price').html(formatPrice((amount+extra)* Number($('#menu-order-quantity').val())));
    }

    function formatPrice(price) {
        var number = price * 1;//makes sure `number` is numeric value
        var str = number.toFixed(CURRENCY_DECIMAL_PLACES ? CURRENCY_DECIMAL_PLACES : 0).toString().split('.');
        var parts = [];
        for (var i = str[0].length; i > 0; i -= 3) {
            parts.unshift(str[0].substring(Math.max(0, i - 3), i));
        }
        str[0] = parts.join(CURRENCY_THOUSAND_SEPARATOR ? CURRENCY_THOUSAND_SEPARATOR : ',');
        price = str.join(CURRENCY_DECIMAL_SEPARATOR ? CURRENCY_DECIMAL_SEPARATOR : '.');

        return (CURRENCY_LEFT == 1 ? CURRENCY_SIGN + ' ' : '') + price + (CURRENCY_LEFT == 0 ? ' ' + CURRENCY_SIGN : '');
    }

    function randomId(length) {
        var result           = '';
        var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for ( var i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() * charactersLength));
        }
        return result;
    }
})(jQuery);