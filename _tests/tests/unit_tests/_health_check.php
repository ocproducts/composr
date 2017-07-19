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
class _health_check_test_set extends cms_test_case
{
    // These tests will eventually become a part of the Health Check system https://compo.sr/tracker/view.php?id=3314

    protected function get_page_url($page_link = ':')
    {
        static $urls = array();
        if (!array_key_exists($page_link, $urls)) {
            $urls[$page_link] = page_link_to_url($page_link);
        }
        return $urls[$page_link];
    }

    protected function get_page_content($page_link = ':')
    {
        static $ret = array();
        if (!array_key_exists($page_link, $ret)) {
            $ret[$page_link] = http_download_file($this->get_page_url($page_link), null, false, true);

            // Server blocked to access itself
            if ($page_link == ':') {
                $this->assertTrue($ret[$page_link] !== null, 'The server cannot download itself');
            }
        }
        return $ret[$page_link];
    }

    protected function get_domain()
    {
        return parse_url(get_base_url(), PHP_URL_HOST);
    }

    protected function get_mail_domains()
    {
        $domains = array();
        $domains[preg_replace('#^.*@#', '', get_option('staff_address'))] = get_option('staff_address');
        $domains[preg_replace('#^.*@#', '', get_option('website_email'))] = get_option('website_email');
        if (addon_installed('tickets')) {
            $domains[preg_replace('#^.*@#', '', get_option('ticket_email_from'))] = get_option('ticket_email_from');
        }

        foreach ($domains as $domain => $email) {
            if ($this->is_localhost_domain($domain)) {
                unset($domains[$email]);
            }
        }

        return array_unique($domains);
    }

    protected function is_localhost_domain($domain = null)
    {
        if ($domain === null) {
            $domain = parse_url(get_base_url(), PHP_URL_HOST);
        }

        return ($domain == 'localhost') || (trim($domain, '0123456789.') == '') || (strpos($domain, ':') !== false);
    }

    protected function call_composr_homesite_api($type, $params)
    {
        $url = 'https://compo.sr/uploads/website_specific/compo.sr/scripts/api.php?type=' . urlencode($type);
        foreach ($params as $key => $_val) {
            switch (gettype($_val)) {
                case 'string':
                    $val = $_val;
                    break;

                case 'boolean':
                    $val = $_val ? '1' : '0';
                    break;

                case 'integer':
                    $val = strval($_val);
                    break;

                case 'double':
                    $val = float_to_raw_string($_val);
                    break;

                case 'array':
                    $val = @implode(',', array_map('strval', $_val));
                    break;

                case 'NULL':
                    $val = '';
                    break;

                case 'string':
                default:
                    $val = $_val;
                    break;
            }

            $url .= '&' . $key . '=' . urlencode($val);
        }
        return @json_decode(http_download_file($url, null, false));
    }

    // Expired SSL certificate, or otherwise malfunctioning SSL (if enabled)
    /*public function testForSSLIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ((addon_installed('ssl')) || (substr(get_base_url(), 0, 7) == 'https://')) {
            // If it's a problem with SSL verification in general
            $data = http_download_file('https://www.google.com/', null, false);
            $ok = (strpos($data, '<html') !== false);
            $this->assertTrue($ok, 'Problem downloading HTTP requests by SSL');

            if ($ok) {
                // If it's a problem with SSL verification on our domain specifically
                $domain = $this->get_domain();
                if (get_value('disable_ssl_for__' . $domain) === null) {
                    $test_url = get_base_url(true) . '/uploads/index.html';

                    set_value('disable_ssl_for__' . $domain, '0');
                    $data = http_download_file($test_url, null, false);
                    $ok1 = (strpos($data, '<html') !== false);

                    if (!$ok1) {
                        set_value('disable_ssl_for__' . $domain, '1');
                        $data = http_download_file($test_url, null, false);
                        $ok2 = (strpos($data, '<html') !== false);

                        $this->assertTrue(!$ok2, 'Problem detected with the ' . $domain . ' SSL certificate'); // Issue with our SSL but not if verify is disabled, suggesting the problem is with verify

                        delete_value('disable_ssl_for__' . $domain);
                    } else {
                        $this->assertTrue(true); // No issue with our SSL
                    }
                }
            }
        }
    }*/

    // Bad 404 page
    /*public function testForBad404($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $url = get_base_url() . '/testing-for-404.html';
        $data = http_download_file($url, null, false); // TODO: In v11 set the parameter to return output even for 404
        $this->assertTrue(($data === null) || (strpos($data, '<link') !== false) || (strpos($data, '<a ') !== false), '404 page is too basic looking, probably not helpful, suggest to display a sitemap');

        $url = get_base_url() . '/testing-for-404.png';
        $data = http_download_file($url, null, false); // TODO: In v11 set the parameter to return output even for 404
        $this->assertTrue(($data === null) || (strpos($data, '<nav class="menu_type__sitemap">') === false), '404 page is too complex looking for broken images');
    }*/

    // Outgoing mail not working
    /*public function testForMailFailing($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // CRON taking more than 5 minutes to run
    /*public function testForCRONSlow($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // CRON tasks not successfully running all the way through
    /*public function testForCRONFailure($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // CRON not running at all
    /*public function testForCRONNotRunning($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // Lost packets doing simple outbound ping
    /*public function testForPingIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $data = shell_exec('ping -c 10 8.8.8.8');
            $matches = array();
            if (preg_match('# (\d(\.\d+)%) packet loss#', $data, $matches) != 0) {
                $this->assertTrue(floatval($matches[1]) == 0.0, 'Unreliable Internet connection on server');
            }
        }
    }*/

    // Slow download speed
    /*public function testForSlowDownload($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $time_before = microtime(true);
        $data = http_download_file('http://www.google.com/');
        $time_after = microtime(true);

        $time = ($time_after - $time_before);

        $threshold = 0.4;

        $this->assertTrue($time < $threshold, 'Slow downloading speed @ ' . float_format($time) . ' seconds (downloading Google home page took over)');
    }*/

    // Slow upload speed
    /*public function testForSlowUpload($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $test_file_path = get_file_base() . '/data/curl-ca-bundle.crt';

        $data_to_send = str_repeat(file_get_contents($test_file_path), 20);

        $time_before = microtime(true);
        $post_params = array('test_data' => $data_to_send);
        $data = http_download_file('http://www.cloudflare.com/about-overview/', null, false, true, 'Composr', $post_params);
        $time_after = microtime(true);

        $time = ($time_after - $time_before);

        $megabytes_per_second = floatval(strlen($data_to_send)) / (1024.0 * 1024.0 * $time);

        $threshold_in_megabits_per_second = 4.0;

        $this->assertTrue($megabytes_per_second * 8.0 > $threshold_in_megabits_per_second, 'Slow uploading speed @ ' . float_format($megabytes_per_second) . ' Megabytes per second');
    }*/

    // A page takes more than a second to load
    /*public function testForSlowPageSpeeds($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $page_links = array( // TODO: Make configurable
            ':',
        );

        foreach ($page_links as $page_link) {
            $url = page_link_to_url($page_link);

            $time_before = microtime(true);
            $data = http_download_file($url);
            $time_after = microtime(true);

            $time = ($time_after - $time_before);

            $threshold = 1.0; // Threshold is pretty high because we may have stale caches etc; we're looking for major issues, not testing our overall optimisation

            $this->assertTrue($time < $threshold, 'Slow page generation speed for "' . $page_link . '" page @ ' . float_format($time) . ' seconds)');
        }
    }*/

    // Meta description missing for page, too short, or too long
    /*public function testForBadMetaDescription($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $data = $this->get_page_content();
        if ($data === null) {
            return;
        }

        $meta_description = null;
        $matches = array();
        if (preg_match('#<meta\s+[^<>]*name="description"[^<>]*content="([^"]*)"#is', $data, $matches) != 0) {
            $meta_description = $matches[1];
        } elseif (preg_match('#<meta\s+[^<>]*content="([^"]*)"[^<>]*name="description"#is', $data, $matches) != 0) {
            $meta_description = $matches[1];
        }

        $ok = ($meta_description !== null);
        $this->assertTrue($ok, 'Could not find a meta description');
        if ($ok) {
            $len = strlen($meta_description);
            $min_threshold = 40;
            $max_threshold = 155;
            $this->assertTrue($len >= $min_threshold, 'Meta description lengthis under ' . strval($min_threshold) . ' @ ' . strval(integer_format($len)) . ' characters');
            $this->assertTrue($len <= $max_threshold, 'Meta description length is over ' . strval($max_threshold) . ' @ ' . strval(integer_format($len)) . ' characters');
        }
    }*/

