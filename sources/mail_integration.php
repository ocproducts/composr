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

/*EXTRA FUNCTIONS: imap\_.+*/

/**
 * Standard code module initialisation function.
 *
 * @ignore
 */
function init__mail_integration()
{
    require_code('mail');
}

/**
 * E-mail integration  base class.
 *
 * @package        core
 */
abstract class EmailIntegration
{
    const STRIP_SUBJECT = 1;
    const STRIP_HTML = 2;
    const STRIP_TEXT = 3;

    /**
     * Log a message, if the log has been created.
     *
     * @param  string $message Message
     */
    protected function log_message($message)
    {
        $path = get_custom_file_base() . '/data_custom/mail_integration.log';
        if (is_file($path)) {
            $myfile = fopen($path, 'ab');
            $log_line = date('Y-m-d H:i:s') . ': ' . $message . "\n";
            fwrite($myfile, $log_line);
            fclose($myfile);
        }
    }

    /**
     * Send out an e-mail message.
     *
     * @param  string $subject Subject
     * @param  string $message Message
     * @param  MEMBER $to_member_id Member ID of recipient
     * @param  string $to_displayname Display name of recipient
     * @param  EMAIL $to_email E-mail address of recipient
     * @param  string $from_displayname Display name of sender
     * @param  EMAIL $from_email E-mail address of sender (blank: use defined system e-mail address for Reply-To)
     */
    protected function _outgoing_message($subject, $message, $to_member_id, $to_displayname, $to_email, $from_displayname, $from_email = '')
    {
        if ($to_email == '') {
            return;
        }

        $this->log_message('Sending outgoing e-mail to ' . $to_email . ' (' . $subject . ')');

        $headers = '';

        // From
        $sender_email = $this->get_sender_email(); // Typically 'website_email' option
        $headers .= 'From: ' . $from_displayname . ' <' . $sender_email . '>' . "\r\n";

        // Reply-To
        if ($from_email == '') {
            $from_email = $this->get_system_email();
        }
        $headers .= 'Reply-To: ' . $from_displayname . ' <' . $from_email . '>';

        // Subject
        $tightened_subject = str_replace(array("\n", "\r"), array('', ''), $subject);

        // Send
        mail($to_displayname . ' <' . $to_email . '>', $tightened_subject, comcode_to_clean_text($message), $headers);
    }

