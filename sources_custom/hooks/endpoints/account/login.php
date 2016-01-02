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
 * Hook class.
 */
class Hook_endpoint_account_login
{
    /**
     * Run an API endpoint.
     *
     * @param  ?string $type Standard type parameter, usually either of add/edit/delete/view (null: not-set).
     * @param  ?string $id Standard ID parameter (null: not-set).
     * @return array Data structure that will be converted to correct response type.
     */
    public function run($type, $id)
    {
        $username = trim(post_param_string('username'));
        $password = trim(post_param_string('password'));

        $feedback = $GLOBALS['FORUM_DRIVER']->forum_authorise_login($username, null, apply_forum_driver_md5_variant($password, $username), $password);
        $id = $feedback['id'];
        if (is_null($id)) {
            warn_exit($feedback['error']);
        }

        require_code('cns_general');
        require_code('users_active_actions');

        cms_setcookie(get_member_cookie(), strval($id));
        $password_hashed_salted = $GLOBALS['FORUM_DRIVER']->get_member_row_field($id, 'm_pass_hash_salted');
        $password_compat_scheme = $GLOBALS['FORUM_DRIVER']->get_member_row_field($id, 'm_password_compat_scheme');
        if ($password_compat_scheme == 'plain') { // can't do direct representation for this, would be a plain text cookie; so in forum_authorise_login we expect it to be md5'd and compare thusly (as per non-cookie call to that function)
            $password_hashed_salted = md5($password_hashed_salted);
        }
        cms_setcookie(get_pass_cookie(), $password_hashed_salted);

        $data = cns_read_in_member_profile($id);
        $data['device_auth_member_id_cn'] = get_member_cookie();
        $data['device_auth_pass_hashed_cn'] = get_pass_cookie();
        $data['device_auth_member_id_vl'] = strval($id);
        $data['device_auth_pass_hashed_vl'] = $password_hashed_salted;
        return $data;
    }
}
