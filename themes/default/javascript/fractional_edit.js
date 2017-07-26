'use strict';
(function ($cms) {
    'use strict';
    
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


    function fractionalEdit(event, object, url, rawText, editParamName, wasDoubleClick, controlButton, type) {
        wasDoubleClick = !!wasDoubleClick;
        type = strVal(type) || 'line';

        if (rawText.length > 255) {
            // Cannot process this
            return null;
        }

        if (!$cms.magicKeypress(event) && !wasDoubleClick && (object === event.target)) {
            return null;
        }

        event.stopPropagation();
        event.preventDefault();

        // Position form
        var width = object.offsetWidth;
        if (width < 160) {
            width = 160;
        }
        var x = $cms.dom.findPosX(object, true);
        var y = $cms.dom.findPosY(object, true) - 8;

        // Record old JS events
        object.old_onclick = object.onclick;
        object.old_ondblclick = object.ondblclick;
        object.old_onkeypress = object.onkeypress;

        // Create form
        var form = document.createElement('form'); // The form is never submitted actually: we use XMLHttpRequest
        form.method = 'post';
        form.action = url;
        form.style.display = 'inline';
        var populatedValue;
        if (object.raw_text !== undefined) {
            populatedValue = object.raw_text; // Our previous text edited in this JS session
        } else {
            object.raw_text = rawText;
            populatedValue = rawText; // What was in the DB when the screen loaded
        }
        var input;
        switch (type) {
            case 'line':
                input = document.createElement('input');
                input.setAttribute('maxlength', '255');
                input.value = populatedValue;
                break;
            case 'textarea':
                input = document.createElement('textarea');
                input.value = populatedValue;
                input.rows = '6';
                break;
            default:
                input = document.createElement('select');
                var listOptions = type.split('|');
                var listOption;
                for (var i = 0; i < listOptions.length; i++) {
                    listOption = document.createElement('option');
                    $cms.dom.html(listOption, $cms.filter.html(listOptions[i]));
                    listOption.selected = (populatedValue == listOptions[i]);
                    input.appendChild(listOption);
                }
                break;
        }
        input.style.position = 'absolute';
        input.style.left = $cms.$MOBILE() ? '0px' : (x + 'px');
        input.style.width = $cms.$MOBILE() ? ($cms.dom.getWindowWidth() + 'px') : (width + 'px');
        input.style.top = (y + 8) + 'px';
        input.style.margin = 0;

        var toCopy = ['font-size', 'font-weight', 'font-style'];
        if (type === 'line') {
            toCopy.push('border');
            toCopy.push('border-top');
            toCopy.push('border-right');
            toCopy.push('border-bottom');
            toCopy.push('border-left');
        }

        for (var i = 0; i < toCopy.length; i++) {
            var style = window.getComputedStyle(object.parentNode).getPropertyValue(toCopy[i]);
            if (style !== undefined) {
                input.style[toCopy[i]] = style;
            }
        }
        input.name = editParamName;
        form.onsubmit = function (event) {
            return false;
        };
        if (controlButton) {
            $cms.dom.html(controlButton, '{!SAVE;^}');
        }

        function cleanupFunction() {
            object.onclick = object.old_onclick;
            object.ondblclick = object.old_ondblclick;
            object.onkeypress = object.old_onkeypress;

            if (input.form.parentNode) {
                input.onblur = null; // So don't get recursion
                input.form.parentNode.removeChild(input.form);
            }

            if (controlButton) {
                $cms.dom.html(controlButton, '{!EDIT;^}');

                // To stop it instantly re-clicking
                var backup = controlButton.onclick;
                controlButton.onclick = function () {
                    return false;
                };
                setTimeout(function () {
                    controlButton.onclick = backup;
                }, 10);
            }
        }

        function cancelFunction() {
            cleanupFunction();

            $cms.ui.alert('{!FRACTIONAL_EDIT_CANCELLED;^}', null, '{!FRACTIONAL_EDIT;^}');

            return false;
        }

        function saveFunction() {
            // Call AJAX request
            $cms.doAjaxRequest(input.form.action, function (response) {
                // Some kind of error?
                if (((response.responseText == '') && (input.value != '')) || (response.status != 200)) {
                    var sessionTestUrl = '{$FIND_SCRIPT_NOHTTP;,confirm_session}';
                    /*TODO: Synchronous XHR*/
                    var sessionTestRet = $cms.doAjaxRequest(sessionTestUrl + $cms.keepStub(true));

                    if (sessionTestRet.responseText) { // If it failed, see if it is due to a non-confirmed session
                        $cms.ui.confirmSession(
                            function (result) {
                                if (result) {
                                    saveFunction();
                                } else {
                                    cleanupFunction();
                                }
                            }
                        );
                    } else {
                        cleanupFunction(); // Has to happen before, as that would cause defocus then refocus, causing a second save attempt

                        $cms.ui.alert((response.status == 500) ? response.responseText : '{!ERROR_FRACTIONAL_EDIT;^}', null, '{!FRACTIONAL_EDIT;^}');
                    }
                } else { // Success
                    object.raw_text = input.value;
                    $cms.dom.html(object, response.responseText);

                    cleanupFunction();
                }
            }, input.name + '=' + encodeURIComponent(input.value));

            return false;
        }

        // If we activate it again, we actually treat this as a cancellation
        object.onclick = object.ondblclick = function (event) {
            event.stopPropagation();
            if (event.cancelable) {
                event.preventDefault();
            }

            if ($cms.magicKeypress(event)) {
                cleanupFunction();
            }

            return false;
        };

        // Cancel or save actions
        if (type === 'line') {
            input.onkeyup = function (event) { // Not using onkeypress because that only works for actual represented characters in the input box

                if ($cms.dom.keyPressed(event, 'Escape')) { // Cancel (escape key)
                    var tmp = input.onblur;
                    input.onblur = null;
                    $cms.ui.confirm('{!javascript:FRACTIONAL_EDIT_CANCEL_CONFIRM;^}', function (result) {
                        if (result) {
                            cancelFunction();
                        } else {
                            input.focus();
                            input.onblur = tmp;
                        }
                    }, '{!CONFIRM_TEXT;^}');
                    return null;
                }

                if ($cms.dom.keyPressed(event, 'Enter') && (this.value != '')) { // Save
                    return saveFunction();
                }

                return null;
            };
        }
        input.onblur = function () {
            if (this.value != '' || rawText == '') {
                saveFunction();
            } else {
                cancelFunction();
            }
        };

        // Add in form
        form.appendChild(input);
        var websiteInner = document.body;
        websiteInner.appendChild(form);
        input.focus();
        if (input.select !== undefined) {
            input.select();
        }
        return false;
    }

}(window.$cms));
