/*{$REQUIRE_LANG,pointstore}*/
(function ($cms) {
    'use strict';
    $cms.functions.hookPointStoreTopicPin = function hookPointStoreTopicPin() {
        var form = document.getElementById('days').form;
        form.addEventListener('submit', function () {
            var days = form.elements['days'].value;
            if (days > $cms.$CONFIG_OPTION('topic_pin_max_days')) {
                $cms.ui.alert($cms.format('{!TOPIC_PINNED_MAX_DAYS;^}', $cms.numberFormat($cms.$CONFIG_OPTION('topic_pin_max_days'))));
                return false;
            }
        });
    };

    $cms.functions.hookPointstorePop3 = function hookPointStoreTopicPin() {
        var form = document.getElementById('pass1').form;
        form.addEventListener('submit', function(e) {
            if ((form.elements['pass1'].value != form.elements['pass2'].value)) {
                $cms.ui.alert('{!PASSWORD_MISMATCH;}');
                e.preventDefault();
            }
        });
    };
}(window.$cms));

