"use strict";

/* Form editing code (general, may be used on many different kinds of form) */

// ===========
// HTML EDITOR
// ===========

function wysiwygOn() {
    var cookie = $cms.readCookie('use_wysiwyg');
    return (!cookie || (cookie !== '0')) && $cms.$CONFIG_OPTION('wysiwyg') && !$cms.$MOBILE();
}

function toggleWysiwyg(name) {
    if (!$cms.$CONFIG_OPTION('wysiwyg')) {
        $cms.ui.alert('{!comcode:TOGGLE_WYSIWYG_ERROR;^}');
        return false;
    }

    var isWysiwygOn = wysiwygOn();
    if (isWysiwygOn) {
        if ($cms.readCookie('use_wysiwyg') === '-1') {
            _toggleWysiwyg(name);
        } else {
            $cms.ui.generateQuestionUi(
                '{!comcode:WHETHER_SAVE_WYSIWYG_SELECTION;^}',
                {
                    buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}',
                    buttons__clear: '{!javascript:WYSIWYG_DISABLE_ONCE;^}',
                    //buttons__no: '{!javascript:WYSIWYG_DISABLE_ONCE_AND_DONT_ASK;^}',	Too confusing, re-enable if you want it
                    buttons__yes: '{!javascript:WYSIWYG_DISABLE_ALWAYS;^}'
                },
                '{!comcode:DISABLE_WYSIWYG;^}',
                '{!javascript:DISCARD_WYSIWYG_CHANGES;^}',
                function (savingCookies) {
                    if (!savingCookies) {
                        return;
                    }

                    if (savingCookies.toLowerCase() === '{!javascript:WYSIWYG_DISABLE_ONCE;^}'.toLowerCase()) {
                        _toggleWysiwyg(name);
                    }

                    if (savingCookies.toLowerCase() === '{!javascript:WYSIWYG_DISABLE_ONCE_AND_DONT_ASK;^}'.toLowerCase()) {
                        _toggleWysiwyg(name);
                        $cms.setCookie('use_wysiwyg', '-1', 3000);
                    }

                    if (savingCookies.toLowerCase() === '{!javascript:WYSIWYG_DISABLE_ALWAYS;^}'.toLowerCase()) {
                        _toggleWysiwyg(name);
                        $cms.setCookie('use_wysiwyg', '0', 3000);
                    }
                },
                600,
                140
            );
        }
        return false;
    }

    _toggleWysiwyg(name);

    if ($cms.readCookie('use_wysiwyg') != '-1') {
        $cms.setCookie('use_wysiwyg', '1', 3000);
    }

    return false;

    function _toggleWysiwyg(name) {
        var isWysiwygOn = wysiwygOn();

        var forms = document.getElementsByTagName('form');
        var so = document.getElementById('post_special_options');
        var so2 = document.getElementById('post_special_options2');

        if (isWysiwygOn) {
            // Find if the WYSIWYG has anything in it - if not, discard
            var allEmpty = true, myregexp = new RegExp(/((\s)|(<p\d*\/>)|(<\/p>)|(<p>)|(&nbsp;)|(<br[^>]*>))*/);
            for (var fid = 0; fid < forms.length; fid++) {
                for (var counter = 0; counter < forms[fid].elements.length; counter++) {
                    var id = forms[fid].elements[counter].id;
                    if (window.wysiwyg_editors[id] !== undefined) {
                        if (window.wysiwyg_editors[id].getData().replace(myregexp, '') != '') allEmpty = false;
                    }
                }
            }

            if (allEmpty) {
                disableWysiwyg(forms, so, so2, true);
            } else if ((window.wysiwyg_original_comcode[id] === undefined) || (window.wysiwyg_original_comcode[id].indexOf('&#8203;') != -1) || (window.wysiwyg_original_comcode[id].indexOf('cms_keep') != -1)) {
                disableWysiwyg(forms, so, so2, false);
            } else {
                $cms.ui.generateQuestionUi(
                    '{!javascript:DISCARD_WYSIWYG_CHANGES_NICE;^}',
                    {
                        buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}',
                        buttons__convert: '{!javascript:DISCARD_WYSIWYG_CHANGES_LINE_CONVERT;^}',
                        buttons__no: '{!javascript:DISCARD_WYSIWYG_CHANGES_LINE;^}'
                    },
                    '{!comcode:DISABLE_WYSIWYG;^}',
                    '{!javascript:DISCARD_WYSIWYG_CHANGES;^}',
                    function (prompt) {
                        if ((!prompt) || (prompt.toLowerCase() == '{!INPUTSYSTEM_CANCEL;^}'.toLowerCase())) {
                            if ($cms.readCookie('use_wysiwyg') == '0')
                                $cms.setCookie('use_wysiwyg', '1', 3000);
                            return false;
                        }
                        var discard = (prompt.toLowerCase() == '{!javascript:DISCARD_WYSIWYG_CHANGES_LINE;^}'.toLowerCase());

                        disableWysiwyg(forms, so, so2, discard);
                    }
                );
            }
        } else {
            enableWysiwyg(forms, so, so2);
        }

        return false;
    }

    function enableWysiwyg(forms, so, so2) {
        window.wysiwygOn = function () {
            return true;
        };

        for (var fid = 0; fid < forms.length; fid++) {
            loadHtmlEdit(forms[fid], true);
        }
    }

    function disableWysiwyg(forms, so, so2, discard) {
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

                    if (window.rebuildAttachmentButtonForNext !== undefined)
                        rebuildAttachmentButtonForNext(id, 'attachment_upload_button');

                    // Unload editor
                    var wysiwygData = window.wysiwyg_editors[id].getData();
                    try {
                        window.wysiwyg_editors[id].destroy();
                    } catch (e) {}
                    delete window.wysiwyg_editors[id];

                    // Comcode conversion
                    if ((discard) && (window.wysiwyg_original_comcode[id])) {
                        textarea.value = window.wysiwyg_original_comcode[id];
                    } else {
                        var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?from_html=1' + $cms.keepStub());
                        if (window.location.href.indexOf('topics') != -1) {
                            url += '&forum_db=1';
                        }
                        var post = 'data=' + encodeURIComponent(wysiwygData.replace(new RegExp(String.fromCharCode(8203), 'g'), ''));
                        post = $cms.form.modsecurityWorkaroundAjax(post);
                        /*FIXME: Synchronous XHR*/
                        var request = $cms.doAjaxRequest(url, null, post);
                        if (!request.responseXML || (!request.responseXML.documentElement.querySelector('result'))) {
                            textarea.value = '[semihtml]' + wysiwygData + '[/semihtml]';
                        } else {
                            var resultTags = request.responseXML.documentElement.getElementsByTagName('result');
                            var result = resultTags[0];
                            textarea.value = result.textContent.replace(/\s*$/, '');
                        }
                        if ((textarea.value.indexOf('{\$,page hint: no_wysiwyg}') == -1) && (textarea.value != '')) {
                            textarea.value += '{\$,page hint: no_wysiwyg}';
                        }
                    }
                    if (document.getElementById('toggle_wysiwyg_' + id))
                        $cms.dom.html(document.getElementById('toggle_wysiwyg_' + id), '<img src="{$IMG*;^,icons/16x16/editor/wysiwyg_on}" srcset="{$IMG;^,icons/16x16/editor/wysiwyg_on} 2x" alt="{!comcode:ENABLE_WYSIWYG;^}" title="{!comcode:ENABLE_WYSIWYG;^}" class="vertical_alignment" />');

                    // Unload editor
                    try {
                        window.wysiwyg_editors[id].destroy();
                    } catch (e) {}
                }
            }
        }
        if (so) {
            so.style.display = 'block';
        }
        if (so2) {
            so2.style.display = 'none';
        }

        window.wysiwygOn = function () {
            return false;
        };
    }
}

