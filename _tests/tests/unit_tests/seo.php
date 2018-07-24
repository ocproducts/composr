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
class seo_test_set extends cms_test_case
{
    public function testKeywordGeneration()
    {
        require_code('content2');

        // Test coverage for many cases:
        //  words differing only in case
        //  Proper Nouns
        //  apostrophes
        //  hyphenation
        //  no word repetition
        //  no stop words
        //  first word detected
        list($keywords) = _seo_meta_find_data(array('hello Mr Tester this Is a world-renowned luxorious test. Epic epic testing, it shan\'t fail.'), '');
        $this->assertTrue($keywords == 'testing,shan\'t,fail,epic,Mr Tester,world-renowned,luxorious,hello', 'Got: ' . $keywords);

        // Test last word detected
        list($keywords) = _seo_meta_find_data(array('Epic'), '');
        $this->assertTrue($keywords == 'Epic', 'Got: ' . $keywords);

        // Test unicode too; also capitalised stop words still stripped
        $emoji = hex2bin('f09f9881');
        list($keywords) = _seo_meta_find_data(array('This is epic' . $emoji), '');
        $this->assertTrue($keywords == 'epic', 'Got: ' . $keywords);
    }
}
