<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_homesite
 */

/**
 * Hook class.
 */
class Hook_privacy_composr_homesite extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('composr_homesite')) {
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
                'sites' => array(
                    'timestamp_field' => 's_add_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('s_member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_anonymise,
                ),
                'sites_email' => array(
                    'timestamp_field' => null,
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array(),
                    'ip_address_fields' => array(),
                    'email_fields' => array('s_email_to'),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                ),
            ),
        );
    }
}
