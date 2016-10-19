"use strict";

/* Form editing code (general, may be used on many different kinds of form) */

// ===========
// HTML EDITOR
// ===========

function wysiwyg_on() {
    var cookie = read_cookie('use_wysiwyg');
    return (!cookie || (cookie !== '0')) && $cms.$CONFIG_OPTION.wysiwyg && !$cms.$MOBILE;
}

function toggle_wysiwyg(name) {
    if (!$cms.$CONFIG_OPTION.wysiwyg) {
        window.fauxmodal_alert('{!comcode:TOGGLE_WYSIWYG_ERROR;^}');
        return false;
    }

    var is_wysiwyg_on = wysiwyg_on();
    if (is_wysiwyg_on) {
        if (read_cookie('use_wysiwyg') === '-1') {
            _toggle_wysiwyg(name);
        } else {
            generate_question_ui(
                '{!comcode:WHETHER_SAVE_WYSIWYG_SELECTION;^}',
                {
                    buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}',
                    buttons__clear: '{!javascript:WYSIWYG_DISABLE_ONCE;^}',
                    //buttons__no: '{!javascript:WYSIWYG_DISABLE_ONCE_AND_DONT_ASK;^}',		Too confusing, re-enable if you want it
                    buttons__yes: '{!javascript:WYSIWYG_DISABLE_ALWAYS;^}'
                },
                '{!comcode:DISABLE_WYSIWYG;^}',
                '{!comcode:DISCARD_WYSIWYG_CHANGES;^}',
                function (saving_cookies) {
                    if (!saving_cookies) return;

                    if (saving_cookies.toLowerCase() == '{!javascript:WYSIWYG_DISABLE_ONCE;^}'.toLowerCase()) {
                        _toggle_wysiwyg(name);
                    }

                    if (saving_cookies.toLowerCase() == '{!javascript:WYSIWYG_DISABLE_ONCE_AND_DONT_ASK;^}'.toLowerCase()) {
                        _toggle_wysiwyg(name);
                        set_cookie('use_wysiwyg', '-1', 3000);
                    }

                    if (saving_cookies.toLowerCase() == '{!javascript:WYSIWYG_DISABLE_ALWAYS;^}'.toLowerCase()) {
                        _toggle_wysiwyg(name);
                        set_cookie('use_wysiwyg', '0', 3000);
                    }
                },
                600,
                140
            );
        }
        return false;
    }

    var ret = _toggle_wysiwyg(name);
    if (read_cookie('use_wysiwyg') != '-1') {
        set_cookie('use_wysiwyg', '1', 3000);
    }
    return ret;
}

function _toggle_wysiwyg(name) {
    var is_wysiwyg_on = wysiwyg_on();

    var forms = document.getElementsByTagName('form');
    var so = document.getElementById('post_special_options');
    var so2 = document.getElementById('post_special_options2');

    if (is_wysiwyg_on) {
        // Find if the WYSIWYG has anything in it - if not, discard
        var all_empty = true, myregexp = new RegExp(/((\s)|(<p\d*\/>)|(<\/p>)|(<p>)|(&nbsp;)|(<br[^>]*>))*/);
        for (var fid = 0; fid < forms.length; fid++) {
            for (var counter = 0; counter < forms[fid].elements.length; counter++) {
                var id = forms[fid].elements[counter].id;
                if (window.wysiwyg_editors[id] !== undefined) {
                    if (window.wysiwyg_editors[id].getData().replace(myregexp, '') != '') all_empty = false;
                }
            }
        }

        if (all_empty) {
            disable_wysiwyg(forms, so, so2, true);
        } else if ((window.wysiwyg_original_comcode[id] === undefined) || (window.wysiwyg_original_comcode[id].indexOf('&#8203;') != -1) || (window.wysiwyg_original_comcode[id].indexOf('cms_keep') != -1)) {
            disable_wysiwyg(forms, so, so2, false);
        } else {
            generate_question_ui(
                '{!comcode:DISCARD_WYSIWYG_CHANGES_NICE;^}',
                {
                    buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}',
                    buttons__convert: '{!comcode:DISCARD_WYSIWYG_CHANGES_LINE_CONVERT;^}',
                    buttons__no: '{!comcode:DISCARD_WYSIWYG_CHANGES_LINE;^}'
                },
                '{!comcode:DISABLE_WYSIWYG;^}',
                '{!comcode:DISCARD_WYSIWYG_CHANGES;^}',
                function (prompt) {
                    if ((!prompt) || (prompt.toLowerCase() == '{!INPUTSYSTEM_CANCEL;^}'.toLowerCase())) {
                        if (saving_cookies)
                            set_cookie('use_wysiwyg', '1', 3000);
                        return false;
                    }
                    var discard = (prompt.toLowerCase() == '{!comcode:DISCARD_WYSIWYG_CHANGES_LINE;^}'.toLowerCase());

                    disable_wysiwyg(forms, so, so2, discard);
                }
            );
        }
    } else {
        enable_wysiwyg(forms, so, so2);
    }

    return false;
}

function enable_wysiwyg(forms, so, so2) {
    window.wysiwyg_on = function () {
        return true;
    };

    for (var fid = 0; fid < forms.length; fid++) {
        load_html_edit(forms[fid], true);
    }
}

