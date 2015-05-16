<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite
 */

/**
 * Hook class.
 */
class Hook_addon_registry_composr_homesite
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
        return 'Development';
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
        return 'The Composr deployment/hosting platform. The hosting side of the build addon (composr_release_build).';
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
                'downloads',
            ),
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
        return 'themes/default/images/icons/48x48/menu/_generic_admin/tool.png';
    }

    /**
     * Get a list of files that belong to this addon
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/composr_homesite.php',
            'adminzone/pages/modules_custom/admin_cmsusers.php',
            'adminzone/pages/minimodules_custom/_make_release.php',
            'sources_custom/hooks/systems/page_groupings/composr_homesite.php',
            'data_custom/composr_homesite_web_service.php',
            'lang_custom/EN/sites.ini',
            'lang_custom/EN/composr_homesite.ini',
            'pages/minimodules_custom/licence.php',
            'site/pages/modules_custom/sites.php',
            'sources_custom/composr_homesite.php',
            'sources_custom/hooks/systems/cron/site_cleanup.php',
            'uploads/website_specific/compo.sr/demonstratr/template.sql',
            'uploads/website_specific/compo.sr/demonstratr/template.tar',
            'data_custom/demonstratr_upgrade.php',
            'sources_custom/cns_forumview.php',
            'sources_custom/errorservice.php',
            'sources_custom/miniblocks/composr_homesite_featuretray.php',
            'sources_custom/miniblocks/composr_homesite_download.php',
            'themes/default/images_custom/help_small.gif',
            'sources_custom/miniblocks/composr_homesite_make_upgrader.php',
            'themes/default/templates_custom/CMS_NEW_WEBSITE.tpl',
            'themes/default/templates_custom/CMS_DOWNLOAD_RELEASES.tpl',
            'themes/default/templates_custom/CMS_DOWNLOAD_BLOCK.tpl',
            'themes/default/templates_custom/CMS_HOSTING_COPY_SUCCESS_SCREEN.tpl',
            'themes/default/templates_custom/CMS_SITE.tpl',
            'themes/default/templates_custom/CMS_SITES_SCREEN.tpl',
            'uploads/website_specific/compo.sr/.htaccess',
            'uploads/website_specific/compo.sr/logos',
            'uploads/website_specific/compo.sr/logos/a.png',
            'uploads/website_specific/compo.sr/logos/b.png',
            'uploads/website_specific/compo.sr/logos/choice.php',
            'uploads/website_specific/compo.sr/logos/default.png',
            'uploads/website_specific/compo.sr/logos/index.html',
            'uploads/website_specific/compo.sr/scripts/addon_manifest.php',
            'uploads/website_specific/compo.sr/scripts/errorservice.php',
            'uploads/website_specific/compo.sr/scripts/fetch_release_details.php',
            'uploads/website_specific/compo.sr/scripts/newsletter_join.php',
            'uploads/website_specific/compo.sr/scripts/user.php',
            'uploads/website_specific/compo.sr/scripts/version.php',
            'uploads/website_specific/compo.sr/upgrades/make_upgrader.php',
            'uploads/website_specific/compo.sr/upgrades/tarring.log',
        );
    }
}
