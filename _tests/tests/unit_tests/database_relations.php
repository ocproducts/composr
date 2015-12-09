<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class database_relations_test_set extends cms_test_case
{
    public function testRelationsdefined()
    {
        if (in_safe_mode()) {
            $this->assertTrue(false, 'Cannot work in safe mode');
            return;
        }

        require_code('database_relations');

        /* Actually we aren't going to force descriptions for all tables
        $all_tables=$GLOBALS['SITE_DB']->query('SELECT DISTINCT m_table FROM '.get_table_prefix().'db_meta WHERE m_type LIKE \''.db_encode_like('%AUTO_LINK%').'\' ORDER BY m_table');
        $table_descriptions=get_table_descriptions();

        foreach ($all_tables as $t)
        {
            $this->assertFalse(!array_key_exists($t['m_table'],$table_descriptions),'Table not described: '.$t['m_table']);
        }*/

        $all_links = $GLOBALS['SITE_DB']->query('SELECT m_table,m_name FROM ' . get_table_prefix() . 'db_meta WHERE m_type LIKE \'' . db_encode_like('%AUTO_LINK%') . '\' ORDER BY m_table');
        $links = get_relation_map();

        foreach ($all_links as $l) {
            if (!table_has_purpose_flag($l['m_table'], TABLE_PURPOSE__NON_BUNDLED)) {
                $_l = $l['m_table'] . '.' . $l['m_name'];
                $this->assertFalse(!array_key_exists($_l, $links), 'Link not described: ' . $_l);
            }
        }
    }
}
