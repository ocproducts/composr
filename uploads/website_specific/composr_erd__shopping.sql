		CREATE TABLE cms10_shopping_order
		(
			id integer auto_increment NULL,
			c_member integer NOT NULL,
			session_id integer NOT NULL,
			add_date integer unsigned NOT NULL,
			tot_price real NOT NULL,
			order_status varchar(80) NOT NULL,
			notes longtext NOT NULL,
			transaction_id varchar(255) NOT NULL,
			purchase_through varchar(255) NOT NULL,
			tax_opted_out tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_shopping_cart
		(
			id integer auto_increment NULL,
			session_id integer NOT NULL,
			ordered_by integer NULL,
			product_id integer NULL,
			product_name varchar(255) NOT NULL,
			product_code varchar(255) NOT NULL,
			quantity integer NOT NULL,
			price_pre_tax real NOT NULL,
			price real NOT NULL,
			product_description longtext NOT NULL,
			product_type varchar(255) NOT NULL,
			product_weight real NOT NULL,
			is_deleted tinyint(1) NOT NULL,
			PRIMARY KEY (id,ordered_by,product_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_shopping_order_details
		(
			id integer auto_increment NULL,
			order_id integer NOT NULL,
			p_id integer NOT NULL,
			p_name varchar(255) NOT NULL,
			p_code varchar(255) NOT NULL,
			p_type varchar(255) NOT NULL,
			p_quantity integer NOT NULL,
			p_price real NOT NULL,
			included_tax real NOT NULL,
			dispatch_status varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_shopping_logging
		(
			id integer auto_increment NULL,
			e_member_id integer NULL,
			session_id integer NOT NULL,
			ip varchar(40) NOT NULL,
			last_action varchar(255) NOT NULL,
			date_and_time integer unsigned NOT NULL,
			PRIMARY KEY (id,e_member_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_shopping_order_addresses
		(
			id integer auto_increment NULL,
			order_id integer NOT NULL,
			address_name varchar(255) NOT NULL,
			address_street longtext NOT NULL,
			address_city varchar(255) NOT NULL,
			address_zip varchar(255) NOT NULL,
			address_country varchar(255) NOT NULL,
			receiver_email varchar(255) NOT NULL,
			PRIMARY KEY (id)
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


		CREATE INDEX `shopping_cart.ordered_by` ON cms10_shopping_cart(ordered_by);
		ALTER TABLE cms10_shopping_cart ADD FOREIGN KEY `shopping_cart.ordered_by` (ordered_by) REFERENCES cms10_f_members (id);

		CREATE INDEX `shopping_cart.product_id` ON cms10_shopping_cart(product_id);
		ALTER TABLE cms10_shopping_cart ADD FOREIGN KEY `shopping_cart.product_id` (product_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `shopping_order_details.order_id` ON cms10_shopping_order_details(order_id);
		ALTER TABLE cms10_shopping_order_details ADD FOREIGN KEY `shopping_order_details.order_id` (order_id) REFERENCES cms10_shopping_order (id);

		CREATE INDEX `shopping_order_details.p_id` ON cms10_shopping_order_details(p_id);
		ALTER TABLE cms10_shopping_order_details ADD FOREIGN KEY `shopping_order_details.p_id` (p_id) REFERENCES cms10_catalogue_entries (id);

		CREATE INDEX `shopping_logging.e_member_id` ON cms10_shopping_logging(e_member_id);
		ALTER TABLE cms10_shopping_logging ADD FOREIGN KEY `shopping_logging.e_member_id` (e_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `shopping_order_addresses.order_id` ON cms10_shopping_order_addresses(order_id);
		ALTER TABLE cms10_shopping_order_addresses ADD FOREIGN KEY `shopping_order_addresses.order_id` (order_id) REFERENCES cms10_shopping_order (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

		CREATE INDEX `catalogue_entries.c_name` ON cms10_catalogue_entries(c_name);
		ALTER TABLE cms10_catalogue_entries ADD FOREIGN KEY `catalogue_entries.c_name` (c_name) REFERENCES cms10_catalogues (c_name);

		CREATE INDEX `catalogue_entries.cc_id` ON cms10_catalogue_entries(cc_id);
		ALTER TABLE cms10_catalogue_entries ADD FOREIGN KEY `catalogue_entries.cc_id` (cc_id) REFERENCES cms10_catalogue_categories (id);

		CREATE INDEX `catalogue_entries.ce_submitter` ON cms10_catalogue_entries(ce_submitter);
		ALTER TABLE cms10_catalogue_entries ADD FOREIGN KEY `catalogue_entries.ce_submitter` (ce_submitter) REFERENCES cms10_f_members (id);

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
