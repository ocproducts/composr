DROP TABLE IF EXISTS `cms_f_polls`;
CREATE TABLE IF NOT EXISTS `cms_f_polls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `po_question` varchar(255) NOT NULL,
  `po_cache_total_votes` int(11) NOT NULL,
  `po_is_private` tinyint(1) NOT NULL,
  `po_is_open` tinyint(1) NOT NULL,
  `po_minimum_selections` int(11) NOT NULL,
  `po_maximum_selections` int(11) NOT NULL,
  `po_requires_reply` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_polls`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_poll_answers`
--

DROP TABLE IF EXISTS `cms_f_poll_answers`;
CREATE TABLE IF NOT EXISTS `cms_f_poll_answers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `pa_poll_id` int(11) NOT NULL,
  `pa_answer` varchar(255) NOT NULL,
  `pa_cache_num_votes` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_poll_answers`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_poll_votes`
--

DROP TABLE IF EXISTS `cms_f_poll_votes`;
CREATE TABLE IF NOT EXISTS `cms_f_poll_votes` (
  `pv_poll_id` int(11) NOT NULL,
  `pv_member_id` int(11) NOT NULL,
  `pv_answer_id` int(11) NOT NULL,
  PRIMARY KEY (`pv_poll_id`,`pv_member_id`,`pv_answer_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_poll_votes`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_posts`
--

DROP TABLE IF EXISTS `cms_f_posts`;
CREATE TABLE IF NOT EXISTS `cms_f_posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `p_title` varchar(255) NOT NULL,
  `p_post` int(10) unsigned NOT NULL,
  `p_ip_address` varchar(40) NOT NULL,
  `p_time` int(10) unsigned NOT NULL,
  `p_poster` int(11) NOT NULL,
  `p_intended_solely_for` int(11) DEFAULT NULL,
  `p_poster_name_if_guest` varchar(80) NOT NULL,
  `p_validated` tinyint(1) NOT NULL,
  `p_topic_id` int(11) NOT NULL,
  `p_cache_forum_id` int(11) DEFAULT NULL,
  `p_last_edit_time` int(10) unsigned DEFAULT NULL,
  `p_last_edit_by` int(11) DEFAULT NULL,
  `p_is_emphasised` tinyint(1) NOT NULL,
  `p_skip_sig` tinyint(1) NOT NULL,
  `p_parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `p_validated` (`p_validated`),
  KEY `in_topic` (`p_topic_id`,`p_time`,`id`),
  KEY `post_order_time` (`p_time`,`id`),
  KEY `p_last_edit_time` (`p_last_edit_time`),
  KEY `posts_by` (`p_poster`),
  KEY `find_pp` (`p_intended_solely_for`),
  KEY `search_join` (`p_post`),
  KEY `postsinforum` (`p_cache_forum_id`),
  KEY `deletebyip` (`p_ip_address`),
  FULLTEXT KEY `p_title` (`p_title`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_f_posts`
--

INSERT INTO `cms_f_posts` (`id`, `p_title`, `p_post`, `p_ip_address`, `p_time`, `p_poster`, `p_intended_solely_for`, `p_poster_name_if_guest`, `p_validated`, `p_topic_id`, `p_cache_forum_id`, `p_last_edit_time`, `p_last_edit_by`, `p_is_emphasised`, `p_skip_sig`, `p_parent_id`) VALUES(1, 'Welcome to the forums', 82, '127.0.0.1', 1344775582, 1, NULL, 'System', 1, 1, 7, NULL, NULL, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_post_history`
--

DROP TABLE IF EXISTS `cms_f_post_history`;
CREATE TABLE IF NOT EXISTS `cms_f_post_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `h_create_date_and_time` int(10) unsigned NOT NULL,
  `h_action_date_and_time` int(10) unsigned NOT NULL,
  `h_owner_member_id` int(11) NOT NULL,
  `h_alterer_member_id` int(11) NOT NULL,
  `h_post_id` int(11) NOT NULL,
  `h_topic_id` int(11) NOT NULL,
  `h_before` longtext NOT NULL,
  `h_action` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `phistorylookup` (`h_post_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_post_history`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_post_templates`
--

DROP TABLE IF EXISTS `cms_f_post_templates`;
CREATE TABLE IF NOT EXISTS `cms_f_post_templates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `t_title` varchar(255) NOT NULL,
  `t_text` longtext NOT NULL,
  `t_forum_multi_code` varchar(255) NOT NULL,
  `t_use_default_forums` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=4 ;

--
-- Dumping data for table `cms_f_post_templates`
--

INSERT INTO `cms_f_post_templates` (`id`, `t_title`, `t_text`, `t_forum_multi_code`, `t_use_default_forums`) VALUES(1, 'Bug report', 'Version: ?\nSupport software environment (operating system, etc.):\n?\n\nAssigned to: ?\nSeverity: ?\nExample URL: ?\nDescription:\n?\n\nSteps for reproduction:\n?\n\n', '', 0);
INSERT INTO `cms_f_post_templates` (`id`, `t_title`, `t_text`, `t_forum_multi_code`, `t_use_default_forums`) VALUES(2, 'Task', 'Assigned to: ?\nPriority/Timescale: ?\nDescription:\n?\n\n', '', 0);
INSERT INTO `cms_f_post_templates` (`id`, `t_title`, `t_text`, `t_forum_multi_code`, `t_use_default_forums`) VALUES(3, 'Fault', 'Version: ?\nAssigned to: ?\nSeverity/Timescale: ?\nDescription:\n?\n\nSteps for reproduction:\n?\n\n', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_read_logs`
--

DROP TABLE IF EXISTS `cms_f_read_logs`;
CREATE TABLE IF NOT EXISTS `cms_f_read_logs` (
  `l_member_id` int(11) NOT NULL,
  `l_topic_id` int(11) NOT NULL,
  `l_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`l_member_id`,`l_topic_id`),
  KEY `erase_old_read_logs` (`l_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_read_logs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_saved_warnings`
--

DROP TABLE IF EXISTS `cms_f_saved_warnings`;
CREATE TABLE IF NOT EXISTS `cms_f_saved_warnings` (
  `s_title` varchar(255) NOT NULL,
  `s_explanation` longtext NOT NULL,
  `s_message` longtext NOT NULL,
  PRIMARY KEY (`s_title`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_saved_warnings`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_special_pt_access`
--

DROP TABLE IF EXISTS `cms_f_special_pt_access`;
CREATE TABLE IF NOT EXISTS `cms_f_special_pt_access` (
  `s_member_id` int(11) NOT NULL,
  `s_topic_id` int(11) NOT NULL,
  PRIMARY KEY (`s_member_id`,`s_topic_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_special_pt_access`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_topics`
--

DROP TABLE IF EXISTS `cms_f_topics`;
CREATE TABLE IF NOT EXISTS `cms_f_topics` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `t_pinned` tinyint(1) NOT NULL,
  `t_sunk` tinyint(1) NOT NULL,
  `t_cascading` tinyint(1) NOT NULL,
  `t_forum_id` int(11) DEFAULT NULL,
  `t_pt_from` int(11) DEFAULT NULL,
  `t_pt_to` int(11) DEFAULT NULL,
  `t_pt_from_category` varchar(255) NOT NULL,
  `t_pt_to_category` varchar(255) NOT NULL,
  `t_description` varchar(255) NOT NULL,
  `t_description_link` varchar(255) NOT NULL,
  `t_emoticon` varchar(255) NOT NULL,
  `t_num_views` int(11) NOT NULL,
  `t_validated` tinyint(1) NOT NULL,
  `t_is_open` tinyint(1) NOT NULL,
  `t_poll_id` int(11) DEFAULT NULL,
  `t_cache_first_post_id` int(11) DEFAULT NULL,
  `t_cache_first_time` int(10) unsigned DEFAULT NULL,
  `t_cache_first_title` varchar(255) NOT NULL,
  `t_cache_first_post` int(10) unsigned DEFAULT NULL,
  `t_cache_first_username` varchar(80) NOT NULL,
  `t_cache_first_member_id` int(11) DEFAULT NULL,
  `t_cache_last_post_id` int(11) DEFAULT NULL,
  `t_cache_last_time` int(10) unsigned DEFAULT NULL,
  `t_cache_last_title` varchar(255) NOT NULL,
  `t_cache_last_username` varchar(80) NOT NULL,
  `t_cache_last_member_id` int(11) DEFAULT NULL,
  `t_cache_num_posts` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `t_num_views` (`t_num_views`),
  KEY `t_pt_to` (`t_pt_to`),
  KEY `t_pt_from` (`t_pt_from`),
  KEY `t_validated` (`t_validated`),
  KEY `in_forum` (`t_forum_id`),
  KEY `topic_order_time` (`t_cache_last_time`),
  KEY `topic_order_time_2` (`t_cache_first_time`),
  KEY `descriptionsearch` (`t_description`),
  KEY `forumlayer` (`t_cache_first_title`),
  KEY `t_cascading` (`t_cascading`),
  KEY `t_cascading_or_forum` (`t_cascading`,`t_forum_id`),
  KEY `topic_order` (`t_cascading`,`t_pinned`,`t_cache_last_time`),
  KEY `topic_order_2` (`t_forum_id`,`t_cascading`,`t_pinned`,`t_sunk`,`t_cache_last_time`),
  KEY `topic_order_3` (`t_forum_id`,`t_cascading`,`t_pinned`,`t_cache_last_time`),
  KEY `ownedtopics` (`t_cache_first_member_id`),
  FULLTEXT KEY `t_description` (`t_description`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_f_topics`
--

INSERT INTO `cms_f_topics` (`id`, `t_pinned`, `t_sunk`, `t_cascading`, `t_forum_id`, `t_pt_from`, `t_pt_to`, `t_pt_from_category`, `t_pt_to_category`, `t_description`, `t_description_link`, `t_emoticon`, `t_num_views`, `t_validated`, `t_is_open`, `t_poll_id`, `t_cache_first_post_id`, `t_cache_first_time`, `t_cache_first_title`, `t_cache_first_post`, `t_cache_first_username`, `t_cache_first_member_id`, `t_cache_last_post_id`, `t_cache_last_time`, `t_cache_last_title`, `t_cache_last_username`, `t_cache_last_member_id`, `t_cache_num_posts`) VALUES(1, 0, 0, 0, 7, NULL, NULL, '', '', '', '', '', 0, 1, 1, NULL, 1, 1344775582, 'Welcome to the forums', 82, 'System', 1, 1, 1344775582, 'Welcome to the forums', 'System', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_usergroup_subs`
--

DROP TABLE IF EXISTS `cms_f_usergroup_subs`;
CREATE TABLE IF NOT EXISTS `cms_f_usergroup_subs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `s_title` int(10) unsigned NOT NULL,
  `s_description` int(10) unsigned NOT NULL,
  `s_cost` varchar(255) NOT NULL,
  `s_length` int(11) NOT NULL,
  `s_length_units` varchar(255) NOT NULL,
  `s_group_id` int(11) NOT NULL,
  `s_enabled` tinyint(1) NOT NULL,
  `s_mail_start` int(10) unsigned NOT NULL,
  `s_mail_end` int(10) unsigned NOT NULL,
  `s_mail_uhoh` int(10) unsigned NOT NULL,
  `s_uses_primary` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_usergroup_subs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_warnings`
--

DROP TABLE IF EXISTS `cms_f_warnings`;
CREATE TABLE IF NOT EXISTS `cms_f_warnings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `w_member_id` int(11) NOT NULL,
  `w_time` int(10) unsigned NOT NULL,
  `w_explanation` longtext NOT NULL,
  `w_by` int(11) NOT NULL,
  `w_is_warning` tinyint(1) NOT NULL,
  `p_silence_from_topic` int(11) DEFAULT NULL,
  `p_silence_from_forum` int(11) DEFAULT NULL,
  `p_probation` int(11) NOT NULL,
  `p_banned_ip` varchar(40) NOT NULL,
  `p_charged_points` int(11) NOT NULL,
  `p_banned_member` tinyint(1) NOT NULL,
  `p_changed_usergroup_from` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `warningsmemberid` (`w_member_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_warnings`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_welcome_emails`
--

DROP TABLE IF EXISTS `cms_f_welcome_emails`;
CREATE TABLE IF NOT EXISTS `cms_f_welcome_emails` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `w_name` varchar(255) NOT NULL,
  `w_subject` int(10) unsigned NOT NULL,
  `w_text` int(10) unsigned NOT NULL,
  `w_send_time` int(11) NOT NULL,
  `w_newsletter` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_welcome_emails`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_galleries`
--

DROP TABLE IF EXISTS `cms_galleries`;
CREATE TABLE IF NOT EXISTS `cms_galleries` (
  `name` varchar(80) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `teaser` int(10) unsigned NOT NULL,
  `fullname` int(10) unsigned NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  `parent_id` varchar(80) NOT NULL,
  `watermark_top_left` varchar(255) NOT NULL,
  `watermark_top_right` varchar(255) NOT NULL,
  `watermark_bottom_left` varchar(255) NOT NULL,
  `watermark_bottom_right` varchar(255) NOT NULL,
  `accept_images` tinyint(1) NOT NULL,
  `accept_videos` tinyint(1) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `notes` longtext NOT NULL,
  `is_member_synched` tinyint(1) NOT NULL,
  `flow_mode_interface` tinyint(1) NOT NULL,
  `gallery_views` int(11) NOT NULL,
  `g_owner` int(11) DEFAULT NULL,
  PRIMARY KEY (`name`),
  KEY `watermark_top_left` (`watermark_top_left`),
  KEY `watermark_top_right` (`watermark_top_right`),
  KEY `watermark_bottom_left` (`watermark_bottom_left`),
  KEY `watermark_bottom_right` (`watermark_bottom_right`),
  KEY `gadd_date` (`add_date`),
  KEY `parent_id` (`parent_id`),
  KEY `ftjoin_gfullname` (`fullname`),
  KEY `ftjoin_gdescrip` (`description`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_galleries`
--

INSERT INTO `cms_galleries` (`name`, `description`, `teaser`, `fullname`, `add_date`, `rep_image`, `parent_id`, `watermark_top_left`, `watermark_top_right`, `watermark_bottom_left`, `watermark_bottom_right`, `accept_images`, `accept_videos`, `allow_rating`, `allow_comments`, `notes`, `is_member_synched`, `flow_mode_interface`, `gallery_views`, `g_owner`) VALUES('root', 298, 299, 300, 1344775599, '', '', '', '', '', '', 1, 1, 1, 1, '', 0, 1, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_gifts`
--

DROP TABLE IF EXISTS `cms_gifts`;
CREATE TABLE IF NOT EXISTS `cms_gifts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_and_time` int(10) unsigned NOT NULL,
  `amount` int(11) NOT NULL,
  `gift_from` int(11) NOT NULL,
  `gift_to` int(11) NOT NULL,
  `reason` int(10) unsigned NOT NULL,
  `anonymous` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `giftsgiven` (`gift_from`),
  KEY `giftsreceived` (`gift_to`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_gifts`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_group_category_access`
--

DROP TABLE IF EXISTS `cms_group_category_access`;
CREATE TABLE IF NOT EXISTS `cms_group_category_access` (
  `module_the_name` varchar(80) NOT NULL,
  `category_name` varchar(80) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`module_the_name`,`category_name`,`group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_group_category_access`
--

INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'advertise_here', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('banners', 'donate', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '2', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '3', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '4', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '5', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '6', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '7', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('calendar', '8', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'faqs', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'hosted', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'links', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'modifications', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'products', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_catalogue', 'projects', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '2', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '3', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '4', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('catalogues_category', '6', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('chat', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('downloads', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '2', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '3', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '3', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '4', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '4', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '5', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '6', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '6', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '7', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '7', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('forums', '8', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('galleries', 'root', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '2', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '3', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '4', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '5', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '6', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('news', '7', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('seedy_page', '1', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Complaint', 10);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 1);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 2);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 3);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 4);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 5);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 6);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 7);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 8);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 9);
INSERT INTO `cms_group_category_access` (`module_the_name`, `category_name`, `group_id`) VALUES('tickets', 'Other', 10);

-- --------------------------------------------------------

--
-- Table structure for table `cms_group_page_access`
--

DROP TABLE IF EXISTS `cms_group_page_access`;
CREATE TABLE IF NOT EXISTS `cms_group_page_access` (
  `page_name` varchar(80) NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`page_name`,`zone_name`,`group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_group_page_access`
--

INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_addons', 'adminzone', 10);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_emaillog', 'adminzone', 10);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_import', 'adminzone', 10);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_commandr', 'adminzone', 10);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_redirects', 'adminzone', 10);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('admin_staff', 'adminzone', 10);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 1);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 2);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 3);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 4);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 5);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 6);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 7);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 8);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 9);
INSERT INTO `cms_group_page_access` (`page_name`, `zone_name`, `group_id`) VALUES('cms_chat', 'cms', 10);

-- --------------------------------------------------------

--
-- Table structure for table `cms_group_zone_access`
--

DROP TABLE IF EXISTS `cms_group_zone_access`;
CREATE TABLE IF NOT EXISTS `cms_group_zone_access` (
  `zone_name` varchar(80) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`zone_name`,`group_id`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_group_zone_access`
--

INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 1);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 2);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 3);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 4);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 5);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 6);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 7);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 8);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 9);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('', 10);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('adminzone', 2);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('adminzone', 3);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 2);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 3);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 4);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 5);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 6);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 7);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 8);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 9);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('cms', 10);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('collaboration', 2);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('collaboration', 3);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('collaboration', 4);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 1);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 2);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 3);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 4);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 5);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 6);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 7);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 8);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 9);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('forum', 10);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 2);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 3);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 4);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 5);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 6);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 7);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 8);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 9);
INSERT INTO `cms_group_zone_access` (`zone_name`, `group_id`) VALUES('site', 10);

