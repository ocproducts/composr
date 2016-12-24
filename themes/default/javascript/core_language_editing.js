(function ($cms){
    'use strict';

    $cms.templates.translateScreen = function (params, container) {
        $cms.dom.on(container, 'submit', '.js-form-submit-modsecurity-workaround', function (e, form) {
            modsecurity_workaround(form)
        });
    };

    $cms.templates.translateLine = function (params, container) {
        $cms.dom.on(container, 'mouseover', '.js-mouseover-enable-textarea-translate-field', function () {
            var textarea = $cms.dom.$(container, '.js-textarea-translate-field');
            textarea.disabled = false;
        });


        $cms.dom.on(container, 'click', '.js-textarea-click-set-value', function (e, textarea) {
            if (textarea.value === '') {
                textarea.value = params.translateAuto;
            }
        });
    };

    $cms.templates.translateAction = function translateAction(params, container) {
        var name = strVal(params.name),
            old = strVal(params.old),
            langFrom = strVal(params.langFrom),
            langTo = strVal(params.langTo);

        $cms.dom.on(container, 'click', function () {
            translate(name, old, langFrom, langTo);
        });

    };
}(window.$cms));