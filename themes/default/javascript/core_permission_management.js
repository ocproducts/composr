(function ($, Composr) {
    'use strict';

    Composr.templates.corePermissionManagement = {
        permissionsTreeEditorScreen: function permissionsTreeEditorScreen(options) {
            window.column_color = options.color;
            window.usergroup_titles = options.usergroups;
            window.sitemap = new tree_list('tree_list', 'data/sitemap.php?start_links=1&get_perms=1&label_content_types=1&keep_full_structure=1' + Composr.$KEEP, null, '', true);

        }
    };

    Composr.behaviors.corePermissionManagement = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_permission_management');
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);
