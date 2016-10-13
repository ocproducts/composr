(function ($cms) {
    'use strict';

    function ZoneEditorScreen(options) {
        $cms.View.apply(this, arguments);
    }

    $cms.inherits(ZoneEditorScreen, $cms.View, {
        events: {
            'submit .js-form-ze-save': 'submit',
            'click .js-btn-fetch-and-submit': 'fetchAndSubmit'
        },

        submit: function (e, form) {
            modsecurity_workaround(form);
            e.preventDefault();
        },

        fetchAndSubmit: function (e, btn) {
            fetch_more_fields();
            btn.form.submit();

            function fetch_more_fields() {
                set_edited_panel('panel_left');
                set_edited_panel('panel_right');
                set_edited_panel('panel_top');
                set_edited_panel('panel_bottom');
                set_edited_panel('{$DEFAULT_ZONE_PAGE_NAME;}');

                var form = document.getElementById('middle_fields');
                var edit_field_store = document.getElementById('edit_field_store');
                var i, store;
                for (i = 0; i < form.elements.length; i++) {
                    store = document.createElement('input');
                    store.setAttribute('type', 'hidden');
                    store.name = form.elements[i].name;
                    if (form.elements[i].getAttribute('type') == 'checkbox') {
                        store.value = form.elements[i].checked ? '1' : '0';
                    } else {
                        store.value = form.elements[i].value;
                    }
                    edit_field_store.appendChild(store);
                }
            }
        }
    });

    function ZoneEditorPanel(options) {
        $cms.View.apply(this, arguments);

        this.id = options.id;

        if (options.preview !== undefined) {
            disable_preview_scripts(document.getElementById('view_' + options.id));
        }

        if (options.comcode && options.class.includes('wysiwyg')) {
            if ((window.wysiwyg_on) && (wysiwyg_on())) {
                document.getElementById('edit_' + options.id + '_textarea').readOnly = true;
            }
        }
    }

    $cms.inherits(ZoneEditorPanel, $cms.View, {
        events: {
            'click .js-click-select-tab': 'selectTab',
            'submit .js-form-zone-editor-comcode': 'submitComcode',
            'click .js-a-toggle-wysiwyg': 'toggleWysiwyg',
            'change .js-ta-ze-comcode, .js-sel-zones-draw, .js-inp-zones-draw': 'setEditedPanel'
        },

        selectTab: function (e, target) {
            var id = this.options.id,
                tab = target.dataset.jsTab;

            select_ze_tab(id, tab);

            if (tab === 'view') {
                reload_preview(id);
            }

            function select_ze_tab(id, tab) {
                var tabs = ['view', 'edit', 'info', 'settings'];
                var i, j, element, elementh, selects;

                for (i = 0; i < tabs.length; i++) {
                    element = document.getElementById(tabs[i] + '_' + id);
                    elementh = document.getElementById(tabs[i] + '_tab_' + id);
                    if (element) {
                        element.style.display = (tabs[i] === tab) ? 'block' : 'none';
                        if ((tabs[i] == tab) && (tab == 'edit')) {
                            if (is_wysiwyg_field(document.getElementById('edit_' + id + '_textarea'))) {
                                // Fix for Firefox
                                if (window.wysiwyg_editors['edit_' + id + '_textarea'].document !== undefined) {
                                    window.wysiwyg_editors['edit_' + id + '_textarea'].document.getBody().$.contentEditable = 'false';
                                    window.wysiwyg_editors['edit_' + id + '_textarea'].document.getBody().$.contentEditable = 'true';
                                }
                            }
                        }
                        if (tabs[i] === tab) {
                            clear_transition_and_set_opacity(element, 0.0);
                            fade_transition(element, 100, 30, 4);

                            elementh.classList.add('tab_active');
                        } else {
                            elementh.classList.remove('tab_active');
                        }
                    }
                }
            }

            function reload_preview(id) {
                var element = document.getElementById('view_' + id);

                var edit_element = document.getElementById('edit_' + id + '_textarea');
                if (!edit_element) {
                    return; // Nothing interatively edited
                }

                $cms.dom.html(element, '<div aria-busy="true" class="ajax_loading vertical_alignment"><img src="' + $cms.img('{$IMG;,loading}') + '" /> <span>{!LOADING;^}</span></div>');

                var loading_preview_of = id;

                var data = '';
                data += get_textbox(edit_element);
                var url = '{$FIND_SCRIPT_NOHTTP;,comcode_convert}?fix_bad_html=1&css=1&javascript=1&from_html=0&is_semihtml=' + (is_wysiwyg_field(edit_element) ? '1' : '0') + '&panel=' + (((id == 'panel_left') || (id == 'panel_right')) ? '1' : '0') + keep_stub();
                var post = (is_wysiwyg_field(edit_element) ? 'data__is_wysiwyg=1&' : '') + 'data=' + encodeURIComponent(data);
                post = modsecurity_workaround_ajax(post);
                do_ajax_request(url, reloaded_preview, post);

                function reloaded_preview(ajax_result_frame, ajax_result) {
                    if (!loading_preview_of) {
                        return;
                    }

                    var element = document.getElementById('view_' + loading_preview_of);
                    $cms.dom.html(element, merge_text_nodes(ajax_result.childNodes).replace(/^((\s)|(\<br\s*\>)|(&nbsp;))*/, '').replace(/((\s)|(\<br\s*\>)|(&nbsp;))*$/, ''));

                    disable_preview_scripts(element);
                }
            }
        },

        submitComcode: function (e, target) {
            modsecurity_workaround(target);
            e.preventDefault();
        },

        toggleWysiwyg: function () {
            toggle_wysiwyg('edit_' + this.options.id + '_textarea');
        },

        setEditedPanel: function (e, field) {
            var opts = this.options,
                editor = document.getElementById('edit_tab_' + opts.id);

            set_edited_panel(opts.id);

            if (editor) {
                if (field.localName === 'select') {
                    editor.style.display = (opts.currentZone === field.options[field.selectedIndex].value) ? 'block' : 'none';
                } else if (field.localName === 'input') {
                    editor.style.display = (opts.currentZone === field.value) ? 'block' : 'none';
                }
            }
        }
    });

    function set_edited_panel(id) {
        var store;

        /* The editing box */

        var object = document.getElementById('edit_' + id + '_textarea');
        if ((object) && (object.nodeName.toLowerCase() == 'textarea')) {
            store = document.getElementById('store_' + id);
            if (!store) {
                store = document.createElement('textarea');
                store.name = object.name;
                store.id = 'store_' + id;
                document.getElementById('edit_field_store').appendChild(store);
            }
            store.value = get_textbox(object);
        }

        /* The WYSIWYG setting (not the actual HTML text value of the editor, the setting of whether WYSIWYG was used or not) */

        var object = document.getElementById('edit_' + id + '_textarea__is_wysiwyg');
        if (object) {
            store = document.getElementById('wysiwyg_store_' + id);
            if (!store) {
                store = document.createElement('textarea');
                store.name = object.name;
                store.id = 'wysiwyg_store_' + id;
                document.getElementById('edit_field_store').appendChild(store);
            }
            store.value = object.value;
        }

        /* The redirect setting */

        var object = document.getElementById('redirect_' + id);
        if ((object) && (object.nodeName.toLowerCase() == 'select')) {
            store = document.getElementById('redirects_store_' + id);
            if (!store) {
                store = document.createElement('textarea');
                store.name = object.name;
                store.id = 'redirects_store_' + id;
                document.getElementById('edit_field_store').appendChild(store);
            }
            store.value = object.options[object.selectedIndex].value;
        }
    }


    $cms.views.ZoneEditorScreen = ZoneEditorScreen;
    $cms.views.ZoneEditorPanel = ZoneEditorPanel;

}(window.$cms));