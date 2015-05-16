		CREATE TABLE cms4_searches_saved
		(
			id integer auto_increment NULL,
			s_auxillary longtext NOT NULL,
			s_member_id integer NOT NULL,
			s_primary varchar(255) NOT NULL,
			s_time integer unsigned NOT NULL,
			s_title varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms4_searches_logged
		(
			id integer auto_increment NULL,
			s_auxillary longtext NOT NULL,
			s_member_id integer NOT NULL,
			s_num_results integer NOT NULL,
			s_primary varchar(255) NOT NULL,
			s_time integer unsigned NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms4_f_members
		(
			id integer auto_increment NULL,
			m_allow_emails tinyint(1) NOT NULL,
			m_avatar_url varchar(255) NOT NULL,
			m_cache_num_posts integer NOT NULL,
			m_cache_warnings integer NOT NULL,
			m_dob_day integer NOT NULL,
			m_dob_month integer NOT NULL,
			m_dob_year integer NOT NULL,
			m_email_address varchar(255) NOT NULL,
			m_highlighted_name tinyint(1) NOT NULL,
			m_ip_address varchar(40) NOT NULL,
			m_is_perm_banned tinyint(1) NOT NULL,
			m_join_time integer unsigned NOT NULL,
			m_language varchar(80) NOT NULL,
			m_last_submit_time integer unsigned NOT NULL,
			m_last_visit_time integer unsigned NOT NULL,
			m_max_email_attach_size_mb integer NOT NULL,
			m_notes longtext NOT NULL,
			m_on_probation_until integer unsigned NOT NULL,
			m_pass_hash_salted varchar(255) NOT NULL,
			m_pass_salt varchar(255) NOT NULL,
			m_password_change_code varchar(255) NOT NULL,
			m_password_compat_scheme varchar(80) NOT NULL,
			m_photo_thumb_url varchar(255) NOT NULL,
			m_photo_url varchar(255) NOT NULL,
			m_preview_posts tinyint(1) NOT NULL,
			m_primary_group integer NOT NULL,
			m_pt_allow varchar(255) NOT NULL,
			m_pt_rules_text integer NOT NULL,
			m_reveal_age tinyint(1) NOT NULL,
			m_signature integer NOT NULL,
			m_theme varchar(80) NOT NULL,
			m_timezone_offset integer NOT NULL,
			m_title varchar(255) NOT NULL,
			m_track_contributed_topics tinyint(1) NOT NULL,
			m_username varchar(80) NOT NULL,
			m_validated tinyint(1) NOT NULL,
			m_validated_email_confirm_code varchar(255) NOT NULL,
			m_views_signatures tinyint(1) NOT NULL,
			m_zone_wide tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms4_f_groups
		(
			g_enquire_on_new_ips tinyint(1) NOT NULL,
			g_flood_control_access_secs integer NOT NULL,
			g_flood_control_submit_secs integer NOT NULL,
			g_gift_points_base integer NOT NULL,
			g_gift_points_per_day integer NOT NULL,
			g_group_leader integer NOT NULL,
			g_hidden tinyint(1) NOT NULL,
			g_is_default tinyint(1) NOT NULL,
			g_is_presented_at_install tinyint(1) NOT NULL,
			g_is_private_club tinyint(1) NOT NULL,
			g_is_super_admin tinyint(1) NOT NULL,
			g_is_super_moderator tinyint(1) NOT NULL,
			g_max_attachments_per_post integer NOT NULL,
			g_max_avatar_height integer NOT NULL,
			g_max_avatar_width integer NOT NULL,
			g_max_daily_upload_mb integer NOT NULL,
			g_max_post_length_comcode integer NOT NULL,
			g_max_sig_length_comcode integer NOT NULL,
			g_name integer NOT NULL,
			g_open_membership tinyint(1) NOT NULL,
			g_order integer NOT NULL,
			g_promotion_target integer NOT NULL,
			g_promotion_threshold integer NOT NULL,
			g_rank_image varchar(80) NOT NULL,
			g_rank_image_pri_only tinyint(1) NOT NULL,
			g_title integer NOT NULL,
			id integer auto_increment NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms4_translate
		(
			broken tinyint(1) NOT NULL,
			id integer auto_increment NULL,
			importance_level tinyint NOT NULL,
			language varchar(5) NULL,
			source_user integer NOT NULL,
			text_original longtext NOT NULL,
			text_parsed longtext NOT NULL,
			PRIMARY KEY (id,language)
		) TYPE=InnoDB;


		CREATE INDEX `searches_saved.s_member_id` ON cms4_searches_saved(s_member_id);
		ALTER TABLE cms4_searches_saved ADD FOREIGN KEY `searches_saved.s_member_id` (s_member_id) REFERENCES cms4_f_members (id);

		CREATE INDEX `searches_logged.s_member_id` ON cms4_searches_logged(s_member_id);
		ALTER TABLE cms4_searches_logged ADD FOREIGN KEY `searches_logged.s_member_id` (s_member_id) REFERENCES cms4_f_members (id);

		CREATE INDEX `f_members.m_primary_group` ON cms4_f_members(m_primary_group);
		ALTER TABLE cms4_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms4_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms4_f_members(m_pt_rules_text);
		ALTER TABLE cms4_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms4_translate (id);

		CREATE INDEX `f_members.m_signature` ON cms4_f_members(m_signature);
		ALTER TABLE cms4_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms4_translate (id);

		CREATE INDEX `f_groups.g_group_leader` ON cms4_f_groups(g_group_leader);
		ALTER TABLE cms4_f_groups ADD FOREIGN KEY `f_groups.g_group_leader` (g_group_leader) REFERENCES cms4_f_members (id);

		CREATE INDEX `f_groups.g_name` ON cms4_f_groups(g_name);
		ALTER TABLE cms4_f_groups ADD FOREIGN KEY `f_groups.g_name` (g_name) REFERENCES cms4_translate (id);

		CREATE INDEX `f_groups.g_promotion_target` ON cms4_f_groups(g_promotion_target);
		ALTER TABLE cms4_f_groups ADD FOREIGN KEY `f_groups.g_promotion_target` (g_promotion_target) REFERENCES cms4_f_groups (id);

		CREATE INDEX `f_groups.g_title` ON cms4_f_groups(g_title);
		ALTER TABLE cms4_f_groups ADD FOREIGN KEY `f_groups.g_title` (g_title) REFERENCES cms4_translate (id);

		CREATE INDEX `translate.source_user` ON cms4_translate(source_user);
		ALTER TABLE cms4_translate ADD FOREIGN KEY `translate.source_user` (source_user) REFERENCES cms4_f_members (id);
