/* Ideally this template should not be edited. See the note at the bottom of how JAVASCRIPT_CUSTOM_GLOBALS.tpl is appended to this template */
'use strict';

if (window.unloaded === undefined) {
    window.unloaded = false; // Serves as a flag to indicate any new errors are probably due to us transitioning
}
window.addEventListener('beforeunload', function () {
    window.unloaded = true;
});

/* Screen transition, for staff */
function staff_unload_action() {
    undo_staff_unload_action();

    // If clicking a download link then don't show the animation
    if (document.activeElement && typeof document.activeElement.href != 'undefined' && document.activeElement.href != null) {
        var url = document.activeElement.href.replace(/.*:\/\/[^\/:]+/, '');
        if (url.indexOf('download') != -1 || url.indexOf('export') != -1)
            return;
    }

    // If doing a meta refresh then don't show the animation
    if ((typeof document.querySelector != 'undefined') && document.querySelector('meta[http-equiv="Refresh"]')) {
        return;
    }

    // Show the animation
    var bi = document.getElementById('main_website_inner');
    if (bi) {
        bi.className += ' site_unloading';
        fade_transition(bi, 20, 30, -4);
    }
    var div = document.createElement('div');
    div.className = 'unload_action';
    div.style.width = '100%';
    div.style.top = (get_window_height() / 2 - 160) + 'px';
    div.style.position = 'fixed';
    div.style.zIndex = 10000;
    div.style.textAlign = 'center';
    Composr.dom.html(div, '<div aria-busy="true" class="loading_box box"><h2>{!LOADING;^}</h2><img id="loading_image" alt="" src="' + '{$IMG_INLINE*;,loading}'.replace(/^https?:/, window.location.protocol) + '" /></div>');
    window.setTimeout(function () {
        if (document.getElementById('loading_image')) document.getElementById('loading_image').src += '';
    }, 100); // Stupid workaround for Google Chrome not loading an image on unload even if in cache
    document.body.appendChild(div);

    // Allow unloading of the animation
    window.addEventListener('pageshow', undo_staff_unload_action);
    window.addEventListener('keydown', undo_staff_unload_action);
    window.addEventListener('click', undo_staff_unload_action);
}

function undo_staff_unload_action() {
    var pre = document.body.querySelectorAll('.unload_action');
    for (var i = 0; i < pre.length; i++) {
        pre[i].parentNode.removeChild(pre[i]);
    }
    var bi = document.getElementById('main_website_inner');
    if (bi) {
        if (window.fade_transition_timers[bi.fader_key]) {
            window.clearTimeout(window.fade_transition_timers[bi.fader_key]);
            window.fade_transition_timers[bi.fader_key] = null;
        }
        bi.className = bi.className.replace(/ site_unloading/g, '');
    }
}

function placeholder_focus(ob, def) {
    if (typeof def == 'undefined') def = ob.defaultValue;
    if (ob.value == def) {
        ob.value = '';
    }
    ob.className = ob.className.replace('field_input_non_filled', 'field_input_filled');
}

function placeholder_blur(ob, def) {
    if (typeof def == 'undefined') def = ob.defaultValue;
    if (ob.value == '') {
        ob.value = def;
    }
    if (ob.value == def) {
        ob.className = ob.className.replace('field_input_filled', 'field_input_non_filled');
    }
}

/* Very simple form control flow */
function check_field_for_blankness(field, event) {
    if (!field) return true; // Shame we need this, seems on Google Chrome things can get confused on JS assigned to page-changing events
    if (typeof field.nodeName == 'undefined') return true; // Also bizarre

    var value;
    if (field.localName === 'select') {
        value = field.options[field.selectedIndex].value;
    } else {
        value = field.value;
    }

    var ee = document.getElementById('error_' + field.id);

    if ((value.replace(/\s/g, '') === '') || (value === '****') || (value === '{!POST_WARNING;^}') || (value === '{!THREADED_REPLY_NOTICE;^,{!POST_WARNING}}')) {
        if (event) {
            cancel_bubbling(event);
        }

        if (ee !== null) {
            ee.style.display = 'block';
            Composr.dom.html(ee, '{!REQUIRED_NOT_FILLED_IN;^}');
        }

        window.fauxmodal_alert('{!IMPROPERLY_FILLED_IN;^}');
        return false;
    }

    if (ee !== null) {
        ee.style.display = 'none';
    }

    return true;
}
function disable_button_just_clicked(input, permanent) {
    if (typeof permanent == 'undefined') permanent = false;

    if (input.localName === 'form') {
        for (var i = 0; i < input.elements.length; i++) {
            if ((input.elements[i].type == 'submit') || (input.elements[i].type == 'button') || (input.elements[i].type == 'image') || (input.elements[i].localName === 'button')) {
                disable_button_just_clicked(input.elements[i]);
            }
        }
        return;
    }

    if (input.form.target == '_blank') return;

    window.setTimeout(function () {
        input.disabled = true;
        input.under_timer = true;
    }, 20);
    input.style.cursor = 'wait';
    if (!permanent) {
        var goback = function () {
            if (input.under_timer) {
                input.disabled = false;
                input.under_timer = false;
                input.style.cursor = 'default';
            }
        };
        window.setTimeout(goback, 5000);
    } else input.under_timer = false;

    window.addEventListener('pagehide', goback);
}

/* Making the height of a textarea match its contents */
function manage_scroll_height(ob) {
    var height = ob.scrollHeight;
    if ((height > 5) && (sts(ob.style.height) < height) && (ob.offsetHeight < height)) {
        ob.style.height = height + 'px';
        ob.style.boxSizing = 'border-box';
        ob.style.overflowY = 'hidden';
        trigger_resize();
    }
}

/* Ask a user a question: they must click a button */
// 'Cancel' should come as index 0 and Ok/default-option should come as index 1. This is so that the fallback works right.
function generate_question_ui(message, button_set, window_title, fallback_message, callback, dialog_width, dialog_height) {
    var image_set = [];
    var new_button_set = [];
    for (var s in button_set) {
        new_button_set.push(button_set[s]);
        image_set.push(s);
    }
    button_set = new_button_set;

    if ((typeof window.showModalDialog != 'undefined')/*{+START,IF,{$CONFIG_OPTION,js_overlays}}*/ || true/*{+END}*/) {
        if (button_set.length > 4) dialog_height += 5 * (button_set.length - 4);

        // Intentionally FIND_SCRIPT and not FIND_SCRIPT_NOHTTP, because no needs-HTTPS security restriction applies to popups, yet popups do not know if they run on HTTPS if behind a transparent reverse proxy
        var url = maintain_theme_in_link('{$FIND_SCRIPT;,question_ui}?message=' + window.encodeURIComponent(message) + '&image_set=' + window.encodeURIComponent(image_set.join(',')) + '&button_set=' + window.encodeURIComponent(button_set.join(',')) + '&window_title=' + window.encodeURIComponent(window_title) + keep_stub());
        if (typeof dialog_width == 'undefined') dialog_width = 440;
        if (typeof dialog_height == 'undefined') dialog_height = 180;
        window.faux_showModalDialog(
            url,
            null,
            'dialogWidth=' + dialog_width + ';dialogHeight=' + dialog_height + ';status=no;unadorned=yes',
            function (result) {
                if ((typeof result == 'undefined') || (result === null)) {
                    callback(button_set[0]); // just pressed 'cancel', so assume option 0
                } else {
                    callback(result);
                }
            }
        );

        return;
    }

    if (button_set.length == 1) {
        window.fauxmodal_alert(
            fallback_message ? fallback_message : message,
            function () {
                callback(button_set[0]);
            },
            window_title
        );
    } else if (button_set.length == 2) {
        window.fauxmodal_confirm(
            fallback_message ? fallback_message : message,
            function (result) {
                callback(result ? button_set[1] : button_set[0]);
            },
            window_title
        );
    } else {
        if (!fallback_message) {
            message += '\n\n{!INPUTSYSTEM_TYPE_EITHER;^}';
            for (var i = 0; i < button_set.length; i++) {
                message += button_set[i] + ',';
            }
            message = message.substr(0, message.length - 1);
        } else message = fallback_message;

        window.fauxmodal_prompt(
            message,
            '',
            function (result) {
                if ((typeof result == 'undefined') || (result === null)) {
                    callback(button_set[0]); // just pressed 'cancel', so assume option 0
                    return;
                } else {
                    if (result == '') {
                        callback(button_set[1]); // just pressed 'ok', so assume option 1
                        return;
                    }
                    for (var i = 0; i < button_set.length; i++) {
                        if (result.toLowerCase() == button_set[i].toLowerCase()) // match
                        {
                            callback(result);
                            return;
                        }
                    }
                }

                // unknown
                callback(button_set[0]);
            },
            window_title
        );
    }
}

/* Find the main Composr window */
function get_main_cms_window(any_large_ok) {
    if (typeof any_large_ok == 'undefined') {
        any_large_ok = false;
    }

    if (document.getElementById('main_website')) return window;

    if ((any_large_ok) && (get_window_width() > 300)) return window;

    try {
        if ((window.parent) && (window.parent != window) && (typeof window.parent.get_main_cms_window != 'undefined')) return window.parent.get_main_cms_window();
    }
    catch (e) {
    }
    try {
        if ((window.opener) && (typeof window.opener.get_main_cms_window != 'undefined')) return window.opener.get_main_cms_window();
    }
    catch (e) {
    }
    return window;
}

