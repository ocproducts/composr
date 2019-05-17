<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Hook class.
 */
class Hook_login_provider_httpauth
{
    /**
     * Standard login provider hook.
     *
     * @param  ?MEMBER $member_id Member ID already detected as logged in (null: none). May be a guest ID.
     * @param  boolean $quick_only Whether to just do a quick check, don't establish new sessions
     * @return ?MEMBER Member ID now detected as logged in (null: none). May be a guest ID.
     */
    public function try_login($member_id, $quick_only = false)
    {
        // Various kinds of possible HTTP authentication
        // NB: We do even if we already have a session, as parts of the site may be HTTP-auth, and others not - so we need to let it work as an override
        if (get_forum_type() == 'cns') {
            if (get_value('windows_auth_is_enabled') === '1') {
                // For Windows auth, we force this always. For httpauth on non-Windows we let the .htaccess file force this, if the webmaster wants it
                require_code('users_inactive_occasionals');
                force_httpauth();
            }

            if ((function_exists('apache_request_headers')) && (get_value('force_admin_auth') === '1') && ($GLOBALS['FORUM_DRIVER']->is_super_admin($GLOBALS['FORUM_DRIVER']->get_member_from_username(preg_replace('#@.*$#', '', $_SERVER['PHP_AUTH_USER']))))) {
                $headers = apache_request_headers();
                if (!isset($headers['Authorization'])) {
                    require_code('site2');
                    redirect_exit(get_base_url() . 'admin_login/index.php');
                }
            }

            // Can we try to see if we're httpauth-bound instead?
            // Security note...
            // New httpauth users will be added as members. Don't edit this to make them be added as privileged members, because presence of PHP_AUTH_USER only guarantees an authentication if it passed though an appropriate .htaccess (which would have filtered bad authentications for us). We are ASSUMING here that this is the case and therefore this must not be a permissive thing (all useful modules should also be in a .htaccess or privilege protected zone to stop member spoofing)
            // As an alternative to the above, we will not allow httpauth to the welcome zone, as by convention, this is a place for visitors. If using httpauth, all other zones should have a relevant .htaccess.
            // We could store the password from the first login and authenticate against that: but we do not want to create a sync issue.
            // So to summarise, either:
            //  - Don't assign any special permissions to these kinds of members
            //  - or, lock off all zones with .htaccess other than root (and root has httpauth login denied)

            if ((!empty($_SERVER['PHP_AUTH_USER'])) && (($member_id === null) || (is_guest($member_id))) && ((get_option('httpauth_is_enabled') == '1') || (get_value('windows_auth_is_enabled') === '1'))) {
                require_code('users_inactive_occasionals');
                $member_id = try_httpauth_login();
            }
        }

        return $member_id;
    }
}