    // Meta keywords missing for page, too few, or too many
    /*public function testForBadMetaKeywords($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $data = $this->get_page_content();
        if ($data === null) {
            return;
        }

        $meta_keywords = null;
        $matches = array();
        if (preg_match('#<meta\s+[^<>]*name="keywords"[^<>]*content="([^"]*)"#is', $data, $matches) != 0) {
            $meta_keywords = array_map('trim', explode(',', $matches[1]));
        } elseif (preg_match('#<meta\s+[^<>]*content="([^"]*)"[^<>]*name="keywords"#is', $data, $matches) != 0) {
            $meta_keywords = array_map('trim', explode(',', $matches[1]));
        }

        $ok = ($meta_keywords !== null);
        $this->assertTrue($ok, 'Could not find any meta keywords');
        if ($ok) {
            $count = count($meta_keywords);
            $min_threshold = 4;
            $max_threshold = 20;
            $this->assertTrue($count >= $min_threshold, 'Meta keyword count is under ' . strval($min_threshold) . ' @ ' . strval(integer_format($count)));
            $this->assertTrue($count <= $max_threshold, 'Meta keyword count is over ' . strval($max_threshold) . ' @ ' . strval(integer_format($count)));
        }
    }*/

    // No <title>, too short, or too long
    /*public function testForBadTitle($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $data = $this->get_page_content();
        if ($data === null) {
            return;
        }

        $title = null;
        $matches = array();
        if (preg_match('#<title[^<>]*>([^<>]*)</title>#is', $data, $matches) != 0) {
            $title = $matches[1];
        }

        $ok = ($title !== null);
        $this->assertTrue($ok, 'Could not find any <title>');
        if ($ok) {
            $len = strlen($title);
            $min_threshold = 4;
            $max_threshold = 70;
            $this->assertTrue($len >= $min_threshold, '<title> length is under ' . strval($min_threshold) . ' @ ' . strval(integer_format($len)));
            $this->assertTrue($len <= $max_threshold, '<title> length is over ' . strval($max_threshold) . ' @ ' . strval(integer_format($len)));
        }
    }*/

    // No <h1>
    /*public function testForBadH1($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $data = $this->get_page_content();
        if ($data === null) {
            return;
        }

        $header = null;
        $matches = array();
        if (preg_match('#<h1[^<>]*>([^<>]*)</h1>#is', $data, $matches) != 0) {
            $header = $matches[1];
        }

        $ok = ($header !== null);
        $this->assertTrue($ok, 'Could not find any <h1>');
    }*/

    // XML Sitemap not being extended
    /*public function testForXMLSitemapUpdating($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (!cron_installed()) {
            return;
        }

        $path = get_custom_file_base() . '/data_custom/sitemaps';

        $last_updated_file = @filemtime($path . '/index.xml');
        $ok = ($last_updated_file !== false);
        $this->assertTrue($ok, 'XML Sitemap does not seem to be building');

        if ($ok) {
            $last_updated_file = 0;
            $dh = opendir($path);
            while (($f = readdir($dh)) !== false) {
                if (preg_match('#^set_\d+\.xml$#', $f) != 0) {
                    $last_updated_file = max($last_updated_file, filemtime($path . '/' . $f));
                }
            }
            closedir($dh);
            $last_updated = $GLOBALS['SITE_DB']->query_select_value_if_there('sitemap_cache', 'MAX(last_updated)');
            if ($last_updated !== null) {
                $this->assertTrue($last_updated_file > $last_updated - 60 * 60 * 24, 'XML Sitemap does not seem to be updating');
            }
        }
    }*/

    // robots.txt fails validation test
    /*public function testForRobotsTxtErrors($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $this->robotsParse(null, true);
    }

    // robots.txt banning Google on a live site
    public function testForRobotsTxtBlocking($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $url = $this->get_page_url();

        $google_blocked = $this->robotsAllowed($url, 'Googlebot', true);
        $other_blocked = $this->robotsAllowed($url, 'Googlebot', false); // We'll still check for Google, just with the other way of doing precedence

        if ($google_blocked == $other_blocked) {
            $this->assertTrue($google_blocked, 'Site blocked by robots.txt');
        } else {
            $this->assertTrue($google_blocked, 'Site blocked on Google by robots.txt as per Google\'s way of implementing robots standard');
            $this->assertTrue($other_blocked, 'Site blocked on Google by robots.txt as per standard (non-Google) way of implementing robots standard');
        }

        / *
        This shows how the inconsistency works...

        Standard block:
        User-Agent: *
        Disallow: /
        Allow: /composr
        (Disallow takes precedence due to order of rules)

        Google block:
        User-Agent: *
        Allow: /
        Disallow: /composr
        (Disallow takes precedence due to specificity)

        Consistent block:
        User-Agent: *
        Disallow: /composr
        Allow: /
        (Disallow takes precedence both due due to order of rules and specificity)
        * /
    }

    protected function robotsAllowed($url, $user_agent, $google_style)
    {
        $this->robotsParse($user_agent);

        $rules = $this->robots_rules;

        if ($rules === null) {
            return true;
        }

        $url_path = parse_url($url, PHP_URL_PATH);

        $best_precedence = 0;
        $allowed = true;
        foreach ($rules as $_rule) {
            list($key, $rule) = $_rule;

            switch ($key) {
                case 'allow':
                case 'disallow':
                    if ($rule == '') {
                        continue; // Ignored rule
                    }

                    if (preg_match('#^' . $rule . '#', $url_path) != 0) {
                        if ($google_style) {
                            if (strlen($rule) > $best_precedence) {
                                $allowed = ($key == 'allow');
                                $best_precedence = strlen($rule);
                            }
                        } else {
                            return ($key == 'allow');
                        }
                    }

                    break;
            }
        }
        return $allowed;
    }

    protected $rules;

    protected function robotsParse($user_agent, $error_messages = false)
    {
        // The best specification is by Google now:
        //  https://developers.google.com/search/reference/robots_txt

        $this->robots_rules = null;

        $robots_path = get_file_base() . '/robots.txt'; // TODO: Should be on domain root
        if (!is_file($robots_path)) {
            return;
        }

        $agents_regexp = preg_quote('*');
        if ($user_agent !== null) {
            $agents_regexp .= '|' . preg_quote($user_agent, '#');
        }

        $robots_lines = explode("\n", cms_file_get_contents_safe($robots_path));

        // Go through lines
        $rules = array();
        $following_rules_apply = false;
        $best_following_rules_apply = 0;
        $just_did_ua_line = false;
        $did_some_ua_line = false;
        foreach ($robots_lines as $line) {
            $line = trim($line);

            // Skip blank lines
            if ($line == '') {
                continue;
            }

            // Skip comment lines
            if ($line[0] == '#') {
                continue;
            }

            // The following rules only apply if the User-Agent matches
            $matches = array();
            if (preg_match('#^User-Agent:(.*)#i', $line, $matches) != 0) {
                $agent_spec = $matches[1];
                $_following_rules_apply = (preg_match('#(' . $agents_regexp . ')#i', $agent_spec) != 0); // It's a bit weird how "googlebot-xxx" would match but "google" would not, but that's the standard (and there's justification when you think about it)
                if ($_following_rules_apply) {
                    if (strlen($agent_spec) >= $best_following_rules_apply) {
                        $following_rules_apply = true;
                        $best_following_rules_apply = strlen($agent_spec);
                        $rules = array(); // Reset rules, as now this is the best scoring rules section (we don't merge sections)
                    }
                } elseif (!$just_did_ua_line) {
                    $following_rules_apply = false;
                }

                $just_did_ua_line = true;
                $did_some_ua_line = true;

                continue;
            }

            // Record rules
            if (preg_match('#^(\w+):\s*(.*)\s*$#i', $line, $matches) != 0) {
                $key = strtolower($matches[1]);
                $value = trim($matches[2]);

                $core_rule = ($key == 'allow') || ($key == 'disallow');

                if ($error_messages) {
                    $this->assertTrue(in_array($key, array('allow', 'disallow', 'sitemap', 'crawl-delay')), 'Unrecognised robots.txt rule:' . $key);

                    if ($core_rule) {
                        $this->assertTrue($did_some_ua_line, 'Floating ' . ucwords($key) . ' outside of any User-Agent section of robots.txt');
                    }
                }

                if ($following_rules_apply) {
                    // Add rules that apply to array for testing
                    if ($core_rule) {
                        $rule = addcslashes($value, '#\+?^[](){}|-'); // Escape things that are in regexps but should be literal here
                        $rule = str_replace('*', '.*', $rule); // * wild cards are ".*" in a regexp
                        // "$" remains unchanged

                        $rules[] = array($key, $rule);
                    } else {
                        $rules[] = array($key, $value);
                    }
                }

                $just_did_ua_line = false;

                continue;
            }

            // TODO: What if Sitemap URL on different domain or different protocol, or relative URL?

            // Unrecognised line
            if ($error_messages) {
                $this->assertTrue(false, 'Unrecognised line in robots.txt:' . $line);
            }
        }

        $this->robots_rules = $rules;
    }*/

