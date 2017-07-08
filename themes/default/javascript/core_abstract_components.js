/* TODO: Salman, merge this into global.js */

(function ($cms) {
    'use strict';

    $cms.templates.buttonScreenItem = function buttonScreenItem() {};

    $cms.templates.cropTextMouseOver = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $cms.dom.on(el, 'mouseover', function (e) {
            $cms.ui.activateTooltip(el, e, textLarge, '40%');
        });
    };

    $cms.templates.cropTextMouseOverInline = function (params, el) {
        var textLarge = $cms.filter.nl(params.textLarge);

        $cms.dom.on(el, 'mouseover', function (e) {
            var window = $cms.getMainCmsWindow(true);
            window.$cms.ui.activateTooltip(el, e, textLarge, '40%', null, null, null, false, false, false, window);
        });
    };

    /* TODO: Salman move to fractional_edit.js */
    $cms.templates.fractionalEdit = function fractionalEdit(params, el) {
        var explicitEditingLinks = !!params.explicitEditingLinks,
            url = strVal(params.url),
            editText = strVal(params.editText),
            editParamName = strVal(params.editParamName),
            editType = strVal(params.editType);

        if (!explicitEditingLinks) {
            $cms.dom.on(el, 'click', function (e) {
                fractionalEdit(e, el, url, editText, editParamName, null, null, editType);
            });

            $cms.dom.on(el, 'mouseover mouseout', function (e, target) {
                if (target.contains(e.relatedTarget)) {
                    return;
                }

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
                fractionalEdit(e, el.previousElementSibling.previousElementSibling, url, editText, editParamName);
            });
        }
    };

    /* TODO: Salman move to core_feedback_features.js */
    $cms.templates.postChildLoadLink = function (params, container) {
        var ids = params.implodedIds,
            id = params.id;

        $cms.dom.on(container, 'click', '.js-click-threaded-load-more', function () {
            /* Load more from a threaded topic */
            $cms.loadSnippet('comments&id=' + encodeURIComponent(id) + '&ids=' + encodeURIComponent(ids) + '&serialized_options=' + encodeURIComponent(window.comments_serialized_options) + '&hash=' + encodeURIComponent(window.comments_hash), null, true).then(function (ajaxResult) {
                var wrapper;
                if (id !== '') {
                    wrapper = $cms.dom.$('#post_children_' + id);
                } else {
                    wrapper = container.parentNode;
                }
                container.parentNode.removeChild(container);

                $cms.dom.append(wrapper, ajaxResult.responseText);

                setTimeout(function () {
                    var _ids = ids.split(',');
                    for (var i = 0; i < _ids.length; i++) {
                        var element = document.getElementById('post_wrap_' + _ids[i]);
                        if (element) {
                            $cms.dom.clearTransitionAndSetOpacity(element, 0);
                            $cms.dom.fadeTransition(element, 100, 30, 10);
                        }
                    }
                }, 0);
            });
        });


    };

    $cms.templates.handleConflictResolution = function (params) {
        if (params.pingUrl) {
            $cms.doAjaxRequest(params.pingUrl, /*async*/function () {});

            setInterval(function () {
                $cms.doAjaxRequest(params.pingUrl, /*async*/function () {});
            }, 12000);
        }
    };

    $cms.templates.indexScreenFancierScreen = function indexScreenFancierScreen(params) {
        document.getElementById('search_content').value = strVal(params.rawSearchString);
    };
}(window.$cms));
