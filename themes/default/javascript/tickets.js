(function ($cms) {
    'use strict';

    $cms.templates.supportTicketsScreen = function (params, container) {
        $cms.dom.on(container, 'submit', '.js-form-submit-scroll-to-top', function () {
            try {
                window.scrollTo(0, 0);
            } catch (ignore) {}
        });
    };

    $cms.templates.supportTicketScreen = function supportTicketScreen(params, container) {
        if ((typeof params.serializedOptions === 'string') && (typeof params.hash === 'string')) {
            window.comments_serialized_options = params.serializedOptions;
            window.comments_hash = params.hash;
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