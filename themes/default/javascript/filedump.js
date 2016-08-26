(function ($, Composr) {
    Composr.templates.filedump = {
        filedumpEmbedScreen: function filedumpEmbedScreen(options) {
            if (typeof options.generated !== 'undefined') {
                var e = document.getElementById('generated_comcode');
                try {
                    e.focus();
                } catch (e) {}

                e.select();
            }
        },

        filedumpScreen: function filedumpScreen(options) {
            if (Composr.isTruthy(options.fileLink)) {
                faux_open(options.fileLink, null, 'width=950;height=700', '_top');
            }

            find_url_tab();

            window.check_filedump_selections = function (form) {
                var action = form.elements['action'].options[form.elements['action'].selectedIndex].value;

                if (action == '') {
                    fauxmodal_alert('{!SELECT_AN_ACTION;}');
                    return false;
                }

                if (action == 'edit') return true;

                for (var i = 0; i < form.elements.length; i++) {
                    if ((form.elements[i].name.match(/^select_\d+$/)) && (form.elements[i].checked)) {
                        return true;
                    }
                }

                fauxmodal_alert('{!NOTHING_SELECTED_YET;}');
                return false;
            }
        }
    };

    Composr.behaviors.filedump = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'filedump');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);