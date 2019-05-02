<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    testing_platform
 */

/**
 * Composr test case class (unit testing).
 */
class log_refs_test_set extends cms_test_case
{
    public function testNoUnexpectedLogs()
    {
        require_code('files2');

        disable_php_memory_limit();
        if (php_function_allowed('set_time_limit')) {
            set_time_limit(100);
        }

        $all_code = '';
        $files = get_directory_contents(get_file_base(), '', IGNORE_SHIPPED_VOLATILE | IGNORE_UNSHIPPED_VOLATILE | IGNORE_FLOATING, true, true, array('php'));
        foreach ($files as $path) {
            $all_code .= file_get_contents(get_file_base() . '/' . $path);
        }

        $codebook = file_get_contents(get_file_base() . '/docs/pages/comcode_custom/EN/codebook_3.txt');

        $admin_errorlog = file_get_contents(get_file_base() . '/adminzone/pages/modules/admin_errorlog.php');

        $web_config = file_get_contents(get_file_base() . '/web.config');

        $matches = array();
        $logs = array();
        $num_matches = preg_match_all('#data_custom/\w+\.log#', $all_code, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $log = $matches[0][$i];

            if (!in_array(basename($log), array('performance.log', 'performance_warnings.log', 'sugarcrm.log'))) {
                $logs[] = $log;
            }
        }
        $logs = array_unique($logs);

        foreach ($logs as $log) {
            $this->assertTrue(strpos($codebook, $log) !== false, 'Missing Codebook listing for ' . $log);

            $this->assertTrue(strpos($admin_errorlog, basename($log)) !== false, 'Missing admin_errorlog reference for ' . $log);

            $this->assertTrue(strpos($web_config, '<add segment="' . basename($log) . '" />') !== false, 'Missing web.config skip for ' . $log);
        }
    }
}
