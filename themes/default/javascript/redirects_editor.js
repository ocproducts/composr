(function ($cms) {
    'use strict';

    $cms.templates.redirecteTableRedirect = function redirecteTableRedirect(params, container) {
        $cms.dom.on(container, 'click', '.js-click-confirm-container-deletion', function () {
            window.fauxmodal_confirm('{!ARE_YOU_SURE_DELETE;}', function (result) {
                if (result) {
                    $cms.dom.remove(container);
                }
            });
        });
    };

}(window.$cms));
