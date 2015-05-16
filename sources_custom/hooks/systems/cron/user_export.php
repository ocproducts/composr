<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * Hook class.
 */
class Hook_cron_user_export
{
    /**
     * Run function for CRON hooks. Searches for tasks to perform.
     */
    public function run()
    {
        require_code('user_export');

        if (!USER_EXPORT_ENABLED) {
            return;
        }

        $last = get_value('last_user_export');
        if ((is_null($last)) || (intval($last) < time() - 60 * USER_EXPORT_MINUTES)) {
            set_value('last_user_export', strval(time()));

            do_user_export();
        }
    }
}
