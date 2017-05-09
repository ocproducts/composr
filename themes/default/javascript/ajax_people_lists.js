(function ($cms) {
    'use strict';
    /**
     * @memberof $cms.form
     * @param target
     * @param e
     * @param search_type
     */
    $cms.form.updateAjaxSearchList = function updateAjaxSearchList(target, e, search_type) {
        var special = 'search';
        search_type = strVal(search_type);
        if (search_type) {
            special += '&search_type=' + encodeURIComponent(search_type);
        }
        $cms.form.updateAjaxMemberList(target, special, false, e);
    };

    var currentlyDoingListTimer = 0,
        currentListForEl = null;

    /**
     * @memberof $cms.form
     * @param target
     * @param special
     * @param delayed
     * @param event
     */
    $cms.form.updateAjaxMemberList = function updateAjaxMemberList(target, special, delayed, event) {
        if ((event && $cms.dom.keyPressed(event, 'Enter')) || target.disabled) {
            return;
        }

        if (!$cms.browserMatches('ios') && !target.onblur) {
            target.onblur = function () {
                setTimeout(function () {
                    closeDownAjaxList();
                }, 300);
            }
        }

        if (!delayed) {// A delay, so as not to throw out too many requests
            if (currentlyDoingListTimer) {
                window.clearTimeout(currentlyDoingListTimer);
            }
            var e_copy = { 'keyCode': event.keyCode, 'which': event.which };

            currentlyDoingListTimer = window.setTimeout(function () {
                $cms.form.updateAjaxMemberList(target, special, true, e_copy);
            }, 400);
            return;
        } else {
            currentlyDoingListTimer = 0;
        }

        target.special = special;

        var v = target.value;

        currentListForEl = target;
        var script = '{$FIND_SCRIPT_NOHTTP;,namelike}?id=' + encodeURIComponent(v);
        if (special) {
            script = script + '&special=' + special;
        }

        $cms.doAjaxRequest(script + $cms.keepStub(), updateAjaxNemberListResponse);

        function closeDownAjaxList() {
            var current = $cms.dom.$('#ajax_list');
            if (current) {
                current.parentNode.removeChild(current);
            }
        }

        function updateAjaxNemberListResponse(result, list_contents) {
            if (!list_contents || !currentListForEl) {
                return;
            }

            closeDownAjaxList();

            var isDataList = false;//(document.createElement('datalist').options!==undefined);	Still too buggy in browsers

            //if (list_contents.childNodes.length==0) return;
            var list = document.createElement(isDataList ? 'datalist' : 'select');
            list.className = 'people_list';
            list.setAttribute('id', 'ajax_list');
            if (isDataList) {
                currentListForEl.setAttribute('list', 'ajax_list');
            } else {
                if (list_contents.childNodes.length == 1) {// We need to make sure it is not a dropdown. Normally we'd use size (multiple isn't correct, but we'll try this for 1 as it may be more stable on some browsers with no side effects)
                    list.setAttribute('multiple', 'multiple');
                } else {
                    list.setAttribute('size', list_contents.childNodes.length + 1);
                }
                list.style.position = 'absolute';
                list.style.left = ($cms.dom.findPosX(currentListForEl)) + 'px';
                list.style.top = ($cms.dom.findPosY(currentListForEl) + currentListForEl.offsetHeight) + 'px';
            }
            setTimeout(function () {
                list.style.zIndex++;
            }, 100); // Fixes Opera by causing a refresh

            if (list_contents.children.length === 0) {
                return;
            }

            var i, item, displaytext;
            for (i = 0; i < list_contents.children.length; i++) {
                item = document.createElement('option');
                item.value = list_contents.children[i].getAttribute('value');
                displaytext = item.value;
                if (list_contents.children[i].getAttribute('displayname') != '')
                    displaytext = list_contents.children[i].getAttribute('displayname');
                item.text = displaytext;
                item.textContent = displaytext;
                list.appendChild(item);
            }
            item = document.createElement('option');
            item.disabled = true;
            item.text = '{!javascript:SUGGESTIONS_ONLY;^}'.toUpperCase();
            item.textContent = '{!javascript:SUGGESTIONS_ONLY;^}'.toUpperCase();
            list.appendChild(item);
            currentListForEl.parentNode.appendChild(list);

            if (isDataList) {
                return;
            }

            $cms.dom.clearTransitionAndSetOpacity(list, 0.0);
            $cms.dom.fadeTransition(list, 100, 30, 8);

            var current_list_for_copy = currentListForEl;

            if (currentListForEl.old_onkeyup === undefined) {
                currentListForEl.old_onkeyup = currentListForEl.onkeyup;
            }

            if (currentListForEl.old_onchange === undefined) {
                currentListForEl.old_onchange = currentListForEl.onchange;
            }

            currentListForEl.down_once = false;

            currentListForEl.onkeyup = function (event) {
                var ret = handleArrowUsage(event);
                if (ret != null) {
                    return ret;
                }
                return $cms.form.updateAjaxMemberList(current_list_for_copy, current_list_for_copy.special, false, event);
            };
            currentListForEl.onchange = function (event) {
                current_list_for_copy.onkeyup = current_list_for_copy.old_onkeyup;
                current_list_for_copy.onchange = current_list_for_copy.old_onchange;
                if (current_list_for_copy.onchange) {
                    current_list_for_copy.onchange(event);
                }
            };
            list.onkeyup = function (event) {
                var ret = handleArrowUsage(event);
                if (ret != null) {
                    return ret;
                }

                if ($cms.dom.keyPressed(event, 'Enter')) {// ENTER
                    makeSelection(event);
                    current_list_for_copy.disabled = true;
                    window.setTimeout(function () {
                        current_list_for_copy.disabled = false;
                    }, 200);

                    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                }
                if (!event.shiftKey && $cms.dom.keyPressed(event, ['ArrowUp', 'ArrowDown'])) {
                    if (event.cancelable) {
                        event.preventDefault();
                    }
                    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                }
                return null;
            };

            currentListForEl.onkeypress = function (event) {
                if (!event.shiftKey && $cms.dom.keyPressed(event, ['ArrowUp', 'ArrowDown'])) {
                    if (event.cancelable) {
                        event.preventDefault();
                    }
                    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                }
                return null;
            };
            list.onkeypress = function (event) {
                if (!event.shiftKey && $cms.dom.keyPressed(event, ['Enter', 'ArrowUp', 'ArrowDown'])) {
                    if (event.cancelable) {
                        event.preventDefault();
                    }
                    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                }
                return null;
            };

            list.addEventListener($cms.browserMatches('ios') ? 'change' : 'click', makeSelection, false);

            currentListForEl = null;

            function handleArrowUsage(event) {
                if (!event.shiftKey && $cms.dom.keyPressed(event, 'ArrowDown')) {// DOWN
                    current_list_for_copy.disabled = true;
                    window.setTimeout(function () {
                        current_list_for_copy.disabled = false;
                    }, 1000);

                    var temp = current_list_for_copy.onblur;
                    current_list_for_copy.onblur = function () {
                    };
                    list.focus();
                    current_list_for_copy.onblur = temp;
                    if (!current_list_for_copy.down_once) {
                        current_list_for_copy.down_once = true;
                        list.selectedIndex = 0;
                    } else {
                        if (list.selectedIndex < list.options.length - 1) list.selectedIndex++;
                    }
                    list.options[list.selectedIndex].selected = true;
                    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                }

                if (!event.shiftKey && $cms.dom.keyPressed(event, 'ArrowUp')) {// UP
                    current_list_for_copy.disabled = true;
                    window.setTimeout(function () {
                        current_list_for_copy.disabled = false;
                    }, 1000);

                    var temp = current_list_for_copy.onblur;
                    current_list_for_copy.onblur = function () {};
                    list.focus();
                    current_list_for_copy.onblur = temp;
                    if (!current_list_for_copy.down_once) {
                        current_list_for_copy.down_once = true;
                        list.selectedIndex = 0;
                    } else {
                        if (list.selectedIndex > 0) {
                            list.selectedIndex--;
                        }
                    }
                    list.options[list.selectedIndex].selected = true;
                    return !!(event && event.target && event.stopPropagation && (event.stopPropagation() === undefined));
                }
                return null;
            }

            function makeSelection(e) {
                var el = e.target;

                current_list_for_copy.value = el.value;
                current_list_for_copy.onkeyup = current_list_for_copy.old_onkeyup;
                current_list_for_copy.onchange = current_list_for_copy.old_onchange;
                current_list_for_copy.onkeypress = function () {
                };
                if (current_list_for_copy.onrealchange) {
                    current_list_for_copy.onrealchange(e);
                }
                if (current_list_for_copy.onchange) {
                    current_list_for_copy.onchange(e);
                }
                var al = $cms.dom.$id('ajax_list');
                al.parentNode.removeChild(al);
                window.setTimeout(function () {
                    current_list_for_copy.focus();
                }, 300);
            }
        }
    };

}(window.$cms));