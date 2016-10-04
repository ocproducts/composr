(function ($, Composr) {
    Composr.behaviors.polls = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'polls');
            }
        }
    };

    var PollBox = Composr.View.extend({
        events: {
            'click .js-click-confirm-forfeit': 'confirmForfeit'
        },
        confirmForfeit: function (e, target) {
            var form = target.form;

            window.fauxmodal_confirm('{!VOTE_FORFEIGHT}',function(answer) {
                if (answer && (!form.onsubmit ||form.onsubmit())) {
                    form.submit();
                }
            });

            return false;
        }
    });

    Composr.views.PollBox = PollBox;

    Composr.templates.polls = {
        blockMainPoll: function blockMainPoll(options) {
            internalise_ajax_block_wrapper_links(options.blockCallUrl, document.getElementById(options.wrapperId), ['.*poll.*'], {}, false, true);
        }
    };

}(window.Composr));