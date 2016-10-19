(function ($cms) {
    $cms.templates.supportTicketScreen = function supportTicketScreen(params) {
        if ((typeof params.serializedOptions === 'string') && (typeof params.hash === 'string')) {
            window.comments_serialized_options = params.serializedOptions;
            window.comments_hash = params.hash;
        }
    };
}(window.$cms));