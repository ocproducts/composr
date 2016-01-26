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

        $all_keys = array();

        $dh = opendir(get_file_base() . '/lang/EN/');
        while (($file = readdir($dh)) !== false) {
            if (substr($file, -4) != '.ini') {
                continue;
            }
            if ($file[0] == '.') {
                continue;
            }

            $input = array();
            _get_lang_file_map(get_file_base() . '/lang/EN/' . $file, $input, 'strings', false);

            foreach ($input as $key => $val) {
                if (!isset($vals[$val])) {
                    $vals[$val] = array();
                }
                $vals[$val][] = $key;

                if (isset($all_keys[$key])) {
                    $this->assertTrue(false, 'Duplication for key ' . $key . ' string');
                }
                $all_keys[$key] = true;
            }

            $num += count($input);
        }
        closedir($dh);

        $num_unique = count($vals);

        $percentage_duplicated = 100.0 - 100.0 * floatval($num_unique) / floatval($num);

        $this->assertTrue($percentage_duplicated < 8.0, 'Overall heavy duplication'); // Ideally we'd lower it, but 6% is what it was when this test was written. We're testing it's not getting worse.

        // Find if there is any unnecessary underscoring
        /*foreach (array_keys($all_keys) as $key) {     Was useful once, but there are reasonable cases remaining
            if ((substr($key, 0, 1) == '_') && (strtoupper($key) == $key) && (!isset($all_keys[substr($key, 1)]))) {
                $this->assertTrue(false, 'Unnecessary prefixing of ' . $key);
            }
        }*/

        // Find out what is duplicated
        foreach ($vals as $val => $multiple) {
            if (count($multiple) == 1) {
                unset($vals[$val]);
            } else {
                if (count(array_unique($vals[$val])) != count($vals[$val])) {
                    $this->assertTrue(false, 'Exact duplication of key&val ' . $val . ' string');
                }
            }
        }
        //@var_dump($vals);exit();
    }
}
