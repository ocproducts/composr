<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/*EXTRA FUNCTIONS: apache\_.+*/

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__users()
{
    global $SESSION_CACHE, $MEMBER_CACHED;
    global $USER_NAME_CACHE, $USERS_GROUPS_CACHE;
    global $SESSION_CONFIRMED_CACHE, $GETTING_MEMBER, $USER_THEME_CACHE, $EMOTICON_LEVELS;
    $EMOTICON_LEVELS = null;
    $USER_NAME_CACHE = array();
    $USERS_GROUPS_CACHE = array();
    $MEMBER_CACHED = null;
    $SESSION_CONFIRMED_CACHE = false;
    $GETTING_MEMBER = false;
    $USER_THEME_CACHE = null;
    global $IS_ACTUALLY;
    global $IS_ACTUALLY_ADMIN;
    /** Find whether Composr is running in SU mode, and therefore the real user is an admin
     *
     * @global boolean $IS_ACTUALLY_ADMIN
     */
    $IS_ACTUALLY_ADMIN = false;
    $IS_ACTUALLY = null;
    global $IS_A_COOKIE_LOGIN;
    $IS_A_COOKIE_LOGIN = false;
    global $DOING_USERS_INIT;
    $DOING_USERS_INIT = true;
    global $IS_VIA_BACKDOOR;
    $IS_VIA_BACKDOOR = false;
    global $DID_CHANGE_SESSION_ID;
    $DID_CHANGE_SESSION_ID = false;

    // Load all sessions into memory, if possible
    if (get_option('session_prudence') == '0' && function_exists('persistent_cache_get')) {
        $SESSION_CACHE = persistent_cache_get('SESSION_CACHE');
    } else {
        $SESSION_CACHE = null;
    }
    global $IN_MINIKERNEL_VERSION;
    if ((!is_array($SESSION_CACHE)) && (!$IN_MINIKERNEL_VERSION)) {
        if (get_option('session_prudence') == '0') {
            $where = '';
        } else {
            $where = ' WHERE ' . db_string_equal_to('the_session', get_session_id()) . ' OR ' . db_string_equal_to('ip', get_ip_address(3));
        }
        $SESSION_CACHE = array();
        if ((get_forum_type() == 'cns') && (!is_on_multi_site_network())) {
            push_db_scope_check(false);
            $_s = $GLOBALS['SITE_DB']->query('SELECT s.*,m.m_primary_group FROM ' . get_table_prefix() . 'sessions s LEFT JOIN ' . $GLOBALS['SITE_DB']->get_table_prefix() . 'f_members m ON m.id=s.member_id' . $where, null, null, true, true);
            if ($_s === null) {
                $_s = array();
            }
            $SESSION_CACHE = list_to_map('the_session', $_s);
            pop_db_scope_check();
        } else {
            $SESSION_CACHE = list_to_map('the_session', $GLOBALS['SITE_DB']->query('SELECT * FROM ' . get_table_prefix() . 'sessions' . $where));
        }
        if (get_option('session_prudence') == '0' && function_exists('persistent_cache_set')) {
            persistent_cache_set('SESSION_CACHE', $SESSION_CACHE);
        }
    }

    // Canonicalise various disparities in how HTTP auth environment variables are set
    if (!empty($_SERVER['REDIRECT_REMOTE_USER'])) {
        $_SERVER['PHP_AUTH_USER'] = preg_replace('#@.*$#', '', $_SERVER['REDIRECT_REMOTE_USER']);
    }
    if (!empty($_SERVER['PHP_AUTH_USER'])) {
        $_SERVER['PHP_AUTH_USER'] = preg_replace('#@.*$#', '', $_SERVER['PHP_AUTH_USER']);
    }
    if (!empty($_SERVER['REMOTE_USER'])) {
        $_SERVER['PHP_AUTH_USER'] = preg_replace('#@.*$#', '', $_SERVER['REMOTE_USER']);
    }

    $DOING_USERS_INIT = null;
}

/**
 * Handles an attempted login or logout, and take care of all the sessions and cookies etc.
 */
function handle_logins()
{
    if (get_param_integer('httpauth', 0) == 1) {
        require_code('users_inactive_occasionals');
        force_httpauth();
    }
    $username = trim(post_param_string('login_username', '', INPUT_FILTER_DEFAULT_POST & ~INPUT_FILTER_ALLOWED_POSTING_SITES));
    if (($username != '') && ($username != do_lang('GUEST'))) {
        require_code('users_active_actions');
        handle_active_login($username);
    }

    // If it was a log out
    $page = get_param_string('page', ''); // Not get_page_name for bootstrap order reasons
    if (($page == 'login') && (get_param_string('type', '', INPUT_FILTER_GET_COMPLEX) == 'logout')) {
        require_code('users_active_actions');
        handle_active_logout();
    }
}

