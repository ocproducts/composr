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
class template_xss_test_set extends cms_test_case
{
    public function setUp()
    {
        parent::setUp();
    }

    public function testQuoteBreakout() // See http://css.dzone.com/articles/xss-still-tricky
    {
        $templates = array();
        $paths = array(
            get_file_base() . '/themes/default/templates',
            get_file_base() . '/themes/default/templates_custom',
        );
        foreach ($paths as $path) {
            $dh = opendir($path);
            while (($f = readdir($dh)) !== false) {
                if (strtolower(substr($f, -4)) == '.tpl') {
                    $file = file_get_contents($path . '/' . $f);
                    $file_orig = $file;

                    $matches = array();

                    // Strip parameters inside symbols, language strings and Tempcode portions
                    do {
                        $num_matches = preg_match('#\{[\$\!\+]#', $file, $matches, PREG_OFFSET_CAPTURE);
                        if ($num_matches != 0) {
                            $posa = $matches[0][1];
                            $pos = $posa;
                            $balance = 0;
                            do {
                                if (!isset($file[$pos])) {
                                    break;
                                }
                                $char = $file[$pos];
                                if ($char == '{') {
                                    $balance++;
                                } elseif ($char == '}') {
                                    $balance--;
                                }
                                $pos++;
                            } while ($balance != 0);
                            $file = str_replace(substr($file, $posa, $pos - $posa), '', $file);
                        }
                    } while ($num_matches > 0);

                    // Search
                    $num_matches = preg_match_all('#\{(\w+)([*=;\#~^\'&.@+-]*)\}#U', $file, $matches);
                    $params_found = array();
                    for ($i = 0; $i < $num_matches; $i++) {
                        $match = $matches[0][$i];
                        $params_found[$match] = $matches;
                    }
                    foreach ($params_found as $match => $matches) {
                        $matches2 = array();
                        if (preg_match('#<script[^<>]*>(?:(?!</script>).)*(?<!\\\\)' . preg_quote($match, '#') . '(?:(?!</script>)).*</script>#Us', $file, $matches2) != 0) {
                            $this->assertTrue(false, 'Unsafe embedded JavaScript parameter (' . $match . ') in ' . $f);

                            if (get_param_integer('save', 0) == 1) {
                                $file_orig = str_replace($match, '{' . $matches[1][$i] . $matches[2][$i] . '/' . '}', $file_orig);
                                file_put_contents($path . '/' . $f, $file_orig);
                            }
                        }
                    }
                }
            }
        }
    }

    public function tearDown()
    {
        parent::tearDown();
    }
}
