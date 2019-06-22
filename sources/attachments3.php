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
 * @package    core_rich_media
 */

/*
Editing/deleting attachments.
(Adding is in attachments2.php)
*/

/**
 * Update a content language string, in such a way that new attachments are created if they were specified.
 *
 * @param  ID_TEXT $field_name The field name
 * @param  mixed $lang_id The content language string
 * @param  LONG_TEXT $text The new text
 * @param  ID_TEXT $type The arbitrary type that the attached is for (e.g. download)
 * @param  ID_TEXT $id The ID in the set of the arbitrary types that the attached is for
 * @param  ?object $db The database connector to use (null: standard site connector)
 * @param  ?MEMBER $for_member The member that owns the content this is for (null: current member)
 * @return array The content language string save fields
 */
function update_lang_comcode_attachments($field_name, $lang_id, $text, $type, $id, $db = null, $for_member = null)
{
    if ($lang_id === 0) {
        return insert_lang_comcode_attachments($field_name, 3, $text, $type, $id, $db, false, $for_member);
    }

    if ($text === STRING_MAGIC_NULL) {
        return array();
    }

    if ($db === null) {
        $db = $GLOBALS['SITE_DB'];
    }

    $lang = get_param_string('lang', user_lang());

    require_lang('comcode');

    _check_attachment_count();

    $member_id = (function_exists('get_member')) ? get_member() : $GLOBALS['FORUM_DRIVER']->get_guest_id();

    if (($for_member === null) || ($GLOBALS['FORUM_DRIVER']->get_username($for_member, false, USERNAME_DEFAULT_NULL) === null)) {
        $for_member = $member_id;
    }

    /*
    We set the Comcode user to the editing user (not the content owner) if the editing user does not have full HTML/Dangerous-Comcode privileges.
    The Comcode user is set to the content owner if the editing user does have those privileges (which is the idealised, consistent state).
    This is necessary as editing admin's content shouldn't let you write content with admin's privileges, even if you have privilege to edit their content
     - yet also, if the source_user is changed, when admin edits it has to change back again.
    */
    if (((cms_admirecookie('use_wysiwyg', '1') == '0') && (get_value('edit_with_my_comcode_perms') === '1')) || (!has_privilege($member_id, 'allow_html')) || (!has_privilege($member_id, 'use_very_dangerous_comcode'))) {
        $source_user = $member_id;
    } else {
        $source_user = $for_member; // Reset to latest submitter for main record
    }

    $_info = do_comcode_attachments($text, $type, $id, false, $db, null, $source_user);
    $text_parsed = ''; // Actually we'll let it regenerate with the correct permissions ($member_id, not $for_member) $_info['tempcode']->to_assembly();

    if (multi_lang_content()) {
        $remap = array(
            'text_original' => $_info['comcode'],
            'text_parsed' => $text_parsed,
            'source_user' => $source_user,
        );

        $test = $db->query_select_value_if_there('translate', 'text_original', array('id' => $lang_id, 'language' => $lang));
        if ($test !== null) { // Good, we save into our own language, as we have a translation for the lang entry setup properly
            $db->query_update('translate', $remap, array('id' => $lang_id, 'language' => $lang));
        } else { // Darn, we'll have to save over whatever we did load from
            $db->query_update('translate', $remap, array('id' => $lang_id));
        }
    } else {
        $ret = array();
        $ret[$field_name] = $_info['comcode'];
        $ret[$field_name . '__text_parsed'] = $text_parsed;
        $ret[$field_name . '__source_user'] = $source_user;
        return $ret;
    }

    return array(
        $field_name => $lang_id,
    );
}

/**
 * Delete attachments solely used by the specified hook.
 *
 * @param  ID_TEXT $type The hook
 * @param  ?object $db The database connector to use (null: standard site connector)
 */
