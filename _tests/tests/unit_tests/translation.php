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
class translation_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('translation');

        // Please don't use these on a live site, we just need these to test against
        set_option('google_apis_api_key', 'AIzaSyD-jqeO_HlD1bLmA68JhAJOBajZw96-UHE');

        set_option('google_translate_enabled', '1');
    }

    public function testTranslation()
    {
        $from = 'Hello';
        $to = translate_text($from, TRANS_TEXT_CONTEXT_autodetect, 'EN', 'FR');
        $this->assertTrue($to == 'Bonjour', 'Got ' . $to);
    }
}
