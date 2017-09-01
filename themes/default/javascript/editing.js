'use strict';

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
        return;
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
                    //buttons__no: '{!javascript:WYSIWYG_DISABLE_ONCE_AND_DONT_ASK;^}', Too confusing, re-enable if you want it
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
        return;
    }

    _toggleWysiwyg(name);

    if ($cms.readCookie('use_wysiwyg') !== '-1') {
        $cms.setCookie('use_wysiwyg', '1', 3000);
    }

    function _toggleWysiwyg(name) {
        var isWysiwygOn = wysiwygOn(),
            forms = document.getElementsByTagName('form'),
            so = document.getElementById('post_special_options'),
            so2 = document.getElementById('post_special_options2');

        if (isWysiwygOn) {
            // Find if the WYSIWYG has anything in it - if not, discard
            var allEmpty = true, 
                myregexp = new RegExp(/((\s)|(<p\d*\/>)|(<\/p>)|(<p>)|(&nbsp;)|(<br[^>]*>))*/);
            
            for (var fid = 0; fid < forms.length; fid++) {
                for (var counter = 0; counter < forms[fid].elements.length; counter++) {
                    var id = forms[fid].elements[counter].id;
                    if (window.wysiwygEditors[id] !== undefined) {
                        if (window.wysiwygEditors[id].getData().replace(myregexp, '') !== '') {
                            allEmpty = false;
                        }
                    }
                }
            }

            if (allEmpty) {
                disableWysiwyg(forms, so, so2, true);
            } else if ((window.wysiwygOriginalComcode[id] === undefined) || (window.wysiwygOriginalComcode[id].indexOf('&#8203;') !== -1) || (window.wysiwygOriginalComcode[id].indexOf('cms_keep') !== -1)) {
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
                    '{!javascript:DISCARD_WYSIWYG_CHANGES;^}'
                ).then(function (prompt) {
                    if (!prompt || (prompt.toLowerCase() === '{!INPUTSYSTEM_CANCEL;^}'.toLowerCase())) {
                        if ($cms.readCookie('use_wysiwyg') === '0') {
                            $cms.setCookie('use_wysiwyg', '1', 3000);
                        }
                        return;
                    }

                    var discard = (prompt.toLowerCase() === '{!javascript:DISCARD_WYSIWYG_CHANGES_LINE;^}'.toLowerCase());
                    disableWysiwyg(forms, so, so2, discard);
                });
            }
        } else {
            enableWysiwyg(forms, so, so2);
        }
    }

    function enableWysiwyg(forms, so, so2) {
        forms = window.arrVal(forms);
        
        window.wysiwygOn = function () {
            return true;
        };

        var promiseCalls = [];
        forms.forEach(function (form) {
            promiseCalls.push(function () {
                return window.loadHtmlEdit(form, true);
            });
        });
        
        return $cms.promiseSequence(promiseCalls);
    }

    function disableWysiwyg(forms, so, so2, discard) {
        var promiseCalls = [];
        
        for (var fid = 0; fid < forms.length; fid++) {
            var form = forms[fid];
            
            for (var counter = 0; counter < form.elements.length; counter++) {
                var textarea = form.elements[counter];
                
                if (window.wysiwygEditors[textarea.id] === undefined) {
                    continue;
                }

                promiseCalls.push((function (textarea) {
                    return function () {
                        return disableWysiwygTextarea(textarea, discard);
                    }
                }(textarea)));
            }
        }
        
        return $cms.promiseSequence(promiseCalls).then(function () {
            if (so) {
                $cms.dom.show(so);
            }
            if (so2) {
                $cms.dom.hide(so2);
            }

            window.wysiwygOn = function () {
                return false;
            };
        });
    }
    
    function disableWysiwygTextarea(textarea, discard) {
        return new Promise(function (resolvePromise) {
            var id = textarea.id;

            // Mark as non-WYSIWYG
            document.getElementById(id + '__is_wysiwyg').value = '0';
            textarea.style.display = 'block';
            textarea.style.visibility = 'visible';
            textarea.disabled = false;
            textarea.readOnly = false;

            if (window.rebuildAttachmentButtonForNext !== undefined) {
                window.rebuildAttachmentButtonForNext(id, 'js-attachment-upload-button');
            }

            // Unload editor
            var wysiwygData = window.wysiwygEditors[id].getData();
            try {
                window.wysiwygEditors[id].destroy();
            } catch (ignore) {}

            delete window.wysiwygEditors[id];

            // Comcode conversion
            if (discard && window.wysiwygOriginalComcode[id]) {
                textarea.value = window.wysiwygOriginalComcode[id];
                postWysiwygDisable(textarea);
                return resolvePromise();
            }
            
            var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?from_html=1' + $cms.keepStub());
            if (window.location.href.includes('topics')) {
                url += '&forum_db=1';
            }
            var post = 'data=' + encodeURIComponent(wysiwygData.replace(new RegExp(String.fromCharCode(8203), 'g'), ''));
            post = $cms.form.modSecurityWorkaroundAjax(post);
            $cms.doAjaxRequest(url, function (_, xhr) {
                if (!xhr.responseXML || !xhr.responseXML.querySelector('result')) {
                    textarea.value = '[semihtml]' + wysiwygData + '[/semihtml]';
                } else {
                    var result = xhr.responseXML.querySelector('result');
                    textarea.value = result.textContent.replace(/\s*$/, '');
                }
                if (textarea.value.includes('{\$,page hint: no_wysiwyg}') && (textarea.value !== '')) {
                    textarea.value += '{\$,page hint: no_wysiwyg}';
                }

                postWysiwygDisable(textarea);
                resolvePromise();
            }, post);
        });
        
        function postWysiwygDisable(textarea) {
            if (document.getElementById('toggle_wysiwyg_' + textarea.id)) {
                $cms.dom.html('#toggle_wysiwyg_' + textarea.id, '<img src="{$IMG*;^,icons/16x16/editor/wysiwyg_on}" srcset="{$IMG;^,icons/16x16/editor/wysiwyg_on} 2x" alt="{!comcode:ENABLE_WYSIWYG;^}" title="{!comcode:ENABLE_WYSIWYG;^}" class="vertical_alignment" />');
            }

            try {  // Unload editor 
                window.wysiwygEditors[textarea.id].destroy();
            } catch (ignore) {}
        }
    }
}

