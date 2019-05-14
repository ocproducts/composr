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
 * Add a forum grouping.
 *
 * @param  SHORT_TEXT $title The title of the forum grouping.
 * @param  SHORT_TEXT $description The description of the forum grouping.
 * @param  BINARY $expanded_by_default Whether the forum grouping will be shown expanded by default (as opposed to contracted, where contained forums will not be shown until expansion).
 * @return AUTO_LINK The ID of the forum grouping just added.
 */
function cns_make_forum_grouping($title, $description, $expanded_by_default = 1)
{
    require_code('global4');
    prevent_double_submit('ADD_FORUM_GROUPING', null, $title);

    $forum_grouping_id = $GLOBALS['FORUM_DB']->query_insert('f_forum_groupings', array(
        'c_title' => $title,
        'c_description' => $description,
        'c_expanded_by_default' => $expanded_by_default
    ), true);

    log_it('ADD_FORUM_GROUPING', strval($forum_grouping_id), $title);

    if ((addon_installed('commandr')) && (!running_script('install')) && (!get_mass_import_mode())) {
        require_code('resource_fs');
        generate_resource_fs_moniker('forum_grouping', strval($forum_grouping_id), null, null, true);
    }

    return $forum_grouping_id;
}

/**
 * Make a forum.
 *
 * @param  SHORT_TEXT $name The name of the forum.
 * @param  SHORT_TEXT $description The description for the forum.
 * @param  ?AUTO_LINK $forum_grouping_id What forum grouping the forum will be filed with (null: this is the root forum).
 * @param  ?array $access_mapping Permission map (null: do it the standard way, outside of this function). This parameter is for import/compatibility only and works upon an emulation of 'access levels' (ala Composr 2.5/2.6), and it is recommended to use the normal crud_module functionality for permissions setting.
 * @param  ?AUTO_LINK $parent_forum The ID of the parent forum (null: this is the root forum).
 * @param  integer $position The position of this forum relative to other forums viewable on the same screen (if parent forum hasn't specified automatic ordering).
 * @param  BINARY $post_count_increment Whether post counts will be incremented if members post in the forum.
 * @param  BINARY $order_sub_alpha Whether the ordering of subforums is done automatically, alphabetically).
 * @param  LONG_TEXT $intro_question The question that is shown for newbies to the forum (blank: none).
 * @param  SHORT_TEXT $intro_answer The answer to the question (blank: no specific answer.. if there's a 'question', it just requires a click-through).
 * @param  SHORT_TEXT $redirection Either blank for no redirection, the ID of another forum we are mirroring, or a URL to redirect to.
 * @param  ID_TEXT $order The order the topics are shown in, by default.
 * @param  BINARY $is_threaded Whether the forum is threaded.
 * @param  BINARY $allows_anonymous_posts Whether anonymous posts are allowed
 * @return AUTO_LINK The ID of the newly created forum.
 */
