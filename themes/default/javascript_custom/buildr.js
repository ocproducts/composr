(function ($cms) {
    'use strict';

    $cms.templates.wMainScreen = function wMainScreen(params, container) {
        $dom.on(container, 'click', '.js-click-set-hidemod-cookie', function (e, el) {
            $cms.setCookie('hideMod', $cms.isIcon(el.querySelector('.icon'), 'trays/contract') ? '0' : '1');
        });

        $dom.on(container, 'click', '.js-click-set-type-edititem', function (e, el) {
            el.form.elements['type'] = 'edititem';
        });
        $dom.on(container, 'click', '.js-click-set-type-confirm', function (e, el) {
            el.form.elements['type'] = 'confirm';
        });
    };
}(window.$cms));
