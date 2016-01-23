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
class catalogues_category_test_set extends cms_test_case
{
    public $cat_id;

    public function setUp()
    {
        parent::setUp();

        require_code('catalogues');
        require_code('catalogues2');

        $this->cat_id = actual_add_catalogue_category('Testing_category', 'Test_Cat', 'Testing_Cat', '', 1, '', 30, 60, null, null, null);

        $this->assertTrue('Testing_category' == $GLOBALS['SITE_DB']->query_select_value('catalogue_categories', 'c_name', array('id' => $this->cat_id)));
    }

    public function testEditCatalogue_category()
    {
        actual_edit_catalogue_category($this->cat_id, 'Test_Cat', 'Cat_edit', 'Test', 1, '', '', '', 30, 60, null, 0);

        $this->assertTrue('Testing_category' == $GLOBALS['SITE_DB']->query_select_value('catalogue_categories', 'c_name', array('id' => $this->cat_id)));
    }

    public function tearDown()
    {
        actual_delete_catalogue_category($this->cat_id, false);
        parent::tearDown();
    }
}
