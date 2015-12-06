<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    composr_mobile_sdk
 */

/**
 * Store a device notification token (i.e. identification of a device, so we can send notifications to it).
 *
 * @param  string $token_type Device type
 * @set ios android
 * @return array Response data
 */
function store_device_notifications_token($token_type)
{
    $member_id = either_param_integer('member');
    $token = either_param_string('token');

    $member_details = $GLOBALS['SITE_DB']->query_select('f_members', array('id'), array('id' => $member_id), '', 1);
    if (isset($member_details[0])) {
        $GLOBALS['SITE_DB']->query_delete('device_token_details', array('member_id' => $member_id, 'token_type' => $token_type));
        $GLOBALS['SITE_DB']->query_insert('device_token_details', array(
            'token_type' => $token_type,
            'member_id' => $member_id,
            'device_token' => $token,
        ));
        return array('status' => 1, 'data' => do_lang('SUCCESS'));
    }
    return array('status' => 0, 'data' => do_lang('MEMBER_NOT_EXISTS'));
}
