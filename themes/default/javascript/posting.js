"use strict";

/* Form editing code (mostly stuff only used on posting forms) */

// ===========
// ATTACHMENTS
// ===========

function addAttachment(startNum, postingFieldName) {
    if (window.num_attachments === undefined) return;
    if (window.max_attachments === undefined) return;

    var addTo = document.getElementById('attachment_store');

    window.num_attachments++;

    // Add new file input, if we are using naked file inputs
    if (window.attachment_template.replace(/\s/, '') != '') {
        var newDiv = document.createElement('div');
        $cms.dom.html(newDiv, window.attachment_template.replace(/\_\_num_attachments\_\_/g, window.num_attachments));
        addTo.appendChild(newDiv);
    }

    // Rebuild uploader button, if we have a singular button
    if (window.rebuildAttachmentButtonForNext != null) {
        rebuildAttachmentButtonForNext(postingFieldName);
    }

    // Previous file input cannot be used anymore, if it exists
    var element = document.getElementById('file' + window.num_attachments);
    if (element) {
        element.setAttribute('unselectable', 'on');
    }

    $cms.dom.triggerResize();
}

function attachmentPresent(postValue, number) {
    return !(postValue.indexOf('[attachment]new_' + number + '[/attachment]') == -1) && (postValue.indexOf('[attachment_safe]new_' + number + '[/attachment_safe]') == -1) && (postValue.indexOf('[attachment thumb="1"]new_' + number + '[/attachment]') == -1) && (postValue.indexOf('[attachment_safe thumb="1"]new_' + number + '[/attachment_safe]') == -1) && (postValue.indexOf('[attachment thumb="0"]new_' + number + '[/attachment]') == -1) && (postValue.indexOf('[attachment_safe thumb="0"]new_' + number + '[/attachment_safe]') == -1);
}