window.wysiwyg_readonly_timer || (window.wysiwyg_readonly_timer = {});
function wysiwygSetReadonly(name, readonly) {
    if (window.wysiwyg_editors[name] === undefined) {
        return;
    }

    var editor = window.wysiwyg_editors[name];
    if (editor.document && editor.document.$ && editor.document.$.body) {
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
            wysiwygSetReadonly(name, false);
        }, 5000);
    }
}

// Initialising the HTML editor if requested later (i.e. toggling it to on)
window.wysiwyg_editors || (window.wysiwyg_editors = {});
window.wysiwyg_original_comcode || (window.wysiwyg_original_comcode = {});

function loadHtmlEdit(postingForm, ajaxCopy) {
    if ((!postingForm.method) || (postingForm.method.toLowerCase() !== 'post')) {
        return;
    }

    if (!postingForm.elements['httpReferer']) {
        var httpReferer = document.createElement('input');
        httpReferer.name = 'http_referer';
        httpReferer.value = window.location.href;
        httpReferer.setAttribute('type', 'hidden');
        postingForm.appendChild(httpReferer);
    }

    if (!window.CKEDITOR || !$cms.$CONFIG_OPTION('wysiwyg') || !wysiwygOn()) {
        return;
    }

    var so = document.getElementById('post_special_options'),
        so2 = document.getElementById('post_special_options2');

    if (!postingForm.elements['post'] || postingForm.elements['post'].className.includes('wysiwyg')) {
        if (so) {
            so.style.display = 'none';
        }

        if (so2) {
            so2.style.display = 'block';
        }
    }

    var counter, count = 0, e, indicator, thoseDone = [], id;
    for (counter = 0; counter < postingForm.elements.length; counter++) {
        e = postingForm.elements[counter];
        id = e.id;

        if ((e.type === 'textarea') && (e.className.indexOf('wysiwyg') !== -1)) {
            if (document.getElementById(id + '__is_wysiwyg')) {
                indicator = document.getElementById(id + '__is_wysiwyg');
            } else {
                indicator = document.createElement('input');
                indicator.setAttribute('type', 'hidden');
                indicator.id = e.id + '__is_wysiwyg';
                indicator.name = e.name + '__is_wysiwyg';
                postingForm.appendChild(indicator);
            }
            indicator.value = '1';

            if (thoseDone[id]) continue;
            thoseDone[id] = 1;

            count++;
            if (document.getElementById('toggle_wysiwyg_' + id))
                $cms.dom.html(document.getElementById('toggle_wysiwyg_' + id), '<img src="{$IMG*;^,icons/16x16/editor/wysiwyg_off}" srcset="{$IMG;^,icons/32x32/editor/wysiwyg_off} 2x" alt="{!comcode:DISABLE_WYSIWYG;^}" title="{!comcode:DISABLE_WYSIWYG;^}" class="vertical_alignment" />');

            window.wysiwyg_original_comcode[id] = e.value;
            if (!ajaxCopy) {
                if ((postingForm.elements[id + '_parsed'] !== undefined) && (postingForm.elements[id + '_parsed'].value != '') && ((e.defaultValue == ''/*IE bug*/) || (e.defaultValue == e.value))) // The extra conditionals are for if back button used
                    e.value = postingForm.elements[id + '_parsed'].value;
            } else {
                var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1&from_html=0' + $cms.keepStub());
                if (window.location.href.indexOf('topics') != -1) url += '&forum_db=1';
                var request = $cms.doAjaxRequest(url, null, 'data=' + encodeURIComponent(postingForm.elements[counter].value.replace(new RegExp(String.fromCharCode(8203), 'g'), '').replace('{' + '$,page hint: no_wysiwyg}', '')));
                if (!request.responseXML) {
                    postingForm.elements[counter].value = '';
                } else {
                    var resultTags = request.responseXML.documentElement.getElementsByTagName('result');
                    if ((!resultTags) || (resultTags.length == 0)) {
                        postingForm.elements[counter].value = '';
                    } else {
                        var result = resultTags[0];
                        postingForm.elements[counter].value = result.textContent;
                    }
                }
            }
            window.setTimeout(function (e, id) {
                return function () {
                    wysiwygEditorInitFor(e, id);
                }
            }(e, id), 1000);
        }
    }

    function wysiwygEditorInitFor(element, id) {
        var pageStylesheets = [];
        if (!document) return;
        var linkedSheets = document.getElementsByTagName('link');
        for (var counter = 0; counter < linkedSheets.length; counter++) {
            if (linkedSheets[counter].getAttribute('rel') == 'stylesheet')
                pageStylesheets.push(linkedSheets[counter].getAttribute('href'));
        }

        // Fiddly procedure to find our colour
        var testDiv = document.createElement('div');
        document.body.appendChild(testDiv);
        testDiv.className = 'wysiwyg_toolbar_color_finder';
        var matches;
        var wysiwygColor = window.getComputedStyle(testDiv).getPropertyValue('color');
        testDiv.parentNode.removeChild(testDiv);
        matches = wysiwygColor.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/, matches);
        if (matches) {
            wysiwygColor = '#';
            var hex;
            hex = (window.parseInt(matches[1]).toString(16)) + '';
            if (hex.length == 1) hex = '0' + hex;
            wysiwygColor += hex;
            hex = (window.parseInt(matches[2]).toString(16)) + '';
            if (hex.length == 1) hex = '0' + hex;
            wysiwygColor += hex;
            hex = (window.parseInt(matches[3]).toString(16)) + '';
            if (hex.length == 1) hex = '0' + hex;
            wysiwygColor += hex;
        }
        // CKEditor doesn't allow low saturation, so raise up if we need to
        matches = wysiwygColor.match(/^#([0-4])(.)([0-4])(.)([0-4])(.)$/);
        if (matches) {
            wysiwygColor = '#';
            wysiwygColor += (window.parseInt(matches[1]) + 4) + matches[2];
            wysiwygColor += (window.parseInt(matches[3]) + 4) + matches[4];
            wysiwygColor += (window.parseInt(matches[5]) + 4) + matches[6];
        }

        /*== START WYSIWYG_SETTINGS.js ==*/
        // Carefully work out toolbar
        // Look to see if this Comcode button is here as a hint whether we are doing an advanced editor. Unfortunately we cannot put contextual Tempcode inside a JavaScript file, so this trick is needed.
        var precisionEditing = $cms.$IS_STAFF() || (document.body.querySelectorAll('.comcode_button_box').length > 1);
        var toolbar = [];
        if (precisionEditing) {
            toolbar.push(['Source', '-']);
        }
        var toolbarEditActions = ['Cut', 'Copy', 'Paste', precisionEditing ? 'PasteText' : null, precisionEditing ? 'PasteFromWord' : null, precisionEditing ? 'PasteCode' : null];
        if ($cms.$VALUE_OPTION('commercial_spellchecker')) {
            toolbarEditActions.push('-', 'SpellChecker', 'Scayt');
        }
        toolbar.push(toolbarEditActions);
        toolbar.push(['Undo', 'Redo', precisionEditing ? '-' : null, precisionEditing ? 'Find' : null, precisionEditing ? 'Replace' : null, ((document.body.spellcheck !== undefined) ? 'spellchecktoggle' : null), '-', precisionEditing ? 'SelectAll' : null, 'RemoveFormat']);
        toolbar.push(['Link', 'Unlink']);
        toolbar.push(precisionEditing ? '/' : '-');
        var formatting = ['Bold', 'Italic', 'Strike', '-', precisionEditing ? 'Subscript' : null, (precisionEditing ? 'Superscript' : null)];
        toolbar.push(formatting);
        toolbar.push(['NumberedList', 'BulletedList', precisionEditing ? '-' : null, precisionEditing ? 'Outdent' : null, precisionEditing ? 'Indent' : null]);
        if (precisionEditing) {
            toolbar.push(['JustifyLeft', 'JustifyCenter', 'JustifyRight', precisionEditing ? 'JustifyBlock' : null]);
        }
        toolbar.push([precisionEditing ? 'composr_image' : null, 'Table']);
        if (precisionEditing) {
            toolbar.push('/');
        }
        toolbar.push(['Format', 'Font', 'FontSize']);
        toolbar.push(['TextColor']);
        if (precisionEditing) {
            toolbar.push(['Maximize', 'ShowBlocks']);
        }
        if (precisionEditing) {
            toolbar.push(['HorizontalRule', 'SpecialChar']);
        }
        var useComposrToolbar = true;
        if (useComposrToolbar) {
            toolbar.push(['composr_block', 'composr_comcode', (precisionEditing ? 'composr_page' : null), 'composr_quote', (precisionEditing ? 'composr_box' : null), 'composr_code']);
        }
        var editorSettings = {
            skin: 'kama',
            enterMode: window.CKEDITOR.ENTER_BR,
            uiColor: wysiwygColor,
            ocpTheme: $cms.$THEME(),
            fontSize_sizes: '0.6em;0.85em;1em;1.1em;1.2em;1.3em;1.4em;1.5em;1.6em;1.7em;1.8em;2em',
            removePlugins: '',
            extraPlugins: 'showcomcodeblocks,imagepaste,spellchecktoggle' + (useComposrToolbar ? ',composr' : ''),
            /*{+START,IF,{$NEQ,{$CKEDITOR_PATH},data_custom/ckeditor}}*/
            customConfig: '',
            /*{+END}*/
            bodyId: 'wysiwyg_editor',
            baseHref: $cms.baseUrl(),
            linkShowAdvancedTab: !$cms.$CONFIG_OPTION('eager_wysiwyg'),
            imageShowAdvancedTab: !$cms.$CONFIG_OPTION('eager_wysiwyg'),
            imageShowLinkTab: !$cms.$CONFIG_OPTION('eager_wysiwyg'),
            imageShowSizing: !$cms.$CONFIG_OPTION('eager_wysiwyg'),
            autoUpdateElement: true,
            contentsCss: pageStylesheets,
            cssStatic: css,
            startupOutlineBlocks: true,
            language: $cms.$LANG() ? $cms.$LANG().toLowerCase() : 'en',
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
        var editor = window.CKEDITOR.replace(element.id, editorSettings);
        if (!editor) return; // Not supported on this platform
        window.wysiwyg_editors[id] = editor;

        element.parentNode.className += ' ' + editorSettings.skin; // Used for us to target per-skin CSS

        // CSS to run inside the CKEditor frame
        linkedSheets = document.getElementsByTagName('style');
        var css = '';
        for (counter = 0; counter < linkedSheets.length; counter++) {
            css += $cms.dom.html(linkedSheets[counter]);
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

        // Mainly used by autosaving, but also sometimes CKEditor seems to not refresh the textarea (e.g. for one user's site when pressing delete key on an image)
        var sync = function (event) {
            element.value = editor.getData();
            if (element.externalOnKeyPress !== undefined) {
                element.externalOnKeyPress(event, element);
            }
        };
        editor.on('change', sync);
        editor.on('mode',function() {
            var ta = editor.container.$.getElementsByTagName('textarea');
            if (typeof ta[0] != 'undefined') {
                ta[0].onchange = sync; // The source view doesn't fire the 'change' event and we don't want to use the 'key' event
            }
        });

        editor.on('instanceReady', function (event) {
            editor.setReadOnly(false); // Workaround for CKEditor bug found in 4.5.6, where it started sometimes without contentEditable=true

            if (window.setUpComcodeAutocomplete !== undefined) {
                setUpComcodeAutocomplete(id);
            }

            // Instant preview of Comcode
            findTagsInEditor(editor, element);
        });
        window.setInterval(function () {
            if ($cms.form.isWysiwygField(element))
                findTagsInEditor(editor, element);
        }, 1000);

        // Weird issues in Chrome cutting+pasting blocks etc
        editor.on('paste', function (event) {
            if (event.data.html) {
                event.data.html = event.data.html.replace(/<meta charset="utf-8">/g, '');
                event.data.html = event.data.html.replace(/<br class="Apple-interchange-newline">/g, '<br>');
                event.data.html = event.data.html.replace(/<div style="text-align: center;"><font class="Apple-style-span" face="'Lucida Grande'"><span class="Apple-style-span" style="font-size: 11px; white-space: pre;"><br><\/span><\/font><\/div>$/, '<br><br>');
            }
        });

        // Monitor pasting, for anti-spam reasons
        editor.on('paste', function (event) {
            if (event.data.html && event.data.html.length > $cms.$CONFIG_OPTION('spam_heuristic_pasting')) {
                $cms.setPostDataFlag('paste');
            }
        });

        // Allow drag and drop uploading
        editor.on('contentDom', function () {
            editor.document.on('dragover', function (e) {
                html5UploadEventDragOver(e.data.$);
            });

            editor.document.on('drop', function (e) {
                html5UploadEventDrop(e.data.$, element, element.id);
            });
        });

        return editor;
    }
}

function findTagsInEditor(editor, element) {
    if (!editor.document || !editor.document.$ || !editor.document.$.querySelector('body')) {
        return;
    }

    var comcodes = editor.document.$.querySelector('body').querySelectorAll('.cms_keep_ui_controlled');

    for (var i = 0; i < comcodes.length; i++) {
        if (comcodes[i].onmouseout) {
            continue;
        }

        comcodes[i].orig_title = comcodes[i].title;
        comcodes[i].onmouseout = function () {
            $cms.ui.deactivateTooltip(this);
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

                if (typeof this.orig_title != 'undefined') {
                    $cms.ui.repositionTooltip(this, eventCopy);
                    this.title = this.orig_title;
                }
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
                var fieldName = editor.name;
                if (this.id == '') this.id = 'comcode_tag_' + Math.round(Math.random() * 10000000);
                var tagType = this.title.replace(/^\[/, '').replace(/[= \]](.|\n)*$/, '');
                if (tagType == 'block') {
                    var blockName = this.title.replace(/\[\/block\]$/, '').replace(/^(.|\s)*\]/, '');
                    var url = '{$FIND_SCRIPT;,block_helper}?type=step2&block=' + encodeURIComponent(blockName) + '&field_name=' + fieldName + '&parse_defaults=' + encodeURIComponent(this.title) + '&save_to_id=' + encodeURIComponent(this.id) + $cms.keepStub();
                    url = url + '&block_type=' + (((fieldName.indexOf('edit_panel_') == -1) && (window.location.href.indexOf(':panel_') == -1)) ? 'main' : 'side');
                    $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
                } else {
                    var url = '{$FIND_SCRIPT;,comcode_helper}?type=step2&tag=' + encodeURIComponent(tagType) + '&field_name=' + fieldName + '&parse_defaults=' + encodeURIComponent(this.title) + '&save_to_id=' + encodeURIComponent(this.id) + $cms.keepStub();
                    $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
                }
                return false;
            }
        }
        comcodes[i].onmouseover = function (event) { // Shows preview
            if (event === undefined) {
                event = editor.window.$.event;
            }

            if (event) {
                event.stopPropagation();
            }

            if (window.$cms.ui.activateTooltip) {
                var tagText = '';
                if (this.nodeName.toLowerCase() === 'input') {
                    tagText = this.orig_title;
                } else {
                    tagText = $cms.dom.html(this);
                }

                this.style.cursor = 'pointer';

                var eventCopy = {};
                if (event) {
                    if (event.pageX) eventCopy.pageX = 3000;
                    if (event.clientX) eventCopy.clientX = 3000;
                    if (event.pageY) eventCopy.pageY = 3000;
                    if (event.clientY) eventCopy.clientY = 3000;

                    var selfOb = this;
                    if ((this.rendered_tooltip === undefined && !selfOb.is_over) || (selfOb.tag_text != tagText)) {
                        selfOb.tag_text = tagText;
                        selfOb.is_over = true;

                        var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&box_title={!PREVIEW&;^}' + $cms.keepStub());
                        if (window.location.href.indexOf('topics') != -1) {
                            url += '&forum_db=1';
                        }

                        $cms.doAjaxRequest(url, function (ajaxResultFrame, ajaxResult) {
                            if (ajaxResult) {
                                var tmpRendered = ajaxResult.textConten;
                                if (tmpRendered.indexOf('{!CCP_ERROR_STUB;^}') == -1) {
                                    selfOb.rendered_tooltip = tmpRendered;
                                }
                            }
                            if (selfOb.rendered_tooltip !== undefined) {
                                if (selfOb.is_over) {
                                    $cms.ui.activateTooltip(selfOb, eventCopy, selfOb.rendered_tooltip, 'auto', null, null, false, true);
                                    selfOb.title = selfOb.orig_title;
                                }
                            }
                        }, 'data=' + encodeURIComponent('[semihtml]' + tagText.replace(/<\/?span[^>]*>/gi, '')).substr(0, 1000).replace(new RegExp(String.fromCharCode(8203), 'g'), '') + '[/semihtml]');
                    } else if (this.rendered_tooltip !== undefined) {
                        $cms.ui.activateTooltip(selfOb, eventCopy, selfOb.rendered_tooltip, '400px', null, null, false, true);
                    }
                }
            }
        };

    }
}

