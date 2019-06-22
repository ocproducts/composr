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
 * @package    core
 */

/*EXTRA FUNCTIONS: imap\_.+|proc\_.+|stream_set_blocking|stream_get_contents|stream_set_timeout*/

/**
 * Spam check an e-mail.
 *
 * @param  string $mime_email The e-mail
 * @return array A tuple: The spam report, and the spam score, raw response, HTTP message
 */
function email_spam_check($mime_email)
{
    $spam_report = null;
    $spam_score = null;

    $_spam_test = cms_http_request('http://spamcheck.postmarkapp.com/filter', array('trigger_error' => false, 'raw_post' => true, 'post_params' => array(json_encode(array('email' => $mime_email, 'options' => 'long'))), 'raw_content_type' => 'application/json'));
    if ($_spam_test->data != '') {
        $spam_test = @json_decode($_spam_test->data, true);
        if (($spam_test !== null) && (isset($spam_test['success'])) && (isset($spam_test['report'])) && (isset($spam_test['score']))) {
            if ($spam_test['success']) {
                $spam_report = $spam_test['report'];
                $spam_score = $spam_test['score'];
            }
        }
    }

    return array($spam_report, $spam_score, $_spam_test->data, $_spam_test->message);
}


/**
 * Get an IMAP/POP3 connection string.
 *
 * @param  string $host The hostname
 * @param  integer $port The port
 * @param  ?string $type The protocol (null: autodetect)
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @return string Connection string
 *
 * @ignore
 */
function _imap_server_spec($host, $port, $type = null)
{
    if ($type === 'pop3' || $type === 'pop3s' || $type === 'pop3s_nocert' || $type === 'pop3t' || $type === 'pop3t_nocert') {
        $is_pop3 = true;
    } elseif ($type === 'imap' || $type === 'imaps' || $type === 'imaps_nocert' || $type === 'imapt' || $type === 'imapt_nocert') {
        $is_pop3 = false;
    } else {
        $is_pop3 = (strpos($host, 'pop') !== false || $port == 110 || $port == 995);
    }

    if ($is_pop3) {
        if ($type === null) {
            $ssl = ($port == 995);
            $starttls = false;
            $nocert = true;
        } else {
            $ssl = ($type == 'pop3s' || $type == 'pop3s_nocert');
            $starttls = ($type == 'pop3t' || $type == 'pop3t_nocert');
            $nocert = ($type == 'pop3s_nocert' || $type == 'pop3t_nocert');
        }
        $server_special_details = '/pop3';
    } else {
        if ($type === null) {
            $ssl = ($port == 993);
            $starttls = false;
            $nocert = true;
        } else {
            $ssl = ($type == 'imaps' || $type == 'imaps_nocert');
            $starttls = ($type == 'imapt' || $type == 'imapt_nocert');
            $nocert = ($type == 'imaps_nocert' || $type == 'imapt_nocert');
        }
        $server_special_details = '/imap';
    }

    if ($ssl || $starttls) {
        //$server_special_details .= '/secure'; "do not transmit a plaintext password over the network", causes issue with gmail ("Can't do secure authentication with this server")
        if ($ssl) {
            $server_special_details .= '/ssl';
        }
        if ($starttls) {
            $server_special_details .= '/tls';
        }
        if ($nocert) {
            $server_special_details .= '/novalidate-cert';
        } else {
            $server_special_details .= '/validate-cert';
        }
    } else {
        $server_special_details .= '/notls';
    }

    return '{' . $host . ':' . strval($port) . $server_special_details . '}';
}

/**
 * Find IMAP/POP3 folders.
 *
 * @param  string $host The server hostname
 * @param  integer $port The port
 * @param  ?string $type The protocol (null: autodetect)
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @param  string $username The username
 * @param  string $password The password
 * @return array Map of folders (codenames to display labels)
 */
