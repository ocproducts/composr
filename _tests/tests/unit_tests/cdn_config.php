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
class cdn_config_test_set extends cms_test_case
{
    public function testCDNConfig()
    {
        if (get_domain() != 'localhost') {
            $this->assertTrue(false, 'Test can only run on localhost');
        }

        require_code('images');

        set_option('cdn', 'localhost,127.0.0.1');

        $a = false;
        $b = false;

        $path = get_file_base() . '/themes/default/images';
        $dh = opendir($path);
        if ($dh !== false) {
            while (($file = readdir($dh)) !== false) {
                if (is_image($file, IMAGE_CRITERIA_WEBSAFE)) {
                    $ext = get_file_extension($file);
                    $url = find_theme_image(basename($file, '.' . $ext));
                    if (strpos($url, 'localhost') !== false) {
                        $a = true;
                    }
                    if (strpos($url, '127.0.0.1') !== false) {
                        $b = true;
                    }
                }
            }
            closedir($dh);
        }

        $this->assertTrue($a && $b);

        set_option('cdn', '');
    }
}
