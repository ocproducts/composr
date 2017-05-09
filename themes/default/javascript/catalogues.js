(function ($cms) {
    'use strict';

    $cms.views.CatalogueAddingScreen = CatalogueAddingScreen;
    function CatalogueAddingScreen(params) {
        CatalogueAddingScreen.base(this, 'constructor', arguments);

        if (params.jsFunctionCalls != null) {
            $cms.executeJsFunctionCalls(params.jsFunctionCalls);
        }

        catalogueFieldChangeWatching();
    }

    $cms.inherits(CatalogueAddingScreen, $cms.View, {
        events: function () {
            return {
                'submit .js-form-catalogue-add': 'submit'
            };
        },

        submit: function (e, form) {
            e.preventDefault();
            $cms.form.modsecurityWorkaround(form);
        }
    });

    $cms.views.CatalogueEditingScreen = CatalogueEditingScreen;
    function CatalogueEditingScreen() {
        CatalogueEditingScreen.base(this, 'constructor', arguments);

        catalogueFieldChangeWatching();
    }

    $cms.inherits(CatalogueEditingScreen, $cms.View, {
        events: function () {
            return {
                'submit .js-form-catalogue-edit': 'submit'
            };
        },

        submit: function (e, form) {
            e.preventDefault();
            $cms.form.modsecurityWorkaround(form);
        }
    });

    $cms.functions.cmsCataloguesImportCatalogue = function cmsCataloguesImportCatalogue() {
        var key_field = document.getElementById('key_field'),
            form = key_field.form;

        key_field.onchange = updateKeySettings;
        updateKeySettings();

        function updateKeySettings() {
            var has_key = (key_field.value != '');

            form.elements.new_handling[0].disabled = !has_key;
            form.elements.new_handling[1].disabled = !has_key;

            form.elements.delete_handling[0].disabled = !has_key;
            form.elements.delete_handling[1].disabled = !has_key;

            form.elements.update_handling[0].disabled = !has_key;
            form.elements.update_handling[1].disabled = !has_key;
            form.elements.update_handling[2].disabled = !has_key;
            form.elements.update_handling[3].disabled = !has_key;
        }
    };

    $cms.functions.moduleCmsCataloguesRunStartAddCatalogue = function moduleCmsCataloguesRunStartAddCatalogue() {
        var form = document.getElementById('new_field_0_name').form;
        form.onsubmit = (function () {
            document.getElementById('submit_button').disabled = true;
            var url = '{$FIND_SCRIPT_NOHTTP;^,snippet}?snippet=exists_catalogue&name=' + encodeURIComponent(form.elements['name'].value);
            if (!$cms.form.doAjaxFieldTest(url)) {
                document.getElementById('submit_button').disabled = false;
                return false;
            }
            document.getElementById('submit_button').disabled = false;
        });
    };

    $cms.functions.moduleCmsCataloguesCat = function moduleCmsCataloguesCat() {
        if (document.getElementById('move_days_lower')) {
            var mt = document.getElementById('move_target');
            var form = mt.form;
            var crf = function () {
                var s = (mt.selectedIndex == 0);
                form.elements['move_days_lower'].disabled = s;
                form.elements['move_days_higher'].disabled = s;
            };
            crf();
            mt.onclick = crf;
        }
    };

    $cms.functions.moduleCmsCataloguesAlt = function moduleCmsCataloguesAlt() {
        var fn = document.getElementById('title');
        if (fn) {
            var form = fn.form;
            fn.onchange = function () {
                if ((form.elements['name']) && (form.elements['name'].value == '')) form.elements['name'].value = fn.value.toLowerCase().replace(/[^{$URL_CONTENT_REGEXP_JS}]/g, '_').replace(/\_+$/, '').substr(0, 80);
            };
        }
    };

    function catalogueFieldChangeWatching() {
        // Find all our ordering fields
        var s = document.getElementsByTagName('select');
        var all_orderers = [];
        for (var i = 0; i < s.length; i++) {
            if (s[i].name.indexOf('order') != -1) {
                all_orderers.push(s[i]);
            }
        }
        // Assign generated change function to all ordering fields (generated so as to avoid JS late binding problem)
        for (var i = 0; i < all_orderers.length; i++) {
            all_orderers[i].onchange = catalogueFieldReindexAround(all_orderers, all_orderers[i]);
        }
    }

    function catalogueFieldReindexAround(all_orderers, ob) {
        return function () {
            var next_index = 0;

            // Sort our all_orderers array by selectedIndex
            for (var i = 0; i < all_orderers.length; i++) {
                for (var j = i + 1; j < all_orderers.length; j++) {
                    if (all_orderers[j].selectedIndex < all_orderers[i].selectedIndex) {
                        var temp = all_orderers[i];
                        all_orderers[i] = all_orderers[j];
                        all_orderers[j] = temp;
                    }
                }
            }

            // Go through all fields, assigning them the order (into selectedIndex). We are reordering *around* the field that has just had it's order set.
            for (var i = 0; i < all_orderers.length; i++) {
                if (next_index == ob.selectedIndex) next_index++;

                if (all_orderers[i] != ob) {
                    all_orderers[i].selectedIndex = next_index;
                    next_index++;
                }
            }
        }
    }

}(window.$cms));
