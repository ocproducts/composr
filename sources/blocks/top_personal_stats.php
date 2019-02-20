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
 * Block class.
 */
class Block_top_personal_stats
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;
        $info['parameters'] = array();
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters.
     * @return Tempcode The result of execution.
     */
    public function run($map)
    {
        if (is_guest()) {
            return new Tempcode();
        }

        require_css('personal_stats');
        require_javascript('notification_poller');
        require_javascript('sound');

        $member_id = get_member();

        $avatar_url = '';
        if (!has_no_forum()) {
            $avatar_url = $GLOBALS['FORUM_DRIVER']->get_member_avatar_url($member_id);
        }

        $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id);

        require_code('global4');
        list($links, $links_ecommerce, $details, $num_unread_pps) = member_personal_links_and_details($member_id);

        return do_template('BLOCK_TOP_PERSONAL_STATS', array('_GUID' => '6460943f1f0944fb6e8fe252dfa1b853', 'NUM_UNREAD_PTS' => strval($num_unread_pps), 'AVATAR_URL' => $avatar_url, 'MEMBER_ID' => strval($member_id), 'USERNAME' => $username, 'LINKS' => $links, 'LINKS_ECOMMERCE' => $links_ecommerce, 'DETAILS' => $details));
    }
}
