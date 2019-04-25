<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2018

 See text/EN/licence.txt for full licensing information.


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
 * Give error if Conversr-joining is not possible on this site.
 *
 * @param  ?array $adjusted_config_options A map of adjusted config options (null: none)
 */
function check_joining_allowed($adjusted_config_options = null)
{
    if (get_forum_type() != 'cns') {
        warn_exit(do_lang_tempcode('NO_CNS'));
    }

    require_code('cns_members_action');

    // Check RBL's/stopforumspam
    $spam_check_level = get_option_with_overrides('spam_check_level', $adjusted_config_options);
    if (($spam_check_level == 'EVERYTHING') || ($spam_check_level == 'ACTIONS') || ($spam_check_level == 'GUESTACTIONS') || ($spam_check_level == 'JOINING')) {
        require_code('antispam');
        check_for_spam(null, null, false);
    }

    global $LDAP_CONNECTION;
    if (($LDAP_CONNECTION !== null) && (get_option('ldap_allow_joining', true) === '0')) {
        warn_exit(do_lang_tempcode('JOIN_DISALLOW'));
    }
}

/**
 * Get the join form.
 *
 * @param  Tempcode $url URL to direct to
 * @param  boolean $captcha_if_enabled Whether to handle CAPTCHA (if enabled at all)
 * @param  boolean $intro_message_if_enabled Whether to ask for intro messages (if enabled at all)
 * @param  boolean $invites_if_enabled Whether to check for invites (if enabled at all)
 * @param  ?array $adjusted_config_options A map of adjusted config options (null: none)
 * @return Tempcode The form
 */
function cns_join_form($url, $captcha_if_enabled = true, $intro_message_if_enabled = true, $invites_if_enabled = true, $adjusted_config_options = null)
{
    cns_require_all_forum_stuff();

    require_css('cns');
    require_code('cns_members_action');
    require_code('cns_members_action2');
    require_code('form_templates');

    $_lead_source_description = either_param_string('_lead_source_description', do_lang('JOINED'));

    $hidden = new Tempcode();
    $hidden->attach(build_keep_post_fields(($_lead_source_description == '') ? array() : array('_lead_source_description')));

    $hidden->attach(form_input_hidden('_joining', '0'));

    if ($_lead_source_description != '') {
        $hidden->attach(form_input_hidden('_lead_source_description', $_lead_source_description));
    }

    $groups = cns_get_all_default_groups(true);
    $primary_group = either_param_integer('primary_group', null);
    if (($primary_group !== null) && (!in_array($primary_group, $groups))) {
        // Check security
        $test = $GLOBALS['FORUM_DB']->query_select_value('f_groups', 'g_is_presented_at_install', array('id' => $primary_group));
        if ($test == 1) {
            $groups = cns_get_all_default_groups(false);
            $hidden->attach(form_input_hidden('primary_group', strval($primary_group)));
            $groups[] = $primary_group;
        }
    }

    url_default_parameters__enable();
    list($fields, $_hidden, $added_section) = cns_get_member_fields(true, '', null, '', '', null, $groups, null, null, null, null, null, null, null, 0, 1, 1, null, null, null, 1, null, 1, 1, 0, '*', '', 1, null, 0, $adjusted_config_options);
    url_default_parameters__disable();
    $hidden->attach($_hidden);

    if ($intro_message_if_enabled) {
        $forum_id = get_option('intro_forum_id');
        if ($forum_id != '') {
            $fields->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => 'b8197832e4467b08e953535202235501', 'TITLE' => do_lang_tempcode('INTRODUCE_YOURSELF'))));
            $fields->attach(form_input_line(do_lang_tempcode('TITLE'), '', 'intro_title', do_lang('INTRO_POST_DEFAULT', '___'), false));
            $fields->attach(form_input_text_comcode(do_lang_tempcode('POST_COMMENT'), do_lang_tempcode('DESCRIPTION_INTRO_POST'), 'intro_post', '', false));
        }
    }

    if (($captcha_if_enabled) && (get_option('recaptcha_site_key') == '') && ($added_section)) {
        $fields->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => 'a8197832e4467b08e953535202235501', 'TITLE' => do_lang_tempcode('SPECIAL_REGISTRATION_FIELDS'))));
    }

    /*PSEUDO-HOOK: cns_join_form special fields*/

    $text = do_lang_tempcode('ENTER_PROFILE_DETAILS');

    if ($captcha_if_enabled) {
        if (addon_installed('captcha')) {
            require_code('captcha');
            if (use_captcha()) {
                $fields->attach(form_input_captcha($hidden));
                $text->attach(' ');
                $text->attach(do_lang_tempcode('FORM_TIME_SECURITY'));
            }
        }
    }

    $submit_name = do_lang_tempcode('PROCEED');

    return do_template('JOIN_FORM', array(
        '_GUID' => 'f6dba5638ae50a04562df50b1f217311',
        'TEXT' => '',
        'HIDDEN' => $hidden,
        'FIELDS' => $fields,
        'SUBMIT_ICON' => 'menu/site_meta/user_actions/join',
        'SUBMIT_NAME' => $submit_name,
        'URL' => $url,
        'ANALYTIC_EVENT_CATEGORY' => do_lang('_JOIN'),
        'USERNAME_CHECK_SCRIPT' => find_script('username_check'),
        'SNIPPET_SCRIPT' => find_script('snippet'),
        'INVITES_ENABLED' => $invites_if_enabled && (get_option_with_overrides('is_on_invites', $adjusted_config_options) == '1'),
        'ONE_PER_EMAIL_ADDRESS' => (get_option_with_overrides('one_per_email_address', $adjusted_config_options) != '0'),
        'USE_CAPTCHA' => $captcha_if_enabled && addon_installed('captcha') && use_captcha(),
    ));
}

