(function ($, Composr) {
    Composr.behaviors.coreThemeing = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_themeing');
                Composr.initializeTemplates(context, 'core_themeing');
            }
        }
    };

    var ThemeManageScreen = Composr.View.extend({
        initialize: function (v, options) {
            Composr.View.prototype.initialize.apply(this, arguments);


        }
    });

    var ThemeTemplateEditorTab = Composr.View.extend({
        initialize: function (viewOptions, options) {
            this.options = options;

            // Allow searching via URL hash
            if (window.location.hash) {
                window.setTimeout(function () {
                    var hash = window.location.hash.substr(1, window.location.hash.length - 1);
                    editarea_do_search('e_' + options.fileId, hash);
                }, 2000);
            }

            if (Composr.is(Composr.$CONFIG_OPTION.editarea)) {
                ace_composr_loader('e_' + options.fileId, options.highlighterType, false);
            }

            if (Composr.is(options.includeCssEditing) && window.opener && window.opener.document) {
                load_contextual_css_editor(options.file, options.fileId);
            }
        },

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
            template_editor_tab_save_content(this.options.file);
        },

        livePreview: function (e) {
            var opts = this.options;
            if (!template_editor_preview(opts.fileId, opts.livePreviewUrl, e.currentTarget, true)) {
                e.preventDefault();
            }
        },

        screenPreview: function (e) {
            var opts = this.options;
            if (!template_editor_preview(opts.fileId, opts.screenPreviewUrl, e.currentTarget)) {
                e.preventDefault();
            }
        },

        editareaSearch: function (e) {
            var regexp = e.currentTarget.dataset.eaSearch;

            editarea_do_search('e_' + this.options.fileId, regexp);
        },

        insertGuid: function (e) {
            var guid = e.currentTarget.dataset.insertGuid;

            insert_guid(this.options.file, guid);
        },

        addEditorTab: function (e) {
            var file = e.currentTarget.dataset.templateFile;

            template_editor_add_tab(file);
        },

        cssEquationHelper: function (e) {
            var opts = this.options,
                url = 'themewizard_equation',
                result;

            e.preventDefault();

            url += '&theme=' + window.encodeURIComponent(opts.theme);
            url += '&css_equation=' + window.encodeURIComponent(document.getElementById('css_equation_' + opts.fileId).value);

            result = load_snippet(url);

            if (!result || result.includes('<html')) {
                window.fauxmodal_alert('{!ERROR_OCCURRED;}');
            } else {
                document.getElementById('css_result_' + opts.fileId).value = result;
            }
        }
    });

    Composr.views.coreThemeing = {
        ThemeManageScreen: ThemeManageScreen,
        ThemeTemplateEditorTab: ThemeTemplateEditorTab
    };

    Composr.templates.coreThemeing = {
        tempcodeTesterScreen: function tempcodeTesterScreen(options) {
            var form = this,
                button = form.querySelector('.js-btn-do-preview');

            button.addEventListener('click', function () {
                doTempcodeTesterPreview(form);
            });
        },

        themeTemplateEditorScreen: function themeTemplateEditorScreen(options) {
            Composr.required(options, ['theme']);

            window.template_editor_theme = options.theme;

            if (typeof options.activeGuid !== 'undefined') {
                window.template_editor_active_guid = options.activeGuid;
            }

            if (typeof options.livePreviewUrl !== 'undefined') {
                window.template_editor_live_preview_url = options.livePreviewUrl;
            }

            template_editor_clean_tabs();

            window.sitemap = new tree_list('theme_files', 'data/ajax_tree.php?hook=choose_theme_files&theme=' + options.theme + Composr.$KEEP, null, '', false, null, false, true);

            window.setTimeout(function () {
                for (var i = 0, len = options.filesToLoad.length; i < len; i++) {
                    template_editor_add_tab(options.filesToLoad[i]);
                }
            }, 1000);

            $('.template_editor_file_selector').resizable();

            template_editor_assign_unload_event();
        },

        themeImageManageScreen: function themeImageManageScreen() {
            window.main_form_very_simple = true;
        }
    };

    function doTempcodeTesterPreview(form) {
        var request = '';

        for (var i = 0; i < form.elements.length; i++) {
            request += window.encodeURIComponent(form.elements[i].name) + '=' + window.encodeURIComponent(form.elements[i].value) + '&';
        }

        do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}' + keep_stub(true), function (ajax_result) {
            Composr.dom.html(document.getElementById('preview_raw'), escape_html(ajax_result.responseText));
            Composr.dom.html(document.getElementById('preview_html'), ajax_result.responseText);
        }, request);

        do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}?comcode=1' + keep_stub(), function (ajax_result) {
            Composr.dom.html(document.getElementById('preview_comcode'), ajax_result.responseText);
        }, request);

        return false;
    }
})(window.jQuery || window.Zepto, Composr);

