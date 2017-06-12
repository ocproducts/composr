<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    sugarcrm
 */

class Hook_contact_forms_sugarcrm
{
    public function dispatch($subject, $body, $to_email, $to_name, $from_email, $from_name, $attachments, $body_parts, $body_prefix, $body_suffix)
    {
        require_code('sugarcrm');

        global $SUGARCRM;

        if ($SUGARCRM === null) {
            return false;
        }

        // Find/create Account
        $contact_details = get_sugarcrm_contact($from_email);
        if ($contact_details === null) {
            $account_id = get_or_create_sugarcrm_account(get_option('sugarcrm_default_company'));
        } else {
            $account_id = $contact_details['account_id'];
        }

        // Metadata
        foreach ($attachments as $file_path => $filename) {
            if ($filename == 'user_metadata.txt') {
                $metadata = json_decode(file_get_contents($file_path), true);
                foreach ($metadata as $key => $val) {
                    if (is_array($val)) {
                        if (!isset($val[0])) { // Not a list
                            $body_parts += $val;
                        }
                    } else {
                        $body_parts[$key] = $val;
                    }
                }
            }
        }

        // Create Case
        $data = array(
            'account_id' => array('name' => 'account_id', 'value' => $account_id),
            'name' => array('name' => 'name', 'value' => $subject),
            'description' => array('name' => 'description', 'value' => $body),
            'status' => array('name' => 'status', 'value' => 'New'),
            'priority' => array('name' => 'priority', 'value' => 'P2'),
        );
        $case_mappings = explode("\n", get_option('sugarcrm_case_mappings'));
        foreach ($case_mappings as $_mapping) {
            if (strpos($_mapping, '=') !== false) {
                list($mapping_from, $mapping_to) = array_map('trim', explode('=', $_mapping, 2));
                $data[$mapping_to] = array('name' => $mapping_to, 'value' => isset($body_parts[$mapping_from]) ? $body_parts[$mapping_from] : '');
            }
        }
        $response = $SUGARCRM->set(
            'Cases',
            $data
        );
        $case_id = $response['id'];

        // Create Contact underneath Case
        list($first_name, $last_name) = deconstruct_long_name($from_name);
        $data = array(
            array('name' => 'account_id', 'value' => $account_id),
            array('name' => 'email1', 'value' => $from_email),
            array('name' => 'first_name', 'value' => $first_name),
            array('name' => 'last_name', 'value' => $last_name),
        );
        $response = $SUGARCRM->set(
            'Contacts',
            $data
        );
        $contact_id = $response['id'];
        $SUGARCRM->set_relationship('Cases', $case_id, 'contacts', array($contact_id));

        // Create Documents underneath Case
        foreach ($attachments as $file_path => $filename) {
            list($first_name, $last_name) = deconstruct_long_name($from_name);
            $data = array(
                array('name' => 'document_name', 'value' => $filename),
                array('name' => 'revision', 'value' => '1'),
            );
            $response = $SUGARCRM->set(
                'Documents',
                $data
            );
            $document_id = $response['id'];
            $SUGARCRM->set_document_revision($document_id, $filename, $file_path, '1');
            $SUGARCRM->set_relationship('Cases', $case_id, 'documents', array($document_id));
        }

        return (get_option('sugarcrm_exclusive_contact') == '1');
    }
}