// ============
// BOTH EDITORS
// ============

function doEmoticon(fieldName, callerEl, isOpener) {
    var element, title, text;

    isOpener = !!isOpener;

    if (isOpener) {
        element = $cms.getMainCmsWindow().document.getElementById(fieldName);
        if (!element) { // If it is really actually cascading popups
            element = window.opener.document.getElementById(fieldName);
        }
    } else {
        element = document.getElementById(fieldName);
    }

    title = callerEl.title;
    if (title === '') {
        // Might be on image inside link instead
        title = callerEl.querySelector('img').alt;
    }
    title = title.replace(/^.*: /, '');

    text = ' ' + title + ' ';

    if (isOpener) {
        insertTextboxOpener(element, text, null, true, $cms.dom.html(callerEl));
    } else {
        insertTextbox(element, text, null, true, $cms.dom.html(callerEl));
    }
}

function doAttachment(fieldName, id, description) {
    if (!$cms.getMainCmsWindow().wysiwyg_editors) {
        return;
    }

    description = strVal(description);

    var element = $cms.getMainCmsWindow().document.getElementById(fieldName);

    var comcode = '\n\n[attachment description="' + $cms.filter.comcode(description) + '"]' + id + '[/attachment]';

    insertTextboxOpener(element, comcode);
}

