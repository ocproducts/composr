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
class css_file_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();

        require_code('themes2');
        require_code('images');
        require_code('files2');
    }

    public function testSelectors()
    {
        $themes = find_all_themes();
        foreach (array_keys($themes) as $theme) {
            $directories = array(
                 get_file_base() . '/themes/default/css_custom' => ($theme == 'default'),
                 get_file_base() . '/themes/default/css' => ($theme == 'default'),
                 get_file_base() . '/themes/default/templates_custom' => ($theme == 'default'),
                 get_file_base() . '/themes/default/templates' => ($theme == 'default'),
                 get_file_base() . '/themes/default/javascript_custom' => ($theme == 'default'),
                 get_file_base() . '/themes/default/javascript' => ($theme == 'default'),
            );
            if ($theme != 'default') {
                $directories = array_merge($directories, array(
                    get_file_base() . '/themes/' . $theme . '/css_custom' => true,
                    get_file_base() . '/themes/' . $theme . '/css' => true,
                    get_file_base() . '/themes/' . $theme . '/templates_custom' => true,
                    get_file_base() . '/themes/' . $theme . '/templates' => true,
                    get_file_base() . '/themes/' . $theme . '/javascript_custom' => true,
                    get_file_base() . '/themes/' . $theme . '/javascript' => true,
                ));
            }

            $non_css_contents = '';
            $selector_files = array();

            foreach ($directories as $dir => $to_use) {
                $dh = opendir($dir);
                while (($f = readdir($dh)) !== false) {
                    // Exceptions
                    $exceptions = array(
                        'columns.css',
                        'google_search.css',
                        'jquery_ui.css',
                        'mediaelementplayer.css',
                        'openid.css',
                        'skitter.css',
                        'svg.css',
                        'widget_color.css',
                        'widget_date.css',
                        'widget_select2.css',
                    );
                    if (in_array($f, $exceptions)) {
                        continue;
                    }

                    $contents = file_get_contents($dir . '/' . $f);

                    $is_css_file = (substr($f, -4) == '.css');

                    if ($is_css_file) {
                        if (!$to_use) {
                            continue;
                        }

                        // Let's do a few simple CSS checks, less than a proper validator would do
                        if (($is_css_file) && (strpos($contents, '{$,Parser hint: pure}') === false)) {
                            // Test comment/brace balancing
                            $a = substr_count($contents, '{');
                            $b = substr_count($contents, '}');
                            $this->assertTrue($a == $b, 'Mismatched braces in ' . $f . ' in ' . $theme . ', ' . integer_format($a) . ' vs ' . integer_format($b));
                            $a = substr_count($contents, '/*');
                            $b = substr_count($contents, '*/');
                            $this->assertTrue($a == $b, 'Mismatched comments in ' . $f . ' in ' . $theme . ', ' . integer_format($a) . ' vs ' . integer_format($b));

                            // Test selectors
                            $matches = array();
                            $num_matches = preg_match_all('#^\s*[^@\s].*[^%\s]\s*\{$#m', $contents, $matches); // @ is media rules, % is keyframe rules. Neither wanted.
                            for ($i = 0; $i < $num_matches; $i++) {
                                $matches2 = array();
                                $num_matches2 = preg_match_all('#[\w\-\_]+#', preg_replace('#"[^"]*"#', '', preg_replace('#[:@][\w\-\_]+#', '', $matches[0][$i])), $matches2);
                                for ($j = 0; $j < $num_matches2; $j++) {
                                    if (!isset($selector_files[$f])) {
                                        $selector_files[$f] = array();
                                    }
                                    $selector_files[$f][$matches2[0][$j]] = true;
                                }
                            }
                        }
                    } else {
                        $non_css_contents .= $contents;
                    }
                }
                closedir($dh);
            }

            foreach ($selector_files as $file => $selectors) {
                ksort($selectors);
                foreach (array_keys($selectors) as $selector) {
                    // Exceptions
                    if (preg_match('#^(page|zone)_running_#', $selector) != 0) {
                        continue;
                    }
                    if (preg_match('#^(menu__)#', $selector) != 0) {
                        continue;
                    }

                    $this->assertTrue(strpos($non_css_contents, $selector) !== false, 'Possibly unused CSS selector for theme ' . $theme . ', ' . $file . ': ' . $selector);
                }
            }
        }
    }
}
