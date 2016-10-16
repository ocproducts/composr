(function ($cms) {
    'use strict';

    function NotificationButtons(options) {
        NotificationButtons.base(this, arguments);

        this.disableFormEl = this.$('#ndisable_' + options.notificationId);
        this.enableFormEl = this.$('#nenable_' + options.notificationId);
    }

    $cms.inherits(NotificationButtons, $cms.View, {
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


    $cms.templates.notificationPoller = function notificationPoller(options) {
        notification_poller_init(options.timestamp);
    };

    $cms.templates.blockTopNotifications = function blockTopNotifications(options) {
        window.max_notifications_to_show = +options.max || 0;
    };

    $cms.templates.notificationsManageScreen = function notificationsManageScreen() {
        var soundRadioEl = document.getElementById('sound_' + read_cookie('sound', 'off'));

        if (soundRadioEl) {
            soundRadioEl.checked = true;
        }
    };

    $cms.templates.notificationTypes_item = function notificationTypes_item() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-click-handle-ntype-tick', function (e, checkbox) {
            var raw = +checkbox.dataset.tpRaw || 0,
                parentRow = $cms.dom.closest(checkbox, 'tr'),
                inputEls = $cms.dom.$$(parentRow, 'input');

            if ((raw === -1) || (raw === -2)) { // Statistical/disallowed (from admin_notifications lock-down) will unselect all else
                for (var i = 0; i < inputEls.length; i++) {
                    if ((inputEls[i] !== checkbox) && (inputEls[i].type === 'checkbox')) {
                        inputEls[i].checked = false;
                    }
                }
            } else {
                if (inputEls[0] && inputEls[0].name.includes('CHOICE')) {
                    inputEls[0].checked = false;
                }

                if (inputEls[1] && inputEls[1].name.includes('STATISTICAL')) {
                    inputEls[1].checked = false;
                }
            }
        });
    };
}(window.$cms));


"use strict";

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


