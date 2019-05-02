<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

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
class glossary_test_set extends cms_test_case
{
    public function testConsistentSize()
    {
        $c = file_get_contents(get_file_base() . '/docs/pages/comcode_custom/EN/sup_glossary.txt');
        $cnt = substr_count($c, '<tr');
        $this->assertTrue($cnt <= 100, 'Glossary should be restricted to 100 terms, but has ' . integer_format($cnt - 1) . '. Merge some terms if you have had to add new ones (e.g. put less important associated terms under a major term) and/or remove some.');

        // Next in line to remove - Web 2.0, PageRank
    }
}
