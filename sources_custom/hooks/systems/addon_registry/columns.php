<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    columns
 */

/**
 * Hook class.
 */
class Hook_addon_registry_columns
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
        return 'Graphical';
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
        return array(
            'Based on the code of Adam Wulf ("Columnizer")',
        );
    }

    /**
     * Get the addon licence (one-line summary only).
     *
     * @return string The licence
     */
    public function get_licence()
    {
        return 'Creative Commons Attribution 3.0';
    }

    /**
     * Get the description of the addon.
     *
     * @return string Description of the addon
     */
    public function get_description()
    {
        return 'Automatically columnise Comcode. Allows wrapping of HTML with a div with a [tt].column-wrapper[/tt] CSS class, to have it automatically put in columns.

You need to add this code into your [tt]HTML_HEAD.tpl[/tt]:
[code]<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
{$REQUIRE_CSS,columns}
{$REQUIRE_JAVASCRIPT,columns}[/code]';
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
        return 'themes/default/images/icons/48x48/menu/_generic_admin/component.png';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'sources_custom/hooks/systems/addon_registry/columns.php',
            'themes/default/css_custom/columns.css',
            'themes/default/javascript_custom/columns.js',
        );
    }
}
