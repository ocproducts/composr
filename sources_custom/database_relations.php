<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * Find how tables might be ignored for backups etc.
 * This is mainly used for building unit tests that make sure things are consistently implemented.
 *
 * @return array List of tables and their status regarding being ignored for backups etc
 */
function get_table_purpose_flags()
{
    $ret = non_overridden__get_table_purpose_flags();
    $more = array(
        'activities' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'bank' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'bookable' => TABLE_PURPOSE__NORMAL,
        'bookable_blacked' => TABLE_PURPOSE__NORMAL,
        'bookable_blacked_for' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under bookable*/,
        'bookable_codes' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under bookable*/,
        'bookable_supplement' => TABLE_PURPOSE__NORMAL,
        'bookable_supplement_for' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under bookable*/,
        'booking' => TABLE_PURPOSE__NORMAL,
        'booking_supplement' => TABLE_PURPOSE__NORMAL,
        'classifieds_prices' => TABLE_PURPOSE__NORMAL,
        'community_billboard' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'credit_charge_log' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'credit_purchases' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'device_token_details' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'diseases' => TABLE_PURPOSE__NORMAL,
        'giftr' => TABLE_PURPOSE__NORMAL,
        'iotd' => TABLE_PURPOSE__NORMAL,
        'locations' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__AUTOGEN_STATIC,
        'logged' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE,
        'mayfeature' => TABLE_PURPOSE__NORMAL,
        'members_diseases' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'members_gifts' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'members_mentors' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE | TABLE_PURPOSE__SUBDATA/*under f_members*/,
        'referees_qualified_for' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'referrer_override' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'reported_content' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE | TABLE_PURPOSE__SUBDATA/*under <content>*/,
        'sites' => TABLE_PURPOSE__NORMAL,
        'sites_advert_pings' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE,
        'sites_deletion_codes' => TABLE_PURPOSE__NORMAL,
        'sites_email' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under sites*/,
        'test_sections' => TABLE_PURPOSE__NORMAL,
        'tests' => TABLE_PURPOSE__NORMAL,
        'tutorials_external' => TABLE_PURPOSE__NORMAL,
        'tutorials_external_tags' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__AUTOGEN_STATIC/*under tutorials_external*/,
        'tutorials_internal' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE | TABLE_PURPOSE__AUTOGEN_STATIC,
        'workflow_approval_points' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under workflows*/,
        'workflow_content' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE | TABLE_PURPOSE__SUBDATA/*under <content>*/,
        'workflow_content_status' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE | TABLE_PURPOSE__SUBDATA/*under <content>*/,
        'workflow_permissions' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__SUBDATA/*under workflows*/,
        'workflows' => TABLE_PURPOSE__NORMAL,
        'w_attempts' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'w_inventory' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'w_itemdef' => TABLE_PURPOSE__NORMAL,
        'w_items' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'w_members' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
        'w_messages' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE,
        'w_portals' => TABLE_PURPOSE__NORMAL,
        'w_realms' => TABLE_PURPOSE__NORMAL,
        'w_rooms' => TABLE_PURPOSE__NORMAL,
        'w_travelhistory' => TABLE_PURPOSE__NORMAL | TABLE_PURPOSE__FLUSHABLE_AGGRESSIVE,
    );
    foreach ($more as $table => $flags) {
        $ret[$table] = $flags | TABLE_PURPOSE__NON_BUNDLED;
    }
    return $ret;
}

function get_all_tables()
{
    $_tables = $GLOBALS['SITE_DB']->query_select('db_meta', array('*'));
    $all_tables = array();
    foreach ($_tables as $t) {
        if (!isset($all_tables[$t['m_table']])) {
            $all_tables[$t['m_table']] = array();
        }

        $all_tables[$t['m_table']][$t['m_name']] = $t['m_type'];
    }
    unset($_tables);
    $all_tables['anything'] = array('id' => '*ID_TEXT');

    return $all_tables;
}

