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
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__mail_forms()
{
    require_code('mail');
}

/**
 * Entry script to process a form that needs to be emailed.
 */
function form_to_email_entry_script()
{
    form_to_email();

    global $PAGE_NAME_CACHE;
    $PAGE_NAME_CACHE = '_form_to_email';
    $title = get_screen_title('MAIL_SENT');
    $text = do_lang_tempcode('MAIL_SENT_TEXT', escape_html(post_param_string('to_written_name', get_site_name())));
    $redirect = get_param_string('redirect', null, INPUT_FILTER_URL_INTERNAL);
    if ($redirect !== null) {
        require_code('site2');
        $tpl = redirect_screen($title, $redirect, $text);
    } else {
        $tpl = do_template('INFORM_SCREEN', array('_GUID' => 'e577a4df79eefd9064c14240cc99e947', 'TITLE' => $title, 'TEXT' => $text));
    }
    $echo = globalise($tpl, null, '', true);
    $echo->evaluate_echo();
}

/**
 * Send the posted form over email to the staff address.
 *
 * @param  ?string $subject The subject of the email (null: from posted subject parameter).
 * @param  string $intro The intro text to the mail (blank: none).
 * @param  ?array $fields A map of fields to field titles to transmit. (null: all posted fields, except subject and email)
 * @param  ?string $to_email Email address to send to (null: look from post environment / staff address).
 * @param  string $outro The outro text to the mail (blank: none).
 * @param  boolean $is_via_post Whether $fields refers to some POSTed fields, as opposed to a direct field->value map.
 */
function form_to_email($subject = null, $intro = '', $fields = null, $to_email = null, $outro = '', $is_via_post = true)
{
    $details = _form_to_email(null, $subject, $intro, $fields, $to_email, $outro, $is_via_post);
    list($subject, $message_raw, $to_email, $to_name, $from_email, $from_name, $attachments) = $details;

    if (addon_installed('captcha')) {
        if (post_param_integer('_security', 0) == 1) {
            require_code('captcha');
            enforce_captcha();
        }
    }

    dispatch_mail($subject, $message_raw, ($to_email === null) ? null : array($to_email), $to_name, $from_email, $from_name, array('attachments' => $attachments, 'bypass_queue' => count($attachments) != 0));

    if ($from_email != '' && get_option('message_received_emails') == '1') {
        dispatch_mail(do_lang('YOUR_MESSAGE_WAS_SENT_SUBJECT', $subject), do_lang('YOUR_MESSAGE_WAS_SENT_BODY', $from_email), array($from_email), null, '', '', array('as' => get_member()));
    }
}

/**
 * Worker funtion for form_to_email.
 *
 * @param  ?array $extra_boring_fields Fields to skip in addition to the normal skipped ones (null: just the normal skipped ones)
 * @param  ?string $subject The subject of the email (null: from posted subject parameter).
 * @param  string $intro The intro text to the mail (blank: none).
 * @param  ?array $fields A map of fields to field titles to transmit. (null: all posted fields, except subject and email)
 * @param  ?string $to_email Email address to send to (null: look from post environment / staff address).
 * @param  string $outro The outro text to the mail (blank: none).
 * @param  boolean $is_via_post Whether $fields refers to some POSTed fields, as opposed to a direct field->value map.
 * @return array A tuple: subject, message, to e-mail, to name, from e-mail, from name, attachments
 *
 * @ignore
 */
