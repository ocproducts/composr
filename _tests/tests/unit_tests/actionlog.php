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
class actionlog_test_set extends cms_test_case
{
    public function testNoCrashes()
    {
        require_code('actionlog');

        $hooks = find_all_hooks('systems', 'actionlog'); // TODO: Change in v11
        foreach (array_keys($hooks) as $hook) {
            require_code('hooks/systems/actionlog/' . $hook);
            $ob = object_factory('Hook_actionlog_' . $hook);
            $handlers = $ob->get_handlers();
            foreach (array_keys($handlers) as $handler) {
                $actionlog_row = array(
                    'the_type' => $handler,
                    'param_a' => '12345',
                    'param_b' => '12345',
                );
                $ob->get_extended_actionlog_data($actionlog_row);
            }
        }
    }
}
