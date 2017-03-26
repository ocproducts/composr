(function ($cms) {
    'use strict';

    $cms.views.ZoneEditorScreen = ZoneEditorScreen;
    function ZoneEditorScreen(params) {
        ZoneEditorScreen.base(this, 'constructor', arguments);
    }

    $cms.inherits(ZoneEditorScreen, $cms.View, {
        events: {
            'submit .js-form-ze-save': 'submit',
            'click .js-btn-fetch-and-submit': 'fetchAndSubmit'
        },

        submit: function (e, form) {
            $cms.form.modsecurityWorkaround(form);
            e.preventDefault();
        },

        fetchAndSubmit: function (e, btn) {
            var params = this.params;

            set_edited_panel('panel_left');
            set_edited_panel('panel_right');
            set_edited_panel('panel_top');
            set_edited_panel('panel_bottom');
            set_edited_panel(params.defaultZonePageName);

            var form = $cms.dom.$id('middle_fields');
            var edit_field_store = $cms.dom.$id('edit_field_store');
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

            btn.form.submit();
        }
    });

    $cms.views.ZoneEditorPanel = ZoneEditorPanel;
    function ZoneEditorPanel(params) {
        ZoneEditorPanel.base(this, 'constructor', arguments);

        this.id = params.id;

        if (params.preview !== undefined) {
            $cms.form.disablePreviewScripts($cms.dom.$('#view_' + params.id));
        }

        if (params.comcode && params.class.includes('wysiwyg')) {
            if ((window.wysiwyg_on) && (wysiwyg_on())) {
                $cms.dom.$('#edit_' + params.id + '_textarea').readOnly = true;
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
            var id = this.params.id,
                tab = target.dataset.jsTab;

            select_ze_tab(id, tab);

            if (tab === 'view') {
                reload_preview(id);
            }

            function select_ze_tab(id, tab) {
                var tabs = ['view', 'edit', 'info', 'settings'];
                var i, j, element, elementh, selects;

                for (i = 0; i < tabs.length; i++) {
                    element = $cms.dom.$id(tabs[i] + '_' + id);
                    elementh = $cms.dom.$id(tabs[i] + '_tab_' + id);
                    if (element) {
                        element.style.display = (tabs[i] === tab) ? 'block' : 'none';
                        if ((tabs[i] == tab) && (tab == 'edit')) {
                            if ($cms.form.isWysiwygField($cms.dom.$id('edit_' + id + '_textarea'))) {
                                // Fix for Firefox
                                if (window.wysiwyg_editors['edit_' + id + '_textarea'].document !== undefined) {
                                    window.wysiwyg_editors['edit_' + id + '_textarea'].document.getBody().$.contentEditable = 'false';
                                    window.wysiwyg_editors['edit_' + id + '_textarea'].document.getBody().$.contentEditable = 'true';
                                }
                            }
                        }
                        if (tabs[i] === tab) {
                            $cms.dom.clearTransitionAndSetOpacity(element, 0.0);
                            $cms.dom.fadeTransition(element, 100, 30, 4);

                            elementh.classList.add('tab_active');
                        } else {
                            elementh.classList.remove('tab_active');
                        }
                    }
                }
            }

            function reload_preview(id) {
                var element = $cms.dom.$id('view_' + id);

                var edit_element = $cms.dom.$id('edit_' + id + '_textarea');
                if (!edit_element) {
                    return; // Nothing interatively edited
                }

                $cms.dom.html(element, '<div aria-busy="true" class="ajax_loading vertical_alignment"><img src="' + $cms.img('{$IMG;,loading}') + '" /> <span>{!LOADING;^}</span></div>');

                var loading_preview_of = id;

                var data = '';
                data += get_textbox(edit_element);
                var url = '{$FIND_SCRIPT_NOHTTP;,comcode_convert}?fix_bad_html=1&css=1&javascript=1&from_html=0&is_semihtml=' + ($cms.form.isWysiwygField(edit_element) ? '1' : '0') + '&panel=' + (((id == 'panel_left') || (id == 'panel_right')) ? '1' : '0') + $cms.keepStub();
                var post = ($cms.form.isWysiwygField(edit_element) ? 'data__is_wysiwyg=1&' : '') + 'data=' + encodeURIComponent(data);
                post = $cms.form.modsecurityWorkaroundAjax(post);
                $cms.doAjaxRequest(url, reloaded_preview, post);

                function reloaded_preview(ajax_result_frame, ajax_result) {
                    if (!loading_preview_of) {
                        return;
                    }

                    var element = $cms.dom.$id('view_' + loading_preview_of);
                    $cms.dom.html(element, ajax_result.textContent.replace(/^((\s)|(\<br\s*\>)|(&nbsp;))*/, '').replace(/((\s)|(\<br\s*\>)|(&nbsp;))*$/, ''));

                    $cms.form.disablePreviewScripts(element);
                }
            }
        },

        submitComcode: function (e, target) {
            $cms.form.modsecurityWorkaround(target);
            e.preventDefault();
        },

        toggleWysiwyg: function () {
            toggle_wysiwyg('edit_' + this.params.id + '_textarea');
        },

        setEditedPanel: function (e, field) {
            var params = this.params,
                editor = $cms.dom.$id('edit_tab_' + params.id);

            set_edited_panel(params.id);

            if (editor) {
                if (field.localName === 'select') {
                    editor.style.display = (params.currentZone === field.options[field.selectedIndex].value) ? 'block' : 'none';
                } else if (field.localName === 'input') {
                    editor.style.display = (params.currentZone === field.value) ? 'block' : 'none';
                }
            }
        }
    });

    $cms.functions.moduleAdminZonesGetFormFields = function moduleAdminZonesGetFormFields() {
        var zone = document.getElementById('new_zone');
        if (!zone) {
            zone = document.getElementById('zone');
        }
        if (zone) {
            zone.addEventListener('blur', function () {
                var title = document.getElementById('title');
                if (title.value == '') {
                    title.value = zone.value.substr(0, 1).toUpperCase() + zone.value.substring(1, zone.value.length).replace(/\_/g, ' ');
                }
            });
        }
    };

    $cms.functions.moduleAdminZonesAddZone = function moduleAdminZonesAddZone() {
        var form = document.getElementById('main_form');
        form.addEventListener('submit', function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_zone&name=' + encodeURIComponent(form.elements['zone'].value);
            if (!$cms.form.doAjaxFieldTest(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };

    function set_edited_panel(id) {
        var el, store;

        /* The editing box */

        el = $cms.dom.$('teaxtarea#edit_' + id + '_textarea');
        if (el) {
            store = $cms.dom.$('#store_' + id);
            if (!store) {
                store = document.createElement('textarea');
                store.name = el.name;
                store.id = 'store_' + id;
                $cms.dom.$('#edit_field_store').appendChild(store);
            }
            store.value = get_textbox(el);
        }

        /* The WYSIWYG setting (not the actual HTML text value of the editor, the setting of whether WYSIWYG was used or not) */

        el = $cms.dom.$id('edit_' + id + '_textarea__is_wysiwyg');
        if (el) {
            store = $cms.dom.$id('wysiwyg_store_' + id);
            if (!store) {
                store = document.createElement('textarea');
                store.id = 'wysiwyg_store_' + id;
                store.name = el.name;
                $cms.dom.$id('edit_field_store').appendChild(store);
            }
            store.value = el.value;
        }

        /* The redirect setting */

        el = $cms.dom.$('select#redirect_' + id);
        if (el) {
            store = $cms.dom.$id('redirects_store_' + id);
            if (!store) {
                store = document.createElement('textarea');
                store.name = el.name;
                store.id = 'redirects_store_' + id;
                $cms.dom.$id('edit_field_store').appendChild(store);
            }
            store.value = el.options[el.selectedIndex].value;
        }
    }
}(window.$cms));