window.wysiwygReadonlyTimer || (window.wysiwygReadonlyTimer = {});
function wysiwygSetReadonly(name, readonly) {
    if (window.wysiwygEditors[name] === undefined) {
        return;
    }

    var editor = window.wysiwygEditors[name];
    if (editor.document && editor.document.$ && editor.document.$.body) {
        editor.document.$.body.readOnly = readonly;
        editor.document.$.body.contentEditable = !readonly;
        editor.document.$.body.designMode = readonly ? 'off' : 'on';
    }

    // In case it sticks as read only we need a timer to put it back. But only if not already back.
    if (window.wysiwygReadonlyTimer[name]) {
        clearTimeout(window.wysiwygReadonlyTimer[name]);
        window.wysiwygReadonlyTimer[name] = null;
    }
    if (readonly) {
        window.wysiwygReadonlyTimer[name] = setTimeout(function () {
            wysiwygSetReadonly(name, false);
        }, 5000);
    }
}

// Initialising the HTML editor if requested later (i.e. toggling it to on)
window.wysiwygEditors || (window.wysiwygEditors = {});
window.wysiwygOriginalComcode || (window.wysiwygOriginalComcode = {});

/**
 * @param { HTMLFormElement } postingForm
 * @param {boolean} ajaxCopy
 * @return { Promise }
 */