    // robots.txt missing or does not block maintenance scripts
    /*public function testForRobotsTxtInsufficient($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // Can download secured files that are meant to be in .htaccess / web.config
    /*public function testForPublicSecuredFileAccess($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $to_check = array(
            'data_custom/ecommerce.log',
            'caches/test.txt',
            'safe_mode_temp/test.txt',
        );
        foreach ($to_check as $c) {
            $full_path = get_custom_file_base() . '/' . $c;
            $exists = is_file($full_path);
            if (!$exists) {
                cms_file_put_contents_safe($full_path, '');
            }
            http_download_file(get_custom_base_url() . '/' . $c, null, false);
            $this->assertTrue($GLOBALS['HTTP_MESSAGE'] == '403', 'Should not be able to download ' . $c . ', should be secured by some kind of server configuration');
            if (!$exists) {
                @unlink($full_path);
            }
        }
    }*/

    // MyISAM database table(s) crashed
    /*public function testForCorruptTables($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (strpos(get_db_type(), 'mysql') !== false) {
            $tables = $GLOBALS['SITE_DB']->query_select('db_meta', array('DISTINCT m_table'));
            foreach ($tables as $table) {
                $results = $GLOBALS['SITE_DB']->query('CHECK TABLE ' . get_table_prefix() . $table['m_table']);
                $ok = $results[0]['Msg_text'] == 'OK';

                if (!$ok) {
                    $message = 'Corrupt table likely repairing: ' . $table['m_table'] . ' gave status ' . $results[0]['Msg_text'];
                    if ($automatic_repair) {
                        $results_repair = $GLOBALS['SITE_DB']->query('REPAIR TABLE ' . get_table_prefix() . $table['m_table']);
                        $ok_repair = $results[0]['Msg_text'] == 'OK';
                        if ($ok_repair) {
                            $message = 'Corrupt table automatically repaired: ' . $table['m_table'] . ' gave status ' . $results[0]['Msg_text'];
                        }
                    }

                    $this->assertTrue($ok, $message);
                } else {
                    $this->assertTrue(true);
                }
            }
        }
    }*/

    // Missing </html> tag on page
    /*public function testForBrokenPages($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $page_links = array( // TODO: Make configurable
            ':',
        );

        foreach ($page_links as $page_link) {
            $data = $this->get_page_content($page_link);
            if ($data === null) {
                continue;
            }

            $this->assertTrue(strpos($data, '</html>') !== false, '"' . $page_link . '" page appears broken, missing closing HTML tag');
        }
    }*/

    // Page too big (configurable
    /*public function testForHugePages($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $page_links = array( // TODO: Make configurable
            ':',
        );

        $threshold_page_size = 500000; // TODO: Make configurable

        require_code('files');

        foreach ($page_links as $page_link) {
            $data = $this->get_page_content($page_link);
            if ($data === null) {
                continue;
            }

            $size = strlen($data);
            $this->assertTrue($size < $threshold_page_size, '"' . $page_link . '" page is very large @ ' . clean_file_size($size));
        }
    }*/

    // Disk space too low
    /*public function testForLowDiskSpace($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('disk_free_space')) {
            $disk_space_threshold = 500 * 1024 * 1024; // TODO: Make configurable

            require_code('files');

            $free_space = disk_free_space(get_custom_file_base());
            $this->assertTrue($free_space > $disk_space_threshold, 'Disk space very low @ ' . clean_file_size($free_space));
        }

        // TODO: Remove page-load request, "Little disk space check" and it's independent notification
    }*/

    // No guest access to page
    /*public function testForPagesWithoutAccess($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $page_links = array( // TODO: Make configurable
            ':',
        );

        require_code('files');

        foreach ($page_links as $page_link) {
            $data = $this->get_page_content($page_link);

            $this->assertTrue(!in_array($GLOBALS['HTTP_MESSAGE'], array('401', '403')), '"' . $page_link . '" page is not allowing guest access');
        }
    }*/

    // Backups configured but not appearing under exports/backups
    /*public function testForFailingBackups($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $backup_schedule_time = intval(get_value('backup_schedule_time'));
        $last_backup = get_value('last_backup');
        if (($backup_schedule_time > 0) && ($last_backup !== null)) {
            $path = get_custom_file_base() . '/exports/backups';
            $found = false;
            $dh = opendir($path);
            while (($f = readdir($dh)) !== false) {
                if ((substr($f, -4) == '.tar') || (substr($f, -3) == '.gz')) {
                    $size = filesize($path . '/' . $f);
                    $found = $found || ($size > 5000000);
                }
            }
            closedir($dh);

            $this->assertTrue($found, 'Cannot find a scheduled backup file that looks complete');
        }
    }*/

    // Web server not accessible from external proxy
    /*public function testForExternalAccess($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ($this->is_localhost_domain()) {
            return;
        }

        $url = 'https://tools.keycdn.com/curl-query.php?url=' . urlencode($this->get_page_url());
        $data = http_download_file($url);
        $this->assertTrue(strpos($data, '200 OK') !== false, 'Cannot access website externally');
    }*/

    // http:// URLs appearing on page when site has a https:// base URL (configurable list of page-links)
    /*public function testForIncorrectHTTPSLinking($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // Non-https images/scripts/CSS/etc embedded on pages that are https (configurable list of page-links)
    /*public function testForIncorrectHTTPSEmbedding($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // Links to broken CSS or JavaScript or image files
    /*public function testForBrokenLinks($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $page_links = array( // TODO: Make configurable
            ':',
        );

        $urls = array();
        foreach ($page_links as $page_link) {
            $data = $this->get_page_content($page_link);
            if ($data === null) {
                continue;
            }

            $matches = array();
            $num_matches = preg_match_all('#<link\s[^<>]*href="([^"]*)"[^<>]*rel="stylesheet"#is', $data, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $urls[] = $matches[1][$i];
            }
            $num_matches = preg_match_all('#<link\s[^<>]*rel="stylesheet"[^<>]*href="([^"]*)"#is', $data, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $urls[] = $matches[1][$i];
            }
            $num_matches = preg_match_all('#<script\s[^<>]*src="([^"]*)"#is', $data, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $urls[] = $matches[1][$i];
            }
            $num_matches = preg_match_all('#<(img|audio|video|source|track|input|iframe|embed)\s[^<>]*src="([^"]*)"#is', $data, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $urls[] = $matches[2][$i];
            }
            $num_matches = preg_match_all('#<(a|area)\s[^<>]*href="([^"]*)"#is', $data, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $urls[] = $matches[2][$i];
            }
            $num_matches = preg_match_all('#<object\s[^<>]*data="([^"]*)"#is', $data, $matches);
            for ($i = 0; $i < $num_matches; $i++) {
                $urls[] = $matches[1][$i];
            }
        }
        $urls = array_unique($urls);

        $_urls = array();
        foreach ($urls as $url) {
            if (substr($url, 0, 2) == '//') {
                $url = 'http:' . $url;
            }

            // Don't check local URLs, we're interested in broken remote links (local validation is too much)
            if (substr($url, 0, strlen(get_base_url(false)) + 1) == get_base_url(false) . '/') {
                continue;
            }
            if (substr($url, 0, strlen(get_base_url(true)) + 1) == get_base_url(true) . '/') {
                continue;
            }
            if (strpos($url, '://') === false) {
                continue;
            }

            $_urls[] = $url;
        }

        foreach ($_urls as $url) {
            // Check
            $data = http_download_file($url, 0, false);
            $this->assertTrue($data !== null, 'Broken link: ' . $url);
        }
    }*/

