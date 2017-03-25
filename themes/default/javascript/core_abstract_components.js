(function ($cms) {
    'use strict';

    var encodeUC = encodeURIComponent;

    $cms.templates.buttonScreenItem = function buttonScreenItem() {};

    $cms.templates.cropTextMouseOver = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $cms.dom.on(el, 'mouseover', function (e) {
            activate_tooltip(el, e, textLarge, '40%');
        });
    };

    $cms.templates.cropTextMouseOverInline = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $cms.dom.on(el, 'mouseover', function (e) {
            var window = get_main_cms_window(true);
            window.activate_tooltip(el, e, textLarge, '40%', null, null, null, false, false, false, window);
        });
    };

    $cms.templates.fractionalEdit = function fractionalEdit(params, el) {
        var explicitEditingLinks = !!params.explicitEditingLinks,
            url = strVal(params.url),
            editText = strVal(params.editText),
            editParamName = strVal(params.editParamName),
            editType = strVal(params.editType);

        if (!explicitEditingLinks) {
            $cms.dom.on(el, 'click', function (e) {
                fractional_edit(e, el, url, editText, editParamName, null, null, editType);
            });

            $cms.dom.on(el, 'mouseover mouseout', function (e) {
                if (e.type === 'mouseover') {
                    window.old_status = window.status;
                    window.status = '{!SPECIAL_CLICK_TO_EDIT;}';
                    el.classList.add('fractional_edit');
                    el.classList.remove('fractional_edit_nonover');
                } else {
                    window.status = window.old_status;
                    el.classList.remove('fractional_edit');
                    el.classList.add('fractional_edit_nonover');
                }
            });
        } else {
            $cms.dom.on(el, 'click', function (e) {
                fractional_edit(e, el.previousElementSibling.previousElementSibling, url, editText, editParamName);
            });
        }
    };

    $cms.templates.postChildLoadLink = function (params, container) {
        var ids = params.implodedIds,
            id = params.id;

        $cms.dom.on(container, 'click', '.js-click-threaded-load-more', function () {
            /* Load more from a threaded topic */
            $cms.loadSnippet('comments&id=' + encodeUC(id) + '&ids=' + encodeUC(ids) + '&serialized_options=' + encodeUC(window.comments_serialized_options) + '&hash=' + encodeUC(window.comments_hash), null, function (ajax_result) {
                var wrapper;
                if (id !== '') {
                    wrapper = $cms.dom.$('#post_children_' + id);
                } else {
                    wrapper = container.parentNode;
                }
                container.parentNode.removeChild(container);

                $cms.dom.appendHtml(wrapper, ajax_result.responseText);

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


    };

    $cms.templates.handleConflictResolution = function (params) {
        if (params.pingUrl) {
            do_ajax_request(params.pingUrl);

            window.setInterval(function () {
                do_ajax_request(params.pingUrl, function () {
                });
            }, 12000);
        }
    };
}(window.$cms));