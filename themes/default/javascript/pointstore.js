(function ($cms) {
    'use strict';
    $cms.functions.hookPointStoreTopicPin = function hookPointStoreTopicPin() {
        var form = document.getElementById('days').form;
        form.old_submit = form.onsubmit;
        form.onsubmit = function () {
            var days = form.elements['days'].value;
            if (days > $cms.$CONFIG_OPTION.topic_pin_max_days) {
                window.fauxmodal_alert($cms.format('{!TOPIC_PINNED_MAX_DAYS;^}', $cms.numberFormat($cms.$CONFIG_OPTION.topic_pin_max_days)));
                return false;
            }
        };
    };
}(window.$cms));

