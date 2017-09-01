'use strict';

/* Form editing code (mostly stuff only used on posting forms) */

// ===========
// ATTACHMENTS
// ===========

/**
 * @param startNum
 * @param postingFieldName
 */
function addAttachment(startNum, postingFieldName) {
    if (window.numAttachments === undefined) return;
    if (window.maxAttachments === undefined) return;

    var addTo = document.getElementById('attachment_store');

    window.numAttachments++;

    // Add new file input, if we are using naked file inputs
    if (window.attachmentTemplate.replace(/\s/, '') !== '') {
        var newDiv = document.createElement('div');
        $cms.dom.html(newDiv, window.attachmentTemplate.replace(/\_\_numAttachments\_\_/g, window.numAttachments));
        addTo.appendChild(newDiv);
    }

    // Rebuild uploader button, if we have a singular button
    if (window.rebuildAttachmentButtonForNext != null) {
        window.rebuildAttachmentButtonForNext(postingFieldName);
    }

    // Previous file input cannot be used anymore, if it exists
    var element = document.getElementById('file' + window.numAttachments);
    if (element) {
        element.setAttribute('unselectable', 'on');
    }

    $cms.dom.triggerResize();
}

function attachmentPresent(postValue, number) {
    return !(postValue.indexOf('[attachment]new_' + number + '[/attachment]') === -1) && (postValue.indexOf('[attachment_safe]new_' + number + '[/attachment_safe]') === -1) && (postValue.indexOf('[attachment thumb="1"]new_' + number + '[/attachment]') === -1) && (postValue.indexOf('[attachment_safe thumb="1"]new_' + number + '[/attachment_safe]') === -1) && (postValue.indexOf('[attachment thumb="0"]new_' + number + '[/attachment]') === -1) && (postValue.indexOf('[attachment_safe thumb="0"]new_' + number + '[/attachment_safe]') === -1);
}

/**
 * @param fieldName
 * @param number
 * @param filename
 * @param multi
 * @param uploaderSettings
 * @return { Promise }
 */
