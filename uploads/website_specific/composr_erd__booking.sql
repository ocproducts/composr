		CREATE TABLE cms10_bookable
		(
			id integer auto_increment NULL,
			title integer NOT NULL,
			description integer NOT NULL,
			price real NOT NULL,
			categorisation integer NOT NULL,
			cycle_type varchar(80) NOT NULL,
			cycle_pattern varchar(255) NOT NULL,
			user_may_choose_code tinyint(1) NOT NULL,
			supports_notes tinyint(1) NOT NULL,
			dates_are_ranges tinyint(1) NOT NULL,
			calendar_type integer NOT NULL,
			add_date integer unsigned NOT NULL,
			edit_date integer unsigned NOT NULL,
			submitter integer NOT NULL,
			sort_order integer NOT NULL,
			enabled tinyint(1) NOT NULL,
			active_from_day tinyint NOT NULL,
			active_from_month tinyint NOT NULL,
			active_from_year integer NOT NULL,
			active_to_day tinyint NOT NULL,
			active_to_month tinyint NOT NULL,
			active_to_year integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_bookable_blacked
		(
			id integer auto_increment NULL,
			blacked_from_day tinyint NOT NULL,
			blacked_from_month tinyint NOT NULL,
			blacked_from_year integer NOT NULL,
			blacked_to_day tinyint NOT NULL,
			blacked_to_month tinyint NOT NULL,
			blacked_to_year integer NOT NULL,
			blacked_explanation integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_bookable_blacked_for
		(
			bookable_id integer NULL,
			blacked_id integer NULL,
			PRIMARY KEY (bookable_id,blacked_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_bookable_codes
		(
			bookable_id integer NULL,
			code varchar(80) NULL,
			PRIMARY KEY (bookable_id,code)
		) TYPE=InnoDB;

		CREATE TABLE cms10_bookable_supplement
		(
			id integer auto_increment NULL,
			price real NOT NULL,
			price_is_per_period tinyint(1) NOT NULL,
			supports_quantities tinyint(1) NOT NULL,
			title integer NOT NULL,
			promo_code varchar(80) NOT NULL,
			supports_notes tinyint(1) NOT NULL,
			sort_order integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_bookable_supplement_for
		(
			supplement_id integer NULL,
			bookable_id integer NULL,
			PRIMARY KEY (supplement_id,bookable_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_booking
		(
			id integer auto_increment NULL,
			bookable_id integer NOT NULL,
			member_id integer NOT NULL,
			b_day tinyint NOT NULL,
			b_month tinyint NOT NULL,
			b_year integer NOT NULL,
			code_allocation varchar(80) NOT NULL,
			notes longtext NOT NULL,
			booked_at integer unsigned NOT NULL,
			paid_at integer unsigned NOT NULL,
			paid_trans_id integer NOT NULL,
			customer_name varchar(255) NOT NULL,
			customer_email varchar(255) NOT NULL,
			customer_mobile varchar(255) NOT NULL,
			customer_phone varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_booking_supplement
		(
			booking_id integer NULL,
			supplement_id integer NULL,
			quantity integer NOT NULL,
			notes longtext NOT NULL,
			PRIMARY KEY (booking_id,supplement_id)
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

		CREATE TABLE cms10_calendar_types
		(
			t_external_feed varchar(255) NOT NULL,
			id integer auto_increment NULL,
			t_title integer NOT NULL,
			t_logo varchar(255) NOT NULL,
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

		CREATE TABLE cms10_transactions
		(
			id varchar(80) NULL,
			purchase_id varchar(80) NOT NULL,
			status varchar(255) NOT NULL,
			reason varchar(255) NOT NULL,
			amount varchar(255) NOT NULL,
			t_currency varchar(80) NOT NULL,
			linked varchar(80) NOT NULL,
			t_time integer unsigned NULL,
			item varchar(255) NOT NULL,
			pending_reason varchar(255) NOT NULL,
			t_memo longtext NOT NULL,
			t_via varchar(80) NOT NULL,
			PRIMARY KEY (id,t_time)
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


		CREATE INDEX `bookable.title` ON cms10_bookable(title);
		ALTER TABLE cms10_bookable ADD FOREIGN KEY `bookable.title` (title) REFERENCES cms10_translate (id);

		CREATE INDEX `bookable.description` ON cms10_bookable(description);
		ALTER TABLE cms10_bookable ADD FOREIGN KEY `bookable.description` (description) REFERENCES cms10_translate (id);

		CREATE INDEX `bookable.categorisation` ON cms10_bookable(categorisation);
		ALTER TABLE cms10_bookable ADD FOREIGN KEY `bookable.categorisation` (categorisation) REFERENCES cms10_translate (id);

		CREATE INDEX `bookable.calendar_type` ON cms10_bookable(calendar_type);
		ALTER TABLE cms10_bookable ADD FOREIGN KEY `bookable.calendar_type` (calendar_type) REFERENCES cms10_calendar_types (id);

		CREATE INDEX `bookable.submitter` ON cms10_bookable(submitter);
		ALTER TABLE cms10_bookable ADD FOREIGN KEY `bookable.submitter` (submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `bookable_blacked.blacked_explanation` ON cms10_bookable_blacked(blacked_explanation);
		ALTER TABLE cms10_bookable_blacked ADD FOREIGN KEY `bookable_blacked.blacked_explanation` (blacked_explanation) REFERENCES cms10_translate (id);

		CREATE INDEX `bookable_blacked_for.bookable_id` ON cms10_bookable_blacked_for(bookable_id);
		ALTER TABLE cms10_bookable_blacked_for ADD FOREIGN KEY `bookable_blacked_for.bookable_id` (bookable_id) REFERENCES cms10_bookable (id);

		CREATE INDEX `bookable_blacked_for.blacked_id` ON cms10_bookable_blacked_for(blacked_id);
		ALTER TABLE cms10_bookable_blacked_for ADD FOREIGN KEY `bookable_blacked_for.blacked_id` (blacked_id) REFERENCES cms10_bookable_codes (code);

		CREATE INDEX `bookable_codes.bookable_id` ON cms10_bookable_codes(bookable_id);
		ALTER TABLE cms10_bookable_codes ADD FOREIGN KEY `bookable_codes.bookable_id` (bookable_id) REFERENCES cms10_bookable (id);

		CREATE INDEX `bookable_supplement.title` ON cms10_bookable_supplement(title);
		ALTER TABLE cms10_bookable_supplement ADD FOREIGN KEY `bookable_supplement.title` (title) REFERENCES cms10_translate (id);

		CREATE INDEX `bookable_supplement_for.supplement_id` ON cms10_bookable_supplement_for(supplement_id);
		ALTER TABLE cms10_bookable_supplement_for ADD FOREIGN KEY `bookable_supplement_for.supplement_id` (supplement_id) REFERENCES cms10_bookable_supplement (id);

		CREATE INDEX `bookable_supplement_for.bookable_id` ON cms10_bookable_supplement_for(bookable_id);
		ALTER TABLE cms10_bookable_supplement_for ADD FOREIGN KEY `bookable_supplement_for.bookable_id` (bookable_id) REFERENCES cms10_bookable (id);

		CREATE INDEX `booking.bookable_id` ON cms10_booking(bookable_id);
		ALTER TABLE cms10_booking ADD FOREIGN KEY `booking.bookable_id` (bookable_id) REFERENCES cms10_bookable (id);

		CREATE INDEX `booking.member_id` ON cms10_booking(member_id);
		ALTER TABLE cms10_booking ADD FOREIGN KEY `booking.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `booking.paid_trans_id` ON cms10_booking(paid_trans_id);
		ALTER TABLE cms10_booking ADD FOREIGN KEY `booking.paid_trans_id` (paid_trans_id) REFERENCES cms10_transactions (id);

		CREATE INDEX `booking_supplement.booking_id` ON cms10_booking_supplement(booking_id);
		ALTER TABLE cms10_booking_supplement ADD FOREIGN KEY `booking_supplement.booking_id` (booking_id) REFERENCES cms10_booking (id);

		CREATE INDEX `booking_supplement.supplement_id` ON cms10_booking_supplement(supplement_id);
		ALTER TABLE cms10_booking_supplement ADD FOREIGN KEY `booking_supplement.supplement_id` (supplement_id) REFERENCES cms10_bookable_supplement (id);

		CREATE INDEX `translate.source_user` ON cms10_translate(source_user);
		ALTER TABLE cms10_translate ADD FOREIGN KEY `translate.source_user` (source_user) REFERENCES cms10_f_members (id);

		CREATE INDEX `calendar_types.t_title` ON cms10_calendar_types(t_title);
		ALTER TABLE cms10_calendar_types ADD FOREIGN KEY `calendar_types.t_title` (t_title) REFERENCES cms10_translate (id);

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
