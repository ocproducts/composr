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
class external_code_considerations_test_set extends cms_test_case
{
    public function testConsistency()
    {
        $a = file_get_contents(get_file_base() . '/.editorconfig');
        $matches = array();
        $does_match = (preg_match('#git checkout -- (.*)\(ends\)#s', $a, $matches) != 0);
        if ($does_match) {
            $a = str_replace("\n#", '', str_replace("\\\n#", '', $matches[1]));
            $parts = preg_split('#\s+#', trim($a));

            $b = file_get_contents(get_file_base() . '/line_count.sh');
            foreach ($parts as $part) {
                $find = '\|\./' . preg_quote($part, '#');
                $in = (strpos($b, $find) !== false);
                $this->assertTrue($in, 'Should be skipped in line_count.sh: ' . $part);
            }
        }
    }
}
