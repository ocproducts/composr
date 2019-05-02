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
 * @package    cns_forum
 */

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__cns_forum_email_integration()
{
    require_lang('cns');
    require_code('cns_forums2');
}

/**
 * Forum e-mail integration class.
 *
 * @package        cns_forum
 */
class ForumEmailIntegration extends EmailIntegration
{
    protected $forum_id = null, $forum_row = null;

    /**
     * Set what forum we're currently dealing with.
     *
     * @param  AUTO_LINK $forum_id Forum ID
     * @param  ?array $forum_row Forum row (null: load up from database)
     */
    public function set_forum($forum_id, $forum_row = null)
    {
        $this->forum_id = $forum_id;

        if ($forum_row === null) {
            $forum_rows = $GLOBALS['FORUM_DB']->query_select('f_forums', array('*'), array('id' => $forum_id), '', 1);
            if (!array_key_exists(0, $forum_rows)) {
                warn_exit(do_lang_tempcode('MISSING_RESOURCE', 'forum'));
            }
            $this->forum_row = $forum_rows[0];
        } else {
            $this->forum_row = $forum_row;
        }
    }

    /**
     * Send out an e-mail message for a forum post.
     *
     * @param  AUTO_LINK $topic_id The ID of the topic that got posted in
     * @param  AUTO_LINK $post_id The ID of the post
     * @param  AUTO_LINK $forum_id The forum that the topic is in
     * @param  mixed $post_url URL to the post (URLPATH or Tempcode)
     * @param  string $topic_title Topic title
     * @param  string $post Post text
     * @param  MEMBER $to_member_id Member ID of recipient
     * @param  string $to_displayname Display name of recipient
     * @param  EMAIL $to_email E-mail address of recipient
     * @param  string $from_displayname Display name of poster
     * @param  boolean $is_starter Whether this is a new topic, just created by the poster
     */
    public function outgoing_message($topic_id, $post_id, $forum_id, $post_url, $topic_title, $post, $to_member_id, $to_displayname, $to_email, $from_displayname, $is_starter = false)
    {
        $this->set_forum($forum_id);

        $extended_subject = do_lang('MAILING_LIST_SIMPLE_SUBJECT_' . ($is_starter ? 'new' : 'reply'), $topic_title, get_site_name(), array($from_displayname), get_lang($to_member_id));

        $extended_message = do_lang('MAILING_LIST_SIMPLE_MAIL_' . ($is_starter ? 'new' : 'reply'), $topic_title, $post, array($post_url, get_site_name(), $from_displayname), get_lang($to_member_id));

        $reply_email = $this->forum_row['f_mail_email_address'];

        $this->_outgoing_message($extended_subject, $extended_message, $to_member_id, $to_displayname, $to_email, $from_displayname, $reply_email);
    }

    /**
     * Find the e-mail address to send from (From header).
     *
     * @return EMAIL E-mail address
     */
    protected function get_sender_email()
    {
        foreach (array('website_email', null, 'staff_address') as $address) {
            if (($address === null) && ($this->forum_row['f_mail_email_address'] != '')) {
                return $this->forum_row['f_mail_email_address'];
            }

            if (get_option($address) != '') {
                return get_option($address);
            }
        }

        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        return '';
    }

    /**
     * Find the e-mail address for system e-mails (Reply-To header).
     *
     * @return EMAIL E-mail address
     */
    protected function get_system_email()
    {
        foreach (array(null, 'staff_address', 'website_email') as $address) {
            if (($address === null) && ($this->forum_row['f_mail_email_address'] != '')) {
                return $this->forum_row['f_mail_email_address'];
            }

            if (get_option($address) != '') {
                return get_option($address);
            }
        }

        warn_exit(do_lang_tempcode('INTERNAL_ERROR'));
        return '';
    }

