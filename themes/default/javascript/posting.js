"use strict";

/* Form editing code (mostly stuff only used on posting forms) */

require_javascript('ajax', window.do_ajax_request);

// ===========
// ATTACHMENTS
// ===========

function add_attachment(start_num, posting_field_name) {
    if (window.num_attachments === undefined) return;
    if (window.max_attachments === undefined) return;

    var add_to = document.getElementById('attachment_store');

    window.num_attachments++;

    // Add new file input, if we are using naked file inputs
    if (window.attachment_template.replace(/\s/, '') != '') {
        var new_div = document.createElement('div');
        $cms.dom.html(new_div, window.attachment_template.replace(/\_\_num_attachments\_\_/g, window.num_attachments));
        add_to.appendChild(new_div);
    }

    // Rebuild uploader button, if we have a singular button
    if (window.rebuild_attachment_button_for_next !== undefined) {
        rebuild_attachment_button_for_next(posting_field_name);
    }

    // Previous file input cannot be used anymore, if it exists
    var element = document.getElementById('file' + window.num_attachments);
    if (element) {
        element.setAttribute('unselectable', 'on');
    }

    if (window.trigger_resize !== undefined) trigger_resize();
}

function attachment_present(post_value, number) {
    return !(post_value.indexOf('[attachment]new_' + number + '[/attachment]') == -1) && (post_value.indexOf('[attachment_safe]new_' + number + '[/attachment_safe]') == -1) && (post_value.indexOf('[attachment thumb="1"]new_' + number + '[/attachment]') == -1) && (post_value.indexOf('[attachment_safe thumb="1"]new_' + number + '[/attachment_safe]') == -1) && (post_value.indexOf('[attachment thumb="0"]new_' + number + '[/attachment]') == -1) && (post_value.indexOf('[attachment_safe thumb="0"]new_' + number + '[/attachment_safe]') == -1);
}

