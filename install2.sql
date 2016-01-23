DROP TABLE IF EXISTS `cms_db_meta`;
CREATE TABLE IF NOT EXISTS `cms_db_meta` (
  `m_table` varchar(80) NOT NULL,
  `m_name` varchar(80) NOT NULL,
  `m_type` varchar(80) NOT NULL,
  PRIMARY KEY (`m_table`,`m_name`),
  KEY `findtransfields` (`m_type`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_db_meta`
--

INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'language', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'importance_level', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'text_original', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'text_parsed', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'broken', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'source_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('values', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('values', 'the_value', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('values', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'human_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'c_set', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'config_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'eval', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'the_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'section', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'explanation', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'shared_hosting_restricted', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'c_data', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'group_id', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'specific_permission', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'the_value', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sp_list', 'p_section', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sp_list', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sp_list', 'the_default', '*BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_file_size', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_description', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_thumb_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_original_filename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_num_downloads', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_last_downloaded_time', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_add_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'r_referer_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'r_referer_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'a_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_default_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_header_text', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_theme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_wide', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_require_session', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_displayed_in_menu', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_organisation', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_hacked_by', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_hack_version', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_version', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_organisation', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_hacked_by', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_hack_version', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_version', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'last_activity', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'session_confirmed', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'session_invisible', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'cache_username', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_zone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('https_pages', 'https_page_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_category_access', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_category_access', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_category_access', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_keywords', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'field_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'guest_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'member_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'friend_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'group_view', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_code', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_theme_img_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_relevance_level', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_use_topics', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_is_special', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_locked', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_description', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_default', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_public_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_owner_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_owner_set', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_required', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_show_in_posts', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_show_in_post_previews', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_only_group', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_encrypted', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_show_on_join_form', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'mf_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_1', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_2', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_3', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_4', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_5', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_6', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_7', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_8', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_9', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_inviter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_email_address', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_taken', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_members', 'gm_group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_members', 'gm_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_members', 'gm_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pass_hash_salted', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pass_salt', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_theme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_avatar_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_validated_email_confirm_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_cache_num_posts', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_cache_warnings', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_join_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_timezone_offset', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_primary_group', 'GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_last_visit_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_last_submit_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_signature', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_is_perm_banned', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_preview_posts', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_dob_day', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_dob_month', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_dob_year', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_reveal_age', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_email_address', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_photo_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_photo_thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_views_signatures', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_auto_monitor_contrib_content', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_language', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_allow_emails', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_allow_emails_from_staff', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_zone_wide', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_highlighted_name', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pt_allow', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pt_rules_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_max_email_attach_size_mb', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_password_change_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_password_compat_scheme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_on_probation_until', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_default', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_presented_at_install', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_super_admin', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_super_moderator', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_group_leader', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_promotion_target', '?GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_promotion_threshold', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_flood_control_submit_secs', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_flood_control_access_secs', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_gift_points_base', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_gift_points_per_day', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_daily_upload_mb', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_attachments_per_post', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_avatar_width', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_avatar_height', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_post_length_comcode', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_sig_length_comcode', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_enquire_on_new_ips', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_rank_image', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_hidden', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_rank_image_pri_only', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_open_membership', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_private_club', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_page_access', 'page_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('match_key_messages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('match_key_messages', 'k_message', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('match_key_messages', 'k_match_key', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_zone_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_zone_access', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'c_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'c_description', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'c_expanded_by_default', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_category_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_parent_forum', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_position', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_order_sub_alpha', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_post_count_increment', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_intro_question', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_intro_answer', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_num_topics', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_num_posts', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_topic_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_username', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_forum_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_redirection', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_order', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_is_threaded', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pinned', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_sunk', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cascading', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_forum_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_from', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_to', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_from_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_to_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_description', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_description_link', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_emoticon', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_num_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_is_open', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_poll_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_post_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_post', '?LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_post_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_num_posts', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_post', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_poster', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_intended_solely_for', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_poster_name_if_guest', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_cache_forum_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_last_edit_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_last_edit_by', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_is_emphasised', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_skip_sig', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_parent_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_special_pt_access', 's_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_special_pt_access', 's_topic_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_saved_warnings', 's_title', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_saved_warnings', 's_explanation', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_saved_warnings', 's_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_create_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_action_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_owner_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_alterer_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_post_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_before', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_action', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_ip', 'i_forum_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_ip', 'i_ip', '*IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_member', 'i_forum_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_member', 'i_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_text', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_forum_multi_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_use_default_forums', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_question', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_cache_total_votes', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_is_private', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_is_open', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_minimum_selections', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_maximum_selections', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_requires_reply', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'pa_poll_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'pa_answer', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'pa_cache_num_votes', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_votes', 'pv_poll_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_votes', 'pv_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_votes', 'pv_answer_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_name', '*SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_post_text', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_move_to', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_pin_state', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_sink_state', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_open_state', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_forum_multi_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_title_suffix', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_explanation', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_by', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_is_warning', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_silence_from_topic', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_silence_from_forum', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_probation', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_banned_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_charged_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_banned_member', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_changed_usergroup_from', '?GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_param_a', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_param_b', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_reason', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_by', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_known_login_ips', 'i_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_known_login_ips', 'i_ip', '*IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_known_login_ips', 'i_val_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_read_logs', 'l_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_read_logs', 'l_topic_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_read_logs', 'l_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_menu', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_parent', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_caption', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_caption_long', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_check_permissions', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_expanded', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_new_window', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_page_only', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_theme_img_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_excerpt', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('security_images', 'si_session_id', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('security_images', 'si_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('security_images', 'si_code', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_cache_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_type', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache_on', 'cached_for', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache_on', 'cache_on', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache_on', 'cache_ttl', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('validated_once', 'hash', '*MD5');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'lang_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'language', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'text_original', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'broken', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'action_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'action_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('long_values', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('long_values', 'the_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('long_values', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tutorial_links', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tutorial_links', 'the_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'member_id', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'specific_permission', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'the_value', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_zone_access', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_zone_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_zone_access', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'page_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_key', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_session_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_title_cache', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_title_cache', 't_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_title_cache', 't_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_resource_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_resource_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_resource_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_moniker', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_deprecated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_post_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating_type', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 's_trigger_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_10', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_subject', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_to_email', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_to_name', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_from_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_from_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_attachments', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_no_cc', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_as', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_as_admin', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_in_html', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_url', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_queued', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_template', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_orig_filename', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_save_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'cached_for', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'identifier', '*MINIID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'the_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'the_theme', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'lang', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'langs_required', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_member_timeouts', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_member_timeouts', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_member_timeouts', 'timeout', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'p_session_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'p_block_constraints', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'p_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_codename', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_map', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_timezone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_is_bot', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_store_as_tempcode', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_lang', 'LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_theme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_notification_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_code_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_setting', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_subject', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_from_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_to_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_no_cc', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_notification_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_code_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_frequency', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_consumed', 'c_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_consumed', 'c_frequency', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_consumed', 'c_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_page_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_page_access', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_name', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_author', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_organisation', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_version', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_description', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_install_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_files', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_files', 'addon_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_files', 'filename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'addon_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'addon_name_dependant_upon', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'addon_name_incompatibility', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'a_type_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'date_and_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'content_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_content_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_hide_awardee', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_update_time_hours', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_tag', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_description', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_replace', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_example', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_parameters', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_dangerous_tag', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_block_tag', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_textual_tag', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'user_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'the_message', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'days', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'order_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'activation_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'active_now', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_parts_done', 'imp_id', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_parts_done', 'imp_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_old_base_dir', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_db_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_db_user', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_hook', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_db_table_prefix', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_refresh_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_old', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_new', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_type', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'ip', '*IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'i_descrip', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'i_ban_until', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'i_ban_positive', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_member', 'the_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notification_lockdown', 'l_notification_code', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notification_lockdown', 'l_setting', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_incoming', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_timestamp', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_subject', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_send_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_newsletter', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_from_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_from_zone', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_to_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_to_zone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_is_transparent', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'data_post', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'user_agent', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'referer', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'user_os', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'reason', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'reason_param_a', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'reason_param_b', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'the_page', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'referer', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'get', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'post', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'browser', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'milliseconds', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'operating_system', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'access_denied_counter', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersonline_track', 'date_and_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersonline_track', 'peak', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'begin_num', 'UINTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'end_num', 'UINTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'country', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'id', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'theme', '*MINIID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'path', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'lang', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('wordfilter', 'word', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('wordfilter', 'w_replacement', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('wordfilter', 'w_substr', '*BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'author', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'forum_handle', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'skills', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'expiry_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'img_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'the_type', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'b_title_text', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'caption', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'b_direct_code', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'campaign_remaining', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'site_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'hits_from', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'views_from', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'hits_to', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'views_to', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'importance_modulus', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'b_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 'id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_is_textual', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_image_width', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_image_height', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_max_file_size', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_comcode_inline', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_source', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_banner_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_owner', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_folder', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_page_link', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_content', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_recurrence', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_recurrences', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_seg_recurrences', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_year', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_month', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_day', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_monthly_spec_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_hour', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_minute', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_year', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_month', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_day', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_monthly_spec_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_hour', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_minute', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_timezone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_do_timezone_conv', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_is_public', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_priority', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_type', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 't_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 't_logo', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 't_external_feed', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'e_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'n_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'n_seconds_before', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_interests', 'i_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_interests', 't_type', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_reminder_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_event_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_display_type', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_is_tree', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_submit_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_ecommerce', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_send_view_reports', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'c_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_parent_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_move_target', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_move_days_lower', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_move_days_higher', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'c_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_defines_order', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_visible', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_searchable', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_default', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_required', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_put_in_category', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_put_in_search', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'c_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'cc_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_views_prior', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_last_moved', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'cv_value', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'cv_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'cv_value', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'cv_value', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entry_linkage', 'catalogue_entry_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entry_linkage', 'content_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entry_linkage', 'content_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_cat_treecache', 'cc_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_cat_treecache', 'cc_ancestor_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_childcountcache', 'cc_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_childcountcache', 'c_num_rec_children', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_childcountcache', 'c_num_rec_entries', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'cv_value', '?REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'cv_value', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'the_action', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'the_page', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'parent_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'child_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'the_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'seedy_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'hide_posts', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'page_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'the_message', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'seedy_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_11', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'room_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'room_owner', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'allow_list', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'allow_list_groups', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'disallow_list', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'disallow_list_groups', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'room_language', 'LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'c_welcome', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'is_im', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'system_message', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'room_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'user_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'the_message', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'text_colour', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'font_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_12', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_blocking', 'member_blocker', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_blocking', 'member_blocked', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_blocking', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_buddies', 'member_likes', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_buddies', 'member_liked', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_buddies', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_type_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_room_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'room_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_sound_effects', 's_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_sound_effects', 's_effect_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_sound_effects', 's_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'category', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'parent_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'category_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'comments', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'num_downloads', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'out_mode_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'default_pic', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'file_size', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_cost', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_submitter_gets_points', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'original_filename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_licence', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_data_mash', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'the_user', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_licences', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_licences', 'l_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_licences', 'l_text', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'teaser', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'fullname', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'parent_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_top_left', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_top_right', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_bottom_left', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_bottom_right', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'accept_images', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'accept_videos', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'is_member_synched', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'flow_mode_interface', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'gallery_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'g_owner', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'cat', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'comments', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'image_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'cat', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'comments', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_width', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_height', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_length', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_error', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_table', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_url_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_orig_filename_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_width_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_height_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_output_filename', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_type_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_state', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_special', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_note', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'i_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'caption', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'is_current', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'used', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'date_and_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'iotd_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_article', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_category', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'nc_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'nc_owner', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'nc_img', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_procedure', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_port', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_path', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_protocol', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'watching_channel', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'register_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_category_entries', 'news_entry', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_category_entries', 'news_entry_category', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'join_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'code_confirm', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'the_password', 'MD5');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'pass_salt', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'language', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'n_forename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'n_surname', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'date_and_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'subject', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'newsletter', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'language', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'importance_level', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletters', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletters', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletters', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_subscribe', 'newsletter_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_subscribe', 'the_level', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_subscribe', 'email', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_inject_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_subject', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_html_only', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_to_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_to_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_from_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_from_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_template', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_subject', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_lang', 'LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_send_details', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_html_only', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_from_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_from_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_csv_data', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_frequency', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_day', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_in_full', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_template', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_last_sent', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'user_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'amount', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'reason', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'amount', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'gift_from', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'gift_to', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'reason', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'anonymous', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_mail_subject', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_mail_body', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_cost', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_one_per_member', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_mail_subject', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_mail_body', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_cost', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_hours', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_specific_permission', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_zone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_module', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_category', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('prices', 'name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('prices', 'price', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'memberid', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'purchasetype', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'details', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'details2', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'question', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option1', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option2', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option3', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option4', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option5', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option6', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option7', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option8', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option9', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option10', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes1', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes2', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes3', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes4', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes5', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes6', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes7', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes8', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes9', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes10', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'num_options', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'is_current', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'date_and_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'add_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'poll_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_poll_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_voter_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_voter_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_vote_for', '?SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_purchase_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_item_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_length', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_length_units', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_13', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_14', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_15', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_16', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_17', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_18', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_19', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_20', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'purchase_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'status', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'reason', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_currency', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'linked', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'item', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'pending_reason', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_memo', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_via', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'v_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'v_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'v_quiz_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_timeout', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_start_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_end_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_percentage', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_open_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_close_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_num_winners', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_redo_time', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_points_for_passing', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_tied_newsletter', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_end_text_fail', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_long_input_field', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_num_choosable_answers', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_quiz', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_question_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_required', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_question', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_answer_text', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_is_correct', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_explanation', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_winner', 'q_quiz', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_winner', 'q_entry', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_winner', 'q_winner_level', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_quiz', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_results', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'q_entry', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'q_question', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'q_answer', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_primary', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_auxillary', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_primary', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_auxillary', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_num_results', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'c_member', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'tot_price', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'order_status', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'transaction_id', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'purchase_through', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'tax_opted_out', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'ordered_by', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'quantity', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'price_pre_tax', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'price', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_description', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_type', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_weight', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'is_deleted', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'order_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_type', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_quantity', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_price', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'included_tax', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'dispatch_status', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'e_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'last_action', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'order_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_street', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_city', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_zip', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_country', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'receiver_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_21', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_22', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_23', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_24', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_25', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_26', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_27', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_type_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_state', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_special', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_auto_fund_source', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_auto_fund_key', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_via', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_cost', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_length', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_length_units', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_group_id', 'GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_mail_start', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_mail_end', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_mail_uhoh', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_uses_primary', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_section', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_inheritable', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_assigned_to', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_section', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_test', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_assigned_to', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_status', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_inherit_section', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'ticket_id', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'forum_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'ticket_type', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'ticket_type', '*SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'guest_emails_mandatory', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'search_faq', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'cache_lead_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'the_zone', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_parent_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_show_as_edit', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'the_zone', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'string_index', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'the_theme', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'cc_page_title', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'path', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'description', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'the_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('leader_board', 'lb_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('leader_board', 'lb_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('leader_board', 'date_and_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'content_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'block_cache_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'run_period', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'running_now', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'last_update', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'param_a', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'param_b', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'task_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'recur_interval', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'recur_every', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'task_is_done', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'link', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'link_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'link_desc', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('staff_tips_dismissed', 't_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('staff_tips_dismissed', 't_tip', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sitewatchlist', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sitewatchlist', 'siteurl', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sitewatchlist', 'site_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_weather_codes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_weather_codes', 'w_string', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_weather_codes', 'w_code', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'failed_account', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_28', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_29', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_30', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_31', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_32', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_33', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_34', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_35', 'SHORT_TEXT');

-- --------------------------------------------------------

--
-- Table structure for table `cms_db_meta_indices`
--

DROP TABLE IF EXISTS `cms_db_meta_indices`;
CREATE TABLE IF NOT EXISTS `cms_db_meta_indices` (
  `i_table` varchar(80) NOT NULL,
  `i_name` varchar(80) NOT NULL,
  `i_fields` varchar(80) NOT NULL,
  PRIMARY KEY (`i_table`,`i_name`,`i_fields`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_db_meta_indices`
--

INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'aip', 'ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'athe_type', 'the_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'ts', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'xas', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('attachments', 'attachmentlimitcheck', 'a_add_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('attachments', 'ownedattachments', 'a_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('authors', 'findmemberlink', 'forum_handle');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('autosave', 'myautosaves', 'a_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('award_archive', 'awardquicksearch', 'content_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'badd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'banner_child_find', 'b_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'bvalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'campaign_remaining', 'campaign_remaining');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'expiry_date', 'expiry_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'the_type', 'the_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'topsites', 'hits_from,hits_to');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banner_clicks', 'clicker_ip', 'c_ip_address');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banner_types', 'hottext', 't_comcode_inline');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_ford', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_fore', 'cached_for');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_forf', 'lang');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_forg', 'identifier');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_forh', 'the_theme');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cached_comcode_pages', 'ccp_join', 'the_page,the_zone');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cached_comcode_pages', 'ftjoin_ccpt', 'cc_page_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cached_comcode_pages', 'ftjoin_ccsi', 'string_index');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'ces', 'e_submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'eventat', 'e_start_year,e_start_month,e_start_day,e_start_hour,e_start_minute');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'e_add_date', 'e_add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'e_type', 'e_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'e_views', 'e_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'ftjoin_econtent', 'e_content');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'ftjoin_etitle', 'e_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'publicevents', 'e_is_public');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'validated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_jobs', 'applicablejobs', 'j_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'cataloguefind', 'c_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'catstoclean', 'cc_move_target');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'cc_parent_id', 'cc_parent_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'ftjoin_ccdescrip', 'cc_description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'ftjoin_cctitle', 'cc_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_cat_treecache', 'cc_ancestor_id', 'cc_ancestor_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'cefv_f_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'fce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'fcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'fcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'cefv_i_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'ice_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'icf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'itv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', '#lcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', 'cefv_l_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', 'lce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', 'lcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'cefv_lt_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'ltce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'ltcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'ltcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', '#scv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'cefv_s_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'iscv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'sce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'scf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'cefv_st_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'stce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'stcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'stcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ces', 'ce_submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_add_date', 'ce_add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_cc_id', 'cc_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_c_name', 'c_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_validated', 'ce_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_views', 'ce_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entry_linkage', 'custom_fields', 'content_type,content_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_active', 'active_ordering', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_active', 'member_select', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_active', 'room_select', 'room_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_events', 'event_ordering', 'e_date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_messages', 'ordering', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_messages', 'room_id', 'room_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'allow_list', 'allow_list(30)');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'first_public', 'is_im,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'is_im', 'is_im,room_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'room_name', 'room_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('comcode_pages', 'p_add_date', 'p_add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('comcode_pages', 'p_submitter', 'p_submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('comcode_pages', 'p_validated', 'p_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cron_caching_requests', 'c_compound', 'c_codename,c_theme,c_lang,c_timezone');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cron_caching_requests', 'c_is_bot', 'c_is_bot');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cron_caching_requests', 'c_store_as_tempcode', 'c_store_as_tempcode');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('digestives_tin', 'd_date_and_time', 'd_date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('digestives_tin', 'd_frequency', 'd_frequency');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('digestives_tin', 'd_to_member_id', 'd_to_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_categories', 'child_find', 'parent_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_categories', 'ftjoin_dccat', 'category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_categories', 'ftjoin_dcdescrip', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', '#download_data_mash', 'download_data_mash');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', '#original_filename', 'original_filename');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'category_list', 'category_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ddl', 'download_licence');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'dds', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'downloadauthor', 'author');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'download_views', 'download_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'dvalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ftjoin_dcomments', 'comments');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ftjoin_ddescrip', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ftjoin_dname', 'name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'recent_downloads', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'top_downloads', 'num_downloads');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_logging', 'calculate_bandwidth', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_emoticons', 'relevantemoticons', 'e_relevance_level');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_emoticons', 'topicemos', 'e_use_topics');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'cache_num_posts', 'f_cache_num_posts');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'findnamedforum', 'f_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'f_position', 'f_position');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'subforum_parenting', 'f_parent_forum');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'ftjoin_gname', 'g_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'ftjoin_gtitle', 'g_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'gorder', 'g_order,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'hidden', 'g_hidden');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_default', 'g_is_default');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_presented_at_install', 'g_is_presented_at_install');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_private_club', 'g_is_private_club');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_super_admin', 'g_is_super_admin');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_super_moderator', 'g_is_super_moderator');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_group_members', 'gm_group_id', 'gm_group_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_group_members', 'gm_member_id', 'gm_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_group_members', 'gm_validated', 'gm_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', '#search_user', 'm_username');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'avatar_url', 'm_avatar_url');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'birthdays', 'm_dob_day,m_dob_month');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'external_auth_lookup', 'm_pass_hash_salted');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'ftjoin_msig', 'm_signature');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'menail', 'm_email_address');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'm_join_time', 'm_join_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'primary_group', 'm_primary_group');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'sort_post_count', 'm_cache_num_posts');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'user_list', 'm_username');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'whos_validated', 'm_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf10', 'field_10');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf13', 'field_13');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf14', 'field_14');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf15', 'field_15');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf17', 'field_17');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf18', 'field_18');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf19', 'field_19');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf2', 'field_2');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf20', 'field_20');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf21', 'field_21');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf22', 'field_22');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf23', 'field_23');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf24', 'field_24');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf25', 'field_25');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf26', 'field_26');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf27', 'field_27');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf3', 'field_3');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf33', 'field_33');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf34', 'field_34');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf35', 'field_35');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf4', 'field_4');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf5', 'field_5');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf7', 'field_7');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf8', 'field_8');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', '#p_title', 'p_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'deletebyip', 'p_ip_address');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'find_pp', 'p_intended_solely_for');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'in_topic', 'p_topic_id,p_time,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'postsinforum', 'p_cache_forum_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'posts_by', 'p_poster');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'post_order_time', 'p_time,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'p_last_edit_time', 'p_last_edit_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'p_validated', 'p_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'search_join', 'p_post');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_post_history', 'phistorylookup', 'h_post_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_read_logs', 'erase_old_read_logs', 'l_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', '#t_description', 't_description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'descriptionsearch', 't_description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'forumlayer', 't_cache_first_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'in_forum', 't_forum_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'ownedtopics', 't_cache_first_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order', 't_cascading,t_pinned,t_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_2', 't_forum_id,t_cascading,t_pinned,t_sunk,t_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_3', 't_forum_id,t_cascading,t_pinned,t_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_time', 't_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_time_2', 't_cache_first_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_cascading', 't_cascading');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_cascading_or_forum', 't_cascading,t_forum_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_num_views', 't_num_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_pt_from', 't_pt_from');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_pt_to', 't_pt_to');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_validated', 't_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_warnings', 'warningsmemberid', 'w_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'ftjoin_gdescrip', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'ftjoin_gfullname', 'fullname');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'gadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'parent_id', 'parent_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_bottom_left', 'watermark_bottom_left');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_bottom_right', 'watermark_bottom_right');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_top_left', 'watermark_top_left');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_top_right', 'watermark_top_right');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('gifts', 'giftsgiven', 'gift_from');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('gifts', 'giftsreceived', 'gift_to');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('group_zone_access', 'group_id', 'group_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('hackattack', 'h_date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('hackattack', 'otherhacksby', 'ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'category_list', 'cat');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'ftjoin_icomments', 'comments');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'iadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'image_views', 'image_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'i_validated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'xis', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'ftjoin_icap', 'caption');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'get_current', 'is_current');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'iadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'ios', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'iotd_views', 'iotd_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('logged_mail_messages', 'queued', 'm_queued');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('logged_mail_messages', 'recentmessages', 'm_date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_category_access', 'mcamember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_category_access', 'mcaname', 'module_the_name,category_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_page_access', 'mzamember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_page_access', 'mzaname', 'page_name,zone_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_tracking', 'mt_id', 'mt_page,mt_id,mt_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_tracking', 'mt_page', 'mt_page');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_zone_access', 'mzamember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_zone_access', 'mzazone_name', 'zone_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('menu_items', 'menu_extraction', 'i_menu');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('messages_to_render', 'forsession', 'r_session_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('msp', 'mspmember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('msp', 'mspname', 'specific_permission,the_page,module_the_name,category_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'findnewscat', 'news_category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'ftjoin_ititle', 'title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'ftjoin_nnews', 'news');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'ftjoin_nnewsa', 'news_article');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'headlines', 'date_and_time,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'nes', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'newsauthor', 'author');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'news_views', 'news_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'nvalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter', 'code_confirm', 'code_confirm');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter', 'welcomemails', 'join_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter_drip_send', 'd_inject_time', 'd_inject_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter_subscribe', 'peopletosendto', 'the_level');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news_categories', 'ncs', 'nc_owner');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news_category_entries', 'news_entry_category', 'news_entry_category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('notifications_enabled', 'l_code_category', 'l_code_category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('notifications_enabled', 'l_member_id', 'l_member_id,l_notification_code');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po1', 'option1');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po2', 'option2');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po3', 'option3');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po4', 'option4');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po5', 'option5');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_pq', 'question');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'get_current', 'is_current');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'padd_time', 'add_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'poll_views', 'poll_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ps', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll_votes', 'v_voter_id', 'v_voter_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll_votes', 'v_voter_ip', 'v_voter_ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll_votes', 'v_vote_for', 'v_vote_for');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('quizzes', 'ftjoin_qstarttext', 'q_start_text');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('quizzes', 'q_validated', 'q_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('rating', 'alt_key', 'rating_for_type,rating_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('rating', 'rating_for_id', 'rating_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('review_supplement', 'rating_for_id', 'r_rating_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('searches_logged', '#past_search_ft', 's_primary');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('searches_logged', 'past_search', 's_primary');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('security_images', 'si_time', 'si_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'ftjoin_spd', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'ftjoin_spt', 'title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'sadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'seedy_views', 'seedy_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'sps', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'cdate_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'ftjoin_spm', 'the_message');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'posts_on_page', 'page_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'seedy_views', 'seedy_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'spos', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'svalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seo_meta', 'alt_key', 'meta_for_type,meta_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sessions', 'delete_old', 'last_activity');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sessions', 'the_user', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sessions', 'userat', 'the_zone,the_page,the_type,the_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_cart', 'ordered_by', 'ordered_by');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_cart', 'product_id', 'product_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_cart', 'session_id', 'session_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_logging', 'calculate_bandwidth', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'finddispatchable', 'order_status');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'recent_shopped', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'soadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'soc_member', 'c_member');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'sosession_id', 'session_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order_addresses', 'order_id', 'order_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order_details', 'order_id', 'order_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order_details', 'p_id', 'p_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sms_log', 'sms_log_for', 's_member_id,s_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sms_log', 'sms_trigger_ip', 's_trigger_ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'browser', 'browser');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'member_track_1', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'member_track_2', 'ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'milliseconds', 'milliseconds');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'operating_system', 'operating_system');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'pages', 'the_page');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'referer', 'referer');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('text', 'findflagrant', 'active_now');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('theme_images', 'theme', 'theme,lang');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('trackbacks', 'trackback_for_id', 'trackback_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('trackbacks', 'trackback_for_type', 'trackback_for_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('trackbacks', 'trackback_time', 'trackback_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', '#search', 'text_original');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', 'decache', 'text_parsed(2)');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', 'equiv_lang', 'text_original(4)');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', 'importance_level', 'importance_level');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('url_id_monikers', 'uim_moniker', 'm_moniker');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('url_id_monikers', 'uim_pagelink', 'm_resource_page,m_resource_type,m_resource_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('usersonline_track', 'peak_track', 'peak');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('values', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'category_list', 'cat');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'ftjoin_vcomments', 'comments');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'vadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'video_views', 'video_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'vs', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'v_validated', 'validated');