function setAttachment(fieldName, number, filename, multi, uploaderSettings) {
    multi = boolVal(multi);
    
    return new Promise(function (resolvePromise) {
        var post = document.getElementById(fieldName),
            trueAttachmentUi = (post.classList.contains('true_attachment_ui')),
            tmpForm = post.form;

        if (tmpForm && tmpForm.preview) {
            tmpForm.preview.checked = false;
            tmpForm.preview.disabled = true;
        }

        var postValue = window.getTextbox(post),
            done = attachmentPresent(post.value, number) || attachmentPresent(postValue, number),
            addAnotherField;

        if (done) {
            // Add field for next one
            addAnotherField = (number == window.numAttachments) && (window.numAttachments < window.maxAttachments);
            if (addAnotherField) {
                addAttachment(window.numAttachments + 1, fieldName);
            }
            return resolvePromise();
        }

        var filepath = filename;

        if (!filename && document.getElementById('file' + number)) {
            filepath = document.getElementById('file' + number).value;
        }

        if (!filepath) { // Upload error
            return resolvePromise();
        }

        var ext = filepath.replace(/^.*\./, '').toLowerCase();
        var isImage = (',{$CONFIG_OPTION;,valid_images},'.indexOf(',' + ext + ',') !== -1);
        var isVideo = (',{$CONFIG_OPTION;,valid_videos},'.indexOf(',' + ext + ',') !== -1);
        var isAudio = (',{$CONFIG_OPTION;,valid_audios},'.indexOf(',' + ext + ',') !== -1);
        var isArchive = (ext === 'tar') || (ext === 'zip');
        var prefix = '', suffix = '';

        if (multi && isImage) {
            prefix = '[media_set]\n';
            suffix = '[/media_set]';
        }

        var tag = 'attachment';
        var showOverlay, defaults = {};

        if (filepath.indexOf('fakepath') === -1) { // iPhone gives c:\fakepath\image.jpg, so don't use that
            defaults.description = filepath; // Default caption to local file path
        }

        /*{+START,INCLUDE,ATTACHMENT_UI_DEFAULTS,.js,javascript}{+END}*/

        if (trueAttachmentUi) {
            // Add field for next one
            addAnotherField = (number == window.numAttachments) && (window.numAttachments < window.maxAttachments); // Needs running late, in case something happened inbetween
            if (addAnotherField) {
                addAttachment(window.numAttachments + 1, fieldName);
            }
            return resolvePromise();
        }

        if (!showOverlay) {
            var comcode = '[' + tag;
            for (var key in defaults) {
                comcode += ' ' + key + '="' + (defaults[key].replace(/"/g, '\\"')) + '"';
            }
            comcode += ']new_' + number + '[/' + tag + ']';

            var promiseCalls = [];
            if (prefix !== '') {
                promiseCalls.push(function () {
                    return window.insertTextbox(post, prefix);
                });
            }

            if (multi) {
                var splitFilename = document.getElementById('txtFileName_file' + window.numAttachments).value.split(/:/);
                splitFilename.forEach(function (part, i) {
                    promiseCalls.push(function () {
                        if (i > 0) {
                            window.numAttachments++;
                        }
                        return window.insertTextbox(post, comcode.replace(']new_' + number + '[', ']new_' + window.numAttachments + '['));
                    });
                });
                number = '' + (parseInt(number) + splitFilename.length - 1);
            } else {
                promiseCalls.push(function () {
                    return window.insertTextbox(post, comcode);
                });
            }

            if (suffix !== '') {
                promiseCalls.push(function () {
                    return window.insertTextbox(post, suffix);
                });
            }
            
            return $cms.promiseSequence(promiseCalls).then(function () {
                // Add field for next one
                var addAnotherField = (number == window.numAttachments) && (window.numAttachments < window.maxAttachments); // Needs running late, in case something happened inbetween
                if (addAnotherField) {
                    addAttachment(window.numAttachments + 1, fieldName);
                }

                if (uploaderSettings !== undefined) {
                    uploaderSettings.callbacks.push(function () {
                        // Do insta-preview
                        if ($cms.form.isWysiwygField(post)) {
                            generateBackgroundPreview(post);
                        }
                    });
                }
            });
        }

        var url = '{$FIND_SCRIPT;,comcode_helper}';
        url += '?field_name=' + fieldName;
        url += '&type=step2';
        url += '&tag=' + tag;
        url += '&default=new_' + number;
        url += '&is_image=' + (isImage ? '1' : '0');
        url += '&is_archive=' + (isArchive ? '1' : '0');
        url += '&multi=' + (multi ? '1' : '0');
        url += '&prefix=' + prefix;
        if ($cms.form.isWysiwygField(post)) {
            url += '&in_wysiwyg=1';
        }
        for (var def in defaults) {
            url += '&default_' + def + '=' + encodeURIComponent(defaults[def]);
        }
        url += $cms.keepStub();

        setTimeout(function () {
            $cms.ui.showModalDialog($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes,unadorned=yes').then(function (comcodeAdded) {
                if (!comcodeAdded) {  // Cancelled
                    var clearButton = document.getElementById('fsClear_file' + number);
                    if (clearButton && clearButton.onclick) {
                        clearButton.onclick();
                    }
                    return;
                }

                var promise = Promise.resolve();

                if (multi) { // Add in additional Comcode buttons for the other files selected at the same time
                    var comcodeSemihtml = '', comcode = '',
                        splitFilename = document.getElementById('txtFileName_file' + window.numAttachments).value.split(/:/);

                    for (var i = 1; i < splitFilename.length; i++) {
                        window.numAttachments++;
                        var tmp = window.insertComcodeTag(']new_' + number + '[', ']new_' + window.numAttachments + '[', true);
                        comcodeSemihtml += tmp[0];
                        comcode += tmp[1];
                    }

                    number = '' + (parseInt(number) + splitFilename.length - 1);

                    if (suffix !== '') {
                        comcode += suffix;
                        comcodeSemihtml += suffix;
                    }

                    promise = window.insertTextbox(post, comcode, true, comcodeSemihtml);
                }

                promise.then(function () {
                    // Add field for next one
                    var addAnotherField = (number == window.numAttachments) && (window.numAttachments < window.maxAttachments); // Needs running late, in case something happened inbetween
                    if (addAnotherField) {
                        addAttachment(window.numAttachments + 1, fieldName);
                    }

                    // Do insta-preview
                    if (comcodeAdded.includes('[attachment_safe') && $cms.form.isWysiwygField(post)) {
                        generateBackgroundPreview(post);
                    }
                });
            });
        }, 800); // In a timeout to disassociate possible 'enter' keypress which could have led to this function being called [enter on the file selection dialogue] and could propagate through (on Google Chrome anyways, maybe a browser bug)

        return resolvePromise();
    });
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
    formPost = $cms.form.modSecurityWorkaroundAjax(formPost.substr(1));

    $cms.doAjaxRequest(window.formPreviewUrl + '&js_only=1&known_utf8=1', function (_, xhr) {
        $cms.dom.append(document.body, xhr.responseText);
    }, formPost);
}

// ====================
// COMCODE UI FUNCTIONS
// ====================

function doInputHtml(fieldName) {
    var post = document.getElementById(fieldName);
    return window.insertTextboxWrapping(post, 'semihtml', '');
}

function doInputCode(fieldName) {
    var post = document.getElementById(fieldName);
    return window.insertTextboxWrapping(post, (post.name === 'message') ? 'tt' : 'codebox', '');
}

function doInputQuote(fieldName) {
    var post = document.getElementById(fieldName);
    $cms.ui.prompt(
        '{!javascript:ENTER_QUOTE_BY;^}',
        '',
        function (va) {
            if (va != null) {
                window.insertTextboxWrapping(post, '[quote=\"' + va + '\"]', '[/quote]');
            }
        },
        '{!comcode:INPUT_COMCODE_quote;^}'
    );
}

function doInputBox(fieldName) {
    var post = document.getElementById(fieldName);
    $cms.ui.prompt(
        '{!javascript:ENTER_BOX_TITLE;^}',
        '',
        function (va) {
            if (va != null) {
                window.insertTextboxWrapping(post, '[box=\"' + va + '\"]', '[/box]');
            }
        },
        '{!comcode:INPUT_COMCODE_box;^}'
    );
}

function doInputMenu(fieldName) {
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
                        add = '[block=\"' + $cms.filter.comcode(va) + '\" caption=\"' + $cms.filter.comcode(vb) + '\" type=\"tree\"]menu[/block]';
                        window.insertTextbox(element, add);
                    },
                    '{!comcode:INPUT_COMCODE_menu;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_menu;^}'
    );
}

