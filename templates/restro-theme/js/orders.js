jQuery(function ($) {
    var $notification_sound = $('.order-notification-sound');

    var audioogg = new Audio(siteurl+'includes/assets/audio/message.ogg');
    var audiomp3 = new Audio(siteurl+'includes/assets/audio/message.mp3');

    localStorage.notification_sound = localStorage.notification_sound || 1;
    if(localStorage.notification_sound == 1){
        $notification_sound.html('<i class="icon-feather-volume-2"></i>');
    }else{
        $notification_sound.html('<i class="icon-feather-volume-x"></i>');
    }

    // complete order
    $(document).on('click','.qr-complete-order', function(e) {
        e.preventDefault();
        var id = $(this).data('id'),
            $this = $(this);

        $this.addClass('button-progress').prop('disabled', true);
        $.ajax({
            type: "POST",
            url: ajaxurl,
            data: {
                action: 'completeOrder',
                id: id
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    $this.closest('tr').find('.order-status')
                        .removeClass('gray').addClass('green')
                        .attr('title',LANG_COMPLETE)
                        .html('<i class="icon-feather-check"></i>');
                }
                $this.removeClass('button-progress').prop('disabled', false);
            }
        });
    });

    // delete order
    $(document).on('click','.qr-delete-order', function(e) {
        e.preventDefault();
        var id = $(this).data('id'),
            $this = $(this);
        if(confirm(LANG_ARE_YOU_SURE)) {
            $this.addClass('button-progress').prop('disabled', true);
            $.ajax({
                type: "POST",
                url: ajaxurl,
                data: {
                    action: 'deleteOrder',
                    id: id
                },
                dataType: 'json',
                success: function (response) {
                    if (response.success) {
                        $this.closest('tr').remove();
                    }
                    $this.removeClass('button-progress').prop('disabled', false);
                }
            });
        }
    });

    // mute notification
    $(document).on('click','.order-notification-sound', function(e) {
        e.preventDefault();
        console.log(localStorage.notification_sound);
        if(localStorage.notification_sound == 1){
            localStorage.notification_sound = 0;
            $notification_sound.html('<i class="icon-feather-volume-x"></i>');
        }else{
            localStorage.notification_sound = 1;
            $notification_sound.html('<i class="icon-feather-volume-2"></i>');
            audiomp3.play();
            audioogg.play();
        }
    });
});