/* Do-next document tooltips */
function doc_onmouseout() {
    if (typeof window.orig_helper_text != 'undefined') {
        var help = document.getElementById('help');
        if (!help) return; // In zone editor, probably
        Composr.dom.html(help, window.orig_helper_text);
        set_opacity(help, 0.0);
        fade_transition(help, 100, 30, 4);
        help.className = 'global_helper_panel_text';
    }
}
function doc_onmouseover(i) {
    var doc = document.getElementById('doc_' + i);
    if ((doc) && (Composr.dom.html(doc) != '')) {
        var help = document.getElementById('help');
        if (!help) return; // In zone editor, probably
        window.orig_helper_text = Composr.dom.html(help);
        Composr.dom.html(help, Composr.dom.html(doc));
        set_opacity(help, 0.0);
        fade_transition(help, 100, 30, 4);

        help.className = 'global_helper_panel_text_over';
    }
}

// The help panel
function helper_panel(show) {
    var panel_right = document.getElementById('panel_right');
    var middles = document.querySelectorAll('.global_middle');
    var global_message = document.getElementById('global_message');
    var helper_panel_contents = document.getElementById('helper_panel_contents');
    var helper_panel_toggle = document.getElementById('helper_panel_toggle');
    var i;
    if (show) {
        panel_right.className = panel_right.className.replace(/ helper_panel_hidden/g, '');

        helper_panel_contents.setAttribute('aria-expanded', 'true');
        helper_panel_contents.style.display = 'block';
        set_opacity(helper_panel_contents, 0.0);
        fade_transition(helper_panel_contents, 100, 30, 4);

        if (read_cookie('hide_helper_panel') == '1') set_cookie('hide_helper_panel', '0', 100);
        helper_panel_toggle.onclick = function () {
            return helper_panel(false);
        };
        helper_panel_toggle.childNodes[0].src = '{$IMG;,icons/14x14/helper_panel_hide}'.replace(/^https?:/, window.location.protocol);
        if (typeof helper_panel_toggle.childNodes[0].srcset != 'undefined')
            helper_panel_toggle.childNodes[0].srcset = '{$IMG;,icons/28x28/helper_panel_hide} 2x'.replace(/^https?:/, window.location.protocol);
    } else {
        if (read_cookie('hide_helper_panel') == '') {
            window.fauxmodal_confirm(
                '{!CLOSING_HELP_PANEL_CONFIRM;^}',
                function (answer) {
                    if (answer)
                        _hide_helper_panel(middles, panel_right, global_message, helper_panel_contents, helper_panel_toggle);
                }
            );
            return false;
        }
        _hide_helper_panel(middles, panel_right, global_message, helper_panel_contents, helper_panel_toggle);
    }
    return false;
}
function _hide_helper_panel(middles, panel_right, global_message, helper_panel_contents, helper_panel_toggle) {
    panel_right.className += ' helper_panel_hidden';
    helper_panel_contents.setAttribute('aria-expanded', 'false');
    helper_panel_contents.style.display = 'none';
    set_cookie('hide_helper_panel', '1', 100);
    helper_panel_toggle.onclick = function () {
        return helper_panel(true);
    };
    helper_panel_toggle.childNodes[0].src = '{$IMG;,icons/14x14/helper_panel_show}'.replace(/^https?:/, window.location.protocol);
    if (typeof helper_panel_toggle.childNodes[0].srcset != 'undefined')
        helper_panel_toggle.childNodes[0].srcset = '{$IMG;,icons/28x28/helper_panel_show} 2x'.replace(/^https?:/, window.location.protocol);
}

/* Find the size of a dimensions in pixels without the px (not general purpose, just to simplify code) */
function sts(src) {
    if (!src) return 0;
    if (src.indexOf('px') == -1) return 0;
    return window.parseInt(src.replace('px', ''));
}

/* Find if the user performed the Composr "magic keypress" to initiate some action */
function capture_click_key_states(event) {
    window.capture_event = event;
}
function magic_keypress(event) {
    // Cmd+Shift works on Mac - cannot hold down control or alt in Mac firefox at least
    if (window.capture_event !== undefined) event = window.capture_event;
    var count = 0;
    if (event.shiftKey) count++;
    if (event.ctrlKey) count++;
    if (event.metaKey) count++;
    if (event.altKey) count++;

    return (count >= 2);
}

