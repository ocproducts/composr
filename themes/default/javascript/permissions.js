"use strict";

function showPermissionSetting(ob, event) {
    if (ob.disabled) { // already showing default in disabled dropdown
        return;
    }
    if (ob.done) {
        return;
    }
    ob.done = true;

    if (!ob.full_setting) {
        var serverid;

        if (window.sitemap != null) {
            var value = document.getElementById('tree_list').value;

            if (value.indexOf(',') != -1) { // Can't find any single value, as multiple resources are selected
                return;
            }

            var node = window.sitemap.getElementByIdHack(value);
            serverid = node.getAttribute('serverid');
        } else {
            serverid = window.perm_serverid + ':_new_';
        }

        var url = '{$FIND_SCRIPT_NOHTTP;,find_permissions}?serverid=' + encodeURIComponent(serverid) + '&x=' + encodeURIComponent(ob.name);
        $cms.doAjaxRequest(url + $cms.keepStub(), function (ret) {
            if (!ret) {
                return;
            }
            ob.full_setting = ret.responseText;
            ob.title += ' [{!permissions:DEFAULT_PERMISSION;^} ' + ob.full_setting + ']';
        });
        return;
    }

    ob.title += ' [{!permissions:DEFAULT_PERMISSION;^} ' + ob.full_setting + ']';
}

function cleanupPermissionList(name) {
    // We always try and cleanup the 'custom' option if we're choosing something else (because it's confusing for it to stay there)
    var custom_option = document.getElementById(name + '_custom_option');
    if (custom_option) {
        custom_option.parentNode.removeChild(custom_option);
    }
}

function copyPermissionPresets(name, value, just_track) {
    name = strVal(name);
    value = strVal(value);

    if (value === '') {
        return false;
    }

    var made_change = false;

    var usual_suspects = ['bypass_validation_xrange_content', 'edit_xrange_content', 'edit_own_xrange_content', 'delete_xrange_content', 'delete_own_xrange_content', 'submit_xrange_content', 'edit_cat_xrange_content'];
    var access = [2, 3, 2, 3, 2, 1, 3]; // The minimum access level that turns on each of the above permissions   NB: Also defined in resource_fs.php, so keep that in-sync

    var holder = document.getElementById(name + '_privilege_container');
    var elements = holder.getElementsByTagName('select');
    var i, j, test, stub = name + '_privilege_', name2, x;

    var node = null;
    if (window.sitemap !== undefined) {
        node = window.sitemap.getElementByIdHack(document.getElementById('tree_list').value.split(',')[0]);
    }

    if (value !== '-1') {
        for (i = 0; i < elements.length; i++) {
            if (elements[i].name.indexOf('presets') != -1) {
                continue;
            }

            if (window.sitemap === undefined) {
                elements[i].disabled = false;
            }
            test = -1;
            name2 = elements[i].name.substr(stub.length);
            x = name2.replace(/(high|mid|low)/, 'x');

            for (j = 0; j < usual_suspects.length; j++) {
                if (usual_suspects[j] == x) {
                    test = (access[j] <= window.parseInt(value)) ? 1 : 0;
                    break;
                }
            }
            if ((test !== -1) || ((node) && (node.getAttribute('serverid') !== '_root'))) {
                if (elements[i].selectedIndex != test + 1) {
                    made_change = true;
                    if (elements[i].selectedIndex != test + 1) {
                        made_change = true;
                        if (!just_track) elements[i].selectedIndex = test + 1; // -1 is at index 0
                    }
                }
            }
        }
    } else {
        for (i = 0; i < elements.length; i++) {
            if (elements[i].name.indexOf('presets') !== -1) {
                continue;
            }

            if (window.sitemap === undefined) elements[i].disabled = true;
            // Any disabled ones will be set to show the default permission rather than the "use-default" one, WHILST all-global is on
            elements[i].selectedIndex = eval(elements[i].name + ';') + 1; // -1 is at index 0
        }
    }

    if ((!just_track) && (elements.length === 2) && (made_change)) {
        $cms.ui.alert('{!permissions:JUST_PRESETS;^}');
    }

    return made_change;
}

