(function ($cms) {
    'use strict';

    var $ADDON_INSTALLED_code_editor = !!+'{$ADDON_INSTALLED,code_editor}',
        $ADDON_INSTALLED_stats = !!+'{$ADDON_INSTALLED,stats}';

    $cms.templates.sitemapEditorScreen = function sitemapEditorScreen(params, container) {
        var edit_zone_url = params.editZoneUrl,
            add_zone_url = params.addZoneUrl,
            zone_editor_url = params.zoneEditorUrl,
            permission_tree_editor_url = params.permissonTreeEditorUrl,
            edit_page_url = params.editPageUrl,
            add_page_url = params.addPageUrl,
            delete_url = params.deleteUrl,
            stats_url = params.statusUrl;

        window.sitemap = $cms.createTreeList('tree_list', 'data/sitemap.php?start_links=1&get_perms=0&label_content_types=1&keep_full_structure=1' + $cms.$KEEP(), null, '', false, null, true);

        $cms.dom.on(container, 'change', '.js-change-update-details-box', function (e, changed) {
            update_details_box(changed);
        });

        function update_details_box(element) {
            var actions_tpl = '{!ACTIONS;^}:<nav><ul class="actions_list">[1]<\/ul><\/nav><br />',
                actions_tpl_item = '<li><a href="[2]">[1]<\/a><\/li>',
                info_tpl = '<div class="wide_table_wrap"><table class="map_table results_table wide_table autosized_table"><tbody>[1]<\/tbody><\/table><\/div>',
                info_tpl_item = '<tr><th>[1]<\/th><td>[2]<\/td><\/tr>';


            if (!window.sitemap) {
                return;
            }

            var target = document.getElementById('details_target');
            if (!element.value) {
                $cms.dom.html(target, '{!zones:NO_ENTRY_POINT_SELECTED;^}');
                return;
            }

            var node = window.sitemap.getElementByIdHack(element.value);
            var type = node.getAttribute('type');
            var page_link = node.getAttribute('serverid');
            var page_link_bits = page_link.split(/:/);
            var full_type = type;
            if (full_type.includes('/')) {
                full_type = full_type.substr(0, full_type.indexOf('/'));
            }

            var action_buildup = '';
            var info_buildup = '';
            var path;
            switch (full_type) {
                case 'root':
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!zones:ADD_ZONE;^}').replace(/\[2\]/, add_zone_url);
                    break;

                case 'zone':
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!zones:ZONE_EDITOR;^}').replace(/\[2\]/, zone_editor_url.replace(/%21/, page_link.replace(/:/, '', page_link)));
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/, permission_tree_editor_url.replace(/%21/, page_link.replace(/:/, '%3A', page_link)));
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!zones:EDIT_ZONE;^}').replace(/\[2\]/, edit_zone_url.replace(/%21/, page_link.replace(/:/, '', page_link)));
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!zones:COMCODE_PAGE_ADD;^}').replace(/\[2\]/, add_page_url.replace(/%21/, page_link.replace(/:/, '', page_link)));
                    break;

                case 'modules':
                case 'modules_custom':
                case 'minimodule':
                case 'minimodule_custom':
                    path = page_link_bits[0] + ((page_link_bits[0] == '') ? '' : '/') + 'pages/' + type + '/' + page_link_bits[1] + '.php';
                    if ($ADDON_INSTALLED_code_editor && !$cms.$CONFIG_OPTION.collapse_user_zones) {
                        action_buildup += actions_tpl_item.replace(/\[1\]/, '{!EDIT;^}').replace(/\[2\]/, '{$BASE_URL;,0}/code_editor.php?path=' + encodeURIComponent(path));
                    }
                    switch (type) {
                        case 'modules':
                        case 'modules_custom':
                            action_buildup += actions_tpl_item.replace(/\[1\]/, '{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/, permission_tree_editor_url.replace(/%21/, page_link.replace(/:/, '%3A', page_link)));
                            if (node.getAttribute('author')) info_buildup += info_tpl_item.replace(/\[1\]/, '{!AUTHOR;^}').replace(/\[2\]/, $cms.filter.html(node.getAttribute('author')));
                            if (node.getAttribute('organisation')) info_buildup += info_tpl_item.replace(/\[1\]/, '{!ORGANISATION;^}').replace(/\[2\]/, $cms.filter.html(node.getAttribute('organisation')));
                            if (node.getAttribute('version')) info_buildup += info_tpl_item.replace(/\[1\]/, '{!VERSION;^}').replace(/\[2\]/, $cms.filter.html(node.getAttribute('version')));
                            break;
                        case 'minimodule':
                        case 'minimodule_custom':
                            break;
                    }
                    break;

                case 'comcode':
                case 'comcode_custom':
                    path = page_link_bits[0] + '/pages/' + full_type + '/' + page_link_bits[1] + '.txt';
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/, permission_tree_editor_url.replace(/%21/, page_link.replace(/:/, '%3A', page_link)));
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!EDIT;^}').replace(/\[2\]/, edit_page_url.replace(/%21/, page_link));
                    break;

                case 'html':
                case 'html_custom':
                    path = page_link_bits[0] + '/pages/' + full_type + '/' + page_link_bits[1] + '.htm';
                    break;

                case 'entry_point':
                    break;
            }

            // Pages
            if (['modules', 'modules_custom', 'comcode', 'comcode_custom', 'html', 'html_custom'].includes(full_type)) {
                action_buildup += actions_tpl_item.replace(/\[1\]/, '{!DELETE;^}').replace(/\[2\]/, delete_url.replace(/%5B1%5D/, page_link_bits[0]).replace(/\[2\]/, page_link_bits[1]));
                if ($ADDON_INSTALLED_stats && stats_url) {
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!stats:PAGES_STATISTICS;^}').replace(/\[2\]/, stats_url.replace(/%21/, path));
                }
            }

            // All
            if (full_type !== 'root') {
                action_buildup += actions_tpl_item.replace(/\[1\]/, '{!VIEW;^}').replace(/\[2\]/, $cms.filter.html(('{$BASE_URL;,0}/data/page_link_redirect.php?id=' + encodeURIComponent(page_link) + $cms.keepStub())));
                info_buildup += info_tpl_item.replace(/\[1\]/, '{!PAGE_LINK;^}').replace(/\[2\]/, '<kbd>' + $cms.filter.html(page_link) + '</kbd>');
                if (element.selected_editlink) {
                    action_buildup += actions_tpl_item.replace(/\[1\]/, '{!EDIT;^}').replace(/\[2\]/, $cms.filter.html('{$FIND_SCRIPT_NOHTTP;,page_link_redirect}?id=' + element.selected_editlink + $cms.keepStub()));
                }
            }

            // Output
            $cms.dom.empty(target);
            if (action_buildup) {
                var actions = document.createElement('div');
                $cms.dom.html(actions, actions_tpl.replace(/\[1\]/, action_buildup));
                target.appendChild(actions);
            }

            if (info_buildup) {
                var info = document.createElement('div');
                $cms.dom.html(info, info_tpl.replace(/\[1\]/, info_buildup));
                target.appendChild(info);
            }
        }

    };
}(window.$cms));
