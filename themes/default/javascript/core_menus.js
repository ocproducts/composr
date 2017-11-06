(function ($cms) {
    'use strict';

    $cms.templates.menuEditorScreen = function (params, container) {
        var menuEditorWrapEl = $cms.dom.$(container, '.js-el-menu-editor-wrap');

        window.allMenus = params.allMenus;

        $cms.dom.$('#url').addEventListener('dblclick', doubleClick);
        $cms.dom.$('#caption_long').addEventListener('dblclick', doubleClick);
        $cms.dom.$('#page_only').addEventListener('dblclick', doubleClick);

        window.currentSelection = '';
        $cms.requireJavascript('tree_list').then(function () {
            window.sitemap = $cms.ui.createTreeList('tree_list', 'data/sitemap.php?get_perms=0' + $cms.$KEEP() + '&start_links=1', null, '', false, null, false, true);
        });

        function doubleClick() {
            if (!menuEditorWrapEl.classList.contains('docked')) {
                $cms.dom.smoothScroll($cms.dom.findPosY(document.getElementById('caption_' + window.currentSelection)));
            }
        }

        $cms.dom.on(container, 'click', '.js-click-menu-editor-add-new-page', function () {
            var form = $cms.dom.$id('edit_form');

            $cms.ui.prompt(
                $cms.$CONFIG_OPTION('collapse_user_zones') ? '{!javascript:ENTER_ZONE_SPZ;^}' : '{!javascript:ENTER_ZONE;^}', '', null, '{!menus:SPECIFYING_NEW_PAGE;^}'
            ).then(function (zone) {
                if (zone != null) {
                    $cms.ui.prompt(
                        '{!javascript:ENTER_PAGE;^}', '', null, '{!menus:SPECIFYING_NEW_PAGE;^}'
                    ).then(function (page) {
                        if (page != null) {
                            form.elements.url.value = zone + ':' + page;
                        }
                    });
                }
            });
        });

        $cms.dom.on(container, 'submit', '.js-submit-modsecurity-workaround', function (e, form) {
            if ($cms.form.isModSecurityWorkaroundEnabled()) {
                e.preventDefault();
                $cms.form.modSecurityWorkaround(form);
            } else {
                form.submit();
            }
        });

        $cms.dom.on(container, 'change', '.js-input-change-update-selection', function (e, input) {
            var el = $cms.dom.$('#url_' + window.currentSelection),
                urlEl,
                captionEl;
            
            if (!el) {
                return;
            }
            
            el.value = input.value;

            urlEl = $cms.dom.$('#edit_form').elements['url'];
            urlEl.value = input.value;

            captionEl = $cms.dom.$('#edit_form').elements['caption_' + window.currentSelection];
            if ((captionEl.value === '') && input.selectedTitle) {
                captionEl.value = input.selectedTitle.replace(/^.*:\s*/, '');
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
            sIndex = Number(params.branchType) || 0;

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
            var index = el.id.substring(el.id.indexOf('_') + 1, el.id.length),
                num = parseInt(form.elements['order_' + index].value) || 0;

            // Find the parent
            var parentNum = $cms.dom.$('#parent_' + index).value,
                i, b, bindex,
                best = -1, bestindex = -1;

            if (upwards) { // Up
                // Find previous branch with same parent (if exists)
                for (i = 0; i < form.elements.length; i++) {
                    if ((form.elements[i].name.startsWith('parent_')) && (form.elements[i].value == parentNum)) {
                        bindex = form.elements[i].name.substr('parent_'.length, form.elements[i].name.length);
                        b = parseInt(form.elements['order_' + bindex].value) || 0;
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
                        b = parseInt(form.elements['order_' + bindex].value);
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
                    if ((elements[i].name.substr('parent_'.length) == possibleChild) && (elements[i].name.substr(0, 'parent_'.length) === 'parent_')) {
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

            if (((window.showModalDialog !== undefined) || $cms.$CONFIG_OPTION('js_overlays')) || (ob.form.elements['branch_type_' + id] !== 'page')) {
                var choices = { buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}', menu___generic_admin__delete: '{!DELETE;^}', buttons__move: '{!menus:MOVETO_MENU;^}' };
                $cms.ui.generateQuestionUi(
                    '{!menus:CONFIRM_DELETE_LINK_NICE;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                    choices,
                    '{!menus:DELETE_MENU_ITEM;^}',
                    null
                ).then(function (result) {
                    if (result.toLowerCase() === '{!DELETE;^}'.toLowerCase()) {
                        deleteBranch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                    } else if (result.toLowerCase() === '{!menus:MOVETO_MENU;^}'.toLowerCase()) {
                        var choices = { buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}' };
                        for (var i = 0; i < window.allMenus.length; i++) {
                            choices['buttons__choose___' + i] = window.allMenus[i];
                        }
                        return $cms.ui.generateQuestionUi(
                            '{!menus:CONFIRM_MOVE_LINK_NICE;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value),
                            choices,
                            '{!menus:MOVE_MENU_ITEM;^}',
                            null
                        );
                    }
                    
                    // Halt here unless we're moving an item
                    return $cms.promiseHalt();
                }).then(function (answer) {
                    if (answer.toLowerCase() === '{!INPUTSYSTEM_CANCEL;^}'.toLowerCase()) {
                        return;
                    }
                    
                    var post = '', name, value;
                    for (var i = 0; i < ob.form.elements.length; i++) {
                        name = ob.form.elements[i].name;
                        if (name.substr(name.length - (('_' + id).length)) === '_' + id) {
                            if (ob.localName === 'select') {
                                value = ob.form.elements[i].value;
                                window.myValue = ob.options[ob.selectedIndex].value;
                            } else {
                                if ((ob.type.toLowerCase() === 'checkbox') && !ob.checked) {
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

                    $cms.doAjaxRequest('{$FIND_SCRIPT_NOHTTP;,menu_management}' + '?id=' + encodeURIComponent(id) + '&menu=' + encodeURIComponent(answer) + $cms.$KEEP(), null, post);
                    deleteBranch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                });
            } else {
                $cms.ui.confirm('{!menus:CONFIRM_DELETE_LINK;^,xxxx}'.replace('xxxx', document.getElementById('caption_' + id).value)).then(function (result) {
                    if (result) {
                        deleteBranch('branch_wrap_' + ob.name.substr(4, ob.name.length));
                    }
                });
            }
        }
    };

    $cms.templates.menuEditorBranch = function menuEditorBranch(params, container) {
        var parentId = strVal(params.i),
            clickableSections = Boolean(params.clickableSections);

        $cms.dom.on(container, 'click', '.js-click-add-new-menu-item', function () {
            var insertBeforeId = 'branches_go_before_' + parentId,
                template = $cms.dom.$id('template').value,
                before = $cms.dom.$id(insertBeforeId),
                newId = 'm_' + Math.floor(Math.random() * 10000),
                template2 = template.replace(/replace\_me\_with\_random/gi, newId),
                highestOrderElement = $cms.dom.$id('highest_order'),
                newOrder = highestOrderElement.value + 1;
            
            highestOrderElement.value++;
            template2 = template2.replace(/replace\_me\_with\_order/gi, newOrder);
            template2 = template2.replace(/replace\_me\_with\_parent/gi, parentId);

            // Backup form branches
            var form = $cms.dom.$id('edit_form'),
                _elementsBak = form.elements, 
                elementsBak = [], i;
            
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

            $cms.dom.hide('#mini_form_hider');
        });
    };
    
    function menuEditorBranchTypeChange(id) {
        var disabled = (document.getElementById('branch_type_' + id).value !== 'page'),
            sub = $cms.dom.$id('branch_' + id + '_follow_1'),
            sub2 = $cms.dom.$id('branch_' + id + '_follow_2');
        
        if (sub) {
            $cms.dom.toggle(sub, disabled);
        }

        if (sub2) {
            $cms.dom.toggle(sub2, disabled);
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
            theLevel = Number(theLevel) || 0;

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
                theLevel = Number(theLevel) || 0;

                var branchId = 'sitemap_menu_branch_' + $cms.random(),
                    li = $cms.dom.create('li', {
                        id: branchId,
                        className: (node.current ? 'current' : 'non_current') + ' ' + (node.img ? 'has_img' : 'has_no_img'),
                        dataset: {
                            toggleableTray: '{}'
                        }
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
                        className: 'toggleable_tray'
                    });
                    // Show expand icon...
                    $cms.dom.append(span, document.createTextNode(' '));

                    var expand = $cms.dom.create('a', {
                        className: 'toggleable_tray_button',
                        href: '#!',
                        dataset: {
                            clickTrayToggle: branchId
                        }
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
                window.returnValue = input.value;
                if (window.fauxClose !== undefined) {
                    window.fauxClose();
                } else {
                    window.close();
                }
            }

            if (params.getTitleToo) {
                if (input.selectedTitle === undefined) {
                    input.value = '';/*was autocomplete, unwanted*/
                } else {
                    input.value += ' ' + input.selectedTitle;
                }
            }
        });
    };

}(window.$cms));
