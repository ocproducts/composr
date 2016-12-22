(function ($cms) {
    'use strict';

    $cms.views.ThemeManageScreen = ThemeManageScreen;
    $cms.views.ThemeTemplateEditorTab = ThemeTemplateEditorTab;

    function ThemeManageScreen() {
        ThemeManageScreen.base(this, 'constructor', arguments);
    }

    $cms.inherits(ThemeManageScreen, $cms.View);

    function ThemeTemplateEditorTab(params) {
        ThemeTemplateEditorTab.base(this, 'constructor', arguments);

        // Allow searching via URL hash
        if (window.location.hash) {
            window.setTimeout(function () {
                var hash = window.location.hash.substr(1, window.location.hash.length - 1);
                editarea_do_search('e_' + params.fileId, hash);
            }, 2000);
        }

        if ($cms.$CONFIG_OPTION.editarea) {
            ace_composr_loader('e_' + params.fileId, params.highlighterType, false);
        }

        if (params.includeCssEditing && window.opener && window.opener.document) {
            load_contextual_css_editor(params.file, params.fileId);
        }
    }

    $cms.inherits(ThemeTemplateEditorTab, $cms.View, {
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
            if (!template_editor_keypress(e)) {
                e.preventDefault();
            }
        },

        saveContent: function (e) {
            e.preventDefault();
            template_editor_tab_save_content(this.params.file);
        },

        livePreview: function (e, target) {
            var params = this.params;
            if (!template_editor_preview(params.fileId, params.livePreviewUrl, target, true)) {
                e.preventDefault();
            }
        },

        screenPreview: function (e, target) {
            var opts = this.params;
            if (!template_editor_preview(opts.fileId, opts.screenPreviewUrl, target)) {
                e.preventDefault();
            }
        },

        editareaSearch: function (e, target) {
            var regexp = target.dataset.eaSearch;

            editarea_do_search('e_' + this.params.fileId, regexp);
        },

        insertGuid: function (e, target) {
            var guid = target.dataset.insertGuid;

            insert_guid(this.params.file, guid);
        },

        addEditorTab: function (e, target) {
            var file = target.dataset.templateFile;

            template_editor_add_tab(file);
        },

        cssEquationHelper: function (e) {
            var params = this.params,
                url = 'themewizard_equation',
                result;

            e.preventDefault();

            url += '&theme=' + encodeURIComponent(params.theme);
            url += '&css_equation=' + encodeURIComponent(document.getElementById('css_equation_' + params.fileId).value);

            result = load_snippet(url);

            if (!result || result.includes('<html')) {
                window.fauxmodal_alert('{!ERROR_OCCURRED;^}');
            } else {
                document.getElementById('css_result_' + params.fileId).value = result;
            }
        }
    });


    $cms.templates.tempcodeTesterScreen = function tempcodeTesterScreen(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-tempcode-tester-do-preview', function (e, btn) {
            var request = '';

            for (var i = 0; i < btn.form.elements.length; i++) {
                request += encodeURIComponent(btn.form.elements[i].name) + '=' + encodeURIComponent(btn.form.elements[i].value) + '&';
            }

            do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}' + keep_stub(true), function (ajax_result) {
                $cms.dom.html(document.getElementById('preview_raw'), escape_html(ajax_result.responseText));
                $cms.dom.html(document.getElementById('preview_html'), ajax_result.responseText);
            }, request);

            do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}?comcode=1' + keep_stub(), function (ajax_result) {
                $cms.dom.html(document.getElementById('preview_comcode'), ajax_result.responseText);
            }, request);
        });
    };

    $cms.templates.themeTemplateEditorTempcodeDropdown = function themeTemplateEditorTempcodeDropdown(params, container) {
        var fileId = strVal(params.fileId),
            stub = strVal(params.stub);

        $cms.dom.on(container, 'click', '.js-click-template-insert-parameter', function () {
            template_insert_parameter('b_' + fileId + '_' + stub, fileId);
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

        template_editor_clean_tabs();

        window.sitemap = $cms.createTreeList('theme_files', 'data/ajax_tree.php?hook=choose_theme_files&theme=' + params.theme + $cms.$KEEP, null, '', false, null, false, true);

        window.setTimeout(function () {
            for (var i = 0, len = params.filesToLoad.length; i < len; i++) {
                template_editor_add_tab(params.filesToLoad[i]);
            }
        }, 1000);

        window.jQuery && window.jQuery.fn.resizable && window.jQuery('.template_editor_file_selector').resizable();

        template_editor_assign_unload_event();

        $cms.dom.on(container, 'change', '.js-change-template-editor-add-tab-wrap', function () {
            template_editor_add_tab(document.getElementById('theme_files').value);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-add-template', function () {
            add_template();
        });

        function add_template() {
            window.fauxmodal_prompt(
                '{!themes:INPUT_TEMPLATE_TYPE;^}',
                'templates',
                function (subdir) {
                    if (subdir !== null) {
                        if (subdir != 'templates' && subdir != 'css' && subdir != 'javascript' && subdir != 'text' && subdir != 'xml') {
                            window.fauxmodal_alert('{!BAD_TEMPLATE_TYPE;^}');
                            return;
                        }

                        window.fauxmodal_prompt(
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

                                    template_editor_add_tab(file);
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
    };

    $cms.templates.themeImageManageScreen = function () {
        window.main_form_very_simple = true;
    };

    $cms.templates.themeTemplateEditorRestoreRevision = function (params, container) {
        var file = strVal(params.file),
            revisionId = strVal(params.revisionId);

        $cms.dom.on(container, 'click', function () {
            template_editor_restore_revision(file, revisionId);
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

    function template_editor_add_tab(file) {
        var tab_title = file.replace(/^.*\//, ''),
            file_id = file_to_file_id(file);

        // Switch to tab if exists
        if (document.getElementById('t_' + file_id)) {
            select_tab('g', file_id);

            template_editor_show_tab(file_id);

            return;
        }

        // Create new tab header
        var headers = document.getElementById('template_editor_tab_headers');

        var header = document.createElement('a');
        header.setAttribute('aria-controls', 'g_' + file_id);
        header.setAttribute('role', 'tab');
        header.setAttribute('href', '#');
        header.id = 't_' + file_id;
        header.className = 'tab file_nonchanged';
        header.onclick = function (event) {
            select_tab('g', file_id);
            template_editor_show_tab(file_id);
            return false;
        };

        var ext = (tab_title.indexOf('.') != -1) ? tab_title.substring(tab_title.indexOf('.') + 1, tab_title.length) : '';
        if (ext != '') tab_title = tab_title.substr(0, tab_title.length - 4);
        var icon_img = document.createElement('img');
        if (ext == 'tpl') {
            icon_img.src = $cms.img('{$IMG;,icons/16x16/filetypes/tpl}');
            icon_img.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/tpl}'));
        }
        if (ext == 'css') {
            icon_img.src = $cms.img('{$IMG;,icons/16x16/filetypes/css}');
            icon_img.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/css}'));
        }
        if (ext == 'js') {
            icon_img.src = $cms.img('{$IMG;,icons/16x16/filetypes/js}');
            icon_img.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/js}'));
        }
        if (ext == 'xml') {
            icon_img.src = $cms.img('{$IMG;,icons/16x16/filetypes/xml}');
            icon_img.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/xml}'));
        }
        if (ext == 'txt' || ext == '') {
            icon_img.src = $cms.img('{$IMG;,icons/16x16/filetypes/page_txt}');
            icon_img.setAttribute('srcset', $cms.img('{$IMG;,icons/32x32/filetypes/page_txt}'));
        }
        icon_img.style.width = '16px';
        header.appendChild(icon_img);
        header.appendChild(document.createTextNode(' '));
        var span = document.createElement('span');
        span.textContent = tab_title;
        header.appendChild(span);
        var close_button = document.createElement('img');
        close_button.src = $cms.img('{$IMG;,icons/16x16/close}');
        if (close_button.srcset !== undefined) {
            close_button.srcset = $cms.img('{$IMG;,icons/32x32/close}') + ' 2x';
        }
        close_button.alt = '{!CLOSE;^}';
        close_button.style.paddingLeft = '5px';
        close_button.style.width = '16px';
        close_button.style.height = '16px';
        close_button.style.verticalAlign = 'middle';
        close_button.onclick = function (event) {
            cancel_bubbling(event);
            if (event.cancelable) {
                event.preventDefault();
            }

            if (window.template_editor_open_files[file].unsaved_changes) {
                fauxmodal_confirm('{!themes:UNSAVED_CHANGES;^}'.replace('\{1\}', file), function (result) {
                    if (result) {
                        template_editor_tab_unload_content(file);
                    }
                }, '{!Q_SURE;^}', true);
            } else {
                template_editor_tab_unload_content(file);
            }
        };
        header.appendChild(close_button);
        headers.appendChild(header);

        // Create new tab body
        var bodies = document.getElementById('template_editor_tab_bodies');
        var body = document.createElement('div');
        body.setAttribute('aria-labeledby', 't_' + file_id);
        body.setAttribute('role', 'tabpanel');
        body.id = 'g_' + file_id;
        body.style.display = 'none';
        var loading_image = document.createElement('img');
        loading_image.className = 'ajax_loading';
        loading_image.src = $cms.img('{$IMG;,loading}');
        loading_image.style.height = '12px';
        body.appendChild(loading_image);
        bodies.appendChild(body);

        // Set content
        var url = template_editor_loading_url(file);
        load_snippet(url, null, function (ajax_result) {
            template_editor_tab_loaded_content(ajax_result, file);
        });

        // Cleanup
        template_editor_clean_tabs();

        // Select tab
        select_tab('g', file_id);

        template_editor_show_tab(file_id);
    }
}(window.$cms));

