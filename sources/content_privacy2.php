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
 * @package    content_privacy
 */

/**
 * Get form fields for setting content privacy.
 *
 * @param  ?ID_TEXT $content_type The content type (null: could be multiple)
 * @param  ?ID_TEXT $content_id The content ID (null: adding)
 * @param  boolean $show_header Whether to show a header to separate the settings out
 * @param  string $prefix Prefix for field naming
 * @return Tempcode The form fields
 */
function get_privacy_form_fields($content_type, $content_id = null, $show_header = true, $prefix = '')
{
    if (is_guest()) {
        return new Tempcode();
    }

    if (!addon_installed('cns_cpfs')) { // This is coded as a dependency
        return new Tempcode();
    }

    require_lang('content_privacy');
    require_lang('cns_privacy');
    require_code('form_templates');

    if ($content_id !== null) {
        $rows = $GLOBALS['SITE_DB']->query_select('content_privacy', array('*'), array('content_type' => $content_type, 'content_id' => $content_id));
        if (count($rows) == 0) {
            $view_by_guests = true;
            $view_by_members = true;
            $view_by_friends = true;
        } else {
            $view_by_guests = ($rows[0]['guest_view'] == 1);
            $view_by_members = ($rows[0]['member_view'] == 1);
            $view_by_friends = ($rows[0]['friend_view'] == 1);
        }
        $rows = $GLOBALS['SITE_DB']->query_select('content_privacy__members', array('*'), array('content_type' => $content_type, 'content_id' => $content_id));
        $additional_access = array();
        foreach ($rows as $row) {
            $additional_access[] = $GLOBALS['FORUM_DRIVER']->get_username($row['member_id']);
        }
    } else {
        $test = ($content_type === null) ? null : $GLOBALS['SITE_DB']->query_select_value_if_there('content_privacy', 'AVG(guest_view)', array('content_type' => $content_type));
        if ($test === null) {
            $view_by_guests = true;
        } else {
            $view_by_guests = (@intval($test) == 1);
        }
        $test = ($content_type === null) ? null : $GLOBALS['SITE_DB']->query_select_value_if_there('content_privacy', 'AVG(member_view)', array('content_type' => $content_type));
        if ($test === null) {
            $view_by_members = true;
        } else {
            $view_by_members = (@intval($test) == 1);
        }
        $test = ($content_type === null) ? null : $GLOBALS['SITE_DB']->query_select_value_if_there('content_privacy', 'AVG(friend_view)', array('content_type' => $content_type));
        if ($test === null) {
            $view_by_friends = true;
        } else {
            $view_by_friends = (@intval($test) == 1);
        }
        $additional_access = array();
    }

    $fields = new Tempcode();

    if ($show_header) {
        $fields->attach(do_template('FORM_SCREEN_FIELD_SPACER', array('_GUID' => '3f3bf4190c8f4973382f264e2a892044', 'SECTION_HIDDEN' => $view_by_guests, 'TITLE' => do_lang_tempcode('PRIVACY_SETTINGS'))));
    }

    $privacy_options = new Tempcode();
    $privacy_options->attach(form_input_list_entry('guests', $view_by_guests, do_lang_tempcode('VISIBLE_TO_GUESTS')));
    $privacy_options->attach(form_input_list_entry('members', $view_by_members && !$view_by_guests, do_lang_tempcode('VISIBLE_TO_MEMBERS')));
    $privacy_options->attach(form_input_list_entry('friends', $view_by_friends && !$view_by_members && !$view_by_guests, do_lang_tempcode('VISIBLE_TO_FRIENDS')));
    $privacy_options->attach(form_input_list_entry('staff', !$view_by_friends && !$view_by_members && !$view_by_guests, do_lang_tempcode('VISIBLE_TO_STAFF')));
    $fields->attach(form_input_list(do_lang_tempcode('VISIBLE_TO'), do_lang_tempcode('DESCRIPTION_VISIBLE_TO'), $prefix . 'privacy_level', $privacy_options));

    $fields->attach(form_input_username_multi(do_lang_tempcode('ADDITIONAL_ACCESS'), do_lang_tempcode($show_header ? 'DESCRIPTION_ADDITIONAL_ACCESS' : 'DESCRIPTION_ADDITIONAL_ACCESS_RAW'), $prefix . 'privacy_friends_list_', $additional_access, 0));

    return $fields;
}

/**
 * Reading privacy settings from the POST environment.
 *
 * @param  string $prefix Prefix for field naming
 * @return array A pair: the privacy level, the list of usernames
 */