function disable_wysiwyg(forms, so, so2, discard) {
    for (var fid = 0; fid < forms.length; fid++) {
        for (var counter = 0; counter < forms[fid].elements.length; counter++) {
            var id = forms[fid].elements[counter].id;
            if (window.wysiwyg_editors[id] !== undefined) {
                var textarea = forms[fid].elements[counter];

                // Mark as non-WYSIWYG
                document.getElementById(id + '__is_wysiwyg').value = '0';
                textarea.style.display = 'block';
                textarea.style.visibility = 'visible';
                textarea.disabled = false;
                textarea.readOnly = false;

                if (window.rebuild_attachment_button_for_next !== undefined)
                    rebuild_attachment_button_for_next(id, 'attachment_upload_button');

                // Unload editor
                var wysiwyg_data = window.wysiwyg_editors[id].getData();
                try {
                    window.wysiwyg_editors[id].destroy();
                }
                catch (e) {
                }
                delete window.wysiwyg_editors[id];

                // Comcode conversion
                if ((discard) && (window.wysiwyg_original_comcode[id])) {
                    textarea.value = window.wysiwyg_original_comcode[id];
                } else {
                    var url = maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?from_html=1' + keep_stub());
                    if (window.location.href.indexOf('topics') != -1) url += '&forum_db=1';
                    var post = 'data=' + encodeURIComponent(wysiwyg_data.replace(new RegExp(String.fromCharCode(8203), 'g'), ''));
                    post = modsecurity_workaround_ajax(post);
                    var request = do_ajax_request(url, null, post);
                    if ((!request.responseXML) || (!request.responseXML.documentElement.querySelector('result'))) {
                        textarea.value = '[semihtml]' + wysiwyg_data + '[/semihtml]';
                    } else {
                        var result_tags = request.responseXML.documentElement.getElementsByTagName('result');
                        var result = result_tags[0];
                        textarea.value = merge_text_nodes(result.childNodes).replace(/\s*$/, '');
                    }
                    if ((textarea.value.indexOf('{\$,page hint: no_wysiwyg}') == -1) && (textarea.value != '')) textarea.value += '{\$,page hint: no_wysiwyg}';
                }
                if (document.getElementById('toggle_wysiwyg_' + id))
                    $cms.dom.html(document.getElementById('toggle_wysiwyg_' + id), '<img src="{$IMG*;^,icons/16x16/editor/wysiwyg_on}" srcset="{$IMG;^,icons/16x16/editor/wysiwyg_on} 2x" alt="{!comcode:ENABLE_WYSIWYG;^}" title="{!comcode:ENABLE_WYSIWYG;^}" class="vertical_alignment" />');

                // Unload editor
                try {
                    window.wysiwyg_editors[id].destroy();
                }
                catch (e) {
                }
            }
        }
    }
    if (so) so.style.display = 'block';
    if (so2) so2.style.display = 'none';

    window.wysiwyg_on = function () {
        return false;
    };
}

window.wysiwyg_readonly_timer = {};
function wysiwyg_set_readonly(name, readonly) {
    if (window.wysiwyg_editors[name] === undefined) {
        return;
    }

    var editor = window.wysiwyg_editors[name];
    if (editor.document.$.body) {
        editor.document.$.body.readOnly = readonly;
        editor.document.$.body.contentEditable = !readonly;
        editor.document.$.body.designMode = readonly ? 'off' : 'on';
    }

    // In case it sticks as read only we need a timer to put it back. But only if not already back.
    if (window.wysiwyg_readonly_timer[name] !== undefined && window.wysiwyg_readonly_timer[name]) {
        window.clearTimeout(window.wysiwyg_readonly_timer[name]);
        window.wysiwyg_readonly_timer[name] = null;
    }
    if (readonly) {
        window.wysiwyg_readonly_timer[name] = window.setTimeout(function () {
            wysiwyg_set_readonly(name, false);
        }, 5000);
    }
}

// Initialising the HTML editor if requested later (i.e. toggling it to on)
if (window.wysiwyg_editors === undefined) {
    window.wysiwyg_editors = {};
    window.wysiwyg_original_comcode = {};
}

