(function ($cms) {
    'use strict';

    function CnsForumTopicWrapper() {
        CnsForumTopicWrapper.base(this, arguments);
    }

    $cms.inherits(CnsForumTopicWrapper, $cms.View, {
        events: {
            'click .js-click-mark-all-topics': 'markAllTopics'
        },
        markAllTopics: function () {
            $cms.dom.$$('input[type="checkbox"][name^="mark_"]').forEach(function (checkbox) {
                checkbox.click();
            });
        }
    });

    $cms.views.CnsForumTopicWrapper = CnsForumTopicWrapper;

    $cms.extend($cms.templates, {
        cnsTopicScreen: function (params) {
            if ((params.serializedOptions !== undefined) && (params.hash !== undefined)) {
                window.comments_serialized_options = params.serializedOptions;
                window.comments_hash = params.hash;
            }
        },

        cnsTopicPoll: function (params) {
            var form = this,
                minSelections = +params.minimumSelections || 0,
                maxSelections = +params.maximumSelections || 0,
                error  = (minSelections === maxSelections) ? $cms.format('{!POLL_NOT_ENOUGH_ERROR_2;^}', minSelections) : $cms.format('{!POLL_NOT_ENOUGH_ERROR;^}', minSelections, maxSelections);

            $cms.dom.on(form, 'submit', function (e) {
                if (cns_check_poll() === false) {
                    e.preventDefault();
                }
            });

            function cns_check_poll() {
                var j = 0;
                for (var i = 0; i < form.elements.length; i++) {
                    if (form.elements[i].checked && ((form.elements[i].type === 'checkbox') || (form.elements[i].type === 'radio'))) {
                        j++;
                    }
                }
                var answer = ((j >= minSelections) && (j <= maxSelections));
                if (!answer) {
                    window.fauxmodal_alert(error);
                    return false;
                }

                $cms.ui.disableButton(form.elements['poll_vote_button']);
            }
        },

        cnsNotification: function (params) {
            var container = this,
                ignoreUrl = params.ignoreUrl2;

            $cms.dom.on(container, 'click', '.js-click-ignore-notification', function () {
                var el = this;
                do_ajax_request(ignoreUrl, function () {
                    var o = el.parentNode.parentNode.parentNode.parentNode;
                    o.parentNode.removeChild(o);

                    var nots = document.querySelector('.cns_member_column_pts');
                    if (nots && (document.querySelectorAll('.cns_notification').length === 0)) {
                        nots.parentNode.removeChild(nots);
                    }
                });
            });
        }
    });

    // TODO: test if the new implementation in CnsForumTopicWrapper works and remove this
    function mark_all_topics(event) {
        var e = document.getElementsByTagName('input');
        var i;
        for (i = 0; i < e.length; i++) {
            if ((e[i].type == 'checkbox') && (e[i].name.substr(0, 5) == 'mark_')) {
                e[i].checked = !e[i].checked;
                e[i].onclick(event);
            }
        }
    }
}(window.$cms));

