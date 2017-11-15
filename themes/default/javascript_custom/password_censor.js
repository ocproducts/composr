(function ($cms) {
    'use strict';

    $cms.templates.comcodeEncrypt = function comcodeEncrypt(params, container) {
        $dom.on(container, 'click', '.js-click-decrypt-data', function () {
            decryptData();
        });
    };
}(window.$cms));
