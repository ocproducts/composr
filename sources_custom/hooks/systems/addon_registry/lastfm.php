<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    lastfm
 */

/**
 * Hook class.
 */
class Hook_addon_registry_lastfm
{
    /**
     * Get a list of file permissions to set
     *
     * @return array File permissions to set
     */
    public function get_chmod_array()
    {
        return array();
    }

    /**
     * Get the version of Composr this addon is for
     *
     * @return float Version number
     */
    public function get_version()
    {
        return cms_version_number();
    }

    /**
     * Get the addon category
     *
     * @return string The category
     */
    public function get_category()
    {
        return 'Third Party Integration';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Kamen Blaginov';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array();
    }

    /**
     * Get the addon licence (one-line summary only)
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'Licensed on the same terms as Composr';
    }

    /**
     * Get the description of the addon
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'A top LastFM playlist on a panel. This displays top artists, top albums or top tracks. Block parameters are someone\'s LastFM username, top rank list period of time (3, 6 or 12 months), and what chart to be displayed (artists, albums or tracks chart).

You will need your Username for Last FM, and you will need to decide how long you want the block to check back, \"3\", \"6\",\"12\" months. Also you will need to decide whether you want to show favourite \"artists\", \"albums\" or \"tracks\". The example code will look something like:
[code=\"Comcode\"][block username=\"Sjarvis78\" period=\"12\" display=\"albums\" height=\"300px\"]side_last_fm[/block][/code]

Period is just the number of the chosen months \"3\", \"6\" or \"12\" and the display is \"artists\", \"albums\" or \"tracks\". You can also specify the height and width as above.';
    }

    /**
     * Get a list of tutorials that apply to this addon
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array();
    }

    /**
     * Get a mapping of dependency types
     *
     * @return array File permissions to set
     */
    public function get_dependencies()
    {
        return array(
            'requires' => array(),
            'recommends' => array(),
            'conflicts_with' => array()
        );
    }

    /**
     * Explicitly say which icon should be used
     *
     * @return URLPATH Icon
     */
    public function get_default_icon()
    {
        return 'themes/default/images/icons/48x48/menu/_generic_admin/component.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/lastfm.php',
            'sources_custom/blocks/side_last_fm.php',
            'lang_custom/EN/last_fm.ini',
            'themes/default/templates_custom/BLOCK_SIDE_LAST_FM.tpl',
        );
    }
}
