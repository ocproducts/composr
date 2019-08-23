<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    google_analytics
 */

/**
 * Hook class.
 */
class Hook_addon_registry_google_analytics
{
    /**
     * Get a list of file permissions to set.
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for.
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the addon category.
     *
     * @return string The category
     */
    public function get_category()
    {
        return 'Development';
    }

    /**
     * Get the addon author.
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Chris Graham';
    }

    /**
     * Find other authors.
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array();
    }

    /**
     * Get the addon licence (one-line summary only).
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'Licensed on the same terms as Composr';
    }

    /**
     * Get the description of the addon.
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Adds Google Analytics to the stats addon, and adds a block for showing analytic data of your choice (suggested for adding to the Admin Zone dashboard).

This addon is a little hard to configure (hence being filed as a Developer addon), but works well.

Instructions...
[list="1"]
[*] Set up oAuth for Google Analytics at Admin Zone > Setup > Setup API Access. You can also consider Google Search Console, as we will pull keyword data from there if configured.
[*] Find the numeric ID of the Google Analytics property you need to integrate with (e.g. 12345678), then run this Commandr command: [code="Commander"]set_value(\'ga_property_id\', \'12345678\', true);[/code]. Note this number has nothing to do with the identifier that starts [tt]UA[/tt].
[*] To use the block on the dashboard, use this Comcode:
[code="Comcode"]
[block]main_staff_google_analytics[/block]
[/code]

There are [i]metric[/i] and [i]days[/i] parameters you may want to use:
 - [b]metric[/b] is a comma-separated list of any of the following: [tt]hits[/tt], [tt]speed[/tt], [tt]browsers[/tt], [tt]device_types[/tt], [tt]screen_sizes[/tt], [tt]countries[/tt], [tt]languages[/tt], [tt]referrers[/tt], [tt]referrers_social[/tt], [tt]referral_mediums[/tt], [tt]popular_pages[/tt], [tt]keywords[/tt]. [tt]keywords[/tt] is only available if Google Search Console is configured. If you don\'t specify this parameter it will default to a reasonable selection.
 - [b]days[/b] is a number, the number of days to show data for (initially). If you don\'t specify this parameter it will default to 31.
[/list]

You can always see all metrics from Admin Zone > Audit > Site statistics > Google Analytics.
';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array();
    }

    /**
     * Get a mapping of dependency types.
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(
                'stats',
            ),
            'recommends' => array(),
            'conflicts_with' => array(),
        );
    }

    /**
     * Explicitly say which icon should be used.
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/buttons/search.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/google_analytics.php',
            'lang_custom/EN/google_analytics.ini',
            'sources_custom/google_analytics.php',
            'sources_custom/hooks/modules/admin_stats/google_analytics.php',
            'sources_custom/hooks/systems/snippets/google_search_console.php',
            'sources_custom/miniblocks/main_staff_google_analytics.php',
            'themes/default/templates_custom/GOOGLE_ANALYTICS.tpl',
            'themes/default/templates_custom/GOOGLE_ANALYTICS_TABS.tpl',
            'themes/default/templates_custom/GOOGLE_SEARCH_CONSOLE_KEYWORDS.tpl',
            'themes/default/templates_custom/_GOOGLE_TIME_PERIODS.tpl',
            'themes/default/javascript_custom/google_analytics.js',
        );
    }
}
