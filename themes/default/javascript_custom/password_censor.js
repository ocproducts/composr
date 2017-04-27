(function ($cms) {
    'use strict';

    $cms.templates.comcodeEncrypt = function comcodeEncrypt(params, container) {
        $cms.dom.on(container, 'click', '.js-click-decrypt-data', function () {
            decrypt_data();
        });
    };
}(window.$cms));
