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
class config_test_set extends cms_test_case
{
    public function testListConfigConsistency()
    {
        $hooks = find_all_hooks('systems', 'config');
        foreach (array_keys($hooks) as $hook) {
            require_code('hooks/systems/config/' . $hook);
            $ob = object_factory('Hook_config_' . $hook);
            $details = $ob->get_details();
            if ($details['type'] == 'list') {
                $list = explode('|', $details['list_options']);
                $this->assertTrue(in_array($ob->get_default(), $list));
            }
        }
    }

    public function testReasonablePerCategory()
    {
        $categories = array();

        $hooks = find_all_hooks('systems', 'config');
        foreach (array_keys($hooks) as $hook) {
            require_code('hooks/systems/config/' . filter_naughty($hook));
            $ob = object_factory('Hook_config_' . $hook);
            $details = $ob->get_details();
            if (!isset($categories[$details['category']])) {
                $categories[$details['category']] = 0;
            }
            $categories[$details['category']]++;
        }

        foreach ($categories as $category => $count) {
            $this->assertTrue($count > 3, $category . ' only has ' . integer_format($count));
            $this->assertTrue($count < 160, $category . ' has as much as ' . integer_format($count)); // max_input_vars would not like a high number
        }
    }
}
