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
 * @package    core_cns
 */

/**
 * Block class.
 */
class Block_main_join
{
    /**
     * Find details of the block.
     *
     * @return ?array Map of block info (null: block is disabled).
     */
    public function info()
    {
        if (get_forum_type() != 'cns') {
            return null;
        }

        $info = array();
        $info['author'] = 'Chris Graham';
        $info['organisation'] = 'ocProducts';
        $info['hacked_by'] = null;
        $info['hack_version'] = null;
        $info['version'] = 2;
        $info['locked'] = false;

        $info['parameters'] = array('subject', 'path', 'to', 'captcha', 'dobs', 'member_email_receipt_configurability', 'staff_email_receipt_configurability', 'enable_timezones', 'enable_language_selection', 'guid');
        // ^ You can also pass in field_<id> to make a CPF onto the join form or not.
        // Also you can set is_on_invites, spam_check_level, email_confirm_join, require_new_member_validation, is_on_coppa, valid_email_domains, one_per_email_address

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
        cns_require_all_forum_stuff();
        require_css('cns');
        require_code('cns_members_action');
        require_code('cns_members_action2');
        require_code('cns_join');

        $guid = isset($map['guid']) ? $map['guid'] : '2953c83685df4970de8f23fcd5dd15bb';

        $captcha_if_enabled = (!isset($map['captcha'])) || ($map['captcha'] == '1');

        if (!array_key_exists('path', $map)) {
            $map['path'] = 'uploads/website_specific/join.txt';
        }

        $options_overridden_as_binary = array(
            'dobs',
            'member_email_receipt_configurability',
            'staff_email_receipt_configurability',
            'enable_timezones',
            'enable_language_selection',
        );
        $adjusted_config_options = array();
        foreach ($map as $key => $val) {
            if ($val != '') {
                if ((in_array($key, $options_overridden_as_binary)) && ($val == '1')) {
                    $val = '2'; // Actually '2' means show on the join form, not '1' -- so remap to that
                }

                $adjusted_config_options[$key] = $val;
            }
        }

        // Already logged in?
        if (!is_guest()) {
            $email_address = $GLOBALS['FORUM_DRIVER']->get_member_email_address(get_member());

            if (post_param_integer('_send_document', 0) == 1) {
                $email_sent = $this->send_email($map, $email_address);
            } else {
                $email_sent = false;
            }

            return do_template('BLOCK_MAIN_JOIN_DONE', array(
                '_GUID' => $guid,
                'MESSAGE' => null,
                'LOGGED_IN' => true,
                'HAS_EMAIL_TO_SEND' => $this->has_email_to_send($map),
                'EMAIL_ADDRESS' => $email_address,
                'EMAIL_SENT' => $email_sent,
            ));
        }

        // Joining now?
        if (post_param_integer('joining', 0) == 1) {
            check_joining_allowed($adjusted_config_options);

            list($message, , $ready) = cns_join_actual($captcha_if_enabled, false, true, true, null, null, null, null, $adjusted_config_options);

            $email_address = post_param_string('email_address', '');
            $email_sent = $this->send_email($map, $email_address);

            if ($ready) {
                $message = null; // No message required
            }

            return do_template('BLOCK_MAIN_JOIN_DONE', array(
                '_GUID' => $guid,
                'MESSAGE' => $message,
                'LOGGED_IN' => $ready,
                'HAS_EMAIL_TO_SEND' => $this->has_email_to_send($map),
                'EMAIL_ADDRESS' => $email_address,
                'EMAIL_SENT' => $email_sent,
            ));
        }

        // Join form
        $post_url = get_self_url();
        $form = cns_join_form($post_url, $captcha_if_enabled, false, true, $adjusted_config_options);
        return do_template('BLOCK_MAIN_JOIN', array(
            '_GUID' => $guid,
            'FORM' => $form,
            'HAS_EMAIL_TO_SEND' => $this->has_email_to_send($map),
        ));
    }

    /**
     * See if there is an e-mail to send.
     *
     * @param  array $map A map of parameters.
     * @return boolean If there is.
     */
    protected function has_email_to_send($map)
    {
        return file_exists(get_custom_file_base() . '/' . $map['path']);
    }

    /**
     * Send the e-mail with the document.
     *
     * @param  array $map A map of parameters.
     * @param  EMAIL $email_address The e-mail address.
     * @return boolean If it worked.
     */
    protected function send_email($map, $email_address)
    {
        if ($email_address != '') {
            if ($this->has_email_to_send($map)) {
                require_code('character_sets');
                $url = (url_is_local($map['path']) ? (get_custom_base_url() . '/') : '') . $map['path'];
                $subject = empty($map['subject']) ? do_lang('_WELCOME') : $map['subject'];
                $http_result = cms_http_request($url);
                $body = convert_to_internal_encoding($http_result->data, $http_result->charset);
                foreach ($_POST as $key => $val) {
                    if (is_string($val)) {
                        $body = str_replace('{' . $key . '}', $val, $body);
                    }
                }
                require_code('mail');
                dispatch_mail($subject, $body, array($email_address), array_key_exists('to', $map) ? $map['to'] : '', '', '', array('as_admin' => true));

                return true;
            }
        }

        return false;
    }
}
