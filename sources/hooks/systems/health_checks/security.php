<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    health_check
 */

/**
 * Hook class.
 */
class Hook_health_check_security extends Hook_Health_Check
{
    protected $category_label = 'Security';

    /**
     * Standard hook run function to run this category of health checks.
     *
     * @param  ?array $sections_to_run Which check sections to run (null: all)
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     * @return array A pair: category label, list of results
     */
    public function run($sections_to_run, $check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        $this->process_checks_section('testMalware', 'Malware', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass, $urls_or_page_links, $comcode_segments);
        $this->process_checks_section('testDirectorySecuring', 'Directory securing', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass, $urls_or_page_links, $comcode_segments);
        $this->process_checks_section('testSiteOrphaned', 'Site orphaning', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass, $urls_or_page_links, $comcode_segments);
        $this->process_checks_section('testAdminScriptAccess', 'Admin Script Access', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass, $urls_or_page_links, $comcode_segments);
        $this->process_checks_section('testIPBackdoor', 'IP backdoor left active', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass, $urls_or_page_links, $comcode_segments);
        $this->process_checks_section('testWebShells', 'WebShells in likely directories (backdoor scripts)', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass, $urls_or_page_links, $comcode_segments);

        return array($this->category_label, $this->results);
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testMalware($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        // API https://developers.google.com/safe-browsing/v4/

        if ($check_context != CHECK_CONTEXT__LIVE_SITE) {
            // Google can't index a non-live site, and thus won't report Safe Browsing results
            return;
        }

        if ($use_test_data_for_pass === null) {
            $key = get_option('google_apis_api_key');
            if (get_option('hc_google_safe_browsing_api_enabled') == '0') {
                $this->stateCheckSkipped(do_lang('API_NOT_CONFIGURED', 'Google Safe Browsing'));
                return;
            }
        } else {
            $key = 'AIzaSyBJyvgYzg-moqMRBZwhiivNxhYvafqMWas';
        }
        if ($key == '') {
            $this->stateCheckSkipped(do_lang('API_NOT_CONFIGURED', 'Google Safe Browsing'));
            return;
        }

        if ($use_test_data_for_pass === null) {
            if ($this->is_localhost_domain()) {
                $this->stateCheckSkipped('Could not scan for Malware on local domain');
                return;
            }

            $page_links = $this->process_urls_into_page_links();

            $urls = array();
            foreach ($page_links as $page_link) {
                $_url = page_link_to_url($page_link);
                if (!empty($_url)) {
                    $urls[] = array('url' => $_url);
                }
            }
        } else {
            if ($use_test_data_for_pass) {
                $urls = array(array('url' => 'http://example.com'));
            } else {
                $urls = array(array('url' => 'http://www23.omrtw.com'));
            }
        }

        $url = 'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=' . urlencode(trim($key));

        require_code('version2');
        $data = array(
            'client' => array(
                'clientId' => 'Composr',
                'clientVersion' => get_version_dotted(),
            ),
            'threatInfo' => array(
                'threatTypes' => array('MALWARE', 'SOCIAL_ENGINEERING'),
                'platformTypes' => array('ANY_PLATFORM'),
                'threatEntryTypes' => array('URL'),
                'threatEntries' => $urls,
            ),
        );

        for ($i = 0; $i < 3; $i++) { // Try a few times in case of some temporary network issue or Google issue
            $http_result = cms_http_request($url, array('trigger_error' => false, 'post_params' => array(json_encode($data)), 'timeout' => 200.0, 'raw_post' => true, 'raw_content_type' => 'application/json'));

            if ($http_result->data !== null) {
                break;
            }
            if (php_function_allowed('usleep')) {
                usleep(5000000);
            }
        }

        $this->assertTrue(!in_array($http_result->message, array('401', '403')), 'Error with our Google Safe Browsing API key (' . $http_result->message . ')');
        $this->assertTrue(!in_array($http_result->message, array('400', '501', '503', '504')), 'Internal error with our Google Safe Browsing check (' . $http_result->message . ')');

        $ok = in_array($http_result->message, array('200'));
        if ($ok) {
            $result = json_decode($http_result->data, true);

            if (empty($result['matches'])) {
                $this->assertTrue(true, 'Malware advisory provided by [url="Google"]https://developers.google.com/safe-browsing/v3/advisory[/url]');
            } else {
                foreach ($result['matches'] as $match) {
                    $this->assertTrue(false, 'Malware advisory provided by [url="Google"]https://developers.google.com/safe-browsing/v3/advisory[/url], ' . json_encode($match));
                }
            }
        } else {
            $this->stateCheckSkipped('Failed calling Google Safe Browsing API');
        }
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testDirectorySecuring($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }
        if ($check_context == CHECK_CONTEXT__SPECIFIC_PAGE_LINKS) {
            return;
        }

        $to_check = array(
            'data_custom/ecommerce.log',
            'caches/test.txt',
            'temp/test.txt',
        );
        foreach ($to_check as $c) {
            $full_path = get_custom_file_base() . '/' . $c;
            $exists = is_file($full_path);
            if (!$exists) {
                require_code('files');
                cms_file_put_contents_safe($full_path, '');
            }
            $http_result = cms_http_request(get_custom_base_url() . '/' . $c, array('trigger_error' => false));
            $this->assertTrue($http_result->message == '403' || $http_result->message == '404', 'Should not be able to download [tt]' . $c . '[/tt], should be secured by some kind of server configuration');
            if (!$exists) {
                @unlink($full_path);
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
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testSiteOrphaned($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        if ($check_context != CHECK_CONTEXT__LIVE_SITE) {
            return;
        }

        $path = 'uploads/website_specific/orphaned-test.txt';
        require_code('crypt');
        $data = get_secure_random_string();
        require_code('files');
        cms_file_put_contents_safe(get_custom_file_base() . '/' . $path, $data);
        $result = http_get_contents(get_custom_base_url() . '/' . $path, array('trigger_error' => false));
        $this->assertTrue($result === $data, 'Website does not seem to be running on the base URL that is configured');
        @unlink(get_custom_file_base() . '/' . $path);

        if (!$this->is_localhost_domain()) {
            if (php_function_allowed('shell_exec')) {
                $domains = $this->get_domains();

                foreach ($domains as $domain) {
                    $regexp = '#\nName:\s+' . $domain . '\nAddress:\s+(.*)\n#';

                    $matches_local = array();
                    $dns_lookup_local = shell_exec('nslookup ' . $domain);
                    $matched_local = preg_match($regexp, $dns_lookup_local, $matches_local);
                    $matches_remote = array();
                    $dns_lookup_remote = shell_exec('nslookup ' . $domain . ' 8.8.8.8');
                    $matched_remote = preg_match($regexp, $dns_lookup_remote, $matches_remote);
                    if (($matched_local != 0) && ($matched_remote != 0)) {
                        $this->assertTrue($matches_local[1] == $matches_remote[1], 'DNS lookup for our domain seems to be looking up differently ([tt]' . $matches_local[1] . '[/tt] vs [tt]' . $matches_remote[1] . '[/tt])');
                    } else {
                        $this->stateCheckSkipped('Failed to get a recognisable DNS resolution via the command line for [tt]' . $domain . '[/tt]');
                    }
                }
            } else {
                $this->stateCheckSkipped('PHP shell_exec function not available');
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
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testAdminScriptAccess($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }
        if ($check_context == CHECK_CONTEXT__SPECIFIC_PAGE_LINKS) {
            return;
        }

        global $SITE_INFO;
        $ok = !isset($SITE_INFO['master_password']);
        if (!$ok) {
            $ok = (http_get_contents(get_base_url() . '/config_editor.php', array('trigger_error' => false)) === null);
        }
        $this->assertTrue($ok, 'Should not have a master password defined, or should control access to config scripts');
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testIPBackdoor($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }
        if ($check_context == CHECK_CONTEXT__SPECIFIC_PAGE_LINKS) {
            return;
        }

        global $SITE_INFO;
        $this->assertTrue(empty($SITE_INFO['backdoor_ip']), 'You have a [tt]backdoor_ip[/tt] setting left defined in _config.php');
    }

    /**
     * Run a section of health checks.
     *
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @param  ?array $urls_or_page_links List of URLs and/or page-links to operate on, if applicable (null: those configured)
     * @param  ?array $comcode_segments Map of field names to Comcode segments to operate on, if applicable (null: N/A)
     */
    public function testWebShells($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null, $urls_or_page_links = null, $comcode_segments = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }
        if ($check_context == CHECK_CONTEXT__SPECIFIC_PAGE_LINKS) {
            return;
        }

        require_code('files2');

        $fb = get_file_base();

        $files = array();
        $base_url_path = parse_url(get_base_url(), PHP_URL_PATH);
        if ($base_url_path != '/') {
            if (substr($fb, -strlen($base_url_path)) == $base_url_path) {
                $webroot_path = substr($fb, 0, strlen($fb) - strlen($base_url_path));
                $files = array_merge($files, get_directory_contents($webroot_path, '', 0, false, true, array('php'))); // webroot directory
            }
        }
        $files = array_merge($files, get_directory_contents($fb, '', 0, false, true, array('php'))); // base directory
        $files = array_merge($files, get_directory_contents($fb . '/uploads', 'uploads', 0, true, true, array('php'))); // common uploads location
        $files = array_merge($files, get_directory_contents($fb . '/themes', 'themes', 0, true, true, array('php'))); // common uploads location

        foreach ($files as $file) {
            $c = @file_get_contents($fb . '/' . $file);
            if ($c !== false) {
                $trigger = $this->isLikelyWebShell($file, $c);
                if ($trigger !== null) {
                    $this->assertTrue(false, 'Likely webshell: ' . $file . '; triggered by [tt]' . $trigger . '[/tt]');
                }
            }
        }
    }

    /**
     * Find if a file is a likely webshell.
     *
     * @param  PATH $file Relative file path
     * @param  string $c File contents
     * @return ?string Trigger that found it (null: nothing)
     */
    protected function isLikelyWebShell($file, $c)
    {
        $triggers = array(
            '[^\w]system\(',
            '[^\w]exec\(',
            '[^\w]shell_exec\(',
            '[^\w]passthru\(',
            '[^\w]popen\(',
            '[^\w]proc_open\(',
            '[^\w]eval\(',
            '[^\w]move_uploaded_file\(',
            '\$\w+\(',
            '\$_FILES',
            '/etc/passwd',
            '(require|include)(_once)?\([\'"]https?://',
        );

        foreach ($triggers as $trigger) {
            if (preg_match('#' . $trigger . '#i', $c) != 0) {
                return $trigger;
            }
        }

        return null;
    }
}