function get_innodb_table_sql($tables, $all_tables)
{
    $out = '';

    $relations = array();
    $relation_map = get_relation_map();

    $i = 0;
    $table_prefix = get_table_prefix();
    for ($loop_it = 0; $loop_it < count($tables); $loop_it++) {
        $tables_keys = array_keys($tables);
        $tables_values = array_values($tables);

        $table = $tables_keys[$loop_it];

        if ($table == 'translate') {
            continue; // Only used in multi-lang mode, which is the exception
        }

        $fields = $tables_values[$loop_it];

        $_i = strval($i);
        $out .= "    CREATE TABLE {$table_prefix}{$table}
        (\n";
        $keys = array();
        $type_remap = get_innodb_data_types();
        foreach ($fields as $field => $type) {
            $_type = $type_remap[str_replace(array('*', '?'), array('', ''), $type)];
            $nullness = (strpos($type, '*') !== false) ? 'NULL' : 'NOT NULL';
            $out .= "         {$field} {$_type} {$nullness},\n";
            if (strpos($type, '*') !== false) {
                $keys[] = $field;
            }
            if ((strpos($type, 'AUTO_LINK') !== false) || (array_key_exists($table . '.' . $field, $relation_map))) {
                $relations[$table . '.' . $field] = $relation_map[$table . '.' . $field];
            }
            if (strpos($type, 'MEMBER') !== false) {
                $relations[$table . '.' . $field] = 'f_members.id';
            }
            if (strpos($type, 'GROUP') !== false) {
                $relations[$table . '.' . $field] = 'f_groups.id';
            }
            /*if (strpos($type, 'TRANS') !== false) {   We don't bother showing this anymore
                $relations[$table . '.' . $field] = 'translate.id';
            }*/
            if ((strpos($field, 'author') !== false) && ($type == 'ID_TEXT') && ($table != 'authors') && ($field != 'block_author') && ($field != 'module_author')) {
                $relations[$table . '.' . $field] = 'authors.author';
            }

            if (isset($relations[$table . '.' . $field])) {
                $mapped_table = preg_replace('#\..*$#', '', $relations[$table . '.' . $field]);
                if (!isset($tables[$mapped_table])) {
                    $tables[$mapped_table] = $all_tables[$mapped_table];
                }
            }
        }
        $out .= "       PRIMARY KEY (";
        foreach ($keys as $it => $key) {
            if ($it != 0) {
                $out .= ',';
            }
            $out .= $key;
        }
        $out .= ")
        ) TYPE=InnoDB;\n\n";

        $i++;
    }

    foreach ($relations as $from => $to) {
        $from_table = preg_replace('#\..*$#', '', $from);
        $to_table = preg_replace('#\..*$#', '', $to);
        $from_field = preg_replace('#^.*\.#', '', $from);
        $to_field = preg_replace('#^.*\.#', '', $to);
        $source_id = strval(array_search($from_table, array_keys($tables)));
        $target_id = strval(array_search($to_table, array_keys($tables)));
        $out .= "
        CREATE INDEX `{$from}` ON {$table_prefix}{$from_table}({$from_field});
        ALTER TABLE {$table_prefix}{$from_table} ADD FOREIGN KEY `{$from}` ({$from_field}) REFERENCES {$table_prefix}{$to_table} ({$to_field});\n";
    }

    return $out;
}

function get_innodb_data_types()
{
    $type_remap = array(
        'AUTO' => 'integer auto_increment', // USUALLY IS UNSIGNED, BUT WE NEED KEY CONSISTENCY HERE
        'AUTO_LINK' => 'integer', // not unsigned because it's useful to have -ve for temporary usage while importing
        'INTEGER' => 'integer',
        'UINTEGER' => 'integer unsigned',
        'SHORT_INTEGER' => 'tinyint',
        'REAL' => 'real',
        'BINARY' => 'tinyint(1)',
        'MEMBER' => 'integer', // not unsigned because it's useful to have -ve for temporary usage while importing
        'GROUP' => 'integer', // not unsigned because it's useful to have -ve for temporary usage while importing
        'TIME' => 'integer unsigned',
        'LONG_TRANS' => 'integer', // USUALLY IS UNSIGNED, BUT WE NEED KEY CONSISTENCY HERE
        'SHORT_TRANS' => 'integer', // USUALLY IS UNSIGNED, BUT WE NEED KEY CONSISTENCY HERE
        'LONG_TRANS__COMCODE' => 'integer', // USUALLY IS UNSIGNED, BUT WE NEED KEY CONSISTENCY HERE
        'SHORT_TRANS__COMCODE' => 'integer', // USUALLY IS UNSIGNED, BUT WE NEED KEY CONSISTENCY HERE
        'SHORT_TEXT' => 'varchar(255)',
        'LONG_TEXT' => 'longtext',
        'ID_TEXT' => 'varchar(80)',
        'MINIID_TEXT' => 'varchar(40)',
        'IP' => 'varchar(40)', // 15 for ip4, but we now support ip6
        'LANGUAGE_NAME' => 'varchar(5)',
        'URLPATH' => 'varchar(255)',
    );

    return $type_remap;
}