-- --------------------------------------------------------

--
-- Table structure for table `cms_gsp`
--

DROP TABLE IF EXISTS `cms_gsp`;
CREATE TABLE IF NOT EXISTS `cms_gsp` (
  `group_id` int(11) NOT NULL,
  `specific_permission` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  `category_name` varchar(80) NOT NULL,
  `the_value` tinyint(1) NOT NULL,
  PRIMARY KEY (`group_id`,`specific_permission`,`the_page`,`module_the_name`,`category_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_gsp`
--

INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '1', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '1', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '1', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '1', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '3', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '3', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '3', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '3', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '4', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '4', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '4', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '4', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '6', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '6', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '6', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '6', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', 'forums', '7', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', 'forums', '7', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '7', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '7', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'run_multi_moderations', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'use_pt', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'edit_personal_topic_posts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'may_report_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'view_member_photos', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'use_quick_reply', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'view_profiles', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'own_avatars', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'rename_self', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_special_emoticons', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_any_profile_field', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'disable_lost_passwords', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'close_own_topics', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'double_post', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_warnings', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_ip', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'may_choose_custom_title', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_account', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_poll_results_before_voting', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'moderate_personal_topic', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'member_maintenance', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'probate_members', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'warn_members', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'control_usergroups', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'multi_delete_topics', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'show_user_browsing', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_hidden_groups', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'pt_anyone', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'use_sms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_sms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'sms_higher_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'sms_higher_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'sms_higher_trigger_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'sms_higher_trigger_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'may_enable_staff_notifications', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'may_enable_staff_notifications', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'draw_to_server', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'draw_to_server', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'see_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'submit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'submit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'set_own_author_profile', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'rate', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'comment', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'have_personal_category', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'vote_in_polls', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'use_very_dangerous_comcode', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_very_dangerous_comcode', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'open_virtual_roots', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'open_virtual_roots', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'scheduled_publication_times', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'scheduled_publication_times', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'mass_delete_from_ip', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'mass_delete_from_ip', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'exceed_filesize_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'exceed_filesize_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_revision_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_revision_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'sees_javascript_error_alerts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'sees_javascript_error_alerts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'see_software_docs', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_software_docs', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_flood_control', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_flood_control', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'allow_html', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'allow_html', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'remove_page_split', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'remove_page_split', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'access_closed_site', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'access_closed_site', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_bandwidth_restriction', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_bandwidth_restriction', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'comcode_dangerous', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'comcode_dangerous', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'comcode_nuisance', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'comcode_nuisance', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'see_php_errors', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_php_errors', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'see_stack_dump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'see_stack_dump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_word_filter', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_word_filter', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_profiling_modes', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_profiling_modes', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'access_overrun_site', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'access_overrun_site', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_validation_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_own_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_own_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_own_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_own_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_own_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'can_submit_to_others_categories', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'can_submit_to_others_categories', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'search_engine_links', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'search_engine_links', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_content_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_content_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'restore_content_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'restore_content_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_content_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_content_history', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'submit_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'submit_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'submit_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'submit_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'submit_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'submit_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_own_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_own_cat_highrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_own_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_own_cat_midrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'mass_import', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'mass_import', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_lowrange_content', '', 'forums', '8', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_validation_midrange_content', '', 'forums', '8', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'full_banner_setup', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'full_banner_setup', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_anyones_banner_stats', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_anyones_banner_stats', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'banner_free', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'banner_free', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'use_html_banner', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_html_banner', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'view_calendar', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'add_public_events', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'sense_personal_conflicts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'sense_personal_conflicts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_event_subscriptions', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_event_subscriptions', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'high_catalogue_entry_timeout', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'high_catalogue_entry_timeout', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'seedy_manage_tree', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'seedy_manage_tree', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'create_private_room', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'start_im', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'ban_chatters_from_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'ban_chatters_from_rooms', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'may_download_gallery', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'may_download_gallery', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'high_personal_gallery_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'high_personal_gallery_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'no_personal_gallery_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'no_personal_gallery_limit', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'choose_iotd', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'choose_iotd', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'change_newsletter_subscriptions', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'change_newsletter_subscriptions', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'use_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'give_points_self', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'give_points_self', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'have_negative_gift_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'have_negative_gift_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'give_negative_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'give_negative_points', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_charge_log', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_charge_log', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'trace_anonymous_gifts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'trace_anonymous_gifts', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'choose_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'choose_poll', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'access_ecommerce_in_test_mode', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'access_ecommerce_in_test_mode', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'bypass_quiz_repeat_time_restriction', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'bypass_quiz_repeat_time_restriction', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'perform_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'perform_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'add_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'edit_own_tests', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'support_operator', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'support_operator', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'view_others_tickets', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'view_others_tickets', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'upload_anything_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'upload_anything_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(1, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(4, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(5, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(6, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(7, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(8, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(9, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(10, 'upload_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(2, 'delete_anything_filedump', '', '', '', 1);
INSERT INTO `cms_gsp` (`group_id`, `specific_permission`, `the_page`, `module_the_name`, `category_name`, `the_value`) VALUES(3, 'delete_anything_filedump', '', '', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_hackattack`
--

DROP TABLE IF EXISTS `cms_hackattack`;
CREATE TABLE IF NOT EXISTS `cms_hackattack` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `data_post` longtext NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `referer` varchar(255) NOT NULL,
  `user_os` varchar(255) NOT NULL,
  `the_user` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `ip` varchar(40) NOT NULL,
  `reason` varchar(80) NOT NULL,
  `reason_param_a` varchar(255) NOT NULL,
  `reason_param_b` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `otherhacksby` (`ip`),
  KEY `h_date_and_time` (`date_and_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_hackattack`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_https_pages`
--

DROP TABLE IF EXISTS `cms_https_pages`;
CREATE TABLE IF NOT EXISTS `cms_https_pages` (
  `https_page_name` varchar(80) NOT NULL,
  PRIMARY KEY (`https_page_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_https_pages`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_images`
--

DROP TABLE IF EXISTS `cms_images`;
CREATE TABLE IF NOT EXISTS `cms_images` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cat` varchar(80) NOT NULL,
  `url` varchar(255) NOT NULL,
  `thumb_url` varchar(255) NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `submitter` int(11) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  `image_views` int(11) NOT NULL,
  `title` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `image_views` (`image_views`),
  KEY `category_list` (`cat`),
  KEY `i_validated` (`validated`),
  KEY `xis` (`submitter`),
  KEY `iadd_date` (`add_date`),
  KEY `ftjoin_icomments` (`comments`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_images`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_import_id_remap`
--

DROP TABLE IF EXISTS `cms_import_id_remap`;
CREATE TABLE IF NOT EXISTS `cms_import_id_remap` (
  `id_old` varchar(80) NOT NULL,
  `id_new` int(11) NOT NULL,
  `id_type` varchar(80) NOT NULL,
  `id_session` int(11) NOT NULL,
  PRIMARY KEY (`id_old`,`id_type`,`id_session`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_import_id_remap`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_import_parts_done`
--

DROP TABLE IF EXISTS `cms_import_parts_done`;
CREATE TABLE IF NOT EXISTS `cms_import_parts_done` (
  `imp_id` varchar(255) NOT NULL,
  `imp_session` int(11) NOT NULL,
  PRIMARY KEY (`imp_id`,`imp_session`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_import_parts_done`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_import_session`
--

DROP TABLE IF EXISTS `cms_import_session`;
CREATE TABLE IF NOT EXISTS `cms_import_session` (
  `imp_old_base_dir` varchar(255) NOT NULL,
  `imp_db_name` varchar(80) NOT NULL,
  `imp_db_user` varchar(80) NOT NULL,
  `imp_hook` varchar(80) NOT NULL,
  `imp_db_table_prefix` varchar(80) NOT NULL,
  `imp_refresh_time` int(11) NOT NULL,
  `imp_session` int(11) NOT NULL,
  PRIMARY KEY (`imp_session`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_import_session`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_incoming_uploads`
--

DROP TABLE IF EXISTS `cms_incoming_uploads`;
CREATE TABLE IF NOT EXISTS `cms_incoming_uploads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `i_submitter` int(11) NOT NULL,
  `i_date_and_time` int(10) unsigned NOT NULL,
  `i_orig_filename` varchar(255) NOT NULL,
  `i_save_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_incoming_uploads`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_invoices`
--

DROP TABLE IF EXISTS `cms_invoices`;
CREATE TABLE IF NOT EXISTS `cms_invoices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `i_type_code` varchar(80) NOT NULL,
  `i_member_id` int(11) NOT NULL,
  `i_state` varchar(80) NOT NULL,
  `i_amount` varchar(255) NOT NULL,
  `i_special` varchar(255) NOT NULL,
  `i_time` int(10) unsigned NOT NULL,
  `i_note` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_invoices`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_iotd`
--

DROP TABLE IF EXISTS `cms_iotd`;
CREATE TABLE IF NOT EXISTS `cms_iotd` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `i_title` int(10) unsigned NOT NULL,
  `caption` int(10) unsigned NOT NULL,
  `thumb_url` varchar(255) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `used` tinyint(1) NOT NULL,
  `date_and_time` int(10) unsigned DEFAULT NULL,
  `iotd_views` int(11) NOT NULL,
  `submitter` int(11) NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `iotd_views` (`iotd_views`),
  KEY `get_current` (`is_current`),
  KEY `ios` (`submitter`),
  KEY `iadd_date` (`add_date`),
  KEY `date_and_time` (`date_and_time`),
  KEY `ftjoin_icap` (`caption`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_iotd`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_ip_country`
--

DROP TABLE IF EXISTS `cms_ip_country`;
CREATE TABLE IF NOT EXISTS `cms_ip_country` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `begin_num` int(10) unsigned NOT NULL,
  `end_num` int(10) unsigned NOT NULL,
  `country` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_ip_country`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_leader_board`
--

DROP TABLE IF EXISTS `cms_leader_board`;
CREATE TABLE IF NOT EXISTS `cms_leader_board` (
  `lb_member` int(11) NOT NULL,
  `lb_points` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`lb_member`,`date_and_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_leader_board`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_link_tracker`
--

DROP TABLE IF EXISTS `cms_link_tracker`;
CREATE TABLE IF NOT EXISTS `cms_link_tracker` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_date_and_time` int(10) unsigned NOT NULL,
  `c_member_id` int(11) NOT NULL,
  `c_ip_address` varchar(40) NOT NULL,
  `c_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_link_tracker`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_logged_mail_messages`
--

DROP TABLE IF EXISTS `cms_logged_mail_messages`;
CREATE TABLE IF NOT EXISTS `cms_logged_mail_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `m_subject` longtext NOT NULL,
  `m_message` longtext NOT NULL,
  `m_to_email` longtext NOT NULL,
  `m_to_name` longtext NOT NULL,
  `m_from_email` varchar(255) NOT NULL,
  `m_from_name` varchar(255) NOT NULL,
  `m_priority` tinyint(4) NOT NULL,
  `m_attachments` longtext NOT NULL,
  `m_no_cc` tinyint(1) NOT NULL,
  `m_as` int(11) NOT NULL,
  `m_as_admin` tinyint(1) NOT NULL,
  `m_in_html` tinyint(1) NOT NULL,
  `m_date_and_time` int(10) unsigned NOT NULL,
  `m_member_id` int(11) NOT NULL,
  `m_url` longtext NOT NULL,
  `m_queued` tinyint(1) NOT NULL,
  `m_template` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `recentmessages` (`m_date_and_time`),
  KEY `queued` (`m_queued`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_logged_mail_messages`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_long_values`
--

DROP TABLE IF EXISTS `cms_long_values`;
CREATE TABLE IF NOT EXISTS `cms_long_values` (
  `the_name` varchar(80) NOT NULL,
  `the_value` longtext NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`the_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_long_values`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_match_key_messages`
--

DROP TABLE IF EXISTS `cms_match_key_messages`;
CREATE TABLE IF NOT EXISTS `cms_match_key_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `k_message` int(10) unsigned NOT NULL,
  `k_match_key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_match_key_messages`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_member_category_access`
--

DROP TABLE IF EXISTS `cms_member_category_access`;
CREATE TABLE IF NOT EXISTS `cms_member_category_access` (
  `active_until` int(10) unsigned NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  `category_name` varchar(80) NOT NULL,
  `member_id` int(11) NOT NULL,
  PRIMARY KEY (`active_until`,`module_the_name`,`category_name`,`member_id`),
  KEY `mcaname` (`module_the_name`,`category_name`),
  KEY `mcamember_id` (`member_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_member_category_access`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_member_page_access`
--

DROP TABLE IF EXISTS `cms_member_page_access`;
CREATE TABLE IF NOT EXISTS `cms_member_page_access` (
  `active_until` int(10) unsigned NOT NULL,
  `page_name` varchar(80) NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  `member_id` int(11) NOT NULL,
  PRIMARY KEY (`active_until`,`page_name`,`zone_name`,`member_id`),
  KEY `mzaname` (`page_name`,`zone_name`),
  KEY `mzamember_id` (`member_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_member_page_access`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_member_tracking`
--

DROP TABLE IF EXISTS `cms_member_tracking`;
CREATE TABLE IF NOT EXISTS `cms_member_tracking` (
  `mt_member_id` int(11) NOT NULL,
  `mt_cache_username` varchar(80) NOT NULL,
  `mt_time` int(10) unsigned NOT NULL,
  `mt_page` varchar(80) NOT NULL,
  `mt_type` varchar(80) NOT NULL,
  `mt_id` varchar(80) NOT NULL,
  PRIMARY KEY (`mt_member_id`,`mt_time`,`mt_page`,`mt_type`,`mt_id`),
  KEY `mt_page` (`mt_page`),
  KEY `mt_id` (`mt_page`,`mt_id`,`mt_type`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_member_tracking`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_member_zone_access`
--

DROP TABLE IF EXISTS `cms_member_zone_access`;
CREATE TABLE IF NOT EXISTS `cms_member_zone_access` (
  `active_until` int(10) unsigned NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  `member_id` int(11) NOT NULL,
  PRIMARY KEY (`active_until`,`zone_name`,`member_id`),
  KEY `mzazone_name` (`zone_name`),
  KEY `mzamember_id` (`member_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_member_zone_access`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_menu_items`
--

DROP TABLE IF EXISTS `cms_menu_items`;
CREATE TABLE IF NOT EXISTS `cms_menu_items` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `i_menu` varchar(80) NOT NULL,
  `i_order` int(11) NOT NULL,
  `i_parent` int(11) DEFAULT NULL,
  `i_caption` int(10) unsigned NOT NULL,
  `i_caption_long` int(10) unsigned NOT NULL,
  `i_url` varchar(255) NOT NULL,
  `i_check_permissions` tinyint(1) NOT NULL,
  `i_expanded` tinyint(1) NOT NULL,
  `i_new_window` tinyint(1) NOT NULL,
  `i_page_only` varchar(80) NOT NULL,
  `i_theme_img_code` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `menu_extraction` (`i_menu`)
) ENGINE=MyISAM  AUTO_INCREMENT=56 ;

--
-- Dumping data for table `cms_menu_items`
--

INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(1, 'root_website', 10, NULL, 91, 92, ':', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(2, 'root_website', 11, NULL, 93, 94, '_SEARCH:rules', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(3, 'main_website', 12, NULL, 95, 96, 'site:', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(4, 'main_website', 13, NULL, 97, 98, '_SEARCH:help', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(5, 'main_community', 14, NULL, 99, 100, 'forum:forumview', 0, 0, 0, '', 'menu_items/community_navigation/forums');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(6, 'main_community', 15, NULL, 101, 102, '_SEARCH:rules', 0, 0, 0, '', 'menu_items/community_navigation/rules');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(7, 'main_community', 16, NULL, 103, 104, '_SEARCH:members:type=misc', 0, 0, 0, '', 'menu_items/community_navigation/members');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(8, 'main_community', 17, NULL, 105, 106, '_SEARCH:groups:type=misc', 0, 0, 0, '', 'menu_items/community_navigation/groups');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(9, 'member_features', 18, NULL, 107, 108, '_SEARCH:join:type=misc', 1, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(10, 'member_features', 19, NULL, 109, 110, '_SEARCH:lostpassword:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(11, 'collab_website', 20, NULL, 111, 112, 'collaboration:', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(12, 'collab_website', 21, NULL, 113, 114, 'collaboration:about', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(13, 'forum_features', 22, NULL, 115, 116, '_SEARCH:rules', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(14, 'forum_features', 23, NULL, 117, 118, '_SEARCH:members:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(15, 'zone_menu', 24, NULL, 119, 120, 'site:', 1, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(16, 'zone_menu', 25, NULL, 121, 122, 'forum:', 1, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(17, 'zone_menu', 26, NULL, 123, 124, 'collaboration:', 1, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(18, 'zone_menu', 27, NULL, 125, 126, 'cms:', 1, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(19, 'zone_menu', 28, NULL, 127, 128, 'adminzone:', 1, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(20, 'collab_features', 10, NULL, 131, 132, '_SELF:authors:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(21, 'collab_features', 11, NULL, 133, 134, '_SEARCH:cms_authors:type=_ad', 0, 0, 1, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(22, 'main_content', 12, NULL, 145, 146, '_SEARCH:calendar:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(23, 'collab_features', 13, NULL, 159, 160, '', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(24, 'collab_features', 14, 23, 161, 162, '_SEARCH:catalogues:type=index:id=projects', 0, 0, 1, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(25, 'collab_features', 15, 23, 163, 164, '_SEARCH:cms_catalogues:type=add_entry:catalogue_name=projects', 0, 0, 1, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(26, 'collab_features', 16, NULL, 179, 180, '_SEARCH:catalogues:type=index:id=modifications', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(27, 'collab_features', 17, NULL, 191, 192, '_SEARCH:catalogues:type=index:id=hosted', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(28, 'main_content', 18, NULL, 203, 204, '_SEARCH:catalogues:type=index:id=links', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(29, 'main_content', 19, NULL, 215, 216, '_SEARCH:catalogues:type=index:id=faqs', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(30, 'main_content', 20, NULL, 247, 248, '_SEARCH:catalogues:type=index:id=contacts', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(45, 'ecommerce_features', 35, NULL, 340, 341, '_SEARCH:shopping:type=my_orders', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(32, 'wiki_features', 22, NULL, 279, 280, '_SEARCH:cedi:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(33, 'wiki_features', 23, NULL, 281, 282, '_SEARCH:cedi:type=random', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(34, 'wiki_features', 24, NULL, 283, 284, '_SEARCH:cedi:type=changes', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(35, 'wiki_features', 25, NULL, 285, 286, '_SEARCH:cedi:type=tree', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(36, 'main_community', 26, NULL, 290, 291, '_SEARCH:chat:type=misc', 0, 0, 0, '', 'menu_items/community_navigation/chat');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(37, 'main_content', 27, NULL, 294, 295, '_SEARCH:downloads:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(38, 'main_content', 28, NULL, 296, 297, '_SEARCH:galleries:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(39, 'main_community', 29, NULL, 312, 313, '_SEARCH:pointstore:type=misc', 0, 0, 0, '', 'menu_items/community_navigation/pointstore');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(40, 'ecommerce_features', 30, NULL, 330, 331, '_SEARCH:purchase:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(41, 'ecommerce_features', 31, NULL, 332, 333, '_SEARCH:invoices:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(42, 'ecommerce_features', 32, NULL, 334, 335, '_SEARCH:subscriptions:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(43, 'main_content', 33, NULL, 336, 337, '_SEARCH:quiz:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(44, 'forum_features', 34, NULL, 338, 339, '_SEARCH:search:type=misc:id=ocf_posts', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(46, 'main_website', 36, NULL, 356, 357, '_SEARCH:staff:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(47, 'main_website', 37, NULL, 360, 361, '_SEARCH:tickets:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(48, 'forum_features', 10, NULL, 362, 363, '_SEARCH:forumview:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(49, 'forum_features', 11, NULL, 364, 365, '_SEARCH:forumview:type=pt', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(50, 'forum_features', 12, NULL, 366, 367, '_SEARCH:vforums:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(51, 'forum_features', 13, NULL, 368, 369, '_SEARCH:vforums:type=unread', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(52, 'forum_features', 14, NULL, 370, 371, '_SEARCH:vforums:type=recently_read', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(53, 'collab_features', 15, NULL, 372, 373, '_SEARCH:filedump:type=misc', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(54, 'root_website', 100, NULL, 374, 375, '_SEARCH:recommend:from={$SELF_URL&,0,0,0,from=<null>}', 0, 0, 0, '', '');
INSERT INTO `cms_menu_items` (`id`, `i_menu`, `i_order`, `i_parent`, `i_caption`, `i_caption_long`, `i_url`, `i_check_permissions`, `i_expanded`, `i_new_window`, `i_page_only`, `i_theme_img_code`) VALUES(55, 'collab_website', 101, NULL, 376, 377, '_SEARCH:supermembers', 0, 0, 0, '', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_messages_to_render`
--

DROP TABLE IF EXISTS `cms_messages_to_render`;
CREATE TABLE IF NOT EXISTS `cms_messages_to_render` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `r_session_id` int(11) NOT NULL,
  `r_message` longtext NOT NULL,
  `r_type` varchar(80) NOT NULL,
  `r_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `forsession` (`r_session_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_messages_to_render`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_modules`
--

DROP TABLE IF EXISTS `cms_modules`;
CREATE TABLE IF NOT EXISTS `cms_modules` (
  `module_the_name` varchar(80) NOT NULL,
  `module_author` varchar(80) NOT NULL,
  `module_organisation` varchar(80) NOT NULL,
  `module_hacked_by` varchar(80) NOT NULL,
  `module_hack_version` int(11) DEFAULT NULL,
  `module_version` int(11) NOT NULL,
  PRIMARY KEY (`module_the_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_modules`
--

INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_permissions', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_version', 'Chris Graham', 'ocProducts', '', NULL, 16);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_actionlog', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_addons', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_awards', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_backup', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_banners', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_bulkupload', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_chat', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_cleanup', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_config', 'Chris Graham', 'ocProducts', '', NULL, 14);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_custom_comcode', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_debrand', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ecommerce', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_emaillog', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_errorlog', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_flagrant', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_import', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_invoices', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ipban', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_lang', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_lookup', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_menus', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_messaging', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_newsletter', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_notifications', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_commandr', 'Philip Withnall', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_categories', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_customprofilefields', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_emoticons', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_forums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_history', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_join', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_ldap', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_merge_members', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_multimoderations', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_post_templates', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ocf_welcome_emails', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_orders', 'Manuprathap', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_phpinfo', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_points', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_pointstore', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_quiz', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_realtime_rain', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_redirects', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_security', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_setupwizard', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_sitetree', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_ssl', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_staff', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_stats', 'Philip Withnall', 'ocProducts', '', NULL, 7);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_themes', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_themewizard', 'Allen Ellis', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_tickets', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_trackbacks', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_unvalidated', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_wordfilter', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_xml_storage', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('admin_zones', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('authors', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('awards', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('banners', 'Chris Graham', 'ocProducts', '', NULL, 6);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('bookmarks', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('calendar', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('catalogues', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cedi', 'Chris Graham', 'ocProducts', '', NULL, 8);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('chat', 'Philip Withnall', 'ocProducts', '', NULL, 11);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('contactmember', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('downloads', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('galleries', 'Chris Graham', 'ocProducts', '', NULL, 8);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('invoices', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('iotds', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('leader_board', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('members', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('news', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('newsletter', 'Chris Graham', 'ocProducts', '', NULL, 9);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('notifications', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('onlinemembers', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('points', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('pointstore', 'Allen Ellis', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('polls', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('purchase', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('quiz', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('search', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('shopping', 'Manuprathap', 'ocProducts', '', NULL, 6);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('staff', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('subscriptions', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('tester', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('tickets', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('warnings', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('forumview', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('topics', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('topicview', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('vforums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_authors', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_banners', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_blogs', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_calendar', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_catalogues', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_cedi', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_chat', 'Philip Withnall', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_comcode_pages', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_downloads', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_galleries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_iotds', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_ocf_groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_polls', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('cms_quiz', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('filedump', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('forums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('join', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('login', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('lostpassword', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('recommend', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_modules` (`module_the_name`, `module_author`, `module_organisation`, `module_hacked_by`, `module_hack_version`, `module_version`) VALUES('supermembers', 'Chris Graham', 'ocProducts', '', NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `cms_msp`
--

