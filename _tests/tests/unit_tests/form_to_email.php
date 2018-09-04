<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class form_to_email_test_set extends cms_test_case
{
    public function testFormToEmail()
    {
        $GLOBALS['SITE_DB']->query_delete('logged_mail_messages');

        $bak = get_option('mail_queue_debug');
        set_option('mail_queue_debug', '1');
        $url = find_script('form_to_email');
        $result = cms_http_request($url, array('trigger_error' => false, 'post_params' => array('foo' => 'bar')));
        set_option('mail_queue_debug', $bak);

        if (get_param_integer('debug', 0) == 1) {
            @var_dump($result);
        }

        $rows = $GLOBALS['SITE_DB']->query_select('logged_mail_messages', array('*'), array(), 'ORDER BY m_date_and_time DESC', 2);
        foreach ($rows as $row) {
            $this->assertTrue(strpos($row['m_message'], 'bar') !== false);
        }

        $this->assertTrue(count($rows) == 1);
    }
}
