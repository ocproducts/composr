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
class antispam_test_set extends cms_test_case
{
    public function testHeuristics()
    {
        $_POST['foo_alien_code'] = '[link]http://example.com[/link] <a href="http://example.com">foo</a>';
        $_POST['foo_autonomous'] = '[font="Times New Roman"]foo[/font]';
        set_option('spam_heuristic_country', 'IN');
        $_GET['keep_country'] = 'IN';
        unset($_SERVER['HTTP_ACCEPT']);
        $_POST['foo_keywords']='Foo ViagrA Bar';
        $_SERVER['HTTP_USER_AGENT'] = 'Spambot';

        require_code('antispam');
        list($confidence, $scoring) = calculation_internal_heuristic_confidence();

        $this->assertTrue(strpos($scoring, 'alien_code') !== false);
        $this->assertTrue(strpos($scoring, 'autonomous') !== false);
        $this->assertTrue(strpos($scoring, 'country') !== false);
        $this->assertTrue(strpos($scoring, 'header_absence') !== false);
        $this->assertTrue(strpos($scoring, 'keywords') !== false);
        $this->assertTrue(strpos($scoring, 'links') !== false);
        $this->assertTrue(strpos($scoring, 'user_agents') !== false);

        if (is_guest()) {
            $this->assertTrue(strpos($scoring, 'guest') !== false);
        } else {
            $this->assertTrue(strpos($scoring, 'guest') === false);
        }
    }
}
