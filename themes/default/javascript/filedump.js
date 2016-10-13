(function ($cms) {
    'use strict';

    $cms.extend($cms.templates, {
        filedumpEmbedScreen: function filedumpEmbedScreen(options) {
            if (options && (options.generated !== undefined)) {
                var el = document.getElementById('generated_comcode');
                try {
                    el.focus();
                } catch (e) {}

                el.select();
            }
        },

        filedumpScreen: function filedumpScreen(options) {
            if(options.fileLink) {
                faux_open(options.fileLink, null, 'width=950;height=700', '_top');
            }

            find_url_tab();

            window.check_filedump_selections = function (form) {
                var action = form.elements['action'].options[form.elements['action'].selectedIndex].value;

                if (action == '') {
                    fauxmodal_alert('{!SELECT_AN_ACTION;^}');
                    return false;
                }

                if (action == 'edit') return true;

                for (var i = 0; i < form.elements.length; i++) {
                    if ((form.elements[i].name.match(/^select_\d+$/)) && (form.elements[i].checked)) {
                        return true;
                    }
                }

                fauxmodal_alert('{!NOTHING_SELECTED_YET;^}');
                return false;
            }
        }
    });
}(window.$cms));