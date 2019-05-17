<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    iotds
 */

/**
 * Hook class.
 */
class Hook_admin_import_types_iotds
{
    /**
     * Get a map of valid import types.
     *
     * @return array A map from codename to the language string that names them to the user
     */
    public function run()
    {
        if (!addon_installed('iotds')) {
            return array();
        }

        return array(
            'iotds' => 'IOTD_ARCHIVE',
        );
    }
}
