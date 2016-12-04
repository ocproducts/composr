(function ($cms) {

    function PollBox() {
        PollBox.base(this, 'constructor', arguments);
    }

    $cms.inherits(PollBox, $cms.View, {
        events: {
            'click .js-click-confirm-forfeit': 'confirmForfeit'
        },
        confirmForfeit: function (e, target) {
            var form = target.form;

            window.fauxmodal_confirm('{!VOTE_FORFEIGHT;^}',function(answer) {
                if (answer && (!form.onsubmit || form.onsubmit())) {
                    form.submit();
                }
            });

            return false;
        }
    });

    $cms.views.PollBox = PollBox;

    $cms.templates.blockMainPoll = function blockMainPoll(params) {
        internalise_ajax_block_wrapper_links(params.blockCallUrl, document.getElementById(params.wrapperId), ['.*poll.*'], {}, false, true);
    };

}(window.$cms));