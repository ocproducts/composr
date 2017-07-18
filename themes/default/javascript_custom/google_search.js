(function ($cms) {
    'use strict';

    $cms.templates.blockSideGoogleSearch = function blockSideGoogleSearch(params) {
        var cx = strVal(params.id);

        $cms.requireJavascript([
            'https://cse.google.com/cse.js?cx=' + cx,
            'https://www.google.com/jsapi'
        ]).then(function () {
            if (document.getElementById('cse')) {// On results page
                var noSearchEntered = document.getElementById('no_search_entered');
                if (noSearchEntered) {
                    noSearchEntered.parentNode.removeChild(noSearchEntered);
                }
            }

            window.google.load('search', '1', {language: 'en'});
            window.google.setOnLoadCallback(function () {
                var cseForm = document.getElementById('cse-search-form');
                cseForm.querySelector('.gsc-search-box').innerHTML += '{$INSERT_SPAMMER_BLACKHOLE;^}';
            });
        });
    };
}(window.$cms));
