<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    aggregate_types
 */

/**
 * Hook class.
 */
class Hook_admin_import_types_aggregate_types
{
    /**
     * Get a map of valid import types.
     *
     * @return array A map from codename to the language string that names them to the user
     */
    public function run()
    {
        if (!addon_installed('aggregate_types')) {
            return array();
        }

        return array(
            'aggregate_type_instances' => 'AGGREGATE_TYPE_INSTANCES',
        );
    }
}