/* Data escaping */
function escape_html(value) {
    if (!value) return '';
    return value.replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(new RegExp('<', 'g')/* For CDATA embedding else causes weird error */, '&lt;').replace(/>/g, '&gt;');
}
function escape_comcode(value) {
    return value.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

/* Image rollover effects */
function create_rollover(rand, rollover) {
    var img = document.getElementById(rand);
    if (!img) return;
    new Image().src = rollover; // precache
    var activate = function () {
        img.old_src = img.getAttribute('src');
        if (typeof img.origsrc != 'undefined') img.old_src = img.origsrc;
        img.setAttribute('src', rollover);
    };
    var deactivate = function () {
        img.setAttribute('src', img.old_src);
    };
    img.addEventListener('mouseover', activate);
    img.addEventListener('click', deactivate);
    img.addEventListener('mouseout', deactivate);
}

/* Cookies */
function set_cookie(cookie_name, cookie_value, num_days) {
    var today = new Date();
    var expire = new Date();
    if (num_days == null || num_days == 0) num_days = 1;
    expire.setTime(today.getTime() + 3600000 * 24 * num_days);
    var extra = '';
    if ('{$COOKIE_PATH;}' != '') extra = extra + ';path={$COOKIE_PATH;}';
    if ('{$COOKIE_DOMAIN;}' != '') extra = extra + ';domain={$COOKIE_DOMAIN;}';
    var to_set = cookie_name + '=' + window.encodeURIComponent(cookie_value) + ';expires=' + expire.toUTCString() + extra;
    document.cookie = to_set;
    var read = read_cookie(cookie_name);
    if ((read != cookie_value) && (read)) {
        /*{+START,IF,{$DEV_MODE}}*/
        if (!window.done_cookie_alert) window.fauxmodal_alert('{!COOKIE_CONFLICT_DELETE_COOKIES;^}' + '... ' + document.cookie + ' (' + to_set + ')', null, '{!ERROR_OCCURRED;^}');
        /*{+END}*/
        window.done_cookie_alert = true;
    }
}
function read_cookie(cookie_name, defaultValue) {
    var theCookie = '' + document.cookie;
    var ind = theCookie.indexOf(' ' + cookie_name + '=');
    if ((ind == -1) && (theCookie.substr(0, cookie_name.length + 1) == cookie_name + '=')) ind = 0; else if (ind != -1) ind++;
    if (ind == -1 || cookie_name == '') return defaultValue;
    var ind1 = theCookie.indexOf(';', ind);
    if (ind1 == -1) ind1 = theCookie.length;
    return window.decodeURIComponent(theCookie.substring(ind + cookie_name.length + 1, ind1));
}

/* Type checking */
function is_integer(val) {
    if (val == '') return false;
    var c;
    for (var i = 0; i < val.length; i++) {
        c = val.charAt(i);
        if ((c != '0') && (c != '1') && (c != '2') && (c != '3') && (c != '4') && (c != '5') && (c != '6') && (c != '7') && (c != '8') && (c != '9'))
            return false;
    }
    return true;
}

/* Browser sniffing */
function browser_matches(code) {
    var browser = navigator.userAgent.toLowerCase();
    var os = navigator.platform.toLowerCase() + ' ' + browser;

    var is_safari = browser.indexOf('applewebkit') != -1;
    var is_chrome = browser.indexOf('chrome/') != -1;
    var is_gecko = (browser.indexOf('gecko') != -1) && !is_safari;
    var _is_ie = ((browser.indexOf('msie') != -1) || (browser.indexOf('trident') != -1));
    var is_ie_8 = (browser.indexOf('msie 8') != -1) && (_is_ie);
    var is_ie_8_plus = is_ie_8;
    var is_ie_9 = (browser.indexOf('msie 9') != -1) && (_is_ie);
    var is_ie_9_plus = is_ie_9 && !is_ie_8;

    switch (code) {
        case 'non_concurrent':
            return browser.indexOf('iphone') != -1 || browser.indexOf('ipad') != -1 || browser.indexOf('android') != -1 || browser.indexOf('phone') != -1 || browser.indexOf('tablet') != -1;
        case 'ios':
            return browser.indexOf('iphone') != -1 || browser.indexOf('ipad') != -1;
        case 'android':
            return browser.indexOf('android') != -1;
        case 'wysiwyg':
            if ('{$CONFIG_OPTION,wysiwyg}' == '0') return false;
            return true;
        case 'windows':
            return os.indexOf('windows') != -1 || os.indexOf('win32') != -1;
        case 'mac':
            return os.indexOf('mac') != -1;
        case 'linux':
            return os.indexOf('linux') != -1;
        case 'ie':
            return _is_ie;
        case 'ie8':
            return is_ie_8;
        case 'ie8+':
            return is_ie_8_plus;
        case 'ie9':
            return is_ie_9;
        case 'ie9+':
            return is_ie_9_plus;
        case 'chrome':
            return is_chrome;
        case 'gecko':
            return is_gecko;
        case 'safari':
            return is_safari;
    }

    // Should never get here
    return false;
}

/* Safe way to get the base URL */
function get_base_url() {
    return (window.location + '').replace(/(^.*:\/\/[^\/]*)\/.*/, '$1') + '{$BASE_URL_NOHTTP;}'.replace(/^.*:\/\/[^\/]*/, '');
}

/* Enforcing a session using AJAX */
function confirm_session(callback) {
    if (typeof window.do_ajax_request == 'undefined') return;

    var url = '{$FIND_SCRIPT_NOHTTP;,confirm_session}' + keep_stub(true);

    // First see if session already established
    require_javascript('ajax', window.do_ajax_request);
    if (typeof window.do_ajax_request == 'undefined') return;
    var ret = do_ajax_request(url + keep_stub(true), function (ret) {
        if (!ret) return;

        if (ret.responseText === '') // Blank means success, no error - so we can call callback
        {
            callback(true);
            return;
        }

        // But non blank tells us the username, and there is an implication that no session is confirmed for this login

        if (ret.responseText == '{!GUEST;}') // Hmm, actually whole login was lost, so we need to ask for username too
        {
            window.fauxmodal_prompt(
                '{!USERNAME;^}',
                '',
                function (promptt) {
                    _confirm_session(callback, promptt, url);
                },
                '{!_LOGIN;}'
            );
            return;
        }

        _confirm_session(callback, ret.responseText, url);
    });
}
function _confirm_session(callback, username, url) {
    window.fauxmodal_prompt(
        '{$?,{$NOT,{$CONFIG_OPTION,js_overlays}},{!ENTER_PASSWORD_JS;^},{!ENTER_PASSWORD_JS_2;^}}',
        '',
        function (promptt) {
            if (promptt !== null) {
                do_ajax_request(url, function (ret) {
                    if (ret && ret.responseText === '') // Blank means success, no error - so we can call callback
                        callback(true);
                    else
                        _confirm_session(callback, username, url); // Recurse
                }, 'login_username=' + window.encodeURIComponent(username) + '&password=' + window.encodeURIComponent(promptt));
            } else callback(false);
        },
        '{!_LOGIN;}',
        'password'
    );
}

/* Dynamic inclusion */
function load_snippet(snippet_hook, post, callback) {
    var title = Composr.dom.html(document.getElementsByTagName('title')[0]);
    title = title.replace(/ \u2013 .*/, '');
    var metas = document.getElementsByTagName('link');
    var i;
    if (!window.location) return null; // In middle of page navigation away
    var url = window.location.href;
    for (i = 0; i < metas.length; i++) {
        if (metas[i].getAttribute('rel') == 'canonical') url = metas[i].getAttribute('href');
    }
    if (!url) url = window.location.href;
    var html;
    if (typeof window.do_ajax_request != 'undefined') {
        var url2 = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=' + snippet_hook + '&url=' + window.encodeURIComponent(url) + '&title=' + window.encodeURIComponent(title) + keep_stub();
        html = do_ajax_request(maintain_theme_in_link(url2), callback, post);
    }
    if (callback) return null;
    return html.responseText;
}
function require_css(sheet) {
    if (document.getElementById('loading_css_' + sheet)) return;
    var link = document.createElement('link');
    link.setAttribute('id', 'loading_css_' + sheet);
    link.setAttribute('type', 'text/css');
    link.setAttribute('rel', 'stylesheet');
    link.setAttribute('href', '{$FIND_SCRIPT_NOHTTP;,sheet}?sheet=' + sheet + keep_stub());
    document.getElementsByTagName('head')[0].appendChild(link);
}
function require_javascript(script, detector) {
    // Check it is not already loading
    if (document.getElementById('loading_js_' + script)) return;

    // Check it is already loaded
    if (typeof detector != 'undefined') return; // Some object reference into the file passed in was defined, so the file must have been loaded already

    // Load it
    var s = document.createElement('script');
    s.setAttribute('id', 'loading_js_' + script);
    s.setAttribute('type', 'text/javascript');
    var url = '{$FIND_SCRIPT_NOHTTP;,javascript}?script=' + script + keep_stub();
    s.src = url;
    document.head.appendChild(s);
}

/* Tabs */
function find_url_tab(hash) {
    if (typeof hash == 'undefined') hash = window.location.hash;

    if (hash.replace(/^#/, '') != '') {
        var tab = hash.replace(/^#/, '').replace(/^tab\_\_/, '');

        if (document.getElementById('g_' + tab)) {
            select_tab('g', tab);
        }
        else if ((tab.indexOf('__') != -1) && (document.getElementById('g_' + tab.substr(0, tab.indexOf('__'))))) {
            var old = hash;
            select_tab('g', tab.substr(0, tab.indexOf('__')));
            window.location.hash = old;
        }
    }
}
function select_tab(id, tab, from_url, automated) {
    if (typeof from_url == 'undefined') from_url = false;
    if (typeof automated == 'undefined') automated = false;

    if (!from_url) {
        var tab_marker = document.getElementById('tab__' + tab.toLowerCase());
        if (tab_marker) {
            // For URL purposes, we will change URL to point to tab
            // HOWEVER, we do not want to cause a scroll so we will be careful
            tab_marker.id = '';
            window.location.hash = '#tab__' + tab.toLowerCase();
            tab_marker.id = 'tab__' + tab.toLowerCase();
        }
    }

    var tabs = [];
    var i, element;
    element = document.getElementById('t_' + tab);
    for (i = 0; i < element.parentNode.childNodes.length; i++) {
        if ((element.parentNode.childNodes[i].id) && (element.parentNode.childNodes[i].id.substr(0, 2) == 't_'))
            tabs.push(element.parentNode.childNodes[i].id.substr(2));
    }

    for (i = 0; i < tabs.length; i++) {
        element = document.getElementById(id + '_' + tabs[i]);
        if (element) {
            element.style.display = (tabs[i] == tab) ? 'block' : 'none';

            if (tabs[i] == tab) {
                if (window['load_tab__' + tab] === undefined) {
                    set_opacity(element, 0.0);
                    fade_transition(element, 100, 30, 8);
                }
            }
        }

        element = document.getElementById('t_' + tabs[i]);
        if (element) {
            if (element.className.indexOf('tab_active') != -1)
                element.className = element.className.replace(/ ?tab_active/g, '');
            if (tabs[i] == tab)    element.className += ' tab_active';
        }
    }

    if (typeof window['load_tab__' + tab] != 'undefined') window['load_tab__' + tab](automated, document.getElementById(id + '_' + tab)); // Usually an AJAX loader

    return false;
}

/* Hiding/Showing of collapsed sections */
function set_display_with_aria(element, mode) {
    element.style.display = mode;
    element.setAttribute('aria-hidden', (mode == 'none') ? 'true' : 'false');
}
function matches_theme_image(src, url) {
    return (src.replace(/^https?:/, window.location.protocol) == url.replace(/^https?:/, window.location.protocol));
}
function set_tray_theme_image(pic, before_theme_img, after_theme_img, before1_url, after1_url, after1_url_2x, after2_url, after2_url_2x) {
    var is_1 = matches_theme_image(pic.src, before1_url);

    if (is_1) {
        if (pic.src.indexOf('themewizard.php') != -1) {
            pic.src = pic.src.replace(before_theme_img, after_theme_img);
        } else {
            pic.src = after1_url.replace(/^https?:/, window.location.protocol);
        }
    } else {
        if (pic.src.indexOf('themewizard.php') != -1) {
            pic.src = pic.src.replace(before_theme_img + '2', after_theme_img + '2');
        } else {
            pic.src = after2_url.replace(/^https?:/, window.location.protocol);
        }
    }

    if (typeof pic.srcset != 'undefined') {
        if (is_1) {
            if (pic.srcset.indexOf('themewizard.php') != -1) {
                pic.srcset = pic.srcset.replace(before_theme_img, after_theme_img);
            } else {
                pic.srcset = after1_url_2x.replace(/^https?:/, window.location.protocol);
            }
        } else {
            if (pic.srcset.indexOf('themewizard.php') != -1) {
                pic.srcset = pic.srcset.replace(before_theme_img + '2', after_theme_img + '2');
            } else {
                pic.srcset = after2_url_2x.replace(/^https?:/, window.location.protocol);
            }
        }
    }
}
function toggleable_tray(element, no_animate, cookie_id_name) {
    if (typeof element === 'string') {
        element = document.getElementById(element);
    }

    if (!element) {
        return;
    }

    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations)) {
        no_animate = true;
    }

    if (!element.classList.contains('toggleable_tray')) {// Suspicious, maybe we need to probe deeper
        element = Composr.dom.$(element, '.toggleable_tray') || element;
    }

    if (element.dataset.trayCookie !== undefined) {
        cookie_id_name = element.dataset.trayCookie;
    }

    if (cookie_id_name !== undefined) {
        set_cookie('tray_' + cookie_id_name, (element.style.display == 'none') ? 'open' : 'closed');
    }

    var type = 'block';
    if (element.localName === 'table') {
        type = 'table';
    } else if (element.localName === 'tr') {
        type = 'table-row';
    }

    var pic = Composr.dom.$(element.parentNode, '.toggleable_tray_button img') || Composr.dom.$('#e_' + element.id);

    if (pic) {// Currently in action?
        if (matches_theme_image(pic.src, '{$IMG;,1x/trays/expcon}')) return;
        if (matches_theme_image(pic.src, '{$IMG;,1x/trays/expcon2}')) return;
    }

    element.setAttribute('aria-expanded', (type === 'none') ? 'false' : 'true');

    if (element.style.display === 'none') {
        element.style.display = type;
        if ((type === 'block') && (element.localName === 'div') && (!no_animate) && ((!pic) || (pic.src.indexOf('themewizard.php') == -1))) {
            element.style.visibility = 'hidden';
            element.style.width = element.offsetWidth + 'px';
            element.style.position = 'absolute'; // So things do not just around now it is visible
            if (pic) {
                set_tray_theme_image(pic, 'expand', 'expcon', '{$IMG;,1x/trays/expand}', '{$IMG;,1x/trays/expcon}', '{$IMG;,2x/trays/expcon}', '{$IMG;,1x/trays/expcon2}', '{$IMG;,2x/trays/expcon2}');
            }
            window.setTimeout(function () {
                begin_toggleable_tray_animation(element, 20, 70, -1, pic);
            }, 20);
        } else {
            set_opacity(element, 0.0);
            fade_transition(element, 100, 30, 4);

            if (pic) {
                set_tray_theme_image(pic, 'expand', 'contract', '{$IMG;,1x/trays/expand}', '{$IMG;,1x/trays/contract}', '{$IMG;,2x/trays/contract}', '{$IMG;,1x/trays/contract2}', '{$IMG;,2x/trays/contract2}');
            }
        }
    } else {
        if ((type === 'block') && (element.localName === 'div') && (!no_animate) && ((!pic) || (pic.src.indexOf('themewizard.php') == -1))) {
            if (pic) {
                set_tray_theme_image(pic, 'contract', 'expcon', '{$IMG;,1x/trays/contract}', '{$IMG;,1x/trays/expcon}', '{$IMG;,2x/trays/expcon}', '{$IMG;,1x/trays/expcon2}', '{$IMG;,2x/trays/expcon2}');
            }
            window.setTimeout(function () {
                begin_toggleable_tray_animation(element, -20, 70, 0, pic);
            }, 20);
        } else {
            if (pic) {
                set_tray_theme_image(pic, 'contract', 'expand', '{$IMG;,1x/trays/contract}', '{$IMG;,1x/trays/expand}', '{$IMG;,2x/trays/expand}', '{$IMG;,1x/trays/expand2}', '{$IMG;,2x/trays/expand2}');
                pic.setAttribute('alt', pic.getAttribute('alt').replace('{!CONTRACT;}', '{!EXPAND;}'));
                pic.title = '{!EXPAND;}'; // Needs doing because convert_tooltip may not have run yet
                pic.cms_tooltip_title = '{!EXPAND;}';
            }
            element.style.display = 'none';
        }
    }

    trigger_resize(true);

    return false;
}
function begin_toggleable_tray_animation(element, animate_dif, animate_ticks, final_height, pic) {
    var full_height = Composr.dom.contentHeight(element);
    if (final_height == -1) // We are animating to full height - not a fixed height
    {
        final_height = full_height;
        element.style.height = '0px';
        element.style.visibility = 'visible';
        element.style.position = 'static';
    }
    if (full_height > 300) // Quick finish in the case of huge expand areas
    {
        toggleable_tray_done(element, final_height, animate_dif, 'hidden', animate_ticks, pic);
        return;
    }
    element.style.outline = '1px dashed gray';

    if (final_height == 0) {
        set_opacity(element, 1.0);
        fade_transition(element, 0, 30, 4);
    } else {
        set_opacity(element, 0.0);
        fade_transition(element, 100, 30, 4);
    }

    var orig_overflow = element.style.overflow;
    element.style.overflow = 'hidden';
    window.setTimeout(function () {
        toggleable_tray_animate(element, final_height, animate_dif, orig_overflow, animate_ticks, pic);
    }, animate_ticks);
}
function toggleable_tray_animate(element, final_height, animate_dif, orig_overflow, animate_ticks, pic) {
    var current_height = ((element.style.height == 'auto') || (element.style.height == '')) ? element.offsetHeight : sts(element.style.height);
    if (((current_height > final_height) && (animate_dif < 0)) || ((current_height < final_height) && (animate_dif > 0))) {
        var num = Math.max(current_height + animate_dif, 0);
        if (animate_dif > 0) num = Math.min(num, final_height);
        element.style.height = num + 'px';
        window.setTimeout(function () {
            toggleable_tray_animate(element, final_height, animate_dif, orig_overflow, animate_ticks, pic);
        }, animate_ticks);
    } else {
        toggleable_tray_done(element, final_height, animate_dif, orig_overflow, animate_ticks, pic);
    }
}
function toggleable_tray_done(element, final_height, animate_dif, orig_overflow, animate_ticks, pic) {
    element.style.height = 'auto';
    if (animate_dif < 0) {
        element.style.display = 'none';
    }
    element.style.overflow = orig_overflow;
    element.style.outline = '0';
    if (pic) {
        if (animate_dif < 0) {
            set_tray_theme_image(pic, 'expcon', 'expand', '{$IMG;,1x/trays/expcon}', '{$IMG;,1x/trays/expand}', '{$IMG;,2x/trays/expand}', '{$IMG;,1x/trays/expand2}', '{$IMG;,2x/trays/expand2}');
        } else {
            set_tray_theme_image(pic, 'expcon', 'contract', '{$IMG;,1x/trays/expcon}', '{$IMG;,1x/trays/contract}', '{$IMG;,2x/trays/contract}', '{$IMG;,1x/trays/contract2}', '{$IMG;,2x/trays/contract2}');
        }
        pic.setAttribute('alt', pic.getAttribute('alt').replace((animate_dif < 0) ? '{!CONTRACT;}' : '{!EXPAND;}', (animate_dif < 0) ? '{!EXPAND;}' : '{!CONTRACT;}'));
        pic.cms_tooltip_title = (animate_dif < 0) ? '{!EXPAND;}' : '{!CONTRACT;}';
    }
    trigger_resize(true);
}


/* Animate the loading of a frame */
function animate_frame_load(pf, frame, leave_gap_top, leave_height) {
    if (!pf) return;
    if (leave_gap_top === undefined) leave_gap_top = 0;
    if (leave_height === undefined) leave_height = false;

    if (!leave_height){
        // Enough to stop jumping around
        pf.style.height = window.top.get_window_height() + 'px';
    }

    illustrate_frame_load(frame);

    var ifuob = window.top.document.getElementById('iframe_under');
    var extra = ifuob ? ((window != window.top) ? find_pos_y(ifuob) : 0) : 0;
    if (ifuob) {
        ifuob.scrolling = 'no';
    }

    if (window === window.top) {
        window.top.smooth_scroll(find_pos_y(pf) + extra - leave_gap_top);
    }
}

function illustrate_frame_load(iframeId) {
    var head, cssText = '', i, iframe = document.getElementById(iframeId), doc, de;

    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations) || !iframe || !iframe.contentDocument || !iframe.contentDocument.documentElement) {
        return;
    }

    doc = iframe.contentDocument;
    de = doc.documentElement;

    head = '<style>';

    for (i = 0; i < document.styleSheets.length; i++) {
        try {
            if (document.styleSheets[i].href && !document.styleSheets[i].href.includes('/global') && !document.styleSheets[i].href.includes('/merged')) {
                continue;
            }

            if (document.styleSheets[i].cssText !== undefined) {
                cssText += document.styleSheets[i].cssText;
            } else {
                var rules = [];
                try {
                    rules = document.styleSheets[i].cssRules ? document.styleSheets[i].cssRules : document.styleSheets[i].rules;
                } catch (ignore) {
                }

                if (rules) {
                    for (var j = 0; j < rules.length; j++) {
                        if (rules[j].cssText){
                            cssText += rules[j].cssText + '\n\n';
                        } else {
                            cssText += rules[j].selectorText + '{ ' + rules[j].style.cssText + '}\n\n';
                        }
                    }
                }
            }
        } catch (ignore) {
        }
    }

    head += cssText + '<\/style>';

    doc.body.classList.add('website_body');
    doc.body.classList.add('main_website_faux');

    if (de.getElementsByTagName('style').length == 0) {// The conditional is needed for Firefox - for some odd reason it is unable to parse any head tags twice
        Composr.dom.html(doc.head, head);
    }

    Composr.dom.html(doc.body, '<div aria-busy="true" class="spaced"><div class="ajax_loading"><img id="loading_image" class="vertical_alignment" src="' + '{$IMG_INLINE*;,loading}'.replace(/^https?:/, window.location.protocol) + '" alt="{!LOADING;^}" /> <span class="vertical_alignment">{!LOADING;^}<\/span><\/div><\/div>');

    // Stupid workaround for Google Chrome not loading an image on unload even if in cache
    window.setTimeout(function () {
        if (!doc.getElementById('loading_image')) {
            return;
        }

        var i_new = doc.createElement('img');
        i_new.src = doc.getElementById('loading_image').src;

        var i_default = doc.getElementById('loading_image');
        if (i_default) {
            i_new.className = i_default.className;
            i_new.alt = i_default.alt;
            i_new.id = i_default.id;
            i_default.parentNode.replaceChild(i_new, i_default);
        }
    }, 0);
}