function find_mail_folders($host, $port, $type, $username, $password)
{
    if (!function_exists('imap_open')) {
        warn_exit(do_lang_tempcode('IMAP_NEEDED'));
    }

    $server_spec = _imap_server_spec($host, $port, $type);
    $mbox = @imap_open($server_spec . 'INBOX', $username, $password);
    if ($mbox === false) {
        $error = imap_last_error();
        imap_errors(); // Works-around weird PHP bug where "Retrying PLAIN authentication after [AUTHENTICATIONFAILED] Authentication failed. (errflg=1) in Unknown on line 0" may get spit out into any stream (even the backup log)
        warn_exit(do_lang_tempcode('IMAP_ERROR', $error));
    }
    $_folders = imap_list($mbox, $server_spec, '*');

    $folders = array();
    foreach ($_folders as $folder) {
        $folder = preg_replace('#\{[^{}]+\}#', '', $folder);
        $label = preg_replace('#@.*$#', '', $folder);
        $folders[$folder] = $label;
    }

    return $folders;
}

/**
 * Find if a member can be e-mailed.
 *
 * @param  MEMBER $member_id The member ID
 * @param  ?string $host The server hostname (null: use configured)
 * @param  ?integer $port The port (null: use configured)
 * @param  ?string $type The protocol (null: use configured / autodetect)
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @param  ?string $folder The inbox identifier (null: use configured)
 * @param  ?string $username The username (null: use configured)
 * @param  ?string $password The password (null: use configured)
 * @return ?TIME Last bounce time (null: not bounced)
 */
function can_email_member($member_id, $host = null, $port = null, $type = null, $folder = null, $username = null, $password = null)
{
    $email = $GLOBALS['FORUM_DRIVER']->get_member_email_address($member_id);
    if ($email == '') {
        return null;
    }

    return is_mail_bounced($email, $host, $port, $folder, $username, $password);
}

/**
 * Find if an e-mail address is bounced.
 *
 * @param  EMAIL $email The e-mail address
 * @param  ?string $host The server hostname (null: use configured)
 * @param  ?integer $port The port (null: use configured)
 * @param  ?string $type The protocol (null: use configured / autodetect)
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @param  ?string $folder The inbox identifier (null: use configured)
 * @param  ?string $username The username (null: use configured)
 * @param  ?string $password The password (null: use configured)
 * @return ?TIME Last bounce time (null: not bounced)
 */
function is_mail_bounced($email, $host = null, $port = null, $type = null, $folder = null, $username = null, $password = null)
{
    if ($email == '') {
        return null;
    }

    if ($host === null) {
        $host = get_option('mail_server_host');
        $port = intval(get_option('mail_server_port'));
        $folder = get_option('mail_folder');
        $username = get_option('mail_username');
        $password = get_option('mail_password');
    }

    if ($password == '' || !function_exists('imap_open')) {
        return null; // Not configured, so cannot proceed
    }

    static $update_since = null;
    if ($update_since === null) {
        $update_since = $GLOBALS['SITE_DB']->query_select_value_if_there('email_bounces', 'MAX(b_time)');
    }
    update_bounce_storage($host, $port, $type, $folder, $username, $password, $update_since);

    return $GLOBALS['SITE_DB']->query_select_value_if_there('email_bounces', 'MAX(b_time)', array('b_email_address' => $email));
}

/**
 * Update the details in our bounce storage table, by looking at received bounces.
 *
 * @param  string $host The server hostname
 * @param  integer $port The port
 * @param  string $type The protocol
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @param  string $folder The inbox identifier
 * @param  string $username The username
 * @param  string $password The password
 * @param  ?TIME $since Only find bounces since this date (null: 8 weeks ago). This is approximate, we will actually look from a bit further back to compensate for possible timezone differences
 */
function update_bounce_storage($host, $port, $type, $folder, $username, $password, $since = null)
{
    if ($since === null) {
        $since = time() - 60 * 60 * 24 * 7 * 8;
    } else {
        static $done_in_session = false;
        if ($since > time() - 10) {
            return;
        }
        if ($done_in_session) {
            return;
        }
        $done_in_session = true;
    }

    $bounces = _find_mail_bounces($host, $port, $type, $folder, $username, $password, true, $since);
    foreach ($bounces as $email => $_details) {
        list($subject, $is_bounce, $time, $body) = $_details;

        $GLOBALS['SITE_DB']->query_delete('email_bounces', array(
            'b_email_address' => $email,
            'b_time' => $time,
            'b_subject' => $subject,
            'b_body' => $body,
        ), '', 1);
        $GLOBALS['SITE_DB']->query_insert('email_bounces', array(
            'b_email_address' => $email,
            'b_time' => $time,
            'b_subject' => $subject,
            'b_body' => $body,
        ));
    }
}

