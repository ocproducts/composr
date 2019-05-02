<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    user_sync
 */

/**
 * Hook class.
 */
class Hook_cron_user_sync
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
        if (!addon_installed('user_sync')) {
            return null;
        }

        if (!addon_installed('commandr')) {
            return;
        }

        if (get_forum_type() != 'cns') {
            return null;
        }

        if (get_value('user_sync_enabled') !== '1') {
            return null;
        }

        return array(
            'label' => 'User synchronisation',
            'num_queued' => null,
            'minutes_between_runs' => 60 * 24,
        );
    }

    /**
     * Run function for system scheduler scripts. Searches for things to do. ->info(..., true) must be called before this method.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     */
    public function run($last_run)
    {
        require_code('user_sync');

        user_sync__inbound($last_time);
    }
}
