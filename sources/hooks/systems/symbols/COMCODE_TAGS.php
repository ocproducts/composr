<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core_form_interfaces
 */

/**
 * Hook class.
 */
class Hook_symbol_COMCODE_TAGS
{
    /**
     * Run function for symbol hooks. Searches for tasks to perform.
     *
     * @param  array $param Symbol parameters
     * @return string Result
     */
    public function run($param)
    {
        require_code('comcode_renderer');
        _custom_comcode_import($GLOBALS['SITE_DB']);

        $out = '';

        global $VALID_COMCODE_TAGS;
        foreach (array_keys($VALID_COMCODE_TAGS) as $tag) {
            if ((!array_key_exists(0, $param)) || (wysiwyg_comcode_markup_style($tag) == intval($param[0]))) {
                if ($out != '') {
                    $out .= ',';
                }
                $out .= $tag;
            }
        }

        return $out;
    }
}
