(function ($cms) {
    'use strict';

    $cms.templates.supportTicketsScreen = function (params, container) {
        $cms.dom.on(container, 'submit', '.js-form-submit-scroll-to-top', function () {
            window.scrollTo(0, 0);
        });
    };

    $cms.templates.supportTicketScreen = function supportTicketScreen(params, container) {
        if ((params.serializedOptions != null) && (params.hash != null)) {
            window.comments_serialized_options = strVal(params.serializedOptions);
            window.comments_hash = strVal(params.hash);
        }

        $cms.dom.on(container, 'focus', '.js-focus-update-ajax-member-list', function (e, input) {
            if (input.value === '') {
                update_ajax_member_list(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            update_ajax_member_list(input, null, false, e);
        });

        $cms.dom.on(container, 'submit', '.js-submit-check-post-and-ticket-type-id-fields', function (e, form) {
            if (!check_field_for_blankness(form.elements.post) || (form.elements.ticket_type_id && !check_field_for_blankness(form.elements.ticket_type_id))) {
                e.preventDefault();
            }
        });
    };
}(window.$cms));