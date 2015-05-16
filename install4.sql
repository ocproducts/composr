DROP TABLE IF EXISTS `cms_msp`;
CREATE TABLE IF NOT EXISTS `cms_msp` (
  `active_until` int(10) unsigned NOT NULL,
  `member_id` int(11) NOT NULL,
  `specific_permission` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  `category_name` varchar(80) NOT NULL,
  `the_value` tinyint(1) NOT NULL,
  PRIMARY KEY (`active_until`,`member_id`,`specific_permission`,`the_page`,`module_the_name`,`category_name`),
  KEY `mspname` (`specific_permission`,`the_page`,`module_the_name`,`category_name`),
  KEY `mspmember_id` (`member_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_msp`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_news`
--

DROP TABLE IF EXISTS `cms_news`;
CREATE TABLE IF NOT EXISTS `cms_news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_and_time` int(10) unsigned NOT NULL,
  `title` int(10) unsigned NOT NULL,
  `news` int(10) unsigned NOT NULL,
  `news_article` int(10) unsigned NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `author` varchar(80) NOT NULL,
  `submitter` int(11) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  `news_category` int(11) NOT NULL,
  `news_views` int(11) NOT NULL,
  `news_image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `news_views` (`news_views`),
  KEY `findnewscat` (`news_category`),
  KEY `newsauthor` (`author`),
  KEY `nes` (`submitter`),
  KEY `headlines` (`date_and_time`,`id`),
  KEY `nvalidated` (`validated`),
  KEY `ftjoin_ititle` (`title`),
  KEY `ftjoin_nnews` (`news`),
  KEY `ftjoin_nnewsa` (`news_article`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_news`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_newsletter`
--

DROP TABLE IF EXISTS `cms_newsletter`;
CREATE TABLE IF NOT EXISTS `cms_newsletter` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `join_time` int(10) unsigned NOT NULL,
  `code_confirm` int(11) NOT NULL,
  `the_password` varchar(33) NOT NULL,
  `pass_salt` varchar(80) NOT NULL,
  `language` varchar(80) NOT NULL,
  `n_forename` varchar(255) NOT NULL,
  `n_surname` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `welcomemails` (`join_time`),
  KEY `code_confirm` (`code_confirm`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_newsletter`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_newsletters`
--

DROP TABLE IF EXISTS `cms_newsletters`;
CREATE TABLE IF NOT EXISTS `cms_newsletters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` int(10) unsigned NOT NULL,
  `description` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_newsletters`
--

INSERT INTO `cms_newsletters` (`id`, `title`, `description`) VALUES(1, 310, 311);

-- --------------------------------------------------------

--
-- Table structure for table `cms_newsletter_archive`
--

DROP TABLE IF EXISTS `cms_newsletter_archive`;
CREATE TABLE IF NOT EXISTS `cms_newsletter_archive` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_and_time` int(11) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `newsletter` longtext NOT NULL,
  `language` varchar(80) NOT NULL,
  `importance_level` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_newsletter_archive`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_newsletter_drip_send`
--

DROP TABLE IF EXISTS `cms_newsletter_drip_send`;
CREATE TABLE IF NOT EXISTS `cms_newsletter_drip_send` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `d_inject_time` int(10) unsigned NOT NULL,
  `d_subject` varchar(255) NOT NULL,
  `d_message` longtext NOT NULL,
  `d_html_only` tinyint(1) NOT NULL,
  `d_to_email` varchar(255) NOT NULL,
  `d_to_name` varchar(255) NOT NULL,
  `d_from_email` varchar(255) NOT NULL,
  `d_from_name` varchar(255) NOT NULL,
  `d_priority` tinyint(4) NOT NULL,
  `d_template` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `d_inject_time` (`d_inject_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_newsletter_drip_send`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_newsletter_periodic`
--

DROP TABLE IF EXISTS `cms_newsletter_periodic`;
CREATE TABLE IF NOT EXISTS `cms_newsletter_periodic` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `np_message` longtext NOT NULL,
  `np_subject` longtext NOT NULL,
  `np_lang` varchar(5) NOT NULL,
  `np_send_details` longtext NOT NULL,
  `np_html_only` tinyint(1) NOT NULL,
  `np_from_email` varchar(255) NOT NULL,
  `np_from_name` varchar(255) NOT NULL,
  `np_priority` tinyint(4) NOT NULL,
  `np_csv_data` longtext NOT NULL,
  `np_frequency` varchar(255) NOT NULL,
  `np_day` tinyint(4) NOT NULL,
  `np_in_full` tinyint(1) NOT NULL,
  `np_template` varchar(80) NOT NULL,
  `np_last_sent` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_newsletter_periodic`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_newsletter_subscribe`
--

DROP TABLE IF EXISTS `cms_newsletter_subscribe`;
CREATE TABLE IF NOT EXISTS `cms_newsletter_subscribe` (
  `newsletter_id` int(11) NOT NULL,
  `the_level` tinyint(4) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`newsletter_id`,`email`),
  KEY `peopletosendto` (`the_level`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_newsletter_subscribe`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_news_categories`
--

DROP TABLE IF EXISTS `cms_news_categories`;
CREATE TABLE IF NOT EXISTS `cms_news_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nc_title` int(10) unsigned NOT NULL,
  `nc_owner` int(11) DEFAULT NULL,
  `nc_img` varchar(80) NOT NULL,
  `notes` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ncs` (`nc_owner`)
) ENGINE=MyISAM  AUTO_INCREMENT=8 ;

--
-- Dumping data for table `cms_news_categories`
--

INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(1, 303, NULL, 'newscats/general', '');
INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(2, 304, NULL, 'newscats/technology', '');
INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(3, 305, NULL, 'newscats/difficulties', '');
INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(4, 306, NULL, 'newscats/community', '');
INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(5, 307, NULL, 'newscats/entertainment', '');
INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(6, 308, NULL, 'newscats/business', '');
INSERT INTO `cms_news_categories` (`id`, `nc_title`, `nc_owner`, `nc_img`, `notes`) VALUES(7, 309, NULL, 'newscats/art', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_news_category_entries`
--

DROP TABLE IF EXISTS `cms_news_category_entries`;
CREATE TABLE IF NOT EXISTS `cms_news_category_entries` (
  `news_entry` int(11) NOT NULL,
  `news_entry_category` int(11) NOT NULL,
  PRIMARY KEY (`news_entry`,`news_entry_category`),
  KEY `news_entry_category` (`news_entry_category`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_news_category_entries`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_news_rss_cloud`
--

DROP TABLE IF EXISTS `cms_news_rss_cloud`;
CREATE TABLE IF NOT EXISTS `cms_news_rss_cloud` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rem_procedure` varchar(80) NOT NULL,
  `rem_port` tinyint(4) NOT NULL,
  `rem_path` varchar(255) NOT NULL,
  `rem_protocol` varchar(80) NOT NULL,
  `rem_ip` varchar(40) NOT NULL,
  `watching_channel` varchar(255) NOT NULL,
  `register_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_news_rss_cloud`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_notifications_enabled`
--

DROP TABLE IF EXISTS `cms_notifications_enabled`;
CREATE TABLE IF NOT EXISTS `cms_notifications_enabled` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `l_member_id` int(11) NOT NULL,
  `l_notification_code` varchar(80) NOT NULL,
  `l_code_category` varchar(255) NOT NULL,
  `l_setting` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `l_member_id` (`l_member_id`,`l_notification_code`),
  KEY `l_code_category` (`l_code_category`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_notifications_enabled`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_notification_lockdown`
--

DROP TABLE IF EXISTS `cms_notification_lockdown`;
CREATE TABLE IF NOT EXISTS `cms_notification_lockdown` (
  `l_notification_code` varchar(80) NOT NULL,
  `l_setting` int(11) NOT NULL,
  PRIMARY KEY (`l_notification_code`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_notification_lockdown`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_commandrchat`
--

DROP TABLE IF EXISTS `cms_commandrchat`;
CREATE TABLE IF NOT EXISTS `cms_commandrchat` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_message` longtext NOT NULL,
  `c_url` varchar(255) NOT NULL,
  `c_incoming` tinyint(1) NOT NULL,
  `c_timestamp` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_commandrchat`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_poll`
--

DROP TABLE IF EXISTS `cms_poll`;
CREATE TABLE IF NOT EXISTS `cms_poll` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `question` int(10) unsigned NOT NULL,
  `option1` int(10) unsigned NOT NULL,
  `option2` int(10) unsigned NOT NULL,
  `option3` int(10) unsigned DEFAULT NULL,
  `option4` int(10) unsigned DEFAULT NULL,
  `option5` int(10) unsigned DEFAULT NULL,
  `option6` int(10) unsigned NOT NULL,
  `option7` int(10) unsigned NOT NULL,
  `option8` int(10) unsigned DEFAULT NULL,
  `option9` int(10) unsigned DEFAULT NULL,
  `option10` int(10) unsigned DEFAULT NULL,
  `votes1` int(11) NOT NULL,
  `votes2` int(11) NOT NULL,
  `votes3` int(11) NOT NULL,
  `votes4` int(11) NOT NULL,
  `votes5` int(11) NOT NULL,
  `votes6` int(11) NOT NULL,
  `votes7` int(11) NOT NULL,
  `votes8` int(11) NOT NULL,
  `votes9` int(11) NOT NULL,
  `votes10` int(11) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `num_options` tinyint(4) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `date_and_time` int(10) unsigned DEFAULT NULL,
  `submitter` int(11) NOT NULL,
  `add_time` int(11) NOT NULL,
  `poll_views` int(11) NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `poll_views` (`poll_views`),
  KEY `get_current` (`is_current`),
  KEY `ps` (`submitter`),
  KEY `padd_time` (`add_time`),
  KEY `date_and_time` (`date_and_time`),
  KEY `ftjoin_pq` (`question`),
  KEY `ftjoin_po1` (`option1`),
  KEY `ftjoin_po2` (`option2`),
  KEY `ftjoin_po3` (`option3`),
  KEY `ftjoin_po4` (`option4`),
  KEY `ftjoin_po5` (`option5`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_poll`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_poll_votes`
--

DROP TABLE IF EXISTS `cms_poll_votes`;
CREATE TABLE IF NOT EXISTS `cms_poll_votes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `v_poll_id` int(11) NOT NULL,
  `v_voter_id` int(11) DEFAULT NULL,
  `v_voter_ip` varchar(40) NOT NULL,
  `v_vote_for` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `v_voter_id` (`v_voter_id`),
  KEY `v_voter_ip` (`v_voter_ip`),
  KEY `v_vote_for` (`v_vote_for`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_poll_votes`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_prices`
--

DROP TABLE IF EXISTS `cms_prices`;
CREATE TABLE IF NOT EXISTS `cms_prices` (
  `name` varchar(80) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_prices`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_pstore_customs`
--

DROP TABLE IF EXISTS `cms_pstore_customs`;
CREATE TABLE IF NOT EXISTS `cms_pstore_customs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_title` int(10) unsigned NOT NULL,
  `c_description` int(10) unsigned NOT NULL,
  `c_mail_subject` int(10) unsigned NOT NULL,
  `c_mail_body` int(10) unsigned NOT NULL,
  `c_enabled` tinyint(1) NOT NULL,
  `c_cost` int(11) NOT NULL,
  `c_one_per_member` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_pstore_customs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_pstore_permissions`
--

DROP TABLE IF EXISTS `cms_pstore_permissions`;
CREATE TABLE IF NOT EXISTS `cms_pstore_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `p_title` int(10) unsigned NOT NULL,
  `p_description` int(10) unsigned NOT NULL,
  `p_mail_subject` int(10) unsigned NOT NULL,
  `p_mail_body` int(10) unsigned NOT NULL,
  `p_enabled` tinyint(1) NOT NULL,
  `p_cost` int(11) NOT NULL,
  `p_hours` int(11) NOT NULL,
  `p_type` varchar(80) NOT NULL,
  `p_specific_permission` varchar(80) NOT NULL,
  `p_zone` varchar(80) NOT NULL,
  `p_page` varchar(80) NOT NULL,
  `p_module` varchar(80) NOT NULL,
  `p_category` varchar(80) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_pstore_permissions`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quizzes`
--

DROP TABLE IF EXISTS `cms_quizzes`;
CREATE TABLE IF NOT EXISTS `cms_quizzes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `q_timeout` int(11) DEFAULT NULL,
  `q_name` int(10) unsigned NOT NULL,
  `q_start_text` int(10) unsigned NOT NULL,
  `q_end_text` int(10) unsigned NOT NULL,
  `q_notes` longtext NOT NULL,
  `q_percentage` int(11) NOT NULL,
  `q_open_time` int(10) unsigned NOT NULL,
  `q_close_time` int(10) unsigned DEFAULT NULL,
  `q_num_winners` int(11) NOT NULL,
  `q_redo_time` int(11) DEFAULT NULL,
  `q_type` varchar(80) NOT NULL,
  `q_add_date` int(10) unsigned NOT NULL,
  `q_validated` tinyint(1) NOT NULL,
  `q_submitter` int(11) NOT NULL,
  `q_points_for_passing` int(11) NOT NULL,
  `q_tied_newsletter` int(11) DEFAULT NULL,
  `q_end_text_fail` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `q_validated` (`q_validated`),
  KEY `ftjoin_qstarttext` (`q_start_text`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_quizzes`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quiz_entries`
--

DROP TABLE IF EXISTS `cms_quiz_entries`;
CREATE TABLE IF NOT EXISTS `cms_quiz_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `q_time` int(10) unsigned NOT NULL,
  `q_member` int(11) NOT NULL,
  `q_quiz` int(11) NOT NULL,
  `q_results` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_quiz_entries`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quiz_entry_answer`
--

DROP TABLE IF EXISTS `cms_quiz_entry_answer`;
CREATE TABLE IF NOT EXISTS `cms_quiz_entry_answer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `q_entry` int(11) NOT NULL,
  `q_question` int(11) NOT NULL,
  `q_answer` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_quiz_entry_answer`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quiz_member_last_visit`
--

DROP TABLE IF EXISTS `cms_quiz_member_last_visit`;
CREATE TABLE IF NOT EXISTS `cms_quiz_member_last_visit` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `v_time` int(10) unsigned NOT NULL,
  `v_member_id` int(11) NOT NULL,
  `v_quiz_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_quiz_member_last_visit`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quiz_questions`
--

DROP TABLE IF EXISTS `cms_quiz_questions`;
CREATE TABLE IF NOT EXISTS `cms_quiz_questions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `q_long_input_field` tinyint(1) NOT NULL,
  `q_num_choosable_answers` int(11) NOT NULL,
  `q_quiz` int(11) NOT NULL,
  `q_question_text` int(10) unsigned NOT NULL,
  `q_order` int(11) NOT NULL,
  `q_required` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_quiz_questions`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quiz_question_answers`
--

DROP TABLE IF EXISTS `cms_quiz_question_answers`;
CREATE TABLE IF NOT EXISTS `cms_quiz_question_answers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `q_question` int(11) NOT NULL,
  `q_answer_text` int(10) unsigned NOT NULL,
  `q_is_correct` tinyint(1) NOT NULL,
  `q_order` int(11) NOT NULL,
  `q_explanation` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_quiz_question_answers`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_quiz_winner`
--

DROP TABLE IF EXISTS `cms_quiz_winner`;
CREATE TABLE IF NOT EXISTS `cms_quiz_winner` (
  `q_quiz` int(11) NOT NULL,
  `q_entry` int(11) NOT NULL,
  `q_winner_level` int(11) NOT NULL,
  PRIMARY KEY (`q_quiz`,`q_entry`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_quiz_winner`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_rating`
--

DROP TABLE IF EXISTS `cms_rating`;
CREATE TABLE IF NOT EXISTS `cms_rating` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rating_for_type` varchar(80) NOT NULL,
  `rating_for_id` varchar(80) NOT NULL,
  `rating_member` int(11) NOT NULL,
  `rating_ip` varchar(40) NOT NULL,
  `rating_time` int(10) unsigned NOT NULL,
  `rating` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `alt_key` (`rating_for_type`,`rating_for_id`),
  KEY `rating_for_id` (`rating_for_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_rating`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_redirects`
--

DROP TABLE IF EXISTS `cms_redirects`;
CREATE TABLE IF NOT EXISTS `cms_redirects` (
  `r_from_page` varchar(80) NOT NULL,
  `r_from_zone` varchar(80) NOT NULL,
  `r_to_page` varchar(80) NOT NULL,
  `r_to_zone` varchar(80) NOT NULL,
  `r_is_transparent` tinyint(1) NOT NULL,
  PRIMARY KEY (`r_from_page`,`r_from_zone`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_redirects`
--

INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('rules', 'site', 'rules', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('rules', 'forum', 'rules', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('authors', 'collaboration', 'authors', 'site', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_top', 'collaboration', 'panel_top', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_top', 'forum', 'panel_top', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_top', 'site', 'panel_top', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_bottom', 'adminzone', 'panel_bottom', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_bottom', 'cms', 'panel_bottom', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_bottom', 'collaboration', 'panel_bottom', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_bottom', 'forum', 'panel_bottom', '', 1);
INSERT INTO `cms_redirects` (`r_from_page`, `r_from_zone`, `r_to_page`, `r_to_zone`, `r_is_transparent`) VALUES('panel_bottom', 'site', 'panel_bottom', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_review_supplement`
--

DROP TABLE IF EXISTS `cms_review_supplement`;
CREATE TABLE IF NOT EXISTS `cms_review_supplement` (
  `r_post_id` int(11) NOT NULL,
  `r_rating_type` varchar(80) NOT NULL,
  `r_rating` tinyint(4) NOT NULL,
  `r_topic_id` int(11) NOT NULL,
  `r_rating_for_id` varchar(80) NOT NULL,
  `r_rating_for_type` varchar(80) NOT NULL,
  PRIMARY KEY (`r_post_id`,`r_rating_type`),
  KEY `rating_for_id` (`r_rating_for_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_review_supplement`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_sales`
--

DROP TABLE IF EXISTS `cms_sales`;
CREATE TABLE IF NOT EXISTS `cms_sales` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date_and_time` int(10) unsigned NOT NULL,
  `memberid` int(11) NOT NULL,
  `purchasetype` varchar(80) NOT NULL,
  `details` varchar(255) NOT NULL,
  `details2` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_sales`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_searches_logged`
--

DROP TABLE IF EXISTS `cms_searches_logged`;
CREATE TABLE IF NOT EXISTS `cms_searches_logged` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `s_member_id` int(11) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_primary` varchar(255) NOT NULL,
  `s_auxillary` longtext NOT NULL,
  `s_num_results` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `past_search` (`s_primary`),
  FULLTEXT KEY `past_search_ft` (`s_primary`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_searches_logged`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_searches_saved`
--

DROP TABLE IF EXISTS `cms_searches_saved`;
CREATE TABLE IF NOT EXISTS `cms_searches_saved` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `s_title` varchar(255) NOT NULL,
  `s_member_id` int(11) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_primary` varchar(255) NOT NULL,
  `s_auxillary` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_searches_saved`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_security_images`
--

DROP TABLE IF EXISTS `cms_security_images`;
CREATE TABLE IF NOT EXISTS `cms_security_images` (
  `si_session_id` int(11) NOT NULL,
  `si_time` int(10) unsigned NOT NULL,
  `si_code` int(11) NOT NULL,
  PRIMARY KEY (`si_session_id`),
  KEY `si_time` (`si_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_security_images`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_seedy_changes`
--

DROP TABLE IF EXISTS `cms_seedy_changes`;
CREATE TABLE IF NOT EXISTS `cms_seedy_changes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `the_action` varchar(80) NOT NULL,
  `the_page` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `ip` varchar(40) NOT NULL,
  `the_user` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_seedy_changes`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_seedy_children`
--

DROP TABLE IF EXISTS `cms_seedy_children`;
CREATE TABLE IF NOT EXISTS `cms_seedy_children` (
  `parent_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `the_order` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`parent_id`,`child_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_seedy_children`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_seedy_pages`
--

DROP TABLE IF EXISTS `cms_seedy_pages`;
CREATE TABLE IF NOT EXISTS `cms_seedy_pages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` int(10) unsigned NOT NULL,
  `notes` longtext NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `seedy_views` int(11) NOT NULL,
  `hide_posts` tinyint(1) NOT NULL,
  `submitter` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `seedy_views` (`seedy_views`),
  KEY `sps` (`submitter`),
  KEY `sadd_date` (`add_date`),
  KEY `ftjoin_spt` (`title`),
  KEY `ftjoin_spd` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_seedy_pages`
--

INSERT INTO `cms_seedy_pages` (`id`, `title`, `notes`, `description`, `add_date`, `seedy_views`, `hide_posts`, `submitter`) VALUES(1, 275, '', 276, 1344775599, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_seedy_posts`
--

DROP TABLE IF EXISTS `cms_seedy_posts`;
CREATE TABLE IF NOT EXISTS `cms_seedy_posts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL,
  `the_message` int(10) unsigned NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `seedy_views` int(11) NOT NULL,
  `the_user` int(11) NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `seedy_views` (`seedy_views`),
  KEY `spos` (`the_user`),
  KEY `posts_on_page` (`page_id`),
  KEY `cdate_and_time` (`date_and_time`),
  KEY `svalidated` (`validated`),
  KEY `ftjoin_spm` (`the_message`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_seedy_posts`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_seo_meta`
--

DROP TABLE IF EXISTS `cms_seo_meta`;
CREATE TABLE IF NOT EXISTS `cms_seo_meta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `meta_for_type` varchar(80) NOT NULL,
  `meta_for_id` varchar(80) NOT NULL,
  `meta_keywords` int(10) unsigned NOT NULL,
  `meta_description` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `alt_key` (`meta_for_type`,`meta_for_id`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_seo_meta`
--

INSERT INTO `cms_seo_meta` (`id`, `meta_for_type`, `meta_for_id`, `meta_keywords`, `meta_description`) VALUES(1, 'gallery', 'root', 301, 302);

-- --------------------------------------------------------

--
-- Table structure for table `cms_sessions`
--

DROP TABLE IF EXISTS `cms_sessions`;
CREATE TABLE IF NOT EXISTS `cms_sessions` (
  `the_session` int(11) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL,
  `the_user` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `session_confirmed` tinyint(1) NOT NULL,
  `session_invisible` tinyint(1) NOT NULL,
  `cache_username` varchar(255) NOT NULL,
  `the_zone` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_type` varchar(80) NOT NULL,
  `the_id` varchar(80) NOT NULL,
  `the_title` varchar(255) NOT NULL,
  PRIMARY KEY (`the_session`),
  KEY `delete_old` (`last_activity`),
  KEY `the_user` (`the_user`),
  KEY `userat` (`the_zone`,`the_page`,`the_type`,`the_id`)
) ENGINE=HEAP;

--
-- Dumping data for table `cms_sessions`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_shopping_cart`
--

DROP TABLE IF EXISTS `cms_shopping_cart`;
CREATE TABLE IF NOT EXISTS `cms_shopping_cart` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `session_id` int(11) NOT NULL,
  `ordered_by` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_code` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price_pre_tax` double NOT NULL,
  `price` double NOT NULL,
  `product_description` longtext NOT NULL,
  `product_type` varchar(255) NOT NULL,
  `product_weight` double NOT NULL,
  `is_deleted` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`,`ordered_by`,`product_id`),
  KEY `ordered_by` (`ordered_by`),
  KEY `session_id` (`session_id`),
  KEY `product_id` (`product_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_shopping_cart`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_shopping_logging`
--

DROP TABLE IF EXISTS `cms_shopping_logging`;
CREATE TABLE IF NOT EXISTS `cms_shopping_logging` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `e_member_id` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `last_action` varchar(255) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`e_member_id`),
  KEY `calculate_bandwidth` (`date_and_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_shopping_logging`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_shopping_order`
--

DROP TABLE IF EXISTS `cms_shopping_order`;
CREATE TABLE IF NOT EXISTS `cms_shopping_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_member` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `tot_price` double NOT NULL,
  `order_status` varchar(80) NOT NULL,
  `notes` longtext NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `purchase_through` varchar(255) NOT NULL,
  `tax_opted_out` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `finddispatchable` (`order_status`),
  KEY `soc_member` (`c_member`),
  KEY `sosession_id` (`session_id`),
  KEY `soadd_date` (`add_date`),
  KEY `recent_shopped` (`add_date`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_shopping_order`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_shopping_order_addresses`
--

DROP TABLE IF EXISTS `cms_shopping_order_addresses`;
CREATE TABLE IF NOT EXISTS `cms_shopping_order_addresses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `address_name` varchar(255) NOT NULL,
  `address_street` longtext NOT NULL,
  `address_city` varchar(255) NOT NULL,
  `address_zip` varchar(255) NOT NULL,
  `address_country` varchar(255) NOT NULL,
  `receiver_email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_shopping_order_addresses`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_shopping_order_details`
--

DROP TABLE IF EXISTS `cms_shopping_order_details`;
CREATE TABLE IF NOT EXISTS `cms_shopping_order_details` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `p_id` int(11) DEFAULT NULL,
  `p_name` varchar(255) NOT NULL,
  `p_code` varchar(255) NOT NULL,
  `p_type` varchar(255) NOT NULL,
  `p_quantity` int(11) NOT NULL,
  `p_price` double NOT NULL,
  `included_tax` double NOT NULL,
  `dispatch_status` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `p_id` (`p_id`),
  KEY `order_id` (`order_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_shopping_order_details`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_sitewatchlist`
--

DROP TABLE IF EXISTS `cms_sitewatchlist`;
CREATE TABLE IF NOT EXISTS `cms_sitewatchlist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `siteurl` varchar(255) NOT NULL,
  `site_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_sitewatchlist`
--

INSERT INTO `cms_sitewatchlist` (`id`, `siteurl`, `site_name`) VALUES(1, 'http://192.168.1.68/git', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_sms_log`
--

DROP TABLE IF EXISTS `cms_sms_log`;
CREATE TABLE IF NOT EXISTS `cms_sms_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `s_member_id` int(11) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_trigger_ip` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sms_log_for` (`s_member_id`,`s_time`),
  KEY `sms_trigger_ip` (`s_trigger_ip`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_sms_log`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_sp_list`
--

DROP TABLE IF EXISTS `cms_sp_list`;
CREATE TABLE IF NOT EXISTS `cms_sp_list` (
  `p_section` varchar(80) NOT NULL,
  `the_name` varchar(80) NOT NULL,
  `the_default` tinyint(1) NOT NULL,
  PRIMARY KEY (`the_name`,`the_default`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_sp_list`
--

INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_own_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'restore_content_history', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'view_content_history', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_own_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'search_engine_links', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'can_submit_to_others_categories', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_own_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_own_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_own_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'bypass_validation_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'bypass_validation_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'access_overrun_site', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'view_profiling_modes', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'bypass_word_filter', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'see_stack_dump', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'see_php_errors', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_COMCODE', 'comcode_nuisance', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_COMCODE', 'comcode_dangerous', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'bypass_bandwidth_restriction', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'access_closed_site', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'remove_page_split', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_COMCODE', 'allow_html', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'bypass_flood_control', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'see_software_docs', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'avoid_simplified_adminzone_look', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'sees_javascript_error_alerts', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'view_revision_history', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'exceed_filesize_limit', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'mass_delete_from_ip', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'scheduled_publication_times', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'open_virtual_roots', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_COMCODE', 'use_very_dangerous_comcode', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POLLS', 'vote_in_polls', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'have_personal_category', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_FEEDBACK', 'comment', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_FEEDBACK', 'rate', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'set_own_author_profile', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'bypass_validation_lowrange_content', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'submit_lowrange_content', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'submit_midrange_content', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'submit_highrange_content', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_own_lowrange_content', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'jump_to_unvalidated', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'see_unvalidated', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'draw_to_server', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'may_enable_staff_notifications', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'run_multi_moderations', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'use_pt', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'edit_personal_topic_posts', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'may_unblind_own_poll', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'may_report_post', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'view_member_photos', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'use_quick_reply', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'view_profiles', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'own_avatars', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'rename_self', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'use_special_emoticons', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'view_any_profile_field', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'disable_lost_passwords', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'close_own_topics', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'edit_own_polls', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'double_post', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'see_warnings', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'see_ip', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'may_choose_custom_title', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'delete_account', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'view_other_pt', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'view_poll_results_before_voting', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'moderate_personal_topic', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'member_maintenance', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'probate_members', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'warn_members', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'control_usergroups', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'multi_delete_topics', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'show_user_browsing', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'see_hidden_groups', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_FORUMS', 'pt_anyone', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_COMCODE', 'reuse_others_attachments', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'assume_any_member', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'use_sms', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'sms_higher_limit', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GENERAL_SETTINGS', 'sms_higher_trigger_limit', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('STAFF_ACTIONS', 'delete_content_history', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'submit_cat_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'submit_cat_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'submit_cat_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_cat_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_cat_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_cat_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_cat_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_cat_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_cat_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_own_cat_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_own_cat_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'edit_own_cat_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_own_cat_highrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_own_cat_midrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'delete_own_cat_lowrange_content', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUBMISSION', 'mass_import', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('BANNERS', 'full_banner_setup', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('BANNERS', 'view_anyones_banner_stats', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('BANNERS', 'banner_free', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_BANNERS', 'use_html_banner', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('_BANNERS', 'use_php_banner', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('CALENDAR', 'view_calendar', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('CALENDAR', 'add_public_events', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('CALENDAR', 'view_personal_events', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('CALENDAR', 'sense_personal_conflicts', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('CALENDAR', 'view_event_subscriptions', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('CATALOGUES', 'high_catalogue_entry_timeout', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SEEDY', 'seedy_manage_tree', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_CHAT', 'create_private_room', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_CHAT', 'start_im', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_CHAT', 'moderate_my_private_rooms', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SECTION_CHAT', 'ban_chatters_from_rooms', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GALLERIES', 'may_download_gallery', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GALLERIES', 'high_personal_gallery_limit', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('GALLERIES', 'no_personal_gallery_limit', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('IOTDS', 'choose_iotd', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('NEWSLETTER', 'change_newsletter_subscriptions', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POINTS', 'use_points', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POINTS', 'give_points_self', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POINTS', 'have_negative_gift_points', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POINTS', 'give_negative_points', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POINTS', 'view_charge_log', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POINTS', 'trace_anonymous_gifts', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('POLLS', 'choose_poll', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('ECOMMERCE', 'access_ecommerce_in_test_mode', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('QUIZZES', 'bypass_quiz_repeat_time_restriction', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('TESTER', 'perform_tests', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('TESTER', 'add_tests', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('TESTER', 'edit_own_tests', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUPPORT_TICKETS', 'support_operator', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('SUPPORT_TICKETS', 'view_others_tickets', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('FILE_DUMP', 'upload_anything_filedump', 0);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('FILE_DUMP', 'upload_filedump', 1);
INSERT INTO `cms_sp_list` (`p_section`, `the_name`, `the_default`) VALUES('FILE_DUMP', 'delete_anything_filedump', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_stafflinks`
--

DROP TABLE IF EXISTS `cms_stafflinks`;
CREATE TABLE IF NOT EXISTS `cms_stafflinks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link` varchar(255) NOT NULL,
  `link_title` varchar(255) NOT NULL,
  `link_desc` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=29 ;

--
-- Dumping data for table `cms_stafflinks`
--

INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(1, 'http://cmsortal.com/', 'Composr.com', 'Composr.com');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(2, 'http://cmsortal.com/forum/vforums/unread.htm', 'Composr.com (topics with unread posts)', 'Composr.com (topics with unread posts)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(3, 'http://cmsroducts.com/', 'ocProducts (web development services)', 'ocProducts (web development services)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(4, 'https://translations.launchpad.net/cmsortal/+translations', 'Launchpad (Composr language translations)', 'Launchpad (Composr language translations)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(5, 'http://www.google.com/alerts', 'Google Alerts', 'Google Alerts');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(6, 'http://www.google.com/analytics/', 'Google Analytics', 'Google Analytics');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(7, 'https://www.google.com/webmasters/tools', 'Google Webmaster Tools', 'Google Webmaster Tools');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(8, 'http://www.google.com/apps/intl/en/group/index.html', 'Google Apps (free gmail for domains, etc)', 'Google Apps (free gmail for domains, etc)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(9, 'http://www.google.com/chrome', 'Google Chrome (web browser)', 'Google Chrome (web browser)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(10, 'https://chrome.google.com/extensions/featured/web_dev', 'Google Chrome addons', 'Google Chrome addons');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(11, 'http://www.getfirefox.com/', 'Firefox (web browser)', 'Firefox (web browser)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(12, 'http://www.instantshift.com/2009/01/25/26-essential-firefox-add-ons-for-web-designers/', 'FireFox addons', 'FireFox addons');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(13, 'http://www.opera.com/', 'Opera (web browser)', 'Opera (web browser)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(14, 'http://www.my-debugbar.com/wiki/IETester/HomePage', 'Internet Explorer Tester (for testing)', 'Internet Explorer Tester (for testing)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(15, 'http://www.getpaint.net/', 'Paint.net (free graphics tool)', 'Paint.net (free graphics tool)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(16, 'http://benhollis.net/software/pnggauntlet/', 'PNGGauntlet (compress PNG files, Windows)', 'PNGGauntlet (compress PNG files, Windows)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(17, 'http://imageoptim.pornel.net/', 'ImageOptim (compress PNG files, Mac)', 'ImageOptim (compress PNG files, Mac)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(18, 'http://www.iconlet.com/', 'Iconlet (free icons)', 'Iconlet (free icons)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(19, 'http://sxc.hu/', 'stock.xchng (free stock art)', 'stock.xchng (free stock art)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(20, 'http://www.kompozer.net/', 'Kompozer (Web design tool)', 'Kompozer (Web design tool)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(21, 'http://www.sourcegear.com/diffmerge/', 'DiffMerge', 'DiffMerge');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(22, 'http://www.jingproject.com/', 'Jing (record screencasts)', 'Jing (record screencasts)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(23, 'http://www.elief.com/billing/aff.php?aff=035', 'Elief hosting (quality shared hosting)', 'Elief hosting (quality shared hosting)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(24, 'http://www.rackspacecloud.com/1043-0-3-13.html', 'Rackspace Cloud hosting', 'Rackspace Cloud hosting');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(25, 'http://www.jdoqocy.com/click-3972552-10378406', 'GoDaddy (Domains and SSL certificates)', 'GoDaddy (Domains and SSL certificates)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(26, 'http://www.silktide.com/siteray', 'SiteRay (site quality auditing)', 'SiteRay (site quality auditing)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(27, 'http://www.smashingmagazine.com/', 'Smashing Magazine (web design articles)', 'Smashing Magazine (web design articles)');
INSERT INTO `cms_stafflinks` (`id`, `link`, `link_title`, `link_desc`) VALUES(28, 'http://www.w3schools.com/', 'w3schools (learn web technologies)', 'w3schools (learn web technologies)');

-- --------------------------------------------------------

--
-- Table structure for table `cms_staff_tips_dismissed`
--

DROP TABLE IF EXISTS `cms_staff_tips_dismissed`;
CREATE TABLE IF NOT EXISTS `cms_staff_tips_dismissed` (
  `t_member` int(11) NOT NULL,
  `t_tip` varchar(80) NOT NULL,
  PRIMARY KEY (`t_member`,`t_tip`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_staff_tips_dismissed`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_stats`
--

DROP TABLE IF EXISTS `cms_stats`;
CREATE TABLE IF NOT EXISTS `cms_stats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `the_page` varchar(255) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `the_user` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `referer` varchar(255) NOT NULL,
  `get` varchar(255) NOT NULL,
  `post` longtext NOT NULL,
  `browser` varchar(255) NOT NULL,
  `milliseconds` int(11) NOT NULL,
  `operating_system` varchar(255) NOT NULL,
  `access_denied_counter` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `member_track_1` (`the_user`),
  KEY `member_track_2` (`ip`),
  KEY `pages` (`the_page`),
  KEY `date_and_time` (`date_and_time`),
  KEY `milliseconds` (`milliseconds`),
  KEY `referer` (`referer`),
  KEY `browser` (`browser`),
  KEY `operating_system` (`operating_system`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_stats`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_subscriptions`
--

DROP TABLE IF EXISTS `cms_subscriptions`;
CREATE TABLE IF NOT EXISTS `cms_subscriptions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `s_type_code` varchar(80) NOT NULL,
  `s_member_id` int(11) NOT NULL,
  `s_state` varchar(80) NOT NULL,
  `s_amount` varchar(255) NOT NULL,
  `s_special` varchar(255) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_auto_fund_source` varchar(80) NOT NULL,
  `s_auto_fund_key` varchar(255) NOT NULL,
  `s_via` varchar(80) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_subscriptions`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_temp_block_permissions`
--

DROP TABLE IF EXISTS `cms_temp_block_permissions`;
CREATE TABLE IF NOT EXISTS `cms_temp_block_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `p_session_id` int(11) NOT NULL,
  `p_block_constraints` longtext NOT NULL,
  `p_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_temp_block_permissions`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_tests`
--

DROP TABLE IF EXISTS `cms_tests`;
CREATE TABLE IF NOT EXISTS `cms_tests` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `t_section` int(11) NOT NULL,
  `t_test` longtext NOT NULL,
  `t_assigned_to` int(11) DEFAULT NULL,
  `t_enabled` tinyint(1) NOT NULL,
  `t_status` int(11) NOT NULL,
  `t_inherit_section` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_tests`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_test_sections`
--

DROP TABLE IF EXISTS `cms_test_sections`;
CREATE TABLE IF NOT EXISTS `cms_test_sections` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `s_section` varchar(255) NOT NULL,
  `s_notes` longtext NOT NULL,
  `s_inheritable` tinyint(1) NOT NULL,
  `s_assigned_to` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_test_sections`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_text`
--

DROP TABLE IF EXISTS `cms_text`;
CREATE TABLE IF NOT EXISTS `cms_text` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `the_message` int(10) unsigned NOT NULL,
  `days` int(11) NOT NULL,
  `order_time` int(10) unsigned NOT NULL,
  `activation_time` int(10) unsigned DEFAULT NULL,
  `active_now` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `findflagrant` (`active_now`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_text`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_theme_images`
--

DROP TABLE IF EXISTS `cms_theme_images`;
CREATE TABLE IF NOT EXISTS `cms_theme_images` (
  `id` varchar(255) NOT NULL,
  `theme` varchar(40) NOT NULL,
  `path` varchar(255) NOT NULL,
  `lang` varchar(5) NOT NULL,
  PRIMARY KEY (`id`,`theme`,`lang`),
  KEY `theme` (`theme`,`lang`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_theme_images`
--

INSERT INTO `cms_theme_images` (`id`, `theme`, `path`, `lang`) VALUES('favicon', 'default', 'favicon.ico', 'EN');
INSERT INTO `cms_theme_images` (`id`, `theme`, `path`, `lang`) VALUES('appleicon', 'default', 'appleicon.png', 'EN');

-- --------------------------------------------------------

--
-- Table structure for table `cms_tickets`
--

DROP TABLE IF EXISTS `cms_tickets`;
CREATE TABLE IF NOT EXISTS `cms_tickets` (
  `ticket_id` varchar(255) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `forum_id` int(11) NOT NULL,
  `ticket_type` int(10) unsigned NOT NULL,
  PRIMARY KEY (`ticket_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_tickets`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_ticket_types`
--

DROP TABLE IF EXISTS `cms_ticket_types`;
CREATE TABLE IF NOT EXISTS `cms_ticket_types` (
  `ticket_type` int(10) unsigned NOT NULL,
  `guest_emails_mandatory` tinyint(1) NOT NULL,
  `search_faq` tinyint(1) NOT NULL,
  `cache_lead_time` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`ticket_type`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_ticket_types`
--

INSERT INTO `cms_ticket_types` (`ticket_type`, `guest_emails_mandatory`, `search_faq`, `cache_lead_time`) VALUES(358, 0, 0, NULL);
INSERT INTO `cms_ticket_types` (`ticket_type`, `guest_emails_mandatory`, `search_faq`, `cache_lead_time`) VALUES(359, 0, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_trackbacks`
--

DROP TABLE IF EXISTS `cms_trackbacks`;
CREATE TABLE IF NOT EXISTS `cms_trackbacks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `trackback_for_type` varchar(80) NOT NULL,
  `trackback_for_id` varchar(80) NOT NULL,
  `trackback_ip` varchar(40) NOT NULL,
  `trackback_time` int(10) unsigned NOT NULL,
  `trackback_url` varchar(255) NOT NULL,
  `trackback_title` varchar(255) NOT NULL,
  `trackback_excerpt` longtext NOT NULL,
  `trackback_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `trackback_for_type` (`trackback_for_type`),
  KEY `trackback_for_id` (`trackback_for_id`),
  KEY `trackback_time` (`trackback_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_trackbacks`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_transactions`
--

DROP TABLE IF EXISTS `cms_transactions`;
CREATE TABLE IF NOT EXISTS `cms_transactions` (
  `id` varchar(80) NOT NULL,
  `purchase_id` varchar(80) NOT NULL,
  `status` varchar(255) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `amount` varchar(255) NOT NULL,
  `t_currency` varchar(80) NOT NULL,
  `linked` varchar(80) NOT NULL,
  `t_time` int(10) unsigned NOT NULL,
  `item` varchar(255) NOT NULL,
  `pending_reason` varchar(255) NOT NULL,
  `t_memo` longtext NOT NULL,
  `t_via` varchar(80) NOT NULL,
  PRIMARY KEY (`id`,`t_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_transactions`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_translate`
--

DROP TABLE IF EXISTS `cms_translate`;
CREATE TABLE IF NOT EXISTS `cms_translate` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `language` varchar(5) NOT NULL,
  `importance_level` tinyint(4) NOT NULL,
  `text_original` longtext NOT NULL,
  `text_parsed` longtext NOT NULL,
  `broken` tinyint(1) NOT NULL,
  `source_user` int(11) NOT NULL,
  PRIMARY KEY (`id`,`language`),
  KEY `importance_level` (`importance_level`),
  KEY `equiv_lang` (`text_original`(4)),
  KEY `decache` (`text_parsed`(2)),
  FULLTEXT KEY `search` (`text_original`)
) ENGINE=MyISAM  AUTO_INCREMENT=394 ;

--
-- Dumping data for table `cms_translate`
--

INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(1, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(2, 'EN', 1, 'Admin Zone', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(3, 'EN', 1, 'Collaboration Zone', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(4, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(5, 'EN', 1, 'Content Management', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(6, 'EN', 1, 'Guides', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(7, 'EN', 1, 'Welcome', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(8, 'EN', 1, 'Admin Zone', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(9, 'EN', 1, 'Site', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(10, 'EN', 1, 'Collaboration Zone', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(11, 'EN', 1, 'Content Management', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(12, 'EN', 1, 'Forum', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(13, 'EN', 1, 'Forums', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(14, 'EN', 2, 'About me', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(15, 'EN', 2, 'Some personally written information.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(16, 'EN', 2, 'Skype ID', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(17, 'EN', 2, 'Your Skype ID.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(18, 'EN', 2, 'Facebook profile', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(19, 'EN', 2, 'A link to your Facebook profile.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(20, 'EN', 2, 'Google+ profile', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(21, 'EN', 2, 'A link to your Google+ profile.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(22, 'EN', 2, 'Twitter account', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(23, 'EN', 2, 'Your Twitter name (for example, ''charlie12345'').', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(24, 'EN', 2, 'Interests', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(25, 'EN', 2, 'A summary of your interests.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(26, 'EN', 2, 'Location', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(27, 'EN', 2, 'Your geographical location.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(28, 'EN', 2, 'Occupation', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(29, 'EN', 2, 'Your occupation.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(30, 'EN', 2, 'Staff notes', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(31, 'EN', 2, 'Notes on this member, only viewable by staff.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(32, 'EN', 2, 'Guests', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(33, 'EN', 2, 'Guest user', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(34, 'EN', 2, 'Administrators', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(35, 'EN', 2, 'Site director', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(36, 'EN', 2, 'Super-moderators', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(37, 'EN', 2, 'Site staff', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(38, 'EN', 2, 'Super-members', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(39, 'EN', 2, 'Super-member', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(40, 'EN', 2, 'Local hero', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(41, 'EN', 2, 'Standard member', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(42, 'EN', 2, 'Old timer', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(43, 'EN', 2, 'Standard member', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(44, 'EN', 2, 'Local', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(45, 'EN', 2, 'Standard member', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(46, 'EN', 2, 'Regular', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(47, 'EN', 2, 'Standard member', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(48, 'EN', 2, 'Newbie', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(49, 'EN', 2, 'Standard member', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(50, 'EN', 2, 'Probation', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(51, 'EN', 2, 'Members will be considered to be in this usergroup (and only this usergroup) if and whilst they have been placed on probation. This usergroup behaves like any other, and therefore may also be manually placed into it.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(52, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(53, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(54, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(55, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(56, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(57, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(58, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(59, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(60, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(61, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(62, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(63, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(64, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(65, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(66, 'EN', 3, 'Trash', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(67, 'EN', 4, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59ee209c8.10623054\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a59ee209c8.10623054'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(68, 'EN', 4, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59ee24298.69385812\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a59ee24298.69385812'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(69, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(70, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(71, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(72, 'EN', 4, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59ee31046.73754395\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a59ee31046.73754395'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(73, 'EN', 4, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59ee32ce2.51627818\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a59ee32ce2.51627818'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(74, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(75, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(76, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(77, 'EN', 4, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59ee415f4.66317420\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a59ee415f4.66317420'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(78, 'EN', 4, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59ee46c77.04167066\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a59ee46c77.04167066'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(79, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(80, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(81, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(82, 'EN', 4, 'This is the inbuilt forum system (known as OCF).\n\nA forum system is a tool for communication between members; it consists of posts, organised into topics: each topic is a line of conversation.\n\nThe website software provides support for a number of different forum systems, and each forum handles authentication of members: OCF is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a59eece9c4.88145153\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:7:\\"(mixed)\\";i:3;s:0:\\"\\";i:4;N;i:5;s:609:\\"\\$TPL_FUNCS[''string_attach_5027a59eece9c4.88145153'']=\\"echo \\\\\\"This is the inbuilt forum system (known as OCF).\\\\\\";echo \\\\\\"<br />\\\\\\";echo \\\\\\"<br />\\\\\\";echo \\\\\\"A forum system is a tool for communication between members; it consists of posts, organised into topics: each topic is a line of conversation.\\\\\\";echo \\\\\\"<br />\\\\\\";echo \\\\\\"<br />\\\\\\";echo \\\\\\"The website software provides support for a number of different forum systems, and each forum handles authentication of members: OCF is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(83, 'EN', 2, 'cms_mobile_phone_number', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(84, 'EN', 2, 'This should be the mobile phone number in international format, devoid of any national or international outgoing access codes. For instance, a typical UK (44) number might be nationally known as ''01234 123456'', but internationally and without outgoing access codes would be ''441234123456''.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(85, 'EN', 2, 'Download of the week', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(86, 'EN', 2, 'The best downloads in the download system, chosen every week.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(87, 'EN', 2, 'Embed Facebook videos', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(88, 'EN', 2, 'Embed Facebook videos into your content.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(89, 'EN', 2, 'Embed YouTube videos', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(90, 'EN', 2, 'Embed YouTube videos into your content.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(91, 'EN', 1, 'Front page', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(92, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(93, 'EN', 1, 'Rules', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(94, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(95, 'EN', 1, 'Front page', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(96, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(97, 'EN', 1, 'Help', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(98, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(99, 'EN', 1, 'Forums', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(100, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(101, 'EN', 1, 'Rules', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(102, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(103, 'EN', 1, 'Members', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(104, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(105, 'EN', 1, 'Usergroups', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(106, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(107, 'EN', 1, 'Join', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(108, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(109, 'EN', 1, 'Reset password', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(110, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(111, 'EN', 1, 'Front page', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(112, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(113, 'EN', 1, 'About', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(114, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(115, 'EN', 1, 'Rules', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(116, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(117, 'EN', 1, 'Members', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(118, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(119, 'EN', 1, 'Site', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(120, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(121, 'EN', 1, 'Social', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(122, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(123, 'EN', 1, 'Collaboration Zone', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(124, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(125, 'EN', 1, 'Content Management', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(126, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(127, 'EN', 1, 'Admin Zone', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(128, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(129, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(130, 'EN', 3, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(131, 'EN', 1, 'My author profile', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(132, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(133, 'EN', 1, 'Setup author profile', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(134, 'EN', 1, 'This link is a shortcut: the menu will change', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(135, 'EN', 1, 'Advertise here!', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5adebd515.72454131\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:81:\\"\\$TPL_FUNCS[''string_attach_5027a5adebd515.72454131'']=\\"echo \\\\\\"Advertise here!\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(136, 'EN', 1, 'Please donate to keep this site alive', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5adec6a58.97336854\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:103:\\"\\$TPL_FUNCS[''string_attach_5027a5adec6a58.97336854'']=\\"echo \\\\\\"Please donate to keep this site alive\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(137, 'EN', 2, '(System command)', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(138, 'EN', 2, 'General', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(139, 'EN', 2, 'Birthday', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(140, 'EN', 2, 'Public holiday', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(141, 'EN', 2, 'Vacation', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(142, 'EN', 2, 'Appointment', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(143, 'EN', 2, 'Task', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(144, 'EN', 2, 'Anniversary', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(145, 'EN', 1, 'Calendar', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(146, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(147, 'EN', 2, 'Super-member projects', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(148, 'EN', 3, 'These are projects listed by super-members, designed to: advertise project existence, detail current progress, and solicit help.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae6f2bc1.93150967\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:194:\\"\\$TPL_FUNCS[''string_attach_5027a5ae6f2bc1.93150967'']=\\"echo \\\\\\"These are projects listed by super-members, designed to: advertise project existence, detail current progress, and solicit help.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(149, 'EN', 3, 'Name', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(150, 'EN', 3, 'The name for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae70a151.94279814\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:84:\\"\\$TPL_FUNCS[''string_attach_5027a5ae70a151.94279814'']=\\"echo \\\\\\"The name for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(151, 'EN', 3, 'Maintainer', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(152, 'EN', 3, 'The maintainer of this project.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae71ed62.86345818\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:97:\\"\\$TPL_FUNCS[''string_attach_5027a5ae71ed62.86345818'']=\\"echo \\\\\\"The maintainer of this project.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(153, 'EN', 3, 'Description', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(154, 'EN', 3, 'A concise description for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae731823.54294354\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:97:\\"\\$TPL_FUNCS[''string_attach_5027a5ae731823.54294354'']=\\"echo \\\\\\"A concise description for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(155, 'EN', 3, 'Project progress', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(156, 'EN', 3, 'The estimated percentage of completion of this project.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae73ed27.66028500\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:121:\\"\\$TPL_FUNCS[''string_attach_5027a5ae73ed27.66028500'']=\\"echo \\\\\\"The estimated percentage of completion of this project.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(157, 'EN', 2, 'Super-member projects', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(158, 'EN', 3, 'These are projects listed by super-members, designed to: advertise project existence, detail current progress, and solicit help.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae754029.25991553\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:194:\\"\\$TPL_FUNCS[''string_attach_5027a5ae754029.25991553'']=\\"echo \\\\\\"These are projects listed by super-members, designed to: advertise project existence, detail current progress, and solicit help.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(159, 'EN', 1, 'Projects', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(160, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(161, 'EN', 1, 'View', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(162, 'EN', 1, 'This link is a shortcut: the menu will change', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(163, 'EN', 1, 'Add', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(164, 'EN', 1, 'This link is a shortcut: the menu will change', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(165, 'EN', 2, 'Modifications', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(166, 'EN', 3, 'These are mods that may be applied.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7895f6.38325520\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:101:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7895f6.38325520'']=\\"echo \\\\\\"These are mods that may be applied.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(167, 'EN', 3, 'Name', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(168, 'EN', 3, 'The name for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae797a11.04480384\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:84:\\"\\$TPL_FUNCS[''string_attach_5027a5ae797a11.04480384'']=\\"echo \\\\\\"The name for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(169, 'EN', 3, 'Image', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(170, 'EN', 3, 'A logo for this modification.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7a21f9.74995421\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:95:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7a21f9.74995421'']=\\"echo \\\\\\"A logo for this modification.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(171, 'EN', 3, 'Status', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(172, 'EN', 3, 'The status of this modification. This can be any text string, such as: Completed, Planning, Development or Testing.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7b2bf3.20266885\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:181:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7b2bf3.20266885'']=\\"echo \\\\\\"The status of this modification. This can be any text string, such as: Completed, Planning, Development or Testing.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(173, 'EN', 3, 'URL', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(174, 'EN', 3, 'The entered text will be interpreted as a URL, and used as a hyperlink.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7bdbf5.12314155\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:137:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7bdbf5.12314155'']=\\"echo \\\\\\"The entered text will be interpreted as a URL, and used as a hyperlink.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(175, 'EN', 3, 'Description', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(176, 'EN', 3, 'A concise description for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7cb423.10683075\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:97:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7cb423.10683075'']=\\"echo \\\\\\"A concise description for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(177, 'EN', 3, 'Author', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(178, 'EN', 3, 'The author of this entry.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7d6eb6.82208031\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:91:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7d6eb6.82208031'']=\\"echo \\\\\\"The author of this entry.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(179, 'EN', 1, 'Modifications', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(180, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(181, 'EN', 2, 'Hosted sites', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(182, 'EN', 3, 'These are sites hosted by us.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae7f44a6.40211673\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:95:\\"\\$TPL_FUNCS[''string_attach_5027a5ae7f44a6.40211673'']=\\"echo \\\\\\"These are sites hosted by us.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(183, 'EN', 2, 'Name', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(184, 'EN', 3, 'The name for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae800260.54700637\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:84:\\"\\$TPL_FUNCS[''string_attach_5027a5ae800260.54700637'']=\\"echo \\\\\\"The name for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(185, 'EN', 2, 'URL', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(186, 'EN', 3, 'The entered text will be interpreted as a URL, and used as a hyperlink.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae80b762.39071894\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:137:\\"\\$TPL_FUNCS[''string_attach_5027a5ae80b762.39071894'']=\\"echo \\\\\\"The entered text will be interpreted as a URL, and used as a hyperlink.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(187, 'EN', 2, 'Description', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(188, 'EN', 3, 'A concise description for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae8195e8.08457062\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:97:\\"\\$TPL_FUNCS[''string_attach_5027a5ae8195e8.08457062'']=\\"echo \\\\\\"A concise description for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(189, 'EN', 2, 'Hosted sites', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(190, 'EN', 3, 'These are sites hosted by us.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae824ed0.70660549\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:95:\\"\\$TPL_FUNCS[''string_attach_5027a5ae824ed0.70660549'']=\\"echo \\\\\\"These are sites hosted by us.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(191, 'EN', 1, 'Hosted sites', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(192, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(193, 'EN', 2, 'Links', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(194, 'EN', 3, 'Warning: these sites are outside our control.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae84b289.64578702\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:111:\\"\\$TPL_FUNCS[''string_attach_5027a5ae84b289.64578702'']=\\"echo \\\\\\"Warning: these sites are outside our control.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(195, 'EN', 1, 'Links home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(196, 'EN', 3, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae853634.79175336\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5ae853634.79175336'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(197, 'EN', 2, 'Title', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(198, 'EN', 3, 'A concise title for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae85a5b6.47277915\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:91:\\"\\$TPL_FUNCS[''string_attach_5027a5ae85a5b6.47277915'']=\\"echo \\\\\\"A concise title for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(199, 'EN', 2, 'URL', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(200, 'EN', 3, 'The entered text will be interpreted as a URL, and used as a hyperlink.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae865543.02681789\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:137:\\"\\$TPL_FUNCS[''string_attach_5027a5ae865543.02681789'']=\\"echo \\\\\\"The entered text will be interpreted as a URL, and used as a hyperlink.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(201, 'EN', 2, 'Description', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(202, 'EN', 3, 'A concise description for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae870dc5.03839528\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:97:\\"\\$TPL_FUNCS[''string_attach_5027a5ae870dc5.03839528'']=\\"echo \\\\\\"A concise description for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(203, 'EN', 1, 'Links', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(204, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(205, 'EN', 2, 'Frequently Asked Questions', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(206, 'EN', 3, 'If you have questions that are not covered in our FAQ, please post them in an appropriate forum.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae893062.61729593\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:162:\\"\\$TPL_FUNCS[''string_attach_5027a5ae893062.61729593'']=\\"echo \\\\\\"If you have questions that are not covered in our FAQ, please post them in an appropriate forum.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(207, 'EN', 2, 'Question', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(208, 'EN', 3, 'The question asked.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae89f350.31250299\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:85:\\"\\$TPL_FUNCS[''string_attach_5027a5ae89f350.31250299'']=\\"echo \\\\\\"The question asked.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(209, 'EN', 2, 'Answer', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(210, 'EN', 3, 'The answer(s) to the question.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae8aa201.46359031\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:96:\\"\\$TPL_FUNCS[''string_attach_5027a5ae8aa201.46359031'']=\\"echo \\\\\\"The answer(s) to the question.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(211, 'EN', 2, 'Order', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(212, 'EN', 3, 'The order priority this entry has in the category.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae8b4ca9.18242274\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:116:\\"\\$TPL_FUNCS[''string_attach_5027a5ae8b4ca9.18242274'']=\\"echo \\\\\\"The order priority this entry has in the category.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(213, 'EN', 2, 'Frequently Asked Questions', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(214, 'EN', 3, 'If you have questions that are not covered in our FAQ, please post them in an appropriate forum.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae8c4418.16000865\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:162:\\"\\$TPL_FUNCS[''string_attach_5027a5ae8c4418.16000865'']=\\"echo \\\\\\"If you have questions that are not covered in our FAQ, please post them in an appropriate forum.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(215, 'EN', 1, 'FAQs', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(216, 'EN', 1, 'Frequently Asked Questions', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(217, 'EN', 2, 'Contacts', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(218, 'EN', 3, 'A contacts/address-book.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae8e9a47.45671809\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:90:\\"\\$TPL_FUNCS[''string_attach_5027a5ae8e9a47.45671809'']=\\"echo \\\\\\"A contacts/address-book.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(219, 'EN', 3, 'Forename', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(220, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(221, 'EN', 3, 'Surname', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(222, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(223, 'EN', 3, 'E-mail address', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(224, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(225, 'EN', 3, 'Company', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(226, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(227, 'EN', 3, 'Home address', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(228, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(229, 'EN', 3, 'City', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(230, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(231, 'EN', 3, 'Home phone number', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(232, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(233, 'EN', 3, 'Work phone number', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(234, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(235, 'EN', 3, 'Homepage', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(236, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(237, 'EN', 3, 'Instant messenger handle', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(238, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(239, 'EN', 3, 'Events relating to them', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(240, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(241, 'EN', 3, 'Notes', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(242, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(243, 'EN', 3, 'Photo', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(244, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(245, 'EN', 2, 'Contacts', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(246, 'EN', 3, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5ae95cfd9.87974862\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5ae95cfd9.87974862'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(247, 'EN', 1, 'Contacts', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(248, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(249, 'EN', 2, 'Products', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(250, 'EN', 2, 'These are products for sale from this website.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(251, 'EN', 1, 'Products home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(252, 'EN', 3, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea08724.81849274\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5aea08724.81849274'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(253, 'EN', 3, 'Product title', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(254, 'EN', 3, 'A concise title for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea12a54.64674532\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:91:\\"\\$TPL_FUNCS[''string_attach_5027a5aea12a54.64674532'']=\\"echo \\\\\\"A concise title for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(255, 'EN', 3, 'Product code', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(256, 'EN', 3, 'The codename for the product', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea1fff2.32246605\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:94:\\"\\$TPL_FUNCS[''string_attach_5027a5aea1fff2.32246605'']=\\"echo \\\\\\"The codename for the product\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(257, 'EN', 3, 'Net price', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(258, 'EN', 3, 'The price, before tax is added, in the primary currency of this website.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea2e5b0.46621372\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:138:\\"\\$TPL_FUNCS[''string_attach_5027a5aea2e5b0.46621372'']=\\"echo \\\\\\"The price, before tax is added, in the primary currency of this website.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(259, 'EN', 3, 'Stock level', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(260, 'EN', 3, 'The stock level of the product (leave blank if no stock counting is to be done).', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea41cd5.19892529\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:146:\\"\\$TPL_FUNCS[''string_attach_5027a5aea41cd5.19892529'']=\\"echo \\\\\\"The stock level of the product (leave blank if no stock counting is to be done).\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(261, 'EN', 3, 'Stock level warn-threshold', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(262, 'EN', 3, 'Send out a notification to the staff if the stock goes below this level (leave blank if no stock counting is to be done).', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea4eff9.52035503\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:187:\\"\\$TPL_FUNCS[''string_attach_5027a5aea4eff9.52035503'']=\\"echo \\\\\\"Send out a notification to the staff if the stock goes below this level (leave blank if no stock counting is to be done).\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(263, 'EN', 3, 'Stock maintained', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(264, 'EN', 3, 'Whether stock will be maintained. If the stock is not maintained then users will not be able to purchase it if the stock runs out.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea5de04.20049882\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:196:\\"\\$TPL_FUNCS[''string_attach_5027a5aea5de04.20049882'']=\\"echo \\\\\\"Whether stock will be maintained. If the stock is not maintained then users will not be able to purchase it if the stock runs out.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(265, 'EN', 3, 'Product tax rate', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(266, 'EN', 3, 'The tax rates that products can be assigned.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea6c424.18160499\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:110:\\"\\$TPL_FUNCS[''string_attach_5027a5aea6c424.18160499'']=\\"echo \\\\\\"The tax rates that products can be assigned.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(267, 'EN', 3, 'Product image', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(268, 'EN', 3, 'Upload an image of your product.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea7b446.09039909\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:98:\\"\\$TPL_FUNCS[''string_attach_5027a5aea7b446.09039909'']=\\"echo \\\\\\"Upload an image of your product.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(269, 'EN', 3, 'Product weight', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(270, 'EN', 3, 'The weight, in whatever units are assumed by the shipping costs programmed-in to this website.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea87a30.28877014\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:160:\\"\\$TPL_FUNCS[''string_attach_5027a5aea87a30.28877014'']=\\"echo \\\\\\"The weight, in whatever units are assumed by the shipping costs programmed-in to this website.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(271, 'EN', 3, 'Product description', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(272, 'EN', 3, 'A concise description for this.', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5aea954b6.08949483\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:97:\\"\\$TPL_FUNCS[''string_attach_5027a5aea954b6.08949483'']=\\"echo \\\\\\"A concise description for this.\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(273, 'EN', 1, 'Products', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(274, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(275, 'EN', 1, 'Wiki+ home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(276, 'EN', 2, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5af05b643.60699112\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5af05b643.60699112'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(277, 'EN', 2, 'cms_points_gained_seedy', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(278, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(279, 'EN', 1, 'Home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(280, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(281, 'EN', 1, 'Random page', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(282, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(283, 'EN', 1, 'Change-log', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(284, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(285, 'EN', 1, 'Tree', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(286, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(287, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(288, 'EN', 2, 'cms_points_gained_chat', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(289, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(290, 'EN', 1, 'Chat lobby', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(291, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(292, 'EN', 2, 'Downloads home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(293, 'EN', 3, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5af5cc488.97827154\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5af5cc488.97827154'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(294, 'EN', 1, 'Downloads', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(295, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(296, 'EN', 1, 'Galleries', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(297, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(298, 'EN', 2, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5afd98fa8.33961157\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5afd98fa8.33961157'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(299, 'EN', 2, '', 'return unserialize("a:6:{i:0;a:1:{i:0;a:5:{i:0;s:37:\\"string_attach_5027a5afd9b7a4.92826767\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\"\\";i:4;s:0:\\"\\";}}i:1;a:0:{}i:2;s:10:\\":container\\";i:3;N;i:4;N;i:5;s:66:\\"\\$TPL_FUNCS[''string_attach_5027a5afd9b7a4.92826767'']=\\"echo \\\\\\"\\\\\\";\\";\\n\\";}");\n', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(300, 'EN', 1, 'Galleries home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(301, 'EN', 2, 'home,galleries', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(302, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(303, 'EN', 2, 'General', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(304, 'EN', 2, 'Technology', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(305, 'EN', 2, 'Difficulties', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(306, 'EN', 2, 'Community', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(307, 'EN', 2, 'Entertainment', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(308, 'EN', 2, 'Business', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(309, 'EN', 2, 'Art', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(310, 'EN', 2, 'General', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(311, 'EN', 2, 'General messages will be sent out in this newsletter.', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(312, 'EN', 1, 'Point-store', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(313, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(314, 'EN', 2, 'cms_currency', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(315, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(316, 'EN', 2, 'cms_payment_cardholder_name', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(317, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(318, 'EN', 2, 'cms_payment_type', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(319, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(320, 'EN', 2, 'cms_payment_card_number', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(321, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(322, 'EN', 2, 'cms_payment_card_start_date', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(323, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(324, 'EN', 2, 'cms_payment_card_expiry_date', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(325, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(326, 'EN', 2, 'cms_payment_card_issue_number', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(327, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(328, 'EN', 2, 'cms_payment_card_cv2', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(329, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(330, 'EN', 1, 'Purchasing', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(331, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(332, 'EN', 1, 'Invoices', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(333, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(334, 'EN', 1, 'Subscriptions', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(335, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(336, 'EN', 1, 'Quizzes', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(337, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(338, 'EN', 1, 'Search', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(339, 'EN', 1, 'This link is a shortcut: the menu will change', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(340, 'EN', 1, 'Orders', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(341, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(342, 'EN', 2, 'cms_firstname', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(343, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(344, 'EN', 2, 'cms_lastname', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(345, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(346, 'EN', 2, 'cms_building_name_or_number', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(347, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(348, 'EN', 2, 'cms_city', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(349, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(350, 'EN', 2, 'cms_state', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(351, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(352, 'EN', 2, 'cms_post_code', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(353, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(354, 'EN', 2, 'cms_country', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(355, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(356, 'EN', 1, 'Staff', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(357, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(358, 'EN', 1, 'Other', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(359, 'EN', 1, 'Complaint', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(360, 'EN', 1, 'Support tickets', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(361, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(362, 'EN', 1, 'Forum home', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(363, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(364, 'EN', 1, 'Private Topics', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(365, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(366, 'EN', 1, 'Posts since last visit', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(367, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(368, 'EN', 1, 'Unread posts', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(369, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(370, 'EN', 1, 'Recently-read topics', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(371, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(372, 'EN', 1, 'File/Media library', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(373, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(374, 'EN', 1, 'Recommend site', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(375, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(376, 'EN', 1, 'Super-members', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(377, 'EN', 1, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(378, 'EN', 2, 'cms_points_used', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(379, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(380, 'EN', 2, 'cms_gift_points_used', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(381, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(382, 'EN', 2, 'cms_points_gained_given', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(383, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(384, 'EN', 2, 'cms_points_gained_rating', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(385, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(386, 'EN', 2, 'cms_points_gained_voting', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(387, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(388, 'EN', 2, 'cms_sites', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(389, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(390, 'EN', 2, 'cms_role', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(391, 'EN', 2, '', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(392, 'EN', 2, 'cms_fullname', '', 0, 1);
INSERT INTO `cms_translate` (`id`, `language`, `importance_level`, `text_original`, `text_parsed`, `broken`, `source_user`) VALUES(393, 'EN', 2, '', '', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_translate_history`
--

DROP TABLE IF EXISTS `cms_translate_history`;
CREATE TABLE IF NOT EXISTS `cms_translate_history` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lang_id` int(11) NOT NULL,
  `language` varchar(5) NOT NULL,
  `text_original` longtext NOT NULL,
  `broken` tinyint(1) NOT NULL,
  `action_member` int(11) NOT NULL,
  `action_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`language`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_translate_history`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_trans_expecting`
--

DROP TABLE IF EXISTS `cms_trans_expecting`;
CREATE TABLE IF NOT EXISTS `cms_trans_expecting` (
  `id` varchar(80) NOT NULL,
  `e_purchase_id` varchar(80) NOT NULL,
  `e_item_name` varchar(255) NOT NULL,
  `e_member_id` int(11) NOT NULL,
  `e_amount` varchar(255) NOT NULL,
  `e_ip_address` varchar(40) NOT NULL,
  `e_session_id` int(11) NOT NULL,
  `e_time` int(10) unsigned NOT NULL,
  `e_length` int(11) DEFAULT NULL,
  `e_length_units` varchar(80) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_trans_expecting`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_tutorial_links`
--

DROP TABLE IF EXISTS `cms_tutorial_links`;
CREATE TABLE IF NOT EXISTS `cms_tutorial_links` (
  `the_name` varchar(80) NOT NULL,
  `the_value` longtext NOT NULL,
  PRIMARY KEY (`the_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_tutorial_links`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_url_id_monikers`
--

DROP TABLE IF EXISTS `cms_url_id_monikers`;
CREATE TABLE IF NOT EXISTS `cms_url_id_monikers` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `m_resource_page` varchar(80) NOT NULL,
  `m_resource_type` varchar(80) NOT NULL,
  `m_resource_id` varchar(80) NOT NULL,
  `m_moniker` varchar(255) NOT NULL,
  `m_deprecated` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uim_pagelink` (`m_resource_page`,`m_resource_type`,`m_resource_id`),
  KEY `uim_moniker` (`m_moniker`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_url_id_monikers`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_url_title_cache`
--

DROP TABLE IF EXISTS `cms_url_title_cache`;
CREATE TABLE IF NOT EXISTS `cms_url_title_cache` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `t_url` varchar(255) NOT NULL,
  `t_title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_url_title_cache`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_usersonline_track`
--

DROP TABLE IF EXISTS `cms_usersonline_track`;
CREATE TABLE IF NOT EXISTS `cms_usersonline_track` (
  `date_and_time` int(10) unsigned NOT NULL,
  `peak` int(11) NOT NULL,
  PRIMARY KEY (`date_and_time`),
  KEY `peak_track` (`peak`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_usersonline_track`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_usersubmitban_ip`
--

DROP TABLE IF EXISTS `cms_usersubmitban_ip`;
CREATE TABLE IF NOT EXISTS `cms_usersubmitban_ip` (
  `ip` varchar(40) NOT NULL,
  `i_descrip` longtext NOT NULL,
  `i_ban_until` int(10) unsigned DEFAULT NULL,
  `i_ban_positive` tinyint(1) NOT NULL,
  PRIMARY KEY (`ip`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_usersubmitban_ip`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_usersubmitban_member`
--

DROP TABLE IF EXISTS `cms_usersubmitban_member`;
CREATE TABLE IF NOT EXISTS `cms_usersubmitban_member` (
  `the_member` int(11) NOT NULL,
  PRIMARY KEY (`the_member`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_usersubmitban_member`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_validated_once`
--

DROP TABLE IF EXISTS `cms_validated_once`;
CREATE TABLE IF NOT EXISTS `cms_validated_once` (
  `hash` varchar(33) NOT NULL,
  PRIMARY KEY (`hash`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_validated_once`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_values`
--

DROP TABLE IF EXISTS `cms_values`;
CREATE TABLE IF NOT EXISTS `cms_values` (
  `the_name` varchar(80) NOT NULL,
  `the_value` varchar(80) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`the_name`),
  KEY `date_and_time` (`date_and_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_values`
--

INSERT INTO `cms_values` (`the_name`, `the_value`, `date_and_time`) VALUES('version', '9.00', 1344775590);
INSERT INTO `cms_values` (`the_name`, `the_value`, `date_and_time`) VALUES('ocf_version', '9.00', 1344775590);

-- --------------------------------------------------------

--
-- Table structure for table `cms_videos`
--

DROP TABLE IF EXISTS `cms_videos`;
CREATE TABLE IF NOT EXISTS `cms_videos` (
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
  `video_views` int(11) NOT NULL,
  `video_width` int(11) NOT NULL,
  `video_height` int(11) NOT NULL,
  `video_length` int(11) NOT NULL,
  `title` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `video_views` (`video_views`),
  KEY `vs` (`submitter`),
  KEY `v_validated` (`validated`),
  KEY `category_list` (`cat`),
  KEY `vadd_date` (`add_date`),
  KEY `ftjoin_vcomments` (`comments`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_videos`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_video_transcoding`
--

DROP TABLE IF EXISTS `cms_video_transcoding`;
CREATE TABLE IF NOT EXISTS `cms_video_transcoding` (
  `t_id` varchar(80) NOT NULL,
  `t_error` longtext NOT NULL,
  `t_url` varchar(255) NOT NULL,
  `t_table` varchar(80) NOT NULL,
  `t_url_field` varchar(80) NOT NULL,
  `t_orig_filename_field` varchar(80) NOT NULL,
  `t_width_field` varchar(80) NOT NULL,
  `t_height_field` varchar(80) NOT NULL,
  `t_output_filename` varchar(80) NOT NULL,
  PRIMARY KEY (`t_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_video_transcoding`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_wordfilter`
--

DROP TABLE IF EXISTS `cms_wordfilter`;
CREATE TABLE IF NOT EXISTS `cms_wordfilter` (
  `word` varchar(255) NOT NULL,
  `w_replacement` varchar(255) NOT NULL,
  `w_substr` tinyint(1) NOT NULL,
  PRIMARY KEY (`word`,`w_substr`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_wordfilter`
--

INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('arsehole', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('asshole', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('arse', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('cock', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('cocked', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('cocksucker', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('crap', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('cunt', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('cum', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('bastard', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('bitch', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('blowjob', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('bollocks', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('bondage', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('bugger', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('buggery', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('dickhead', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('fuck', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('fucked', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('fucking', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('fucker', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('gayboy', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('motherfucker', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('nigger', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('piss', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('pissed', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('puffter', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('pussy', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('shag', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('shagged', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('shat', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('shit', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('slut', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('twat', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('wank', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('wanker', '', 0);
INSERT INTO `cms_wordfilter` (`word`, `w_replacement`, `w_substr`) VALUES('whore', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_zones`
--

DROP TABLE IF EXISTS `cms_zones`;
CREATE TABLE IF NOT EXISTS `cms_zones` (
  `zone_name` varchar(80) NOT NULL,
  `zone_title` int(10) unsigned NOT NULL,
  `zone_default_page` varchar(80) NOT NULL,
  `zone_header_text` int(10) unsigned NOT NULL,
  `zone_theme` varchar(80) NOT NULL,
  `zone_wide` tinyint(1) DEFAULT NULL,
  `zone_require_session` tinyint(1) NOT NULL,
  `zone_displayed_in_menu` tinyint(1) NOT NULL,
  PRIMARY KEY (`zone_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_zones`
--

INSERT INTO `cms_zones` (`zone_name`, `zone_title`, `zone_default_page`, `zone_header_text`, `zone_theme`, `zone_wide`, `zone_require_session`, `zone_displayed_in_menu`) VALUES('', 7, 'start', 1, '-1', 0, 0, 0);
INSERT INTO `cms_zones` (`zone_name`, `zone_title`, `zone_default_page`, `zone_header_text`, `zone_theme`, `zone_wide`, `zone_require_session`, `zone_displayed_in_menu`) VALUES('adminzone', 8, 'start', 2, 'default', 0, 1, 1);
INSERT INTO `cms_zones` (`zone_name`, `zone_title`, `zone_default_page`, `zone_header_text`, `zone_theme`, `zone_wide`, `zone_require_session`, `zone_displayed_in_menu`) VALUES('site', 9, 'start', 4, '-1', 0, 0, 1);
INSERT INTO `cms_zones` (`zone_name`, `zone_title`, `zone_default_page`, `zone_header_text`, `zone_theme`, `zone_wide`, `zone_require_session`, `zone_displayed_in_menu`) VALUES('collaboration', 10, 'start', 3, '-1', 0, 0, 1);
INSERT INTO `cms_zones` (`zone_name`, `zone_title`, `zone_default_page`, `zone_header_text`, `zone_theme`, `zone_wide`, `zone_require_session`, `zone_displayed_in_menu`) VALUES('cms', 11, 'cms', 5, 'default', 0, 1, 1);
INSERT INTO `cms_zones` (`zone_name`, `zone_title`, `zone_default_page`, `zone_header_text`, `zone_theme`, `zone_wide`, `zone_require_session`, `zone_displayed_in_menu`) VALUES('forum', 13, 'forumview', 12, '-1', NULL, 0, 1);
