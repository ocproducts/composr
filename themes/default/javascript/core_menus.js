/* TODO: Salman move the general stuff for normal page views into global.js, loading menu editing stuff just for drop downs to work is too much */

(function ($cms) {
    'use strict';

    $cms.views.Menu = Menu;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
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
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
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
                recreateCleanTimeout();
            }
        },

        /* For admin/templates/MENU_dropdown.tpl */
        adminTimerPopUpMenu: function (e, target) {
            var menu = $cms.filter.id(this.menu),
                rand = strVal(target.dataset.vwRand);

            window.menu_hold_time = 3000;
            if (!target.dataset.timer) {
                target.dataset.timer = window.setTimeout(function () {
                    var ret = popUpMenu(menu + '_dexpand_' + rand, 'below', menu + '_d', true);
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
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function PopupMenu(params) {
        PopupMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(PopupMenu, Menu, /**@lends PopupMenu#*/{
        events: function () {
            return {
                'click .js-click-unset-active-menu': 'unsetActiveMenu',
                'mouseout .js-mouseout-unset-active-menu': 'unsetActiveMenu'
            };
        },

        unsetActiveMenu: function (e, target) {
            if (!target.contains(e.relatedTarget)) {
                window.active_menu = null;
                recreateCleanTimeout();
            }
        }
    });

    $cms.views.PopupMenuBranch = PopupMenuBranch;
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function PopupMenuBranch() {
        PopupMenuBranch.base(this, 'constructor', arguments);

        this.rand = this.params.rand;
        this.menu = $cms.filter.id(this.params.menu);
        this.popup = this.menu + '_pexpand_' + this.rand;
    }

    $cms.inherits(PopupMenuBranch, $cms.View, /**@lends PopupMenuBranch#*/{
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
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function TreeMenu() {
        TreeMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(TreeMenu, Menu, /**@lends TreeMenu#*/{
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
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function MobileMenu() {
        MobileMenu.base(this, 'constructor', arguments);
        this.menuContentEl = this.$('.js-el-menu-content');
    }

    $cms.inherits(MobileMenu, Menu, /**@lends MobileMenu#*/{
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
    /**
     * @memberof $cms.views
     * @class
     * @extends Menu
     */
    function SelectMenu() {
        SelectMenu.base(this, 'constructor', arguments);
    }

    $cms.inherits(SelectMenu, Menu, /**@lends SelectMenu#*/{
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
            $cms.form.modSecurityWorkaround(form);
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
            if (!checkMenu()) {
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
                menuEditorWrapEl.classList.remove('docked');
                img.src = '{$IMG;*,1x/arrow_box_hover}';
                if (img.srcset !== undefined) {
                    img.srcset = '{$IMG;*,2x/arrow_box_hover} 2x';
                }
            } else {
                menuEditorWrapEl.classList.add('non_docked');
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
            makeFieldSelected(focused);
        });

        $cms.dom.on(container, 'dblclick', '.js-dblclick-scroll-to-heading', function (e) {
            if (!document.getElementById('menu_editor_wrap').classList.contains('docked')) {
                $cms.dom.smoothScroll($cms.dom.findPosY(document.getElementsByTagName('h2')[2]));
            }
        });

        $cms.dom.on(container, 'click', '.js-click-delete-menu-branch', function (e, clicked) {
            deleteMenuBranch(clicked);
        });

        $cms.dom.on(container, 'click', '.js-click-menu-editor-branch-type-change', function () {
            menuEditorBranchTypeChange(id);
        });

        $cms.dom.on(container, 'change', '.js-change-menu-editor-branch-type-change', function () {
            menuEditorBranchTypeChange(id);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-move-down-handle-ordering', function (e, btn) {
            handleOrdering(btn, /*up*/false, /*down*/true);
        });

        $cms.dom.on(container, 'click', '.js-click-btn-move-up-handle-ordering', function (e, btn) {
            handleOrdering(btn, /*up*/true, /*down*/false);
        });

        function makeFieldSelected(el) {
            if (el.classList.contains('menu_editor_selected_field')) {
                return;
            }

            el.classList.add('menu_editor_selected_field');

            var changed = false;
            for (var i = 0; i < el.form.elements.length; i++) {
                if ((el.form.elements[i].classList.contains('menu_editor_selected_field')) && (el.form.elements[i] !== el)) {
                    el.form.elements[i].classList.remove('menu_editor_selected_field');
                    changed = true;
                }
            }

            copyFieldsIntoBottom(el.id.substr(8), changed);
        }

        function handleOrdering(el, upwards) {
            var form = $cms.dom.$('#edit_form');

            // Find the num
            var index = el.id.substring(el.id.indexOf('_') + 1, el.id.length);
            var num = window.parseInt(form.elements['order_' + index].value) || 0;

            // Find the parent
            var parentNum = $cms.dom.$('#parent_' + index).value;

            var i, b, bindex;
            var best = -1, bestindex = -1;

            if (upwards) { // Up
                // Find previous branch with same parent (if exists)
                for (i = 0; i < form.elements.length; i++) {
                    if ((form.elements[i].name.startsWith('parent_')) && (form.elements[i].value == parentNum)) {
                        bindex = form.elements[i].name.substr('parent_'.length, form.elements[i].name.length);
                        b = window.parseInt(form.elements['order_' + bindex].value) || 0;
                        if ((b < num) && (b > best)) {
                            best = b;
                            bestindex = bindex;
                        }
                    }
                }
            } else { // Down
                // Find next branch with same parent (if exists)
                for (i = 0; i < form.elements.length; i++) {
                    if ((form.elements[i].name.startsWith('parent_')) && (form.elements[i].value === parentNum)) {
                        bindex = form.elements[i].name.substr('parent_'.length, form.elements[i].name.length);
                        b = window.parseInt(form.elements['order_' + bindex].value);
                        if ((b > num) && ((b < best) || (best === -1))) {
                            best = b;
                            bestindex = bindex;
                        }
                    }
                }
            }

            var elements = form.querySelectorAll('input');
            for (i = 0; i < elements.length; i++) {
                if (elements[i].name === 'parent_' + index) { // Found our spot
                    var el = elements[i];
                    for (b = upwards ? (i - 1) : (i + 1); upwards ? (b > 0) : (b < elements.length); upwards ? b-- : b++) {
                        if ((!isChild(elements, index, elements[b].name.substr('parent_'.length))) && (elements[b].name.startsWith('parent_') && ((upwards) || (document.getElementById('branch_type_' + elements[b].name.substr('parent_'.length)).selectedIndex === 0) || (!existsChild(elements, elements[b].name.substr('parent_'.length)))))) {
                            var target = elements[b];
                            var main = el.parentNode.parentNode;
                            var place = target.parentNode.parentNode;
                            if ((upwards && (branchDepth(target) <= branchDepth(el))) || ((branchDepth(target) !== branchDepth(el)))) {
                                main.parentNode.removeChild(main);
                                place.parentNode.insertBefore(main, place);
                            } else {
                                main.parentNode.removeChild(main);
                                if (!place.nextSibling) {
                                    place.parentNode.appendChild(main);
                                } else {
                                    place.parentNode.insertBefore(main, place.nextSibling);
                                }
                            }
                            el.value = target.value;
                            return;
                        }
                    }
                }
            }

            function isChild(elements, possibleParent, possibleChild) {
                for (var i = 0; i < elements.length; i++) {
                    if ((elements[i].name.substr('parent_'.length) == possibleChild) && (elements[i].name.substr(0, 'parent_'.length) == 'parent_')) {
                        if (elements[i].value == possibleParent) {
                            return true;
                        }

                        return isChild(elements, possibleParent, elements[i].value);
                    }
                }

                return false;
            }

            function branchDepth(branch) {
                if (branch.parentNode) {
                    return branchDepth(branch.parentNode) + 1;
                }

                return 0;
            }
        }

        function deleteMenuBranch(ob) {
            var id = ob.id.substring(4, ob.id.length);

            if (((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) || (ob.form.elements['branch_type_' + id] != 'page')) {
                var choices = { buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}', menu___generic_admin__delete: '{!DELETE;^}', buttons__move: '{!menus:MOVETO_MENU;^}' };
                $cms.ui.generateQuestionUi(
                    '{!menus:CONFIRM_DELETE_LINK_NICE;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                    choices,
                    '{!menus:DELETE_MENU_ITEM;^}',
                    null,
                    function (result) {
                        if (result.toLowerCase() === '{!DELETE;^}'.toLowerCase()) {
                            deleteBranch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                        } else if (result.toLowerCase() === '{!menus:MOVETO_MENU;^}'.toLowerCase()) {
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
                                    if (result.toLowerCase() !== '{!INPUTSYSTEM_CANCEL;^}'.toLowerCase()) {
                                        var post = '', name, value;
                                        for (var i = 0; i < ob.form.elements.length; i++) {
                                            name = ob.form.elements[i].name;
                                            if (name.substr(name.length - (('_' + id).length)) === '_' + id) {
                                                if (ob.localName === 'select') {
                                                    value = ob.form.elements[i].value;
                                                    window.myValue = ob.options[ob.selectedIndex].value;
                                                } else {
                                                    if ((ob.type.toLowerCase() === 'checkbox') && (!ob.checked)) {
                                                        continue;
                                                    }

                                                    value = ob.form.elements[i].value;
                                                }
                                                if (post !== '') {
                                                    post += '&';
                                                }
                                                post += name + '=' + encodeURIComponent(value);
                                            }
                                        }
                                        /*TODO: Synchronous XHR*/
                                        $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,menu_management}' + '?id=' + encodeURIComponent(id) + '&menu=' + encodeURIComponent(result) + $cms.keepStub(), null, post);
                                        deleteBranch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                                    }
                                }
                            );
                        }
                    }
                );
            } else {
                $cms.ui.confirm(
                    '{!menus:CONFIRM_DELETE_LINK;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                    function (result) {
                        if (result) {
                            deleteBranch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                        }
                    }
                );
            }
        }
    };

    $cms.templates.menuEditorBranch = function menuEditorBranch(params, container) {
        var parentId = strVal(params.i),
            clickableSections = !!params.clickableSections && (params.clickableSections !== '0');

        $cms.dom.on(container, 'click', '.js-click-add-new-menu-item', function () {
            var insertBeforeId = 'branches_go_before_' + parentId;

            var template = $cms.dom.$id('template').value;

            var before = $cms.dom.$id(insertBeforeId);
            var newId = 'm_' + Math.floor(Math.random() * 10000);
            var template2 = template.replace(/replace\_me\_with\_random/gi, newId);
            var highestOrderElement = $cms.dom.$id('highest_order');
            var newOrder = highestOrderElement.value + 1;
            highestOrderElement.value++;
            template2 = template2.replace(/replace\_me\_with\_order/gi, newOrder);
            template2 = template2.replace(/replace\_me\_with\_parent/gi, parentId);

            // Backup form branches
            var form = $cms.dom.$id('edit_form');
            var _elementsBak = form.elements, elementsBak = [];
            var i;
            for (i = 0; i < _elementsBak.length; i++) {
                elementsBak.push([_elementsBak[i].name, _elementsBak[i].value]);
            }

            $cms.dom.append(before, template2); // Technically we are actually putting after "branches_go_before_XXX", but it makes no difference. It only needs to act as a divider.

            // Restore form branches
            for (i = 0; i < elementsBak.length; i++) {
                if (elementsBak[i][0]) {
                    form.elements[elementsBak[i][0]].value = elementsBak[i][1];
                }
            }

            if (!clickableSections) {
                menuEditorBranchTypeChange(newId);
            }

            $cms.dom.$id('mini_form_hider').style.display = 'none';
        });
    };


    function menuEditorBranchTypeChange(id) {
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

        generateMenuSitemap($cms.dom.$('#' + menuId), content, 0);

        // ==============================
        // DYNAMIC TREE CREATION FUNCTION
        // ==============================
        function generateMenuSitemap(targetEl, structure, theLevel) {
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
                _generateMenuSitemap(targetEl, node, theLevel);
            }

            function _generateMenuSitemap(target, node, theLevel) {
                theLevel = +theLevel || 0;

                var branchId = 'sitemap_menu_branch_' + $cms.random();

                var li = $cms.dom.create('li', {
                    'id': branchId,
                    'class': (node.current ? 'current' : 'non_current') + ' ' + (node.img ? 'has_img' : 'has_no_img'),
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
                        'id': 'sitemap_menu_children_' + $cms.random(),
                        'class': 'toggleable_tray'
                    });
                    // Show expand icon...
                    $cms.dom.append(span, document.createTextNode(' '));

                    var expand = $cms.dom.create('a', {
                        'class': 'toggleable_tray_button',
                        'href': '#!',
                        'data-click-tray-toggle': branchId
                    });

                    var expandImg = $cms.dom.create('img');
                    if (theLevel < 2) { // High-levels start expanded
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
                    generateMenuSitemap(ul, node.children, theLevel + 1);
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

    function menuActiveSelection(menuId) {
        var menuElement = $cms.dom.$('#' + menuId),
            possibilities = [], isSelected, url, min_score, i;

        if (menuElement.localName === 'select') {
            for (i = 0; i < menuElement.options.length; i++) {
                url = menuElement.options[i].value;
                isSelected = menuItemIsSelected(url);
                if (isSelected !== null) {
                    possibilities.push({
                        url: url,
                        score: isSelected,
                        element: menuElement.options[i]
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
            var menuItems = menuElement.querySelectorAll('.non_current'), a;
            for (i = 0; i < menuItems.length; i++) {
                a = null;
                for (var j = 0; j < menuItems[i].children.length; j++) {
                    if (menuItems[i].children[j].localName === 'a') {
                        a = menuItems[i].children[j];
                    }
                }
                if (!a) {
                    continue;
                }

                url = (a.getAttribute('href') === '') ? '' : a.href;
                isSelected = menuItemIsSelected(url);
                if (isSelected !== null) {
                    possibilities.push({
                        url: url,
                        score: isSelected,
                        element: menuItems[i]
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

        var currentUrl = window.location.href;
        if (currentUrl === url) {
            return 0;
        }
        var globalBreadcrumbs = document.getElementById('global_breadcrumbs');

        if (globalBreadcrumbs) {
            var links = globalBreadcrumbs.querySelectorAll('a');
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

    var cleanMenusTimeout,
        lastActiveMenu;

    function setActiveMenu(id, menu) {
        window.active_menu = id;
        if (menu != null) {
            lastActiveMenu = menu;
        }
    }

    function recreateCleanTimeout() {
        if (cleanMenusTimeout) {
            window.clearTimeout(cleanMenusTimeout);
        }
        cleanMenusTimeout = window.setTimeout(cleanMenus, window.menu_hold_time);
    }

    function cleanMenus() {
        cleanMenusTimeout = null;

        var m = $cms.dom.$('#r_' + lastActiveMenu);
        if (!m) {
            return;
        }
        var tags = m.querySelectorAll('.nlevel');
        var e = (window.active_menu == null) ? null : document.getElementById(window.active_menu), t;
        var i, hideable;
        for (i = tags.length - 1; i >= 0; i--) {
            if (tags[i].localName !== 'ul' && tags[i].localName !== 'div') continue;

            hideable = true;
            if (e) {
                t = e;
                do {
                    if (tags[i].id == t.id) hideable = false;
                    t = t.parentNode.parentNode;
                } while (t.id != 'r_' + lastActiveMenu);
            }
            if (hideable) {
                tags[i].style.left = '-999px';
                tags[i].style.display = 'none';
            }
        }
    }

    function popUpMenu(id, place, menu, outsideFixedWidth) {
        place || (place = 'right');
        outsideFixedWidth = !!outsideFixedWidth;

        var el = $cms.dom.$('#' + id);

        if (!el) {
            return;
        }

        if (cleanMenusTimeout) {
            window.clearTimeout(cleanMenusTimeout);
        }

        if ($cms.dom.isDisplayed(el)) {
            return false;
        }

        window.active_menu = id;
        lastActiveMenu = menu;
        cleanMenus();

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

        var fullHeight = $cms.dom.getWindowScrollHeight(); // Has to be got before e is visible, else results skewed
        el.style.position = 'absolute';
        el.style.left = '0'; // Setting this lets the browser calculate a more appropriate (larger) width, before we set the correct left for that width will fit
        el.style.display = 'block';
        $cms.dom.clearTransitionAndSetOpacity(el, 0.0);
        $cms.dom.fadeTransition(el, 100, 30, 8);

        var fullWidth = (window.scrollX == 0) ? $cms.dom.getWindowWidth() : window.document.body.scrollWidth;

        if ($cms.$CONFIG_OPTION('fixed_width') && !outsideFixedWidth) {
            var mainWebsiteInner = document.getElementById('main_website_inner');
            if (mainWebsiteInner) {
                fullWidth = mainWebsiteInner.offsetWidth;
            }
        }

        var eParentWidth = el.parentNode.offsetWidth;
        el.style.minWidth = eParentWidth + 'px';
        var eParentHeight = el.parentNode.offsetHeight;
        var eWidth = el.offsetWidth;
        function positionL() {
            var posLeft = l;
            if (place == 'below') { // Top-level of drop-down
                if (posLeft + eWidth > fullWidth) {
                    posLeft += eParentWidth - eWidth;
                }
            } else { // NB: For non-below, we can't assume 'left' is absolute, as it is actually relative to parent node which is itself positioned
                if ($cms.dom.findPosX(el.parentNode, true) + eWidth + eParentWidth + 10 > fullWidth) posLeft -= eWidth + eParentWidth;
            }
            el.style.left = posLeft + 'px';
        }
        positionL();
        window.setTimeout(positionL, 0);
        function positionT() {
            var posTop = t;
            if (posTop + el.offsetHeight + 10 > fullHeight) {
                var abovePosTop = posTop - $cms.dom.contentHeight(el) + eParentHeight - 10;
                if (abovePosTop > 0) posTop = abovePosTop;
            }
            el.style.top = posTop + 'px';
        }
        positionT();
        window.setTimeout(positionT, 0);
        el.style.zIndex = 200;

        recreateCleanTimeout();

        return false;
    }
}(window.$cms));
