DROP TABLE IF EXISTS cms_member_privileges;

CREATE TABLE cms_member_privileges (
    member_id integer NOT NULL,
    privilege varchar(80) NOT NULL,
    the_page varchar(80) NOT NULL,
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    the_value tinyint(1) NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (member_id, privilege, the_page, module_the_name, category_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_member_privileges ADD INDEX member_privileges_member (member_id);

ALTER TABLE cms10_member_privileges ADD INDEX member_privileges_name (privilege,the_page,module_the_name,category_name);

DROP TABLE IF EXISTS cms_member_tracking;

CREATE TABLE cms_member_tracking (
    mt_member_id integer NOT NULL,
    mt_cache_username varchar(80) NOT NULL,
    mt_time integer unsigned NOT NULL,
    mt_page varchar(80) NOT NULL,
    mt_type varchar(80) NOT NULL,
    mt_id varchar(80) NOT NULL,
    PRIMARY KEY (mt_member_id, mt_time, mt_page, mt_type, mt_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_member_tracking ADD INDEX mt_id (mt_page,mt_id,mt_type);

ALTER TABLE cms10_member_tracking ADD INDEX mt_page (mt_page);

ALTER TABLE cms10_member_tracking ADD INDEX mt_time (mt_time);

DROP TABLE IF EXISTS cms_member_zone_access;

CREATE TABLE cms_member_zone_access (
    zone_name varchar(80) NOT NULL,
    member_id integer NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (zone_name, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_member_zone_access ADD INDEX mzamember_id (member_id);

ALTER TABLE cms10_member_zone_access ADD INDEX mzazone_name (zone_name);

DROP TABLE IF EXISTS cms_menu_items;

CREATE TABLE cms_menu_items (
    id integer unsigned auto_increment NOT NULL,
    i_menu varchar(80) NOT NULL,
    i_order integer NOT NULL,
    i_parent integer NULL,
    i_caption longtext NOT NULL,
    i_caption_long longtext NOT NULL,
    i_url varchar(255) NOT NULL,
    i_check_permissions tinyint(1) NOT NULL,
    i_expanded tinyint(1) NOT NULL,
    i_new_window tinyint(1) NOT NULL,
    i_include_sitemap tinyint NOT NULL,
    i_page_only varchar(80) NOT NULL,
    i_theme_img_code varchar(80) NOT NULL,
    i_caption__text_parsed longtext NOT NULL,
    i_caption__source_user integer DEFAULT 1 NOT NULL,
    i_caption_long__text_parsed longtext NOT NULL,
    i_caption_long__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_menu_items ADD FULLTEXT i_caption (i_caption);

ALTER TABLE cms10_menu_items ADD FULLTEXT i_caption_long (i_caption_long);

ALTER TABLE cms10_menu_items ADD INDEX menu_extraction (i_menu);

DROP TABLE IF EXISTS cms_messages_to_render;

CREATE TABLE cms_messages_to_render (
    id integer unsigned auto_increment NOT NULL,
    r_session_id varchar(80) NOT NULL,
    r_message longtext NOT NULL,
    r_type varchar(80) NOT NULL,
    r_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_messages_to_render ADD INDEX forsession (r_session_id);

DROP TABLE IF EXISTS cms_modules;

CREATE TABLE cms_modules (
    module_the_name varchar(80) NOT NULL,
    module_author varchar(80) NOT NULL,
    module_organisation varchar(80) NOT NULL,
    module_hacked_by varchar(80) NOT NULL,
    module_hack_version integer NULL,
    module_version integer NOT NULL,
    PRIMARY KEY (module_the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_permissions', 'Chris Graham', 'ocProducts', '', NULL, 9);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_version', 'Chris Graham', 'ocProducts', '', NULL, 17);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('authors', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('forumview', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('topics', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('topicview', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('vforums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_authors', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_banners', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_blogs', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_calendar', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_catalogues', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_chat', 'Philip Withnall', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_cns_groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_comcode_pages', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_downloads', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_galleries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_polls', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_quiz', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_wiki', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('filedump', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('forums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('join', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('login', 'Chris Graham', 'ocProducts', '', NULL, 3);

DROP TABLE IF EXISTS cms_notifications_enabled;

CREATE TABLE cms_notifications_enabled (
    id integer unsigned auto_increment NOT NULL,
    l_member_id integer NOT NULL,
    l_notification_code varchar(80) NOT NULL,
    l_code_category varchar(255) NOT NULL,
    l_setting integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_notifications_enabled ADD INDEX l_code_category (l_code_category(250));

ALTER TABLE cms10_notifications_enabled ADD INDEX l_member_id (l_member_id,l_notification_code);

ALTER TABLE cms10_notifications_enabled ADD INDEX l_notification_code (l_notification_code);

DROP TABLE IF EXISTS cms_post_tokens;

CREATE TABLE cms_post_tokens (
    token varchar(80) NOT NULL,
    generation_time integer unsigned NOT NULL,
    member_id integer NOT NULL,
    session_id varchar(80) NOT NULL,
    ip_address varchar(40) NOT NULL,
    usage_tally integer NOT NULL,
    PRIMARY KEY (token)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_post_tokens ADD INDEX generation_time (generation_time);

DROP TABLE IF EXISTS cms_privilege_list;

CREATE TABLE cms_privilege_list (
    p_section varchar(80) NOT NULL,
    the_name varchar(80) NOT NULL,
    the_default tinyint(1) NOT NULL,
    PRIMARY KEY (the_name, the_default)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'allow_html', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'comcode_dangerous', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'comcode_nuisance', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'use_very_dangerous_comcode', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'access_closed_site', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'bypass_bandwidth_restriction', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'see_php_errors', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'see_stack_dump', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'view_profiling_modes', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'access_overrun_site', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'feature', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_validation_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_validation_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'can_submit_to_others_categories', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'search_engine_links', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'mass_import', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'scheduled_publication_times', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'mass_delete_from_ip', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'exceed_filesize_limit', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'draw_to_server', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'open_virtual_roots', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'sees_javascript_error_alerts', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'see_software_docs', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'see_unvalidated', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'may_enable_staff_notifications', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'bypass_flood_control', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'remove_page_split', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'bypass_wordfilter', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'perform_keyword_check', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'have_personal_category', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'assume_any_member', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_lowrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_highrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_midrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_lowrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_validation_lowrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_FEEDBACK', 'rate', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_FEEDBACK', 'comment', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('VOTE', 'vote_in_polls', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'jump_to_unvalidated', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'reuse_others_attachments', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'unfiltered_input', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'run_multi_moderations', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_pt', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'edit_private_topic_posts', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_unblind_own_poll', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_report_post', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_member_photos', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_quick_reply', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_profiles', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'own_avatars', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'double_post', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'delete_account', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'rename_self', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_special_emoticons', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_any_profile_field', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'disable_lost_passwords', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'close_own_topics', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'edit_own_polls', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'see_warnings', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'see_ip', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_choose_custom_title', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_other_pt', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_poll_results_before_voting', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'moderate_private_topic', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'member_maintenance', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'probate_members', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'warn_members', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'control_usergroups', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'multi_delete_topics', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'show_user_browsing', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'see_hidden_groups', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'pt_anyone', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'delete_private_topic_posts', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'exceed_post_edit_time_limit', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'exceed_post_delete_time_limit', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_required_cpfs', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_required_cpfs_if_already_empty', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_email_address', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_email_address_if_already_empty', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_dob', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_dob_if_already_empty', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_meta_fields', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'perform_webstandards_check_by_default', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'view_private_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'set_own_author_profile', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'upload_anything_filedump', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'upload_filedump', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'delete_anything_filedump', 0);

DROP TABLE IF EXISTS cms_rating;

CREATE TABLE cms_rating (
    id integer unsigned auto_increment NOT NULL,
    rating_for_type varchar(80) NOT NULL,
    rating_for_id varchar(80) NOT NULL,
    rating_member integer NOT NULL,
    rating_ip varchar(40) NOT NULL,
    rating_time integer unsigned NOT NULL,
    rating tinyint NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_rating ADD INDEX alt_key (rating_for_type,rating_for_id);

ALTER TABLE cms10_rating ADD INDEX rating_for_id (rating_for_id);

DROP TABLE IF EXISTS cms_review_supplement;

CREATE TABLE cms_review_supplement (
    r_post_id integer NOT NULL,
    r_rating_type varchar(80) NOT NULL,
    r_rating tinyint NOT NULL,
    r_topic_id integer NOT NULL,
    r_rating_for_id varchar(80) NOT NULL,
    r_rating_for_type varchar(80) NOT NULL,
    PRIMARY KEY (r_post_id, r_rating_type)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_review_supplement ADD INDEX rating_for_id (r_rating_for_id);

DROP TABLE IF EXISTS cms_seo_meta;

CREATE TABLE cms_seo_meta (
    id integer unsigned auto_increment NOT NULL,
    meta_for_type varchar(80) NOT NULL,
    meta_for_id varchar(80) NOT NULL,
    meta_description longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_seo_meta ADD FULLTEXT meta_description (meta_description);

ALTER TABLE cms10_seo_meta ADD INDEX alt_key (meta_for_type,meta_for_id);

ALTER TABLE cms10_seo_meta ADD INDEX ftjoin_dmeta_description (meta_description(250));

DROP TABLE IF EXISTS cms_seo_meta_keywords;

CREATE TABLE cms_seo_meta_keywords (
    id integer unsigned auto_increment NOT NULL,
    meta_for_type varchar(80) NOT NULL,
    meta_for_id varchar(80) NOT NULL,
    meta_keyword longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_seo_meta_keywords ADD FULLTEXT meta_keyword (meta_keyword);

ALTER TABLE cms10_seo_meta_keywords ADD INDEX ftjoin_dmeta_keywords (meta_keyword(250));

ALTER TABLE cms10_seo_meta_keywords ADD INDEX keywords_alt_key (meta_for_type,meta_for_id);

DROP TABLE IF EXISTS cms_sessions;

CREATE TABLE cms_sessions (
    the_session varchar(80) NOT NULL,
    last_activity integer unsigned NOT NULL,
    member_id integer NOT NULL,
    ip varchar(40) NOT NULL,
    session_confirmed tinyint(1) NOT NULL,
    session_invisible tinyint(1) NOT NULL,
    cache_username varchar(255) NOT NULL,
    the_zone varchar(80) NOT NULL,
    the_page varchar(80) NOT NULL,
    the_type varchar(80) NOT NULL,
    the_id varchar(80) NOT NULL,
    the_title varchar(255) NOT NULL,
    PRIMARY KEY (the_session)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_sessions ADD INDEX delete_old (last_activity);

ALTER TABLE cms10_sessions ADD INDEX member_id (member_id);

ALTER TABLE cms10_sessions ADD INDEX userat (the_zone,the_page,the_id);

DROP TABLE IF EXISTS cms_sitemap_cache;

CREATE TABLE cms_sitemap_cache (
    page_link varchar(255) NOT NULL,
    set_number integer NOT NULL,
    add_date integer unsigned NULL,
    edit_date integer unsigned NULL,
    last_updated integer unsigned NOT NULL,
    is_deleted tinyint(1) NOT NULL,
    priority real NOT NULL,
    refreshfreq varchar(80) NOT NULL,
    guest_access tinyint(1) NOT NULL,
    PRIMARY KEY (page_link)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_sitemap_cache ADD INDEX is_deleted (is_deleted);

ALTER TABLE cms10_sitemap_cache ADD INDEX last_updated (last_updated);

ALTER TABLE cms10_sitemap_cache ADD INDEX set_number (set_number,last_updated);

DROP TABLE IF EXISTS cms_task_queue;

CREATE TABLE cms_task_queue (
    id integer unsigned auto_increment NOT NULL,
    t_title varchar(255) NOT NULL,
    t_hook varchar(80) NOT NULL,
    t_args longtext NOT NULL,
    t_member_id integer NOT NULL,
    t_secure_ref varchar(80) NOT NULL,
    t_send_notification tinyint(1) NOT NULL,
    t_locked tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_temp_block_permissions;

CREATE TABLE cms_temp_block_permissions (
    id integer unsigned auto_increment NOT NULL,
    p_session_id varchar(80) NOT NULL,
    p_block_constraints longtext NOT NULL,
    p_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_trackbacks;

CREATE TABLE cms_trackbacks (
    id integer unsigned auto_increment NOT NULL,
    trackback_for_type varchar(80) NOT NULL,
    trackback_for_id varchar(80) NOT NULL,
    trackback_ip varchar(40) NOT NULL,
    trackback_time integer unsigned NOT NULL,
    trackback_url varchar(255) NOT NULL,
    trackback_title varchar(255) NOT NULL,
    trackback_excerpt longtext NOT NULL,
    trackback_name varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_trackbacks ADD INDEX trackback_for_id (trackback_for_id);

ALTER TABLE cms10_trackbacks ADD INDEX trackback_for_type (trackback_for_type);

ALTER TABLE cms10_trackbacks ADD INDEX trackback_time (trackback_time);

DROP TABLE IF EXISTS cms_translate;

CREATE TABLE cms_translate (
    id integer unsigned auto_increment NOT NULL,
    language varchar(5) NOT NULL,
    importance_level tinyint NOT NULL,
    text_original longtext NOT NULL,
    text_parsed longtext NOT NULL,
    broken tinyint(1) NOT NULL,
    source_user integer NOT NULL,
    PRIMARY KEY (id, language)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_translate ADD FULLTEXT tsearch (text_original);

ALTER TABLE cms10_translate ADD INDEX decache (text_parsed(2));

ALTER TABLE cms10_translate ADD INDEX equiv_lang (text_original(4));

ALTER TABLE cms10_translate ADD INDEX importance_level (importance_level);

DROP TABLE IF EXISTS cms_tutorial_links;

CREATE TABLE cms_tutorial_links (
    the_name varchar(80) NOT NULL,
    the_value longtext NOT NULL,
    PRIMARY KEY (the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_unbannable_ip;

CREATE TABLE cms_unbannable_ip (
    ip varchar(40) NOT NULL,
    note varchar(255) NOT NULL,
    PRIMARY KEY (ip)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_url_id_monikers;

CREATE TABLE cms_url_id_monikers (
    id integer unsigned auto_increment NOT NULL,
    m_resource_page varchar(80) NOT NULL,
    m_resource_type varchar(80) NOT NULL,
    m_resource_id varchar(80) NOT NULL,
    m_moniker varchar(255) NOT NULL,
    m_moniker_reversed varchar(255) NOT NULL,
    m_deprecated tinyint(1) NOT NULL,
    m_manually_chosen tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_url_id_monikers ADD INDEX uim_moniker (m_moniker(250));

ALTER TABLE cms10_url_id_monikers ADD INDEX uim_monrev (m_moniker_reversed(250));

ALTER TABLE cms10_url_id_monikers ADD INDEX uim_page_link (m_resource_page,m_resource_type,m_resource_id);

DROP TABLE IF EXISTS cms_url_title_cache;

CREATE TABLE cms_url_title_cache (
    id integer unsigned auto_increment NOT NULL,
    t_url varchar(255) BINARY NOT NULL,
    t_title varchar(255) NOT NULL,
    t_meta_title longtext NOT NULL,
    t_keywords longtext NOT NULL,
    t_description longtext NOT NULL,
    t_image_url varchar(255) BINARY NOT NULL,
    t_mime_type varchar(80) NOT NULL,
    t_json_discovery varchar(255) BINARY NOT NULL,
    t_xml_discovery varchar(255) BINARY NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_url_title_cache ADD INDEX t_url (t_url(250));

DROP TABLE IF EXISTS cms_urls_checked;

CREATE TABLE cms_urls_checked (
    id integer unsigned auto_increment NOT NULL,
    url longtext NOT NULL,
    url_exists tinyint(1) NOT NULL,
    url_check_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_urls_checked ADD INDEX url (url(200));

DROP TABLE IF EXISTS cms_values;

CREATE TABLE cms_values (
    the_name varchar(80) NOT NULL,
    the_value varchar(255) NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_topic_count', '1', 1524093340);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_member_count', '1', 1524093340);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_post_count', '1', 1524093341);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('version', '10.00', 1524093346);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_version', '10.00', 1524093346);

ALTER TABLE cms10_values ADD INDEX date_and_time (date_and_time);

DROP TABLE IF EXISTS cms_values_elective;

CREATE TABLE cms_values_elective (
    the_name varchar(80) NOT NULL,
    the_value longtext NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_values_elective (the_name, the_value, date_and_time) VALUES ('call_home', '0', 1524093346);

DROP TABLE IF EXISTS cms_webstandards_checked_once;

CREATE TABLE cms_webstandards_checked_once (
    hash varchar(255) NOT NULL,
    PRIMARY KEY (hash)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_zones;

CREATE TABLE cms_zones (
    zone_name varchar(80) NOT NULL,
    zone_title longtext NOT NULL,
    zone_default_page varchar(80) NOT NULL,
    zone_header_text longtext NOT NULL,
    zone_theme varchar(80) NOT NULL,
    zone_require_session tinyint(1) NOT NULL,
    PRIMARY KEY (zone_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('', 'Welcome', 'start', '', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('adminzone', 'Admin Zone', 'start', 'Admin Zone', 'admin', 1);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('collaboration', 'Collaboration Zone', 'start', 'Collaboration Zone', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('site', 'Site', 'start', '', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('cms', 'Content Management', 'cms', 'Content Management', 'admin', 1);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('docs', 'Tutorials', 'tutorials', '', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('forum', 'Forums', 'forumview', 'Forum', '-1', 0);

ALTER TABLE cms10_zones ADD FULLTEXT zone_header_text (zone_header_text);

ALTER TABLE cms10_zones ADD FULLTEXT zone_title (zone_title);

