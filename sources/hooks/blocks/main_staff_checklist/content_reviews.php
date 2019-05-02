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
 * @package    content_reviews
 */

/**
 * Hook class.
 */
class Hook_checklist_content_reviews
{
    /**
     * Find items to include on the staff checklist.
     *
     * @return array An array of tuples: The task row to show, the number of seconds until it is due (or null if not on a timer), the number of things to sort out (or null if not on a queue), The name of the config option that controls the schedule (or null if no option)
     */
    public function run()
    {
        if (!addon_installed('content_reviews')) {
            return array();
        }

        $num_to_review = $GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . get_table_prefix() . 'content_reviews WHERE next_review_time<=' . strval(time()));
        if ($num_to_review >= 1) {
            $status = 0;
        } else {
            $status = 1;
        }
        require_lang('content_reviews');
        $_status = ($status == 0) ? do_template('BLOCK_MAIN_STAFF_CHECKLIST_ITEM_STATUS_0') : do_template('BLOCK_MAIN_STAFF_CHECKLIST_ITEM_STATUS_1');
        $url = build_url(array('page' => 'admin_content_reviews'), 'adminzone');
        $tpl = do_template('BLOCK_MAIN_STAFF_CHECKLIST_ITEM', array(
            '_GUID' => 'c00c54ed0e3095ff0b653a5799b7cd92',
            'URL' => '',
            'STATUS' => $_status,
            'TASK' => do_lang_tempcode('NAG_CONTENT_REVIEWS', escape_html_tempcode($url)),
            'INFO' => do_lang_tempcode('CONTENT_NEEDING_REVIEWING', escape_html(integer_format($num_to_review))),
        ));
        return array(array($tpl, null, $num_to_review, null));
    }
}
