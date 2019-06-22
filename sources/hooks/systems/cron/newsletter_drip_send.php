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
 * @package    newsletter
 */

/**
 * Hook class.
 */
class Hook_cron_newsletter_drip_send
{
    /**
     * Get info from this hook.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     * @param  boolean $calculate_num_queued Calculate the number of items queued, if possible
     * @return ?array Return a map of info about the hook (null: disabled)
     */
    public function info($last_run, $calculate_num_queued)
    {
        if (!addon_installed('newsletter')) {
            return null;
        }

        return array(
            'label' => 'Send queued newsletters',
            'num_queued' => $calculate_num_queued ? $GLOBALS['SITE_DB']->query_select_value('newsletter_drip_send', 'COUNT(*)') : null,
            'minutes_between_runs' => intval(get_option('minutes_between_sends')),
        );
    }

    /**
     * Run function for system scheduler scripts. Searches for things to do. ->info(..., true) must be called before this method.
     *
     * @param  ?TIME $last_run Last time run (null: never)
     */
    public function run($last_run)
    {
        $mails_per_send = intval(get_option('mails_per_send'));
        $minutes_between_sends = intval(get_option('minutes_between_sends'));

        $time = time();
        $last_time = intval(get_value('last_newsletter_drip_send', null, true));
        if (($last_time > time() - $minutes_between_sends * 60) && (!/*we do allow an admin to force it by Cron URL*/$GLOBALS['FORUM_DRIVER']->is_super_admin(get_member()))) {
            return;
        }
        set_value('last_newsletter_drip_send', strval($time), true);

        require_lang('newsletter');

        $to_send = $GLOBALS['SITE_DB']->query_select('newsletter_drip_send', array('*'), array(), 'ORDER BY id DESC', $mails_per_send); // From disk-end, for maximum performance (truncating files to mark done is quicker?)
        if (count($to_send) != 0) {
            // These variables are for optimisation, we detect if we can avoid work on the loop iterations via looking at what happened on the first
            $needs_substitutions = null;
            $needs_tempcode = null;

            // Quick cleanup for maximum performance
            $id_list = '';
            foreach ($to_send as $mail) {
                if ($id_list != '') {
                    $id_list .= ' OR ';
                }
                $id_list .= 'id=' . strval($mail['id']);
            }
            $GLOBALS['SITE_DB']->query('DELETE FROM ' . get_table_prefix() . 'newsletter_drip_send WHERE ' . $id_list, null, 0, false, true);

            // We'll cache messages here
            $cached_messages = array();

            // Send
            require_code('newsletter');
            require_code('mail');
            foreach ($to_send as $mail) {
                $message_id = $mail['d_message_id'];
                list($forename, $surname, $username, $id, $hash) = json_decode($mail['d_message_binding'], true);

                // Load message
                if (!isset($cached_messages[$message_id])) {
                    $newsletter_archive_rows = $GLOBALS['SITE_DB']->query_select('newsletter_archive', array('*'), array('id' => $message_id), '', 1);
                    $cached_messages[$message_id] = $newsletter_archive_rows[0];
                }
                $message_row = $cached_messages[$message_id];
                $lang = $message_row['language'];
                $message = $message_row['newsletter'];
                $subject = $message_row['subject'];
                $from_email = $message_row['from_email'];
                $from_name = $message_row['from_name'];
                $priority = $message_row['priority'];
                $template = $message_row['template'];
                $html_only = $message_row['html_only'];

                // Variable substitution in body
                if ($needs_substitutions === null || $needs_substitutions) {
                    $newsletter_message_substituted = (strpos($message, '{') === false) ? $message : newsletter_variable_substitution($message, $subject, $forename, $surname, $username, $mail['d_to_email'], $id, $hash);

                    if ($needs_substitutions === null) {
                        $needs_substitutions = ($newsletter_message_substituted != $message);
                    }
                } else {
                    $newsletter_message_substituted = $message;
                }
                $in_html = false;
                if (stripos(trim($message), '<') === 0) { // HTML
                    if ($needs_tempcode === null || $needs_tempcode) {
                        require_code('tempcode_compiler');
                        $_m = template_to_tempcode($newsletter_message_substituted);
                        $temp = $_m->evaluate($lang);

                        if ($needs_tempcode === null) {
                            $needs_tempcode = (trim($temp) != trim($newsletter_message_substituted));
                        }

                        $newsletter_message_substituted = $temp;
                    }
                    $in_html = true;
                } else { // Comcode
                    if ($html_only == 1) {
                        $_m = comcode_to_tempcode($newsletter_message_substituted, get_member(), true);
                        $newsletter_message_substituted = $_m->evaluate($lang);
                        $in_html = true;
                    }
                }

                dispatch_mail(
                    $subject,
                    $newsletter_message_substituted,
                    array($mail['d_to_email']),
                    array($mail['d_to_name']),
                    $from_email,
                    $from_name,
                    array(
                        'priority' => $priority,
                        'no_cc' => true,
                        'as_admin' => true,
                        'in_html' => ($html_only == 1),
                        'mail_template' => $template,
                        'bypass_queue' => true,
                        'smtp_sockets_use' => (get_option('newsletter_smtp_sockets_use') == '1'),
                        'smtp_sockets_host' => get_option('newsletter_smtp_sockets_host'),
                        'smtp_sockets_port' => intval(get_option('newsletter_smtp_sockets_port')),
                        'smtp_sockets_username' => get_option('newsletter_smtp_sockets_username'),
                        'smtp_sockets_password' => get_option('newsletter_smtp_sockets_password'),
                        'smtp_from_address' => get_option('newsletter_smtp_from_address'),
                        'enveloper_override' => (get_option('newsletter_enveloper_override') == '1'),
                        'allow_ext_images' => (get_option('newsletter_allow_ext_images') == '1'),
                        'website_email' => get_option('newsletter_website_email'),
                        'is_bulk' => true,
                    )
                );
            }
        }
    }
}
