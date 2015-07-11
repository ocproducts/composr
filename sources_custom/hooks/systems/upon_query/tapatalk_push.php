<?php /*

 ocPortal
 Copyright (c) ocProducts/Tapatalk, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */

/**
 * Hook class.
 */
class upon_query_tapatalk_push
{
    function run($ob, $query, $max, $start, $fail_ok, $get_insert_id, $ret)
    {
        if ((strpos($query, 'INTO ' . get_table_prefix() . 'f_posts ') !== false) && ($get_insert_id)) {
            require_once(get_file_base() . '/mobiquo/lib/TapatalkPush.php');
            $push = new TapatalkPush();
            register_shutdown_function(array($push, 'do_push'), $ret);
        }
    }
}
