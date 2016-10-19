(function ($cms){
    'use strict';

    $cms.templates.translateScreen = function () {
        var container = this;

        $cms.dom.on(container, 'submit', '.js-form-submit-modsecurity-workaround', function (e, form) {
            modsecurity_workaround(form)
        });
    };
}(window.$cms));