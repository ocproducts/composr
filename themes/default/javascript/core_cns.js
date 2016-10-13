(function ($cms) {

    $cms.templates.cnsMemberProfileScreen = function cnsMemberProfileScreen(options) {
        var tabFunc = 'load_tab__' + options.tabCode;

        if (options.tabContent === undefined) {
            window[tabFunc] = function (automated) {
                if (automated) {
                    try {
                        window.scrollTo(0, 0);
                    } catch (e) {}
                }

                // Self destruct loader after this first run
                window[tabFunc] = $cms.noop;

                load_snippet('profile_tab&tab=' + options.tabCode + '&member_id=' + options.memberId + window.location.search.replace('?', '&'), null, function (result) {
                    $cms.dom.html(document.getElementById('g_' + options.tabCode), result.responseText);

                    find_url_tab();
                });
            }
        }

        var tabs = +options.tabs || 0;

        if (tabs > 1) {
            // we do not want it to scroll down
            var old_hash = window.location.hash;
            window.location.hash = '#';
            find_url_tab(old_hash);
        }
    };

}(window.$cms));