function get_tables_by_addon()
{
    $tables = collapse_1d_complexity('m_table', $GLOBALS['SITE_DB']->query_select('db_meta', array('DISTINCT m_table')));
    $tables = array_combine($tables, array_fill(0, count($tables), '1'));

    $hooks = find_all_hooks('systems', 'addon_registry');
    $tables_by = array();
    foreach (array_keys($hooks) as $hook) {
        require_code('hooks/systems/addon_registry/' . filter_naughty($hook));
        $object = object_factory('Hook_addon_registry_' . $hook);
        $files = $object->get_file_list();
        $addon_name = $hook;
        foreach ($files as $file) {
            if ((strpos($file, 'blocks/') !== false) || (strpos($file, 'pages/modules') !== false) || (strpos($file, 'hooks/systems/addon_registry') !== false)) {
                $file_contents = file_get_contents(get_file_base() . '/' . $file);

                $matches = array();
                $num_matches = preg_match_all("#create\_table\('([^']+)'#", $file_contents, $matches);
                for ($i = 0; $i < $num_matches; $i++) {
                    $table_name = $matches[1][$i];
                    if (strpos($file_contents, "/*\$GLOBALS['SITE_DB']->create_table('" . $table_name . "'") === false) {
                        if ($table_name == 'group_page_access') {
                            $addon_name = 'core';
                        }
                        if ($table_name == 'group_zone_access') {
                            $addon_name = 'core';
                        }

                        if (!isset($tables_by[$addon_name])) {
                            $tables_by[$addon_name] = array();
                        }
                        $tables_by[$addon_name][] = $table_name;
                        unset($tables[$table_name]);
                    }
                }
            }
        }
    }

    foreach (array_keys($tables) as $table) {
        if (substr($table, 0, 2) == 'f_') {
            $tables_by['core_cns'][] = $table;
        } else {
            $tables_by['core'][] = $table;
        }
    }

    ksort($tables_by);

    return $tables_by;
}