function _form_to_email($extra_boring_fields = null, $subject = null, $intro = '', $fields = null, $to_email = null, $outro = '', $is_via_post = true)
{
    if ($subject === null) {
        $subject = post_param_string('subject', get_site_name());
    }

    if ($fields === null) {
        $fields = array();
        $boring_fields = array( // NB: Keep in sync with static_export.php
            'MAX_FILE_SIZE',
            'perform_webstandards_check',
            '_validated',
            'posting_ref_id',
            'f_face',
            'f_colour',
            'f_size',
            'x',
            'y',
            'name',
            'subject',
            'email',
            'to_members_email',
            'to_written_name',
            'redirect',
            'http_referer',
            'session_id',
            'csrf_token',
            md5(get_site_name() . ': antispam'),
        );
        if ($extra_boring_fields !== null) {
            $boring_fields = array_merge($boring_fields, $extra_boring_fields);
        }
        foreach (array_diff(array_keys($_POST), $boring_fields) as $key) {
            $is_hidden =  // NB: Keep in sync with static_export.php
                (strpos($key, 'hour') !== false) || 
                (strpos($key, 'access_') !== false) || 
                (strpos($key, 'minute') !== false) || 
                (strpos($key, 'confirm') !== false) || 
                (strpos($key, 'pre_f_') !== false) || 
                (strpos($key, 'tick_on_form__') !== false) || 
                (strpos($key, 'label_for__') !== false) || 
                (strpos($key, 'description_for__') !== false) || 
                (strpos($key, 'wysiwyg_version_of_') !== false) || 
                (strpos($key, 'is_wysiwyg') !== false) || 
                (strpos($key, 'require__') !== false) || 
                (strpos($key, 'tempcodecss__') !== false) || 
                (strpos($key, 'comcode__') !== false) || 
                (strpos($key, '_parsed') !== false) || 
                (substr($key, 0, 1) == '_') || 
                (substr($key, 0, 9) == 'hidFileID') || 
                (substr($key, 0, 11) == 'hidFileName');
            if ($is_hidden) {
                continue;
            }

            if (substr($key, 0, 1) != '_') {
                $label = post_param_string('label_for__' . $key, titleify($key));
                $description = post_param_string('description_for__' . $key, '');
                $_label = $label . (($description == '') ? '' : (' (' . $description . ')'));

                if ($is_via_post) {
                    $fields[$key] = $_label;
                } else {
                    $fields[$label] = post_param_string($key, null);
                }
            }
        }
    }

    $from_email = trim(post_param_string('email', ''));

    $message_raw = '';
    if ($intro != '') {
        $message_raw .= $intro . "\n\n------------\n\n";
    }

    if ($is_via_post) {
        foreach ($fields as $field_name => $field_title) {
            $field_val = post_param_string($field_name, null);
            if ($field_val !== null) {
                _append_form_to_email($message_raw, post_param_integer('tick_on_form__' . $field_name, null) !== null, $field_title, $field_val);

                if (($from_email == '') && ($field_val != '') && (post_param_string('field_tagged__' . $field_name, '') == 'email')) {
                    $from_email = $field_val;
                }
            }
        }
    } else {
        foreach ($fields as $field_title => $field_val) {
            if ($field_val !== null) {
                _append_form_to_email($message_raw, false, $field_title, $field_val);
            }
        }
    }

    if ($outro != '') {
        $message_raw .= "\n\n------------\n\n" . $outro;
    }

    if ($from_email == '') {
        $from_email = $GLOBALS['FORUM_DRIVER']->get_member_email_address(get_member());
    }
    $from_name = post_param_string('name', $GLOBALS['FORUM_DRIVER']->get_username(get_member(), true));

    $to_name = mixed();
    if (($to_email === null) && (get_value('allow_member_mail_relay') !== null)) {
        $to = post_param_integer('to_members_email', null);
        if ($to !== null) {
            $to_email = $GLOBALS['FORUM_DRIVER']->get_member_email_address($to);
            $to_name = $GLOBALS['FORUM_DRIVER']->get_username($to, true);
        }
    }

    $attachments = array();
    require_code('uploads');
    is_plupload(true);
    foreach ($_FILES as $file) {
        $attachments[$file['tmp_name']] = $file['name'];
    }

    return array($subject, $message_raw, $to_email, $to_name, $from_email, $from_name, $attachments);
}

/**
 * Append a value to a text e-mail.
 *
 * @param  string $message_raw Text-email (altered by reference).
 * @param  boolean $is_tick Whether it is a tick field.
 * @param  string $field_title Field title.
 * @param  string $field_val Field value.
 *
 * @ignore
 */
function _append_form_to_email(&$message_raw, $is_tick, $field_title, $field_val)
{
    $prefix = '';
    $prefix .= '[b]' . $field_title . '[/b]:';
    if (strpos($prefix, "\n") !== false || strpos($field_title, ' (') !== false) {
        $prefix .= "\n";
    } else {
        $prefix .= " ";
    }

    if ($is_tick && in_array($field_val, array('', '0', '1'))) {
        $message_raw .= $prefix;
        $message_raw .= ($field_val == '1') ? do_lang('YES') : do_lang('NO');
    } else {
        if ($field_val == '') {
            return; // We won't show blank values, gets long
        }

        $message_raw .= $prefix;
        if ($field_val == '') {
            $message_raw .= '(' . do_lang('EMPTY') . ')';
        } else {
            $message_raw .= $field_val;
        }
    }

    $message_raw .= "\n\n";
}
