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
class Hook_checklist_translations
{
    /**
     * Find items to include on the staff checklist.
     *
     * @return array An array of tuples: The task row to show, the number of seconds until it is due (or null if not on a timer), the number of things to sort out (or null if not on a queue), The name of the config option that controls the schedule (or null if no option)
     */
    public function run()
    {
        if (!multi_lang()) {
            return array();
        }
        if (!multi_lang_content()) {
            return array();
        }

        $langs = find_all_langs();
        $num_langs = count($langs);
        $cnt = $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM (SELECT id FROM ' . get_table_prefix() . 'translate WHERE broken=0 AND importance_level<=3 GROUP BY id HAVING COUNT(*)<' . strval($num_langs) . ') t');

        if ($cnt > 0) {
            $status = do_template('BLOCK_MAIN_STAFF_CHECKLIST_ITEM_STATUS_0', array('_GUID' => 'k578142633c6f3d37776e82a869deb91'));
        } else {
            $status = do_template('BLOCK_MAIN_STAFF_CHECKLIST_ITEM_STATUS_1', array('_GUID' => 'l578142633c6f3d37776e82a869deb91'));
        }

        $url = build_url(array('page' => 'admin_lang', 'type' => 'content'), get_module_zone('admin_lang'));

        require_lang('lang');

        $tpl = do_template('BLOCK_MAIN_STAFF_CHECKLIST_ITEM', array(
            '_GUID' => 'aacf866e2ea104ac41685a8756e182f8',
            'URL' => $url,
            'STATUS' => $status,
            'TASK' => do_lang_tempcode('TRANSLATE_CONTENT'),
            'INFO' => do_lang_tempcode('NUM_QUEUE', escape_html(integer_format($cnt))),
        ));
        return array(array($tpl, null, $cnt, null));
    }
}