function delete_attachments($type, $db = null)
{
    if (get_option('attachment_cleanup') == '0') {
        return;
    }

    if ($db === null) {
        $db = $GLOBALS['SITE_DB'];
    }

    require_code('attachments2');
    require_code('attachments3');

    // Clear any de-referenced attachments
    $before = $db->query_select('attachment_refs', array('a_id', 'id'), array('r_referer_type' => $type));
    foreach ($before as $ref) {
        // Delete reference (as it's not actually in the new Comcode!)
        $db->query_delete('attachment_refs', array('id' => $ref['id']), '', 1);

        // Was that the last reference to this attachment? (if so -- delete attachment)
        $test = $db->query_select_value_if_there('attachment_refs', 'id', array('a_id' => $ref['a_id']));
        if ($test === null) {
            _delete_attachment($ref['a_id'], $db);
        }
    }
}

/**
 * Delete the specified attachment.
 *
 * @param  AUTO_LINK $id The attachment ID to delete
 * @param  object $db The database connector to use
 * @set cms forum
 *
 * @ignore
 */
function _delete_attachment($id, $db)
{
    $db->query_delete('attachment_refs', array('a_id' => $id));

    // Get attachment details
    $_attachment_info = $db->query_select('attachments', array('a_url', 'a_thumb_url'), array('id' => $id), '', 1);
    if (!array_key_exists(0, $_attachment_info)) {
        return; // Already gone
    }
    $attachment_info = $_attachment_info[0];

    // Delete url and thumb_url if local
    if ((url_is_local($attachment_info['a_url'])) && (substr($attachment_info['a_url'], 0, 19) == 'uploads/attachments')) {
        $url = rawurldecode($attachment_info['a_url']);
        @unlink(get_custom_file_base() . '/' . $url);
        sync_file(get_custom_file_base() . '/' . $url);
        if (($attachment_info['a_thumb_url'] != '') && (strpos($attachment_info['a_thumb_url'], 'uploads/filedump/') === false)) {
            $thumb_url = rawurldecode($attachment_info['a_thumb_url']);
            @unlink(get_custom_file_base() . '/' . $thumb_url);
            sync_file(get_custom_file_base() . '/' . $thumb_url);
        }
    }

    // Delete attachment
    $db->query_delete('attachments', array('id' => $id), '', 1);
}

/**
 * Deletes all the attachments a given content language string holds. Well, not quite! It deletes all references, and any attachments have through it, run out of references.
 *
 * @param  ID_TEXT $type The arbitrary type that the attached is for (e.g. download)
 * @param  ID_TEXT $id The ID in the set of the arbitrary types that the attached is for
 * @param  ?object $db The database connector to use (null: standard site connector)
 * @param  boolean $force Whether to force this, regardless of config
 */
function delete_comcode_attachments($type, $id, $db = null, $force = false)
{
    if (get_option('attachment_cleanup') == '0' && !$force) {
        return;
    }

    if ($db === null) {
        $db = $GLOBALS['SITE_DB'];
    }

    require_lang('comcode');

    $refs = $db->query_select('attachment_refs', array('a_id', 'id'), array('r_referer_type' => $type, 'r_referer_id' => $id));
    $db->query_delete('attachment_refs', array('r_referer_type' => $type, 'r_referer_id' => $id));
    foreach ($refs as $ref) {
        // Was that the last reference to this attachment? (if so -- delete attachment)
        $test = $db->query_select_value_if_there('attachment_refs', 'id', array('a_id' => $ref['a_id']));
        if ($test === null) {
            _delete_attachment($ref['a_id'], $db);
        }
    }
}

/**
 * This function is the same as delete_comcode_attachments, except that it deletes the content language string as well.
 *
 * @param  mixed $lang_id The content language string
 * @param  ID_TEXT $type The arbitrary type that the attached is for (e.g. download)
 * @param  ID_TEXT $id The ID in the set of the arbitrary types that the attached is for
 * @param  ?object $db The database connector to use (null: standard site connector)
 */
function delete_lang_comcode_attachments($lang_id, $type, $id, $db = null)
{
    if ($db === null) {
        $db = $GLOBALS['SITE_DB'];
    }

    delete_comcode_attachments($type, $id, $db);

    if (multi_lang_content()) {
        $db->query_delete('translate', array('id' => $lang_id), '', 1);
    }
}
