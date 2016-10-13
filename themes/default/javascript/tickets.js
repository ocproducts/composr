(function ($cms) {
    $cms.templates.supportTicketScreen = function supportTicketScreen(options) {
        if ((typeof options.serializedOptions === 'string') && (typeof options.hash === 'string')) {
            window.comments_serialized_options = options.serializedOptions;
            window.comments_hash = options.hash;
        }
    };
}(window.$cms));