function getTextbox(element) {
    if ($cms.form.isWysiwygField(element)) {
        var ret = window.wysiwyg_editors[element.id].getData();
        if ((ret === '\n') || (ret === '<br />')) {
            ret = '';
        }
        return ret;
    }
    return element.value;
}

function setTextbox(element, text, html) {
    if ($cms.form.isWysiwygField(element)) {
        if (html === undefined) {
            html = $cms.filter.html(text).replace(new RegExp('\\\\n', 'gi'), '<br />');
        }

        window.wysiwyg_editors[element.id].setData(html);
        window.wysiwyg_editors[element.id].updateElement();

        window.setTimeout(function () {
            findTagsInEditor(window.wysiwyg_editors[element.id], element);
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

 (Use insertTextboxWrapping to wrap Comcode tags around a selection)
 */
function insertTextbox(element, text, sel, plainInsert, html) {
    plainInsert = !!plainInsert;
    html = strVal(html);

    if ($cms.form.isWysiwygField(element)) {
        var editor = window.wysiwyg_editors[element.id];

        var insert = '';
        if (plainInsert) {
            insert = getSelectedHtml(editor) + (html ? html : $cms.filter.html(text).replace(new RegExp('\\\\n', 'gi'), '<br />'));
        } else {
            var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1' + $cms.keepStub());
            if (window.location.href.indexOf('topics') != -1) url += '&forum_db=1';
            /*FIXME: Synchronous XHR*/
            var request = $cms.doAjaxRequest(url, null, 'data=' + encodeURIComponent(text.replace(new RegExp(String.fromCharCode(8203), 'g'), '')));
            if ((request.responseXML) && (request.responseXML.documentElement.querySelector('result'))) {
                var resultTags = request.responseXML.documentElement.getElementsByTagName('result');
                var result = resultTags[0];
                insert = result.textContent.replace(/\s*$/, '');
            }
        }

        var before = editor.getData();

        try {
            editor.focus(); // Needed on some browsers
            var selectedHtml = getSelectedHtml(editor);

            if ((editor.getSelection()) && (editor.getSelection().getStartElement().getName() == 'kbd')) // Danger Danger - don't want to insert into another Comcode tag. Put it after. They can cut+paste back if they need.
            {
                editor.document.getBody().appendHtml(insert);
            } else {
                //editor.insertHtml(insert); Actually may break up the parent tag, we want it to nest nicely
                var elementForInserting = window.CKEDITOR.dom.element.createFromHtml(insert);
                editor.insertElement(elementForInserting);
            }

            var after = editor.getData();
            if (after == before) {
                throw 'Failed to insert';
            }

            findTagsInEditor(editor, element);
        } catch (e) { // Sometimes happens on Firefox in Windows, appending is a bit tamer (e.g. you cannot insert if you have the start of a h1 at cursor)

            var after = editor.getData();
            if (after === before) { // Could have just been a window.scrollBy popup-blocker exception, so only do this if the op definitely failed
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

    if (element.selectionEnd !== undefined)  { // Mozilla style
        from = element.selectionStart;
        to = element.selectionEnd;

        var start = element.value.substring(0, from);
        var end = element.value.substring(to, element.value.length);

        element.value = start + element.value.substring(from, to) + text + end;
        setSelectionRange(element, from + text.length, from + text.length);
    } else if (sel) { // IE style
        var ourRange = sel.createRange();
        if ((ourRange.moveToElementText) || (ourRange.parentElement() == element)) {
            if (ourRange.parentElement() != element) ourRange.moveToElementText(element);
            ourRange.text = ourRange.text + text;
        } else {
            element.value += text;
            from += 2;
            setSelectionRange(element, from + text.length, from + text.length);
        }
    }
    else {
        // :(
        from += 2;
        element.value += text;
        setSelectionRange(element, from + text.length, from + text.length);
    }
 }
function insertTextboxOpener(element, text, sel, plainInsert, html) {
    if (!sel) {
        sel = $cms.getMainCmsWindow().document.selection || null;
    }

    $cms.getMainCmsWindow().insertTextbox(element, text, sel, plainInsert, html);
}

// Get selected HTML from CKEditor
function getSelectedHtml(editor) {
    var mySelection = editor.getSelection();
    if (!mySelection || mySelection.getType() == window.CKEDITOR.SELECTION_NONE) return '';

    var selectedText = '';
    if (mySelection.getNative()) {
        if ((window.CKEDITOR.env.ie) && (mySelection.getNative().getRangeAt === undefined)) { // IE8 and under (selection object)
            mySelection.unlock(true);
            selectedText = mySelection.getNative().createRange().htmlText;
        } else { // IE9 / standards (HTMLSelection object)
            try {
                selectedText = $cms.dom.html(mySelection.getNative().getRangeAt(0).cloneContents());
            } catch (e) {}
        }
    }
    return selectedText;
}

// Insert into the editor such as to *wrap* the current selection with something new (typically a new Comcode tag)
function insertTextboxWrapping(element, beforeWrapTag, afterWrapTag) {
    var from, to;

    beforeWrapTag = strVal(beforeWrapTag);
    afterWrapTag = strVal(afterWrapTag);

    if (afterWrapTag === '') {
        afterWrapTag = '[/' + beforeWrapTag + ']';
        beforeWrapTag = '[' + beforeWrapTag + ']';
    }

    if ($cms.form.isWysiwygField(element)) {
        var editor = window.wysiwyg_editors[element.id];

        editor.focus(); // Needed on some browsers, but on Opera will defocus our selection
        var selectedHtml = getSelectedHtml(editor);

        if (selectedHtml == '') {
            selectedHtml = '{!comcode:TEXT_OR_COMCODE_GOES_HERE;^}'.toUpperCase();
        }

        var newHtml = '';

        var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1' + $cms.keepStub());
        if (window.location.href.indexOf('topics') != -1) {
            url += '&forum_db=1';
        }
        /*FIXME: Synchronous XHR*/
        var request = $cms.doAjaxRequest(url, null, 'data=' + encodeURIComponent((beforeWrapTag + selectedHtml + afterWrapTag).replace(new RegExp(String.fromCharCode(8203), 'g'), '')));
        if ((request.responseXML) && (request.responseXML.documentElement.querySelector('result'))) {
            var resultTags = request.responseXML.documentElement.getElementsByTagName('result');
            var result = resultTags[0];
            newHtml = result.textContent.replace(/\s*$/, '');
            /* result is an XML-escaped string of HTML, so we get via looking at the node text */
        } else {
            newHtml = selectedHtml;
        }

        if ((editor.getSelection()) && (editor.getSelection().getStartElement().getName() == 'kbd')) { // Danger Danger - don't want to insert into another Comcode tag. Put it after. They can cut+paste back if they need.
            editor.document.getBody().appendHtml(newHtml);
        } else {
            editor.insertHtml(newHtml);
        }

        findTagsInEditor(editor, element);

        editor.updateElement();

        return;
    }

    if (element.selectionEnd != null)  { // Mozilla style
        from = element.selectionStart;
        to = element.selectionEnd;

        var start = element.value.substring(0, from);
        var end = element.value.substring(to, element.value.length);

        if (to > from) {
            element.value = start + beforeWrapTag + element.value.substring(from, to) + afterWrapTag + end;
        } else {
            element.value = start + beforeWrapTag + afterWrapTag + end;
        }
        setSelectionRange(element, from, to + beforeWrapTag.length + afterWrapTag.length);
    } else if (document.selection != null) { // IE style
        element.focus();
        var sel = document.selection;
        var ourRange = sel.createRange();
        if ((ourRange.moveToElementText) || (ourRange.parentElement() == element)) {
            if (ourRange.parentElement() != element) {
                ourRange.moveToElementText(element);
            }
            ourRange.text = beforeWrapTag + ourRange.text + afterWrapTag;
        } else element.value += beforeWrapTag + afterWrapTag;
    } else {
        // :(
        element.value += beforeWrapTag + afterWrapTag;
        setSelectionRange(element, from, to + beforeWrapTag.length + afterWrapTag.length);
    }
}

// From http://www.faqts.com/knowledge_base/view.phtml/aid/13562
function setSelectionRange(input, selectionStart, selectionEnd) {
    if (input.setSelectionRange !== undefined) {/* Mozilla style */
        input.focus();
        input.setSelectionRange(selectionStart, selectionEnd);
    } else if (input.createTextRange !== undefined) {/* IE style */
        var range = input.createTextRange();
        range.collapse(true);
        range.moveEnd('character', selectionEnd);
        range.moveStart('character', selectionStart);
        range.select();
    } else {
        input.focus();
    }
}

function showUploadSyndicationOptions(name, syndicationJson, noQuota) {
    name = strVal(name);
    syndicationJson = strVal(syndicationJson);
    noQuota = !!noQuota;

    var htmlSpot = document.getElementById(name + '_syndication_options'),
        html = '',
        numChecked = 0,
        fileOb = document.getElementById(name),
        preDisabled = fileOb.disabled, hook,
        syndication = JSON.parse(syndicationJson),
        num = Object.keys(syndication).length,
        id, authorised, label, checked;

    for (hook in syndication) {
        id = 'upload_syndicate__' + hook + '__' + name;
        authorised = syndication[hook].authorised;
        label = syndication[hook].label;

        if (authorised) {
            checked = true;
            numChecked++;
        } else {
            checked = false;
        }

        window.setTimeout((function (id, authorised, hook) {
            document.getElementById(id).onclick = function () {
                var el = document.getElementById(id);
                if (el.checked && !authorised) {
                    //e.checked=false;	Better to assume success, not all oAuth support callback
                    var url = '{$FIND_SCRIPT_NOHTTP;,upload_syndication_auth}?hook=' + encodeURIComponent(hook) + '&name=' + encodeURIComponent(name) + $cms.keepStub();

                    if ($cms.$MOBILE()) {
                        window.open(url);
                    } else {
                        $cms.ui.open(url, null, 'width=960;height=500', '_top');
                    }

                    if (!preDisabled) {
                        fileOb.disabled = false;
                    }
                }
            };
        }).bind(undefined, id, authorised, hook), 0);

        html += '<span><label for="' + id + '"><input type="checkbox" ' + (checked ? 'checked="checked" ' : '') + 'id="' + id + '" name="' + id + '" value="1" />{!upload_syndication:UPLOAD_TO;^} ' + $cms.filter.html(label) + ((noQuota && (num === 1)) ? ' ({!_REQUIRED;^})' : '') + '</label></span>';
    }

    if (noQuota && (numChecked === 0)) {
        fileOb.disabled = true;
    }

    if ((html !== '') && !noQuota) {
        html += '<span><label for="force_remove_locally"><input type="checkbox" id="force_remove_locally" name="force_remove_locally" value="1" />{!upload_syndication:FORCE_REMOVE_LOCALLY;^}</label></span>';
    }

    html = '<div>' + html + '</div>';

    $cms.dom.html(htmlSpot, html);
}
