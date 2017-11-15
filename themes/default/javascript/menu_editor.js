'use strict';

// ==============
// MENU FUNCTIONS
// ==============

function copyFieldsIntoBottom(i, changed) {
    window.currentSelection = i;
    var form = $dom.$id('edit_form');

    form.elements['caption_long'].value = $dom.$id('caption_long_' + i).value;
    form.elements['caption_long'].addEventListener('change', function () {
        $dom.$('#caption_long_' + i).value = this.value;
        $dom.$('#caption_long_' + i).disabled = (this.value == '');
    });

    form.elements['url'].value = $dom.$id('url_' + i).value;
    form.elements['url'].onchange = function () {
        $dom.$('#url_' + i).value = this.value;
    };

    form.elements['page_only'].value = $dom.$id('page_only_' + i).value;
    form.elements['page_only'].addEventListener('change', function () {
        $dom.$('#page_only_' + i).value = this.value;
        $dom.$('#page_only_' + i).disabled = (this.value === '');
    });

    var s;
    for (s = 0; s < form.elements['theme_img_code'].options.length; s++) {
        if (document.getElementById('theme_img_code_' + i).value == form.elements['theme_img_code'].options[s].value) {
            break;
        }
    }
    if (s == form.elements['theme_img_code'].options.length) {
        s = 0;
        $cms.ui.alert('{!menus:MISSING_THEME_IMAGE_FOR_MENU;^}'.replace(/\\{1\\}/, $cms.filter.html($dom.$id('theme_img_code_' + i).value)));
    }
    form.elements['theme_img_code'].selectedIndex = s;
    form.elements['theme_img_code'].addEventListener('change', function () {
        $dom.$('#theme_img_code_' + i).value = this.options[this.selectedIndex].value;
        $dom.$('#theme_img_code_' + i).disabled = (this.selectedIndex == 0);
    });
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery(form.elements['theme_img_code']).trigger('change');
    }

    form.elements['new_window'].checked = $dom.$id('new_window_' + i).value == '1';
    form.elements['new_window'].addEventListener('click', function () {
        $dom.$('#new_window_' + i).value = this.checked ? '1' : '0';
        $dom.$('#new_window_' + i).disabled = !this.checked;
    });

    form.elements['check_perms'].checked = $dom.$id('check_perms_' + i).value == '1';
    form.elements['check_perms'].addEventListener('click', function () {
        $dom.$('#check_perms_' + i).value = this.checked ? '1' : '0';
        $dom.$('#check_perms_' + i).disabled = !this.checked;
    });

    form.elements['branch_type'].selectedIndex = $dom.$id('branch_type_' + i).selectedIndex;
    form.elements['branch_type'].addEventListener('change', function (event) {
        $dom.$('#branch_type_' + i).selectedIndex = this.selectedIndex;
        if ($dom.$('#branch_type_' + i).onchange) {
            $dom.$('#branch_type_' + i).onchange(event);
        }
    });
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery(form.elements['branch_type']).trigger('change');
    }

    form.elements['include_sitemap'].selectedIndex = $dom.$id('include_sitemap_' + i).value;
    form.elements['include_sitemap'].addEventListener('change', function (event) {
        $dom.$('#include_sitemap_' + i).value = this.selectedIndex;
        $dom.$('#include_sitemap_' + i).disabled = (this.selectedIndex == 0);
    });
    if (window.jQuery && window.jQuery.fn.select2) {
        window.jQuery(form.elements['include_sitemap']).trigger('change');
    }

    var mfh = $dom.$('#mini_form_hider');
    $dom.slideDown(mfh);
    if (changed) {
        $dom.fadeIn(form.elements.url);
    }
}

function existsChild(elements, parent) {
    for (var i = 0; i < elements.length; i++) {
        if ((elements[i].name.substr(0, 'parent_'.length) === 'parent_') && (elements[i].value == parent)) {
            return true;
        }
    }

    return false;
}

function deleteBranch(id) {
    var branch = $dom.$id(id);
    branch.parentNode.removeChild(branch);
}

function checkMenu() {
    var form = $dom.$('#edit_form');
    var i, id, name, theParent, ignore, caption, url, branchType;
    for (i = 0; i < form.elements.length; i++) {
        name = form.elements[i].name.substr(0, 'parent_'.length);
        if (name === 'parent_') { // We don't care about this, but it does tell us we have found a menu branch ID

            id = form.elements[i].name.substring('parent_'.length, form.elements[i].name.length);

            // Is this visible? (if it is we need to check the IDs
            theParent = form.elements[i];
            do {
                if (theParent.style.display === 'none') {
                    ignore = true;
                    break;
                }
                theParent = theParent.parentNode;
            } while (theParent.parentNode);

            if (!ignore) { // It's the real deal
                // Check we have a caption
                caption = $dom.$id('caption_' + id);
                url = $dom.$id('url_' + id);
                if ((caption.value == '') && (url.value != '')) {
                    $cms.ui.alert('{!menus:MISSING_CAPTION_ERROR;^}');
                    return false;
                }

                // If we are a page, check we have a URL
                branchType = $dom.$id('branch_type_' + id);
                if (branchType.options[branchType.selectedIndex].value === 'page') {
                    if ((caption.value != '') && (url.value == '')) {
                        $cms.ui.alert('{!menus:MISSING_URL_ERROR;^}');
                        return false;
                    }
                }
            }
        }
    }

    return true;
}