/**
 * Find whether the current member is a guest.
 *
 * @param  ?MEMBER $member_id Member ID to check (null: current user)
 * @param  boolean $quick_only Whether to just do a quick check, don't establish new sessions
 * @return boolean Whether the current member is a guest
 */
function is_guest($member_id = null, $quick_only = false)
{
    if (!isset($GLOBALS['FORUM_DRIVER'])) {
        return true;
    }
    if ($member_id === null) {
        $member_id = get_member($quick_only);
    }
    return ($GLOBALS['FORUM_DRIVER']->get_guest_id() == $member_id);
}

/**
 * Get the ID of the currently active member.
 * It see's if the session exists / cookie is valid -- and gets the member ID accordingly
 *
 * @param  boolean $quick_only Whether to just do a quick check, don't establish new sessions
 * @return MEMBER The member requesting this web page (possibly the guest member - which strictly speaking, is not a member)
 */
function get_member($quick_only = false)
{
    global $SESSION_CACHE, $MEMBER_CACHED, $GETTING_MEMBER, $SITE_INFO;

    if ($MEMBER_CACHED !== null) {
        return $MEMBER_CACHED;
    }

    if (!isset($GLOBALS['FORUM_DRIVER'])) {
        load_user_stuff();
    }

    // If lots of aging sessions, clean out
    reset($SESSION_CACHE);
    if ((count($SESSION_CACHE) > 50) && ($SESSION_CACHE[key($SESSION_CACHE)]['last_activity'] < time() - intval(60.0 * 60.0 * max(0.017, floatval(get_option('session_expiry_time')))))) {
        delete_expired_sessions_or_recover();
    }

    // Try via restricted_manually_enabled_backdoor that someone with full server access can place
    $backdoor_ip_address = mixed(); // Enable to a real IP address to force login from FTP access (if lost admin password)
    if (!empty($SITE_INFO['backdoor_ip'])) {
        $backdoor_ip_address = normalise_ip_address($SITE_INFO['backdoor_ip']);
    }
    if ((is_string($backdoor_ip_address)) && ($backdoor_ip_address != '') && ((get_ip_address() == $backdoor_ip_address) || ((get_ip_address() == '0000:0000:0000:0000:0000:0000:0000:0001') && (($backdoor_ip_address == '::1') || ($backdoor_ip_address == '127.0.0.1'))))) {
        require_code('users_active_actions');
        if (function_exists('restricted_manually_enabled_backdoor')) { // May be trying to check in safe mode when doing above require_code, so recurse
            $MEMBER_CACHED = restricted_manually_enabled_backdoor();
            // Will have created a session in here already
            return $MEMBER_CACHED;
        }
    }

    if ($GETTING_MEMBER) {
        if (!isset($GLOBALS['FORUM_DRIVER'])) {
            return db_get_first_id(); // :S
        }
        return $GLOBALS['FORUM_DRIVER']->get_guest_id();
    }
    $GETTING_MEMBER = true;

    global $FORCE_INVISIBLE_GUEST;
    if ($FORCE_INVISIBLE_GUEST) {
        $GETTING_MEMBER = false;
        if (!isset($GLOBALS['FORUM_DRIVER'])) {
            fatal_exit(do_lang_tempcode('INTERNAL_ERROR'));
        }
        $MEMBER_CACHED = $GLOBALS['FORUM_DRIVER']->get_guest_id();
        return $MEMBER_CACHED;
    }

    $member = null;

    $cookie_bits = explode(':', str_replace('|', ':', get_member_cookie()));
    $base = $cookie_bits[0];

    // Try by session
    $session = get_session_id();
    if (($session != '') && (get_param_integer('keep_force_htaccess', 0) == 0)) {
        $ip = get_ip_address(3); // I hope AOL can cope with this
        $allow_unbound_guest = true; // Note: Guest sessions are not IP bound
        $member_row = null;

        if (
            ($SESSION_CACHE !== null) &&
            (array_key_exists($session, $SESSION_CACHE)) &&
            ($SESSION_CACHE[$session] !== null) &&
            (array_key_exists('member_id', $SESSION_CACHE[$session])) &&
            ((get_option('ip_strict_for_sessions') == '0') || ($SESSION_CACHE[$session]['ip'] == $ip) || ((is_guest($SESSION_CACHE[$session]['member_id'])) && ($allow_unbound_guest)) || (($SESSION_CACHE[$session]['session_confirmed'] == 0) && (!is_guest($SESSION_CACHE[$session]['member_id'])))) &&
            ($SESSION_CACHE[$session]['last_activity'] > time() - intval(60.0 * 60.0 * max(0.017, floatval(get_option('session_expiry_time')))))
        ) {
            $member_row = $SESSION_CACHE[$session];
        }
        if (($member_row !== null) && ((!array_key_exists($base, $_COOKIE)) || (!is_guest($member_row['member_id'])))) {
            $member = $member_row['member_id'];

            if (($member !== null) && ((time() - $member_row['last_activity']) > 10)) { // Performance optimisation. Pointless re-storing the last_activity if less than 3 seconds have passed!
                if (!running_script('index')) { // For 'index' it happens in get_screen_title, as screen meta-information is used
                    $GLOBALS['SITE_DB']->query_update('sessions', array('last_activity' => time()), array('the_session' => $session), '', 1);
                }
                $SESSION_CACHE[$session]['last_activity'] = time();
                if (get_option('session_prudence') == '0' && function_exists('persistent_cache_set')) {
                    persistent_cache_set('SESSION_CACHE', $SESSION_CACHE);
                }
            }
            global $SESSION_CONFIRMED_CACHE;
            $SESSION_CONFIRMED_CACHE = ($member_row['session_confirmed'] == 1);

            if ((!is_guest($member)) && ($GLOBALS['FORUM_DRIVER']->is_banned($member)) && (!$GLOBALS['IS_VIA_BACKDOOR'])) { // All hands to the guns
                warn_exit(do_lang_tempcode('YOU_ARE_BANNED'));
            }

            // Test this member still exists
            if ($GLOBALS['FORUM_DRIVER']->get_username($member) === null) {
                $member = $GLOBALS['FORUM_DRIVER']->get_guest_id();
            }

            if (array_key_exists($base, $_COOKIE)) {
                global $IS_A_COOKIE_LOGIN;
                $IS_A_COOKIE_LOGIN = true;
            }
        } else {
            require_code('users_inactive_occasionals');
            set_session_id('');
        }
    }

    if (($member === null) && (get_session_id() == '') && (get_param_integer('keep_force_htaccess', 0) == 0)) {
        // Try by cookie (will defer to forum driver to authorise against detected cookie)
        require_code('users_inactive_occasionals');
        $member = try_cookie_login();

        // Can forum driver help more directly?
        if (method_exists($GLOBALS['FORUM_DRIVER'], 'get_member')) {
            $member = $GLOBALS['FORUM_DRIVER']->get_member();
        }
    }

    // Try via additional login providers. They can choose whether to respect existing $member of get_session_id() settings. Some may do an account linkage, so we need to let them decide what to do.
    $hooks = find_all_hook_obs('systems', 'login_providers', 'Hook_login_provider_');
    foreach ($hooks as $ob) {
        $member = $ob->try_login($member);
    }

    // Try via GAE Console
    if (GOOGLE_APPENGINE) {
        if (gae_is_admin()) {
            require_code('users_active_actions');
            if (function_exists('restricted_manually_enabled_backdoor')) { // May be trying to check in safe mode when doing above require_code, so recurse
                $MEMBER_CACHED = restricted_manually_enabled_backdoor();
                // Will have created a session in here already
                return $MEMBER_CACHED;
            }
        }
    }

    // Guest or banned
    if ($member === null) {
        $member = $GLOBALS['FORUM_DRIVER']->get_guest_id();
        $is_guest = true;
    } else {
        $is_guest = is_guest($member);
    }

    // If we are doing a very quick init, bomb out now - no need to establish session etc
    global $SITE_INFO;
    if ($quick_only) {
        $GETTING_MEMBER = false;
        return $member;
    }

    // If one of the try_* functions hasn't actually created the session, call it here
    $session = get_session_id();
    if ($session == '') {
        require_code('users_inactive_occasionals');
        create_session($member);
    }

    // If we are logged in, maybe do some further processing
    if (!$is_guest) {
        // Is there a su operation?
        $ks = get_param_string('keep_su', '');
        if ($ks != '') {
            require_code('users_inactive_occasionals');
            $member = try_su_login($member);
        }

        // Run hooks, if any exist
        $hooks = find_all_hook_obs('systems', 'upon_login', 'Hook_upon_login_');
        foreach ($hooks as $ob) {
            $ob->run(false, null, $member); // false means "not a new login attempt"
        }
    }

    // Ok we have our answer
    $MEMBER_CACHED = $member;
    $GETTING_MEMBER = false;

    // We call this to ensure any HTTP-auth specific code has a chance to run
    is_httpauth_login();

    if ($member !== null) {
        enforce_temporary_passwords($member);

        if (get_forum_type() == 'cns') {
            $GLOBALS['FORUM_DRIVER']->cns_flood_control($member);
        }
    }

    return $member;
}

