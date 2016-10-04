(function (Composr) {
    'use strict';

    Composr.behaviors.coreNotificatons = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_notifications');
            }
        }
    };

    Composr.views.NotificationButtons = Composr.View.extend({
        disableForm: null,
        enableForm: null,
        initialize: function (v, opts) {
            Composr.View.initialize.apply(this, arguments);
            this.disableForm = this.$('#ndisable_' + opts.notificationId);
            this.enableForm = this.$('#nenable_' + opts.notificationId);
        },
        events: {
            'submit .js-submit-show-disable-form': 'showDisableForm',
            'submit .js-submit-show-enable-form': 'showEnableForm'
        },
        showDisableForm: function () {
            set_display_with_aria(this.enableForm, 'none');
            set_display_with_aria(this.disableForm,'inline');
        },
        showEnableForm: function () {
            set_display_with_aria(this.disableForm, 'none');
            set_display_with_aria(this.enableForm,'inline');
        }
    });

    Composr.templates.coreNotificatons = {
        notificationPoller: function (options) {
            notification_poller_init(options.timestamp);
        },

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

                if (Composr.is(nt.available, nt.typeHasChildrenSet)) {
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
}(window.Composr));
