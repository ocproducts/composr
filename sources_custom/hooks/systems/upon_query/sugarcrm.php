<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

class Hook_upon_query_sugarcrm
{
    public function run_post($ob, $query, $max, $start, $fail_ok, $get_insert_id, $ret)
    {
        if (!addon_installed('sugarcrm')) {
            return;
        }

        if (!function_exists('curl_init')) {
            return;
        }

        if ($query[0] == 'S') {
            return;
        }

        if (!isset($GLOBALS['FORUM_DB'])) {
            return;
        }

        if (running_script('install')) {
            return;
        }

        if (strpos($query, 'f_member') === false) {
            return;
        }

        $prefix = preg_quote($GLOBALS['FORUM_DB']->get_table_prefix(), '#');

        $matches = array();
        if (
        (   preg_match('#^INSERT INTO ' . $prefix . 'f_member_custom_fields .*\((\d+),#U', $query, $matches) != 0)
        ) {
            $this->sync_user(intval($matches[1]));
            return;
        }
    }

    protected function sync_user($member_id)
    {
        if (!addon_installed('sugarcrm')) {
            return;
        }

        require_code('sugarcrm');

        global $SUGARCRM;

        if ($SUGARCRM === null) {
            return null;
        }

        try {
            $contact_id = save_composr_account_into_sugarcrm_as_configured($member_id);
        }
        catch (Exception $e) {
            sugarcrm_failed($e->getMessage());
            return null;
        }

        return $contact_id;
    }
}