/**
 * Make sure temporary passwords restrict you to the edit account page. May not return, if it needs to do a redirect.
 *
 * @param  MEMBER $member The current member
 */
function enforce_temporary_passwords($member)
{
    if ((get_forum_type() == 'cns') && (running_script('index')) && ($member != db_get_first_id()) && (!$GLOBALS['IS_ACTUALLY_ADMIN']) && ($GLOBALS['FORUM_DRIVER']->get_member_row_field($member, 'm_password_compat_scheme') == 'temporary') && (get_page_name() != 'lost_password') && ((get_page_name() != 'members') || (get_param_string('type', 'browse') != 'view'))) {
        require_code('users_active_actions');
        _enforce_temporary_passwords($member);
    }
}

/**
 * Get the display name of a username.
 * If no display name generator is configured, this will be the same as the username.
 *
 * @param  ID_TEXT $username The username
 * @return SHORT_TEXT The display name
 */
function get_displayname($username)
{
    if ($username == do_lang('UNKNOWN')) {
        return $username;
    }
    if ($username == do_lang('GUEST')) {
        return $username;
    }
    if ($username == do_lang('DELETED')) {
        return $username;
    }

    if (method_exists($GLOBALS['FORUM_DRIVER'], 'get_displayname')) {
        $displayname = $GLOBALS['FORUM_DRIVER']->get_displayname($username);
        return ($displayname === null) ? $username : $displayname;
    }

    return $username;
}

