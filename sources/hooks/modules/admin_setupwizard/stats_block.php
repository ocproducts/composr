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
 * @package    stats_block
 */

/**
 * Hook class.
 */
class Hook_sw_stats_block
{
    /**
     * Run function for blocks in the setup wizard.
     *
     * @return array A pair: Main blocks and Side blocks (each is a map of block names to display types)
     */
    public function get_blocks()
    {
        if (!addon_installed('stats_block')) {
            return array();
        }

        return array(array(), array('side_stats' => array('PANEL_LEFT', 'PANEL_RIGHT')));
    }
}