function load_html_edit(posting_form, ajax_copy) {
    if ((!posting_form.method) || (posting_form.method.toLowerCase() !== 'post')) {
        return;
    }

    if (!posting_form.elements['http_referer']) {
        var http_referer = document.createElement('input');
        http_referer.name = 'http_referer';
        http_referer.value = window.location.href;
        http_referer.setAttribute('type', 'hidden');
        posting_form.appendChild(http_referer);
    }

    if (!window.CKEDITOR || !$cms.$CONFIG_OPTION.wysiwyg || !wysiwyg_on()) {
        return;
    }

    var so = document.getElementById('post_special_options'),
        so2 = document.getElementById('post_special_options2');

    if (!posting_form.elements['post'] || posting_form.elements['post'].className.includes('wysiwyg')) {
        if (so) {
            so.style.display = 'none';
        }

        if (so2) {
            so2.style.display = 'block';
        }
    }

    var counter, count = 0, e, indicator, those_done = [], id;
    for (counter = 0; counter < posting_form.elements.length; counter++) {
        e = posting_form.elements[counter];
        id = e.id;

        if ((e.type == 'textarea') && (e.className.indexOf('wysiwyg') != -1)) {
            if (document.getElementById(id + '__is_wysiwyg')) {
                indicator = document.getElementById(id + '__is_wysiwyg');
            } else {
                indicator = document.createElement('input');
                indicator.setAttribute('type', 'hidden');
                indicator.id = e.id + '__is_wysiwyg';
                indicator.name = e.name + '__is_wysiwyg';
                posting_form.appendChild(indicator);
            }
            indicator.value = '1';

            if (those_done[id]) continue;
            those_done[id] = 1;

            count++;
            if (document.getElementById('toggle_wysiwyg_' + id))
                $cms.dom.html(document.getElementById('toggle_wysiwyg_' + id), '<img src="{$IMG*;^,icons/16x16/editor/wysiwyg_off}" srcset="{$IMG;^,icons/32x32/editor/wysiwyg_off} 2x" alt="{!comcode:DISABLE_WYSIWYG;^}" title="{!comcode:DISABLE_WYSIWYG;^}" class="vertical_alignment" />');

            window.wysiwyg_original_comcode[id] = e.value;
            if (!ajax_copy) {
                if ((posting_form.elements[id + '_parsed'] !== undefined) && (posting_form.elements[id + '_parsed'].value != '') && ((e.defaultValue == ''/*IE bug*/) || (e.defaultValue == e.value))) // The extra conditionals are for if back button used
                    e.value = posting_form.elements[id + '_parsed'].value;
            } else {
                var url = maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1&from_html=0' + keep_stub());
                if (window.location.href.indexOf('topics') != -1) url += '&forum_db=1';
                var request = do_ajax_request(url, null, 'data=' + encodeURIComponent(posting_form.elements[counter].value.replace(new RegExp(String.fromCharCode(8203), 'g'), '').replace('{' + '$,page hint: no_wysiwyg}', '')));
                if (!request.responseXML) {
                    posting_form.elements[counter].value = '';
                } else {
                    var result_tags = request.responseXML.documentElement.getElementsByTagName('result');
                    if ((!result_tags) || (result_tags.length == 0)) {
                        posting_form.elements[counter].value = '';
                    } else {
                        var result = result_tags[0];
                        posting_form.elements[counter].value = merge_text_nodes(result.childNodes);
                    }
                }
            }
            window.setTimeout(function (e, id) {
                return function () {
                    wysiwyg_editor_init_for(e, id);
                }
            }(e, id), 1000);
        }
    }
}

