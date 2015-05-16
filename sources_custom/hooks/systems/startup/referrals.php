<?php

/**
 * Hook class.
 */
class Hook_startup_referrals
{
    public function run()
    {
        // Store referrer in cookie
        $by_url = get_param_string('keep_referrer', '');
        if ($by_url != '') {
            $ini_file = parse_ini_file(get_custom_file_base() . '/text_custom/referrals.txt', true);
            if ((!isset($ini_file['referrer_cookies'])) || ($ini_file['referrer_cookies'] == '1')) {
                require_code('users_active_actions');
                cms_setcookie('referrer', $by_url);
            }
        }
    }
}
