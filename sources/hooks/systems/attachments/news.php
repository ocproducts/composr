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
 * @package    news
 */

/**
 * Hook class.
 */
class Hook_attachments_news
{
    /**
     * Run function for attachment hooks. They see if permission to an attachment of an ID relating to this content is present for the current member.
     *
     * @param  ID_TEXT $id The ID
     * @param  object $db The database connector to check on
     * @return boolean Whether there is permission
     */
    public function run($id, $db)
    {
        if (!addon_installed('news')) {
            return false;
        }

        if ($db->is_forum_db()) {
            return false;
        }

        if (addon_installed('content_privacy')) {
            require_code('content_privacy');
            if (!has_privacy_access('news', $id)) {
                return false;
            }
        }

        $cat_id = $GLOBALS['SITE_DB']->query_select_value_if_there('news', 'news_category', array('id' => intval($id)));
        if ($cat_id === null) {
            return false;
        }
        return has_category_access(get_member(), 'news', strval($cat_id));
    }
}
