<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_language_editing
 */

/**
 * Hook class.
 */
class Hook_addon_registry_core_language_editing
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
        return 'Translate the software, or just change what it says for stylistic reasons.';
    }

    /**
     * Get a list of tutorials that apply to this addon.
     *
     * @return array List of tutorials
     */
    public function get_applicable_tutorials()
    {
        return array(
            'tut_intl',
            'tut_intl_users',
            'tut_intl_content',
            'tut_intl_code_philosophy',
            'tut_intl_maintenance',
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
        return 'themes/default/images/icons/menu/adminzone/style/language/language.svg';
    }

    /**
     * Get a list of files that belong to this addon.
     *
     * @return array List of files
     */
    public function get_file_list()
    {
        return array(
            'themes/default/images/icons/menu/adminzone/style/language/language.svg',
            'themes/default/images/icons/menu/adminzone/style/language/language_content.svg',
            'themes/default/images/icons/menu/adminzone/style/language/criticise_language.svg',
            'themes/default/images/icons/menu/adminzone/style/language/index.html',
            'themes/default/css/translations_editor.css',
            'sources/hooks/systems/addon_registry/core_language_editing.php',
            'sources/hooks/blocks/main_staff_checklist/translations.php',
            'themes/default/templates/TRANSLATE_ACTION.tpl',
            'themes/default/templates/TRANSLATE_LINE.tpl',
            'themes/default/templates/TRANSLATE_LINE_CONTENT.tpl',
            'themes/default/templates/TRANSLATE_SCREEN.tpl',
            'themes/default/templates/TRANSLATE_SCREEN_CONTENT_SCREEN.tpl',
            'themes/default/templates/TRANSLATE_LANGUAGE_CRITICISE_SCREEN.tpl',
            'themes/default/templates/TRANSLATE_LANGUAGE_CRITICISE_FILE.tpl',
            'themes/default/templates/TRANSLATE_LANGUAGE_CRITICISM.tpl',
            'adminzone/pages/modules/admin_lang.php',
            'sources/hooks/systems/page_groupings/language.php',
            'themes/default/images/icons/admin/translate.svg',
            'sources/hooks/systems/config/google_translate_enabled.php',
            'sources/database_multi_lang_conv.php',
            'themes/default/javascript/core_language_editing.js',
            'sources/translation.php',
            'sources/hooks/systems/symbols/PROVIDE_WITH_TRANSLATION.php',
            'themes/default/images/google_translate.svg',
            'sources/hooks/systems/startup/translation.php',
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
            'templates/TRANSLATE_LANGUAGE_CRITICISM.tpl' => 'administrative__translate_language_criticise_screen',
            'templates/TRANSLATE_LANGUAGE_CRITICISE_FILE.tpl' => 'administrative__translate_language_criticise_screen',
            'templates/TRANSLATE_LANGUAGE_CRITICISE_SCREEN.tpl' => 'administrative__translate_language_criticise_screen',
            'templates/TRANSLATE_ACTION.tpl' => 'administrative__translate_screen_content_screen',
            'templates/TRANSLATE_LINE_CONTENT.tpl' => 'administrative__translate_screen_content_screen',
            'templates/TRANSLATE_SCREEN_CONTENT_SCREEN.tpl' => 'administrative__translate_screen_content_screen',
            'templates/TRANSLATE_LINE.tpl' => 'administrative__translate_screen',
            'templates/TRANSLATE_SCREEN.tpl' => 'administrative__translate_screen',
        );
    }

    /**
     * Get a preview(s) of a (group of) template(s), as a full standalone piece of HTML in Tempcode format.
     * Uses sources/lorem.php functions to place appropriate stock-text. Should not hard-code things, as the code is intended to be declaritive.
     * Assumptions: You can assume all Lang/CSS/JavaScript files in this addon have been pre-required.
     *
     * @return array Array of previews, each is Tempcode. Normally we have just one preview, but occasionally it is good to test templates are flexible (e.g. if they use IF_EMPTY, we can test with and without blank data).
     */
    public function tpl_preview__administrative__translate_language_criticise_screen()
    {
        $file = new Tempcode();
        $files = '';
        foreach (placeholder_array() as $value) {
            $crit = do_lorem_template('TRANSLATE_LANGUAGE_CRITICISM', array(
                'CRITICISM' => lorem_sentence(),
            ));
            $file->attach($crit);
        }
        $file_result = do_lorem_template('TRANSLATE_LANGUAGE_CRITICISE_FILE', array(
            'COMPLAINTS' => $file,
            'FILENAME' => do_lang_tempcode('NA_EM'),
        ));

        $files .= $file_result->evaluate();

        return array(
            lorem_globalise(do_lorem_template('TRANSLATE_LANGUAGE_CRITICISE_SCREEN', array(
                'TITLE' => lorem_title(),
                'FILES' => $files,
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
    public function tpl_preview__administrative__translate_screen_content_screen()
    {
        require_lang('lang');
        $lines = new Tempcode();
        foreach (placeholder_array() as $key => $value) {
            $actions = do_lorem_template('TRANSLATE_ACTION', array(
                'LANG_FROM' => fallback_lang(),
                'LANG_TO' => fallback_lang(),
                'NAME' => 'trans_' . strval($key),
                'OLD' => $value,
            ));
            $lines->attach(do_lorem_template('TRANSLATE_LINE_CONTENT', array(
                'ID' => strval($key),
                'NAME' => 'trans_' . strval($key),
                'OLD' => $value,
                'CURRENT' => $value,
                'ACTIONS' => $actions,
                'PRIORITY' => lorem_word(),
            )));
        }

        return array(
            lorem_globalise(do_lorem_template('TRANSLATE_SCREEN_CONTENT_SCREEN', array(
                'LANG_NICE_NAME' => lorem_word(),
                'LANG_NICE_ORIGINAL_NAME' => lorem_word(),
                'TOO_MANY' => lorem_phrase(),
                'TRANSLATION_CREDIT' => '',
                'TOTAL' => placeholder_number(),
                'LANG' => fallback_lang(),
                'LANG_ORIGINAL_NAME' => fallback_lang(),
                'LINES' => $lines,
                'TITLE' => lorem_title(),
                'URL' => placeholder_url(),
                'MAX' => placeholder_number(),
                'PAGINATION' => placeholder_pagination(),
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
    public function tpl_preview__administrative__translate_screen()
    {
        require_lang('lang');
        $lines = '';
        foreach (placeholder_array() as $i => $value) {
            $temp = do_lorem_template('TRANSLATE_LINE', array(
                'DESCRIPTION' => lorem_sentence(),
                'NAME' => lorem_word() . strval($i),
                'OLD' => str_replace('\n', "\n", $value),
                'CURRENT' => $value,
                'ACTIONS' => lorem_phrase(),
            ));
            $lines .= $temp->evaluate();
        }

        return array(
            lorem_globalise(do_lorem_template('TRANSLATE_SCREEN', array(
                'PAGE' => lorem_phrase(),
                'TRANSLATION_CREDIT' => '',
                'LANG' => fallback_lang(),
                'LINES' => $lines,
                'TITLE' => lorem_title(),
                'URL' => placeholder_url(),
            )), null, '', true)
        );
    }
}
