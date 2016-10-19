(function ($cms) {
    'use strict';

    $cms.templates.blockTopSearch = function (params) {
        var container = this,
            searchType = $cms.filter.crLf(params.searchType);


        $cms.dom.on(container, 'submit', '.js-submit-check-search-content-element', function (e, form) {
            if (form.elements.content === undefined) {
                $cms.ui.disableFormButtons(form);
                return;
            }

            if (check_field_for_blankness(form.elements.content, e)) {
                $cms.ui.disableFormButtons(form);
                return;
            }

            e.preventDefault();
        });

        $cms.dom.on(container, 'keyup', '.js-input-keyup-update-ajax-search-list', function (e, input) {
            if (searchType) {
                update_ajax_search_list(input, e, searchType);
            } else {
                update_ajax_search_list(input, e);
            }
        });
    };
}(window.$cms));
