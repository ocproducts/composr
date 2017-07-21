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
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__health_check()
{
    define('CHECK_CONTEXT__INSTALL', 0);
    define('CHECK_CONTEXT__TEST_SITE', 1);
    define('CHECK_CONTEXT__LIVE_SITE', 2);
    define('CHECK_CONTEXT__PROBING_FOR_SECTIONS', 3);

    define('HEALTH_CHECK__FAIL', 0);
    define('HEALTH_CHECK__PASS', 1);
    define('HEALTH_CHECK__MANUAL', 2);
    define('HEALTH_CHECK__SKIPPED', 3);
    define('HEALTH_CHECK__IDENTIFIED_SECTION', 4); // Only (and solely) used during the CHECK_CONTEXT__PROBING_FOR_SECTIONS context
}

/**
 * Find all the Health Check categories.
 *
 * @return array List of result categories
 */
function find_health_check_categories()
{
    $check_context = CHECK_CONTEXT__PROBING_FOR_SECTIONS;

    $all_results = array();

    $hooks = find_all_hooks('systems', 'health_checks'); // TODO: Fix in v11
    foreach (array_keys($hooks) as $hook) {
        require_code('hooks/systems/health_checks/' . filter_naughty($hook));
        $ob = object_factory('Hook_health_check_' . $hook);
        list($category_label, $results) = $ob->run($check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);
        $all_results[] = array($category_label, $results);
    }

    return $all_results;
}

/**
 * Run a Health Check.
 *
 * @param  boolean $manual_checks Mention manual checks
 * @param  boolean $automatic_repair Do automatic repairs where possible
 * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
 * @return array List of result categories with results
 */
