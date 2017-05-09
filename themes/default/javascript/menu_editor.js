"use strict";

// ==============
// MENU FUNCTIONS
// ==============

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

function copyFieldsIntoBottom(i, changed) {
    window.current_selection = i;
    var form = $cms.dom.$id('edit_form');

    form.elements['caption_long'].value = $cms.dom.$id('caption_long_' + i).value;
    form.elements['caption_long'].addEventListener('change', function () {
        $cms.dom.$('#caption_long_' + i).value = this.value;
        $cms.dom.$('#caption_long_' + i).disabled = (this.value == '');
    });

    form.elements['url'].value = $cms.dom.$id('url_' + i).value;
    form.elements['url'].onchange = function () {
        $cms.dom.$('#url_' + i).value = this.value;
    };

    form.elements['page_only'].value = $cms.dom.$id('page_only_' + i).value;
    form.elements['page_only'].addEventListener('change', function () {
        $cms.dom.$('#page_only_' + i).value = this.value;
        $cms.dom.$('#page_only_' + i).disabled = (this.value === '');
    });

    var s;
    for (s = 0; s < form.elements['theme_img_code'].options.length; s++) {
        if (document.getElementById('theme_img_code_' + i).value == form.elements['theme_img_code'].options[s].value) {
            break;
        }
    }
    if (s == form.elements['theme_img_code'].options.length) {
        s = 0;
        $cms.ui.alert('{!menus:MISSING_THEME_IMAGE_FOR_MENU;^}'.replace(/\\{1\\}/, $cms.dom.$id('theme_img_code_' + i).value));
    }
    form.elements['theme_img_code'].selectedIndex = s;
    form.elements['theme_img_code'].addEventListener('change', function () {
        $cms.dom.$('#theme_img_code_' + i).value = this.options[this.selectedIndex].value;
        $cms.dom.$('#theme_img_code_' + i).disabled = (this.selectedIndex == 0);
    });
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery(form.elements['theme_img_code']).trigger('change');
    }

    form.elements['new_window'].checked = $cms.dom.$id('new_window_' + i).value == '1';
    form.elements['new_window'].addEventListener('click', function () {
        $cms.dom.$('#new_window_' + i).value = this.checked ? '1' : '0';
        $cms.dom.$('#new_window_' + i).disabled = !this.checked;
    });

    form.elements['check_perms'].checked = $cms.dom.$id('check_perms_' + i).value == '1';
    form.elements['check_perms'].addEventListener('click', function () {
        $cms.dom.$('#check_perms_' + i).value = this.checked ? '1' : '0';
        $cms.dom.$('#check_perms_' + i).disabled = !this.checked;
    });

    //$cms.dom.html(form.elements['branch_type'],$cms.dom.html(document.getElementById('branch_type_'+i))); Breaks in IE due to strict container rules
    form.elements['branch_type'].selectedIndex = $cms.dom.$id('branch_type_' + i).selectedIndex;
    form.elements['branch_type'].addEventListener('change', function (event) {
        $cms.dom.$('#branch_type_' + i).selectedIndex = this.selectedIndex;
        if ($cms.dom.$('#branch_type_' + i).onchange) {
            $cms.dom.$('#branch_type_' + i).onchange(event);
        }
    });
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery(form.elements['branch_type']).trigger('change');
    }

    form.elements['include_sitemap'].selectedIndex = $cms.dom.$id('include_sitemap_' + i).value;
    form.elements['include_sitemap'].addEventListener('change', function (event) {
        $cms.dom.$('#include_sitemap_' + i).value = this.selectedIndex;
        $cms.dom.$('#include_sitemap_' + i).disabled = (this.selectedIndex == 0);
    });
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery(form.elements['include_sitemap']).trigger('change');
    }

    var mfh = $cms.dom.$('#mini_form_hider');
    mfh.style.display = 'block';

    if (!changed) {
        $cms.dom.clearTransitionAndSetOpacity(mfh, 0.0);
        $cms.dom.fadeTransition(mfh, 100, 30, 4);
    } else {
        $cms.dom.clearTransitionAndSetOpacity(form.elements.url, 0.0);
        $cms.dom.fadeTransition(form.elements.url, 100, 30, 4);
    }
}

function menuEditorHandleKeypress(e) {
    var t = e.target;

    var up = (e.keyCode ? e.keyCode : e.charCode) == 38;
    var down = (e.keyCode ? e.keyCode : e.charCode) == 40;

    handleOrdering(t, up, down);
}

function branchDepth(branch) {
    if (branch.parentNode) {
        return branchDepth(branch.parentNode) + 1;
    }

    return 0;
}

