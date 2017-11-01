(function ($cms) {
    'use strict';

    $cms.views.ZoneEditorScreen = ZoneEditorScreen;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function ZoneEditorScreen(params) {
        ZoneEditorScreen.base(this, 'constructor', arguments);
    }

    $cms.inherits(ZoneEditorScreen, $cms.View, /**@lends ZoneEditorScreen#*/{
        events: function () {
            return {
                'submit .js-form-ze-save': 'submit',
                'click .js-btn-fetch-and-submit': 'fetchAndSubmit'
            };
        },

        submit: function (e, form) {
            if ('{$VALUE_OPTION;,disable_modsecurity_workaround}' !== '1') {
                e.preventDefault();
                $cms.form.modSecurityWorkaround(form);
            }
        },

        fetchAndSubmit: function (e, btn) {
            var params = this.params;

            setEditedPanel('panel_left');
            setEditedPanel('panel_right');
            setEditedPanel('panel_top');
            setEditedPanel('panel_bottom');
            setEditedPanel(params.defaultZonePageName);

            var form = $cms.dom.$id('middle_fields');
            var editFieldStore = $cms.dom.$id('edit_field_store');
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
                editFieldStore.appendChild(store);
            }

            $cms.dom.submit(btn.form);
        }
    });

    $cms.views.ZoneEditorPanel = ZoneEditorPanel;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function ZoneEditorPanel(params) {
        ZoneEditorPanel.base(this, 'constructor', arguments);

        this.id = params.id;

        if (params.preview !== undefined) {
            $cms.form.disablePreviewScripts($cms.dom.$('#view_' + params.id));
        }

        if (params.comcode && params.class.includes('wysiwyg')) {
            if ((window.wysiwygOn) && (wysiwygOn())) {
                $cms.dom.$('#edit_' + params.id + '_textarea').readOnly = true;
            }
        }
    }

    $cms.inherits(ZoneEditorPanel, $cms.View, /**@lends ZoneEditorPanel#*/{
        events: function () {
            return {
                'click .js-click-select-tab': 'selectTab',
                'submit .js-form-zone-editor-comcode': 'submitComcode',
                'click .js-a-toggle-wysiwyg': 'toggleWysiwyg',
                'change .js-ta-ze-comcode, .js-sel-zones-draw, .js-inp-zones-draw': 'setEditedPanel'
            };
        },

        selectTab: function (e, target) {
            var id = this.params.id,
                tab = target.dataset.jsTab;

            selectZeTab(id, tab);

            if (tab === 'view') {
                reloadPreview(id);
            }

            function selectZeTab(id, tab) {
                var tabs = ['view', 'edit', 'info', 'settings'];
                var i, j, element, elementh, selects;

                for (i = 0; i < tabs.length; i++) {
                    element = $cms.dom.$id(tabs[i] + '_' + id);
                    elementh = $cms.dom.$id(tabs[i] + '_tab_' + id);
                    if (element) {
                        element.style.display = (tabs[i] === tab) ? 'block' : 'none';
                        if ((tabs[i] == tab) && (tab == 'edit')) {
                            if ($cms.form.isWysiwygField($cms.dom.$id('edit_' + id + '_textarea'))) {
                                // LEGACY Fix for Firefox
                                if (window.wysiwygEditors['edit_' + id + '_textarea'].document !== undefined) {
                                    if (window.wysiwygEditors['edit_' + id + '_textarea'].document.getBody().$) {
                                        window.wysiwygEditors['edit_' + id + '_textarea'].document.getBody().$.contentEditable = 'false';
                                        window.wysiwygEditors['edit_' + id + '_textarea'].document.getBody().$.contentEditable = 'true';
                                    }
                                }
                            }
                        }
                        if (tabs[i] === tab) {
                            $cms.dom.fadeIn(element);

                            elementh.classList.add('tab_active');
                        } else {
                            elementh.classList.remove('tab_active');
                        }
                    }
                }
            }

            function reloadPreview(id) {
                var element = $cms.dom.$id('view_' + id);

                var editElement = $cms.dom.$id('edit_' + id + '_textarea');
                if (!editElement) {
                    return; // Nothing interatively edited
                }

                $cms.dom.html(element, '<div aria-busy="true" class="ajax_loading vertical_alignment"><img src="' + $cms.img('{$IMG;,loading}') + '" /> <span>{!LOADING;^}</span></div>');

                var loadingPreviewOf = id;

                var data = '';
                data += window.getTextbox(editElement);
                var url = '{$FIND_SCRIPT_NOHTTP;,comcode_convert}?fix_bad_html=1&css=1&javascript=1&from_html=0&is_semihtml=' + ($cms.form.isWysiwygField(editElement) ? '1' : '0') + '&panel=' + (((id == 'panel_left') || (id == 'panel_right')) ? '1' : '0') + $cms.$KEEP();
                var post = ($cms.form.isWysiwygField(editElement) ? 'data__is_wysiwyg=1&' : '') + 'data=' + encodeURIComponent(data);
                post = $cms.form.modSecurityWorkaroundAjax(post);
                $cms.doAjaxRequest(url, reloadedPreview, post);

                function reloadedPreview(responseXml) {
                    var ajaxResult = responseXml && responseXml.querySelector('result');
                    
                    if (!loadingPreviewOf) {
                        return;
                    }

                    var element = $cms.dom.$id('view_' + loadingPreviewOf);
                    $cms.dom.html(element, ajaxResult.textContent.replace(/^((\s)|(\<br\s*\>)|(&nbsp;))*/, '').replace(/((\s)|(\<br\s*\>)|(&nbsp;))*$/, ''));
                    $cms.form.disablePreviewScripts(element);
                }
            }
        },

        submitComcode: function (e, target) {
            if ('{$VALUE_OPTION;,disable_modsecurity_workaround}' !== '1') {
                e.preventDefault();
                $cms.form.modSecurityWorkaround(form);
            }
        },

        toggleWysiwyg: function () {
            toggleWysiwyg('edit_' + this.params.id + '_textarea');
        },

        setEditedPanel: function (e, field) {
            var params = this.params,
                editor = $cms.dom.$id('edit_tab_' + params.id);

            setEditedPanel(params.id);

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
        var form = document.getElementById('main_form'),
            submitBtn = document.getElementById('submit_button'),
            validValue;
        
        form.addEventListener('submit', function submitCheck(e) {
            var value = form.elements['zone'].value;
            
            if (value === validValue) {
                return;
            }
            
            submitBtn.disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_zone&name=' + encodeURIComponent(value);
            e.preventDefault();
            
            $cms.form.doAjaxFieldTest(url).then(function (valid) {
                if (valid) {
                    validValue = value;
                    $cms.dom.submit(form);
                } else {
                    submitBtn.disabled = false;
                }
            });
        });
    };

    function setEditedPanel(id) {
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
            store.value = getTextbox(el);
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