function run_health_check($manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
{
    if (running_script('install')) {
        $check_context = CHECK_CONTEXT__INSTALL;
    } else {
        if (true) { // TODO: Make configurable
            $check_context = CHECK_CONTEXT__TEST_SITE;
        } else {
            $check_context = CHECK_CONTEXT__LIVE_SITE;
        }
    }

    $all_results = array();

    $hooks = find_all_hooks('systems', 'health_checks'); // TODO: Fix in v11
    foreach (array_keys($hooks) as $hook) {
        require_code('hooks/systems/health_checks/' . filter_naughty($hook));
        $ob = object_factory('Hook_health_check_' . $hook);
        list($category_label, $results) = $ob->run($check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);
        $all_results[] = array($category_label, $results);
    }

    return $all_results;
}

/**
 * Base object for Health Check hooks.
 *
 * @package    health_check
 */
abstract class Hook_Health_Check
{
    protected $category_label = 'Unknown category';
    private $current_section_label = 'Unknown section';
    protected $results = array();

    /*
    HEALTH CHECK BASIC API
    */

    /**
     * Process a checks section.
     *
     * @param  string $method The method containing the checks
     * @param  string $section_label The section label
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     */
    protected function process_checks_section($method, $section_label, $check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        $this->current_section_label = $section_label;

        if ($check_context != CHECK_CONTEXT__PROBING_FOR_SECTIONS) {
            call_user_func(array($this, $method), $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);
        } else {
            $this->results[] = array(HEALTH_CHECK__IDENTIFIED_SECTION, $section_label);
        }
    }

    /*
    CHECK REPORTING
    */

    /**
     * Report a check result, with the message if it failed.
     *
     * @param  boolean $result Whether the check passed
     * @param  string $message Failure message
     */
    protected function assert_true($result, $message = '%s')
    {
        if ($result) {
            $this->results[] = array($this->current_section_label, HEALTH_CHECK__PASS, $message);
        } else {
            $this->results[] = array($this->current_section_label, HEALTH_CHECK__FAIL, $message);
        }
    }

    /**
     * State a manual check.
     *
     * @param  string $message What to check
     */
    protected function state_check_manual($message)
    {
        $this->results[] = array($this->current_section_label, HEALTH_CHECK__MANUAL, $message);
    }

    /**
     * State that a check was skipped.
     * This is only called when we would like to run a check but something is stopping us; we do not call it for checks that don't make any sense to run for any reason.
     *
     * @param  string $reason The reason for the skip, with possible details of exactly what was skipped
     */
    protected function state_check_skipped($reason)
    {
        $this->results[] = array($this->current_section_label, HEALTH_CHECK__SKIPPED, $reason);
    }

    /*
    SITE URL/DOMAIN QUERYING
    */

    /**
     * Get the URL for a page-link.
     *
     * @param  string $page_link The page-link
     * @param  string The URL
     */
    protected function get_page_url($page_link = ':')
    {
        static $urls = array();
        if (!array_key_exists($page_link, $urls)) {
            $urls[$page_link] = page_link_to_url($page_link);
        }
        return $urls[$page_link];
    }

    /**
     * Get the website domain name.
     *
     * @param  string Domain name
     */
    protected function get_domain()
    {
        return parse_url(get_base_url(), PHP_URL_HOST);
    }

    /**
     * Get a list of e-mail domains the site uses.
     *
     * @param  array List of e-mail domains
     */
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
                unset($domains[$domain]);
            }
        }

        return array_unique($domains);
    }

    /**
     * Find whether a domain is local.
     *
     * @param  ?string $domain The domain (null: website domain)
     * @param  boolean Whether it is local
     */
    protected function is_localhost_domain($domain = null)
    {
        if ($domain === null) {
            $domain = parse_url(get_base_url(), PHP_URL_HOST);
        }

        return ($domain == 'localhost') || (trim($domain, '0123456789.') == '') || (strpos($domain, ':') !== false);
    }

    /**
     * Convert any URLs to page-links in the given array.
     *
     * @param  array $_urls_or_page_links List of URLs and/or page-links
     * @return array List of page-links
     */
    protected function process_urls_into_page_links($_urls_or_page_links)
    {
        $urls_or_page_links = array();
        foreach ($_urls_or_page_links as $url_or_page_link) {
            if (looks_like_url($url_or_page_link)) {
                $urls_or_page_links[] = url_to_page_link($url_or_page_link);
            } else {
                $urls_or_page_links[] = $url_or_page_link;
            }
        }
        return $urls_or_page_links;
    }

    /*
    PAGE DOWNLOADING
    */

    /**
     * Download a page by page-link.
     *
     * @param  string $page_link Page-link
     * @param  string Page content
     */
    protected function get_page_content($page_link = ':')
    {
        static $ret = array();
        if (!array_key_exists($page_link, $ret)) {
            $ret[$page_link] = http_download_file($this->get_page_url($page_link), null, false, true);

            // Server blocked to access itself
            if ($page_link == ':') {
                $this->assert_true($ret[$page_link] !== null, 'The server cannot download itself');
            }
        }
        return $ret[$page_link];
    }

    /*
    PAGE SCANNING
    */

    /**
     * Get all the embedded URLs in some HTML.
     *
     * @param  string $data HTML
     * @return array List of URLs
     */
    protected function get_embed_urls_from_data($data)
    {
        $urls = array();

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
        $num_matches = preg_match_all('#<(area)\s[^<>]*href="([^"]*)"#is', $data, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $urls[] = $matches[2][$i];
        }
        $num_matches = preg_match_all('#<object\s[^<>]*data="([^"]*)"#is', $data, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $urls[] = $matches[1][$i];
        }

        $urls = array_unique($urls);

        return $urls;
    }

    /**
     * Get all the hyperlinked URLs in some HTML.
     *
     * @param  string $data HTML
     * @return array List of URLs
     */
    protected function get_link_urls_from_data($data)
    {
        $urls = array();

        $matches = array();

        $num_matches = preg_match_all('#<(a)\s[^<>]*href="([^"]*)"#is', $data, $matches);
        for ($i = 0; $i < $num_matches; $i++) {
            $urls[] = $matches[2][$i];
        }

        $urls = array_unique($urls);

        return $urls;
    }

    /*
    COMPO.SR API
    */

    /**
     * Call a compo.sr API function.
     *
     * @param  string $type API type
     * @param  array $params Map of parameters
     * @param  mixed API result
     */
    protected function call_composr_homesite_api($type, $params)
    {
        require_code('json'); // Fix in v11

        $url = 'https://compo.sr/uploads/website_specific/compo.sr/scripts/api.php?type=' . urlencode($type);
        foreach ($params as $key => $_val) {
            switch (gettype($_val)) {
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
        return @json_decode(http_download_file($url, null, false), true);
    }
}
