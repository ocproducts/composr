<?php

/**
 * Hook class.
 */
class Hook_symbol_FB_CONNECT_FINISHING_PROFILE
{
    public function run($param)
    {
        require_code('facebook_connect');

        if (isset($GLOBALS['FACEBOOK_FINISHING_PROFILE'])) {
            return '1';
        }
        return '0';
    }
}
