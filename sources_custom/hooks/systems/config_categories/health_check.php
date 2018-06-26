<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    health_check
 */

/**
 * Hook class.
 */
class Hook_config_categories_health_check
{
    /**
     * Find if this config category is enabled.
     *
     * @return boolean Whether it is enabled
     */
    public function is_enabled()
    {
        return addon_installed('health_check');
    }
}
