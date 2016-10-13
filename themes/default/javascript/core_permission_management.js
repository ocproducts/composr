(function ($cms) {
    'use strict';

    function PermissionsTreeEditorScreen(options) {
        PermissionsTreeEditorScreen.base(this, arguments);

        window.column_color = options.color;
        window.usergroup_titles = options.usergroups;
        window.sitemap = $cms.createTreeList('tree_list', 'data/sitemap.php?start_links=1&get_perms=1&label_content_types=1&keep_full_structure=1' + $cms.$KEEP, null, '', true);
    }

    $cms.inherits(PermissionsTreeEditorScreen, $cms.View, {
        events: {
            'click .js-click-update-group': 'updateGroupDisplayer',
            'change .js-change-update-group': 'updateGroupDisplayer',
            'click .js-click-set-permissions': 'setPermissions',
            'change: .js-change-update-perm-box': 'updatePermissionBox'
        },

        updateGroupDisplayer: function (e, select) {
            $cms.dom.html(document.getElementById('group_name'), escape_html(window.usergroup_titles[select.options[select.selectedIndex].value]));
            var tree = document.getElementById('tree_list__root_tree_list');
            $cms.dom.html(tree, '');
            window.sitemap.renderTree(window.sitemap.tree_list_data, tree);
        },

        setPermissions: function () {
            set_permissions(document.getElementById('tree_list'));
        },

        updatePermissionBox: function (e, target) {
            update_permission_box(target);
        }
    });

    $cms.views.PermissionsTreeEditorScreen = PermissionsTreeEditorScreen;

    // Selection changed, so update box
    function update_permission_box(setting) {
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
        var id, name, value, i, node, j, group, element, privilege, privilege_title, known_groups = [], known_privileges = [], k, html, new_option, num_privilege_default, num_privilege, ths, tds, cells, new_cell, row;
        var matrix = document.getElementById('enter_the_matrix').querySelector('table');
        var num_privilege_total = 0;
        var is_cms = null;
        var rows = matrix.getElementsByTagName('tr');
        var done_header = false;
        for (i = 0; i < values.length; i++) {// For all items that we are loading permissions for (we usually just do it for one, but sometimes we load whole sets if we are batch setting permissions)
            node = window.sitemap.getElementByIdHack(values[i]);

            if (i === 0) {// On first iteration we do a cleanup

                // Find usergroups
                for (j = 0; j < node.attributes.length; j++) {
                    if (node.attributes[j].name.substr(0, 7) == 'g_view_') {
                        group = node.attributes[j].name.substr(7);
                        known_groups.push(group);
                    }
                }

                // Blank out everything in the permissions box, remove all privileges
                for (j = 0; j < known_groups.length; j++) {
                    group = known_groups[j];
                    element = document.getElementById('access_' + group);
                    element.checked = false;
                    element = document.getElementById('access_' + group + '_presets');
                    if (element.options[0].id != 'access_' + group + '_custom_option') {
                        new_option = document.createElement('option');
                        $cms.dom.html(new_option, '{!permissions:PINTERFACE_LEVEL_CUSTOM;^}');
                        new_option.id = 'access_' + group + '_custom_option';
                        new_option.value = '';
                        element.insertBefore(new_option, element.options[0]);
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

            if (node.getAttribute('serverid').includes(':cms_') && (is_cms !== false)) {
                is_cms = true;
            } else {
                is_cms = false;
            }

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
            var no_view_settings = (node.getAttribute('serverid') == '_root') || (node.getAttribute('serverid').substr(0, 22) == 'cms:cms_comcode_pages:');
            for (j = 0; j < form.elements.length; j++) {
                element = form.elements[j];
                if (element.id.substr(0, 7) == 'access_') {
                    element.style.display = ((values.length == 1) && (no_view_settings)) ? 'none' : 'inline';
                    element.disabled = (element.name == '_ignore') || ((values.length == 1) && (no_view_settings));
                }
            }

            // Create privilege nodes
            num_privilege = 0;
            known_privileges = [];
            id = node.getAttribute('id');
            if (window.attributes_full === undefined) window.attributes_full = [];
            if (window.attributes_full[id] === undefined) window.attributes_full[id] = node.attributes;
            for (name in window.attributes_full[id]) {
                value = window.attributes_full[id][name];
                if (name.substr(0, 'privilege_'.length) == 'privilege_') {
                    privilege = name.substr('privilege_'.length);
                    privilege_title = value;
                    done_header = false;
                    for (k = 0; k < rows.length; k++) {
                        if (rows[k].id.substr(0, 7) != 'access_') continue;

                        group = rows[k].id.substring(7, rows[k].id.indexOf('_privilege_container'));

                        element = document.getElementById('access_' + group + '_privilege_' + privilege);
                        if (!element) // We haven't added it yet for one of the resources we're doing permissions for
                        {
                            if (!done_header) {
                                row = rows[0];
                                new_cell = row.insertBefore(document.createElement('th'), row.cells[row.cells.length]);
                                new_cell.className = 'privilege_header';
                                $cms.dom.html(new_cell, '<img class="gd_text" data-gd-text="1" src="' + $cms.$BASE_URL + '/data/gd_text.php?color=' + window.column_color + '&amp;text=' + encodeURIComponent(privilege_title) + escape_html(keep_stub()) + '" title="' + escape_html(privilege_title) + '" alt="' + escape_html(privilege_title) + '" />');

                                rows[rows.length - 1].appendChild(document.createElement('td')).className = 'form_table_field_input privilege_footer'; // Footer cell

                                num_privilege_total++;

                                done_header = true;
                            }

                            // Manually build up cell
                            row = document.getElementById('access_' + group + '_privilege_container');
                            new_cell = row.insertBefore(document.createElement('td'), row.cells[row.cells.length - 1]);
                            new_cell.className = 'form_table_field_input privilege_cell';
                            if (document.getElementById('access_' + group).name != '_ignore') {
                                $cms.dom.html(new_cell, '<div class="accessibility_hidden"><label for="access_' + group + '_privilege_' + privilege + '">{!permissions:OVERRIDE;^}</label></div><select title="' + escape_html(privilege_title) + '" onmouseover="if (this.options[this.selectedIndex].value==\'-1\') show_permission_setting(this,event);" id="access_' + group + '_privilege_' + privilege + '" name="access_' + group + '_privilege_' + privilege + '"><option selected="selected" value="-1">/</option><option value="0">{!permissions:NO_COMPACT;^}</option><option value="1">{!permissions:YES_COMPACT;^}</option></select>');

                                element = document.getElementById('access_' + group + '_privilege_' + privilege);

                                setup_privilege_override_selector('access_' + group, '-1', privilege, privilege_title, false);
                            }
                        }
                        if (element)
                            element.options[0].disabled = ((values.length == 1) && (node.getAttribute('serverid') == '_root'));
                    }
                    known_privileges.push(privilege);
                    num_privilege++;
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
            for (k = 0; k < known_groups.length; k++) {
                group = known_groups[k];
                num_privilege_default = 0;
                for (j = 0; j < known_privileges.length; j++) {
                    element = document.getElementById('access_' + group + '_privilege_' + known_privileges[j]);
                    if (element.selectedIndex == 0) num_privilege_default++;
                }
                if (num_privilege_default == num_privilege) {
                    element = document.getElementById('access_' + group + '_presets');
                    element.selectedIndex = 1;
                    cleanup_permission_list('access_' + group);
                    for (j = 0; j < known_privileges.length; j++) {
                        element = document.getElementById('access_' + group + '_privilege_' + known_privileges[j]);
                        if (window.sitemap === undefined) element.disabled = true;
                    }
                }
            }

            // Hide certain things if we only have view settings here, else show them
            if (num_privilege_total == 0) {
                $cms.dom.html(matrix.querySelector('tr').cells[0], '{!USERGROUP;^}');
                for (k = 0; k < known_groups.length; k++) {
                    document.getElementById('access_' + known_groups[k] + '_presets').style.display = 'none';
                    var button = document.getElementById('access_' + known_groups[k] + '_privilege_container').querySelector('button');
                    if (button) {
                        button.disabled = true;
                    }
                }
            } else {
                $cms.dom.html(matrix.querySelector('tr').cells[0], '<span class="heading_group">{!USERGROUP;^}</span> <span class="heading_presets">{!permissions:PINTERFACE_PRESETS;^}</span>');
                for (k = 0; k < known_groups.length; k++) {
                    document.getElementById('access_' + known_groups[k] + '_presets').style.display = 'block';
                    var button = document.getElementById('access_' + known_groups[k] + '_privilege_container').querySelector('button');
                    if (button) {
                        button.disabled = false;
                    }
                }
            }

            // Test to see what we wouldn't have to make a change to get - and that is what we're set at
            for (k = 0; k < known_groups.length; k++) {
                group = known_groups[k];
                var list = document.getElementById('access_' + group + '_presets');
                if (!copy_permission_presets('access_' + group, '0', true)) list.selectedIndex = list.options.length - 4;
                else if (!copy_permission_presets('access_' + group, '1', true)) list.selectedIndex = list.options.length - 3;
                else if (!copy_permission_presets('access_' + group, '2', true)) list.selectedIndex = list.options.length - 2;
                else if (!copy_permission_presets('access_' + group, '3', true)) list.selectedIndex = list.options.length - 1;
            }
        }

        // Set correct admin colspan
        for (var i = 0; i < matrix.rows.length; i++) {
            if (matrix.rows[i].cells.length == 3) {
                matrix.rows[i].cells[2].colSpan = num_privilege_total + 1;
            }
        }

        document.getElementById('selection_form_fields').style.display = 'block';
        document.getElementById('selection_button').disabled = false;
        $cms.dom.html(document.getElementById('selection_message'), (values.length <= 1) ? '{!permissions:PERMISSIONS_TREE_EDITOR_ONE_SELECTED;^}' : '{!permissions:PERMISSIONS_TREE_EDITOR_MULTI_SELECTED;^}');
    }

    // Saving
    function set_permissions(setting) {
        if (!setting.value) {
            return;
        }

        // Go through and set maximum permissions/override from those selected
        var values = setting.value.split(',');
        var id, i, node, j, group, element, privilege, known_groups = [], k, serverid, set_request = '', set_request_b, new_value;
        for (i = 0; i < values.length; i++) {
            node = window.sitemap.getElementByIdHack(values[i]);
            serverid = node.getAttribute('serverid');

            // Find usergroups
            for (j = 0; j < node.attributes.length; j++) {
                if (node.attributes[j].name.substr(0, 7) == 'g_view_') {
                    group = node.attributes[j].name.substr(7);
                    known_groups.push(group);
                }
            }

            set_request_b = '';

            for (j = 0; j < known_groups.length; j++) {
                group = known_groups[j];

                // Set view access
                element = document.getElementById('access_' + group);
                new_value = element.checked ? 'true' : 'false';
                if (new_value != node.getAttribute('g_view_' + group)) {
                    node.setAttribute('g_view_' + group, new_value);
                    set_request_b = set_request_b + '&' + i + 'g_view_' + group + '=' + ((new_value == 'true') ? 1 : 0);
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
                    for (j = 0; j < known_groups.length; j++) {
                        group = known_groups[j];
                        privilege = name.substr('privilege_'.length);
                        value = window.attributes_full[id]['group_privileges_' + privilege + '_' + group];
                        if (!value) value = -1;
                        element = document.getElementById('access_' + group + '_privilege_' + privilege);
                        if (element) {
                            new_value = element.selectedIndex - 1;
                            if (new_value != value) {
                                window.attributes_full[id]['group_privileges_' + privilege + '_' + group] = new_value;
                                set_request_b = set_request_b + '&' + i + 'group_privileges_' + privilege + '_' + group + '=' + new_value;
                            }
                        }
                    }
                }

                // Update UI indicators
                $cms.dom.html(document.getElementById('tree_listextra_' + id), permissions_img_func_1(node, id) + permissions_img_func_2(node, id));
            }

            if (set_request_b != '') set_request = set_request + '&map_' + i + '=' + encodeURIComponent(serverid) + set_request_b;
        }

        // Send AJAX request
        if (set_request != '') {
            do_ajax_request('{$BASE_URL_NOHTTP;}/data/sitemap.php?set_perms=1' + keep_stub(), function () {
                window.fauxmodal_alert('{!permissions:PERMISSIONS_TREE_EDITOR_SAVED;^}');
            }, set_request);
            return;
        }

        window.fauxmodal_alert('{!permissions:PERMISSIONS_TREE_EDITOR_SAVED;^}');
    }
}(window.$cms));
