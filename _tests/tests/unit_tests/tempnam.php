<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2017

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
class tempnam_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        require_code('files2');
    }

    public function testUnlink()
    {
        $files = get_directory_contents(get_file_base());
        foreach ($files as $path) {
            if (should_ignore_file($path, IGNORE_CUSTOM_DIR_GROWN_CONTENTS)) {
                continue;
            }

            if (preg_match('#^sources/hooks/systems/tasks/#', $path) != 0) {
                continue;
            }

            if (substr($path, -4) == '.php') {
                $c = file_get_contents($path);

                $this->assertTrue((strpos($c, 'cms_tempnam(') === false) || (strpos($c, 'unlink(') !== false), 'Seems a temporary file is not cleaned up in ' . $path);
            }
        }
    }
}