    // Inconsistent database state
    /*public function testForInconsistentDBState($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ($manual_checks) {
            require_code('database_repair');
            $repair_ob = new DatabaseRepair();
            list($phase, $sql) = $repair_ob->search_for_database_issues();
            $this->assertTrue($sql == '', 'There seem to be some inconsistencies in the database, run the "Correct MySQL schema issues (advanced)" Website Cleanup Tool');
        }
    }*/

    // Outdated copyright date
    /*public function testForCopyrightOutdated($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $data = $this->get_page_content();

        if ((date('m-d') == '00-01') || (date('m-d') == '12-31')) {
            // Allow for inconsistencies around new year
            return;
        }

        $current_year = intval(date('Y'));

        $year = null;
        $matches = array();
        if (preg_match('#(Copyright|&copy;|©).*(\d{4})[^\d]{1,10}(\d{4})#', $data, $matches) != 0) {
            $_year_first = intval($matches[2]);
            $_year = intval($matches[3]);
            if (($_year - $_year_first > 0) && ($_year - $_year_first < 100) && ($_year > $current_year - 10) && ($_year <= $current_year)) {
                $year = $_year;
            }
        } elseif (preg_match('#(Copyright|&copy;|©).*(\d{4})#', $data, $matches) != 0) {
            $_year = intval($matches[2]);
            if (($_year > $current_year - 10) && ($_year <= $current_year)) {
                $year = $_year;
            }
        }

        if ($year !== null) {
            $this->assertTrue($year == $current_year, 'Copyright date seems outdated');
        }
    }*/

    // Fall in Google position (ties into main_staff_website_monitoring block)
    /*public function testForGooglePositionDrop($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // Fall in hits
    /*public function testForHitDrop($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // www/non-www redirect not handled well - either does not exist, or redirects deep to home page, and/or is not 301
    /*public function testForWWWRedirectingIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // https/non-https redirect not handled well - either does not exist, or redirects deep to home page, and/or is not 301
    /*public function testForHTTPSRedirectingIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO
    }*/

    // Database upgrade pending
    /*public function testForIntegrityIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        require_code('upgrade');

        $version_files = cms_version_number();

        $_version_database = get_value('version');
        $version_database = floatval($_version_database);
        $this->assertTrue($version_files <= $version_database, 'Database seems to need an upgrade (' . float_format($version_files, 1) . ' vs ' . float_format($version_database, 1) . '), run upgrader');

        $_version_database = get_value('cns_version');
        $version_database = floatval($_version_database);
        $this->assertTrue($version_files <= $version_database, 'Database seems to need an upgrade (' . float_format($version_files, 1) . ' vs ' . float_format($version_database, 1) . '), run upgrader');
    }*/

    // Integrity checker fail
    /*public function testForIntegrityIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ($manual_checks) {
            require_code('upgrade');
            $data = run_integrity_check(false, false, false);
            $this->assertTrue($data == do_lang('NO_ISSUES_FOUND'), 'Integrity checker in upgrader reporting potential issues');
        }
    }*/

    // E-mail queue piling up
    /*public function testForEmailQueueStuck($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $sql = 'SELECT COUNT(*) FROM ' . get_table_prefix() . 'logged_mail_messages WHERE m_queued=1 AND m_date_and_time<' . strval(time() - 60 * 60 * 1);
        $count = $GLOBALS['SITE_DB']->query_value_if_there($sql);

        $this->assertTrue($count == 0, 'The e-mail queue has e-mails still not sent within the last hour');
    }*/

    // Newsletter queue piling up
    /*public function testForNewsletterQueueStuck($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $sql = 'SELECT COUNT(*) FROM ' . get_table_prefix() . 'newsletter_drip_send WHERE d_inject_time<' . strval(time() - 60 * 60 * 24 * 7);
        $count = $GLOBALS['SITE_DB']->query_value_if_there($sql);

        $this->assertTrue($count == 0, 'The newsletter queue has e-mails still not sent within a week');
    }*/

    // Stuff going into error log fast
    /*public function testForErrorLogFlooding($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $path = get_custom_file_base() . '/data_custom/errorlog.php';
        $myfile = fopen($path, 'rb');
        if ($myfile !== false) {
            $filesize = filesize($path);

            fseek($myfile, max(0, $filesize - 50000));

            fgets($myfile); // Skip line part-way-through

            $threshold_time = time() - 60 * 60 * 24 * 1;
            $threshold_count = 50; // TODO: Make configurable

            $dates = array();
            while (!feof($myfile)) {
                $line = fgets($myfile);

                $matches = array();
                if (preg_match('#^\[([^\[\]]*)\] #', $line, $matches) != 0) {
                    $timestamp = @strtotime($matches[1]);
                    if (($timestamp !== false) && ($timestamp > $threshold_time)) {
                        $dates[] = $timestamp;
                    }
                }
            }

            fclose($myfile);

            $this->assertTrue(count($dates) < $threshold_count, integer_format(count($dates)) . ' logged errors in the last day');
        }
    }*/

    // Cache or temp directories unreasonably huge
    /*public function testForOverflowingDirectories($manual_checks = false, $automatic_repair = false, $is_test_site = false)
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
                $this->assertTrue($size < $mb * $max_threshold_size_in_mb, 'Directory ' . $dir . ' is very large @ ' . clean_file_size($size));
            }
        }

        $directories = array(
            'uploads/incoming' => 50,
            'safe_mode_temp' => 50, // TODO: temp in v11
            'data_custom' => 100,
        );
        foreach ($directories as $dir => $max_contents_threshold) {
            $count = count(get_directory_contents(get_file_base() . '/' . $dir));
            $this->assertTrue($count < $max_contents_threshold, 'Directory ' . $dir . ' now contains ' . integer_format($count) . ' files, should hover only slightly over empty');
        }
    }*/

    // Logs too large
    /*public function testForLargeLogs($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        require_code('files');

        $path = get_file_base() . '/data_custom';
        $dh = opendir($path);
        while (($f = readdir($dh)) !== false) {
            if (strpos($f, 'log') !== false) {
                $size = filesize($path . '/' . $f);
                $this->assertTrue($size < 1000000, 'Size of ' . $f . ' log is very large @ ' . clean_file_size($size));
            }
        }
        closedir($dh);
    }*/

    // Volatile tables unreasonably huge
    /*public function testForOverflowingTables($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
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
            $this->assertTrue($cnt < max_threshold, 'Volatile-defined table now contains ' . integer_format($cnt) . ' records');
        }
    }*/

    // Admin account that has not logged in in months and should be deleted
    /*public function testForUnusedAdminAccounts($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $threshold = time() - 60 * 60 * 24 * 90; // TODO: Make configurable

        $admin_groups = $GLOBALS['FORUM_DRIVER']->get_super_admin_groups();
        $members = $GLOBALS['FORUM_DRIVER']->member_group_query($admin_groups);
        foreach ($members as $member) {
            $last_visit = $GLOBALS['FORUM_DRIVER']->mrow_lastvisit($member);
            $username = $GLOBALS['FORUM_DRIVER']->mrow_username($member);
            $this->assertTrue($last_visit > $threshold, 'Admin account "' . $username . '" not logged in for a long time @ ' . display_time_period(time() - $last_visit) . ', consider deleting');
        }
    }*/

    // Logins from the same account but different countries (indicates hacking)
    /*public function testForCountryShifting($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (addon_installed('stats')) {
            $test = $GLOBALS['SITE_DB']->query_select_value_if_there('ip_country', 'id');
            $ok = ($test !== null);

            if ($manual_checks) {
                $this->assertTrue($ok, 'Geolocation data not installed so cannot do admin country checks');
            }

            if ($ok) {
                require_code('locations');

                $admin_groups = $GLOBALS['FORUM_DRIVER']->get_super_admin_groups();
                $members = $GLOBALS['FORUM_DRIVER']->member_group_query($admin_groups);
                foreach ($members as $member) {
                    $id = $GLOBALS['FORUM_DRIVER']->mrow_id($member);
                    $username = $GLOBALS['FORUM_DRIVER']->mrow_username($member);

                    $countries = array();
                    $rows = $GLOBALS['SITE_DB']->query_select('stats', array('DISTINCT ip'), array('member_id' => $id), 'AND date_and_time>' . strval(time() - 60 * 60 * 24 * 7));
                    foreach ($rows as $row) {
                        $country = geolocate_ip($row['ip']);
                        if ($country !== null) {
                            $countries[] = $country;
                        }
                    }

                    $this->assertTrue(count($countries) <= 1, 'Admin account "' . $username . '" appears to have logged in from multiple countries (' . implode(', ', $countries) . ')');
                }
            }
        }
    }*/

