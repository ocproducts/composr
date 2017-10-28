(function ($cms) {
    'use strict';

    var $ADDON_INSTALLED_code_editor = !!+'{$ADDON_INSTALLED,code_editor}',
        $ADDON_INSTALLED_stats = !!+'{$ADDON_INSTALLED,stats}';

    $cms.templates.sitemapEditorScreen = function sitemapEditorScreen(params, container) {
        var editZoneUrl = params.editZoneUrl,
            addZoneUrl = params.addZoneUrl,
            zoneEditorUrl = params.zoneEditorUrl,
            permissionTreeEditorUrl = params.permissonTreeEditorUrl,
            editPageUrl = params.editPageUrl,
            addPageUrl = params.addPageUrl,
            deleteUrl = params.deleteUrl,
            statsUrl = params.statusUrl;

        $cms.requireJavascript('tree_list').then(function () {
            window.sitemap = $cms.ui.createTreeList('tree_list', 'data/sitemap.php?start_links=1&get_perms=0&label_content_types=1&keep_full_structure=1' + $cms.$KEEP(), null, '', false, null, true);
        });

        $cms.dom.on(container, 'change', '.js-change-update-details-box', function (e, changed) {
            updateDetailsBox(changed);
        });

        function updateDetailsBox(element) {
            var actionsTpl = '{!ACTIONS;^}:<nav><ul class="actions_list">[1]<\/ul><\/nav><br />',
                actionsTplItem = '<li><a href="[2]">[1]<\/a><\/li>',
                infoTpl = '<div class="wide_table_wrap"><table class="map_table results_table wide_table autosized_table"><tbody>[1]<\/tbody><\/table><\/div>',
                infoTplItem = '<tr><th>[1]<\/th><td>[2]<\/td><\/tr>';


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
            var pageLink = node.getAttribute('serverid');
            var pageLinkBits = pageLink.split(/:/);
            var fullType = type;
            if (fullType.includes('/')) {
                fullType = fullType.substr(0, fullType.indexOf('/'));
            }

            var actionBuildup = '';
            var infoBuildup = '';
            var path;
            switch (fullType) {
                case 'root':
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!zones:ADD_ZONE;^}').replace(/\[2\]/, addZoneUrl);
                    break;

                case 'zone':
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!zones:ZONE_EDITOR;^}').replace(/\[2\]/, zoneEditorUrl.replace(/%21/, pageLink.replace(/:/, '', pageLink)));
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/, permissionTreeEditorUrl.replace(/%21/, pageLink.replace(/:/, '%3A', pageLink)));
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!zones:EDIT_ZONE;^}').replace(/\[2\]/, editZoneUrl.replace(/%21/, pageLink.replace(/:/, '', pageLink)));
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!zones:COMCODE_PAGE_ADD;^}').replace(/\[2\]/, addPageUrl.replace(/%21/, pageLink.replace(/:/, '', pageLink)));
                    break;

                case 'modules':
                case 'modules_custom':
                case 'minimodule':
                case 'minimodule_custom':
                    path = pageLinkBits[0] + ((pageLinkBits[0] == '') ? '' : '/') + 'pages/' + type + '/' + pageLinkBits[1] + '.php';
                    if ($ADDON_INSTALLED_code_editor && !$cms.$CONFIG_OPTION('collapse_user_zones')) {
                        actionBuildup += actionsTplItem.replace(/\[1\]/, '{!EDIT;^}').replace(/\[2\]/, '{$BASE_URL;,0}/code_editor.php?path=' + encodeURIComponent(path));
                    }
                    switch (type) {
                        case 'modules':
                        case 'modules_custom':
                            actionBuildup += actionsTplItem.replace(/\[1\]/, '{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/, permissionTreeEditorUrl.replace(/%21/, pageLink.replace(/:/, '%3A', pageLink)));
                            if (node.getAttribute('author')) infoBuildup += infoTplItem.replace(/\[1\]/, '{!AUTHOR;^}').replace(/\[2\]/, $cms.filter.html(node.getAttribute('author')));
                            if (node.getAttribute('organisation')) infoBuildup += infoTplItem.replace(/\[1\]/, '{!ORGANISATION;^}').replace(/\[2\]/, $cms.filter.html(node.getAttribute('organisation')));
                            if (node.getAttribute('version')) infoBuildup += infoTplItem.replace(/\[1\]/, '{!VERSION;^}').replace(/\[2\]/, $cms.filter.html(node.getAttribute('version')));
                            break;
                        case 'minimodule':
                        case 'minimodule_custom':
                            break;
                    }
                    break;

                case 'comcode':
                case 'comcode_custom':
                    path = pageLinkBits[0] + '/pages/' + fullType + '/' + pageLinkBits[1] + '.txt';
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/, permissionTreeEditorUrl.replace(/%21/, pageLink.replace(/:/, '%3A', pageLink)));
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!EDIT;^}').replace(/\[2\]/, editPageUrl.replace(/%21/, pageLink));
                    break;

                case 'html':
                case 'html_custom':
                    path = pageLinkBits[0] + '/pages/' + fullType + '/' + pageLinkBits[1] + '.htm';
                    break;

                case 'entry_point':
                    break;
            }

            // Pages
            if (['modules', 'modules_custom', 'comcode', 'comcode_custom', 'html', 'html_custom'].includes(fullType)) {
                actionBuildup += actionsTplItem.replace(/\[1\]/, '{!DELETE;^}').replace(/\[2\]/, deleteUrl.replace(/%5B1%5D/, pageLinkBits[0]).replace(/\[2\]/, pageLinkBits[1]));
                if ($ADDON_INSTALLED_stats && statsUrl) {
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!stats:PAGES_STATISTICS;^}').replace(/\[2\]/, statsUrl.replace(/%21/, path));
                }
            }

            // All
            if (fullType !== 'root') {
                actionBuildup += actionsTplItem.replace(/\[1\]/, '{!VIEW;^}').replace(/\[2\]/, $cms.filter.html(('{$BASE_URL;,0}/data/page_link_redirect.php?id=' + encodeURIComponent(pageLink) + $cms.$KEEP())));
                infoBuildup += infoTplItem.replace(/\[1\]/, '{!zones:PAGE_LINK;^}').replace(/\[2\]/, '<kbd>' + $cms.filter.html(pageLink) + '</kbd>');
                if (element.selectedEditlink) {
                    actionBuildup += actionsTplItem.replace(/\[1\]/, '{!EDIT;^}').replace(/\[2\]/, $cms.filter.html('{$FIND_SCRIPT_NOHTTP;,page_link_redirect}?id=' + element.selectedEditlink + $cms.$KEEP()));
                }
            }

            // Output
            $cms.dom.empty(target);
            if (actionBuildup) {
                var actions = document.createElement('div');
                $cms.dom.html(actions, actionsTpl.replace(/\[1\]/, actionBuildup));
                target.appendChild(actions);
            }

            if (infoBuildup) {
                var info = document.createElement('div');
                $cms.dom.html(info, infoTpl.replace(/\[1\]/, infoBuildup));
                target.appendChild(info);
            }
        }

    };
}(window.$cms));