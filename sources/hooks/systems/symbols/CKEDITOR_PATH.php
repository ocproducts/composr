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
 * @package    core_form_interfaces
 */

/**
 * Hook class.
 */
class Hook_symbol_CKEDITOR_PATH
{
    /**
     * Run function for symbol hooks. Searches for tasks to perform.
     *
     * @param  array $param Symbol parameters
     * @return string Result
     */
    public function run($param)
    {
        $value = 'data/ckeditor';

        if ((get_param_integer('ckeditor_dev', 0) == 1) && (is_dir(get_file_base() . '/data_custom/ckeditor'))) {
            $value = 'data_custom/ckeditor';
        }

        return $value;
    }
}
