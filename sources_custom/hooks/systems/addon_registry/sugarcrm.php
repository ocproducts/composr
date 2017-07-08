<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

/**
 * Hook class.
 */
class Hook_addon_registry_sugarcrm
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
        return 'Third Party Integration';
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
        return array('Asa Kusuma');
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
        return 'Sync new accounts into SugarCRM (Accounts and Contacts), and contact form messages into SugarCRM (Cases or Leads). Form messages are taken from [tt]main_contact_simple[/tt] block, [tt]main_contact_catalogues[/tt] block, and [tt]form_to_email.php[/tt].';
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
            'requires' => array('cURL'),
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
        return 'themes/default/images/icons/48x48/menu/_generic_admin/sync.png';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/sugarcrm.php',
            'sources_custom/hooks/systems/contact_forms/sugarcrm.php',
            'sources_custom/hooks/systems/upon_query/sugarcrm.php',
            'sources_custom/hooks/systems/config/sugarcrm_username.php',
            'sources_custom/hooks/systems/config/sugarcrm_password.php',
            'sources_custom/hooks/systems/config/sugarcrm_base_url.php',
            'sources_custom/hooks/systems/config/sugarcrm_exclusive_messaging.php',
            'sources_custom/hooks/systems/config/sugarcrm_contact_mappings.php',
            'sources_custom/hooks/systems/config/sugarcrm_sync_type.php',
            'sources_custom/hooks/systems/config/sugarcrm_case_mappings.php',
            'sources_custom/hooks/systems/config/sugarcrm_company_field.php',
            'sources_custom/hooks/systems/config/sugarcrm_default_company.php',
            'sources_custom/sugarcrm.php',
            'lang_custom/EN/sugarcrm.ini',
            'sources_custom/curl.php',
            'sources_custom/sugar_crm_lib.php',
        );
    }
}
