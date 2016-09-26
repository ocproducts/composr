(function (Composr) {
    Composr.templates.tickets = {
        supportTicketScreen: function supportTicketScreen(options) {
            if ((typeof options.serializedOptions === 'string') && (typeof options.hash === 'string')) {
                window.comments_serialized_options = options.serializedOptions;
                window.comments_hash = options.hash;
            }
        }
    };

    Composr.behaviors.tickets = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'tickets');
            }
        }
    };
}(Composr));