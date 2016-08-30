(function ($, Composr) {
    Composr.behaviors.coreMenus = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_menus');
            }
        }
    };

    var Menu = Composr.View.extend({
        initialize: function (viewOptions, options) {
            Composr.View.prototype.initialize.apply(this, arguments);
        }
    });

    // Templates:
    // MENU_dropdown
    // - MENU_BRANCH_dropdown
    var DropdownMenu = Menu.extend({
        initialize: function (viewOptions, options) {
            Menu.prototype.initialize.apply(this, arguments);

            this.menuId = 'r_' + Composr.filters.identifier(options.menu) + '_d';

            if (Composr.isTruthy(options.javascriptHighlighting)) {
                menu_active_selection(this.menuId);
            }
        },

        events: {
            'mouseout .js-ul-menu': 'desetActiveMenu'
        },

        desetActiveMenu: function () {
            deset_active_menu();
        }
    });

    Composr.views.coreMenus = {
        Menu: Menu,
        DropdownMenu: DropdownMenu
    };

    Composr.templates.coreMenus = {
        menuEditorScreen: function menuEditorScreen(options) {
            window.all_menus = options.allMenus;

            document.getElementById('url').ondblclick = cb;
            document.getElementById('caption_long').ondblclick = cb;
            document.getElementById('page_only').ondblclick = cb;

            window.current_selection = '';
            window.sitemap = new tree_list('tree_list', 'data/sitemap.php?get_perms=0' + Composr.$KEEP +'&start_links=1', null, '', false, null, false, true);

            function cb() {
                var e = document.getElementById('menu_editor_wrap');
                if (e.className.indexOf(' docked') == -1) smooth_scroll(find_pos_y(document.getElementById('caption_' + window.current_selection)));
            }
        },

        menuEditorBranchWrap: function (options) {
            var sIndex = Number(options.branchType);

            if (Composr.isTruthy(options.clickableSections)) {
                sIndex = sIndex === 0 ? 0 : sIndex - 1;
            }

            document.getElementById('branch_type_' + options.i).selectedIndex = sIndex;
        },

        menuSitemap: function menuSitemap(options, content) {
            generate_menu_sitemap(options.menuSitemapId, content, 0);
        },

        pageLinkChooser: function pageLinkChooser(options) {
            var ajax_url = 'data/sitemap.php?get_perms=0' + Composr.$KEEP + '&start_links=1';

            if (typeof options.pageType !== 'undefined') {
                ajax_url += '&page_type=' + options.pageType;
            }

            new tree_list(options.name, ajax_url, '', '', false, null, false, true);
        }
    };
})(window.jQuery || window.Zepto, Composr);