function setupPrivilegeOverrideSelector(name, default_access, privilege, title, all_global) {
    eval('window.' + name + '_privilege_' + privilege + '=' + default_access);
    var select_element = document.getElementById(name + '_privilege_' + privilege);
    if (all_global) {
        // Any disabled ones will be set to show the default permission rather than the "use-default" one, WHILST all-global is on
        select_element.selectedIndex = eval(name + '_privilege_' + privilege) + 1; // -1 is at index 0
        if (window.sitemap === undefined) select_element.disabled = true;
    }
}

// =========================================
// These are for the Permissions Tree Editor
// =========================================


function permissionsImgFunc1(node, id) {
    var temp = permissionsImgFunc1b(node, id);
    var url = temp[0];
    var title = temp[1];
    return '<img class="vertical_alignment perm_icon" src="' + url + '" alt="' + title + '" title="' + title + '" />&nbsp;';


    function permissionsImgFunc1b(node, id) {
        var group = document.getElementById('group').value;

        if (id === undefined) {
            id = node.getAttribute('id');
        }

        if (window.attributes_full === undefined) {
            window.attributes_full = [];
        }

        if (window.attributes_full[id] === undefined) {
            window.attributes_full[id] = node.attributes;
        }

        if (((window.attributes_full[id]['group_privileges_delete_highrange_content_' + group]) && (window.attributes_full[id]['group_privileges_delete_highrange_content_' + group] == '1')) ||
            ((window.attributes_full[id]['group_privileges_delete_midrange_content_' + group]) && (window.attributes_full[id]['group_privileges_delete_midrange_content_' + group] == '1')) ||
            ((window.attributes_full[id]['group_privileges_delete_lowrange_content_' + group]) && (window.attributes_full[id]['group_privileges_delete_lowrange_content_' + group] == '1')))
            return [$cms.img('{$IMG;,permlevels/3}'), '{!PINTERFACE_LEVEL_3;^}'];
        else if (((window.attributes_full[id]['group_privileges_bypass_validation_highrange_content_' + group]) && (window.attributes_full[id]['group_privileges_bypass_validation_highrange_content_' + group] == '1')) ||
            ((window.attributes_full[id]['group_privileges_bypass_validation_midrange_content_' + group]) && (window.attributes_full[id]['group_privileges_bypass_validation_midrange_content_' + group] == '1')) ||
            ((window.attributes_full[id]['group_privileges_bypass_validation_lowrange_content_' + group]) && (window.attributes_full[id]['group_privileges_bypass_validation_lowrange_content_' + group] == '1')))
            return [$cms.img('{$IMG;,permlevels/2}'), '{!PINTERFACE_LEVEL_2;^}'];
        else if (((window.attributes_full[id]['group_privileges_submit_highrange_content_' + group]) && (window.attributes_full[id]['group_privileges_submit_highrange_content_' + group] == '1')) ||
            ((window.attributes_full[id]['group_privileges_submit_midrange_content_' + group]) && (window.attributes_full[id]['group_privileges_submit_midrange_content_' + group] == '1')) ||
            ((window.attributes_full[id]['group_privileges_submit_lowrange_content_' + group]) && (window.attributes_full[id]['group_privileges_submit_lowrange_content_' + group] == '1')))
            return [$cms.img('{$IMG;,permlevels/1}'), '{!PINTERFACE_LEVEL_1;^}'];
        else if (window.attributes_full[id]['inherits_something'])
            return [$cms.img('{$IMG;,permlevels/inherit}'), '{!permissions:PINTERFACE_LEVEL_GLOBAL;^}'];
        else if (window.attributes_full[id]['no_privileges']) return [$cms.img('{$IMG;,blank}'), ''];

        return [$cms.img('{$IMG;,permlevels/0}'), '{!permissions:PINTERFACE_LEVEL_0;^}'];
    }
}

function permissionsImgFunc2(node, id) {
    var temp = permissionsImgFunc2b(node, id);
    var url = temp[0];
    var title = temp[1];
    return '<img class="vertical_alignment" src="' + url + '" alt="' + title + '" title="' + title + '" />';

    function permissionsImgFunc2b(node, id) {
        if (id === undefined) id = node.getAttribute('id');

        var group = document.getElementById('group').value;

        if (node.getAttribute('g_view_' + group) == 'true') {
            return [$cms.img('{$IMG;,led_on}'), '{!permissions:PINTERFACE_VIEW;^}'];
        }

        return [$cms.img('{$IMG;,led_off}'), '{!permissions:PINTERFACE_VIEW_NO;^}'];
    }
}

