(function ($cms) {
    'use strict';

    $cms.views.Menu = Menu;
    function Menu(params) {
        Menu.base(this, 'constructor', arguments);

        /** @var {string} */
        this.menu = strVal(params.menu);

        /** @var {string} */
        this.menuId = strVal(params.menuId);

        if (params.javascriptHighlighting) {
            menuActiveSelection(this.menuId);
        }
    }

    $cms.inherits(Menu, $cms.View);

    // Templates:
    // MENU_dropdown.tpl
    // - MENU_BRANCH_dropdown.tpl
    $cms.views.DropdownMenu = DropdownMenu;
    function DropdownMenu(params) {
        DropdownMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(DropdownMenu, Menu, /**@lends DropdownMenu#*/{
        events: function () {
            return {
                'mousemove .js-mousemove-timer-pop-up-menu': 'timerPopUpMenu',
                'mouseout .js-mouseout-clear-pop-up-timer': 'clearPopUpTimer',
                'focus .js-focus-pop-up-menu': 'focusPopUpMenu',
                'mousemove .js-mousemove-pop-up-menu': 'popUpMenu',
                'mouseover .js-mouseover-set-active-menu': 'setActiveMenu',
                'click .js-click-unset-active-menu': 'unsetActiveMenu',
                'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu',
                // For admin/templates/MENU_dropdown.tpl:
                'mousemove .js-mousemove-admin-timer-pop-up-menu': 'adminTimerPopUpMenu',
                'mouseout .js-mouseout-admin-clear-pop-up-timer': 'adminClearPopUpTimer'
            };
        },

        timerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            if (!target.timer) {
                target.timer = window.setTimeout(function () {
                    popUpMenu(menu + '_dexpand_' + rand, 'below', menu + '_d');
                }, 200);
            }
        },

        clearPopUpTimer: function (e, target) {
            if (target.timer) {
                window.clearTimeout(target.timer);
                target.timer = null;
            }
        },

        focusPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            popUpMenu(menu + '_dexpand_' + rand, 'below', menu + '_d', true);
        },

        popUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            popUpMenu(menu + '_dexpand_' + rand, null, menu + '_d');
        },

        setActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                var menu = $cms.filter.id(this.menu);

                if (window.active_menu == null) {
                    setActiveMenu(target.id, menu + '_d');
                }
            }
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.active_menu = null;
                recreate_clean_timeout();
            }
        },

        /* For admin/templates/MENU_dropdown.tpl */
        adminTimerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            window.menu_hold_time = 3000;
            if (!target.dataset.timer) {
                target.dataset.timer = window.setTimeout(function () {
                    var ret = pop_up_menu(menu + '_dexpand_' + rand, 'below', menu + '_d', true);
                    try {
                        document.getElementById('search_content').focus();
                    } catch (ignore) {}
                    return ret;
                }, 200);
            }
        },
        adminClearPopUpTimer: function (e, target) {
            if (target.dataset.timer) {
                window.clearTimeout(target.dataset.timer);
                target.dataset.timer = null;
            }
        }
    });

    $cms.views.PopupMenu = PopupMenu;
    function PopupMenu(params) {
        PopupMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(PopupMenu, Menu, /**@lends PopupMenu.prototype*/{
        events: function () {
            return {
                'click .js-click-unset-active-menu': 'unsetActiveMenu',
                'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu'
            };
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.active_menu = null;
                recreate_clean_timeout();
            }
        }
    });

    $cms.views.PopupMenuBranch = PopupMenuBranch;
    function PopupMenuBranch() {
        PopupMenuBranch.base(this, 'constructor', arguments);

        this.rand = this.params.rand;
        this.menu = $cms.filter.id(this.params.menu);
        this.popup = this.menu + '_pexpand_' + this.rand;
    }

    $cms.inherits(PopupMenuBranch, $cms.View, /**@lends PopupMenuBranch.prototype*/{
        events: function () {
            return {
                'focus .js-focus-pop-up-menu': 'popUpMenu',
                'mousemove .js-mousemove-pop-up-menu': 'popUpMenu',
                'mouseover .js-mouseover-set-active-menu': 'setActiveMenu'
            };
        },
        popUpMenu: function () {
            popUpMenu(this.popup, null, this.menu + '_p');
        },
        setActiveMenu: function () {
            if (!window.active_menu) {
                setActiveMenu(this.popup, this.menu + '_p');
            }
        }
    });

    $cms.views.TreeMenu = TreeMenu;
    function TreeMenu() {
        TreeMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(TreeMenu, Menu, /**@lends TreeMenu.prototype*/{
        events: function () {
            return {
                'click [data-menu-tree-toggle]': 'toggleMenu'
            };
        },

        toggleMenu: function (e, target) {
            var menuId = target.dataset.menuTreeToggle;

            $cms.toggleableTray($cms.dom.$('#' + menuId));
        }
    });

    // Templates:
    // MENU_mobile.tpl
    // - MENU_BRANCH_mobile.tpl
    $cms.views.MobileMenu = MobileMenu;
    function MobileMenu() {
        MobileMenu.base(this, 'constructor', arguments);
        this.menuContentEl = this.$('.js-el-menu-content');
    }

    $cms.inherits(MobileMenu, Menu, /**@lends MobileMenu.prototype*/{
        events: function () {
            return {
                'click .js-click-toggle-content': 'toggleContent',
                'click .js-click-toggle-sub-menu': 'toggleSubMenu'
            };
        },
        toggleContent: function (e) {
            e.preventDefault();
            $cms.dom.toggle(this.menuContentEl);
        },
        toggleSubMenu: function (e, link) {
            var rand = link.dataset.vwRand,
                subEl = this.$('#' + this.menuId + '_pexpand_' + rand),
                href;

            if ($cms.dom.notDisplayed(subEl)) {
                $cms.dom.show(subEl);
            } else {
                href = link.getAttribute('href');
                // Second click goes to it
                if (href && !href.startsWith('#')) {
                    return;
                }
                $cms.dom.hide(subEl);
            }

            e.preventDefault();
        }
    });

    // For admin/templates/MENU_mobile.tp
    $cms.templates.menuMobile = function menuMobile(params) {
        var menuId = strVal(params.menuId);
        $cms.dom.on(document.body, 'click', 'click .js-click-toggle-' + menuId + '-content', function (e) {
            var branch = document.getElementById(menuId);

            if (branch) {
                $cms.dom.toggle(branch.parentElement);
                e.preventDefault();
            }
        });
    };

    $cms.views.SelectMenu = SelectMenu;
    function SelectMenu() {
        SelectMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(SelectMenu, Menu, /**@lends SelectMenu.prototype*/{
        events: function () {
            return {
                'change .js-change-redirect-to-value': 'redirect'
            };
        },
        redirect: function (e, changed) {
            if (changed.value) {
                window.location.href = changed.value;
            }
        }
    });


    $cms.templates.menuEditorScreen = function (params, container) {
        var menuEditorWrapEl = $cms.dom.$(container, '.js-el-menu-editor-wrap');

        window.all_menus = params.allMenus;

        $cms.dom.$('#url').addEventListener('dblclick', doubleClick);
        $cms.dom.$('#caption_long').addEventListener('dblclick', doubleClick);
        $cms.dom.$('#page_only').addEventListener('dblclick', doubleClick);

        window.current_selection = '';
        $cms.requireJavascript('tree_list').then(function () {
            window.sitemap = $cms.ui.createTreeList('tree_list', 'data/sitemap.php?get_perms=0' + $cms.$KEEP() + '&start_links=1', null, '', false, null, false, true);
        });

        function doubleClick() {
            if (!menuEditorWrapEl.classList.contains('docked')) {
                $cms.dom.smoothScroll($cms.dom.findPosY(document.getElementById('caption_' + window.current_selection)));
            }
        }

        $cms.dom.on(container, 'click', '.js-click-menu-editor-add-new-page', function () {
            var form = $cms.dom.$id('edit_form');

            $cms.ui.prompt(
                $cms.$CONFIG_OPTION('collapse_user_zones') ? '{!javascript:ENTER_ZONE_SPZ;^}' : '{!javascript:ENTER_ZONE;^}',
                '',
                function (zone) {
                    if (zone !== null) {
                        $cms.ui.prompt(
                            '{!javascript:ENTER_PAGE;^}',
                            '',
                            function (page) {
                                if (page !== null) {
                                    form.elements.url.value = zone + ':' + page;
                                }
                            },
                            '{!menus:SPECIFYING_NEW_PAGE;^}'
                        );
                    }
                },
                '{!menus:SPECIFYING_NEW_PAGE;^}'
            );
        });

        $cms.dom.on(container, 'submit', '.js-submit-modsecurity-workaround', function (e, form) {
            $cms.form.modsecurityWorkaround(form);
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

    $cms.templates.menuEditorBranchWrap = function menuEditorBranchWrap(params, container) {
        var id = strVal(params.i),
            sIndex = +params.branchType || 0;

        if (params.clickableSections) {
            sIndex = (sIndex === 0) ? 0 : (sIndex - 1);
        }

        document.getElementById('branch_type_' + id).selectedIndex = sIndex;

        $cms.dom.on(container, 'focus', '.js-focus-make-caption-field-selected', function (e, focused) {
            make_field_selected(focused);
        });

        $cms.dom.on(container, 'dblclick', '.js-dblclick-scroll-to-heading', function (e) {
            if (!document.getElementById('menu_editor_wrap').classList.contains('docked')) {
                $cms.dom.smoothScroll($cms.dom.findPosY(document.getElementsByTagName('h2')[2]));
            }
        });

        $cms.dom.on(container, 'click', '.js-click-delete-menu-branch', function (e, clicked) {
            delete_menu_branch(clicked);
        });

        $cms.dom.on(container, 'click', '.js-click-menu-editor-branch-type-change', function () {
            menu_editor_branch_type_change(id);
        });

        $cms.dom.on(container, 'change', '.js-change-menu-editor-branch-type-change', function () {
            menu_editor_branch_type_change(id);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-move-down-handle-ordering', function (e, btn) {
            handle_ordering(btn, false, true);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-move-up-handle-ordering', function (e, btn) {
            handle_ordering(btn, true, false);
        });

        function delete_menu_branch(ob) {
            var id = ob.id.substring(4, ob.id.length);

            if (((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) || (ob.form.elements['branch_type_' + id] != 'page')) {
                var choices = { buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}', menu___generic_admin__delete: '{!DELETE;^}', buttons__move: '{!menus:MOVETO_MENU;^}' };
                $cms.ui.generateQuestionUi(
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
                            $cms.ui.generateQuestionUi(
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
                                        $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,menu_management}' + '?id=' + encodeURIComponent(id) + '&menu=' + encodeURIComponent(result) + $cms.keepStub(), null, post);
                                        delete_branch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                                    }
                                }
                            );
                        }
                    }
                );
            } else {
                $cms.ui.confirm(
                    '{!CONFIRM_DELETE_LINK;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                    function (result) {
                        if (result)
                            delete_branch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                    }
                );
            }
        }
    };

    $cms.templates.menuEditorBranch = function menuEditorBranch(params, container) {
        var parentId = strVal(params.i),
            clickableSections = !!params.clickableSections && (params.clickableSections !== '0');

        $cms.dom.on(container, 'click', '.js-click-add-new-menu-item', function () {
            var insert_before_id = 'branches_go_before_' + parentId;

            var template = $cms.dom.$id('template').value;

            var before = $cms.dom.$id(insert_before_id);
            var new_id = 'm_' + Math.floor(Math.random() * 10000);
            var template2 = template.replace(/replace\_me\_with\_random/gi, new_id);
            var highest_order_element = $cms.dom.$id('highest_order');
            var new_order = highest_order_element.value + 1;
            highest_order_element.value++;
            template2 = template2.replace(/replace\_me\_with\_order/gi, new_order);
            template2 = template2.replace(/replace\_me\_with\_parent/gi, parentId);

            // Backup form branches
            var form = $cms.dom.$id('edit_form');
            var _elements_bak = form.elements, elements_bak = [];
            var i;
            for (i = 0; i < _elements_bak.length; i++) {
                elements_bak.push([_elements_bak[i].name, _elements_bak[i].value]);
            }

            $cms.dom.append(before, template2); // Technically we are actually putting after "branches_go_before_XXX", but it makes no difference. It only needs to act as a divider.

            // Restore form branches
            for (i = 0; i < elements_bak.length; i++) {
                if (elements_bak[i][0]) {
                    form.elements[elements_bak[i][0]].value = elements_bak[i][1];
                }
            }

            if (!clickableSections) {
                menu_editor_branch_type_change(new_id);
            }

            $cms.dom.$id('mini_form_hider').style.display = 'none';
        });
    };


    function menu_editor_branch_type_change(id) {
        var disabled = (document.getElementById('branch_type_' + id).value !== 'page');
        var sub = $cms.dom.$id('branch_' + id + '_follow_1');
        if (sub) {
            sub.style.display = disabled ? 'block' : 'none';
        }
        sub = $cms.dom.$id('branch_' + id + '_follow_2');
        if (sub) {
            sub.style.display = disabled ? 'block' : 'none';
        }
    }

    $cms.templates.menuSitemap = function (params, container) {
        var menuId = strVal(params.menuSitemapId),
            content = arrVal($cms.dom.data(container, 'tpMenuContent'));

        generate_menu_sitemap($cms.dom.$('#' + menuId), content, 0);

        // ==============================
        // DYNAMIC TREE CREATION FUNCTION
        // ==============================
        function generate_menu_sitemap(targetEl, structure, theLevel) {
            structure = arrVal(structure);
            theLevel = +theLevel || 0;

            if (theLevel === 0) {
                $cms.dom.empty(targetEl);
                var ul = document.createElement('ul');
                $cms.dom.append(targetEl, ul);
                targetEl = ul;
            }

            var node;
            for (var i = 0; i < structure.length; i++) {
                node = structure[i];
                _generate_menu_sitemap(targetEl, node, theLevel);
            }

            function _generate_menu_sitemap(target, node, theLevel) {
                theLevel = +theLevel || 0;

                var branchId = 'sitemap_menu_branch_' + $cms.random();

                var li = $cms.dom.create('li', {
                    id: branchId,
                    class: (node.current ? 'current' : 'non_current') + ' ' + (node.img ? 'has_img' : 'has_no_img'),
                    'data-toggleable-tray': '{}'
                });

                var span = $cms.dom.create('span');
                $cms.dom.append(li, span);

                if (node.img) {
                    $cms.dom.append(span, $cms.dom.create('img', { src: node.img, srcset: node.img_2x + ' 2x' }));
                    $cms.dom.append(span, document.createTextNode(' '));
                }

                var a = $cms.dom.create(node.url ? 'a' : 'span');
                if (node.url) {
                    if (node.tooltip) {
                        a.title = node.caption + ': ' + node.tooltip;
                    }
                    a.href = node.url;
                }

                $cms.dom.append(span, a);
                $cms.dom.html(a, node.caption);
                $cms.dom.append(target, li);

                if (node.children && node.children.length) {
                    var ul = $cms.dom.create('ul', {
                        id: 'sitemap_menu_children_' + $cms.random(),
                        class: 'toggleable_tray'
                    });
                    // Show expand icon...
                    $cms.dom.append(span, document.createTextNode(' '));

                    var expand = $cms.dom.create('a', {
                        class: 'toggleable_tray_button',
                        href: '#!',
                        'data-click-tray-toggle': branchId
                    });

                    var expandImg = $cms.dom.create('img');
                    if (theLevel < 2) {// High-levels start expanded
                        expandImg.alt = '{!CONTRACT;^}';
                        expandImg.src = $cms.img('{$IMG;^,1x/trays/contract}');
                        expandImg.srcset = $cms.img('{$IMG;^,2x/trays/contract}') + ' 2x';
                    } else {
                        expandImg.alt = '{!EXPAND;^}';
                        expandImg.src = $cms.img('{$IMG;^,1x/trays/expand}');
                        expandImg.srcset = $cms.img('{$IMG;^,2x/trays/expand}') + ' 2x';
                        $cms.dom.hide(ul);
                    }

                    $cms.dom.append(expand, expandImg);
                    $cms.dom.append(span, expand);

                    // Show children...
                    $cms.dom.append(li, ul);
                    generate_menu_sitemap(ul, node.children, theLevel + 1);
                }
            }
        }
    };

    $cms.templates.pageLinkChooser = function pageLinkChooser(params, container) {
        var ajaxUrl = 'data/sitemap.php?get_perms=0' + $cms.$KEEP() + '&start_links=1';

        if (params.pageType != null) {
            ajaxUrl += '&page_type=' + params.pageType;
        }

        $cms.requireJavascript('tree_list').then(function () {
            $cms.ui.createTreeList(params.name, ajaxUrl, '', '', false, null, false, true);
        });

        $cms.dom.on(container, 'change', '.js-input-page-link-chooser', function (e, input) {
            if (!params.asField) {
                if (window.faux_close) {
                    window.faux_close();
                } else {
                    window.close();
                }
            }

            if (params.getTitleToo) {
                if (input.selected_title === undefined) {
                    input.value = '';
                    /*was autocomplete, unwanted*/
                } else {
                    input.value += ' ' + input.selected_title;
                }
            }
        });
    };

    function menuActiveSelection(menu_id) {
        var menu_element = $cms.dom.$('#' + menu_id),
            possibilities = [], is_selected, url, min_score, i;

        if (menu_element.localName === 'select') {
            for (i = 0; i < menu_element.options.length; i++) {
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

                min_score = possibilities[0].score;
                for (i = 0; i < possibilities.length; i++) {
                    if (possibilities[i].score != min_score) {
                        break;
                    }
                    possibilities[i].element.selected = true;
                }
            }
        } else {
            var menu_items = menu_element.querySelectorAll('.non_current'), a;
            for (i = 0; i < menu_items.length; i++) {
                a = null;
                for (var j = 0; j < menu_items[i].children.length; j++) {
                    if (menu_items[i].children[j].localName === 'a') {
                        a = menu_items[i].children[j];
                    }
                }
                if (!a) {
                    continue;
                }

                url = (a.getAttribute('href') === '') ? '' : a.href;
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

                min_score = possibilities[0].score;
                for (i = 0; i < possibilities.length; i++) {
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
        url = strVal(url);

        if (url === '') {
            return null;
        }

        var current_url = window.location.href;
        if (current_url === url) {
            return 0;
        }
        var global_breadcrumbs = document.getElementById('global_breadcrumbs');

        if (global_breadcrumbs) {
            var links = global_breadcrumbs.querySelectorAll('a');
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

    function setActiveMenu(id, menu) {
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
    }

    function clean_menus() {
        clean_menus_timeout = null;

        var m = $cms.dom.$('#r_' + last_active_menu);
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
                do {
                    if (tags[i].id == t.id) hideable = false;
                    t = t.parentNode.parentNode;
                } while (t.id != 'r_' + last_active_menu);
            }
            if (hideable) {
                tags[i].style.left = '-999px';
                tags[i].style.display = 'none';
            }
        }
    }

    function popUpMenu(id, place, menu, outside_fixed_width) {
        place || (place = 'right');
        outside_fixed_width = !!outside_fixed_width;

        var el = $cms.dom.$('#' + id);

        if (!el) {
            return;
        }

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
        if ($cms.dom.isCss(p.parentElement, 'position', 'absolute')) {
            l += p.offsetLeft;
            t += p.offsetTop;
        } else {
            while (p) {
                if (p && $cms.dom.isCss(p, 'position', 'relative')) {
                    break;
                }

                l += p.offsetLeft;
                t += p.offsetTop - (parseInt(p.style.borderTop) || 0);
                p = p.offsetParent;

                if (p && $cms.dom.isCss(p, 'position', 'absolute')) {
                    break;
                }
            }
        }
        if (place === 'below') {
            t += el.parentNode.offsetHeight;
        } else {
            l += el.parentNode.offsetWidth;
        }

        var full_height = $cms.dom.getWindowScrollHeight(); // Has to be got before e is visible, else results skewed
        el.style.position = 'absolute';
        el.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
        el.style.display = 'block';
        $cms.dom.clearTransitionAndSetOpacity(el, 0.0);
        $cms.dom.fadeTransition(el, 100, 30, 8);

        var full_width = (window.scrollX == 0) ? $cms.dom.getWindowWidth() : window.document.body.scrollWidth;

        if ($cms.$CONFIG_OPTION('fixed_width') && !outside_fixed_width) {
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
                if ($cms.dom.findPosX(el.parentNode, true) + e_width + e_parent_width + 10 > full_width) pos_left -= e_width + e_parent_width;
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

        return false;
    }

    window.set_active_menu = setActiveMenu;
    window.pop_up_menu = popUpMenu;
}(window.$cms));
