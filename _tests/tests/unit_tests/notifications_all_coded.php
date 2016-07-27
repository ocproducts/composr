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
class notifications_all_coded_test_set extends cms_test_case
{
    public function testAllNotificationsCoded()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        // Ensure all notification types used
        $hooks = find_all_hooks('systems', 'notifications');

        require_code('files2');
        $php_path = find_php_path();
        $contents = get_directory_contents(get_file_base());
        foreach ($contents as $c) {
            if ((substr($c, -4) == '.php') && (basename($c) != 'errorlog.php') && (basename($c) != 'phpstub.php') && (basename($c) != 'permissioncheckslog.php')) {
                foreach (array_keys($hooks) as $hook) {
                    $file = file_get_contents($c);
                    if (preg_match('#dispatch_notification\(\s*\'' . $hook . '\'#', $file) != 0) {
                        unset($hooks[$hook]);
                    }
                }
            }
        }

        $allowed = array( // Adjust this to account for cases of notifications coded up in non-direct ways
                          'error_occurred_cron',
                          'error_occurred_missing_page',
                          'error_occurred_missing_reference',
                          'error_occurred_missing_reference_important',
                          'error_occurred_missing_resource',
                          'error_occurred_weather',
                          'error_occurred_rss',
                          'ticket_new_staff',
                          'ticket_reply_staff',
                          'catalogue_view_reports',
                          'catalogue_entry',
                          'classifieds',
        );
        foreach (array_keys($hooks) as $hook) {
            $this->assertTrue(in_array($hook, $allowed), $hook . ' is unused');
        }
    }
}
