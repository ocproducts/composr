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
}
