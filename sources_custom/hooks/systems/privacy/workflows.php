<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    workflows
 */

/**
 * Hook class.
 */
class Hook_privacy_workflows extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('workflows')) {
            return null;
        }

        return array(
            'cookies' => array(
            ),

            'positive' => array(
            ),

            'general' => array(
            ),

            'database_records' => array(
                'workflow_content' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('original_submitter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'workflow_content_status' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('approved_by'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
            ),
        );
    }

    /**
     * Serialise a row.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $row Row raw from the database
     * @return array Row in a cleanly serialised format
     */
    public function serialise($table_name, $row)
    {
        $ret = $this->serialise($table_name, $row);

        switch ($table_name) {
            case 'workflow_content':
                require_code('content');
                list($content_title) = content_get_details($row['content_type'], $row['content_id']);
                $ret += array(
                    'content_id__dereferenced' => $content_title,
                );
                $workflow_name = $GLOBALS['SITE_DB']->query_select_value_if_there('workflows', 'workflow_name', array('id' => $row['workflow_id']));
                if ($workflow_name !== null) {
                    $ret += array(
                        'workflow_id__dereferenced' => get_translated_text($workflow_name),
                    );
                }
                break;

            case 'workflow_content_status':
                $content_title = null;
                $workflow_content_rows = $GLOBALS['SITE_DB']->query_select('workflow_content', array('*'), array('id' => $row['workflow_content_id']), '', 1);
                if (array_key_exists(0, $workflow_content_rows)) {
                    require_code('content');
                    list($content_title) = content_get_details($workflow_content_rows[0]['content_type'], $workflow_content_rows[0]['content_id']);
                }
                $ret += array(
                    'workflow_content_id_dereferenced' => $content_title,
                );
                $workflow_approval_name = $GLOBALS['SITE_DB']->query_select_value_if_there('workflow_approval_points', 'workflow_approval_name', array('id' => $row['id']));
                if ($workflow_approval_name !== null) {
                    $ret += array(
                        'workflow_approval_point_id__dereferenced' => get_translated_text($workflow_approval_name),
                    );
                }
                break;
        }

        return $ret;
    }
}
