<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */

/**
 * Composr API helper class.
 */
class CMSForumWrite
{
    /**
     * Mark a forum as read.
     *
     * @param  AUTO_LINK $forum_id Forum ID
     */
    public function mark_forum_as_read($forum_id)
    {
        cms_verify_parameters_phpdoc();

        if (is_guest()) {
            warn_exit(do_lang_tempcode('NOT_AS_GUEST'));
        }

        require_code('cns_forums_action2');
        cns_ping_forum_read_all($forum_id);
    }
}