/**
 * Apply hashing to some input. To this date, all forum drivers use md5, but some use it differently.
 * This function will pass through the parameters to an equivalent forum_md5 function if it is defined.
 *
 * @param  string $data The data to hash (the password in actuality)
 * @param  string $key The string converted member-ID in actuality, although this function is more general
 * @return string The hashed data
 */
function apply_forum_driver_md5_variant($data, $key)
{
    if (method_exists($GLOBALS['FORUM_DRIVER'], 'forum_md5')) {
        return $GLOBALS['FORUM_DRIVER']->forum_md5($data, $key);
    }
    return md5($data);
}

/**
 * Get the current session ID.
 *
 * @return ID_TEXT The current session ID (blank: none)
 */
function get_session_id()
{
    $cookie_var = get_session_cookie();

    if ((!isset($_COOKIE[$cookie_var])) || (/*To work around Commandr's development mode trick*/$GLOBALS['DEV_MODE'] && running_script('commandr'))) {
        if (array_key_exists('keep_session', $_GET)) {
            return get_param_string('keep_session');
        }
        return '';
    }
    return isset($_COOKIE[$cookie_var]) ? $_COOKIE[$cookie_var] : '';
}

/**
 * Find whether the current member is logged in via httpauth.
 *
 * @return boolean Whether the current member is logged in via httpauth
 */
function is_httpauth_login()
{
    if (get_forum_type() != 'cns') {
        return false;
    }
    if (is_guest()) {
        return false;
    }

    require_code('cns_members');
    return ((!empty($_SERVER['PHP_AUTH_USER'])) && (cns_authusername_is_bound_via_httpauth($_SERVER['PHP_AUTH_USER']) !== null));
}

/**
 * Make sure that the given URL contains a session if cookies are disabled.
 * NB: This is used for login redirection. It had to add the session ID into the redirect url.
 *
 * @param  URLPATH $url The URL to enforce results in session persistence for the user
 * @return URLPATH The fixed URL (potentially nothing was done, depending on cookies)
 */
function enforce_sessioned_url($url)
{
    if ((!has_cookies()) && (get_bot_type() === null)) {
        require_code('users_inactive_occasionals');
        return _enforce_sessioned_url($url);
    }
    return $url;
}

/**
 * Find what sessions are expired and delete them, and recover an existing one for $member if there is one.
 *
 * @param  ?MEMBER $member User to get a current session for (null: do not try, which guarantees a return result of null also)
 * @return ?AUTO_LINK The session ID we rebound to (null: did not rebind)
 */
