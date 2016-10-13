<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    data_mappr
 */

/**
 * Hook class.
 */
class Hook_addon_registry_data_mappr
{
    /**
     * Get a list of file permissions to set
     *
     * @param  boolean $runtime Whether to include wildcards represented runtime-created chmoddable files
     * @return array File permissions to set
     */
    public function get_chmod_array($runtime = false)
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
        return is_maintained('google_maps') ? 'Information Display' : 'Development';
    }

    /**
     * Get the addon author
     *
     * @return string The author
     */
    public function get_author()
    {
        return 'Kamen Blaginov / Chris Graham / temp1024';
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
        return 'Shows different catalogue entries locations longitude/latitude values (the names of the fields to take longitude/latitude from are configured inside block parameters).

The different catalogue entries are shown as pins on a {$IS_MAINTAINED,google_maps,Google map}. Clicking on the pin shows the catalogue entry in a little box (as a link to the entry).

Example:
[code="Comcode"][block title="store locater" description="This is a Store Locater" latfield="lat" longfield="long" catalogue="stores" width="100%" height="300px" zoom="6" latitude="24.2135" longitude="-1.4654"]main_google_map[/block][/code]

You will need to create a catalogue with at least 1 entry which has the latitude and longitude fields filled in. You can call the fields in the catalogue latitude and longitude field anything you like and you can find the coordinates by using the option in Google Maps Labs or via http://itouchmap.com/latlong.html.

When you add the block you see various block parameters to be filled in including:
 - title -- The Name of the block which will appear on screen (for example, Store Locater)
 - description -- a Description of the block
 - latfield -- This is the field you chose in the catalogue which has all the latitude coordinates in it
 - longfield -- This is the field you chose in the catalogue which has all the longitude coordinates in it
 - catalogue -- This is the name of the catalogue you chose and want to display the pins for
 - width -- Defaults to 100% of the column
 - height -- Defaults to 300px but can be set to how ever many pixels(px) you need it to be
 - zoom -- A number between 1 and 17, the higher the number the more zoomed in the map will start at
 - latitude -- The Latitude coordinates where you want the centre of the map to be when first loaded
 - longtude -- The Longitude coordinates where you want the centre of the map to be when first loaded';
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
                'catalogues',
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
            'sources_custom/hooks/systems/addon_registry/data_mappr.php',
            'lang_custom/EN/google_map.ini',
            'sources_custom/blocks/main_google_map.php',
            'themes/default/templates_custom/BLOCK_MAIN_GOOGLE_MAP.tpl',
            'sources_custom/hooks/systems/fields/float.php',
            'themes/default/templates_custom/FORM_SCREEN_INPUT_MAP_POSITION.tpl',
            'themes/default/images_custom/star_highlight.png',
            'sources_custom/catalogues2.php',
            'sources_custom/hooks/systems/upon_query/google_maps.php',
        );
    }
}
