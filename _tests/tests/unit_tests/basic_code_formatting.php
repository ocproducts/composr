<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

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
class basic_code_formatting_test_set extends cms_test_case
{
    protected $files;

    public function setUp()
    {
        parent::setUp();

        require_code('files2');

        $this->files = get_directory_contents(get_file_base(), '', IGNORE_CUSTOM_DIR_GROWN_CONTENTS | IGNORE_BUNDLED_VOLATILE, true, true, array('php'));
        $this->files[] = 'install.php';
    }

    // TODO: #3467 Make sure no core text files contain non-ASCII characters; with some exceptions like maintenance_status.csv

    public function testNoBomMarkers()
    {
        $boms = array(
            'utf-32' => chr(hexdec('FF')) . chr(hexdec('FE')) . chr(hexdec('00')) . chr(hexdec('00')),
            'utf-16' => chr(hexdec('FF')) . chr(hexdec('FE')),
            'utf-8' => chr(hexdec('EF')) . chr(hexdec('BB')) . chr(hexdec('BF')) ,
            'GB-18030' => chr(hexdec('84')) . chr(hexdec('31')) . chr(hexdec('95')) . chr(hexdec('33')),
        );

        foreach ($this->files as $path) {
            $myfile = fopen(get_file_base() . '/' . $path, 'rb');
            $magic_data = fread($myfile, 4);
            fclose($myfile);

            foreach ($boms as $charset => $bom) {
                $this->assertTrue(substr($magic_data, strlen($bom)) != $bom, $charset . ' byte-order mark found in ' . $path . ': we do not want them');
            }
        }
    }

    public function testTabbing()
    {
        $file_types_spaces = array(
            'js',
            'php',
        );

        $file_types_tabs = array(
            'css',
            'tpl',
            'xml',
            'sh',
            'txt',
        );

        $exceptions = array(
            '_tests/tests/unit_tests/tempcode.php',
            '_tests/tests/unit_tests/xss.php',
            'data_custom/sitemaps/news_sitemap.xml',
            'manifest.xml',
            'mobiquo/lib/xmlrpc.php',
            'mobiquo/lib/xmlrpcs.php',
            'mobiquo/smartbanner/appbanner.css',
            'mobiquo/smartbanner/appbanner.js',
            'mobiquo/tapatalkdetect.js',
            'parameters.xml',
            'site/pages/comcode/EN/userguide_comcode.txt',
            'sources_custom/twitter.php',
            'themes/default/css/widget_color.css',
            'themes/default/css/widget_select2.css',
            'themes/default/css_custom/mediaelementplayer.css',
            'themes/default/javascript/jquery.js',
            'themes/default/javascript/jquery_ui.js',
            'themes/default/javascript/plupload.js',
            'themes/default/javascript/select2.js',
            'themes/default/javascript/theme_colours.js',
            'themes/default/javascript/widget_date.js',
            'themes/default/javascript_custom/columns.js',
            'themes/default/javascript_custom/jquery_flip.js',
            'themes/default/javascript_custom/mediaelement-and-player.js',
            'themes/default/javascript_custom/skitter.js',
            'themes/default/javascript_custom/sortable_tables.js',
            'themes/default/javascript_custom/unslider.js',
        );

        foreach ($this->files as $path) {
            if (in_array($path, $exceptions)) {
                continue;
            }

            if (preg_match('#^(data_custom/sitemap|sources_custom/sabredav|docs/pages/comcode_custom/EN|data_custom/modules/admin_stats|data/polyfills|aps|_tests/codechecker/netbeans|data/ace|data/ckeditor|sources_custom/composr_mobile_sdk|tracker|sources_custom/ILess|sources_custom/spout|sources_custom/getid3|sources_custom/programe|_tests/simpletest)/#', $path) != 0) {
                continue;
            }

            $ext = get_file_extension(get_file_base() . '/' . $path);

            if ((in_array($ext, $file_types_spaces)) || (in_array($ext, $file_types_tabs))) {
                $c = file_get_contents($path);

                $contains_tabs = strpos($c, "\t");
                $contains_spaced_tabs = strpos($c, '    ');

                if (in_array($ext, $file_types_spaces)) {
                    $this->assertTrue(!$contains_tabs, 'Tabs are in ' . $path);
                } elseif (in_array($ext, $file_types_tabs)) {
                    $this->assertTrue(!$contains_spaced_tabs, 'Spaced tabs are in ' . $path);
                }
            }
        }
    }

    public function testCorrectLineTerminationAndLineFormat()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(300);
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
            'svg',
        ));

        foreach ($this->files as $path) {
            if (filesize($path) == 0) {
                continue;
            }

            if (preg_match('#^(tracker|data/ace|data/ckeditor|sources_custom/composr_mobile_sdk/ios/ApnsPHP|sources_custom/sabredav|sources_custom/spout|sources_custom/photobucket|sources_custom/ILess|sources_custom/facebook|sources_custom/aws/Aws|docs/jsdoc)/#', $path) != 0) {
                continue;
            }

            $ext = get_file_extension(get_file_base() . '/' . $path);

            if (isset($file_types[$ext])) {
                $c = file_get_contents($path);

                $this->assertTrue(strpos($c, "\r") === false, 'Windows text format detected for ' . $path);

                if ($ext == 'svg') {
                    continue;
                }

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
                    'themes/default/templates/CNS_USER_MEMBER.tpl',
                ))) {
                    $expected_breaks = 0;
                }

                $this->assertTrue($term_breaks == $expected_breaks, 'Wrong number of terminating line breaks (got ' . integer_format($term_breaks) . ', expects ' . integer_format($expected_breaks) . ') for ' . $path);
            }
        }
    }
}
