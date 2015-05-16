		CREATE TABLE cms10_news
		(
			news_image varchar(255) NOT NULL,
			news_views integer NOT NULL,
			validated tinyint(1) NOT NULL,
			edit_date integer unsigned NOT NULL,
			news_category integer NOT NULL,
			submitter integer NOT NULL,
			author varchar(80) NOT NULL,
			allow_comments tinyint NOT NULL,
			allow_trackbacks tinyint(1) NOT NULL,
			notes longtext NOT NULL,
			news_article integer NOT NULL,
			allow_rating tinyint(1) NOT NULL,
			title integer NOT NULL,
			news integer NOT NULL,
			date_and_time integer unsigned NOT NULL,
			id integer auto_increment NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_news_categories
		(
			id integer auto_increment NULL,
			nc_title integer NOT NULL,
			nc_owner integer NOT NULL,
			nc_img varchar(80) NOT NULL,
			notes longtext NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_news_rss_cloud
		(
			rem_ip varchar(40) NOT NULL,
			rem_path varchar(255) NOT NULL,
			watching_channel varchar(255) NOT NULL,
			register_time integer unsigned NOT NULL,
			rem_protocol varchar(80) NOT NULL,
			id integer auto_increment NULL,
			rem_procedure varchar(80) NOT NULL,
			rem_port integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_news_category_entries
		(
			news_entry_category integer NULL,
			news_entry integer NULL,
			PRIMARY KEY (news_entry_category,news_entry)
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

		CREATE TABLE cms10_authors
		(
			description integer NOT NULL,
			author varchar(80) NULL,
			url varchar(255) NOT NULL,
			skills integer NOT NULL,
			member_id integer NOT NULL,
			PRIMARY KEY (author)
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


		CREATE INDEX `news.news_category` ON cms10_news(news_category);
		ALTER TABLE cms10_news ADD FOREIGN KEY `news.news_category` (news_category) REFERENCES cms10_news_categories (id);

		CREATE INDEX `news.submitter` ON cms10_news(submitter);
		ALTER TABLE cms10_news ADD FOREIGN KEY `news.submitter` (submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `news.author` ON cms10_news(author);
		ALTER TABLE cms10_news ADD FOREIGN KEY `news.author` (author) REFERENCES cms10_authors (author);

		CREATE INDEX `news.news_article` ON cms10_news(news_article);
		ALTER TABLE cms10_news ADD FOREIGN KEY `news.news_article` (news_article) REFERENCES cms10_translate (id);

		CREATE INDEX `news.title` ON cms10_news(title);
		ALTER TABLE cms10_news ADD FOREIGN KEY `news.title` (title) REFERENCES cms10_translate (id);

		CREATE INDEX `news.news` ON cms10_news(news);
		ALTER TABLE cms10_news ADD FOREIGN KEY `news.news` (news) REFERENCES cms10_translate (id);

		CREATE INDEX `news_categories.nc_title` ON cms10_news_categories(nc_title);
		ALTER TABLE cms10_news_categories ADD FOREIGN KEY `news_categories.nc_title` (nc_title) REFERENCES cms10_translate (id);

		CREATE INDEX `news_categories.nc_owner` ON cms10_news_categories(nc_owner);
		ALTER TABLE cms10_news_categories ADD FOREIGN KEY `news_categories.nc_owner` (nc_owner) REFERENCES cms10_f_members (id);

		CREATE INDEX `news_category_entries.news_entry_category` ON cms10_news_category_entries(news_entry_category);
		ALTER TABLE cms10_news_category_entries ADD FOREIGN KEY `news_category_entries.news_entry_category` (news_entry_category) REFERENCES cms10_news_categories (id);

		CREATE INDEX `news_category_entries.news_entry` ON cms10_news_category_entries(news_entry);
		ALTER TABLE cms10_news_category_entries ADD FOREIGN KEY `news_category_entries.news_entry` (news_entry) REFERENCES cms10_news (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

		CREATE INDEX `authors.description` ON cms10_authors(description);
		ALTER TABLE cms10_authors ADD FOREIGN KEY `authors.description` (description) REFERENCES cms10_translate (id);

		CREATE INDEX `authors.skills` ON cms10_authors(skills);
		ALTER TABLE cms10_authors ADD FOREIGN KEY `authors.skills` (skills) REFERENCES cms10_translate (id);

		CREATE INDEX `authors.member_id` ON cms10_authors(member_id);
		ALTER TABLE cms10_authors ADD FOREIGN KEY `authors.member_id` (member_id) REFERENCES cms10_f_members (id);

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
