<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    twitter_support
 */

/**
 * Hook class.
 */
class Hook_addon_registry_twitter_support
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
        return 'Chris Graham';
    }

    /**
     * Find other authors
     *
     * @return array A list of co-authors that should be attributed
     */
    public function get_copyright_attribution()
    {
        return array(
            'Icon by leslienayibe',
            'Class by Tijs Verkoyen',
        );
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
        return 'Syndicate site activities to Twitter.

This addon sits on top of the activity feed addon to syndicate out logged activities to the user\'s associated twitter account (if they have one).

The code is based on \'Twitter class\' by \'Tijs Verkoyen\'.

Set up is a little tricky, you need to set up an application on Twitter, and authorise the site to it via the option on the Admin Zone drop-down menu. Setting up the application is explained by the configuration options.';
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
            'requires' => array(
                'PHP CuRL extension',
            ),
            'recommends' => array('activity_feed'),
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
        return 'themes/default/images_custom/icons/48x48/menu/twitter.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'themes/default/images_custom/icons/24x24/menu/twitter.png',
            'themes/default/images_custom/icons/48x48/menu/twitter.png',
            'sources_custom/hooks/systems/addon_registry/twitter_support.php',
            'sources_custom/twitter.php',
            'adminzone/pages/minimodules_custom/twitter_oauth.php',
            'lang_custom/EN/twitter.ini',
            'sources_custom/hooks/systems/syndication/twitter.php',
            'sources_custom/hooks/systems/page_groupings/twitter.php',
            'sources_custom/hooks/systems/config/twitter_api_key.php',
            'sources_custom/hooks/systems/config/twitter_api_secret.php',
        );
    }
}
