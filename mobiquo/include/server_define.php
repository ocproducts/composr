<?php /*

 Composr
 Copyright (c) ocProducts/Tapatalk, 2004-2019

 See text/EN/licence.txt for full licensing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */

/*CQC: No check*/

if (!defined('IN_MOBIQUO') && !function_exists('get_base_url')) {
    exit('May not call this directly');
}

global $SERVER_DEFINE;

global $xmlrpcInt, $xmlrpcBoolean, $xmlrpcDouble, $xmlrpcString, $xmlrpcDateTime, $xmlrpcBase64, $xmlrpcArray, $xmlrpcStruct, $xmlrpcValue;

/*
Standard file taken from other implementation.

Modified so that old endpoints are commented out (because our mobiquo_common code checks it all).

Added some ones which were missing at the bottom.

Fixed method signatures, which had many issues.

Removed docstirng lines (didn't want to make them consistent).

Reformatted code in PhpStorm.
*/

/*
Info...

A signature is a description of a method's return type and its parameter types. A method may have more than one signature.

Within a server's dispatch map, each method has an array of possible signatures. Each signature is an array of types. The first entry is the return type. For instance, the method
*/

$SERVER_DEFINE = array(
    'login' => array(
        'function' => 'login_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBoolean, $xmlrpcString), // 4th parameter is unused but passed by client
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBoolean),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcBase64)),
    ),

    'sign_in' => array(
        'function' => 'sign_in_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),

    'register' => array(
        'function' => 'register_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcString, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64)),
    ),

    'ignore_user' => array(
        'function' => 'ignore_user_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),

    'forget_password' => array(
        'function' => 'forget_password_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcString, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcBase64)),
    ),

    'update_password' => array(
        'function' => 'update_password_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcString, $xmlrpcString)),
    ),

    'update_email' => array(
        'function' => 'update_email_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64)),
    ),

    'get_forum' => array(
        'function' => 'get_forum_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcBoolean),
                             array($xmlrpcStruct, $xmlrpcBoolean, $xmlrpcString)),
    ),

    'get_board_stat' => array(
        'function' => 'get_board_stat_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_topic' => array(
        'function' => 'get_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),

    'get_thread' => array(
        'function' => 'get_thread_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt, $xmlrpcBoolean),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),
    'get_thread_by_unread' => array(
        'function' => 'get_thread_by_unread_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcBoolean),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),
    'get_thread_by_post' => array(
        'function' => 'get_thread_by_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcBoolean),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),

    'get_recommended_user' => array(
        'function' => 'get_recommended_user_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct)),
    ),

    'search_user' => array(
        'function' => 'search_user_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcBase64)),
    ),

    'mark_conversation_unread' => array(
        'function' => 'mark_conversation_unread_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),
    'mark_conversation_read' => array(
        'function' => 'mark_conversation_read_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct)),
    ),

    'get_raw_post' => array(
        'function' => 'get_raw_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'save_raw_post' => array(
        'function' => 'save_raw_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBoolean),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBoolean, $xmlrpcArray, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBoolean, $xmlrpcArray, $xmlrpcString, $xmlrpcBase64)),
    ),

    'get_quote_post' => array(
        'function' => 'get_quote_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'get_user_topic' => array(
        'function' => 'get_user_topic_func',
        'signature' => array(array($xmlrpcArray, $xmlrpcBase64),
                             array($xmlrpcArray, $xmlrpcBase64, $xmlrpcString)),
    ),

    'get_user_reply_post' => array(
        'function' => 'get_user_reply_post_func',
        'signature' => array(array($xmlrpcArray, $xmlrpcBase64),
                             array($xmlrpcArray, $xmlrpcBase64, $xmlrpcString)),
    ),

    /*'get_new_topic' => array( NO LONGER EXISTS
        'function' => 'get_new_topic_func',
        'signature' => array(array($xmlrpcStruct),
                                array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),*/

    'get_latest_topic' => array(
        'function' => 'get_latest_topic_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcString, $xmlrpcStruct)),
    ),

    'get_unread_topic' => array(
        'function' => 'get_unread_topic_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcString, $xmlrpcArray)),
    ),

    'get_subscribed_topic' => array(
        'function' => 'get_subscribed_topic_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),
    'get_subscribed_forum' => array(
        'function' => 'get_subscribed_forum_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_user_info' => array(
        'function' => 'get_user_info_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcString)),
    ),

    'get_config' => array(
        'function' => 'get_config_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'logout_user' => array(
        'function' => 'logout_user_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'new_topic' => array(
        'function' => 'new_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcString, $xmlrpcArray),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcString, $xmlrpcArray, $xmlrpcString)),
    ),

    'reply_post' => array(
        'function' => 'reply_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray, $xmlrpcString, $xmlrpcBoolean)),
    ),

    /*'reply_topic' => array(   NO LONGER EXISTS
        'function' => 'reply_topic_func',
            'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcString),
                               array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcBase64),
                               array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                               array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                               array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray, $xmlrpcString),
                               array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray, $xmlrpcString, $xmlrpcBoolean)),
    ),*/

    'subscribe_topic' => array(
        'function' => 'subscribe_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),
    'unsubscribe_topic' => array(
        'function' => 'unsubscribe_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'subscribe_forum' => array(
        'function' => 'subscribe_forum_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),
    'unsubscribe_forum' => array(
        'function' => 'unsubscribe_forum_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'get_inbox_stat' => array(
        'function' => 'get_inbox_stat_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_conversations' => array(
        'function' => 'get_conversations_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),

    'get_conversation' => array(
        'function' => 'get_conversation_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt, $xmlrpcBoolean)),
    ),

    'get_online_users' => array(
        'function' => 'get_online_users_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt, $xmlrpcString, $xmlrpcString)),
    ),

    'mark_all_as_read' => array(
        'function' => 'mark_all_as_read_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),

    'search' => array(
        'function' => 'search_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcStruct)),
    ),
    'search_topic' => array(
        'function' => 'search_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcBase64)),
    ),
    'search_post' => array(
        'function' => 'search_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcBase64)),
    ),

    'get_participated_topic' => array(
        'function' => 'get_participated_topic_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcInt, $xmlrpcString, $xmlrpcString)),
    ),

    'login_forum' => array(
        'function' => 'login_forum_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64)),
    ),

    'invite_participant' => array(
        'function' => 'invite_participant_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcArray, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcArray, $xmlrpcString, $xmlrpcBase64)),
    ),

    'new_conversation' => array(
        'function' => 'new_conversation_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcArray, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcArray, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray, $xmlrpcString)),
    ),

    'reply_conversation' => array(
        'function' => 'reply_conversation_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcArray, $xmlrpcString)),
    ),

    'get_quote_conversation' => array(
        'function' => 'get_quote_conversation_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),

    'delete_conversation' => array(
        'function' => 'delete_conversation_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),

    'get_dashboard' => array(
        'function' => 'get_dashboard_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcBoolean)),
    ),

    'like_post' => array(
        'function' => 'like_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),
    'unlike_post' => array(
        'function' => 'unlike_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'report_post' => array(
        'function' => 'report_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64),
        ),
    ),
    'report_pm' => array(
        'function' => 'report_pm_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64),
        ),
    ),

    'upload_attach' => array(
        'function' => 'upload_attach_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    /*'set_avatar' => array(    NO LONGER EXISTS
        'function' => 'upload_avatar_func',
        'signature' => array(array($xmlrpcStruct)),
    ),*/

    'upload_avatar' => array(
        'function' => 'upload_avatar_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_id_by_url' => array(
        'function' => 'get_id_by_url_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    /*'authorize_user' => array(    NO LONGER EXISTS
        'function' =>'authorize_user_func',
        'signature' => array(array($xmlrpcStruct,$xmlrpcBase64,$xmlrpcString),
                                 array($xmlrpcStruct,$xmlrpcBase64,$xmlrpcBase64),
        ),
    ),*/

    'remove_attachment' => array(
        'function' => 'remove_attachment_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcString, $xmlrpcString)),
    ),

    'm_stick_topic' => array(
        'function' => 'm_stick_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),

    'm_close_topic' => array(
        'function' => 'm_close_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),

    'm_delete_topic' => array(
        'function' => 'm_delete_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),
    'm_delete_post' => array(
        'function' => 'm_delete_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcString)),
    ),

    'm_undelete_topic' => array(
        'function' => 'm_undelete_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64),
        ),
    ),
    'm_undelete_post' => array(
        'function' => 'm_undelete_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64),
        ),
    ),

    /*'m_delete_post_by_user' => array( NO LONGER EXISTS
        'function' => 'm_delete_post_by_user_func',
        'signature' => array(array($xmlrpcStruct,$xmlrpcString,$xmlrpcBase64)),
    ),*/

    'm_move_topic' => array(
        'function' => 'm_move_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBoolean),
        ),
    ),

    'm_rename_topic' => array(
        'function' => 'm_rename_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcBase64)),
    ),

    'm_move_post' => array(
        'function' => 'm_move_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBase64, $xmlrpcString),
        ),
    ),

    'm_merge_topic' => array(
        'function' => 'm_merge_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBoolean)),
    ),

    'm_get_moderate_topic' => array(
        'function' => 'm_get_moderate_topic_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),
    'm_get_moderate_post' => array(
        'function' => 'm_get_moderate_post_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),

    'm_approve_topic' => array(
        'function' => 'm_approve_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),
    'm_approve_post' => array(
        'function' => 'm_approve_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),

    'm_ban_user' => array(
        'function' => 'm_ban_user_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcInt, $xmlrpcBase64, $xmlrpcInt)),
    ),

    'm_get_report_post' => array(
        'function' => 'm_get_report_post_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),

    'reset_push_slug' => array(
        'function' => 'reset_push_slug_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcStruct, $xmlrpcBase64, $xmlrpcBase64)),
    ),

    'get_alert' => array(
        'function' => 'get_alert_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcInt),
                             array($xmlrpcStruct)),
    ),

    'prefetch_account' => array(
        'function' => 'prefetch_account_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcBase64)),
    ),

    'm_unban_user' => array(
        'function' => 'm_unban_user_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'get_contact' => array(
        'function' => 'get_contact_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct)),
    ),

    'm_close_report' => array(
        'function' => 'm_close_report_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'update_signature' => array(
        'function' => 'update_signature_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcBase64)),
    ),

    'get_topic_participants' => array(
        'function' => 'get_topic_participants_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt)),
    ),

    /*'activate_account' => array(  NO LONGER EXISTS
          'function' => 'activate_account_func',
          'signature' => array(array($xmlrpcStruct, $xmlrpcBase64, $xmlrpcString, $xmlrpcString)),
     ),*/

    'set_api_key' => array(
        'function' => 'set_api_key_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'verify_connection' => array(
        'function' => 'verify_connection_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'sync_user' => array(
        'function' => 'sync_user_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_contact' => array(
        'function' => 'get_contact_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'user_subscription' => array(
        'function' => 'user_subscription_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'push_content_check' => array(
        'function' => 'push_content_check_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    // Added missing ones...

    'get_participated_forum' => array(
        'function' => 'get_participated_forum_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_forum_status' => array(
        'function' => 'get_forum_status_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcArray)),
    ),

    'get_smilies' => array(
        'function' => 'get_smilies_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'login_mod' => array(
        'function' => 'login_mod_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),

    'm_merge_post' => array(
        'function' => 'm_merge_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),

    'm_get_delete_topic' => array(
        'function' => 'm_get_delete_topic_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),
    'm_get_delete_post' => array(
        'function' => 'm_get_delete_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt)),
    ),

    'm_mark_as_spam' => array(
        'function' => 'm_mark_as_spam_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'create_message' => array(
        'function' => 'create_message_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcArray, $xmlrpcBase64, $xmlrpcBase64),
                             array($xmlrpcStruct, $xmlrpcArray, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcInt),
                             array($xmlrpcStruct, $xmlrpcArray, $xmlrpcBase64, $xmlrpcBase64, $xmlrpcInt, $xmlrpcString),
        ),
    ),

    'get_box_info' => array(
        'function' => 'get_box_info_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'get_box' => array(
        'function' => 'get_box_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString),
                             array($xmlrpcStruct, $xmlrpcString, $xmlrpcInt, $xmlrpcInt),
        ),
    ),

    'get_message' => array(
        'function' => 'get_message_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString, $xmlrpcBoolean)),
    ),

    'get_quote_pm' => array(
        'function' => 'get_quote_pm_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'delete_message' => array(
        'function' => 'delete_message_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),

    'mark_pm_unread' => array(
        'function' => 'mark_pm_unread_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcString),
        ),
    ),
    'mark_pm_read' => array(
        'function' => 'mark_pm_read_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcString),
        ),
    ),

    'thank_post' => array(
        'function' => 'thank_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'follow' => array(
        'function' => 'follow_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),
    'unfollow' => array(
        'function' => 'unfollow_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'like_post' => array(
        'function' => 'like_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),
    'unlike_post' => array(
        'function' => 'unlike_post_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString)),
    ),

    'get_dashboard' => array(
        'function' => 'get_dashboard_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcBoolean),
        ),
    ),

    'get_feed' => array(
        'function' => 'get_feed_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcString),
        ),
    ),

    'get_following' => array(
        'function' => 'get_following_func',
        'signature' => array(array($xmlrpcStruct)),
    ),
    'get_follower' => array(
        'function' => 'get_follower_func',
        'signature' => array(array($xmlrpcStruct)),
    ),

    'set_reputation' => array(
        'function' => 'set_reputation_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),

    'get_activity' => array(
        'function' => 'get_activity_func',
        'signature' => array(array($xmlrpcStruct),
                             array($xmlrpcStruct, $xmlrpcInt, $xmlrpcInt),
        ),
    ),

    'mark_topic_read' => array(
        'function' => 'mark_topic_read_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcArray)),
    ),

    'get_topic_status' => array(
        'function' => 'get_topic_status_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcArray)),
    ),

    // Added by us, as will be needed in future by official client. Wanted to give a good starting example

    'get_real_url' => array(
        'function' => 'get_real_url_func',
        'signature' => array(array($xmlrpcStruct, $xmlrpcString, $xmlrpcString)),
    ),
);

// We don't want to define signatures outside dev-mode, because parameters may be added in the mobile clients over time
if (!$GLOBALS['DEV_MODE']) {
    foreach ($SERVER_DEFINE as $endpoint => $details) {
        unset($details['signature']);
    }
}
