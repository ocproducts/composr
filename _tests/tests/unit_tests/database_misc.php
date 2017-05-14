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
class database_misc_test_set extends cms_test_case
{
    public function testEmoji()
    {
        $emoji = chr(hexdec('F0')) . chr(hexdec('9F')) . chr(hexdec('98')) . chr(hexdec('81'));
        set_value('emoji_test', $emoji);
        $this->assertTrue($emoji == get_value('emoji_test'));
        delete_value('emoji_test');
    }
}
