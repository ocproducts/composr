		CREATE TABLE cms10_catalogues
		(
			c_send_view_reports varchar(80) NOT NULL,
			c_default_review_freq integer NOT NULL,
			c_submit_points integer NOT NULL,
			c_ecommerce tinyint(1) NOT NULL,
			c_is_tree tinyint(1) NOT NULL,
			c_notes longtext NOT NULL,
			c_add_date integer unsigned NOT NULL,
			c_display_type tinyint NOT NULL,
			c_description integer NOT NULL,
			c_name varchar(80) NULL,
			c_title integer NOT NULL,
			PRIMARY KEY (c_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_categories
		(
			id integer auto_increment NULL,
			c_name varchar(80) NOT NULL,
			cc_title integer NOT NULL,
			cc_description integer NOT NULL,
			rep_image varchar(255) NOT NULL,
			cc_notes longtext NOT NULL,
			cc_add_date integer unsigned NOT NULL,
			cc_parent_id integer NOT NULL,
			cc_move_target integer NOT NULL,
			cc_move_days_lower integer NOT NULL,
			cc_move_days_higher integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_fields
		(
			id integer auto_increment NULL,
			c_name varchar(80) NOT NULL,
			cf_name integer NOT NULL,
			cf_description integer NOT NULL,
			cf_type varchar(80) NOT NULL,
			cf_order integer NOT NULL,
			cf_defines_order tinyint NOT NULL,
			cf_visible tinyint(1) NOT NULL,
			cf_searchable tinyint(1) NOT NULL,
			cf_default longtext NOT NULL,
			cf_required tinyint(1) NOT NULL,
			cf_put_in_category tinyint(1) NOT NULL,
			cf_put_in_search tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_entries
		(
			id integer auto_increment NULL,
			c_name varchar(80) NOT NULL,
			cc_id integer NOT NULL,
			ce_submitter integer NOT NULL,
			ce_add_date integer unsigned NOT NULL,
			ce_edit_date integer unsigned NOT NULL,
			ce_views integer NOT NULL,
			ce_views_prior integer NOT NULL,
			ce_validated tinyint(1) NOT NULL,
			notes longtext NOT NULL,
			allow_rating tinyint(1) NOT NULL,
			allow_comments tinyint NOT NULL,
			allow_trackbacks tinyint(1) NOT NULL,
			ce_last_moved integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_efv_long_trans
		(
			id integer auto_increment NULL,
			cf_id integer NOT NULL,
			ce_id integer NOT NULL,
			cv_value integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_efv_long
		(
			id integer auto_increment NULL,
			cf_id integer NOT NULL,
			ce_id integer NOT NULL,
			cv_value longtext NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_efv_short_trans
		(
			id integer auto_increment NULL,
			cf_id integer NOT NULL,
			ce_id integer NOT NULL,
			cv_value integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_efv_short
		(
			id integer auto_increment NULL,
			cf_id integer NOT NULL,
			ce_id integer NOT NULL,
			cv_value varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_entry_linkage
		(
			catalogue_entry_id integer NULL,
			content_type varchar(80) NOT NULL,
			content_id varchar(80) NOT NULL,
			PRIMARY KEY (catalogue_entry_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_cat_treecache
		(
			cc_ancestor_id integer NULL,
			cc_id integer NULL,
			PRIMARY KEY (cc_ancestor_id,cc_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_childcountcache
		(
			cc_id integer NULL,
			c_num_rec_children integer NOT NULL,
			c_num_rec_entries integer NOT NULL,
			PRIMARY KEY (cc_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_efv_float
		(
			id integer auto_increment NULL,
			cf_id integer NOT NULL,
			ce_id integer NOT NULL,
			cv_value real NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_catalogue_efv_integer
		(
			cv_value integer NOT NULL,
			id integer auto_increment NULL,
			cf_id integer NOT NULL,
			ce_id integer NOT NULL,
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


		CREATE INDEX `catalogues.c_description` ON cms10_catalogues(c_description);
		ALTER TABLE cms10_catalogues ADD FOREIGN KEY `catalogues.c_description` (c_description) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogues.c_title` ON cms10_catalogues(c_title);
		ALTER TABLE cms10_catalogues ADD FOREIGN KEY `catalogues.c_title` (c_title) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_categories.c_name` ON cms10_catalogue_categories(c_name);
		ALTER TABLE cms10_catalogue_categories ADD FOREIGN KEY `catalogue_categories.c_name` (c_name) REFERENCES cms10_catalogues (c_name);

		CREATE INDEX `catalogue_categories.cc_title` ON cms10_catalogue_categories(cc_title);
		ALTER TABLE cms10_catalogue_categories ADD FOREIGN KEY `catalogue_categories.cc_title` (cc_title) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_categories.cc_description` ON cms10_catalogue_categories(cc_description);
		ALTER TABLE cms10_catalogue_categories ADD FOREIGN KEY `catalogue_categories.cc_description` (cc_description) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_categories.cc_parent_id` ON cms10_catalogue_categories(cc_parent_id);
		ALTER TABLE cms10_catalogue_categories ADD FOREIGN KEY `catalogue_categories.cc_parent_id` (cc_parent_id) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_categories.cc_move_target` ON cms10_catalogue_categories(cc_move_target);
		ALTER TABLE cms10_catalogue_categories ADD FOREIGN KEY `catalogue_categories.cc_move_target` (cc_move_target) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_fields.c_name` ON cms10_catalogue_fields(c_name);
		ALTER TABLE cms10_catalogue_fields ADD FOREIGN KEY `catalogue_fields.c_name` (c_name) REFERENCES cms10_catalogues (c_name);

		CREATE INDEX `catalogue_fields.cf_name` ON cms10_catalogue_fields(cf_name);
		ALTER TABLE cms10_catalogue_fields ADD FOREIGN KEY `catalogue_fields.cf_name` (cf_name) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_fields.cf_description` ON cms10_catalogue_fields(cf_description);
		ALTER TABLE cms10_catalogue_fields ADD FOREIGN KEY `catalogue_fields.cf_description` (cf_description) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_entries.c_name` ON cms10_catalogue_entries(c_name);
		ALTER TABLE cms10_catalogue_entries ADD FOREIGN KEY `catalogue_entries.c_name` (c_name) REFERENCES cms10_catalogues (c_name);

		CREATE INDEX `catalogue_entries.cc_id` ON cms10_catalogue_entries(cc_id);
		ALTER TABLE cms10_catalogue_entries ADD FOREIGN KEY `catalogue_entries.cc_id` (cc_id) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_entries.ce_submitter` ON cms10_catalogue_entries(ce_submitter);
		ALTER TABLE cms10_catalogue_entries ADD FOREIGN KEY `catalogue_entries.ce_submitter` (ce_submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `catalogue_efv_long_trans.cf_id` ON cms10_catalogue_efv_long_trans(cf_id);
		ALTER TABLE cms10_catalogue_efv_long_trans ADD FOREIGN KEY `catalogue_efv_long_trans.cf_id` (cf_id) REFERENCES cms10_catalogue_fields (id);

		CREATE INDEX `catalogue_efv_long_trans.ce_id` ON cms10_catalogue_efv_long_trans(ce_id);
		ALTER TABLE cms10_catalogue_efv_long_trans ADD FOREIGN KEY `catalogue_efv_long_trans.ce_id` (ce_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `catalogue_efv_long_trans.cv_value` ON cms10_catalogue_efv_long_trans(cv_value);
		ALTER TABLE cms10_catalogue_efv_long_trans ADD FOREIGN KEY `catalogue_efv_long_trans.cv_value` (cv_value) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_efv_long.cf_id` ON cms10_catalogue_efv_long(cf_id);
		ALTER TABLE cms10_catalogue_efv_long ADD FOREIGN KEY `catalogue_efv_long.cf_id` (cf_id) REFERENCES cms10_catalogue_fields (id);

		CREATE INDEX `catalogue_efv_long.ce_id` ON cms10_catalogue_efv_long(ce_id);
		ALTER TABLE cms10_catalogue_efv_long ADD FOREIGN KEY `catalogue_efv_long.ce_id` (ce_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `catalogue_efv_short_trans.cf_id` ON cms10_catalogue_efv_short_trans(cf_id);
		ALTER TABLE cms10_catalogue_efv_short_trans ADD FOREIGN KEY `catalogue_efv_short_trans.cf_id` (cf_id) REFERENCES cms10_catalogue_fields (id);

		CREATE INDEX `catalogue_efv_short_trans.ce_id` ON cms10_catalogue_efv_short_trans(ce_id);
		ALTER TABLE cms10_catalogue_efv_short_trans ADD FOREIGN KEY `catalogue_efv_short_trans.ce_id` (ce_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `catalogue_efv_short_trans.cv_value` ON cms10_catalogue_efv_short_trans(cv_value);
		ALTER TABLE cms10_catalogue_efv_short_trans ADD FOREIGN KEY `catalogue_efv_short_trans.cv_value` (cv_value) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_efv_short.cf_id` ON cms10_catalogue_efv_short(cf_id);
		ALTER TABLE cms10_catalogue_efv_short ADD FOREIGN KEY `catalogue_efv_short.cf_id` (cf_id) REFERENCES cms10_catalogue_fields (id);

		CREATE INDEX `catalogue_efv_short.ce_id` ON cms10_catalogue_efv_short(ce_id);
		ALTER TABLE cms10_catalogue_efv_short ADD FOREIGN KEY `catalogue_efv_short.ce_id` (ce_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `catalogue_entry_linkage.catalogue_entry_id` ON cms10_catalogue_entry_linkage(catalogue_entry_id);
		ALTER TABLE cms10_catalogue_entry_linkage ADD FOREIGN KEY `catalogue_entry_linkage.catalogue_entry_id` (catalogue_entry_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `catalogue_cat_treecache.cc_ancestor_id` ON cms10_catalogue_cat_treecache(cc_ancestor_id);
		ALTER TABLE cms10_catalogue_cat_treecache ADD FOREIGN KEY `catalogue_cat_treecache.cc_ancestor_id` (cc_ancestor_id) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_cat_treecache.cc_id` ON cms10_catalogue_cat_treecache(cc_id);
		ALTER TABLE cms10_catalogue_cat_treecache ADD FOREIGN KEY `catalogue_cat_treecache.cc_id` (cc_id) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_childcountcache.cc_id` ON cms10_catalogue_childcountcache(cc_id);
		ALTER TABLE cms10_catalogue_childcountcache ADD FOREIGN KEY `catalogue_childcountcache.cc_id` (cc_id) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_efv_float.cf_id` ON cms10_catalogue_efv_float(cf_id);
		ALTER TABLE cms10_catalogue_efv_float ADD FOREIGN KEY `catalogue_efv_float.cf_id` (cf_id) REFERENCES cms10_catalogue_fields (id);

		CREATE INDEX `catalogue_efv_float.ce_id` ON cms10_catalogue_efv_float(ce_id);
		ALTER TABLE cms10_catalogue_efv_float ADD FOREIGN KEY `catalogue_efv_float.ce_id` (ce_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `catalogue_efv_integer.cf_id` ON cms10_catalogue_efv_integer(cf_id);
		ALTER TABLE cms10_catalogue_efv_integer ADD FOREIGN KEY `catalogue_efv_integer.cf_id` (cf_id) REFERENCES cms10_catalogue_fields (id);

		CREATE INDEX `catalogue_efv_integer.ce_id` ON cms10_catalogue_efv_integer(ce_id);
		ALTER TABLE cms10_catalogue_efv_integer ADD FOREIGN KEY `catalogue_efv_integer.ce_id` (ce_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `translate.source_user` ON cms10_translate(source_user);
		ALTER TABLE cms10_translate ADD FOREIGN KEY `translate.source_user` (source_user) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

		CREATE INDEX `f_groups.g_promotion_target` ON cms10_f_groups(g_promotion_target);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_promotion_target` (g_promotion_target) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_groups.g_name` ON cms10_f_groups(g_name);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_name` (g_name) REFERENCES cms10_translate (id);

		CREATE INDEX `f_groups.g_group_leader` ON cms10_f_groups(g_group_leader);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_group_leader` (g_group_leader) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_groups.g_title` ON cms10_f_groups(g_title);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_title` (g_title) REFERENCES cms10_translate (id);
