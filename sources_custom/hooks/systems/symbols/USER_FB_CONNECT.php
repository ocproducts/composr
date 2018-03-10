<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    facebook_support
 */

/**
 * Hook class.
 */
class Hook_symbol_USER_FB_CONNECT
{
    public function run($param)
    {
        require_code('facebook_connect');

        if (!array_key_exists(0, $param)) {
            return '';
        }

        $member_id = intval($param[0]);

        $value = '';
        if ((get_forum_type() == 'cns') && ($GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id, 'm_password_compat_scheme') == 'facebook')) {
            // Find Facebook ID via their member profile (we stashed it in here; authorisation stuff is never stored in DB, only on Facebook and user's JS)...

            $value = $GLOBALS['FORUM_DRIVER']->get_member_row_field($param[0], 'm_pass_hash_salted');
        } else {
            // Okay, look to see if they have set up syndication permissions instead, which is the other way around: stores authorisation, but not Facebook ID...

            $token = get_value('facebook_oauth_token__' . strval($member_id), null, true);
            if (($token === null) || ($token == '')) {
                return '';
            }

            $appid = get_option('facebook_appid');
            $appsecret = get_option('facebook_secret_code');
            try {
                $facebook_connect = new Facebook(array('appId' => $appid, 'secret' => $appsecret));
                $facebook_connect->setAccessToken($token);
                $temp_cookie = $_COOKIE;
                $fb_user = $facebook_connect->getUser();
                $_COOKIE = $temp_cookie;
                $value = is_null($fb_user) ? '' : strval($fb_user);
                if ($value == '0') {
                    $value = '';
                }
            } catch (Exception $e) {
                $value = '';
            }
        }
        return $value;
    }
}
