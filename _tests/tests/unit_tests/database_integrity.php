<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

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
class database_integrity_test_set extends cms_test_case
{
    public function setUp()
    {
        require_code('database_repair');

        parent::setUp();
    }

    public function testIsMySQL()
    {
        $this->assertTrue(strpos(get_db_type(), 'mysql') !== false, 'Test can only run with MySQL');
    }

    public function testNoErrors()
    {
        if (strpos(get_db_type(), 'mysql') !== false) {
            $ob = new DatabaseRepair();
            list($phase, $sql) = $ob->search_for_database_issues();
            $this->assertTrue($phase == 2);
            $this->assertTrue($sql == '', $sql);
        }
    }
}
