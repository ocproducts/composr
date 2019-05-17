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
 * @package    tickets
 */

/**
 * Block class.
 */
class Block_main_contact_us
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled)
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
        $info['parameters'] = array('param', 'title', 'email_optional', 'subject', 'subject_prefix', 'subject_suffix', 'body_prefix', 'body_suffix', 'redirect', 'guid', 'attachments');
        return $info;
    }

    /**
     * Execute the block.
     *
     * @param  array $map A map of parameters
     * @return Tempcode The result of execution
     */
    public function run($map)
    {
        $error_msg = new Tempcode();
        if (!addon_installed__messaged('tickets', $error_msg)) {
            return $error_msg;
        }

        if (get_forum_type() == 'none') {
            return do_template('RED_ALERT', array('_GUID' => 'dwxpstfxs8mhfud6j23yvhorurauchng', 'TEXT' => do_lang_tempcode('NO_FORUM_INSTALLED')));
        }

        require_lang('tickets');

        require_code('feedback');

        require_code('mail');
        require_code('mail_forms');

        $block_id = get_block_id($map);

        $message = new Tempcode();

        // Options...

        if (addon_installed('captcha')) {
            require_code('captcha');
            $use_captcha = ((get_option('captcha_on_feedback') == '1') && (use_captcha()));
        } else {
            $use_captcha = false;
        }

        $subject = array_key_exists('subject', $map) ? $map['subject'] : '';
        $subject_prefix = array_key_exists('subject_prefix', $map) ? $map['subject_prefix'] : '';
        $subject_suffix = array_key_exists('subject_suffix', $map) ? $map['subject_suffix'] : '';
        $body_prefix = array_key_exists('body_prefix', $map) ? $map['body_prefix'] : '';
        $body_suffix = array_key_exists('body_suffix', $map) ? $map['body_suffix'] : '';

        $type = empty($map['param']) ? do_lang('GENERAL') : $map['param'];
        $box_title = array_key_exists('title', $map) ? $map['title'] : do_lang('CONTACT_US');
        $email_optional = array_key_exists('email_optional', $map) ? (intval($map['email_optional']) == 1) : true;
        $support_attachments = array_key_exists('attachments', $map) ? (intval($map['attachments']) == 1) : false;

        $block_id = md5(serialize($map));

        // Submission...

        if ((post_param_integer('_comment_form_post', 0) == 1) && (post_param_string('_block_id', '') == $block_id)) {
            // Check CAPTCHA
            if ($use_captcha) {
                enforce_captcha();
            }

            list($subject, $body, , , $from_email, $from_name) = _form_to_email(array(), $subject_prefix, $subject_suffix, $body_prefix, $body_suffix);

            // Checking
            if ($from_email != '') {
                require_code('type_sanitisation');
                if (!is_email_address($from_email)) {
                    return do_template('RED_ALERT', array('_GUID' => '5pu5qw042z8exijsgty78o4tvq9mpnb6', 'TEXT' => do_lang_tempcode('INVALID_EMAIL_ADDRESS')));
                }
            }
            $from_name = trim(post_param_string('name', $GLOBALS['FORUM_DRIVER']->get_username(get_member(), true)));

            // Check spam
            require_code('antispam');
            inject_action_spamcheck(null, $from_email);

            // Handle notifications
            require_code('notifications');
            $notification_subject = do_lang('CONTACT_US_NOTIFICATION_SUBJECT', $subject, null, null, get_site_default_lang());
            $notification_message = do_notification_lang('CONTACT_US_NOTIFICATION_MESSAGE', comcode_escape(get_site_name()), comcode_escape($from_name), array($body, comcode_escape($type), strval(get_member())), get_site_default_lang());
            $id = uniqid('', false);
            $attachments = array();
            if (addon_installed('securitylogging')) {
                require_code('lookup');
                $user_metadata_path = save_user_metadata();
                $attachments[$user_metadata_path] = 'user_metadata.txt';
            }
            dispatch_notification('ticket_reply', $type . '_' . $id, $notification_subject, $notification_message, null, null, array('create_ticket' => true, 'attachments' => $attachments));

            // Send standard confirmation e-mail to current user
            if ($from_email != '' && get_option('message_received_emails') == '1') {
                require_code('mail');
                dispatch_mail(do_lang('YOUR_MESSAGE_WAS_SENT_SUBJECT', $subject), do_lang('YOUR_MESSAGE_WAS_SENT_BODY', $body), array($from_email), empty($from_name) ? null : $from_name, '', '', array('require_recipient_valid_since' => get_member()));
            }

            // Redirect/messaging
            $redirect = array_key_exists('redirect', $map) ? $map['redirect'] : '';
            if ($redirect != '') {
                $redirect = page_link_to_url($redirect);
                require_code('site2');
                assign_refresh($redirect, 0.0); // redirect_screen not used because there is already a legitimate output screen happening
            } else {
                attach_message(do_lang_tempcode('MESSAGE_SENT'), 'inform');
            }

            // Tidy up
            delete_cache_entry('main_staff_checklist');
        }

        // Form...

        $emoticons = $GLOBALS['FORUM_DRIVER']->get_emoticon_chooser();

        require_javascript('editing');
        require_javascript('checking');

        $comment_url = get_self_url();

        if (addon_installed('captcha')) {
            require_code('captcha');
            $use_captcha = ((get_option('captcha_on_feedback') == '1') && (use_captcha()));
            if ($use_captcha) {
                generate_captcha();
            }
        } else {
            $use_captcha = false;
        }

        $default_post = null;
        $redirect = get_param_string('redirect', '', INPUT_FILTER_GET_COMPLEX);
        if ($redirect != '') {
            $default_post = do_lang('COMMENTS_DEFAULT_POST', $redirect);
        }

        $hidden = new Tempcode();
        $hidden->attach(form_input_hidden('_block_id', $block_id));

        $guid = isset($map['guid']) ? $map['guid'] : '31fe96c5ec3b609fbf19595a1de3886f';

        if ($support_attachments) {
            require_code('form_templates');
            list($attachments, $attach_size_field) = get_attachments('post', false);
        } else {
            $attachments = null;
            $attach_size_field = null;
        }

        $comment_details = do_template('COMMENTS_POSTING_FORM', array(
            '_GUID' => $guid,
            'TITLE' => $box_title,
            'HIDDEN' => $hidden,
            'USE_CAPTCHA' => $use_captcha,
            'GET_EMAIL' => true,
            'EMAIL_OPTIONAL' => $email_optional,
            'GET_TITLE' => true,
            'TITLE_OPTIONAL' => false,
            'DEFAULT_TITLE' => $subject,
            'DEFAULT_POST' => $default_post,
            'POST_WARNING' => '',
            'RULES_TEXT' => '',
            'ATTACHMENTS' => $attachments,
            'ATTACH_SIZE_FIELD' => $attach_size_field,
            'TRUE_ATTACHMENT_UI' => false,
            'EMOTICONS' => $emoticons,
            'DISPLAY' => 'block',
            'FIRST_POST_URL' => '',
            'FIRST_POST' => '',
            'COMMENT_URL' => $comment_url,
            'SUBMIT_NAME' => do_lang_tempcode('SEND'),
            'SUBMIT_ICON' => 'buttons/send',
            'SKIP_PREVIEW' => true,
            'ANALYTIC_EVENT_CATEGORY' => do_lang('CONTACT_US'),
        ));

        return do_template('BLOCK_MAIN_CONTACT_US', array(
            '_GUID' => $guid,
            'BLOCK_ID' => $block_id,
            'COMMENT_DETAILS' => $comment_details,
            'TYPE' => $type,
        ));
    }
}
