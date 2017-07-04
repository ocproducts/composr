<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

 See text/EN/licence.txt for full licencing information.

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
        require_code('sugarcrm');

        global $SUGARCRM;

        if ($SUGARCRM === null) {
            return;
        }

        $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id);
        $email_address = $GLOBALS['FORUM_DRIVER']->get_member_email_address($member_id);

        require_code('cns_members');
        $cpfs = cns_get_all_custom_fields_match_member($member_id);

        $company_field = get_option('sugarcrm_company_field');

        $company = isset($cpfs[$company_field]) ? $cpfs[$company_field]['RAW'] : get_option('sugarcrm_default_company');

        list($first_name, $last_name) = deconstruct_long_name($username);

        // Find/create Account
        $account_id = get_or_create_sugarcrm_account($company);

        // Find/create Contact
        $contact_details = get_sugarcrm_contact($email_address, $account_id);
        if ($contact_details === null) {
            $data = array(
                'account_id' => array('name' => 'account_id', 'value' => $account_id),

                'email1' => array('name' => 'email1', 'value' => $email_address),

                'first_name' => array('name' => 'first_name', 'value' => $first_name),
                'last_name' => array('name' => 'last_name', 'value' => $last_name),
            );

            $contact_mappings = explode("\n", get_option('sugarcrm_contact_mappings'));
            foreach ($contact_mappings as $_mapping) {
                if (strpos($_mapping, '=') !== false) {
                    list($mapping_from, $mapping_to) = array_map('trim', explode('=', $_mapping, 2));
                    $data[$mapping_to] = array('name' => $mapping_to, 'value' => isset($cpfs[$mapping_from]) ? $cpfs[$mapping_from]['RAW'] : '');
                }
            }

            $response = $SUGARCRM->set(
                'Contacts',
                array_values($data)
            );
            $contact_id = $response['id'];
        } else {
            $contact_id = $contact_details['id'];
        }
        return $contact_id;
    }
}
