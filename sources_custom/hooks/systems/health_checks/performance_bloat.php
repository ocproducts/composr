<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    health_check
 */

/**
 * Hook class.
 */
class Hook_health_check_performance_bloat extends Hook_Health_Check
{
    protected $category_label = 'Bloated data';

    /**
     * Standard hook run function to run this category of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @return array A pair: category label, list of results
     */
    public function run($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        $this->process_checks_section('testTableSize', 'Table size', $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);
        $this->process_checks_section('testDirectorySize', 'Directory size', $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);
        $this->process_checks_section('testLogSize', 'Log size', $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);

        return array($this->category_label, $this->results);
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     */
    public function testTableSize($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }

        $tables = array(
            'autosave' => 100000,
            'cache' => 1000000,
            'cached_comcode_pages' => 10000,
            'captchas' => 10000,
            'chat_active' => 100000,
            'chat_events' => 10000000,
            'cron_caching_requests' => 10000,
            'post_tokens' => 10000,
            'edit_pings' => 10000,
            'hackattack' => 1000000,
            'incoming_uploads' => 10000,
            'logged_mail_messages' => 100000,
            'messages_to_render' => 100000,
            'sessions' => 1000000,
            'sitemap_cache' => 100000,
            'temp_block_permissions' => 10000000,
            'url_title_cache' => 100000,
            'urls_checked' => 100000,
        );

        foreach ($tables as $table => $max_threshold) {
            $cnt = $GLOBALS['SITE_DB']->query_select_value($table, 'COUNT(*)');
            $this->assert_true($cnt < $max_threshold, 'Volatile-defined table now contains ' . integer_format($cnt) . ' records');
        }
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     */
    public function testDirectorySize($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        require_code('files');
        require_code('files2');

        $mb = 1024 * 1024;
        $directories = array(
            'caches/guest_pages' => 500,
            'caches/lang' => 200,
            'caches/persistent' => 500,
            'caches/self_learning' => 500,
            'uploads/incoming' => 500,
            'safe_mode_temp' => 50, // TODO: temp in v11
            'themes/' . $GLOBALS['FORUM_DRIVER']->get_theme('') . '/templates_cached' => 20,
        );
        foreach ($directories as $dir => $max_threshold_size_in_mb) {
            if (file_exists(get_file_base() . '/' . $dir)) {
                $size = get_directory_size(get_file_base() . '/' . $dir);
                $this->assert_true($size < $mb * $max_threshold_size_in_mb, 'Directory ' . $dir . ' is very large @ ' . clean_file_size($size));
            }
        }

        $directories = array(
            'uploads/incoming' => 50,
            'safe_mode_temp' => 50, // TODO: temp in v11
            'data_custom' => 100,
        );
        foreach ($directories as $dir => $max_contents_threshold) {
            if (file_exists(get_file_base() . '/' . $dir)) {
                $count = count(get_directory_contents(get_file_base() . '/' . $dir, '', false, false));
                $this->assert_true($count < $max_contents_threshold, 'Directory ' . $dir . ' now contains ' . integer_format($count) . ' files, should hover only slightly over empty');
            }
        }
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     */
    public function testLogSize($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        require_code('files');

        $log_threshold = 1000000;

        $path = get_file_base() . '/data_custom';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if (strpos($f, 'log') !== false) {
                $size = filesize($path . '/' . $f);
                $this->assert_true($size < $log_threshold, 'Size of ' . $f . ' log is very large @ ' . clean_file_size($size));
            }
        }
        closedir($dh);
    }
}