    /**
     * Scan for new e-mails in the support inbox.
     */
    public function incoming_scan()
    {
        $test = cns_has_mailing_list_style();
        if ($test[0] == 0) {
            $this->log_message('No mailing-list forums to deal with');

            return; // Possibly due to not being fully configured yet
        }

        $this->log_message('Starting overall incoming e-mail scan process (forums)');

        $sql = 'SELECT * FROM ' . $GLOBALS['FORUM_DB']->get_table_prefix() . 'f_forums';
        $sql_sup = ' WHERE ' . db_string_not_equal_to('f_mail_username', '') . ' AND ' . db_string_not_equal_to('f_mail_email_address', '');
        $rows = $GLOBALS['FORUM_DB']->query($sql . $sql_sup);
        foreach ($rows as $row) {
            $this->set_forum($row['id'], $row);

            $type = $row['f_mail_server_type'];
            $host = $row['f_mail_server_host'];
            $port = ($row['f_mail_server_port'] == '') ? null : intval($row['f_mail_server_port']);
            $folder = $row['f_mail_folder'];
            $username = $row['f_mail_username'];
            $password = $row['f_mail_password'];

            $this->_incoming_scan($type, $host, $port, $folder, $username, $password);
        }

        $this->log_message('Finished overall incoming e-mail scan process (forums)');
    }

    /**
     * Process an e-mail found.
     *
     * @param  EMAIL $from_email From e-mail
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     * @param  string $from_name From name
     * @param  string $subject E-mail subject
     * @param  ?string $_body_text E-mail body in text format (null: not present)
     * @param  ?string $_body_html E-mail body in HTML format (null: not present)
     * @param  array $attachments Map of attachments (name to file data); only populated if $mime_type is appropriate for an attachment
     */
    protected function _process_incoming_message($from_email, $email_bounce_to, $from_name, $subject, $_body_text, $_body_html, $attachments)
    {
        // Try to bind to a from member
        $member_id = $this->find_member_id($from_email);
        if ($member_id === null) {
            $member_id = $this->handle_missing_member($from_email, $email_bounce_to, $this->forum_row['f_mail_nonmatch_policy'], $subject, $_body_text, $_body_html);

            if ($member_id !== null) {
                if (is_guest($member_id)) {
                    $this->log_message('Will be posting as guest');
                } else {
                    $this->log_message('Created a new member, #' . strval($member_id));
                }
            }
        } else {
            $this->log_message('Bound to a member, #' . strval($member_id));
        }
        if ($member_id === null) {
            $this->log_message('Could not bind to a member');

            return;
        }
        if ($GLOBALS['FORUM_DRIVER']->is_banned($member_id)) {
            $this->log_message('Member is banned');

            return;
        }
        if (
            ($GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id, 'm_validated') == 0) ||
            ($GLOBALS['FORUM_DRIVER']->get_member_row_field($member_id, 'm_validated_email_confirm_code') != '')
        ) {
            $this->log_message('Member is not validated');

            return;
        }

        $prefer_html = has_privilege($member_id, 'allow_html');
        if (($_body_html === null) || ((!$prefer_html) && ($_body_text !== null))) {
            $body = $this->email_comcode_from_text($_body_text);
        } else {
            $body = $this->email_comcode_from_html($_body_html, $member_id);
        }

        $username = $GLOBALS['FORUM_DRIVER']->get_username($member_id);

        // Check access
        if (!has_category_access($member_id, 'forums', strval($this->forum_id))) {
            $forum_name = $this->forum_row['f_name'];

            $this->log_message('Access denied to the bound member for ' . $forum_name);

            $this->send_bounce_email__access_denied($subject, $_body_text, $_body_html, $from_email, $email_bounce_to, $forum_name, $username, $member_id);
        }

        // Check there can be no forgery vulnerability
        $member_id_comcode = $this->degrade_member_id_for_comcode($member_id);

        global $LAX_COMCODE, $OVERRIDE_MEMBER_ID_COMCODE;
        $OVERRIDE_MEMBER_ID_COMCODE = $member_id_comcode;
        $LAX_COMCODE = true;

