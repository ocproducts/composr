<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.


 NOTE TO PROGRAMMERS:
   Do not edit this file. If you need to make changes, save your changed file to the appropriate *_custom folder
   **** If you ignore this advice, then your website upgrades (e.g. for bug fixes) will likely kill your changes ****

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    chat
 */

/**
 * Outputs the shoutbox iframe.
 *
 * @param  boolean $ret Whether to get the output instead of outputting it directly
 * @param  ?AUTO_LINK $room_id Chatroom ID (null: read from environment)
 * @param  ?integer $num_messages The maximum number of messages to show (null: read from environment)
 * @return ?object Output (null: outputted it already)
 */
function shoutbox_script($ret = false, $room_id = null, $num_messages = null)
{
    if (is_null($room_id)) {
        $room_id = get_param_integer('room_id');
    }
    if (is_null($num_messages)) {
        $num_messages = get_param_integer('num_messages', 5);
    }
    $zone = get_param_string('zone', get_module_zone('chat'));

    require_lang('chat');
    require_code('chat');
    require_css('chat');

    if (is_null($room_id)) {
        $room_id = $GLOBALS['SITE_DB']->query_select_value_if_there('chat_rooms', 'MIN(id)', array('is_im' => 0/*, 'room_language' => user_lang()*/));
        if (is_null($room_id)) {
            warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'chat'));
        }
    }

    $room_check = $GLOBALS['SITE_DB']->query_select('chat_rooms', array('*'), array('id' => $room_id), '', 1);
    if (!array_key_exists(0, $room_check)) {
        warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'chat'));
    }
    if (!check_chatroom_access($room_check[0])) {
        warn_exit(do_lang_tempcode('ACCESS_DENIED__CHATROOM_UNAUTHORISED', escape_html($GLOBALS['FORUM_DRIVER']->get_username(get_member()))));
    }

    // Did a message get sent last time?
    $shoutbox_message = post_param_string('shoutbox_message', '');
    if ($shoutbox_message != '') {
        if (!chat_post_message($room_id, $shoutbox_message, get_option('chat_default_post_font'), get_option('chat_default_post_colour'), 15)) {
            // Error. But actually we'll get it from below
        }
    }

    $messages = chat_get_room_content($room_id, $room_check, $num_messages * 3, false, false, null, null, -1, $zone, null, true, $shoutbox_message != '');
    $_tpl = array();
    foreach ($messages as $_message) {
        $evaluated = $_message['the_message']->evaluate();

        // We are only interested in private-message system messages and flood-control system messages, no other kinds of system message
        if (($_message['system_message'] == 1) && (strpos($evaluated, '[private') === false) && (preg_match('#' . str_replace('\{1\}', '\d+', preg_quote(do_lang('FLOOD_CONTROL_BLOCKED'))) . '#', $evaluated) == 0)) {
            continue;
        }

        if ((strpos($evaluated, '[private') === false) || (($shoutbox_message != '') && (strpos($evaluated, '[private="' . $GLOBALS['FORUM_DRIVER']->get_username(get_member()) . '"]') !== false))) {
            $member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username($_message['username']);
            $member = $GLOBALS['FORUM_DRIVER']->member_profile_hyperlink($member_id, true, $_message['username']);
            $_tpl[] = do_template('BLOCK_SIDE_SHOUTBOX_MESSAGE', array('_GUID' => 'a6f86aa48af7de7ec78423864c82c626', 'USER' => $member, 'MESSAGE' => $_message['the_message'], 'TIME_RAW' => strval($_message['date_and_time']), 'TIME' => $_message['date_and_time_nice']));
        }
    }

    $tpl = new Tempcode();
    while (count($_tpl) > $num_messages) {
        array_shift($_tpl);
    }
    foreach ($_tpl as $t) {
        $tpl->attach($t);
    }

    if (running_script('shoutbox')) {
        $keep = symbol_tempcode('KEEP');
        $_url = find_script('shoutbox') . '?room_id=' . strval($room_id) . '&num_messages=' . strval($num_messages) . $keep->evaluate();
        if (get_param_string('utheme', '') != '') {
            $_url .= '&utheme=' . get_param_string('utheme');
        }
        $url = make_string_tempcode($_url);
    } else {
        $url = get_self_url(false, (array_keys($_POST) != array('shoutbox_message')), array('room_id' => $room_id));
    }
    $tpl = do_template('BLOCK_SIDE_SHOUTBOX', array('_GUID' => '080880eb9ebdb7fcdca1ebdae6b1b9aa', 'MESSAGES' => $tpl, 'URL' => $url));

    if ($ret) {
        return $tpl;
    }

    $keep = symbol_tempcode('KEEP');
    $echo = do_template('STANDALONE_HTML_WRAP', array('_GUID' => 'aacac778b145bfe7b063317fbcae7fde', 'FRAME' => true, 'TARGET' => '_top', 'TITLE' => do_lang_tempcode('SHOUTBOX'), 'CONTENT' => $tpl));
    $echo->evaluate_echo();
    return null;
}