function get_table_descriptions()
{
    $table_descriptions = array(
        'alternative_ids' => 'different sets of IDs for a database ID, allowing more robust cross-site or label based content referencing',
        'adminlogs' => 'stores logs of actions performed on the website',
        'attachment_refs' => 'stores references of what content uses what attachments (it allows attachment permissions to work, as it tells Composr what \'owner\' content to verify permissions against)',
        'attachments' => 'attachments referenced by Comcode (images, downloads, videos, etc)',
        'autosave' => 'stores unsaved form data in case of browser crashes, called by AJAX',
        'blocks' => 'a registry of all installed blocks',
        'cache' => 'data caching, especially block caching',
        'cache_on' => 'a registry of what cacheable things are cached by what parameters',
        'config' => 'all the configuration settings that have been saved',
        'edit_pings' => 'used to stop people editing the same thing at the same time (AJAX)',
        'failedlogins' => 'a log of all failed logins',
        'group_category_access' => 'defines what groups may access what categories',
        'group_page_access' => 'defines what groups may access what pages',
        'group_zone_access' => 'defines what groups may access what zones',
        'group_privileges' => 'defines what groups have what privileges',
        'https_pages' => 'lists pages that the webmaster has decided need to run over SSL',
        'incoming_uploads' => 'temporary storage of uploaded files, before main form submission',
        'link_tracker' => 'outgoing click tracking (not really used much)',
        'logged_mail_messages' => 'logged emails (so you can check incorrect emails aren\'t going out) / email queuing',
        'member_category_access' => 'defines what members may access what categories (rarely used, no admin UI)',
        'member_page_access' => 'defines what members may access what pages (rarely used, no admin UI)',
        'member_tracking' => 'tracks the locations of online users',
        'member_zone_access' => 'defines what members may access what zones (rarely used, no admin UI)',
        'menu_items' => 'stores all the items shown on menus (except auto-generated ones)',
        'messages_to_render' => 'stores messages that have been queued up for display on a members browser (e.g. if they have just been redirected after completing something, so a status message will be queued for display after they\'ve been redirected)',
        'modules' => 'registry of all installed modules',
        'member_privileges' => 'defines what members have what privileges (rarely used, no admin UI)',
        'notifications_enabled' => 'what notifications members receive',
        'rating' => 'stores ratings for all kinds of content (rating_for_type determines what kind of content, rating_for_id determines what ID of content within that type)',
        'review_supplement' => 'stores reviews for all kinds of content',
        'captchas' => 'stores CAPTCHA image expectations, so Composr can check what they entered against what they were asked to enter',
        'seo_meta' => 'stores meta descriptions for all kinds of content',
        'seo_meta_keywords' => 'stores meta keywords for all kinds of content',
        'sessions' => 'stores user sessions, for guests and members (session ID\'s are treated with high security)',
        'sitemap_cache' => 'a cache of all addressable sitemap nodes for building out the full XML sitemaps across multiple files iteratively, which is extremely intensive on large sites',
        'sms_log' => 'logs what SMS messages were sent out on behalf of what users and when',
        'privilege_list' => 'a list of all the privileges available (aka privileges)',
        'staff_tips_dismissed' => 'stores what webmaster tips (Admin Zone front page) have been read so far',
        'trackbacks' => 'stores trackbacks for all kinds of content',
        'tracking' => 'stores tracking for all content that supports it except forum/topic tracking (Composr 4.2 doesn\'t really use this table much, except for the staff-messaging tracking)',
        'translate' => 'very important table, stores most of the text; this table exists to internationalise content and also to store compiled Comcode',
        'translate_history' => 'used by Conversr to store old versions of posts, but potentially any addon can use this so long as it maintains it (think of it as a revision history store that can work on a per-field level)',
        'tutorial_links' => 'used by the Composr documentation, don\'t worry about this table',
        'url_id_monikers' => 'stores search-engine-friendly URL codes for all kinds of content (we call these "monikers")',
        'url_title_cache' => 'stores the HTML titles for URLs, used in particular by the Comcode parser when it auto-detects links, and the media rendering system',
        'urls_checked' => 'stores whether URLs exists, may be used by any system within Composr',
        'banned_ip' => 'list of banned IP addresses (Composr will use .htaccess also if it can, to improve performance)',
        'usersubmitban_member' => 'list of banned members',
        'webstandards_checked_once' => 'this is used by the inbuilt XHTML checker to know what markup it has already checked, so it doesn\'t waste a lot of time re-checking the same stuff; it uses a hash-signature-check so it doesn\'t need to store all data in the table',
        'values' => 'arbitrary store of data values (mapping of keys to values)',
        'values_elective' => 'arbitrary store of lengthy/elective data values (mapping of keys to values)',
        'zones' => 'details of all zones on the website',
        'content_primary__members' => 'sets content privacy',
        'content_regions' => 'sets the regions content may be viewed from',
    );

    return $table_descriptions;
}