    // Unusual number of hack attacks
    /*public function testForHackAttackSpike($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $sql = 'SELECT COUNT(*) FROM ' . get_table_prefix() . 'hackattack WHERE date_and_time>' . strval(time() - 60 * 60 * 24);
        $num_failed = $GLOBALS['SITE_DB']->query_value_if_there($sql);
        $this->assertTrue($num_failed < 100, integer_format($num_failed) . ' hack-attack alerts happened today');

        // TODO: For v11 add a 'percentage_score' field to the hackattack table
        //  insert rows in enforce_captcha with a low score
        //  insert rows before warn_exit(do_lang_tempcode('STOPPED_BY_ANTISPAM' in antispam.php with a zero score
        //  consider the score in any threshold tests (including automatic banning)
        //  filter out any lower scores from the admin_security module with a threshold input field that defaults to 80%
    }*/

    // Unusual number of failed logins
    /*public function testForFailedLoginsSpike($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $sql = 'SELECT COUNT(*) FROM ' . get_table_prefix() . 'failedlogins WHERE date_and_time>' . strval(time() - 60 * 60 * 24);
        $num_failed = $GLOBALS['SITE_DB']->query_value_if_there($sql);
        $this->assertTrue($num_failed < 100, integer_format($num_failed) . ' failed logins happened today');
    }*/

    // Unusual increase in rate limiting triggers (could indicate a DDOS)
    /*public function testForRateLimitingSpike($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        global $RATE_LIMITING_DATA;
        $RATE_LIMITING_DATA = array();

        $rate_limiter_path = get_custom_file_base() . '/data_custom/rate_limiter.php';
        if (is_file($rate_limiter_path)) {
            $fp = fopen($rate_limiter_path, 'rb');
            flock($fp, LOCK_SH);
            include($rate_limiter_path);
            flock($fp, LOCK_UN);
            fclose($fp);
        }

        $threshold_sample = 20;
        $threshold_rps = 1.0;

        $threshold_sample_compound = 60;
        $threshold_rps_compound = 0.3;

        / *  Test
        $RATE_LIMITING_DATA = array(
            '1.2.3.4' => array_fill(0, 30, time()),
        );
        * /

        if (!empty($RATE_LIMITING_DATA)) {
            global $SITE_INFO;
            $rate_limit_time_window = empty($SITE_INFO['rate_limit_time_window']) ? 10 : intval($SITE_INFO['rate_limit_time_window']);

            $times_compound = array();

            foreach ($RATE_LIMITING_DATA as $ip => $times) {
                $requests_per_second = floatval(count($times)) / floatval($rate_limit_time_window);
                $ok = (count($times) < $threshold_sample) || ($requests_per_second < $threshold_rps);
                $this->assertTrue($ok, float_format($requests_per_second, 2, true) . ' PHP requests per second (for a sample size over ' . integer_format($threshold_sample) . ') requests from IP ' . $ip);

                $times_compound = array_merge($times_compound, $times);
            }

            $requests_per_second = floatval(count($times_compound)) / floatval($rate_limit_time_window);
            $ok = (count($times_compound) < $threshold_sample) || ($requests_per_second < $threshold_rps);
            $this->assertTrue($ok, float_format($requests_per_second, 2, true) . ' PHP requests per second (for a sample size over ' . integer_format($threshold_sample_compound) . ') requests from all IPs together');
        }
    }*/

    // High server CPU load
    /*public function testForHighCPULoad($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $cpu = null;

            if (strpos(PHP_OS, 'Darwin') !== false) {
                $result = explode("\n", shell_exec('iostat'));
                array_shift($result);
                array_shift($result);
                if (isset($result[0])) {
                    $matches = array();
                    if (preg_match('#(\d+)\s+(\d+)\s+(\d+)\s+\d+\.\d+\s+\d+\.\d+\s+\d+\.\d+\s*$#', $result[0], $matches) != 0) {
                        $cpu = floatval($matches[1]) + floatval($matches[2]);
                    }
                }
            }

            if (strpos(PHP_OS, 'Linux') !== false) {
                $result = explode("\n", shell_exec('iostat'));
                array_shift($result);
                array_shift($result);
                array_shift($result);
                if (isset($result[0])) {
                    $matches = array();
                    if (preg_match('#^\s*(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)#', $result[0], $matches) != 0) {
                        $cpu = floatval($matches[1]) + floatval($matches[2]) + floatval($matches[3]);
                    }
                }
            }

            / *  This technique is okay in theory, but there's too much rounding when we're looking at a narrow threshold
            sleep(2); // Let CPU recover a bit from our own script
            $result = explode("\n", shell_exec('ps -A -o %cpu'));
            $cpu = 0.0;
            foreach ($result as $r) {
                if (is_numeric(trim($cpu))) {
                    $cpu += floatval($r);
                }
            }
            * /

            if ($cpu !== null) {
                $threshold = 97.0;

                $this->assertTrue($cpu < $threshold, 'CPU utilisation is very high @ ' . float_format($cpu) . '%');
            }
        }
    }*/ 

    // High server uptime value
    /*public function testForPoorUptimeValue($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $data = shell_exec('uptime');

            $matches = array();
            if (preg_match('#load averages:\s*(\d+\.\d+)#', $data, $matches) != 0) {
                $uptime = floatval($matches[1]);
                $threshold = 20; // TODO: Make a config option
                $this->assertTrue($uptime < $threshold, '"uptime" (server load) is very high @ ' . float_format($uptime) . '%');
            }
        }
    }*/

    // High server I/O load
    /*public function testForHighIOLoad($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $load = null;

            if (strpos(PHP_OS, 'Linux') !== false) {
                $result = explode("\n", shell_exec('iostat'));
                array_shift($result);
                array_shift($result);
                array_shift($result);
                if (isset($result[0])) {
                    $matches = array();
                    if (preg_match('#^\s*(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)\s+(\d+\.\d+)#', $result[0], $matches) != 0) {
                        $load = floatval($matches[4]);
                    }
                }
            }

            if ($load !== null) {
                $threshold = 80.0;

                $this->assertTrue($load < $threshold, 'I/O load is causing high wait time @ ' . float_format($load) . '%');
            }
        }
    }*/

    // Hanging (long-running) PHP/Apache processes (the process names to monitor would be configurable)
    /*public function testForHangingProcesses($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $commands_regexp = 'php\d*|php\d*-cgi|php\d*-fpm|php\d*.dSYM'; // TODO: Make configurable
            $threshold_minutes = 5; // TODO: Make configurable

            $ps_cmd = 'ps -ocomm,etime';
            //$ps_cmd .= ' -A';
            $result = explode("\n", shell_exec($ps_cmd));
            foreach ($result as $r) {
                $matches = array();
                if (preg_match('#^(' . $commands_regexp . ')\s+(\d+(:(\d+))*)\s*$#', $r, $matches) != 0) {
                    $seconds = 0;
                    $time_parts = array_reverse(explode(':', $matches[2]));
                    foreach ($time_parts as $i => $_time_part) {
                        $time_part = intval($_time_part);

                        switch ($i) {
                            case 0:
                                $seconds += $time_part;
                                break;

                            case 1:
                                $seconds += $time_part * 60;
                                break;

                            case 2:
                                $seconds += $time_part * 60 * 60;
                                break;

                            case 3:
                            default: // We assume anything else is days, we don't know what other units may be here, and it's longer than we care of anyway
                                $seconds += $time_part * 60 * 60 * 24;
                                break;
                        }
                    }

                    $cmd = $matches[1];

                    $this->assertTrue($seconds < 60 * $threshold_minutes, 'Process "' . $cmd . '" has been running a long time @ ' . display_time_period($seconds));
                }
            }
        }
    }*/

