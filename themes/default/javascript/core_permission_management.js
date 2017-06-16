(function ($cms) {
    'use strict';

    $cms.views.PermissionsTreeEditorScreen = PermissionsTreeEditorScreen;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function PermissionsTreeEditorScreen(params) {
        PermissionsTreeEditorScreen.base(this, 'constructor', arguments);

        window.column_color = params.color;
        window.usergroup_titles = params.usergroups;

        $cms.requireJavascript('tree_list').then(function () {
            window.sitemap = $cms.ui.createTreeList('tree_list', 'data/sitemap.php?start_links=1&get_perms=1&label_content_types=1&keep_full_structure=1' + $cms.$KEEP(), null, '', true);
        });
    }

    $cms.inherits(PermissionsTreeEditorScreen, $cms.View, /**@lends PermissionsTreeEditorScreen#*/{
        events: function () {
            return {
                'click .js-click-update-group': 'updateGroupDisplayer',
                'change .js-change-update-group': 'updateGroupDisplayer',
                'click .js-click-set-permissions': 'setPermissions',
                'change: .js-change-update-perm-box': 'updatePermissionBox'
            };
        },

        updateGroupDisplayer: function (e, select) {
            $cms.dom.html(document.getElementById('group_name'), $cms.filter.html(window.usergroup_titles[select.options[select.selectedIndex].value]));
            var tree = document.getElementById('tree_list__root_tree_list');
            $cms.dom.html(tree, '');
            window.sitemap.renderTree(window.sitemap.tree_list_data, tree);
        },

        setPermissions: function () {
            setPermissions(document.getElementById('tree_list'));
        },

        updatePermissionBox: function (e, target) {
            updatePermissionBox(target);
        }
    });

    $cms.templates.permissionRow = function permissionRow(params, container) {
        $cms.dom.on(container, 'click', '.js-click-input-toggle-value', function (e, input) {
            input.value = (input.value === '-') ? '+' : '-';
        });
    };

    $cms.templates.permissionKeysMessageRow = function permissionKeysMessageRow(params, container) {
        $cms.dom.on(container, 'focus', '.js-focus-textarea-expand', function (e, textarea) {
            textarea.setAttribute('rows', '10');
        });

        $cms.dom.on(container, 'blur', '.js-blur-textarea-contract', function (e, textarea) {
            if (!textarea.form.disable_size_change) {
                textarea.setAttribute('rows', '2');
            }
        });
    };

    $cms.templates.permissionKeysPermissionRow = function permissionKeysPermissionRow(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-toggle-value', function (e, btn) {
            btn.value = (btn.value === '-') ? '+' : '-';
        });
    };

    $cms.templates.permissionKeysPermissionsScreen = function permissionKeysPermissionsScreen(params, container) {
        $cms.dom.on(container, 'mouseover mouseout', '.js-btn-hover-toggle-disable-size-change', function (e, btn) {
            btn.form.disable_size_change = (e.type === 'mouseover');
        });
    };

    // Selection changed, so update box
    function updatePermissionBox(setting) {
        if (!window.sitemap) {
            return;
        }

        if (!setting.value) {
            document.getElementById('selection_form_fields').style.display = 'none';
            document.getElementById('selection_button').disabled = true;
            $cms.dom.html(document.getElementById('selection_message'), '{!permissions:PERMISSIONS_TREE_EDITOR_NONE_SELECTED;^}');
            return;
        }

        // Go through and set maximum permissions/override from those selected
        var values = setting.value.split(',');
        var id, name, value, i, node, j, group, element, privilege, privilegeTitle, knownGroups = [], knownPrivileges = [], k, html, newOption, numPrivilegeDefault, numPrivilege, ths, tds, cells, newCell, row;
        var matrix = document.getElementById('enter_the_matrix').querySelector('table');
        var numPrivilegeTotal = 0;
        var isCms = null;
        var rows = matrix.getElementsByTagName('tr');
        var doneHeader = false;
        for (i = 0; i < values.length; i++) { // For all items that we are loading permissions for (we usually just do it for one, but sometimes we load whole sets if we are batch setting permissions)
            node = window.sitemap.getElementByIdHack(values[i]);

            if (i === 0) { // On first iteration we do a cleanup

                // Find usergroups
                for (j = 0; j < node.attributes.length; j++) {
                    if (node.attributes[j].name.substr(0, 7) == 'g_view_') {
                        group = node.attributes[j].name.substr(7);
                        knownGroups.push(group);
                    }
                }

                // Blank out everything in the permissions box, remove all privileges
                for (j = 0; j < knownGroups.length; j++) {
                    group = knownGroups[j];
                    element = document.getElementById('access_' + group);
                    element.checked = false;
                    element = document.getElementById('access_' + group + '_presets');
                    if (element.options[0].id != 'access_' + group + '_custom_option') {
                        newOption = document.createElement('option');
                        $cms.dom.html(newOption, '{!permissions:PINTERFACE_LEVEL_CUSTOM;^}');
                        newOption.id = 'access_' + group + '_custom_option';
                        newOption.value = '';
                        element.insertBefore(newOption, element.options[0]);
                    }
                    element.selectedIndex = 0;

                    // Delete existing privilege nodes
                    ths = matrix.getElementsByTagName('th');
                    tds = matrix.getElementsByTagName('td');
                    cells = [];
                    for (k = 0; k < ths.length; k++) cells.push(ths[k]);
                    for (k = 0; k < tds.length; k++) cells.push(tds[k]);
                    for (k = 0; k < cells.length; k++) {
                        if ((cells[k].className.match(/(^|\s)privilege\_header($|\s)/)) || (cells[k].className.match(/(^|\s)privilege\_footer($|\s)/)) || (cells[k].className.match(/(^|\s)privilege\_cell($|\s)/))) {
                            cells[k].parentNode.removeChild(cells[k]);
                        }
                    }
                }
            }

            isCms = !!(node.getAttribute('serverid').includes(':cms_') && (isCms !== false));

            // Set view access
            for (j = 0; j < node.attributes.length; j++) {
                if (node.attributes[j].name.substr(0, 7) == 'g_view_') {
                    group = node.attributes[j].name.substr(7);
                    element = document.getElementById('access_' + group);
                    if (!element.checked) {
                        element.checked = (node.attributes[j].value == 'true');
                    }
                    element = document.getElementById('access_' + group);
                }
            }
            var form = document.getElementById('permissions_form');
            var noViewSettings = (node.getAttribute('serverid') == '_root') || (node.getAttribute('serverid').substr(0, 22) == 'cms:cms_comcode_pages:');
            for (j = 0; j < form.elements.length; j++) {
                element = form.elements[j];
                if (element.id.substr(0, 7) == 'access_') {
                    element.style.display = ((values.length == 1) && (noViewSettings)) ? 'none' : 'inline';
                    element.disabled = (element.name == '_ignore') || ((values.length == 1) && (noViewSettings));
                }
            }

            // Create privilege nodes
            numPrivilege = 0;
            knownPrivileges = [];
            id = node.getAttribute('id');
            if (window.attributes_full === undefined) window.attributes_full = [];
            if (window.attributes_full[id] === undefined) window.attributes_full[id] = node.attributes;
            for (name in window.attributes_full[id]) {
                value = window.attributes_full[id][name];
                if (name.substr(0, 'privilege_'.length) == 'privilege_') {
                    privilege = name.substr('privilege_'.length);
                    privilegeTitle = value;
                    doneHeader = false;
                    for (k = 0; k < rows.length; k++) {
                        if (rows[k].id.substr(0, 7) != 'access_') continue;

                        group = rows[k].id.substring(7, rows[k].id.indexOf('_privilege_container'));

                        element = document.getElementById('access_' + group + '_privilege_' + privilege);
                        if ((!element) && (!document.getElementById('privilege_cell_' + group + '_' + privilege))) // We haven't added it yet for one of the resources we're doing permissions for
                        {
                            if (!doneHeader) {
                                row = rows[0];
                                newCell = row.insertBefore(document.createElement('th'), row.cells[row.cells.length]);
                                newCell.className = 'privilege_header';
                                newCell.id = 'privilege_header_' + privilege;
                                $cms.dom.html(newCell, '<img class="gd_text" data-gd-text="1" src="' + $cms.baseUrl() + 'data/gd_text.php?color=' + window.column_color + '&amp;text=' + encodeURIComponent(privilegeTitle) + $cms.filter.html($cms.keepStub()) + '" title="' + $cms.filter.html(privilegeTitle) + '" alt="' + $cms.filter.html(privilegeTitle) + '" />');

                                rows[rows.length - 1].appendChild(document.createElement('td')).className = 'form_table_field_input privilege_footer'; // Footer cell

                                numPrivilegeTotal++;

                                doneHeader = true;
                            }

                            // Manually build up cell
                            row = document.getElementById('access_' + group + '_privilege_container');
                            newCell = row.insertBefore(document.createElement('td'), row.cells[row.cells.length - 1]);
                            newCell.className = 'form_table_field_input privilege_cell';
                            new_cell.id = 'privilege_cell_' + group + '_' + privilege;
                            if (document.getElementById('access_' + group).name != '_ignore') {
                                $cms.dom.html(newCell, '<div class="accessibility_hidden"><label for="access_' + group + '_privilege_' + privilege + '">{!permissions:OVERRIDE;^}</label></div><select title="' + $cms.filter.html(privilegeTitle) + '" id="access_' + group + '_privilege_' + privilege + '" name="access_' + group + '_privilege_' + privilege + '"><option selected="selected" value="-1">/</option><option value="0">{!permissions:NO_COMPACT;^}</option><option value="1">{!permissions:YES_COMPACT;^}</option></select>');
                                $cms.dom.on(newCell, 'mouseover', '.js-mouseover-show-permission-setting', function (e, select) {
                                    if (select.value === '-1') {
                                        showPermissionSetting(select, e);
                                    }
                                });

                                element = document.getElementById('access_' + group + '_privilege_' + privilege);

                                setupPrivilegeOverrideSelector('access_' + group, '-1', privilege, privilegeTitle, false);
                            }
                        }
                        if (element)
                            element.options[0].disabled = ((values.length == 1) && (node.getAttribute('serverid') == '_root'));
                    }
                    knownPrivileges.push(privilege);
                    numPrivilege++;
                }
            }

            // Set privileges for all usergroups (to highest permissions from all usergroups selected)
            for (name in window.attributes_full[id]) {
                value = window.attributes_full[id][name];
                if (name.substr(0, 'group_privileges_'.length) == 'group_privileges_') {
                    group = name.substr(name.lastIndexOf('_') + 1);
                    privilege = name.substr('group_privileges_'.length, name.length - group.length - 1 - ('group_privileges_'.length));
                    element = document.getElementById('access_' + group + '_privilege_' + privilege);
                    if (element.selectedIndex < window.parseInt(value) + 1)
                        element.selectedIndex = window.parseInt(value) + 1; // -1 corresponds to 0.
                }
            }

            // Blank out any rows of defaults
            for (k = 0; k < knownGroups.length; k++) {
                group = knownGroups[k];
                numPrivilegeDefault = 0;
                for (j = 0; j < knownPrivileges.length; j++) {
                    element = document.getElementById('access_' + group + '_privilege_' + knownPrivileges[j]);
                    if (element.selectedIndex == 0) numPrivilegeDefault++;
                }
                if (numPrivilegeDefault == numPrivilege) {
                    element = document.getElementById('access_' + group + '_presets');
                    element.selectedIndex = 1;
                    cleanupPermissionList('access_' + group);
                    for (j = 0; j < knownPrivileges.length; j++) {
                        element = document.getElementById('access_' + group + '_privilege_' + knownPrivileges[j]);
                        if (window.sitemap === undefined) element.disabled = true;
                    }
                }
            }

            // Hide certain things if we only have view settings here, else show them
            if (numPrivilegeTotal == 0) {
                $cms.dom.html(matrix.querySelector('tr').cells[0], '{!USERGROUP;^}');
                for (k = 0; k < knownGroups.length; k++) {
                    document.getElementById('access_' + knownGroups[k] + '_presets').style.display = 'none';
                    var button = document.getElementById('access_' + knownGroups[k] + '_privilege_container').querySelector('button');
                    if (button) {
                        button.disabled = true;
                    }
                }
            } else {
                $cms.dom.html(matrix.querySelector('tr').cells[0], '<span class="heading_group">{!USERGROUP;^}</span> <span class="heading_presets">{!permissions:PINTERFACE_PRESETS;^}</span>');
                for (k = 0; k < knownGroups.length; k++) {
                    document.getElementById('access_' + knownGroups[k] + '_presets').style.display = 'block';
                    var button = document.getElementById('access_' + knownGroups[k] + '_privilege_container').querySelector('button');
                    if (button) {
                        button.disabled = false;
                    }
                }
            }

            // Test to see what we wouldn't have to make a change to get - and that is what we're set at
            for (k = 0; k < knownGroups.length; k++) {
                group = knownGroups[k];
                var list = document.getElementById('access_' + group + '_presets');
                if (!copyPermissionPresets('access_' + group, '0', true)) list.selectedIndex = list.options.length - 4;
                else if (!copyPermissionPresets('access_' + group, '1', true)) list.selectedIndex = list.options.length - 3;
                else if (!copyPermissionPresets('access_' + group, '2', true)) list.selectedIndex = list.options.length - 2;
                else if (!copyPermissionPresets('access_' + group, '3', true)) list.selectedIndex = list.options.length - 1;
            }
        }

        // Set correct admin colspan
        for (i = 0; i < matrix.rows.length; i++) {
            if (matrix.rows[i].cells.length == 3) {
                matrix.rows[i].cells[2].colSpan = numPrivilegeTotal + 1;
            }
        }

        document.getElementById('selection_form_fields').style.display = 'block';
        document.getElementById('selection_button').disabled = false;
        $cms.dom.html(document.getElementById('selection_message'), (values.length <= 1) ? '{!permissions:PERMISSIONS_TREE_EDITOR_ONE_SELECTED;^}' : '{!permissions:PERMISSIONS_TREE_EDITOR_MULTI_SELECTED;^}');
    }

    // Saving
    function setPermissions(setting) {
        if (!setting.value) {
            return;
        }

        // Go through and set maximum permissions/override from those selected
        var values = setting.value.split(',');
        var id, i, node, j, group, element, privilege, knownGroups = [], k, serverid, setRequest = '', setRequestB, newValue;
        for (i = 0; i < values.length; i++) {
            node = window.sitemap.getElementByIdHack(values[i]);
            serverid = node.getAttribute('serverid');

            // Find usergroups
            for (j = 0; j < node.attributes.length; j++) {
                if (node.attributes[j].name.substr(0, 7) == 'g_view_') {
                    group = node.attributes[j].name.substr(7);
                    knownGroups.push(group);
                }
            }

            setRequestB = '';

            for (j = 0; j < knownGroups.length; j++) {
                group = knownGroups[j];

                // Set view access
                element = document.getElementById('access_' + group);
                newValue = element.checked ? 'true' : 'false';
                if (newValue != node.getAttribute('g_view_' + group)) {
                    node.setAttribute('g_view_' + group, newValue);
                    setRequestB = setRequestB + '&' + i + 'g_view_' + group + '=' + ((newValue == 'true') ? 1 : 0);
                }
            }

            // Set privileges for all usergroups
            id = node.getAttribute('id');
            if (window.attributes_full === undefined) {
                window.attributes_full = [];
            }
            if (window.attributes_full[id] === undefined) {
                window.attributes_full[id] = node.attributes;
            }
            for (var name in window.attributes_full[id]) {
                var value = window.attributes_full[id][name];
                if (name.substr(0, 'privilege_'.length) == 'privilege_') {
                    for (j = 0; j < knownGroups.length; j++) {
                        group = knownGroups[j];
                        privilege = name.substr('privilege_'.length);
                        value = window.attributes_full[id]['group_privileges_' + privilege + '_' + group];
                        if (!value) value = -1;
                        element = document.getElementById('access_' + group + '_privilege_' + privilege);
                        if (element) {
                            newValue = element.selectedIndex - 1;
                            if (newValue != value) {
                                window.attributes_full[id]['group_privileges_' + privilege + '_' + group] = newValue;
                                setRequestB = setRequestB + '&' + i + 'group_privileges_' + privilege + '_' + group + '=' + newValue;
                            }
                        }
                    }
                }

                // Update UI indicators
                $cms.dom.html(document.getElementById('tree_listextra_' + id), permissionsImgFunc1(node, id) + permissionsImgFunc2(node, id));
            }

            if (setRequestB != '') setRequest = setRequest + '&map_' + i + '=' + encodeURIComponent(serverid) + setRequestB;
        }

        // Send AJAX request
        if (setRequest != '') {
            $cms.doAjaxRequest('{$BASE_URL_NOHTTP;}/data/sitemap.php?set_perms=1' + $cms.keepStub(), function () {
                $cms.ui.alert('{!permissions:PERMISSIONS_TREE_EDITOR_SAVED;^}');
            }, setRequest);
            return;
        }

        $cms.ui.alert('{!permissions:PERMISSIONS_TREE_EDITOR_SAVED;^}');
    }
}(window.$cms));
