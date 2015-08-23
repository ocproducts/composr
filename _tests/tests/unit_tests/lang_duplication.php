<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

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
class lang_duplication_test_set extends cms_test_case
{
    public function setUp()
    {
        require_code('lang_compile');

        parent::setUp();
    }

    public function testLangMistakes()
    {
        $verbose = false;

        $vals = array();

        $num = 0;

        $dh = opendir(get_file_base() . '/lang/EN/');
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) != '.ini') {
                continue;
            }
            if ($file[0] == '.') {
                continue;
            }

            $input = array();
            _get_lang_file_map(get_file_base() . '/lang/EN/' . $file, $input, null, false);

            foreach ($input as $key => $val) {
                if (!isset($vals[$val])) {
                    $vals[$val] = array();
                }
                $vals[$val][] = $key;
            }

            $num += count($input);
        }
        closedir($dh);

        $num_unique = count($vals);

        $percentage_duplicated = 100.0 - 100.0 * floatval($num_unique) / floatval($num);

        $this->assertTrue($percentage_duplicated < 6.0); // Ideally we'd lower it, but 6% is what it was when this test was written. We're testing it's not getting worse.

        // Find out what is duplicated
        foreach ($vals as $val => $multiple) {
            if (count($multiple) == 1) {
                unset($vals[$val]);
            }
        }
        //@var_dump($vals);exit();
    }

    public function tearDown()
    {
        parent::tearDown();
    }
}
