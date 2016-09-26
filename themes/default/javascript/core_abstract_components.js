(function (Composr) {
    'use strict';
    Composr.behaviors.coreAbstractComponents = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_abstract_components');
            }
        }
    };

    Composr.templates.coreAbstractComponents = {
        cropTextMouseOver: function (options) {
            var textLarge = Composr.filter.crLf(options.textLarge),
                el = this;

            Composr.dom.on(el, 'mouseover', function (e) {
                activate_tooltip(el, e, textLarge, '40%');
            });
        },

        cropTextMouseOverInline: function (options) {
            var textLarge = Composr.filter.crLf(options.textLarge),
                el = this;

            Composr.dom.on(el, 'mouseover', function (e) {
                var window = get_main_cms_window(true);
                window.activate_tooltip(el, e, textLarge, '40%', null, null, null, false, false, false, window);
            });
        },

        postChildLoadLink: function (options) {
            var container = this,
                ids = options.implodedIds,
                id = options.id;

            Composr.dom.on(container, 'click', '.js-click-threaded-load-more', function () {
                /* Load more from a threaded topic */
                load_snippet('comments&id=' + window.encodeURIComponent(id) + '&ids=' + window.encodeURIComponent(ids) + '&serialized_options=' + window.encodeURIComponent(window.comments_serialized_options) + '&hash=' + window.encodeURIComponent(window.comments_hash), null, function (ajax_result) {
                    var wrapper;
                    if (id !== '') {
                        wrapper = document.getElementById('post_children_' + id);
                    } else {
                        wrapper = container.parentNode;
                    }
                    container.parentNode.removeChild(container);

                    Composr.dom.appendHtml(wrapper, ajax_result.responseText);

                    window.setTimeout(function () {
                        var _ids = ids.split(',');
                        for (var i = 0; i < _ids.length; i++) {
                            var element = document.getElementById('post_wrap_' + _ids[i]);
                            if (element) {
                                clear_transition_and_set_opacity(element, 0);
                                fade_transition(element, 100, 30, 10);
                            }
                        }
                    }, 0);
                });
            });


        },
        handleConflictResolution: function (options) {
            options = options || {};

            if (Composr.is(options.pingUrl)) {
                do_ajax_request(options.pingUrl);

                window.setInterval(function () {
                    do_ajax_request(options.pingUrl, function () {});
                }, 12000);
            }
        }
    };
}(window.Composr));