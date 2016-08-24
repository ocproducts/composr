(function ($, Composr) {
    Composr.templates.polls = {
        blockMainPoll: function blockMainPoll(options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['.*poll.*'], {}, false, true);
        }
    };

    Composr.behaviors.polls = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'polls');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);