/**
 * Find bounces in an IMAP/POP3 folder, with DB caching.
 *
 * @param  string $host The server hostname
 * @param  integer $port The port
 * @param  string $type The protocol
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @param  string $folder The inbox identifier
 * @param  string $username The username
 * @param  string $password The password
 * @param  ?TIME $since Only find bounces since this date (null: 8 weeks ago). This is approximate, we will actually look from a bit further back to compensate for possible timezone differences
 * @return array Bounces (a map between email address and details of the bounce)
 */
function find_mail_bounces($host, $port, $type, $folder, $username, $password, $since = null)
{
    if ($since === null) {
        $since = time() - 60 * 60 * 24 * 7 * 8;
    }
    $update_since = $GLOBALS['SITE_DB']->query_select_value_if_there('email_bounces', 'MAX(b_time)');
    if ($update_since === null) {
        $update_since = 0;
    }
    $_since = max($since, $update_since);
    if ($_since == 0) {
        $_since = null;
    }

    update_bounce_storage($host, $port, $type, $folder, $username, $password, $_since);

    $_ret = $GLOBALS['SITE_DB']->query_select('email_bounces', array('b_email_address', 'b_subject', 'b_time', 'b_body'), array(), 'ORDER BY b_time');
    $ret = array();
    foreach ($_ret as $r) {
        $ret[$r['b_email_address']] = array($r['b_subject'], true, $r['b_time'], $r['b_body']);
    }
    return $ret;
}

/**
 * Find bounces in an IMAP/POP3 folder.
 *
 * @param  string $host The server hostname
 * @param  integer $port The port
 * @param  string $type The protocol
 * @set imap imaps imaps_nocert pop3 pop3s pop3s_nocert
 * @param  string $folder The inbox identifier
 * @param  string $username The username
 * @param  string $password The password
 * @param  boolean $bounces_only Only find bounces (otherwise will find anything)
 * @param  ?TIME $since Only find bounces since this date (null: no limit). This is approximate, we will actually look from a bit further back to compensate for possible timezone differences
 * @return array Bounces (a map between email address and details of the bounce)
 *
 * @ignore
 */
