(function ($cms) {

    $cms.templates.cnsJoinStep1Screen = function cnsJoinStep1Screen() {
        var container = this;

        $cms.dom.on(container, 'click', '.js-chb-click-toggle-proceed-btn', function (e, checkbox) {
            document.getElementById('proceed_button').disabled = !checkbox.checked;
        });
    };

    $cms.templates.cnsMemberProfileScreen = function cnsMemberProfileScreen(params) {
        var container = this,
            tabFunc = 'load_tab__' + params.tabCode;

        if (params.tabContent === undefined) {
            window[tabFunc] = function (automated) {
                if (automated) {
                    try {
                        window.scrollTo(0, 0);
                    } catch (e) {}
                }

                // Self destruct loader after this first run
                window[tabFunc] = $cms.noop;

                load_snippet('profile_tab&tab=' + params.tabCode + '&member_id=' + params.memberId + window.location.search.replace('?', '&'), null, function (result) {
                    $cms.dom.html(document.getElementById('g_' + params.tabCode), result.responseText);

                    find_url_tab();
                });
            }
        }

        var tabs = +params.tabs || 0;

        if (tabs > 1) {
            // we do not want it to scroll down
            var old_hash = window.location.hash;
            window.location.hash = '#';
            find_url_tab(old_hash);
        }

        $cms.dom.on(container, 'click', '.js-click-select-tab-g', function (e, clicked) {
            var tab = clicked.dataset.tpTab;
            if (tab) {
                select_tab('g', tab);
            }
        });
    };

}(window.$cms));