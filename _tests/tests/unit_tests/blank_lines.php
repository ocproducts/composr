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
class blank_lines_test_set extends cms_test_case
{
    public function testCorrectLineTermination()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        $file_types = array_flip(array(
            'config',
            'css',
            'csv',
            'hdf',
            'htaccess',
            'ini',
            'java',
            'js',
            'php',
            'sh',
            'tpl',
            'txt',
            'xml',
        ));

        require_code('files2');
        $contents = get_directory_contents(get_file_base());
        foreach ($contents as $path) {
            if (filesize($path) == 0) {
                continue;
            }

            if (should_ignore_file($path, IGNORE_CUSTOM_DIR_GROWN_CONTENTS)) {
                continue;
            }

            if (preg_match('#^(tracker|data/ace|data/ckeditor|sources_custom/composr_mobile_sdk/ios/ApnsPHP|sources_custom/sabredav|sources_custom/spout|sources_custom/photobucket|sources_custom/ILess|sources_custom/facebook|sources_custom/aws/Aws|docs/jsdoc)/#', $path) != 0) {
                continue;
            }

            $ext = get_file_extension($path);

            if (isset($file_types[$ext])) {
                $c = file_get_contents($path);

                $this->assertTrue(strpos($c, "\r") === false, 'Windows text format detected for ' . $path);

                $term_breaks = strlen($c) - strlen(rtrim($c, "\n"));

                $expected_breaks = 1;

                if (in_array($path, array(
                    'data_custom/latest_activity.txt',
                    'themes/admin/templates/MENU_BRANCH_dropdown.tpl',
                    'themes/default/templates/BREADCRUMB_SEPARATOR.tpl',
                    'themes/default/templates/CHATCODE_EDITOR_BUTTON.tpl',
                    'themes/default/templates/CHATCODE_EDITOR_MICRO_BUTTON.tpl',
                    'themes/default/templates/COMCODE_CURRENCY.tpl',
                    'themes/default/templates/COMCODE_EDITOR_BUTTON.tpl',
                    'themes/default/templates/COMCODE_EDITOR_MICRO_BUTTON.tpl',
                    'themes/default/templates/COMCODE_IMG.tpl',
                    'themes/default/templates/FRACTIONAL_EDIT.tpl',
                    'themes/default/templates/MENU_BRANCH_dropdown.tpl',
                    'themes/default/templates/MENU_BRANCH_popup.tpl',
                    'themes/default/templates/NOTIFICATION_PT_DESKTOP.tpl',
                    'themes/default/templates/NOTIFICATION_WEB_DESKTOP.tpl',
                    'themes/default/templates/PAGINATION_CONTINUE.tpl',
                    'themes/default/templates/PAGINATION_CONTINUE_FIRST.tpl',
                    'themes/default/templates/PAGINATION_CONTINUE_LAST.tpl',
                    'themes/default/templates/PAGINATION_NEXT.tpl',
                    'themes/default/templates/PAGINATION_NEXT_LINK.tpl',
                    'themes/default/templates/PAGINATION_PAGE_NUMBER.tpl',
                    'themes/default/templates/PAGINATION_PAGE_NUMBER_LINK.tpl',
                    'themes/default/templates/PAGINATION_PREVIOUS.tpl',
                    'themes/default/templates/PAGINATION_PREVIOUS_LINK.tpl',
                    'themes/default/templates/CURRENCY.tpl',
                    'themes/default/templates/CROP_TEXT_MOUSE_OVER_INLINE.tpl',
                    'themes/default/templates/CROP_TEXT_MOUSE_OVER.tpl',
                ))) {
                    $expected_breaks = 0;
                }

                $this->assertTrue($term_breaks == $expected_breaks, 'Wrong number of terminating line breaks (got ' . integer_format($term_breaks) . ', expects ' . integer_format($expected_breaks) . ') for ' . $path);
            }
        }
    }
}
