(function ($cms) {
    $cms.views.Menu = Menu;
    $cms.views.DropdownMenu = DropdownMenu;
    $cms.views.PopupMenu = PopupMenu;
    $cms.views.PopupMenuBranch = PopupMenuBranch;
    $cms.views.TreeMenu = TreeMenu;
    $cms.views.MobileMenu = MobileMenu;
    $cms.views.SelectMenu = SelectMenu;

    function Menu() {
        Menu.base(this, 'constructor', arguments);

        this.menuId = this.params.menuId;

        if (this.params.javascriptHighlighting && this.menuId) {
            menuActiveSelection(this.menuId);
        }
    }

    $cms.inherits(Menu, $cms.View, {
        menuId: null
    });

    // Templates:
    // MENU_dropdown.tpl
    // - MENU_BRANCH_dropdown.tpl
    function DropdownMenu() {
        DropdownMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(DropdownMenu, Menu, {
        events: {
            'click .js-click-unset-active-menu': 'unsetActiveMenu',
            'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu'
        },

        unsetActiveMenu: function () {
            window.active_menu = null;
            recreate_clean_timeout();
        }
    });

    function PopupMenu() {
        PopupMenu.base(this, 'constructor', arguments);

        this.menuId = this.params.menuId;
        if (this.params.javascriptHighlighting && this.menuId) {
            menuActiveSelection(this.menuId);
        }
    }

    $cms.inherits(PopupMenu, Menu, {
        menuId: null,
        events: {
            'click .js-click-unset-active-menu': 'unsetActiveMenu',
            'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu'
        },

        unsetActiveMenu: function () {
            window.active_menu = null;

            recreate_clean_timeout();
        }
    });

    function PopupMenuBranch() {
        PopupMenuBranch.base(this, 'constructor', arguments);

        this.rand = this.params.rand;
        this.menu = $cms.filter.id(this.params.menu);
        this.popup = this.menu + '_pexpand_' + this.rand;
    }

    $cms.inherits(PopupMenuBranch, $cms.View, {
        rand: null,
        menu: null,
        popup: null,
        events: {
            'focus .js-focus-pop-up-menu': 'popUpMenu',
            'mousemove .js-mousemove-pop-up-menu': 'popUpMenu',
            'mouseover .js-mouseover-set-active-menu': 'setActiveMenu'
        },
        popUpMenu: function () {
            pop_up_menu(this.popup, null, this.menu + '_p');
        },
        setActiveMenu: function () {
            if (!window.active_menu) {
                set_active_menu(this.popup, this.menu + '_p');
            }
        }
    });

    function TreeMenu() {
        TreeMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(TreeMenu, Menu, {
        events: {
            'click [data-menu-tree-toggle]': 'toggleMenu'
        },

        toggleMenu: function (e, target) {
            var menuId = target.dataset.menuTreeToggle;

            $cms.toggleableTray($cms.dom.id(menuId));
        }
    });

    // Templates:
    // MENU_mobile.tpl
    // - MENU_BRANCH_mobile.tpl
    function MobileMenu() {
        MobileMenu.base(this, 'constructor', arguments);
        this.menuContentEl = this.$('.js-el-menu-content');
    }

    $cms.inherits(MobileMenu, Menu, {
        events: {
            'click .js-click-toggle-content': 'toggleContent',
            'click .js-click-toggle-sub-menu': 'toggleSubMenu'
        },
        toggleContent: function (e) {
            e.preventDefault();
            $cms.dom.toggle(this.menuContentEl);
        },
        toggleSubMenu: function (e, link) {
            var rand = link.dataset.vwRand, href,
                subEl = this.$('#' + this.menuId + '_pexpand_' + rand);

            if ($cms.dom.css(subEl, 'display') === 'none') {
                subEl.style.display = $cms.dom.initial(subEl, 'display');
            } else {
                href = link.getAttribute('href');
                // Second click goes to it
                if (href && !href.startsWith('#')) {
                    return;
                }
                subEl.style.display = 'none';
            }

            e.preventDefault();
        }
    });

    function SelectMenu() {
        SelectMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(SelectMenu, Menu, {
        events: {
            'change .js-change-redirect-to-value': 'redirect'
        },
        redirect: function (e, changed) {
            if (changed.value) {
                window.location.href = changed.value;
            }
        }
    });

    $cms.templates.menuEditorScreen = function (params) {
        var container = this,
            menuEditorWrapEl = $cms.dom.$(container, '.js-el-menu-editor-wrap');

        window.all_menus = params.allMenus;

        $cms.dom.$('#url').ondblclick = doubleClick;
        $cms.dom.$('#caption_long').ondblclick = doubleClick;
        $cms.dom.$('#page_only').ondblclick = doubleClick;

        window.current_selection = '';
        window.sitemap = $cms.createTreeList('tree_list', 'data/sitemap.php?get_perms=0' + $cms.$KEEP + '&start_links=1', null, '', false, null, false, true);

        function doubleClick() {
            if (!menuEditorWrapEl.classList.contains('docked')) {
                smooth_scroll(find_pos_y(document.getElementById('caption_' + window.current_selection)));
            }
        }

        $cms.dom.on(container, 'click', '.js-click-menu-editor-add-new-page', function () {
            menu_editor_add_new_page();
        });

        $cms.dom.on(container, 'submit', '.js-submit-modsecurity-workaround', function (e, form) {
            modsecurity_workaround(form);
        });

        $cms.dom.on(container, 'change', '.js-input-change-update-selection', function (e, input) {
            var el = $cms.dom.$('#url_' + window.current_selection);
            if (!el) {
                return;
            }
            el.value = input.value;
            el = $cms.dom.$('#edit_form').elements['url'];
            el.value = input.value;
            el = $cms.dom.$('#edit_form').elements['caption_' + window.current_selection];

            if ((el.value == '') && input.selected_title) {
                el.value = input.selected_title.replace(/^.*:\s*/, '');
            }
        });

        $cms.dom.on(container, 'click', '.js-click-check-menu', function (e, button) {
            if (!check_menu()) {
                e.preventDefault();
                return;
            }

            $cms.ui.disableButton(button);
        });


        $cms.dom.on(container, 'click', '.js-img-click-toggle-docked-field-editing', toggleDockedFieldEditing);
        $cms.dom.on(container, 'keypress', '.js-img-keypress-toggle-docked-field-editing', toggleDockedFieldEditing);

        function toggleDockedFieldEditing(e, img) {
            if (!menuEditorWrapEl.classList.contains('docked')) {
                menuEditorWrapEl.classList.add('docked');
                img.src = '{$IMG;*,1x/arrow_box_hover}';
                if (img.srcset !== undefined) {
                    img.srcset = '{$IMG;*,2x/arrow_box_hover} 2x';
                }
            } else {
                menuEditorWrapEl.classList.remove('docked');
                img.src = '{$IMG;*,1x/arrow_box}';
                if (img.srcset !== undefined) {
                    img.srcset = '{$IMG;*,2x/arrow_box} 2x';
                }
            }
        }
    };

    $cms.extend($cms.templates, {
        menuEditorBranchWrap: function (params) {
            var container = this,
                sIndex = +params.branchType || 0;

            if (params.clickableSections) {
                sIndex = (sIndex === 0) ? 0 : (sIndex - 1);
            }

            document.getElementById('branch_type_' + params.i).selectedIndex = sIndex;

            $cms.dom.on(container, 'click', '.js-click-delete-menu-branch', function (e, clicked) {
                delete_menu_branch(clicked);
            });


            function delete_menu_branch(ob) {
                var id = ob.id.substring(4, ob.id.length);

                if (((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION.js_overlays) || (ob.form.elements['branch_type_' + id] != 'page')) {
                    var choices = { buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}', menu___generic_admin__delete: '{!DELETE;^}', buttons__move: '{!menus:MOVETO_MENU;^}' };
                    generate_question_ui(
                        '{!CONFIRM_DELETE_LINK_NICE;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                        choices,
                        '{!menus:DELETE_MENU_ITEM;^}',
                        null,
                        function (result) {
                            if (result.toLowerCase() == '{!DELETE;^}'.toLowerCase()) {
                                delete_branch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                            } else if (result.toLowerCase() == '{!menus:MOVETO_MENU;^}'.toLowerCase()) {
                                var choices = {buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}'};
                                for (var i = 0; i < window.all_menus.length; i++) {
                                    choices['buttons__choose___' + i] = window.all_menus[i];
                                }
                                generate_question_ui(
                                    '{!menus:CONFIRM_MOVE_LINK_NICE;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                                    choices,
                                    '{!menus:MOVE_MENU_ITEM;^}',
                                    null,
                                    function (result) {
                                        if (result.toLowerCase() != '{!INPUTSYSTEM_CANCEL;^}'.toLowerCase()) {
                                            var post = '', name, value;
                                            for (var i = 0; i < ob.form.elements.length; i++) {
                                                name = ob.form.elements[i].name;
                                                if (name.substr(name.length - (('_' + id).length)) == '_' + id) {
                                                    if (ob.localName == 'select') {
                                                        value = ob.form.elements[i].value;
                                                        window.myValue = ob.options[ob.selectedIndex].value;
                                                    } else {
                                                        if ((ob.type.toLowerCase() == 'checkbox') && (!ob.checked)) continue;

                                                        value = ob.form.elements[i].value;
                                                    }
                                                    if (post != '') post += '&';
                                                    post += name + '=' + encodeURIComponent(value);
                                                }
                                            }
                                            do_ajax_request('{$FIND_SCRIPT_NOHTTP;,menu_management}' + '?id=' + encodeURIComponent(id) + '&menu=' + encodeURIComponent(result) + keep_stub(), null, post);
                                            delete_branch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                                        }
                                    }
                                );
                            }
                        }
                    );
                } else {
                    window.fauxmodal_confirm(
                        '{!CONFIRM_DELETE_LINK;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                        function (result) {
                            if (result)
                                delete_branch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                        }
                    );
                }
            }
        },

        menuSitemap: function (params) {
            generate_menu_sitemap(params.menuSitemapId, params.content);
        },

        pageLinkChooser: function pageLinkChooser(params) {
            var ajax_url = 'data/sitemap.php?get_perms=0' + $cms.$KEEP + '&start_links=1';

            if (params.pageType !== undefined) {
                ajax_url += '&page_type=' + params.pageType;
            }

            $cms.createTreeList(params.name, ajax_url, '', '', false, null, false, true);
        }
    });

    function menuActiveSelection(menu_id) {
        var menu_element = document.getElementById(menu_id);
        var possibilities = [], is_selected, url;
        if (menu_element.localName === 'select') {
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
                for (var j = 0; j < menu_items[i].children.length; j++) {
                    if (menu_items[i].children[j].localName === 'a') {
                        a = menu_items[i].children[j];
                    }
                }
                if (!a) {
                    continue;
                }

                url = (a.getAttribute('href') == '') ? '' : a.href;
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
                });

                var min_score = possibilities[0].score;
                for (var i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != min_score) {
                        break;
                    }
                    possibilities[i].element.classList.remove('non_current');
                    possibilities[i].element.classList.add('current');
                }
            }
        }
    }

    function menuItemIsSelected(url) {
        if (url == '') {
            return null;
        }

        var current_url = window.location.href;
        if (current_url === url) {
            return 0;
        }
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


    window.menu_hold_time = 500;
    window.active_menu = null;
    window.last_active_menu = null;

    var clean_menus_timeout,
        last_active_menu;

    function set_active_menu(id, menu) {
        window.active_menu = id;
        if (menu != null) {
            last_active_menu = menu;
        }
    }

    function recreate_clean_timeout() {
        if (clean_menus_timeout) {
            window.clearTimeout(clean_menus_timeout);
        }
        clean_menus_timeout = window.setTimeout(clean_menus, window.menu_hold_time);

        function clean_menus() {
            clean_menus_timeout = null;

            var m = document.getElementById('r_' + last_active_menu);
            if (!m) {
                return;
            }
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
                    while (t.id != 'r_' + last_active_menu);
                }
                if (hideable) {
                    tags[i].style.left = '-999px';
                    tags[i].style.display = 'none';
                }
            }
        }
    }

    function pop_up_menu(id, place, menu, event, outside_fixed_width) {
        place || (place = 'right');
        outside_fixed_width = !!outside_fixed_width;

        var el = document.getElementById(id);

        if (clean_menus_timeout) {
            window.clearTimeout(clean_menus_timeout);
        }

        if ($cms.dom.isDisplayed(el)) {
            return false;
        }

        window.active_menu = id;
        last_active_menu = menu;
        clean_menus();

        var l = 0;
        var t = 0;
        var p = el.parentNode;

        // Our own position computation as we are positioning relatively, as things expand out
        if (window.getComputedStyle(p.parentNode).getPropertyValue('position') === 'absolute') {
            l += p.offsetLeft;
            t += p.offsetTop;
        } else {
            while (p) {
                if (p && (window.getComputedStyle(p).getPropertyValue('position') === 'relative')) {
                    break;
                }

                l += p.offsetLeft;
                t += p.offsetTop - sts(p.style.borderTop);
                p = p.offsetParent;

                if (p && (window.getComputedStyle(p).getPropertyValue('position') === 'absolute')) {
                    break;
                }
            }
        }
        if (place == 'below') {
            t += el.parentNode.offsetHeight;
        } else {
            l += el.parentNode.offsetWidth;
        }

        var full_height = get_window_scroll_height(); // Has to be got before e is visible, else results skewed
        el.style.position = 'absolute';
        el.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
        el.style.display = 'block';
        clear_transition_and_set_opacity(el, 0.0);
        fade_transition(el, 100, 30, 8);

        var full_width = (window.scrollX == 0) ? get_window_width() : get_window_scroll_width();

        if ($cms.$CONFIG_OPTION.fixed_width && !outside_fixed_width) {
            var main_website_inner = document.getElementById('main_website_inner');
            if (main_website_inner) {
                full_width = main_website_inner.offsetWidth;
            }
        }

        var e_parent_width = el.parentNode.offsetWidth;
        el.style.minWidth = e_parent_width + 'px';
        var e_parent_height = el.parentNode.offsetHeight;
        var e_width = el.offsetWidth;
        function position_l() {
            var pos_left = l;
            if (place == 'below') {// Top-level of drop-down
                if (pos_left + e_width > full_width) {
                    pos_left += e_parent_width - e_width;
                }
            } else { // NB: For non-below, we can't assume 'left' is absolute, as it is actually relative to parent node which is itself positioned
                if (find_pos_x(el.parentNode, true) + e_width + e_parent_width + 10 > full_width) pos_left -= e_width + e_parent_width;
            }
            el.style.left = pos_left + 'px';
        }
        position_l();
        window.setTimeout(position_l, 0);
        function position_t() {
            var pos_top = t;
            if (pos_top + el.offsetHeight + 10 > full_height) {
                var above_pos_top = pos_top - $cms.dom.contentHeight(el) + e_parent_height - 10;
                if (above_pos_top > 0) pos_top = above_pos_top;
            }
            el.style.top = pos_top + 'px';
        }
        position_t();
        window.setTimeout(position_t, 0);
        el.style.zIndex = 200;

        recreate_clean_timeout();

        if (event) {
            cancel_bubbling(event);
        }

        return false;
    }

    window.set_active_menu = set_active_menu;
    window.pop_up_menu = pop_up_menu;
}(window.$cms));
