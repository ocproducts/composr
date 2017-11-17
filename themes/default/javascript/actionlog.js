(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.revisionsScreen = function (params, container) {
        $dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });
    };

    $cms.templates.revisionsDiffIcon = function revisionsDiffIcon(params, container) {
        $dom.on(container, 'mousemove', function (e) {
            $cms.ui.repositionTooltip(container, e, true);
        });
    };
}(window.$cms, window.$util, window.$dom));
