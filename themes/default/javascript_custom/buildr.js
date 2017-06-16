(function ($cms) {
    'use strict';

    $cms.templates.wMainScreen = function wMainScreen(params, container) {
        $cms.dom.on(container, 'click', '.js-click-set-hidemod-cookie', function (e, el) {
            $cms.setCookie('hideMod', (el.querySelector('img').getAttribute('src') === '{$IMG;,1x/trays/contract}') ? '0' : '1')
        });

        $cms.dom.on(container, 'click', '.js-click-set-type-edititem', function (e, el) {
            el.form.elements['type'] = 'edititem';
        });
        $cms.dom.on(container, 'click', '.js-click-set-type-confirm', function (e, el) {
            el.form.elements['type'] = 'confirm';
        });
    };
}(window.$cms));
