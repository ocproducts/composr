<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * Module page class.
 */
class Mx_chat extends Module_chat
{
    /**
     * Find entry-points available within this module.
     *
     * @param  boolean $check_perms Whether to check permissions.
     * @param  ?MEMBER $member_id The member to check permissions as (null: current user).
     * @param  boolean $support_crosslinks Whether to allow cross links to other modules (identifiable via a full-page-link rather than a screen-name).
     * @param  boolean $be_deferential Whether to avoid any entry-point (or even return NULL to disable the page in the Sitemap) if we know another module, or page_group, is going to link to that entry-point. Note that "!" and "browse" entry points are automatically merged with container page nodes (likely called by page-groupings) as appropriate.
     * @return ?array A map of entry points (screen-name=>language-code/string or screen-name=>[language-code/string, icon-theme-image]) (null: disabled).
     */
    public function get_entry_points($check_perms = true, $member_id = null, $support_crosslinks = true, $be_deferential = false)
    {
        return array(
            'browse' => array('CHAT_LOBBY', 'menu/social/chat/chat'),
        );
    }

    /**
     * Execute the module.
     *
     * @return Tempcode The result of execution.
     */
    public function run()
    {
        i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

        if (!has_js()) {
            warn_exit(do_lang_tempcode('MSG_JS_NEEDED'));
        }

        // What action are we going to do?
        $type = get_param_string('type', 'browse');

        if (function_exists('set_time_limit')) {
            @set_time_limit(200);
        }

        require_javascript('xmpp_prototype');
        //require_javascript('xmpp_extjs2');
        require_javascript('xmpp_dom-all');
        require_javascript('xmpp_crypto');
        require_javascript('xmpp_xmpp4js');

        require_javascript('ajax');
        require_javascript('chat');
        require_javascript('sound');
        require_javascript('editing');
        require_javascript('checking');

        require_lang('comcode');
        require_code('chat');
        require_css('chat');

        if ($type == 'room') {
            return $this->chat_room();
        }
        if ($type == 'options') {
            return $this->chat_options();
        }
        if ($type == 'private') {
            return $this->chat_private();
        }
        if ($type == '_private') {
            return $this->_chat_private();
        }
        if ($type == 'download_logs') {
            return $this->chat_download_logs();
        }
        if ($type == '_download_logs') {
            return $this->_chat_download_logs();
        }
        if ($type == 'browse') {
            return $this->chat_lobby();
        }
        if ($type == 'blocking_interface') {
            return $this->blocking_interface();
        }
        if ($type == 'blocking_set') {
            return $this->blocking_set();
        }
        if ($type == 'blocking_add') {
            return $this->blocking_add();
        }
        if ($type == 'blocking_remove') {
            return $this->blocking_remove();
        }
        if ($type == 'friend_add') {
            return $this->friend_add();
        }
        if ($type == 'friend_remove') {
            return $this->friend_remove();
        }
        if ($type == 'set_effects') {
            return $this->set_effects();
        }
        if ($type == '_set_effects') {
            return $this->_set_effects();
        }

        return new Tempcode();
    }