/* Smoothly scroll to another position on the page */
function smooth_scroll(dest_y, expected_scroll_y, dir, event_after) {
    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations)) {
        try {
            window.scrollTo(0, dest_y);
        } catch (e) {
        }
        return;
    }

    var scroll_y = window.pageYOffset;
    if (typeof dest_y == 'string') dest_y = find_pos_y(document.getElementById(dest_y), true);
    if (dest_y < 0) dest_y = 0;
    if ((typeof expected_scroll_y != 'undefined') && (expected_scroll_y != null) && (expected_scroll_y != scroll_y)) return; // We must terminate, as the user has scrolled during our animation and we do not want to interfere with their action -- or because our last scroll failed, due to us being on the last scroll screen already
    if (typeof dir == 'undefined' || !null) var dir = (dest_y > scroll_y) ? 1 : -1;

    var distance_to_go = (dest_y - scroll_y) * dir;
    var dist = Math.round(dir * (distance_to_go / 25));
    if (dir == -1 && dist > -25) dist = -25;
    if (dir == 1 && dist < 25) dist = 25;

    if (((dir == 1) && (scroll_y + dist >= dest_y)) || ((dir == -1) && (scroll_y + dist <= dest_y)) || (distance_to_go > 2000)) {
        try {
            window.scrollTo(0, dest_y);
        }
        catch (e) {
        }
        if (event_after) event_after();
        return;
    }

    try {
        window.scrollBy(0, dist);
    } catch (e) {
        return; // May be stopped by popup blocker
    }

    window.setTimeout(function () {
        smooth_scroll(dest_y, scroll_y + dist, dir, event_after);
    }, 30);
}

