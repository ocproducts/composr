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
class glossary_test_set extends cms_test_case
{
    public function testConsistentSize()
    {
        $c = file_get_contents(get_file_base() . '/docs/pages/comcode_custom/EN/sup_glossary.txt');
        $cnt = substr_count($c, '<tr');
        $this->assertTrue($cnt == 100 + 1, 'Should be 100 terms, has ' . integer_format($cnt) . 'terms');
    }
}
