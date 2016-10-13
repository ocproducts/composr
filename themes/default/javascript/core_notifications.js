(function ($cms) {
    'use strict';

    function NotificationButtons(options) {
        $cms.View.apply(this, arguments);

        this.disableFormEl = this.$('#ndisable_' + options.notificationId);
        this.enableFormEl = this.$('#nenable_' + options.notificationId);

    }

    $cms.inherits(NotificationButtons, $cms.View, {
        disableFormEl: null,
        enableFormEl: null,
        events: {
            'submit .js-submit-show-disable-form': 'showDisableForm',
            'submit .js-submit-show-enable-form': 'showEnableForm'
        },
        showDisableForm: function () {
            $cms.dom.show(this.disableFormEl);
            $cms.dom.hide(this.enableFormEl);
        },
        showEnableForm: function () {
            $cms.dom.hide(this.disableFormEl);
            $cms.dom.show(this.enableFormEl);
        }
    });

    $cms.extend($cms.templates, {
        notificationPoller: function (options) {
            notification_poller_init(options.timestamp);
        },

        blockTopNotifications: function blockTopNotifications(options) {
            window.max_notifications_to_show = +options.max || 0;
        },

        notificationsManageScreen: function notificationsManageScreen() {
            var soundRadioEl = document.getElementById('sound_' + read_cookie('sound', 'off'));

            if (soundRadioEl) {
                soundRadioEl.checked = true;
            }
        },

        notificationTypes: function (options) {
            var types = options.notificationTypes || [];

            types.forEach(function (nt) {
                if (!nt || !nt.available || !nt.typeHasChildrenSet){
                    return;
                }

                var el = document.getElementById('notification_' + nt.scope + '_' + nt.ntype);

                if (!el.checked) {
                    el.indeterminate = true;
                }

                el.addEventListener('change', function () {
                    if (!el.checked) {
                        // Put back
                        el.indeterminate = true;
                    }
                });
            });
        }
    });
}(window.$cms));
