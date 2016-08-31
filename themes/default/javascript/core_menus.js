(function ($, Composr) {
    Composr.behaviors.coreMenus = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_menus');
            }
        }
    };

    var Menu = Composr.View.extend({
        menuId: '',
        initialize: function (v, options) {
            Composr.View.prototype.initialize.apply(this, arguments);

            this.menuId = 'r_' + Composr.filters.id(options.menu) + '_d';

            if (Composr.isTruthy(options.javascriptHighlighting)) {
                menuActiveSelection(this.menuId);
            }
        }
    });

    // Templates:
    // MENU_dropdown
    // - MENU_BRANCH_dropdown
    var DropdownMenu = Menu.extend({
        initialize: function (v, options) {
            Menu.prototype.initialize.apply(this, arguments);
        },

        events: {
            'mouseout .js-ul-menu-items': 'desetActiveMenu'
        },

        desetActiveMenu: function () {
            deset_active_menu();
        }
    });

    var PopupMenu = Menu.extend({
        initialize: function (v, options) {
            Menu.prototype.initialize.apply(this, arguments);
        },

        events: {
            'mouseout .js-ul-menu-items': 'desetActiveMenu'
        },

        desetActiveMenu: function () {
            deset_active_menu();
        }
    });

    Composr.views.coreMenus = {
        Menu: Menu,
        DropdownMenu: DropdownMenu,
        PopupMenu: PopupMenu
    };

    Composr.templates.coreMenus = {
        menuEditorScreen: function menuEditorScreen(options) {
            window.all_menus = options.allMenus;

            document.getElementById('url').ondblclick = cb;
            document.getElementById('caption_long').ondblclick = cb;
            document.getElementById('page_only').ondblclick = cb;

            window.current_selection = '';
            window.sitemap = new tree_list('tree_list', 'data/sitemap.php?get_perms=0' + Composr.$KEEP + '&start_links=1', null, '', false, null, false, true);

            function cb() {
                var el = document.getElementById('menu_editor_wrap');
                if (!el.classList.contains('docked')) {
                    smooth_scroll(find_pos_y(document.getElementById('caption_' + window.current_selection)));
                }
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

    function menuActiveSelection(menu_id) {
        var menu_element = document.getElementById(menu_id);
        var possibilities = [], is_selected, url;
        if (menu_element.nodeName.toLowerCase() == 'select') {
            for (var i = 0; i < menu_element.options.length; i++) {
                url = menu_element.options[i].value;
                is_selected = menuItemIsSelected(url);
                if (is_selected !== null) {
                    possibilities.push({
                        url: url,
                        score: is_selected,
                        element: menu_element.options[i]
                    });
                }
            }

            if (possibilities.length > 0) {
                possibilities.sort(function (a, b) {
                    return a.score - b.score
                });

                var min_score = possibilities[0].score;
                for (var i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != min_score) break;
                    possibilities[i].element.selected = true;
                }
            }
        } else {
            var menu_items = menu_element.querySelectorAll('.non_current'), a;
            for (var i = 0; i < menu_items.length; i++) {
                a = null;
                for (var j = 0; j < menu_items[i].childNodes.length; j++) {
                    if (menu_items[i].childNodes[j].nodeName.toLowerCase() == 'a') {
                        a = menu_items[i].childNodes[j];
                    }
                }
                if (a == null) {
                    continue;
                }

                url = a.href;
                is_selected = menuItemIsSelected(url);
                if (is_selected !== null) {
                    possibilities.push({
                        url: url,
                        score: is_selected,
                        element: menu_items[i]
                    });
                }
            }

            if (possibilities.length > 0) {
                possibilities.sort(function (a, b) {
                    return a.score - b.score
                })

                var min_score = possibilities[0].score;
                for (var i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != min_score) break;
                    possibilities[i].element.className = possibilities[i].element.className.replace('non_current', 'current');
                }
            }
        }
    }

    function menuItemIsSelected(url) {
        var current_url = window.location.toString();
        if (current_url == url) return 0;
        var global_breadcrumbs = document.getElementById('global_breadcrumbs');
        if (global_breadcrumbs) {
            var links = global_breadcrumbs.getElementsByTagName('a');
            for (var i = 0; i < links.length; i++) {
                if (url == links[links.length - 1 - i].href) {
                    return i + 1;
                }
            }
        }

        return null;
    }
})(window.jQuery || window.Zepto, Composr);
