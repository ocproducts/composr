<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.


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
class Hook_cron_group_member_timeouts
{
    /**
     * Get info from this hook.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     * @param  boolean $calculate_num_queued Calculate the number of items queued, if possible
     * @return ?array Return a map of info about the hook (null: disabled)
     */
    public function info($last_run, $calculate_num_queued)
    {
        if ($calculate_num_queued) {
            $db = (get_forum_type() == 'cns') ? $GLOBALS['FORUM_DB'] : $GLOBALS['SITE_DB'];
            $num_queued = $db->query_value_if_there('SELECT COUNT(*) FROM ' . $db->get_table_prefix() . 'f_group_member_timeouts WHERE timeout<' . strval(time()));
        } else {
            $num_queued = null;
        }

        return array(
            'label' => 'Expire temporary usergroup subscriptions',
            'num_queued' => $num_queued,
            'minutes_between_runs' => 60,
        );
    }

    /**
     * Run function for system scheduler scripts. Searches for things to do. ->info(..., true) must be called before this method.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     */
    public function run($last_run)
    {
        require_code('group_member_timeouts');

        cleanup_member_timeouts();
    }
}
