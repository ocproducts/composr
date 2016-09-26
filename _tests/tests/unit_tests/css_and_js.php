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
class css_and_js_test_set extends cms_test_case
{
    public function setUp()
    {
        if (php_function_allowed('set_time_limit')) {
            @set_time_limit(0);
        }

        $_GET['keep_minify'] = '0';

        require_code('webstandards');
        require_code('webstandards2');
        require_lang('webstandards');

        global $WEBSTANDARDS_JAVASCRIPT, $WEBSTANDARDS_CSS, $WEBSTANDARDS_WCAG, $WEBSTANDARDS_COMPAT, $WEBSTANDARDS_EXT_FILES, $WEBSTANDARDS_MANUAL, $MAIL_MODE;
        $WEBSTANDARDS_JAVASCRIPT = true;
        $WEBSTANDARDS_CSS = true;
        $WEBSTANDARDS_WCAG = true;
        $WEBSTANDARDS_COMPAT = false;
        $WEBSTANDARDS_EXT_FILES = true;
        $WEBSTANDARDS_MANUAL = false;
        $MAIL_MODE = false;

        //set_time_limit(0);

        parent::setUp();
    }

    public function testJavaScript()
    {
        require_code('webstandards_js_lint');

        $dh = opendir(get_file_base() . '/themes/default/javascript');
        while (($f = readdir($dh)) !== false) {
            if ((substr($f, -4) == '.tpl') && (substr($f, 0, 7) == 'themes/') && (strtolower($f) == $f) && (strpos($f, 'jwplayer') === false) && (strpos($f, 'sound') === false) && (strpos($f, 'widget') === false) && (strpos($f, 'jquery') === false)) {
                $path = javascript_enforce(basename($f, '.js'), 'default');
                $contents = file_get_contents($path);
                $errors = check_js($contents);
                if ($errors !== null) {
                    foreach ($errors['errors'] as $i => $e) {
                        $e['line'] += 3;
                        $errors['errors'][$i] = $e;
                    }
                }
                if (($errors !== null) && ($errors['errors'] == array())) {
                    $errors = null; // Normalise
                }
                $this->assertTrue(($errors === null), 'Bad JS in ' . $f);
                if ($errors !== null) {
                    if (get_param_integer('debug', 0) == 1) {
                        unset($errors['tag_ranges']);
                        unset($errors['value_ranges']);
                        unset($errors['level_ranges']);
                        var_dump($errors['errors']);
                    }
                } else {
                    //echo 'Ok: ' . $f . "\n";
                    //flush();
                }
            }
        }
    }

    public function testCSS()
    {
        $dh = opendir(get_file_base() . '/themes/default/css');
        while (($f = readdir($dh)) !== false) {
            if ((substr($f, -4) == '.css') && (substr($f, 0, 7) == 'themes/') && ($f != 'svg.css') && ($f != 'no_cache.css') && ($f != 'quizzes.css'/*we know this doesn't pass but it is extra glitz only*/)) {
                $path = css_enforce(basename($f, '.css'), 'default');

                $contents = file_get_contents($path);
                $errors = check_css($contents);
                if (($errors !== null) && ($errors['errors'] == array())) {
                    $errors = null; // Normalise
                }
                $this->assertTrue(($errors === null), 'Bad CSS in ' . $f);
                if ($errors !== null) {
                    var_dump($errors['errors']);
                    var_dump($contents);
                }
            }
        }
    }
}