/* Helper to change class on checkbox check */
function change_class(box, theId, to, from) {
    var cell = document.getElementById(theId);
    if (!cell) cell = theId;
    cell.className = (box.checked) ? to : from;
}

/* Dimension functions */
function register_mouse_listener(e) {
    if (!window.mouse_listener_enabled) {
        window.mouse_listener_enabled = true;
        document.body.addEventListener('mousemove', get_mouse_xy);
        if (typeof e != 'undefined') get_mouse_xy(e);
    }
}
function get_mouse_xy(e, win) {
    if (typeof win == 'undefined') win = window;
    win.mouse_x = get_mouse_x(e, win);
    win.mouse_y = get_mouse_y(e, win);
    win.ctrl_pressed = e.ctrlKey;
    win.alt_pressed = e.altKey;
    win.meta_pressed = e.metaKey;
    win.shift_pressed = e.shiftKey;
    return true
}
function get_mouse_x(event, win) // Usually use window.mouse_x after calling register_mouse_listener(), it's more accurate on Firefox
{
    if (typeof win == 'undefined') win = window;
    try {
        if ((typeof event.pageX != 'undefined') && (event.pageX)) {
            return event.pageX;
        } else if ((typeof event.clientX != 'undefined') && (event.clientX)) {
            return event.clientX + win.pageXOffset
        }
    }
    catch (err) {
    }
    return 0;
}
function get_mouse_y(event, win) // Usually use window.mouse_y after calling register_mouse_listener(), it's more accurate on Firefox
{
    if (typeof win == 'undefined') win = window;
    try {
        if ((typeof event.pageY != 'undefined') && (event.pageY)) {
            return event.pageY;
        } else if ((typeof event.clientY != 'undefined') && (event.clientY)) {
            return event.clientY + win.pageYOffset
        }
    }
    catch (err) {
    }
    return 0;
}
function get_window_width(win) {
    if ( win === undefined) {
        win = window;
    }
    if (win.innerWidth !== undefined) {
        return win.innerWidth - 18;
    }

    if ((win.document.documentElement) && (win.document.documentElement.clientWidth)) {
        return win.document.documentElement.clientWidth;
    }

    if ((win.document.body) && (win.document.body.clientWidth)) {
        return win.document.body.clientWidth;
    }

    return 0;
}
function get_window_height(win) {
    if (typeof win == 'undefined') win = window;
    if (typeof win.innerHeight != 'undefined') return win.innerHeight - 18;
    if ((win.document.documentElement) && (win.document.documentElement.clientHeight)) return win.document.documentElement.clientHeight;
    if ((win.document.body) && (win.document.body.clientHeight)) return win.document.body.clientHeight;
    return 0;
}
function get_window_scroll_width(win) {
    if (typeof win == 'undefined') win = window;

    return win.document.body.scrollWidth;
}
function get_window_scroll_height(win) {
    if (typeof win == 'undefined') win = window;

    var rect_a = win.document.body.parentNode.getBoundingClientRect();
    var a = rect_a.bottom - rect_a.top;
    var rect_b = win.document.body.getBoundingClientRect();
    var b = rect_b.bottom - rect_b.top;
    if (a > b) return a;

    return b;
}

function find_pos_x(obj, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
    if (typeof not_relative == 'undefined') not_relative = false;
    var ret = obj.getBoundingClientRect().left + window.pageXOffset;
    if (!not_relative) {
        var position;
        while (obj != null) {
            position = window.getComputedStyle(obj).getPropertyValue('position');
            if (position == 'absolute' || position == 'relative') {
                ret -= find_pos_x(obj, true);
                break;
            }
            obj = obj.parentNode;
        }
    }
    return ret;
}
function find_pos_y(obj, not_relative) {/* if not_relative is true it gets the position relative to the browser window, else it will be relative to the most recent position:absolute/relative going up the element tree */
    if (typeof not_relative == 'undefined') not_relative = false;
    var ret = obj.getBoundingClientRect().top + window.pageYOffset;
    if (!not_relative) {
        var position;
        while (obj != null) {
            position = window.getComputedStyle(obj).getPropertyValue('position');
            if (position == 'absolute' || position == 'relative') {
                ret -= find_pos_y(obj, true);
                break;
            }
            obj = obj.parentNode;
        }
    }
    return ret;
}

/* See if a key event was an enter key being pressed */
function enter_pressed(event, alt_char) {
    if ((alt_char !== undefined) && (event.which && (event.which === alt_char.charCodeAt(0))))  {
        return true;
    }

    return event.which && (event.which === 13);
}

function modsecurity_workaround(form) {
    var temp_form = document.createElement('form');
    temp_form.method = 'post';
    if (form.target != null && form.target != '') {
        temp_form.target = form.target;
    }
    temp_form.action = form.action;

    var data = $(form).serialize();
    data = _modsecurity_workaround(data);

    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = '_data';
    input.value = data;
    temp_form.appendChild(input);

    if (typeof form.elements['csrf_token'] != 'undefined') {
        var csrf_input = document.createElement('input');
        csrf_input.type = 'hidden';
        csrf_input.name = 'csrf_token';
        csrf_input.value = form.elements['csrf_token'].value;
        temp_form.appendChild(csrf_input);
    }

    temp_form.style.display = 'none';
    document.body.appendChild(temp_form);

    window.setTimeout(function () {
        temp_form.submit();

        temp_form.parentNode.removeChild(temp_form);
    }, 0);

    return false;
}

function modsecurity_workaround_ajax(data) {
    return '_data=' + window.encodeURIComponent(_modsecurity_workaround(data));
}

function _modsecurity_workaround(data) {
    var remapper = {
        '\\': '<',
        '/': '>',
        '<': '\'',
        '>': '"',
        '\'': '/',
        '"': '\\',
        '%': '&',
        '&': '%'
    };
    var out = '';
    var len = data.length, char;
    for (var i = 0; i < len; i++) {
        char = data[i];
        if (typeof remapper[char] != 'undefined') {
            out += remapper[char];
        } else {
            out += char;
        }
    }
    return out;
}

function clear_out_tooltips(tooltip_being_opened) {
    // Delete other tooltips, which due to browser bugs can get stuck
    var selector = tooltip_being_opened ? '.tooltip:not(#' + tooltip_being_opened + ')' : '.tooltip';
    Composr.dom.$$(selector).forEach(function(el) {
        deactivate_tooltip(el.ac, el);
    });
}