function _find_mail_bounces($host, $port, $type, $folder, $username, $password, $bounces_only = true, $since = null)
{
    if (!function_exists('imap_open')) {
        warn_exit(do_lang_tempcode('IMAP_NEEDED'));
    }

    require_code('type_sanitisation');

    disable_php_memory_limit(); // In case of a huge number

    $server_spec = _imap_server_spec($host, $port, $type);
    $mbox = @imap_open($server_spec . $folder, $username, $password);
    if ($mbox === false) {
        $error = imap_last_error();
        imap_errors(); // Works-around weird PHP bug where "Retrying PLAIN authentication after [AUTHENTICATIONFAILED] Authentication failed. (errflg=1) in Unknown on line 0" may get spit out into any stream (even the backup log)
        warn_exit(do_lang_tempcode('IMAP_ERROR', $error), false, true);
    }

    $out = array();

    $filter = 'UNDELETED';
    if ($since !== null) {
        $filter .= ' SINCE "' . gmdate('j-M-Y', $since - 60 * 60 * 24) . '"';
    }
    $messages = imap_search($mbox, $filter);
    if ($messages === false) {
        $messages = array();
    }
    sort($messages); // Date order, approximately
    $num = 0;
    foreach ($messages as $val) {
        $body = imap_body($mbox, $val);
        $header = imap_fetchheader($mbox, $val);

        $is_bounce =
            // Proper failure header
            (strpos($header, 'X-Failed-Recipients') !== false)

            // Failure message coming from our end
            || (strpos($body, 'Delivery to the following recipient failed permanently') !== false)

            // SMTP error codes (http://www.greenend.org.uk/rjk/tech/smtpreplies.html)
            || (preg_match('#421 .* Service not available#', $body) != 0)
            || (strpos($body, '450 Requested mail action not taken') !== false)
            || (strpos($body, '451 Requested action aborted') !== false)
            || (strpos($body, '452 Requested action not taken') !== false)
            || (preg_match('#521 .* does not accept mail#', $body) != 0)
            || (strpos($body, '530 Access denied') !== false)
            || (strpos($body, '550 Requested action not taken') !== false)
            || (strpos($body, '550 No such recipient') !== false)
            || (strpos($body, '550 ') !== false) // Actually allow any 550's
            || (strpos($body, '551 User not local') !== false)
            || (strpos($body, '552 Requested mail action aborted') !== false)
            || (strpos($body, '553 Requested action not taken') !== false)
            || (strpos($body, '554 Transaction failed') !== false)

            // Enhanced Mail System Status Codes (http://tools.ietf.org/html/rfc3463 / http://www.iana.org/assignments/smtp-enhanced-status-codes/smtp-enhanced-status-codes.xhtml)
            || (preg_match('#\s(4|5)\.\d+\.\d+\s#', $body) != 0);

        if ($is_bounce || !$bounces_only) {
            if (strpos($header, 'X-Failed-Recipients') !== false) { // Best way
                $overview = imap_headerinfo($mbox, $val);

                $matches2 = array();
                preg_match('#X-Failed-Recipients:\s*([^\"\n<>@]+@[^\n<>@]+)#', $header, $matches2);
                $email = str_replace('@localhost.localdomain', '', $matches2[1]);
                if (($email != get_option('staff_address')) && ($email != get_option('website_email')) && (is_email_address($email)) && ((!isset($out[$email])) || (!$out[$email][1]))) {
                    $out[$email] = array($overview->subject, $is_bounce, strtotime($overview->date), $body);
                }
            } else {
                $overview = imap_headerinfo($mbox, $val);

                $matches = array();

                // Find e-mail addresses in body
                // (message/content IDs look similar, avoid those, also avoid routine headers)
                $_body = preg_replace('#"[^"]*" #', '', $body); // Strip out quoted name before e-mail address, to put e-mail address right after header so that our backreference assertions work
                $_body = preg_replace('#: .* <([^"\n<>@]+@[^\n<>@]+)>#', ': <$1>', $_body); // Also strip unquoted names
                $_body = preg_replace('#(Message-ID: |Content-ID: |Return-Path: |From: |Reply-To: |X-Sender: |X-Google-Original-From: )<([^"\n<>@]+@[^\n<>@]+)>#', '', $_body); // Also strip unwanted headers
                $num_matches = preg_match_all('#<([^"\n<>@]+@[^\n<>@]+)>#i', $_body, $matches);
                if ($num_matches == 0) {
                    $num_matches = preg_match_all('#([\w\.\-\+]+@[\w\.\-]+)#i', $_body, $matches); // Try less explicit but stricter formed e-mail addresses
                }

                for ($i = 0; $i < $num_matches; $i++) {
                    $email = str_replace('@localhost.localdomain', '', $matches[1][$i]);

                    if (($email != get_option('staff_address')) && ($email != get_option('website_email')) && (is_email_address($email)) && ((!isset($out[$email])) || (!$out[$email][1]))) {
                        $out[$email] = array($overview->subject, $is_bounce, strtotime($overview->date), $body);
                    }
                }
            }
        }
    }
    imap_close($mbox);

    return $out;
}

/**
 * E-mail dispatcher object. Handles the actual delivery of an e-mail over a process call.
 *
 * @package    core
 */
class Mail_dispatcher_manualproc extends Mail_dispatcher_base
{
    /**
     * Construct e-mail dispatcher.
     *
     * @param  array $advanced_parameters List of advanced parameters
     */
    public function __construct($advanced_parameters = array())
    {
        $this->line_term = "\n";

        parent::__construct($advanced_parameters);
    }

    /**
     * Find whether the dispatcher instance is capable of sending e-mails.
     *
     * @param  array $advanced_parameters List of advanced parameters
     * @return boolean Whether the dispatcher instance is capable of sending e-mails
     */
    public function is_dispatcher_available($advanced_parameters)
    {
        return true;
    }

