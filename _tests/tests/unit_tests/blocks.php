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
class blocks_test_set extends cms_test_case
{
    public function testBlocksRender()
    {
        require_code('zones2');
        $blocks = find_all_blocks();
        foreach ($blocks as $block => $type) {
            if (strpos($type, '_custom') !== false) {
                continue;
            }

            $test = do_block($block, array());
            $this->assertTrue(is_object($test), 'Failed block ' . $block);
        }
    }
}
