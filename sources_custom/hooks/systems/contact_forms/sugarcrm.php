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

class Hook_contact_forms_sugarcrm
{
    public function dispatch($subject, $body, $to_email, $to_name, $from_email, $from_name, $attachments, $body_parts, $body_prefix, $body_suffix)
    {
        require_code('sugarcrm');

        global $SUGARCRM;

        if ($SUGARCRM === null) {
            return false;
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

        // Find/create Contact
        $contact_details = get_sugarcrm_contact($from_email);

        // Name fields
        list($first_name, $last_name) = deconstruct_long_name($from_name);

        // Create Case/Lead
        $sync_type = get_option('sugarcrm_messaging_sync_type');
        $data = array(
            'status' => array('name' => 'status', 'value' => 'New'),
        );
        switch ($sync_type) {
            case 'Cases':
                // Find/create Account
                if ($contact_details === null) {
                    $account_id = get_or_create_sugarcrm_account(get_option('sugarcrm_default_company'));
                } else {
                    $account_id = $contact_details['account_id'];
                }

                $data += array(
                    // These are for Case-only
                    'account_id' => array('name' => 'account_id', 'value' => $account_id),
                    'name' => array('name' => 'name', 'value' => $subject),
                    'description' => array('name' => 'description', 'value' => $body),
                    'priority' => array('name' => 'priority', 'value' => 'P2'),
                );
                break;

            case 'Leads':
                if ($contact_details === null) {
                    $account_name = get_option('sugarcrm_default_company');
                } else {
                    $account_name = $contact_details['name'];
                }

                $data += array(
                    // These are for Lead-only
                    'account_name' => array('name' => 'account_name', 'value' => $account_name),
                    'description' => array('name' => 'description', 'value' => $subject),
                    'email1' => array('name' => 'email1', 'value' => $from_email),
                    'first_name' => array('name' => 'first_name', 'value' => $first_name),
                    'last_name' => array('name' => 'last_name', 'value' => $last_name),
                    'lead_source' => array('name' => 'lead_source', 'value' => 'Web Site'),
                );
                break;
        }
        $messaging_mappings = explode("\n", get_option('sugarcrm_messaging_mappings'));
        foreach ($messaging_mappings as $_mapping) {
            if (strpos($_mapping, '=') !== false) {
                list($mapping_from, $mapping_to) = array_map('trim', explode('=', $_mapping, 2));
                if ((isset($data[$mapping_to])) && ($data[$mapping_to]['value'] != '')) {
                    if (isset($body_parts[$mapping_from])) {
                        $data[$mapping_to]['value'] .= "\n\n" . $body_parts[$mapping_from];
                    }
                } else {
                    $data[$mapping_to] = array('name' => $mapping_to, 'value' => isset($body_parts[$mapping_from]) ? $body_parts[$mapping_from] : '');
                }
            }
        }
        $response = $SUGARCRM->set(
            $sync_type,
            array_values($data)
        );
        $entity_id = $response['id'];

        // Create Contact underneath Case (for Lead it is part of the main set of Lead fields)
        if ($sync_type == 'Cases') {
            $data = array(
                'account_id' => array('name' => 'account_id', 'value' => $account_id),
                'email1' => array('name' => 'email1', 'value' => $from_email),
                'first_name' => array('name' => 'first_name', 'value' => $first_name),
                'last_name' => array('name' => 'last_name', 'value' => $last_name),
            );
            $response = $SUGARCRM->set(
                'Contacts',
                array_values($data)
            );
            $contact_id = $response['id'];
            $SUGARCRM->set_relationship($sync_type, $entity_id, 'contacts', array($contact_id));
        }

        // Create Notes under Lead
        if ($sync_type == 'Leads') {
            foreach ($attachments as $file_path => $filename) {
                $data = array(
                    'name' => array('name' => 'name', 'value' => $filename),
                    'description' => array('name' => 'description', 'value' => ''),
                    'parent_type' => array('name' => 'parent_type', 'value' => 'Leads'),
                    'parent_id' => array('name' => 'parent_id', 'value' => $entity_id),
                );
                if ($contact_details !== null) {
                    $data['contact_id'] = array('name' => 'contact_id', 'value' => $contact_details['id']);
                }
                $response = $SUGARCRM->set(
                    'Notes',
                    array_values($data)
                );
                $note_id = $response['id'];
                $SUGARCRM->set_note_attachment($note_id, base64_encode(file_get_contents($file_path)), $filename);
            }
        }

        // Create Documents underneath Case
        if ($sync_type == 'Cases') {
            foreach ($attachments as $file_path => $filename) {
                $data = array(
                    'document_name' => array('name' => 'document_name', 'value' => $filename),
                    'revision' => array('name' => 'revision', 'value' => '1'),
                );
                $response = $SUGARCRM->set(
                    'Documents',
                    array_values($data)
                );
                $document_id = $response['id'];
                $SUGARCRM->set_document_revision($document_id, $filename, $file_path, '1');
                $SUGARCRM->set_relationship($sync_type, $entity_id, 'documents', array($document_id));
            }
        }

        return (get_option('sugarcrm_exclusive_messaging') == '1');
    }
}

/*
Notes...

When posting to SugarCRM API, SugarCRM won't do required-field validation.
SugarCRM is basically a data dump at the low-level.
Unrecognised values are silently-skipped.
*/
