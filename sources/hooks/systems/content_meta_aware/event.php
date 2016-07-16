<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    calendar
 */

/**
 * Hook class.
 */
class Hook_content_meta_aware_event
{
    /**
     * Get content type details. Provides information to allow task reporting, randomisation, and add-screen linking, to function.
     *
     * @param  ?ID_TEXT $zone The zone to link through to (null: autodetect).
     * @return ?array Map of award content-type info (null: disabled).
     */
    public function info($zone = null)
    {
        return array(
            'support_custom_fields' => true,

            'content_type_label' => 'calendar:EVENT',
            'content_type_universal_label' => 'Calendar event',

            'db' => $GLOBALS['SITE_DB'],
            'table' => 'calendar_events',
            'id_field' => 'id',
            'id_field_numeric' => true,
            'parent_category_field' => 'e_type',
            'parent_category_meta_aware_type' => 'calendar_type',
            'is_category' => false,
            'is_entry' => true,
            'category_field' => 'e_type', // For category permissions
            'category_type' => 'calendar', // For category permissions
            'parent_spec__table_name' => 'calendar_types',
            'parent_spec__parent_name' => null,
            'parent_spec__field_name' => 'id',
            'category_is_string' => false,

            'title_field' => 'e_title',
            'title_field_dereference' => true,
            'description_field' => 'e_content',
            'thumb_field' => null,
            'thumb_field_is_theme_image' => false,
            'alternate_icon_theme_image' => 'icons/48x48/menu/rich_content/calendar',

            'view_page_link_pattern' => '_SEARCH:calendar:view:_WILD',
            'edit_page_link_pattern' => '_SEARCH:cms_calendar:_edit:_WILD',
            'view_category_page_link_pattern' => '_SEARCH:calendar:browse:_WILD',
            'add_url' => (function_exists('has_submit_permission') && has_submit_permission('mid', get_member(), get_ip_address(), 'cms_calendar')) ? (get_module_zone('cms_calendar') . ':cms_calendar:add') : null,
            'archive_url' => ((!is_null($zone)) ? $zone : get_module_zone('calendar')) . ':calendar',

            'support_url_monikers' => true,

            'views_field' => 'e_views',
            'order_field' => null,
            'submitter_field' => 'e_submitter',
            'author_field' => null,
            'add_time_field' => 'e_add_date',
            'edit_time_field' => 'e_edit_date',
            'date_field' => 'e_add_date',
            'validated_field' => 'validated',

            'seo_type_code' => 'event',

            'feedback_type_code' => 'events',

            'permissions_type_code' => null, // null if has no permissions

            'search_hook' => 'calendar',
            'rss_hook' => 'calendar',
            'attachment_hook' => 'calendar',
            'unvalidated_hook' => 'calendar',
            'notification_hook' => 'calendar_event',
            'sitemap_hook' => 'event',

            'addon_name' => 'calendar',

            'cms_page' => 'cms_calendar',
            'module' => 'calendar',

            'commandr_filesystem_hook' => 'calendar',
            'commandr_filesystem__is_folder' => false,

            'support_revisions' => false,

            'support_privacy' => true,

            'support_content_reviews' => true,

            'actionlog_regexp' => '\w+_EVENT',
        );
    }

    /**
     * Run function for content hooks. Renders a content box for an award/randomisation.
     *
     * @param  array $row The database row for the content
     * @param  ID_TEXT $zone The zone to display in
     * @param  boolean $give_context Whether to include context (i.e. say WHAT this is, not just show the actual content)
     * @param  boolean $include_breadcrumbs Whether to include breadcrumbs (if there are any)
     * @param  ?ID_TEXT $root Virtual root to use (null: none)
     * @param  boolean $attach_to_url_filter Whether to copy through any filter parameters in the URL, under the basis that they are associated with what this box is browsing
     * @param  ID_TEXT $guid Overridden GUID to send to templates (blank: none)
     * @return Tempcode Results
     */
    public function run($row, $zone, $give_context = true, $include_breadcrumbs = true, $root = null, $attach_to_url_filter = false, $guid = '')
    {
        require_code('calendar');

        return render_event_box($row, $zone, $give_context, $guid);
    }
}
