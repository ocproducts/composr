<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    health_check
 */

/**
 * Hook class.
 */
class Hook_cron_health_check
{
    /**
     * Run function for CRON hooks. Searches for tasks to perform.
     */
    public function run()
    {
        $last = get_value('last_health_check', null, true);
        $time = time();
        if (($last !== null) && (intval($last) > $time - intval(get_option('hc_cron_regularity')) * 60)) {
            return;
        }
        set_value('last_health_check', strval($time), true);

        require_code('health_check');

        $results = run_health_check();

        // TODO: Process results and send notification if failures or hc_cron_notify_regardless option
    }
}
