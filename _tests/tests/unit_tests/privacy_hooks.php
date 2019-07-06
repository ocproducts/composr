<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class privacy_hooks_test_set extends cms_test_case
{
    public function testHookIntegrity()
    {
        require_code('privacy');

        $debug = (get_param_integer('debug', 0) == 1);

        $all_tables = collapse_1d_complexity('m_table', $GLOBALS['SITE_DB']->query_select('db_meta', array('DISTINCT m_table')));
        $found_tables = array();

        $hook_obs = find_all_hook_obs('systems', 'privacy', 'Hook_privacy_');
        foreach ($hook_obs as $hook => $hook_ob) {
            $info = $hook_ob->info();

            foreach ($info['cookies'] as $x) {
                $this->assertTrue($x === null || is_array($x) && array_key_exists('purpose', $x), 'Invalid cookie name in ' . $hook . ' (' . serialize($x) . ')');
            }

            foreach ($info['positive'] as $x) {
                $this->assertTrue($x === null || is_array($x) && array_key_exists('heading', $x) && array_key_exists('explanation', $x), 'Invalid positive message in ' . $hook . ' (' . serialize($x) . ')');
            }

            foreach ($info['general'] as $x) {
                $this->assertTrue($x === null || is_array($x) && array_key_exists('heading', $x) && array_key_exists('action', $x) && array_key_exists('reason', $x), 'Invalid general message in ' . $hook . ' (' . serialize($x) . ')');
            }

            foreach ($info['database_records'] as $table => $details) {
                $this->assertTrue(!isset($all_tables[$table]), 'Table unknown: ' . $table);

                $this->assertTrue(!isset($found_tables[$table]), 'Table defined more than once: ' . $table);
                $found_tables[$table] = $details;

                $this->assertTrue($details['timestamp_field'] === null || is_string($details['timestamp_field']), 'Invalid timestamp field in ' . $table);
                $this->assertTrue($details['retention_days'] === null || is_integer($details['retention_days']), 'Invalid retention_days field in ' . $table);
                $this->assertTrue(is_integer($details['retention_handle_method']), 'Invalid retention_handle_method field in ' . $table);
                $this->assertTrue(is_array($details['member_id_fields']), 'Invalid member_id_fields field in ' . $table);
                $this->assertTrue(is_array($details['ip_address_fields']), 'Invalid ip_address_fields field in ' . $table);
                $this->assertTrue(is_array($details['email_fields']), 'Invalid email_fields field in ' . $table);
                $this->assertTrue(is_array($details['additional_anonymise_fields']), 'Invalid additional_anonymise_fields field in ' . $table);
                $this->assertTrue($details['extra_where'] === null || is_string($details['extra_where']), 'Invalid extra_where field in ' . $table);
                $this->assertTrue(is_integer($details['removal_default_handle_method']), 'Invalid removal_default_handle_method field in ' . $table);

                if ($details['retention_handle_method'] == PRIVACY_METHOD_leave) {
                    $this->assertTrue($details['retention_days'] === null, 'retention_days should not be set for PRIVACY_METHOD_leave, for ' . $table);
                } else {
                    $this->assertTrue($details['timestamp_field'] !== null, 'timestamp_field should be set for !PRIVACY_METHOD_leave, for ' . $table);
                    $this->assertTrue($details['retention_days'] !== null, 'retention_days should be set for !PRIVACY_METHOD_leave, for ' . $table);
                }

                $this->assertTrue(count($details['member_id_fields']) + count($details['ip_address_fields']) + count($details['email_fields']) + count($details['additional_anonymise_fields']) > 0, 'No personal data in ' . $table . ', so should not be defined');
            }

            $this->assertTrue(strpos(serialize($info), 'TODO') === false);
        }

        foreach ($all_tables as $table) {
            $all_fields = collapse_2d_complexity('m_name', 'm_type', $GLOBALS['SITE_DB']->query_select('db_meta', array('m_name', 'm_type'), array('m_table' => $table)));
            $relevant_fields_member_id = array();
            $relevant_fields_ip_address = array();
            $relevant_fields_email = array();
            foreach ($all_fields as $name => $type) {
                if (preg_match('#^[\*\?]*(MEMBER)$#', $type) != 0) {
                    $relevant_fields_member_id[$name] = $type;
                }
                if (preg_match('#^[\*\?]*(IP)$#', $type) != 0) {
                    $relevant_fields_ip_address[$name] = $type;
                }
                if ((strpos($name, 'email') !== false) && (preg_match('#^[\*\?]*(SHORT_TEXT)$#', $type) != 0)) {
                    $relevant_fields_email[$name] = $type;
                }
            }
            if ($table == 'f_members') {
                $relevant_fields_member_id['id'] = '*AUTO';
            }
            if ($table == 'w_members') {
                $relevant_fields_member_id['id'] = 'MEMBER';
            }
            $total_fields = count($relevant_fields_member_id) + count($relevant_fields_ip_address) + count($relevant_fields_email);

            if (isset($found_tables[$table])) {
                if ($debug) {
//TODO                    $this->assertTrue(array_keys($relevant_fields_member_id) == $found_tables[$table]['member_id_fields'], 'Member field mismatch for: ' . $table);
//TODO                    $this->assertTrue(array_keys($relevant_fields_ip_address) == $found_tables[$table]['ip_address_fields'], 'IP address field mismatch for: ' . $table);
//TODO                    $this->assertTrue(array_keys($relevant_fields_email) == $found_tables[$table]['email_fields'], 'E-mail field mismatch for: ' . $table);
                }

                foreach ($found_tables[$table]['member_id_fields'] as $name) {
                    $this->assertTrue(isset($relevant_fields_member_id[$name]), 'Could not find ' . $name . ' field in ' . $table);
                }
                foreach ($found_tables[$table]['ip_address_fields'] as $name) {
                    $this->assertTrue(isset($relevant_fields_ip_address[$name]), 'Could not find ' . $name . ' field in ' . $table);
                }
                foreach ($found_tables[$table]['email_fields'] as $name) {
                    $this->assertTrue(isset($relevant_fields_email[$name]), 'Could not find ' . $name . ' field in ' . $table);
                }
                foreach ($found_tables[$table]['additional_anonymise_fields'] as $name) {
                    $this->assertTrue(isset($all_fields[$name]), 'Could not find ' . $name . ' field in ' . $table);
                }
            } else {
//TODO                $this->assertTrue($total_fields == 0, 'Should be defined in a privacy hook: ' . $table); // TODO: Likely have to define some exceptions
            }
        }
    }
}
