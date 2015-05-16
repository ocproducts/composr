<?php

/**
 * Process a logout.
 */
function handle_active_logout()
{
    if (get_forum_type() == 'cns') {
        $compat = $GLOBALS['FORUM_DRIVER']->get_member_row_field(get_member(), 'm_password_compat_scheme');
    } else {
        $compat = '';
    }

    non_overridden__handle_active_logout();

    if ($compat == 'facebook') {
        $GLOBALS['FACEBOOK_LOGOUT'] = true;
        @ob_end_clean();
        echo ' ';
        flush(); // Force headers to be sent so it's not an HTTP header request so Facebook can do it's JS magic
    }
    $GLOBALS['MEMBER_CACHED'] = $GLOBALS['FORUM_DRIVER']->get_guest_id();
}
