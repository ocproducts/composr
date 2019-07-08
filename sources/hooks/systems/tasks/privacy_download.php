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
 * @package    core_privacy
 */

/**
 * Hook class.
 */
class Hook_task_privacy_download
{
    /**
     * Run the task hook.
     *
     * @param  array $table_actions Map between table names and PRIVACY_METHOD_* constants
     * @param  ?MEMBER $member_id Member ID to search for (null: none)
     * @param  array $ip_addresses List of IP addresses to search for
     * @param  string $email_address E-mail address to search for (blank: none)
     * @param  array $others List of other strings to search for, via additional-anonymise-fields
     * @return ?array A tuple of at least 2: Return mime-type, content (either Tempcode, or a string, or a filename and file-path pair to a temporary file), map of HTTP headers if transferring immediately, map of ini_set commands if transferring immediately (null: show standard success message)
     */
    public function run($table_actions, $member_id, $ip_addresses, $email_address, $others)
    {
        require_code('privacy');

        disable_php_memory_limit();

        $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id);

        $data = array();

        $hook_obs = find_all_hook_obs('systems', 'privacy', 'Hook_privacy_');
        foreach ($hook_obs as $hook_ob) {
            $details = $hook_ob->info();
            if ($details !== null) {
                foreach ($details['database_records'] as $table_name => $table_details) {
                    if ((array_key_exists($table_name, $table_actions)) && ($table_actions[$table_name] == 1)) {
                        $data[$table_name] = array();

                        $db = get_db_for($table_name);
                        $selection_sql = $hook_ob->get_selection_sql($table_name, $table_details, $member_id, $ip_addresses, $email_address, $others);
                        $rows = $db->query('SELECT * FROM ' . $db->get_table_prefix() . $table_name . $selection_sql);
                        foreach ($rows as $row) {
                            $data[$table_name][] = $hook_ob->serialise($table_name, $row);
                        }
                    }
                }
            }
        }

        $filename = preg_replace('#[^\w]#', '_', $username) . '.json';
        $headers = array();
        $headers['Content-type'] = 'application/json';
        $headers['Content-Disposition'] = 'attachment; filename="' . escape_header($filename) . '"';

        $ini_set = array();
        $ini_set['ocproducts.xss_detect'] = '0';

        require_code('files2');
        $outfile_path = cms_tempnam();
        make_csv($data, $filename, false, false, $outfile_path);
        return array('text/csv', array($filename, $outfile_path), $headers, $ini_set);
    }
}