    /**
     * The UI to choose a chat room.
     *
     * @return Tempcode The UI
     */
    public function chat_lobby()
    {
        require_javascript('ajax_people_lists');

        // Starting an IM? The IM will popup by AJAX once the page loads, because it's in the system now
        $enter_im = get_param_integer('enter_im', null);
        if (!is_null($enter_im)) {
            require_code('chat2');
            friend_add(get_member(), $enter_im);

            $you = $GLOBALS['FORUM_DRIVER']->get_username(get_member());
            $them = $GLOBALS['FORUM_DRIVER']->get_username($enter_im);
            attach_message('Instant messaging has been disabled on this site, but you can arrange with members to connect via XMPP software (create a Private Topic, asking them to use XMPP, and tell them your username is ' . escape_html($you) . ' &ndash; we have auto-added ' . escape_html($them) . ' as an contact in your XMPP software).', 'warn');
        }

        // Rooms
        $room_url = build_url(array('page' => '_SELF', 'type' => 'room', 'id' => 'room_id'), '_SELF');
        $fields = '
            <ul id="rooms"></ul>
        ';

        $seteffectslink = hyperlink(build_url(array('page' => '_SELF', 'type' => 'set_effects'/*,'redirect'=>get_self_url(true,true)*/), '_SELF'), do_lang_tempcode('CHAT_SET_EFFECTS'), true, false);

        $friends = array();
        $friend_rows = $GLOBALS['SITE_DB']->query_select('chat_friends', array('*'), array('member_likes' => get_member()));
        foreach ($friend_rows as $br) {
            $u = $GLOBALS['FORUM_DRIVER']->get_username($br['member_liked']);
            if (!is_null($u)) {
                $friends[] = array('USERNAME' => $u);
            }
        }

        $password_hash = $GLOBALS['FORUM_DRIVER']->get_member_row_field(get_member(), 'm_pass_hash_salted');
        return do_template('CHAT_LOBBY_SCREEN', array(
            '_GUID' => 'fb96937da8ac1796b80f1f618ba9a01e',
            'CHATROOM_URL' => $room_url,
            'FRIENDS' => $friends,
            'PASSWORD_HASH' => $password_hash,
            'CHAT_SOUND' => get_chat_sound_tpl(),
            'TITLE' => $this->title,
            'CHATROOMS' => $fields,
            'SETEFFECTS_LINK' => $seteffectslink,
        ));
    }

    /**
     * The UI for a chat room.
     *
     * @return Tempcode The UI
     */
    public function chat_room()
    {
        require_javascript('posting');

        $prefs = @$_COOKIE['software_chat_prefs'];
        $prefs = @explode(';', $prefs);
        $room_id = get_param_string('id');

        $posting_name = do_lang_tempcode('SEND_MESSAGE');

        $cs_post_url = build_url(array('page' => '_SELF', 'type' => 'options', 'id' => $room_id), '_SELF');

        $yourname = $GLOBALS['FORUM_DRIVER']->get_username(get_member());

        $debug = (get_param_integer('debug', 0) == 1) ? 'block' : 'none';

        $seteffectslink = hyperlink(build_url(array('page' => '_SELF', 'type' => 'set_effects'/*,'redirect'=>get_self_url(true,true)*/), '_SELF'), do_lang_tempcode('CHAT_SET_EFFECTS'), true, false);
        $logslink = hyperlink(get_base_url() . '/data_custom/jabber-logs/' . strtolower($room_id) . '@conference.' . get_domain(), 'Chat logs', true, true);

        $links = array(
            $seteffectslink,
            $logslink,
        );

        $messages_php = find_script('messages');
        $password_hash = $GLOBALS['FORUM_DRIVER']->get_member_row_field(get_member(), 'm_pass_hash_salted');
        return do_template('CHAT_ROOM_SCREEN', array(
            '_GUID' => '0b4adbe09e9cf38b2104b12b4381b256',
            'MESSAGES_PHP' => $messages_php,
            'PASSWORD_HASH' => $password_hash,
            'CHAT_SOUND' => get_chat_sound_tpl(),
            'CHATROOM_ID' => $room_id,
            'DEBUG' => $debug,
            'OPTIONS_URL' => $cs_post_url,
            'CHATROOM_NAME' => '',
            'YOUR_NAME' => $yourname,
            'SUBMIT_VALUE' => $posting_name,
            'INTRODUCTION' => '',
            'TITLE' => $this->title,
            'LINKS' => $links,
        ));
    }

    /**
     * Save the user's options into a cookie.
     *
     * @return Tempcode The UI
     */
    public function chat_options()
    {
        $value = preg_replace('#^\##', '', post_param_string('text_colour', get_option('chat_default_post_colour'))) . ';' . post_param_string('font_name', get_option('chat_default_post_font')) . ';';
        require_code('users_active_actions');
        cms_setcookie('software_chat_prefs', $value);

        $url = build_url(array('page' => '_SELF', 'type' => 'room', 'id' => get_param_string('id'), 'no_reenter_message' => 1), '_SELF');
        return redirect_screen($this->title, $url, do_lang_tempcode('SUCCESS'));
    }
}
