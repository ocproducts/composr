(function ($cms) {

    function PollBox() {
        PollBox.base(this, 'constructor', arguments);
    }

    $cms.inherits(PollBox, $cms.View, {
        events: function () {
            return {
                'click .js-click-confirm-forfeit': 'confirmForfeit'
            };
        },
        confirmForfeit: function (e, target) {
            var form = target.form;

            $cms.ui.confirm('{!VOTE_FORFEIGHT;^}',function(answer) {
                if (answer) {
                    form.submit();
                }
            });

            return false;
        }
    });

    $cms.views.PollBox = PollBox;

    $cms.templates.blockMainPoll = function blockMainPoll(params) {
        internaliseAjaxBlockWrapperLinks(params.blockCallUrl, document.getElementById(params.wrapperId), ['.*poll.*'], {}, false, true);
    };

    $cms.templates.pollAnswer = function pollAnswer(params, container) {
        var pollId = strVal(params.pid);

        $cms.dom.on(container, 'click', '.js-click-enable-poll-input', function () {
            $cms.dom.$('#poll' + pollId).disabled = false;
        });
    };

}(window.$cms));