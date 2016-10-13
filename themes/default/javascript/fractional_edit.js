"use strict";

function fractional_edit(event, object, url, raw_text, edit_param_name, was_double_click, control_button, type) {
    was_double_click = !!was_double_click;
    type || (type = 'line');

    if (raw_text.length > 255) {
        // Cannot process this
        return null;
    }

    if (!magic_keypress(event) && !was_double_click && (object === event.target)) {
        return null;
    }

    cancel_bubbling(event);
    if (event.cancelable) {
        event.preventDefault();
    }

    // Position form
    var width = object.offsetWidth;
    if (width < 160) {
        width = 160;
    }
    var x = find_pos_x(object, true);
    var y = find_pos_y(object, true) - 8;

    // Record old JS events
    object.old_onclick = object.onclick;
    object.old_ondblclick = object.ondblclick;
    object.old_onkeypress = object.onkeypress;

    // Create form
    var form = document.createElement('form'); // The form is never submitted actually: we use XMLHttpRequest
    form.method = 'post';
    form.action = url;
    form.style.display = 'inline';
    var populated_value;
    if (object.raw_text !== undefined) {
        populated_value = object.raw_text; // Our previous text edited in this JS session
    } else {
        object.raw_text = raw_text;
        populated_value = raw_text; // What was in the DB when the screen loaded
    }
    var input;
    switch (type) {
        case 'line':
            input = document.createElement('input');
            input.setAttribute('maxlength', '255');
            input.value = populated_value;
            break;
        case 'textarea':
            input = document.createElement('textarea');
            input.value = populated_value;
            input.rows = '6';
            break;
        default:
            input = document.createElement('select');
            var list_options = type.split('|');
            var list_option;
            for (var i = 0; i < list_options.length; i++) {
                list_option = document.createElement('option');
                $cms.dom.html(list_option, escape_html(list_options[i]));
                list_option.selected = (populated_value == list_options[i]);
                input.appendChild(list_option);
            }
            break;
    }
    input.style.position = 'absolute';

    input.style.left = $cms.$MOBILE ? '0px' : (x + 'px');
    input.style.width = $cms.$MOBILE ? (get_window_width() + 'px') : (width + 'px');

    input.style.top = (y + 8) + 'px';
    input.style.margin = 0;

    var to_copy = ['font-size', 'font-weight', 'font-style'];
    if (type === 'line') {
        to_copy.push('border');
        to_copy.push('border-top');
        to_copy.push('border-right');
        to_copy.push('border-bottom');
        to_copy.push('border-left');
    }

    for (var i = 0; i < to_copy.length; i++) {
        var style = window.getComputedStyle(object.parentNode).getPropertyValue(to_copy[i]);
        if (style !== undefined) {
            input.style[to_copy[i]] = style;
        }
    }
    input.name = edit_param_name;
    form.onsubmit = function (event) {
        return false;
    };
    if (control_button) {
        $cms.dom.html(control_button, '{!SAVE;^}');
    }

    function cleanup_function() {
        object.onclick = object.old_onclick;
        object.ondblclick = object.old_ondblclick;
        object.onkeypress = object.old_onkeypress;

        if (input.form.parentNode) {
            input.onblur = null; // So don't get recursion
            input.form.parentNode.removeChild(input.form);
        }

        if (control_button) {
            $cms.dom.html(control_button, '{!EDIT;^}');

            // To stop it instantly re-clicking
            var backup = control_button.onclick;
            control_button.onclick = function () {
                return false;
            };
            window.setTimeout(function () {
                control_button.onclick = backup;
            }, 10);
        }
    }

    function cancel_function() {
        cleanup_function();

        window.fauxmodal_alert('{!FRACTIONAL_EDIT_CANCELLED;^}', null, '{!FRACTIONAL_EDIT;^}');

        return false;
    }

    function save_function() {
        // Call AJAX request
        var response = do_ajax_request(input.form.action, null, input.name + '=' + encodeURIComponent(input.value));

        // Some kind of error?
        if (((response.responseText == '') && (input.value != '')) || (response.status != 200)) {
            var session_test_url = '{$FIND_SCRIPT_NOHTTP;,confirm_session}';
            var session_test_ret = do_ajax_request(session_test_url + keep_stub(true), null);

            if (session_test_ret.responseText) {// If it failed, see if it is due to a non-confirmed session
                confirm_session(
                    function (result) {
                        if (result) {
                            save_function();
                        } else {
                            cleanup_function();
                        }
                    }
                );
            } else {
                cleanup_function(); // Has to happen before, as that would cause defocus then refocus, causing a second save attempt

                window.fauxmodal_alert((response.status == 500) ? response.responseText : '{!ERROR_FRACTIONAL_EDIT;^}', null, '{!FRACTIONAL_EDIT;^}');
            }
        } else {// Success
            object.raw_text = input.value;
            $cms.dom.html(object, response.responseText);

            cleanup_function();
        }

        return false;
    }

    // If we activate it again, we actually treat this as a cancellation
    object.onclick = object.ondblclick = function (event) {
        cancel_bubbling(event);
        if (event.cancelable) {
            event.preventDefault();
        }

        if (magic_keypress(event)) {
            cleanup_function();
        }

        return false;
    };

    // Cancel or save actions
    if (type === 'line') {
        input.onkeyup = function (event) {// Not using onkeypress because that only works for actual represented characters in the input box

            if ($cms.dom.keyPressed(event, 'Escape')) {// Cancel (escape key)
                var tmp = input.onblur;
                input.onblur = null;
                fauxmodal_confirm('{!javascript:FRACTIONAL_EDIT_CANCEL_CONFIRM;^}', function (result) {
                    if (result) {
                        cancel_function();
                    } else {
                        input.focus();
                        input.onblur = tmp;
                    }
                }, '{!CONFIRM_TEXT;^}');
                return null;
            }

            if (enter_pressed(event) && (this.value != '')) {// Save
                return save_function();
            }

            return null;
        };
    }
    input.onblur = function () {
        if (this.value != '' || raw_text == '') {
            save_function();
        } else {
            cancel_function();
        }
    };

    // Add in form
    form.appendChild(input);
    var website_inner = document.body;
    website_inner.appendChild(form);
    input.focus();
    if (input.select !== undefined) {
        input.select();
    }
    return false;
}

