<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    catalogues
 */

/**
 * Hook class.
 */
class Hook_cron_catalogue_entry_timeouts
{
    /**
     * Run function for CRON hooks. Searches for tasks to perform.
     */
    public function run()
    {
        if (!addon_installed('catalogues')) {
            return;
        }

        $time = time();
        $last_time = get_value('last_catalogue_entry_timeouts_calc', null, true);
        if (!is_null($last_time)) {
            if (intval($last_time) > $time - 6 * 60 * 60) {
                return; // Every 6 hours
            }
        }

        if (php_function_allowed('set_time_limit')) {
            set_time_limit(0);
        }

        $catalogue_categories = $GLOBALS['SITE_DB']->query('SELECT id,cc_move_target,cc_move_days_lower,cc_move_days_higher FROM ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'catalogue_categories WHERE cc_move_target IS NOT NULL');
        foreach ($catalogue_categories as $row) {
            $changed = false;

            $start = 0;
            do {
                $entries = $GLOBALS['SITE_DB']->query_select('catalogue_entries', array('id', 'ce_submitter', 'ce_last_moved'), array('cc_id' => $row['id']), '', 1000, $start);
                foreach ($entries as $entry) {
                    $higher = has_privilege($entry['ce_submitter'], 'high_catalogue_entry_timeout');
                    $time_diff = $time - $entry['ce_last_moved'];
                    $move_days = $higher ? $row['cc_move_days_higher'] : $row['cc_move_days_lower'];
                    if ($time_diff / (60 * 60 * 24) > $move_days) {
                        $GLOBALS['SITE_DB']->query_update('catalogue_entries', array('ce_last_moved' => $time, 'cc_id' => $row['cc_move_target']), array('id' => $entry['id']), '', 1);
                        $changed = true;
                    }
                }
                $start += 1000;
            } while (count($entries) == 1000);

            if ($changed) {
                require_code('catalogues2');
                calculate_category_child_count_cache($row['cc_move_target']);
                calculate_category_child_count_cache($row['id']);
            }
        }

        set_value('last_catalogue_entry_timeouts_calc', strval($time), true);
    }
}
