(function ($cms) {
    'use strict';

    $cms.templates.revisionsScreen = function (params, container) {
        $cms.dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });
    };

    $cms.templates.revisionsDiffIcon = function revisionsDiffIcon(params, container) {
        $cms.dom.on(container, 'mousemove', function (e) {
            $cms.ui.repositionTooltip(container, e, true);
        });
    };
}(window.$cms));