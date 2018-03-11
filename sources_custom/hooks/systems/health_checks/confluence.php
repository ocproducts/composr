<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    confluence
 */

/**
 * Hook class.
 */
class Hook_health_check_confluence extends Hook_Health_Check
{
    protected $category_label = 'Confluence';

    /**
     * Standard hook run function to run this category of health checks.
     *
     * @param  ?array $sections_to_run Which check sections to run (null: all)
     * @param  integer $check_context The current state of the website (a CHECK_CONTEXT__* constant)
     * @param  boolean $manual_checks Mention manual checks
     * @param  boolean $automatic_repair Do automatic repairs where possible
     * @param  ?boolean $use_test_data_for_pass Should test data be for a pass [if test data supported] (null: no test data)
     * @return array A pair: category label, list of results
     */
    public function run($sections_to_run, $check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        if (($check_context != CHECK_CONTEXT__INSTALL) && (addon_installed('confluence'))) {
            $confluence_subdomain = get_option('confluence_subdomain');
            $confluence_space = get_option('confluence_space');
            if (($confluence_subdomain == '') || ($confluence_space == '')) {
                return array($this->category_label, array());
            }

            $this->process_checks_section('testConfluenceConnection', 'API connection', $sections_to_run, $check_context, $manual_checks, $automatic_repair, $use_test_data_for_pass);
        }

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
    public function testConfluenceConnection($check_context, $manual_checks = false, $automatic_repair = false, $use_test_data_for_pass = null)
    {
        if ($check_context == CHECK_CONTEXT__INSTALL) {
            return;
        }

        require_code('confluence');

        global $CONFLUENCE_SPACE;
        $space = confluence_query('space?spaceKey=' . $CONFLUENCE_SPACE, false);
        $this->assert_true($space !== null, 'Configured Confluence connection is working');
    }
}