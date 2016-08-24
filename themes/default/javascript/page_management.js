(function ($, Composr) {
    Composr.templates.pageManagement = {
        sitemapEditorScreen: function sitemapEditorScreen(options) {
            window.actions_tpl = '{!ACTIONS;/}:<nav><ul class="actions_list">[1]<\/ul><\/nav><br />';
            window.actions_tpl_item = '<li><a href="[2]">[1]<\/a><\/li>';

            window.info_tpl = '<div class="wide_table_wrap"><table class="map_table results_table wide_table autosized_table"><tbody>[1]<\/tbody><\/table><\/div>';
            window.info_tpl_item = '<tr><th>[1]<\/th><td>[2]<\/td><\/tr>';

            window.edit_zone_url = options.editZoneUrl;
            window.add_zone_url = options.addZoneUrl;
            window.zone_editor_url = options.zoneEditorUrl;
            window.permission_tree_editor_url = options.permissonTreeEditorUrl;
            window.edit_page_url = options.editPageUrl;
            window.add_page_url = options.addPageUrl;
            window.delete_url = options.deleteUrl;
            window.stats_url = options.statusUrl;
            window.move_url = options.moveUrl;

            window.sitemap = new tree_list('tree_list', 'data/sitemap.php?start_links=1&get_perms=0&label_content_types=1&keep_full_structure=1' + Composr.$KEEP, null, '', false, null, true);
        }
    };

    Composr.behaviors.pageManagement = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'page_management');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);