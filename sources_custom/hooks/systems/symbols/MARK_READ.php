<?php

/**
 * Hook class.
 */
class Hook_symbol_MARK_READ
{
    public function run($param)
    {
        if (!$GLOBALS['SITE_DB']->table_exists('content_read')) {
            $GLOBALS['SITE_DB']->create_table('content_read', array(
                'r_content_type' => '*ID_TEXT',
                'r_content_id' => '*ID_TEXT',
                'r_member_id' => '*USER',
                'r_time' => 'TIME',
            ));
            $GLOBALS['SITE_DB']->create_index('content_read', 'content_read', array('r_content_type', 'r_content_id'));
            $GLOBALS['SITE_DB']->create_index('content_read', 'content_read_cleanup', array('r_time'));
        }

        if (!isset($param[1])) {
            return ''; // Not enough parameters
        }
        if (is_guest()) {
            return ''; // Guests can't be tracked
        }

        $GLOBALS['SITE_DB']->query_insert('content_read', array(
            'r_content_type' => $param[0],
            'r_content_id' => $param[1],
            'r_member_id' => get_member(),
            'r_time' => time(),
        ), false, true);

        // Cleanup stale data
        $cleanup_days = isset($param[2]) ? intval($param[2]) : 0;
        if (($cleanup_days != 0) && (mt_rand(0, 100) == 1/*Only do 1% of the time, for performance reasons*/)) {
            $GLOBALS['SITE_DB']->query('DELETE FROM ' . get_table_prefix() . 'content_read WHERE r_time<' . strval(time() - 60 * 60 * 24 * $cleanup_days));
        }

        return ''; // Not output for this symbol ever
    }
}
