(function ($cms) {
    'use strict';

    $cms.templates.blockSideGoogleSearch = function blockSideGoogleSearch(params) {
        var search = strVal(params.search),
            spammerBlackhole = strVal(params.spammerBlackhole);

        $cms.requireJavascript('https://www.google.com/jsapi').then(function () {
            google.load('search', '1', { language: 'en' });
            google.setOnLoadCallback(function() {
                var customSearchControl = new google.search.CustomSearchControl('');
                customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
                var options = new google.search.DrawOptions();
                options.setSearchFormRoot('cse-search-form');
                customSearchControl.draw('cse', options);

                var cse_form = document.getElementById('cse-search-form'),
                    gsc_search_box = cse_form.querySelector('.gsc-search-box'),
                    gsc_search_button = cse_form.querySelector('.gsc-search-button');

                if (!document.getElementById('cse')) {// Not on the results page, so we need to direct the search to it
                    gsc_search_box.action = '{$PAGE_LINK;,_SEARCH:{PAGE_NAME}}';
                    gsc_search_box.method = 'post';
                    gsc_search_box.innerHTML += spammerBlackhole;
                    gsc_search_button.onclick = function () {
                        gsc_search_box.submit();
                    };
                } else {// On result page, so normal operation
                    gsc_search_button.onclick = function () {
                        var no_search_entered = document.getElementById('no_search_entered');
                        if (no_search_entered) {
                            no_search_entered.parentNode.removeChild(no_search_entered);
                        }
                    };

                    if (search !== '') {
                        customSearchControl.execute(search); // Relay through search from prior page
                    }
                }
            }, true);
        });
    };
}(window.$cms));