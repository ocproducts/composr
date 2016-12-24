(function ($cms) {
    'use strict';

    $cms.templates.revisionsScreen = function (params, container) {
        $cms.dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                update_ajax_member_list(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            update_ajax_member_list(input, null, false, e);
        });
    };

    $cms.templates.revisionsDiffIcon = function revisionsDiffIcon(params, container) {
        $cms.dom.on(container, 'mousemove', function (e) {
            reposition_tooltip(container, e, true);
        });
    };
}(window.$cms));