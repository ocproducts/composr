<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    gallery_syndication
 */

/**
 * Hook class.
 */
class Hook_cron_gallery_syndication
{
    /**
     * Run function for Cron hooks. Searches for tasks to perform.
     */
    public function run()
    {
        $value = get_value('last_gallery_syndication');
        if ($value !== 'in_progress') {
            if (($value === null) || (intval($value) < time() - 60 * 60)) {
                set_value('last_gallery_syndication', 'in_progress');

                require_code('gallery_syndication');

                // Main sync of everything
                sync_video_syndication();

                set_value('last_gallery_syndication', strval(time()));
            }
        }
    }
}