    // Low free RAM
    /*public function testForLowRAM($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $kb_free = null;

            $matches = array();

            if (strpos(PHP_OS, 'Darwin') !== false) {
                $data = shell_exec('vm_stat');
                if (preg_match('#^Pages free:\s*(\d+)#m', $data, $matches) != 0) {
                    $kb_free = intval($matches[1]) * 4;
                }
            }

            if (strpos(PHP_OS, 'Linux') !== false) {
                $data = shell_exec('free');
                if (preg_match('#^Mem:\s+(\d+)\s+(\d+)\s+(\d+)#m', $data, $matches) != 0) {
                    $kb_free = intval($matches[3]);
                }
            }

            if ($kb_free !== null) {
                $mb_threshold = 200; // TODO: Make configurable
                $this->assertTrue($kb_free > $mb_threshold * 1024, 'Server has less than 200MB of free RAM');
            }
        }
    }*/

    // Infected with Malware
    /*public function testForMalwareInfection($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // API https://developers.google.com/safe-browsing/v4/

        $key = 'AIzaSyBJyvgYzg-moqMRBZwhiivNxhYvafqMWas'; // TODO: Make configurable
        if ($key == '') {
            return;
        }

        require_code('json'); // Change in v11

        / *if ($this->is_localhost_domain()) {   TODO Re-enable
            return;
        }* /

        $page_links = array( // TODO: Make configurable
            ':',
        );

        $urls = array();
        foreach ($page_links as $page_link) {
            $_url = page_link_to_url($page_link);
            if (!empty($_url)) {
                $urls[] = array('url' => $_url);
            }
        }
        $urls = array(array('url' => 'http://www23.omrtw.com')); // TODO: This is just temporary test data
        //$urls = array(array('url' => 'http://example.com')); // TODO: This is just temporary test data

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
        $_result = http_download_file($url, null, false, false, 'Composr', array(json_encode($data)), null, null, null, null, null, null, null, 200.0, true, null, null, null, 'application/json');

        $this->assertTrue(!in_array($GLOBALS['HTTP_MESSAGE'], array('401', '403')), 'Error with our Google Safe Browsing API key (' . $GLOBALS['HTTP_MESSAGE'] . ')');
        $this->assertTrue(!in_array($GLOBALS['HTTP_MESSAGE'], array('400', '501', '503', '504')), 'Internal error with our Google Safe Browsing check (' . $GLOBALS['HTTP_MESSAGE'] . ')');

        $ok = in_array($GLOBALS['HTTP_MESSAGE'], array('200'));
        if ($ok) {
            $result = json_decode($_result, true);

            if (empty($result['matches'])) {
                $this->assertTrue(true);
            } else {
                foreach ($result['matches'] as $match) {
                    $this->assertTrue(false, 'Malware advisory provided by Google ' . json_encode($match) . ' (https://developers.google.com/safe-browsing/v3/advisory)');
                }
            }
        }
    }*/

    // DNS not resolving
    /*public function testForMailIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ((php_function_allowed('getmxrr')) && (php_function_allowed('checkdnsrr'))) {
            $domains = $this->get_mail_domains();

            foreach ($domains as $domain => $email) {
                $mail_hosts = array();
                $result = @getmxrr($domain, $mail_hosts);
                $this->assertTrue($result, 'Cannot look up MX records for our ' . $email . ' e-mail address');

                foreach ($mail_hosts as $host) {
                    $this->assertTrue(checkdnsrr($host, 'A'), 'Mail server DNS does not seem to be setup properly for our ' . $email . ' e-mail address');

                    if ((php_function_allowed('fsockopen')) && (php_function_allowed('gethostbyname')) && (php_function_allowed('gethostbyaddr'))) {
                        // See if SMTP running
                        $socket = @fsockopen($host, 25);
                        $can_connect = ($socket !== false);
                        $this->assertTrue($can_connect, 'Cannot connect to SMTP server for ' . $email . ' address');
                        if ($can_connect) {
                            fread($socket, 1024);
                            fwrite($socket, 'HELO ' . $domain . "\n");
                            $data = fread($socket, 1024);
                            fclose($socket);

                            $matches = array();
                            $has_helo = preg_match('#^250 ([^\s]*)#', $data, $matches) != 0;
                            $this->assertTrue($has_helo, 'Cannot get HELO response from SMTP server for ' . $email . ' address');
                            if ($has_helo) {
                                $reported_host = $matches[1];

                                / *
                                $reverse_dns_host = gethostbyaddr(gethostbyname($host));  Fails way too much

                                $this->assertTrue($reported_host == $reverse_dns_host, 'HELO response from SMTP server (' . $reported_host . ') not matching reverse DNS (' . $reverse_dns_host . ') for ' . $email . ' address');
                                * /
                            }
                        }
                    }
                }

                // What if mailbox missing? Or generally e-mail not received
                if ($manual_checks) {
                    require_code('mail');
                    mail_wrap('Test', 'Test e-mail from Health Check', array($email));
                    $this->assertTrue(false, 'Manual check: An e-mail was sent to ' . $email . ', confirm it was received');
                }
            }
        }
    }*/

    /*protected function do_spf_check($domain, $self_domain, $self_ip)
    {
        $records = dns_get_record($domain, DNS_TXT);
        foreach ($records as $record) {
            if (!isset($record['txt'])) {
                continue;
            }
            $_record = $record['txt'];

            $matches = array();
            if (preg_match('#^v=spf1 (.*)#', $_record, $matches) != 0) {
                $passed = false;
                $blocked = false;
                $passed_wildcard = false;

                $parts = explode(' ', $matches[1]);
                foreach ($parts as $part) {
                    // Normalise to something more manageable
                    $prefix = substr($part, 0, 1);
                    if (in_array($prefix, array('+', '-', '#', '?'))) {
                        $part = substr($part, 1);
                    } else {
                        $prefix = '+';
                    }
                    if ($prefix == '~') {
                        $prefix = '-';
                    }

                    if ($this->spf_term_matches($part, $self_domain, $self_ip)) {
                        switch ($prefix) {
                            case '+':
                                $passed = true;
                                break;

                            case '-':
                                $blocked = true;
                                break;
                        }
                    }

                    if ($part == 'all') {
                        switch ($prefix) {
                            case '+':
                                $passed_wildcard = true;
                                break;

                            case '-':
                                // We ignore this, we consider neutrality and blocking all equivalently
                                break;
                        }
                    }
                }

                $this->assertTrue(!$passed_wildcard, 'SPF record for ' . $domain . ' is wildcarded, so offers no real value');

                return ($passed || $passed_wildcard) && !$blocked;
            }
        }

        return null;
    }

    protected function spf_term_matches($part, $self_domain, $self_ip)
    {
        if (substr($part, 0, 4) == 'ip4:') {
            $_part = substr($part, 4);

            if (strpos($_part, '/') === false) {
                return ($self_ip == $_part);
            } else {
                require_code('failure'); // TODO: Remove in v11
                return ip_cidr_check($self_ip, $_part);
            }
        }

        if (($part == 'a:' . $self_domain) || ($part == 'a')) {
            return true;
        }

        if (($part == 'mx:' . $self_domain) || ($part == 'mx')) {
            return true;
        }
        if (($part == 'ptr:' . $self_domain) || ($part == 'ptr')) {
            return true;
        }

        if (substr($part, 0, 8) == 'include:') {
            $include = substr($part, 8);
            $ret = $this->do_spf_check($include, $self_domain, $self_ip);

            $this->assertTrue($ret !== null, 'SPF include ' . $include . ' is broken');

            if ($ret === null) {
                $ret = false;
            }
            return $ret;
        }

        if (substr($part, 0, 9) == 'redirect:') {
            $redirect = substr($part, 9);
            $ret = $this->do_spf_check($redirect, $self_domain, $self_ip);

            $this->assertTrue($ret !== null, 'SPF redirect ' . $redirect . ' is broken');

            if ($ret === null) {
                $ret = false;
            }
            return $ret;
        }

        return false;
    }

    // SPF prohibits us sending
    public function testForSPFBlock($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ((php_function_allowed('dns_get_record')) && (php_function_allowed('gethostbyname')) && ($manual_checks) && (get_option('smtp_sockets_use') == '0')) {
            $self_domain = $this->get_domain();
            $self_ip = gethostbyname($self_domain);

            $domains = $this->get_mail_domains();

            foreach ($domains as $domain => $email) {
                $passed = $this->do_spf_check($domain, $self_domain, $self_ip);

                $this->assertTrue($passed !== null, 'SPF record is not set for ' . $domain . ', setting it will significantly reduce the chance of fraud and spam blockage');

                if ($passed !== null) {
                    $this->assertTrue($passed, 'SPF record for ' . $domain . ' does not allow the server to send (either blocked or neutral). Maybe your local SMTP is relaying via another server, but check that.');
                }
            }
        }
    }*/

