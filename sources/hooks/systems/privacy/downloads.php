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
 * @package    downloads
 */

/**
 * Hook class.
 */
class Hook_privacy_downloads extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('downloads')) {
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
                'download_downloads' => array(
                    'timestamp_field' => 'add_date',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('submitter'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'download_logging' => array(
                    'timestamp_field' => 'date_and_time',
                    'retention_days' => intval(get_option('website_activity_store_time')),
                    'retention_handle_method' => PRIVACY_METHOD_delete,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array('ip'),
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
            case 'download_logging':
                $ret += array(
                    'id__dereferenced' => get_translated_text($GLOBALS['SITE_DB']->query_select_value('download_downloads', 'name', array('id' => $row['id']))),
                );
                break;
        }

        return $ret;
    }

    /**
     * Delete a row.
     *
     * @param ID_TEXT Table name
     * @param array Row raw from the database
     */
    public function delete($table_name, $row)
    {
        switch ($table_name) {
            case 'download_downloads':
                require_code('downloads2');
                delete_download($row['id']);
                break;

            default:
                $this->delete($table_name, $row);
                break;
        }
    }
}