    /**
     * Find the e-mail address to send from (From header).
     *
     * @return EMAIL E-mail address
     */
    protected function get_sender_email()
    {
        foreach (array('website_email', 'staff_address') as $address) {
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
    abstract protected function get_system_email();

    /**
     * Scan for new e-mails.
     */
    abstract public function incoming_scan();

    /**
     * Scan for new e-mails.
     *
     * @param  string $type Server type (blank: get from glboal configuration)
     * @param  string $host Server hostname (blank: get from glboal configuration)
     * @param  ?integer $port Server port (null: get from glboal configuration)
     * @param  string $folder Inbox folder (blank: get from glboal configuration)
     * @param  string $username Username (blank: get from glboal configuration)
     * @param  string $password Password (blank: get from glboal configuration)
     */
    protected function _incoming_scan($type, $host, $port, $folder, $username, $password)
    {
        require_code('mail2');

        $this->log_message('Starting an incoming e-mail scan on ' . $host . ' (' . $username . ')');

        if (!function_exists('imap_open')) {
            warn_exit(do_lang_tempcode('IMAP_NEEDED'));
        }

        if ($type == '') {
            $type = get_option('mail_server_type');
        }
        if ($host == '') {
            $host = get_option('mail_server_host');
        }
        if ($port === null) {
            $port = intval(get_option('mail_server_port'));
        }
        if ($folder == '') {
            $folder = get_option('mail_folder');
        }

        if ($username == '') {
            $username = get_option('mail_username');
        }
        if ($password == '') {
            $password = get_option('mail_password');
        }

        $server_spec = _imap_server_spec($host, $port, $type);
        $mbox = @imap_open($server_spec . $folder, $username, $password, CL_EXPUNGE);
        if ($mbox !== false) {
            $this->log_message('Successfully opened server connection');

            $reprocess = (get_param_integer('test', 0) == 1 && $GLOBALS['FORUM_DRIVER']->is_super_admin(get_member()));
            $list = imap_search($mbox, $reprocess ? '' : 'UNSEEN');
            if ($list === false) {
                $list = array();
            }
            foreach ($list as $l) {
                $header = imap_headerinfo($mbox, $l);
                $full_header = imap_fetchheader($mbox, $l);
                imap_clearflag_full($mbox, $l, '\\Seen'); // Clear this, as otherwise it is a real pain to debug (have to keep manually marking unread)

                $subject = $header->subject;
                $this->strip_system_code($subject, self::STRIP_SUBJECT);

                $this->log_message('Found an unread e-mail, ' . $subject);

                // Find overall character set
                $input_charset = 'iso-8859-1';
                $matches = array();
                if (preg_match('#^Content-Type:.*;\s*charset=([\s\w\-]+)$#im', $full_header, $matches) != 0) {
                    $input_charset = trim($matches[1], " \t\"'");
                }

                // Find body parts and attachments
                $attachments = array();
                $attachment_size_total = 0;
                $body = $this->_imap_get_part($mbox, $l, 'TEXT/HTML', $attachments, $attachment_size_total, $input_charset);
                imap_clearflag_full($mbox, $l, '\\Seen'); // Clear this, as otherwise it is a real pain to debug (have to keep manually marking unread)
                if ($body === null) { // Convert from plain text
                    $body = $this->_imap_get_part($mbox, $l, 'TEXT/PLAIN', $attachments, $attachment_size_total, $input_charset);
                    imap_clearflag_full($mbox, $l, '\\Seen'); // Clear this, as otherwise it is a real pain to debug (have to keep manually marking unread)
                    $body = $this->email_comcode_from_text($body);
                } else { // Convert from HTML
                    $body = $this->email_comcode_from_html($body);
                }
                $this->_imap_get_part($mbox, $l, 'APPLICATION/OCTET-STREAM', $attachments, $attachment_size_total, $input_charset);
                imap_clearflag_full($mbox, $l, '\\Seen'); // Clear this, as otherwise it is a real pain to debug (have to keep manually marking unread)

                // Find from details (preferencing Reply-To)
                $from_email = null;
                $from_name = null;
                foreach (array($header->reply_toaddress, $header->fromaddress) as $from_header) {
                    if (!empty($from_header)) {
                        $test = $this->get_email_address_from_header($from_header);
                        if ($test !== null) {
                            $from_email_alt = $test[0];
                            $from_name_alt = $test[1];
                            $from_email_binds = ($from_email_alt !== null) && ($this->find_member_id($from_email_alt) !== null);
                            if (($from_email === null) || ($from_email_binds)) {
                                $from_email = $from_email_alt;
                                $from_name = $from_name_alt;
                                if ($from_email_binds) {
                                    break;
                                }
                            }
                        }
                    }
                }

                // Continue to real processing
                if (!$this->is_non_human_email($subject, $body, $full_header, $from_email)) {
                    $this->log_message('E-mail is being processed (From e-mail=' . $from_email . ', From name=' . $from_name . ', From subject=' . $subject . ')');

                    $this->process_incoming_message(
                        $from_email,
                        $from_name,
                        $subject,
                        $body,
                        $attachments
                    );
                } else {
                    $this->log_message('E-mail was considered non-human');
                }

                imap_setflag_full($mbox, $l, '\\Seen');
            }

            // Cleanup
            $mail_delete_after = get_option('mail_delete_after');
            if (($mail_delete_after != '') && ($mail_delete_after != '0')) {
                $cutoff = time() - 60 * 60 * 24 * intval($mail_delete_after);
                $list = imap_search($mbox, 'SEEN BEFORE "' . date('j-M-Y', $cutoff) . '"');
                if ($list === false) {
                    $list = array();
                }
                foreach ($list as $l) {
                    if ((!empty($header->udate)) && ($header->udate < $cutoff)) {
                        imap_delete($mbox, $l);
                    }
                }
            }

            imap_close($mbox,  CL_EXPUNGE);
        } else {
            $error = imap_last_error();
            imap_errors(); // Works-around weird PHP bug where "Retrying PLAIN authentication after [AUTHENTICATIONFAILED] Authentication failed. (errflg=1) in Unknown on line 0" may get spit out into any stream (even the backup log)

            $this->log_message('Failed to open server connection (' . $error . ')');

            $cli = ((php_function_allowed('php_sapi_name')) && (php_sapi_name() == 'cli') && (cms_srv('REMOTE_ADDR') == ''));
            if (!$cli && get_param_integer('no_fatal_cron_errors', 0) != 1) {
                warn_exit(do_lang_tempcode('IMAP_ERROR', $error));
            }
        }

        $this->log_message('Finished incoming e-mail scan');
    }

    /**
     * Process an e-mail found.
     *
     * @param  EMAIL $from_email From e-mail
     * @param  string $from_name From name
     * @param  string $subject E-mail subject
     * @param  string $body E-mail body
     * @param  array $attachments Map of attachments (name to file data); only populated if $mime_type is appropriate for an attachment
     */
    protected function process_incoming_message($from_email, $from_name, $subject, $body, $attachments)
    {
        $email_bounce_to = $from_email;

        // De-forward
        $forwarded = false;
        foreach (array('fwd: ', 'fw: ') as $prefix) {
            if (substr(strtolower($subject), 0, strlen($prefix)) == $prefix) {
                $subject = substr($subject, strlen($prefix));
                $forwarded = true;
                $body = preg_replace('#^(\[semihtml\])?(<br />\n)*-------- Original Message --------(\n|<br />)+#', '${1}', $body);
                $body = preg_replace('#^(\[semihtml\])?(<br />\n)*Begin forwarded message:(\n|<br />)*#', '${1}', $body);
                $body = preg_replace('#^(\[semihtml\])?(<br />\n)*<div>Begin forwarded message:</div>(\n|<br />)*#', '${1}', $body);
                $body = preg_replace('#^(\[semihtml\])?(<br />\n)*<div>(<br />\n)*<div>Begin forwarded message:</div>(\n|<br />)*#', '${1}<div>', $body);
            }
        }
        if ($forwarded) {
            if ($this->find_member_id($from_email) === null) {
                foreach (array('Reply-To', 'From') as $from_header_type) {
                    $matches = array();
                    if (preg_match('#' . $from_header_type . ':(.*)#is', $body, $matches) != 0) {
                        $from_email_alt = null;
                        $from_name_alt = null;
                        $test = $this->get_email_address_from_header($matches[1]);
                        if ($test !== null) {
                            $from_email_alt = $test[0];
                            $from_name_alt = $test[1];
                        }
                        if (($from_email_alt !== null) && ($this->find_member_id($from_email_alt) !== null)) {
                            $from_email = $from_email_alt;
                            $from_name = $from_name_alt;
                            break;
                        }
                    }
                }
            }
        }

        $this->_process_incoming_message($from_email, $email_bounce_to, $from_name, $subject, $body, $attachments);
    }

    /**
     * Process an e-mail found.
     *
     * @param  EMAIL $from_email From e-mail
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     * @param  string $from_name From name
     * @param  string $subject E-mail subject
     * @param  string $body E-mail body
     * @param  array $attachments Map of attachments (name to file data); only populated if $mime_type is appropriate for an attachment
     */
    abstract protected function _process_incoming_message($from_email, $email_bounce_to, $from_name, $subject, $body, $attachments);

    /**
     * Get the mime type for a part of the IMAP structure.
     *
     * @param  object $structure Structure
     * @return string Mime type
     */
    protected function _imap_get_mime_type($structure)
    {
        $primary_mime_type = array('TEXT', 'MULTIPART', 'MESSAGE', 'APPLICATION', 'AUDIO', 'IMAGE', 'VIDEO', 'OTHER');
        if ($structure->subtype) {
            return $primary_mime_type[intval($structure->type)] . '/' . strtoupper($structure->subtype);
        }
        return 'TEXT/PLAIN';
    }

    /**
     * Find a message part of an e-mail that matches a mime-type.
     * Also collects a list of *all* attachments along the way, for APPLICATION/OCTET-STREAM.
     * Taken from http://php.net/manual/en/function.imap-fetchbody.php
     *
     * @param  resource $stream IMAP connection object
     * @param  integer $msg_number Message number
     * @param  string $mime_type Mime type we need (in upper case)
     * @param  array $attachments Map of attachments (name to file data); only populated if $mime_type is appropriate for an attachment
     * @param  integer $attachment_size_total Total size of attachments in bytes
     * @param  string $input_charset The character set of the e-mail
     * @param  ?object $structure IMAP message structure (null: look up)
     * @param  string $part_number Message part number (blank: root)
     * @return ?string The message part (null: could not find one)
     */
    protected function _imap_get_part($stream, $msg_number, $mime_type, &$attachments, &$attachment_size_total, $input_charset, $structure = null, $part_number = '')
    {
        if ($structure === null) {
            $structure = imap_fetchstructure($stream, $msg_number);
        }

        $part_mime_type = $this->_imap_get_mime_type($structure);

        if ($mime_type == 'APPLICATION/OCTET-STREAM') { // Anything 'attachment' will be considered as 'application/octet-stream' so long as it is not plain text or HTML
            $disposition = $structure->ifdisposition ? strtoupper($structure->disposition) : '';
            if (
                ($disposition == 'ATTACHMENT') ||
                (
                    ($structure->type != 1) &&
                    ($structure->type != 2) &&
                    (isset($structure->bytes)) &&
                    (!in_array($part_mime_type, array('TEXT/PLAIN', 'TEXT/HTML', 'TEXT/X-VCARD', 'APPLICATION/PGP-SIGNATURE')))
                )
            ) {
                $filename = $structure->parameters[0]->value;

                if ($attachment_size_total + $structure->bytes < 1024 * 1024 * 20/*20MB is quite enough, thank you*/) {
                    $data = imap_fetchbody($stream, $msg_number, $part_number);
                    if ($structure->encoding == 3) {
                        $data = imap_base64($data);
                    } elseif ($structure->encoding == 4) {
                        $data = imap_qprint($data);
                    }

                    $attachments[$filename] = $data;

                    $attachment_size_total += $structure->bytes;
                } else {
                    $new_filename = 'errors-' . $filename . '.txt';
                    $attachments[] = array($new_filename => '20MB filesize limit exceeded');
                }
            }
        } elseif ($part_mime_type == $mime_type) { // If mime type matches
            require_code('character_sets');

            if ($part_number == '') {
                $part_number = '1';
            }
            $data = imap_fetchbody($stream, $msg_number, $part_number);

            if ($structure->encoding == 3) {
                $data = imap_base64($data);
            } elseif ($structure->encoding == 4) {
                $data = imap_qprint($data);
            }

            // Handle character set
            $full_header = imap_fetchmime($stream, $msg_number, $part_number);
            $matches = array();
            if (preg_match('#^Content-(Type|Disposition):.*;\s*charset=([\s\w\-]+)$#im', $full_header, $matches) != 0) {
                $input_charset = trim($matches[2], " \t\"'");
            }
            if ($structure->ifparameters == 1) {
                $parameters = array();
                foreach ($structure->parameters as $param) {
                    $parameters[strtolower($param->attribute)] = $param->value;
                }
                if (isset($parameters['charset'])) {
                    $input_charset = $parameters['charset'];
                }
            }
            $data = convert_to_internal_encoding($data, $input_charset);

            return $data;
        }

        if ($structure->type == 1) { // Multi-part, so recurse to scan further parts
            foreach ($structure->parts as $index => $sub_structure) {
                if ($part_number != '') {
                    $prefix = $part_number . '.';
                } else {
                    $prefix = '';
                }
                $data = $this->_imap_get_part($stream, $msg_number, $mime_type, $attachments, $attachment_size_total, $input_charset, $sub_structure, $prefix . strval($index + 1));
                if ($data !== null) {
                    return $data;
                }
            }
        }

        return null;
    }

    /**
     * Handle a case where we could not bind to a member.
     *
     * @param  EMAIL $from_email From e-mail
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     * @param  string $mail_nonmatch_policy Non-match policy
     * @set post_as_guest create_account block
     * @param  string $subject Subject line
     * @param  string $body Message body
     * @return ?MEMBER The member ID (null: none)
     */
    protected function handle_missing_member($from_email, $email_bounce_to, $mail_nonmatch_policy, $subject, $body)
    {
        $member_id = null;

        // Pre-checks to make sure our operation is actually possible
        switch ($mail_nonmatch_policy) {
            case 'create_account':
                if (get_forum_type() != 'cns') {
                    $mail_nonmatch_policy = 'block';
                    break;
                }

                require_code('type_sanitisation');
                if (!is_email_address($from_email)) {
                    $mail_nonmatch_policy = 'block';
                    break;
                }

                $i = 1;
                $_username = preg_replace('#@.*$#', '', $from_email);
                $username = $_username;
                while ($GLOBALS['FORUM_DB']->query_select_value_if_there('f_members', 'id', array('m_username' => $username)) !== null) {
                    $username = $_username . strval($i);
                    $i++;

                    if ($i >= 1000) {
                        $mail_nonmatch_policy = 'block';
                        break;
                    }
                }
        }

        switch ($mail_nonmatch_policy) {
            case 'post_as_guest':
                $member_id = $GLOBALS['FORUM_DRIVER']->get_guest_id();
                break;

            case 'create_account':
                require_code('crypt');
                $password = get_rand_password();
                require_code('cns_members_action');
                $member_id = cns_make_member($username, $password, $from_email);

                // Send creation e-mail
                $system_subject = do_lang('MAIL_INTEGRATION_AUTOMATIC_ACCOUNT_SUBJECT', $subject, $from_email, array(get_site_name(), $username), get_site_default_lang());
                $system_message = do_lang('MAIL_INTEGRATION_AUTOMATIC_ACCOUNT_MAIL', comcode_to_clean_text($body), $from_email, array($subject, get_site_name(), $username, $password), get_site_default_lang());
                $this->send_system_email($system_subject, $system_message, $from_email, $email_bounce_to);

                break;

            case 'block':
            default:
                // E-mail back, saying user not found
                $this->send_bounce_email__cannot_bind($subject, $body, $from_email, $email_bounce_to);
                break;
        }

        return $member_id;
    }

    /**
     * Find member ID for use in saving Comcode.
     *
     * @param  MEMBER $member_id Regular member ID
     * @return MEMBER Degraded member ID
     */
    protected function degrade_member_id_for_comcode($member_id)
    {
        if (has_privilege($member_id, 'comcode_dangerous')) {
            $member_id_security = $GLOBALS['FORUM_DRIVER']->get_guest_id(); // Sorry, we can't let e-mail posting with staff permissions
        } else {
            $member_id_security = $member_id;
        }
        return $member_id_security;
    }

    /**
     * Save e-mail attachments and attach to body Comcode.
     *
     * @param  array $attachments Attachments
     * @param  MEMBER $member_id Member ID
     * @param  MEMBER $member_id_comcode Member ID to save against
     * @param  string $body Comcode body (altered by reference)
     * @return array List of attachment error messages
     */
    protected function save_attachments($attachments, $member_id, $member_id_comcode, &$body)
    {
        require_code('files');
        require_code('files2');
        require_lang('mail');

        if (get_forum_type() == 'cns') {
            require_code('cns_groups');
            $max_attachments_per_post = cns_get_member_best_group_property($member_id, 'max_attachments_per_post');
            $daily_quota = cns_get_member_best_group_property($member_id, 'max_daily_upload_mb');
        } else {
            $max_attachments_per_post = null;
            $daily_quota = NON_CNS_QUOTA;
        }

        $max_download_size = intval(get_option('max_download_size')) * 1024;

        $errors = array();

        $num_attachments_handed = 0;
        foreach ($attachments as $filename => $filedata) {
            if (($max_attachments_per_post !== null) && ($max_attachments_per_post <= $num_attachments_handed)) {
                $errors[] = do_lang('MAIL_INTEGRATION_ATTACHMENT_TOO_MANY', integer_format($num_attachments_handed), integer_format($max_attachments_per_post));
                break;
            }

            if (!check_extension($filename, true, null, true, $member_id_comcode)) {
                $errors[] = do_lang('MAIL_INTEGRATION_ATTACHMENT_INVALID_TYPE', $filename);
                continue;
            }

            if (strlen($filedata) > $max_download_size) {
                $errors[] = do_lang('MAIL_INTEGRATION_ATTACHMENT_TOO_BIG', clean_file_size($max_download_size));
            }

            $max_size = get_max_file_size($member_id, null, false);
            if (strlen($filedata) > $max_size) {
                $errors[] = do_lang('MAIL_INTEGRATION_ATTACHMENT_OVER_QUOTA', clean_file_size($daily_quota * 1024 * 1024));
            }

            $new_filename = preg_replace('#\..*#', '', $filename) . '.dat';
            do {
                $new_path = get_custom_file_base() . '/uploads/attachments/' . $new_filename;
                if (file_exists($new_path)) {
                    $new_filename = uniqid('', true) . '_' . preg_replace('#\..*#', '', $filename) . '.dat';
                }
            } while (file_exists($new_path));
            cms_file_put_contents_safe($new_path, $filedata, FILE_WRITE_FIX_PERMISSIONS | FILE_WRITE_SYNC_FILE);

            $urls = array(cms_rawurlrecode('uploads/attachments/' . rawurlencode($new_filename)), '');

            require_code('upload_syndication');
            $urls[0] = handle_upload_syndication('', '', '', $urls[0], $filename, true);

            $attachment_id = $GLOBALS['SITE_DB']->query_insert('attachments', array(
                'a_member_id' => $member_id,
                'a_file_size' => strlen($filedata),
                'a_url' => $urls[0],
                'a_thumb_url' => '',
                'a_original_filename' => $filename,
                'a_num_downloads' => 0,
                'a_last_downloaded_time' => time(),
                'a_description' => '',
                'a_add_time' => time()
            ), true);
            $GLOBALS['SITE_DB']->query_insert('attachment_refs', array('r_referer_type' => 'null', 'r_referer_id' => '', 'a_id' => $attachment_id));

            $body .= "\n\n" . '[attachment framed="1" thumb="1"]' . strval($attachment_id) . '[/attachment]';

            $num_attachments_handed++;
        }

        return $errors;
    }

    /**
     * Convert e-mail HTML to Comcode.
     *
     * @param  string $body HTML body
     * @return string Comcode version
     */
    protected function email_comcode_from_html($body)
    {
        $body = unixify_line_format($body);

        // We only want inside the body
        $body = preg_replace('#.*<body[^<>]*>#is', '', $body);
        $body = preg_replace('#</body>.*#is', '', $body);

        // Cleanup some junk
        $body = str_replace(array('<<', '>>'), array('&lt;<', '>&gt;'), $body);
        $body = str_replace(array(' class="Apple-interchange-newline"', ' style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px;"', ' apple-width="yes" apple-height="yes"', '<br clear="all">', ' class="gmail_extra"', ' class="gmail_quote"', ' style="word-wrap:break-word"', ' style="word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-white-space; "'), array('', '', '', '<br />', '', '', '', ''), $body);
        $body = preg_replace('# style="text-indent:0px.*"#U', '', $body); // Apple Mail long list of styles

        // Convert quotes
        $body = preg_replace('#<div[^<>]*>On (.*) wrote:</div><br[^<>]*><blockquote[^<>]*>#i', '[quote="${1}"]', $body); // Apple Mail
        $body = preg_replace('#(<div[^<>]*>)On (.*) wrote:<br[^<>]*><blockquote[^<>]*>#i', '${1}[quote="${2}"]', $body); // gmail
        $body = preg_replace('#(\[quote="[^"]*) &lt;<.*>&gt;#U', '${1}', $body); // Remove e-mail address (Apple Mail)
        $body = preg_replace('#(\[quote="[^"]*) <span[^<>]*>&lt;<.*>&gt;</span>#U', '${1}', $body); // Remove e-mail address (gmail)
        $body = preg_replace('#<blockquote[^<>]*>#i', '[quote]', $body);
        $body = preg_replace('#</blockquote>#i', '[/quote]', $body);

        $body = preg_replace('<img [^<>]*src="cid:[^"]*"[^<>]*>', '', $body); // We will get this as an attachment instead

        // Strip signature
        do {
            $pos = strpos($body, '<div apple-content-edited="true">');
            if ($pos !== false) {
                $stack = 1;
                $len = strlen($body);
                for ($pos_b = $pos + 1; $pos_b < $len; $pos_b++) {
                    if ($body[$pos_b] == '<') {
                        if (substr($body, $pos_b, 4) == '<div') {
                            $stack++;
                        } else {
                            if (substr($body, $pos_b, 5) == '</div') {
                                $stack--;
                                if ($stack == 0) {
                                    $body = substr($body, 0, $pos) . substr($body, $pos_b);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        } while ($pos !== false);

        $body = cms_trim($body, true);

        require_code('comcode_from_html');
        $body = semihtml_to_comcode($body, true);

        // Trim too much white-space
        $body = preg_replace('#\[quote\](\s|<br />)+#s', '[quote]', $body);
        $body = preg_replace('#(\s|<br />)+\[/quote\]#s', '[/quote]', $body);
        $body = str_replace("\n\n\n", "\n\n", $body);

        // Tidy up the body
        $this->strip_system_code($body, self::STRIP_HTML);
        $body = trim($body, "- \n\r");

        return $body;
    }

    /**
     * Convert e-mail text to Comcode.
     *
     * @param  string $body Text body
     * @return string Comcode version
     */
    protected function email_comcode_from_text($body)
    {
        $body = unixify_line_format($body);

        $body = preg_replace_callback('#(\n> .*)+#', array($this, '_convert_text_quote_to_comcode'), $body);

        // Tidy up the body
        $this->strip_system_code($body, self::STRIP_TEXT);
        $body = trim($body, "- \n\r");

        return $body;
    }

    /**
     * Strip system code from an e-mail component.
     *
     * @param  string $body E-mail component
     * @param  integer $format A STRIP_* constant
     */
    abstract protected function strip_system_code(&$body, $format);

    /**
     * Process a quote block in plain-text e-mail, into a Comcode quote tag. preg callback.
     *
     * @param  array $matches preg Matches
     * @return string The result
     */
    public function _convert_text_quote_to_comcode($matches)
    {
        return '[quote]' . "\n" . trim(preg_replace('#\n> (.*)#', "\n" . '${1}', $matches[0])) . "\n" . '[/quote]';
    }

    /**
     * See if we need to skip over an e-mail message, due to it not being from a human.
     *
     * @param  string $subject Subject line
     * @param  string $body Message body
     * @param  string $full_header Message headers
     * @param  EMAIL $from_email From address
     * @return boolean Whether it should not be processed
     */
    protected function is_non_human_email($subject, $body, $full_header, $from_email)
    {
        if (array_key_exists($from_email, find_system_email_addresses())) {
            return true;
        }

        $full_header = "\r\n" . strtolower($full_header);
        if (strpos($full_header, "\r\nfrom: <>") !== false) {
            $this->log_message('Considered non-human due to: empty-from field');

            return true;
        }
        if (strpos($full_header, "\r\nauto-submitted: ") !== false && strpos($full_header, "\r\nauto-submitted: no") === false) {
            $this->log_message('Considered non-human due to: auto-submitted header');

            return true;
        }

        $junk_strings = array(
            'Delivery Status Notification',
            'Delivery Notification',
            'Returned mail',
            'Undeliverable message',
            'Mail delivery failed',
            'Failure Notice',
            'Delivery Failure',
            'Nondeliverable',
            'Undeliverable',
        );
        foreach ($junk_strings as $j) {
            if ((stripos($subject, $j) !== false) || (stripos($body, $j) !== false)) {
                $this->log_message('Considered non-human due to: recognised automated subject line');

                return true;
            }
        }
        return false;
    }

    /**
     * Try and get an e-mail address from an embedded part of an e-mail header.
     *
     * @param  string $header E-mail header
     * @return ?array A pair: E-mail address (hopefully), From name (null: failed to parse)
     */
    protected function get_email_address_from_header($header)
    {
        $addresses = imap_rfc822_parse_adrlist($header, get_domain());
        if (count($addresses) == 0) {
            return null;
        }

        return array($addresses[0]->mailbox . '@' . $addresses[0]->host, $addresses[0]->personal);
    }

    /**
     * Find the member for an e-mail address.
     *
     * @param  string $from_email E-mail address
     * @return ?MEMBER Member ID (null: none)
     */
    protected function find_member_id($from_email)
    {
        return $GLOBALS['FORUM_DRIVER']->get_member_from_email_address($from_email);
    }

    /**
     * Send out an e-mail about us having some problem(s) with attachments.
     *
     * @param  string $subject Subject line of original message
     * @param  string $body Body of original message
     * @param  EMAIL $email E-mail address we tried to bind to
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     * @param  array $errors Attachment errors
     * @param  string $url URL to content
     */
    protected function send_bounce_email__attachment_errors($subject, $body, $email, $email_bounce_to, $errors, $url)
    {
        $extended_subject = do_lang('MAIL_INTEGRATION_ATTACHMENT_ERRORS_SUBJECT', $subject, $email, array(get_site_name()), get_site_default_lang());
        $extended_message = do_lang('MAIL_INTEGRATION_ATTACHMENT_ERRORS_MAIL', comcode_to_clean_text($body), $email, array($subject, get_site_name(), implode("\n", $errors), $url), get_site_default_lang());

        $this->send_system_email($extended_subject, $extended_message, $email, $email_bounce_to);
    }

    /**
     * Send out an e-mail about us not recognising an e-mail address for an incoming e-mail.
     *
     * @param  string $subject Subject line of original message
     * @param  string $body Body of original message
     * @param  EMAIL $email E-mail address we tried to bind to
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     */
    abstract protected function send_bounce_email__cannot_bind($subject, $body, $email, $email_bounce_to);

    /**
     * Send out a system (advisory) e-mail.
     *
     * @param  string $subject Subject line of original message
     * @param  string $body Body of original message
     * @param  EMAIL $email E-mail address we were to bind to
     * @param  EMAIL $email_bounce_to E-mail address of sender (usually the same as $email, but not if it was a forwarded e-mail)
     */
    protected function send_system_email($subject, $body, $email, $email_bounce_to)
    {
        $from_email = $this->get_system_email();

        require_code('mail');
        mail_wrap($subject, $body, array($email_bounce_to), null, $from_email, '', 2);
    }
}
