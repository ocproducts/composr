(function ($, Composr) {
    'use strict';

    Composr.templates.coreNotificatons = {
        blockTopNotifications: function blockTopNotifications(options) {
            window.max_notifications_to_show = options.max;
        },

        notificationsManageScreen: function notificationsManageScreen() {
            var soundRadioEl = document.getElementById('sound_' + read_cookie('sound', 'off'));

            if (soundRadioEl) {
                soundRadioEl.checked = true;
            }
        },

        notificationTypes: function (options) {
            var types = options.notificationTypes, i, len, nt, el;

            for (i = 0, len = types.length; i < len; i++) {
                nt = types[i];

                if (Composr.areTruthy(nt.available, nt.typeHasChildrenSet)) {
                    el = document.getElementById('notification_' + options.scope + '_' + options.ntype);

                    if (!el.checked) {
                        el.indeterminate = true;
                    }

                    el.addEventListener('change', function () {
                        if (!this.checked) {
                            // Put back
                            this.indeterminate = true;
                        }
                    });
                }
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
