<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    bankr
 */

/**
 * Hook class.
 */
class Hook_privacy_bankr extends Hook_privacy_base
{
    /**
     * Find privacy details.
     *
     * @return ?array A map of privacy details in a standardised format (null: disabled)
     */
    public function info()
    {
        if (!addon_installed('bankr')) {
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
                'bank' => array(
                    'timestamp_field' => 'add_time',
                    'retention_days' => null,
                    'retention_handle_method' => PRIVACY_METHOD_leave,
                    'member_id_fields' => array('member_id'),
                    'ip_address_fields' => array(),
                    'email_fields' => array(),
                    'additional_anonymise_fields' => array(),
                    'extra_where' => null,
                    'removal_default_handle_method' => PRIVACY_METHOD_delete,
                    'allowed_handle_methods' => PRIVACY_METHOD_delete,
                ),
            ),
        );
    }
}
