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

                var cseForm = document.getElementById('cse-search-form'),
                    gscSearchBox = cseForm.querySelector('.gsc-search-box'),
                    gscSearchButton = cseForm.querySelector('.gsc-search-button');

                if (!document.getElementById('cse')) {// Not on the results page, so we need to direct the search to it
                    gscSearchBox.action = '{$PAGE_LINK;,_SEARCH:{PAGE_NAME}}';
                    gscSearchBox.method = 'post';
                    gscSearchBox.innerHTML += spammerBlackhole;
                    gscSearchButton.onclick = function () {
                        gscSearchBox.submit();
                    };
                } else {// On result page, so normal operation
                    gscSearchButton.onclick = function () {
                        var noSearchEntered = document.getElementById('no_search_entered');
                        if (noSearchEntered) {
                            noSearchEntered.parentNode.removeChild(noSearchEntered);
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