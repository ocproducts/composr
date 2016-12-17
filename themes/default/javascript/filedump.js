(function ($cms) {
    'use strict';

    $cms.extend($cms.templates, {
        filedumpEmbedScreen: function filedumpEmbedScreen(params, container) {
            if (params && (params.generated !== undefined)) {
                var el = $cms.dom.$('#generated_comcode');
                try {
                    el.focus();
                } catch (e) {}

                el.select();
            }

            $cms.dom.on(container, 'click', '.js-click-input-img-size-select', function (e, input) {
                input.select();
            });
        },

        filedumpScreen: function filedumpScreen(params) {
            var container = this;

            if(params.fileLink) {
                faux_open(params.fileLink, null, 'width=950;height=700', '_top');
            }

            find_url_tab();

            $cms.dom.on(container, 'click', '.js-submit-check-filedump-selections', function (e, form) {
                if (check_filedump_selections(form) === false) {
                    e.preventDefault();
                }
            });

            $cms.dom.on(container, 'click', '.js-click-select-tab-g', function (e, clicked) {
                var tab = clicked.dataset.tpTab;

                if (tab) {
                    select_tab('g', tab);
                }
            });

            function check_filedump_selections(form) {
                var action = form.elements['action'].value;

                if (!action) {
                    fauxmodal_alert('{!SELECT_AN_ACTION;^}');
                    return false;
                }

                if (action === 'edit') {
                    return;
                }

                for (var i = 0; i < form.elements.length; i++) {
                    if ((form.elements[i].name.match(/^select_\d+$/)) && (form.elements[i].checked)) {
                        return;
                    }
                }

                fauxmodal_alert('{!NOTHING_SELECTED_YET;^}');
                return false;
            }
        }
    });
}(window.$cms));