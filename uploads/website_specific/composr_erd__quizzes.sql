		CREATE TABLE cms10_quiz_member_last_visit
		(
			id integer auto_increment NULL,
			v_time integer unsigned NOT NULL,
			v_member_id integer NOT NULL,
			v_quiz_id integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_quizzes
		(
			id integer auto_increment NULL,
			q_timeout integer NOT NULL,
			q_name integer NOT NULL,
			q_start_text integer NOT NULL,
			q_end_text integer NOT NULL,
			q_notes longtext NOT NULL,
			q_percentage integer NOT NULL,
			q_open_time integer unsigned NOT NULL,
			q_close_time integer unsigned NOT NULL,
			q_num_winners integer NOT NULL,
			q_redo_time integer NOT NULL,
			q_type varchar(80) NOT NULL,
			q_add_date integer unsigned NOT NULL,
			q_validated tinyint(1) NOT NULL,
			q_submitter integer NOT NULL,
			q_points_for_passing integer NOT NULL,
			q_tied_newsletter integer NOT NULL,
			q_end_text_fail integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_quiz_questions
		(
			id integer auto_increment NULL,
			q_long_input_field tinyint(1) NOT NULL,
			q_num_choosable_answers integer NOT NULL,
			q_quiz integer NOT NULL,
			q_question_text integer NOT NULL,
			q_order integer NOT NULL,
			q_required tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_quiz_question_answers
		(
			id integer auto_increment NULL,
			q_question integer NOT NULL,
			q_answer_text integer NOT NULL,
			q_is_correct tinyint(1) NOT NULL,
			q_order integer NOT NULL,
			q_explanation integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_quiz_winner
		(
			q_quiz integer NULL,
			q_entry integer NULL,
			q_winner_level integer NOT NULL,
			PRIMARY KEY (q_quiz,q_entry)
		) TYPE=InnoDB;

		CREATE TABLE cms10_quiz_entries
		(
			id integer auto_increment NULL,
			q_time integer unsigned NOT NULL,
			q_member integer NOT NULL,
			q_quiz integer NOT NULL,
			q_results integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_quiz_entry_answer
		(
			id integer auto_increment NULL,
			q_entry integer NOT NULL,
			q_question integer NOT NULL,
			q_answer longtext NOT NULL,
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

		CREATE TABLE cms10_newsletters
		(
			id integer auto_increment NULL,
			title integer NOT NULL,
			description integer NOT NULL,
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


		CREATE INDEX `quiz_member_last_visit.v_member_id` ON cms10_quiz_member_last_visit(v_member_id);
		ALTER TABLE cms10_quiz_member_last_visit ADD FOREIGN KEY `quiz_member_last_visit.v_member_id` (v_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `quiz_member_last_visit.v_quiz_id` ON cms10_quiz_member_last_visit(v_quiz_id);
		ALTER TABLE cms10_quiz_member_last_visit ADD FOREIGN KEY `quiz_member_last_visit.v_quiz_id` (v_quiz_id) REFERENCES cms10_quizzes (id);

		CREATE INDEX `quizzes.q_name` ON cms10_quizzes(q_name);
		ALTER TABLE cms10_quizzes ADD FOREIGN KEY `quizzes.q_name` (q_name) REFERENCES cms10_translate (id);

		CREATE INDEX `quizzes.q_start_text` ON cms10_quizzes(q_start_text);
		ALTER TABLE cms10_quizzes ADD FOREIGN KEY `quizzes.q_start_text` (q_start_text) REFERENCES cms10_translate (id);

		CREATE INDEX `quizzes.q_end_text` ON cms10_quizzes(q_end_text);
		ALTER TABLE cms10_quizzes ADD FOREIGN KEY `quizzes.q_end_text` (q_end_text) REFERENCES cms10_translate (id);

		CREATE INDEX `quizzes.q_submitter` ON cms10_quizzes(q_submitter);
		ALTER TABLE cms10_quizzes ADD FOREIGN KEY `quizzes.q_submitter` (q_submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `quizzes.q_tied_newsletter` ON cms10_quizzes(q_tied_newsletter);
		ALTER TABLE cms10_quizzes ADD FOREIGN KEY `quizzes.q_tied_newsletter` (q_tied_newsletter) REFERENCES cms10_newsletters (id);

		CREATE INDEX `quizzes.q_end_text_fail` ON cms10_quizzes(q_end_text_fail);
		ALTER TABLE cms10_quizzes ADD FOREIGN KEY `quizzes.q_end_text_fail` (q_end_text_fail) REFERENCES cms10_translate (id);

		CREATE INDEX `quiz_questions.q_quiz` ON cms10_quiz_questions(q_quiz);
		ALTER TABLE cms10_quiz_questions ADD FOREIGN KEY `quiz_questions.q_quiz` (q_quiz) REFERENCES cms10_quizzes (id);

		CREATE INDEX `quiz_questions.q_question_text` ON cms10_quiz_questions(q_question_text);
		ALTER TABLE cms10_quiz_questions ADD FOREIGN KEY `quiz_questions.q_question_text` (q_question_text) REFERENCES cms10_translate (id);

		CREATE INDEX `quiz_question_answers.q_question` ON cms10_quiz_question_answers(q_question);
		ALTER TABLE cms10_quiz_question_answers ADD FOREIGN KEY `quiz_question_answers.q_question` (q_question) REFERENCES cms10_quiz_questions (id);

		CREATE INDEX `quiz_question_answers.q_answer_text` ON cms10_quiz_question_answers(q_answer_text);
		ALTER TABLE cms10_quiz_question_answers ADD FOREIGN KEY `quiz_question_answers.q_answer_text` (q_answer_text) REFERENCES cms10_translate (id);

		CREATE INDEX `quiz_question_answers.q_explanation` ON cms10_quiz_question_answers(q_explanation);
		ALTER TABLE cms10_quiz_question_answers ADD FOREIGN KEY `quiz_question_answers.q_explanation` (q_explanation) REFERENCES cms10_translate (id);

		CREATE INDEX `quiz_winner.q_quiz` ON cms10_quiz_winner(q_quiz);
		ALTER TABLE cms10_quiz_winner ADD FOREIGN KEY `quiz_winner.q_quiz` (q_quiz) REFERENCES cms10_quizzes (id);

		CREATE INDEX `quiz_winner.q_entry` ON cms10_quiz_winner(q_entry);
		ALTER TABLE cms10_quiz_winner ADD FOREIGN KEY `quiz_winner.q_entry` (q_entry) REFERENCES cms10_quiz_entries (id);

		CREATE INDEX `quiz_entries.q_member` ON cms10_quiz_entries(q_member);
		ALTER TABLE cms10_quiz_entries ADD FOREIGN KEY `quiz_entries.q_member` (q_member) REFERENCES cms10_f_members (id);

		CREATE INDEX `quiz_entries.q_quiz` ON cms10_quiz_entries(q_quiz);
		ALTER TABLE cms10_quiz_entries ADD FOREIGN KEY `quiz_entries.q_quiz` (q_quiz) REFERENCES cms10_quizzes (id);

		CREATE INDEX `quiz_entry_answer.q_entry` ON cms10_quiz_entry_answer(q_entry);
		ALTER TABLE cms10_quiz_entry_answer ADD FOREIGN KEY `quiz_entry_answer.q_entry` (q_entry) REFERENCES cms10_quiz_entries (id);

		CREATE INDEX `quiz_entry_answer.q_question` ON cms10_quiz_entry_answer(q_question);
		ALTER TABLE cms10_quiz_entry_answer ADD FOREIGN KEY `quiz_entry_answer.q_question` (q_question) REFERENCES cms10_quiz_questions (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

		CREATE INDEX `translate.source_user` ON cms10_translate(source_user);
		ALTER TABLE cms10_translate ADD FOREIGN KEY `translate.source_user` (source_user) REFERENCES cms10_f_members (id);

		CREATE INDEX `newsletters.title` ON cms10_newsletters(title);
		ALTER TABLE cms10_newsletters ADD FOREIGN KEY `newsletters.title` (title) REFERENCES cms10_translate (id);

		CREATE INDEX `newsletters.description` ON cms10_newsletters(description);
		ALTER TABLE cms10_newsletters ADD FOREIGN KEY `newsletters.description` (description) REFERENCES cms10_translate (id);

		CREATE INDEX `f_groups.g_promotion_target` ON cms10_f_groups(g_promotion_target);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_promotion_target` (g_promotion_target) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_groups.g_name` ON cms10_f_groups(g_name);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_name` (g_name) REFERENCES cms10_translate (id);

		CREATE INDEX `f_groups.g_group_leader` ON cms10_f_groups(g_group_leader);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_group_leader` (g_group_leader) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_groups.g_title` ON cms10_f_groups(g_title);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_title` (g_title) REFERENCES cms10_translate (id);
