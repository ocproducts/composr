<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
        require_code('tasks');
    }

    public function testNewsletterCSV()
    {
        $tmp_path = cms_tempnam();

        cms_file_put_contents_safe($tmp_path, "Email,Name\ntest@example.com,Test");

        require_code('hooks/systems/tasks/import_newsletter_subscribers');
        $ob_import = new Hook_task_import_newsletter_subscribers();
        $ob_import->run(fallback_lang(), db_get_first_id(), true, $tmp_path);

        $this->establish_admin_session();
        $url = build_url(array('page' => 'admin_newsletter', 'type' => 'subscribers', 'id' => db_get_first_id(), 'lang' => fallback_lang(), 'csv' => 1), 'adminzone');
        $data = http_get_contents($url->evaluate(), array('cookies' => array(get_session_cookie() => get_session_id())));
        $this->assertTrue(strpos($data, 'test@example.com') !== false);

        file_put_contents($tmp_path, $data);
        $ob_import->run(fallback_lang(), db_get_first_id(), true, $tmp_path);
    }

    public function testCatalogueCSV()
    {
        $tmp_path = cms_tempnam();

        cms_file_put_contents_safe($tmp_path, "Title,URL,Description\nTestingABC,http://example.com,Test");

        require_code('hooks/systems/tasks/import_catalogue');
        $ob_import = new Hook_task_import_catalogue();
        $ob_import->run('links', 'Title', 'add', 'leave', 'skip', '', '', '', 1, 1, 1, $tmp_path);

        require_code('hooks/systems/tasks/export_catalogue');
        $ob_export = new Hook_task_export_catalogue();
        $results = $ob_export->run('links');
        $this->assertTrue(strpos(cms_file_get_contents_safe($results[1][1]), 'TestingABC') !== false);

        $ob_import->run('links', 'Title', 'add', 'leave', 'skip', '', '', '', 1, 1, 1, $results[1][1]);
    }

    public function testCalendarICal()
    {
        require_code('calendar2');

        // Add complex event with start and recurrence
        $complex_event_id = add_calendar_event(8, 'daily', 3, 0, 'complex event', '', 3, 2010, 1, 10, 'day_of_month', 10, 15, 2010, 1, 10, 'day_of_month', 11, 15, null, 1, null, 1, 1, 1, 1, '', null, 0, null, null, null);

        // Add event with start only
        $simple_event_id = add_calendar_event(8, 'none', null, 0, 'simple event', '', 3, 2010, 1, 10, 'day_of_month', 10, 15, null, null, null, 'day_of_month', null, null, null, 1, null, 1, 1, 1, 1, '', null, 0, null, null, null);

        $last_rows_before = $GLOBALS['SITE_DB']->query_select('calendar_events', array('*'), array(), 'ORDER BY id DESC', 2);
        $this->cleanEventRowsForComparison($last_rows_before);

        require_code('calendar_ical');
        ob_start();
        output_ical(false);
        $ical = ob_get_contents();
        ob_end_clean();

        $temp_path = cms_tempnam();
        file_put_contents($temp_path, $ical);

        $post_params = array(
            'snip' => $ical,
        );
        $result = http_get_contents('http://severinghaus.org/projects/icv/', array('post_params' => $post_params));

        $this->assertTrue(strpos($result, 'Congratulations; your calendar validated!') !== false);

        delete_calendar_event($complex_event_id);
        delete_calendar_event($simple_event_id);

        $num_events_before = $GLOBALS['SITE_DB']->query_select_value('calendar_events', 'COUNT(*)');
        ical_import($temp_path);
        $num_events_after = $GLOBALS['SITE_DB']->query_select_value('calendar_events', 'COUNT(*)');
        $this->assertTrue($num_events_after > $num_events_before, 'Did not appear to import events (' . integer_format($num_events_after) . ' after, ' . integer_format($num_events_before) . ' before)');

        $_last_rows_after = $GLOBALS['SITE_DB']->query_select('calendar_events', array('*'), array(), 'ORDER BY id DESC', 2);
        $last_rows_after = $_last_rows_after;
        $this->cleanEventRowsForComparison($last_rows_after);

        $this->assertTrue($last_rows_before == $last_rows_after, 'Our test events changed during the export/import cycle)');

        foreach ($_last_rows_after as $row) {
            delete_calendar_event($row['id']);
        }

        unlink($temp_path);
    }

    protected function cleanEventRowsForComparison(&$rows)
    {
        foreach ($rows as &$row) {
            unset($row['id']);
            unset($row['e_add_date']);
            $row['e_title'] = get_translated_text($row['e_title']);
            unset($row['e_title__text_parsed']);
            $row['e_content'] = get_translated_text($row['e_content']);
            unset($row['e_content__text_parsed']);
        }
    }

    public function testMemberCSV()
    {
        $tmp_path = cms_tempnam();

        cms_file_put_contents_safe($tmp_path, "Username,E-mail\nTestingABC,test@example.com");

        require_code('hooks/systems/tasks/import_member_csv');
        $ob_import = new Hook_task_import_member_csv();
        $ob_import->run('', false, $tmp_path);

        @unlink($tmp_path);

        require_code('hooks/systems/tasks/export_member_csv');
        $ob_export = new Hook_task_export_member_csv();
        $results = $ob_export->run(false, '.csv', '', array('ID', 'Username'), array(), 'ID');
        $this->assertTrue(strpos(cms_file_get_contents_safe($results[1][1]), 'TestingABC') !== false);

        $ob_import->run('', false, $results[1][1]);
    }
}
