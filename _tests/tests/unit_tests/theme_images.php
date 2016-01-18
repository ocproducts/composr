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
class theme_images_test_set extends cms_test_case
{
    public function testDuplicateThemeImages()
    {
        require_code('files2');
        require_code('themes2');

        $themes = find_all_themes();
        foreach ($themes as $theme) {
            $dirs = array(
                get_custom_file_base() . '/themes/' . $theme . '/images_custom',
                get_custom_file_base() . '/themes/' . $theme . '/images_custom/' . fallback_lang(),
            );
            $files = array();
            foreach ($dirs as $dir) {
                $files = array_merge($files, get_directory_contents($dir));
            }

            $files2 = array();
            foreach ($files as $file) {
                $trimmed = preg_replace('#\.\w+$#', '', $file);
                $this->assertTrue(!isset($files2[$trimmed]), 'Duplicate theme image ' . $trimmed . ' in theme ' . $theme);
                $files2[$trimmed] = true;
            }
        }
    }
}
