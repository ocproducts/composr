<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2016

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    core
 */

/**
 * Hook class.
 */
class Hook_check_gd
{
    /**
     * Check various input var restrictions.
     *
     * @return array List of warnings
     */
    public function run()
    {
        $warning = array();
        if (!function_exists('imagecreatefromstring')) {
            $warning[] = do_lang_tempcode('NO_GD_ON_SERVER');
        }
        if (!function_exists('imagepng')) {
            $warning[] = do_lang_tempcode('NO_GD_ON_SERVER_PNG');
        }
        if (!function_exists('imagejpeg')) {
            $warning[] = do_lang_tempcode('NO_GD_ON_SERVER_JPEG');
        }
        return $warning;
    }
}