function preactivate_rich_semantic_tooltip(ob, event, have_links) {
    if (typeof ob.ttitle == 'undefined') ob.ttitle = ob.title;
    ob.title = '';
    ob.onmouseover = null;
    ob.onclick = function () {
        activate_rich_semantic_tooltip(ob, event, have_links);
    };
}
function activate_rich_semantic_tooltip(ob, event, have_links) {
    if (typeof ob.ttitle == 'undefined') ob.ttitle = ob.title;
    activate_tooltip(ob, event, ob.ttitle, 'auto', null, null, false, true, false, false, window, have_links);
}
/* Tooltips that can work on any element with rich HTML support */
//  ac is the object to have the tooltip
//  event is the event handler
//  tooltip is the text for the tooltip
//  width is in pixels (but you need 'px' on the end), can be null or auto
//  pic is the picture to show in the top-left corner of the tooltip; should be around 30px x 30px
//  height is the maximum height of the tooltip for situations where an internal but unusable scrollbar is wanted
//  bottom is set to true if the tooltip should definitely appear upwards; rarely use this parameter
//  no_delay is set to true if the tooltip should appear instantly
//  lights_off is set to true if the image is to be dimmed
//  force_width is set to true if you want width to not be a max width
//  win is the window to open in
//  have_links is set to true if we activate/deactivate by clicking due to possible links in the tooltip or the need for it to work on mobile
function activate_tooltip(ac, event, tooltip, width, pic, height, bottom, no_delay, lights_off, force_width, win, have_links) {
    if (window.is_doing_a_drag) return; // Don't want tooltips appearing when doing a drag and drop operation

    if (!have_links) {
        if (document.body.className.indexOf(' touch_enabled') != -1) return; // Too erratic
    }

    if (typeof width == 'undefined' || !width) var width = 'auto';
    if (typeof pic == 'undefined') pic = '';
    if (typeof height == 'undefined' || !height) var height = 'auto';
    if (typeof bottom == 'undefined') bottom = false;
    if (typeof no_delay == 'undefined') no_delay = false;
    if (typeof lights_off == 'undefined') lights_off = false;
    if (typeof force_width == 'undefined') force_width = false;
    if (typeof win == 'undefined') win = window;
    if (typeof have_links == 'undefined') have_links = false;

    if (!window.page_loaded) return;
    if ((typeof tooltip != 'function') && (tooltip == '')) return;

    register_mouse_listener(event);

    clear_out_tooltips(ac.tooltip_id);

    // Add in move/leave events if needed
    if (!have_links) {
        if (!ac.onmouseout) ac.onmouseout = function (event) {
            win.deactivate_tooltip(ac);
        };
        if (!ac.onmousemove) ac.onmousemove = function (event) {
            win.reposition_tooltip(ac, event, false, false, null, false, win);
        };
    } else {
        ac.old_onclick = ac.onclick;
        ac.onclick = function (event) {
            win.deactivate_tooltip(ac);
        };
    }

    if (typeof tooltip == 'function') tooltip = tooltip();
    if (tooltip == '') return;

    ac.is_over = true;
    ac.tooltip_on = false;
    ac.initial_width = width;
    ac.have_links = have_links;

    var children = ac.getElementsByTagName('img');
    for (var i = 0; i < children.length; i++) children[i].setAttribute('title', '');

    var tooltip_element;
    if ((typeof ac.tooltip_id != 'undefined') && (document.getElementById(ac.tooltip_id))) {
        tooltip_element = win.document.getElementById(ac.tooltip_id);
        tooltip_element.style.display = 'none';
        Composr.dom.html(tooltip_element, '');
        window.setTimeout(function () {
            reposition_tooltip(ac, event, bottom, true, tooltip_element, force_width);
        }, 0);
    } else {
        tooltip_element = win.document.createElement('div');
        tooltip_element.role = 'tooltip';
        tooltip_element.style.display = 'none';
        var rt_pos = tooltip.indexOf('results_table');
        tooltip_element.className = 'tooltip ' + ((rt_pos == -1 || rt_pos > 100) ? 'tooltip_ownlayout' : 'tooltip_nolayout') + ' boxless_space' + (have_links ? ' have_links' : '');
        if (ac.className.substr(0, 3) == 'tt_') {
            tooltip_element.className += ' ' + ac.className;
        }
        if (tooltip.length < 50) tooltip_element.style.wordWrap = 'normal'; // Only break words on long tooltips. Otherwise it messes with alignment.
        if (force_width) {
            tooltip_element.style.width = width;
        } else {
            if (width == 'auto') {
                var new_auto_width = get_window_width(win) - 30 - window.mouse_x;
                if (new_auto_width < 150) new_auto_width = 150; // For tiny widths, better let it slide to left instead, which it will as this will force it to not fit
                tooltip_element.style.maxWidth = new_auto_width + 'px';
            } else {
                tooltip_element.style.maxWidth = width;
            }
            tooltip_element.style.width = 'auto'; // Needed for Opera, else it uses maxWidth for width too
        }
        if ((height) && (height != 'auto')) {
            tooltip_element.style.maxHeight = height;
            tooltip_element.style.overflow = 'auto';
        }
        tooltip_element.style.position = 'absolute';
        tooltip_element.id = 't_' + Math.floor(Math.random() * 1000);
        ac.tooltip_id = tooltip_element.id;
        reposition_tooltip(ac, event, bottom, true, tooltip_element, force_width);
        document.body.appendChild(tooltip_element);
    }
    tooltip_element.ac = ac;

    if (pic) {
        var img = win.document.createElement('img');
        img.src = pic;
        img.className = 'tooltip_img';
        if (lights_off) img.className += ' faded_tooltip_img';
        tooltip_element.appendChild(img);
        tooltip_element.className += ' tooltip_with_img';
    }

    var event_copy;
    try {
        event_copy = { // Needs to be copied as it will get erased on IE after this function ends
            'pageX': event.pageX,
            'pageY': event.pageY,
            'clientX': event.clientX,
            'clientY': event.clientY,
            'type': event.type
        };
    }
    catch (e) { // Can happen if IE has lost the event
        event_copy = {
            'pageX': 0,
            'pageY': 0,
            'clientX': 0,
            'clientY': 0,
            'type': ''
        };
    }

    // This allows turning off tooltips by pressing anywhere, on iPhone (and probably Android etc). The clickability of body forces the simulated onmouseout events to fire.
    var bi = document.getElementById('main_website_inner');
    if (!bi) bi = document.body;
    if ((typeof window.TouchEvent != 'undefined') && (!bi.onmouseover)) {
        bi.onmouseover = function () {
            return true;
        };
    }

    window.setTimeout(function () {
        if (!ac.is_over) return;

        if ((!ac.tooltip_on) || (tooltip_element.childNodes.length == 0)) // Some other tooltip jumped in and wiped out tooltip on a delayed-show yet never triggers due to losing focus during that delay
            Composr.dom.appendHtml(tooltip_element, tooltip);

        ac.tooltip_on = true;
        tooltip_element.style.display = 'block';
        if (tooltip_element.style.width == 'auto')
            tooltip_element.style.width = (Composr.dom.contentWidth(tooltip_element) + 1/*for rounding issues from em*/) + 'px'; // Fix it, to stop the browser retroactively reflowing ambiguous layer widths on mouse movement

        if (!no_delay) {
            // If delayed we will sub in what the currently known global mouse coordinate is
            event_copy.pageX = win.mouse_x;
            event_copy.pageY = win.mouse_y;
        }

        reposition_tooltip(ac, event_copy, bottom, true, tooltip_element, force_width, win);
    }, no_delay ? 0 : 666);
}
function reposition_tooltip(ac, event, bottom, starting, tooltip_element, force_width, win) {
    if (typeof win === 'undefined') { win = window; }

    if (!starting) // Real JS mousemove event, so we assume not a screen reader and have to remove natural tooltip
    {
        if (ac.getAttribute('title')) ac.setAttribute('title', '');
        if ((ac.parentNode.localName === 'a') && (ac.parentNode.getAttribute('title')) && ((ac.localName === 'abbr') || (ac.parentNode.getAttribute('title').indexOf('{!LINK_NEW_WINDOW;^}') != -1)))
            ac.parentNode.setAttribute('title', ''); // Do not want second tooltips that are not useful
    }

    if (!window.page_loaded) return;
    if (!ac.tooltip_id) {
        if ((typeof ac.onmouseover != 'undefined') && (ac.onmouseover)) ac.onmouseover(event);
        return;
    }  // Should not happen but written as a fail-safe

    if ((typeof tooltip_element == 'undefined') || (!tooltip_element)) var tooltip_element = document.getElementById(ac.tooltip_id);
    if (tooltip_element) {
        var style__offset_x = 9;
        var style__offset_y = (ac.have_links) ? 18 : 9;

        // Find mouse position
        var x, y;
        x = window.mouse_x;
        y = window.mouse_y;
        x += style__offset_x;
        y += style__offset_y;
        try {
            if (typeof event.type != 'undefined') {
                if (event.type != 'focus') ac.done_none_focus = true;
                if ((event.type == 'focus') && (ac.done_none_focus)) return;
                x = (event.type == 'focus') ? (win.pageXOffset + get_window_width(win) / 2) : (window.mouse_x + style__offset_x);
                y = (event.type == 'focus') ? (win.pageYOffset + get_window_height(win) / 2 - 40) : (window.mouse_y + style__offset_y);
            }
        }
        catch (ignore) {
        }
        // Maybe mouse position actually needs to be in parent document?
        try {
            if (event.target !== undefined) {
                if (event.target.ownerDocument !== win.document) {
                    x = win.mouse_x + style__offset_x;
                    y = win.mouse_y + style__offset_y;
                }
            }
        }
        catch (ignore) {
        }

        // Work out which direction to render in
        var width = Composr.dom.contentWidth(tooltip_element);
        if (tooltip_element.style.width == 'auto') {
            if (width < 200) width = 200; // Give some breathing room, as might already have painfully-wrapped when it found there was not much space
        }
        var height = tooltip_element.offsetHeight;
        var x_excess = x - get_window_width(win) - win.pageXOffset + width + 10/*magic tolerance factor*/;
        if (x_excess > 0) // Either we explicitly gave too much width, or the width auto-calculated exceeds what we THINK is the maximum width in which case we have to re-compensate with an extra contingency to stop CSS/JS vicious disagreement cycles
        {
            var x_before = x;
            x -= x_excess + 20 + style__offset_x;
            if (x < 100) x = (x_before < 100) ? x_before : 100; // Do not make it impossible to de-focus the tooltip
        }
        if (x < 0) x = 0;
        if (bottom) {
            tooltip_element.style.top = (y - height) + 'px';
        } else {
            var y_excess = y - get_window_height(win) - win.pageYOffset + height + style__offset_y;
            if (y_excess > 0) y -= y_excess;
            var scroll_y = win.pageYOffset;
            if (y < scroll_y) y = scroll_y;
            tooltip_element.style.top = y + 'px';
        }
        tooltip_element.style.left = x + 'px';
    }
}
function deactivate_tooltip(ac, tooltip_element) {
    ac.is_over = false;

    if (typeof ac.tooltip_id == 'undefined') return;

    if (typeof tooltip_element == 'undefined')
        tooltip_element = document.getElementById(ac.tooltip_id);
    if (tooltip_element) tooltip_element.style.display = 'none';

    if (typeof ac.old_onclick != 'undefined') {
        ac.onclick = ac.old_onclick;
    }
}