function existsChild(elements, parent) {
    for (var i = 0; i < elements.length; i++) {
        if ((elements[i].name.substr(0, 7) === 'parent_') && (elements[i].value == parent)) {
            return true;
        }
    }

    return false;
}

function isChild(elements, possible_parent, possible_child) {
    for (var i = 0; i < elements.length; i++) {
        if ((elements[i].name.substr(7) == possible_child) && (elements[i].name.substr(0, 7) == 'parent_')) {
            if (elements[i].value == possible_parent) {
                return true;
            }

            return isChild(elements, possible_parent, elements[i].value);
        }
    }

    return false;
}

function handleOrdering(el, up, down) {
    if (up || down) {
        var form = $cms.dom.$('#edit_form');

        // Find the num
        var index = el.id.substring(el.id.indexOf('_') + 1, el.id.length);
        var num = window.parseInt(form.elements['order_' + index].value) || 0;

        // Find the parent
        var parent_num = $cms.dom.$('#parent_' + index).value;

        var i, b, bindex;
        var best = -1, bestindex = -1;
    }

    if (up) {// Up
        // Find previous branch with same parent (if exists)
        for (i = 0; i < form.elements.length; i++) {
            if ((form.elements[i].name.startsWith('parent_')) && (form.elements[i].value == parent_num)) {
                bindex = form.elements[i].name.substr(7, form.elements[i].name.length);
                b = window.parseInt(form.elements['order_' + bindex].value) || 0;
                if ((b < num) && (b > best)) {
                    best = b;
                    bestindex = bindex;
                }
            }
        }
    }

    if (down) {// Down
        // Find next branch with same parent (if exists)
        for (i = 0; i < form.elements.length; i++) {
            if ((form.elements[i].name.startsWith('parent_')) && (form.elements[i].value == parent_num)) {
                bindex = form.elements[i].name.substr(7, form.elements[i].name.length);
                b = window.parseInt(form.elements['order_' + bindex].value);
                if ((b > num) && ((b < best) || (best == -1))) {
                    best = b;
                    bestindex = bindex;
                }
            }
        }
    }

    if (up || down) {
        var elements = form.querySelectorAll('input');
        for (i = 0; i < elements.length; i++) {
            if (elements[i].name == 'parent_' + index) {// Found our spot

                var us = elements[i];
                for (b = up ? (i - 1) : (i + 1); up ? (b > 0) : (b < elements.length); up ? b-- : b++) {
                    if ((!isChild(elements, index, elements[b].name.substr(7))) && (elements[b].name.startsWith('parent_') && ((up) || (document.getElementById('branch_type_' + elements[b].name.substr(7)).selectedIndex == 0) || (!existsChild(elements, elements[b].name.substr(7)))))) {
                        var target = elements[b];
                        var main = us.parentNode.parentNode;
                        var place = target.parentNode.parentNode;
                        if (((up) && (branchDepth(target) <= branchDepth(us))) || ((down) && (branchDepth(target) != branchDepth(us)))) {
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
                        us.value = target.value;
                        return;
                    }
                }
            }
        }
    }
}


function deleteBranch(id) {
    var branch = $cms.dom.$id(id);
    branch.parentNode.removeChild(branch);
}

function checkMenu() {
    var form = $cms.dom.$('#edit_form');
    var i, id, name, the_parent, ignore, caption, url, branch_type;
    for (i = 0; i < form.elements.length; i++) {
        name = form.elements[i].name.substr(0, 7);
        if (name == 'parent_') {// We don't care about this, but it does tell us we have found a menu branch ID

            id = form.elements[i].name.substring(7, form.elements[i].name.length);

            // Is this visible? (if it is we need to check the IDs
            the_parent = form.elements[i];
            do {
                if (the_parent.style.display == 'none') {
                    ignore = true;
                    break;
                }
                the_parent = the_parent.parentNode;
            } while (the_parent.parentNode);

            if (!ignore) {// It's the real deal

                // Check we have a caption
                caption = $cms.dom.$id('caption_' + id);
                url = $cms.dom.$id('url_' + id);
                if ((caption.value == '') && (url.value != '')) {
                    $cms.ui.alert('{!MISSING_CAPTION_ERROR;^}');
                    return false;
                }

                // If we are a page, check we have a URL
                branch_type = $cms.dom.$id('branch_type_' + id);
                if (branch_type.options[branch_type.selectedIndex].value == 'page') {
                    if ((caption.value != '') && (url.value == '')) {
                        $cms.ui.alert('{!MISSING_URL_ERROR;^}');
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

