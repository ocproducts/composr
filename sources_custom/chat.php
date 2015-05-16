<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

if (!function_exists('init__chat')) {
    function init__chat()
    {
        global $MEMBERS_BEFRIENDED_CACHE;
        $MEMBERS_BEFRIENDED_CACHE = null;

        global $EFFECT_SETTINGS_ROWS;
        $EFFECT_SETTINGS_ROWS = null;

        if (!defined('CHAT_ACTIVITY_PRUNE')) {
            define('CHAT_ACTIVITY_PRUNE', 25);
            define('CHAT_BACKLOG_TIME', 60 * 5); // 5 minutes of messages if you enter an existing room
            define('CHAT_EVENT_PRUNE', 60 * 24);
        }

        if (get_page_name() == 'chat') {
            require_code('developer_tools');
            destrictify(false);
        }
    }
}