function cns_make_forum($name, $description, $forum_grouping_id, $access_mapping, $parent_forum, $position = 1, $post_count_increment = 1, $order_sub_alpha = 0, $intro_question = '', $intro_answer = '', $redirection = '', $order = 'last_post', $is_threaded = 0, $allows_anonymous_posts = 0)
{
    require_code('global4');
    prevent_double_submit('ADD_FORUM', null, $name);

    if ($forum_grouping_id == -1) {
        $forum_grouping_id = null;
    }
    if ($parent_forum == -1) {
        $parent_forum = null;
    }

    if (!get_mass_import_mode()) {
        if ((!is_null($forum_grouping_id)) && (function_exists('cns_ensure_forum_grouping_exists'))) {
            cns_ensure_forum_grouping_exists($forum_grouping_id);
        }
        if ((!is_null($parent_forum)) && (function_exists('cns_ensure_forum_exists'))) {
            cns_ensure_forum_exists($parent_forum);
        }
    }

    $map = array(
        'f_name' => $name,
        'f_forum_grouping_id' => $forum_grouping_id,
        'f_parent_forum' => $parent_forum,
        'f_position' => $position,
        'f_order_sub_alpha' => $order_sub_alpha,
        'f_post_count_increment' => $post_count_increment,
        'f_intro_answer' => $intro_answer,
        'f_cache_num_topics' => 0,
        'f_cache_num_posts' => 0,
        'f_cache_last_topic_id' => null,
        'f_cache_last_forum_id' => null,
        'f_cache_last_title' => '',
        'f_cache_last_time' => null,
        'f_cache_last_username' => '',
        'f_cache_last_member_id' => null,
        'f_redirection' => $redirection,
        'f_order' => $order,
        'f_is_threaded' => $is_threaded,
        'f_allows_anonymous_posts' => $allows_anonymous_posts,
    );
    $map += insert_lang_comcode('f_description', $description, 2, $GLOBALS['FORUM_DB']);
    $map += insert_lang_comcode('f_intro_question', $intro_question, 3, $GLOBALS['FORUM_DB']);
    $forum_id = $GLOBALS['FORUM_DB']->query_insert('f_forums', $map, true);

    // Set permissions
    if (!is_null($access_mapping)) {
        $groups = $GLOBALS['CNS_DRIVER']->get_usergroup_list(false, true);

        $cat_ins_module_the_name = array();
        $cat_ins_category_name = array();
        $cat_ins_group_id = array();

        $ins_privilege = array();
        $ins_group_id = array();
        $ins_the_page = array();
        $ins_module_the_name = array();
        $ins_category_name = array();
        $ins_the_value = array();

        foreach (array_keys($groups) as $group_id) {
            $level = 0; // No-access
            if (array_key_exists($group_id, $access_mapping)) {
                $level = $access_mapping[$group_id];
            }

            if ($level >= 1) { // Access
                $cat_ins_module_the_name[] = 'forums';
                $cat_ins_category_name[] = strval($forum_id);
                $cat_ins_group_id[] = $group_id;

                if ($level == 1) { // May not post - so specifically override to say this
                    $ins_privilege[] = 'submit_lowrange_content';
                    $ins_group_id[] = $group_id;
                    $ins_the_page[] = '';
                    $ins_module_the_name[] = 'forums';
                    $ins_category_name[] = strval($forum_id);
                    $ins_the_value[] = 0;

                    $ins_privilege[] = 'submit_midrange_content';
                    $ins_group_id[] = $group_id;
                    $ins_the_page[] = '';
                    $ins_module_the_name[] = 'forums';
                    $ins_category_name[] = strval($forum_id);
                    $ins_the_value[] = 0;
                }
                if ($level >= 3) {
                    $ins_privilege[] = 'bypass_validation_lowrange_content';
                    $ins_group_id[] = $group_id;
                    $ins_the_page[] = '';
                    $ins_module_the_name[] = 'forums';
                    $ins_category_name[] = strval($forum_id);
                    $ins_the_value[] = 1;
                }
                if ($level >= 4) {
                    $ins_privilege[] = 'bypass_validation_midrange_content';
                    $ins_group_id[] = $group_id;
                    $ins_the_page[] = '';
                    $ins_module_the_name[] = 'forums';
                    $ins_category_name[] = strval($forum_id);
                    $ins_the_value[] = 1;
                }
                // 2=May post, [3=May post instantly , 4=May start topics instantly , 5=Moderator  --  these ones will not be treated specially, so as to avoid overriding permissions unnecessary - let the admins configure it optimally manually]
            }
        }

        $GLOBALS['FORUM_DB']->query_insert('group_category_access', array(
            'module_the_name' => $cat_ins_module_the_name,
            'category_name' => $cat_ins_category_name,
            'group_id' => $cat_ins_group_id
        ));

        $GLOBALS['FORUM_DB']->query_insert('group_privileges', array(
            'privilege' => $ins_privilege,
            'group_id' => $ins_group_id,
            'the_page' => $ins_the_page,
            'module_the_name' => $ins_module_the_name,
            'category_name' => $ins_category_name,
            'the_value' => $ins_the_value,
        ));
    }

    log_it('ADD_FORUM', strval($forum_id), $name);

    if ((addon_installed('commandr')) && (!running_script('install')) && (!get_mass_import_mode())) {
        require_code('resource_fs');
        generate_resource_fs_moniker('forum', strval($forum_id), null, null, true);
    }

    if ((!is_null($parent_forum)) && (!running_script('install'))) {
        require_code('notifications2');
        copy_notifications_to_new_child('cns_topic', strval($parent_forum), strval($forum_id));
    }

    require_code('member_mentions');
    dispatch_member_mention_notifications('forum', strval($forum_id));

    require_code('sitemap_xml');
    if ($forum_id == db_get_first_id()) {
        $sitemap_priority = SITEMAP_IMPORTANCE_ULTRA;
    } else {
        if ($parent_forum == db_get_first_id()) {
            $sitemap_priority = SITEMAP_IMPORTANCE_HIGH;
        } else {
            $sitemap_priority = SITEMAP_IMPORTANCE_MEDIUM;
        }
    }
    notify_sitemap_node_add('_SEARCH:forumview:id=' . strval($forum_id), null, null, $sitemap_priority, 'monthly', has_category_access($GLOBALS['FORUM_DRIVER']->get_guest_id(), 'forums', strval($forum_id)));

    return $forum_id;
}