function set_attachment(field_name, number, filename, multi, uploader_settings) {
    multi = !!multi;

    if (window.insert_textbox === undefined) return;
    if (window.num_attachments === undefined) return;
    if (window.max_attachments === undefined) return;

    var post = document.getElementById(field_name);

    var tmp_form = post.form;
    if ((tmp_form) && (tmp_form.preview)) {
        tmp_form.preview.checked = false;
        tmp_form.preview.disabled = true;
    }

    var post_value = get_textbox(post);
    var done = attachment_present(post.value, number) || attachment_present(post_value, number);
    if (!done) {
        var filepath = filename;
        if ((!filename) && (document.getElementById('file' + number))) {
            filepath = document.getElementById('file' + number).value;
        }

        if (filepath == '')
            return; // Upload error

        var ext = filepath.replace(/^.*\./, '').toLowerCase();

        var is_image = (',{$CONFIG_OPTION;,valid_images},'.indexOf(',' + ext + ',') != -1);
        var is_video = (',{$CONFIG_OPTION;,valid_videos},'.indexOf(',' + ext + ',') != -1);
        var is_audio = (',{$CONFIG_OPTION;,valid_audios},'.indexOf(',' + ext + ',') != -1);
        var is_archive = (ext == 'tar') || (ext == 'zip');

        var prefix = '', suffix = '';
        if (multi && is_image) {
            prefix = '[media_set]\n';
            suffix = '[/media_set]';
        }

        var tag = 'attachment';

        var show_overlay, defaults = {};
        if (filepath.indexOf('fakepath') == -1) // iPhone gives c:\fakepath\image.jpg, so don't use that
            defaults.description = filepath; // Default caption to local file path

        /*== START ATTACHMENT_UI_DEFAULTS.js ==*/
        /*
         This file is intended for customising the way the attachment UI operates/defaults.

         The following variables are defined:
         is_image (boolean)
         is_video (boolean)
         is_audio (boolean)
         is_archive (boolean)
         ext (the file extension, with no dot)
         */

        // Add any defaults into URL
        defaults.thumb = '1';
        defaults.type = ''; // =autodetect rendering type

        // Shall we show the options overlay?
        show_overlay = !(multi || (is_image && $cms.$CONFIG_OPTION.simplifiedAttachmentsUi) || is_archive);

        if (is_image) {
            tag = 'attachment_safe';
        }

        if (multi || is_image) {
            defaults.framed = '0';
        }

        /*== END ATTACHMENT_UI_DEFAULTS.js ==*/

        if (!show_overlay) {
            var comcode = '[' + tag;
            for (var key in defaults) {
                comcode += ' ' + key + '="' + (defaults[key].replace(/"/g, '\\"')) + '"';
            }
            comcode += ']new_' + number + '[/' + tag + ']';
            if (prefix != '') insert_textbox(post, prefix);
            if (multi) {
                var split_filename = document.getElementById('txtFileName_file' + window.num_attachments).value.split(/:/);
                for (var i = 0; i < split_filename.length; i++) {
                    if (i != 0) window.num_attachments++;
                    insert_textbox(
                        post,
                        comcode.replace(']new_' + number + '[', ']new_' + window.num_attachments + '[')
                    );
                }
                number = '' + (window.parseInt(number) + split_filename.length - 1);
            } else {
                insert_textbox(
                    post,
                    comcode,
                    document.selection ? document.selection : null
                );

                // Add field for next one
                var add_another_field = (number == window.num_attachments) && (window.num_attachments < window.max_attachments); // Needs running late, in case something happened inbetween
                if (add_another_field) {
                    add_attachment(window.num_attachments + 1, field_name);
                }
            }
            if (suffix != '') insert_textbox(post, suffix);

            if (uploader_settings !== undefined) {
                uploader_settings.callbacks.push(function () {
                    // Do insta-preview
                    if (is_wysiwyg_field(post)) {
                        generate_background_preview(post);
                    }
                });
            }

            return;
        }

        var wysiwyg = is_wysiwyg_field(post);

        var url = '{$FIND_SCRIPT;,comcode_helper}';
        url += '?field_name=' + field_name;
        url += '&type=step2';
        url += '&tag=' + tag;
        url += '&default=new_' + number;
        url += '&is_image=' + (is_image ? '1' : '0');
        url += '&is_archive=' + (is_archive ? '1' : '0');
        url += '&multi=' + (multi ? '1' : '0');
        url += '&prefix=' + prefix;
        if (wysiwyg) url += '&in_wysiwyg=1';
        for (var key in defaults) {
            url += '&default_' + key + '=' + encodeURIComponent(defaults[key]);
        }
        url += keep_stub();

        window.setTimeout(function () {
            window.faux_showModalDialog(
                maintain_theme_in_link(url),
                '',
                'width=750,height=auto,status=no,resizable=yes,scrollbars=yes,unadorned=yes',
                function (comcode_added) {
                    if (comcode_added) {
                        // Add in additional Comcode buttons for the other files selected at the same time
                        if (multi) {
                            var comcode_semihtml = '', comcode = '';
                            var split_filename = document.getElementById('txtFileName_file' + window.num_attachments).value.split(/:/);
                            for (var i = 1; i < split_filename.length; i++) {
                                window.num_attachments++;
                                var tmp = window.insert_comcode_tag(']new_' + number + '[', ']new_' + window.num_attachments + '[', true);
                                comcode_semihtml += tmp[0];
                                comcode += tmp[1];
                            }
                            number = '' + (window.parseInt(number) + split_filename.length - 1);

                            if (suffix != '') {
                                comcode += suffix;
                                comcode_semihtml += suffix;
                            }

                            insert_textbox(post, comcode, null, true, comcode_semihtml);
                        }

                        // Add field for next one
                        var add_another_field = (number == window.num_attachments) && (window.num_attachments < window.max_attachments); // Needs running late, in case something happened inbetween
                        if (add_another_field) {
                            add_attachment(window.num_attachments + 1, field_name);
                        }

                        // Do insta-preview
                        if ((comcode_added.indexOf('[attachment_safe') != -1) && (is_wysiwyg_field(post))) {
                            generate_background_preview(post);
                        }
                    } else // Cancelled
                    {
                        var clear_button = document.getElementById('fsClear_file' + number);
                        if (clear_button) {
                            clear_button.onclick();
                        }
                    }
                }
            );
        }, 800); // In a timeout to disassociate possible 'enter' keypress which could have led to this function being called [enter on the file selection dialogue] and could propagate through (on Google Chrome anyways, maybe a browser bug)
    } else {
        // Add field for next one
        var add_another_field = (number == window.num_attachments) && (window.num_attachments < window.max_attachments);
        if (add_another_field)
            add_attachment(window.num_attachments + 1, field_name);
    }
}

function generate_background_preview(post) {
    var form_post = '';
    var form = post.form;
    for (var i = 0; i < form.elements.length; i++) {
        if ((!form.elements[i].disabled) && ( form.elements[i].name !== undefined) && (form.elements[i].name != '')) {
            var name = form.elements[i].name;
            var value = clever_find_value(form, form.elements[i]);
            if (name == 'title' && value == '') value = 'x'; // Fudge, title must be filled in on many forms
            form_post += '&' + name + '=' + encodeURIComponent(value);
        }
    }
    form_post = modsecurity_workaround_ajax(form_post.substr(1));
    var preview_ret = do_ajax_request(form_preview_url + '&js_only=1&known_utf8=1', null, form_post);
    eval(preview_ret.responseText.replace('<script>', '').replace('</script>', ''));
}

// ====================
// COMCODE UI FUNCTIONS
// ====================

function do_input_html(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var post = document.getElementById(field_name);
    insert_textbox_wrapping(post, 'semihtml', '');
}

function do_input_code(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var post = document.getElementById(field_name);
    insert_textbox_wrapping(post, (post.name == 'message') ? 'tt' : 'codebox', '');
}

function do_input_quote(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var post = document.getElementById(field_name);
    window.fauxmodal_prompt(
        '{!javascript:ENTER_QUOTE_BY;^}',
        '',
        function (va) {
            if (va !== null) insert_textbox_wrapping(post, '[quote=\"' + va + '\"]', '[/quote]');
        },
        '{!comcode:INPUT_COMCODE_quote;^}'
    );
}

function do_input_box(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var post = document.getElementById(field_name);
    window.fauxmodal_prompt(
        '{!javascript:ENTER_BOX_TITLE;^}',
        '',
        function (va) {
            if (va !== null) insert_textbox_wrapping(post, '[box=\"' + va + '\"]', '[/box]');
        },
        '{!comcode:INPUT_COMCODE_box;^}'
    );
}

function do_input_menu(field_name) {
    if (window.insert_textbox === undefined) return;

    window.fauxmodal_prompt(
        '{!javascript:ENTER_MENU_NAME;^,' + (document.getElementById(field_name).form.menu_items.value) + '}',
        '',
        function (va) {
            if (va) {
                window.fauxmodal_prompt(
                    '{!javascript:ENTER_MENU_CAPTION;^}',
                    '',
                    function (vb) {
                        if (!vb) vb = '';

                        var add;
                        var element = document.getElementById(field_name);
                        add = '[block=\""+escape_comcode(va)+"\" caption=\""+escape_comcode(vb)+"\" type=\"tree\"]menu[/block]';
                        insert_textbox(element, add);
                    },
                    '{!comcode:INPUT_COMCODE_menu;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_menu;^}'
    );
}

function do_input_block(field_name) {
    var url = '{$FIND_SCRIPT;,block_helper}?field_name=' + field_name + keep_stub();
    url = url + '&block_type=' + (((field_name.indexOf('edit_panel_') == -1) && (window.location.href.indexOf(':panel_') == -1)) ? 'main' : 'side');
    window.faux_open(maintain_theme_in_link(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
}

function do_input_comcode(field_name, tag) {
    var attributes = {};
    var default_embed = null;
    var save_to_id = null;

    if (tag == null) {
        var element = document.getElementById(field_name);
        if (is_wysiwyg_field(element)) {
            var selection = wysiwyg_editors[field_name].getSelection();
            var ranges = selection.getRanges();
            if ( ranges[0] !== undefined) {
                var comcode_element = ranges[0].startContainer.$;
                do
                {
                    var matches = comcode_element.localName.match(/^comcode-(\w+)/);
                    if (matches !== null) {
                        tag = matches[1];

                        for (var i = 0; i < comcode_element.attributes.length; i++) {
                            if (comcode_element.attributes[i].name != 'id') {
                                attributes[comcode_element.attributes[i].name] = comcode_element.attributes[i].value;
                            }
                        }

                        default_embed = $cms.dom.html(comcode_element);

                        if (comcode_element.id == '') {
                            comcode_element.id = 'comcode_' + Date.now();
                        }
                        save_to_id = comcode_element.id;

                        break;
                    }

                    comcode_element = comcode_element.parentNode;
                }
                while (comcode_element !== null);
            }
        }
    }

    var url = '{$FIND_SCRIPT;,comcode_helper}?field_name=' + encodeURIComponent(field_name);
    if (tag) {
        url += '&tag=' + encodeURIComponent(tag);
    }
    if (default_embed !== null) {
        url += '&type=replace';
    } else {
        if (tag == null) {
            url += '&type=step1';
        } else {
            url += '&type=step2';
        }
    }
    if (is_wysiwyg_field(document.getElementById(field_name))) url += '&in_wysiwyg=1';
    for (var key in attributes) {
        url += '&default_' + key + '=' + encodeURIComponent(attributes[key]);
    }
    if (default_embed !== null) {
        url += '&default=' + encodeURIComponent(default_embed);
    }
    if (save_to_id !== null) {
        url += '&save_to_id=' + encodeURIComponent(save_to_id);
    }
    url += keep_stub();

    window.faux_open(maintain_theme_in_link(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
}

function do_input_list(field_name, add) {
    if (window.insert_textbox === undefined) return;

    if (add === undefined) add = [];

    var post = document.getElementById(field_name);
    insert_textbox(post, '\n');
    window.fauxmodal_prompt(
        '{!javascript:ENTER_LIST_ENTRY;^}',
        '',
        function (va) {
            if ((va != null) && (va != '')) {
                add.push(va);
                return do_input_list(field_name, add)
            }
            if (add.length == 0) return;
            var i;
            if (post.value.indexOf('[semihtml') != -1)
                insert_textbox(post, '[list]\n');
            for (i = 0; i < add.length; i++) {
                if (post.value.indexOf('[semihtml') != -1) {
                    insert_textbox(post, '[*]' + add[i] + '\n')
                } else {
                    insert_textbox(post, ' - ' + add[i] + '\n')
                }
            }
            if (post.value.indexOf('[semihtml') != -1)
                insert_textbox(post, '[/list]\n')
        },
        '{!comcode:INPUT_COMCODE_list;^}'
    );
}

function do_input_hide(field_name) {
    if (window.insert_textbox === undefined) return;

    window.fauxmodal_prompt(
        '{!javascript:ENTER_WARNING;^}',
        '',
        function (va) {
            if (va) {
                window.fauxmodal_prompt(
                    '{!javascript:ENTER_HIDDEN_TEXT;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(field_name);
                        if (vb) {
                            insert_textbox(element, '[hide=\"' + escape_comcode(va) + '\"]' + escape_comcode(vb) + '[/hide]');
                        }
                    },
                    '{!comcode:INPUT_COMCODE_hide;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_hide;^}'
    );
}

function do_input_thumb(field_name, va) {
    if (window.insert_textbox === undefined) return;

    if (window.start_simplified_upload !== undefined && document.getElementById(field_name).name != 'message') {
        var test = start_simplified_upload(field_name);
        if (test) return;
    }

    window.fauxmodal_prompt(
        '{!javascript:ENTER_URL;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('://') == -1)) {
                window.fauxmodal_alert('{!javascript:NOT_A_URL;^}', function () {
                    do_input_url(field_name, va);
                });
                return;
            }

            if (va) {
                generate_question_ui(
                    '{!javascript:THUMB_OR_IMG_2;^}',
                    {buttons__thumbnail: '{!THUMBNAIL;^}', buttons__fullsize: '{!IMAGE;^}'},
                    '{!comcode:INPUT_COMCODE_img;^}',
                    null,
                    function (vb) {
                        window.fauxmodal_prompt(
                            '{!javascript:ENTER_IMAGE_CAPTION;^}',
                            '',
                            function (vc) {
                                if (!vc) vc = '';

                                var element = document.getElementById(field_name);
                                if (vb.toLowerCase() == '{!IMAGE;^}'.toLowerCase()) {
                                    insert_textbox(element, '[img=\"' + escape_comcode(vc) + '\"]' + escape_comcode(va) + '[/img]');
                                } else {
                                    insert_textbox(element, '[thumb caption=\"' + escape_comcode(vc) + '\"]' + escape_comcode(va) + '[/thumb]');
                                }
                            },
                            '{!comcode:INPUT_COMCODE_img;^}'
                        );
                    }
                );
            }
        },
        '{!comcode:INPUT_COMCODE_img;^}'
    );
}

function do_input_attachment(field_name) {
    if (window.insert_textbox === undefined) {
        return;
    }

    window.fauxmodal_prompt(
        '{!javascript:ENTER_ATTACHMENT;^}',
        '',
        function (val) {
            if (!is_integer(val)) {
                window.fauxmodal_alert('{!javascript:NOT_VALID_ATTACHMENT;^}');
            } else {
                var element = document.getElementById(field_name);
                insert_textbox(element, '[attachment]new_' + val + '[/attachment]');
            }
        },
        '{!comcode:INPUT_COMCODE_attachment;^}'
    );

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
}

function do_input_url(field_name, va) {
    if (window.insert_textbox === undefined) return;

    window.fauxmodal_prompt(
        '{!javascript:ENTER_URL;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('://') == -1)) {
                window.fauxmodal_alert('{!javascript:NOT_A_URL;^}', function () {
                    do_input_url(field_name, va);
                });
                return;
            }

            if (va !== null) {
                window.fauxmodal_prompt(
                    '{!javascript:ENTER_LINK_NAME;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(field_name);
                        if (vb != null) insert_textbox(element, '[url=\"' + escape_comcode(vb) + '\"]' + escape_comcode(va) + '[/url]');
                    },
                    '{!comcode:INPUT_COMCODE_url;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_url;^}'
    );
}

function do_input_page(field_name) {
    if (window.insert_textbox === undefined) {
        return;
    }

    var result;

    if ((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION.jsOverlays) {
        window.faux_showModalDialog(
            maintain_theme_in_link('{$FIND_SCRIPT;,page_link_chooser}' + keep_stub(true)),
            null,
            'dialogWidth=600;dialogHeight=400;status=no;unadorned=yes',
            function (result) {
                if ((result === undefined) || (result === null)) return;

                window.fauxmodal_prompt(
                    '{!javascript:ENTER_CAPTION;^}',
                    '',
                    function (vc) {
                        _do_input_page(field_name, result, vc);
                    },
                    '{!comcode:INPUT_COMCODE_page;^}'
                );
            }
        );
    } else {
        window.fauxmodal_prompt(
            '{!javascript:ENTER_ZONE;^}',
            '',
            function (va) {
                if (va !== null) {
                    window.fauxmodal_prompt(
                        '{!javascript:ENTER_PAGE;^}',
                        '',
                        function (vb) {
                            if (vb !== null) {
                                result = va + ':' + vb;

                                window.fauxmodal_prompt(
                                    '{!javascript:ENTER_CAPTION;^}',
                                    '',
                                    function (vc) {
                                        _do_input_page(field_name, result, vc);
                                    },
                                    '{!comcode:INPUT_COMCODE_page;^}'
                                );
                            }
                        }
                    );
                }
            },
            '{!comcode:INPUT_COMCODE_page;^}'
        );
    }
}

function _do_input_page(field_name, result, vc) {
    var element = document.getElementById(field_name);
    insert_textbox(element, '[page=\"' + escape_comcode(result) + '\"]' + escape_comcode(vc) + '[/page]');
}

function do_input_email(field_name, va) {
    if (window.insert_textbox === undefined) return;

    window.fauxmodal_prompt(
        '{!javascript:ENTER_ADDRESS;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('@') == -1)) {
                window.fauxmodal_alert('{!javascript:NOT_A_EMAIL;^}', function () {
                    do_input_url(field_name, va);
                });
                return;
            }

            if (va !== null) {
                window.fauxmodal_prompt(
                    '{!javascript:ENTER_CAPTION;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(field_name);
                        if (vb !== null) insert_textbox(element, '[email=\"' + escape_comcode(vb) + '\"]' + escape_comcode(va) + '[/email]');
                    },
                    '{!comcode:INPUT_COMCODE_email;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_email;^}'
    );
}

function do_input_b(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var element = document.getElementById(field_name);
    insert_textbox_wrapping(element, 'b', '');
}

function do_input_i(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var element = document.getElementById(field_name);
    insert_textbox_wrapping(element, 'i', '');
}

function do_input_font(field_name) {
    if (window.insert_textbox_wrapping === undefined) return;

    var element = document.getElementById(field_name);
    var form = element.form;
    var face = form.elements['f_face'];
    var size = form.elements['f_size'];
    var colour = form.elements['f_colour'];
    if ((face.value == '') && (size.value == '') && (colour.value == '')) {
        window.fauxmodal_alert('{!javascript:NO_FONT_SELECTED;^}');
        return;
    }
    insert_textbox_wrapping(document.getElementById(field_name), '[font=\"' + escape_comcode(face.value) + '\" color=\"' + escape_comcode(colour.value) + '\" size=\"' + escape_comcode(size.value) + '\"]', '[/font]');
}

// ==================
// Auto-saving/drafts
// ==================

/*
 We support both remote and local saving.

 The advantage of local saving is that it works when you're offline or the server is offline.
 Also, it is faster because no load/save network requests are required.

 The advantage of remove saving is you can switch machines.
 */

function init_form_saving(form_id) {
    window.last_autosave = new Date();

    $cms.log('Initialising auto-save subsystem');

    // Go through all forms/elements
    var form = document.getElementById(form_id);
    for (var i = 0; i < form.elements.length; i++) {
        if (field_supports_autosave(form.elements[i])) {
            // Register events for auto-save
            form.elements[i].addEventListener('keypress', handle_form_saving);
            form.elements[i].addEventListener('blur', handle_form_saving);
            form.elements[i].externalOnKeyPress = handle_form_saving;
        }
    }

    // Register event for explicit draft save
    document.body.addEventListener('keydown', function (form) {
        return function (event) {
            handle_form_saving_explicit(event, form);
        }
    }(form));

    // Load via local storage
    var autosave_value = read_cookie(encodeURIComponent(get_autosave_url_stem()));
    if ((autosave_value != '') && (autosave_value != '0')) {
        if (window.localStorage !== undefined) {
            var fields_to_do = {}, fields_to_do_counter = 0, biggest_length_data = '';
            var key, value;
            var element_name, autosave_name;
            for (var j = 0; j < form.elements.length; j++) {
                element_name = (form.elements[j].name === undefined) ? form.elements[0][j].name : form.elements[j].name;
                autosave_name = get_autosave_name(element_name);
                if (localStorage[autosave_name] !== undefined) {
                    key = autosave_name;
                    value = localStorage[autosave_name];

                    fields_to_do[element_name] = value;
                    fields_to_do_counter++;
                    if (value.length > biggest_length_data.length) // The longest is what we quote to the user as being restored
                    {
                        biggest_length_data = value;
                    }

                    $cms.log('+ Has autosave for ' + element_name + ' (' + autosave_name + ')');
                } else {
                    $cms.log('- Has no autosave for ' + element_name);
                }
            }

            if ((fields_to_do_counter != 0) && (biggest_length_data.length > 25)) {
                _restore_form_autosave(form, fields_to_do, biggest_length_data);
                return; // If we had it locally, we won't let it continue on to try via AJAX
            } else {
                $cms.log('No auto-save, fields found was ' + fields_to_do_counter + ', largest length was ' + biggest_length_data.length);
            }
        }
    } else {
        $cms.log('Nothing in local storage');
    }

    // Load via AJAX (if issue happened on another machine, or if we do not support local storage)
    if (navigator.onLine) {
        $cms.log('Searching AJAX for auto-save');

        var url = '{$FIND_SCRIPT;,autosave}?type=retrieve';
        url += '&stem=' + encodeURIComponent(get_autosave_url_stem());
        url += keep_stub();
        var callback = function (form) {
            return function (result) {
                $cms.log('Auto-save AJAX says', result);
                _retrieve_form_autosave(result, form);
            }
        }(form);
        do_ajax_request(url, callback);
    }
}

function _retrieve_form_autosave(result, form) {
    var fields_to_do = {}, fields_to_do_counter = 0, biggest_length_data = '';
    var key, value;
    var fields = result.getElementsByTagName('field');
    var element, element_name, autosave_name;
    for (var i = 0; i < fields.length; i++) {
        key = fields[i].getAttribute('key');
        value = fields[i].getAttribute('value');

        element = null;
        for (var j = 0; j < form.elements.length; j++) {
            element_name = (form.elements[j].name === undefined) ? form.elements[0][j].name : form.elements[j].name;
            autosave_name = get_autosave_name(element_name);
            if (autosave_name == key) {
                element = form.elements[j];
                break;
            }
        }

        if (element) {
            fields_to_do[element_name] = value;
            fields_to_do_counter++;
            if (value.length > biggest_length_data.length) // The longest is what we quote to the user as being restored
            {
                biggest_length_data = value;
            }
        }
    }

    if ((fields_to_do_counter != 0) && (biggest_length_data.length > 25)) {
        _restore_form_autosave(form, fields_to_do, biggest_length_data);
    } else {
        $cms.log('No auto-save, fields found was ' + fields_to_do_counter + ', largest length was ' + biggest_length_data.length);
    }
}

function _restore_form_autosave(form, fields_to_do, biggest_length_data) {
    var autosave_name;

    // If we've found something to restore then invite user to restore it
    biggest_length_data = biggest_length_data.replace(/<[^>]*>/g, '').replace(/\n/g, ' ').replace(/&nbsp;/g, ' '); // Strip HTML and new lines
    if (biggest_length_data.length > 100) biggest_length_data = biggest_length_data.substr(0, 100) + '...'; // Trim down if needed
    window.fauxmodal_confirm(
        '{!javascript:RESTORE_SAVED_FORM_DATA;^}\n\n' + biggest_length_data,
        function (result) {
            if (result) {
                for (key in fields_to_do) {
                    if (typeof fields_to_do[key] != 'string') continue;

                    if (form.elements[key] !== undefined) {
                        if (console.log !== undefined) console.log('Restoring ' + key);
                        clever_set_value(form, form.elements[key], fields_to_do[key]);
                    }
                }
            } else {
                // Was asked to throw the autosave away...

                set_cookie(encodeURIComponent(get_autosave_url_stem()), '0', 0.167/*4 hours*/); // Mark as not wanting to restore from local storage

                if (window.localStorage !== undefined) {
                    for (var key in fields_to_do) {
                        if (typeof fields_to_do[key] != 'string') continue;

                        autosave_name = get_autosave_name(key);
                        if (localStorage[autosave_name] !== undefined) {
                            delete localStorage[autosave_name];
                        }
                    }
                }
            }
        },
        '{!javascript:AUTO_SAVING;^}'
    );
}

function field_supports_autosave(element) {
    if ((element.length !== undefined) && (element.nodeName === undefined)) {
        // Radio button
        element = element[0];
    }

    if (element.name === undefined) return false;

    var name = element.name;
    if (name == '') return false;
    if (name.substr(-2) == '[]') return false;

    if (is_wysiwyg_field(element)) return true;

    if (element.disabled) return false;

    switch (element.localName) {
        case 'textarea':
        case 'select':
            return true;
        case 'input':
            switch (element.type) {
                case 'checkbox':
                case 'radio':
                case 'text':
                case 'color':
                case 'date':
                case 'datetime':
                case 'datetime-local':
                case 'email':
                case 'month':
                case 'number':
                case 'range':
                case 'tel':
                case 'time':
                case 'url':
                case 'week':
                    return true;
            }
    }

    return false;
}

function is_typed_input(element) {
    if ((element.length !== undefined) && (element.nodeName === undefined)) {
        // Radio button
        element = element[0];
    }

    switch (element.nodeName.toLowerCase()) {
        case 'textarea':
            return true;
        case 'input':
            switch (element.type) {
                case 'hidden':
                case 'text':
                case 'color':
                case 'date':
                case 'datetime':
                case 'datetime-local':
                case 'email':
                case 'month':
                case 'number':
                case 'range':
                case 'tel':
                case 'time':
                case 'url':
                case 'week':
                    return true;
            }
    }

    return false;
}

function handle_form_saving_explicit(event, form) {
    if (event.keyCode == 83/*s*/ && (navigator.platform.match('Mac') ? event.metaKey : event.ctrlKey) && (!navigator.platform.match('Mac') ? event.ctrlKey : event.metaKey) && (!event.altKey)) {
        $cms.log('Doing explicit auto-save');

        event.preventDefault(); // Prevent browser save dialog

        // Go through al fields to save
        var post = '', found_validated_field = false, temp;
        for (var i = 0; i < form.elements.length; i++) {
            if (form.elements[i].name == 'validated') found_validated_field = true;

            if (field_supports_autosave(form.elements[i])) {
                temp = _handle_form_saving(event, form.elements[i], true);
                if (temp) {
                    if (post != '') post += '&';
                    post += encodeURIComponent(temp[0]) + '=' + encodeURIComponent(temp[1]);
                }
            }
        }

        if (post != '') {
            document.body.style.cursor = 'wait';

            // Save remotely
            if (navigator.onLine) {
                post = modsecurity_workaround_ajax(post);
                do_ajax_request('{$FIND_SCRIPT_NOHTTP;,autosave}?type=store' + keep_stub(), function () {
                    if (document.body.style.cursor == 'wait') document.body.style.cursor = '';

                    var message = found_validated_field ? '{!javascript:DRAFT_SAVED_WITH_VALIDATION;^}' : '{!javascript:DRAFT_SAVED_WITHOUT_VALIDATION;^}';
                    fauxmodal_alert(message, null, '{!javascript:DRAFT_SAVE;^}');
                }, post);
            }
        }
    }
}

function handle_form_saving(event, element, force) {
    var temp = _handle_form_saving(event, element, force);
    if (temp) {
        var post = encodeURIComponent(temp[0]) + '=' + encodeURIComponent(temp[1]);

        // Save remotely
        if (navigator.onLine) {

            if ($cms.$DEV_MODE) {
                console.log('Doing AJAX auto-save');
            }

            post = modsecurity_workaround_ajax(post);
            do_ajax_request('{$FIND_SCRIPT_NOHTTP;,autosave}?type=store' + keep_stub(), function () {
            }, post);
        }
    }
}

function _handle_form_saving(event, element, force) {
    if (force === undefined) force = (event.type == 'blur');

    var this_date = new Date();
    if (!force) {
        if ((this_date.getTime() - window.last_autosave.getTime()) < 20 * 1000) return null; // Only save every 20 seconds
    }

    if (element === undefined) {
        element = event.target;
    }
    if ((element === undefined) || (element === null)) {
        return null; // Some weird error, perhaps an extension fired this event
    }

    var value = clever_find_value(element.form, element);
    if ((event.type == 'keypress') && (is_typed_input(element))) {
        value += String.fromCharCode(event.keyCode ? event.keyCode : event.charCode);
    }

    // Mark it as saved, so the server can clear it out when we submit, signally local storage should get deleted too
    var element_name = (element.name === undefined) ? element[0].name : element.name;
    var autosave_name = get_autosave_name(element_name);
    set_cookie(encodeURIComponent(get_autosave_url_stem()), '1', 0.167/*4 hours*/);

    window.last_autosave = this_date;

    // Save locally
    if (window.localStorage !== undefined) {
        if ($cms.$DEV_MODE) {
            console.log('Doing local storage auto-save for ' + element_name + ' (' + autosave_name + ')');
        }

        try {
            localStorage.setItem(autosave_name, value);
        } catch (e) {}; // Could have NS_ERROR_DOM_QUOTA_REACHED
    }

    return [autosave_name, value];
}

function clever_set_value(form, element, value) {
    if ((element.length !== undefined) && (element.nodeName === undefined)) {
        // Radio button
        element = element[0];
    }

    switch (element.nodeName.toLowerCase()) {
        case 'textarea':
            set_textbox(element, value, value);
            break;
        case 'select':
            for (var i = 0; i < element.options.length; i++) {
                if (element.options[i].value == value) {
                    element.selectedIndex = i;
                    if ($(element).select2 !== undefined) {
                        $(element).trigger('change');
                    }
                }
            }
            break;
        case 'input':
            switch (element.type) {
                case 'checkbox':
                    element.checked = (value != '');
                    break;

                case 'radio':
                    value = '';
                    for (var i = 0; i < form.elements.length; i++) {
                        if ((form.elements[i].name == element.name) && (form.elements[i].value == value))
                            form.elements[i].checked = true;
                    }
                    break;

                case 'text':
                case 'color':
                case 'date':
                case 'datetime':
                case 'datetime-local':
                case 'email':
                case 'month':
                case 'number':
                case 'range':
                case 'search':
                case 'tel':
                case 'time':
                case 'url':
                case 'week':
                    element.value = value;
                    break;
            }
    }

    if (element.onchange) element.onchange();
}

function get_autosave_url_stem() {
    var name = 'cms_autosave_' + window.location.pathname;
    if (window.location.search.indexOf('type=') != -1) {
        name += window.location.search.replace(/[\?&]redirect=.*/, '').replace(/[\?&]keep_\w+=.*/, '').replace(/[\?&]cat=.*/, '');
    }
    name = name.replace(/\./, '_'); // PHP can't use dots in field names
    return name;
}

function get_autosave_name(field_name) {
    return get_autosave_url_stem() + ':' + field_name;
}
