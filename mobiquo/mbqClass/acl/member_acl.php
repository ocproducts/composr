<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */
/*EXTRA FUNCTIONS: TapatalkPush*/

class member_acl
{
    /**
     * Login.
     *
     * @param  string            Username
     * @param  string            Password
     * @param  boolean        Log in as invisible
     * @return ?MEMBER Member ID (null: login failed)
     */
    function authenticate_credentials_and_set_auth($username, $password, $invisible = false)
    {
        $feedback = $GLOBALS['FORUM_DRIVER']->forum_authorise_login($username, null, md5($password), $password);

        $id = $feedback['id'];
        if (!is_null($id)) {
            $this->set_auth($id, $invisible);

            return $id;
        }
        return null;
    }

    /**
     * Login with no password check.
     *
     * @param  MEMBER            Member ID
     * @param  boolean        Log in as invisible
     */
    function set_auth($id, $invisible = false)
    {
        require_code('users_active_actions');

        cms_setcookie(get_member_cookie(), strval($id));

        $password_hashed_salted = $GLOBALS['FORUM_DRIVER']->get_member_row_field($id, 'm_pass_hash_salted');
        cms_setcookie(get_pass_cookie(), $password_hashed_salted);

        if ($invisible) {
            require_code('users_active_actions');
            set_invisibility();
        }

        $push = new TapatalkPush();
        $push->set_is_tapatalk_member($id);

        header('Mobiquo_is_login: true');
    }

    /**
     * Logout.
     */
    function logout_user()
    {
        require_code('users_active_actions');
        handle_active_logout();
    }
}
