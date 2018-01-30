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
 * @package    awards
 */

/**
 * Hook class.
 */
class Hook_addon_registry_awards
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
        return 'Pick out content for featuring.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_featured',
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
        return 'themes/default/images/icons/48x48/menu/adminzone/setup/awards.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'themes/default/images/icons/48x48/menu/adminzone/setup/awards.svg',
            'sources/hooks/systems/addon_registry/awards.php',
            'sources/hooks/systems/resource_meta_aware/award_type.php',
            'themes/default/templates/AWARDED_CONTENT.tpl',
            'themes/default/templates/BLOCK_MAIN_AWARDS.tpl',
            'adminzone/pages/modules/admin_awards.php',
            'sources/blocks/main_awards.php',
            'sources/awards.php',
            'sources/awards2.php',
            'site/pages/modules/awards.php',
            'lang/EN/awards.ini',
            'sources/hooks/blocks/main_staff_checklist/awards.php',
            'themes/default/css/awards.css',
            'themes/default/images/awarded.svg',
            'sources/hooks/modules/admin_import_types/awards.php',
            'sources/hooks/systems/block_ui_renderers/awards.php',
            'sources/hooks/systems/commandr_fs/award_types.php',
            'sources/hooks/systems/config/awarded_items_per_page.php',
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
            'templates/BLOCK_MAIN_AWARDS.tpl' => 'block_main_awards',
            'templates/AWARDED_CONTENT.tpl' => 'awarded_content',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__block_main_awards()
    {
        return array(
            lorem_globalise(do_lorem_template('BLOCK_MAIN_AWARDS', array(
                'BLOCK_ID' => lorem_word(),
                'TITLE' => lorem_word(),
                'TYPE' => lorem_word(),
                'DESCRIPTION' => lorem_paragraph_html(),
                'AWARDEE_PROFILE_URL' => placeholder_url(),
                'AWARDEE' => lorem_phrase(),
                'AWARDEE_USERNAME' => lorem_word(),
                'RAW_AWARD_DATE' => placeholder_date(),
                'AWARD_DATE' => placeholder_date(),
                'CONTENT' => lorem_phrase_html(),
                'SUBMIT_URL' => placeholder_url(),
                'ARCHIVE_URL' => placeholder_url(),
            )), null, '', true)
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__awarded_content()
    {
        return array(
            lorem_globalise(do_lorem_template('AWARDED_CONTENT', array(
                'AWARDEE_PROFILE_URL' => placeholder_url(),
                'AWARDEE' => lorem_phrase(),
                'AWARDEE_USERNAME' => lorem_word(),
                'RAW_AWARD_DATE' => placeholder_date_raw(),
                'AWARD_DATE' => placeholder_date(),
                'CONTENT' => lorem_phrase(),
            )), null, '', true)
        );
    }
}