    // SMTP server is blacklisted
    /*public function testForSMTPBlacklisting($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        require_code('antispam');

        if ((php_function_allowed('getmxrr')) && (php_function_allowed('checkdnsrr')) && (php_function_allowed('gethostbyname'))) {
            $domains = $this->get_mail_domains();

            foreach ($domains as $domain => $email) {
                $mail_hosts = array();
                $result = @getmxrr($domain, $mail_hosts);
                if ($result === false) {
                    continue;
                }

                foreach ($mail_hosts as $host) {
                    $ip = gethostbyname($host);
                    $rbls = array(
                        '*.dnsbl.sorbs.net',
                        '*.bl.spamcop.net',
                    );
                    foreach ($rbls as $rbl) {
                        $response = rbl_resolve($ip, $rbl, true);
                        $blocked = ($response === array('127', '0', '0', '2'));
                        $this->assertTrue(!$blocked, 'The ' . $host . ' SMTP server is blocked by ' . $rbl);
                    }
                }
            }
        }
    }*/

    // DNS not resolving
    /*public function testForDNSResolutionIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('checkdnsrr')) {
            $domain = $this->get_domain();

            if (!$this->is_localhost_domain($domain)) {
                $this->assertTrue(checkdnsrr($domain, 'A'), 'DNS does not seem to be setup properly for our domain');
            }
        }
    }*/

    // Running on an expired domain name
    /*public function testForExpiringDomainName($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (php_function_allowed('shell_exec')) {
            $domain = $this->get_domain();

            if (!$this->is_localhost_domain($domain)) {
                $data = shell_exec('whois \'domain ' . escapeshellarg($domain) . '\'');

                $matches = array();
                if (preg_match('#(Expiry date|Expiration date|Expiration):\s*([^\s]*)#im', $data, $matches) != 0) {
                    $expiry = strtotime($matches[2]);
                    if ($expiry > 0) {
                        $this->assertTrue($expiry > time() - 60 * 60 * 24 * 7, 'Domain seems to be expiring within a week or already expired');
                    }
                }
            }
        }
    }*/

    // Site seems to be configured on a base URL which is not what a public web request sees is running on that base URL (security)
    /*public function testForOrphanedSite($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $path = 'uploads/website_specific/orphaned-test.txt';
        require_code('crypt');
        $data = get_rand_password();
        cms_file_put_contents_safe(get_custom_file_base() . '/' . $path, $data);
        $this->assertTrue(http_download_file(get_custom_base_url() . '/' . $path) == $data);
        @unlink(get_custom_file_base() . '/' . $path);

        if (php_function_allowed('shell_exec')) {
            $domain = $this->get_domain();
            $regexp = '#\nNon-authoritative answer:\nName:\s+' . $domain . '\nAddress:\s+(.*)\n#';

            $matches_local = array();
            $dns_lookup_local = shell_exec('nslookup ' . $domain);
            $matched_local = preg_match($regexp, $dns_lookup_local, $matches_local);
            $matches_remote = array();
            $dns_lookup_remote = shell_exec('nslookup ' . $domain . ' 8.8.8.8');
            $matched_remote = preg_match($regexp, $dns_lookup_remote, $matches_remote);
            if (($matched_local != 0) && ($matched_remote != 0)) {
                $this->assertTrue($matches_local[1] == $matches_remote[1], 'DNS lookup for our domain seems to be looking up differently (' . $matches_local[1] . ' vs ' . $matches_remote[1] . ')');
            }
        }
    }*/

    // Cookie problems
    /*public function testForLargeCookies($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $url = $this->get_page_url();

        $headers = get_headers($url, 1);
        $found_has_cookies_cookie = false;
        foreach ($headers as $key => $vals) {
            if (strtolower($key) == strtolower('Set-Cookie')) {
                if (is_string($vals)) {
                    $vals = array($val);
                }

                foreach ($vals as $val) {
                    if (preg_match('#^has_cookies=1;#', $val) != 0) {
                        $found_has_cookies_cookie = true;
                    }

                    // Large cookies set
                    $_val = preg_replace('#^.*=#U', '', preg_replace('#; .*$#s', '', $val));
                    $this->assertTrue(strlen($_val) < 100, 'Cookie with over 100 bytes being set which is bad for performance');
                }

                // Too many cookies set
                $this->assertTrue(count($vals) < 8, '8 or more cookies are being set which is bad for performance');
            }
        }

        // Composr cookies not set
        $this->assertTrue($found_has_cookies_cookie, 'Cookies not being properly set');
    }*/

    // Files/Pages are not gzipped or cached properly
    /*public function testForURLHTTPPerfIssues($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        //set_option('gzip_output', '1');   To test

        $urls = array(
            'page' => $this->get_page_url(),
            'css' => get_base_url() . '/themes/default/templates_cached/EN/global.css',
            'js' => get_base_url() . '/themes/default/templates_cached/EN/global.js',
            'png' => get_base_url() . '/themes/default/images/button1.png',
        );

        foreach ($urls as $type => $url) {
            stream_context_set_default(array('http' => array('header' => 'Accept-Encoding: gzip')));
            $headers = @get_headers($url, 1);
            if ($headers === false) {
                continue;
            }

            $is_gzip = false;
            $is_cached = false;
            foreach ($headers as $key => $vals) {
                if (is_string($vals)) {
                    $vals = array($vals);
                }

                switch (strtolower($key)) {
                    case 'content-encoding':
                        foreach ($vals as $val) {
                            if ($val == 'gzip') {
                                $is_gzip = true;
                            }
                        }

                        break;

                    case 'expires':
                        $is_cached = (strtotime($vals[0]) > time());
                        break;

                    case 'last-modified':
                        $is_cached = (strtotime($vals[0]) < time());
                        break;
                }
            }

            switch ($type) {
                case 'page':
                    $this->assertTrue(!$is_cached, 'Caching should not be given for pages (except for bots, which Composr will automatically do if the static cache is enabled)');
                    $this->assertTrue($is_gzip, 'Gzip compression is not enabled/working for pages, significantly wasting bandwidth for page loads');
                    break;

                case 'css':
                case 'js':
                    $this->assertTrue($is_cached, 'Caching should be given for ' . $type . ' files (Composr will automatically make sure edited versions cache under different URLs via automatic timestamp parameters)');
                    $this->assertTrue($is_gzip, 'Gzip compression is not enabled/working for ' . $type . ' files, significantly wasting bandwidth for page loads');
                    break;

                case 'png':
                    $this->assertTrue($is_cached, 'Caching should be given for ' . $type . ' files');
                    $this->assertTrue(!$is_gzip, 'Gzip compression should not be given for ' . $type . ' files, they are already compressed so it is a waste of CPU power');
                    break;
            }
        }
    }*/

    // Composr version no longer supported
    /*public function testForDiscontinuedComposr($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $is_discontinued = $this->call_composr_homesite_api('is_release_discontinued', array('version' => cms_version_number()));
        $this->assertTrue($is_discontinued !== true, 'The ' . brand_name() . ' version is discontinued');
    }*/

    // PHP version no longer supported
    /*public function testForUnsupportedPHP($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        require_code('version2');

        $v = strval(PHP_MAJOR_VERSION) . '.' . strval(PHP_MINOR_VERSION);

        $this->assertTrue(is_php_version_supported($v), 'Unsupported PHP version ' . $v);
    }*/

    // Site is closed
    /*public function testForSiteClosed($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (!$is_test_site) {
            $this->assertTrue(get_option('site_closed') == '1', 'The website is still closed');
        }
    }*/

