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
class filtering_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        // In case test crashed and needs resetting
        $GLOBALS['SITE_DB']->drop_table_if_exists('temp_test_categories');
        $GLOBALS['SITE_DB']->drop_table_if_exists('temp_test_entries');

        require_code('rss');
    }

    protected $ids_and_parents;
    protected $selectcode;
    protected $expected;
    protected $expected_lazy;
    protected $expected_full;

    public function getIdsAndParents()
    {
        return $this->ids_and_parents;
    }

    public function testSelectcode()
    {
        $GLOBALS['SITE_DB']->create_table('temp_test_categories', array(
            'id' => '*INTEGER',
            'parent_id_of_cat' => 'INTEGER',
        ));
        $GLOBALS['SITE_DB']->create_table('temp_test_entries', array(
            'id' => '*INTEGER',
            'parent_id' => 'INTEGER',
        ));

        $this->ids_and_parents = array(
            1 => 2,
            2 => 2,
            3 => 2,
            4 => 3,
            5 => 3,
            6 => 3,
            7 => 3,
            8 => 3,
            100 => 12,
            101 => 13,
        );

        foreach (array_unique($this->ids_and_parents) as $parent_id) {
            $GLOBALS['SITE_DB']->query_insert('temp_test_categories', array(
                'id' => $parent_id,
                'parent_id_of_cat' => ($parent_id == 13) ? 12 : 1,
            ));
        }

        foreach ($this->ids_and_parents as $id => $parent_id) {
            $GLOBALS['SITE_DB']->query_insert('temp_test_entries', array(
                'id' => $id,
                'parent_id' => $parent_id,
            ));
        }

        require_code('selectcode');

        // Test scenario 1
        // ---------------

        $this->selectcode = '1,3-10,!6,12*';
        $this->expected_lazy = array(1, 3, 4, 5, 7, 8, 9, 10, 100, 101);
        $this->expected_full = array(1, 3, 4, 5, 7, 8, 100, 101);
 
        $sql = selectcode_to_sqlfragment($this->selectcode, 'id', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $results = collapse_1d_complexity('id', $GLOBALS['SITE_DB']->query_select('temp_test_entries', array('id'), null, 'WHERE ' . $sql));
        $this->assertTrue($results == $this->expected_full);

        $results = selectcode_to_idlist_using_db($this->selectcode, 'id', 'temp_test_entries', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected_lazy);

        $results = selectcode_to_idlist_using_memory($this->selectcode, $this->ids_and_parents, 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected_full);

        $results = selectcode_to_idlist_using_callback($this->selectcode, array(array($this, 'getIdsAndParents'), array()), 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected_lazy);

        // Test scenario 2
        // ---------------

        $this->selectcode = '*,!1';
        $this->expected = array(2, 3, 4, 5, 6, 7, 8, 100, 101);
 
        $sql = selectcode_to_sqlfragment($this->selectcode, 'id', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $results = collapse_1d_complexity('id', $GLOBALS['SITE_DB']->query_select('temp_test_entries', array('id'), null, 'WHERE ' . $sql));
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_db($this->selectcode, 'id', 'temp_test_entries', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_memory($this->selectcode, $this->ids_and_parents, 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_callback($this->selectcode, array(array($this, 'getIdsAndParents'), array()), 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        // Test scenario 3
        // ---------------

        $this->selectcode = '8+';
        $this->expected = array(8, 100, 101);
 
        $sql = selectcode_to_sqlfragment($this->selectcode, 'id', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $results = collapse_1d_complexity('id', $GLOBALS['SITE_DB']->query_select('temp_test_entries', array('id'), null, 'WHERE ' . $sql));
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_db($this->selectcode, 'id', 'temp_test_entries', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_memory($this->selectcode, $this->ids_and_parents, 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_callback($this->selectcode, array(array($this, 'getIdsAndParents'), array()), 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        // Test scenario 4
        // ---------------

        $this->selectcode = '2#';
        $this->expected = array(1, 2, 3);
 
        $sql = selectcode_to_sqlfragment($this->selectcode, 'id', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $results = collapse_1d_complexity('id', $GLOBALS['SITE_DB']->query_select('temp_test_entries', array('id'), null, 'WHERE ' . $sql));
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_db($this->selectcode, 'id', 'temp_test_entries', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_memory($this->selectcode, $this->ids_and_parents, 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_callback($this->selectcode, array(array($this, 'getIdsAndParents'), array()), 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        // Test scenario 5
        // ---------------

        $this->selectcode = '12>';
        $this->expected = array(101);
 
        $sql = selectcode_to_sqlfragment($this->selectcode, 'id', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $results = collapse_1d_complexity('id', $GLOBALS['SITE_DB']->query_select('temp_test_entries', array('id'), null, 'WHERE ' . $sql));
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_db($this->selectcode, 'id', 'temp_test_entries', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_memory($this->selectcode, $this->ids_and_parents, 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_callback($this->selectcode, array(array($this, 'getIdsAndParents'), array()), 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        // Test scenario 6
        // ---------------

        $this->selectcode = '12*,13~';
        $this->expected = array(100);
 
        $sql = selectcode_to_sqlfragment($this->selectcode, 'id', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $results = collapse_1d_complexity('id', $GLOBALS['SITE_DB']->query_select('temp_test_entries', array('id'), null, 'WHERE ' . $sql));
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_db($this->selectcode, 'id', 'temp_test_entries', 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_memory($this->selectcode, $this->ids_and_parents, 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);

        $results = selectcode_to_idlist_using_callback($this->selectcode, array(array($this, 'getIdsAndParents'), array()), 'temp_test_categories', 'parent_id_of_cat', 'parent_id', 'id');
        $this->assertTrue($results == $this->expected);
    }

    public function tearDown()
    {
        $GLOBALS['SITE_DB']->drop_table_if_exists('temp_test_categories');
        $GLOBALS['SITE_DB']->drop_table_if_exists('temp_test_entries');

        parent::tearDown();
    }
}
