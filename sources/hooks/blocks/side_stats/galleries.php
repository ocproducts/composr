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
 * @package    galleries
 */

/**
 * Hook class.
 */
class Hook_stats_galleries
{
    /**
     * Show a stats section.
     *
     * @return Tempcode The result of execution
     */
    public function run()
    {
        if (!addon_installed('galleries')) {
            return new Tempcode();
        }

        require_lang('galleries');

        $bits = new Tempcode();

        if (get_option('galleries_show_stats_count_galleries') == '1') {
            $bits->attach(do_template('BLOCK_SIDE_STATS_SUBLINE', array('_GUID' => '979bcf993db7c01ced08d8f8a696fec0', 'KEY' => do_lang_tempcode('GALLERIES'), 'VALUE' => integer_format($GLOBALS['SITE_DB']->query_value_if_there('SELECT COUNT(*) FROM ' . get_table_prefix() . 'galleries WHERE name NOT LIKE \'' . db_encode_like('download\_%') . '\'')))));
        }
        if (get_option('galleries_show_stats_count_images') == '1') {
            $bits->attach(do_template('BLOCK_SIDE_STATS_SUBLINE', array('_GUID' => '0f06d6a5e1632bae0101a531912b1c29', 'KEY' => do_lang_tempcode('IMAGES'), 'VALUE' => integer_format($GLOBALS['SITE_DB']->query_select_value('images', 'COUNT(*)')))));
        }
        if (get_option('galleries_show_stats_count_videos') == '1') {
            $bits->attach(do_template('BLOCK_SIDE_STATS_SUBLINE', array('_GUID' => 'a9274594cde52028fc810b7b780e9942', 'KEY' => do_lang_tempcode('VIDEOS'), 'VALUE' => integer_format($GLOBALS['SITE_DB']->query_select_value('videos', 'COUNT(*)')))));
        }
        if ($bits->is_empty_shell()) {
            return new Tempcode();
        }
        $section = do_template('BLOCK_SIDE_STATS_SECTION', array('_GUID' => '128d3b49ad53927dff65252735dd2106', 'SECTION' => do_lang_tempcode('GALLERIES'), 'CONTENT' => $bits));

        return $section;
    }
}
