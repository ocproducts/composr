(function ($, Composr) {
    Composr.templates.coreMenus = {
        pageLinkChooser: function pageLinkChooser(options) {
            var ajax_url = 'data/sitemap.php?get_perms=0' + Composr.$KEEP + '&start_links=1';

            if (typeof options.pageType !== 'undefined') {
                ajax_url += '&page_type=' + options.pageType;
            }

            new tree_list(options.name, ajax_url, '', '', false, null, false, true);
        }
    };

    Composr.behaviors.coreMenus = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_menus');
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