    /**
     * Implementation-specific e-mail dispatcher, passed with pre-prepared/tidied e-mail component details for us to use.
     *
     * @param  array $to_emails To e-mail addresses
     * @param  array $to_names To names
     * @param  EMAIL $from_email From e-mail address
     * @param  string $from_name From name
     * @param  string $subject_wrapped Subject line
     * @param  string $headers Headers to use
     * @param  string $sending_message Full MIME message
     * @param  string $charset Character set to use
     * @param  string $html_evaluated Full HTML message (is also inside $sending_message, so we won't use this unless we are not using $sending_message)
     * @param  string $message_plain Full text message (is also inside $sending_message, so we won't use this unless we are not using $sending_message)
     * @return array A pair: Whether it worked, and an error message
     */
    protected function _dispatch($to_emails, $to_names, $from_email, $from_name, $subject_wrapped, $headers, $sending_message, $charset, $html_evaluated, $message_plain)
    {
        $worked = false;
        $error = null;

        $worked = false;
        foreach ($to_emails as $i => $_to_email) {
            $additional = '';
            if (($this->enveloper_override) && ($this->website_email != '')) {
                $additional = '-f ' . $this->website_email;
            }
            $_to_name = $to_names[$i];
            if ($_to_email == $_to_name) {
                $to_line = $_to_email;
            } else {
                $to_line = '"' . $_to_name . '" <' . $_to_email . '>';
            }

            if (function_exists('error_clear_last')) {
                error_clear_last();
            }
            $worked = $this->manualproc_mail($to_line, $subject_wrapped, $sending_message, $headers, $additional);
            if (!$worked) {
                $error = cms_error_get_last();
            }
        }

        return array($worked, $error);
    }

    /**
     * Send an e-mail.
     *
     * @param  string $to The TO address
     * @param  string $subject The subject
     * @param  string $message The message
     * @param  string $additional_headers Additional headers
     * @param  string $additional_flags Additional stuff to send to sendmail executable
     * @return boolean Success status
     */
    protected function manualproc_mail($to, $subject, $message, $additional_headers, $additional_flags = '')
    {
        $descriptorspec = array(
            0 => array('pipe', 'r'), // stdin is a pipe that the child will read from
            1 => array('pipe', 'w'), // stdout is a pipe that the child will write to
            2 => array('pipe', 'w'), // stderr is a file to write to
        );
        $pipes = array();
        if (substr($additional_flags, 0, 1) != ' ') {
            $additional_flags = ' ' . $additional_flags;
        }
        //$additional_flags.=' -v';     mini_sendmail puts everything onto stderr if using this https://github.com/mattrude/mini_sendmail/blob/master/mini_sendmail.c
        $command = ini_get('sendmail_path') . $additional_flags;
        $handle = @proc_open($command, $descriptorspec, $pipes);
        if ($handle !== false) {
            fprintf($pipes[0], "To: %s\n", $to);
            fprintf($pipes[0], "Subject: %s\n", $subject);
            fprintf($pipes[0], "%s\n", $additional_headers);
            fprintf($pipes[0], "\n%s\n", $message);
            fclose($pipes[0]);

            $test = proc_get_status($handle);

            $retmsg = '';
            $stdout = stream_get_contents($pipes[1]);
            $retmsg .= $stdout;
            fclose($pipes[1]);
            $stderr = stream_get_contents($pipes[2]);
            $retmsg .= $stderr;
            fclose($pipes[2]);

            if (!$test['running']) {
                $retcode = $test['exitcode'];
            } else {
                $retcode = proc_close($handle);
            }
            if (($retcode == -1) && ($stderr == '')) {
                $retcode = 0; // https://bugs.php.net/bug.php?id=29123
            }

            if ($retcode != 0) {
                trigger_error('Sendmail error code: ' . strval($retcode) . ' [' . $retmsg . ']', E_USER_WARNING);
                return false;
            }
        } else {
            trigger_error('Could not connect to sendmail process', E_USER_WARNING);
            return false;
        }
        return true;
    }
}
