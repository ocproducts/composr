<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

/**
 * Hook class.
 */
class Hook_cron_sugarcrm_sync_lead_metadata
{
    /**
     * Run function for Cron hooks. Searches for tasks to perform.
     */
    public function run()
    {
        if (!addon_installed('sugarcrm')) {
            return;
        }

        $last = get_value('last_lead_metadata_sync', null, true);
        $time = time();
        if (($last !== null) && (intval($last) > $time - 60 * 60 * 24)) {
            return;
        }
        set_value('last_lead_metadata_sync', strval($time), true);

        if (get_option('sugarcrm_lead_metadata_field') == '') {
            // Not configured
            return;
        }

        require_lang('sugarcrm');
        require_code('tasks');
        $_title = do_lang('SUGARCRM_MEMBER_SYNC');
        call_user_func_array__long_task($_title, null, 'sugarcrm_sync_lead_metadata', array(), false, false, false);
    }
}
