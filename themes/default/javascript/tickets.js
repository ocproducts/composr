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
                $cms.form.updateAjaxMemberList(input, null, true, e);
            }
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-update-ajax-member-list', function (e, input) {
            $cms.form.updateAjaxMemberList(input, null, false, e);
        });

        $cms.dom.on(container, 'submit', '.js-submit-check-post-and-ticket-type-id-fields', function (e, form) {
            if (!$cms.form.checkFieldForBlankness(form.elements.post) || (form.elements['ticket_type_id'] && !$cms.form.checkFieldForBlankness(form.elements['ticket_type_id']))) {
                e.preventDefault();
            }
        });
    };
}(window.$cms));