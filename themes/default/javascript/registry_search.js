(function ($cms) {
    'use strict';

    $cms.views.SearchFormScreen = SearchFormScreen;

    function SearchFormScreen() {
        SearchFormScreen.base(this, 'constructor', arguments);

        this.primaryFormEl = this.$('js-form-primary-form');
        this.booleanOptionsEl = this.$('.js-el-boolean-options');
    }

    $cms.inherits(SearchFormScreen, $cms.View, {
        events: function () {
            return {
                'keypress .js-keypress-enter-submit-primary-form': 'submitPrimaryForm',
                'keyup .js-keyup-update-ajax-search-list': 'updateAjaxSearchList',
                'keyup .js-keyup-update-author-list': 'updateAuthorList',
                'click .js-click-trigger-resize': 'triggerResize',
                'click .js-checkbox-click-toggle-boolean-options': 'toggleBooleanOptions'
            };
        },
        submitPrimaryForm: function (e) {
            if ($cms.dom.keyPressed(e, 'Enter')) {
                this.primaryFormEl.submit();
            }
        },
        updateAjaxSearchList: function (e, input) {
            var params = this.params;

            if (params.searchType !== undefined) {
                update_ajax_search_list(input, e, $cms.filter.nl(params.searchType));
            } else {
                update_ajax_search_list(input, e);
            }
        },
        updateAuthorList: function (e, target) {
            update_ajax_author_list(target, e);
        },
        triggerResize: function () {
            trigger_resize();
        },
        toggleBooleanOptions: function (e, checkbox) {
            $cms.dom.toggle(this.booleanOptionsEl, checkbox.checked);
        }
    });

}(window.$cms));