<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * Hook class.
 */
class Hook_upon_query_google_maps
{
    public function run_post($ob, $query, $max, $start, $fail_ok, $get_insert_id, $ret)
    {
        if (preg_match('#^DELETE FROM ' . get_table_prefix() . 'cache WHERE .*main_cc_embed#', $query) != 0) { // If main_cc_embed being decached
            decache('main_google_map'); // decache map block too
        }
    }
}
