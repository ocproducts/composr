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
class lang_descriptions_test_set extends cms_test_case
{
    private $lang_files;

    public function setUp()
    {
        parent::setUp();

        require_code('lang_compile');
        require_code('lang2');

        $this->lang_files = get_lang_files(fallback_lang());
    }

    public function testNoMissingOrphanDescriptions()
    {
        foreach (array_keys($this->lang_files) as $file) {
            $descriptions = get_lang_file_section(fallback_lang(), $file, 'descriptions');
            $strings = get_lang_file_section(fallback_lang(), $file, 'strings');
            foreach ($descriptions as $key => $val) {
                $this->assertTrue(isset($strings[$key]), 'Description has no string to match: ' . $key);
            }
        }
    }

    public function testNoMissingDescriptions()
    {
        foreach (array_keys($this->lang_files) as $file) {
            $descriptions = get_lang_file_section(fallback_lang(), $file, 'descriptions');
            $strings = get_lang_file_section(fallback_lang(), $file, 'strings');
            foreach ($strings as $key => $val) {
                if (strtolower($key) == $key) {
                    $this->assertTrue(isset($descriptions[$key]), 'Lower case string has no description to match: ' . $key);
                }
            }
        }
    }
}
