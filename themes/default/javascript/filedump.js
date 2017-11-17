(function ($cms, $util, $dom) {
    'use strict';

    $cms.templates.filedumpEmbedScreen = function filedumpEmbedScreen(params, container) {
        if (params && (params.generated !== undefined)) {
            var el = $dom.$('#generated_comcode');
            try {
                el.focus();
            } catch (e) {}

            el.select();
        }

        $dom.on(container, 'click', '.js-click-input-img-size-select', function (e, input) {
            input.select();
        });
    };

    $cms.templates.filedumpScreen = function filedumpScreen(params, container) {
        if(params.fileLink) {
            $cms.ui.open(params.fileLink, null, 'width=950;height=700', '_top');
        }

        $cms.ui.findUrlTab();

        $dom.on(container, 'submit', '.js-submit-check-filedump-selections', function (e, form) {
            if (checkFiledumpSelections(form) === false) {
                e.preventDefault();
            }
        });

        $dom.on(container, 'click', '.js-click-select-tab-g', function (e, clicked) {
            var tab = clicked.dataset.tpTab;

            if (tab) {
                $cms.ui.selectTab('g', tab);
            }
        });

        function checkFiledumpSelections(form) {
            var action = form.elements['action'].value;

            if (!action) {
                $cms.ui.alert('{!filedump:SELECT_AN_ACTION;^}');
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

            $cms.ui.alert('{!NOTHING_SELECTED_YET;^}');
            return false;
        }
    };
}(window.$cms, window.$util, window.$dom));
