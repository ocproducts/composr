<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_webstandards
 */

/**
 * Hook class.
 */
class Hook_addon_registry_core_webstandards
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
        return 'Web Standards checking tools.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_accessibility',
            'tut_markup',
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
            'themes/default/css/webstandards.css',
            'sources/hooks/systems/addon_registry/core_webstandards.php',
            'themes/default/templates/WEBSTANDARDS_ATTRIBUTE_END.tpl',
            'themes/default/templates/WEBSTANDARDS_ATTRIBUTE_START.tpl',
            'themes/default/templates/WEBSTANDARDS_ERROR.tpl',
            'themes/default/templates/WEBSTANDARDS_ERROR_SCREEN.tpl',
            'themes/default/templates/WEBSTANDARDS_LINE_START.tpl',
            'themes/default/templates/WEBSTANDARDS_LINE_END.tpl',
            'themes/default/templates/WEBSTANDARDS_LINE_ERROR.tpl',
            'themes/default/templates/WEBSTANDARDS_MARKER_END.tpl',
            'themes/default/templates/WEBSTANDARDS_MARKER_START.tpl',
            'themes/default/templates/WEBSTANDARDS_SCREEN.tpl',
            'themes/default/templates/WEBSTANDARDS_SCREEN_END.tpl',
            'themes/default/templates/WEBSTANDARDS_TAG_END.tpl',
            'themes/default/templates/WEBSTANDARDS_TAG_NAME_END.tpl',
            'themes/default/templates/WEBSTANDARDS_TAG_NAME_START.tpl',
            'themes/default/templates/WEBSTANDARDS_TAG_START.tpl',
            'themes/default/templates/WEBSTANDARDS_MARKER.tpl',
            'sources/webstandards_js_lex.php',
            'sources/webstandards_js_parse.php',
            'sources/webstandards_js_lint.php',
            'lang/EN/webstandards.ini',
            'sources/webstandards.php',
            'sources/webstandards2.php',
            'sources/hooks/systems/config/webstandards_compat.php',
            'sources/hooks/systems/config/webstandards_css.php',
            'sources/hooks/systems/config/webstandards_ext_files.php',
            'sources/hooks/systems/config/webstandards_javascript.php',
            'sources/hooks/systems/config/webstandards_wcag.php',
            'sources/hooks/systems/config/webstandards_xhtml.php',
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
            'templates/WEBSTANDARDS_SCREEN.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_TAG_START.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_TAG_NAME_START.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_LINE_END.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_LINE_START.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_TAG_END.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_TAG_NAME_END.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_SCREEN_END.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_ERROR.tpl' => 'administrative__webstandards_error_screen',
            'templates/WEBSTANDARDS_ERROR_SCREEN.tpl' => 'administrative__webstandards_error_screen',
            'templates/WEBSTANDARDS_ATTRIBUTE_START.tpl' => 'administrative__webstandards_error_screen',
            'templates/WEBSTANDARDS_ATTRIBUTE_END.tpl' => 'administrative__webstandards_error_screen',
            'templates/WEBSTANDARDS_MARKER.tpl' => 'administrative__webstandards_error_screen',
            'templates/WEBSTANDARDS_LINE_ERROR.tpl' => 'administrative__webstandards_error_screen',
            'templates/WEBSTANDARDS_MARKER_START.tpl' => 'administrative__webstandards',
            'templates/WEBSTANDARDS_MARKER_END.tpl' => 'administrative__webstandards',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__webstandards()
    {
        $display = new Tempcode();
        $display->attach(do_lorem_template('WEBSTANDARDS_SCREEN', array(
            'MSG' => lorem_phrase(),
            'RETURN_URL' => placeholder_url(),
            'TITLE' => lorem_title(),
            'MESSY_URL' => placeholder_url(),
            'RET' => lorem_phrase(),
        )));

        $display->attach(do_lorem_template('WEBSTANDARDS_LINE_START', array(
            'NUMBER' => placeholder_number(),
        )));

        $display->attach(do_lorem_template('WEBSTANDARDS_TAG_START', array(
            'COLOUR' => '#b7b7b7',
        )));
        $display->attach(lorem_word());
        $display->attach(do_lorem_template('WEBSTANDARDS_TAG_END', array()));

        $display->attach(do_lorem_template('WEBSTANDARDS_TAG_NAME_START', array()));
        $display->attach(lorem_word());
        $display->attach(do_lorem_template('WEBSTANDARDS_TAG_NAME_END', array()));

        $display->attach(do_lorem_template('WEBSTANDARDS_MARKER_START', array()));
        $display->attach(lorem_word());
        $display->attach(do_lorem_template('WEBSTANDARDS_MARKER_END', array()));

        $display->attach(do_lorem_template('WEBSTANDARDS_LINE_END', array()));

        $display->attach(do_lorem_template('WEBSTANDARDS_SCREEN_END', array()));

        return array(
            lorem_globalise($display, null, '', true)
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__webstandards_error_screen()
    {
        $errors = new Tempcode();
        $display = new Tempcode();
        foreach (placeholder_array() as $key => $_error) {
            $errors->attach(do_lorem_template('WEBSTANDARDS_ERROR', array(
                'I' => lorem_word() . strval($key),
                'LINE' => placeholder_number(),
                'POS' => placeholder_number(),
                'ERROR' => $_error,
            )));
        }

        $display->attach(do_lorem_template('WEBSTANDARDS_ERROR_SCREEN', array(
            'MSG' => lorem_phrase(),
            'RETURN_URL' => placeholder_url(),
            'TITLE' => lorem_title(),
            'IGNORE_URL_2' => placeholder_url(),
            'IGNORE_URL' => placeholder_url(),
            'MESSY_URL' => placeholder_url(),
            'ERRORS' => $errors,
            'RET' => lorem_phrase(),
        )));

        $markers = new Tempcode();
        foreach (placeholder_array() as $key => $_error) {
            $markers->attach(do_lorem_template('WEBSTANDARDS_MARKER', array(
                'I' => lorem_word() . strval($key),
                'ERROR' => $_error,
            )));
        }
        $display->attach(do_lorem_template('WEBSTANDARDS_LINE_ERROR', array(
            'MARKERS' => $markers,
            'NUMBER' => placeholder_number(),
        )));
        $display->attach(do_lorem_template('WEBSTANDARDS_ATTRIBUTE_START', array()));
        $display->attach(lorem_word());
        $display->attach(do_lorem_template('WEBSTANDARDS_ATTRIBUTE_END', array()));
        $display->attach(do_lorem_template('WEBSTANDARDS_LINE_END', array()));
        $display->attach(lorem_phrase());

        $display->attach(do_lorem_template('WEBSTANDARDS_LINE_START', array(
            'NUMBER' => placeholder_number(),
        )));
        $display->attach(do_lorem_template('WEBSTANDARDS_LINE_END', array()));

        $display->attach(do_lorem_template('WEBSTANDARDS_SCREEN_END', array()));

        return array(
            lorem_globalise($display, null, '', true)
        );
    }
}