-- --------------------------------------------------------

--
-- Table structure for table `cms_digestives_consumed`
--

DROP TABLE IF EXISTS `cms_digestives_consumed`;
CREATE TABLE IF NOT EXISTS `cms_digestives_consumed` (
  `c_member_id` int(11) NOT NULL,
  `c_frequency` int(11) NOT NULL,
  `c_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`c_member_id`,`c_frequency`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_digestives_consumed`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_digestives_tin`
--

DROP TABLE IF EXISTS `cms_digestives_tin`;
CREATE TABLE IF NOT EXISTS `cms_digestives_tin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `d_subject` longtext NOT NULL,
  `d_message` longtext NOT NULL,
  `d_from_member_id` int(11) DEFAULT NULL,
  `d_to_member_id` int(11) NOT NULL,
  `d_priority` tinyint(4) NOT NULL,
  `d_no_cc` tinyint(1) NOT NULL,
  `d_date_and_time` int(10) unsigned NOT NULL,
  `d_notification_code` varchar(80) NOT NULL,
  `d_code_category` varchar(255) NOT NULL,
  `d_frequency` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `d_date_and_time` (`d_date_and_time`),
  KEY `d_frequency` (`d_frequency`),
  KEY `d_to_member_id` (`d_to_member_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_digestives_tin`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_download_categories`
--

DROP TABLE IF EXISTS `cms_download_categories`;
CREATE TABLE IF NOT EXISTS `cms_download_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` int(10) unsigned NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `notes` longtext NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `child_find` (`parent_id`),
  KEY `ftjoin_dccat` (`category`),
  KEY `ftjoin_dcdescrip` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_download_categories`
--

INSERT INTO `cms_download_categories` (`id`, `category`, `parent_id`, `add_date`, `notes`, `description`, `rep_image`) VALUES(1, 292, NULL, 1344775599, '', 293, '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_download_downloads`
--

DROP TABLE IF EXISTS `cms_download_downloads`;
CREATE TABLE IF NOT EXISTS `cms_download_downloads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `name` int(10) unsigned NOT NULL,
  `url` varchar(255) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `author` varchar(80) NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `num_downloads` int(11) NOT NULL,
  `out_mode_id` int(11) DEFAULT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  `validated` tinyint(1) NOT NULL,
  `default_pic` int(11) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `download_views` int(11) NOT NULL,
  `download_cost` int(11) NOT NULL,
  `download_submitter_gets_points` tinyint(1) NOT NULL,
  `submitter` int(11) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  `download_licence` int(11) DEFAULT NULL,
  `download_data_mash` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `download_views` (`download_views`),
  KEY `category_list` (`category_id`),
  KEY `recent_downloads` (`add_date`),
  KEY `top_downloads` (`num_downloads`),
  KEY `downloadauthor` (`author`),
  KEY `dds` (`submitter`),
  KEY `ddl` (`download_licence`),
  KEY `dvalidated` (`validated`),
  KEY `ftjoin_dname` (`name`),
  KEY `ftjoin_ddescrip` (`description`),
  KEY `ftjoin_dcomments` (`comments`),
  FULLTEXT KEY `download_data_mash` (`download_data_mash`),
  FULLTEXT KEY `original_filename` (`original_filename`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_download_downloads`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_download_licences`
--

DROP TABLE IF EXISTS `cms_download_licences`;
CREATE TABLE IF NOT EXISTS `cms_download_licences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `l_title` varchar(255) NOT NULL,
  `l_text` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_download_licences`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_download_logging`
--

DROP TABLE IF EXISTS `cms_download_logging`;
CREATE TABLE IF NOT EXISTS `cms_download_logging` (
  `id` int(11) NOT NULL,
  `the_user` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`the_user`),
  KEY `calculate_bandwidth` (`date_and_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_download_logging`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_edit_pings`
--

DROP TABLE IF EXISTS `cms_edit_pings`;
CREATE TABLE IF NOT EXISTS `cms_edit_pings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `the_page` varchar(80) NOT NULL,
  `the_type` varchar(80) NOT NULL,
  `the_id` varchar(80) NOT NULL,
  `the_time` int(10) unsigned NOT NULL,
  `the_member` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_edit_pings`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_failedlogins`
--

DROP TABLE IF EXISTS `cms_failedlogins`;
CREATE TABLE IF NOT EXISTS `cms_failedlogins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `failed_account` varchar(80) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `ip` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_failedlogins`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_feature_lifetime_monitor`
--

DROP TABLE IF EXISTS `cms_feature_lifetime_monitor`;
CREATE TABLE IF NOT EXISTS `cms_feature_lifetime_monitor` (
  `content_id` varchar(80) NOT NULL,
  `block_cache_id` varchar(80) NOT NULL,
  `run_period` int(11) NOT NULL,
  `running_now` tinyint(1) NOT NULL,
  `last_update` int(10) unsigned NOT NULL,
  PRIMARY KEY (`content_id`,`block_cache_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_feature_lifetime_monitor`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_filedump`
--

DROP TABLE IF EXISTS `cms_filedump`;
CREATE TABLE IF NOT EXISTS `cms_filedump` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `path` varchar(255) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `the_member` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_filedump`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_categories`
--

DROP TABLE IF EXISTS `cms_f_categories`;
CREATE TABLE IF NOT EXISTS `cms_f_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_title` varchar(255) NOT NULL,
  `c_description` longtext NOT NULL,
  `c_expanded_by_default` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=3 ;

--
-- Dumping data for table `cms_f_categories`
--

INSERT INTO `cms_f_categories` (`id`, `c_title`, `c_description`, `c_expanded_by_default`) VALUES(1, 'General', '', 1);
INSERT INTO `cms_f_categories` (`id`, `c_title`, `c_description`, `c_expanded_by_default`) VALUES(2, 'Staff', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_custom_fields`
--

DROP TABLE IF EXISTS `cms_f_custom_fields`;
CREATE TABLE IF NOT EXISTS `cms_f_custom_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_locked` tinyint(1) NOT NULL,
  `cf_name` int(10) unsigned NOT NULL,
  `cf_description` int(10) unsigned NOT NULL,
  `cf_default` longtext NOT NULL,
  `cf_public_view` tinyint(1) NOT NULL,
  `cf_owner_view` tinyint(1) NOT NULL,
  `cf_owner_set` tinyint(1) NOT NULL,
  `cf_type` varchar(80) NOT NULL,
  `cf_required` tinyint(1) NOT NULL,
  `cf_show_in_posts` tinyint(1) NOT NULL,
  `cf_show_in_post_previews` tinyint(1) NOT NULL,
  `cf_order` int(11) NOT NULL,
  `cf_only_group` longtext NOT NULL,
  `cf_encrypted` tinyint(1) NOT NULL,
  `cf_show_on_join_form` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=36 ;

--
-- Dumping data for table `cms_f_custom_fields`
--

INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(1, 0, 14, 15, '', 1, 1, 1, 'long_trans', 0, 0, 0, 0, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(2, 0, 16, 17, '', 1, 1, 1, 'short_text', 0, 0, 0, 1, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(3, 0, 18, 19, '', 1, 1, 1, 'short_text', 0, 0, 0, 2, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(4, 0, 20, 21, '', 1, 1, 1, 'short_text', 0, 0, 0, 3, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(5, 0, 22, 23, '', 1, 1, 1, 'short_text', 0, 0, 0, 4, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(6, 0, 24, 25, '', 1, 1, 1, 'long_trans', 0, 0, 0, 5, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(7, 0, 26, 27, '', 1, 1, 1, 'short_text', 0, 0, 0, 6, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(8, 0, 28, 29, '', 1, 1, 1, 'short_text', 0, 0, 0, 7, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(9, 0, 30, 31, '', 0, 0, 0, 'long_trans', 0, 0, 0, 8, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(10, 1, 83, 84, '', 0, 0, 1, 'short_text', 0, 0, 0, 9, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(11, 1, 277, 278, '0', 0, 0, 0, 'integer', 0, 0, 0, 10, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(12, 1, 288, 289, '0', 0, 0, 0, 'integer', 0, 0, 0, 11, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(13, 1, 314, 315, 'AED|AFA|ALL|AMD|ANG|AOK|AON|ARA|ARP|ARS|AUD|AWG|AZM|BAM|BBD|BDT|BGL|BHD|BIF|BMD|BND|BOB|BOP|BRC|BRL|BRR|BSD|BTN|BWP|BYR|BZD|CAD|CDZ|CHF|CLF|CLP|CNY|COP|CRC|CSD|CUP|CVE|CYP|CZK|DJF|DKK|DOP|DZD|EEK|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHC|GIP|GMD|GNS|GQE|GTQ|GWP|GYD|HKD|HNL|HRD|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LSL|LSM|LTL|LVL|LYD|MAD|MDL|MGF|MKD|MLF|MMK|MNT|MOP|MRO|MTL|MUR|MVR|MWK|MXN|MYR|MZM|NAD|NGN|NIC|NOK|NPR|NZD|OMR|PAB|PEI|PEN|PGK|PHP|PKR|PLN|PYG|QAR|ROL|RUB|RWF|SAR|SBD|SCR|SDD|SDP|SEK|SGD|SHP|SIT|SKK|SLL|SOS|SRG|STD|SUR|SVC|SYP|SZL|THB|TJR|TMM|TND|TOP|TPE|TRL|TTD|TWD|TZS|UAH|UAK|UGS|USD|UYU|UZS|VEB|VND|VUV|WST|XAF|XCD|XOF|XPF|YDD|YER|ZAL|ZAR|ZMK|ZWD', 0, 0, 1, 'list', 0, 0, 0, 12, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(14, 1, 316, 317, '', 0, 0, 1, 'short_text', 0, 0, 0, 13, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(15, 1, 318, 319, 'American Express|Delta|Diners Card|JCB|Master Card|Solo|Switch|Visa', 0, 0, 1, 'list', 0, 0, 0, 14, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(16, 1, 320, 321, '', 0, 0, 1, 'integer', 0, 0, 0, 15, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(17, 1, 322, 323, 'mm/yy', 0, 0, 1, 'short_text', 0, 0, 0, 16, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(18, 1, 324, 325, 'mm/yy', 0, 0, 1, 'short_text', 0, 0, 0, 17, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(19, 1, 326, 327, '', 0, 0, 1, 'short_text', 0, 0, 0, 18, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(20, 1, 328, 329, '', 0, 0, 1, 'short_text', 0, 0, 0, 19, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(21, 1, 342, 343, '', 0, 0, 0, 'short_text', 0, 0, 0, 20, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(22, 1, 344, 345, '', 0, 0, 0, 'short_text', 0, 0, 0, 21, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(23, 1, 346, 347, '', 0, 0, 0, 'long_text', 0, 0, 0, 22, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(24, 1, 348, 349, '', 0, 0, 0, 'short_text', 0, 0, 0, 23, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(25, 1, 350, 351, '', 0, 0, 0, 'short_text', 0, 0, 0, 24, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(26, 1, 352, 353, '', 0, 0, 0, 'short_text', 0, 0, 0, 25, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(27, 1, 354, 355, '|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BM|BN|BO|BR|BS|BT|BU|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GH|GI|GL|GM|GN|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IN|IO|IQ|IR|IS|IT|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LY|MA|MC|MD|MG|MH|MK|ML|MM|MN|MO|MP|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PN|PR|PT|PW|PY|QA|RO|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|ST|SU|SV|SY|SZ|TC|TD|TG|TH|TJ|TK|TM|TN|TO|TP|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YD|YE|ZA|ZM|ZR|ZW', 0, 0, 0, 'list', 0, 0, 0, 26, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(28, 1, 378, 379, '0', 0, 0, 0, 'integer', 0, 0, 0, 27, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(29, 1, 380, 381, '0', 0, 0, 0, 'integer', 0, 0, 0, 28, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(30, 1, 382, 383, '0', 0, 0, 0, 'integer', 0, 0, 0, 29, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(31, 1, 384, 385, '0', 0, 0, 0, 'integer', 0, 0, 0, 30, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(32, 1, 386, 387, '0', 0, 0, 0, 'integer', 0, 0, 0, 31, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(33, 1, 388, 389, '', 0, 0, 0, 'short_text', 0, 0, 0, 32, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(34, 1, 390, 391, '', 0, 0, 1, 'short_text', 0, 0, 0, 33, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(35, 1, 392, 393, '', 0, 0, 1, 'short_text', 0, 0, 0, 34, '', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_emoticons`
--

DROP TABLE IF EXISTS `cms_f_emoticons`;
CREATE TABLE IF NOT EXISTS `cms_f_emoticons` (
  `e_code` varchar(80) NOT NULL,
  `e_theme_img_code` varchar(255) NOT NULL,
  `e_relevance_level` int(11) NOT NULL,
  `e_use_topics` tinyint(1) NOT NULL,
  `e_is_special` tinyint(1) NOT NULL,
  PRIMARY KEY (`e_code`),
  KEY `relevantemoticons` (`e_relevance_level`),
  KEY `topicemos` (`e_use_topics`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_emoticons`
--

INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':P', 'ocf_emoticons/cheeky', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':''(', 'ocf_emoticons/cry', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':dry:', 'ocf_emoticons/dry', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':$', 'ocf_emoticons/blush', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(';)', 'ocf_emoticons/wink', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES('O_o', 'ocf_emoticons/blink', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':wub:', 'ocf_emoticons/wub', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':cool:', 'ocf_emoticons/cool', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':lol:', 'ocf_emoticons/lol', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':(', 'ocf_emoticons/sad', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':)', 'ocf_emoticons/smile', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':thumbs:', 'ocf_emoticons/thumbs', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':offtopic:', 'ocf_emoticons/offtopic', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':|', 'ocf_emoticons/mellow', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':ninja:', 'ocf_emoticons/ph34r', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':o', 'ocf_emoticons/shocked', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':rolleyes:', 'ocf_emoticons/rolleyes', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':D', 'ocf_emoticons/grin', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES('^_^', 'ocf_emoticons/glee', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES('(K)', 'ocf_emoticons/kiss', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':S', 'ocf_emoticons/confused', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':@', 'ocf_emoticons/angry', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':shake:', 'ocf_emoticons/shake', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':hand:', 'ocf_emoticons/hand', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':drool:', 'ocf_emoticons/drool', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':devil:', 'ocf_emoticons/devil', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':party:', 'ocf_emoticons/party', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':constipated:', 'ocf_emoticons/constipated', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':depressed:', 'ocf_emoticons/depressed', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':zzz:', 'ocf_emoticons/zzz', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':whistle:', 'ocf_emoticons/whistle', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':upsidedown:', 'ocf_emoticons/upsidedown', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':sick:', 'ocf_emoticons/sick', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':shutup:', 'ocf_emoticons/shutup', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':sarcy:', 'ocf_emoticons/sarcy', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':puppyeyes:', 'ocf_emoticons/puppyeyes', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':nod:', 'ocf_emoticons/nod', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':nerd:', 'ocf_emoticons/nerd', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':king:', 'ocf_emoticons/king', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':birthday:', 'ocf_emoticons/birthday', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':cyborg:', 'ocf_emoticons/cyborg', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':hippie:', 'ocf_emoticons/hippie', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':ninja2:', 'ocf_emoticons/ninja2', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':rockon:', 'ocf_emoticons/rockon', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':sinner:', 'ocf_emoticons/sinner', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':guitar:', 'ocf_emoticons/guitar', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':christmas:', 'ocf_emoticons/christmas', 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_forums`
--

DROP TABLE IF EXISTS `cms_f_forums`;
CREATE TABLE IF NOT EXISTS `cms_f_forums` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `f_name` varchar(255) NOT NULL,
  `f_description` int(10) unsigned NOT NULL,
  `f_category_id` int(11) DEFAULT NULL,
  `f_parent_forum` int(11) DEFAULT NULL,
  `f_position` int(11) NOT NULL,
  `f_order_sub_alpha` tinyint(1) NOT NULL,
  `f_post_count_increment` tinyint(1) NOT NULL,
  `f_intro_question` int(10) unsigned NOT NULL,
  `f_intro_answer` varchar(255) NOT NULL,
  `f_cache_num_topics` int(11) NOT NULL,
  `f_cache_num_posts` int(11) NOT NULL,
  `f_cache_last_topic_id` int(11) DEFAULT NULL,
  `f_cache_last_title` varchar(255) NOT NULL,
  `f_cache_last_time` int(10) unsigned DEFAULT NULL,
  `f_cache_last_username` varchar(255) NOT NULL,
  `f_cache_last_member_id` int(11) DEFAULT NULL,
  `f_cache_last_forum_id` int(11) DEFAULT NULL,
  `f_redirection` varchar(255) NOT NULL,
  `f_order` varchar(80) NOT NULL,
  `f_is_threaded` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cache_num_posts` (`f_cache_num_posts`),
  KEY `subforum_parenting` (`f_parent_forum`),
  KEY `findnamedforum` (`f_name`),
  KEY `f_position` (`f_position`)
) ENGINE=MyISAM  AUTO_INCREMENT=9 ;

--
-- Dumping data for table `cms_f_forums`
--

INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(1, 'Forum home', 52, NULL, NULL, 1, 0, 1, 53, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(2, 'General chat', 54, 1, 1, 1, 0, 1, 55, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(3, 'Reported posts forum', 56, 2, 1, 1, 0, 1, 57, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(4, 'Trash', 58, 2, 1, 1, 0, 1, 59, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(5, 'Website comment topics', 60, 1, 1, 1, 0, 1, 61, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 1);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(6, 'Website support tickets', 62, 2, 1, 1, 0, 1, 63, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(7, 'Staff', 64, 2, 1, 1, 0, 1, 65, '', 1, 1, 1, 'Welcome to the forums', 1344775582, 'System', 1, 7, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(8, 'Website "Contact Us" messages', 129, 2, 1, 1, 0, 1, 130, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_forum_intro_ip`
--

DROP TABLE IF EXISTS `cms_f_forum_intro_ip`;
CREATE TABLE IF NOT EXISTS `cms_f_forum_intro_ip` (
  `i_forum_id` int(11) NOT NULL,
  `i_ip` varchar(40) NOT NULL,
  PRIMARY KEY (`i_forum_id`,`i_ip`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_forum_intro_ip`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_forum_intro_member`
--

DROP TABLE IF EXISTS `cms_f_forum_intro_member`;
CREATE TABLE IF NOT EXISTS `cms_f_forum_intro_member` (
  `i_forum_id` int(11) NOT NULL,
  `i_member_id` int(11) NOT NULL,
  PRIMARY KEY (`i_forum_id`,`i_member_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_forum_intro_member`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_groups`
--

DROP TABLE IF EXISTS `cms_f_groups`;
CREATE TABLE IF NOT EXISTS `cms_f_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `g_name` int(10) unsigned NOT NULL,
  `g_is_default` tinyint(1) NOT NULL,
  `g_is_presented_at_install` tinyint(1) NOT NULL,
  `g_is_super_admin` tinyint(1) NOT NULL,
  `g_is_super_moderator` tinyint(1) NOT NULL,
  `g_group_leader` int(11) DEFAULT NULL,
  `g_title` int(10) unsigned NOT NULL,
  `g_promotion_target` int(11) DEFAULT NULL,
  `g_promotion_threshold` int(11) DEFAULT NULL,
  `g_flood_control_submit_secs` int(11) NOT NULL,
  `g_flood_control_access_secs` int(11) NOT NULL,
  `g_gift_points_base` int(11) NOT NULL,
  `g_gift_points_per_day` int(11) NOT NULL,
  `g_max_daily_upload_mb` int(11) NOT NULL,
  `g_max_attachments_per_post` int(11) NOT NULL,
  `g_max_avatar_width` int(11) NOT NULL,
  `g_max_avatar_height` int(11) NOT NULL,
  `g_max_post_length_comcode` int(11) NOT NULL,
  `g_max_sig_length_comcode` int(11) NOT NULL,
  `g_enquire_on_new_ips` tinyint(1) NOT NULL,
  `g_rank_image` varchar(80) NOT NULL,
  `g_hidden` tinyint(1) NOT NULL,
  `g_order` int(11) NOT NULL,
  `g_rank_image_pri_only` tinyint(1) NOT NULL,
  `g_open_membership` tinyint(1) NOT NULL,
  `g_is_private_club` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ftjoin_gname` (`g_name`),
  KEY `ftjoin_gtitle` (`g_title`),
  KEY `is_private_club` (`g_is_private_club`),
  KEY `is_super_admin` (`g_is_super_admin`),
  KEY `is_super_moderator` (`g_is_super_moderator`),
  KEY `is_default` (`g_is_default`),
  KEY `hidden` (`g_hidden`),
  KEY `is_presented_at_install` (`g_is_presented_at_install`),
  KEY `gorder` (`g_order`,`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=11 ;

--
-- Dumping data for table `cms_f_groups`
--

INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(1, 32, 0, 0, 0, 0, NULL, 33, NULL, NULL, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 0, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(2, 34, 0, 0, 1, 0, NULL, 35, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/admin', 0, 1, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(3, 36, 0, 0, 0, 1, NULL, 37, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/mod', 0, 2, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(4, 38, 0, 0, 0, 0, NULL, 39, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 3, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(5, 40, 0, 0, 0, 0, NULL, 41, NULL, NULL, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/4', 0, 4, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(6, 42, 0, 0, 0, 0, NULL, 43, 5, 10000, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/3', 0, 5, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(7, 44, 0, 0, 0, 0, NULL, 45, 6, 2500, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/2', 0, 6, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(8, 46, 0, 0, 0, 0, NULL, 47, 7, 400, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/1', 0, 7, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(9, 48, 0, 0, 0, 0, NULL, 49, 8, 100, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/0', 0, 8, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(10, 50, 0, 0, 0, 0, NULL, 51, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 9, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_group_members`
--

DROP TABLE IF EXISTS `cms_f_group_members`;
CREATE TABLE IF NOT EXISTS `cms_f_group_members` (
  `gm_group_id` int(11) NOT NULL,
  `gm_member_id` int(11) NOT NULL,
  `gm_validated` tinyint(1) NOT NULL,
  PRIMARY KEY (`gm_group_id`,`gm_member_id`),
  KEY `gm_validated` (`gm_validated`),
  KEY `gm_member_id` (`gm_member_id`),
  KEY `gm_group_id` (`gm_group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_group_members`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_group_member_timeouts`
--

DROP TABLE IF EXISTS `cms_f_group_member_timeouts`;
CREATE TABLE IF NOT EXISTS `cms_f_group_member_timeouts` (
  `member_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `timeout` int(10) unsigned NOT NULL,
  PRIMARY KEY (`member_id`,`group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_group_member_timeouts`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_invites`
--

DROP TABLE IF EXISTS `cms_f_invites`;
CREATE TABLE IF NOT EXISTS `cms_f_invites` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `i_inviter` int(11) NOT NULL,
  `i_email_address` varchar(255) NOT NULL,
  `i_time` int(10) unsigned NOT NULL,
  `i_taken` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_invites`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_members`
--

DROP TABLE IF EXISTS `cms_f_members`;
CREATE TABLE IF NOT EXISTS `cms_f_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `m_username` varchar(80) NOT NULL,
  `m_pass_hash_salted` varchar(255) NOT NULL,
  `m_pass_salt` varchar(255) NOT NULL,
  `m_theme` varchar(80) NOT NULL,
  `m_avatar_url` varchar(255) NOT NULL,
  `m_validated` tinyint(1) NOT NULL,
  `m_validated_email_confirm_code` varchar(255) NOT NULL,
  `m_cache_num_posts` int(11) NOT NULL,
  `m_cache_warnings` int(11) NOT NULL,
  `m_join_time` int(10) unsigned NOT NULL,
  `m_timezone_offset` varchar(255) NOT NULL,
  `m_primary_group` int(11) NOT NULL,
  `m_last_visit_time` int(10) unsigned NOT NULL,
  `m_last_submit_time` int(10) unsigned NOT NULL,
  `m_signature` int(10) unsigned NOT NULL,
  `m_is_perm_banned` tinyint(1) NOT NULL,
  `m_preview_posts` tinyint(1) NOT NULL,
  `m_dob_day` int(11) DEFAULT NULL,
  `m_dob_month` int(11) DEFAULT NULL,
  `m_dob_year` int(11) DEFAULT NULL,
  `m_reveal_age` tinyint(1) NOT NULL,
  `m_email_address` varchar(255) NOT NULL,
  `m_title` varchar(255) NOT NULL,
  `m_photo_url` varchar(255) NOT NULL,
  `m_photo_thumb_url` varchar(255) NOT NULL,
  `m_views_signatures` tinyint(1) NOT NULL,
  `m_auto_monitor_contrib_content` tinyint(1) NOT NULL,
  `m_language` varchar(80) NOT NULL,
  `m_ip_address` varchar(40) NOT NULL,
  `m_allow_emails` tinyint(1) NOT NULL,
  `m_allow_emails_from_staff` tinyint(1) NOT NULL,
  `m_notes` longtext NOT NULL,
  `m_zone_wide` tinyint(1) NOT NULL,
  `m_highlighted_name` tinyint(1) NOT NULL,
  `m_pt_allow` varchar(255) NOT NULL,
  `m_pt_rules_text` int(10) unsigned NOT NULL,
  `m_max_email_attach_size_mb` int(11) NOT NULL,
  `m_password_change_code` varchar(255) NOT NULL,
  `m_password_compat_scheme` varchar(80) NOT NULL,
  `m_on_probation_until` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_list` (`m_username`),
  KEY `menail` (`m_email_address`),
  KEY `external_auth_lookup` (`m_pass_hash_salted`),
  KEY `sort_post_count` (`m_cache_num_posts`),
  KEY `m_join_time` (`m_join_time`),
  KEY `whos_validated` (`m_validated`),
  KEY `birthdays` (`m_dob_day`,`m_dob_month`),
  KEY `ftjoin_msig` (`m_signature`),
  KEY `primary_group` (`m_primary_group`),
  KEY `avatar_url` (`m_avatar_url`),
  FULLTEXT KEY `search_user` (`m_username`)
) ENGINE=MyISAM  AUTO_INCREMENT=4 ;

--
-- Dumping data for table `cms_f_members`
--

INSERT INTO `cms_f_members` (`id`, `m_username`, `m_pass_hash_salted`, `m_pass_salt`, `m_theme`, `m_avatar_url`, `m_validated`, `m_validated_email_confirm_code`, `m_cache_num_posts`, `m_cache_warnings`, `m_join_time`, `m_timezone_offset`, `m_primary_group`, `m_last_visit_time`, `m_last_submit_time`, `m_signature`, `m_is_perm_banned`, `m_preview_posts`, `m_dob_day`, `m_dob_month`, `m_dob_year`, `m_reveal_age`, `m_email_address`, `m_title`, `m_photo_url`, `m_photo_thumb_url`, `m_views_signatures`, `m_auto_monitor_contrib_content`, `m_language`, `m_ip_address`, `m_allow_emails`, `m_allow_emails_from_staff`, `m_notes`, `m_zone_wide`, `m_highlighted_name`, `m_pt_allow`, `m_pt_rules_text`, `m_max_email_attach_size_mb`, `m_password_change_code`, `m_password_compat_scheme`, `m_on_probation_until`) VALUES(1, 'Guest', 'cb9f57a36ef4f7f5d7371fec898fb52b', '5027a59ee0ad94.82899191', '', '', 1, '', 0, 0, 1344775582, 'UTC', 1, 1344775582, 1344775582, 67, 0, 1, NULL, NULL, NULL, 1, '', '', '', '', 1, 0, '', '192.168.1.68', 1, 1, '', 1, 0, '*', 68, 5, '', '', NULL);
INSERT INTO `cms_f_members` (`id`, `m_username`, `m_pass_hash_salted`, `m_pass_salt`, `m_theme`, `m_avatar_url`, `m_validated`, `m_validated_email_confirm_code`, `m_cache_num_posts`, `m_cache_warnings`, `m_join_time`, `m_timezone_offset`, `m_primary_group`, `m_last_visit_time`, `m_last_submit_time`, `m_signature`, `m_is_perm_banned`, `m_preview_posts`, `m_dob_day`, `m_dob_month`, `m_dob_year`, `m_reveal_age`, `m_email_address`, `m_title`, `m_photo_url`, `m_photo_thumb_url`, `m_views_signatures`, `m_auto_monitor_contrib_content`, `m_language`, `m_ip_address`, `m_allow_emails`, `m_allow_emails_from_staff`, `m_notes`, `m_zone_wide`, `m_highlighted_name`, `m_pt_allow`, `m_pt_rules_text`, `m_max_email_attach_size_mb`, `m_password_change_code`, `m_password_compat_scheme`, `m_on_probation_until`) VALUES(2, 'admin', '7a3d8e11d09610667f3da74690d8cc6d', '5027a59ee30379.58521014', '', 'themes/default/images/ocf_default_avatars/default_set/cool_flare.png', 1, '', 0, 0, 1344775582, 'UTC', 2, 1344775582, 1344775582, 72, 0, 0, NULL, NULL, NULL, 1, '', '', '', '', 1, 1, '', '192.168.1.68', 1, 1, '', 1, 0, '*', 73, 5, '', '', NULL);
INSERT INTO `cms_f_members` (`id`, `m_username`, `m_pass_hash_salted`, `m_pass_salt`, `m_theme`, `m_avatar_url`, `m_validated`, `m_validated_email_confirm_code`, `m_cache_num_posts`, `m_cache_warnings`, `m_join_time`, `m_timezone_offset`, `m_primary_group`, `m_last_visit_time`, `m_last_submit_time`, `m_signature`, `m_is_perm_banned`, `m_preview_posts`, `m_dob_day`, `m_dob_month`, `m_dob_year`, `m_reveal_age`, `m_email_address`, `m_title`, `m_photo_url`, `m_photo_thumb_url`, `m_views_signatures`, `m_auto_monitor_contrib_content`, `m_language`, `m_ip_address`, `m_allow_emails`, `m_allow_emails_from_staff`, `m_notes`, `m_zone_wide`, `m_highlighted_name`, `m_pt_allow`, `m_pt_rules_text`, `m_max_email_attach_size_mb`, `m_password_change_code`, `m_password_compat_scheme`, `m_on_probation_until`) VALUES(3, 'test', '13e3d264c79211046c23625a89d78022', '5027a59ee40750.19930630', '', '', 1, '', 0, 0, 1344775582, 'UTC', 9, 1344775582, 1344775582, 77, 0, 0, NULL, NULL, NULL, 1, '', '', '', '', 1, 0, '', '192.168.1.68', 1, 1, '', 1, 0, '*', 78, 5, '', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_member_cpf_perms`
--

DROP TABLE IF EXISTS `cms_f_member_cpf_perms`;
CREATE TABLE IF NOT EXISTS `cms_f_member_cpf_perms` (
  `member_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `guest_view` tinyint(1) NOT NULL,
  `member_view` tinyint(1) NOT NULL,
  `friend_view` tinyint(1) NOT NULL,
  `group_view` varchar(255) NOT NULL,
  PRIMARY KEY (`member_id`,`field_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_member_cpf_perms`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_member_custom_fields`
--

DROP TABLE IF EXISTS `cms_f_member_custom_fields`;
CREATE TABLE IF NOT EXISTS `cms_f_member_custom_fields` (
  `mf_member_id` int(11) NOT NULL,
  `field_1` int(10) unsigned NOT NULL DEFAULT '0',
  `field_2` varchar(255) NOT NULL DEFAULT '',
  `field_3` varchar(255) NOT NULL DEFAULT '',
  `field_4` varchar(255) NOT NULL DEFAULT '',
  `field_5` varchar(255) NOT NULL DEFAULT '',
  `field_6` int(10) unsigned NOT NULL DEFAULT '0',
  `field_7` varchar(255) NOT NULL DEFAULT '',
  `field_8` varchar(255) NOT NULL DEFAULT '',
  `field_9` int(10) unsigned NOT NULL DEFAULT '0',
  `field_10` varchar(255) NOT NULL DEFAULT '',
  `field_11` varchar(255) NOT NULL DEFAULT '',
  `field_12` varchar(255) NOT NULL DEFAULT '',
  `field_13` longtext NOT NULL,
  `field_14` varchar(255) NOT NULL DEFAULT '',
  `field_15` longtext NOT NULL,
  `field_16` varchar(255) NOT NULL DEFAULT '',
  `field_17` varchar(255) NOT NULL DEFAULT '',
  `field_18` varchar(255) NOT NULL DEFAULT '',
  `field_19` varchar(255) NOT NULL DEFAULT '',
  `field_20` varchar(255) NOT NULL DEFAULT '',
  `field_21` varchar(255) NOT NULL DEFAULT '',
  `field_22` varchar(255) NOT NULL DEFAULT '',
  `field_23` longtext NOT NULL,
  `field_24` varchar(255) NOT NULL DEFAULT '',
  `field_25` varchar(255) NOT NULL DEFAULT '',
  `field_26` varchar(255) NOT NULL DEFAULT '',
  `field_27` longtext NOT NULL,
  `field_28` varchar(255) NOT NULL DEFAULT '',
  `field_29` varchar(255) NOT NULL DEFAULT '',
  `field_30` varchar(255) NOT NULL DEFAULT '',
  `field_31` varchar(255) NOT NULL DEFAULT '',
  `field_32` varchar(255) NOT NULL DEFAULT '',
  `field_33` varchar(255) NOT NULL DEFAULT '',
  `field_34` varchar(255) NOT NULL DEFAULT '',
  `field_35` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`mf_member_id`),
  FULLTEXT KEY `mcf2` (`field_2`),
  FULLTEXT KEY `mcf3` (`field_3`),
  FULLTEXT KEY `mcf4` (`field_4`),
  FULLTEXT KEY `mcf5` (`field_5`),
  FULLTEXT KEY `mcf7` (`field_7`),
  FULLTEXT KEY `mcf8` (`field_8`),
  FULLTEXT KEY `mcf10` (`field_10`),
  FULLTEXT KEY `mcf13` (`field_13`),
  FULLTEXT KEY `mcf14` (`field_14`),
  FULLTEXT KEY `mcf15` (`field_15`),
  FULLTEXT KEY `mcf17` (`field_17`),
  FULLTEXT KEY `mcf18` (`field_18`),
  FULLTEXT KEY `mcf19` (`field_19`),
  FULLTEXT KEY `mcf20` (`field_20`),
  FULLTEXT KEY `mcf21` (`field_21`),
  FULLTEXT KEY `mcf22` (`field_22`),
  FULLTEXT KEY `mcf23` (`field_23`),
  FULLTEXT KEY `mcf24` (`field_24`),
  FULLTEXT KEY `mcf25` (`field_25`),
  FULLTEXT KEY `mcf26` (`field_26`),
  FULLTEXT KEY `mcf27` (`field_27`),
  FULLTEXT KEY `mcf33` (`field_33`),
  FULLTEXT KEY `mcf34` (`field_34`),
  FULLTEXT KEY `mcf35` (`field_35`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_member_custom_fields`
--

INSERT INTO `cms_f_member_custom_fields` (`mf_member_id`, `field_1`, `field_2`, `field_3`, `field_4`, `field_5`, `field_6`, `field_7`, `field_8`, `field_9`, `field_10`, `field_11`, `field_12`, `field_13`, `field_14`, `field_15`, `field_16`, `field_17`, `field_18`, `field_19`, `field_20`, `field_21`, `field_22`, `field_23`, `field_24`, `field_25`, `field_26`, `field_27`, `field_28`, `field_29`, `field_30`, `field_31`, `field_32`, `field_33`, `field_34`, `field_35`) VALUES(1, 69, '', '', '', '', 70, '', '', 71, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `cms_f_member_custom_fields` (`mf_member_id`, `field_1`, `field_2`, `field_3`, `field_4`, `field_5`, `field_6`, `field_7`, `field_8`, `field_9`, `field_10`, `field_11`, `field_12`, `field_13`, `field_14`, `field_15`, `field_16`, `field_17`, `field_18`, `field_19`, `field_20`, `field_21`, `field_22`, `field_23`, `field_24`, `field_25`, `field_26`, `field_27`, `field_28`, `field_29`, `field_30`, `field_31`, `field_32`, `field_33`, `field_34`, `field_35`) VALUES(2, 74, '', '', '', '', 75, '', '', 76, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `cms_f_member_custom_fields` (`mf_member_id`, `field_1`, `field_2`, `field_3`, `field_4`, `field_5`, `field_6`, `field_7`, `field_8`, `field_9`, `field_10`, `field_11`, `field_12`, `field_13`, `field_14`, `field_15`, `field_16`, `field_17`, `field_18`, `field_19`, `field_20`, `field_21`, `field_22`, `field_23`, `field_24`, `field_25`, `field_26`, `field_27`, `field_28`, `field_29`, `field_30`, `field_31`, `field_32`, `field_33`, `field_34`, `field_35`) VALUES(3, 79, '', '', '', '', 80, '', '', 81, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_member_known_login_ips`
--

DROP TABLE IF EXISTS `cms_f_member_known_login_ips`;
CREATE TABLE IF NOT EXISTS `cms_f_member_known_login_ips` (
  `i_member_id` int(11) NOT NULL,
  `i_ip` varchar(40) NOT NULL,
  `i_val_code` varchar(255) NOT NULL,
  PRIMARY KEY (`i_member_id`,`i_ip`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_member_known_login_ips`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_moderator_logs`
--

DROP TABLE IF EXISTS `cms_f_moderator_logs`;
CREATE TABLE IF NOT EXISTS `cms_f_moderator_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `l_the_type` varchar(80) NOT NULL,
  `l_param_a` varchar(255) NOT NULL,
  `l_param_b` varchar(255) NOT NULL,
  `l_date_and_time` int(10) unsigned NOT NULL,
  `l_reason` longtext NOT NULL,
  `l_by` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_moderator_logs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_multi_moderations`
--

DROP TABLE IF EXISTS `cms_f_multi_moderations`;
CREATE TABLE IF NOT EXISTS `cms_f_multi_moderations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mm_name` int(10) unsigned NOT NULL,
  `mm_post_text` longtext NOT NULL,
  `mm_move_to` int(11) DEFAULT NULL,
  `mm_pin_state` tinyint(1) DEFAULT NULL,
  `mm_sink_state` tinyint(1) DEFAULT NULL,
  `mm_open_state` tinyint(1) DEFAULT NULL,
  `mm_forum_multi_code` varchar(255) NOT NULL,
  `mm_title_suffix` varchar(255) NOT NULL,
  PRIMARY KEY (`id`,`mm_name`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_f_multi_moderations`
--

INSERT INTO `cms_f_multi_moderations` (`id`, `mm_name`, `mm_post_text`, `mm_move_to`, `mm_pin_state`, `mm_sink_state`, `mm_open_state`, `mm_forum_multi_code`, `mm_title_suffix`) VALUES(1, 66, '', 4, 0, 0, 0, '*', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_polls`
--