/* Automatic resizing to make frames seamless. Composr calls this automatically. Make sure id&name attributes are defined on your iframes! */
function resize_frame(name, min_height) {
    if (typeof min_height == 'undefined') min_height = 0;
    var frame_element = document.getElementById(name);
    var frame_window;
    if (typeof window.frames[name] != 'undefined') frame_window = window.frames[name]; else if (parent && parent.frames[name]) frame_window = parent.frames[name]; else return;
    if ((frame_element) && (frame_window) && (frame_window.document) && (frame_window.document.body)) {
        var h = get_window_scroll_height(frame_window);
        if ((h == 0) && (frame_element.parentNode.style.display == 'none')) {
            h = ((typeof min_height == 'undefined') || (min_height == 0)) ? 100 : min_height;
            if (frame_window.parent) window.setTimeout(function () {
                if (frame_window.parent) frame_window.parent.trigger_resize();
            }, 0);
        }
        if (h + 'px' != frame_element.style.height) {
            if (frame_element.scrolling != 'auto') {
                frame_element.style.height = ((h >= min_height) ? h : min_height) + 'px';
                if (frame_window.parent) window.setTimeout(function () {
                    if (frame_window.parent) frame_window.parent.trigger_resize();
                }, 0);
                frame_element.scrolling = 'no';
                frame_window.onscroll = function (event) {
                    if (event == null) return false;
                    try {
                        frame_window.scrollTo(0, 0);
                    } catch (e) {
                    }
                    return cancel_bubbling(event);
                }; // Needed for Opera
            }
        }
    }

    frame_element.style.transform = 'scale(1)'; // Workaround Chrome painting bug
}
function trigger_resize(and_subframes) {
    if (typeof window.parent == 'undefined') return;
    if (typeof window.parent.document == 'undefined') return;
    var frames = window.parent.document.getElementsByTagName('iframe');
    var done = false;

    for (let i = 0; i < frames.length; i++) {
        if ((frames[i].src == window.location.href) || (frames[i].contentWindow == window) || ((frames[i].id != '') && (typeof window.parent.frames[frames[i].id] != 'undefined') && (window.parent.frames[frames[i].id] == window))) {
            if (frames[i].style.height == '900px') frames[i].style.height = 'auto';
            window.parent.resize_frame(frames[i].name);
        }
    }

    if (and_subframes) {
        frames = document.getElementsByTagName('iframe');
        for (let i = 0; i < frames.length; i++) {
            if ((frames[i].name != '') && ((frames[i].className.indexOf('expandable_iframe') != -1) || (frames[i].className.indexOf('dynamic_iframe') != -1))) resize_frame(frames[i].name);
        }
    }
}

/* Marking things (to avoid illegally nested forms) */
function add_form_marked_posts(work_on, prefix) {
    var get = work_on.method.toLowerCase() == 'get';
    var elements = document.getElementsByTagName('input');
    var i;
    var append = '';
    if (get) {
        for (i = 0; i < work_on.elements.length; i++) {
            if (work_on.elements[i].name.match(new RegExp('&' + prefix.replace('_', '\_') + '\d+=1$', 'g'))) {
                work_on.elements[i].parentNode.removeChild(work_on.elements[i]);
            }
        }
    } else {
        // Strip old marks out of the URL
        work_on.action = work_on.action.replace('?', '&');
        work_on.action = work_on.action.replace(new RegExp('&' + prefix.replace('_', '\_') + '\d+=1$', 'g'), '');
        work_on.action = work_on.action.replace('&', '?'); // will just do first due to how JS works
    }
    for (i = 0; i < elements.length; i++) {
        if ((elements[i].type == 'checkbox') && (elements[i].name.substring(0, prefix.length) == prefix) && (elements[i].checked))
            append += (((append == '') && (work_on.action.indexOf('?') == -1) && (work_on.action.indexOf('/pg/') == -1) && (!get)) ? '?' : '&') + elements[i].name + '=1';
    }
    if (get) {
        var bits = append.split('&');
        for (i = 0; i < bits.length; i++) {
            if (bits[i] != '') {
                var hidden = document.createElement('input');
                hidden.name = bits[i].substr(0, bits[i].indexOf('=1'));
                hidden.value = '1';
                hidden.type = 'hidden';
                work_on.appendChild(hidden);
            }
        }
    } else {
        work_on.action += append;
    }
    return append != '';
}


/* Set opacity, without interfering with the thumbnail timer */
function set_opacity(element, fraction) {
    if (element.fader_key && (window.fade_transition_timers !== undefined) && (window.fade_transition_timers[element.fader_key])) {
        try { // Cross-frame issues may cause error
            window.clearTimeout(window.fade_transition_timers[element.fader_key]);
        } catch (ignore) {
        }
        window.fade_transition_timers[element.fader_key] = null;
    }

    element.style.opacity = fraction;
}

/* Event listeners */

function cancel_bubbling(event) {
    if (!event || !event.target || (event.stopPropagation === undefined)) {
        return false;
    }

    event.stopPropagation();
    return true;
}

/* Update a URL to maintain the current theme into it */
function maintain_theme_in_link(url) {
    if (url.includes('&utheme=')) return url;
    if (url.includes('?utheme=')) return url;
    if (url.includes('&keep_theme=')) return url;
    if (url.includes('?keep_theme=')) return url;

    url += (url.includes('?') ? '&' : '?');
    url += 'utheme=' + window.encodeURIComponent(Composr.$THEME);

    return url;
}

/* Get URL stub to propagate keep_* parameters */
function keep_stub(starting_query_string, skip_session, context) {// starting_query_string means "Put a '?' for the first parameter"
    if (!window) return '';
    if (typeof window.location == 'undefined') return ''; // Can happen, in a document.write'd popup

    if (typeof skip_session == 'undefined') skip_session = false;

    if (((typeof context == 'undefined') || (context.indexOf('keep_') == -1)) && (skip_session)) {
        if (starting_query_string) {
            if (typeof window.cache_keep_stub_starting_query_string != 'undefined')
                return window.cache_keep_stub_starting_query_string;
        } else {
            if (typeof window.cache_keep_stub != 'undefined')
                return window.cache_keep_stub;
        }
    }

    var to_add = '', i;
    var search = (window.location.search == '') ? '?' : window.location.search.substr(1);
    var bits = search.split('&');
    var done_session = skip_session;
    var gap_symbol;
    for (i = 0; i < bits.length; i++) {
        if (bits[i].substr(0, 5) == 'keep_') {
            if ((typeof context == 'undefined') || (context.indexOf('?' + bits[i]) == -1 && context.indexOf('&' + bits[i]) == -1)) {
                gap_symbol = (((to_add == '') && (starting_query_string)) ? '?' : '&');
                to_add += gap_symbol + bits[i];
                if (bits[i].substr(0, 13) == 'keep_session=') done_session = true;
            }
        }
    }
    if (!done_session) {
        var session = get_session_id();
        gap_symbol = (((to_add == '') && (starting_query_string)) ? '?' : '&');
        if (session) to_add = to_add + gap_symbol + 'keep_session=' + window.encodeURIComponent(session);
    }

    if (((typeof context == 'undefined') || (context.indexOf('keep_') == -1)) && (skip_session)) {
        if (starting_query_string) {
            window.cache_keep_stub_starting_query_string = to_add;
        } else {
            window.cache_keep_stub = to_add;
        }
    }

    return to_add;
}

