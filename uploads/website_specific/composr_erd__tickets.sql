		CREATE TABLE cms10_ticket_known_emailers
		(
			email_address varchar(255) NULL,
			member_id integer NOT NULL,
			PRIMARY KEY (email_address)
		) TYPE=InnoDB;

		CREATE TABLE cms10_tickets
		(
			ticket_id varchar(255) NULL,
			topic_id integer NOT NULL,
			forum_id integer NOT NULL,
			ticket_type integer NOT NULL,
			PRIMARY KEY (ticket_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_ticket_types
		(
			ticket_type integer NULL,
			guest_emails_mandatory tinyint(1) NOT NULL,
			search_faq tinyint(1) NOT NULL,
			cache_lead_time integer unsigned NOT NULL,
			PRIMARY KEY (ticket_type)
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

		CREATE TABLE cms10_f_topics
		(
			t_cache_last_username varchar(80) NOT NULL,
			t_cache_last_time integer unsigned NOT NULL,
			t_cache_last_title varchar(255) NOT NULL,
			t_cache_last_member_id integer NOT NULL,
			t_cache_num_posts integer NOT NULL,
			t_cache_last_post_id integer NOT NULL,
			t_cache_first_member_id integer NOT NULL,
			id integer auto_increment NULL,
			t_pinned tinyint(1) NOT NULL,
			t_sunk tinyint(1) NOT NULL,
			t_cascading tinyint(1) NOT NULL,
			t_forum_id integer NOT NULL,
			t_pt_from integer NOT NULL,
			t_pt_to integer NOT NULL,
			t_pt_from_category varchar(255) NOT NULL,
			t_pt_to_category varchar(255) NOT NULL,
			t_description varchar(255) NOT NULL,
			t_description_link varchar(255) NOT NULL,
			t_emoticon varchar(255) NOT NULL,
			t_num_views integer NOT NULL,
			t_validated tinyint(1) NOT NULL,
			t_is_open tinyint(1) NOT NULL,
			t_poll_id integer NOT NULL,
			t_cache_first_post_id integer NOT NULL,
			t_cache_first_time integer unsigned NOT NULL,
			t_cache_first_title varchar(255) NOT NULL,
			t_cache_first_post integer NOT NULL,
			t_cache_first_username varchar(80) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_f_forums
		(
			id integer auto_increment NULL,
			f_name varchar(255) NOT NULL,
			f_description integer NOT NULL,
			f_forum_grouping_id integer NOT NULL,
			f_parent_forum integer NOT NULL,
			f_position integer NOT NULL,
			f_order_sub_alpha tinyint(1) NOT NULL,
			f_post_count_increment tinyint(1) NOT NULL,
			f_intro_question integer NOT NULL,
			f_intro_answer varchar(255) NOT NULL,
			f_cache_num_topics integer NOT NULL,
			f_cache_num_posts integer NOT NULL,
			f_cache_last_topic_id integer NOT NULL,
			f_cache_last_title varchar(255) NOT NULL,
			f_cache_last_time integer unsigned NOT NULL,
			f_cache_last_username varchar(255) NOT NULL,
			f_cache_last_member_id integer NOT NULL,
			f_cache_last_forum_id integer NOT NULL,
			f_redirection varchar(255) NOT NULL,
			f_order varchar(80) NOT NULL,
			f_is_threaded tinyint(1) NOT NULL,
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

		CREATE TABLE cms10_f_posts
		(
			p_skip_sig tinyint(1) NOT NULL,
			p_parent_id integer NOT NULL,
			id integer auto_increment NULL,
			p_title varchar(255) NOT NULL,
			p_post integer NOT NULL,
			p_ip_address varchar(40) NOT NULL,
			p_time integer unsigned NOT NULL,
			p_poster integer NOT NULL,
			p_intended_solely_for integer NOT NULL,
			p_poster_name_if_guest varchar(80) NOT NULL,
			p_validated tinyint(1) NOT NULL,
			p_topic_id integer NOT NULL,
			p_cache_forum_id integer NOT NULL,
			p_last_edit_time integer unsigned NOT NULL,
			p_last_edit_by integer NOT NULL,
			p_is_emphasised tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_f_polls
		(
			id integer auto_increment NULL,
			po_question varchar(255) NOT NULL,
			po_cache_total_votes integer NOT NULL,
			po_is_private tinyint(1) NOT NULL,
			po_is_open tinyint(1) NOT NULL,
			po_minimum_selections integer NOT NULL,
			po_maximum_selections integer NOT NULL,
			po_requires_reply tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_f_forum_groupings
		(
			id integer auto_increment NULL,
			c_title varchar(255) NOT NULL,
			c_description longtext NOT NULL,
			c_expanded_by_default tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;


		CREATE INDEX `ticket_known_emailers.member_id` ON cms10_ticket_known_emailers(member_id);
		ALTER TABLE cms10_ticket_known_emailers ADD FOREIGN KEY `ticket_known_emailers.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `tickets.topic_id` ON cms10_tickets(topic_id);
		ALTER TABLE cms10_tickets ADD FOREIGN KEY `tickets.topic_id` (topic_id) REFERENCES cms10_f_topics (id);

		CREATE INDEX `tickets.forum_id` ON cms10_tickets(forum_id);
		ALTER TABLE cms10_tickets ADD FOREIGN KEY `tickets.forum_id` (forum_id) REFERENCES cms10_f_forums (id);

		CREATE INDEX `tickets.ticket_type` ON cms10_tickets(ticket_type);
		ALTER TABLE cms10_tickets ADD FOREIGN KEY `tickets.ticket_type` (ticket_type) REFERENCES cms10_translate (id);

		CREATE INDEX `ticket_types.ticket_type` ON cms10_ticket_types(ticket_type);
		ALTER TABLE cms10_ticket_types ADD FOREIGN KEY `ticket_types.ticket_type` (ticket_type) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

		CREATE INDEX `f_topics.t_cache_last_member_id` ON cms10_f_topics(t_cache_last_member_id);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_cache_last_member_id` (t_cache_last_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_topics.t_cache_last_post_id` ON cms10_f_topics(t_cache_last_post_id);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_cache_last_post_id` (t_cache_last_post_id) REFERENCES cms10_f_posts (id);

		CREATE INDEX `f_topics.t_cache_first_member_id` ON cms10_f_topics(t_cache_first_member_id);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_cache_first_member_id` (t_cache_first_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_topics.t_forum_id` ON cms10_f_topics(t_forum_id);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_forum_id` (t_forum_id) REFERENCES cms10_f_forums (id);

		CREATE INDEX `f_topics.t_pt_from` ON cms10_f_topics(t_pt_from);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_pt_from` (t_pt_from) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_topics.t_pt_to` ON cms10_f_topics(t_pt_to);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_pt_to` (t_pt_to) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_topics.t_poll_id` ON cms10_f_topics(t_poll_id);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_poll_id` (t_poll_id) REFERENCES cms10_f_polls (id);

		CREATE INDEX `f_topics.t_cache_first_post_id` ON cms10_f_topics(t_cache_first_post_id);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_cache_first_post_id` (t_cache_first_post_id) REFERENCES cms10_f_posts (id);

		CREATE INDEX `f_topics.t_cache_first_post` ON cms10_f_topics(t_cache_first_post);
		ALTER TABLE cms10_f_topics ADD FOREIGN KEY `f_topics.t_cache_first_post` (t_cache_first_post) REFERENCES cms10_translate (id);

		CREATE INDEX `f_forums.f_description` ON cms10_f_forums(f_description);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_description` (f_description) REFERENCES cms10_translate (id);

		CREATE INDEX `f_forums.f_forum_grouping_id` ON cms10_f_forums(f_forum_grouping_id);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_forum_grouping_id` (f_forum_grouping_id) REFERENCES cms10_f_forum_groupings (id);

		CREATE INDEX `f_forums.f_parent_forum` ON cms10_f_forums(f_parent_forum);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_parent_forum` (f_parent_forum) REFERENCES cms10_f_forums (id);

		CREATE INDEX `f_forums.f_intro_question` ON cms10_f_forums(f_intro_question);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_intro_question` (f_intro_question) REFERENCES cms10_translate (id);

		CREATE INDEX `f_forums.f_cache_last_topic_id` ON cms10_f_forums(f_cache_last_topic_id);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_cache_last_topic_id` (f_cache_last_topic_id) REFERENCES cms10_f_topics (id);

		CREATE INDEX `f_forums.f_cache_last_member_id` ON cms10_f_forums(f_cache_last_member_id);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_cache_last_member_id` (f_cache_last_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_forums.f_cache_last_forum_id` ON cms10_f_forums(f_cache_last_forum_id);
		ALTER TABLE cms10_f_forums ADD FOREIGN KEY `f_forums.f_cache_last_forum_id` (f_cache_last_forum_id) REFERENCES cms10_f_forums (id);

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

		CREATE INDEX `f_posts.p_parent_id` ON cms10_f_posts(p_parent_id);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_parent_id` (p_parent_id) REFERENCES cms10_f_posts (id);

		CREATE INDEX `f_posts.p_post` ON cms10_f_posts(p_post);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_post` (p_post) REFERENCES cms10_translate (id);

		CREATE INDEX `f_posts.p_poster` ON cms10_f_posts(p_poster);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_poster` (p_poster) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_posts.p_intended_solely_for` ON cms10_f_posts(p_intended_solely_for);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_intended_solely_for` (p_intended_solely_for) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_posts.p_topic_id` ON cms10_f_posts(p_topic_id);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_topic_id` (p_topic_id) REFERENCES cms10_f_topics (id);

		CREATE INDEX `f_posts.p_cache_forum_id` ON cms10_f_posts(p_cache_forum_id);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_cache_forum_id` (p_cache_forum_id) REFERENCES cms10_f_forums (id);

		CREATE INDEX `f_posts.p_last_edit_by` ON cms10_f_posts(p_last_edit_by);
		ALTER TABLE cms10_f_posts ADD FOREIGN KEY `f_posts.p_last_edit_by` (p_last_edit_by) REFERENCES cms10_f_members (id);