function wysiwyg_editor_init_for(element, id) {
    var page_stylesheets = [];
    if (!document) return;
    var linked_sheets = document.getElementsByTagName('link');
    for (var counter = 0; counter < linked_sheets.length; counter++) {
        if (linked_sheets[counter].getAttribute('rel') == 'stylesheet')
            page_stylesheets.push(linked_sheets[counter].getAttribute('href'));
    }

    // Fiddly procedure to find our colour
    var test_div = document.createElement('div');
    document.body.appendChild(test_div);
    test_div.className = 'wysiwyg_toolbar_color_finder';
    var matches;
    var wysiwyg_color = window.getComputedStyle(test_div).getPropertyValue('color');
    test_div.parentNode.removeChild(test_div);
    matches = wysiwyg_color.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/, matches);
    if (matches) {
        wysiwyg_color = '#';
        var hex;
        hex = (window.parseInt(matches[1]).toString(16)) + '';
        if (hex.length == 1) hex = '0' + hex;
        wysiwyg_color += hex;
        hex = (window.parseInt(matches[2]).toString(16)) + '';
        if (hex.length == 1) hex = '0' + hex;
        wysiwyg_color += hex;
        hex = (window.parseInt(matches[3]).toString(16)) + '';
        if (hex.length == 1) hex = '0' + hex;
        wysiwyg_color += hex;
    }
    // CKEditor doesn't allow low saturation, so raise up if we need to
    matches = wysiwyg_color.match(/^#([0-4])(.)([0-4])(.)([0-4])(.)$/);
    if (matches) {
        wysiwyg_color = '#';
        wysiwyg_color += (window.parseInt(matches[1]) + 4) + matches[2];
        wysiwyg_color += (window.parseInt(matches[3]) + 4) + matches[4];
        wysiwyg_color += (window.parseInt(matches[5]) + 4) + matches[6];
    }

    /*== START WYSIWYG_SETTINGS.js ==*/
    // Carefully work out toolbar
    // Look to see if this Comcode button is here as a hint whether we are doing an advanced editor. Unfortunately we cannot put contextual Tempcode inside a JavaScript file, so this trick is needed.
    var precision_editing = $cms.$IS_STAFF || (document.body.querySelectorAll('.comcode_button_box').length > 1);
    var toolbar = [];
    if (precision_editing) {
        toolbar.push(['Source', '-']);
    }
    var toolbar_edit_actions = ['Cut', 'Copy', 'Paste', precision_editing ? 'PasteText' : null, precision_editing ? 'PasteFromWord' : null, precision_editing ? 'PasteCode' : null];
    if ($cms.$VALUE_OPTION.commercial_spellchecker) {
        toolbar_edit_actions.push('-', 'SpellChecker', 'Scayt');
    }
    toolbar.push(toolbar_edit_actions);
    toolbar.push(['Undo', 'Redo', precision_editing ? '-' : null, precision_editing ? 'Find' : null, precision_editing ? 'Replace' : null, ((document.body.spellcheck !== undefined) ? 'spellchecktoggle' : null), '-', precision_editing ? 'SelectAll' : null, 'RemoveFormat']);
    toolbar.push(['Link', 'Unlink']);
    toolbar.push(precision_editing ? '/' : '-');
    var formatting = ['Bold', 'Italic', 'Strike', '-', precision_editing ? 'Subscript' : null, (precision_editing ? 'Superscript' : null)];
    toolbar.push(formatting);
    toolbar.push(['NumberedList', 'BulletedList', precision_editing ? '-' : null, precision_editing ? 'Outdent' : null, precision_editing ? 'Indent' : null]);
    if (precision_editing) {
        toolbar.push(['JustifyLeft', 'JustifyCenter', 'JustifyRight', precision_editing ? 'JustifyBlock' : null]);
    }
    toolbar.push([precision_editing ? 'composr_image' : null, 'Table']);
    if (precision_editing) {
        toolbar.push('/');
    }
    toolbar.push(['Format', 'Font', 'FontSize']);
    toolbar.push(['TextColor']);
    if (precision_editing) {
        toolbar.push(['Maximize', 'ShowBlocks']);
    }
    if (precision_editing) {
        toolbar.push(['HorizontalRule', 'SpecialChar']);
    }
    var use_composr_toolbar = true;
    if (use_composr_toolbar) {
        toolbar.push(['composr_block', 'composr_comcode', (precision_editing ? 'composr_page' : null), 'composr_quote', (precision_editing ? 'composr_box' : null), 'composr_code']);
    }
    var editor_settings = {
        skin: 'kama',
        enterMode: window.CKEDITOR.ENTER_BR,
        uiColor: wysiwyg_color,
        ocpTheme: $cms.$THEME,
        fontSize_sizes: '0.6em;0.85em;1em;1.1em;1.2em;1.3em;1.4em;1.5em;1.6em;1.7em;1.8em;2em',
        removePlugins: '',
        extraPlugins: 'showcomcodeblocks,imagepaste,spellchecktoggle' + (use_composr_toolbar ? ',composr' : ''),
        /*{+START,IF,{$NEQ,{$CKEDITOR_PATH},data_custom/ckeditor}}*/
        customConfig: '',
        /*{+END}*/
        bodyId: 'wysiwyg_editor',
        baseHref: $cms.$BASE_URL_S,
        linkShowAdvancedTab: !$cms.$CONFIG_OPTION.eager_wysiwyg,
        imageShowAdvancedTab: !$cms.$CONFIG_OPTION.eager_wysiwyg,
        imageShowLinkTab: !$cms.$CONFIG_OPTION.eager_wysiwyg,
        imageShowSizing: !$cms.$CONFIG_OPTION.eager_wysiwyg,
        autoUpdateElement: true,
        contentsCss: page_stylesheets,
        cssStatic: css,
        startupOutlineBlocks: true,
        language: $cms.$LANG ? $cms.$LANG.toLowerCase() : 'en',
        emailProtection: false,
        resize_enabled: true,
        width: (element.offsetWidth - 15),
        height: window.location.href.includes('cms_comcode_pages') ? 250 : 500,
        toolbar: toolbar,
        allowedContent: true,
        browserContextMenuOnCtrl: true,
        comcodeXMLBlockTags: '{$COMCODE_TAGS;,{$WYSIWYG_COMCODE__XML_BLOCK}}',
        comcodeXMLInlineTags: '{$COMCODE_TAGS;,{$WYSIWYG_COMCODE__XML_INLINE}}',
        magicline_everywhere: true,
        autoGrow_onStartup: true
    };
    /*== END WYSIWYG_SETTINGS.js ==*/


    if (window.CKEDITOR.instances[element.id]) {
        // Workaround "The instance "xxx" already exists" error in Google Chrome
        delete window.CKEDITOR.instances[element.id];
    }
    var editor = window.CKEDITOR.replace(element.id, editor_settings);
    if (!editor) return; // Not supported on this platform
    window.wysiwyg_editors[id] = editor;

    element.parentNode.className += ' ' + editor_settings.skin; // Used for us to target per-skin CSS

    // CSS to run inside the CKEditor frame
    linked_sheets = document.getElementsByTagName('style');
    var css = '';
    for (counter = 0; counter < linked_sheets.length; counter++) {
        css += $cms.dom.html(linked_sheets[counter]);
    }
    window.CKEDITOR.addCss(css);

    // Change some CKEditor defaults
    window.CKEDITOR.on('dialogDefinition', function (ev) {
        var dialogName = ev.data.name;
        var dialogDefinition = ev.data.definition;

        if (dialogName == 'table') {
            var info = dialogDefinition.getContents('info');

            info.get('txtWidth')['default'] = '100%';
            info.get('txtBorder')['default'] = '0';
            info.get('txtBorder')['default'] = '0';
            info.get('txtCellSpace')['default'] = '0';
            info.get('txtCellPad')['default'] = '0';
        }
    });
    if (document.getElementById('attachment_store')) {
        window.lang_PREFER_CMS_ATTACHMENTS = '{!javascript:PREFER_CMS_ATTACHMENTS;^}';
    }
    window.lang_SPELLCHECKER_ENABLED = '{!javascript:SPELLCHECKER_ENABLED;^}';
    window.lang_SPELLCHECKER_DISABLED = '{!javascript:SPELLCHECKER_DISABLED;^}';
    window.lang_SPELLCHECKER_TOGGLE = '{!javascript:SPELLCHECKER_TOGGLE;^}';
    window.lang_SPELLCHECKER_LABEL = '{!javascript:SPELLCHECKER_LABEL;^}';
    window.lang_NO_IMAGE_PASTE_SAFARI = '{!javascript:NO_IMAGE_PASTE_SAFARI;^}';

    // Mainly used by autosaving
    editor.on('key', function (event) {
        if (element.externalOnKeyPress !== undefined) {
            window.setTimeout(function () { // timeout so that getData returns data *after* keypress
                element.value = editor.getData();
            }, 0);
            element.externalOnKeyPress(event, element);
        }
    });

    editor.on('instanceReady', function (event) {
        editor.setReadOnly(false); // Workaround for CKEditor bug found in 4.5.6, where it started sometimes without contentEditable=true

        if (window.set_up_comcode_autocomplete !== undefined) {
            set_up_comcode_autocomplete(id);
        }

        // Instant preview of Comcode
        find_tags_in_editor(editor, element);
    });
    window.setInterval(function () {
        if (is_wysiwyg_field(element))
            find_tags_in_editor(editor, element);
    }, 1000);

    // Weird issues in Chrome cutting+pasting blocks etc
    editor.on('paste', function (event) {
        if (event.data.html) {
            event.data.html = event.data.html.replace(/<meta charset="utf-8">/g, '');
            event.data.html = event.data.html.replace(/<br class="Apple-interchange-newline">/g, '<br>');
            event.data.html = event.data.html.replace(/<div style="text-align: center;"><font class="Apple-style-span" face="'Lucida Grande'"><span class="Apple-style-span" style="font-size: 11px; white-space: pre;"><br><\/span><\/font><\/div>$/, '<br><br>');
        }
    });

    // Allow drag and drop uploading
    editor.on('contentDom', function () {
        editor.document.on('dragover', function (e) {
            html5_upload_event_drag_over(e.data.$, element, element.id);
        });

        editor.document.on('drop', function (e) {
            html5_upload_event_drop(e.data.$, element, element.id);
        });
    });

    return editor;
}