function delete_expired_sessions_or_recover($member = null)
{
    $new_session = null;

    $ip = get_ip_address(3);

    // Delete expired sessions; it's important we do this reasonably routinely, as the session table is loaded up and can get large -- unless we aren't tracking online users, in which case the table is never loaded up
    if (mt_rand(0, 1000) == 50) {
        if (!$GLOBALS['SITE_DB']->table_is_locked('sessions')) {
            $GLOBALS['SITE_DB']->query('DELETE FROM ' . get_table_prefix() . 'sessions WHERE last_activity<' . strval(time() - intval(60.0 * 60.0 * max(0.017, floatval(get_option('session_expiry_time'))))));
        }
    }

    // Look through sessions
    $dirty_session_cache = false;
    global $SESSION_CACHE;
    $_session = mixed();
    foreach ($SESSION_CACHE as $_session => $row) {
        if (!array_key_exists('member_id', $row)) {
            continue; // Workaround to HHVM weird bug
        }

        if (is_integer($_session)) {
            $_session = strval($_session);
        }

        // Delete expiry from cache
        if ($row['last_activity'] < time() - intval(60.0 * 60.0 * max(0.017, floatval(get_option('session_expiry_time'))))) {
            $dirty_session_cache = true;
            unset($SESSION_CACHE[$_session]);
            continue;
        }

        // Get back to prior session if there was one (NB: we don't turn guest sessions into member sessions, as that would increase risk of there being a session fixation vulnerability)
        if ($member !== null) {
            if (($row['member_id'] == $member) && (((get_option('ip_strict_for_sessions') == '0') && ($member != $GLOBALS['FORUM_DRIVER']->get_guest_id())) || ($row['ip'] == $ip)) && ($row['last_activity'] > time() - intval(60.0 * 60.0 * max(0.017, floatval(get_option('session_expiry_time')))))) {
                $new_session = $_session;
            }
        }
    }
    if ($dirty_session_cache) {
        if (get_option('session_prudence') == '0' && function_exists('persistent_cache_set')) {
            persistent_cache_set('SESSION_CACHE', $SESSION_CACHE);
        }
    }

    return $new_session;
}

/**
 * Get the member cookie's name.
 *
 * @return string The member username/ID (depending on forum driver) cookie's name
 */
function get_member_cookie()
{
    global $SITE_INFO;
    if (empty($SITE_INFO['user_cookie'])) {
        $SITE_INFO['user_cookie'] = 'cms_member_id';
    }
    return $SITE_INFO['user_cookie'];
}

/**
 * Get the session cookie's name.
 *
 * @return string The session ID cookie's name
 */
function get_session_cookie()
{
    global $SITE_INFO;
    if (empty($SITE_INFO['session_cookie'])) {
        $SITE_INFO['session_cookie'] = 'cms_session';
    }
    return $SITE_INFO['session_cookie'];
}

/**
 * Get the member password cookie's name.
 *
 * @return string The member password cookie's name
 */
function get_pass_cookie()
{
    global $SITE_INFO;
    if (empty($SITE_INFO['pass_cookie'])) {
        $SITE_INFO['pass_cookie'] = 'cms_member_hash';
    }
    return $SITE_INFO['pass_cookie'];
}

/**
 * Get a cookie value.
 *
 * @param  string $name The name of the cookie
 * @param  ?string $default The default value (null: just use the value null)
 * @return ?string The value stored in the cookie (null: the default default)
 */
function cms_admirecookie($name, $default = null)
{
    if (!isset($_COOKIE[$name])) {
        return $default;
    }
    $the_cookie = $_COOKIE[$name];
    return $the_cookie;
}

/**
 * Get the value of a special 'cms_' custom profile field. For Conversr it can also do it for a pure field title, e.g. "Example Field".
 *
 * @param  ID_TEXT $cpf The CPF name stem
 * @param  ?MEMBER $member Member to lookup for (null: current member)
 * @return string The value (blank: has a blank value, or does not exist)
 */
function get_cms_cpf($cpf, $member = null)
{
    if ($member === null) {
        $member = get_member();
    }

    $values = $GLOBALS['FORUM_DRIVER']->get_custom_fields($member);
    if ($values === null) {
        return '';
    }

    if (array_key_exists($cpf, $values)) {
        $ret = $values[$cpf];
        if (is_object($ret)) {
            $ret = $ret->evaluate();
        }
        return $ret;
    }

    if (get_forum_type() == 'cns') {
        $values = cns_get_all_custom_fields_match_member($member);
        if (array_key_exists($cpf, $values)) {
            return $values[$cpf]['RAW'];
        }
    }

    return '';
}

/**
 * Get the name of the default theme, assuming it exists. This is based on the site name.
 *
 * @return string Theme name
 */
function get_default_theme_name()
{
    return substr(preg_replace('#[^A-Za-z\d]#', '_', get_site_name()), 0, 80);
}
