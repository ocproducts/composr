<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    stats_block
 */

/**
 * Hook class.
 */
class Hook_addon_registry_stats_block
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
     * Get the description of the addon.
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'A block to show a selection of your website statistics to your visitors.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_statistics',
        );
    }

    /**
     * Get a mapping of dependency types.
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(),
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
        return 'themes/default/images/icons/48x48/menu/_generic_admin/component.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources/hooks/systems/config/activity_show_stats_count_page_views_this_month.php',
            'sources/hooks/systems/config/activity_show_stats_count_page_views_this_week.php',
            'sources/hooks/systems/config/activity_show_stats_count_page_views_today.php',
            'sources/hooks/systems/config/activity_show_stats_count_users_online.php',
            'sources/hooks/systems/config/activity_show_stats_count_users_online_forum.php',
            'sources/hooks/systems/config/activity_show_stats_count_users_online_record.php',
            'sources/hooks/systems/config/forum_show_stats_count_members.php',
            'sources/hooks/systems/config/forum_show_stats_count_members_active_this_month.php',
            'sources/hooks/systems/config/forum_show_stats_count_members_active_this_week.php',
            'sources/hooks/systems/config/forum_show_stats_count_members_active_today.php',
            'sources/hooks/systems/config/forum_show_stats_count_members_new_this_month.php',
            'sources/hooks/systems/config/forum_show_stats_count_members_new_this_week.php',
            'sources/hooks/systems/config/forum_show_stats_count_members_new_today.php',
            'sources/hooks/systems/config/forum_show_stats_count_posts.php',
            'sources/hooks/systems/config/forum_show_stats_count_posts_today.php',
            'sources/hooks/systems/config/forum_show_stats_count_topics.php',
            'sources/hooks/systems/addon_registry/stats_block.php',
            'sources/hooks/modules/admin_setupwizard/stats_block.php',
            'themes/default/templates/BLOCK_SIDE_STATS_SECTION.tpl',
            'themes/default/templates/BLOCK_SIDE_STATS_SUBLINE.tpl',
            'themes/default/templates/BLOCK_SIDE_STATS.tpl',
            'sources/blocks/side_stats.php',
            'sources/hooks/blocks/side_stats/forum.php',
            'sources/hooks/blocks/side_stats/.htaccess',
            'sources_custom/hooks/blocks/side_stats/.htaccess',
            'sources/hooks/blocks/side_stats/index.html',
            'sources_custom/hooks/blocks/side_stats/index.html',
        );
    }

    /**
     * Get mapping between template names and the method of this class that can render a preview of them.
     *
     * @return array The mapping
     */
    public function tpl_previews()
    {
        return array(
            'templates/BLOCK_SIDE_STATS_SUBLINE.tpl' => 'block_side_stats',
            'templates/BLOCK_SIDE_STATS_SECTION.tpl' => 'block_side_stats',
            'templates/BLOCK_SIDE_STATS.tpl' => 'block_side_stats',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__block_side_stats()
    {
        $full_tpl = new Tempcode();
        $bits = new Tempcode();
        foreach (placeholder_array() as $v) {
            $bits->attach(do_lorem_template('BLOCK_SIDE_STATS_SUBLINE', array(
                'KEY' => lorem_phrase(),
                'VALUE' => placeholder_number(),
            )));
        }
        $full_tpl->attach(do_lorem_template('BLOCK_SIDE_STATS_SECTION', array(
            'SECTION' => lorem_phrase(),
            'CONTENT' => $bits,
        )));

        return array(
            lorem_globalise(do_lorem_template('BLOCK_SIDE_STATS', array(
                'BLOCK_ID' => lorem_word(),
                'CONTENT' => $full_tpl,
            )), null, '', true)
        );
    }
}
