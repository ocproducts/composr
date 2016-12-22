"use strict";

window.template_editor_open_files || (window.template_editor_open_files = {});

/*
 Naming conventions...

 t_	Tab header
 g_	Tab body
 b_ Toolbar
 e_	Editor textbox
 */

function file_to_file_id(file) {
    return file.replace(/\//, '__').replace(/:/, '__').replace(/\./, '__');
}

function file_id_to_file(file_id) {
    for (var file in window.template_editor_open_files) {
        if (file_to_file_id(file) == file_id) return file;
    }
    return null;
}

function template_editor_assign_unload_event() {
    window.addEventListener('beforeunload', function (event) {
        if (document.querySelector('.file_changed')) {
            undo_staff_unload_action();
            window.unloaded = false;

            var ret = '{!UNSAVED_TEMPLATE_CHANGES;^}';
            event.returnValue = ret; // Fix Chrome bug (explained on https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload)
            return ret;
        }
        return null;
    });
}

/* Tab and file management */



function template_editor_loading_url(file, revision_id) {
    var url = 'template_editor_load';
    url += '&file=' + encodeURIComponent(file);
    url += '&theme=' + encodeURIComponent(window.template_editor_theme);
    if (window.template_editor_active_guid !== undefined) {
        url += '&active_guid=' + encodeURIComponent(window.template_editor_active_guid);
    }
    if (window.template_editor_live_preview_url !== undefined) {
        url += '&live_preview_url=' + encodeURIComponent(window.template_editor_live_preview_url);
    }
    if (revision_id !== undefined) {
        url += '&undo_revision=' + encodeURIComponent(revision_id);
    }
    return url;
}

function template_editor_show_tab(file_id) {
    window.setTimeout(function () {
        if (!document.getElementById('t_' + file_id) || document.getElementById('t_' + file_id).className.indexOf('tab_active') == -1) {
            // No longer visible
            return;
        }

        if (window.opener) // If anchored
            highlight_template(window.opener, file_id_to_file(file_id));

        $('#e_' + file_id.replace(/\./g, '\\.') + '_wrap').resizable({
            resize: function (event, ui) {
                var editor = window.ace_editors['e_' + file_id];
                if (editor !== undefined) {
                    $('#e_' + file_id.replace(/\./g, '\\.') + '__ace')[0].style.height = '100%';
                    $('#e_' + file_id.replace(/\./g, '\\.') + '__ace')[0].parentNode.style.height = '100%';
                    editor.resize();
                }
            },
            handles: 's'
        });
    }, 1000);
}

function template_editor_tab_loaded_content(ajax_result, file) {
    var file_id = file_to_file_id(file);

    $cms.dom.html(document.getElementById('g_' + file_id), ajax_result.responseText);

    window.setTimeout(function () {
        var textarea_id = 'e_' + file_id;
        if (editarea_is_loaded(textarea_id)) {
            var editor = window.ace_editors[textarea_id];
            var editor_session = editor.getSession();
            editor_session.on('change', function () {
                template_editor_tab_mark_changed_content(file);
                editor.last_change = (new Date()).getTime();
            });
        } else {
            get_file_textbox(file).addEventListener('change', function () {
                template_editor_tab_mark_changed_content(file);
            });
        }
    }, 1000);

    window.template_editor_open_files[file] = {
        unsaved_changes: false
    };
}

function template_editor_tab_mark_changed_content(file) {
    window.template_editor_open_files[file].unsaved_changes = true;

    var file_id = file_to_file_id(file);
    var ob = document.getElementById('t_' + file_id);
    ob.classList.remove('file_nonchanged');
    ob.classList.add('file_changed');
}

function template_editor_tab_save_content(file) {
    var url = 'template_editor_save';
    url += '&file=' + encodeURIComponent(file);
    url += '&theme=' + encodeURIComponent(window.template_editor_theme);

    editarea_reverse_refresh('e_' + file_to_file_id(file));

    var post = 'contents=' + encodeURIComponent(get_file_textbox(file).value);
    load_snippet(url, post, function (ajax_result) {
        fauxmodal_alert(ajax_result.responseText, null, null, true);
        template_editor_tab_mark_nonchanged_content(file);
    });
}

function template_editor_tab_mark_nonchanged_content(file) {
    window.template_editor_open_files[file].unsaved_changes = false;

    var file_id = file_to_file_id(file);
    var ob = document.getElementById('t_' + file_id);
    ob.classList.remove('file_changed');
    ob.classList.add('file_nonchanged');
}

function template_editor_get_tab_count() {
    var count = 0;
    for (var k in window.template_editor_open_files) {
        if (window.template_editor_open_files.hasOwnProperty(k)) {
            count++;
        }
    }
    return count;
}

function template_editor_tab_unload_content(file) {
    var file_id = file_to_file_id(file);
    var was_active = template_editor_remove_tab(file_id);

    delete window.template_editor_open_files[file];

    if (was_active) {
        // Select tab
        var c = document.getElementById('template_editor_tab_headers').childNodes;
        if (c[0] !== undefined) {
            var next_file_id = c[0].id.substr(2);

            select_tab('g', next_file_id);

            template_editor_show_tab(next_file_id);
        }
    }
}

function template_editor_remove_tab(file_id) {
    var header = document.getElementById('t_' + file_id);
    if (header) {
        var is_active = (header.className.indexOf(' tab_active') != -1);

        header.parentNode.removeChild(header);
        var body = document.getElementById('g_' + file_id);
        if (body) body.parentNode.removeChild(body);

        template_editor_clean_tabs();

        return is_active;
    }

    return false;
}

function template_editor_clean_tabs() {
    var headers = document.getElementById('template_editor_tab_headers');
    var bodies = document.getElementById('template_editor_tab_bodies');
    var num_tabs = headers.childNodes.length;

    var header = document.getElementById('t_default');
    var body = document.getElementById('g_default');

    if (header && num_tabs > 1) {
        header.parentNode.removeChild(header);
        body.parentNode.removeChild(body);
    }

    if (num_tabs == 0) {
        $cms.dom.html(headers, '<a href="#!" id="t_default" class="tab"><span>&mdash;</span></a>');
        $cms.dom.html(bodies, '<div id="g_default"><p class="nothing_here">{!NA}</p></div>');
    }
}

function template_editor_restore_revision(file, revision_id) {
    var file_id = file_to_file_id(file);

    // Set content from revision
    var url = template_editor_loading_url(file, revision_id);
    load_snippet(url, null, function (ajax_result) {
        document.getElementById('t_' + file_id).className = 'tab tab_active';

        template_editor_tab_loaded_content(ajax_result, file);
    });

    return false;
}

function template_editor_preview(file_id, url, button, ask_for_url) {
    if (ask_for_url === undefined) ask_for_url = false;

    var has_editarea = editarea_is_loaded('e_' + file_id);
    if (has_editarea) editarea_reverse_refresh('e_' + file_id);

    if (document.getElementById('mobile_preview_' + file_id).checked) {
        url += (url.indexOf('?') == -1) ? '?' : '&';
        url += 'keep_mobile=1';
    }

    if (ask_for_url) {
        window.fauxmodal_prompt(
            '{!themes:URL_TO_PREVIEW_WITH;^}',
            url,
            function (url) {
                if (url !== null) {
                    button.form.action = url;
                    button.form.submit();
                }
            },
            '{!PREVIEW;^}'
        );

        return false;
    }

    button.form.action = url;

    return true;
}

/* Editing */

function get_file_textbox(file) {
    var ob = document.getElementById('e_' + file_to_file_id(file));
    return ob;
}

function template_editor_keypress(event) {
    if ($cms.dom.keyPressed(event, 'Tab')) {
        insert_textbox(this, "\t");
        return false;
    }
    return true;
}

/* Templates (.tpl) */

function insert_guid(file, guid) {
    var textbox = get_file_textbox(file);

    var has_editarea = editarea_is_loaded(textbox.name);

    editarea_reverse_refresh('e_' + file_to_file_id(file));

    insert_textbox(textbox, '{' + '+START,IF,{' + '$EQ,{' + '_GUID},' + guid + '}}\n{' + '+END}');
    if (has_editarea) editarea_refresh(textbox.id);

    return false;
}

function template_insert_parameter(dropdown_name, file_id) {
    var textbox = document.getElementById('e_' + file_id);

    editarea_reverse_refresh('e_' + file_id);

    var dropdown = document.getElementById(dropdown_name);
    var value = dropdown.options[dropdown.selectedIndex].value;
    var value_parts = value.split('__');
    value = value_parts[0];
    if (value == '---') return false;

    var has_editarea = editarea_is_loaded(textbox.name);

    if ((value == 'BLOCK') && ((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION.js_overlays)) {
        var url = '{$FIND_SCRIPT_NOHTTP;,block_helper}?field_name=' + textbox.name + '&block_type=template' + keep_stub();
        window.faux_showModalDialog(
            maintain_theme_in_link(url),
            null,
            'dialogWidth=750;dialogHeight=600;status=no;resizable=yes;scrollbars=yes;unadorned=yes',
            function () {
                if (has_editarea) {
                    editarea_refresh(textbox.name);
                }
            }
        );
        return;
    }

    var arity = value_parts[1];
    var definite_gets = 0;
    if (arity == '1') definite_gets = 1;
    else if (arity == '2') definite_gets = 2;
    else if (arity == '3') definite_gets = 3;
    else if (arity == '4') definite_gets = 4;
    else if (arity == '5') definite_gets = 5;
    else if (arity == '0-1') definite_gets = 0;
    else if (arity == '3-4') definite_gets = 3;
    else if (arity == '0+') definite_gets = 0;
    else if (arity == '1+') definite_gets = 1;
    var parameter = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];

    _get_parameter_parameters(
        definite_gets,
        parameter,
        arity,
        textbox,
        name,
        value,
        0,
        '',
        function (textbox, name, value, params) {
            if (name.indexOf('ppdirective') != -1) {
                insert_textbox_wrapping(textbox, '{' + '+START,' + value + params + '}', '{' + '+END}');
            } else {
                var st_value;
                if (name.indexOf('ppparameter') == -1) {
                    st_value = '{' + '$';
                } else {
                    st_value = '{';
                }

                value = st_value + value + '*' + params + '}';

                insert_textbox(textbox, value);
            }

            if (has_editarea) editarea_refresh(textbox.name);
        }
    );

    return false;
}

function _get_parameter_parameters(definite_gets, parameter, arity, box, name, value, num_done, params, callback) {
    if (num_done < definite_gets) {
        window.fauxmodal_prompt(
            '{!themes:INPUT_NECESSARY_PARAMETER;^}' + ', ' + parameter[num_done],
            '',
            function (v) {
                if (v !== null) {
                    params = params + ',' + v;
                    _get_parameter_parameters(definite_gets, parameter, arity, box, name, value, num_done + 1, params, callback);
                }
            },
            '{!themes:INSERT_PARAMETER;^}'
        );
    } else {
        if ((arity == '0+') || (arity == '1+')) {
            window.fauxmodal_prompt(
                '{!themes:INPUT_OPTIONAL_PARAMETER;^}',
                '',
                function (v) {
                    if (v !== null) {
                        params = params + ',' + v;
                        _get_parameter_parameters(definite_gets, parameter, arity, box, name, value, num_done + 1, params, callback);
                    } else callback(box, name, value, params);
                },
                '{!themes:INSERT_PARAMETER;^}'
            );
        }
        else if ((arity == '0-1') || (arity == '3-4')) {
            window.fauxmodal_prompt(
                '{!themes:INPUT_OPTIONAL_PARAMETER;^}',
                '',
                function (v) {
                    if (v != null)
                        params = params + ',' + v;
                    callback(box, name, value, params);
                },
                '{!themes:INSERT_PARAMETER;^}'
            );
        }
        else callback(box, name, value, params);
    }
}

function cleanup_template_markers(win) {
    if (window.done_cleanup_template_markers) {
        return;
    }

    _cleanup_template_markers(win.document.body, 0);

    window.done_cleanup_template_markers = true;
}

function _cleanup_template_markers(node, depth) {
    var inside = [];

    node = node.firstChild;
    while (node) {
        if (node.nodeType === 3) // Text node
        {
            var matches = node.data.match(/[\u200B\uFEFF]+/g);
            if (matches) {
                var all_decoded = [];
                for (var i = 0; i < matches.length; i++) {
                    var decoded = invisible_output_decode(matches[i]);
                    var _decoded = decoded.match(/<\/?templates\/[^<>]*>/g);
                    for (var j = 0; j < _decoded.length; j++) {
                        all_decoded.push(_decoded[j]);
                    }
                }
                for (var i = 0; i < all_decoded.length; i++) {
                    var decoded = all_decoded[i];
                    var opener_match = decoded.match('<(templates/.*)>');
                    if (opener_match != null) {
                        inside.push(opener_match[1]);
                    }
                    var closer_match = decoded.match('</(templates/.*)>');
                    if (closer_match != null) {
                        var at = inside.indexOf(closer_match[1]);
                        if (at != -1) inside.splice(at, 1);
                    }

                    node.data = node.data.replace(matches[i], ''); // Strip it, to clean document
                }
            }
        } else if (node.nodeType === 1) // Element node
        {
            var before = node.getAttribute('data-template');
            if (!before) before = '';
            node.setAttribute('data-template', before + ' ' + inside.join(' ') + ' ');
        }

        // Continue...

        _cleanup_template_markers(node, depth + 1);

        node = node.nextSibling;
    }
}

function highlight_template(win, template_path) {
    _highlight_template(win.document.body, template_path, 0);
}

function _highlight_template(node, template_path, depth) {
    var inside = [];

    node = node.firstChild;
    while (node) {
        if (node.nodeType === 1) {// Element node
            var template = node.getAttribute('data-template');
            var data_match = (template && template.includes(' ' + template_path + ' '));
            if (data_match) {
                node.classList.add('glowing_node');
            } else {
                node.classList.remove('glowing_node');
            }
        }

        // Continue...

        _highlight_template(node, template_path, depth + 1);

        node = node.nextSibling;
    }
}

function invisible_output_encode(string) {
    var ret = '';
    var i, j, char, _bitmask, bitmask, _bit, bit;
    var len = string.length;
    for (i = 0; i < len; i++) {
        char = string.charCodeAt(i);

        for (_bit = 7; _bit >= 0; _bit--) {
            _bitmask = '1';
            for (j = 0; j < _bit; j++) {
                _bitmask += '0';
            }
            bitmask = window.parseInt(_bitmask, 2);
            bit = (char & bitmask) != 0;
            ret += bit ? "\u200B" : "\uFEFF";
        }
    }

    return ret;
}

function invisible_output_decode(string) {
    var ret = '';
    var i, j, char, _bits_rep, bits_rep, _bit, bit;
    var len = string.length;
    for (i = 0; i < len / 8; i++) {
        _bits_rep = '';
        for (_bit = 0; _bit < 8; _bit++) {
            char = string.substr(i * 8 + _bit, 1);
            bit = (char == "\u200B") ? "1" : "0";
            _bits_rep += bit;
        }
        bits_rep = window.parseInt(_bits_rep, 2);
        ret += String.fromCharCode(bits_rep);
    }

    return ret;
}

/* CSS */

function load_contextual_css_editor(file, file_id) {
    var ui = document.getElementById('selectors_' + file_id);
    ui.style.display = 'block'; // Un-hide it
    var list = document.createElement('ul');
    list.id = 'selector_list_' + file_id;
    document.getElementById('selectors_inner_' + file_id).appendChild(list);

    set_up_parent_page_highlighting(file, file_id);

    // Set up background compiles
    var textarea_id = 'e_' + file_id;
    if (editarea_is_loaded(textarea_id)) {
        var editor = window.ace_editors[textarea_id];

        var last_css = editarea_get_value(textarea_id);

        editor.css_recompiler_timer = window.setInterval(function () {
            if ((window.opener) && (window.opener.document)) {
                if (editor.last_change === undefined) return; // No change made at all

                var milliseconds_ago = (new Date()).getTime() - editor.last_change;
                if (milliseconds_ago > 3 * 1000) return; // Not changed recently enough (within last 3 seconds)

                if (window.opener.have_set_up_parent_page_highlighting === undefined) {
                    set_up_parent_page_highlighting(file, file_id);
                    last_css = '';
                    /*force new CSS to apply*/
                }

                var new_css = editarea_get_value(textarea_id);
                if (new_css == last_css) return; // Not changed

                var url = $cms.baseUrl('data/snippet.php?snippet=css_compile__text' + keep_stub());
                do_ajax_request(url, function (ajax_result_frame) {
                    receive_compiled_css(ajax_result_frame, file);
                }, 'css=' + encodeURIComponent(new_css));

                last_css = new_css;
            }
        }, 2000);
    }
}

function set_up_parent_page_highlighting(file, file_id) {
    if (window.opener.find_active_selectors === undefined) return; // themeing.js is loaded up for staff, so it should be there
    window.opener.have_set_up_parent_page_highlighting = true;

    var doing_css_for = file.replace(/^css\//, '').replace('.css', '');

    var li, a, selector, elements, element, j, css_text;

    var selectors = window.opener.find_active_selectors(doing_css_for, window.opener);

    var list = document.getElementById('selector_list_' + file_id);
    $cms.dom.html(list, '');

    for (var i = 0; i < selectors.length; i++) {
        selector = selectors[i].selectorText;

        // Add to list of selectors
        li = document.createElement('li');
        a = document.createElement('a');
        li.appendChild(a);
        a.href = '#!';
        a.id = 'selector_' + i;
        $cms.dom.html(a, escape_html(selector));
        list.appendChild(li);

        // Add tooltip so we can see what the CSS text is in when hovering the selector
        css_text = (selectors[i].cssText === undefined) ? selectors[i].style.cssText : selectors[i].cssText;
        if (css_text.indexOf('{') != -1) {
            css_text = css_text.replace(/ \{ /g, ' {<br />\n&nbsp;&nbsp;&nbsp;').replace(/; \}/g, '<br />\n}').replace(/; /g, ';<br />\n&nbsp;&nbsp;&nbsp;');
        } else  {// IE
            css_text = css_text.toLowerCase().replace(/; /, ';<br />\n');
        }
        li.onmouseout = function (event) {
            deactivate_tooltip(this);
        };
        li.onmousemove = function (event) {
            reposition_tooltip(this, event);
        };
        li.onmouseover = function (css_text) {
            return function (event) {
                activate_tooltip(this, event, css_text, 'auto');
            }
        }(css_text);

        // Jump-to
        a.onclick = function (selector) {
            return function (event) {
                cancel_bubbling(event);
                editarea_do_search(
                    'e_' + file_id,
                    '^[ \t]*' + selector.replace(/\./g, '\\.').replace(/\[/g, '\\[').replace(/\]/g, '\\]').replace(/\{/g, '\\{').replace(/\}/g, '\\}').replace(/\+/g, '\\+').replace(/\*/g, '\\*').replace(/\s/g, '[ \t]+') + '\\s*\\{'
                ); // Opera does not support \s
                return false;
            }
        }(selector);

        // Highlighting on parent page
        a.onmouseover = function (selector) {
            return function (event) {
                if ((window.opener) && (!event.ctrlKey) && (!event.metaKey)) {
                    var elements = find_selectors_for(window.opener, selector);
                    for (var i = 0; i < elements.length; i++) {
                        elements[i].style.outline = '3px dotted green';
                        elements[i].style.backgroundColor = 'green';
                    }
                }
            }
        }(selector);
        a.onmouseout = function (selector) {
            return function (event) {
                if ((window.opener) && (!event.ctrlKey) && (!event.metaKey)) {
                    var elements = find_selectors_for(window.opener, selector);
                    for (var i = 0; i < elements.length; i++) {
                        elements[i].style.outline = '';
                        elements[i].style.backgroundColor = '';
                    }
                }
            }
        }(selector);

        // Highlighting from parent page
        elements = find_selectors_for(window.opener, selector);
        for (j = 0; j < elements.length; j++) {
            element = elements[j];

            element.addEventListener('mouseover', function (a, element) {
                return function (event) {

                    if ((window) && (!event.ctrlKey) && (!event.metaKey)) {
                        var target = event.target;
                        var target_distance = 0;
                        var element_recurse = element;
                        do
                        {
                            if (element_recurse == target) break;
                            element_recurse = element_recurse.parentNode;
                            target_distance++;
                        }
                        while (element_recurse);
                        if (target_distance > 10) target_distance = 10; // Max range

                        a.style.outline = '1px dotted green';
                        a.style.background = '#00' + (dec_to_hex(255 - target_distance * 25)) + '00';
                        if (target_distance > 4)
                            a.style.color = 'white';
                        else
                            a.style.color = 'black';
                    }
                }
            }(a, element));
            element.addEventListener('mouseout', function (a) {
                return function (event) {
                    if ((window) && (!event.ctrlKey) && (!event.metaKey)) {
                        a.style.outline = '';
                        a.style.background = '';
                        a.style.color = '';
                    }
                }
            }(a));
        }
    }
}

function dec_to_hex(number) {
    var hexbase = '0123456789ABCDEF';
    return hexbase.charAt((number >> 4) & 0xf) + hexbase.charAt(number & 0xf);
}

function find_active_selectors(match, win) {
    var test, selector, selectors = [], classes, i, j, result2;
    try {
        for (i = 0; i < win.document.styleSheets.length; i++) {
            try {
                if ((!match) || (!win.document.styleSheets[i].href && ((win.document.styleSheets[i].ownerNode && win.document.styleSheets[i].ownerNode.id == 'style_for_' + match) || (!win.document.styleSheets[i].ownerNode && win.document.styleSheets[i].id == 'style_for_' + match))) || (win.document.styleSheets[i].href && win.document.styleSheets[i].href.indexOf('/' + match) != -1)) {
                    classes = win.document.styleSheets[i].rules || win.document.styleSheets[i].cssRules;
                    for (j = 0; j < classes.length; j++) {
                        selector = classes[j].selectorText;
                        test = win.document.querySelectorAll(selector);
                        if (test.length != 0) selectors.push(classes[j]);
                    }
                }
            }
            catch (e) {
            }
        }
    }
    catch (e) {
    }

    for (i = 0; i < win.frames.length; i++) {
        if (win.frames[i]) // If test needed for some browsers, as window.frames can get out-of-date
        {
            result2 = find_active_selectors(match, win.frames[i]);
            for (var j = 0; j < result2.length; j++) selectors.push(result2[j]);
        }
    }

    return selectors;
}

function find_selectors_for(opener, selector) {
    var result = [], result2;
    try {
        result2 = opener.document.querySelectorAll(selector);
        for (var j = 0; j < result2.length; j++) result.push(result2[j]);
    }
    catch (e) {
    }
    for (var i = 0; i < opener.frames.length; i++) {
        if (opener.frames[i]) // If test needed for some browsers, as window.frames can get out-of-date
        {
            result2 = find_selectors_for(opener.frames[i], selector);
            for (var j = 0; j < result2.length; j++) result.push(result2[j]);
        }
    }
    return result;
}

function receive_compiled_css(ajax_result_frame, file, win) {
    var doing_css_for = file.replace(/^css\//, '').replace('.css', '');

    win || (win = window.opener)

    if (win) {
        try {
            var css = ajax_result_frame.responseText;

            // Remove old link tag
            var e;
            if (doing_css_for == 'no_cache') {
                e = win.document.getElementById('inline_css');
                if (e) {
                    e.parentNode.removeChild(e);
                }
            } else {
                var links = win.document.getElementsByTagName('link');
                for (var i = 0; i < links.length; i++) {
                    e = links[i];
                    if ((e.type == 'text/css') && (e.href.indexOf('/templates_cached/' + window.opener.$cms.$LANG + '/' + doing_css_for) != -1)) {
                        e.parentNode.removeChild(e);
                    }
                }
            }

            // Create style tag for this
            var style = win.document.getElementById('style_for_' + doing_css_for);
            if (!style) style = win.document.createElement('style');
            style.type = 'text/css';
            style.id = 'style_for_' + doing_css_for;
            if (style.styleSheet) {
                style.styleSheet.cssText = css;
            } else {
                if (style.childNodes[0] !== undefined) style.removeChild(style.childNodes[0]);
                var tn = win.document.createTextNode(css);
                style.appendChild(tn);
            }
            win.document.querySelector('head').appendChild(style);

            for (var i = 0; i < win.frames.length; i++) {
                if (win.frames[i]) // If test needed for some browsers, as window.frames can get out-of-date
                {
                    receive_compiled_css(ajax_result_frame, file, win.frames[i]);
                }
            }
        }
        catch (ex) {
        }
    }
}

function css_equation_helper(file_id, theme) {
    var url = 'themewizard_equation';
    url += '&theme=' + encodeURIComponent(theme);
    url += '&css_equation=' + encodeURIComponent(document.getElementById('css_equation_' + file_id).value);

    var result = load_snippet(url);

    if (result == '' || result.indexOf('<html') != -1) {
        window.fauxmodal_alert('{!ERROR_OCCURRED;^}');
    } else {
        document.getElementById('css_result_' + file_id).value = result;
    }

    return false;
}

// INIT CODE

window.done_cleanup_template_markers = false;
if (window.location.href.includes('keep_template_magic_markers=1')) {
    $cms.ready.then(function () {
        cleanup_template_markers(window);
    });
}