function get_relation_map()
{
    $relation_map = array(
        'transaction.linked' => 'transactions.id',
        'catalogue_categories.c_name' => 'catalogues.c_name',
        'catalogue_fields.c_name' => 'catalogues.c_name',
        'catalogue_entries.c_name' => 'catalogues.c_name',
        'banners.b_type' => 'banner_types.id',
        'banners_types.b_type' => 'banner_types.id',
        'banners_types.b_name' => 'banners.name',
        'galleries.parent_id' => 'galleries.name',
        'galleries.g_owner' => 'f_members.id',
        'images.cat' => 'galleries.name',
        'videos.cat' => 'galleries.name',
        'import_id_remap.id_old' => 'anything.id',
        'import_id_remap.id_new' => 'anything.id',
        'seo_meta.meta_for_id' => 'anything.id',
        'attachment_refs.r_referer_id' => 'anything.id',
        'attachment_refs.a_id' => 'attachments.id',
        'trackbacks.trackback_for_id' => 'anything.id',
        'group_category_access.category_name' => 'anything.id',
        'member_category_access.category_name' => 'anything.id',
        'member_zone_access.zone_name' => 'zones.zone_name',
        'member_page_access.zone_name' => 'zones.zone_name',
        'member_page_access.page_name' => 'modules.module_the_name',
        'member_privileges.privilege' => 'privilege_list.the_name',
        'member_privileges.category_name' => 'anything.id',
        'member_privileges.the_page' => 'modules.module_the_name',
        'group_privileges.privilege' => 'privilege_list.the_name',
        'group_privileges.the_page' => 'modules.module_the_name',
        'group_privileges.category_name' => 'anything.id',
        'url_id_monikers.m_resource_id' => 'anything.id',
        'url_monikers.m_resource_page' => 'modules.module_the_name',
        'review_supplement.r_rating_for_id' => 'modules.module_the_name',
        'rating.rating_for_id' => 'modules.module_the_name',
        'comcode_page.zone' => 'zones.zone_name',
        'cached_comcode_pages.the_zone' => 'zones.zone_name',
        'redirects.r_from_zone' => 'zones.zone_name',
        'redirects.r_to_zone' => 'zones.zone_name',
        'group_zone_access.zone_name' => 'zones.zone_name',
        'group_page_access.zone_name' => 'zones.zone_name',
        'pstore_permissions.p_privilege' => 'privilege_list.the_name',
        'pstore_permissions.p_zone' => 'zones.zone_name',
        'pstore_permissions.p_page' => 'modules.module_the_name',
        'pstore_permissions.p_category' => 'anything.id',
        'sales.purcase_type' => 'prices.name',
        'sessions.zone_name' => 'zones.zone_name',
        'f_multi_moderations.mm_move_to' => 'f_forums.id',
        'f_member_cpf_perms.field_id' => 'f_custom_fields.id',
        'f_forums.f_forum_grouping_id' => 'f_forum_groupings.id',
        'f_forums.f_parent_forum' => 'f_forums.id',
        'f_forums.f_cache_last_topic_id' => 'f_topics.id',
        'f_forums.f_cache_last_forum_id' => 'f_forums.id',
        'f_topics.t_forum_id' => 'f_forums.id',
        'f_topics.t_poll_id' => 'f_polls.id',
        'f_topics.t_cache_first_post_id' => 'f_posts.id',
        'f_topics.t_cache_last_post_id' => 'f_posts.id',
        'f_posts.p_topic_id' => 'f_topics.id',
        'f_posts.p_cache_forum_id' => 'f_forums.id',
        'f_special_pt_access.s_topic_id' => 'f_topics.id',
        'f_post_history.h_post_id' => 'f_posts.id',
        'f_post_history.h_topic_id' => 'f_topics.id',
        'f_forum_intro_ip.i_forum_id' => 'f_forums.id',
        'f_forum_intro_member.i_forum_id' => 'f_forums.id',
        'f_poll_answers.pa_poll_id' => 'f_polls.id',
        'f_poll_votes.pv_poll_id' => 'f_polls.id',
        'f_poll_votes.pv_answer_id' => 'f_poll_answers.id',
        'f_warnings.p_silence_from_topic' => 'f_topics.id',
        'f_warnings.p_silence_from_forum' => 'f_forums.id',
        'f_read_logs.l_topic_id' => 'f_topics.id',
        'f_forum_tracking.r_forum_id' => 'f_forums.id',
        'f_topic_tracking.r_topic_id' => 'f_topics.id',
        'f_usergroup_sub_mails.m_usergroup_sub_id' => 'f_usergroup_subs.id',
        'menu_items.i_parent' => 'menu_items.id',
        'translate_history.lang_id' => 'translate.id',
        'messages_to_render.r_session_id' => 'sessions.the_session',
        'review_supplement.r_post_id' => 'f_posts.id',
        'review_supplement.r_topic_id' => 'f_topics.id',
        'award_archive.a_type_id' => 'award_types.id',
        'calendar_events.e_type' => 'calendar_types.id',
        'calendar_reminders.e_id' => 'calendar_events.id',
        'calendar_interests.t_type' => 'calendar_types.id',
        'calendar_jobs.j_reminder_id' => 'calendar_reminders.id',
        'calendar_jobs.j_event_id' => 'calendar_events.id',
        'catalogue_categories.cc_parent_id' => 'catalogue_categories.id',
        'catalogue_categories.cc_move_target' => 'catalogue_categories.id',
        'catalogue_entries.cc_id' => 'catalogue_categories.id',
        'catalogue_efv_long_trans.cf_id' => 'catalogue_fields.id',
        'catalogue_efv_long_trans.ce_id' => 'catalogue_entries.id',
        'catalogue_efv_long.cf_id' => 'catalogue_fields.id',
        'catalogue_efv_long.ce_id' => 'catalogue_entries.id',
        'catalogue_efv_short_trans.cf_id' => 'catalogue_fields.id',
        'catalogue_efv_short_trans.ce_id' => 'catalogue_entries.id',
        'catalogue_efv_short.cf_id' => 'catalogue_fields.id',
        'catalogue_efv_short.ce_id' => 'catalogue_entries.id',
        'catalogue_efv_float.cf_id' => 'catalogue_fields.id',
        'catalogue_efv_float.ce_id' => 'catalogue_entries.id',
        'catalogue_efv_integer.cf_id' => 'catalogue_fields.id',
        'catalogue_efv_integer.ce_id' => 'catalogue_entries.id',
        'wiki_changes.the_page' => 'wiki_pages.id',
        'wiki_children.parent_id' => 'wiki_pages.id',
        'wiki_children.child_id' => 'wiki_pages.id',
        'wiki_posts.page_id' => 'wiki_pages.id',
        'chat_messages.room_id' => 'chat_rooms.id',
        'chat_events.e_room_id' => 'chat_rooms.id',
        'chat_active.room_id' => 'chat_rooms.id',
        'download_categories.parent_id' => 'download_categories.id',
        'download_downloads.category_id' => 'download_categories.id',
        'download_downloads.out_mode_id' => 'download_downloads.id',
        'download_downloads.download_licence' => 'download_licences.id',
        'download_logging.id' => 'download_downloads.id',
        'news.news_category' => 'news_categories.id',
        'news_category_entries.news_entry' => 'news.id',
        'news_category_entries.news_entry_category' => 'news_categories.id',
        'newsletter_subscribe.newsletter_id' => 'newsletters.id',
        'quiz_member_last_visit.v_quiz_id' => 'quizzes.id',
        'quizzes.q_tied_newsletter' => 'newsletters.id',
        'quiz_questions.q_quiz' => 'quizzes.id',
        'quiz_question_answers.q_question' => 'quiz_questions.id',
        'quiz_winner.q_quiz' => 'quizzes.id',
        'quiz_winner.q_entry' => 'quiz_entries.id',
        'quiz_entries.q_quiz' => 'quizzes.id',
        'quiz_entry_answer.q_entry' => 'quiz_entries.id',
        'quiz_entry_answer.q_question' => 'quiz_questions.id',
        'shopping_cart.ordered_by' => 'f_members.id',
        'shopping_cart.product_id' => 'catalogue_entries.id',
        'shopping_order_details.order_id' => 'shopping_order.id',
        'shopping_order_details.p_id' => 'catalogue_entries.id',
        'shopping_order_addresses.order_id' => 'shopping_order.id',
        'tickets.topic_id' => 'f_topics.id',
        'tickets.forum_id' => 'f_forums.id',
        'tickets.ticket_type' => 'ticket_types.id',
        'poll_votes.v_poll_id' => 'poll.poll_id',
        'catalogue_cat_treecache.cc_id' => 'catalogue_categories.id',
        'catalogue_cat_treecache.cc_ancestor_id' => 'catalogue_categories.id',
        'catalogue_childcountcache.cc_id' => 'catalogue_categories.id',
        'catalogue_entry_linkage.catalogue_entry_id' => 'catalogue_entries.id',
        'f_posts.p_parent_id' => 'f_posts.id',
        'temp_block_permissions.p_session_id' => 'sessions.id',
        'video_transcoding.t_local_id' => 'videos.id',
        'f_welcome_emails.w_newsletter' => 'newsletters.id',
        'f_welcome_emails.w_usergroup' => 'f_groups.id',
        'f_group_join_log.usergroup_id' => 'f_groups.id',
    );

    return $relation_map;
}
