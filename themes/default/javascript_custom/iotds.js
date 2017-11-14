(function ($cms) {
    'use strict';

    $cms.templates.iotdBox = function iotdBox(params, container) {
        $dom.on(container, 'submit', '.js-submit-confirm-iotd-deletion', function (e, form) {
            $cms.ui.confirm('{!ARE_YOU_SURE_DELETE;}', function (answer) {
                if (answer) {
                    $dom.submit(form);
                }
            });
            e.preventDefault();
        });
    };
}(window.$cms));