function doInputBlock(fieldName) {
    var url = '{$FIND_SCRIPT;,block_helper}?field_name=' + fieldName + $cms.keepStub();
    url += '&block_type=' + ((!fieldName.includes('edit_panel_') && !window.location.href.includes(':panel_')) ? 'main' : 'side');
    
    return $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
}

function doInputComcode(fieldName, tag) {
    var attributes = {},
        defaultEmbed = null,
        saveToId = null;

    if (tag == null) {
        var element = document.getElementById(fieldName);
        
        if ($cms.form.isWysiwygField(element)) {
            var selection = window.wysiwygEditors[fieldName].getSelection(),
                ranges = selection.getRanges();
            
            if (ranges[0] !== undefined) {
                var comcodeElement = ranges[0].startContainer.$;
                do {
                    var matches = comcodeElement.nodeName.toLowerCase().match(/^comcode-(\w+)/);
                    if (matches !== null) {
                        tag = matches[1];

                        for (var i = 0; i < comcodeElement.attributes.length; i++) {
                            if (comcodeElement.attributes[i].name !== 'id') {
                                attributes[comcodeElement.attributes[i].name] = comcodeElement.attributes[i].value;
                            }
                        }

                        defaultEmbed = $cms.dom.html(comcodeElement);

                        if (comcodeElement.id === '') {
                            comcodeElement.id = 'comcode_' + Date.now();
                        }
                        saveToId = comcodeElement.id;

                        break;
                    }

                    comcodeElement = comcodeElement.parentNode;
                } while (comcodeElement != null);
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
    if ($cms.form.isWysiwygField(document.getElementById(fieldName))) {
        url += '&in_wysiwyg=1';
    }
    
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

function doInputList(fieldName, add) {
    add = window.arrVal(add);

    var post = document.getElementById(fieldName);

    return window.insertTextbox(post, '\n').then(function () {
        return $cms.ui.prompt('{!javascript:ENTER_LIST_ENTRY;^}', '', null, '{!comcode:INPUT_COMCODE_list;^}');
    }).then(function (va) {
        if (va) {
            add.push(va);
            return doInputList(fieldName, add)
        }
        
        if (add.length === 0) {
            return;
        }

        var promiseCalls = [];
        
        promiseCalls.push(function () {
            if (post.value.includes('[semihtml')) {
                return window.insertTextbox(post, '[list]\n');
            }
        });

        add.forEach(function (entryName) {
            promiseCalls.push(function () {
                if (post.value.includes('[semihtml')) {
                    return window.insertTextbox(post, '[*]' + entryName + '\n')
                } else {
                    return window.insertTextbox(post, ' - ' + entryName + '\n')
                }
            });
        });
        
        promiseCalls.push(function () {
            if (post.value.includes('[semihtml')) {
                return window.insertTextbox(post, '[/list]\n');
            }
        });
        
        return $cms.promiseSequence(promiseCalls);
    });
}

function doInputHide(fieldName) {
    $cms.ui.prompt('{!javascript:ENTER_WARNING;^}', '', null, '{!comcode:INPUT_COMCODE_hide;^}').then(function (va) {
        if (va) {
            $cms.ui.prompt(
                '{!javascript:ENTER_HIDDEN_TEXT;^}',
                '',
                function (vb) {
                    if (vb) {
                        var element = document.getElementById(fieldName);
                        window.insertTextbox(element, '[hide=\"' + $cms.filter.comcode(va) + '\"]' + $cms.filter.comcode(vb) + '[/hide]');
                    }
                },
                '{!comcode:INPUT_COMCODE_hide;^}'
            );
        }
    })
}

function doInputThumb(fieldName, url) {
    fieldName = strVal(fieldName);
    url = strVal(url);

    if ((window.startSimplifiedUpload !== undefined) && (document.getElementById(fieldName).name !== 'message')) {
        var test = window.startSimplifiedUpload(fieldName);
        if (test) {
            return;
        }
    }
    
    var answer;
    $cms.ui.prompt('{!javascript:ENTER_URL;^}', url, null, '{!comcode:INPUT_COMCODE_img;^}').then(function (_url) {
        url = strVal(_url);
        
        if (!url) {
            return $cms.promiseHalt();
        }
        
        if (!url.includes('://')) {
            $cms.ui.alert('{!javascript:NOT_A_URL;^}').then(function () {
                doInputUrl(fieldName, url);
            });
            return $cms.promiseHalt();
        }
    
        return $cms.ui.generateQuestionUi(
            '{!javascript:THUMB_OR_IMG_2;^}',
            { buttons__thumbnail: '{!THUMBNAIL;^}', buttons__fullsize: '{!IMAGE;^}' },
            '{!comcode:INPUT_COMCODE_img;^}'
        );
    }).then(function (_answer) {
        answer = strVal(_answer);
        return $cms.ui.prompt('{!javascript:ENTER_IMAGE_CAPTION;^}', '', null, '{!comcode:INPUT_COMCODE_img;^}');
    }).then(function (caption) {
        caption = strVal(caption);
        
        var element = document.getElementById(fieldName);
        if (answer.toLowerCase() === '{!IMAGE;^}'.toLowerCase()) {
            window.insertTextbox(element, '[img="' + $cms.filter.comcode(caption) + '"]' + $cms.filter.comcode(url) + '[/img]');
        } else {
            window.insertTextbox(element, '[thumb caption="' + $cms.filter.comcode(caption) + '"]' + $cms.filter.comcode(url) + '[/thumb]');
        }
    });
}

function doInputAttachment(fieldName) {
    $cms.ui.prompt(
        '{!javascript:ENTER_ATTACHMENT;^}',
        '',
        function (val) {
            if (!isInteger(val)) {
                $cms.ui.alert('{!javascript:NOT_VALID_ATTACHMENT;^}');
            } else {
                var element = document.getElementById(fieldName);
                window.insertTextbox(element, '[attachment]new_' + val + '[/attachment]');
            }
        },
        '{!comcode:INPUT_COMCODE_attachment;^}'
    );

    /* Type checking */
    function isInteger(val) {
        if (val == '') {
            return false;
        }
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

function doInputUrl(fieldName, va) {
    $cms.ui.prompt(
        '{!javascript:ENTER_URL;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('://') === -1)) {
                $cms.ui.alert('{!javascript:NOT_A_URL;^}', function () {
                    doInputUrl(fieldName, va);
                });
                return;
            }

            if (va !== null) {
                $cms.ui.prompt(
                    '{!javascript:ENTER_LINK_NAME;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(fieldName);
                        if (vb != null) {
                            window.insertTextbox(element, '[url=\"' + $cms.filter.comcode(vb) + '\"]' + $cms.filter.comcode(va) + '[/url]');
                        }
                    },
                    '{!comcode:INPUT_COMCODE_url;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_url;^}'
    );
}

function doInputPage(fieldName) {
    var result;

    if (($cms.ui.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) {
        $cms.ui.showModalDialog(
            $cms.maintainThemeInLink('{$FIND_SCRIPT;,page_link_chooser}' + $cms.keepStub(true)),
            null,
            'dialogWidth=600;dialogHeight=400;status=no;unadorned=yes',
            function (result) {
                if (result == null) {
                    return;
                }

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
        window.insertTextbox(element, '[page=\"' + $cms.filter.comcode(result) + '\"]' + $cms.filter.comcode(vc) + '[/page]');
    }
}

function doInputEmail(fieldName, va) {
    $cms.ui.prompt(
        '{!javascript:ENTER_ADDRESS;^}',
        va,
        function (va) {
            if ((va != null) && (va.indexOf('@') === -1)) {
                $cms.ui.alert('{!javascript:NOT_A_EMAIL;^}', function () {
                    doInputUrl(fieldName, va);
                });
                return;
            }

            if (va !== null) {
                $cms.ui.prompt(
                    '{!javascript:ENTER_CAPTION;^}',
                    '',
                    function (vb) {
                        var element = document.getElementById(fieldName);
                        if (vb !== null) {
                            window.insertTextbox(element, '[email=\"' + $cms.filter.comcode(vb) + '\"]' + $cms.filter.comcode(va) + '[/email]');
                        }
                    },
                    '{!comcode:INPUT_COMCODE_email;^}'
                );
            }
        },
        '{!comcode:INPUT_COMCODE_email;^}'
    );
}

function doInputB(fieldName) {
    var element = document.getElementById(fieldName);
    return window.insertTextboxWrapping(element, 'b', '');
}

function doInputI(fieldName) {
    var element = document.getElementById(fieldName);
    return window.insertTextboxWrapping(element, 'i', '');
}

function doInputFont(fieldName) {
    var element = document.getElementById(fieldName);
    var form = element.form;
    var face = form.elements['f_face'];
    var size = form.elements['f_size'];
    var colour = form.elements['f_colour'];
    if ((face.value == '') && (size.value == '') && (colour.value == '')) {
        $cms.ui.alert('{!javascript:NO_FONT_SELECTED;^}');
        return;
    }
    return window.insertTextboxWrapping(document.getElementById(fieldName), '[font=\"' + $cms.filter.comcode(face.value) + '\" color=\"' + $cms.filter.comcode(colour.value) + '\" size=\"' + $cms.filter.comcode(size.value) + '\"]', '[/font]', true);
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
    window.lastAutosave = new Date();

    //$cms.inform('Initialising auto-save subsystem');

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

                    if (form.elements[j].value != undefined && form.elements[j].value.replace(/\s/g, '') == value.replace(/\s/g, '')) {
                        continue;
                    }

                    fieldsToDo[elementName] = value;

                    fieldsToDoCounter++;

                    if (value.length > biggestLengthData.length) {// The longest is what we quote to the user as being restored
                        biggestLengthData = value;
                    }

                    //$cms.inform('+ Has autosave for ' + elementName + ' (' + autosaveName + ')');
                } else {
                    //$cms.inform('- Has no autosave for ' + elementName);
                }
            }

            if ((fieldsToDoCounter != 0) && (biggestLengthData.length > 25)) {
                _restoreFormAutosave(form, fieldsToDo, biggestLengthData);
                return; // If we had it locally, we won't let it continue on to try via AJAX
            } else {
                //$cms.inform('No auto-save, fields found was ' + fieldsToDoCounter + ', largest length was ' + biggestLengthData.length);
            }
        }
    } else {
        //$cms.inform('Nothing in local storage');
    }

    // Load via AJAX (if issue happened on another machine, or if we do not support local storage)
    if (navigator.onLine) {
        //$cms.inform('Searching AJAX for auto-save');

        var url = '{$FIND_SCRIPT_NOHTTP;,autosave}?type=retrieve';
        url += '&stem=' + encodeURIComponent(getAutosaveUrlStem());
        url += $cms.keepStub();
        var callback = function (form) {
            return function (responseXml) {
                var result = responseXml && responseXml.querySelector('result');
                //$cms.inform('Auto-save AJAX says', result);
                _retrieveFormAutosave(result, form);
            }
        }(form);
        $cms.doAjaxRequest(url, callback);
    }

    function handleFormSavingExplicit(event, form) {
        if (event.keyCode == 83/*s*/ && (navigator.platform.match('Mac') ? event.metaKey : event.ctrlKey) && (!navigator.platform.match('Mac') ? event.ctrlKey : event.metaKey) && (!event.altKey)) {
            //$cms.inform('Doing explicit auto-save');

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
                    post = $cms.form.modSecurityWorkaroundAjax(post);
                    $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,autosave}?type=store' + $cms.keepStub(), function () {
                        if (document.body.style.cursor === 'wait') {
                            document.body.style.cursor = '';
                        }

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
                if (element.value != undefined && element.value.replace(/\s/g, '') == value.replace(/\s/g, '')) {
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
            //$cms.inform('No auto-save, fields found was ' + fieldsToDoCounter + ', largest length was ' + biggestLengthData.length);
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
                            //$cms.inform('Restoring ' + key);
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
                window.setTextbox(element, value, value);
                break;
            case 'select':
                for (var i = 0; i < element.options.length; i++) {
                    if (element.options[i].value == value) {
                        element.selectedIndex = i;
                        if (jQuery.fn.select2 !== undefined) {
                            jQuery(element).trigger('change');
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
                            if ((form.elements[i].name == element.name) && (form.elements[i].value == value)) {
                                form.elements[i].checked = true;
                            }
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

        $cms.dom.trigger(element, 'change');
    }

    function fieldSupportsAutosave(element) {
        if ((element.length !== undefined) && (element.nodeName === undefined)) {
            // Radio button
            element = element[0];
        }

        if (element.name === undefined) {
            return false;
        }

        var name = element.name;
        if (name == '') {
            return false;
        }
        if (name.substr(-2) == '[]') {
            return false;
        }

        if ($cms.form.isWysiwygField(element)) {
            return true;
        }

        if (element.disabled) {
            return false;
        }

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
            //$cms.inform('Doing AJAX auto-save');

            post = $cms.form.modSecurityWorkaroundAjax(post);
            $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,autosave}?type=store' + $cms.keepStub(), true, post);
        }
    }
}

function _handleFormSaving(event, element, force) {
    if (force === undefined) {
        force = (event.type === 'blur');
    }

    var thisDate = new Date();
    if (!force) {
        if ((thisDate.getTime() - window.lastAutosave.getTime()) < 20 * 1000) return null; // Only save every 20 seconds
    }

    if (element === undefined) {
        element = event.target;
    }
    if ((element === undefined) || (element === null)) {
        return null; // Some weird error, perhaps an extension fired this event
    }

    var value = $cms.form.cleverFindValue(element.form, element);
    if ((event.type === 'keypress') && (isTypedInput(element))) {
        value += String.fromCharCode(event.keyCode ? event.keyCode : event.charCode);
    }

    // Mark it as saved, so the server can clear it out when we submit, signally local storage should get deleted too
    var elementName = (element.name === undefined) ? element[0].name : element.name;
    var autosaveName = getAutosaveName(elementName);
    $cms.setCookie(encodeURIComponent(getAutosaveUrlStem()), '1', 0.167/*4 hours*/);

    window.lastAutosave = thisDate;

    // Save locally
    if (window.localStorage !== undefined) {
        if ($cms.$DEV_MODE()) {
            //$cms.inform('Doing local storage auto-save for ' + elementName + ' (' + autosaveName + ')');
        }

        try {
            window.localStorage.setItem(autosaveName, value);
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
    if (window.location.search.indexOf('type=') !== -1) {
        name += window.location.search.replace(/[\?&]redirect=.*/, '').replace(/[\?&]keep_\w+=.*/, '').replace(/[\?&]cat=.*/, '');
    }
    name = name.replace(/\./, '_'); // PHP can't use dots in field names
    return name;
}

function getAutosaveName(fieldName) {
    return getAutosaveUrlStem() + ':' + fieldName;
}
