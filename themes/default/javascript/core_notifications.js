(function ($, Composr) {
    Composr.templates.coreNotificatons = {
        blockTopNotifications: function blockTopNotifications(options) {
            window.max_notifications_to_show = options.max;
        },

        notificationsManageScreen: function notificationsManageScreen() {
            var soundRadioEl = document.getElementById('sound_' + read_cookie('sound', 'off'));

            if (soundRadioEl) {
                soundRadioEl.checked = true;
            }
        }
    };

    Composr.behaviors.coreNotificatons = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_notifications');
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
