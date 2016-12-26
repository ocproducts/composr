(function ($cms) {
    'use strict';

    function NotificationButtons(params) {
        NotificationButtons.base(this, 'constructor', arguments);

        this.disableFormEl = this.$('#ndisable_' + params.notificationId);
        this.enableFormEl = this.$('#nenable_' + params.notificationId);
    }

    $cms.inherits(NotificationButtons, $cms.View, {
        events: function () {
            return {
                'submit .js-submit-show-disable-form': 'showDisableForm',
                'submit .js-submit-show-enable-form': 'showEnableForm'
            };
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


    $cms.templates.notificationPoller = function notificationPoller(params) {
        notification_poller_init(params.timestamp);
    };

    $cms.templates.blockTopNotifications = function blockTopNotifications(params, container) {
        window.max_notifications_to_show = +params.max || 0;

        $cms.dom.on(container, 'click', '.js-click-notifications-mark-all-read', function (e) {
            notifications_mark_all_read(e);
        });

        $cms.dom.on(container, 'click', '.js-click-toggle-web-notifications', function (e) {
            if (toggle_web_notifications(e) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'mouseup', '.js-mouseup-toggle-web-notifications', function (e) {
            toggle_web_notifications(e);
        });

        $cms.dom.on(container, 'mouseup', '.js-mouseup-find-url-tab', function (e) {
            find_url_tab();
        });

        $cms.dom.on(container, 'click', '.js-click-toggle-pts', function (e) {
            if (toggle_pts(e) === false) {
                e.preventDefault();
            }
        });

        $cms.dom.on(container, 'mouseup', '.js-mouseup-toggle-pts', function (e) {
            toggle_pts(e);
        });
    };

    $cms.templates.notificationsManageScreen = function notificationsManageScreen(params, container) {
        var soundRadioEl = $cms.dom.$('#sound_' + read_cookie('sound', 'off'));

        if (soundRadioEl) {
            soundRadioEl.checked = true;
        }

        $cms.dom.on(container, 'click', '.js-click-set-sound-cookie-on', function () {
            set_cookie('sound', 'on');
        });

        $cms.dom.on(container, 'click', '.js-click-set-sound-cookie-off', function () {
            set_cookie('sound', 'off');
        });
    };

    $cms.templates.notificationsTree = function notificationsTree() {
        var tableRow = this;

        $cms.dom.on(tableRow, 'click', '.js-click-copy-advanced-notifications', function () {
            advanced_notifications_copy_under(tableRow);
        });

        function advanced_notifications_copy_under(row) {
            var inputsFrom = row.querySelectorAll('input'),
                parentDepth = $cms.dom.css(row.querySelector('th'), 'padding-left'),
                childDepth, inputsTo;

            while (true) {
                row = $cms.dom.next(row, 'tr');

                if (!row) {
                    return; // Should not happen
                }

                childDepth = $cms.dom.css(row.querySelector('th'), 'padding-left');

                if (childDepth === parentDepth) {
                    break; // Don't allow to progress one further
                }

                inputsTo = row.querySelectorAll('input');
                for (var j = 0; j < inputsTo.length; j++) {
                    if (inputsTo[j].type === 'checkbox') {
                        inputsTo[j].checked = inputsFrom[j].checked;
                    }
                }
            }
        }
    };

    $cms.templates.notificationWeb = function notificationWeb() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-click-poll-for-notifications', function () {
            poll_for_notifications(true, true);
        });
    };

    $cms.templates.notificationTypes_item = function notificationTypes_item() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-click-handle-ntype-tick', function (e, checkbox) {
            var raw = +checkbox.dataset.tpRaw || 0,
                parentRow = $cms.dom.closest(checkbox, 'tr'),
                inputEls = $cms.dom.$$(parentRow, 'input'),
                firstInput = inputEls[0],
                secondInput = inputEls[1];

            if ((raw === -1) || (raw === -2)) { // Statistical/disallowed (from admin_notifications lock-down) will unselect all else
                for (var i = 0; i < inputEls.length; i++) {
                    if ((inputEls[i] !== checkbox) && (inputEls[i].type === 'checkbox')) {
                        inputEls[i].checked = false;
                    }
                }
            } else {
                if (firstInput && firstInput.name.includes('CHOICE')) {
                    firstInput.checked = false;
                }

                if (secondInput && secondInput.name.includes('STATISTICAL')) {
                    secondInput.checked = false;
                }
            }
        });
    };
}(window.$cms));