function find_tags_in_editor(editor, element) {
    if (!editor.document || !editor.document.$) {
        return;
    }

    var comcodes = editor.document.$.querySelector('body').querySelectorAll('.cms_keep_ui_controlled');

    for (var i = 0; i < comcodes.length; i++) {
        if (comcodes[i].onmouseout) {
            continue;
        }

        comcodes[i].orig_title = comcodes[i].title;
        comcodes[i].onmouseout = function () {
            deactivate_tooltip(this);
        };
        comcodes[i].onmousemove = function (event) {
            if (event === undefined) {
                event = editor.window.$.event;
            }

            var eventCopy = {};
            if (event) {
                if (event.pageX) eventCopy.pageX = 3000;
                if (event.clientX) eventCopy.clientX = 3000;
                if (event.pageY) eventCopy.pageY = 3000;
                if (event.clientY) eventCopy.clientY = 3000;

                reposition_tooltip(this, eventCopy);
                this.title = this.orig_title;
            }
        };
        comcodes[i].onmousedown = function (event) {
            if (event === undefined) {
                event = editor.window.$.event;
            }

            if (event.altKey) {
                // Mouse cursor to start
                var range = document.selection.getRanges()[0];
                range.startOffset = 0;
                range.endOffset = 0;
                range.select();
                document.selection.selectRanges([range]);
            }
        };
        if (comcodes[i].localName === 'input') {
            comcodes[i].readOnly = true;
            comcodes[i].contentEditable = true; // Undoes what ckeditor sets. Fixes weirdness with copy and paste in Chrome (adding extra block on end)
            comcodes[i].ondblclick = function (event) {
                if (this.onmouseout) {
                    this.onmouseout();
                }
                var field_name = editor.name;
                if (this.id == '') this.id = 'comcode_tag_' + Math.round(Math.random() * 10000000);
                var tag_type = this.title.replace(/^\[/, '').replace(/[= \]](.|\n)*$/, '');
                if (tag_type == 'block') {
                    var block_name = this.title.replace(/\[\/block\]$/, '').replace(/^(.|\s)*\]/, '');
                    var url = '{$FIND_SCRIPT;,block_helper}?type=step2&block=' + encodeURIComponent(block_name) + '&field_name=' + field_name + '&parse_defaults=' + encodeURIComponent(this.title) + '&save_to_id=' + encodeURIComponent(this.id) + keep_stub();
                    url = url + '&block_type=' + (((field_name.indexOf('edit_panel_') == -1) && (window.location.href.indexOf(':panel_') == -1)) ? 'main' : 'side');
                    window.faux_open(maintain_theme_in_link(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
                } else {
                    var url = '{$FIND_SCRIPT;,comcode_helper}?type=step2&tag=' + encodeURIComponent(tag_type) + '&field_name=' + field_name + '&parse_defaults=' + encodeURIComponent(this.title) + '&save_to_id=' + encodeURIComponent(this.id) + keep_stub();
                    window.faux_open(maintain_theme_in_link(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
                }
                return false;
            }
        }
        comcodes[i].onmouseover = function (event) { // Shows preview
            if (event === undefined) {
                event = editor.window.$.event;
            }

            cancel_bubbling(event);

            if (window.activate_tooltip) {
                var tag_text = '';
                if (this.nodeName.toLowerCase() === 'input') {
                    tag_text = this.orig_title;
                } else {
                    tag_text = $cms.dom.html(this);
                }

                this.style.cursor = 'pointer';

                var eventCopy = {};
                if (event) {
                    if (event.pageX) eventCopy.pageX = 3000;
                    if (event.clientX) eventCopy.clientX = 3000;
                    if (event.pageY) eventCopy.pageY = 3000;
                    if (event.clientY) eventCopy.clientY = 3000;

                    var self_ob = this;
                    if ((this.rendered_tooltip === undefined && !self_ob.is_over) || (self_ob.tag_text != tag_text)) {
                        self_ob.tag_text = tag_text;
                        self_ob.is_over = true;

                        var url = maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&box_title={!PREVIEW&;^}' + keep_stub());
                        if (window.location.href.indexOf('topics') != -1) url += '&forum_db=1';
                        var request = do_ajax_request(url, function (ajax_result_frame, ajax_result) {
                            if (ajax_result) {
                                var tmp_rendered = merge_text_nodes(ajax_result.childNodes);
                                if (tmp_rendered.indexOf('{!CCP_ERROR_STUB;^}') == -1)
                                    self_ob.rendered_tooltip = tmp_rendered;
                            }
                            if (self_ob.rendered_tooltip !== undefined) {
                                if (self_ob.is_over) {
                                    activate_tooltip(self_ob, eventCopy, self_ob.rendered_tooltip, 'auto', null, null, false, true);
                                    self_ob.title = self_ob.orig_title;
                                }
                            }
                        }, 'data=' + encodeURIComponent('[semihtml]' + tag_text.replace(/<\/?span[^>]*>/gi, '')).substr(0, 1000).replace(new RegExp(String.fromCharCode(8203), 'g'), '') + '[/semihtml]');
                    } else if (this.rendered_tooltip !== undefined) {
                        activate_tooltip(self_ob, eventCopy, self_ob.rendered_tooltip, '400px', null, null, false, true);
                    }
                }
            }
        };

    }
}

// ============
// BOTH EDITORS
// ============

function do_emoticon(field_name, p, _opener) {
    var element, title, text;
    if (_opener) {
        element = get_main_cms_window().document.getElementById(field_name);
        if (!element) { // If it is really actually cascading popups
            element = opener.document.getElementById(field_name);
        }
    } else {
        element = document.getElementById(field_name);
    }

    title = p.title;
    if (title === '') {
        // Might be on image inside link instead
        title = p.querySelector('img').alt;
    }
    title = title.replace(/^.*: /, '');

    text = ' ' + title + ' ';

    if (_opener) {
        insert_textbox_opener(element, text, null, true, $cms.dom.html(p));
    } else {
        insert_textbox(element, text, null, true, $cms.dom.html(p));
    }
}

function do_attachment(field_name, id, description) {
    if (!get_main_cms_window().wysiwyg_editors) {
        return;
    }

    description || (description = '');

    var element = get_main_cms_window().document.getElementById(field_name);

    var comcode = '\n\n[attachment description="' + escape_comcode(description) + '"]' + id + '[/attachment]';

    insert_textbox_opener(element, comcode);
}

function is_wysiwyg_field(the_element) {
    var id = the_element.id;
    return window.wysiwyg_editors && (typeof window.wysiwyg_editors === 'object') && (typeof window.wysiwyg_editors[id] === 'object');
}

function get_textbox(element) {
    if (is_wysiwyg_field(element)) {
        var ret = window.wysiwyg_editors[element.id].getData();
        if ((ret === '\n') || (ret === '<br />')) {
            ret = '';
        }
        return ret;
    }
    return element.value;
}

function set_textbox(element, text, html) {
    if (is_wysiwyg_field(element)) {
        if (html === undefined) {
            html = escape_html(text).replace(new RegExp('\\\\n', 'gi'), '<br />');
        }

        window.wysiwyg_editors[element.id].setData(html);
        window.wysiwyg_editors[element.id].updateElement();

        window.setTimeout(function () {
            find_tags_in_editor(window.wysiwyg_editors[element.id], element);
        }, 100);
    } else {
        element.value = text;
    }
}

/*
 Insert some text, with WYSIWYG support...

 element: non-WYSIWYG element
 text: text to insert (non-HTML)
 sel: Selection DOM object so we know what to *overwrite* with the inserted text (or NULL)
 plain_insert: Set to true if we are doing a simple insert, not inserting complex Comcode that needs to have editing representation
 html: HTML to insert (if not passed then 'text' will be escaped)

 (Use insert_textbox_wrapping to wrap Comcode tags around a selection)
 */
function insert_textbox(element, text, sel, plain_insert, html) {
    plain_insert = !!plain_insert;
    html || (html = '');

    if (is_wysiwyg_field(element)) {
        var editor = window.wysiwyg_editors[element.id];

        var insert = '';
        if (plain_insert) {
            insert = get_selected_html(editor) + (html ? html : escape_html(text).replace(new RegExp('\\\\n', 'gi'), '<br />'));
        } else {
            var url = maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1' + keep_stub());
            if (window.location.href.indexOf('topics') != -1) url += '&forum_db=1';
            var request = do_ajax_request(url, null, 'data=' + encodeURIComponent(text.replace(new RegExp(String.fromCharCode(8203), 'g'), '')));
            if ((request.responseXML) && (request.responseXML.documentElement.querySelector('result'))) {
                var result_tags = request.responseXML.documentElement.getElementsByTagName('result');
                var result = result_tags[0];
                insert = merge_text_nodes(result.childNodes).replace(/\s*$/, '');
            }
        }

        var before = editor.getData();

        try {
            editor.focus(); // Needed on some browsers
            var selected_html = get_selected_html(editor);

            if ((editor.getSelection()) && (editor.getSelection().getStartElement().getName() == 'kbd')) // Danger Danger - don't want to insert into another Comcode tag. Put it after. They can cut+paste back if they need.
            {
                editor.document.getBody().appendHtml(insert);
            } else {
                //editor.insertHtml(insert); Actually may break up the parent tag, we want it to nest nicely
                var element_for_inserting = CKEDITOR.dom.element.createFromHtml(insert);
                editor.insertElement(element_for_inserting);
            }

            var after = editor.getData();
            if (after == before) {
                throw 'Failed to insert';
            }

            find_tags_in_editor(editor, element);
        } catch (e) { // Sometimes happens on Firefox in Windows, appending is a bit tamer (e.g. you cannot insert if you have the start of a h1 at cursor)

            var after = editor.getData();
            if (after === before) {// Could have just been a window.scrollBy popup-blocker exception, so only do this if the op definitely failed
                editor.document.getBody().appendHtml(insert);
            }
        }

        editor.updateElement();

        return;
    }

    var from = element.value.length, to;

    element.focus();

    if ((sel === undefined) || (sel === null)) {
        sel = document.selection ? document.selection : null;
    }

    if (element.selectionEnd !== undefined)  {// Mozilla style
        from = element.selectionStart;
        to = element.selectionEnd;

        var start = element.value.substring(0, from);
        var end = element.value.substring(to, element.value.length);

        element.value = start + element.value.substring(from, to) + text + end;
        set_selection_range(element, from + text.length, from + text.length);
    } else if (sel) {// IE style
        var ourRange = sel.createRange();
        if ((ourRange.moveToElementText) || (ourRange.parentElement() == element)) {
            if (ourRange.parentElement() != element) ourRange.moveToElementText(element);
            ourRange.text = ourRange.text + text;
        } else {
            element.value += text;
            from += 2;
            set_selection_range(element, from + text.length, from + text.length);
        }
    }
    else {
        // :(
        from += 2;
        element.value += text;
        set_selection_range(element, from + text.length, from + text.length);
    }
 }
function insert_textbox_opener(element, text, sel, plain_insert, html) {
    if (!sel) {
        sel = get_main_cms_window().document.selection || null;
    }

    get_main_cms_window().insert_textbox(element, text, sel, plain_insert, html);
}

// Get selected HTML from CKEditor
function get_selected_html(editor) {
    var my_selection = editor.getSelection();
    if (!my_selection || my_selection.getType() == window.CKEDITOR.SELECTION_NONE) return '';

    var selected_text = '';
    if (my_selection.getNative()) {
        if ((window.CKEDITOR.env.ie) && (my_selection.getNative().getRangeAt === undefined)) {// IE8 and under (selection object)
            my_selection.unlock(true);
            selected_text = my_selection.getNative().createRange().htmlText;
        } else {// IE9 / standards (HTMLSelection object)
            try {
                selected_text = $cms.dom.html(my_selection.getNative().getRangeAt(0).cloneContents());
            } catch (e) {
            }
        }
    }
    return selected_text;
}

// Insert into the editor such as to *wrap* the current selection with something new (typically a new Comcode tag)
function insert_textbox_wrapping(element, before_wrap_tag, after_wrap_tag) {
    var from, to;

    if (after_wrap_tag == '') {
        after_wrap_tag = '[/' + before_wrap_tag + ']';
        before_wrap_tag = '[' + before_wrap_tag + ']';
    }

    if (is_wysiwyg_field(element)) {
        var editor = window.wysiwyg_editors[element.id];

        editor.focus(); // Needed on some browsers, but on Opera will defocus our selection
        var selected_html = get_selected_html(editor);

        if (selected_html == '') selected_html = '{!comcode:TEXT_OR_COMCODE_GOES_HERE;^}'.toUpperCase();

        var new_html = '';

        var url = maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1' + keep_stub());
        if (window.location.href.indexOf('topics') != -1) {
            url += '&forum_db=1';
        }
        var request = do_ajax_request(url, null, 'data=' + encodeURIComponent((before_wrap_tag + selected_html + after_wrap_tag).replace(new RegExp(String.fromCharCode(8203), 'g'), '')));
        if ((request.responseXML) && (request.responseXML.documentElement.querySelector('result'))) {
            var result_tags = request.responseXML.documentElement.getElementsByTagName('result');
            var result = result_tags[0];
            new_html = merge_text_nodes(result.childNodes).replace(/\s*$/, '');
            /* result is an XML-escaped string of HTML, so we get via looking at the node text */
        } else {
            new_html = selected_html;
        }

        if ((editor.getSelection()) && (editor.getSelection().getStartElement().getName() == 'kbd')) {// Danger Danger - don't want to insert into another Comcode tag. Put it after. They can cut+paste back if they need.
            editor.document.getBody().appendHtml(new_html);
        } else {
            editor.insertHtml(new_html);
        }

        find_tags_in_editor(editor, element);

        editor.updateElement();

        return;
    }

    if (element.selectionEnd !== undefined)  {// Mozilla style
        from = element.selectionStart;
        to = element.selectionEnd;

        var start = element.value.substring(0, from);
        var end = element.value.substring(to, element.value.length);

        if (to > from) {
            element.value = start + before_wrap_tag + element.value.substring(from, to) + after_wrap_tag + end;
        } else {
            element.value = start + before_wrap_tag + after_wrap_tag + end;
        }
        set_selection_range(element, from, to + before_wrap_tag.length + after_wrap_tag.length);
    } else if (document.selection !== undefined) {// IE style
        element.focus();
        var sel = document.selection;
        var ourRange = sel.createRange();
        if ((ourRange.moveToElementText) || (ourRange.parentElement() == element)) {
            if (ourRange.parentElement() != element) ourRange.moveToElementText(element);
            ourRange.text = before_wrap_tag + ourRange.text + after_wrap_tag;
        } else element.value += before_wrap_tag + after_wrap_tag;
    } else {
        // :(
        element.value += before_wrap_tag + after_wrap_tag;
        set_selection_range(element, from, to + before_wrap_tag.length + after_wrap_tag.length);
    }
}

// From http://www.faqts.com/knowledge_base/view.phtml/aid/13562
function set_selection_range(input, selection_start, selection_end) {
    if (input.set_selection_range !== undefined) {/* Mozilla style */
        input.focus();
        input.set_selection_range(selection_start, selection_end);
    } else if (input.createTextRange !== undefined) {/* IE style */
        var range = input.createTextRange();
        range.collapse(true);
        range.moveEnd('character', selection_end);
        range.moveStart('character', selection_start);
        range.select();
    } else {
        input.focus();
    }
}

function show_upload_syndication_options(name, syndication_json, no_quota) {
    no_quota = !!no_quota;

    var html_spot = document.getElementById(name + '_syndication_options');
    var html = '';
    var num_checked = 0;
    var file_ob = document.getElementById(name);
    var pre_disabled = file_ob.disabled;

    var syndication = JSON.parse(syndication_json), id, authorised, label, checked;
    var num = 0;
    for (var hook in syndication) {
        num++;
    }
    for (var hook in syndication) {
        id = 'upload_syndicate__' + hook + '__' + name;
        authorised = syndication[hook].authorised;
        label = syndication[hook].label;

        if (authorised) {
            checked = true;
            num_checked++;
        } else {
            checked = false;
        }

        window.setTimeout(function (id, authorised) {
            return function () {
                document.getElementById(id).onclick = function () {
                    var e = document.getElementById(id);
                    if (e.checked) {
                        if (!authorised) {
                            //e.checked=false;	Better to assume success, not all oAuth support callback
                            var url = '{$FIND_SCRIPT;,upload_syndication_auth}?hook=' + encodeURIComponent(hook) + '&name=' + encodeURIComponent(name) + keep_stub();

                            if ($cms.$MOBILE) {
                                window.open(url);
                            } else {
                                faux_open(url, null, 'width=960;height=500', '_top');
                            }

                            if (!pre_disabled) {
                                file_ob.disabled = false;
                            }
                        }
                    }
                };
            };
        }(id, authorised), 0);

        html += '<span><label for="' + id + '"><input type="checkbox" ' + (checked ? 'checked="checked" ' : '') + 'id="' + id + '" name="' + id + '" value="1" />{!upload_syndication:UPLOAD_TO;^} ' + escape_html(label) + (((no_quota) && (num == 1)) ? ' ({!_REQUIRED;^})' : '') + '</label></span>';
    }

    if ((no_quota) && (num_checked == 0)) {
        file_ob.disabled = true;
    }

    if ((html != '') && (!no_quota)) {
        html += '<span><label for="force_remove_locally"><input type="checkbox" id="force_remove_locally" name="force_remove_locally" value="1" />{!upload_syndication:FORCE_REMOVE_LOCALLY;^}</label></span>';
    }

    html = '<div>' + html + '</div>';

    $cms.dom.html(html_spot, html);
}
