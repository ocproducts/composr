<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    password_censor
 */

/**
 * Hook class.
 */
class Hook_cron_password_censor
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
        if (!addon_installed('password_censor')) {
            return null;
        }

        return array(
            'label' => 'Censor old written passwords',
            'num_queued' => null, // Too time-consuming to calculate
            'minutes_between_runs' => 60 * 12,
        );
    }

    /**
     * Run function for system scheduler scripts. Searches for things to do. ->info(..., true) must be called before this method.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     */
    public function run($last_run)
    {
        require_code('password_censor');
        password_censor(true, false);
    }
}
