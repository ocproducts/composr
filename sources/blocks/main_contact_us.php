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
 * @package    staff_messaging
 */

/**
 * Block class.
 */
class Block_main_contact_us
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
        $info['parameters'] = array('param', 'title', 'email_optional', 'body_prefix', 'body_suffix', 'subject_prefix', 'subject_suffix', 'redirect', 'guid');
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
        require_lang('messaging');
        require_code('feedback');

        $type = array_key_exists('param', $map) ? $map['param'] : do_lang('GENERAL');

        $body_prefix = array_key_exists('body_prefix', $map) ? $map['body_prefix'] : '';
        $body_suffix = array_key_exists('body_suffix', $map) ? $map['body_suffix'] : '';
        $subject_prefix = array_key_exists('subject_prefix', $map) ? $map['subject_prefix'] : '';
        $subject_suffix = array_key_exists('subject_suffix', $map) ? $map['subject_suffix'] : '';

        $id = uniqid('', false);
        $_self_url = build_url(array('page' => 'admin_messaging', 'type' => 'view', 'id' => $id, 'message_type' => $type), get_module_zone('admin_messaging'));
        $self_url = $_self_url->evaluate();
        $self_title = post_param_string('title', do_lang('CONTACT_US_MESSAGING'));
        $post = post_param_string('post', '');
        $title = post_param_string('title', '');

        $box_title = array_key_exists('title', $map) ? $map['title'] : do_lang('CONTACT_US');

        $block_id = md5(serialize($map));

        if ((post_param_integer('_comment_form_post', 0) == 1) && (post_param_string('_block_id', '') == $block_id) && ($post != '')) {
            $message = new Tempcode();/*Used to be written out here*/
            attach_message(do_lang_tempcode('MESSAGE_SENT'), 'inform');

            // Check CAPTCHA
            if ((addon_installed('captcha')) && (get_option('captcha_on_feedback') == '1')) {
                require_code('captcha');
                enforce_captcha();
            }

            $email_from = trim(post_param_string('email', $GLOBALS['FORUM_DRIVER']->get_member_email_address(get_member())));
            if ($email_from != '') {
                require_code('type_sanitisation');
                if (!is_email_address($email_from)) {
                    warn_exit(do_lang_tempcode('INVALID_EMAIL_ADDRESS'));
                }
            }

            // Handle notifications
            require_code('notifications');
            $notification_subject = do_lang('CONTACT_US_NOTIFICATION_SUBJECT', $subject_prefix . $title . $subject_suffix, null, null, get_site_default_lang());
            $notification_message = do_notification_lang('CONTACT_US_NOTIFICATION_MESSAGE', comcode_escape(get_site_name()), comcode_escape($GLOBALS['FORUM_DRIVER']->get_username(get_member())), array($body_prefix . $post . $body_suffix, comcode_escape($type), strval(get_member())), get_site_default_lang());
            dispatch_notification('messaging', $type . '_' . $id, $notification_subject, $notification_message, null, null, 3, true, false, null, null, $subject_prefix, $subject_suffix, $body_prefix, $body_suffix);

            // Send standard confirmation email to current user
            if ($email_from != '') {
                require_code('mail');
                mail_wrap(do_lang('YOUR_MESSAGE_WAS_SENT_SUBJECT', $title), do_lang('YOUR_MESSAGE_WAS_SENT_BODY', $post), array($email_from), null, '', '', 3, null, false, get_member());
            }

            $redirect = array_key_exists('redirect', $map) ? $map['redirect'] : '';
            if ($redirect != '') {
                $redirect = page_link_to_url($redirect);
                require_code('site2');
                assign_refresh($redirect, 0.0);
            }

    		decache('main_staff_checklist');
        } else {
            $message = new Tempcode();
        }

        if (get_forum_type() != 'none') { // If cns_forum not installed, will still work
            // Comment posts
            $forum = get_option('messaging_forum_name');
            $count = 0;
            $_comments = $GLOBALS['FORUM_DRIVER']->get_forum_topic_posts($GLOBALS['FORUM_DRIVER']->find_topic_id_for_topic_identifier($forum, $type . '_' . $id), $count);

            if ($_comments !== -1) {
                $em = $GLOBALS['FORUM_DRIVER']->get_emoticon_chooser();

                require_javascript('editing');
                require_javascript('checking');

                $comment_url = get_self_url();
                $email_optional = array_key_exists('email_optional', $map) ? (intval($map['email_optional']) == 1) : true;

                if (addon_installed('captcha')) {
                    require_code('captcha');
                    $use_captcha = ((get_option('captcha_on_feedback') == '1') && (use_captcha()));
                    if ($use_captcha) {
                        generate_captcha();
                    }
                } else {
                    $use_captcha = false;
                }

                $default_text = mixed();
                $redirect = get_param_string('redirect', '', true);
                if ($redirect != '') {
                    $default_text = do_lang('COMMENTS_DEFAULT_TEXT', $redirect);
                }

                $hidden = new Tempcode();
                $hidden->attach(form_input_hidden('_block_id', $block_id));

                $guid = isset($map['guid']) ? $map['guid'] : '31fe96c5ec3b609fbf19595a1de3886f';

                $comment_details = do_template('COMMENTS_POSTING_FORM', array(
                    '_GUID' => $guid,
                    'DEFAULT_TEXT' => $default_text,
                    'JOIN_BITS' => '',
                    'FIRST_POST_URL' => '',
                    'FIRST_POST' => '',
                    'USE_CAPTCHA' => $use_captcha,
                    'EMAIL_OPTIONAL' => $email_optional,
                    'POST_WARNING' => '',
                    'COMMENT_TEXT' => '',
                    'GET_EMAIL' => true,
                    'GET_TITLE' => true,
                    'EM' => $em,
                    'DISPLAY' => 'block',
                    'COMMENT_URL' => $comment_url,
                    'TITLE' => $box_title,
                    'HIDDEN' => $hidden,
                ));

                $notifications_enabled = null;
                $notification_change_url = null;
                if (has_actual_page_access(get_member(), 'admin_messaging')) {
                    require_code('notifications');
                    $notifications_enabled = notifications_enabled('messaging', 'type', get_member());
                }

                $out = do_template('BLOCK_MAIN_CONTACT_US', array(
                    '_GUID' => $guid,
                    'COMMENT_DETAILS' => $comment_details,
                    'MESSAGE' => $message,
                    'NOTIFICATIONS_ENABLED' => $notifications_enabled,
                    'TYPE' => $type,
                ));
            } else {
                $out = new Tempcode();
            }
        } else {
            $out = new Tempcode();
        }

        return $out;
    }
}
