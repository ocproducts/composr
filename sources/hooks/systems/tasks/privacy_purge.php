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
class Hook_task_privacy_purge
{
    /**
     * Run the task hook.
     *
     * @param  array $table_actions Map between table names and PRIVACY_METHOD_* constants
     * @param  ?MEMBER $member_id_username Member ID to search for, based on username (null: none)
     * @param  array $ip_addresses List of IP addresses to search for
     * @param  ?MEMBER $member_id Member ID to search for (null: none)
     * @param  string $email_address E-mail address to search for (blank: none)
     * @param  array $others List of other strings to search for, via additional-anonymise-fields
     * @return ?array A tuple of at least 2: Return mime-type, content (either Tempcode, or a string, or a filename and file-path pair to a temporary file), map of HTTP headers if transferring immediately, map of ini_set commands if transferring immediately (null: show standard success message)
     */
    public function run($table_actions, $member_id_username, $ip_addresses, $member_id, $email_address, $others)
    {
        // See also warnings.php - this code will delete/anonymise on mass for any kinds of database record, while warnings.php handles deletion of individually-identified high-level content items

        disable_php_memory_limit();

        require_code('privacy');

        set_mass_import_mode(true);

        $hook_obs = find_all_hook_obs('systems', 'privacy', 'Hook_privacy_');
        foreach ($hook_obs as $hook_ob) {
            $details = $hook_ob->info();
            if ($details !== null) {
                foreach ($details['database_records'] as $table_name => $table_details) {
                    if ((array_key_exists($table_name, $table_actions)) && ($table_actions[$table_name] != PRIVACY_METHOD_leave)) {
                        $this->handle_for_table($hook_ob, $table_name, $table_details, $table_actions[$table_name], $member_id_username, $ip_addresses, $member_id, $email_address, $others);
                    }
                }
            }
        }

        set_mass_import_mode(false);

        require_code('caches3');
        erase_block_cache();

        return null;
    }

    /**
     * Run the task hook.
     *
     * @param  object $hook_ob Privacy object
     * @param  string $table_name Table name
     * @param  array $table_details Table details
     * @param  integer $table_action A PRIVACY_METHOD_* constant
     * @param  ?MEMBER $member_id_username Member ID to search for, based on username (null: none)
     * @param  array $ip_addresses List of IP addresses to search for
     * @param  ?MEMBER $member_id Member ID to search for (null: none)
     * @param  string $email_address E-mail address to search for (blank: none)
     * @param  array $others List of other strings to search for, via additional-anonymise-fields
     */
    protected function handle_for_table($hook_ob, $table_name, $table_details, $table_action, $member_id_username, $ip_addresses, $member_id, $email_address, $others)
    {
        $db = get_db_for($table_name);

        $selection_sql = $hook_ob->get_selection_sql($table_name, $table_details, $member_id_username, $ip_addresses, $member_id, $email_address, $others);
        $sql = 'SELECT * FROM ' . $db->get_table_prefix() . $table_name;
        $sql .= $selection_sql;
        $rows = $db->query($sql);

        foreach ($rows as $row) {
            switch ($table_action) {
                case PRIVACY_METHOD_anonymise:
                    $hook_ob->anonymise($table_name, $row);
                    break;

                case PRIVACY_METHOD_delete:
                    $hook_ob->delete($table_name, $row);
                    break;
            }
        }
    }
}