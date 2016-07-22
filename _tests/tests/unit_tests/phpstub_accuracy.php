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
class phpstub_accuracy_test_set extends cms_test_case
{
    public function testFunctionsNeeded()
    {
        $c = file_get_contents(get_file_base() . '/sources_custom/phpstub.php');
        $matches = array();
        $num_matches = preg_match_all('#^function (\w+)\(#m', $c, $matches);
        $declared_functions = array();
        for ($i = 0; $i < $num_matches; $i++) {
            $function = $matches[1][$i];
            $declared_functions[] = $function;
        }
        sort($declared_functions);

        $c = file_get_contents(get_file_base() . '/sources/hooks/systems/checks/functions_needed.php');
        $num_matches = preg_match_all('#<<<END(.*)END;#Us', $c, $matches);
        $c = '';
        for ($i = 0; $i < $num_matches; $i++) {
            $c .= $matches[1][$i] . "\n";
        }
        $c = str_replace("\n", ' ', $c);
        $c = trim(preg_replace('#\s+#', ' ', $c));
        $required_functions = explode(' ', $c);
        sort($required_functions);

        foreach ($declared_functions as $function) {
            $this->assertTrue(in_array($function, $required_functions), 'Missing from functions_needed.php? ' . $function);
        }

        foreach ($required_functions as $function) {
            $this->assertTrue(in_array($function, $declared_functions), 'Missing from phpstub.php? ' . $function);
        }

        if (get_param_integer('dev_check', 0) == 1) { // This extra switch let's us automatically find new functions in PHP we aren't coding for
            $will_never_define = array(
            );

            $defined = get_defined_functions();
            foreach ($defined['internal'] as $function) {
                if (!in_array($function, $will_never_define)) {
                    $this->assertTrue(in_array($function, $declared_functions), 'Should be defined? ' . $function);
                }
            }
        }
    }
}