function read_privacy_fields($prefix = '')
{
    $privacy_level = post_param_string($prefix . 'privacy_level', '');

    $additional_access = array();
    foreach ($_POST as $key => $value) {
        if (strpos($key, $prefix . 'privacy_friends_list_') === 0) {
            if ($value != '') {
                $additional_access[] = $value;
            }
        }
    }

    return array($privacy_level, $additional_access);
}

/**
 * Actualise form data for setting content privacy.
 *
 * @param  ID_TEXT $content_type The content type
 * @param  ?ID_TEXT $content_id The content ID (null: adding)
 * @param  ID_TEXT $privacy_level The privacy level
 * @set members friends staff guests
 * @param  array $additional_access A list of usernames
 * @param  boolean $send_invites Whether to send out invite notifications (only do this is it is a new content entry, rather than something obscure, like a member's photo)
 * @return boolean Whether it saved something
 */
function save_privacy_form_fields($content_type, $content_id, $privacy_level, $additional_access, $send_invites = true)
{
    if (fractional_edit()) {
        return false;
    }

    if (is_guest()) {
        return false;
    }

    if (!addon_installed('cns_cpfs')) { // This is coded as a dependency
        return false;
    }

    switch ($privacy_level) {
        case 'members':
            $member_view = 1;
            $friend_view = 0;
            $guest_view = 0;
            break;

        case 'friends':
            $member_view = 0;
            $friend_view = 1;
            $guest_view = 0;
            break;

        case 'staff':
            $member_view = 0;
            $friend_view = 0;
            $guest_view = 0;
            break;

        case 'guests':
        default:
            $member_view = 0;
            $friend_view = 0;
            $guest_view = 1;
            break;
    }
    $GLOBALS['SITE_DB']->query_delete('content_privacy', array(
        'content_type' => $content_type,
        'content_id' => $content_id,
    ));
    $GLOBALS['SITE_DB']->query_insert('content_privacy', array(
        'content_type' => $content_type,
        'content_id' => $content_id,
        'guest_view' => $guest_view,
        'member_view' => $member_view,
        'friend_view' => $friend_view,
    ));

    $rows = $GLOBALS['SITE_DB']->query_select('content_privacy__members', array('member_id'), array('content_type' => $content_type, 'content_id' => $content_id));
    $currently_invited_members = array();
    foreach ($rows as $value) {
        $currently_invited_members[] = $value['member_id'];
    }

    $GLOBALS['SITE_DB']->query_delete('content_privacy__members', array('content_type' => $content_type, 'content_id' => $content_id));

    if (count($additional_access) != 0) {
        $invited_members = array();
        foreach ($additional_access as $member) {
            $member_id = $GLOBALS['FORUM_DRIVER']->get_member_from_username($member);
            if ($member_id !== null) {
                $GLOBALS['SITE_DB']->query_insert('content_privacy__members', array(
                    'member_id' => $member_id,
                    'content_type' => $content_type,
                    'content_id' => $content_id,
                ));
                if (!in_array($member_id, $currently_invited_members)) {
                    $invited_members[] = $member_id;
                }
            }
        }

        if ((count($invited_members) != 0) && ($send_invites)) {
            require_lang('content_privacy');
            require_code('notifications');
            require_code('content');
            list($content_title, $content_submitter, $cma_info, , , $content_url) = content_get_details($content_type, $content_id);
            $content_submitter_username = $GLOBALS['FORUM_DRIVER']->get_username($content_submitter);
            $content_type_label = do_lang($cma_info['content_type_label']);

            $subject = do_lang('NOTIFICATION_SUBJECT_invited_content', comcode_escape($content_submitter_username));
            $mail = do_notification_lang('NOTIFICATION_BODY_invited_content', comcode_escape($content_submitter_username), strtolower(comcode_escape($content_type_label)), array(comcode_escape($content_title), $content_url->evaluate(), comcode_escape($content_type_label)));
            dispatch_notification('invited_content', null, $subject, $mail, $invited_members);
        }
    }

    return true;
}

/**
 * Delete privacy data.
 *
 * @param  ID_TEXT $content_type The content type
 * @param  ID_TEXT $content_id The content ID
 * @return boolean Whether it deleted something
 */
function delete_privacy_form_fields($content_type, $content_id)
{
    if (is_guest()) {
        return false;
    }

    $GLOBALS['SITE_DB']->query_delete('content_privacy', array('content_type' => $content_type, 'content_id' => $content_id), '', 1);
    $GLOBALS['SITE_DB']->query_delete('content_privacy__members', array('content_type' => $content_type, 'content_id' => $content_id));

    return true;
}