function setAttachment(fieldName, number, filename, multi, uploaderSettings) {
    multi = !!multi;

    if (window.insertTextbox === undefined) return;
    if (window.num_attachments === undefined) return;
    if (window.max_attachments === undefined) return;

    var post = document.getElementById(fieldName);

    var tmpForm = post.form;
    if ((tmpForm) && (tmpForm.preview)) {
        tmpForm.preview.checked = false;
        tmpForm.preview.disabled = true;
    }

    var postValue = getTextbox(post);
    var done = attachmentPresent(post.value, number) || attachmentPresent(postValue, number);
    if (!done) {
        var filepath = filename;
        if ((!filename) && (document.getElementById('file' + number))) {
            filepath = document.getElementById('file' + number).value;
        }

        if (filepath == '')
            return; // Upload error

        var ext = filepath.replace(/^.*\./, '').toLowerCase();

        var isImage = (',{$CONFIG_OPTION;,valid_images},'.indexOf(',' + ext + ',') != -1);
        var isVideo = (',{$CONFIG_OPTION;,valid_videos},'.indexOf(',' + ext + ',') != -1);
        var isAudio = (',{$CONFIG_OPTION;,valid_audios},'.indexOf(',' + ext + ',') != -1);
        var isArchive = (ext == 'tar') || (ext == 'zip');

        var prefix = '', suffix = '';
        if (multi && isImage) {
            prefix = '[media_set]\n';
            suffix = '[/media_set]';
        }

        var tag = 'attachment';

        var showOverlay, defaults = {};
        if (filepath.indexOf('fakepath') === -1) // iPhone gives c:\fakepath\image.jpg, so don't use that
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
        defaults.thumb = ($cms.$CONFIG_OPTION('simplified_attachments_ui') && isImage && !multi) ? '0' : '1';
        defaults.type = ''; // =autodetect rendering type

        // Shall we show the options overlay?
        showOverlay = !(multi || (isImage && $cms.$CONFIG_OPTION('simplified_attachments_ui')) || isArchive);

        if (isImage) {
            tag = 'attachment_safe';
        }

        if (multi || isImage) {
            defaults.framed = '0';
        }

        /*== END ATTACHMENT_UI_DEFAULTS.js ==*/

        if (!showOverlay) {
            var comcode = '[' + tag;
            for (var key in defaults) {
                comcode += ' ' + key + '="' + (defaults[key].replace(/"/g, '\\"')) + '"';
            }
            comcode += ']new_' + number + '[/' + tag + ']';
            if (prefix != '') insertTextbox(post, prefix);
            if (multi) {
                var splitFilename = document.getElementById('txtFileName_file' + window.num_attachments).value.split(/:/);
                for (var i = 0; i < splitFilename.length; i++) {
                    if (i != 0) window.num_attachments++;
                    insertTextbox(
                        post,
                        comcode.replace(']new_' + number + '[', ']new_' + window.num_attachments + '[')
                    );
                }
                number = '' + (window.parseInt(number) + splitFilename.length - 1);
            } else {
                insertTextbox(
                    post,
                    comcode,
                    document.selection ? document.selection : null
                );
            }
            if (suffix != '') {
                insertTextbox(post, suffix);
            }

            // Add field for next one
            var addAnotherField = (number == window.num_attachments) && (window.num_attachments < window.max_attachments); // Needs running late, in case something happened inbetween
            if (addAnotherField) {
                addAttachment(window.num_attachments + 1, fieldName);
            }

            if (uploaderSettings !== undefined) {
                uploaderSettings.callbacks.push(function () {
                    // Do insta-preview
                    if ($cms.form.isWysiwygField(post)) {
                        generateBackgroundPreview(post);
                    }
                });
            }

            return;
        }

        var wysiwyg = $cms.form.isWysiwygField(post);

        var url = '{$FIND_SCRIPT;,comcode_helper}';
        url += '?field_name=' + fieldName;
        url += '&type=step2';
        url += '&tag=' + tag;
        url += '&default=new_' + number;
        url += '&is_image=' + (isImage ? '1' : '0');
        url += '&is_archive=' + (isArchive ? '1' : '0');
        url += '&multi=' + (multi ? '1' : '0');
        url += '&prefix=' + prefix;
        if (wysiwyg) url += '&in_wysiwyg=1';
        for (var key in defaults) {
            url += '&default_' + key + '=' + encodeURIComponent(defaults[key]);
        }
        url += $cms.keepStub();

        window.setTimeout(function () {
            $cms.ui.showModalDialog(
                $cms.maintainThemeInLink(url),
                '',
                'width=750,height=auto,status=no,resizable=yes,scrollbars=yes,unadorned=yes',
                function (comcodeAdded) {
                    if (comcodeAdded) {
                        // Add in additional Comcode buttons for the other files selected at the same time
                        if (multi) {
                            var comcodeSemihtml = '', comcode = '';
                            var splitFilename = document.getElementById('txtFileName_file' + window.num_attachments).value.split(/:/);
                            for (var i = 1; i < splitFilename.length; i++) {
                                window.num_attachments++;
                                var tmp = window.insert_comcode_tag(']new_' + number + '[', ']new_' + window.num_attachments + '[', true);
                                comcodeSemihtml += tmp[0];
                                comcode += tmp[1];
                            }
                            number = '' + (window.parseInt(number) + splitFilename.length - 1);

                            if (suffix != '') {
                                comcode += suffix;
                                comcodeSemihtml += suffix;
                            }

                            insertTextbox(post, comcode, null, true, comcodeSemihtml);
                        }

                        // Add field for next one
                        var addAnotherField = (number == window.num_attachments) && (window.num_attachments < window.max_attachments); // Needs running late, in case something happened inbetween
                        if (addAnotherField) {
                            addAttachment(window.num_attachments + 1, fieldName);
                        }

                        // Do insta-preview
                        if ((comcodeAdded.indexOf('[attachment_safe') !== -1) && ($cms.form.isWysiwygField(post))) {
                            generateBackgroundPreview(post);
                        }
                    } else { // Cancelled
                        var clearButton = document.getElementById('fsClear_file' + number);
                        if (clearButton) {
                            clearButton.onclick();
                        }
                    }
                }
            );
        }, 800); // In a timeout to disassociate possible 'enter' keypress which could have led to this function being called [enter on the file selection dialogue] and could propagate through (on Google Chrome anyways, maybe a browser bug)
    } else {
        // Add field for next one
        var addAnotherField = (number == window.num_attachments) && (window.num_attachments < window.max_attachments);
        if (addAnotherField)
            addAttachment(window.num_attachments + 1, fieldName);
    }
}

function generateBackgroundPreview(post) {
    var formPost = '';
    var form = post.form;

    for (var i = 0; i < form.elements.length; i++) {
        if ((!form.elements[i].disabled) && ( form.elements[i].name !== undefined) && (form.elements[i].name != '')) {
            var name = form.elements[i].name;
            var value = $cms.form.cleverFindValue(form, form.elements[i]);
            if ((name === 'title') && (value === '')) {  // Fudge, title must be filled in on many forms
                value = 'x';
            }
            formPost += '&' + name + '=' + encodeURIComponent(value);
        }
    }
    formPost = $cms.form.modsecurityWorkaroundAjax(formPost.substr(1));
    /*FIXME: Synchronous XHR*/
    var previewRet = $cms.doAjaxRequest(window.form_preview_url + '&js_only=1&known_utf8=1', null, formPost);
    /*FIXME: eval() call*/
    eval(previewRet.responseText.replace('<script>', '').replace('</script>', ''));
}

// ====================
// COMCODE UI FUNCTIONS
// ====================

function do_input_html(fieldName) {
    if (window.insertTextboxWrapping === undefined) return;

    var post = document.getElementById(fieldName);
    insertTextboxWrapping(post, 'semihtml', '');
}

function do_input_code(fieldName) {
    if (window.insertTextboxWrapping === undefined) return;

    var post = document.getElementById(fieldName);
    insertTextboxWrapping(post, (post.name == 'message') ? 'tt' : 'codebox', '');
}

function do_input_quote(fieldName) {
    if (window.insertTextboxWrapping === undefined) return;

    var post = document.getElementById(fieldName);
    $cms.ui.prompt(
        '{!javascript:ENTER_QUOTE_BY;^}',
        '',
        function (va) {
            if (va !== null) insertTextboxWrapping(post, '[quote=\"' + va + '\"]', '[/quote]');
        },
        '{!comcode:INPUT_COMCODE_quote;^}'
    );
}

function do_input_box(fieldName) {
    if (window.insertTextboxWrapping === undefined) return;

    var post = document.getElementById(fieldName);
    $cms.ui.prompt(
        '{!javascript:ENTER_BOX_TITLE;^}',
        '',
        function (va) {
            if (va !== null) insertTextboxWrapping(post, '[box=\"' + va + '\"]', '[/box]');
        },
        '{!comcode:INPUT_COMCODE_box;^}'
    );
}

function do_input_menu(fieldName) {
    if (window.insertTextbox === undefined) return;

    $cms.ui.prompt(
        '{!javascript:ENTER_MENU_NAME;^,' + (document.getElementById(fieldName).form.menu_items.value) + '}',
        '',
        function (va) {
            if (va) {
                $cms.ui.prompt(
                    '{!javascript:ENTER_MENU_CAPTION;^}',
                    '',
                    function (vb) {
                        if (!vb) {
                            vb = '';
                        }

                        var add;
                        var element = document.getElementById(fieldName);
                        add = '[block=\""+$cms.filter.comcode(va)+"\" caption=\""+$cms.filter.comcode(vb)+"\" type=\"tree\"]menu[/block]';
                        insertTextbox(element, add);
                    },
                    '{!comcode:INPUT_COMCODE_menu;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_menu;^}'
    );
}

function do_input_block(fieldName) {
    var url = '{$FIND_SCRIPT;,block_helper}?field_name=' + fieldName + $cms.keepStub();
    url = url + '&block_type=' + (((fieldName.indexOf('edit_panel_') == -1) && (window.location.href.indexOf(':panel_') == -1)) ? 'main' : 'side');
    $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
}

function do_input_comcode(fieldName, tag) {
    var attributes = {};
    var defaultEmbed = null;
    var saveToId = null;

    if (tag == null) {
        var element = document.getElementById(fieldName);
        if ($cms.form.isWysiwygField(element)) {
            var selection = window.wysiwyg_editors[fieldName].getSelection();
            var ranges = selection.getRanges();
            if ( ranges[0] !== undefined) {
                var comcodeElement = ranges[0].startContainer.$;
                do {
                    var matches = comcodeElement.localName.match(/^comcode-(\w+)/);
                    if (matches !== null) {
                        tag = matches[1];

                        for (var i = 0; i < comcodeElement.attributes.length; i++) {
                            if (comcodeElement.attributes[i].name != 'id') {
                                attributes[comcodeElement.attributes[i].name] = comcodeElement.attributes[i].value;
                            }
                        }

                        defaultEmbed = $cms.dom.html(comcodeElement);

                        if (comcodeElement.id == '') {
                            comcodeElement.id = 'comcode_' + Date.now();
                        }
                        saveToId = comcodeElement.id;

                        break;
                    }

                    comcodeElement = comcodeElement.parentNode;
                } while (comcodeElement !== null);
            }
        }
    }

    var url = '{$FIND_SCRIPT;,comcode_helper}?field_name=' + encodeURIComponent(fieldName);
    if (tag) {
        url += '&tag=' + encodeURIComponent(tag);
    }
    if (defaultEmbed !== null) {
        url += '&type=replace';
    } else {
        if (tag == null) {
            url += '&type=step1';
        } else {
            url += '&type=step2';
        }
    }
    if ($cms.form.isWysiwygField(document.getElementById(fieldName))) url += '&in_wysiwyg=1';
    for (var key in attributes) {
        url += '&default_' + key + '=' + encodeURIComponent(attributes[key]);
    }
    if (defaultEmbed !== null) {
        url += '&default=' + encodeURIComponent(defaultEmbed);
    }
    if (saveToId !== null) {
        url += '&save_to_id=' + encodeURIComponent(saveToId);
    }
    url += $cms.keepStub();

    $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
}

function do_input_list(fieldName, add) {
    if (window.insertTextbox === undefined) return;

    if (add === undefined) add = [];

    var post = document.getElementById(fieldName);
    insertTextbox(post, '\n');
    $cms.ui.prompt(
        '{!javascript:ENTER_LIST_ENTRY;^}',
        '',
        function (va) {
            if ((va != null) && (va != '')) {
                add.push(va);
                return do_input_list(fieldName, add)
            }
            if (add.length == 0) return;
            var i;
            if (post.value.indexOf('[semihtml') != -1)
                insertTextbox(post, '[list]\n');
            for (i = 0; i < add.length; i++) {
                if (post.value.indexOf('[semihtml') != -1) {
                    insertTextbox(post, '[*]' + add[i] + '\n')
                } else {
                    insertTextbox(post, ' - ' + add[i] + '\n')
                }
            }
            if (post.value.indexOf('[semihtml') != -1)
                insertTextbox(post, '[/list]\n')
        },
        '{!comcode:INPUT_COMCODE_list;^}'
    );
}

function do_input_hide(fieldName) {
    if (window.insertTextbox === undefined) return;

    $cms.ui.prompt(
        '{!javascript:ENTER_WARNING;^}',
        '',
        function (va) {
            if (va) {
                $cms.ui.prompt(
                    '{!javascript:ENTER_HIDDEN_TEXT;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(fieldName);
                        if (vb) {
                            insertTextbox(element, '[hide=\"' + $cms.filter.comcode(va) + '\"]' + $cms.filter.comcode(vb) + '[/hide]');
                        }
                    },
                    '{!comcode:INPUT_COMCODE_hide;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_hide;^}'
    );
}

function do_input_thumb(fieldName, va) {
    if (window.insertTextbox === undefined) {
        return;
    }

    if ((window.start_simplified_upload !== undefined) && (document.getElementById(fieldName).name != 'message')) {
        var test = start_simplified_upload(fieldName);
        if (test) return;
    }

    $cms.ui.prompt(
        '{!javascript:ENTER_URL;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('://') == -1)) {
                $cms.ui.alert('{!javascript:NOT_A_URL;^}', function () {
                    do_input_url(fieldName, va);
                });
                return;
            }

            if (va) {
                $cms.ui.generateQuestionUi(
                    '{!javascript:THUMB_OR_IMG_2;^}',
                    {buttons__thumbnail: '{!THUMBNAIL;^}', buttons__fullsize: '{!IMAGE;^}'},
                    '{!comcode:INPUT_COMCODE_img;^}',
                    null,
                    function (vb) {
                        $cms.ui.prompt(
                            '{!javascript:ENTER_IMAGE_CAPTION;^}',
                            '',
                            function (vc) {
                                if (!vc) vc = '';

                                var element = document.getElementById(fieldName);
                                if (vb.toLowerCase() == '{!IMAGE;^}'.toLowerCase()) {
                                    insertTextbox(element, '[img=\"' + $cms.filter.comcode(vc) + '\"]' + $cms.filter.comcode(va) + '[/img]');
                                } else {
                                    insertTextbox(element, '[thumb caption=\"' + $cms.filter.comcode(vc) + '\"]' + $cms.filter.comcode(va) + '[/thumb]');
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

function do_input_attachment(fieldName) {
    if (window.insertTextbox === undefined) {
        return;
    }

    $cms.ui.prompt(
        '{!javascript:ENTER_ATTACHMENT;^}',
        '',
        function (val) {
            if (!isInteger(val)) {
                $cms.ui.alert('{!javascript:NOT_VALID_ATTACHMENT;^}');
            } else {
                var element = document.getElementById(fieldName);
                insertTextbox(element, '[attachment]new_' + val + '[/attachment]');
            }
        },
        '{!comcode:INPUT_COMCODE_attachment;^}'
    );

    /* Type checking */
    function isInteger(val) {
        if (val == '') return false;
        var c;
        for (var i = 0; i < val.length; i++) {
            c = val.charAt(i);
            if ((c != '0') && (c != '1') && (c != '2') && (c != '3') && (c != '4') && (c != '5') && (c != '6') && (c != '7') && (c != '8') && (c != '9')) {
                return false;
            }
        }
        return true;
    }
}

function do_input_url(fieldName, va) {
    if (window.insertTextbox === undefined) {
        return;
    }

    $cms.ui.prompt(
        '{!javascript:ENTER_URL;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('://') == -1)) {
                $cms.ui.alert('{!javascript:NOT_A_URL;^}', function () {
                    do_input_url(fieldName, va);
                });
                return;
            }

            if (va !== null) {
                $cms.ui.prompt(
                    '{!javascript:ENTER_LINK_NAME;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(fieldName);
                        if (vb != null) insertTextbox(element, '[url=\"' + $cms.filter.comcode(vb) + '\"]' + $cms.filter.comcode(va) + '[/url]');
                    },
                    '{!comcode:INPUT_COMCODE_url;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_url;^}'
    );
}

function do_input_page(fieldName) {
    if (window.insertTextbox === undefined) {
        return;
    }

    var result;

    if (($cms.ui.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) {
        $cms.ui.showModalDialog(
            $cms.maintainThemeInLink('{$FIND_SCRIPT;,page_link_chooser}' + $cms.keepStub(true)),
            null,
            'dialogWidth=600;dialogHeight=400;status=no;unadorned=yes',
            function (result) {
                if ((result === undefined) || (result === null)) return;

                $cms.ui.prompt(
                    '{!javascript:ENTER_CAPTION;^}',
                    '',
                    function (vc) {
                        _doInputPage(fieldName, result, vc);
                    },
                    '{!comcode:INPUT_COMCODE_page;^}'
                );
            }
        );
    } else {
        $cms.ui.prompt(
            '{!javascript:ENTER_ZONE;^}',
            '',
            function (va) {
                if (va !== null) {
                    $cms.ui.prompt(
                        '{!javascript:ENTER_PAGE;^}',
                        '',
                        function (vb) {
                            if (vb !== null) {
                                result = va + ':' + vb;

                                $cms.ui.prompt(
                                    '{!javascript:ENTER_CAPTION;^}',
                                    '',
                                    function (vc) {
                                        _doInputPage(fieldName, result, vc);
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

    function _doInputPage(fieldName, result, vc) {
        var element = document.getElementById(fieldName);
        insertTextbox(element, '[page=\"' + $cms.filter.comcode(result) + '\"]' + $cms.filter.comcode(vc) + '[/page]');
    }
}

function do_input_email(fieldName, va) {
    if (window.insertTextbox === undefined) return;

    $cms.ui.prompt(
        '{!javascript:ENTER_ADDRESS;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('@') == -1)) {
                $cms.ui.alert('{!javascript:NOT_A_EMAIL;^}', function () {
                    do_input_url(fieldName, va);
                });
                return;
            }

            if (va !== null) {
                $cms.ui.prompt(
                    '{!javascript:ENTER_CAPTION;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(fieldName);
                        if (vb !== null) insertTextbox(element, '[email=\"' + $cms.filter.comcode(vb) + '\"]' + $cms.filter.comcode(va) + '[/email]');
                    },
                    '{!comcode:INPUT_COMCODE_email;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_email;^}'
    );
}

function do_input_b(fieldName) {
    if (window.insertTextboxWrapping === undefined) return;

    var element = document.getElementById(fieldName);
    insertTextboxWrapping(element, 'b', '');
}

function do_input_i(fieldName) {
    if (window.insertTextboxWrapping === undefined) return;

    var element = document.getElementById(fieldName);
    insertTextboxWrapping(element, 'i', '');
}


function do_input_font(fieldName) {
    if (window.insertTextboxWrapping === undefined) {
        return;
    }

    var element = document.getElementById(fieldName);
    var form = element.form;
    var face = form.elements['f_face'];
    var size = form.elements['f_size'];
    var colour = form.elements['f_colour'];
    if ((face.value == '') && (size.value == '') && (colour.value == '')) {
        $cms.ui.alert('{!javascript:NO_FONT_SELECTED;^}');
        return;
    }
    insertTextboxWrapping(document.getElementById(fieldName), '[font=\"' + $cms.filter.comcode(face.value) + '\" color=\"' + $cms.filter.comcode(colour.value) + '\" size=\"' + $cms.filter.comcode(size.value) + '\"]', '[/font]');
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

function initFormSaving(formId) {
    window.last_autosave = new Date();

    $cms.log('Initialising auto-save subsystem');

    // Go through all forms/elements
    var form = document.getElementById(formId);
    for (var i = 0; i < form.elements.length; i++) {
        if (fieldSupportsAutosave(form.elements[i])) {
            // Register events for auto-save
            form.elements[i].addEventListener('keypress', handleFormSaving);
            form.elements[i].addEventListener('blur', handleFormSaving);
            form.elements[i].externalOnKeyPress = handleFormSaving;
        }
    }

    // Register event for explicit draft save
    document.body.addEventListener('keydown', function (form) {
        return function (event) {
            handleFormSavingExplicit(event, form);
        }
    }(form));

    // Load via local storage
    var autosaveValue = $cms.readCookie(encodeURIComponent(getAutosaveUrlStem()));
    if ((autosaveValue != '') && (autosaveValue != '0')) {
        if (window.localStorage !== undefined) {
            var fieldsToDo = {}, fieldsToDoCounter = 0, biggestLengthData = '';
            var key, value;
            var elementName, autosaveName;
            for (var j = 0; j < form.elements.length; j++) {
                elementName = (form.elements[j].name === undefined) ? form.elements[0][j].name : form.elements[j].name;
                autosaveName = getAutosaveName(elementName);
                if (localStorage[autosaveName] !== undefined) {
                    key = autosaveName;
                    value = localStorage[autosaveName];

                    if (typeof form.elements[j].value != 'undefined' && form.elements[j].value.replace(/\s/g, '') == value.replace(/\s/g, '')) {
                        continue;
                    }

                    fieldsToDo[elementName] = value;

                    fieldsToDoCounter++;

                    if (value.length > biggestLengthData.length) // The longest is what we quote to the user as being restored
                    {
                        biggestLengthData = value;
                    }

                    $cms.log('+ Has autosave for ' + elementName + ' (' + autosaveName + ')');
                } else {
                    $cms.log('- Has no autosave for ' + elementName);
                }
            }

            if ((fieldsToDoCounter != 0) && (biggestLengthData.length > 25)) {
                _restoreFormAutosave(form, fieldsToDo, biggestLengthData);
                return; // If we had it locally, we won't let it continue on to try via AJAX
            } else {
                $cms.log('No auto-save, fields found was ' + fieldsToDoCounter + ', largest length was ' + biggestLengthData.length);
            }
        }
    } else {
        $cms.log('Nothing in local storage');
    }

    // Load via AJAX (if issue happened on another machine, or if we do not support local storage)
    if (navigator.onLine) {
        $cms.log('Searching AJAX for auto-save');

        var url = '{$FIND_SCRIPT_NOHTTP;,autosave}?type=retrieve';
        url += '&stem=' + encodeURIComponent(getAutosaveUrlStem());
        url += $cms.keepStub();
        var callback = function (form) {
            return function (result) {
                $cms.log('Auto-save AJAX says', result);
                _retrieveFormAutosave(result, form);
            }
        }(form);
        $cms.doAjaxRequest(url, callback);
    }

    function handleFormSavingExplicit(event, form) {
        if (event.keyCode == 83/*s*/ && (navigator.platform.match('Mac') ? event.metaKey : event.ctrlKey) && (!navigator.platform.match('Mac') ? event.ctrlKey : event.metaKey) && (!event.altKey)) {
            $cms.log('Doing explicit auto-save');

            event.preventDefault(); // Prevent browser save dialog

            // Go through al fields to save
            var post = '', foundValidatedField = false, temp;
            for (var i = 0; i < form.elements.length; i++) {
                if (form.elements[i].name == 'validated') foundValidatedField = true;

                if (fieldSupportsAutosave(form.elements[i])) {
                    temp = _handleFormSaving(event, form.elements[i], true);
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
                    post = $cms.form.modsecurityWorkaroundAjax(post);
                    $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,autosave}?type=store' + $cms.keepStub(), function () {
                        if (document.body.style.cursor == 'wait') document.body.style.cursor = '';

                        var message = foundValidatedField ? '{!javascript:DRAFT_SAVED_WITH_VALIDATION;^}' : '{!javascript:DRAFT_SAVED_WITHOUT_VALIDATION;^}';
                        $cms.ui.alert(message, null, '{!javascript:DRAFT_SAVE;^}');
                    }, post);
                }
            }
        }
    }


    function _retrieveFormAutosave(result, form) {
        var fieldsToDo = {}, fieldsToDoCounter = 0, biggestLengthData = '';
        var key, value;
        var fields = result.getElementsByTagName('field');
        var element, elementName, autosave_name;
        for (var i = 0; i < fields.length; i++) {
            key = fields[i].getAttribute('key');
            value = fields[i].getAttribute('value');

            element = null;
            for (var j = 0; j < form.elements.length; j++) {
                elementName = (form.elements[j].name === undefined) ? form.elements[0][j].name : form.elements[j].name;
                autosave_name = getAutosaveName(elementName);
                if (autosave_name == key) {
                    element = form.elements[j];
                    break;
                }
            }

            if (element) {
                if (typeof element.value != 'undefined' && element.value.replace(/\s/g, '') == value.replace(/\s/g, '')) {
                    continue;
                }

                fieldsToDo[elementName] = value;

                fieldsToDoCounter++;

                if (value.length > biggestLengthData.length) // The longest is what we quote to the user as being restored
                {
                    biggestLengthData = value;
                }
            }
        }

        if ((fieldsToDoCounter != 0) && (biggestLengthData.length > 25)) {
            _restoreFormAutosave(form, fieldsToDo, biggestLengthData);
        } else {
            $cms.log('No auto-save, fields found was ' + fieldsToDoCounter + ', largest length was ' + biggestLengthData.length);
        }
    }


    function _restoreFormAutosave(form, fieldsToDo, biggestLengthData) {
        var autosaveName;

        // If we've found something to restore then invite user to restore it
        biggestLengthData = biggestLengthData.replace(/<[^>]*>/g, '').replace(/\n/g, ' ').replace(/&nbsp;/g, ' '); // Strip HTML and new lines
        if (biggestLengthData.length > 100) { // Trim down if needed
            biggestLengthData = biggestLengthData.substr(0, 100) + '...';
        }

        $cms.ui.confirm(
            '{!javascript:RESTORE_SAVED_FORM_DATA;^}\n\n' + biggestLengthData,
            function (result) {
                if (result) {
                    for (key in fieldsToDo) {
                        if (typeof fieldsToDo[key] != 'string') continue;

                        if (form.elements[key] !== undefined) {
                            if (console.log !== undefined) console.log('Restoring ' + key);
                            cleverSetValue(form, form.elements[key], fieldsToDo[key]);
                        }
                    }
                } else {
                    // Was asked to throw the autosave away...

                    $cms.setCookie(encodeURIComponent(getAutosaveUrlStem()), '0', 0.167/*4 hours*/); // Mark as not wanting to restore from local storage

                    if (window.localStorage !== undefined) {
                        for (var key in fieldsToDo) {
                            if (typeof fieldsToDo[key] != 'string') continue;

                            autosaveName = getAutosaveName(key);
                            if (localStorage[autosaveName] !== undefined) {
                                delete localStorage[autosaveName];
                            }
                        }
                    }
                }
            },
            '{!javascript:AUTO_SAVING;^}'
        );
    }

    function cleverSetValue(form, element, value) {
        if ((element.length !== undefined) && (element.nodeName === undefined)) {
            // Radio button
            element = element[0];
        }

        switch (element.nodeName.toLowerCase()) {
            case 'textarea':
                setTextbox(element, value, value);
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

    function fieldSupportsAutosave(element) {
        if ((element.length !== undefined) && (element.nodeName === undefined)) {
            // Radio button
            element = element[0];
        }

        if (element.name === undefined) return false;

        var name = element.name;
        if (name == '') return false;
        if (name.substr(-2) == '[]') return false;

        if ($cms.form.isWysiwygField(element)) return true;

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
}

function handleFormSaving(event, element, force) {
    var temp = _handleFormSaving(event, element, force);
    if (temp) {
        var post = encodeURIComponent(temp[0]) + '=' + encodeURIComponent(temp[1]);

        // Save remotely
        if (navigator.onLine) {

            if ($cms.$DEV_MODE()) {
                console.log('Doing AJAX auto-save');
            }

            post = $cms.form.modsecurityWorkaroundAjax(post);
            $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,autosave}?type=store' + $cms.keepStub(), function () {
            }, post);
        }
    }
}

function _handleFormSaving(event, element, force) {
    if (force === undefined) force = (event.type == 'blur');

    var thisDate = new Date();
    if (!force) {
        if ((thisDate.getTime() - window.last_autosave.getTime()) < 20 * 1000) return null; // Only save every 20 seconds
    }

    if (element === undefined) {
        element = event.target;
    }
    if ((element === undefined) || (element === null)) {
        return null; // Some weird error, perhaps an extension fired this event
    }

    var value = $cms.form.cleverFindValue(element.form, element);
    if ((event.type == 'keypress') && (isTypedInput(element))) {
        value += String.fromCharCode(event.keyCode ? event.keyCode : event.charCode);
    }

    // Mark it as saved, so the server can clear it out when we submit, signally local storage should get deleted too
    var elementName = (element.name === undefined) ? element[0].name : element.name;
    var autosaveName = getAutosaveName(elementName);
    $cms.setCookie(encodeURIComponent(getAutosaveUrlStem()), '1', 0.167/*4 hours*/);

    window.last_autosave = thisDate;

    // Save locally
    if (window.localStorage !== undefined) {
        if ($cms.$DEV_MODE()) {
            console.log('Doing local storage auto-save for ' + elementName + ' (' + autosaveName + ')');
        }

        try {
            localStorage.setItem(autosaveName, value);
        } catch (e) {} // Could have NS_ERROR_DOM_QUOTA_REACHED
    }

    return [autosaveName, value];

    function isTypedInput(element) {
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
}

function getAutosaveUrlStem() {
    var name = 'cms_autosave_' + window.location.pathname;
    if (window.location.search.indexOf('type=') != -1) {
        name += window.location.search.replace(/[\?&]redirect=.*/, '').replace(/[\?&]keep_\w+=.*/, '').replace(/[\?&]cat=.*/, '');
    }
    name = name.replace(/\./, '_'); // PHP can't use dots in field names
    return name;
}

function getAutosaveName(fieldName) {
    return getAutosaveUrlStem() + ':' + fieldName;
}
