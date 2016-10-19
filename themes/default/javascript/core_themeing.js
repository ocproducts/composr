(function ($cms) {
    'use strict';

    $cms.views.ThemeManageScreen = ThemeManageScreen;
    $cms.views.ThemeTemplateEditorTab = ThemeTemplateEditorTab;

    function ThemeManageScreen() {
        ThemeManageScreen.base(this, arguments);
    }

    $cms.inherits(ThemeManageScreen, $cms.View);

    function ThemeTemplateEditorTab(params) {
        ThemeTemplateEditorTab.base(this, arguments);

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
        events: {
            'keydown .js-ta-tpl-editor': 'editorKeyPress',
            'click .js-btn-save-content': 'saveContent',
            'click .js-btn-live-preview': 'livePreview',
            'click .js-btn-screen-preview': 'screenPreview',
            'click .js-a-editarea-search': 'editareaSearch',
            'click .js-a-insert-guid': 'insertGuid',
            'click .js-a-tpl-editor-add-tab' : 'addEditorTab',
            'click .js-btn-equation-helper': 'cssEquationHelper'
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
            var opts = this.params;
            if (!template_editor_preview(opts.fileId, opts.livePreviewUrl, target, true)) {
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

    $cms.extend($cms.templates, {
        tempcodeTesterScreen: function tempcodeTesterScreen() {
            var form = this,
                button = form.querySelector('.js-btn-do-preview');

            button.addEventListener('click', function () {
                var request = '';

                for (var i = 0; i < form.elements.length; i++) {
                    request += encodeURIComponent(form.elements[i].name) + '=' + encodeURIComponent(form.elements[i].value) + '&';
                }

                do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}' + keep_stub(true), function (ajax_result) {
                    $cms.dom.html(document.getElementById('preview_raw'), escape_html(ajax_result.responseText));
                    $cms.dom.html(document.getElementById('preview_html'), ajax_result.responseText);
                }, request);

                do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}?comcode=1' + keep_stub(), function (ajax_result) {
                    $cms.dom.html(document.getElementById('preview_comcode'), ajax_result.responseText);
                }, request);
            });
        },

        themeTemplateEditorScreen: function themeTemplateEditorScreen(params) {
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

            window.jQuery('.template_editor_file_selector').resizable();

            template_editor_assign_unload_event();
        },

        themeImageManageScreen: function () {
            window.main_form_very_simple = true;
        }
    });
}(window.$cms));