function get_csrf_token() {
    return read_cookie(Composr.$SESSION_COOKIE_NAME); // Session also works as a CSRF-token, as client-side knows it (AJAX)
}

function get_session_id() {
    return read_cookie(Composr.$SESSION_COOKIE_NAME);
}

/* Import an XML node into the current document */
function careful_import_node(node) {
    try {
        return document.importNode(node, true);
    } catch (e) {
        return node;
    }
}

/* Google Analytics tracking for links; particularly useful if you have no server-side stat collection */
function ga_track(ob, category, action) {
    /*{+START,IF_NON_EMPTY,{$CONFIG_OPTION,google_analytics}}{+START,IF,{$NOR,{$IS_STAFF},{$IS_ADMIN}}}*/
    if (typeof category == 'undefined') category = '{!URL;}';
    if (typeof action == 'undefined') action = ob ? ob.href : '{!UNKNOWN;}';

    try {
        ga('send', 'event', category, action);
    }
    catch (err) {
    }

    if (ob) {
        setTimeout(function () {
            click_link(ob);
        }, 100);

        return false;
    }
    /*{+END}{+END}*/

    return null;
}

/* Force a link to be clicked without user clicking it directly (useful if there's a confirmation dialog inbetween their click) */
function click_link(link) {
    var cancelled = false;

    if ((link.localName !== 'a') && (link.localName !== 'input')) {
        link = link.querySelector('a');
    }

    var backup = link.onclick;

    link.onclick = function (e) {
        cancel_bubbling(e);
    };

    var event = document.createEvent('MouseEvents');
    event.initMouseEvent('click', true, true, window,
        0, 0, 0, 0, 0,
        false, false, false, false,
        0, null
    );
    cancelled = !link.dispatchEvent(event);

    link.onclick = backup;

    if (!cancelled && link.href) {
        if (link.target) {
            window.open(link.href, link.target);
        }

        window.location = link.href;
    }
}

/* Reply to a topic using AJAX */
function topic_reply(is_threaded, ob, id, replying_to_username, replying_to_post, replying_to_post_plain, explicit_quote) {
    if (typeof explicit_quote == 'undefined') explicit_quote = false;

    var form = document.getElementById('comments_form');

    var parent_id_field;
    if (typeof form.elements['parent_id'] == 'undefined') {
        parent_id_field = document.createElement('input');
        parent_id_field.type = 'hidden';
        parent_id_field.name = 'parent_id';
        form.appendChild(parent_id_field);
    } else {
        parent_id_field = form.elements['parent_id'];
        if (typeof window.last_reply_to != 'undefined') set_opacity(window.last_reply_to, 1.0);
    }
    window.last_reply_to = ob;
    parent_id_field.value = is_threaded ? id : '';

    ob.className += ' activated_quote_button';

    var post = form.elements['post'];

    smooth_scroll(find_pos_y(form, true));

    var outer = document.getElementById('comments_posting_form_outer');
    if (outer && outer.style.display == 'none')
        toggleable_tray('comments_posting_form_outer');

    if (is_threaded) {
        post.value = '{!QUOTED_REPLY_MESSAGE;^}'.replace(/\\{1\\}/g, replying_to_username).replace(/\\{2\\}/g, replying_to_post_plain);
        post.strip_on_focus = post.value;
        post.className += ' field_input_non_filled';
    } else {
        if (typeof post.strip_on_focus != 'undefined' && post.value == post.strip_on_focus)
            post.value = '';
        else if (post.value != '') post.value += '\n\n';

        post.focus();
        post.value += '[quote="' + replying_to_username + '"]\n' + replying_to_post + '\n[snapback]' + id + '[/snapback][/quote]\n\n';
        if (!explicit_quote) post.default_substring_to_strip = post.value;
    }

    manage_scroll_height(post);
    post.scrollTop = post.scrollHeight;

    return false;
}

/* Load more from a threaded topic */
function threaded_load_more(ob, ids, id) {
    load_snippet('comments&id=' + window.encodeURIComponent(id) + '&ids=' + window.encodeURIComponent(ids) + '&serialized_options=' + window.encodeURIComponent(window.comments_serialized_options) + '&hash=' + window.encodeURIComponent(window.comments_hash), null, function (ajax_result) {
        var wrapper;
        if (id != '') {
            wrapper = document.getElementById('post_children_' + id);
        } else {
            wrapper = ob.parentNode;
        }
        ob.parentNode.removeChild(ob);

        Composr.dom.appendHtml(wrapper, ajax_result.responseText);

        window.setTimeout(function () {
            var _ids = ids.split(',');
            for (var i = 0; i < _ids.length; i++) {
                var element = document.getElementById('post_wrap_' + _ids[i]);
                if (element) {
                    set_opacity(element, 0);
                    fade_transition(element, 100, 30, 10);
                }
            }
        }, 0);
    });

    return false;
}

/* Set it up so a form field is known and can be monitored for changes */
function set_up_change_monitor(container) {
    var firstInp = Composr.dom.$(container, 'input, select, textarea');

    if (!firstInp || firstInp.id.includes('choose_')) {
        return;
    }

    function check() {
        container.classList.toggle('filledin', find_if_children_set(container));
    }

    Composr.dom.on(container, 'focusout change', check);
}


function find_if_children_set(container) {
    var value, blank = true, el;
    var elements = Composr.dom.$$(container, 'input, select, textarea');
    for (var i = 0; i < elements.length; i++) {
        el = elements[i];
        if (((el.type === 'hidden') || ((el.style.display === 'none') && !is_wysiwyg_field(el))) && !el.classList.contains('hidden_but_needed')) {
            continue;
        }
        value = clever_find_value(el.form, el);
        blank = blank && (value == '');
    }
    return !blank;
}


/* Used by audio CAPTCHA. */
function play_self_audio_link(ob) {
    require_javascript('sound', window.SoundManager);

    var timer = window.setInterval(function () {
        if (typeof window.soundManager == 'undefined') return;

        window.clearInterval(timer);

        window.soundManager.setup({
            url: get_base_url() + '/data',
            debugMode: false,
            onready: function () {
                var sound_object = window.soundManager.createSound({url: ob.href});
                if (sound_object) {
                    sound_object.play();
                }
            }
        });
    }, 50);

    return false;
}


function confirm_delete(form, multi, callback) {
    if (typeof multi == 'undefined') multi = false;

    window.fauxmodal_confirm(
        multi ? '{!_ARE_YOU_SURE_DELETE;^}' : '{!ARE_YOU_SURE_DELETE;^}',
        function (result) {
            if (result) {
                if (typeof callback != 'undefined') {
                    callback();
                } else {
                    form.submit();
                }
            }
        }
    );
    return false;
}

if (window.fade_transition_timers === undefined) {
    window.fade_transition_timers = {};
}

function fade_transition(fade_element, dest_percent_opacity, period_in_msecs, increment, destroy_after) {
    if (!_.isElement(fade_element)) {
        return;
    }

    if (Composr.not(Composr.$CONFIG_OPTION.enableAnimations)) {
        set_opacity(fade_element, dest_percent_opacity / 100.0);
        return;
    }

    if (window.fade_transition_timers === undefined) {
        return;
    }

    if (fade_element.fader_key === undefined) {
        fade_element.fader_key = fade_element.id + '_' + Math.round(Math.random() * 1000000);
    }

    if (window.fade_transition_timers[fade_element.fader_key]) {
        window.clearTimeout(window.fade_transition_timers[fade_element.fader_key]);
        window.fade_transition_timers[fade_element.fader_key] = null;
    }

    var again;

    if (fade_element.style.opacity) {
        var diff = (dest_percent_opacity / 100.0) - fade_element.style.opacity;
        var direction = 1;
        if (increment > 0) {
            if (fade_element.style.opacity > dest_percent_opacity / 100.0) {
                direction = -1;
            }
            var new_increment = Math.min(direction * diff, increment / 100.0);
        } else {
            if (fade_element.style.opacity < dest_percent_opacity / 100.0) {
                direction = -1;
            }
            var new_increment = Math.max(direction * diff, increment / 100.0);
        }
        var temp = parseFloat(fade_element.style.opacity) + direction * new_increment;
        if (temp < 0.0) temp = 0.0;
        if (temp > 1.0) temp = 1.0;
        fade_element.style.opacity = temp;
        again = (Math.round(temp * 100) != Math.round(dest_percent_opacity));
    } else {
        // Opacity not set yet, need to call back in an event timer
        again = true;
    }

    if (again) {
        window.fade_transition_timers[fade_element.fader_key] = window.setTimeout(function () {
            fade_transition(fade_element, dest_percent_opacity, period_in_msecs, increment, destroy_after);
        }, period_in_msecs);
    } else {
        if (destroy_after && fade_element.parentNode) fade_element.parentNode.removeChild(fade_element);
    }
}
