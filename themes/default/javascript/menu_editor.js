"use strict";

// ==============
// MENU FUNCTIONS
// ==============


function make_field_selected(el) {
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

    copy_fields_into_bottom(el.id.substr(8), changed);
}

function copy_fields_into_bottom(i, changed) {
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
    for (s = 0; s < form.elements['theme_img_code'].options.length; s++)
        if (document.getElementById('theme_img_code_' + i).value == form.elements['theme_img_code'].options[s].value) break;
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

function menu_editor_handle_keypress(e) {
    var t = e.target;

    var up = (e.keyCode ? e.keyCode : e.charCode) == 38;
    var down = (e.keyCode ? e.keyCode : e.charCode) == 40;

    handle_ordering(t, up, down);
}

function branch_depth(branch) {
    if (branch.parentNode) {
        return branch_depth(branch.parentNode) + 1;
    }

    return 0;
}

function exists_child(elements, parent) {
    for (var i = 0; i < elements.length; i++) {
        if ((elements[i].name.substr(0, 7) === 'parent_') && (elements[i].value == parent)) {
            return true;
        }
    }

    return false;
}

function is_child(elements, possible_parent, possible_child) {
    for (var i = 0; i < elements.length; i++) {
        if ((elements[i].name.substr(7) == possible_child) && (elements[i].name.substr(0, 7) == 'parent_')) {
            if (elements[i].value == possible_parent) {
                return true;
            }

            return is_child(elements, possible_parent, elements[i].value);
        }
    }

    return false;
}

function handle_ordering(el, up, down) {
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
                    if ((!is_child(elements, index, elements[b].name.substr(7))) && (elements[b].name.startsWith('parent_') && ((up) || (document.getElementById('branch_type_' + elements[b].name.substr(7)).selectedIndex == 0) || (!exists_child(elements, elements[b].name.substr(7)))))) {
                        var target = elements[b];
                        var main = us.parentNode.parentNode;
                        var place = target.parentNode.parentNode;
                        if (((up) && (branch_depth(target) <= branch_depth(us))) || ((down) && (branch_depth(target) != branch_depth(us)))) {
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

function swap_names(t, a, b, t2, values_also) {
    if (t2 === undefined) {
        t2 = '';
    }
    if (values_also === undefined) {
        values_also = false;
    }

    var _a = $cms.dom.$id(t + '_' + a + t2);
    var _b = $cms.dom.$id(t + '_' + b + t2);
    _a.name = t + '_' + b + t2;
    _b.name = t + '_' + a + t2;
    _a.id = t + '_' + b + t2;
    _b.id = t + '_' + a + t2;
    if (values_also) {
        var temp = _a.value;
        _a.value = _b.value;
        _b.value = temp;
    }

    var _al = $cms.dom.$('#label_' + t + '_' + a + t2);
    var _bl = $cms.dom.$('#label_' + t + '_' + b + t2);
    if (_al) {
        _al.setAttribute('for', t + '_' + b + t2);
        _bl.setAttribute('for', t + '_' + a + t2);
        _al.id = 'label_' + t + '_' + b + t2;
        _bl.id = 'label_' + t + '_' + a + t2;
    }
}

function magic_copier(object, caption, url, error_message, confirm_message) {
    var els = parent.document.getElementsByName('selected');

    var i, num, yes = false, target_type;
    for (i = 0; i < els.length; i++) {
        if (els[i].checked) {
            num = els[i].value.substring(9, els[i].value.length);
            target_type = parent.document.getElementById('branch_type_' + num);
            if ((target_type.value == 'page') || (target_type.getElementsByTagName('option').length < 3)) {
                if (parent.document.getElementById('url_' + num).value == '') {
                    _do_magic_copier(num, url, caption);
                } else {
                    $cms.ui.confirm(
                        confirm_message,
                        function (answer) {
                            if (answer) _do_magic_copier(num, url, caption);
                        }
                    );
                }
            } else $cms.ui.alert(error_message);
            yes = true;
        }
    }

    if (!yes) {
        $cms.ui.alert('{!javascript:RADIO_NOTHING_SELECTED;^}');
    }

    return false;
}

function _do_magic_copier(num, url, caption) {
    parent.document.getElementById('url_' + num).value = url;
    parent.document.getElementById('caption_' + num).value = caption;
}


function delete_branch(id) {
    var branch = $cms.dom.$id(id);
    branch.parentNode.removeChild(branch);
}

function check_menu() {
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

