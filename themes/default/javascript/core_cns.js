(function ($, Composr) {
    Composr.behaviors.coreCns = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_cns');
            }
        }
    };

    Composr.templates.coreCns = {
        cnsMemberProfileScreen: function cnsMemberProfileScreen(options) {
            var tabFunc = 'load_tab__' + options.tabCode;

            if (typeof options.tabContent === 'undefined') {
                window[tabFunc] = function (automated) {
                    if ((typeof window[tabFunc].done !== 'undefined') && window[tabFunc].done) {
                        return;
                    }

                    if (automated) {
                        try {
                            window.scrollTo(0, 0);
                        } catch (e) {
                        }
                    }

                    // Self destruct loader after this first run
                    window[tabFunc].done = true;

                    load_snippet('profile_tab&tab=' + options.tabCode + '&member_id=' + options.memberId + window.location.search.replace('?', '&'), null, function (result) {
                        Composr.dom.html(document.getElementById('g_' + options.tabCode), result.responseText);

                        find_url_tab();
                    });
                }
            }

            if (Number(options.tabs) > 1) {
                // we do not want it to scroll down
                var old_hash = window.location.hash;
                window.location.hash = '#';
                find_url_tab(old_hash);
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);