        // Add in attachments
        $attachment_errors = $this->save_attachments($attachments, $member_id, $member_id_comcode, $body);

        // Mark that this was e-mailed in
        $body = static_evaluate_tempcode(do_template('CNS_POST_FROM_MAILING_LIST', array(
            'UNCONFIRMED_MEMBER_NOTICE' => ($this->forum_row['f_mail_unconfirmed_notice'] == 1) && (!is_guest($member_id)),
            'POST' => $body,
            'USERNAME' => $username,
        ), null, false, null, '.txt', 'text'));

        $title = $subject;
        $possible_reply = /*false*/true; // Better to just let anything be a possible reply, more user-friendly
        do {
            $changed = false;
            if (strtolower(substr($title, 0, 4)) == 're: ') {
                $title = substr($title, 4);
                $changed = true;
                $possible_reply = true;
            } elseif (strtolower(substr($title, 0, 4)) == 'fw: ') {
                $title = substr($title, 4);
                $changed = true;
            }
        }
        while ($changed);

        // Try and match to a topic
        $topic_id = null;
        if ($possible_reply) {
            $topic_id = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_topics', 'id', array('t_cache_first_title' => $title, 't_forum_id' => $this->forum_id), 'ORDER BY t_cache_last_time DESC');
        }
        $is_starter = ($topic_id === null);

        if ($is_starter) {
            require_code('cns_topics_action');
            $topic_validated = has_privilege($member_id, 'bypass_validation_midrange_content', 'topics', array('forums', $this->forum_id));
            $topic_id = cns_make_topic($this->forum_id, '', '', $topic_validated ? 1 : 0, 1, 0, 0, null, null, false);

            $this->log_message('Created topic #' . strval($topic_id));
        }

        if (is_guest($member_id)) {
            $poster_name_if_guest = titleify(str_replace('.', ' ', preg_replace('#[@+].*$#', '', $from_email)));
        } else {
            $poster_name_if_guest = $GLOBALS['FORUM_DRIVER']->get_username($member_id);
        }

        require_code('cns_posts_action');
        $post_validated = has_privilege($member_id, 'bypass_validation_lowrange_content', 'topics', array('forums', $this->forum_id));
        $post_id = cns_make_post($topic_id, $title, $body, 0, $is_starter, $post_validated ? 1 : 0, 0, $poster_name_if_guest, null, null, $member_id, null, null, null, false, true, $this->forum_id, true, $title, null, false, true);

        require_code('users2');
        if ((has_actual_page_access(get_modal_user(), 'forumview')) && (has_category_access(get_modal_user(), 'forums', strval($this->forum_id)))) {
            require_code('activities');
            syndicate_described_activity($is_starter ? 'cns:ACTIVITY_ADD_TOPIC' : 'cns:ACTIVITY_ADD_POST_IN', $title, '', '', '_SEARCH:topicview:browse:' . strval($topic_id) . '#post_' . strval($post_id), '', '', 'cns_forum', 1, $member_id);
        }

        $this->log_message('Created post #' . strval($post_id));

