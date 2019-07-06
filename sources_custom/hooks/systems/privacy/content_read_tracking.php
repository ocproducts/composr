<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    content_read_tracking
 */

/**
 * Hook class.
 */
class Hook_privacy_content_read_tracking extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('content_read_tracking')) {
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
                'content_read' => array(
                    'timestamp_field' => 'r_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('r_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
            ),
        );
    }

    /**
     * Serialise a row.
     *
     * @param ID_TEXT Table name
     * @param array Row raw from the database
     * @return array Row in a cleanly serialised format
     */
    public function serialise($table_name, $row)
    {
        $ret = serialise($table_name, $row);

        switch ($table_name) {
            case 'TODO':
        }

        return $ret;
    }
}
