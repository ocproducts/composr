		CREATE TABLE cms10_feature_lifetime_monitor
		(
			running_now tinyint(1) NOT NULL,
			last_update integer unsigned NOT NULL,
			content_id varchar(80) NULL,
			block_cache_id varchar(80) NULL,
			run_period integer NOT NULL,
			PRIMARY KEY (content_id,block_cache_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_menu_items
		(
			id integer auto_increment NULL,
			i_menu varchar(80) NOT NULL,
			i_order integer NOT NULL,
			i_parent integer NOT NULL,
			i_caption integer NOT NULL,
			i_caption_long integer NOT NULL,
			i_url varchar(255) NOT NULL,
			i_check_permissions tinyint(1) NOT NULL,
			i_expanded tinyint(1) NOT NULL,
			i_new_window tinyint(1) NOT NULL,
			i_include_sitemap tinyint NOT NULL,
			i_page_only varchar(80) NOT NULL,
			i_theme_img_code varchar(80) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_trackbacks
		(
			id integer auto_increment NULL,
			trackback_for_type varchar(80) NOT NULL,
			trackback_for_id varchar(80) NOT NULL,
			trackback_ip varchar(40) NOT NULL,
			trackback_time integer unsigned NOT NULL,
			trackback_url varchar(255) NOT NULL,
			trackback_title varchar(255) NOT NULL,
			trackback_excerpt longtext NOT NULL,
			trackback_name varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_captchas
		(
			si_session_id integer NULL,
			si_time integer unsigned NOT NULL,
			si_code integer NOT NULL,
			PRIMARY KEY (si_session_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_member_tracking
		(
			mt_member_id integer NULL,
			mt_cache_username varchar(80) NOT NULL,
			mt_time integer unsigned NULL,
			mt_page varchar(80) NULL,
			mt_type varchar(80) NULL,
			mt_id varchar(80) NULL,
			PRIMARY KEY (mt_member_id,mt_time,mt_page,mt_type,mt_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_cache_on
		(
			cached_for varchar(80) NULL,
			cache_on longtext NOT NULL,
			cache_ttl integer NOT NULL,
			PRIMARY KEY (cached_for)
		) TYPE=InnoDB;

		CREATE TABLE cms10_validated_once
		(
			hash varchar(33) NULL,
			PRIMARY KEY (hash)
		) TYPE=InnoDB;

		CREATE TABLE cms10_edit_pings
		(
			id integer auto_increment NULL,
			the_page varchar(80) NOT NULL,
			the_type varchar(80) NOT NULL,
			the_id varchar(80) NOT NULL,
			the_time integer unsigned NOT NULL,
			the_member integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_translate_history
		(
			id integer auto_increment NULL,
			lang_id integer NOT NULL,
			language varchar(5) NULL,
			text_original longtext NOT NULL,
			broken tinyint(1) NOT NULL,
			action_member integer NOT NULL,
			action_time integer unsigned NOT NULL,
			PRIMARY KEY (id,language)
		) TYPE=InnoDB;

		CREATE TABLE cms10_long_values
		(
			the_name varchar(80) NULL,
			the_value longtext NOT NULL,
			date_and_time integer unsigned NOT NULL,
			PRIMARY KEY (the_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_tutorial_links
		(
			the_name varchar(80) NULL,
			the_value longtext NOT NULL,
			PRIMARY KEY (the_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_member_privileges
		(
			member_id integer NULL,
			privilege varchar(80) NULL,
			the_page varchar(80) NULL,
			module_the_name varchar(80) NULL,
			category_name varchar(80) NULL,
			the_value tinyint(1) NOT NULL,
			active_until integer unsigned NOT NULL,
			PRIMARY KEY (member_id,privilege,the_page,module_the_name,category_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_member_zone_access
		(
			zone_name varchar(80) NULL,
			member_id integer NULL,
			active_until integer unsigned NOT NULL,
			PRIMARY KEY (zone_name,member_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_member_page_access
		(
			page_name varchar(80) NULL,
			zone_name varchar(80) NULL,
			member_id integer NULL,
			active_until integer unsigned NOT NULL,
			PRIMARY KEY (page_name,zone_name,member_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_member_category_access
		(
			module_the_name varchar(80) NULL,
			category_name varchar(80) NULL,
			member_id integer NULL,
			active_until integer unsigned NOT NULL,
			PRIMARY KEY (module_the_name,category_name,member_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_autosave
		(
			id integer auto_increment NULL,
			a_member_id integer NOT NULL,
			a_key longtext NOT NULL,
			a_value longtext NOT NULL,
			a_time integer unsigned NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_messages_to_render
		(
			id integer auto_increment NULL,
			r_session_id integer NOT NULL,
			r_message longtext NOT NULL,
			r_type varchar(80) NOT NULL,
			r_time integer unsigned NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_url_title_cache
		(
			id integer auto_increment NULL,
			t_url varchar(255) NOT NULL,
			t_title varchar(255) NOT NULL,
			t_meta_title longtext NOT NULL,
			t_keywords longtext NOT NULL,
			t_description longtext NOT NULL,
			t_image_url varchar(255) NOT NULL,
			t_mime_type varchar(80) NOT NULL,
			t_json_discovery varchar(255) NOT NULL,
			t_xml_discovery varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_rating
		(
			id integer auto_increment NULL,
			rating_for_type varchar(80) NOT NULL,
			rating_for_id varchar(80) NOT NULL,
			rating_member integer NOT NULL,
			rating_ip varchar(40) NOT NULL,
			rating_time integer unsigned NOT NULL,
			rating tinyint NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_comcode_pages
		(
			the_zone varchar(80) NULL,
			the_page varchar(80) NULL,
			p_parent_page varchar(80) NOT NULL,
			p_validated tinyint(1) NOT NULL,
			p_edit_date integer unsigned NOT NULL,
			p_add_date integer unsigned NOT NULL,
			p_submitter integer NOT NULL,
			p_show_as_edit tinyint(1) NOT NULL,
			PRIMARY KEY (the_zone,the_page)
		) TYPE=InnoDB;

		CREATE TABLE cms10_cached_comcode_pages
		(
			the_zone varchar(80) NULL,
			the_page varchar(80) NULL,
			string_index integer NOT NULL,
			the_theme varchar(80) NULL,
			cc_page_title integer NOT NULL,
			PRIMARY KEY (the_zone,the_page,the_theme)
		) TYPE=InnoDB;

		CREATE TABLE cms10_url_id_monikers
		(
			id integer auto_increment NULL,
			m_resource_page varchar(80) NOT NULL,
			m_resource_type varchar(80) NOT NULL,
			m_resource_id varchar(80) NOT NULL,
			m_moniker varchar(255) NOT NULL,
			m_deprecated tinyint(1) NOT NULL,
			m_manually_chosen tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_review_supplement
		(
			r_post_id integer NULL,
			r_rating_type varchar(80) NULL,
			r_rating tinyint NOT NULL,
			r_topic_id integer NOT NULL,
			r_rating_for_id varchar(80) NOT NULL,
			r_rating_for_type varchar(80) NOT NULL,
			PRIMARY KEY (r_post_id,r_rating_type)
		) TYPE=InnoDB;

		CREATE TABLE cms10_logged_mail_messages
		(
			id integer auto_increment NULL,
			m_subject longtext NOT NULL,
			m_message longtext NOT NULL,
			m_to_email longtext NOT NULL,
			m_extra_cc_addresses longtext NOT NULL,
			m_extra_bcc_addresses longtext NOT NULL,
			m_to_name longtext NOT NULL,
			m_from_email varchar(255) NOT NULL,
			m_from_name varchar(255) NOT NULL,
			m_priority tinyint NOT NULL,
			m_attachments longtext NOT NULL,
			m_no_cc tinyint(1) NOT NULL,
			m_as integer NOT NULL,
			m_as_admin tinyint(1) NOT NULL,
			m_in_html tinyint(1) NOT NULL,
			m_date_and_time integer unsigned NOT NULL,
			m_member_id integer NOT NULL,
			m_url longtext NOT NULL,
			m_queued tinyint(1) NOT NULL,
			m_template varchar(80) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_link_tracker
		(
			id integer auto_increment NULL,
			c_date_and_time integer unsigned NOT NULL,
			c_member_id integer NOT NULL,
			c_ip_address varchar(40) NOT NULL,
			c_url varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_incoming_uploads
		(
			id integer auto_increment NULL,
			i_submitter integer NOT NULL,
			i_date_and_time integer unsigned NOT NULL,
			i_orig_filename varchar(255) NOT NULL,
			i_save_url varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_cache
		(
			cached_for varchar(80) NULL,
			identifier varchar(40) NULL,
			the_value longtext NOT NULL,
			date_and_time integer unsigned NOT NULL,
			the_theme varchar(80) NULL,
			lang varchar(5) NULL,
			dependencies longtext NOT NULL,
			PRIMARY KEY (cached_for,identifier,the_theme,lang)
		) TYPE=InnoDB;

		CREATE TABLE cms10_f_group_member_timeouts
		(
			member_id integer NULL,
			group_id integer NULL,
			timeout integer unsigned NOT NULL,
			PRIMARY KEY (member_id,group_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_temp_block_permissions
		(
			id integer auto_increment NULL,
			p_session_id integer NOT NULL,
			p_block_constraints longtext NOT NULL,
			p_time integer unsigned NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_cron_caching_requests
		(
			id integer auto_increment NULL,
			c_codename varchar(80) NOT NULL,
			c_map longtext NOT NULL,
			c_timezone varchar(80) NOT NULL,
			c_is_bot tinyint(1) NOT NULL,
			c_store_as_tempcode tinyint(1) NOT NULL,
			c_lang varchar(5) NOT NULL,
			c_theme varchar(80) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_notifications_enabled
		(
			l_member_id integer NOT NULL,
			l_notification_code varchar(80) NOT NULL,
			l_code_category varchar(255) NOT NULL,
			l_setting integer NOT NULL,
			id integer auto_increment NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_digestives_tin
		(
			d_subject longtext NOT NULL,
			id integer auto_increment NULL,
			d_message integer NOT NULL,
			d_from_member_id integer NOT NULL,
			d_to_member_id integer NOT NULL,
			d_priority tinyint NOT NULL,
			d_no_cc tinyint(1) NOT NULL,
			d_date_and_time integer unsigned NOT NULL,
			d_notification_code varchar(80) NOT NULL,
			d_code_category varchar(255) NOT NULL,
			d_frequency integer NOT NULL,
			d_read tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_digestives_consumed
		(
			c_member_id integer NULL,
			c_frequency integer NULL,
			c_time integer unsigned NOT NULL,
			PRIMARY KEY (c_member_id,c_frequency)
		) TYPE=InnoDB;

		CREATE TABLE cms10_alternative_ids
		(
			resource_resourcefs_hook varchar(80) NOT NULL,
			resource_label varchar(255) NOT NULL,
			resource_guid varchar(80) NOT NULL,
			resource_type varchar(80) NULL,
			resource_id varchar(80) NULL,
			resource_moniker varchar(80) NOT NULL,
			PRIMARY KEY (resource_type,resource_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_content_privacy
		(
			content_id varchar(80) NULL,
			content_type varchar(80) NULL,
			guest_view tinyint(1) NOT NULL,
			member_view tinyint(1) NOT NULL,
			friend_view tinyint(1) NOT NULL,
			PRIMARY KEY (content_id,content_type)
		) TYPE=InnoDB;

		CREATE TABLE cms10_content_primary__members
		(
			content_type varchar(80) NULL,
			content_id varchar(80) NULL,
			member_id integer NULL,
			PRIMARY KEY (content_type,content_id,member_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_task_queue
		(
			id integer auto_increment NULL,
			t_title varchar(255) NOT NULL,
			t_hook varchar(80) NOT NULL,
			t_args longtext NOT NULL,
			t_member_id integer NOT NULL,
			t_secure_ref varchar(80) NOT NULL,
			t_send_notification tinyint(1) NOT NULL,
			t_locked tinyint(1) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_failedlogins
		(
			id integer auto_increment NULL,
			failed_account varchar(80) NOT NULL,
			date_and_time integer unsigned NOT NULL,
			ip varchar(40) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_group_zone_access
		(
			zone_name varchar(80) NULL,
			group_id integer NULL,
			PRIMARY KEY (zone_name,group_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_group_page_access
		(
			zone_name varchar(80) NULL,
			group_id integer NULL,
			page_name varchar(80) NULL,
			PRIMARY KEY (zone_name,group_id,page_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_attachments
		(
			id integer auto_increment NULL,
			a_member_id integer NOT NULL,
			a_file_size integer NOT NULL,
			a_url varchar(255) NOT NULL,
			a_description varchar(255) NOT NULL,
			a_thumb_url varchar(255) NOT NULL,
			a_original_filename varchar(255) NOT NULL,
			a_num_downloads integer NOT NULL,
			a_last_downloaded_time integer NOT NULL,
			a_add_time integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_attachment_refs
		(
			id integer auto_increment NULL,
			r_referer_type varchar(80) NOT NULL,
			r_referer_id varchar(80) NOT NULL,
			a_id integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_bank
		(
			member_id integer NOT NULL,
			amount integer NOT NULL,
			id integer auto_increment NULL,
			add_time integer unsigned NOT NULL,
			dividend integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_blocks
		(
			block_name varchar(80) NULL,
			block_author varchar(80) NOT NULL,
			block_organisation varchar(80) NOT NULL,
			block_hacked_by varchar(80) NOT NULL,
			block_hack_version integer NOT NULL,
			block_version integer NOT NULL,
			PRIMARY KEY (block_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_config
		(
			c_name varchar(80) NULL,
			c_set tinyint(1) NOT NULL,
			c_value longtext NOT NULL,
			c_needs_dereference tinyint(1) NOT NULL,
			PRIMARY KEY (c_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_group_category_access
		(
			module_the_name varchar(80) NULL,
			category_name varchar(80) NULL,
			group_id integer NULL,
			PRIMARY KEY (module_the_name,category_name,group_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_group_points
		(
			p_group_id integer NULL,
			p_points_one_off integer NOT NULL,
			p_points_per_month integer NOT NULL,
			PRIMARY KEY (p_group_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_group_privileges
		(
			group_id integer NULL,
			privilege varchar(80) NULL,
			the_page varchar(80) NULL,
			module_the_name varchar(80) NULL,
			category_name varchar(80) NULL,
			the_value tinyint(1) NOT NULL,
			PRIMARY KEY (group_id,privilege,the_page,module_the_name,category_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_https_pages
		(
			https_page_name varchar(80) NULL,
			PRIMARY KEY (https_page_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_locations
		(
			id integer auto_increment NULL,
			l_place varchar(255) NOT NULL,
			l_type varchar(80) NOT NULL,
			l_continent varchar(80) NOT NULL,
			l_country varchar(80) NOT NULL,
			l_parent_1 varchar(80) NOT NULL,
			l_parent_2 varchar(80) NOT NULL,
			l_population integer NOT NULL,
			l_parent_3 varchar(80) NOT NULL,
			l_latitude real NOT NULL,
			l_longitude real NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_members_mentors
		(
			member_id integer NULL,
			id integer auto_increment NULL,
			mentor_id integer NULL,
			PRIMARY KEY (member_id,id,mentor_id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_modules
		(
			module_the_name varchar(80) NULL,
			module_author varchar(80) NOT NULL,
			module_organisation varchar(80) NOT NULL,
			module_hacked_by varchar(80) NOT NULL,
			module_hack_version integer NOT NULL,
			module_version integer NOT NULL,
			PRIMARY KEY (module_the_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_privilege_list
		(
			p_section varchar(80) NOT NULL,
			the_name varchar(80) NULL,
			the_default tinyint(1) NULL,
			PRIMARY KEY (the_name,the_default)
		) TYPE=InnoDB;

		CREATE TABLE cms10_referees_qualified_for
		(
			id integer auto_increment NULL,
			q_referee integer NOT NULL,
			q_referrer integer NOT NULL,
			q_scheme_name varchar(80) NOT NULL,
			q_email_address varchar(255) NOT NULL,
			q_time integer unsigned NOT NULL,
			q_action varchar(80) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_referrer_override
		(
			o_referrer integer NULL,
			o_scheme_name varchar(80) NULL,
			o_referrals_dif integer NOT NULL,
			o_is_qualified tinyint(1) NOT NULL,
			PRIMARY KEY (o_referrer,o_scheme_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_seo_meta
		(
			id integer auto_increment NULL,
			meta_for_type varchar(80) NOT NULL,
			meta_for_id varchar(80) NOT NULL,
			meta_keywords integer NOT NULL,
			meta_description integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_sessions
		(
			the_session integer NULL,
			last_activity integer unsigned NOT NULL,
			member_id integer NOT NULL,
			ip varchar(40) NOT NULL,
			session_confirmed tinyint(1) NOT NULL,
			session_invisible tinyint(1) NOT NULL,
			cache_username varchar(255) NOT NULL,
			the_zone varchar(80) NOT NULL,
			the_page varchar(80) NOT NULL,
			the_type varchar(80) NOT NULL,
			the_id varchar(80) NOT NULL,
			the_title varchar(255) NOT NULL,
			PRIMARY KEY (the_session)
		) TYPE=InnoDB;

		CREATE TABLE cms10_sms_log
		(
			s_time integer unsigned NOT NULL,
			s_member_id integer NOT NULL,
			s_trigger_ip varchar(40) NOT NULL,
			id integer auto_increment NULL,
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

		CREATE TABLE cms10_values
		(
			the_name varchar(80) NULL,
			the_value varchar(255) NOT NULL,
			date_and_time integer unsigned NOT NULL,
			PRIMARY KEY (the_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_zones
		(
			zone_name varchar(80) NULL,
			zone_title integer NOT NULL,
			zone_default_page varchar(80) NOT NULL,
			zone_header_text integer NOT NULL,
			zone_theme varchar(80) NOT NULL,
			zone_require_session tinyint(1) NOT NULL,
			PRIMARY KEY (zone_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_anything
		(
			id varchar(80) NULL,
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


		CREATE INDEX `menu_items.i_parent` ON cms10_menu_items(i_parent);
		ALTER TABLE cms10_menu_items ADD FOREIGN KEY `menu_items.i_parent` (i_parent) REFERENCES cms10_menu_items (id);

		CREATE INDEX `menu_items.i_caption` ON cms10_menu_items(i_caption);
		ALTER TABLE cms10_menu_items ADD FOREIGN KEY `menu_items.i_caption` (i_caption) REFERENCES cms10_translate (id);

		CREATE INDEX `menu_items.i_caption_long` ON cms10_menu_items(i_caption_long);
		ALTER TABLE cms10_menu_items ADD FOREIGN KEY `menu_items.i_caption_long` (i_caption_long) REFERENCES cms10_translate (id);

		CREATE INDEX `trackbacks.trackback_for_id` ON cms10_trackbacks(trackback_for_id);
		ALTER TABLE cms10_trackbacks ADD FOREIGN KEY `trackbacks.trackback_for_id` (trackback_for_id) REFERENCES cms10_anything (id);

		CREATE INDEX `member_tracking.mt_member_id` ON cms10_member_tracking(mt_member_id);
		ALTER TABLE cms10_member_tracking ADD FOREIGN KEY `member_tracking.mt_member_id` (mt_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `edit_pings.the_member` ON cms10_edit_pings(the_member);
		ALTER TABLE cms10_edit_pings ADD FOREIGN KEY `edit_pings.the_member` (the_member) REFERENCES cms10_f_members (id);

		CREATE INDEX `translate_history.lang_id` ON cms10_translate_history(lang_id);
		ALTER TABLE cms10_translate_history ADD FOREIGN KEY `translate_history.lang_id` (lang_id) REFERENCES cms10_translate (id);

		CREATE INDEX `translate_history.action_member` ON cms10_translate_history(action_member);
		ALTER TABLE cms10_translate_history ADD FOREIGN KEY `translate_history.action_member` (action_member) REFERENCES cms10_f_members (id);

		CREATE INDEX `member_privileges.privilege` ON cms10_member_privileges(privilege);
		ALTER TABLE cms10_member_privileges ADD FOREIGN KEY `member_privileges.privilege` (privilege) REFERENCES cms10_privilege_list (the_name);

		CREATE INDEX `member_privileges.the_page` ON cms10_member_privileges(the_page);
		ALTER TABLE cms10_member_privileges ADD FOREIGN KEY `member_privileges.the_page` (the_page) REFERENCES cms10_modules (module_the_name);

		CREATE INDEX `member_privileges.category_name` ON cms10_member_privileges(category_name);
		ALTER TABLE cms10_member_privileges ADD FOREIGN KEY `member_privileges.category_name` (category_name) REFERENCES cms10_anything (id);

		CREATE INDEX `member_zone_access.zone_name` ON cms10_member_zone_access(zone_name);
		ALTER TABLE cms10_member_zone_access ADD FOREIGN KEY `member_zone_access.zone_name` (zone_name) REFERENCES cms10_zones (zone_name);

		CREATE INDEX `member_zone_access.member_id` ON cms10_member_zone_access(member_id);
		ALTER TABLE cms10_member_zone_access ADD FOREIGN KEY `member_zone_access.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `member_page_access.page_name` ON cms10_member_page_access(page_name);
		ALTER TABLE cms10_member_page_access ADD FOREIGN KEY `member_page_access.page_name` (page_name) REFERENCES cms10_modules (module_the_name);

		CREATE INDEX `member_page_access.zone_name` ON cms10_member_page_access(zone_name);
		ALTER TABLE cms10_member_page_access ADD FOREIGN KEY `member_page_access.zone_name` (zone_name) REFERENCES cms10_zones (zone_name);

		CREATE INDEX `member_page_access.member_id` ON cms10_member_page_access(member_id);
		ALTER TABLE cms10_member_page_access ADD FOREIGN KEY `member_page_access.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `member_category_access.category_name` ON cms10_member_category_access(category_name);
		ALTER TABLE cms10_member_category_access ADD FOREIGN KEY `member_category_access.category_name` (category_name) REFERENCES cms10_anything (id);

		CREATE INDEX `member_category_access.member_id` ON cms10_member_category_access(member_id);
		ALTER TABLE cms10_member_category_access ADD FOREIGN KEY `member_category_access.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `autosave.a_member_id` ON cms10_autosave(a_member_id);
		ALTER TABLE cms10_autosave ADD FOREIGN KEY `autosave.a_member_id` (a_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `messages_to_render.r_session_id` ON cms10_messages_to_render(r_session_id);
		ALTER TABLE cms10_messages_to_render ADD FOREIGN KEY `messages_to_render.r_session_id` (r_session_id) REFERENCES cms10_sessions (the_session);

		CREATE INDEX `rating.rating_for_id` ON cms10_rating(rating_for_id);
		ALTER TABLE cms10_rating ADD FOREIGN KEY `rating.rating_for_id` (rating_for_id) REFERENCES cms10_modules (module_the_name);

		CREATE INDEX `rating.rating_member` ON cms10_rating(rating_member);
		ALTER TABLE cms10_rating ADD FOREIGN KEY `rating.rating_member` (rating_member) REFERENCES cms10_f_members (id);

		CREATE INDEX `comcode_pages.p_submitter` ON cms10_comcode_pages(p_submitter);
		ALTER TABLE cms10_comcode_pages ADD FOREIGN KEY `comcode_pages.p_submitter` (p_submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `cached_comcode_pages.the_zone` ON cms10_cached_comcode_pages(the_zone);
		ALTER TABLE cms10_cached_comcode_pages ADD FOREIGN KEY `cached_comcode_pages.the_zone` (the_zone) REFERENCES cms10_zones (zone_name);

		CREATE INDEX `cached_comcode_pages.string_index` ON cms10_cached_comcode_pages(string_index);
		ALTER TABLE cms10_cached_comcode_pages ADD FOREIGN KEY `cached_comcode_pages.string_index` (string_index) REFERENCES cms10_translate (id);

		CREATE INDEX `cached_comcode_pages.cc_page_title` ON cms10_cached_comcode_pages(cc_page_title);
		ALTER TABLE cms10_cached_comcode_pages ADD FOREIGN KEY `cached_comcode_pages.cc_page_title` (cc_page_title) REFERENCES cms10_translate (id);

		CREATE INDEX `url_id_monikers.m_resource_id` ON cms10_url_id_monikers(m_resource_id);
		ALTER TABLE cms10_url_id_monikers ADD FOREIGN KEY `url_id_monikers.m_resource_id` (m_resource_id) REFERENCES cms10_anything (id);

		CREATE INDEX `review_supplement.r_post_id` ON cms10_review_supplement(r_post_id);
		ALTER TABLE cms10_review_supplement ADD FOREIGN KEY `review_supplement.r_post_id` (r_post_id) REFERENCES cms10_f_posts (id);

		CREATE INDEX `review_supplement.r_topic_id` ON cms10_review_supplement(r_topic_id);
		ALTER TABLE cms10_review_supplement ADD FOREIGN KEY `review_supplement.r_topic_id` (r_topic_id) REFERENCES cms10_f_topics (id);

		CREATE INDEX `review_supplement.r_rating_for_id` ON cms10_review_supplement(r_rating_for_id);
		ALTER TABLE cms10_review_supplement ADD FOREIGN KEY `review_supplement.r_rating_for_id` (r_rating_for_id) REFERENCES cms10_modules (module_the_name);

		CREATE INDEX `logged_mail_messages.m_as` ON cms10_logged_mail_messages(m_as);
		ALTER TABLE cms10_logged_mail_messages ADD FOREIGN KEY `logged_mail_messages.m_as` (m_as) REFERENCES cms10_f_members (id);

		CREATE INDEX `logged_mail_messages.m_member_id` ON cms10_logged_mail_messages(m_member_id);
		ALTER TABLE cms10_logged_mail_messages ADD FOREIGN KEY `logged_mail_messages.m_member_id` (m_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `link_tracker.c_member_id` ON cms10_link_tracker(c_member_id);
		ALTER TABLE cms10_link_tracker ADD FOREIGN KEY `link_tracker.c_member_id` (c_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `incoming_uploads.i_submitter` ON cms10_incoming_uploads(i_submitter);
		ALTER TABLE cms10_incoming_uploads ADD FOREIGN KEY `incoming_uploads.i_submitter` (i_submitter) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_group_member_timeouts.member_id` ON cms10_f_group_member_timeouts(member_id);
		ALTER TABLE cms10_f_group_member_timeouts ADD FOREIGN KEY `f_group_member_timeouts.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_group_member_timeouts.group_id` ON cms10_f_group_member_timeouts(group_id);
		ALTER TABLE cms10_f_group_member_timeouts ADD FOREIGN KEY `f_group_member_timeouts.group_id` (group_id) REFERENCES cms10_f_groups (id);

		CREATE INDEX `temp_block_permissions.p_session_id` ON cms10_temp_block_permissions(p_session_id);
		ALTER TABLE cms10_temp_block_permissions ADD FOREIGN KEY `temp_block_permissions.p_session_id` (p_session_id) REFERENCES cms10_sessions (id);

		CREATE INDEX `notifications_enabled.l_member_id` ON cms10_notifications_enabled(l_member_id);
		ALTER TABLE cms10_notifications_enabled ADD FOREIGN KEY `notifications_enabled.l_member_id` (l_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `digestives_tin.d_message` ON cms10_digestives_tin(d_message);
		ALTER TABLE cms10_digestives_tin ADD FOREIGN KEY `digestives_tin.d_message` (d_message) REFERENCES cms10_translate (id);

		CREATE INDEX `digestives_tin.d_from_member_id` ON cms10_digestives_tin(d_from_member_id);
		ALTER TABLE cms10_digestives_tin ADD FOREIGN KEY `digestives_tin.d_from_member_id` (d_from_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `digestives_tin.d_to_member_id` ON cms10_digestives_tin(d_to_member_id);
		ALTER TABLE cms10_digestives_tin ADD FOREIGN KEY `digestives_tin.d_to_member_id` (d_to_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `digestives_consumed.c_member_id` ON cms10_digestives_consumed(c_member_id);
		ALTER TABLE cms10_digestives_consumed ADD FOREIGN KEY `digestives_consumed.c_member_id` (c_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `content_primary__members.member_id` ON cms10_content_primary__members(member_id);
		ALTER TABLE cms10_content_primary__members ADD FOREIGN KEY `content_primary__members.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `task_queue.t_member_id` ON cms10_task_queue(t_member_id);
		ALTER TABLE cms10_task_queue ADD FOREIGN KEY `task_queue.t_member_id` (t_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `group_zone_access.zone_name` ON cms10_group_zone_access(zone_name);
		ALTER TABLE cms10_group_zone_access ADD FOREIGN KEY `group_zone_access.zone_name` (zone_name) REFERENCES cms10_zones (zone_name);

		CREATE INDEX `group_zone_access.group_id` ON cms10_group_zone_access(group_id);
		ALTER TABLE cms10_group_zone_access ADD FOREIGN KEY `group_zone_access.group_id` (group_id) REFERENCES cms10_f_groups (id);

		CREATE INDEX `group_page_access.zone_name` ON cms10_group_page_access(zone_name);
		ALTER TABLE cms10_group_page_access ADD FOREIGN KEY `group_page_access.zone_name` (zone_name) REFERENCES cms10_zones (zone_name);

		CREATE INDEX `group_page_access.group_id` ON cms10_group_page_access(group_id);
		ALTER TABLE cms10_group_page_access ADD FOREIGN KEY `group_page_access.group_id` (group_id) REFERENCES cms10_f_groups (id);

		CREATE INDEX `attachments.a_member_id` ON cms10_attachments(a_member_id);
		ALTER TABLE cms10_attachments ADD FOREIGN KEY `attachments.a_member_id` (a_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `attachment_refs.r_referer_id` ON cms10_attachment_refs(r_referer_id);
		ALTER TABLE cms10_attachment_refs ADD FOREIGN KEY `attachment_refs.r_referer_id` (r_referer_id) REFERENCES cms10_anything (id);

		CREATE INDEX `attachment_refs.a_id` ON cms10_attachment_refs(a_id);
		ALTER TABLE cms10_attachment_refs ADD FOREIGN KEY `attachment_refs.a_id` (a_id) REFERENCES cms10_attachments (id);

		CREATE INDEX `bank.member_id` ON cms10_bank(member_id);
		ALTER TABLE cms10_bank ADD FOREIGN KEY `bank.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `group_category_access.category_name` ON cms10_group_category_access(category_name);
		ALTER TABLE cms10_group_category_access ADD FOREIGN KEY `group_category_access.category_name` (category_name) REFERENCES cms10_anything (id);

		CREATE INDEX `group_category_access.group_id` ON cms10_group_category_access(group_id);
		ALTER TABLE cms10_group_category_access ADD FOREIGN KEY `group_category_access.group_id` (group_id) REFERENCES cms10_f_groups (id);

		CREATE INDEX `group_points.p_group_id` ON cms10_group_points(p_group_id);
		ALTER TABLE cms10_group_points ADD FOREIGN KEY `group_points.p_group_id` (p_group_id) REFERENCES cms10_f_groups (id);

		CREATE INDEX `group_privileges.privilege` ON cms10_group_privileges(privilege);
		ALTER TABLE cms10_group_privileges ADD FOREIGN KEY `group_privileges.privilege` (privilege) REFERENCES cms10_privilege_list (the_name);

		CREATE INDEX `group_privileges.the_page` ON cms10_group_privileges(the_page);
		ALTER TABLE cms10_group_privileges ADD FOREIGN KEY `group_privileges.the_page` (the_page) REFERENCES cms10_modules (module_the_name);

		CREATE INDEX `group_privileges.category_name` ON cms10_group_privileges(category_name);
		ALTER TABLE cms10_group_privileges ADD FOREIGN KEY `group_privileges.category_name` (category_name) REFERENCES cms10_anything (id);

		CREATE INDEX `referees_qualified_for.q_referee` ON cms10_referees_qualified_for(q_referee);
		ALTER TABLE cms10_referees_qualified_for ADD FOREIGN KEY `referees_qualified_for.q_referee` (q_referee) REFERENCES cms10_f_members (id);

		CREATE INDEX `referees_qualified_for.q_referrer` ON cms10_referees_qualified_for(q_referrer);
		ALTER TABLE cms10_referees_qualified_for ADD FOREIGN KEY `referees_qualified_for.q_referrer` (q_referrer) REFERENCES cms10_f_members (id);

		CREATE INDEX `referrer_override.o_referrer` ON cms10_referrer_override(o_referrer);
		ALTER TABLE cms10_referrer_override ADD FOREIGN KEY `referrer_override.o_referrer` (o_referrer) REFERENCES cms10_f_members (id);

		CREATE INDEX `seo_meta.meta_for_id` ON cms10_seo_meta(meta_for_id);
		ALTER TABLE cms10_seo_meta ADD FOREIGN KEY `seo_meta.meta_for_id` (meta_for_id) REFERENCES cms10_anything (id);

		CREATE INDEX `seo_meta.meta_keywords` ON cms10_seo_meta(meta_keywords);
		ALTER TABLE cms10_seo_meta ADD FOREIGN KEY `seo_meta.meta_keywords` (meta_keywords) REFERENCES cms10_translate (id);

		CREATE INDEX `seo_meta.meta_description` ON cms10_seo_meta(meta_description);
		ALTER TABLE cms10_seo_meta ADD FOREIGN KEY `seo_meta.meta_description` (meta_description) REFERENCES cms10_translate (id);

		CREATE INDEX `sessions.member_id` ON cms10_sessions(member_id);
		ALTER TABLE cms10_sessions ADD FOREIGN KEY `sessions.member_id` (member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `sms_log.s_member_id` ON cms10_sms_log(s_member_id);
		ALTER TABLE cms10_sms_log ADD FOREIGN KEY `sms_log.s_member_id` (s_member_id) REFERENCES cms10_f_members (id);

		CREATE INDEX `translate.source_user` ON cms10_translate(source_user);
		ALTER TABLE cms10_translate ADD FOREIGN KEY `translate.source_user` (source_user) REFERENCES cms10_f_members (id);

		CREATE INDEX `zones.zone_title` ON cms10_zones(zone_title);
		ALTER TABLE cms10_zones ADD FOREIGN KEY `zones.zone_title` (zone_title) REFERENCES cms10_translate (id);

		CREATE INDEX `zones.zone_header_text` ON cms10_zones(zone_header_text);
		ALTER TABLE cms10_zones ADD FOREIGN KEY `zones.zone_header_text` (zone_header_text) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_signature` ON cms10_f_members(m_signature);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_signature` (m_signature) REFERENCES cms10_translate (id);

		CREATE INDEX `f_members.m_primary_group` ON cms10_f_members(m_primary_group);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_primary_group` (m_primary_group) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_members.m_pt_rules_text` ON cms10_f_members(m_pt_rules_text);
		ALTER TABLE cms10_f_members ADD FOREIGN KEY `f_members.m_pt_rules_text` (m_pt_rules_text) REFERENCES cms10_translate (id);

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

		CREATE INDEX `f_groups.g_promotion_target` ON cms10_f_groups(g_promotion_target);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_promotion_target` (g_promotion_target) REFERENCES cms10_f_groups (id);

		CREATE INDEX `f_groups.g_name` ON cms10_f_groups(g_name);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_name` (g_name) REFERENCES cms10_translate (id);

		CREATE INDEX `f_groups.g_group_leader` ON cms10_f_groups(g_group_leader);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_group_leader` (g_group_leader) REFERENCES cms10_f_members (id);

		CREATE INDEX `f_groups.g_title` ON cms10_f_groups(g_title);
		ALTER TABLE cms10_f_groups ADD FOREIGN KEY `f_groups.g_title` (g_title) REFERENCES cms10_translate (id);

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
