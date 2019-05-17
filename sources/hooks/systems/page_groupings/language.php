<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

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
class Hook_page_groupings_language
{
    /**
     * Run function for do_next_menu hooks. They find links to put on standard navigation menus of the system.
     *
     * @param  ?MEMBER $member_id Member ID to run as (null: current member)
     * @param  boolean $extensive_docs Whether to use extensive documentation tooltips, rather than short summaries
     * @return array List of tuple of links (page grouping, icon, do-next-style linking data), label, help (optional) and/or nulls
     */
    public function run($member_id = null, $extensive_docs = false)
    {
        $has_langs = false;

        require_code('files');

        $_dir = opendir(get_file_base() . '/lang/');
        $_langs = array();
        while (false !== ($file = readdir($_dir))) {
            if ($file == fallback_lang()) {
                continue;
            }
            if ((!should_ignore_file('lang/' . $file, IGNORE_ACCESS_CONTROLLERS)) && (strlen($file) <= 5)) {
                if (is_dir(get_file_base() . '/lang/' . $file)) {
                    $has_langs = true;
                }
            }
        }
        closedir($_dir);
        if (!in_safe_mode()) {
            $_dir = @opendir(get_custom_file_base() . '/lang_custom/');
            if ($_dir !== false) {
                while (false !== ($file = readdir($_dir))) {
                    if ($file == fallback_lang()) {
                        continue;
                    }
                    if ((!should_ignore_file('lang_custom/' . $file, IGNORE_ACCESS_CONTROLLERS)) && (strlen($file) <= 5)) {
                        if (is_dir(get_custom_file_base() . '/lang_custom/' . $file)) {
                            $has_langs = true;
                        }
                    }
                }
                closedir($_dir);
            }
            if (get_custom_file_base() != get_file_base()) {
                $_dir = opendir(get_file_base() . '/lang_custom/');
                while (false !== ($file = readdir($_dir))) {
                    if ($file == fallback_lang()) {
                        continue;
                    }
                    if ((!should_ignore_file('lang_custom/' . $file, IGNORE_ACCESS_CONTROLLERS)) && (strlen($file) <= 5)) {
                        $has_langs = true;
                    }
                }
                closedir($_dir);
            }
        }

        return array(
            array('style', 'menu/adminzone/style/language/language', array('admin_lang', array('type' => 'browse'), get_module_zone('admin_lang')), do_lang_tempcode('lang:TRANSLATE_CODE'), 'lang:DOC_TRANSLATE'),
            multi_lang() ? array('style', 'menu/adminzone/style/language/language_content', array('admin_lang', array('type' => 'content'), get_module_zone('admin_lang')), do_lang_tempcode('lang:TRANSLATE_CONTENT'), 'lang:DOC_TRANSLATE_CONTENT') : null,
            (!$has_langs) ? null : array('style', 'menu/adminzone/style/language/criticise_language', array('admin_lang', array('type' => 'criticise'), get_module_zone('admin_lang')), do_lang_tempcode('lang:CRITICISE_LANGUAGE_PACK'), 'lang:DOC_CRITICISE_LANGUAGE_PACK'),
        );
    }
}
