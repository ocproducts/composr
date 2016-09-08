(function ($, Composr) {
    Composr.behaviors.coreMenus = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core_menus');
                Composr.initializeTemplates(context, 'core_menus');
            }
        }
    };

    var Menu = Composr.View.extend({
        menuId: '',
        initialize: function (v, options) {
            Composr.View.prototype.initialize.apply(this, arguments);

            this.menuId = options.menuId;

            if (Composr.is(options.javascriptHighlighting) && this.menuId) {
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

    var TreeMenu = Menu.extend({
        initialize: function (v, options) {
            Menu.prototype.initialize.apply(this, arguments);
        },

        events: {
            'click [data-menu-tree-toggle]': 'toggleMenu'
        },

        toggleMenu: function (e) {
            var menuId = e.currentTarget.dataset.menuTreeToggle;
            toggleable_tray(menuId);
        }
    });

    Composr.views.coreMenus = {
        Menu: Menu,
        DropdownMenu: DropdownMenu,
        PopupMenu: PopupMenu,
        TreeMenu: TreeMenu
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

            if (Composr.is(options.clickableSections)) {
                sIndex = sIndex === 0 ? 0 : sIndex - 1;
            }

            document.getElementById('branch_type_' + options.i).selectedIndex = sIndex;
        },

        menuSitemap: function (options, content) {
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

if (window.menu_hold_time === undefined) {
    window.menu_hold_time = 500;
    window.clean_menus_timeout = null;
    window.active_menu = null;
    window.last_active_menu = null;
}

function clean_menus() {
    window.clean_menus_timeout = null;

    var m = document.getElementById('r_' + window.last_active_menu);
    if (!m) return;
    var tags = m.querySelectorAll('.nlevel');
    var e = (window.active_menu == null) ? null : document.getElementById(window.active_menu), t;
    var i, hideable;
    for (i = tags.length - 1; i >= 0; i--) {
        if (tags[i].localName != 'ul' && tags[i].localName != 'div') continue;

        hideable = true;
        if (e) {
            t = e;
            do
            {
                if (tags[i].id == t.id) hideable = false;
                t = t.parentNode.parentNode;
            }
            while (t.id != 'r_' + window.last_active_menu);
        }
        if (hideable) {
            tags[i].style.left = '-999px';
            tags[i].style.display = 'none';
        }
    }
}

function set_active_menu(id, menu) {
    window.active_menu = id;
    if (menu != null) window.last_active_menu = menu;
}

function deset_active_menu() {
    window.active_menu = null;

    recreate_clean_timeout();
}

function recreate_clean_timeout() {
    if (window.clean_menus_timeout) {
        window.clearTimeout(window.clean_menus_timeout);
    }
    window.clean_menus_timeout = window.setTimeout(clean_menus, window.menu_hold_time);
}

function pop_up_menu(id, place, menu, event, outside_fixed_width) {
    if ((typeof place == 'undefined') || (!place)) var place = 'right';
    if (typeof outside_fixed_width == 'undefined') outside_fixed_width = false;

    var e = document.getElementById(id);

    if (window.clean_menus_timeout) {
        window.clearTimeout(window.clean_menus_timeout);
    }

    if (e.style.display == 'block') {
        return false;
    }

    window.active_menu = id;
    window.last_active_menu = menu;
    clean_menus();

    var l = 0;
    var t = 0;
    var p = e.parentNode;

    // Our own position computation as we are positioning relatively, as things expand out
    if (window.getComputedStyle(p.parentNode).getPropertyValue('position') == 'absolute') {
        l += p.offsetLeft;
        t += p.offsetTop;
    } else {
        while (p) {
            if ((p) && (window.getComputedStyle(p).getPropertyValue('position') == 'relative')) break;
            l += p.offsetLeft;
            t += p.offsetTop - sts(p.style.borderTop);
            p = p.offsetParent;
            if ((p) && (window.getComputedStyle(p).getPropertyValue('position') == 'absolute')) break;
        }
    }
    if (place == 'below') {
        t += e.parentNode.offsetHeight;
    } else {
        l += e.parentNode.offsetWidth;
    }

    var full_height = get_window_scroll_height(); // Has to be got before e is visible, else results skewed
    e.style.position = 'absolute';
    e.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
    e.style.display = 'block';
    set_opacity(e, 0.0);
    fade_transition(e, 100, 30, 8);

    var full_width = (window.scrollX == 0) ? get_window_width() : get_window_scroll_width();
    /*{+START,IF,{$CONFIG_OPTION,fixed_width}}*/
    if (!outside_fixed_width) {
        var main_website_inner = document.getElementById('main_website_inner');
        if (main_website_inner) full_width = main_website_inner.offsetWidth;
    }
    /*{+END}*/
    var e_parent_width = e.parentNode.offsetWidth;
    e.style.minWidth = e_parent_width + 'px';
    var e_parent_height = e.parentNode.offsetHeight;
    var e_width = e.offsetWidth;
    var position_l = function () {
        var pos_left = l;
        if (place == 'below') // Top-level of drop-down
        {
            if (pos_left + e_width > full_width) {
                pos_left += e_parent_width - e_width;
            }
        } else { // NB: For non-below, we can't assume 'left' is absolute, as it is actually relative to parent node which is itself positioned
            if (find_pos_x(e.parentNode, true) + e_width + e_parent_width + 10 > full_width) pos_left -= e_width + e_parent_width;
        }
        e.style.left = pos_left + 'px';
    };
    position_l();
    window.setTimeout(position_l, 0);
    var position_t = function () {
        var pos_top = t;
        if (pos_top + e.offsetHeight + 10 > full_height) {
            var above_pos_top = pos_top - Composr.dom.contentHeight(e) + e_parent_height - 10;
            if (above_pos_top > 0) pos_top = above_pos_top;
        }
        e.style.top = pos_top + 'px';
    };
    position_t();
    window.setTimeout(position_t, 0);
    e.style.zIndex = 200;


    recreate_clean_timeout();

    if ((typeof event != 'undefined') && (event)) {
        cancel_bubbling(event);
    }

    return false;
}

