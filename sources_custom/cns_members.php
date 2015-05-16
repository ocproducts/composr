<?php

/**
 * Find whether a member is bound to HTTP authentication (an exceptional situation, only for sites that use it).
 *
 * @param  MEMBER $member_id The member.
 * @return boolean The answer.
 */
function cns_is_httpauth_member($member_id)
{
    $scheme = $GLOBALS['CNS_DRIVER']->get_member_row_field($member_id, 'm_password_compat_scheme');

    if (($scheme == 'facebook') || ($scheme == 'openid')) {
        return true;
    }

    return $scheme == 'httpauth';
}