    // Staff not doing their tasks as identified by items in the staff checklist
    /*public function testForStaffChecklistIgnoring($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ($manual_checks) {
            require_code('blocks/main_staff_checklist');

            $_hooks = find_all_hooks('blocks', 'main_staff_checklist'); // TODO: Change in v11
            foreach (array_keys($_hooks) as $hook) {
                require_code('hooks/blocks/main_staff_checklist/' . filter_naughty_harsh($hook));
                $object = object_factory('Hook_checklist_' . filter_naughty_harsh($hook), true);
                if (is_null($object)) {
                    continue;
                }
                $ret = $object->run();

                foreach ($ret as $r) {
                    list(, $seconds_due_in, $num_to_do) = $r;

                    if ($seconds_due_in !== null) {
                        $ok = ($seconds_due_in > 0);
                        $this->assertTrue($ok, 'Staff checklist items for ' . $hook . ' due ' . display_time_period($seconds_due_in) . ' ago');
                        if (!$ok) {
                            break;
                        }
                    }

                    if ($num_to_do !== null) {
                        $ok = ($num_to_do == 0);
                        $this->assertTrue($ok, 'Staff checklist items for ' . $hook . ', ' . integer_format($num_to_do) . ' items');
                        if (!$ok) {
                            break;
                        }
                    }
                }
            }
        }
    }*/

    // Google Analytics configured but not in output HTML
    /*public function testForGANonPresent($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        $ga = get_option('google_analytics');
        if (trim($ga) != '') {
            $data = $this->get_page_content();
            if ($data === null) {
                return;
            }

            $this->assertTrue(strpos($data, $ga) !== false, 'Google Analytics enabled but not in page output (themeing issue?)');
        }
    }*/
    // TODO: Check with API data being collected?

    // Has links to local files.
    /*public function testForLocalLinks($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ($manual_checks) {
            if ($this->is_localhost_domain()) {
                return;
            }

            $data = $this->get_page_content();
            if ($data === null) {
                return;
            }

            $c = '#https?://(localhost|127\.|192\.168\.|10\.)#';
            $this->assertTrue(preg_match($c, $data) == 0, 'Found links to a local URL');
        }
    }*/

    // Has lorem ipsum or TODOs
    /*public function testForIncomplete($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if ($manual_checks) {
            $data = $this->get_page_content();
            if ($data === null) {
                return;
            }

            $check_for = array('TODO', 'FIXME', 'Lorem Ipsum');
            foreach ($check_for as $c) {
                $this->assertTrue(strpos($data, $c) === false, 'Found a suspicious "' . $c . '"');
            }
        }
    }*/

    // Things wrong found by checking manually
    /*public function testForManualValidation($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        if (!$manual_checks) {
            return;
        }

        $this->assertTrue(false, 'Check HTML5 validation https://validator.w3.org/ (take warnings with a pinch of salt, not every suggestion is appropriate)');
        $this->assertTrue(false, 'Check CSS validation https://jigsaw.w3.org/css-validator/ (take warnings with a pinch of salt, not every suggestion is appropriate)');
        $this->assertTrue(false, 'Check WCAG validation https://achecker.ca/ (take warnings with a pinch of salt, not every suggestion is appropriate)');

        $this->assertTrue(false, 'Check schema.org/microformats validation on any key pages you want to be semantic https://search.google.com/structured-data/testing-tool/u/0/');
        $this->assertTrue(false, 'Check OpenGraph metadata on any key pages you expect to be shared https://developers.facebook.com/tools/debug/sharing/');

        $this->assertTrue(false, 'Check for speed issues https://developers.google.com/speed/pagespeed/insights (take warnings with a pinch of salt, not every suggestion is appropriate)');

        $this->assertTrue(false, 'Check for SSL security issues https://www.ssllabs.com/ssltest/ (take warnings with a pinch of salt, not every suggestion is appropriate)');

        $this->assertTrue(false, 'Check for SEO issues https://seositecheckup.com/ (take warnings with a pinch of salt, not every suggestion is appropriate)');
        $this->assertTrue(false, 'Check for search issues in Google Webmaster Tools https://www.google.com/webmasters/tools/home');

        $this->assertTrue(false, 'Do a general check https://www.woorank.com/ (take warnings with a pinch of salt, not every suggestion is appropriate)');
        $this->assertTrue(false, 'Do a general check https://website.grader.com/ (take warnings with a pinch of salt, not every suggestion is appropriate)');

        $this->assertTrue(false, 'Test in Firefox');
        $this->assertTrue(false, 'Test in Google Chrome');
        $this->assertTrue(false, 'Test in IE10');
        $this->assertTrue(false, 'Test in IE11');
        $this->assertTrue(false, 'Test in Microsoft Edge');
        $this->assertTrue(false, 'Test in Safari');
        $this->assertTrue(false, 'Test in Google Chrome (mobile)');
        $this->assertTrue(false, 'Test in Safari (mobile)');

        $this->assertTrue(false, 'Manually check the web server error logs, e.g. for 404 errors you may want to serve via a redirect');

        $this->assertTrue(false, 'Manually check the website would look good if printed');

        $this->assertTrue(false, 'Manually check the social media channels are being regularly updated');
    }*/

    // HTTP implementation is failing
    /*public function testForHTTPFailing($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO: Move http.php unit test to here
    }*/

    // Some block(s) not rendering
    /*public function testForBlocksFailing($manual_checks = false, $automatic_repair = false, $is_test_site = false)
    {
        // TODO: Move blocks all render unit test (blocks.php) to here
    }*/

    // -- finishing --

    // TODO: Check that http_download_file calls all have errors blocked but also properly handle null results and HTTP response codes

    // TODO: Some of the services we are using should be moved to compo.sr so we don't abuse other people's services

    // TODO: Say what has to be skipped. Probably instead of assert's we'll have success/failure/skip calls

    // TODO: Whether it is a test site or a live site would be controlled via a configuration option, which will turn into a method parameter. Change methods to use it as appropriate (e.g. robots.txt checks for blocking on a test site).

    // -- integration --

    // TODO: Convert into checks hooks, initially in a non-bundled addon. Each check hook would get a parameter to say whether it was running for an install, a live site, or a test site, or in manual mode.

    // TODO: The checks should be initiated from a new "Health Check" item on the 'Tools' menu of the Admin Zone, which would call manual mode. There'd be checkboxes to say what tests to run, very similar to 'Website cleanup tools'.
    // TODO: Results would be shown in a table. Each failed check would quote the codename of the hook that failed, and there'd be a config option to list codenames of hooks to not run.

    // TODO: Checks would also be runnable by a health_check.php script in data_custom. This would need http-authentication to run, or an explicit login as an admin. It would need to be documented in the codebook (which lists manually callable scripts). It should allow a parameter to filter which checks to run.

    // TODO: Tie into CRON, but with a config option of whether it runs. It should run as the first CRON hook. E-mail results on a new notification type ("Automatic check failure"). A config option would allow specifying whether to get a daily "all is good" e-mail sent out.

    // TODO: Create new bridge unit test (out of this file)

    // -- testing --

    // TODO: Windows support, and test

    // TODO: Test everything on compo.sr

    // -- documentation in v11 --

    // TODO: List feature in our features list.

    // TODO: Document this Health Check system, including all the checks that run, and how it needs CRON, and how you can plug an external uptime checker tool into the health_check.php script. Maybe this would all be documented next to our advice about something like Uptime Robot.
    /*
    We want to be able to automatically detect when something goes wrong with a website.
    This could be:
     - Software compatibility issue arisen
     - Upgrade fault
     - Hardware failure
     - Hack-attack
     - Some important admin item forgotten
     - Some kind of screw up
    The web is just far too complex and commoditised now for people to be able to intentionally check for everything that could go wrong. We need to get all the checks automated into the system.
    */

    // TODO: Document in the Code Book: Health Check vs Testing Platform vs Local web-standards checks vs PHP-Info vs Website Cleanup Tools vs Staff Checklist vs Health Check manual linking to external tools. Most tests will still be done in the dev cycle (testing platform) [due to needing extra code, or taking a long time to run, or being destructive]

    // TODO: Add running a Health Check to the sup_professional_upgrading and the codebook_standards tutorials.

    // -- v11 --

    // TODO: Add testForManualValidation etc links to maintenance-sheet

    // TODO: Move over to bundled in Composr v11

    // TODO: Drop database_integrity.php unit test

    // TODO: Strip from 'PHP-info' and the Admin Zone dashboard, where it runs currently.

    // TODO: Mark done on tracker https://compo.sr/tracker/view.php?id=3314
}
