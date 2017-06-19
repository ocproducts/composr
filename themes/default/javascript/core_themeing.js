(function ($cms) {
    'use strict';

    /*
     Naming conventions...

     t_	Tab header
     g_	Tab body
     b_ Toolbar
     e_	Editor textbox
     */

    // INIT CODE
    window.template_editor_open_files || (window.template_editor_open_files = {});
    window.done_cleanup_template_markers = window.done_cleanup_template_markers !== undefined ? !!window.done_cleanup_template_markers : false;

    if (window.location.href.includes('keep_template_magic_markers=1')) {
        window.$cmsReady.push(function () {
            cleanupTemplateMarkers(window);
        });
    }

    $cms.views.ThemeManageScreen = ThemeManageScreen;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function ThemeManageScreen() {
        ThemeManageScreen.base(this, 'constructor', arguments);
    }

    $cms.inherits(ThemeManageScreen, $cms.View);

    $cms.views.ThemeTemplateEditorTab = ThemeTemplateEditorTab;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function ThemeTemplateEditorTab(params) {
        ThemeTemplateEditorTab.base(this, 'constructor', arguments);

        // Allow searching via URL hash
        if (window.location.hash) {
            window.setTimeout(function () {
                var hash = window.location.hash.substr(1, window.location.hash.length - 1);
                editareaDoSearch('e_' + params.fileId, hash);
            }, 2000);
        }

        if ($cms.$CONFIG_OPTION('editarea')) {
            aceComposrLoader('e_' + params.fileId, params.highlighterType, false);
        }

        if (params.includeCssEditing && window.opener && window.opener.document) {
            loadContextualCssEditor(params.file, params.fileId);
        }
    }

    $cms.inherits(ThemeTemplateEditorTab, $cms.View, /**@lends ThemeTemplateEditorTab#*/{
        events: function () {
            return {
                'keydown .js-ta-tpl-editor': 'editorKeyPress',
                'click .js-btn-save-content': 'saveContent',
                'click .js-btn-live-preview': 'livePreview',
                'click .js-btn-screen-preview': 'screenPreview',
                'click .js-a-editarea-search': 'editareaSearch',
                'click .js-a-insert-guid': 'insertGuid',
                'click .js-a-tpl-editor-add-tab': 'addEditorTab',
                'click .js-btn-equation-helper': 'cssEquationHelper'
            };
        },

        editorKeyPress: function (e) {
            if (!templateEditorKeypress(e)) {
                e.preventDefault();
            }

            function templateEditorKeypress(event) {
                if ($cms.dom.keyPressed(event, 'Tab')) {
                    insertTextbox(this, "\t");
                    return false;
                }
                return true;
            }
        },

        saveContent: function (e) {
            e.preventDefault();
            templateEditorTabSaveContent(this.params.file);

            function templateEditorTabSaveContent(file) {
                var url = 'template_editor_save';
                url += '&file=' + encodeURIComponent(file);
                url += '&theme=' + encodeURIComponent(window.template_editor_theme);

                editareaReverseRefresh('e_' + fileToFileId(file));

                var post = 'contents=' + encodeURIComponent(getFileTextbox(file).value);
                $cms.loadSnippet(url, post, true).then(function (ajaxResult) {
                    $cms.ui.alert(ajaxResult.responseText, null, null, true);
                    templateEditorTabMarkNonchangedContent(file);
                });
            }

            function templateEditorTabMarkNonchangedContent(file) {
                window.template_editor_open_files[file].unsaved_changes = false;

                var fileId = fileToFileId(file);
                var ob = document.getElementById('t_' + fileId);
                ob.classList.remove('file_changed');
                ob.classList.add('file_nonchanged');
            }
        },

        livePreview: function (e, target) {
            var params = this.params;
            if (!templateEditorPreview(params.fileId, params.livePreviewUrl, target, true)) {
                e.preventDefault();
            }
        },

        screenPreview: function (e, target) {
            var opts = this.params;
            if (!templateEditorPreview(opts.fileId, opts.screenPreviewUrl, target)) {
                e.preventDefault();
            }
        },

        editareaSearch: function (e, target) {
            var regexp = target.dataset.eaSearch;

            editareaDoSearch('e_' + this.params.fileId, regexp);
        },

        insertGuid: function (e, target) {
            var guid = target.dataset.insertGuid;

            insertGuid(this.params.file, guid);

            function insertGuid(file, guid) {
                var textbox = getFileTextbox(file);

                var hasEditarea = editareaIsLoaded(textbox.name);

                editareaReverseRefresh('e_' + fileToFileId(file));

                insertTextbox(textbox, '{' + '+START,IF,{' + '$EQ,{' + '_GUID},' + guid + '}}\n{' + '+END}');
                if (hasEditarea) {
                    editareaRefresh(textbox.id);
                }

                return false;
            }
        },

        addEditorTab: function (e, target) {
            var file = target.dataset.templateFile;

            templateEditorAddTab(file);
        },

        cssEquationHelper: function (e) {
            var params = this.params,
                url = 'themewizard_equation',
                result;

            e.preventDefault();

            url += '&theme=' + encodeURIComponent(params.theme);
            url += '&css_equation=' + encodeURIComponent(document.getElementById('css_equation_' + params.fileId).value);

            result = $cms.loadSnippet(url);

            if (!result || result.includes('<html')) {
                $cms.ui.alert('{!ERROR_OCCURRED;^}');
            } else {
                document.getElementById('css_result_' + params.fileId).value = result;
            }
        }
    });

    function templateEditorPreview(fileId, url, button, askForUrl) {
        if (askForUrl === undefined) {
            askForUrl = false;
        }

        var hasEditarea = editareaIsLoaded('e_' + fileId);
        if (hasEditarea) {
            editareaReverseRefresh('e_' + fileId);
        }

        if (document.getElementById('mobile_preview_' + fileId).checked) {
            url += (url.indexOf('?') == -1) ? '?' : '&';
            url += 'keep_mobile=1';
        }

        if (askForUrl) {
            $cms.ui.prompt(
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

    function loadContextualCssEditor(file, fileId) {
        var ui = document.getElementById('selectors_' + fileId);
        ui.style.display = 'block'; // Un-hide it
        var list = document.createElement('ul');
        list.id = 'selector_list_' + fileId;
        document.getElementById('selectors_inner_' + fileId).appendChild(list);

        setUpParentPageHighlighting(file, fileId);

        // Set up background compiles
        var textareaId = 'e_' + fileId;
        if (editareaIsLoaded(textareaId)) {
            var editor = window.ace_editors[textareaId];

            var lastCss = editareaGetValue(textareaId);

            editor.css_recompiler_timer = window.setInterval(function () {
                if ((window.opener) && (window.opener.document)) {
                    if (editor.last_change === undefined) return; // No change made at all

                    var millisecondsAgo = (new Date()).getTime() - editor.last_change;
                    if (millisecondsAgo > 3 * 1000) return; // Not changed recently enough (within last 3 seconds)

                    if (window.opener.have_set_up_parent_page_highlighting === undefined) {
                        setUpParentPageHighlighting(file, fileId);
                        lastCss = '';
                        /*force new CSS to apply*/
                    }

                    var newCss = editareaGetValue(textareaId);
                    if (newCss == lastCss) return; // Not changed

                    var url = $cms.baseUrl('data/snippet.php?snippet=css_compile__text' + $cms.keepStub());
                    $cms.doAjaxRequest(url, function (ajaxResultFrame) {
                        receiveCompiledCss(ajaxResultFrame, file);
                    }, $cms.form.modsecurityWorkaroundAjax('css=' + encodeURIComponent(newCss)));

                    lastCss = newCss;
                }
            }, 2000);
        }

        function receiveCompiledCss(ajaxResultFrame, file, win) {
            var doingCssFor = file.replace(/^css\//, '').replace('.css', '');

            win || (win = window.opener)

            if (win) {
                try {
                    var css = ajaxResultFrame.responseText;

                    // Remove old link tag
                    var e;
                    if (doingCssFor == 'no_cache') {
                        e = win.document.getElementById('inline_css');
                        if (e) {
                            e.parentNode.removeChild(e);
                        }
                    } else {
                        var links = win.document.getElementsByTagName('link');
                        for (var i = 0; i < links.length; i++) {
                            e = links[i];
                            if ((e.type == 'text/css') && (e.href.indexOf('/templates_cached/' + window.opener.$cms.$LANG() + '/' + doingCssFor) != -1)) {
                                e.parentNode.removeChild(e);
                            }
                        }
                    }

                    // Create style tag for this
                    var style = win.document.getElementById('style_for_' + doingCssFor);
                    if (!style) style = win.document.createElement('style');
                    style.type = 'text/css';
                    style.id = 'style_for_' + doingCssFor;
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
                            receiveCompiledCss(ajaxResultFrame, file, win.frames[i]);
                        }
                    }
                } catch (ex) {}
            }
        }

        function setUpParentPageHighlighting(file, fileId) {
            window.opener.have_set_up_parent_page_highlighting = true;

            var doingCssFor = file.replace(/^css\//, '').replace('.css', '');

            var li, a, selector, elements, element, j, css_text;

            var selectors = window.opener.findActiveSelectors(doingCssFor, window.opener);

            var list = document.getElementById('selector_list_' + fileId);
            $cms.dom.html(list, '');

            for (var i = 0; i < selectors.length; i++) {
                selector = selectors[i].selectorText;

                // Add to list of selectors
                li = document.createElement('li');
                a = document.createElement('a');
                li.appendChild(a);
                a.href = '#!';
                a.id = 'selector_' + i;
                $cms.dom.html(a, $cms.filter.html(selector));
                list.appendChild(li);

                // Add tooltip so we can see what the CSS text is in when hovering the selector
                css_text = (selectors[i].cssText === undefined) ? selectors[i].style.cssText : selectors[i].cssText;
                if (css_text.indexOf('{') !== -1) {
                    css_text = css_text.replace(/ \{ /g, ' {<br />\n&nbsp;&nbsp;&nbsp;').replace(/; \}/g, '<br />\n}').replace(/; /g, ';<br />\n&nbsp;&nbsp;&nbsp;');
                } else  { // IE
                    css_text = css_text.toLowerCase().replace(/; /, ';<br />\n');
                }
                li.addEventListener('mouseout', function (event) {
                    $cms.ui.deactivateTooltip(this);
                });
                li.addEventListener('mousemove', function (event) {
                    $cms.ui.repositionTooltip(this, event);
                });
                li.addEventListener('mouseover', function (cssText) {
                    return function (event) {
                        $cms.ui.activateTooltip(this, event, cssText, 'auto');
                    }
                }(css_text));

                // Jump-to
                a.addEventListener('click', function (selector) {
                    return function (event) {
                        event.stopPropagation();
                        editareaDoSearch(
                            'e_' + fileId,
                            '^[ \t]*' + selector.replace(/\./g, '\\.').replace(/\[/g, '\\[').replace(/\]/g, '\\]').replace(/\{/g, '\\{').replace(/\}/g, '\\}').replace(/\+/g, '\\+').replace(/\*/g, '\\*').replace(/\s/g, '[ \t]+') + '\\s*\\{'
                        ); // Opera does not support \s
                        return false;
                    }
                }(selector));

                // Highlighting on parent page
                a.addEventListener('onmouseover', function (selector) {
                    return function (event) {
                        if ((window.opener) && (!event.ctrlKey) && (!event.metaKey)) {
                            var elements = findSelectorsFor(window.opener, selector);
                            for (var i = 0; i < elements.length; i++) {
                                elements[i].style.outline = '3px dotted green';
                                elements[i].style.backgroundColor = 'green';
                            }
                        }
                    }
                }(selector));
                a.addEventListener('mouseout', function (selector) {
                    return function (event) {
                        if ((window.opener) && (!event.ctrlKey) && (!event.metaKey)) {
                            var elements = findSelectorsFor(window.opener, selector);
                            for (var i = 0; i < elements.length; i++) {
                                elements[i].style.outline = '';
                                elements[i].style.backgroundColor = '';
                            }
                        }
                    }
                }(selector));

                // Highlighting from parent page
                elements = findSelectorsFor(window.opener, selector);
                for (j = 0; j < elements.length; j++) {
                    element = elements[j];

                    element.addEventListener('mouseover', function (a, element) {
                        return function (event) {
                            if (window && !event.ctrlKey && !event.metaKey) {
                                var target = event.target;
                                var targetDistance = 0;
                                var elementRecurse = element;
                                do
                                {
                                    if (elementRecurse == target) break;
                                    elementRecurse = elementRecurse.parentNode;
                                    targetDistance++;
                                }
                                while (elementRecurse);
                                if (targetDistance > 10) targetDistance = 10; // Max range

                                a.style.outline = '1px dotted green';
                                a.style.background = '#00' + (decToHex(255 - targetDistance * 25)) + '00';
                                if (targetDistance > 4)
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

            function findSelectorsFor(opener, selector) {
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
                        result2 = findSelectorsFor(opener.frames[i], selector);
                        for (var j = 0; j < result2.length; j++) result.push(result2[j]);
                    }
                }
                return result;
            }

            function findActiveSelectors(match, win) {
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
                        result2 = findActiveSelectors(match, win.frames[i]);
                        for (var j = 0; j < result2.length; j++) selectors.push(result2[j]);
                    }
                }

                return selectors;
            }
        }
    }

    $cms.functions.adminThemesEditTheme = function () {
        var themee = document.getElementById('theme'),
            themet = document.getElementById('title'),
            copy = document.getElementById('copy');

        if (copy) {
            copy.addEventListener('change', function () {
                if (copy.checked && !themee.value.includes('-copy')) {
                    themee.value += '-copy';
                    themet.value += ' copy';
                }
            });
        }
    };

    $cms.functions.adminThemesAddTheme = function () {
        var title = document.getElementById('title');
        title.addEventListener('change', function () {
            var codename = document.getElementById('theme');
            if (codename.value == '') {
                codename.value = title.value.replace(/[^{$URL_CONTENT_REGEXP_JS}]/g, '');
            }
        });
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button');
        form.addEventListener('submit', function submitCheck(e) {
            var url = '{$FIND_SCRIPT_NOHTTP;,snippet}?snippet=exists_theme&name=' + encodeURIComponent(form.elements['theme'].value);

            submitBtn.disabled = true;
            e.preventDefault();
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    form.removeEventListener('submit', submitCheck);
                    form.submit();
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    };

    $cms.templates.tempcodeTesterScreen = function tempcodeTesterScreen(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-tempcode-tester-do-preview', function (e, btn) {
            var request = '';

            for (var i = 0; i < btn.form.elements.length; i++) {
                request += encodeURIComponent(btn.form.elements[i].name) + '=' + encodeURIComponent(btn.form.elements[i].value) + '&';
            }

            $cms.doAjaxRequest('{$FIND_SCRIPT;,tempcode_tester}' + $cms.keepStub(true), function (ajaxResult) {
                $cms.dom.html(document.getElementById('preview_raw'), $cms.filter.html(ajaxResult.responseText));
                $cms.dom.html(document.getElementById('preview_html'), ajaxResult.responseText);
            }, request);

            $cms.doAjaxRequest('{$FIND_SCRIPT;,tempcode_tester}?comcode=1' + $cms.keepStub(), function (ajaxResult) {
                $cms.dom.html(document.getElementById('preview_comcode'), ajaxResult.responseText);
            }, request);
        });
    };

    $cms.templates.themeTemplateEditorTempcodeDropdown = function themeTemplateEditorTempcodeDropdown(params, container) {
        var fileId = strVal(params.fileId),
            stub = strVal(params.stub);

        $cms.dom.on(container, 'click', '.js-click-template-insert-parameter', function () {
            templateInsertParameter('b_' + fileId + '_' + stub, fileId);
        });

        function templateInsertParameter(dropdownName, fileId) {
            var textbox = document.getElementById('e_' + fileId);

            editareaReverseRefresh('e_' + fileId);

            var dropdown = document.getElementById(dropdownName);
            var value = dropdown.options[dropdown.selectedIndex].value;
            var valueParts = value.split('__');
            value = valueParts[0];
            if (value == '---') return false;

            var hasEditarea = editareaIsLoaded(textbox.name);

            if ((value == 'BLOCK') && (($cms.ui.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays'))) {
                var url = '{$FIND_SCRIPT_NOHTTP;,block_helper}?field_name=' + textbox.name + '&block_type=template' + $cms.keepStub();
                $cms.ui.showModalDialog(
                    $cms.maintainThemeInLink(url),
                    null,
                    'dialogWidth=750;dialogHeight=600;status=no;resizable=yes;scrollbars=yes;unadorned=yes',
                    function () {
                        if (hasEditarea) {
                            editareaRefresh(textbox.name);
                        }
                    }
                );
                return;
            }

            var arity = valueParts[1];
            var definiteGets = 0;
            if (arity == '1') definiteGets = 1;
            else if (arity == '2') definiteGets = 2;
            else if (arity == '3') definiteGets = 3;
            else if (arity == '4') definiteGets = 4;
            else if (arity == '5') definiteGets = 5;
            else if (arity == '0-1') definiteGets = 0;
            else if (arity == '3-4') definiteGets = 3;
            else if (arity == '0+') definiteGets = 0;
            else if (arity == '1+') definiteGets = 1;
            var parameter = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'];

            _getParameterParameters(
                definiteGets,
                parameter,
                arity,
                textbox,
                name,
                value,
                0,
                '',
                function (textbox, name, value, params) {
                    if (name.indexOf('ppdirective') != -1) {
                        insertTextboxWrapping(textbox, '{' + '+START,' + value + params + '}', '{' + '+END}');
                    } else {
                        var stValue;
                        if (name.indexOf('ppparameter') == -1) {
                            stValue = '{' + '$';
                        } else {
                            stValue = '{';
                        }

                        value = stValue + value + '*' + params + '}';

                        insertTextbox(textbox, value);
                    }

                    if (hasEditarea) editareaRefresh(textbox.name);
                }
            );

            return false;

            function _getParameterParameters(definiteGets, parameter, arity, box, name, value, numDone, params, callback) {
                if (numDone < definiteGets) {
                    $cms.ui.prompt(
                        '{!themes:INPUT_NECESSARY_PARAMETER;^}' + ', ' + parameter[numDone],
                        '',
                        function (v) {
                            if (v !== null) {
                                params = params + ',' + v;
                                _getParameterParameters(definiteGets, parameter, arity, box, name, value, numDone + 1, params, callback);
                            }
                        },
                        '{!themes:INSERT_PARAMETER;^}'
                    );
                } else {
                    if ((arity == '0+') || (arity == '1+')) {
                        $cms.ui.prompt(
                            '{!themes:INPUT_OPTIONAL_PARAMETER;^}',
                            '',
                            function (v) {
                                if (v !== null) {
                                    params = params + ',' + v;
                                    _getParameterParameters(definiteGets, parameter, arity, box, name, value, numDone + 1, params, callback);
                                } else callback(box, name, value, params);
                            },
                            '{!themes:INSERT_PARAMETER;^}'
                        );
                    }
                    else if ((arity == '0-1') || (arity == '3-4')) {
                        $cms.ui.prompt(
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
        }
    };

    $cms.templates.templateEditLink = function templateEditLink(params, container) {
        var editUrl = strVal(params.editUrl);

        $cms.dom.on(container, 'click', '.js-click-open-edit-url', function () {
            window.open(editUrl);
        });

        $cms.dom.on(container, 'click', '.js-keypress-open-edit-url', function () {
            window.open(editUrl);
        });
    };

    $cms.templates.themeTemplateEditorScreen = function themeTemplateEditorScreen(params, container) {
        window.template_editor_theme = params.theme;

        if (params.activeGuid !== undefined) {
            window.template_editor_active_guid = params.activeGuid;
        }

        if (params.livePreviewUrl !== undefined) {
            window.template_editor_live_preview_url = params.livePreviewUrl;
        }

        templateEditorCleanTabs();

        $cms.requireJavascript('tree_list').then(function () {
            window.sitemap = $cms.ui.createTreeList('theme_files', 'data/ajax_tree.php?hook=choose_theme_files&theme=' + params.theme + $cms.$KEEP(), null, '', false, null, false, true);
        });

        window.setTimeout(function () {
            for (var i = 0, len = params.filesToLoad.length; i < len; i++) {
                templateEditorAddTab(params.filesToLoad[i]);
            }
        }, 1000);

        window.jQuery && window.jQuery.fn.resizable && window.jQuery('.template_editor_file_selector').resizable();

        templateEditorAssignUnloadEvent();

        $cms.dom.on(container, 'change', '.js-change-template-editor-add-tab-wrap', function () {
            templateEditorAddTab(document.getElementById('theme_files').value);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-add-template', function () {
            addTemplate();
        });

        function addTemplate() {
            $cms.ui.prompt(
                '{!themes:INPUT_TEMPLATE_TYPE;^}',
                'templates',
                function (subdir) {
                    if (subdir !== null) {
                        if (subdir != 'templates' && subdir != 'css' && subdir != 'javascript' && subdir != 'text' && subdir != 'xml') {
                            $cms.ui.alert('{!BAD_TEMPLATE_TYPE;^}');
                            return;
                        }

                        $cms.ui.prompt(
                            '{!themes:INPUT_TEMPLATE_NAME;^}',
                            'example',
                            function (file) {
                                if (file !== null) {
                                    file = file.replace(/\..*$/, '');
                                    switch (subdir) {
                                        case 'templates':
                                            file += '.tpl';
                                            break;

                                        case 'css':
                                            file += '.css';
                                            break;

                                        case 'javascript':
                                            file += '.js';
                                            break;

                                        case 'text':
                                            file += '.txt';
                                            break;

                                        case 'xml':
                                            file += '.xml';
                                            break;
                                    }

                                    templateEditorAddTab(file);
                                }
                            },
                            '{!themes:ADD_TEMPLATE;^}'
                        );
                    }
                },
                '{!themes:ADD_TEMPLATE;^}'
            );

            return false;
        }

        function templateEditorAssignUnloadEvent() {
            window.addEventListener('beforeunload', function (event) {
                if (document.querySelector('.file_changed')) {
                    $cms.undoStaffUnloadAction();
                    window.unloaded = false;

                    var ret = '{!UNSAVED_TEMPLATE_CHANGES;^}';
                    event.returnValue = ret; // Fix Chrome bug (explained on https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload)
                    return ret;
                }
                return null;
            });
        }
    };

    $cms.templates.themeImageManageScreen = function () {
        window.main_form_very_simple = true;
    };

    $cms.templates.themeTemplateEditorRestoreRevision = function (params, container) {
        var file = strVal(params.file),
            revisionId = strVal(params.revisionId);

        $cms.dom.on(container, 'click', function () {
            templateEditorRestoreRevision(file, revisionId);
        });

        function templateEditorRestoreRevision(file, revisionId) {
            var fileId = fileToFileId(file);

            // Set content from revision
            var url = templateEditorLoadingUrl(file, revisionId);
            $cms.loadSnippet(url, null, true).then(function (ajaxResult) {
                document.getElementById('t_' + fileId).className = 'tab tab_active';

                templateEditorTabLoadedContent(ajaxResult, file);
            });

            return false;
        }
    };

    $cms.templates.templateTreeItem = function templateTreeItem(params, container) {
        $cms.dom.on(container, 'click', '.js-click-checkbox-toggle-guid-input', function (e, checkbox) {
            var el = $cms.dom.$('#f' + checkbox.id.replace(/file/, 'guid'));
            if (el) {
                el.disabled = !checkbox.checked;
            }
        });
    };

    $cms.templates.themeScreenPreview = function (params, container) {
        var template = strVal(params.template);

        $cms.dom.on(container, 'click', '.js-link-click-open-template-preview-window', function (e, link) {
            window.open(link.href, 'template_preview_' + template, 'width=800,height=600,status=no,resizable=yes,scrollbars=yes');
        });

        $cms.dom.on(container, 'click', '.js-link-click-open-mobile-template-preview-window', function (e, link) {
            window.open(link.href, 'template_preview_' + template, 'width=320,height=480,status=no,resizable=yes,scrollbars=yes');
        });
    };

    function cleanupTemplateMarkers(win) {
        if (window.done_cleanup_template_markers) {
            return;
        }

        _cleanupTemplateMarkers(win.document.body, 0);

        window.done_cleanup_template_markers = true;

        function _cleanupTemplateMarkers(node, depth) {
            var inside = [];

            node = node.firstChild;
            while (node) {
                if (node.nodeType === 3) { // Text node
                    var matches = node.data.match(/[\u200B\uFEFF]+/g);
                    if (matches) {
                        var allDecoded = [];
                        for (var i = 0; i < matches.length; i++) {
                            var decoded = invisibleOutputDecode(matches[i]);
                            var _decoded = decoded.match(/<\/?templates\/[^<>]*>/g);
                            for (var j = 0; j < _decoded.length; j++) {
                                allDecoded.push(_decoded[j]);
                            }
                        }
                        for (var i = 0; i < allDecoded.length; i++) {
                            var decoded = allDecoded[i];
                            var openerMatch = decoded.match('<(templates/.*)>');
                            if (openerMatch != null) {
                                inside.push(openerMatch[1]);
                            }
                            var closerMatch = decoded.match('</(templates/.*)>');
                            if (closerMatch != null) {
                                var at = inside.indexOf(closerMatch[1]);
                                if (at != -1) inside.splice(at, 1);
                            }

                            node.data = node.data.replace(matches[i], ''); // Strip it, to clean document
                        }
                    }
                } else if (node.nodeType === 1) { // Element node
                    var before = node.getAttribute('data-template');
                    if (!before) before = '';
                    node.setAttribute('data-template', before + ' ' + inside.join(' ') + ' ');
                }

                // Continue...

                _cleanupTemplateMarkers(node, depth + 1);

                node = node.nextSibling;
            }

            function invisibleOutputDecode(string) {
                var ret = '';
                var i, j, character, _bitsRep, bitsRep, _bit, bit;
                var len = string.length;
                for (i = 0; i < len / 8; i++) {
                    _bitsRep = '';
                    for (_bit = 0; _bit < 8; _bit++) {
                        character = string.substr(i * 8 + _bit, 1);
                        bit = (character == "\u200B") ? "1" : "0";
                        _bitsRep += bit;
                    }
                    bitsRep = window.parseInt(_bitsRep, 2);
                    ret += String.fromCharCode(bitsRep);
                }

                return ret;
            }
        }
    }

    function templateEditorAddTab(file) {
        var tabTitle = file.replace(/^.*\//, ''),
            fileId = fileToFileId(file);

        // Switch to tab if exists
        if (document.getElementById('t_' + fileId)) {
            $cms.ui.selectTab('g', fileId);

            templateEditorShowTab(fileId);

            return;
        }

        // Create new tab header
        var headers = document.getElementById('template_editor_tab_headers');

        var header = document.createElement('a');
        header.setAttribute('aria-controls', 'g_' + fileId);
        header.setAttribute('role', 'tab');
        header.setAttribute('href', '#');
        header.id = 't_' + fileId;
        header.className = 'tab file_nonchanged';
        header.addEventListener('click', function (event) {
            $cms.ui.selectTab('g', fileId);
            templateEditorShowTab(fileId);
            return false;
        });

        var ext = (tabTitle.indexOf('.') != -1) ? tabTitle.substring(tabTitle.indexOf('.') + 1, tabTitle.length) : '';
        if (ext != '') {
            tabTitle = tabTitle.substr(0, tabTitle.length - 4);
        }
        var iconImg = document.createElement('img');
        if (ext == 'tpl') {
            iconImg.src = $cms.img('{$IMG;,icons/16x16/filetypes/tpl}');
            iconImg.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/tpl}'));
        }
        if (ext == 'css') {
            iconImg.src = $cms.img('{$IMG;,icons/16x16/filetypes/css}');
            iconImg.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/css}'));
        }
        if (ext == 'js') {
            iconImg.src = $cms.img('{$IMG;,icons/16x16/filetypes/js}');
            iconImg.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/js}'));
        }
        if (ext == 'xml') {
            iconImg.src = $cms.img('{$IMG;,icons/16x16/filetypes/xml}');
            iconImg.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/xml}'));
        }
        if (ext == 'txt' || ext == '') {
            iconImg.src = $cms.img('{$IMG;,icons/16x16/filetypes/page_txt}');
            iconImg.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/page_txt}'));
        }
        iconImg.style.width = '16px';
        header.appendChild(iconImg);
        header.appendChild(document.createTextNode(' '));
        var span = document.createElement('span');
        span.textContent = tabTitle;
        header.appendChild(span);
        var closeButton = document.createElement('img');
        closeButton.src = $cms.img('{$IMG;,icons/16x16/close}');
        if (closeButton.srcset !== undefined) {
            closeButton.srcset = $cms.img('{$IMG;,icons/32x32/close}') + ' 2x';
        }
        closeButton.alt = '{!CLOSE;^}';
        closeButton.style.paddingLeft = '5px';
        closeButton.style.width = '16px';
        closeButton.style.height = '16px';
        closeButton.style.verticalAlign = 'middle';
        closeButton.addEventListener('click', function (event) {
            event.stopPropagation();
            if (event.cancelable) {
                event.preventDefault();
            }

            if (window.template_editor_open_files[file].unsaved_changes) {
                $cms.ui.confirm('{!themes:UNSAVED_CHANGES;^}'.replace('\{1\}', file), function (result) {
                    if (result) {
                        templateEditorTabUnloadContent(file);
                    }
                }, '{!Q_SURE;^}', true);
            } else {
                templateEditorTabUnloadContent(file);
            }
        });
        header.appendChild(closeButton);
        headers.appendChild(header);

        // Create new tab body
        var bodies = document.getElementById('template_editor_tab_bodies');
        var body = document.createElement('div');
        body.setAttribute('aria-labeledby', 't_' + fileId);
        body.setAttribute('role', 'tabpanel');
        body.id = 'g_' + fileId;
        body.style.display = 'none';
        var loadingImage = document.createElement('img');
        loadingImage.className = 'ajax_loading';
        loadingImage.src = $cms.img('{$IMG;,loading}');
        loadingImage.style.height = '12px';
        body.appendChild(loadingImage);
        bodies.appendChild(body);

        // Set content
        var url = templateEditorLoadingUrl(file);
        $cms.loadSnippet(url, null, true).then(function (ajaxResult) {
            templateEditorTabLoadedContent(ajaxResult, file);
        });

        // Cleanup
        templateEditorCleanTabs();

        // Select tab
        $cms.ui.selectTab('g', fileId);

        templateEditorShowTab(fileId);

        function templateEditorTabUnloadContent(file) {
            var fileId = fileToFileId(file);
            var wasActive = templateEditorRemoveTab(fileId);

            delete window.template_editor_open_files[file];

            if (wasActive) {
                // Select tab
                var c = document.getElementById('template_editor_tab_headers').childNodes;
                if (c[0] !== undefined) {
                    var nextFileId = c[0].id.substr(2);

                    $cms.ui.selectTab('g', nextFileId);

                    templateEditorShowTab(nextFileId);
                }
            }

            function templateEditorRemoveTab(fileId) {
                var header = document.getElementById('t_' + fileId);
                if (header) {
                    var isActive = (header.className.indexOf(' tab_active') != -1);

                    header.parentNode.removeChild(header);
                    var body = document.getElementById('g_' + fileId);
                    if (body) body.parentNode.removeChild(body);

                    templateEditorCleanTabs();

                    return isActive;
                }

                return false;
            }
        }
    }

    function templateEditorLoadingUrl(file, revisionId) {
        var url = 'template_editor_load';
        url += '&file=' + encodeURIComponent(file);
        url += '&theme=' + encodeURIComponent(window.template_editor_theme);
        if (window.template_editor_active_guid !== undefined) {
            url += '&active_guid=' + encodeURIComponent(window.template_editor_active_guid);
        }
        if (window.template_editor_live_preview_url !== undefined) {
            url += '&live_preview_url=' + encodeURIComponent(window.template_editor_live_preview_url);
        }
        if (revisionId !== undefined) {
            url += '&undo_revision=' + encodeURIComponent(revisionId);
        }
        return url;
    }

    function templateEditorCleanTabs() {
        var headers = document.getElementById('template_editor_tab_headers');
        var bodies = document.getElementById('template_editor_tab_bodies');
        var numTabs = headers.childNodes.length;

        var header = document.getElementById('t_default');
        var body = document.getElementById('g_default');

        if (header && numTabs > 1) {
            header.parentNode.removeChild(header);
            body.parentNode.removeChild(body);
        }

        if (numTabs == 0) {
            $cms.dom.html(headers, '<a href="#!" id="t_default" class="tab"><span>&mdash;</span></a>');
            $cms.dom.html(bodies, '<div id="g_default"><p class="nothing_here">{!NA}</p></div>');
        }
    }

    function templateEditorTabLoadedContent(ajaxResult, file) {
        var fileId = fileToFileId(file);

        $cms.dom.html('#g_' + fileId, ajaxResult.responseText);

        window.setTimeout(function () {
            var textareaId = 'e_' + fileId;
            if (editareaIsLoaded(textareaId)) {
                var editor = window.ace_editors[textareaId];
                var editorSession = editor.getSession();
                editorSession.on('change', function () {
                    templateEditorTabMarkChangedContent(file);
                    editor.last_change = (new Date()).getTime();
                });
            } else {
                getFileTextbox(file).addEventListener('change', function () {
                    templateEditorTabMarkChangedContent(file);
                });
            }
        }, 1000);

        window.template_editor_open_files[file] = {
            unsaved_changes: false
        };

        function templateEditorTabMarkChangedContent(file) {
            window.template_editor_open_files[file].unsaved_changes = true;

            var fileId = fileToFileId(file);
            var ob = document.getElementById('t_' + fileId);
            ob.classList.remove('file_nonchanged');
            ob.classList.add('file_changed');
        }
    }

    function templateEditorShowTab(fileId) {
        window.setTimeout(function () {
            if (!document.getElementById('t_' + fileId) || document.getElementById('t_' + fileId).className.indexOf('tab_active') == -1) {
                // No longer visible
                return;
            }

            if (window.opener) // If anchored
                highlightTemplate(window.opener, fileIdToFile(fileId));

            window.jQuery('#e_' + fileId.replace(/\./g, '\\.') + '_wrap').resizable({
                resize: function (event, ui) {
                    var editor = window.ace_editors['e_' + fileId];
                    if (editor !== undefined) {
                        $cms.dom.$('#e_' + fileId.replace(/\./g, '\\.') + '__ace').style.height = '100%';
                        $cms.dom.$('#e_' + fileId.replace(/\./g, '\\.') + '__ace').parentNode.style.height = '100%';
                        editor.resize();
                    }
                },
                handles: 's'
            });
        }, 1000);

        function fileIdToFile(fileId) {
            for (var file in window.template_editor_open_files) {
                if (fileToFileId(file) == fileId) return file;
            }
            return null;
        }

        function highlightTemplate(win, templatePath) {
            _highlightTemplate(win.document.body, templatePath, 0);


            function _highlightTemplate(node, templatePath, depth) {
                var inside = [];

                node = node.firstChild;
                while (node) {
                    if (node.nodeType === 1) { // Element node
                        var template = node.getAttribute('data-template');
                        var dataMatch = (template && template.includes(' ' + templatePath + ' '));
                        if (dataMatch) {
                            node.classList.add('glowing_node');
                        } else {
                            node.classList.remove('glowing_node');
                        }
                    }

                    // Continue...

                    _highlightTemplate(node, templatePath, depth + 1);

                    node = node.nextSibling;
                }
            }
        }
    }

    function getFileTextbox(file) {
        return document.getElementById('e_' + fileToFileId(file));
    }

    function fileToFileId(file) {
        return file.replace(/\//, '__').replace(/:/, '__').replace(/\./, '__');
    }

    function decToHex(number) {
        var hexbase = '0123456789ABCDEF';
        return hexbase.charAt((number >> 4) & 0xf) + hexbase.charAt(number & 0xf);
    }
}(window.$cms));