function loadHtmlEdit(postingForm, ajaxCopy) {
    if (!postingForm.method || (postingForm.method.toLowerCase() !== 'post')) {
        return Promise.resolve();
    }

    if (!postingForm.elements['http_referer']) {
        var httpReferer = document.createElement('input');
        httpReferer.name = 'http_referer';
        httpReferer.value = window.location.href;
        httpReferer.setAttribute('type', 'hidden');
        postingForm.appendChild(httpReferer);
    }

    if (!window.CKEDITOR || !$cms.$CONFIG_OPTION('wysiwyg') || !wysiwygOn()) {
        return Promise.resolve();
    }

    var so = document.getElementById('post_special_options'),
        so2 = document.getElementById('post_special_options2');

    if (!postingForm.elements['post'] || postingForm.elements['post'].className.includes('wysiwyg')) {
        if (so) {
            $cms.dom.hide(so);
        }
        if (so2) {
            $cms.dom.show(so2);
        }
    }

    var promiseCalls = [];
    window.arrVal(postingForm.elements).forEach(function (el) {
        if ((el.type === 'textarea') && el.classList.contains('wysiwyg')) {
            promiseCalls.push(function () {
                return loadHtmlForTextarea(postingForm, el, ajaxCopy);
            });
        }
    });
    
    return $cms.promiseSequence(promiseCalls);
    
    function loadHtmlForTextarea(postingForm, textarea, ajaxCopy) {
        return new Promise(function (resolvePromise) {
            var id = textarea.id, indicator;
            
            if (document.getElementById(id + '__is_wysiwyg')) {
                indicator = document.getElementById(id + '__is_wysiwyg');
            } else {
                indicator = document.createElement('input');
                indicator.setAttribute('type', 'hidden');
                indicator.id = textarea.id + '__is_wysiwyg';
                indicator.name = textarea.name + '__is_wysiwyg';
                postingForm.appendChild(indicator);
            }
            indicator.value = '1';

            if (document.getElementById('toggle_wysiwyg_' + id)) {
                $cms.dom.html(document.getElementById('toggle_wysiwyg_' + id), '<img src="{$IMG*;^,icons/16x16/editor/wysiwyg_off}" srcset="{$IMG;^,icons/32x32/editor/wysiwyg_off} 2x" alt="{!comcode:DISABLE_WYSIWYG;^}" title="{!comcode:DISABLE_WYSIWYG;^}" class="vertical_alignment" />');
            }

            window.wysiwygOriginalComcode[id] = textarea.value;
            if (!ajaxCopy) {
                if ((postingForm.elements[id + '_parsed'] !== undefined) && (postingForm.elements[id + '_parsed'].value !== '') && ((textarea.defaultValue == ''/*LEGACY IE bug*/) || (textarea.defaultValue == textarea.value))) {// The extra conditionals are for if back button used
                    textarea.value = postingForm.elements[id + '_parsed'].value;
                }

                setTimeout(function () {
                    wysiwygEditorInitFor(textarea);
                }, 1000);
                return resolvePromise();
            }

            var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1&from_html=0' + $cms.keepStub());
            if (window.location.href.includes('topics')) {
                url += '&forum_db=1';
            }

            $cms.doAjaxRequest(url, function (_, xhr) {
                if (!xhr.responseXML) {
                    textarea.value = '';
                } else {
                    var result = xhr.responseXML.querySelector('result');
                    textarea.value = result ? result.textContent : '';
                }

                setTimeout(function () {
                    wysiwygEditorInitFor(textarea);
                }, 1000);

                resolvePromise();
            }, 'data=' + encodeURIComponent(textarea.value.replace(new RegExp(String.fromCharCode(8203), 'g'), '').replace('{' + '$,page hint: no_wysiwyg}', '')));
        });
    }

    function wysiwygEditorInitFor(element) {
        var pageStylesheets = []; // NB: Used by WYSIWYG_SETTINGS.js
        var linkedSheets = document.querySelectorAll('link[rel="stylesheet"]');
        
        for (var counter = 0; counter < linkedSheets.length; counter++) {
            pageStylesheets.push(linkedSheets[counter].getAttribute('href'));
        }

        // Fiddly procedure to find our colour
        var testDiv = document.createElement('div');
        document.body.appendChild(testDiv);
        testDiv.className = 'wysiwyg_toolbar_color_finder';
        var matches;
        var wysiwygColor = window.getComputedStyle(testDiv).getPropertyValue('color');  // NB: Used by WYSIWYG_SETTINGS.js
        testDiv.parentNode.removeChild(testDiv);
        matches = wysiwygColor.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/, matches);
        if (matches) {
            wysiwygColor = '#';
            var hex;
            hex = (parseInt(matches[1]).toString(16)) + '';
            if (hex.length === 1) {
                hex = '0' + hex;
            }
            wysiwygColor += hex;
            hex = (parseInt(matches[2]).toString(16)) + '';
            if (hex.length === 1) {
                hex = '0' + hex;
            }
            wysiwygColor += hex;
            hex = (parseInt(matches[3]).toString(16)) + '';
            if (hex.length === 1) {
                hex = '0' + hex;
            }
            wysiwygColor += hex;
        }
        // CKEditor doesn't allow low saturation, so raise up if we need to
        matches = wysiwygColor.match(/^#([0-4])(.)([0-4])(.)([0-4])(.)$/);
        if (matches) {
            wysiwygColor = '#';
            wysiwygColor += (parseInt(matches[1]) + 4) + matches[2];
            wysiwygColor += (parseInt(matches[3]) + 4) + matches[4];
            wysiwygColor += (parseInt(matches[5]) + 4) + matches[6];
        }

        /*{+START,INCLUDE,WYSIWYG_SETTINGS,.js,javascript}{+END}*/

        if (window.CKEDITOR.instances[element.id]) {
            // Workaround "The instance "xxx" already exists" error in Google Chrome
            delete window.CKEDITOR.instances[element.id];
        }
        var editor = window.CKEDITOR.replace(element.id, editorSettings);
        if (!editor) { // Not supported on this platform
            return;
        } 
        window.wysiwygEditors[element.id] = editor;

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

            if (dialogName === 'table') {
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
        editor.on('mode', function () {
            var ta = editor.container.$.getElementsByTagName('textarea');
            if (ta[0] != null) {
                ta[0].onchange = sync; // The source view doesn't fire the 'change' event and we don't want to use the 'key' event
            }
        });

        editor.on('instanceReady', function (event) {
            editor.setReadOnly(false); // Workaround for CKEditor bug found in 4.5.6, where it started sometimes without contentEditable=true

            if (window.setUpComcodeAutocomplete !== undefined) {
                window.setUpComcodeAutocomplete(element.id);
            }

            // Instant preview of Comcode
            findTagsInEditor(editor, element);
        });
        setInterval(function () {
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

        comcodes[i].origTitle = comcodes[i].title;
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

                if (this.origTitle != null) {
                    $cms.ui.repositionTooltip(this, eventCopy);
                    this.title = this.origTitle;
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
            comcodes[i].ondblclick = function (e) {
                e.preventDefault();
                
                if (this.onmouseout) {
                    this.onmouseout();
                }
                var fieldName = editor.name;
                if (this.id === '') {
                    this.id = 'comcode_tag_' + Math.round(Math.random() * 10000000);
                }
                var tagType = this.title.replace(/^\[/, '').replace(/[= \]](.|\n)*$/, '');
                if (tagType === 'block') {
                    var blockName = this.title.replace(/\[\/block\]$/, '').replace(/^(.|\s)*\]/, '');
                    var url = '{$FIND_SCRIPT;,block_helper}?type=step2&block=' + encodeURIComponent(blockName) + '&field_name=' + fieldName + '&parse_defaults=' + encodeURIComponent(this.title) + '&save_to_id=' + encodeURIComponent(this.id) + $cms.keepStub();
                    url = url + '&block_type=' + (((fieldName.indexOf('edit_panel_') === -1) && (window.location.href.indexOf(':panel_') === -1)) ? 'main' : 'side');
                    $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
                } else {
                    var url = '{$FIND_SCRIPT;,comcode_helper}?type=step2&tag=' + encodeURIComponent(tagType) + '&field_name=' + fieldName + '&parse_defaults=' + encodeURIComponent(this.title) + '&save_to_id=' + encodeURIComponent(this.id) + $cms.keepStub();
                    $cms.ui.open($cms.maintainThemeInLink(url), '', 'width=750,height=auto,status=no,resizable=yes,scrollbars=yes', null, '{!INPUTSYSTEM_CANCEL;^}');
                }
            };
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
                    tagText = this.origTitle;
                } else {
                    tagText = $cms.dom.html(this);
                }

                this.style.cursor = 'pointer';

                var eventCopy = {};
                if (event) {
                    if (event.pageX) {
                        eventCopy.pageX = 3000;
                    }
                    if (event.clientX) {
                        eventCopy.clientX = 3000;
                    }
                    if (event.pageY) {
                        eventCopy.pageY = 3000;
                    }
                    if (event.clientY) {
                        eventCopy.clientY = 3000;
                    }

                    var selfOb = this;
                    if ((this.renderedTooltip === undefined && !selfOb.isOver) || (selfOb.tagText != tagText)) {
                        selfOb.tagText = tagText;
                        selfOb.isOver = true;

                        var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&box_title={!PREVIEW&;^}' + $cms.keepStub());
                        if (window.location.href.includes('topics')) {
                            url += '&forum_db=1';
                        }

                        $cms.doAjaxRequest(url, function (responseXml) {
                            var ajaxResult = responseXml && responseXml.querySelector('result');
                            
                            if (ajaxResult) {
                                var tmpRendered = ajaxResult.textContent;
                                if (tmpRendered.indexOf('{!CCP_ERROR_STUB;^}') === -1) {
                                    selfOb.renderedTooltip = tmpRendered;
                                }
                            }
                            if (selfOb.renderedTooltip !== undefined) {
                                if (selfOb.isOver) {
                                    $cms.ui.activateTooltip(selfOb, eventCopy, selfOb.renderedTooltip, 'auto', null, null, false, true);
                                    selfOb.title = selfOb.origTitle;
                                }
                            }
                        }, 'data=' + encodeURIComponent('[semihtml]' + tagText.replace(/<\/?span[^>]*>/gi, '')).substr(0, 1000).replace(new RegExp(String.fromCharCode(8203), 'g'), '') + '[/semihtml]');
                    } else if (this.renderedTooltip !== undefined) {
                        $cms.ui.activateTooltip(selfOb, eventCopy, selfOb.renderedTooltip, '400px', null, null, false, true);
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
        return insertTextboxOpener(element, text, true, $cms.dom.html(callerEl), true);
    } else {
        return insertTextbox(element, text, true, $cms.dom.html(callerEl), true);
    }
}

function doAttachment(fieldName, id, description) {
    if (!$cms.getMainCmsWindow().wysiwygEditors) {
        return Promise.resolve();
    }

    description = strVal(description);

    var element = $cms.getMainCmsWindow().document.getElementById(fieldName);
    var comcode = '\n\n[attachment description="' + $cms.filter.comcode(description) + '"]' + id + '[/attachment]';

    return insertTextboxOpener(element, comcode);
}

function getTextbox(element) {
    if ($cms.form.isWysiwygField(element)) {
        var ret = window.wysiwygEditors[element.id].getData();
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

        window.wysiwygEditors[element.id].setData(html);
        window.wysiwygEditors[element.id].updateElement();

        setTimeout(function () {
            findTagsInEditor(window.wysiwygEditors[element.id], element);
        }, 100);
    } else {
        element.value = text;
    }
}

/**
 * Insert some text, with WYSIWYG support...
 * (Use insertTextboxWrapping to wrap Comcode tags around a selection)
 *
 * @param { Element } element - non-WYSIWYG element
 * @param {string} text - text to insert (non-HTML)
 * @param {boolean} [isPlainInsert] - Set to true if we are doing a simple insert, not inserting complex Comcode that needs to have editing representation.
 * @param {string} [html] - HTML to insert (if not passed then 'text' will be escaped)
 * @returns { Promise }
 */
function insertTextbox(element, text, isPlainInsert, html) {
    text = strVal(text);
    isPlainInsert = boolVal(isPlainInsert);
    html = strVal(html);

    if ($cms.form.isWysiwygField(element)) {
        return insertTextboxWysiwyg(element, text, isPlainInsert, html);
    } else {
        return insertTextboxVanilla(element, text);
    }
    
    function insertTextboxVanilla(element, text) {
        var from = element.value.length,
            to, start, end;

        element.focus();

        if (element.selectionEnd !== undefined) {
            from = element.selectionStart;
            to = element.selectionEnd;
            start = element.value.substring(0, from);
            end = element.value.substring(to, element.value.length);

            element.value = start + element.value.substring(from, to) + text + end;
            setSelectionRange(element, from + text.length, from + text.length);
        } else {
            // :(
            from += 2;
            element.value += text;
            setSelectionRange(element, from + text.length, from + text.length);
        }

        return Promise.resolve();
    }
    
    function insertTextboxWysiwyg(element, text, isPlainInsert, html) {
        return new Promise(function (resolvePromise) {
            var editor = window.wysiwygEditors[element.id],
                insert = '';

            if (isPlainInsert) {
                insert = getSelectedHtml(editor) + (html ? html : $cms.filter.html(text).replace(new RegExp('\\\\n', 'gi'), '<br />'));

                _insertTextboxWysiwyg(element, editor, insert);
                resolvePromise();
            } else {
                var url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1' + $cms.keepStub());
                if (window.location.href.includes('topics')) {
                    url += '&forum_db=1';
                }
                
                $cms.doAjaxRequest(url, function (responseXML) {
                    if (responseXML && (responseXML.querySelector('result'))) {
                        var result = responseXML.querySelector('result');
                        insert = result.textContent.replace(/\s*$/, '');
                    }

                    _insertTextboxWysiwyg(element, editor, insert);
                    resolvePromise();
                }, 'data=' + encodeURIComponent(text.replace(new RegExp(String.fromCharCode(8203), 'g'), '')));
            }
        });
    }

    function _insertTextboxWysiwyg(element, editor, insert) {
        var before = editor.getData(),
            after;

        try {
            editor.focus(); // Needed on some browsers
            getSelectedHtml(editor);

            if (editor.getSelection() && (editor.getSelection().getStartElement().getName() === 'kbd')) {// Danger Danger - don't want to insert into another Comcode tag. Put it after. They can cut+paste back if they need.
                editor.document.getBody().appendHtml(insert);
            } else {
                //editor.insertHtml(insert); Actually may break up the parent tag, we want it to nest nicely
                var elementForInserting = window.CKEDITOR.dom.element.createFromHtml(insert);
                editor.insertElement(elementForInserting);
            }

            after = editor.getData();
            if (after == before) {
                throw new Error('Failed to insert');
            }

            findTagsInEditor(editor, element);
        } catch (e) { // Sometimes happens on Firefox in Windows, appending is a bit tamer (e.g. you cannot insert if you have the start of a h1 at cursor)
            after = editor.getData();
            if (after === before) { // Could have just been a window.scrollBy popup-blocker exception, so only do this if the op definitely failed
                editor.document.getBody().appendHtml(insert);
            }
        }

        editor.updateElement();
    }
}
/**
 * @param element
 * @param text
 * @param isPlainInsert
 * @param html
 * @return { Promise }
 */
function insertTextboxOpener(element, text, isPlainInsert, html) {
    return $cms.getMainCmsWindow().insertTextbox(element, text, isPlainInsert, html);
}

// Get selected HTML from CKEditor
function getSelectedHtml(editor) {
    var mySelection = editor.getSelection();
    if (!mySelection || mySelection.getType() == window.CKEDITOR.SELECTION_NONE) {
        return '';
    }

    var selectedText = '';
    if (mySelection.getNative()) {
        try {
            selectedText = $cms.dom.html(mySelection.getNative().getRangeAt(0).cloneContents());
        } catch (e) {}
    }
    return selectedText;
}

/**
 * Insert into the editor such as to *wrap* the current selection with something new (typically a new Comcode tag)
 * @param element
 * @param beforeWrapTag
 * @param afterWrapTag
 * @return { Promise }
 */
function insertTextboxWrapping(element, beforeWrapTag, afterWrapTag) {
    beforeWrapTag = strVal(beforeWrapTag);
    afterWrapTag = strVal(afterWrapTag);

    if (afterWrapTag === '') {
        afterWrapTag = '[/' + beforeWrapTag + ']';
        beforeWrapTag = '[' + beforeWrapTag + ']';
    }

    if ($cms.form.isWysiwygField(element)) {
        return insertTextboxWrappingWysiwyg(element, beforeWrapTag, afterWrapTag);
    } else {
        return insertTextboxWrappingVanilla(element, beforeWrapTag, afterWrapTag);
    }
    
    function insertTextboxWrappingVanilla(element, beforeWrapTag, afterWrapTag) {
        var from, to, start, end;
        
        if (element.selectionEnd !== undefined) {
            from = element.selectionStart;
            to = element.selectionEnd;
            start = element.value.substring(0, from);
            end = element.value.substring(to, element.value.length);

            if (to > from) {
                element.value = start + beforeWrapTag + element.value.substring(from, to) + afterWrapTag + end;
            } else {
                element.value = start + beforeWrapTag + afterWrapTag + end;
            }
            setSelectionRange(element, from, to + beforeWrapTag.length + afterWrapTag.length);
        } else {
            // :(
            element.value += beforeWrapTag + afterWrapTag;
            setSelectionRange(element, from, to + beforeWrapTag.length + afterWrapTag.length);
        }
        
        return Promise.resolve();
    }
    
    function insertTextboxWrappingWysiwyg(element, beforeWrapTag, afterWrapTag) {
        return new Promise(function (resolvePromise) {

            var editor = window.wysiwygEditors[element.id];

            editor.focus();
            var selectedHtml = getSelectedHtml(editor);

            if (selectedHtml === '') {
                selectedHtml = '{!comcode:TEXT_OR_COMCODE_GOES_HERE;^}'.toUpperCase();
            }

            var newHtml = '',
                url = $cms.maintainThemeInLink('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?semihtml=1' + $cms.keepStub());

            if (window.location.href.includes('topics')) {
                url += '&forum_db=1';
            }
            
            $cms.doAjaxRequest(url, function (responseXml) {
                if (responseXml && (responseXml.querySelector('result'))) {
                    var result = responseXml.querySelector('result');
                    newHtml = result.textContent.replace(/\s*$/, '');
                    /* result is an XML-escaped string of HTML, so we get via looking at the node text */
                } else {
                    newHtml = selectedHtml;
                }

                _insertTextboxWrappingWysiwyg(element, editor, newHtml);
                resolvePromise();
            }, 'data=' + encodeURIComponent((beforeWrapTag + selectedHtml + afterWrapTag).replace(new RegExp(String.fromCharCode(8203), 'g'), '')));
        });
    }

    function _insertTextboxWrappingWysiwyg(element, editor, newHtml) {
        if ((editor.getSelection()) && (editor.getSelection().getStartElement().getName() === 'kbd')) { // Danger Danger - don't want to insert into another Comcode tag. Put it after. They can cut+paste back if they need.
            editor.document.getBody().appendHtml(newHtml);
        } else {
            editor.insertHtml(newHtml);
        }

        findTagsInEditor(editor, element);

        editor.updateElement();
    }
}

// From http://www.faqts.com/knowledge_base/view.phtml/aid/13562
function setSelectionRange(input, selectionStart, selectionEnd) {
    input.focus();
    if (input.setSelectionRange !== undefined) {
        input.setSelectionRange(selectionStart, selectionEnd);
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

        setTimeout((function (id, authorised, hook) {
            document.getElementById(id).onclick = function () {
                var el = document.getElementById(id);
                if (el.checked && !authorised) {
                    //e.checked=false;  Better to assume success, not all oAuth support callback
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
