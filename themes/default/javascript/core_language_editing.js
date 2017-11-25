(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.translateScreen = function (params, container) {
        $dom.on(container, 'submit', '.js-form-submit-modsecurity-workaround', function (e, form) {
            if ($cms.form.isModSecurityWorkaroundEnabled()) {
                e.preventDefault();
                $cms.form.modSecurityWorkaround(form);
            }
        });
    };

    $cms.templates.translateLine = function (params, container) {
        $dom.on(container, 'mouseover', '.js-mouseover-enable-textarea-translate-field', function () {
            var textarea = $dom.$(container, '.js-textarea-translate-field');
            textarea.disabled = false;
        });


        $dom.on(container, 'click', '.js-textarea-click-set-value', function (e, textarea) {
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

        $dom.on(container, 'click', function () {
            window.$translate.translate(name, old, langFrom, langTo);
        });

    };
}(window.$cms, window.$util, window.$dom));
