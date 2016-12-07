(function ($cms) {
    'use strict';

    function BlockMainSearch (params) {
        BlockMainSearch.base(this, 'constructor', arguments);
    }

    $cms.inherits(BlockMainSearch, $cms.View, {
        events: function () {
            return {
                'submit form.js-form-submit-main-search': 'submitMainSearch',
                'keyup .js-keyup-update-ajax-search-list-with-type': 'updateAjaxSearchListWithType',
                'keyup .js-keyup-update-ajax-search-list': 'updateAjaxSearchList'
            };
        },

        submitMainSearch: function (e, form) {
            if ((form.elements.content == null) || check_field_for_blankness(form.elements.content, e)) {
                $cms.ui.disableFormButtons(form);
            } else {
                e.preventDefault();
            }
        },

        updateAjaxSearchListWithType: function (e, input) {
            update_ajax_search_list(input, e, this.params.searchType);
        },

        updateAjaxSearchList: function (e, input) {
            update_ajax_search_list(input, e);
        }
    });

    $cms.views.BlockMainSearch = BlockMainSearch;

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
            update_ajax_search_list(input, e, searchType);
        });
    };

}(window.$cms));