/**
 * Actualise the join form.
 *
 * @param  boolean $captcha_if_enabled Whether to handle CAPTCHA (if enabled at all)
 * @param  boolean $intro_message_if_enabled Whether to ask for intro messages (if enabled at all)
 * @param  boolean $invites_if_enabled Whether to check for invites (if enabled at all)
 * @param  boolean $instant_login Whether to instantly log the user in
 * @param  ?ID_TEXT $username Username (null: read from environment)
 * @param  ?EMAIL $email_address E-mail address (null: read from environment)
 * @param  ?string $password Password (null: read from environment)
 * @param  ?array $actual_custom_fields Custom fields to save (null: read from environment)
 * @param  ?array $adjusted_config_options A map of adjusted config options (null: none)
 * @return array A tuple: Messages to show, member ID of new member, whether the account is ready
 */
function cns_join_actual($captcha_if_enabled = true, $intro_message_if_enabled = true, $invites_if_enabled = true, $instant_login = true, $username = null, $email_address = null, $password = null, $actual_custom_fields = null, $adjusted_config_options = null)
{
    cns_require_all_forum_stuff();

    require_css('cns');
    require_code('cns_members_action');
    require_code('cns_members_action2');

    // Read in data

    if ($username === null) {
        $username = trim(post_param_string('username'));
    }
    cns_check_name_valid($username, null, null, true); // Adjusts username if needed

    if ($password === null) {
        $password = trim(post_param_string('password', false, INPUT_FILTER_NONE));
        $password_confirm = trim(post_param_string('password_confirm', false, INPUT_FILTER_NONE));
        if ($password != $password_confirm) {
            warn_exit(make_string_tempcode(escape_html(do_lang('PASSWORD_MISMATCH'))));
        }
    }

    if ($email_address === null) {
        $confirm_email_address = post_param_string('email_address_confirm', null);
        $email_address = trim(post_param_string('email', member_field_is_required(null, 'email_address', null, null, $adjusted_config_options) ? false : ''));
        if ($confirm_email_address !== null) {
            if (trim($confirm_email_address) != $email_address) {
                warn_exit(make_string_tempcode(escape_html(do_lang('EMAIL_ADDRESS_MISMATCH'))));
            }
        }
        require_code('type_sanitisation');
        if (!is_email_address($email_address)) {
            warn_exit(do_lang_tempcode('INVALID_EMAIL_ADDRESS'));
        }
    }

    // Check e-mail domain, if applicable
    $email_address = trim(post_param_string('email'));
    if ($email_address != '') {
        $valid_email_domains = get_option_with_overrides('valid_email_domains', $adjusted_config_options);
        if ($valid_email_domains != '') {
            $domains = explode(',', $valid_email_domains);
            $ok = false;
            foreach ($domains as $domain) {
                if (substr($email_address, -strlen('@' . $domain)) == '@' . $domain) {
                    $ok = true;
                }
            }
            if (!$ok) {
                warn_exit(do_lang_tempcode('_MUST_BE_EMAIL_DOMAIN', escape_html($valid_email_domains)));
            }
        }
    }

    if ($invites_if_enabled) { // code branch also triggers general tracking of referrals
        if (get_option_with_overrides('is_on_invites', $adjusted_config_options) == '1') {
            $test = $GLOBALS['FORUM_DB']->query_select_value_if_there('f_invites', 'i_inviter', array('i_email_address' => $email_address, 'i_taken' => 0));
            if ($test === null) {
                warn_exit(do_lang_tempcode('NO_INVITE'));
            }
        }

        /*PSEUDO-HOOK: cns_join_actual referrals*/

        $GLOBALS['FORUM_DB']->query_update('f_invites', array('i_taken' => 1), array('i_email_address' => $email_address, 'i_taken' => 0), '', 1);
    }

    require_code('temporal2');
    list($dob_year, $dob_month, $dob_day) = post_param_date_components('birthday');
    if (($dob_year === null) || ($dob_month === null) || ($dob_day === null)) {
        if (member_field_is_required(null, 'dob', null, null, $adjusted_config_options)) {
            warn_exit(do_lang_tempcode('NO_PARAMETER_SENT', escape_html('birthday')));
        }

        $dob_day = null;
        $dob_month = null;
        $dob_year = null;
    }
    $reveal_age = post_param_integer('reveal_age', 0);

    $timezone = post_param_string('timezone', get_users_timezone());

    $language = post_param_string('language', user_lang());

    if (get_option_with_overrides('member_email_receipt_configurability', $adjusted_config_options) == '0') {
        $allow_emails = 1;
    } else {
        $allow_emails = post_param_integer('allow_emails', 0);
    }
    if (get_option_with_overrides('staff_email_receipt_configurability', $adjusted_config_options) == '0') {
        $allow_emails_from_staff = 1;
    } else {
        $allow_emails_from_staff = post_param_integer('allow_emails_from_staff', 0);
    }

    $groups = cns_get_all_default_groups(true); // $groups will contain the built-in default primary group too (it is not $secondary_groups)
    $primary_group = post_param_integer('primary_group', null);
    if (($primary_group !== null) && (!in_array($primary_group, $groups)/*= not built-in default, which is automatically ok to join without extra security*/)) {
        // Check security
        $test = $GLOBALS['FORUM_DB']->query_select_value('f_groups', 'g_is_presented_at_install', array('id' => $primary_group));
        if ($test == 1) {
            $groups = cns_get_all_default_groups(false); // Get it so it does not include the built-in default primary group
            $groups[] = $primary_group; // And add in the *chosen* primary group
        } else {
            $primary_group = null;
        }
    } else {
        $primary_group = null;
    }
    if ($primary_group === null) { // Security error, or built-in default (which will already be in $groups)
        $primary_group = get_first_default_group();
    }

    $custom_fields = cns_get_all_custom_fields_match($groups, null, null, null, null, null, null, 0, true, $adjusted_config_options);
    if ($actual_custom_fields === null) {
        $actual_custom_fields = cns_read_in_custom_fields($custom_fields);
    }

    // Check that the given address isn't already used (if one_per_email_address on)
    $member_id = null;
    if (get_option_with_overrides('one_per_email_address', $adjusted_config_options) != '0') {
        $test = $GLOBALS['FORUM_DB']->query_select('f_members', array('id', 'm_username'), array('m_email_address' => $email_address), '', 1);
        if (array_key_exists(0, $test)) {
            if ($test[0]['m_username'] != $username) {
                $reset_url = build_url(array('page' => 'lost_password', 'email' => $email_address), get_module_zone('lost_password'));
                warn_exit(do_lang_tempcode('EMAIL_ADDRESS_IN_USE', escape_html(get_site_name()), escape_html($reset_url->evaluate())));
            }
            $member_id = $test[0]['id'];
        }
    }

    // Check RBL's/stopforumspam
    $spam_check_level = get_option_with_overrides('spam_check_level', $adjusted_config_options);
    if (($spam_check_level == 'EVERYTHING') || ($spam_check_level == 'ACTIONS') || ($spam_check_level == 'GUESTACTIONS') || ($spam_check_level == 'JOINING')) {
        require_code('antispam');
        check_for_spam($username, $email_address, false);
    }

    if ($captcha_if_enabled) {
        if (addon_installed('captcha')) {
            require_code('captcha');
            enforce_captcha();
        }
    }
    if (addon_installed('ldap')) {
        require_code('cns_ldap');
        if (cns_is_ldap_member_potential($username)) {
            warn_exit(do_lang_tempcode('DUPLICATE_JOIN_AUTH'));
        }
    }

    // Add member
    $email_validation = (get_option_with_overrides('email_confirm_join', $adjusted_config_options) == '1');
    require_code('crypt');
    $validated_email_confirm_code = $email_validation ? strval(get_secure_random_number()) : '';
    $staff_validation = (get_option_with_overrides('require_new_member_validation', $adjusted_config_options) == '1');
    $coppa = (get_option_with_overrides('is_on_coppa', $adjusted_config_options) == '1') && ($dob_year !== null) && (utctime_to_usertime(time() - mktime(0, 0, 0, $dob_month, $dob_day, $dob_year)) / 31536000.0 < 13.0);
    $validated = ($staff_validation || $coppa) ? 0 : 1;
    if ($member_id === null) {
        $member_id = cns_make_member(
            $username, // username
            $password, // password
            $email_address, // email_address
            $primary_group, // primary_group
            $groups, // secondary_groups
            $dob_day, // dob_day
            $dob_month, // dob_month
            $dob_year, // dob_year
            $actual_custom_fields, // custom_fields
            $timezone, // timezone
            $language, // language
            '', // theme
            '', // title
            '', // photo_url
            '', // photo_thumb_url
            null, // avatar_url
            '', // signature
            null, // preview_posts
            $reveal_age, // reveal_age
            1, // views_signatures
            null, // auto_monitor_contrib_content
            null, // smart_topic_notification
            null, // mailing_list_style
            1, // auto_mark_read
            null, // sound_enabled
            $allow_emails, // allow_emails
            $allow_emails_from_staff, // allow_emails_from_staff
            0, // highlighted_name
            '*', // pt_allow
            '', // pt_rules_text
            $validated, // validated
            $validated_email_confirm_code, // validated_email_confirm_code
            null, // on_probation_until
            0, // is_perm_banned
            false // check_correctness
        );
    } else {
        attach_message(do_lang_tempcode('ALREADY_EXISTS', escape_html($username)), 'notice');
    }

    // Send confirm mail
    if ($email_validation) {
        $zone = get_module_zone('join');
        $_url = build_url(array('page' => 'join', 'type' => 'step4', 'email' => $email_address, 'code' => $validated_email_confirm_code), $zone, array(), false, false, true);
        $url = $_url->evaluate();
        $_url_simple = build_url(array('page' => 'join', 'type' => 'step4'), $zone, array(), false, false, true);
        $url_simple = $_url_simple->evaluate();
        $redirect = get_param_string('redirect', '', INPUT_FILTER_URL_INTERNAL);
        if ($redirect != '') {
            $url .= '&redirect=' . cms_urlencode(static_evaluate_tempcode(protect_url_parameter($redirect)));
        }
        $message = do_lang('CNS_SIGNUP_TEXT', comcode_escape(get_site_name()), comcode_escape($url), array($url_simple, $email_address, $validated_email_confirm_code), $language);
        require_code('mail');
        if (!$coppa) {
            dispatch_mail(do_lang('CONFIRM_EMAIL_SUBJECT', get_site_name(), null, null, $language), $message, array($email_address), $username, '', '', array('bypass_queue' => true));
        }
    }

    // Send COPPA mail
    if ($coppa) {
        $fields_done = do_lang('THIS_WITH_COMCODE', do_lang('USERNAME'), $username) . "\n\n";
        foreach ($custom_fields as $custom_field) {
            if ($custom_field['cf_type'] != 'upload') {
                $fields_done .= do_lang('THIS_WITH_COMCODE', $custom_field['trans_name'], post_param_string('field_' . $custom_field['id'])) . "\n";
            }
        }
        $_privacy_url = build_url(array('page' => 'privacy'), '_SEARCH', array(), false, false, true);
        $privacy_url = $_privacy_url->evaluate();
        $message = do_lang('COPPA_MAIL', comcode_escape(get_option('site_name')), comcode_escape(get_option('privacy_fax')), array(comcode_escape(get_option('privacy_postal_address')), comcode_escape($fields_done), comcode_escape($privacy_url)), $language);
        require_code('mail');
        dispatch_mail(do_lang('COPPA_JOIN_SUBJECT', $username, get_site_name(), null, $language), $message, array($email_address), $username);
    }

    // Send 'validate this member' notification
    if ($staff_validation) {
        require_code('notifications');
        $_validation_url = build_url(array('page' => 'members', 'type' => 'view', 'id' => $member_id), get_module_zone('members'), array(), false, false, true, 'tab--edit');
        $validation_url = $_validation_url->evaluate();
        $message = do_notification_lang('VALIDATE_NEW_MEMBER_MAIL', comcode_escape($username), comcode_escape($validation_url), comcode_escape(strval($member_id)), get_site_default_lang());
        dispatch_notification('cns_member_needs_validation', null, do_lang('VALIDATE_NEW_MEMBER_SUBJECT', $username, null, null, get_site_default_lang()), $message, null, A_FROM_SYSTEM_PRIVILEGED);
    }

    // Send new member notification
    require_code('notifications');
    $_member_url = build_url(array('page' => 'members', 'type' => 'view', 'id' => $member_id), get_module_zone('members'), array(), false, false, true);
    $member_url = $_member_url->evaluate();
    $message = do_notification_lang('NEW_MEMBER_NOTIFICATION_MAIL', comcode_escape($username), comcode_escape(get_site_name()), array(comcode_escape($member_url), comcode_escape(strval($member_id))), get_site_default_lang());
    dispatch_notification('cns_new_member', null, do_lang('NEW_MEMBER_NOTIFICATION_MAIL_SUBJECT', $username, get_site_name(), null, get_site_default_lang()), $message, null, A_FROM_SYSTEM_PRIVILEGED);

    // Intro post
    if ($intro_message_if_enabled) {
        $forum_id = get_option('intro_forum_id');
        if ($forum_id != '') {
            if (!is_numeric($forum_id)) {
                $_forum_id = $GLOBALS['FORUM_DB']->query_select_value('f_forums', 'id', array('f_name' => $forum_id));
                if ($_forum_id === null) {
                    $forum_id = strval(db_get_first_id());
                } else {
                    $forum_id = strval($_forum_id);
                }
            }

            $intro_title = post_param_string('intro_title', '');
            $intro_post = post_param_string('intro_post', '');
            if ($intro_post != '') {
                require_code('cns_topics_action');
                $initial_validated = 1;
                if ($intro_title == '') {
                    $intro_title = do_lang('INTRO_POST_DEFAULT', $username);
                }
                $topic_id = cns_make_topic(intval($forum_id), '', '', $initial_validated, 1, 0, 0, null, null, false);
                require_code('cns_posts_action');
                cns_make_post($topic_id, $intro_title, $intro_post, 0, true, $initial_validated, 0, null, null, null, $member_id, null, null, null, false);
            }
        }
    }

    // Alert user to situation
    $message = new Tempcode();
    $ready = false;
    if ($coppa) {
        if ($email_validation) {
            $message->attach(do_lang_tempcode('CNS_WAITING_CONFIRM_MAIL'));
        }
        $message->attach(do_lang_tempcode('CNS_WAITING_CONFIRM_MAIL_COPPA'));
    } elseif ($staff_validation) {
        if ($email_validation) {
            $message->attach(do_lang_tempcode('CNS_WAITING_CONFIRM_MAIL'));
        }
        $message->attach(do_lang_tempcode('CNS_WAITING_CONFIRM_MAIL_VALIDATED', escape_html(get_custom_base_url())));
    } elseif (!$email_validation) {
        if (($instant_login) && (!$GLOBALS['IS_ACTUALLY_ADMIN'])) { // Automatic instant log in
            require_code('users_active_actions');
            handle_active_login($username); // The auto-login simulates a real login, i.e. actually checks the password from the form against the real account. So no security hole when "re-registering" a real user
            $message->attach(do_lang_tempcode('CNS_LOGIN_AUTO'));
        } else { // Invite them to explicitly instant log in
            $redirect = get_param_string('redirect', (get_page_name() == 'join') ? null : get_self_url(true), INPUT_FILTER_URL_INTERNAL);
            $_login_url = build_url(array('page' => 'login', 'type' => 'browse', 'redirect' => protect_url_parameter($redirect)), get_module_zone('login'));
            $login_url = $_login_url->evaluate();
            $message->attach(do_lang_tempcode('CNS_LOGIN_INSTANT', escape_html($login_url)));
        }
        $ready = true;
    } else {
        if ($email_validation) {
            $message->attach(do_lang_tempcode('CNS_WAITING_CONFIRM_MAIL'));
        }
        $message->attach(do_lang_tempcode('CNS_WAITING_CONFIRM_MAIL_INSTANT'));
    }
    $message = protect_from_escaping($message);

    /*PSEUDO-HOOK: cns_join_actual ends*/

    return array($message, $member_id, $ready);
}
