(function ($, Composr) {
    Composr.templates.coreThemeing = {
        tempcodeTesterScreen: function tempcodeTesterScreen(options) {
            var form = this,
                button = form.querySelector('.js-btn-do-preview');

            button.addEventListener('click', function () {
                doTempcodeTesterPreview(form);
            });
        },

        themeTemplateEditorTab: function themeTemplateEditorTab(options) {
            // Allow searching via URL hash
            if (window.location.hash) {
                window.setTimeout(function () {
                    var hash = window.location.hash.substr(1, window.location.hash.length - 1);
                    editarea_do_search('e_' + options.fileId, hash);
                }, 2000);
            }

            if (Composr.isTruthy(options.editareaConfig)) {
                ace_composr_loader('e_' + options.fileId, options.highlighterType, false);
            }

            if (Composr.isTruthy(options.includeCssEditing) && window.opener && window.opener.document) {
                load_contextual_css_editor(options.file, options.fileId);
            }
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

    Composr.behaviors.coreThemeing = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_themeing');
            }
        }
    };

    function doTempcodeTesterPreview(form) {
        var request = '';

        for (var i = 0; i < form.elements.length; i++) {
            request += window.encodeURIComponent(form.elements[i].name) + '=' + window.encodeURIComponent(form.elements[i].value) + '&';
        }

        do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}' + keep_stub(true), function (ajax_result) {
            set_inner_html(document.getElementById('preview_raw'), escape_html(ajax_result.responseText));
            set_inner_html(document.getElementById('preview_html'), ajax_result.responseText);
        }, request);

        do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}?comcode=1' + keep_stub(), function (ajax_result) {
            set_inner_html(document.getElementById('preview_comcode'), ajax_result.responseText);
        }, request);

        return false;
    }
})(window.jQuery || window.Zepto, Composr);

