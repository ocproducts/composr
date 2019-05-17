<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    user_mappr
 */

/**
 * Hook class.
 */
class Hook_cns_cpf_filter_latitude
{
    /**
     * Find which special CPFs to enable.
     *
     * @return array A list of CPFs to enable
     */
    public function to_enable()
    {
        if (!addon_installed('user_mappr')) {
            return array();
        }

        $cpf = array();
        $cpf['latitude'] = true;
        $cpf['longitude'] = true;
        return $cpf;
    }
}
