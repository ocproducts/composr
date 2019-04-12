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
class firephp_test_set extends cms_test_case
{
    public function testFirePHP()
    {
        $this->establish_admin_session();

        $guest_username = $GLOBALS['FORUM_DRIVER']->get_username($GLOBALS['FORUM_DRIVER']->get_guest_id());

        $url = build_url(array('page' => '', 'keep_firephp' => 1, 'keep_su' => $guest_username), 'adminzone');

        $header = '';
        $header .= 'Cookie: ' . get_session_cookie() . '=' . get_session_id() . "\r\n";
        $header .= 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36 FirePHP/4Chrome' . "\r\n";
        $header .= 'X-FirePHP-Version: 0.0.6';

        $default_opts = array(
            'http' => array(
                'header' => $header,
            )
        );
        stream_context_set_default($default_opts);
        $headers = @get_headers($url->evaluate());

        $this->assertTrue($headers !== false, 'HTTP request failed');

        if (get_param_integer('debug', 0) == 1) {
            @var_dump($url->evaluate());
            @var_dump($header);
            @var_dump($headers);
        }

        $found = false;
        if ($headers !== false) {
            foreach ($headers as $header) {
                $found = $found || (strpos($header, 'Permission check FAILED: has_zone_access: adminzone') !== false);
            }
        }
        $this->assertTrue($found, 'Could not find a firephp header');
    }
}
