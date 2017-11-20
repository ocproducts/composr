(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.redirectETableRedirect = function redirectETableRedirect(params, container) {
        $dom.on(container, 'click', '.js-click-confirm-container-deletion', function () {
            $cms.ui.confirm('{!ARE_YOU_SURE_DELETE;}', function (result) {
                if (result) {
                    $dom.remove(container);
                }
            });
        });
    };
}(window.$cms, window.$util, window.$dom));