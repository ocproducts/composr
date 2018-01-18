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
class tasks_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('files');
    }

    public function testMemberCSV()
    {
        $tmp_path = cms_tempnam();

        cms_file_put_contents_safe($tmp_path, "Username,E-mail\nTestingABC,test@example.com");

        require_code('hooks/systems/tasks/import_member_csv');
        $ob_import = new Hook_task_import_member_csv();
        $ob_import->run('', false, $tmp_path);

        require_code('hooks/systems/tasks/download_member_csv');
        $ob_export = new Hook_task_download_member_csv();
        $results = $ob_export->run(false, '.csv', '', array('ID', 'Username'), array(), 'ID');
        $this->assertTrue(strpos(cms_file_get_contents_safe($results[1][1]), 'TestingABC') !== false);

        $ob_import->run('', false, $results[1][1]);
    }
}
