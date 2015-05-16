		CREATE TABLE cms10_galleries
		(
			rep_image varchar(255) NOT NULL,
			parent_id varchar(80) NOT NULL,
			watermark_top_left varchar(255) NOT NULL,
			watermark_top_right varchar(255) NOT NULL,
			watermark_bottom_left varchar(255) NOT NULL,
			watermark_bottom_right varchar(255) NOT NULL,
			accept_images tinyint(1) NOT NULL,
			accept_videos tinyint(1) NOT NULL,
			allow_rating tinyint(1) NOT NULL,
			allow_comments tinyint NOT NULL,
			notes longtext NOT NULL,
			is_member_synched tinyint(1) NOT NULL,
			flow_mode_interface tinyint(1) NOT NULL,
			gallery_views integer NOT NULL,
			g_owner integer NOT NULL,
			name varchar(80) NULL,
			description integer NOT NULL,
			fullname integer NOT NULL,
			add_date integer unsigned NOT NULL,
			PRIMARY KEY (name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_images
		(
			id integer auto_increment NULL,
			cat varchar(80) NOT NULL,
			url varchar(255) NOT NULL,
			thumb_url varchar(255) NOT NULL,
			description integer NOT NULL,
			allow_rating tinyint(1) NOT NULL,
			allow_comments tinyint NOT NULL,
			allow_trackbacks tinyint(1) NOT NULL,
			notes longtext NOT NULL,
			submitter integer NOT NULL,
			validated tinyint(1) NOT NULL,
			add_date integer unsigned NOT NULL,
			edit_date integer unsigned NOT NULL,
			image_views integer NOT NULL,
			title integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_videos
		(
			id integer auto_increment NULL,
			cat varchar(80) NOT NULL,
			url varchar(255) NOT NULL,
			thumb_url varchar(255) NOT NULL,
			description integer NOT NULL,
			allow_rating tinyint(1) NOT NULL,
			allow_comments tinyint NOT NULL,
			allow_trackbacks tinyint(1) NOT NULL,
			notes longtext NOT NULL,
			submitter integer NOT NULL,
			validated tinyint(1) NOT NULL,
			add_date integer unsigned NOT NULL,
			edit_date integer unsigned NOT NULL,
			video_views integer NOT NULL,
			video_width integer NOT NULL,
			video_height integer NOT NULL,
			title integer NOT NULL,
			video_length integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_video_transcoding
		(
			t_id varchar(80) NULL,
			t_local_id integer NOT NULL,
			t_local_id_field varchar(80) NOT NULL,
			t_error longtext NOT NULL,
			t_url varchar(255) NOT NULL,
			t_table varchar(80) NOT NULL,
			t_url_field varchar(80) NOT NULL,
			t_orig_filename_field varchar(80) NOT NULL,
			t_width_field varchar(80) NOT NULL,
			t_height_field varchar(80) NOT NULL,
			t_output_filename varchar(80) NOT NULL,
			PRIMARY KEY (t_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_f_members
		(
			m_dob_month tinyint NOT NULL,
			m_dob_day tinyint NOT NULL,
			m_is_perm_banned tinyint(1) NOT NULL,
			m_preview_posts tinyint(1) NOT NULL,
			m_signature integer NOT NULL,
			m_last_visit_time integer unsigned NOT NULL,
			m_last_submit_time integer unsigned NOT NULL,
			m_primary_group integer NOT NULL,
			id integer auto_increment NULL,
			m_username varchar(80) NOT NULL,
			m_pass_hash_salted varchar(255) NOT NULL,
			m_pass_salt varchar(255) NOT NULL,
			m_theme varchar(80) NOT NULL,
			m_avatar_url varchar(255) NOT NULL,
			m_validated tinyint(1) NOT NULL,
			m_validated_email_confirm_code varchar(255) NOT NULL,
			m_cache_num_posts integer NOT NULL,
			m_cache_warnings integer NOT NULL,
			m_join_time integer unsigned NOT NULL,
			m_timezone_offset varchar(255) NOT NULL,
			m_dob_year integer NOT NULL,
			m_reveal_age tinyint(1) NOT NULL,
			m_email_address varchar(255) NOT NULL,
			m_title varchar(255) NOT NULL,
			m_photo_url varchar(255) NOT NULL,
			m_photo_thumb_url varchar(255) NOT NULL,
			m_views_signatures tinyint(1) NOT NULL,
			m_auto_monitor_contrib_content tinyint(1) NOT NULL,
			m_language varchar(80) NOT NULL,
			m_ip_address varchar(40) NOT NULL,
			m_allow_emails tinyint(1) NOT NULL,
			m_allow_emails_from_staff tinyint(1) NOT NULL,
			m_highlighted_name tinyint(1) NOT NULL,
			m_pt_allow varchar(255) NOT NULL,
			m_pt_rules_text integer NOT NULL,
			m_max_email_attach_size_mb integer NOT NULL,
			m_password_change_code varchar(255) NOT NULL,
			m_password_compat_scheme varchar(80) NOT NULL,
			m_on_probation_until integer unsigned NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_translate
		(
			id integer auto_increment NULL,
			language varchar(5) NULL,
			importance_level tinyint NOT NULL,
			text_original longtext NOT NULL,
			text_parsed longtext NOT NULL,
			broken tinyint(1) NOT NULL,
			source_user integer NOT NULL,
			PRIMARY KEY (id,language)
		) TYPE=InnoDB;

		CREATE TABLE cms10_f_groups
		(
			g_is_private_club tinyint(1) NOT NULL,
			g_open_membership tinyint(1) NOT NULL,
			g_rank_image_pri_only tinyint(1) NOT NULL,
			g_order integer NOT NULL,
			g_hidden tinyint(1) NOT NULL,
			g_rank_image varchar(80) NOT NULL,
			g_enquire_on_new_ips tinyint(1) NOT NULL,
			g_max_sig_length_comcode integer NOT NULL,
			g_max_post_length_comcode integer NOT NULL,
			g_max_avatar_height integer NOT NULL,
			g_max_avatar_width integer NOT NULL,
			g_max_attachments_per_post integer NOT NULL,
			g_max_daily_upload_mb integer NOT NULL,
			g_gift_points_per_day integer NOT NULL,
			g_flood_control_submit_secs integer NOT NULL,
			g_flood_control_access_secs integer NOT NULL,
			g_gift_points_base integer NOT NULL,
			g_promotion_threshold integer NOT NULL,
			g_promotion_target integer NOT NULL,
			id integer auto_increment NULL,
			g_name integer NOT NULL,
			g_is_default tinyint(1) NOT NULL,
			g_is_presented_at_install tinyint(1) NOT NULL,
			g_is_super_admin tinyint(1) NOT NULL,
			g_is_super_moderator tinyint(1) NOT NULL,
			g_group_leader integer NOT NULL,
			g_title integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;


		CREATE INDEX `galleries.parent_id` ON cms10_galleries(parent_id);
		ALTER TABLE cms10_galleries ADD FOREIGN KEY `galleries.parent_id` (parent_id) REFERENCES cms10_galleries (name);

		CREATE INDEX `galleries.g_owner` ON cms10_galleries(g_owner);
		ALTER TABLE cms10_galleries ADD FOREIGN KEY `galleries.g_owner` (g_owner) REFERENCES cms10_f_members (id);

		CREATE INDEX `galleries.description` ON cms10_galleries(description);
		ALTER TABLE cms10_galleries ADD FOREIGN KEY `galleries.description` (description) REFERENCES cms10_translate (id);

		CREATE INDEX `galleries.fullname` ON cms10_galleries(fullname);
		ALTER TABLE cms10_galleries ADD FOREIGN KEY `galleries.fullname` (fullname) REFERENCES cms10_translate (id);

		CREATE INDEX `images.cat` ON cms10_images(cat);
		ALTER TABLE cms10_images ADD FOREIGN KEY `images.cat` (cat) REFERENCES cms10_galleries (name);

		CREATE INDEX `images.description` ON cms10_images(description);
		ALTER TABLE cms10_images ADD FOREIGN KEY `images.description` (description) REFERENCES cms10_translate (id);

		CREATE INDEX `images.submitter` ON cms10_images(submitter);
		ALTER TABLE cms10_images ADD FOREIGN KEY `images.submitter` (submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `images.title` ON cms10_images(title);
		ALTER TABLE cms10_images ADD FOREIGN KEY `images.title` (title) REFERENCES cms10_translate (id);

		CREATE INDEX `videos.cat` ON cms10_videos(cat);
		ALTER TABLE cms10_videos ADD FOREIGN KEY `videos.cat` (cat) REFERENCES cms10_galleries (name);

		CREATE INDEX `videos.description` ON cms10_videos(description);
		ALTER TABLE cms10_videos ADD FOREIGN KEY `videos.description` (description) REFERENCES cms10_translate (id);

		CREATE INDEX `videos.submitter` ON cms10_videos(submitter);
		ALTER TABLE cms10_videos ADD FOREIGN KEY `videos.submitter` (submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `videos.title` ON cms10_videos(title);
		ALTER TABLE cms10_videos ADD FOREIGN KEY `videos.title` (title) REFERENCES cms10_translate (id);

		CREATE INDEX `video_transcoding.t_local_id` ON cms10_video_transcoding(t_local_id);
		ALTER TABLE cms10_video_transcoding ADD FOREIGN KEY `video_transcoding.t_local_id` (t_local_id) REFERENCES cms10_videos (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

		CREATE INDEX `translate.source_user` ON cms10_translate(source_user);
		ALTER TABLE cms10_translate ADD FOREIGN KEY `translate.source_user` (source_user) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_groups.g_promotion_target` ON cms10_f_groups(g_promotion_target);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_promotion_target` (g_promotion_target) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_groups.g_name` ON cms10_f_groups(g_name);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_name` (g_name) REFERENCES cms10_translate (id);

		CREATE INDEX `f_groups.g_group_leader` ON cms10_f_groups(g_group_leader);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_group_leader` (g_group_leader) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_groups.g_title` ON cms10_f_groups(g_title);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_title` (g_title) REFERENCES cms10_translate (id);
