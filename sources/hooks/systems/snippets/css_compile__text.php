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
 * @package    core
 */

/**
 * Hook class.
 */
class Hook_snippet_css_compile__text
{
    /**
     * Run function for snippet hooks. Generates XHTML to insert into a page using AJAX.
     *
     * @return Tempcode The snippet
     */
    public function run()
    {
        require_code('input_filter_2');
        if (get_value('disable_modsecurity_workaround') !== '1') {
            modsecurity_workaround_enable();
        }

        if (has_actual_page_access(get_member(), 'admin_themes')) {
            cms_ini_set('ocproducts.xss_detect', '0');

            $css = post_param_string('css');

            require_code('tempcode_compiler');
            $ret = template_to_tempcode($css);

            return $ret;
        }
        return new Tempcode();
    }
}
