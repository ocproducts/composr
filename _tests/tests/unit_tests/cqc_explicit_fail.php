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
class cqc_explicit_fail_test_set extends cms_test_case
{
    public function testDatabase()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }
        $path = get_file_base() . '/temp/temp.php';
        file_put_contents($path, '<?php echo foo().1+\'\';');
        fix_permissions($path);
        sync_file($path);
        $result = http_get_contents(get_base_url() . '/_tests/codechecker/code_quality.php?subdir=temp&api=1', array('timeout' => 10000.0));
        unlink($path);

        $this->assertTrue(strpos($result, 'Could not find function') !== false, 'Should have an error but does not (' . $result . ')');
    }
}
