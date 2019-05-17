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
 * @package    galleries
 */

/**
 * Hook class.
 */
class Hook_unvalidated_images
{
    /**
     * Find details on the unvalidated hook.
     *
     * @return ?array Map of hook info (null: hook is disabled)
     */
    public function info()
    {
        if (!addon_installed('galleries')) {
            return null;
        }

        require_lang('galleries');

        $info = array();
        $info['db_table'] = 'images';
        $info['db_identifier'] = 'id';
        $info['db_validated'] = 'validated';
        $info['db_title'] = 'title';
        $info['db_title_dereference'] = true;
        $info['db_add_date'] = 'add_date';
        $info['db_edit_date'] = 'edit_date';
        $info['edit_module'] = 'cms_galleries';
        $info['edit_type'] = '_edit';
        $info['view_module'] = 'galleries';
        $info['view_type'] = 'image';
        $info['edit_identifier'] = 'id';
        $info['title'] = do_lang_tempcode('IMAGES');

        return $info;
    }
}
