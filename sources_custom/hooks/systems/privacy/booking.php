<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    booking
 */

/**
 * Hook class.
 */
class Hook_privacy_booking extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('booking')) {
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
                'bookable' => array(
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
                'booking' => array(
                    'timestamp_field' => 'booked_at',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array('customer_email'),
                    'additional_anonymise_fields' => array('customer_name', 'customer_mobile', 'customer_phone'),
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
            case 'booking':
                $title = $GLOBALS['SITE_DB']->query_select_value_if_there('bookable', 'title', array('id' => $row['bookable_id']));
                if ($title !== null) {
                    $ret += array(
                        'bookable_id__dereferenced' => get_translated_text($title),
                    );
                }
                break;
        }

        return $ret;
    }

    /**
     * Delete a row.
     *
     * @param  ID_TEXT $table_name Table name
     * @param  array $row Row raw from the database
     */
    public function delete($table_name, $row)
    {
        switch ($table_name) {
            case 'delete_bookable':
                require_code('booking2');
                delete_booking($row['id']);
                break;

            case 'booking':
                require_code('booking2');
                delete_booking($row['id']);
                break;

            default:
                $this->delete($table_name, $row);
                break;
        }
    }
}
