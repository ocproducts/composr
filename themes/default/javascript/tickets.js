(function ($cms) {
    'use strict';

    $cms.templates.supportTicketsScreen = function (params, container) {
        $cms.dom.on(container, 'submit', '.js-form-submit-scroll-to-top', function () {
            try {
                window.scrollTo(0, 0);
            } catch (ignore) {}
        });
    };

    $cms.templates.supportTicketScreen = function supportTicketScreen(params) {
        if ((typeof params.serializedOptions === 'string') && (typeof params.hash === 'string')) {
            window.comments_serialized_options = params.serializedOptions;
            window.comments_hash = params.hash;
        }
    };
}(window.$cms));