        if (count($attachment_errors) != 0) {
            $this->log_message('Had some issues creating an attachment(s) [non-fatal], e-mailing them about it');

            $post_url = $GLOBALS['FORUM_DRIVER']->post_url($post_id, '');

            $this->send_bounce_email__attachment_errors($subject, $body, $from_email, $email_bounce_to, $attachment_errors, $post_url);
        }
    }

    /**
     * Strip system code from an e-mail component.
     *
     * @param  string $text E-mail component
     * @param  integer $format A STRIP_* constant
     */
    protected function strip_system_code(&$text, $format)
    {
        switch ($format) {
            case self::STRIP_SUBJECT:
                $strings = array();
                foreach (array_keys(find_all_langs()) as $lang) {
                    $strings[] = do_lang('MAILING_LIST_SIMPLE_SUBJECT_new_regexp', null, null, null, $lang);
                    $strings[] = do_lang('MAILING_LIST_SIMPLE_SUBJECT_reply_regexp', null, null, null, $lang);
                }
                foreach ($strings as $s) {
                    $text = preg_replace('#' . $s . '#', '', $text);
                }
                break;

            case self::STRIP_HTML:
                $strings = array();
                foreach (array_keys(find_all_langs()) as $lang) {
                    $strings[] = do_lang('MAILING_LIST_SIMPLE_MAIL_regexp', null, null, null, $lang);
                }
                foreach ($strings as $s) {
                    $text = preg_replace('#' . $s . '#is', '', $text);
                }
                $text = cms_preg_replace_safe('#(<[^/][^<>]*>\s*)*$#is', '', $text); // Remove left over tags on end (as the rest may have just been chopped off)
                require_code('xhtml');
                $text = xhtmlise_html($text, true); // Fix any HTML errors (e.g. uneven tags, which would break out layout)
                break;

            case self::STRIP_TEXT:
                $strings = array();
                foreach (array_keys(find_all_langs()) as $lang) {
                    $strings[] = do_lang('MAILING_LIST_SIMPLE_MAIL_regexp', null, null, null, $lang);
                }
                foreach ($strings as $s) {
                    $text = preg_replace('#' . $s . '#i', '', $text);
                }
                break;
        }
    }

    /**
     * Send out an e-mail about us not recognising an e-mail address for an incoming e-mail.
     *
     * @param  string $subject Subject line of original message
     * @param  ?string $_body_text E-mail body in text format (null: not present)
     * @param  ?string $_body_html E-mail body in HTML format (null: not present)
     * @param  EMAIL $email E-mail address we tried to bind to
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     */
    protected function send_bounce_email__cannot_bind($subject, $_body_text, $_body_html, $email, $email_bounce_to)
    {
        $prefer_html = has_privilege($GLOBALS['FORUM_DRIVER']->get_guest_id(), 'allow_html');
        if (($_body_html === null) || ((!$prefer_html) && ($_body_text !== null))) {
            $body = $this->email_comcode_from_text($_body_text);
        } else {
            $body = $this->email_comcode_from_html($_body_html, $GLOBALS['FORUM_DRIVER']->get_guest_id());
        }

        $extended_subject = do_lang('MAILING_LIST_CANNOT_BIND_SUBJECT', $subject, $email, array(get_site_name()), get_site_default_lang());
        $extended_message = do_lang('MAILING_LIST_CANNOT_BIND_MAIL', strip_comcode($body), $email, array($subject, get_site_name()), get_site_default_lang());

        $this->send_system_email($extended_subject, $extended_message, $email, $email_bounce_to);
    }

    /**
     * Send out an e-mail about us not having access to the forum.
     *
     * @param  string $subject Subject line of original message
     * @param  ?string $_body_text E-mail body in text format (null: not present)
     * @param  ?string $_body_html E-mail body in HTML format (null: not present)
     * @param  EMAIL $email E-mail address we tried to bind to
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     * @param  string $forum_name Forum name
     * @param  string $username Bound username
     * @param  MEMBER $member_id Member ID
     */
    protected function send_bounce_email__access_denied($subject, $_body_text, $_body_html, $email, $email_bounce_to, $forum_name, $username, $member_id)
    {
        $prefer_html = has_privilege($member_id, 'allow_html');
        if (($_body_html === null) || ((!$prefer_html) && ($_body_text !== null))) {
            $body = $this->email_comcode_from_text($_body_text);
        } else {
            $body = $this->email_comcode_from_html($_body_html, $member_id);
        }

        $extended_subject = do_lang('MAILING_LIST_ACCESS_DENIED_SUBJECT', $subject, $email, array(get_site_name(), $forum_name, $username), get_site_default_lang());
        $extended_message = do_lang('MAILING_LIST_ACCESS_DENIED_MAIL', strip_comcode($body), $email, array($subject, get_site_name(), $forum_name, $username), get_site_default_lang());

        $this->send_system_email($extended_subject, $extended_message, $email, $email_bounce_to);
    }
}
