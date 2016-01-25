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
class should_ignore_file_test_set extends cms_test_case
{
    public function testShouldIgnoreFile()
    {
        require_code('files');
        $this->assertTrue(should_ignore_file('data_custom/unit_test_positive_ignore_sampler.cms', IGNORE_BUNDLED_VOLATILE));
        $this->assertTrue(!should_ignore_file('data_custom/unit_test_negative_ignore_sampler.cms', IGNORE_BUNDLED_VOLATILE));
        $this->assertTrue(!should_ignore_file('unit_test_positive_ignore_sampler.cms', IGNORE_BUNDLED_VOLATILE)); // should not fail in root, as ignore rule is scoped to data_custom
    }
}
