(function ($cms) {
    'use strict';

    function SearchFormScreen() {
        SearchFormScreen.base(this, arguments);
    }

    $cms.inherits(SearchFormScreen, $cms.View, {
        events: {
            'keyup .js-keyup-update-author-list': 'updateAuthorList'
        },
        updateAuthorList: function (e, target) {
            update_ajax_author_list(target, e);
        }
    });

    $cms.views.SearchFormScreen = SearchFormScreen;

}(window.$cms));