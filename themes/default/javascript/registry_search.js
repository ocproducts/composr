(function (Composr) {
    'use strict';

    Composr.views.SearchFormScreen = Composr.View.extend({
        events: {
            'keyup .js-keyup-update-author-list': 'updateAuthorList'
        }
    });
}(window.Composr));