DROP TABLE IF EXISTS cms_db_meta;

CREATE TABLE cms_db_meta (
    m_table varchar(80) NOT NULL,
    m_name varchar(80) NOT NULL,
    m_type varchar(80) NOT NULL,
    PRIMARY KEY (m_table, m_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'language', '*LANGUAGE_NAME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'importance_level', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'text_original', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'text_parsed', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'broken', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('translate', 'source_user', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('values', 'the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('values', 'the_value', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('values', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('config', 'c_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('config', 'c_set', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('config', 'c_value', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('config', 'c_value_trans', '?LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('config', 'c_needs_dereference', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_privileges', 'group_id', '*INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_privileges', 'privilege', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_privileges', 'the_page', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_privileges', 'module_the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_privileges', 'category_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_privileges', 'the_value', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('privilege_list', 'p_section', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('privilege_list', 'the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('privilege_list', 'the_default', '*BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_file_size', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_url', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_description', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_thumb_url', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_original_filename', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_num_downloads', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_last_downloaded_time', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachments', 'a_add_time', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachment_refs', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachment_refs', 'r_referer_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachment_refs', 'r_referer_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('attachment_refs', 'a_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('zones', 'zone_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('zones', 'zone_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('zones', 'zone_default_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('zones', 'zone_header_text', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('zones', 'zone_theme', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('zones', 'zone_require_session', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('modules', 'module_the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('modules', 'module_author', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('modules', 'module_organisation', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('modules', 'module_hacked_by', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('modules', 'module_hack_version', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('modules', 'module_version', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('blocks', 'block_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('blocks', 'block_author', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('blocks', 'block_organisation', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('blocks', 'block_hacked_by', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('blocks', 'block_hack_version', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('blocks', 'block_version', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'the_session', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'last_activity', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'session_confirmed', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'session_invisible', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'cache_username', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'the_zone', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'the_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'the_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'the_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sessions', 'the_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('https_pages', 'https_page_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_category_access', 'module_the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_category_access', 'category_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_category_access', 'group_id', '*GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta', 'meta_for_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta', 'meta_for_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta', 'meta_description', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta_keywords', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta_keywords', 'meta_for_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta_keywords', 'meta_for_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('seo_meta_keywords', 'meta_keyword', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_join_log', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_join_log', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_join_log', 'usergroup_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_join_log', 'join_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_password_history', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_password_history', 'p_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_password_history', 'p_hash_salted', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_password_history', 'p_salt', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_password_history', 'p_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_cpf_perms', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_cpf_perms', 'field_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_cpf_perms', 'guest_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_cpf_perms', 'member_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_cpf_perms', 'friend_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_cpf_perms', 'group_view', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_emoticons', 'e_code', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_emoticons', 'e_theme_img_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_emoticons', 'e_relevance_level', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_emoticons', 'e_use_topics', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_emoticons', 'e_is_special', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_locked', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_description', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_default', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_public_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_owner_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_owner_set', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_required', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_show_in_posts', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_show_in_post_previews', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_only_group', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_encrypted', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_show_on_join_form', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_custom_fields', 'cf_options', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'mf_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_1', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_2', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_3', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_4', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_5', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_6', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_7', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_8', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_invites', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_invites', 'i_inviter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_invites', 'i_email_address', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_invites', 'i_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_invites', 'i_taken', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_members', 'gm_group_id', '*GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_members', 'gm_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_members', 'gm_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_username', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_pass_hash_salted', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_pass_salt', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_theme', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_avatar_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_validated_email_confirm_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_cache_num_posts', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_cache_warnings', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_join_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_timezone_offset', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_primary_group', 'GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_last_visit_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_last_submit_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_signature', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_is_perm_banned', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_preview_posts', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_dob_day', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_dob_month', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_dob_year', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_reveal_age', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_email_address', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_photo_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_photo_thumb_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_views_signatures', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_auto_monitor_contrib_content', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_language', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_allow_emails', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_allow_emails_from_staff', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_highlighted_name', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_pt_allow', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_pt_rules_text', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_max_email_attach_size_mb', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_password_change_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_password_compat_scheme', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_on_probation_until', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_profile_views', 'UINTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_total_sessions', 'UINTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_members', 'm_auto_mark_read', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_is_default', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_is_presented_at_install', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_is_super_admin', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_is_super_moderator', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_group_leader', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_promotion_target', '?GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_promotion_threshold', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_flood_control_submit_secs', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_flood_control_access_secs', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_gift_points_base', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_gift_points_per_day', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_max_daily_upload_mb', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_max_attachments_per_post', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_max_avatar_width', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_max_avatar_height', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_max_post_length_comcode', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_max_sig_length_comcode', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_enquire_on_new_ips', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_rank_image', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_hidden', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_rank_image_pri_only', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_open_membership', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_groups', 'g_is_private_club', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_page_access', 'page_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('match_key_messages', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('match_key_messages', 'k_message', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('match_key_messages', 'k_match_key', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_zone_access', 'zone_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_zone_access', 'group_id', '*GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_groupings', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_groupings', 'c_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_groupings', 'c_description', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_groupings', 'c_expanded_by_default', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_forum_grouping_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_parent_forum', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_position', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_order_sub_alpha', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_post_count_increment', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_intro_question', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_intro_answer', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_num_topics', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_num_posts', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_last_topic_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_last_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_last_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_last_username', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_last_member_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_cache_last_forum_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_redirection', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_order', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_is_threaded', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forums', 'f_allows_anonymous_posts', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_pinned', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_sunk', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cascading', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_forum_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_pt_from', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_pt_to', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_pt_from_category', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_pt_to_category', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_description', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_description_link', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_emoticon', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_num_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_is_open', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_poll_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_first_post_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_first_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_first_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_first_post', '?LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_first_username', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_first_member_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_last_post_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_last_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_last_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_last_username', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_last_member_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_topics', 't_cache_num_posts', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_post', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_poster', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_intended_solely_for', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_poster_name_if_guest', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_topic_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_cache_forum_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_last_edit_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_last_edit_by', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_is_emphasised', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_skip_sig', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_posts', 'p_parent_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_special_pt_access', 's_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_special_pt_access', 's_topic_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_saved_warnings', 's_title', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_saved_warnings', 's_explanation', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_saved_warnings', 's_message', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_intro_ip', 'i_forum_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_intro_ip', 'i_ip', '*IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_intro_member', 'i_forum_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_forum_intro_member', 'i_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_post_templates', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_post_templates', 't_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_post_templates', 't_text', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_post_templates', 't_forum_multi_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_post_templates', 't_use_default_forums', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_question', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_cache_total_votes', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_is_private', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_is_open', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_minimum_selections', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_maximum_selections', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_polls', 'po_requires_reply', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_answers', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_answers', 'pa_poll_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_answers', 'pa_answer', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_answers', 'pa_cache_num_votes', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_votes', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_votes', 'pv_poll_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_votes', 'pv_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_votes', 'pv_answer_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_poll_votes', 'pv_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_post_text', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_move_to', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_pin_state', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_sink_state', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_open_state', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_forum_multi_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_multi_moderations', 'mm_title_suffix', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'w_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'w_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'w_explanation', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'w_by', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'w_is_warning', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_silence_from_topic', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_silence_from_forum', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_probation', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_banned_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_charged_points', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_banned_member', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_warnings', 'p_changed_usergroup_from', '?GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'l_the_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'l_param_a', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'l_param_b', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'l_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'l_reason', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_moderator_logs', 'l_by', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_known_login_ips', 'i_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_known_login_ips', 'i_ip', '*IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_known_login_ips', 'i_val_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_read_logs', 'l_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_read_logs', 'l_topic_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_read_logs', 'l_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_menu', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_parent', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_caption', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_caption_long', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_url', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_check_permissions', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_expanded', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_new_window', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_include_sitemap', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_page_only', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('menu_items', 'i_theme_img_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_for_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_for_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_url', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_excerpt', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trackbacks', 'trackback_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('captchas', 'si_session_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('captchas', 'si_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('captchas', 'si_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_tracking', 'mt_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_tracking', 'mt_cache_username', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_tracking', 'mt_time', '*TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_tracking', 'mt_page', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_tracking', 'mt_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_tracking', 'mt_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache_on', 'cached_for', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache_on', 'cache_on', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache_on', 'special_cache_flags', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache_on', 'cache_ttl', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('webstandards_checked_once', 'hash', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('edit_pings', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('edit_pings', 'the_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('edit_pings', 'the_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('edit_pings', 'the_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('edit_pings', 'the_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('edit_pings', 'the_member', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('values_elective', 'the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('values_elective', 'the_value', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('values_elective', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('tutorial_links', 'the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('tutorial_links', 'the_value', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'member_id', '*INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'privilege', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'the_page', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'module_the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'category_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'the_value', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_privileges', 'active_until', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_zone_access', 'zone_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_zone_access', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_zone_access', 'active_until', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_page_access', 'page_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_page_access', 'zone_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_page_access', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_page_access', 'active_until', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_category_access', 'module_the_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_category_access', 'category_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_category_access', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('member_category_access', 'active_until', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('autosave', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('autosave', 'a_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('autosave', 'a_key', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('autosave', 'a_value', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('autosave', 'a_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('messages_to_render', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('messages_to_render', 'r_session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('messages_to_render', 'r_message', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('messages_to_render', 'r_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('messages_to_render', 'r_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_meta_title', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_keywords', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_description', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_image_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_mime_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_json_discovery', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_title_cache', 't_xml_discovery', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'rating_for_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'rating_for_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'rating_member', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'rating_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'rating_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('rating', 'rating', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'the_zone', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'the_page', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_parent_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_show_as_edit', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('comcode_pages', 'p_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cached_comcode_pages', 'the_zone', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cached_comcode_pages', 'the_page', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cached_comcode_pages', 'string_index', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cached_comcode_pages', 'the_theme', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cached_comcode_pages', 'cc_page_title', '?SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_resource_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_resource_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_resource_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_moniker', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_moniker_reversed', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_deprecated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('url_id_monikers', 'm_manually_chosen', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('review_supplement', 'r_post_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('review_supplement', 'r_rating_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('review_supplement', 'r_rating', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('review_supplement', 'r_topic_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('review_supplement', 'r_rating_for_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('review_supplement', 'r_rating_for_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_subject', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_message', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_to_email', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_extra_cc_addresses', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_extra_bcc_addresses', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_join_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_to_name', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_from_email', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_from_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_priority', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_attachments', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_no_cc', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_as', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_as_admin', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_in_html', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_url', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_queued', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('logged_mail_messages', 'm_template', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('link_tracker', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('link_tracker', 'c_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('link_tracker', 'c_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('link_tracker', 'c_ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('link_tracker', 'c_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('incoming_uploads', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('incoming_uploads', 'i_submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('incoming_uploads', 'i_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('incoming_uploads', 'i_orig_filename', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('incoming_uploads', 'i_save_url', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'cached_for', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'identifier', 'MINIID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'the_theme', 'MINIID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'staff_status', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'the_member', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'groups', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'is_bot', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'timezone', 'MINIID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'lang', 'LANGUAGE_NAME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'the_value', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'dependencies', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cache', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_member_timeouts', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_member_timeouts', 'group_id', '*GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_group_member_timeouts', 'timeout', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('temp_block_permissions', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('temp_block_permissions', 'p_session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('temp_block_permissions', 'p_block_constraints', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('temp_block_permissions', 'p_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_codename', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_map', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_lang', 'LANGUAGE_NAME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_theme', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_staff_status', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_member', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_groups', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_is_bot', '?BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_timezone', 'MINIID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('cron_caching_requests', 'c_store_as_tempcode', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notifications_enabled', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notifications_enabled', 'l_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notifications_enabled', 'l_notification_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notifications_enabled', 'l_code_category', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notifications_enabled', 'l_setting', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_subject', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_message', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_from_member_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_to_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_priority', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_no_cc', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_notification_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_code_category', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_frequency', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_tin', 'd_read', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_consumed', 'c_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_consumed', 'c_frequency', '*INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('digestives_consumed', 'c_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('alternative_ids', 'resource_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('alternative_ids', 'resource_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('alternative_ids', 'resource_moniker', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('alternative_ids', 'resource_label', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('alternative_ids', 'resource_guid', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('alternative_ids', 'resource_resource_fs_hook', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_9', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('email_bounces', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('email_bounces', 'b_email_address', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('email_bounces', 'b_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('email_bounces', 'b_subject', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('email_bounces', 'b_body', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy', 'content_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy', 'content_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy', 'guest_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy', 'member_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy', 'friend_view', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy__members', 'content_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy__members', 'content_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_privacy__members', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_hook', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_args', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_secure_ref', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_send_notification', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('task_queue', 't_locked', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'page_link', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'set_number', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'add_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'last_updated', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'is_deleted', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'priority', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'refreshfreq', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sitemap_cache', 'guest_access', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('urls_checked', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('urls_checked', 'url', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('urls_checked', 'url_exists', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('urls_checked', 'url_check_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_regions', 'content_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_regions', 'content_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_regions', 'region', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('unbannable_ip', 'ip', '*IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('unbannable_ip', 'note', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('post_tokens', 'token', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('post_tokens', 'generation_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('post_tokens', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('post_tokens', 'session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('post_tokens', 'ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('post_tokens', 'usage_tally', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_page_access', 'zone_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('group_page_access', 'group_id', '*GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_name', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_author', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_organisation', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_version', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_category', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_copyright_attribution', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_licence', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_description', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons', 'addon_install_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_files', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_files', 'addon_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_files', 'filename', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_dependencies', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_dependencies', 'addon_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_dependencies', 'addon_name_dependant_upon', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('addons_dependencies', 'addon_name_incompatibility', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('aggregate_type_instances', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('aggregate_type_instances', 'aggregate_label', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('aggregate_type_instances', 'aggregate_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('aggregate_type_instances', 'other_parameters', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('aggregate_type_instances', 'add_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('aggregate_type_instances', 'edit_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_archive', 'a_type_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_archive', 'date_and_time', '*TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_archive', 'content_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_archive', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'a_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'a_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'a_points', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'a_content_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'a_hide_awardee', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('award_types', 'a_update_time_hours', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_subject', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_text', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_send_time', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_newsletter', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_usergroup', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_welcome_emails', 'w_usergroup_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('commandrchat', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('commandrchat', 'c_message', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('commandrchat', 'c_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('commandrchat', 'c_incoming', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('commandrchat', 'c_timestamp', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'content_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'content_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'review_freq', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'next_review_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'auto_action', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'review_notification_happened', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'display_review_status', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('content_reviews', 'last_reviewed_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_tag', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_description', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_replace', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_example', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_parameters', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_enabled', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_dangerous_tag', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_block_tag', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('custom_comcode', 'tag_textual_tag', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_parts_done', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_parts_done', 'imp_id', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_parts_done', 'imp_session', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_session', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_old_base_dir', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_db_name', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_db_user', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_hook', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_db_table_prefix', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_db_host', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_session', 'imp_refresh_time', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_id_remap', 'id_old', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_id_remap', 'id_new', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_id_remap', 'id_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('import_id_remap', 'id_session', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banned_ip', 'ip', '*IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banned_ip', 'i_descrip', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banned_ip', 'i_ban_until', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banned_ip', 'i_ban_positive', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('usersubmitban_member', 'the_member', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notification_lockdown', 'l_notification_code', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('notification_lockdown', 'l_setting', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('redirects', 'r_from_page', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('redirects', 'r_from_zone', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('redirects', 'r_to_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('redirects', 'r_to_zone', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('redirects', 'r_is_transparent', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_resource_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_resource_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_category_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_original_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_original_text', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_original_content_owner', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_original_content_timestamp', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_original_resource_fs_path', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_original_resource_fs_record', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_actionlog_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('revisions', 'r_moderatorlog_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'data_post', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'user_agent', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'referer', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'user_os', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'reason', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'reason_param_a', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('hackattack', 'reason_param_b', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'the_page', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'referer', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 's_get', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'post', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'browser', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'milliseconds', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'operating_system', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('stats', 'access_denied_counter', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('usersonline_track', 'date_and_time', '*TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('usersonline_track', 'peak', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ip_country', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ip_country', 'begin_num', 'UINTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ip_country', 'end_num', 'UINTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ip_country', 'country', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('theme_images', 'id', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('theme_images', 'theme', '*MINIID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('theme_images', 'path', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('theme_images', 'lang', '*LANGUAGE_NAME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wordfilter', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wordfilter', 'word', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wordfilter', 'w_replacement', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wordfilter', 'w_substr', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sms_log', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sms_log', 's_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sms_log', 's_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sms_log', 's_trigger_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('authors', 'author', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('authors', 'url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('authors', 'member_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('authors', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('authors', 'skills', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'expiry_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'img_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'the_type', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'b_title_text', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'caption', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'b_direct_code', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'campaign_remaining', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'site_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'hits_from', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'views_from', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'hits_to', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'views_to', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'importance_modulus', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners', 'b_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_types', 'id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_types', 't_is_textual', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_types', 't_image_width', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_types', 't_image_height', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_types', 't_max_file_size', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_types', 't_comcode_inline', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_clicks', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_clicks', 'c_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_clicks', 'c_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_clicks', 'c_ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_clicks', 'c_source', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banner_clicks', 'c_banner_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners_types', 'name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('banners_types', 'b_type', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('bookmarks', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('bookmarks', 'b_owner', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('bookmarks', 'b_folder', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('bookmarks', 'b_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('bookmarks', 'b_page_link', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_member_calendar', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_title', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_content', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_recurrence', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_recurrences', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_seg_recurrences', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_start_year', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_start_month', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_start_day', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_start_monthly_spec_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_start_hour', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_start_minute', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_end_year', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_end_month', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_end_day', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_end_monthly_spec_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_end_hour', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_end_minute', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_timezone', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_do_timezone_conv', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_priority', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'e_type', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_events', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_types', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_types', 't_title', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_types', 't_logo', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_types', 't_external_feed', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_reminders', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_reminders', 'e_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_reminders', 'n_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_reminders', 'n_seconds_before', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_interests', 'i_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_interests', 't_type', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_jobs', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_jobs', 'j_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_jobs', 'j_reminder_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_jobs', 'j_member_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('calendar_jobs', 'j_event_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_display_type', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_is_tree', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_submit_points', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_ecommerce', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_default_review_freq', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogues', 'c_send_view_reports', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'c_name', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'rep_image', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_parent_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_move_target', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_move_days_lower', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_move_days_higher', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_categories', 'cc_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'c_name', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_description', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_defines_order', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_visible', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_searchable', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_default', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_required', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_put_in_category', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_put_in_search', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_fields', 'cf_options', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'c_name', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'cc_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_views_prior', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entries', 'ce_last_moved', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long_trans', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long_trans', 'cf_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long_trans', 'ce_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long_trans', 'cv_value', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long', 'cf_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long', 'ce_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_long', 'cv_value', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short_trans', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short_trans', 'cf_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short_trans', 'ce_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short_trans', 'cv_value', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short', 'cf_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short', 'ce_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_short', 'cv_value', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entry_linkage', 'catalogue_entry_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entry_linkage', 'content_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_entry_linkage', 'content_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_cat_treecache', 'cc_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_cat_treecache', 'cc_ancestor_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_childcountcache', 'cc_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_childcountcache', 'c_num_rec_children', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_childcountcache', 'c_num_rec_entries', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_float', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_float', 'cf_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_float', 'ce_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_float', 'cv_value', '?REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_integer', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_integer', 'cf_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_integer', 'ce_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('catalogue_efv_integer', 'cv_value', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'room_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'room_owner', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'allow_list', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'allow_list_groups', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'disallow_list', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'disallow_list_groups', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'room_language', 'LANGUAGE_NAME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'c_welcome', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_rooms', 'is_im', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'system_message', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'room_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'the_message', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'text_colour', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_messages', 'font_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_10', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_blocking', 'member_blocker', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_blocking', 'member_blocked', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_blocking', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_friends', 'member_likes', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_friends', 'member_liked', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_friends', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_events', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_events', 'e_type_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_events', 'e_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_events', 'e_room_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_events', 'e_date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_active', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_active', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_active', 'room_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_active', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_sound_effects', 's_member', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_sound_effects', 's_effect_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chat_sound_effects', 's_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'category', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'parent_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_categories', 'rep_image', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'category_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'author', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'additional_details', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'num_downloads', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'out_mode_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'default_pic', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'file_size', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'download_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'download_cost', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'download_submitter_gets_points', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'original_filename', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'rep_image', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'download_licence', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'download_data_mash', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_downloads', 'url_redirect', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_logging', 'id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_logging', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_logging', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_logging', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_licences', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_licences', 'l_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('download_licences', 'l_text', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'fullname', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'rep_image', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'parent_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'watermark_top_left', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'watermark_top_right', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'watermark_bottom_left', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'watermark_bottom_right', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'accept_images', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'accept_videos', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'is_member_synched', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'flow_mode_interface', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'gallery_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('galleries', 'g_owner', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'cat', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'thumb_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'image_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('images', 'title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'cat', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'thumb_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'video_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'video_width', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'video_height', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'video_length', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('videos', 'title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_local_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_local_id_field', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_error', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_table', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_url_field', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_orig_filename_field', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_width_field', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_height_field', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('video_transcoding', 't_output_filename', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_type_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_state', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_amount', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_special', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('invoices', 'i_note', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'title', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'news', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'news_article', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'author', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'news_category', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'news_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news', 'news_image', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_categories', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_categories', 'nc_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_categories', 'nc_owner', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_categories', 'nc_img', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_categories', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'rem_procedure', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'rem_port', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'rem_path', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'rem_protocol', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'rem_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'watching_channel', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_rss_cloud', 'register_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_category_entries', 'news_entry', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('news_category_entries', 'news_entry_category', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'email', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'join_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'code_confirm', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'the_password', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'pass_salt', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'language', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'n_forename', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribers', 'n_surname', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_archive', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_archive', 'date_and_time', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_archive', 'subject', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_archive', 'newsletter', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_archive', 'language', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_archive', 'importance_level', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletters', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletters', 'title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletters', 'description', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribe', 'newsletter_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribe', 'the_level', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_subscribe', 'email', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_inject_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_subject', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_message', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_html_only', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_to_email', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_to_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_from_email', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_from_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_priority', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_drip_send', 'd_template', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_message', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_subject', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_lang', 'LANGUAGE_NAME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_send_details', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_html_only', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_from_email', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_from_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_priority', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_csv_data', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_frequency', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_day', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_in_full', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_template', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('newsletter_periodic', 'np_last_sent', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chargelog', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chargelog', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chargelog', 'amount', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chargelog', 'reason', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('chargelog', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'amount', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'gift_from', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'gift_to', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'reason', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('gifts', 'anonymous', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_11', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_12', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_13', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_14', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_15', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('prices', 'name', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('prices', 'price', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sales', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sales', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sales', 'memberid', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sales', 'purchasetype', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sales', 'details', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('sales', 'details2', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_mail_subject', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_mail_body', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_enabled', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_cost', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_customs', 'c_one_per_member', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_mail_subject', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_mail_body', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_enabled', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_cost', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_hours', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_privilege', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_zone', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_page', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_module', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('pstore_permissions', 'p_category', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'question', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option1', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option2', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option3', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option4', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option5', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option6', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option7', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option8', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option9', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'option10', '?SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes1', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes2', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes3', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes4', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes5', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes6', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes7', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes8', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes9', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'votes10', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'allow_rating', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'allow_trackbacks', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'num_options', 'SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'is_current', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'date_and_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'add_time', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'poll_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_16', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll_votes', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll_votes', 'v_poll_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll_votes', 'v_voter_id', '?MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll_votes', 'v_voter_ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('poll_votes', 'v_vote_for', '?SHORT_INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_purchase_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_item_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_amount', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_currency', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_ip_address', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_length', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('trans_expecting', 'e_length_units', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_17', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_18', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_19', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_20', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_21', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_22', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_23', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_24', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 'id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_type_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_purchase_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_status', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_reason', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_amount', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_currency', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_parent_txn_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_time', '*TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_pending_reason', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_memo', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('transactions', 't_via', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_member_last_visit', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_member_last_visit', 'v_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_member_last_visit', 'v_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_member_last_visit', 'v_quiz_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_timeout', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_start_text', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_end_text', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_percentage', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_open_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_close_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_num_winners', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_redo_time', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_points_for_passing', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_tied_newsletter', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_end_text_fail', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_reveal_answers', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_shuffle_questions', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quizzes', 'q_shuffle_answers', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_quiz', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_question_text', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_question_extra_text', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_required', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_questions', 'q_marked', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_question_answers', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_question_answers', 'q_question', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_question_answers', 'q_answer_text', 'SHORT_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_question_answers', 'q_is_correct', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_question_answers', 'q_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_question_answers', 'q_explanation', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_winner', 'q_quiz', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_winner', 'q_entry', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_winner', 'q_winner_level', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entries', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entries', 'q_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entries', 'q_member', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entries', 'q_quiz', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entries', 'q_results', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entry_answer', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entry_answer', 'q_entry', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entry_answer', 'q_question', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('quiz_entry_answer', 'q_answer', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_saved', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_saved', 's_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_saved', 's_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_saved', 's_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_saved', 's_primary', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_saved', 's_auxillary', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_logged', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_logged', 's_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_logged', 's_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_logged', 's_primary', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_logged', 's_auxillary', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('searches_logged', 's_num_results', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'ordered_by', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'product_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'product_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'product_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'quantity', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'price_pre_tax', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'price', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'product_description', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'product_type', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'product_weight', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_cart', 'is_deleted', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'c_member', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'tot_price', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'order_status', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'transaction_id', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'purchase_through', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order', 'tax_opted_out', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'order_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'p_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'p_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'p_code', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'p_type', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'p_quantity', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'p_price', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'included_tax', 'REAL');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_details', 'dispatch_status', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_logging', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_logging', 'e_member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_logging', 'session_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_logging', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_logging', 'last_action', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_logging', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'order_id', '?AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'address_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'address_street', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'address_city', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'address_state', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'address_zip', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'address_country', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'receiver_email', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'contact_phone', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'first_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('shopping_order_addresses', 'last_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_25', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_26', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_type_code', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_state', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_amount', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_purchase_id', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_auto_fund_source', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_auto_fund_key', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_via', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_length', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('subscriptions', 's_length_units', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_cost', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_length', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_length_units', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_auto_recur', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_group_id', 'GROUP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_enabled', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_mail_start', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_mail_end', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_mail_uhoh', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_subs', 's_uses_primary', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_sub_mails', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_sub_mails', 'm_usergroup_sub_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_sub_mails', 'm_ref_point', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_sub_mails', 'm_ref_point_offset', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_sub_mails', 'm_subject', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_usergroup_sub_mails', 'm_body', 'LONG_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_known_emailers', 'email_address', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_known_emailers', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_extra_access', 'ticket_id', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_extra_access', 'member_id', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('tickets', 'ticket_id', '*SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('tickets', 'topic_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('tickets', 'forum_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('tickets', 'ticket_type', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_types', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_types', 'ticket_type_name', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_types', 'guest_emails_mandatory', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_types', 'search_faq', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('ticket_types', 'cache_lead_time', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_children', 'parent_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_children', 'child_id', '*AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_children', 'the_order', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_children', 'title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'title', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'notes', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'description', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'wiki_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'hide_posts', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_pages', 'submitter', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'page_id', 'AUTO_LINK');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'the_message', 'LONG_TRANS__COMCODE');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'validated', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'wiki_views', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('wiki_posts', 'edit_date', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_27', '?INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('filedump', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('filedump', 'name', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('filedump', 'path', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('filedump', 'description', 'SHORT_TRANS');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('filedump', 'the_member', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('leader_board', 'lb_member', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('leader_board', 'lb_points', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('leader_board', 'date_and_time', '*TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('feature_lifetime_monitor', 'content_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('feature_lifetime_monitor', 'block_cache_id', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('feature_lifetime_monitor', 'run_period', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('feature_lifetime_monitor', 'running_now', 'BINARY');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('feature_lifetime_monitor', 'last_update', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'the_type', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'param_a', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'param_b', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'member_id', 'MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('actionlogs', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_checklist_cus_tasks', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_checklist_cus_tasks', 'task_title', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_checklist_cus_tasks', 'add_date', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_checklist_cus_tasks', 'recur_interval', 'INTEGER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_checklist_cus_tasks', 'recur_every', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_checklist_cus_tasks', 'task_is_done', '?TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_links', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_links', 'link', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_links', 'link_title', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_links', 'link_desc', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_tips_dismissed', 't_member', '*MEMBER');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_tips_dismissed', 't_tip', '*ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_website_monitoring', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_website_monitoring', 'site_url', 'URLPATH');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('staff_website_monitoring', 'site_name', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('failedlogins', 'id', '*AUTO');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('failedlogins', 'failed_account', 'ID_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('failedlogins', 'date_and_time', 'TIME');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('failedlogins', 'ip', 'IP');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_28', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_29', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_30', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_31', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_32', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_33', 'LONG_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_34', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_35', 'SHORT_TEXT');
INSERT INTO cms_db_meta (m_table, m_name, m_type) VALUES ('f_member_custom_fields', 'field_36', 'SHORT_TEXT');

ALTER TABLE cms10_db_meta ADD INDEX findtransfields (m_type);

DROP TABLE IF EXISTS cms_db_meta_indices;

CREATE TABLE cms_db_meta_indices (
    i_table varchar(80) NOT NULL,
    i_name varchar(80) NOT NULL,
    i_fields varchar(80) NOT NULL,
    PRIMARY KEY (i_table, i_name, i_fields)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('actionlogs', 'aip', 'ip');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('actionlogs', 'athe_type', 'the_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('actionlogs', 'ts', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('actionlogs', 'xas', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('aggregate_type_instances', 'aggregate_lookup', 'aggregate_label');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('alternative_ids', 'resource_guid', 'resource_guid');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('alternative_ids', 'resource_label', 'resource_label');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('alternative_ids', 'resource_moniker', 'resource_moniker,resource_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('alternative_ids', 'resource_moniker_uniq', 'resource_moniker,resource_resource_fs_hook');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('attachments', 'attachmentlimitcheck', 'a_add_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('attachments', 'ownedattachments', 'a_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('authors', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('authors', '#skills', 'skills');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('authors', 'findmemberlink', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('autosave', 'myautosaves', 'a_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('award_archive', 'awardquicksearch', 'content_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('award_types', '#a_description', 'a_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('award_types', '#a_title', 'a_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', '#caption', 'caption');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'badd_date', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'banner_child_find', 'b_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'bvalidated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'campaign_remaining', 'campaign_remaining');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'expiry_date', 'expiry_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'the_type', 'the_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banners', 'topsites', 'hits_from,hits_to');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banner_clicks', 'clicker_ip', 'c_ip_address');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banner_clicks', 'c_banner_id', 'c_banner_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('banner_types', 'hottext', 't_comcode_inline');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cache', 'cached_ford', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cache', 'cached_fore', 'cached_for');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cache', 'cached_forf', 'cached_for,identifier,the_theme,lang,staff_status,the_member,is_bot');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cache', 'cached_forh', 'the_theme');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cached_comcode_pages', '#cc_page_title', 'cc_page_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cached_comcode_pages', '#page_search__combined', 'cc_page_title,string_index');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cached_comcode_pages', '#string_index', 'string_index');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cached_comcode_pages', 'ccp_join', 'the_page,the_zone');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cached_comcode_pages', 'ftjoin_ccpt', 'cc_page_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cached_comcode_pages', 'ftjoin_ccsi', 'string_index');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', '#event_search__combined', 'e_title,e_content');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', '#e_content', 'e_content');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', '#e_title', 'e_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'ces', 'e_submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'eventat', 'e_start_year,e_start_month,e_start_day,e_start_hour,e_start_minute');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'e_add_date', 'e_add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'e_type', 'e_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'e_views', 'e_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'ftjoin_econtent', 'e_content');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'ftjoin_etitle', 'e_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_events', 'validated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_jobs', 'applicablejobs', 'j_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('calendar_types', '#t_title', 't_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('captchas', 'si_time', 'si_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogues', '#c_description', 'c_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogues', '#c_title', 'c_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', '#cat_cat_search__combined', 'cc_title,cc_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', '#cc_description', 'cc_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', '#cc_title', 'cc_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', 'cataloguefind', 'c_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', 'catstoclean', 'cc_move_target');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', 'cc_order', 'cc_order');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', 'cc_parent_id', 'cc_parent_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', 'ftjoin_ccdescrip', 'cc_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_categories', 'ftjoin_cctitle', 'cc_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_cat_treecache', 'cc_ancestor_id', 'cc_ancestor_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_float', 'cefv_f_combo', 'ce_id,cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_float', 'fce_id', 'ce_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_float', 'fcf_id', 'cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_float', 'fcv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_integer', 'cefv_i_combo', 'ce_id,cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_integer', 'ice_id', 'ce_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_integer', 'icf_id', 'cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_integer', 'itv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long', '#lcv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long', 'cefv_l_combo', 'ce_id,cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long', 'lce_id', 'ce_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long', 'lcf_id', 'cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long_trans', '#cv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long_trans', 'cefv_lt_combo', 'ce_id,cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long_trans', 'ltce_id', 'ce_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long_trans', 'ltcf_id', 'cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_long_trans', 'ltcv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short', '#scv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short', 'cefv_s_combo', 'ce_id,cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short', 'iscv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short', 'sce_id', 'ce_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short', 'scf_id', 'cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short_trans', '#cv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short_trans', 'cefv_st_combo', 'ce_id,cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short_trans', 'stce_id', 'ce_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short_trans', 'stcf_id', 'cf_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_efv_short_trans', 'stcv_value', 'cv_value');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entries', 'ces', 'ce_submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entries', 'ce_add_date', 'ce_add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entries', 'ce_cc_id', 'cc_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entries', 'ce_c_name', 'c_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entries', 'ce_validated', 'ce_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entries', 'ce_views', 'ce_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_entry_linkage', 'custom_fields', 'content_type,content_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_fields', '#cf_description', 'cf_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('catalogue_fields', '#cf_name', 'cf_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chargelog', '#reason', 'reason');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_active', 'active_ordering', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_active', 'member_select', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_active', 'room_select', 'room_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_events', 'event_ordering', 'e_date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_messages', '#the_message', 'the_message');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_messages', 'ordering', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_messages', 'room_id', 'room_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_rooms', '#c_welcome', 'c_welcome');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_rooms', 'allow_list', 'allow_list(30)');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_rooms', 'first_public', 'is_im,id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_rooms', 'is_im', 'is_im');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('chat_rooms', 'room_name', 'room_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('comcode_pages', 'p_add_date', 'p_add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('comcode_pages', 'p_order', 'p_order');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('comcode_pages', 'p_submitter', 'p_submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('comcode_pages', 'p_validated', 'p_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('config', '#c_value_trans', 'c_value_trans');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('content_privacy', 'friend_view', 'friend_view');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('content_privacy', 'guest_view', 'guest_view');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('content_privacy', 'member_view', 'member_view');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('content_reviews', 'needs_review', 'next_review_time,content_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('content_reviews', 'next_review_time', 'next_review_time,review_notification_happened');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cron_caching_requests', 'c_compound', 'c_codename,c_theme,c_lang,c_timezone');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cron_caching_requests', 'c_is_bot', 'c_is_bot');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('cron_caching_requests', 'c_store_as_tempcode', 'c_store_as_tempcode');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('custom_comcode', '#tag_description', 'tag_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('custom_comcode', '#tag_title', 'tag_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('db_meta', 'findtransfields', 'm_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('digestives_tin', '#d_message', 'd_message');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('digestives_tin', 'd_date_and_time', 'd_date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('digestives_tin', 'd_frequency', 'd_frequency');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('digestives_tin', 'd_read', 'd_read');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('digestives_tin', 'd_to_member_id', 'd_to_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('digestives_tin', 'unread', 'd_to_member_id,d_read');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_categories', '#category', 'category');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_categories', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_categories', '#dl_cat_search__combined', 'category,description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_categories', 'child_find', 'parent_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_categories', 'ftjoin_dccat', 'category');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_categories', 'ftjoin_dcdescrip', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', '#additional_details', 'additional_details');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', '#dl_search__combined', 'original_filename,download_data_mash');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', '#download_data_mash', 'download_data_mash');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', '#name', 'name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', '#original_filename', 'original_filename');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'category_list', 'category_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'ddl', 'download_licence');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'dds', 'submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'downloadauthor', 'author');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'download_views', 'download_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'dvalidated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'ftjoin_dadditional', 'additional_details');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'ftjoin_ddescrip', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'ftjoin_dname', 'name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'recent_downloads', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_downloads', 'top_downloads', 'num_downloads');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('download_logging', 'calculate_bandwidth', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('edit_pings', 'edit_pings_on', 'the_page,the_type,the_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('email_bounces', 'b_email_address', 'b_email_address');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('email_bounces', 'b_time', 'b_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('failedlogins', 'failedlogins_by_ip', 'ip');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('filedump', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_custom_fields', '#cf_description', 'cf_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_custom_fields', '#cf_name', 'cf_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_emoticons', 'relevantemoticons', 'e_relevance_level');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_emoticons', 'topicemos', 'e_use_topics');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_forums', '#f_description', 'f_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_forums', '#f_intro_question', 'f_intro_question');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_forums', 'cache_num_posts', 'f_cache_num_posts');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_forums', 'findnamedforum', 'f_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_forums', 'f_position', 'f_position');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_forums', 'subforum_parenting', 'f_parent_forum');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', '#groups_search__combined', 'g_name,g_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', '#g_name', 'g_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', '#g_title', 'g_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'ftjoin_gname', 'g_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'ftjoin_gtitle', 'g_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'gorder', 'g_order,id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'hidden', 'g_hidden');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'is_default', 'g_is_default');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'is_presented_at_install', 'g_is_presented_at_install');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'is_private_club', 'g_is_private_club');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'is_super_admin', 'g_is_super_admin');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_groups', 'is_super_moderator', 'g_is_super_moderator');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_group_join_log', 'join_time', 'join_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_group_join_log', 'member_id', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_group_join_log', 'usergroup_id', 'usergroup_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_group_members', 'gm_group_id', 'gm_group_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_group_members', 'gm_member_id', 'gm_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_group_members', 'gm_validated', 'gm_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', '#m_pt_rules_text', 'm_pt_rules_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', '#m_signature', 'm_signature');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', '#search_user', 'm_username');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'avatar_url', 'm_avatar_url');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'birthdays', 'm_dob_day,m_dob_month');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'external_auth_lookup', 'm_pass_hash_salted');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'ftjoin_msig', 'm_signature');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'last_visit_time', 'm_dob_month,m_dob_day,m_last_visit_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'menail', 'm_email_address');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'm_join_time', 'm_join_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'primary_group', 'm_primary_group');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'sort_post_count', 'm_cache_num_posts');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'user_list', 'm_username');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_members', 'whos_validated', 'm_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#field_1', 'field_1');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#field_2', 'field_2');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#field_4', 'field_4');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_17', 'field_17');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_18', 'field_18');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_19', 'field_19');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_21', 'field_21');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_22', 'field_22');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_23', 'field_23');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_24', 'field_24');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_25', 'field_25');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_26', 'field_26');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_28', 'field_28');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_29', 'field_29');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_3', 'field_3');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_30', 'field_30');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_31', 'field_31');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_32', 'field_32');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_33', 'field_33');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_34', 'field_34');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_35', 'field_35');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_36', 'field_36');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_5', 'field_5');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_6', 'field_6');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_7', 'field_7');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', '#mcf_ft_8', 'field_8');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf1', 'field_1');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf10', 'field_10');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf11', 'field_11');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf12', 'field_12');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf13', 'field_13');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf14', 'field_14');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf15', 'field_15');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf16', 'field_16');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf2', 'field_2');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf20', 'field_20');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf25', 'field_25');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf26', 'field_26');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf27', 'field_27');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf29', 'field_29');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf3', 'field_3');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf30', 'field_30');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf31', 'field_31');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf32', 'field_32');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf34', 'field_34');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf35', 'field_35');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf36', 'field_36');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf4', 'field_4');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf5', 'field_5');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf6', 'field_6');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf7', 'field_7');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_member_custom_fields', 'mcf8', 'field_8');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_multi_moderations', '#mm_name', 'mm_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_password_history', 'p_member_id', 'p_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', '#posts_search__combined', 'p_post,p_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', '#p_post', 'p_post');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', '#p_title', 'p_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'deletebyip', 'p_ip_address');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'find_pp', 'p_intended_solely_for');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'in_topic', 'p_topic_id,p_time,id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'in_topic_change_order', 'p_topic_id,p_last_edit_time,p_time,id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'postsinforum', 'p_cache_forum_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'posts_by', 'p_poster,p_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'posts_by_in_forum', 'p_poster,p_cache_forum_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'posts_by_in_topic', 'p_poster,p_topic_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'posts_since', 'p_time,p_cache_forum_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'post_order_time', 'p_time,id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'p_last_edit_time', 'p_last_edit_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'p_validated', 'p_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_posts', 'search_join', 'p_post');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_read_logs', 'erase_old_read_logs', 'l_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', '#t_cache_first_post', 't_cache_first_post');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', '#t_description', 't_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'descriptionsearch', 't_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'forumlayer', 't_cache_first_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'in_forum', 't_forum_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'ownedtopics', 't_cache_first_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'topic_order', 't_cascading,t_pinned,t_cache_last_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'topic_order_2', 't_forum_id,t_cascading,t_pinned,t_sunk,t_cache_last_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'topic_order_3', 't_forum_id,t_cascading,t_pinned,t_cache_last_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'topic_order_time', 't_cache_last_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'topic_order_time_2', 't_cache_first_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_cache_first_post_id', 't_cache_first_post_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_cache_last_member_id', 't_cache_last_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_cache_last_post_id', 't_cache_last_post_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_cache_num_posts', 't_cache_num_posts');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_cascading', 't_cascading');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_cascading_or_forum', 't_cascading,t_forum_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_num_views', 't_num_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_pt_from', 't_pt_from');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_pt_to', 't_pt_to');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 't_validated', 't_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_topics', 'unread_forums', 't_forum_id,t_cache_last_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_subs', '#s_description', 's_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_subs', '#s_mail_end', 's_mail_end');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_subs', '#s_mail_start', 's_mail_start');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_subs', '#s_mail_uhoh', 's_mail_uhoh');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_subs', '#s_title', 's_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_sub_mails', '#m_body', 'm_body');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_usergroup_sub_mails', '#m_subject', 'm_subject');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_warnings', 'warningsmemberid', 'w_member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_welcome_emails', '#w_subject', 'w_subject');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('f_welcome_emails', '#w_text', 'w_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', '#fullname', 'fullname');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', '#gallery_search__combined', 'fullname,description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'ftjoin_gdescrip', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'ftjoin_gfullname', 'fullname');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'gadd_date', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'parent_id', 'parent_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'watermark_bottom_left', 'watermark_bottom_left');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'watermark_bottom_right', 'watermark_bottom_right');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'watermark_top_left', 'watermark_top_left');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('galleries', 'watermark_top_right', 'watermark_top_right');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('gifts', '#reason', 'reason');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('gifts', 'giftsgiven', 'gift_from');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('gifts', 'giftsreceived', 'gift_to');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('group_page_access', 'group_id', 'group_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('group_privileges', 'group_id', 'group_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('group_zone_access', 'group_id', 'group_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('hackattack', 'h_date_and_time', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('hackattack', 'otherhacksby', 'ip');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', '#image_search__combined', 'description,title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', '#title', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'category_list', 'cat');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'ftjoin_dtitle', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'ftjoin_idescription', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'iadd_date', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'image_views', 'image_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'i_validated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('images', 'xis', 'submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('link_tracker', 'c_url', 'c_url');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('logged_mail_messages', 'combo', 'm_date_and_time,m_queued');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('logged_mail_messages', 'queued', 'm_queued');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('logged_mail_messages', 'recentmessages', 'm_date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('match_key_messages', '#k_message', 'k_message');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_category_access', 'mcamember_id', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_category_access', 'mcaname', 'module_the_name,category_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_page_access', 'mzamember_id', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_page_access', 'mzaname', 'page_name,zone_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_privileges', 'member_privileges_member', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_privileges', 'member_privileges_name', 'privilege,the_page,module_the_name,category_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_tracking', 'mt_id', 'mt_page,mt_id,mt_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_tracking', 'mt_page', 'mt_page');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_tracking', 'mt_time', 'mt_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_zone_access', 'mzamember_id', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('member_zone_access', 'mzazone_name', 'zone_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('menu_items', '#i_caption', 'i_caption');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('menu_items', '#i_caption_long', 'i_caption_long');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('menu_items', 'menu_extraction', 'i_menu');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('messages_to_render', 'forsession', 'r_session_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', '#news', 'news');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', '#news_article', 'news_article');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', '#news_search__combined', 'title,news,news_article');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', '#title', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'findnewscat', 'news_category');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'ftjoin_ititle', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'ftjoin_nnews', 'news');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'ftjoin_nnewsa', 'news_article');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'headlines', 'date_and_time,id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'nes', 'submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'newsauthor', 'author');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'news_views', 'news_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news', 'nvalidated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletters', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletters', '#title', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletter_drip_send', 'd_inject_time', 'd_inject_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletter_drip_send', 'd_to_email', 'd_to_email');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletter_subscribe', 'peopletosendto', 'the_level');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletter_subscribers', 'code_confirm', 'code_confirm');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletter_subscribers', 'email', 'email');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('newsletter_subscribers', 'welcomemails', 'join_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news_categories', '#nc_title', 'nc_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news_categories', 'ncs', 'nc_owner');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('news_category_entries', 'news_entry_category', 'news_entry_category');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('notifications_enabled', 'l_code_category', 'l_code_category');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('notifications_enabled', 'l_member_id', 'l_member_id,l_notification_code');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('notifications_enabled', 'l_notification_code', 'l_notification_code');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option1', 'option1');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option10', 'option10');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option2', 'option2');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option3', 'option3');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option4', 'option4');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option5', 'option5');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option6', 'option6');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option7', 'option7');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option8', 'option8');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#option9', 'option9');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#poll_search__combined', 'question,option1,option2,option3,option4,option5');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', '#question', 'question');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'date_and_time', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ftjoin_po1', 'option1');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ftjoin_po2', 'option2');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ftjoin_po3', 'option3');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ftjoin_po4', 'option4');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ftjoin_po5', 'option5');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ftjoin_pq', 'question');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'get_current', 'is_current');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'padd_time', 'add_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'poll_views', 'poll_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll', 'ps', 'submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll_votes', 'v_voter_id', 'v_voter_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll_votes', 'v_voter_ip', 'v_voter_ip');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('poll_votes', 'v_vote_for', 'v_vote_for');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('post_tokens', 'generation_time', 'generation_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_customs', '#c_description', 'c_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_customs', '#c_mail_body', 'c_mail_body');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_customs', '#c_mail_subject', 'c_mail_subject');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_customs', '#c_title', 'c_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_permissions', '#p_description', 'p_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_permissions', '#p_mail_body', 'p_mail_body');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_permissions', '#p_mail_subject', 'p_mail_subject');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('pstore_permissions', '#p_title', 'p_title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', '#quiz_search__combined', 'q_start_text,q_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', '#q_end_text', 'q_end_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', '#q_end_text_fail', 'q_end_text_fail');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', '#q_name', 'q_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', '#q_start_text', 'q_start_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', 'ftjoin_qstarttext', 'q_start_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quizzes', 'q_validated', 'q_validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quiz_questions', '#q_question_extra_text', 'q_question_extra_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quiz_questions', '#q_question_text', 'q_question_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quiz_question_answers', '#q_answer_text', 'q_answer_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('quiz_question_answers', '#q_explanation', 'q_explanation');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('rating', 'alt_key', 'rating_for_type,rating_for_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('rating', 'rating_for_id', 'rating_for_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('review_supplement', 'rating_for_id', 'r_rating_for_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('revisions', 'actionlog_link', 'r_actionlog_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('revisions', 'lookup_by_cat', 'r_resource_type,r_category_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('revisions', 'lookup_by_id', 'r_resource_type,r_resource_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('revisions', 'moderatorlog_link', 'r_moderatorlog_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('searches_logged', '#past_search_ft', 's_primary');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('searches_logged', 'past_search', 's_primary');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('seo_meta', '#meta_description', 'meta_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('seo_meta', 'alt_key', 'meta_for_type,meta_for_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('seo_meta', 'ftjoin_dmeta_description', 'meta_description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('seo_meta_keywords', '#meta_keyword', 'meta_keyword');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('seo_meta_keywords', 'ftjoin_dmeta_keywords', 'meta_keyword');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('seo_meta_keywords', 'keywords_alt_key', 'meta_for_type,meta_for_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sessions', 'delete_old', 'last_activity');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sessions', 'member_id', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sessions', 'userat', 'the_zone,the_page,the_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_cart', 'ordered_by', 'ordered_by');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_cart', 'product_id', 'product_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_cart', 'session_id', 'session_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_logging', 'calculate_bandwidth', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order', 'finddispatchable', 'order_status');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order', 'soadd_date', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order', 'soc_member', 'c_member');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order', 'sosession_id', 'session_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order_addresses', 'order_id', 'order_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order_details', 'order_id', 'order_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('shopping_order_details', 'p_id', 'p_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sitemap_cache', 'is_deleted', 'is_deleted');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sitemap_cache', 'last_updated', 'last_updated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sitemap_cache', 'set_number', 'set_number,last_updated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sms_log', 'sms_log_for', 's_member_id,s_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('sms_log', 'sms_trigger_ip', 's_trigger_ip');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'browser', 'browser');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'date_and_time', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'member_track_1', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'member_track_2', 'ip');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'member_track_3', 'member_id,date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'member_track_4', 'session_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'milliseconds', 'milliseconds');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'operating_system', 'operating_system');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'pages', 'the_page');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('stats', 'referer', 'referer');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('temp_block_permissions', 'p_session_id', 'p_session_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('theme_images', 'theme', 'theme,lang');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('ticket_types', '#ticket_type_name', 'ticket_type_name');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('trackbacks', 'trackback_for_id', 'trackback_for_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('trackbacks', 'trackback_for_type', 'trackback_for_type');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('trackbacks', 'trackback_time', 'trackback_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('translate', '#tsearch', 'text_original');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('translate', 'decache', 'text_parsed(2)');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('translate', 'equiv_lang', 'text_original(4)');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('translate', 'importance_level', 'importance_level');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('urls_checked', 'url', 'url(200)');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('url_id_monikers', 'uim_moniker', 'm_moniker');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('url_id_monikers', 'uim_monrev', 'm_moniker_reversed');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('url_id_monikers', 'uim_page_link', 'm_resource_page,m_resource_type,m_resource_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('url_title_cache', 't_url', 't_url');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('usersonline_track', 'peak_track', 'peak');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('values', 'date_and_time', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', '#title', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', '#video_search__combined', 'description,title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'category_list', 'cat');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'ftjoin_dtitle', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'ftjoin_vdescription', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'vadd_date', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'video_views', 'video_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'vs', 'submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('videos', 'v_validated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('video_transcoding', 't_local_id', 't_local_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', '#description', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', '#title', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', '#wiki_search__combined', 'title,description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', 'ftjoin_spd', 'description');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', 'ftjoin_spt', 'title');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', 'sadd_date', 'add_date');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', 'sps', 'submitter');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_pages', 'wiki_views', 'wiki_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', '#the_message', 'the_message');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', 'cdate_and_time', 'date_and_time');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', 'ftjoin_spm', 'the_message');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', 'posts_on_page', 'page_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', 'spos', 'member_id');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', 'svalidated', 'validated');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('wiki_posts', 'wiki_views', 'wiki_views');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('zones', '#zone_header_text', 'zone_header_text');
INSERT INTO cms_db_meta_indices (i_table, i_name, i_fields) VALUES ('zones', '#zone_title', 'zone_title');

DROP TABLE IF EXISTS cms_digestives_consumed;

CREATE TABLE cms_digestives_consumed (
    c_member_id integer NOT NULL,
    c_frequency integer NOT NULL,
    c_time integer unsigned NOT NULL,
    PRIMARY KEY (c_member_id, c_frequency)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_digestives_tin;

CREATE TABLE cms_digestives_tin (
    id integer unsigned auto_increment NOT NULL,
    d_subject longtext NOT NULL,
    d_message longtext NOT NULL,
    d_from_member_id integer NULL,
    d_to_member_id integer NOT NULL,
    d_priority tinyint NOT NULL,
    d_no_cc tinyint(1) NOT NULL,
    d_date_and_time integer unsigned NOT NULL,
    d_notification_code varchar(80) NOT NULL,
    d_code_category varchar(255) NOT NULL,
    d_frequency integer NOT NULL,
    d_read tinyint(1) NOT NULL,
    d_message__text_parsed longtext NOT NULL,
    d_message__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_digestives_tin ADD FULLTEXT d_message (d_message);

ALTER TABLE cms10_digestives_tin ADD INDEX d_date_and_time (d_date_and_time);

ALTER TABLE cms10_digestives_tin ADD INDEX d_frequency (d_frequency);

ALTER TABLE cms10_digestives_tin ADD INDEX d_read (d_read);

ALTER TABLE cms10_digestives_tin ADD INDEX d_to_member_id (d_to_member_id);

ALTER TABLE cms10_digestives_tin ADD INDEX unread (d_to_member_id,d_read);

DROP TABLE IF EXISTS cms_download_categories;

CREATE TABLE cms_download_categories (
    id integer unsigned auto_increment NOT NULL,
    category longtext NOT NULL,
    parent_id integer NULL,
    add_date integer unsigned NOT NULL,
    notes longtext NOT NULL,
    description longtext NOT NULL,
    rep_image varchar(255) BINARY NOT NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_download_categories (id, category, parent_id, add_date, notes, description, rep_image, description__text_parsed, description__source_user) VALUES (1, 'Downloads home', NULL, 1550714700, '', '', '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e074b558fb4.21844620_21\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e074b558fb4.21844620_21\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e074b558fb4.21844620_21\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);

ALTER TABLE cms10_download_categories ADD FULLTEXT category (category);

ALTER TABLE cms10_download_categories ADD FULLTEXT description (description);

ALTER TABLE cms10_download_categories ADD FULLTEXT dl_cat_search__combined (category,description);

ALTER TABLE cms10_download_categories ADD INDEX child_find (parent_id);

ALTER TABLE cms10_download_categories ADD INDEX ftjoin_dccat (category(250));

ALTER TABLE cms10_download_categories ADD INDEX ftjoin_dcdescrip (description(250));

DROP TABLE IF EXISTS cms_download_downloads;

CREATE TABLE cms_download_downloads (
    id integer unsigned auto_increment NOT NULL,
    category_id integer NOT NULL,
    name longtext NOT NULL,
    url varchar(255) BINARY NOT NULL,
    description longtext NOT NULL,
    author varchar(80) NOT NULL,
    additional_details longtext NOT NULL,
    num_downloads integer NOT NULL,
    out_mode_id integer NULL,
    add_date integer unsigned NOT NULL,
    edit_date integer unsigned NULL,
    validated tinyint(1) NOT NULL,
    default_pic integer NOT NULL,
    file_size integer NULL,
    allow_rating tinyint(1) NOT NULL,
    allow_comments tinyint NOT NULL,
    allow_trackbacks tinyint(1) NOT NULL,
    notes longtext NOT NULL,
    download_views integer NOT NULL,
    download_cost integer NOT NULL,
    download_submitter_gets_points tinyint(1) NOT NULL,
    submitter integer NOT NULL,
    original_filename varchar(255) NOT NULL,
    rep_image varchar(255) BINARY NOT NULL,
    download_licence integer NULL,
    download_data_mash longtext NOT NULL,
    url_redirect varchar(255) BINARY NOT NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    additional_details__text_parsed longtext NOT NULL,
    additional_details__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_download_downloads ADD FULLTEXT additional_details (additional_details);

ALTER TABLE cms10_download_downloads ADD FULLTEXT description (description);

ALTER TABLE cms10_download_downloads ADD FULLTEXT dl_search__combined (original_filename,download_data_mash);

ALTER TABLE cms10_download_downloads ADD FULLTEXT download_data_mash (download_data_mash);

ALTER TABLE cms10_download_downloads ADD FULLTEXT name (name);

ALTER TABLE cms10_download_downloads ADD FULLTEXT original_filename (original_filename);

ALTER TABLE cms10_download_downloads ADD INDEX category_list (category_id);

ALTER TABLE cms10_download_downloads ADD INDEX ddl (download_licence);

ALTER TABLE cms10_download_downloads ADD INDEX dds (submitter);

ALTER TABLE cms10_download_downloads ADD INDEX downloadauthor (author);

ALTER TABLE cms10_download_downloads ADD INDEX download_views (download_views);

ALTER TABLE cms10_download_downloads ADD INDEX dvalidated (validated);

ALTER TABLE cms10_download_downloads ADD INDEX ftjoin_dadditional (additional_details(250));

ALTER TABLE cms10_download_downloads ADD INDEX ftjoin_ddescrip (description(250));

ALTER TABLE cms10_download_downloads ADD INDEX ftjoin_dname (name(250));

ALTER TABLE cms10_download_downloads ADD INDEX recent_downloads (add_date);

ALTER TABLE cms10_download_downloads ADD INDEX top_downloads (num_downloads);

DROP TABLE IF EXISTS cms_download_licences;

CREATE TABLE cms_download_licences (
    id integer unsigned auto_increment NOT NULL,
    l_title varchar(255) NOT NULL,
    l_text longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_download_logging;

CREATE TABLE cms_download_logging (
    id integer NOT NULL,
    member_id integer NOT NULL,
    ip varchar(40) NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (id, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_download_logging ADD INDEX calculate_bandwidth (date_and_time);

DROP TABLE IF EXISTS cms_edit_pings;

CREATE TABLE cms_edit_pings (
    id integer unsigned auto_increment NOT NULL,
    the_page varchar(80) NOT NULL,
    the_type varchar(80) NOT NULL,
    the_id varchar(80) NOT NULL,
    the_time integer unsigned NOT NULL,
    the_member integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_edit_pings ADD INDEX edit_pings_on (the_page,the_type,the_id);

DROP TABLE IF EXISTS cms_email_bounces;

CREATE TABLE cms_email_bounces (
    id integer unsigned auto_increment NOT NULL,
    b_email_address varchar(255) NOT NULL,
    b_time integer unsigned NOT NULL,
    b_subject varchar(255) NOT NULL,
    b_body longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_email_bounces ADD INDEX b_email_address (b_email_address(250));

ALTER TABLE cms10_email_bounces ADD INDEX b_time (b_time);

DROP TABLE IF EXISTS cms_f_custom_fields;

CREATE TABLE cms_f_custom_fields (
    id integer unsigned auto_increment NOT NULL,
    cf_locked tinyint(1) NOT NULL,
    cf_name longtext NOT NULL,
    cf_description longtext NOT NULL,
    cf_default longtext NOT NULL,
    cf_public_view tinyint(1) NOT NULL,
    cf_owner_view tinyint(1) NOT NULL,
    cf_owner_set tinyint(1) NOT NULL,
    cf_type varchar(80) NOT NULL,
    cf_required tinyint(1) NOT NULL,
    cf_show_in_posts tinyint(1) NOT NULL,
    cf_show_in_post_previews tinyint(1) NOT NULL,
    cf_order integer NOT NULL,
    cf_only_group longtext NOT NULL,
    cf_encrypted tinyint(1) NOT NULL,
    cf_show_on_join_form tinyint(1) NOT NULL,
    cf_options varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (1, 0, 'About me', 'Some personally written information.', '', 1, 1, 1, 'long_trans', 0, 0, 0, 0, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (2, 0, 'Interests', 'A summary of your interests.', '', 1, 1, 1, 'long_trans', 0, 1, 1, 1, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (3, 0, 'Occupation', 'Your occupation.', '', 1, 1, 1, 'short_text', 0, 0, 0, 2, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (4, 0, 'Staff notes', 'Notes on this member, only viewable by staff.', '', 0, 0, 0, 'long_trans', 0, 0, 0, 3, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (5, 0, 'Skype ID', 'Your Skype ID.', '', 1, 1, 1, 'short_text', 0, 0, 0, 4, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (6, 0, 'Facebook profile', 'A link to your Facebook profile.', '', 1, 1, 1, 'short_text', 0, 0, 0, 5, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (7, 0, 'Google+ profile', 'A link to your Google+ profile.', '', 1, 1, 1, 'short_text', 0, 0, 0, 6, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (8, 0, 'Twitter account', 'Your Twitter name (for example, \'charlie12345\').', '', 1, 1, 1, 'short_text', 0, 0, 0, 7, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (9, 1, 'cms_smart_topic_notification', '', '0', 0, 0, 1, 'tick', 1, 0, 0, 8, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (10, 1, 'cms_points_gained_chat', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 9, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (11, 1, 'cms_points_used', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 10, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (12, 1, 'cms_gift_points_used', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 11, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (13, 1, 'cms_points_gained_given', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 12, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (14, 1, 'cms_points_gained_rating', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 13, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (15, 1, 'cms_points_gained_visiting', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 14, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (16, 1, 'cms_points_gained_voting', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 15, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (17, 0, 'cms_currency', '', '|AED|AFA|ALL|AMD|ANG|AOK|AON|ARA|ARP|ARS|AUD|AWG|AZM|BAM|BBD|BDT|BGL|BHD|BIF|BMD|BND|BOB|BOP|BRC|BRL|BRR|BSD|BTN|BWP|BYR|BZD|CAD|CDZ|CHF|CLF|CLP|CNY|COP|CRC|CSD|CUP|CVE|CYP|CZK|DJF|DKK|DOP|DZD|EEK|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHC|GIP|GMD|GNS|GQE|GTQ|GWP|GYD|HKD|HNL|HRD|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LSL|LSM|LTL|LVL|LYD|MAD|MDL|MGF|MKD|MLF|MMK|MNT|MOP|MRO|MTL|MUR|MVR|MWK|MXN|MYR|MZM|NAD|NGN|NIC|NOK|NPR|NZD|OMR|PAB|PEI|PEN|PGK|PHP|PKR|PLN|PYG|QAR|ROL|RUB|RWF|SAR|SBD|SCR|SDD|SDP|SEK|SGD|SHP|SIT|SKK|SLL|SOS|SRG|STD|SUR|SVC|SYP|SZL|THB|TJR|TMM|TND|TOP|TPE|TRL|TTD|TWD|TZS|UAH|UAK|UGS|USD|UYU|UZS|VEB|VND|VUV|WST|XAF|XCD|XOF|XPF|YDD|YER|ZAL|ZAR|ZMK|ZWD', 0, 0, 1, 'list', 0, 0, 0, 16, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (18, 0, 'cms_payment_cardholder_name', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 17, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (19, 0, 'cms_payment_type', '', 'American Express|Delta|Diners Card|JCB|Master Card|Solo|Switch|Visa', 0, 0, 1, 'list', 0, 0, 0, 18, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (20, 0, 'cms_payment_card_number', '', '', 0, 0, 1, 'integer', 0, 0, 0, 19, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (21, 0, 'cms_payment_card_start_date', '', 'mm/yy', 0, 0, 1, 'short_text', 0, 0, 0, 20, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (22, 0, 'cms_payment_card_expiry_date', '', 'mm/yy', 0, 0, 1, 'short_text', 0, 0, 0, 21, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (23, 0, 'cms_payment_card_issue_number', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 22, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (24, 0, 'cms_payment_card_cv2', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 23, '', 1, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (25, 1, 'cms_sites', '', '', 0, 0, 0, 'short_text', 0, 0, 0, 24, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (26, 0, 'cms_role', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 25, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (27, 1, 'cms_points_gained_wiki', '', '0', 0, 0, 0, 'integer', 0, 0, 0, 26, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (28, 0, 'cms_street_address', '', '', 0, 0, 1, 'long_text', 0, 0, 0, 27, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (29, 0, 'cms_city', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 28, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (30, 0, 'cms_county', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 29, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (31, 0, 'cms_state', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 30, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (32, 0, 'cms_post_code', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 31, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (33, 0, 'cms_country', '', '|AF=Afghanistan|AL=Albania|DZ=Algeria|AS=American Samoa|AD=Andorra|AO=Angola|AI=Anguilla|AQ=Antarctica|AG=Antigua and Barbuda|AR=Argentina|AM=Armenia|AW=Aruba|AU=Australia|AT=Austria|AZ=Azerbaijan|BS=Bahamas|BH=Bahrain|BD=Bangladesh|BB=Barbados|BY=Belarus|BE=Belgium|BZ=Belize|BJ=Benin|BM=Bermuda|BT=Bhutan|BO=Bolivia|BA=Bosnia and Herzegovina|BW=Botswana|BV=Bouvet Island|BR=Brazil|IO=British Indian Ocean Territory|VG=British Virgin Islands|BN=Brunei|BG=Bulgaria|BF=Burkina Faso|BI=Burundi|KH=Cambodia|CM=Cameroon|CA=Canada|CV=Cape Verde|KY=Cayman Islands|CF=Central African Republic|TD=Chad|CL=Chile|CN=China|CX=Christmas Island|CC=Cocos [Keeling] Islands|CO=Colombia|KM=Comoros|CG=Congo|CD=Congo (Dem. Rep.)|CK=Cook Islands|CR=Costa Rica|HR=Croatia|CU=Cuba|CY=Cyprus|CZ=Czech Republic|DK=Denmark|DJ=Djibouti|DM=Dominica|DO=Dominican Republic|DD=East Germany|TL=East Timor|EC=Ecuador|EG=Egypt|SV=El Salvador|GQ=Equatorial Guinea|ER=Eritrea|EE=Estonia|ET=Ethiopia|FK=Falkland Islands|FO=Faroe Islands|FJ=Fiji Islands|FI=Finland|FR=France|GF=French Guiana|PF=French Polynesia|TF=French Southern Territories|GA=Gabon|GM=Gambia|GE=Georgia|DE=Germany|GH=Ghana|GI=Gibraltar|GR=Greece|GL=Greenland|GD=Grenada|GP=Guadeloupe|GU=Guam|GT=Guatemala|GG=Guernsey and Alderney|GN=Guinea|GW=Guinea-Bissau|GY=Guyana|HT=Haiti|HM=Heard Island and McDonald Islands|HN=Honduras|HK=Hong Kong SAR China|HU=Hungary|IS=Iceland|IN=India|ID=Indonesia|IR=Iran|IQ=Iraq|IE=Ireland|IM=Isle of Man|IL=Israel|IT=Italy|CI=Ivory Coast|JM=Jamaica|JP=Japan|JE=Jersey|JO=Jordan|KZ=Kazakhstan|KE=Kenya|KI=Kiribati|KP=Korea (North)|KR=Korea (South)|XK=Kosovo|KW=Kuwait|KG=Kyrgyzstan|LA=Laos|LV=Latvia|LB=Lebanon|LS=Lesotho|LR=Liberia|LY=Libya|LI=Liechtenstein|LT=Lithuania|LU=Luxembourg|MO=Macau SAR China|MK=Macedonia|MG=Madagascar|MW=Malawi|MY=Malaysia|MV=Maldives|ML=Mali|MT=Malta|MH=Marshall Islands|MQ=Martinique|MR=Mauritania|MU=Mauritius|YT=Mayotte|FX=Metropolitan France|MX=Mexico|FM=Micronesia|MD=Moldova|MC=Monaco|MN=Mongolia|ME=Montenegro|MS=Montserrat|MA=Morocco|MZ=Mozambique|MM=Myanmar|NA=Namibia|NR=Nauru|NP=Nepal|NL=Netherlands|AN=Netherlands Antilles|NT=Neutral Zone|NC=New Caledonia|NZ=New Zealand|NI=Nicaragua|NE=Niger|NG=Nigeria|NU=Niue|NF=Norfolk Island|MP=Northern Mariana Islands|NO=Norway|OM=Oman|PK=Pakistan|PW=Palau|PS=Palestine|PA=Panama|PG=Papua New Guinea|PY=Paraguay|YD=People\'s Democratic Republic of Yemen|PE=Peru|PH=Philippines|PN=Pitcairn Islands|PL=Poland|PT=Portugal|PR=Puerto Rico|QA=Qatar|RO=Romania|RU=Russia|RW=Rwanda|RE=Réunion|BL=Saint Barthélemy|SH=Saint Helena|KN=Saint Kitts and Nevis|LC=Saint Lucia|MF=Saint Martin|PM=Saint Pierre and Miquelon|VC=Saint Vincent and The Grenadines|WS=Samoa|SM=San Marino|SA=Saudi Arabia|SN=Senegal|RS=Serbia|CS=Serbia and Montenegro|SC=Seychelles|SL=Sierra Leone|SG=Singapore|SK=Slovakia|SI=Slovenia|SB=Solomon Islands|SO=Somalia|ZA=South Africa|GS=South Georgia and the South Sandwich Islands|ES=Spain|LK=Sri Lanka|SD=Sudan|SR=Suriname|SJ=Svalbard and Jan Mayen|SZ=Swaziland|SE=Sweden|CH=Switzerland|SY=Syria|ST=São Tomé and Príncipe|TW=Taiwan|TJ=Tajikistan|TZ=Tanzania|TH=Thailand|TG=Togo|TK=Tokelau|TO=Tonga|TT=Trinidad and Tobago|TN=Tunisia|TR=Turkey|TM=Turkmenistan|TC=Turks and Caicos Islands|TV=Tuvalu|UG=Uganda|UA=Ukraine|SU=Union of Soviet Socialist Republics|AE=United Arab Emirates|GB=United Kingdom|UM=United States Minor Outlying Islands|US=United States of America|UY=Uruguay|UZ=Uzbekistan|VU=Vanuatu|VA=Vatican City|VE=Venezuela|VN=Vietnam|VI=Virgin Islands of the United States|WF=Wallis and Futuna|EH=Western Sahara|YE=Yemen|ZM=Zambia|ZW=Zimbabwe|AX=Åland Islands', 0, 0, 1, 'list', 0, 0, 0, 32, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (34, 0, 'cms_firstname', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 33, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (35, 0, 'cms_lastname', '', '', 0, 0, 1, 'short_text', 0, 0, 0, 34, '', 0, 0, '');
INSERT INTO cms_f_custom_fields (id, cf_locked, cf_name, cf_description, cf_default, cf_public_view, cf_owner_view, cf_owner_set, cf_type, cf_required, cf_show_in_posts, cf_show_in_post_previews, cf_order, cf_only_group, cf_encrypted, cf_show_on_join_form, cf_options) VALUES (36, 0, 'cms_mobile_phone_number', 'This should be the mobile phone number in international format, devoid of any national or international outgoing access codes. For instance, a typical UK (44) number might be nationally known as \'01234 123456\', but internationally and without outgoing access codes would be \'441234123456\'.', '', 0, 0, 1, 'short_text', 0, 0, 0, 35, '', 0, 0, '');

ALTER TABLE cms10_f_custom_fields ADD FULLTEXT cf_description (cf_description);

ALTER TABLE cms10_f_custom_fields ADD FULLTEXT cf_name (cf_name);

DROP TABLE IF EXISTS cms_f_emoticons;

CREATE TABLE cms_f_emoticons (
    e_code varchar(80) NOT NULL,
    e_theme_img_code varchar(255) NOT NULL,
    e_relevance_level integer NOT NULL,
    e_use_topics tinyint(1) NOT NULL,
    e_is_special tinyint(1) NOT NULL,
    PRIMARY KEY (e_code)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':P', 'cns_emoticons/cheeky', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':\'(', 'cns_emoticons/cry', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':dry:', 'cns_emoticons/dry', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':$', 'cns_emoticons/blush', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (';)', 'cns_emoticons/wink', 0, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES ('O_o', 'cns_emoticons/blink', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':wub:', 'cns_emoticons/wub', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':cool:', 'cns_emoticons/cool', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':lol:', 'cns_emoticons/lol', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':(', 'cns_emoticons/sad', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':)', 'cns_emoticons/smile', 0, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':thumbs:', 'cns_emoticons/thumbs', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':|', 'cns_emoticons/mellow', 0, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':ninja:', 'cns_emoticons/ph34r', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':o', 'cns_emoticons/shocked', 0, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':offtopic:', 'cns_emoticons/offtopic', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':rolleyes:', 'cns_emoticons/rolleyes', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':D', 'cns_emoticons/grin', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES ('^_^', 'cns_emoticons/glee', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES ('(K)', 'cns_emoticons/kiss', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':S', 'cns_emoticons/confused', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':@', 'cns_emoticons/angry', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':shake:', 'cns_emoticons/shake', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':hand:', 'cns_emoticons/hand', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':drool:', 'cns_emoticons/drool', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':devil:', 'cns_emoticons/devil', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':party:', 'cns_emoticons/party', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':constipated:', 'cns_emoticons/constipated', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':depressed:', 'cns_emoticons/depressed', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':zzz:', 'cns_emoticons/zzz', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':whistle:', 'cns_emoticons/whistle', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':upsidedown:', 'cns_emoticons/upsidedown', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':sick:', 'cns_emoticons/sick', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':shutup:', 'cns_emoticons/shutup', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':sarcy:', 'cns_emoticons/sarcy', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':puppyeyes:', 'cns_emoticons/puppyeyes', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':nod:', 'cns_emoticons/nod', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':nerd:', 'cns_emoticons/nerd', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':king:', 'cns_emoticons/king', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':birthday:', 'cns_emoticons/birthday', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':cyborg:', 'cns_emoticons/cyborg', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':hippie:', 'cns_emoticons/hippie', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':ninja2:', 'cns_emoticons/ninja2', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':rockon:', 'cns_emoticons/rockon', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':sinner:', 'cns_emoticons/sinner', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':guitar:', 'cns_emoticons/guitar', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':angel:', 'cns_emoticons/angel', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':cowboy:', 'cns_emoticons/cowboy', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':fight:', 'cns_emoticons/fight', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':goodbye:', 'cns_emoticons/goodbye', 1, 1, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':idea:', 'cns_emoticons/idea', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':boat:', 'cns_emoticons/boat', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':fishing:', 'cns_emoticons/fishing', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':reallybadday:', 'cns_emoticons/reallybadday', 1, 0, 0);
INSERT INTO cms_f_emoticons (e_code, e_theme_img_code, e_relevance_level, e_use_topics, e_is_special) VALUES (':christmas:', 'cns_emoticons/christmas', 1, 0, 0);

ALTER TABLE cms10_f_emoticons ADD INDEX relevantemoticons (e_relevance_level);

ALTER TABLE cms10_f_emoticons ADD INDEX topicemos (e_use_topics);

DROP TABLE IF EXISTS cms_f_forum_groupings;

CREATE TABLE cms_f_forum_groupings (
    id integer unsigned auto_increment NOT NULL,
    c_title varchar(255) NOT NULL,
    c_description longtext NOT NULL,
    c_expanded_by_default tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_forum_groupings (id, c_title, c_description, c_expanded_by_default) VALUES (1, 'General', '', 1);
INSERT INTO cms_f_forum_groupings (id, c_title, c_description, c_expanded_by_default) VALUES (2, 'Staff', '', 1);

DROP TABLE IF EXISTS cms_f_forum_intro_ip;

CREATE TABLE cms_f_forum_intro_ip (
    i_forum_id integer NOT NULL,
    i_ip varchar(40) NOT NULL,
    PRIMARY KEY (i_forum_id, i_ip)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_forum_intro_member;

CREATE TABLE cms_f_forum_intro_member (
    i_forum_id integer NOT NULL,
    i_member_id integer NOT NULL,
    PRIMARY KEY (i_forum_id, i_member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_forums;

CREATE TABLE cms_f_forums (
    id integer unsigned auto_increment NOT NULL,
    f_name varchar(255) NOT NULL,
    f_description longtext NOT NULL,
    f_forum_grouping_id integer NULL,
    f_parent_forum integer NULL,
    f_position integer NOT NULL,
    f_order_sub_alpha tinyint(1) NOT NULL,
    f_post_count_increment tinyint(1) NOT NULL,
    f_intro_question longtext NOT NULL,
    f_intro_answer varchar(255) NOT NULL,
    f_cache_num_topics integer NOT NULL,
    f_cache_num_posts integer NOT NULL,
    f_cache_last_topic_id integer NULL,
    f_cache_last_title varchar(255) NOT NULL,
    f_cache_last_time integer unsigned NULL,
    f_cache_last_username varchar(255) NOT NULL,
    f_cache_last_member_id integer NULL,
    f_cache_last_forum_id integer NULL,
    f_redirection varchar(255) NOT NULL,
    f_order varchar(80) NOT NULL,
    f_is_threaded tinyint(1) NOT NULL,
    f_allows_anonymous_posts tinyint(1) NOT NULL,
    f_description__text_parsed longtext NOT NULL,
    f_description__source_user integer DEFAULT 1 NOT NULL,
    f_intro_question__text_parsed longtext NOT NULL,
    f_intro_question__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (1, 'Forum home', '', NULL, NULL, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_1\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_1\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_1\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_2\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_2\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_2\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (2, 'General chat', '', 1, 1, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_3\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_3\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_3\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_4\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_4\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_4\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (3, 'Reported posts forum', '', 2, 1, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_5\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_5\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_5\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_6\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_6\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_6\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (4, 'Trash', '', 2, 1, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_7\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_7\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_7\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_8\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_8\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_8\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (5, 'Website comment topics', '', 1, 1, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 1, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0740df71b5.30746288_9\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0740df71b5.30746288_9\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_9\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_10\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_10\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_10\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (6, 'Website support tickets', '', 2, 1, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_11\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_11\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_11\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_12\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_12\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_12\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (7, 'Staff', '', 2, 1, 1, 0, 1, '', '', 1, 1, 1, 'Welcome to the forums', 1550714689, 'System', 1, 7, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_13\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_13\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_13\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_14\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_14\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_14\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_forums (id, f_name, f_description, f_forum_grouping_id, f_parent_forum, f_position, f_order_sub_alpha, f_post_count_increment, f_intro_question, f_intro_answer, f_cache_num_topics, f_cache_num_posts, f_cache_last_topic_id, f_cache_last_title, f_cache_last_time, f_cache_last_username, f_cache_last_member_id, f_cache_last_forum_id, f_redirection, f_order, f_is_threaded, f_allows_anonymous_posts, f_description__text_parsed, f_description__source_user, f_intro_question__text_parsed, f_intro_question__source_user) VALUES (8, 'Website \"Contact Us\" messages', '', 2, 1, 1, 0, 1, '', '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0, 0, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0743a9e771.53575025_2\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0743a9e771.53575025_2\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0743a9e771.53575025_2\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:39:\\\"string_attach_5c6e0743a9e771.53575025_3\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:39:\\\"string_attach_5c6e0743a9e771.53575025_3\\\";s:68:\\\"\\$tpl_funcs[\'string_attach_5c6e0743a9e771.53575025_3\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);

ALTER TABLE cms10_f_forums ADD FULLTEXT f_description (f_description);

ALTER TABLE cms10_f_forums ADD FULLTEXT f_intro_question (f_intro_question);

ALTER TABLE cms10_f_forums ADD INDEX cache_num_posts (f_cache_num_posts);

ALTER TABLE cms10_f_forums ADD INDEX findnamedforum (f_name(250));

ALTER TABLE cms10_f_forums ADD INDEX f_position (f_position);

ALTER TABLE cms10_f_forums ADD INDEX subforum_parenting (f_parent_forum);

DROP TABLE IF EXISTS cms_f_group_join_log;

CREATE TABLE cms_f_group_join_log (
    id integer unsigned auto_increment NOT NULL,
    member_id integer NOT NULL,
    usergroup_id integer NULL,
    join_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_f_group_join_log ADD INDEX join_time (join_time);

ALTER TABLE cms10_f_group_join_log ADD INDEX member_id (member_id);

ALTER TABLE cms10_f_group_join_log ADD INDEX usergroup_id (usergroup_id);

DROP TABLE IF EXISTS cms_f_group_member_timeouts;

CREATE TABLE cms_f_group_member_timeouts (
    member_id integer NOT NULL,
    group_id integer NOT NULL,
    timeout integer unsigned NOT NULL,
    PRIMARY KEY (member_id, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_group_members;

CREATE TABLE cms_f_group_members (
    gm_group_id integer NOT NULL,
    gm_member_id integer NOT NULL,
    gm_validated tinyint(1) NOT NULL,
    PRIMARY KEY (gm_group_id, gm_member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_f_group_members ADD INDEX gm_group_id (gm_group_id);

ALTER TABLE cms10_f_group_members ADD INDEX gm_member_id (gm_member_id);

ALTER TABLE cms10_f_group_members ADD INDEX gm_validated (gm_validated);

DROP TABLE IF EXISTS cms_f_groups;

CREATE TABLE cms_f_groups (
    id integer unsigned auto_increment NOT NULL,
    g_name longtext NOT NULL,
    g_is_default tinyint(1) NOT NULL,
    g_is_presented_at_install tinyint(1) NOT NULL,
    g_is_super_admin tinyint(1) NOT NULL,
    g_is_super_moderator tinyint(1) NOT NULL,
    g_group_leader integer NULL,
    g_title longtext NOT NULL,
    g_promotion_target integer NULL,
    g_promotion_threshold integer NULL,
    g_flood_control_submit_secs integer NOT NULL,
    g_flood_control_access_secs integer NOT NULL,
    g_gift_points_base integer NOT NULL,
    g_gift_points_per_day integer NOT NULL,
    g_max_daily_upload_mb integer NOT NULL,
    g_max_attachments_per_post integer NOT NULL,
    g_max_avatar_width integer NOT NULL,
    g_max_avatar_height integer NOT NULL,
    g_max_post_length_comcode integer NOT NULL,
    g_max_sig_length_comcode integer NOT NULL,
    g_enquire_on_new_ips tinyint(1) NOT NULL,
    g_rank_image varchar(80) NOT NULL,
    g_hidden tinyint(1) NOT NULL,
    g_order integer NOT NULL,
    g_rank_image_pri_only tinyint(1) NOT NULL,
    g_open_membership tinyint(1) NOT NULL,
    g_is_private_club tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (1, 'Guests', 0, 0, 0, 0, NULL, 'Guest user', NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 0, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (2, 'Administrators', 0, 0, 1, 0, NULL, 'Site director', NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/admin', 0, 1, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (3, 'Super-moderators', 0, 0, 0, 1, NULL, 'Site staff', NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/mod', 0, 2, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (4, 'Super-members', 0, 0, 0, 0, NULL, 'Super-member', NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 3, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (5, 'Local hero', 0, 0, 0, 0, NULL, 'Standard member', NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/4', 0, 4, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (6, 'Old timer', 0, 0, 0, 0, NULL, 'Standard member', 5, 10000, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/3', 0, 5, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (7, 'Local', 0, 0, 0, 0, NULL, 'Standard member', 6, 2500, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/2', 0, 6, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (8, 'Regular', 0, 0, 0, 0, NULL, 'Standard member', 7, 400, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/1', 0, 7, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (9, 'Newbie', 0, 0, 0, 0, NULL, 'Standard member', 8, 100, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'cns_rank_images/0', 0, 8, 1, 0, 0);
INSERT INTO cms_f_groups (id, g_name, g_is_default, g_is_presented_at_install, g_is_super_admin, g_is_super_moderator, g_group_leader, g_title, g_promotion_target, g_promotion_threshold, g_flood_control_submit_secs, g_flood_control_access_secs, g_gift_points_base, g_gift_points_per_day, g_max_daily_upload_mb, g_max_attachments_per_post, g_max_avatar_width, g_max_avatar_height, g_max_post_length_comcode, g_max_sig_length_comcode, g_enquire_on_new_ips, g_rank_image, g_hidden, g_order, g_rank_image_pri_only, g_open_membership, g_is_private_club) VALUES (10, 'Probation', 0, 0, 0, 0, NULL, 'Placed on temporary probation', NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 9, 1, 0, 0);

ALTER TABLE cms10_f_groups ADD FULLTEXT groups_search__combined (g_name,g_title);

ALTER TABLE cms10_f_groups ADD FULLTEXT g_name (g_name);

ALTER TABLE cms10_f_groups ADD FULLTEXT g_title (g_title);

ALTER TABLE cms10_f_groups ADD INDEX ftjoin_gname (g_name(250));

ALTER TABLE cms10_f_groups ADD INDEX ftjoin_gtitle (g_title(250));

ALTER TABLE cms10_f_groups ADD INDEX gorder (g_order,id);

ALTER TABLE cms10_f_groups ADD INDEX hidden (g_hidden);

ALTER TABLE cms10_f_groups ADD INDEX is_default (g_is_default);

ALTER TABLE cms10_f_groups ADD INDEX is_presented_at_install (g_is_presented_at_install);

ALTER TABLE cms10_f_groups ADD INDEX is_private_club (g_is_private_club);

ALTER TABLE cms10_f_groups ADD INDEX is_super_admin (g_is_super_admin);

ALTER TABLE cms10_f_groups ADD INDEX is_super_moderator (g_is_super_moderator);

DROP TABLE IF EXISTS cms_f_invites;

CREATE TABLE cms_f_invites (
    id integer unsigned auto_increment NOT NULL,
    i_inviter integer NOT NULL,
    i_email_address varchar(255) NOT NULL,
    i_time integer unsigned NOT NULL,
    i_taken tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_member_cpf_perms;

CREATE TABLE cms_f_member_cpf_perms (
    member_id integer NOT NULL,
    field_id integer NOT NULL,
    guest_view tinyint(1) NOT NULL,
    member_view tinyint(1) NOT NULL,
    friend_view tinyint(1) NOT NULL,
    group_view varchar(255) NOT NULL,
    PRIMARY KEY (member_id, field_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_member_custom_fields;

CREATE TABLE cms_f_member_custom_fields (
    mf_member_id integer NOT NULL,
    field_1 longtext NOT NULL,
    field_2 longtext NOT NULL,
    field_3 varchar(255) NOT NULL,
    field_4 longtext NOT NULL,
    field_5 varchar(255) NOT NULL,
    field_6 varchar(255) NOT NULL,
    field_7 varchar(255) NOT NULL,
    field_8 varchar(255) NOT NULL,
    field_9 integer NULL,
    field_10 integer NULL,
    field_11 integer NULL,
    field_12 integer NULL,
    field_13 integer NULL,
    field_14 integer NULL,
    field_15 integer NULL,
    field_16 integer NULL,
    field_17 longtext NOT NULL,
    field_18 longtext NOT NULL,
    field_19 longtext NOT NULL,
    field_20 integer NULL,
    field_21 longtext NOT NULL,
    field_22 longtext NOT NULL,
    field_23 longtext NOT NULL,
    field_24 longtext NOT NULL,
    field_25 varchar(255) NOT NULL,
    field_26 varchar(255) NOT NULL,
    field_27 integer NULL,
    field_28 longtext NOT NULL,
    field_29 varchar(255) NOT NULL,
    field_30 varchar(255) NOT NULL,
    field_31 varchar(255) NOT NULL,
    field_32 varchar(255) NOT NULL,
    field_33 longtext NOT NULL,
    field_34 varchar(255) NOT NULL,
    field_35 varchar(255) NOT NULL,
    field_36 varchar(255) NOT NULL,
    field_1__text_parsed longtext NOT NULL,
    field_1__source_user integer DEFAULT 1 NOT NULL,
    field_2__text_parsed longtext NOT NULL,
    field_2__source_user integer DEFAULT 1 NOT NULL,
    field_4__text_parsed longtext NOT NULL,
    field_4__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (mf_member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_member_custom_fields (mf_member_id, field_1, field_1__text_parsed, field_1__source_user, field_2, field_2__text_parsed, field_2__source_user, field_3, field_4, field_4__text_parsed, field_4__source_user, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29, field_30, field_31, field_32, field_33, field_34, field_35, field_36) VALUES (1, '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_17\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_17\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_17\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_18\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_18\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_18\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_19\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_19\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_19\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', NULL, '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '');
INSERT INTO cms_f_member_custom_fields (mf_member_id, field_1, field_1__text_parsed, field_1__source_user, field_2, field_2__text_parsed, field_2__source_user, field_3, field_4, field_4__text_parsed, field_4__source_user, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29, field_30, field_31, field_32, field_33, field_34, field_35, field_36) VALUES (2, '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_22\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_22\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_22\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_23\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_23\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_23\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_24\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_24\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_24\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', NULL, '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '');
INSERT INTO cms_f_member_custom_fields (mf_member_id, field_1, field_1__text_parsed, field_1__source_user, field_2, field_2__text_parsed, field_2__source_user, field_3, field_4, field_4__text_parsed, field_4__source_user, field_5, field_6, field_7, field_8, field_9, field_10, field_11, field_12, field_13, field_14, field_15, field_16, field_17, field_18, field_19, field_20, field_21, field_22, field_23, field_24, field_25, field_26, field_27, field_28, field_29, field_30, field_31, field_32, field_33, field_34, field_35, field_36) VALUES (3, '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_27\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_27\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_27\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_28\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_28\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_28\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', '', 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_29\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_29\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_29\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, '', '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', NULL, '', '', '', '', '', '', 0, '', '', '', '', '', '', '', '', '');

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT field_1 (field_1);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT field_2 (field_2);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT field_4 (field_4);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_17 (field_17);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_18 (field_18);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_19 (field_19);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_21 (field_21);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_22 (field_22);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_23 (field_23);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_24 (field_24);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_25 (field_25);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_26 (field_26);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_28 (field_28);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_29 (field_29);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_3 (field_3);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_30 (field_30);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_31 (field_31);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_32 (field_32);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_33 (field_33);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_34 (field_34);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_35 (field_35);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_36 (field_36);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_5 (field_5);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_6 (field_6);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_7 (field_7);

ALTER TABLE cms10_f_member_custom_fields ADD FULLTEXT mcf_ft_8 (field_8);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf1 (field_1(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf10 (field_10);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf11 (field_11(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf12 (field_12(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf13 (field_13(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf14 (field_14(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf15 (field_15(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf16 (field_16);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf2 (field_2(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf20 (field_20);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf25 (field_25(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf26 (field_26);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf27 (field_27(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf29 (field_29(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf3 (field_3(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf30 (field_30(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf31 (field_31(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf32 (field_32(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf34 (field_34);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf35 (field_35);

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf36 (field_36(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf4 (field_4(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf5 (field_5(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf6 (field_6(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf7 (field_7(250));

ALTER TABLE cms10_f_member_custom_fields ADD INDEX mcf8 (field_8(250));

DROP TABLE IF EXISTS cms_f_member_known_login_ips;

CREATE TABLE cms_f_member_known_login_ips (
    i_member_id integer NOT NULL,
    i_ip varchar(40) NOT NULL,
    i_val_code varchar(255) NOT NULL,
    PRIMARY KEY (i_member_id, i_ip)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_members;

CREATE TABLE cms_f_members (
    id integer unsigned auto_increment NOT NULL,
    m_username varchar(80) NOT NULL,
    m_pass_hash_salted varchar(255) NOT NULL,
    m_pass_salt varchar(255) NOT NULL,
    m_theme varchar(80) NOT NULL,
    m_avatar_url varchar(255) BINARY NOT NULL,
    m_validated tinyint(1) NOT NULL,
    m_validated_email_confirm_code varchar(255) NOT NULL,
    m_cache_num_posts integer NOT NULL,
    m_cache_warnings integer NOT NULL,
    m_join_time integer unsigned NOT NULL,
    m_timezone_offset varchar(255) NOT NULL,
    m_primary_group integer NOT NULL,
    m_last_visit_time integer unsigned NOT NULL,
    m_last_submit_time integer unsigned NOT NULL,
    m_signature longtext NOT NULL,
    m_is_perm_banned tinyint(1) NOT NULL,
    m_preview_posts tinyint(1) NOT NULL,
    m_dob_day tinyint NULL,
    m_dob_month tinyint NULL,
    m_dob_year integer NULL,
    m_reveal_age tinyint(1) NOT NULL,
    m_email_address varchar(255) NOT NULL,
    m_title varchar(255) NOT NULL,
    m_photo_url varchar(255) BINARY NOT NULL,
    m_photo_thumb_url varchar(255) BINARY NOT NULL,
    m_views_signatures tinyint(1) NOT NULL,
    m_auto_monitor_contrib_content tinyint(1) NOT NULL,
    m_language varchar(80) NOT NULL,
    m_ip_address varchar(40) NOT NULL,
    m_allow_emails tinyint(1) NOT NULL,
    m_allow_emails_from_staff tinyint(1) NOT NULL,
    m_highlighted_name tinyint(1) NOT NULL,
    m_pt_allow varchar(255) NOT NULL,
    m_pt_rules_text longtext NOT NULL,
    m_max_email_attach_size_mb integer NOT NULL,
    m_password_change_code varchar(255) NOT NULL,
    m_password_compat_scheme varchar(80) NOT NULL,
    m_on_probation_until integer unsigned NULL,
    m_profile_views integer unsigned NOT NULL,
    m_total_sessions integer unsigned NOT NULL,
    m_auto_mark_read tinyint(1) NOT NULL,
    m_signature__text_parsed longtext NOT NULL,
    m_signature__source_user integer DEFAULT 1 NOT NULL,
    m_pt_rules_text__text_parsed longtext NOT NULL,
    m_pt_rules_text__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_members (id, m_username, m_pass_hash_salted, m_pass_salt, m_theme, m_avatar_url, m_validated, m_validated_email_confirm_code, m_cache_num_posts, m_cache_warnings, m_join_time, m_timezone_offset, m_primary_group, m_last_visit_time, m_last_submit_time, m_signature, m_is_perm_banned, m_preview_posts, m_dob_day, m_dob_month, m_dob_year, m_reveal_age, m_email_address, m_title, m_photo_url, m_photo_thumb_url, m_views_signatures, m_auto_monitor_contrib_content, m_language, m_ip_address, m_allow_emails, m_allow_emails_from_staff, m_highlighted_name, m_pt_allow, m_pt_rules_text, m_max_email_attach_size_mb, m_password_change_code, m_password_compat_scheme, m_on_probation_until, m_profile_views, m_total_sessions, m_auto_mark_read, m_signature__text_parsed, m_signature__source_user, m_pt_rules_text__text_parsed, m_pt_rules_text__source_user) VALUES (1, 'Guest', '', '', '', '', 1, '', 0, 0, 1550714689, 'UTC', 1, 1550714689, 1550714689, '', 0, 1, NULL, NULL, NULL, 1, '', '', '', '', 1, 0, '', '127.0.0.1', 1, 1, 0, '*', '', 5, '', 'plain', NULL, 0, 0, 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_15\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_15\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_15\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_16\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_16\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_16\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_members (id, m_username, m_pass_hash_salted, m_pass_salt, m_theme, m_avatar_url, m_validated, m_validated_email_confirm_code, m_cache_num_posts, m_cache_warnings, m_join_time, m_timezone_offset, m_primary_group, m_last_visit_time, m_last_submit_time, m_signature, m_is_perm_banned, m_preview_posts, m_dob_day, m_dob_month, m_dob_year, m_reveal_age, m_email_address, m_title, m_photo_url, m_photo_thumb_url, m_views_signatures, m_auto_monitor_contrib_content, m_language, m_ip_address, m_allow_emails, m_allow_emails_from_staff, m_highlighted_name, m_pt_allow, m_pt_rules_text, m_max_email_attach_size_mb, m_password_change_code, m_password_compat_scheme, m_on_probation_until, m_profile_views, m_total_sessions, m_auto_mark_read, m_signature__text_parsed, m_signature__source_user, m_pt_rules_text__text_parsed, m_pt_rules_text__source_user) VALUES (2, 'admin', '', '', '', 'themes/default/images/cns_default_avatars/default_set/cool_flare.png', 1, '', 0, 0, 1550714689, 'UTC', 2, 1550714689, 1550714689, '', 0, 0, NULL, NULL, NULL, 1, '', '', '', '', 1, 1, '', '127.0.0.1', 1, 1, 0, '*', '', 5, '', 'plain', NULL, 0, 0, 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_20\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_20\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_20\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_21\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_21\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_21\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);
INSERT INTO cms_f_members (id, m_username, m_pass_hash_salted, m_pass_salt, m_theme, m_avatar_url, m_validated, m_validated_email_confirm_code, m_cache_num_posts, m_cache_warnings, m_join_time, m_timezone_offset, m_primary_group, m_last_visit_time, m_last_submit_time, m_signature, m_is_perm_banned, m_preview_posts, m_dob_day, m_dob_month, m_dob_year, m_reveal_age, m_email_address, m_title, m_photo_url, m_photo_thumb_url, m_views_signatures, m_auto_monitor_contrib_content, m_language, m_ip_address, m_allow_emails, m_allow_emails_from_staff, m_highlighted_name, m_pt_allow, m_pt_rules_text, m_max_email_attach_size_mb, m_password_change_code, m_password_compat_scheme, m_on_probation_until, m_profile_views, m_total_sessions, m_auto_mark_read, m_signature__text_parsed, m_signature__source_user, m_pt_rules_text__text_parsed, m_pt_rules_text__source_user) VALUES (3, 'test', '', '', '', '', 1, '', 0, 0, 1550714689, 'UTC', 9, 1550714689, 1550714689, '', 0, 0, NULL, NULL, NULL, 1, '', '', '', '', 1, 0, '', '127.0.0.1', 1, 1, 0, '*', '', 5, '', 'plain', NULL, 0, 0, 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_25\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_25\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_25\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5c6e0740df71b5.30746288_26\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5c6e0740df71b5.30746288_26\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5c6e0740df71b5.30746288_26\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1);

ALTER TABLE cms10_f_members ADD FULLTEXT m_pt_rules_text (m_pt_rules_text);

ALTER TABLE cms10_f_members ADD FULLTEXT m_signature (m_signature);

ALTER TABLE cms10_f_members ADD FULLTEXT search_user (m_username);

ALTER TABLE cms10_f_members ADD INDEX avatar_url (m_avatar_url(250));

ALTER TABLE cms10_f_members ADD INDEX birthdays (m_dob_day,m_dob_month);

ALTER TABLE cms10_f_members ADD INDEX external_auth_lookup (m_pass_hash_salted(250));

ALTER TABLE cms10_f_members ADD INDEX ftjoin_msig (m_signature(250));

ALTER TABLE cms10_f_members ADD INDEX last_visit_time (m_dob_month,m_dob_day,m_last_visit_time);

ALTER TABLE cms10_f_members ADD INDEX menail (m_email_address(250));

ALTER TABLE cms10_f_members ADD INDEX m_join_time (m_join_time);

ALTER TABLE cms10_f_members ADD INDEX primary_group (m_primary_group);

ALTER TABLE cms10_f_members ADD INDEX sort_post_count (m_cache_num_posts);

ALTER TABLE cms10_f_members ADD INDEX user_list (m_username);

ALTER TABLE cms10_f_members ADD INDEX whos_validated (m_validated);

DROP TABLE IF EXISTS cms_f_moderator_logs;

CREATE TABLE cms_f_moderator_logs (
    id integer unsigned auto_increment NOT NULL,
    l_the_type varchar(80) NOT NULL,
    l_param_a varchar(255) NOT NULL,
    l_param_b varchar(255) NOT NULL,
    l_date_and_time integer unsigned NOT NULL,
    l_reason longtext NOT NULL,
    l_by integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_multi_moderations;

CREATE TABLE cms_f_multi_moderations (
    id integer unsigned auto_increment NOT NULL,
    mm_name longtext NOT NULL,
    mm_post_text longtext NOT NULL,
    mm_move_to integer NULL,
    mm_pin_state tinyint(1) NULL,
    mm_sink_state tinyint(1) NULL,
    mm_open_state tinyint(1) NULL,
    mm_forum_multi_code varchar(255) NOT NULL,
    mm_title_suffix varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_multi_moderations (id, mm_name, mm_post_text, mm_move_to, mm_pin_state, mm_sink_state, mm_open_state, mm_forum_multi_code, mm_title_suffix) VALUES (1, 'Trash', '', 4, 0, 0, 0, '*', '');

ALTER TABLE cms10_f_multi_moderations ADD FULLTEXT mm_name (mm_name);

DROP TABLE IF EXISTS cms_f_password_history;

CREATE TABLE cms_f_password_history (
    id integer unsigned auto_increment NOT NULL,
    p_member_id integer NOT NULL,
    p_hash_salted varchar(255) NOT NULL,
    p_salt varchar(255) NOT NULL,
    p_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_f_password_history ADD INDEX p_member_id (p_member_id);

DROP TABLE IF EXISTS cms_f_poll_answers;

CREATE TABLE cms_f_poll_answers (
    id integer unsigned auto_increment NOT NULL,
    pa_poll_id integer NOT NULL,
    pa_answer varchar(255) NOT NULL,
    pa_cache_num_votes integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_poll_votes;

CREATE TABLE cms_f_poll_votes (
    id integer unsigned auto_increment NOT NULL,
    pv_poll_id integer NOT NULL,
    pv_member_id integer NOT NULL,
    pv_answer_id integer NOT NULL,
    pv_ip varchar(40) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

