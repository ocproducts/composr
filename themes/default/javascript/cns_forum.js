(function (Composr) {
    'use strict';

    Composr.behaviors.cnsForum = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'cns_forum');
                Composr.initializeTemplates(context, 'cns_forum');
            }
        }
    };

    var CnsForumTopicWrapper = Composr.View.extend({
        initialize: function () {
            Composr.View.prototype.initialize.apply(this, arguments);
        },
        events: {
            'click .js-click-mark-all-topics': 'markAllTopics'
        },
        markAllTopics: function () {
            Composr.dom.$$('input[type="checkbox"][name^="mark_"]').forEach(function (checkbox) {
                checkbox.click();
            });
        }
    });

    Composr.views.cnsForum = {
        CnsForumTopicWrapper: CnsForumTopicWrapper
    };

    Composr.templates.cnsForum = {
        cnsTopicScreen: function (options) {
            if ((options.serializedOptions !== undefined) && (options.hash !== undefined)) {
                window.comments_serialized_options = options.serializedOptions;
                window.comments_hash = options.hash;
            }
        },

        cnsTopicPoll: function (options) {
            var form = this,
                minSelections = +options.minimumSelections,
                maxSelections = +options.maximumSelections,
                errorMessage  = (minSelections === maxSelections) ? Composr.str('{!POLL_NOT_ENOUGH_ERROR_2;^}', minSelections) : Composr.str('{!POLL_NOT_ENOUGH_ERROR;^}', minSelections, maxSelections);

            Composr.dom.on(form, 'submit', function (e) {
                var success = cns_check_poll(form, minSelections, maxSelections, errorMessage);
                if (!success) {
                    e.preventDefault();
                }
            });

            function cns_check_poll(form, min, max, error) {
                var j = 0;
                for (var i = 0; i < form.elements.length; i++)
                    if ((form.elements[i].checked) && ((form.elements[i].type == 'checkbox') || (form.elements[i].type == 'radio'))) j++;
                var answer = ((j >= min) && (j <= max));
                if (!answer) {
                    window.fauxmodal_alert(error);
                } else {
                    disable_button_just_clicked(form.elements['poll_vote_button']);
                }

                return answer;
            }
        },

        cnsNotification: function (options) {
            var container = this,
                ignoreUrl = options.ignoreUrl2;

            Composr.dom.on(container, 'click', '.js-click-ignore-notification', function () {
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
    };

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
}(window.Composr));

