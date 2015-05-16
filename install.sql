-- phpMyAdmin SQL Dump
-- version 3.2.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Aug 12, 2012 at 02:38 PM
-- Server version: 5.5.24
-- PHP Version: 5.2.4

--
-- Database: `test`
--

-- --------------------------------------------------------

--
-- Table structure for table `cms_addons`
--

DROP TABLE IF EXISTS `cms_addons`;
CREATE TABLE IF NOT EXISTS `cms_addons` (
  `addon_name` varchar(255) NOT NULL,
  `addon_author` varchar(255) NOT NULL,
  `addon_organisation` varchar(255) NOT NULL,
  `addon_version` varchar(255) NOT NULL,
  `addon_description` longtext NOT NULL,
  `addon_install_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`addon_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_addons`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_addons_dependencies`
--

DROP TABLE IF EXISTS `cms_addons_dependencies`;
CREATE TABLE IF NOT EXISTS `cms_addons_dependencies` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `addon_name` varchar(255) NOT NULL,
  `addon_name_dependant_upon` varchar(255) NOT NULL,
  `addon_name_incompatibility` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_addons_dependencies`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_addons_files`
--

DROP TABLE IF EXISTS `cms_addons_files`;
CREATE TABLE IF NOT EXISTS `cms_addons_files` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `addon_name` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_addons_files`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_adminlogs`
--

DROP TABLE IF EXISTS `cms_adminlogs`;
CREATE TABLE IF NOT EXISTS `cms_adminlogs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `the_type` varchar(80) NOT NULL,
  `param_a` varchar(80) NOT NULL,
  `param_b` varchar(255) NOT NULL,
  `the_user` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `xas` (`the_user`),
  KEY `ts` (`date_and_time`),
  KEY `aip` (`ip`),
  KEY `athe_type` (`the_type`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_adminlogs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_attachments`
--

DROP TABLE IF EXISTS `cms_attachments`;
CREATE TABLE IF NOT EXISTS `cms_attachments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_member_id` int(11) NOT NULL,
  `a_file_size` int(11) DEFAULT NULL,
  `a_url` varchar(255) NOT NULL,
  `a_description` varchar(255) NOT NULL,
  `a_thumb_url` varchar(255) NOT NULL,
  `a_original_filename` varchar(255) NOT NULL,
  `a_num_downloads` int(11) NOT NULL,
  `a_last_downloaded_time` int(11) DEFAULT NULL,
  `a_add_time` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ownedattachments` (`a_member_id`),
  KEY `attachmentlimitcheck` (`a_add_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_attachments`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_attachment_refs`
--

DROP TABLE IF EXISTS `cms_attachment_refs`;
CREATE TABLE IF NOT EXISTS `cms_attachment_refs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `r_referer_type` varchar(80) NOT NULL,
  `r_referer_id` varchar(80) NOT NULL,
  `a_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_attachment_refs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_authors`
--

DROP TABLE IF EXISTS `cms_authors`;
CREATE TABLE IF NOT EXISTS `cms_authors` (
  `author` varchar(80) NOT NULL,
  `url` varchar(255) NOT NULL,
  `forum_handle` int(11) DEFAULT NULL,
  `description` int(10) unsigned NOT NULL,
  `skills` int(10) unsigned NOT NULL,
  PRIMARY KEY (`author`),
  KEY `findmemberlink` (`forum_handle`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_authors`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_autosave`
--

DROP TABLE IF EXISTS `cms_autosave`;
CREATE TABLE IF NOT EXISTS `cms_autosave` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_member_id` int(11) NOT NULL,
  `a_key` longtext NOT NULL,
  `a_value` longtext NOT NULL,
  `a_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `myautosaves` (`a_member_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_autosave`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_award_archive`
--

DROP TABLE IF EXISTS `cms_award_archive`;
CREATE TABLE IF NOT EXISTS `cms_award_archive` (
  `a_type_id` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `content_id` varchar(80) NOT NULL,
  `member_id` int(11) NOT NULL,
  PRIMARY KEY (`a_type_id`,`date_and_time`),
  KEY `awardquicksearch` (`content_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_award_archive`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_award_types`
--

DROP TABLE IF EXISTS `cms_award_types`;
CREATE TABLE IF NOT EXISTS `cms_award_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `a_title` int(10) unsigned NOT NULL,
  `a_description` int(10) unsigned NOT NULL,
  `a_points` int(11) NOT NULL,
  `a_content_type` varchar(80) NOT NULL,
  `a_hide_awardee` tinyint(1) NOT NULL,
  `a_update_time_hours` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_award_types`
--

INSERT INTO `cms_award_types` (`id`, `a_title`, `a_description`, `a_points`, `a_content_type`, `a_hide_awardee`, `a_update_time_hours`) VALUES(1, 85, 86, 0, 'download', 1, 168);

-- --------------------------------------------------------

--
-- Table structure for table `cms_banners`
--

DROP TABLE IF EXISTS `cms_banners`;
CREATE TABLE IF NOT EXISTS `cms_banners` (
  `name` varchar(80) NOT NULL,
  `expiry_date` int(10) unsigned DEFAULT NULL,
  `submitter` int(11) NOT NULL,
  `img_url` varchar(255) NOT NULL,
  `the_type` tinyint(4) NOT NULL,
  `b_title_text` varchar(255) NOT NULL,
  `caption` int(10) unsigned NOT NULL,
  `b_direct_code` longtext NOT NULL,
  `campaign_remaining` int(11) NOT NULL,
  `site_url` varchar(255) NOT NULL,
  `hits_from` int(11) NOT NULL,
  `views_from` int(11) NOT NULL,
  `hits_to` int(11) NOT NULL,
  `views_to` int(11) NOT NULL,
  `importance_modulus` int(11) NOT NULL,
  `notes` longtext NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  `b_type` varchar(80) NOT NULL,
  PRIMARY KEY (`name`),
  KEY `banner_child_find` (`b_type`),
  KEY `the_type` (`the_type`),
  KEY `expiry_date` (`expiry_date`),
  KEY `badd_date` (`add_date`),
  KEY `topsites` (`hits_from`,`hits_to`),
  KEY `campaign_remaining` (`campaign_remaining`),
  KEY `bvalidated` (`validated`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_banners`
--

INSERT INTO `cms_banners` (`name`, `expiry_date`, `submitter`, `img_url`, `the_type`, `b_title_text`, `caption`, `b_direct_code`, `campaign_remaining`, `site_url`, `hits_from`, `views_from`, `hits_to`, `views_to`, `importance_modulus`, `notes`, `validated`, `add_date`, `edit_date`, `b_type`) VALUES('advertise_here', NULL, 1, 'data/images/advertise_here.png', 2, '', 135, '', 0, 'http://192.168.1.68/git/site/index.php?page=advertise', 0, 0, 0, 0, 10, 'Provided as default. This is a default banner (it shows when others are not available).', 1, 1344775597, NULL, '');
INSERT INTO `cms_banners` (`name`, `expiry_date`, `submitter`, `img_url`, `the_type`, `b_title_text`, `caption`, `b_direct_code`, `campaign_remaining`, `site_url`, `hits_from`, `views_from`, `hits_to`, `views_to`, `importance_modulus`, `notes`, `validated`, `add_date`, `edit_date`, `b_type`) VALUES('donate', NULL, 1, 'data/images/donate.png', 0, '', 136, '', 0, 'http://192.168.1.68/git/site/index.php?page=donate', 0, 0, 0, 0, 30, 'Provided as default.', 1, 1344775597, NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_banner_clicks`
--

DROP TABLE IF EXISTS `cms_banner_clicks`;
CREATE TABLE IF NOT EXISTS `cms_banner_clicks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_date_and_time` int(10) unsigned NOT NULL,
  `c_member_id` int(11) NOT NULL,
  `c_ip_address` varchar(40) NOT NULL,
  `c_source` varchar(80) NOT NULL,
  `c_banner_id` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `clicker_ip` (`c_ip_address`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_banner_clicks`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_banner_types`
--

DROP TABLE IF EXISTS `cms_banner_types`;
CREATE TABLE IF NOT EXISTS `cms_banner_types` (
  `id` varchar(80) NOT NULL,
  `t_is_textual` tinyint(1) NOT NULL,
  `t_image_width` int(11) NOT NULL,
  `t_image_height` int(11) NOT NULL,
  `t_max_file_size` int(11) NOT NULL,
  `t_comcode_inline` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hottext` (`t_comcode_inline`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_banner_types`
--

INSERT INTO `cms_banner_types` (`id`, `t_is_textual`, `t_image_width`, `t_image_height`, `t_max_file_size`, `t_comcode_inline`) VALUES('', 0, 468, 60, 80, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_blocks`
--

DROP TABLE IF EXISTS `cms_blocks`;
CREATE TABLE IF NOT EXISTS `cms_blocks` (
  `block_name` varchar(80) NOT NULL,
  `block_author` varchar(80) NOT NULL,
  `block_organisation` varchar(80) NOT NULL,
  `block_hacked_by` varchar(80) NOT NULL,
  `block_hack_version` int(11) DEFAULT NULL,
  `block_version` int(11) NOT NULL,
  PRIMARY KEY (`block_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_blocks`
--

INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('bottom_forum_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('bottom_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('bottom_rss', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_as_zone_access', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_awards', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_banner_wave', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_block_help', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_bottom_bar', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_cc_embed', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_code_documentor', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_comcode_page_children', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_comments', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_contact_catalogues', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_contact_simple', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_contact_us', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_content', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_content_filtering', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_count', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_countdown', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_custom_comcode_tags', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_custom_gfx', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_db_notes', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_download_category', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_download_tease', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_emoticon_codes', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_feedback', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_forum_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_forum_topics', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_gallery_embed', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_gallery_tease', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_greeting', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_image_fader', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_include_module', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_iotd', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_leader_board', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_member_bar', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_multi_content', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_newsletter_signup', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_notes', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_only_if_match', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_poll', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_pt_notifications', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_quotes', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_rating', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_recent_cc_entries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_recent_downloads', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_recent_galleries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_rss', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_screen_actions', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_search', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_sitemap', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_staff_actions', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_staff_checklist', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_staff_links', 'Jack Franklin', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_staff_new_version', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_staff_tips', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_staff_website_monitoring', 'Jack Franklin', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_top_downloads', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_top_galleries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_topsites', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('main_trackback', 'Philip Withnall', 'ocProducts', '', NULL, 1);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_calendar', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_forum_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_language', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_network', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_news_archive', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_news_categories', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_ocf_personal_topics', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_personal_stats', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_printer_friendly', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_root_galleries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_rss', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_shoutbox', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_stats', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_stored_menu', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_tag_cloud', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_users_online', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO `cms_blocks` (`block_name`, `block_author`, `block_organisation`, `block_hacked_by`, `block_hack_version`, `block_version`) VALUES('side_weather', 'Manuprathap', 'ocProducts', '', NULL, 6);

-- --------------------------------------------------------

--
-- Table structure for table `cms_bookmarks`
--

DROP TABLE IF EXISTS `cms_bookmarks`;
CREATE TABLE IF NOT EXISTS `cms_bookmarks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `b_owner` int(11) NOT NULL,
  `b_folder` varchar(255) NOT NULL,
  `b_title` varchar(255) NOT NULL,
  `b_page_link` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_bookmarks`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_cache`
--

DROP TABLE IF EXISTS `cms_cache`;
CREATE TABLE IF NOT EXISTS `cms_cache` (
  `cached_for` varchar(80) NOT NULL,
  `identifier` varchar(40) NOT NULL,
  `the_value` longtext NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `the_theme` varchar(80) NOT NULL,
  `lang` varchar(5) NOT NULL,
  `langs_required` longtext NOT NULL,
  PRIMARY KEY (`cached_for`,`identifier`,`the_theme`,`lang`),
  KEY `cached_ford` (`date_and_time`),
  KEY `cached_fore` (`cached_for`),
  KEY `cached_forf` (`lang`),
  KEY `cached_forg` (`identifier`),
  KEY `cached_forh` (`the_theme`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_cache`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_cached_comcode_pages`
--

DROP TABLE IF EXISTS `cms_cached_comcode_pages`;
CREATE TABLE IF NOT EXISTS `cms_cached_comcode_pages` (
  `the_zone` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `string_index` int(10) unsigned NOT NULL,
  `the_theme` varchar(80) NOT NULL,
  `cc_page_title` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`the_zone`,`the_page`,`the_theme`),
  KEY `ftjoin_ccpt` (`cc_page_title`),
  KEY `ftjoin_ccsi` (`string_index`),
  KEY `ccp_join` (`the_page`,`the_zone`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_cached_comcode_pages`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_cached_weather_codes`
--

DROP TABLE IF EXISTS `cms_cached_weather_codes`;
CREATE TABLE IF NOT EXISTS `cms_cached_weather_codes` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `w_string` varchar(255) NOT NULL,
  `w_code` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_cached_weather_codes`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_cache_on`
--

DROP TABLE IF EXISTS `cms_cache_on`;
CREATE TABLE IF NOT EXISTS `cms_cache_on` (
  `cached_for` varchar(80) NOT NULL,
  `cache_on` longtext NOT NULL,
  `cache_ttl` int(11) NOT NULL,
  PRIMARY KEY (`cached_for`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_cache_on`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_calendar_events`
--

DROP TABLE IF EXISTS `cms_calendar_events`;
CREATE TABLE IF NOT EXISTS `cms_calendar_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `e_submitter` int(11) NOT NULL,
  `e_views` int(11) NOT NULL,
  `e_title` int(10) unsigned NOT NULL,
  `e_content` int(10) unsigned NOT NULL,
  `e_add_date` int(10) unsigned NOT NULL,
  `e_edit_date` int(10) unsigned DEFAULT NULL,
  `e_recurrence` varchar(80) NOT NULL,
  `e_recurrences` int(11) DEFAULT NULL,
  `e_seg_recurrences` tinyint(1) NOT NULL,
  `e_start_year` int(11) NOT NULL,
  `e_start_month` int(11) NOT NULL,
  `e_start_day` int(11) NOT NULL,
  `e_start_monthly_spec_type` varchar(80) NOT NULL,
  `e_start_hour` int(11) DEFAULT NULL,
  `e_start_minute` int(11) DEFAULT NULL,
  `e_end_year` int(11) DEFAULT NULL,
  `e_end_month` int(11) DEFAULT NULL,
  `e_end_day` int(11) DEFAULT NULL,
  `e_end_monthly_spec_type` varchar(80) NOT NULL,
  `e_end_hour` int(11) DEFAULT NULL,
  `e_end_minute` int(11) DEFAULT NULL,
  `e_timezone` varchar(80) NOT NULL,
  `e_do_timezone_conv` tinyint(1) NOT NULL,
  `e_is_public` tinyint(1) NOT NULL,
  `e_priority` int(11) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `e_type` int(11) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `e_views` (`e_views`),
  KEY `ces` (`e_submitter`),
  KEY `publicevents` (`e_is_public`),
  KEY `e_type` (`e_type`),
  KEY `eventat` (`e_start_year`,`e_start_month`,`e_start_day`,`e_start_hour`,`e_start_minute`),
  KEY `e_add_date` (`e_add_date`),
  KEY `validated` (`validated`),
  KEY `ftjoin_etitle` (`e_title`),
  KEY `ftjoin_econtent` (`e_content`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_calendar_events`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_calendar_interests`
--

DROP TABLE IF EXISTS `cms_calendar_interests`;
CREATE TABLE IF NOT EXISTS `cms_calendar_interests` (
  `i_member_id` int(11) NOT NULL,
  `t_type` int(11) NOT NULL,
  PRIMARY KEY (`i_member_id`,`t_type`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_calendar_interests`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_calendar_jobs`
--

DROP TABLE IF EXISTS `cms_calendar_jobs`;
CREATE TABLE IF NOT EXISTS `cms_calendar_jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `j_time` int(10) unsigned NOT NULL,
  `j_reminder_id` int(11) DEFAULT NULL,
  `j_member_id` int(11) DEFAULT NULL,
  `j_event_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `applicablejobs` (`j_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_calendar_jobs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_calendar_reminders`
--

DROP TABLE IF EXISTS `cms_calendar_reminders`;
CREATE TABLE IF NOT EXISTS `cms_calendar_reminders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `e_id` int(11) NOT NULL,
  `n_member_id` int(11) NOT NULL,
  `n_seconds_before` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_calendar_reminders`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_calendar_types`
--

DROP TABLE IF EXISTS `cms_calendar_types`;
CREATE TABLE IF NOT EXISTS `cms_calendar_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `t_title` int(10) unsigned NOT NULL,
  `t_logo` varchar(255) NOT NULL,
  `t_external_feed` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=9 ;

--
-- Dumping data for table `cms_calendar_types`
--

INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(1, 137, 'calendar/system_command', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(2, 138, 'calendar/general', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(3, 139, 'calendar/birthday', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(4, 140, 'calendar/public_holiday', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(5, 141, 'calendar/vacation', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(6, 142, 'calendar/appointment', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(7, 143, 'calendar/commitment', '');
INSERT INTO `cms_calendar_types` (`id`, `t_title`, `t_logo`, `t_external_feed`) VALUES(8, 144, 'calendar/anniversary', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogues`
--

DROP TABLE IF EXISTS `cms_catalogues`;
CREATE TABLE IF NOT EXISTS `cms_catalogues` (
  `c_name` varchar(80) NOT NULL,
  `c_title` int(10) unsigned NOT NULL,
  `c_description` int(10) unsigned NOT NULL,
  `c_display_type` tinyint(4) NOT NULL,
  `c_is_tree` tinyint(1) NOT NULL,
  `c_notes` longtext NOT NULL,
  `c_add_date` int(10) unsigned NOT NULL,
  `c_submit_points` int(11) NOT NULL,
  `c_ecommerce` tinyint(1) NOT NULL,
  `c_send_view_reports` varchar(80) NOT NULL,
  PRIMARY KEY (`c_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_catalogues`
--

INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('projects', 147, 148, 0, 0, '', 1344775598, 30, 0, 'never');
INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('modifications', 165, 166, 1, 0, '', 1344775598, 60, 0, 'never');
INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('hosted', 181, 182, 0, 0, '', 1344775598, 0, 0, 'never');
INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('links', 193, 194, 2, 1, '', 1344775598, 0, 0, 'never');
INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('faqs', 205, 206, 0, 0, '', 1344775598, 0, 0, 'never');
INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('contacts', 217, 218, 0, 0, '', 1344775598, 30, 0, 'never');
INSERT INTO `cms_catalogues` (`c_name`, `c_title`, `c_description`, `c_display_type`, `c_is_tree`, `c_notes`, `c_add_date`, `c_submit_points`, `c_ecommerce`, `c_send_view_reports`) VALUES('products', 249, 250, 3, 1, '', 1344775598, 0, 1, 'never');

-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_categories`
--

DROP TABLE IF EXISTS `cms_catalogue_categories`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_name` varchar(80) NOT NULL,
  `cc_title` int(10) unsigned NOT NULL,
  `cc_description` int(10) unsigned NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  `cc_notes` longtext NOT NULL,
  `cc_add_date` int(10) unsigned NOT NULL,
  `cc_parent_id` int(11) DEFAULT NULL,
  `cc_move_target` int(11) DEFAULT NULL,
  `cc_move_days_lower` int(11) NOT NULL,
  `cc_move_days_higher` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `catstoclean` (`cc_move_target`),
  KEY `cataloguefind` (`c_name`),
  KEY `cc_parent_id` (`cc_parent_id`),
  KEY `ftjoin_cctitle` (`cc_title`),
  KEY `ftjoin_ccdescrip` (`cc_description`)
) ENGINE=MyISAM  AUTO_INCREMENT=7 ;

--
-- Dumping data for table `cms_catalogue_categories`
--

INSERT INTO `cms_catalogue_categories` (`id`, `c_name`, `cc_title`, `cc_description`, `rep_image`, `cc_notes`, `cc_add_date`, `cc_parent_id`, `cc_move_target`, `cc_move_days_lower`, `cc_move_days_higher`) VALUES(1, 'projects', 157, 158, '', '', 1344775598, NULL, NULL, 30, 60);
INSERT INTO `cms_catalogue_categories` (`id`, `c_name`, `cc_title`, `cc_description`, `rep_image`, `cc_notes`, `cc_add_date`, `cc_parent_id`, `cc_move_target`, `cc_move_days_lower`, `cc_move_days_higher`) VALUES(2, 'hosted', 189, 190, '', '', 1344775598, NULL, NULL, 30, 60);
INSERT INTO `cms_catalogue_categories` (`id`, `c_name`, `cc_title`, `cc_description`, `rep_image`, `cc_notes`, `cc_add_date`, `cc_parent_id`, `cc_move_target`, `cc_move_days_lower`, `cc_move_days_higher`) VALUES(3, 'links', 195, 196, '', '', 1344775598, NULL, NULL, 30, 60);
INSERT INTO `cms_catalogue_categories` (`id`, `c_name`, `cc_title`, `cc_description`, `rep_image`, `cc_notes`, `cc_add_date`, `cc_parent_id`, `cc_move_target`, `cc_move_days_lower`, `cc_move_days_higher`) VALUES(4, 'faqs', 213, 214, '', '', 1344775598, NULL, NULL, 30, 60);
INSERT INTO `cms_catalogue_categories` (`id`, `c_name`, `cc_title`, `cc_description`, `rep_image`, `cc_notes`, `cc_add_date`, `cc_parent_id`, `cc_move_target`, `cc_move_days_lower`, `cc_move_days_higher`) VALUES(5, 'contacts', 245, 246, '', '', 1344775598, NULL, NULL, 30, 60);
INSERT INTO `cms_catalogue_categories` (`id`, `c_name`, `cc_title`, `cc_description`, `rep_image`, `cc_notes`, `cc_add_date`, `cc_parent_id`, `cc_move_target`, `cc_move_days_lower`, `cc_move_days_higher`) VALUES(6, 'products', 251, 252, '', '', 1344775598, NULL, NULL, 30, 60);

-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_cat_treecache`
--

DROP TABLE IF EXISTS `cms_catalogue_cat_treecache`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_cat_treecache` (
  `cc_id` int(11) NOT NULL,
  `cc_ancestor_id` int(11) NOT NULL,
  PRIMARY KEY (`cc_id`,`cc_ancestor_id`),
  KEY `cc_ancestor_id` (`cc_ancestor_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_catalogue_cat_treecache`
--

INSERT INTO `cms_catalogue_cat_treecache` (`cc_id`, `cc_ancestor_id`) VALUES(1, 1);
INSERT INTO `cms_catalogue_cat_treecache` (`cc_id`, `cc_ancestor_id`) VALUES(2, 2);
INSERT INTO `cms_catalogue_cat_treecache` (`cc_id`, `cc_ancestor_id`) VALUES(4, 4);
INSERT INTO `cms_catalogue_cat_treecache` (`cc_id`, `cc_ancestor_id`) VALUES(5, 5);

-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_childcountcache`
--

DROP TABLE IF EXISTS `cms_catalogue_childcountcache`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_childcountcache` (
  `cc_id` int(11) NOT NULL,
  `c_num_rec_children` int(11) NOT NULL,
  `c_num_rec_entries` int(11) NOT NULL,
  PRIMARY KEY (`cc_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_catalogue_childcountcache`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_efv_float`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_float`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_efv_float` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fcv_value` (`cv_value`),
  KEY `fcf_id` (`cf_id`),
  KEY `fce_id` (`ce_id`),
  KEY `cefv_f_combo` (`ce_id`,`cf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_efv_float`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_efv_integer`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_integer`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_efv_integer` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `itv_value` (`cv_value`),
  KEY `icf_id` (`cf_id`),
  KEY `ice_id` (`ce_id`),
  KEY `cefv_i_combo` (`ce_id`,`cf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_efv_integer`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_efv_long`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_long`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_efv_long` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cefv_l_combo` (`ce_id`,`cf_id`),
  KEY `lcf_id` (`cf_id`),
  KEY `lce_id` (`ce_id`),
  FULLTEXT KEY `lcv_value` (`cv_value`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_efv_long`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_efv_long_trans`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_long_trans`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_efv_long_trans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cefv_lt_combo` (`ce_id`,`cf_id`),
  KEY `ltcf_id` (`cf_id`),
  KEY `ltce_id` (`ce_id`),
  KEY `ltcv_value` (`cv_value`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_efv_long_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_efv_short`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_short`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_efv_short` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cefv_s_combo` (`ce_id`,`cf_id`),
  KEY `iscv_value` (`cv_value`),
  KEY `scf_id` (`cf_id`),
  KEY `sce_id` (`ce_id`),
  FULLTEXT KEY `scv_value` (`cv_value`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_efv_short`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_efv_short_trans`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_short_trans`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_efv_short_trans` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cefv_st_combo` (`ce_id`,`cf_id`),
  KEY `stcf_id` (`cf_id`),
  KEY `stce_id` (`ce_id`),
  KEY `stcv_value` (`cv_value`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_efv_short_trans`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_entries`
--

DROP TABLE IF EXISTS `cms_catalogue_entries`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_entries` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_name` varchar(80) NOT NULL,
  `cc_id` int(11) NOT NULL,
  `ce_submitter` int(11) NOT NULL,
  `ce_add_date` int(10) unsigned NOT NULL,
  `ce_edit_date` int(10) unsigned DEFAULT NULL,
  `ce_views` int(11) NOT NULL,
  `ce_views_prior` int(11) NOT NULL,
  `ce_validated` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `ce_last_moved` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ce_views` (`ce_views`),
  KEY `ces` (`ce_submitter`),
  KEY `ce_validated` (`ce_validated`),
  KEY `ce_add_date` (`ce_add_date`),
  KEY `ce_c_name` (`c_name`),
  KEY `ce_cc_id` (`cc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_catalogue_entries`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_entry_linkage`
--

DROP TABLE IF EXISTS `cms_catalogue_entry_linkage`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_entry_linkage` (
  `catalogue_entry_id` int(11) NOT NULL,
  `content_type` varchar(80) NOT NULL,
  `content_id` varchar(80) NOT NULL,
  PRIMARY KEY (`catalogue_entry_id`),
  KEY `custom_fields` (`content_type`,`content_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_catalogue_entry_linkage`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_catalogue_fields`
--

DROP TABLE IF EXISTS `cms_catalogue_fields`;
CREATE TABLE IF NOT EXISTS `cms_catalogue_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_name` varchar(80) NOT NULL,
  `cf_name` int(10) unsigned NOT NULL,
  `cf_description` int(10) unsigned NOT NULL,
  `cf_type` varchar(80) NOT NULL,
  `cf_order` int(11) NOT NULL,
  `cf_defines_order` tinyint(4) NOT NULL,
  `cf_visible` tinyint(1) NOT NULL,
  `cf_searchable` tinyint(1) NOT NULL,
  `cf_default` longtext NOT NULL,
  `cf_required` tinyint(1) NOT NULL,
  `cf_put_in_category` tinyint(1) NOT NULL,
  `cf_put_in_search` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=43 ;

--
-- Dumping data for table `cms_catalogue_fields`
--

INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(1, 'projects', 149, 150, 'short_trans', 0, 1, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(2, 'projects', 151, 152, 'user', 1, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(3, 'projects', 153, 154, 'long_trans', 2, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(4, 'projects', 155, 156, 'integer', 3, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(5, 'modifications', 167, 168, 'short_trans', 0, 1, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(6, 'modifications', 169, 170, 'picture', 1, 0, 1, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(7, 'modifications', 171, 172, 'short_trans', 2, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(8, 'modifications', 173, 174, 'url', 3, 0, 1, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(9, 'modifications', 175, 176, 'long_trans', 4, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(10, 'modifications', 177, 178, 'short_text', 5, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(11, 'hosted', 183, 184, 'short_trans', 0, 1, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(12, 'hosted', 185, 186, 'url', 1, 0, 1, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(13, 'hosted', 187, 188, 'long_trans', 2, 0, 1, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(14, 'links', 197, 198, 'short_trans', 0, 1, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(15, 'links', 199, 200, 'url', 1, 0, 1, 1, '', 1, 0, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(16, 'links', 201, 202, 'long_trans', 2, 0, 1, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(17, 'faqs', 207, 208, 'short_trans', 0, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(18, 'faqs', 209, 210, 'long_trans', 1, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(19, 'faqs', 211, 212, 'auto_increment', 2, 1, 0, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(20, 'contacts', 219, 220, 'short_text', 0, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(21, 'contacts', 221, 222, 'short_text', 1, 1, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(22, 'contacts', 223, 224, 'short_text', 2, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(23, 'contacts', 225, 226, 'short_text', 3, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(24, 'contacts', 227, 228, 'short_text', 4, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(25, 'contacts', 229, 230, 'short_text', 5, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(26, 'contacts', 231, 232, 'short_text', 6, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(27, 'contacts', 233, 234, 'short_text', 7, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(28, 'contacts', 235, 236, 'short_text', 8, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(29, 'contacts', 237, 238, 'short_text', 9, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(30, 'contacts', 239, 240, 'long_text', 10, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(31, 'contacts', 241, 242, 'long_text', 11, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(32, 'contacts', 243, 244, 'picture', 12, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(33, 'products', 253, 254, 'short_trans', 0, 1, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(34, 'products', 255, 256, 'random', 1, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(35, 'products', 257, 258, 'float', 2, 0, 1, 1, '', 1, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(36, 'products', 259, 260, 'integer', 3, 0, 1, 0, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(37, 'products', 261, 262, 'integer', 4, 0, 0, 0, '', 0, 0, 0);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(38, 'products', 263, 264, 'list', 5, 0, 0, 0, 'No|Yes', 1, 0, 0);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(39, 'products', 265, 266, 'list', 6, 0, 0, 0, '0%|5%|17.5%', 1, 0, 0);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(40, 'products', 267, 268, 'picture', 7, 0, 1, 1, '', 0, 1, 1);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(41, 'products', 269, 270, 'float', 8, 0, 0, 0, '', 1, 0, 0);
INSERT INTO `cms_catalogue_fields` (`id`, `c_name`, `cf_name`, `cf_description`, `cf_type`, `cf_order`, `cf_defines_order`, `cf_visible`, `cf_searchable`, `cf_default`, `cf_required`, `cf_put_in_category`, `cf_put_in_search`) VALUES(42, 'products', 271, 272, 'long_trans', 9, 0, 1, 1, '', 1, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_chargelog`
--

DROP TABLE IF EXISTS `cms_chargelog`;
CREATE TABLE IF NOT EXISTS `cms_chargelog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `reason` int(10) unsigned NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_chargelog`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_active`
--

DROP TABLE IF EXISTS `cms_chat_active`;
CREATE TABLE IF NOT EXISTS `cms_chat_active` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `active_ordering` (`date_and_time`),
  KEY `member_select` (`member_id`),
  KEY `room_select` (`room_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_chat_active`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_blocking`
--

DROP TABLE IF EXISTS `cms_chat_blocking`;
CREATE TABLE IF NOT EXISTS `cms_chat_blocking` (
  `member_blocker` int(11) NOT NULL,
  `member_blocked` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`member_blocker`,`member_blocked`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_chat_blocking`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_buddies`
--

DROP TABLE IF EXISTS `cms_chat_buddies`;
CREATE TABLE IF NOT EXISTS `cms_chat_buddies` (
  `member_likes` int(11) NOT NULL,
  `member_liked` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`member_likes`,`member_liked`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_chat_buddies`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_events`
--

DROP TABLE IF EXISTS `cms_chat_events`;
CREATE TABLE IF NOT EXISTS `cms_chat_events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `e_type_code` varchar(80) NOT NULL,
  `e_member_id` int(11) NOT NULL,
  `e_room_id` int(11) DEFAULT NULL,
  `e_date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `event_ordering` (`e_date_and_time`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_chat_events`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_messages`
--

DROP TABLE IF EXISTS `cms_chat_messages`;
CREATE TABLE IF NOT EXISTS `cms_chat_messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `system_message` tinyint(1) NOT NULL,
  `ip_address` varchar(40) NOT NULL,
  `room_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `the_message` int(10) unsigned NOT NULL,
  `text_colour` varchar(255) NOT NULL,
  `font_name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ordering` (`date_and_time`),
  KEY `room_id` (`room_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_chat_messages`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_rooms`
--

DROP TABLE IF EXISTS `cms_chat_rooms`;
CREATE TABLE IF NOT EXISTS `cms_chat_rooms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `room_name` varchar(255) NOT NULL,
  `room_owner` int(11) DEFAULT NULL,
  `allow_list` longtext NOT NULL,
  `allow_list_groups` longtext NOT NULL,
  `disallow_list` longtext NOT NULL,
  `disallow_list_groups` longtext NOT NULL,
  `room_language` varchar(5) NOT NULL,
  `c_welcome` int(10) unsigned NOT NULL,
  `is_im` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `room_name` (`room_name`),
  KEY `is_im` (`is_im`,`room_name`),
  KEY `first_public` (`is_im`,`id`),
  KEY `allow_list` (`allow_list`(30))
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_chat_rooms`
--

INSERT INTO `cms_chat_rooms` (`id`, `room_name`, `room_owner`, `allow_list`, `allow_list_groups`, `disallow_list`, `disallow_list_groups`, `room_language`, `c_welcome`, `is_im`) VALUES(1, 'General chat', NULL, '', '', '', '', 'EN', 287, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_chat_sound_effects`
--

DROP TABLE IF EXISTS `cms_chat_sound_effects`;
CREATE TABLE IF NOT EXISTS `cms_chat_sound_effects` (
  `s_member` int(11) NOT NULL,
  `s_effect_id` varchar(80) NOT NULL,
  `s_url` varchar(255) NOT NULL,
  PRIMARY KEY (`s_member`,`s_effect_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_chat_sound_effects`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_comcode_pages`
--

DROP TABLE IF EXISTS `cms_comcode_pages`;
CREATE TABLE IF NOT EXISTS `cms_comcode_pages` (
  `the_zone` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `p_parent_page` varchar(80) NOT NULL,
  `p_validated` tinyint(1) NOT NULL,
  `p_edit_date` int(10) unsigned DEFAULT NULL,
  `p_add_date` int(10) unsigned NOT NULL,
  `p_submitter` int(11) NOT NULL,
  `p_show_as_edit` tinyint(1) NOT NULL,
  PRIMARY KEY (`the_zone`,`the_page`),
  KEY `p_submitter` (`p_submitter`),
  KEY `p_add_date` (`p_add_date`),
  KEY `p_validated` (`p_validated`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_comcode_pages`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_config`
--

DROP TABLE IF EXISTS `cms_config`;
CREATE TABLE IF NOT EXISTS `cms_config` (
  `the_name` varchar(80) NOT NULL,
  `human_name` varchar(80) NOT NULL,
  `c_set` tinyint(1) NOT NULL,
  `config_value` longtext NOT NULL,
  `the_type` varchar(80) NOT NULL,
  `eval` varchar(255) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `section` varchar(80) NOT NULL,
  `explanation` varchar(80) NOT NULL,
  `shared_hosting_restricted` tinyint(1) NOT NULL,
  `c_data` varchar(255) NOT NULL,
  PRIMARY KEY (`the_name`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_config`
--

INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('encryption_key', 'ENCRYPTION_KEY', 0, '', 'line', 'require_code(''encryption'');return is_encryption_available()?'''':NULL;', 'PRIVACY', 'ADVANCED', 'CONFIG_OPTION_encryption_key', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('decryption_key', 'DECRYPTION_KEY', 0, '', 'line', 'require_code(''encryption'');return is_encryption_available()?'''':NULL;', 'PRIVACY', 'ADVANCED', 'CONFIG_OPTION_decryption_key', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_post_titles', 'IS_ON_POST_TITLES', 0, '', 'tick', 'return is_null($old=get_value(''no_post_titles''))?''0'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_post_titles', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_anonymous_posts', 'IS_ON_ANONYMOUS_POSTS', 0, '', 'tick', 'return is_null($old=get_value(''ocf_no_anonymous_post''))?''0'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_anonymous_posts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_timezone_detection', 'IS_ON_TIMEZONE_DETECTION', 0, '', 'tick', 'return is_null($old=get_value(''no_js_timezone_detect''))?''0'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_timezone_detection', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_topic_descriptions', 'IS_ON_TOPIC_DESCRIPTIONS', 0, '', 'tick', 'return is_null($old=get_value(''no_topic_descriptions''))?''1'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_topic_descriptions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_topic_emoticons', 'IS_ON_TOPIC_EMOTICONS', 0, '', 'tick', 'return is_null($old=get_value(''ocf_no_topic_emoticons''))?''1'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_topic_emoticons', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('default_preview_guests', 'DEFAULT_PREVIEW_GUESTS', 0, '', 'tick', 'return is_null($old=get_value(''no_default_preview_guests''))?''0'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_default_preview_guests', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forced_preview_option', 'FORCED_PREVIEW_OPTION', 0, '', 'tick', 'return is_null($old=get_value(''no_forced_preview_option''))?''0'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_forced_preview_option', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('overt_whisper_suggestion', 'OVERT_WHISPER_SUGGESTION', 0, '', 'tick', 'return is_null($old=get_value(''disable_overt_whispering''))?''1'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_overt_whisper_suggestion', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_invisibility', 'IS_ON_INVISIBILITY', 0, '', 'tick', 'return is_null($old=get_value(''no_invisible_option''))?''0'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_invisibility', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_alpha_search', 'ALLOW_ALPHA_SEARCH', 0, '', 'tick', 'return is_null($old=get_value(''allow_alpha_search''))?''0'':$old;', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_allow_alpha_search', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_email_disable', 'ALLOW_EMAIL_DISABLE', 0, '', 'tick', 'return is_null($old=get_value(''disable_allow_emails_field''))?''1'':invert_value($old);', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_allow_email_disable', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_member_title_length', 'MAX_MEMBER_TITLE_LENGTH', 0, '', 'integer', 'return addon_installed(''ocf_member_titles'')?''20'':NULL;', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_max_member_title_length', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('httpauth_is_enabled', 'HTTPAUTH_IS_ENABLED', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'ADVANCED', 'CONFIG_OPTION_httpauth_is_enabled', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('post_history_days', 'POST_HISTORY_DAYS', 0, '', 'integer', 'return ''21'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_post_history_days', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_posts_per_page', 'FORUM_POSTS_PER_PAGE', 0, '', 'integer', 'return has_no_forum()?NULL:''20'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_forum_posts_per_page', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_topics_per_page', 'FORUM_TOPICS_PER_PAGE', 0, '', 'integer', 'return has_no_forum()?NULL:''30'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_forum_topics_per_page', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('prevent_shouting', 'PREVENT_SHOUTING', 0, '', 'tick', 'return has_no_forum()?NULL:''1'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_prevent_shouting', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('restricted_usernames', 'RESTRICTED_USERNAMES', 0, '', 'line', 'return do_lang(''GUEST'').'', ''.do_lang(''STAFF'').'', ''.do_lang(''ADMIN'').'', ''.do_lang(''MODERATOR'').'', googlebot'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_restricted_usernames', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('require_new_member_validation', 'REQUIRE_NEW_MEMBER_VALIDATION', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_require_new_member_validation', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('reported_posts_forum', 'REPORTED_POSTS_FORUM', 0, '', 'forum', 'return (has_no_forum()||(!addon_installed(''ocf_reported_posts'')))?NULL:do_lang(''ocf:REPORTED_POSTS_FORUM'');', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_reported_posts_forum', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('one_per_email_address', 'ONE_PER_EMAIL_ADDRESS', 0, '', 'tick', 'return ''1'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_one_per_email_address', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('hot_topic_definition', 'HOT_TOPIC_DEFINITION', 0, '', 'integer', 'return has_no_forum()?NULL:''20'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_hot_topic_definition', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('minimum_password_length', 'MINIMUM_PASSWORD_LENGTH', 0, '', 'integer', 'return ''4'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_minimum_password_length', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_password_length', 'MAXIMUM_PASSWORD_LENGTH', 0, '', 'integer', 'return ''20'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_maximum_password_length', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('minimum_username_length', 'MINIMUM_USERNAME_LENGTH', 0, '', 'integer', 'return ''1'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_minimum_username_length', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_username_length', 'MAXIMUM_USERNAME_LENGTH', 0, '', 'integer', 'return ''20'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_maximum_username_length', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('prohibit_password_whitespace', 'PROHIBIT_PASSWORD_WHITESPACE', 0, '', 'tick', 'return ''1'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_prohibit_password_whitespace', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('prohibit_username_whitespace', 'PROHIBIT_USERNAME_WHITESPACE', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_prohibit_username_whitespace', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('random_avatars', 'ASSIGN_RANDOM_AVATARS', 0, '', 'tick', 'return addon_installed(''ocf_member_avatars'')?''1'':NULL;', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_random_avatars', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('club_forum_parent_forum', 'CLUB_FORUM_PARENT_FORUM', 0, '', 'forum', 'return has_no_forum()?NULL:strval(db_get_first_id());', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_club_forum_parent_forum', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('club_forum_parent_category', 'CLUB_FORUM_PARENT_CATEGORY', 0, '', 'category', 'return has_no_forum()?NULL:strval(db_get_first_id());', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_club_forum_parent_category', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('delete_trashed_pts', 'DELETE_TRASHED_PTS', 0, '', 'tick', 'return has_no_forum()?NULL:''0'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_delete_trashed_pts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('probation_usergroup', 'PROBATION_USERGROUP', 0, '', 'usergroup', 'return do_lang(''PROBATION'');', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_probation_usergroup', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_first_join_page', 'SHOW_FIRST_JOIN_PAGE', 0, '', 'tick', 'return ''1'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_show_first_join_page', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('skip_email_confirm_join', 'SKIP_EMAIL_CONFIRM_JOIN', 0, '', 'tick', 'return ''1'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_skip_email_confirm_join', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('no_dob_ask', 'NO_DOB_ASK', 0, '', 'list', 'return ''0'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_no_dob_ask', 0, '0|1|2');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_international', 'ALLOW_INTERNATIONAL', 0, '', 'tick', 'return ''1'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_allow_international', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_email_from_staff_disable', 'ALLOW_EMAIL_FROM_STAFF_DISABLE', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_allow_email_from_staff_disable', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('intro_forum_id', 'INTRO_FORUM_ID', 0, '', '?forum', 'return '''';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_intro_forum_id', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('signup_fullname', 'SIGNUP_FULLNAME', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'USERNAMES_AND_PASSWORDS', 'CONFIG_OPTION_signup_fullname', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_coppa', 'COPPA_ENABLED', 0, '', 'tick', 'return ''0'';', 'PRIVACY', 'GENERAL', 'CONFIG_OPTION_is_on_coppa', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('privacy_fax', 'FAX_NUMBER', 0, '', 'line', 'return '''';', 'PRIVACY', 'GENERAL', 'CONFIG_OPTION_privacy_fax', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('privacy_postal_address', 'ADDRESS', 0, '', 'text', 'return '''';', 'PRIVACY', 'GENERAL', 'CONFIG_OPTION_privacy_postal_address', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_invites', 'INVITES_ENABLED', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_is_on_invites', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('invites_per_day', 'INVITES_PER_DAY', 0, '', 'float', 'return ''1'';', 'SECTION_FORUMS', 'GENERAL', 'CONFIG_OPTION_invites_per_day', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('url_monikers_enabled', 'URL_MONIKERS_ENABLED', 0, '', 'tick', 'return ''1'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_url_monikers_enabled', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_time', 'BACKUP_REGULARITY', 0, '', 'integer', 'return ''168'';', 'ADMIN', 'CHECK_LIST', 'CONFIG_OPTION_backup_time', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_server_hostname', 'BACKUP_SERVER_HOSTNAME', 0, '', 'line', 'return '''';', 'FEATURE', 'BACKUP', 'CONFIG_OPTION_backup_server_hostname', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_server_port', 'BACKUP_SERVER_PORT', 0, '', 'integer', 'return ''21'';', 'FEATURE', 'BACKUP', 'CONFIG_OPTION_backup_server_port', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_server_user', 'BACKUP_SERVER_USER', 0, '', 'line', 'return '''';', 'FEATURE', 'BACKUP', 'CONFIG_OPTION_backup_server_user', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_server_password', 'BACKUP_SERVER_PASSWORD', 0, '', 'line', 'return '''';', 'FEATURE', 'BACKUP', 'CONFIG_OPTION_backup_server_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_server_path', 'BACKUP_SERVER_PATH', 0, '', 'line', 'return '''';', 'FEATURE', 'BACKUP', 'CONFIG_OPTION_backup_server_path', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('backup_overwrite', 'BACKUP_OVERWRITE', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'BACKUP', 'CONFIG_OPTION_backup_overwrite', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_block_cache', 'BLOCK_CACHE', 0, '', 'tick', 'return $GLOBALS[''SEMI_DEV_MODE'']?''0'':''1'';', 'SITE', 'CACHES', 'CONFIG_OPTION_is_on_block_cache', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_template_cache', 'TEMPLATE_CACHE', 0, '', 'tick', 'return ''1'';', 'SITE', 'CACHES', 'CONFIG_OPTION_is_on_template_cache', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_comcode_page_cache', 'COMCODE_PAGE_CACHE', 0, '', 'tick', 'return ''1'';', 'SITE', 'CACHES', 'CONFIG_OPTION_is_on_comcode_page_cache', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_lang_cache', 'LANGUAGE_CACHE', 0, '', 'tick', 'return ''1'';', 'SITE', 'CACHES', 'CONFIG_OPTION_is_on_lang_cache', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('mod_rewrite', 'MOD_REWRITE', 0, '', 'tick', 'return ''0''; /*function_exists(''apache_get_modules'')?''1'':''0'';*/', 'SITE', 'ADVANCED', 'CONFIG_OPTION_mod_rewrite', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('session_expiry_time', 'SESSION_EXPIRY_TIME', 0, '', 'integer', 'return ''1'';', 'SECURITY', 'GENERAL', 'CONFIG_OPTION_session_expiry_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_trackbacks', 'TRACKBACKS', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_is_on_trackbacks', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('unzip_dir', 'UNZIP_DIR', 0, '', 'line', 'return (DIRECTORY_SEPARATOR==''/'')?''/tmp/'':cms_srv(''TMP'');', 'SITE', 'ARCHIVES', 'CONFIG_OPTION_unzip_dir', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('unzip_cmd', 'UNZIP_CMD', 0, '', 'line', 'return ''/usr/bin/unzip -o @_SRC_@ -x -d @_DST_@'';', 'SITE', 'ARCHIVES', 'CONFIG_OPTION_unzip_cmd', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('smtp_sockets_use', 'ENABLED', 0, '', 'tick', 'return ''0'';', 'SITE', 'SMTP', 'CONFIG_OPTION_smtp_sockets_use', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('smtp_sockets_host', 'HOST', 0, '', 'line', 'return ''mail.yourispwhateveritis.net'';', 'SITE', 'SMTP', 'CONFIG_OPTION_smtp_sockets_host', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('smtp_sockets_port', 'PORT', 0, '', 'line', 'return ''25'';', 'SITE', 'SMTP', 'CONFIG_OPTION_smtp_sockets_port', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('smtp_sockets_username', 'USERNAME', 0, '', 'line', 'return '''';', 'SITE', 'SMTP', 'CONFIG_OPTION_smtp_sockets_username', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('smtp_sockets_password', 'PASSWORD', 0, '', 'line', 'return '''';', 'SITE', 'SMTP', 'CONFIG_OPTION_smtp_sockets_password', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('smtp_from_address', 'EMAIL_ADDRESS', 0, '', 'line', 'return '''';', 'SITE', 'SMTP', 'CONFIG_OPTION_smtp_from_address', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('use_security_images', 'USE_SECURITY_IMAGES', 0, '', 'tick', 'return ''1'';', 'SECURITY', 'GENERAL', 'CONFIG_OPTION_use_security_images', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('enable_https', 'HTTPS_SUPPORT', 0, '', 'tick', 'return ''0'';', 'SECURITY', 'GENERAL', 'CONFIG_OPTION_enable_https', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('send_error_emails_cmsroducts', 'SEND_ERROR_EMAILS_CMSRODUCTS', 0, '', 'tick', 'return 1;', 'SITE', 'ADVANCED', 'CONFIG_OPTION_send_error_emails_cmsroducts', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('low_space_check', 'LOW_DISK_SPACE_SUBJECT', 0, '', 'integer', 'return ''20'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_low_space_check', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('detect_lang_forum', 'DETECT_LANG_FORUM', 0, '', 'tick', 'return ''1'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_detect_lang_forum', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('detect_lang_browser', 'DETECT_LANG_BROWSER', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_detect_lang_browser', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_audio_videos', 'ALLOW_AUDIO_VIDEOS', 0, '', 'tick', 'return ''1'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_allow_audio_videos', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation', 'VALIDATION', 0, '', 'tick', 'return ''0'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation_xhtml', 'VALIDATION_XHTML', 0, '', 'tick', 'return ''1'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation_xhtml', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation_wcag', 'VALIDATION_WCAG', 0, '', 'tick', 'return ''1'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation_wcag', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation_css', 'VALIDATION_CSS', 0, '', 'tick', 'return ''0'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation_css', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation_javascript', 'VALIDATION_JAVASCRIPT', 0, '', 'tick', 'return ''0'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation_javascript', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation_compat', 'VALIDATION_COMPAT', 0, '', 'tick', 'return ''0'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation_compat', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('validation_ext_files', 'VALIDATION_EXT_FILES', 0, '', 'tick', 'return ''0'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_validation_ext_files', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_download_size', 'MAX_SIZE', 0, '', 'integer', 'return ''20000'';', 'SITE', 'UPLOAD', 'CONFIG_OPTION_max_download_size', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_username', 'USERNAME', 0, '', 'line', 'return addon_installed(''sms'')?'''':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_username', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_password', 'PASSWORD', 0, '', 'line', 'return addon_installed(''sms'')?'''':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_api_id', 'API_ID', 0, '', 'integer', 'return addon_installed(''sms'')?'''':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_api_id', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_low_limit', 'SMS_LOW_LIMIT', 0, '', 'integer', 'return addon_installed(''sms'')?''10'':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_low_limit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_high_limit', 'SMS_HIGH_LIMIT', 0, '', 'integer', 'return addon_installed(''sms'')?''20'':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_high_limit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_low_trigger_limit', 'SMS_LOW_TRIGGER_LIMIT', 0, '', 'integer', 'return addon_installed(''sms'')?''50'':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_low_trigger_limit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sms_high_trigger_limit', 'SMS_HIGH_TRIGGER_LIMIT', 0, '', 'integer', 'return addon_installed(''sms'')?''100'':NULL;', 'FEATURE', 'SMS', 'CONFIG_OPTION_sms_high_trigger_limit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allowed_post_submitters', 'ALLOWED_POST_SUBMITTERS', 0, '', 'text', 'return '''';', 'SECURITY', 'ADVANCED', 'CONFIG_OPTION_allowed_post_submitters', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_strong_forum_tie', 'STRONG_FORUM_TIE', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_is_on_strong_forum_tie', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_preview_validation', 'VALIDATION_ON_PREVIEW', 0, '', 'tick', 'return ''1'';', 'SITE', 'VALIDATION', 'CONFIG_OPTION_is_on_preview_validation', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_inline_stats', 'SHOW_INLINE_STATS', 0, '', 'tick', 'return ''1'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_show_inline_stats', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('simplified_donext', 'SIMPLIFIED_DONEXT', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_simplified_donext', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('anti_leech', 'ANTI_LEECH', 0, '', 'tick', 'return ''0'';', 'SECURITY', 'GENERAL', 'CONFIG_OPTION_anti_leech', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ssw', 'SSW', 0, '', 'tick', 'return ''0'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_ssw', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_admin_menu', 'ADMIN_MENU', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_admin_menu', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_top_button', 'TOP_LINK', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_top_button', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_feedback_link', 'FEEDBACK_LINK', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_feedback_link', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_privacy_link', 'PRIVACY_LINK', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_privacy_link', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_sitemap_button', 'SITEMAP_LINK', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_sitemap_button', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_personal_stats_posts', 'COUNT_POSTSCOUNT', 0, '', 'tick', 'return has_no_forum()?NULL:''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_forum_show_personal_stats_posts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_personal_stats_topics', 'COUNT_TOPICSCOUNT', 0, '', 'tick', 'return ((has_no_forum()) || (get_forum_type()!=''ocf''))?NULL:''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_forum_show_personal_stats_topics', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_personal_adminzone_link', 'ADMIN_ZONE_LINK', 0, '', 'tick', 'return ''1'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_personal_adminzone_link', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_conceded_mode_link', 'CONCEDED_MODE_LINK', 0, '', 'tick', 'return ''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_conceded_mode_link', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_su', 'SU', 0, '', 'tick', 'return has_no_forum()?NULL:''1'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_su', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_staff_page_actions', 'PAGE_ACTIONS', 0, '', 'tick', 'return ''1'';', 'THEME', 'GENERAL', 'CONFIG_OPTION_cms_show_staff_page_actions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ocf_show_profile_link', 'MY_PROFILE_LINK', 0, '', 'tick', 'return has_no_forum()?NULL:''1'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_ocf_show_profile_link', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_personal_usergroup', '_USERGROUP', 0, '', 'tick', 'return has_no_forum()?NULL:''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_personal_usergroup', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_personal_last_visit', 'LAST_HERE', 0, '', 'tick', 'return has_no_forum()?NULL:''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_personal_last_visit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_avatar', 'AVATAR', 0, '', 'tick', 'return (has_no_forum() || ((get_forum_type()==''ocf'') && (!addon_installed(''ocf_member_avatars''))))?NULL:''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_avatar', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('root_zone_login_theme', 'ROOT_ZONE_LOGIN_THEME', 0, '', 'tick', 'return ''0'';', 'THEME', 'GENERAL', 'CONFIG_OPTION_root_zone_login_theme', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_docs', 'SHOW_DOCS', 0, '', 'tick', 'return ''1'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_show_docs', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('captcha_noise', 'CAPTCHA_NOISE', 0, '', 'tick', 'return addon_installed(''captcha'')?''1'':NULL;', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_captcha_noise', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('captcha_on_feedback', 'CAPTCHA_ON_FEEDBACK', 0, '', 'tick', 'return addon_installed(''captcha'')?''0'':NULL;', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_captcha_on_feedback', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_post_validation', 'SHOW_POST_VALIDATION', 0, '', 'tick', 'return ''1'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_show_post_validation', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ip_forwarding', 'IP_FORWARDING', 0, '', 'tick', 'return ''0'';', 'SITE', 'ENVIRONMENT', 'CONFIG_OPTION_ip_forwarding', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('force_meta_refresh', 'FORCE_META_REFRESH', 0, '', 'tick', 'return ''0'';', 'SITE', 'ENVIRONMENT', 'CONFIG_OPTION_force_meta_refresh', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('use_contextual_dates', 'USE_CONTEXTUAL_DATES', 0, '', 'tick', 'return ''1'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_use_contextual_dates', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('eager_wysiwyg', 'EAGER_WYSIWYG', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_eager_wysiwyg', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('website_email', 'WEBSITE_EMAIL', 0, '', 'line', '$staff_address=get_option(''staff_address''); $website_email=''website@''.get_domain(); if (substr($staff_address,-strlen(get_domain())-1)==''@''.get_domain()) $website_email=$staff_address; return $website_email;', 'SITE', 'EMAIL', 'CONFIG_OPTION_website_email', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('enveloper_override', 'ENVELOPER_OVERRIDE', 0, '', 'tick', 'return ''0'';', 'SITE', 'EMAIL', 'CONFIG_OPTION_enveloper_override', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bcc', 'BCC', 0, '', 'tick', 'return ''1'';', 'SITE', 'EMAIL', 'CONFIG_OPTION_bcc', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_ext_images', 'ALLOW_EXT_IMAGES', 0, '', 'tick', 'return ''0'';', 'SITE', 'EMAIL', 'CONFIG_OPTION_allow_ext_images', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('htm_short_urls', 'HTM_SHORT_URLS', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_htm_short_urls', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ip_strict_for_sessions', 'IP_STRICT_FOR_SESSIONS', 0, '', 'tick', 'return ''1'';', 'SECURITY', 'GENERAL', 'CONFIG_OPTION_ip_strict_for_sessions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('enable_previews', 'ENABLE_PREVIEWS', 0, '', 'tick', 'return ''1'';', 'SITE', 'PREVIEW', 'CONFIG_OPTION_enable_previews', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('enable_keyword_density_check', 'ENABLE_KEYWORD_DENSITY_CHECK', 0, '', 'tick', 'return ''0'';', 'SITE', 'PREVIEW', 'CONFIG_OPTION_enable_keyword_density_check', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('enable_spell_check', 'ENABLE_SPELL_CHECK', 0, '', 'tick', 'return function_exists(''pspell_check'')?''0'':NULL;', 'SITE', 'PREVIEW', 'CONFIG_OPTION_enable_spell_check', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('enable_markup_validation', 'ENABLE_MARKUP_VALIDATION', 0, '', 'tick', 'return ''0'';', 'SITE', 'PREVIEW', 'CONFIG_OPTION_enable_markup_validation', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('auto_submit_sitemap', 'AUTO_SUBMIT_SITEMAP', 0, '', 'tick', 'return ''0'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_auto_submit_sitemap', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('user_postsize_errors', 'USER_POSTSIZE_ERRORS', 0, '', 'tick', 'return is_null($old=get_value(''no_user_postsize_errors''))?''1'':invert_value($old);', 'SITE', 'UPLOAD', 'CONFIG_OPTION_user_postsize_errors', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('automatic_meta_extraction', 'AUTOMATIC_META_EXTRACTION', 0, '', 'tick', 'return is_null($old=get_option(''no_auto_meta''))?''1'':invert_value($old);', 'SITE', 'GENERAL', 'CONFIG_OPTION_automatic_meta_extraction', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_emoticon_choosers', 'IS_ON_EMOTICON_CHOOSERS', 0, '', 'tick', 'return is_null($old=get_value(''no_emoticon_choosers''))?''1'':invert_value($old);', 'THEME', 'GENERAL', 'CONFIG_OPTION_is_on_emoticon_choosers', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('deeper_admin_breadcrumbs', 'DEEPER_ADMIN_BREADCRUMBS', 0, '', 'tick', 'return is_null($old=get_value(''no_admin_menu_assumption''))?''1'':invert_value($old);', 'SITE', 'ADVANCED', 'CONFIG_OPTION_deeper_admin_breadcrumbs', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('has_low_memory_limit', 'HAS_LOW_MEMORY_LIMIT', 0, '', 'tick', 'return is_null($old=get_value(''has_low_memory_limit''))?((ini_get(''memory_limit'')==''-1'' || ini_get(''memory_limit'')==''0'' || ini_get(''memory_limit'')=='''')?''0'':NULL):$old;', 'SITE', 'ADVANCED', 'CONFIG_OPTION_has_low_memory_limit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_comcode_page_children', 'IS_ON_COMCODE_PAGE_CHILDREN', 0, '', 'tick', 'return is_null($old=get_value(''disable_comcode_page_children''))?''1'':invert_value($old);', 'SITE', 'ADVANCED', 'CONFIG_OPTION_is_on_comcode_page_children', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('global_donext_icons', 'GLOBAL_DONEXT_ICONS', 0, '', 'tick', 'return is_null($old=get_value(''disable_donext_global''))?''1'':invert_value($old);', 'SITE', 'ADVANCED', 'CONFIG_OPTION_global_donext_icons', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('no_stats_when_closed', 'NO_STATS_WHEN_CLOSED', 0, '', 'tick', 'return ''0'';', 'SITE', 'CLOSED_SITE', 'CONFIG_OPTION_no_stats_when_closed', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('no_bot_stats', 'NO_BOT_STATS', 0, '', 'tick', 'return ''0'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_no_bot_stats', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('filesystem_caching', 'FILE_SYSTEM_CACHING', 0, '', 'tick', 'return ''0'';', 'SITE', 'CACHES', 'CONFIG_OPTION_filesystem_caching', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('java_upload', 'ENABLE_JAVA_UPLOAD', 0, '', 'tick', 'return ''0'';', 'SITE', 'JAVA_UPLOAD', 'CONFIG_OPTION_java_upload', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('java_ftp_host', 'JAVA_FTP_HOST', 0, '', 'line', 'return cms_srv(''HTTP_HOST'');', 'SITE', 'JAVA_UPLOAD', 'CONFIG_OPTION_java_ftp_host', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('java_username', 'JAVA_FTP_USERNAME', 0, '', 'line', 'return ''anonymous'';', 'SITE', 'JAVA_UPLOAD', 'CONFIG_OPTION_java_username', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('java_password', 'JAVA_FTP_PASSWORD', 0, '', 'line', 'return ''someone@example.com'';', 'SITE', 'JAVA_UPLOAD', 'CONFIG_OPTION_java_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('java_ftp_path', 'JAVA_FTP_PATH', 0, '', 'line', 'return ''/public_html/uploads/incoming/'';', 'SITE', 'JAVA_UPLOAD', 'CONFIG_OPTION_java_ftp_path', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('advanced_admin_cache', 'ADVANCED_ADMIN_CACHE', 0, '', 'tick', 'return ''0'';', 'SITE', 'CACHES', 'CONFIG_OPTION_advanced_admin_cache', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('collapse_user_zones', 'COLLAPSE_USER_ZONES', 0, '', 'tick', 'return ''0'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_collapse_user_zones', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('check_broken_urls', 'CHECK_BROKEN_URLS', 0, '', 'tick', 'return ''1'';', 'SITE', '_COMCODE', 'CONFIG_OPTION_check_broken_urls', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('google_analytics', 'GOOGLE_ANALYTICS', 0, '', 'line', 'return '''';', 'SITE', 'GENERAL', 'CONFIG_OPTION_google_analytics', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('fixed_width', 'FIXED_WIDTH', 0, '', 'tick', 'return ''1'';', 'THEME', 'GENERAL', 'CONFIG_OPTION_fixed_width', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_content_tagging', 'SHOW_CONTENT_TAGGING', 0, '', 'tick', 'return ''0'';', 'THEME', 'GENERAL', 'CONFIG_OPTION_show_content_tagging', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_content_tagging_inline', 'SHOW_CONTENT_TAGGING_INLINE', 0, '', 'tick', 'return ''0'';', 'THEME', 'GENERAL', 'CONFIG_OPTION_show_content_tagging_inline', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_screen_actions', 'SHOW_SCREEN_ACTIONS', 0, '', 'tick', 'return ''1'';', 'THEME', 'GENERAL', 'CONFIG_OPTION_show_screen_actions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cms_show_personal_sub_links', 'PERSONAL_SUB_LINKS', 0, '', 'tick', 'return ''1'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_cms_show_personal_sub_links', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('long_google_cookies', 'LONG_GOOGLE_COOKIES', 0, '', 'tick', 'return ''0'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_long_google_cookies', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('remember_me_by_default', 'REMEMBER_ME_BY_DEFAULT', 0, '', 'tick', 'return ''0'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_remember_me_by_default', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('detect_javascript', 'DETECT_JAVASCRIPT', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_detect_javascript', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('mobile_support', 'MOBILE_SUPPORT', 0, '', 'tick', 'return ''1'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_mobile_support', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('mail_queue', 'MAIL_QUEUE', 0, '', 'tick', 'return ''0'';', 'SITE', 'EMAIL', 'CONFIG_OPTION_mail_queue', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('mail_queue_debug', 'MAIL_QUEUE_DEBUG', 0, '', 'tick', 'return ''0'';', 'SITE', 'EMAIL', 'CONFIG_OPTION_mail_queue_debug', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('comments_to_show_in_thread', 'COMMENTS_TO_SHOW_IN_THREAD', 0, '', 'integer', 'return ''30'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_comments_to_show_in_thread', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_thread_depth', 'MAX_THREAD_DEPTH', 0, '', 'integer', 'return ''6'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_max_thread_depth', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('complex_uploader', 'COMPLEX_UPLOADER', 0, '', 'tick', 'return ''1'';', 'ACCESSIBILITY', 'GENERAL', 'CONFIG_OPTION_complex_uploader', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('wysiwyg', 'ENABLE_WYSIWYG', 0, '', 'tick', 'return ''1'';', 'ACCESSIBILITY', 'GENERAL', 'CONFIG_OPTION_wysiwyg', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('editarea', 'EDITAREA', 0, '', 'tick', 'return ''1'';', 'ACCESSIBILITY', 'GENERAL', 'CONFIG_OPTION_editarea', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('js_overlays', 'JS_OVERLAYS', 0, '', 'tick', 'return ''1'';', 'ACCESSIBILITY', 'GENERAL', 'CONFIG_OPTION_js_overlays', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('tree_lists', 'TREE_LISTS', 0, '', 'tick', 'return ''1'';', 'ACCESSIBILITY', 'GENERAL', 'CONFIG_OPTION_tree_lists', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('css_captcha', 'CSS_CAPTCHA', 0, '', 'tick', 'return ''1'';', 'SECURITY', 'SECURITY_IMAGE', 'CONFIG_OPTION_css_captcha', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('captcha_single_guess', 'CAPTCHA_SINGLE_GUESS', 0, '', 'tick', 'return ''1'';', 'SECURITY', 'SECURITY_IMAGE', 'CONFIG_OPTION_captcha_single_guess', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('autoban', 'ENABLE_AUTOBAN', 0, '', 'tick', 'return ''1'';', 'SECURITY', 'GENERAL', 'CONFIG_OPTION_autoban', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('likes', 'ENABLE_LIKES', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_likes', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_check_level', 'SPAM_CHECK_LEVEL', 0, '', 'list', 'return ''NEVER'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_check_level', 0, 'EVERYTHING|ACTIONS|GUESTACTIONS|JOINING|NEVER');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('stopforumspam_api_key', 'STOPFORUMSPAM_API_KEY', 0, '', 'line', 'return '''';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_stopforumspam_api_key', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('tornevall_api_username', 'TORNEVALL_API_USERNAME', 0, '', 'line', 'return class_exists(''SoapClient'')?'''':NULL;', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_tornevall_api_username', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('tornevall_api_password', 'TORNEVALL_API_PASSWORD', 0, '', 'line', 'return class_exists(''SoapClient'')?'''':NULL;', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_tornevall_api_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_block_lists', 'SPAM_BLOCK_LISTS', 0, '', 'line', 'return ''*.opm.tornevall.org'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_block_lists', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_cache_time', 'SPAM_CACHE_TIME', 0, '', 'integer', 'return ''60'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_cache_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_check_exclusions', 'SPAM_CHECK_EXCLUSIONS', 0, '', 'line', 'return ''127.0.0.1,''.cms_srv(''SERVER_ADDR'').'''';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_check_exclusions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_stale_threshold', 'SPAM_STALE_THRESHOLD', 0, '', 'integer', 'return ''31'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_stale_threshold', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_ban_threshold', 'SPAM_BAN_THRESHOLD', 0, '', 'integer', 'return ''90'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_ban_threshold', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_block_threshold', 'SPAM_BLOCK_THRESHOLD', 0, '', 'integer', 'return ''60'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_block_threshold', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_approval_threshold', 'SPAM_APPROVAL_THRESHOLD', 0, '', 'integer', 'return ''40'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_approval_threshold', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_check_usernames', 'SPAM_CHECK_USERNAMES', 0, '', 'tick', 'return ''0'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_check_usernames', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('implied_spammer_confidence', 'IMPLIED_SPAMMER_CONFIDENCE', 0, '', 'integer', 'return ''80'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_implied_spammer_confidence', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('spam_blackhole_detection', 'SPAM_BLACKHOLE_DETECTION', 0, '', 'tick', 'return ''1'';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_spam_blackhole_detection', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('honeypot_url', 'HONEYPOT_URL', 0, '', 'line', 'return '''';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_honeypot_url', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('honeypot_phrase', 'HONEYPOT_PHRASE', 0, '', 'line', 'return '''';', 'SECURITY', 'SPAMMER_DETECTION', 'CONFIG_OPTION_honeypot_phrase', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_rules_link', 'RULES_LINK', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_rules_link', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('site_name', 'SITE_NAME', 0, '', 'line', 'return do_lang(''UNNAMED'');', 'SITE', 'GENERAL', 'CONFIG_OPTION_site_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('site_scope', 'SITE_SCOPE', 0, '', 'transline', 'return ''???'';', 'SITE', 'GENERAL', 'CONFIG_OPTION_site_scope', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('description', 'DESCRIPTION', 0, '', 'transline', 'return '''';', 'SITE', 'GENERAL', 'CONFIG_OPTION_description', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('copyright', 'COPYRIGHT', 0, '', 'transline', 'return ''Copyright &copy; ''.get_site_name().'' ''.date(''Y'').'''';', 'SITE', 'GENERAL', 'CONFIG_OPTION_copyright', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('welcome_message', 'WELCOME_MESSAGE', 0, '', 'transtext', 'return '''';', 'SITE', 'GENERAL', 'CONFIG_OPTION_welcome_message', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('main_forum_name', 'MAIN_FORUM_NAME', 0, '', 'forum', 'return has_no_forum()?NULL:do_lang(''DEFAULT_FORUM_TITLE'','''','''','''',get_site_default_lang());', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_main_forum_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('keywords', 'KEYWORDS', 0, '', 'line', 'return '''';', 'SITE', 'GENERAL', 'CONFIG_OPTION_keywords', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('gzip_output', 'GZIP_OUTPUT', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_gzip_output', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_in_portal', 'FORUM_IN_PORTAL', 0, '', 'tick', 'return has_no_forum()?NULL:''0'';', 'SITE', 'ENVIRONMENT', 'CONFIG_OPTION_forum_in_portal', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('staff_address', 'EMAIL', 0, '', 'line', 'return ''staff@''.get_domain();', 'SITE', 'EMAIL', 'CONFIG_OPTION_staff_address', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_gd', 'GD', 0, '', 'tick', 'return function_exists(''imagetypes'')?''1'':''0'';', 'SITE', 'ENVIRONMENT', 'CONFIG_OPTION_is_on_gd', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_folder_create', 'FOLDER_CREATE', 0, '', 'tick', 'return ''1'';', 'SITE', 'ENVIRONMENT', 'CONFIG_OPTION_is_on_folder_create', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('site_closed', 'CLOSED_SITE', 0, '', 'tick', 'return ''0'';', 'SITE', 'CLOSED_SITE', 'CONFIG_OPTION_site_closed', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('closed', 'MESSAGE', 0, '', 'transtext', 'return do_lang(''BEING_INSTALLED'');', 'SITE', 'CLOSED_SITE', 'CONFIG_OPTION_closed', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_users', 'MAXIMUM_USERS', 0, '', 'integer', 'return ''100'';', 'SITE', 'CLOSED_SITE', 'CONFIG_OPTION_maximum_users', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cc_address', 'CC_ADDRESS', 0, '', 'line', 'return '''';', 'SITE', 'EMAIL', 'CONFIG_OPTION_cc_address', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('log_php_errors', 'LOG_PHP_ERRORS', 0, '', 'tick', 'return ''1'';', 'SITE', 'LOGGING', 'CONFIG_OPTION_log_php_errors', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('display_php_errors', 'DISPLAY_PHP_ERRORS', 0, '', 'tick', 'return ''0'';', 'SITE', 'LOGGING', 'CONFIG_OPTION_display_php_errors', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('valid_types', 'FILE_TYPES', 0, '', 'line', 'return ''swf,sql,odg,odp,odt,ods,pdf,pgp,dot,doc,ppt,csv,xls,docx,pptx,xlsx,pub,txt,log,psd,tga,tif,gif,png,ico,bmp,jpg,jpeg,flv,avi,mov,3gp,mpg,mpeg,mp4,webm,asf,wmv,zip,tar,rar,gz,wav,mp3,ogg,ogv,torrent,php,css,tpl,ini,eml,patch,diff,iso,dmg'';', 'SECURITY', 'UPLOADED_FILES', 'CONFIG_OPTION_valid_types', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('valid_images', 'IMAGE_TYPES', 0, '', 'line', 'return ''jpg,jpeg,gif,png,ico'';', 'SECURITY', 'UPLOADED_FILES', 'CONFIG_OPTION_valid_images', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_rating', 'RATING', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_is_on_rating', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_comments', 'COMMENTS', 0, '', 'tick', 'return has_no_forum()?NULL:''1'';', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_is_on_comments', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('comments_forum_name', 'COMMENTS_FORUM_NAME', 0, '', 'forum', 'return has_no_forum()?NULL:do_lang(''COMMENT_FORUM_NAME'','''','''','''',get_site_default_lang());', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_comments_forum_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('comment_text', 'COMMENT_FORM_TEXT', 0, '', 'transtext', 'return has_no_forum()?NULL:static_evaluate_tempcode(do_template(''COMMENTS_DEFAULT_TEXT''));', 'FEATURE', 'USER_INTERACTION', 'CONFIG_OPTION_comment_text', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('thumb_width', 'THUMB_WIDTH', 0, '', 'integer', 'return ''175'';', 'FEATURE', 'IMAGES', 'CONFIG_OPTION_thumb_width', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_image_size', 'IMAGES', 0, '', 'integer', 'return ''700'';', 'SITE', 'UPLOAD', 'CONFIG_OPTION_max_image_size', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('users_online_time', 'USERS_ONLINE_TIME', 0, '', 'integer', 'return ''5'';', 'SITE', 'LOGGING', 'CONFIG_OPTION_users_online_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('system_flagrant', 'SYSTEM_FLAGRANT', 0, '', 'transline', 'return '''';', 'SITE', 'GENERAL', 'CONFIG_OPTION_system_flagrant', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('messaging_forum_name', '_MESSAGING_FORUM_NAME', 0, '', 'forum', 'return do_lang(''MESSAGING_FORUM_NAME'','''','''','''',get_site_default_lang());', 'FEATURE', 'CONTACT_US_MESSAGING', 'CONFIG_OPTION_messaging_forum_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('commandr_chat_announce', 'COMMANDR_CHAT_ANNOUNCE', 0, '', 'tick', 'return ''0'';', 'SITE', 'ADVANCED', 'CONFIG_OPTION_commandr_chat_announce', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_commandr_button', 'COMMANDR_BUTTON', 0, '', 'tick', 'return (get_file_base()!=get_custom_file_base())?''0'':''1'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_commandr_button', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_is_enabled', 'LDAP_IS_ENABLED', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_is_enabled', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_is_windows', 'LDAP_IS_WINDOWS', 0, '', 'tick', 'return (DIRECTORY_SEPARATOR==''/'')?''0'':''1'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_is_windows', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_allow_joining', 'LDAP_ALLOW_JOINING', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_allow_joining', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_hostname', 'LDAP_HOSTNAME', 0, '', 'line', 'return ''localhost'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_hostname', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_base_dn', 'LDAP_BASE_DN', 0, '', 'line', 'return ''dc=192,dc=168,dc=1,dc=68'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_base_dn', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_bind_rdn', 'USERNAME', 0, '', 'line', 'return (DIRECTORY_SEPARATOR==''/'')?''NotManager'':''NotAdministrator'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_bind_rdn', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_bind_password', 'PASSWORD', 0, '', 'line', 'return '''';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_bind_password', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('windows_auth_is_enabled', 'WINDOWS_AUTHENTICATION', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_windows_auth_is_enabled', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_login_qualifier', 'LDAP_LOGIN_QUALIFIER', 0, '', 'line', 'return is_null($old=get_value(''ldap_login_qualifier''))?'''':$old;', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_login_qualifier', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_group_search_qualifier', 'LDAP_GROUP_SEARCH_QUALIFIER', 0, '', 'line', 'return '''';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_group_search_qualifier', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_member_search_qualifier', 'LDAP_MEMBER_SEARCH_QUALIFIER', 0, '', 'line', 'return '''';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_member_search_qualifier', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_member_property', 'LDAP_MEMBER_PROPERTY', 0, '', 'line', 'return (get_option(''ldap_is_windows'')==''1'')?''sAMAccountName'':''cn'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_member_property', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_none_bind_logins', 'LDAP_NONE_BIND_LOGINS', 0, '', 'tick', 'return ''0'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_none_bind_logins', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_version', 'LDAP_VERSION', 0, '', 'integer', 'return ''3'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_version', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_group_class', 'LDAP_GROUP_CLASS', 0, '', 'line', 'return (get_option(''ldap_is_windows'')==''1'')?''group'':''posixGroup'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_group_class', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ldap_member_class', 'LDAP_MEMBER_CLASS', 0, '', 'line', 'return (get_option(''ldap_is_windows'')==''1'')?''user'':''posixAccount'';', 'SECTION_FORUMS', 'LDAP', 'CONFIG_OPTION_ldap_member_class', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bottom_show_realtime_rain_button', 'REALTIME_RAIN_BUTTON', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'BOTTOM_LINKS', 'CONFIG_OPTION_bottom_show_realtime_rain_button', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('staff_text', 'PAGE_TEXT', 0, '', 'transtext', 'return do_lang(''POST_STAFF'');', 'SECURITY', 'STAFF', 'CONFIG_OPTION_staff_text', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_staff_filter', 'MEMBER_FILTER', 0, '', 'tick', 'return ''0'';', 'SECURITY', 'STAFF', 'CONFIG_OPTION_is_on_staff_filter', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_sync_staff', 'SYNCHRONISATION', 0, '', 'tick', 'return ''0'';', 'SECURITY', 'STAFF', 'CONFIG_OPTION_is_on_sync_staff', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('super_logging', 'SUPER_LOGGING', 0, '', 'tick', 'return ''1'';', 'SITE', 'LOGGING', 'CONFIG_OPTION_super_logging', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('stats_store_time', 'STORE_TIME', 0, '', 'integer', 'return ''124'';', 'SITE', 'LOGGING', 'CONFIG_OPTION_stats_store_time', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('templates_store_revisions', 'STORE_REVISIONS', 0, '', 'tick', 'return ''1'';', 'ADMIN', 'EDIT_TEMPLATES', 'CONFIG_OPTION_templates_store_revisions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('templates_number_revisions_show', 'SHOW_REVISIONS', 0, '', 'integer', 'return ''5'';', 'ADMIN', 'EDIT_TEMPLATES', 'CONFIG_OPTION_templates_number_revisions_show', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_BANNER', 'ADD_BANNER', 0, '', 'integer', 'return addon_installed(''points'')?''0'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_BANNER', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('use_banner_permissions', 'PERMISSIONS', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'BANNERS', 'CONFIG_OPTION_use_banner_permissions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('banner_autosize', 'BANNER_AUTOSIZE', 0, '', 'tick', 'return is_null($old=get_value(''banner_autosize''))?''0'':$old;', 'FEATURE', 'BANNERS', 'CONFIG_OPTION_banner_autosize', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('admin_banners', 'ADMIN_BANNERS', 0, '', 'tick', 'return is_null($old=get_value(''always_banners''))?''0'':$old;', 'FEATURE', 'BANNERS', 'CONFIG_OPTION_admin_banners', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('calendar_show_stats_count_events', 'EVENTS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_calendar_show_stats_count_events', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('calendar_show_stats_count_events_this_week', '_EVENTS_THIS_WEEK', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_calendar_show_stats_count_events_this_week', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('calendar_show_stats_count_events_this_month', '_EVENTS_THIS_MONTH', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_calendar_show_stats_count_events_this_month', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('calendar_show_stats_count_events_this_year', '_EVENTS_THIS_YEAR', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_calendar_show_stats_count_events_this_year', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('catalogues_subcat_narrowin', 'CATALOGUES_SUBCAT_NARROWIN', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'CATALOGUES', 'CONFIG_OPTION_catalogues_subcat_narrowin', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_cedi', 'CEDI_MAKE_POST', 0, '', 'integer', 'return addon_installed(''points'')?''10'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_cedi', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cedi_show_stats_count_pages', 'CEDI_PAGES', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_cedi_show_stats_count_pages', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('cedi_show_stats_count_posts', 'CEDI_POSTS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_cedi_show_stats_count_posts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_flood_timelimit', 'FLOOD_TIMELIMIT', 0, '', 'integer', 'return ''5'';', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_chat_flood_timelimit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_default_post_colour', 'CHAT_OPTIONS_COLOUR_NAME', 0, '', 'colour', 'return ''inherit'';', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_chat_default_post_colour', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_default_post_font', 'CHAT_OPTIONS_TEXT_NAME', 0, '', 'list', 'return ''Verdana'';', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_chat_default_post_font', 0, 'Arial|Courier|Georgia|Impact|Times| Trebuchet|Verdana|Tahoma|Geneva|Helvetica');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_private_room_deletion_time', 'PRIVATE_ROOM_DELETION_TIME', 0, '', 'integer', 'return ''1440'';', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_chat_private_room_deletion_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('username_click_im', 'USERNAME_CLICK_IM', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_username_click_im', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_chat', 'CHATTING', 0, '', 'integer', 'return addon_installed(''points'')?''1'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_chat', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_show_stats_count_users', 'COUNT_CHATTERS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_chat_show_stats_count_users', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_show_stats_count_rooms', 'ROOMS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_chat_show_stats_count_rooms', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('chat_show_stats_count_messages', 'COUNT_CHATPOSTS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_chat_show_stats_count_messages', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('sitewide_im', 'SITEWIDE_IM', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_sitewide_im', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('group_private_chatrooms', 'GROUP_PRIVATE_CHATROOMS', 0, '', 'tick', 'return is_null($old=get_value(''no_group_private_chatrooms''))?''1'':invert_value($old);', 'FEATURE', 'SECTION_CHAT', 'CONFIG_OPTION_group_private_chatrooms', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_download', 'MAXIMUM_DOWNLOAD', 0, '', 'integer', 'return ''15'';', 'SITE', 'CLOSED_SITE', 'CONFIG_OPTION_maximum_download', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_dload_trees', 'SHOW_DLOAD_TREES', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SECTION_DOWNLOADS', 'CONFIG_OPTION_show_dload_trees', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_DOWNLOAD', 'ADD_DOWNLOAD', 0, '', 'integer', 'return addon_installed(''points'')?''150'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_DOWNLOAD', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('downloads_show_stats_count_total', '_SECTION_DOWNLOADS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_downloads_show_stats_count_total', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('downloads_show_stats_count_archive', 'TOTAL_DOWNLOADS_IN_ARCHIVE', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_downloads_show_stats_count_archive', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('downloads_show_stats_count_downloads', '_COUNT_DOWNLOADS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_downloads_show_stats_count_downloads', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('downloads_show_stats_count_bandwidth', '_COUNT_BANDWIDTH', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_downloads_show_stats_count_bandwidth', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('immediate_downloads', 'IMMEDIATE_DOWNLOADS', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SECTION_DOWNLOADS', 'CONFIG_OPTION_immediate_downloads', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('download_gallery_root', 'DOWNLOAD_GALLERY_ROOT', 0, '', 'line', 'return is_null($old=get_value(''download_gallery_root''))?(addon_installed(''galleries'')?''root'':NULL):$old;', 'FEATURE', 'SECTION_DOWNLOADS', 'CONFIG_OPTION_download_gallery_root', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('downloads_subcat_narrowin', 'DOWNLOADS_SUBCAT_NARROWIN', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SECTION_DOWNLOADS', 'CONFIG_OPTION_downloads_subcat_narrowin', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_IMAGE', 'ADD_IMAGE', 0, '', 'integer', 'return addon_installed(''points'')?''100'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_IMAGE', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_VIDEO', 'ADD_VIDEO', 0, '', 'integer', 'return addon_installed(''points'')?''100'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_VIDEO', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('default_video_width', 'DEFAULT_VIDEO_WIDTH', 0, '', 'integer', 'return ''320'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_default_video_width', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('default_video_height', 'DEFAULT_VIDEO_HEIGHT', 0, '', 'integer', 'return ''240'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_default_video_height', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_image_size', 'MAXIMUM_IMAGE_SIZE', 0, '', 'integer', 'return ''1024'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_maximum_image_size', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_personal_gallery_images_low', 'GALLERY_IMAGE_LIMIT_LOW', 0, '', 'integer', 'return ''5'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_max_personal_gallery_images_low', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_personal_gallery_images_high', 'GALLERY_IMAGE_LIMIT_HIGH', 0, '', 'integer', 'return ''10'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_max_personal_gallery_images_high', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_personal_gallery_videos_low', 'GALLERY_VIDEO_LIMIT_LOW', 0, '', 'integer', 'return ''2'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_max_personal_gallery_videos_low', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_personal_gallery_videos_high', 'GALLERY_VIDEO_LIMIT_HIGH', 0, '', 'integer', 'return ''5'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_max_personal_gallery_videos_high', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('galleries_show_stats_count_galleries', 'GALLERIES', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_galleries_show_stats_count_galleries', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('galleries_show_stats_count_images', 'IMAGES', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_galleries_show_stats_count_images', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('galleries_show_stats_count_videos', 'VIDEOS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_galleries_show_stats_count_videos', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_empty_galleries', 'SHOW_EMPTY_GALLERIES', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_show_empty_galleries', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('gallery_name_order', 'GALLERY_NAME_ORDER', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_gallery_name_order', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('gallery_selectors', 'GALLERY_SELECTORS', 0, '', 'line', 'return is_null($old=get_value(''gallery_selectors''))?''12,24,36,64,128'':$old;', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_gallery_selectors', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('reverse_thumb_order', 'REVERSE_THUMB_ORDER', 0, '', 'tick', 'return is_null($old=get_value(''reverse_thumb_order''))?''0'':$old;', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_reverse_thumb_order', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('show_gallery_counts', 'SHOW_GALLERY_COUNTS', 0, '', 'tick', 'return is_null($old=get_value(''show_gallery_counts''))?((get_forum_type()==''ocf'')?''0'':NULL):$old;', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_show_gallery_counts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('video_bitrate', 'VIDEO_BITRATE', 0, '', 'integer', 'return ''1000'';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_video_bitrate', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('audio_bitrate', 'AUDIO_BITRATE', 0, '', 'integer', 'return ''192'';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_audio_bitrate', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('video_width_setting', 'VIDEO_WIDTH_SETTING', 0, '', 'integer', 'return ''720'';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_video_width_setting', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('video_height_setting', 'VIDEO_HEIGHT_SETTING', 0, '', 'integer', 'return ''480'';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_video_height_setting', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('transcoding_zencoder_api_key', 'TRANSCODING_ZENCODER_API_KEY', 0, '', 'line', 'return '''';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_transcoding_zencoder_api_key', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('transcoding_zencoder_ftp_path', 'TRANSCODING_ZENCODER_FTP_PATH', 0, '', 'line', 'return '''';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_transcoding_zencoder_ftp_path', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('transcoding_server', 'TRANSCODING_SERVER', 0, '', 'line', 'return '''';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_transcoding_server', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ffmpeg_path', 'FFMPEG_PATH', 0, '', 'line', 'return '''';', 'FEATURE', 'TRANSCODING', 'CONFIG_OPTION_ffmpeg_path', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('galleries_subcat_narrowin', 'GALLERIES_SUBCAT_NARROWIN', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'GALLERIES', 'CONFIG_OPTION_galleries_subcat_narrowin', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_CHOOSE_IOTD', 'CHOOSE_IOTD', 0, '', 'integer', 'return addon_installed(''points'')?''35'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_CHOOSE_IOTD', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_IOTD', 'ADD_IOTD', 0, '', 'integer', 'return addon_installed(''points'')?''150'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_IOTD', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('iotd_update_time', 'IOTD_REGULARITY', 0, '', 'integer', 'return ''24'';', 'ADMIN', 'CHECK_LIST', 'CONFIG_OPTION_iotd_update_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_NEWS', 'ADD_NEWS', 0, '', 'integer', 'return addon_installed(''points'')?''225'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_NEWS', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('news_update_time', 'NEWS_REGULARITY', 0, '', 'integer', 'return ''168'';', 'ADMIN', 'CHECK_LIST', 'CONFIG_OPTION_news_update_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('blog_update_time', 'BLOG_REGULARITY', 0, '', 'integer', 'return ''168'';', 'ADMIN', 'CHECK_LIST', 'CONFIG_OPTION_blog_update_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ping_url', 'PING_URL', 0, '', 'text', 'return ''http://pingomatic.com/ping/?title={title}&blogurl={url}&rssurl={rss}'';', 'FEATURE', 'NEWS_AND_RSS', 'CONFIG_OPTION_ping_url', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('news_show_stats_count_total_posts', 'TOTAL_NEWS_ENTRIES', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_news_show_stats_count_total_posts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('news_show_stats_count_blogs', 'BLOGS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_news_show_stats_count_blogs', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('newsletter_text', 'PAGE_TEXT', 0, '', 'transtext', 'return '''';', 'FEATURE', 'NEWSLETTER', 'CONFIG_OPTION_newsletter_text', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('newsletter_title', 'TITLE', 0, '', 'line', 'return get_option(''site_name'').'' ''.cms_mb_strtolower(do_lang(''NEWSLETTER''));', 'FEATURE', 'NEWSLETTER', 'CONFIG_OPTION_newsletter_title', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('interest_levels', 'USE_INTEREST_LEVELS', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'NEWSLETTER', 'CONFIG_OPTION_interest_levels', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_joining', 'JOINING', 0, '', 'integer', 'return ''40'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_joining', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_posting', 'MAKE_POST', 0, '', 'integer', 'return ''5'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_posting', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_rating', 'RATING', 0, '', 'integer', 'return ''5'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_rating', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_voting', 'VOTING', 0, '', 'integer', 'return ''5'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_voting', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_if_liked', 'POINTS_IF_LIKED', 0, '', 'integer', 'return ''5'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_if_liked', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_per_currency_unit', 'POINTS_PER_CURRENCY_UNIT', 0, '', 'integer', 'return addon_installed(''ecommerce'')?''100.0'':NULL;', 'POINTS', 'ECOMMERCE', 'CONFIG_OPTION_points_per_currency_unit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_show_personal_stats_points_left', 'COUNT_POINTS_LEFT', 0, '', 'tick', 'return ''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_points_show_personal_stats_points_left', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_show_personal_stats_points_used', 'COUNT_POINTS_USED', 0, '', 'tick', 'return ''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_points_show_personal_stats_points_used', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_show_personal_stats_gift_points_left', 'COUNT_GIFT_POINTS_LEFT', 0, '', 'tick', 'return ''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_points_show_personal_stats_gift_points_left', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_show_personal_stats_gift_points_used', 'COUNT_GIFT_POINTS_USED', 0, '', 'tick', 'return ''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_points_show_personal_stats_gift_points_used', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_show_personal_stats_total_points', 'COUNT_POINTS_EVER', 0, '', 'tick', 'return ''0'';', 'BLOCKS', 'PERSONAL_BLOCK', 'CONFIG_OPTION_points_show_personal_stats_total_points', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_per_day', 'POINTS_PER_DAY', 0, '', 'integer', 'return ''0'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_per_day', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_per_daily_visit', 'POINTS_PER_DAILY_VISIT', 0, '', 'integer', 'return ''0'';', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_per_daily_visit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_highlight_name_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return (get_forum_type()!=''ocf'')?false:''1'';', 'POINTSTORE', 'NAME_HIGHLIGHTING', 'CONFIG_OPTION_is_on_highlight_name_buy', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('highlight_name', 'COST_highlight_name', 0, '', 'integer', 'return (get_forum_type()!=''ocf'')?false:''2000'';', 'POINTSTORE', 'NAME_HIGHLIGHTING', 'CONFIG_OPTION_highlight_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_topic_pin_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return (!addon_installed(''ocf_forum''))?false:''1'';', 'POINTSTORE', 'TOPIC_PINNING', 'CONFIG_OPTION_is_on_topic_pin_buy', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('topic_pin', 'COST_topic_pin', 0, '', 'integer', 'return (!addon_installed(''ocf_forum''))?false:''180'';', 'POINTSTORE', 'TOPIC_PINNING', 'CONFIG_OPTION_topic_pin', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_gambling_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return ''1'';', 'POINTSTORE', 'GAMBLING', 'CONFIG_OPTION_is_on_gambling_buy', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('minimum_gamble_amount', 'MINIMUM_GAMBLE_AMOUNT', 0, '', 'integer', 'return ''6'';', 'POINTSTORE', 'GAMBLING', 'CONFIG_OPTION_minimum_gamble_amount', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_gamble_amount', 'MAXIMUM_GAMBLE_AMOUNT', 0, '', 'integer', 'return ''200'';', 'POINTSTORE', 'GAMBLING', 'CONFIG_OPTION_maximum_gamble_amount', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('maximum_gamble_multiplier', 'MAXIMUM_GAMBLE_MULTIPLIER', 0, '', 'integer', 'return ''200'';', 'POINTSTORE', 'GAMBLING', 'CONFIG_OPTION_maximum_gamble_multiplier', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('average_gamble_multiplier', 'AVERAGE_GAMBLE_MULTIPLIER', 0, '', 'integer', 'return ''85'';', 'POINTSTORE', 'GAMBLING', 'CONFIG_OPTION_average_gamble_multiplier', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('banner_setup', 'COST_banner_setup', 0, '', 'integer', 'return (!addon_installed(''banners''))?false:''750'';', 'POINTSTORE', 'BANNERS', 'CONFIG_OPTION_banner_setup', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('banner_imp', 'COST_banner_imp', 0, '', 'integer', 'return (!addon_installed(''banners''))?false:''700'';', 'POINTSTORE', 'BANNERS', 'CONFIG_OPTION_banner_imp', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('banner_hit', 'COST_banner_hit', 0, '', 'integer', 'return (!addon_installed(''banners''))?false:''20'';', 'POINTSTORE', 'BANNERS', 'CONFIG_OPTION_banner_hit', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('quota', 'COST_quota', 0, '', 'integer', 'return ''2'';', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_quota', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('text', 'COST_text', 0, '', 'integer', 'return (!addon_installed(''flagrant''))?false:''700'';', 'POINTSTORE', 'FLAGRANT_MESSAGE', 'CONFIG_OPTION_text', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_banner_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return (!addon_installed(''banners''))?false:''1'';', 'POINTSTORE', 'BANNERS', 'CONFIG_OPTION_is_on_banner_buy', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('initial_banner_hits', 'HITS_ALLOCATED', 0, '', 'integer', 'return (!addon_installed(''banners''))?false:''100'';', 'POINTSTORE', 'BANNERS', 'CONFIG_OPTION_initial_banner_hits', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_pop3_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return ''0'';', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_is_on_pop3_buy', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('initial_quota', 'QUOTA', 0, '', 'integer', 'return ''200'';', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_initial_quota', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('max_quota', 'MAX_QUOTA', 0, '', 'integer', 'return ''10000'';', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_max_quota', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('mail_server', 'MAIL_SERVER', 0, '', 'line', 'return ''mail.''.get_domain();', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_mail_server', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('pop_url', 'POP3_MAINTAIN_URL', 0, '', 'line', 'return ''http://''.get_domain().'':2082/frontend/x/mail/addpop2.html'';', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_pop_url', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('quota_url', 'QUOTA_MAINTAIN_URL', 0, '', 'line', 'return ''http://''.get_domain().'':2082/frontend/x/mail/pops.html'';', 'POINTSTORE', 'POP3', 'CONFIG_OPTION_quota_url', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_forw_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return ''0'';', 'POINTSTORE', 'FORWARDING', 'CONFIG_OPTION_is_on_forw_buy', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forw_url', 'FORW_MAINTAIN_URL', 0, '', 'line', 'return ''http://''.get_domain().'':2082/frontend/x/mail/addfwd.html'';', 'POINTSTORE', 'FORWARDING', 'CONFIG_OPTION_forw_url', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_flagrant_buy', 'ENABLE_PURCHASE', 0, '', 'tick', 'return (!addon_installed(''flagrant''))?false:''1'';', 'POINTSTORE', 'FLAGRANT_MESSAGE', 'CONFIG_OPTION_is_on_flagrant_buy', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_POLL', 'ADD_POLL', 0, '', 'integer', 'return addon_installed(''points'')?''150'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_POLL', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_CHOOSE_POLL', 'CHOOSE_POLL', 0, '', 'integer', 'return addon_installed(''points'')?''35'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_CHOOSE_POLL', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('poll_update_time', 'POLL_REGULARITY', 0, '', 'integer', 'return ''168'';', 'ADMIN', 'CHECK_LIST', 'CONFIG_OPTION_poll_update_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('payment_gateway', 'PAYMENT_GATEWAY', 0, '', 'line', 'return ''paypal'';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_payment_gateway', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('use_local_payment', 'USE_LOCAL_PAYMENT', 0, '', 'tick', 'return ''0'';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_use_local_payment', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ipn_password', 'IPN_PASSWORD', 0, '', 'line', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_ipn_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ipn_digest', 'IPN_DIGEST', 0, '', 'line', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_ipn_digest', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('vpn_username', 'VPN_USERNAME', 0, '', 'line', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_vpn_username', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('vpn_password', 'VPN_PASSWORD', 0, '', 'line', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_vpn_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('callback_password', 'CALLBACK_PASSWORD', 0, '', 'line', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_callback_password', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('pd_address', 'POSTAL_ADDRESS', 0, '', 'text', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_pd_address', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('pd_email', 'EMAIL_ADDRESS', 0, '', 'line', 'return get_option(''staff_address'');', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_pd_email', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('pd_number', 'PHONE_NUMBER', 0, '', 'line', 'return '''';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_pd_number', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('currency', 'CURRENCY', 0, '', 'line', 'return ''GBP'';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_currency', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ecommerce_test_mode', 'ECOMMERCE_TEST_MODE', 0, '', 'tick', 'return ''0'';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_ecommerce_test_mode', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ipn_test', 'IPN_ADDRESS_TEST', 0, '', 'line', 'return get_option(''staff_address'');', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_ipn_test', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ipn', 'IPN_ADDRESS', 0, '', 'line', 'return get_option(''staff_address'');', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_ipn', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('quiz_show_stats_count_total_open', 'QUIZZES', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_quiz_show_stats_count_total_open', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_ADD_QUIZ', 'ADD_QUIZ', 0, '', 'integer', 'return addon_installed(''points'')?''0'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_ADD_QUIZ', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('shipping_cost_factor', 'SHIPPING_COST_FACTOR', 0, '', 'float', 'return ''0'';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_shipping_cost_factor', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('allow_opting_out_of_tax', 'ALLOW_OPTING_OUT_OF_TAX', 0, '', 'tick', 'return ''1'';', 'ECOMMERCE', 'ECOMMERCE', 'CONFIG_OPTION_allow_opting_out_of_tax', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('tester_forum_name', 'TESTER_FORUM_NAME', 0, '', 'forum', 'return do_lang(''DEFAULT_TESTER_FORUM'');', 'FEATURE', 'TESTER', 'CONFIG_OPTION_tester_forum_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('bug_report_text', 'BUG_REPORT_TEXT', 0, '', 'text', 'return do_lang(''DEFAULT_BUG_REPORT_TEMPLATE'');', 'FEATURE', 'TESTER', 'CONFIG_OPTION_bug_report_text', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ticket_member_forums', 'TICKET_MEMBER_FORUMS', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SUPPORT_TICKETS', 'CONFIG_OPTION_ticket_member_forums', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ticket_type_forums', 'TICKET_TYPE_FORUMS', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'SUPPORT_TICKETS', 'CONFIG_OPTION_ticket_type_forums', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ticket_text', 'PAGE_TEXT', 0, '', 'transtext', 'return do_lang(''NEW_TICKET_WELCOME'');', 'FEATURE', 'SUPPORT_TICKETS', 'CONFIG_OPTION_ticket_text', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('ticket_forum_name', 'TICKET_FORUM_NAME', 0, '', 'forum', 'require_lang(''tickets''); return do_lang(''TICKET_FORUM_NAME'','''','''','''',get_site_default_lang());', 'FEATURE', 'SUPPORT_TICKETS', 'CONFIG_OPTION_ticket_forum_name', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_COMCODE_PAGE_ADD', 'COMCODE_PAGE_ADD', 0, '', 'integer', 'return addon_installed(''points'')?''10'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_COMCODE_PAGE_ADD', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('store_revisions', 'STORE_REVISIONS', 0, '', 'tick', 'return ''1'';', 'ADMIN', 'COMCODE_PAGE_MANAGEMENT', 'CONFIG_OPTION_store_revisions', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('number_revisions_show', 'SHOW_REVISIONS', 0, '', 'integer', 'return ''5'';', 'ADMIN', 'COMCODE_PAGE_MANAGEMENT', 'CONFIG_OPTION_number_revisions_show', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('filedump_show_stats_count_total_files', 'FILEDUMP_COUNT_FILES', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_filedump_show_stats_count_total_files', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('filedump_show_stats_count_total_space', 'FILEDUMP_DISK_USAGE', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_filedump_show_stats_count_total_space', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('leaderboard_start_date', 'LEADERBOARD_START_DATE', 0, '', 'date', 'return strval(filemtime(get_file_base().''/index.php''));', 'POINTS', 'POINT_LEADERBOARD', 'CONFIG_OPTION_leaderboard_start_date', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_on_rss', 'ENABLE_RSS', 0, '', 'tick', 'return ''1'';', 'FEATURE', 'NEWS_AND_RSS', 'CONFIG_OPTION_is_on_rss', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('rss_update_time', 'UPDATE_TIME', 0, '', 'integer', 'return ''60'';', 'FEATURE', 'NEWS_AND_RSS', 'CONFIG_OPTION_rss_update_time', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('is_rss_advertised', 'ENABLE_RSS_ADVERTISING', 0, '', 'tick', 'return ''0'';', 'FEATURE', 'NEWS_AND_RSS', 'CONFIG_OPTION_is_rss_advertised', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('network_links', 'NETWORK_LINKS', 0, '', 'line', 'return get_base_url().''/netlink.php'';', 'SITE', 'ENVIRONMENT', 'CONFIG_OPTION_network_links', 1, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members', 'COUNT_MEMBERS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''1'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_topics', 'COUNT_TOPICS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''1'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_topics', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_posts', 'COUNT_POSTS', 0, '', 'tick', 'return addon_installed(''stats_block'')?''1'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_posts', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_posts_today', 'COUNT_POSTSTODAY', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_posts_today', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('activity_show_stats_count_users_online', 'COUNT_ONSITE', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_activity_show_stats_count_users_online', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('activity_show_stats_count_users_online_record', 'COUNT_ONSITE_RECORD', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_activity_show_stats_count_users_online_record', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('activity_show_stats_count_users_online_forum', 'COUNT_ONFORUMS', 0, '', 'tick', 'return ((get_forum_type()!=''ocf'') && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_activity_show_stats_count_users_online_forum', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('activity_show_stats_count_page_views_today', 'PAGE_VIEWS_TODAY', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_activity_show_stats_count_page_views_today', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('activity_show_stats_count_page_views_this_week', 'PAGE_VIEWS_THIS_WEEK', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_activity_show_stats_count_page_views_this_week', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('activity_show_stats_count_page_views_this_month', 'PAGE_VIEWS_THIS_MONTH', 0, '', 'tick', 'return addon_installed(''stats_block'')?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_activity_show_stats_count_page_views_this_month', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members_active_today', 'MEMBERS_ACTIVE_TODAY', 0, '', 'tick', 'return ((get_forum_type()==''ocf'') && (!has_no_forum()) && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members_active_today', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members_active_this_week', 'MEMBERS_ACTIVE_THIS_WEEK', 0, '', 'tick', 'return ((get_forum_type()==''ocf'') && (!has_no_forum()) && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members_active_this_week', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members_active_this_month', 'MEMBERS_ACTIVE_THIS_MONTH', 0, '', 'tick', 'return ((get_forum_type()==''ocf'') && (!has_no_forum()) && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members_active_this_month', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members_new_today', 'MEMBERS_NEW_TODAY', 0, '', 'tick', 'return ((get_forum_type()==''ocf'') && (!has_no_forum()) && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members_new_today', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members_new_this_week', 'MEMBERS_NEW_THIS_WEEK', 0, '', 'tick', 'return ((get_forum_type()==''ocf'') && (!has_no_forum()) && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members_new_this_week', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('forum_show_stats_count_members_new_this_month', 'MEMBERS_NEW_THIS_MONTH', 0, '', 'tick', 'return ((get_forum_type()==''ocf'') && (!has_no_forum()) && (addon_installed(''stats_block'')))?''0'':NULL;', 'BLOCKS', 'STATISTICS', 'CONFIG_OPTION_forum_show_stats_count_members_new_this_month', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('usersonline_show_newest_member', 'SHOW_NEWEST_MEMBER', 0, '', 'tick', 'return ((has_no_forum()) || (get_forum_type()!=''ocf''))?NULL:''0'';', 'BLOCKS', 'USERS_ONLINE_BLOCK', 'CONFIG_OPTION_usersonline_show_newest_member', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('usersonline_show_birthdays', 'BIRTHDAYS', 0, '', 'tick', 'return ((has_no_forum()) || (get_forum_type()!=''ocf''))?NULL:''0'';', 'BLOCKS', 'USERS_ONLINE_BLOCK', 'CONFIG_OPTION_usersonline_show_birthdays', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('points_RECOMMEND_SITE', 'RECOMMEND_SITE', 0, '', 'integer', 'return addon_installed(''points'')?''350'':NULL;', 'POINTS', 'COUNT_POINTS_GIVEN', 'CONFIG_OPTION_points_RECOMMEND_SITE', 0, '');
INSERT INTO `cms_config` (`the_name`, `human_name`, `c_set`, `config_value`, `the_type`, `eval`, `the_page`, `section`, `explanation`, `shared_hosting_restricted`, `c_data`) VALUES('supermembers_text', 'PAGE_TEXT', 0, '', 'transtext', 'return do_lang(''SUPERMEMBERS_TEXT'');', 'SECURITY', 'SUPER_MEMBERS', 'CONFIG_OPTION_supermembers_text', 0, '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_cron_caching_requests`
--

DROP TABLE IF EXISTS `cms_cron_caching_requests`;
CREATE TABLE IF NOT EXISTS `cms_cron_caching_requests` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_codename` varchar(80) NOT NULL,
  `c_map` longtext NOT NULL,
  `c_timezone` varchar(80) NOT NULL,
  `c_is_bot` tinyint(1) NOT NULL,
  `c_store_as_tempcode` tinyint(1) NOT NULL,
  `c_lang` varchar(5) NOT NULL,
  `c_theme` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `c_compound` (`c_codename`,`c_theme`,`c_lang`,`c_timezone`),
  KEY `c_is_bot` (`c_is_bot`),
  KEY `c_store_as_tempcode` (`c_store_as_tempcode`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_cron_caching_requests`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_customtasks`
--

DROP TABLE IF EXISTS `cms_customtasks`;
CREATE TABLE IF NOT EXISTS `cms_customtasks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tasktitle` varchar(255) NOT NULL,
  `datetimeadded` int(10) unsigned NOT NULL,
  `recurinterval` int(11) NOT NULL,
  `recurevery` varchar(80) NOT NULL,
  `taskisdone` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=14 ;

--
-- Dumping data for table `cms_customtasks`
--

INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(1, 'Set up website configuration and structure', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(2, 'Make ''favicon'' theme image', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(3, 'Make ''appleicon'' (webclip) theme image', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(4, 'Make/install custom theme', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(5, 'Add your content', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(6, '[page="adminzone:admin_themes:edit_image:logo/trimmed_logo:theme=default"]Customise your mail/RSS logo[/page]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(7, '[page="adminzone:admin_themes:_edit_templates:theme=default:f0file=MAIL.tpl"]Customise your ''MAIL'' template[/page]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(8, '[url="P3P Wizard (set up privacy policy)"]http://www.p3pwiz.com/[/url]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(9, '[url="Submit to Google"]http://www.google.com/addurl/[/url]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(10, '[url="Submit to OpenDMOZ"]http://www.dmoz.org/add.html[/url]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(11, '[url="Submit to Bing"]http://www.bing.com/webmaster/SubmitSitePage.aspx[/url]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(12, 'Facebook user? Like Composr on Facebook:[html]<iframe src="http://www.cmsortal.com/facebook.html" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:430px; height:30px;" allowTransparency="true"></iframe>[/html]', 1344775608, 0, '', NULL);
INSERT INTO `cms_customtasks` (`id`, `tasktitle`, `datetimeadded`, `recurinterval`, `recurevery`, `taskisdone`) VALUES(13, '[url="Consider helping out with the Composr project"]http://cmsortal.com/site/helping_out.htm[/url]', 1344775608, 0, '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_custom_comcode`
--

DROP TABLE IF EXISTS `cms_custom_comcode`;
CREATE TABLE IF NOT EXISTS `cms_custom_comcode` (
  `tag_tag` varchar(80) NOT NULL,
  `tag_title` int(10) unsigned NOT NULL,
  `tag_description` int(10) unsigned NOT NULL,
  `tag_replace` longtext NOT NULL,
  `tag_example` longtext NOT NULL,
  `tag_parameters` varchar(255) NOT NULL,
  `tag_enabled` tinyint(1) NOT NULL,
  `tag_dangerous_tag` tinyint(1) NOT NULL,
  `tag_block_tag` tinyint(1) NOT NULL,
  `tag_textual_tag` tinyint(1) NOT NULL,
  PRIMARY KEY (`tag_tag`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_custom_comcode`
--

INSERT INTO `cms_custom_comcode` (`tag_tag`, `tag_title`, `tag_description`, `tag_replace`, `tag_example`, `tag_parameters`, `tag_enabled`, `tag_dangerous_tag`, `tag_block_tag`, `tag_textual_tag`) VALUES('facebook_video', 87, 88, '{$SET,VIDEO,{$PREG_REPLACE,(http://.*\\?v=)?(\\w+)(.*)?,$\\{2\\},{content}}}<object width="640" height="385"><param name="movie" value="http://www.facebook.com/v/{$GET*,VIDEO};hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.facebook.com/v/{$GET*,VIDEO};hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="640" height="385"></embed></object>', '[facebook_video]http://www.facebook.com/video/video.php?v=10150307159560581[/facebook_video]', '', 1, 0, 1, 0);
INSERT INTO `cms_custom_comcode` (`tag_tag`, `tag_title`, `tag_description`, `tag_replace`, `tag_example`, `tag_parameters`, `tag_enabled`, `tag_dangerous_tag`, `tag_block_tag`, `tag_textual_tag`) VALUES('youtube', 89, 90, '{$SET,VIDEO,{$PREG_REPLACE,(http://.*\\?v=)?(http://youtu.be/)?([\\w\\-]+)(.*)?,$\\{3\\},{$STRIP_TAGS,{content}}}}<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/{$GET*,VIDEO}?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/{$GET*,VIDEO}?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>', '[youtube]http://www.youtube.com/watch?v=ZDFFHaz9GsY[/youtube]', '', 1, 0, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_db_meta`
--

DROP TABLE IF EXISTS `cms_db_meta`;
CREATE TABLE IF NOT EXISTS `cms_db_meta` (
  `m_table` varchar(80) NOT NULL,
  `m_name` varchar(80) NOT NULL,
  `m_type` varchar(80) NOT NULL,
  PRIMARY KEY (`m_table`,`m_name`),
  KEY `findtransfields` (`m_type`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_db_meta`
--

INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'language', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'importance_level', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'text_original', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'text_parsed', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'broken', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate', 'source_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('values', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('values', 'the_value', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('values', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'human_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'c_set', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'config_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'eval', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'the_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'section', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'explanation', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'shared_hosting_restricted', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('config', 'c_data', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'group_id', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'specific_permission', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gsp', 'the_value', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sp_list', 'p_section', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sp_list', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sp_list', 'the_default', '*BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_file_size', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_description', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_thumb_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_original_filename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_num_downloads', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_last_downloaded_time', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachments', 'a_add_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'r_referer_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'r_referer_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('attachment_refs', 'a_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_default_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_header_text', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_theme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_wide', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_require_session', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('zones', 'zone_displayed_in_menu', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_organisation', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_hacked_by', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_hack_version', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('modules', 'module_version', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_organisation', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_hacked_by', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_hack_version', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('blocks', 'block_version', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'last_activity', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'session_confirmed', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'session_invisible', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'cache_username', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_zone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sessions', 'the_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('https_pages', 'https_page_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_category_access', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_category_access', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_category_access', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_keywords', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seo_meta', 'meta_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'field_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'guest_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'member_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'friend_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_cpf_perms', 'group_view', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_code', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_theme_img_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_relevance_level', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_use_topics', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_emoticons', 'e_is_special', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_locked', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_description', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_default', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_public_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_owner_view', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_owner_set', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_required', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_show_in_posts', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_show_in_post_previews', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_only_group', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_encrypted', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_custom_fields', 'cf_show_on_join_form', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'mf_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_1', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_2', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_3', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_4', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_5', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_6', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_7', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_8', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_9', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_inviter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_email_address', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_invites', 'i_taken', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_members', 'gm_group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_members', 'gm_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_members', 'gm_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pass_hash_salted', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pass_salt', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_theme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_avatar_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_validated_email_confirm_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_cache_num_posts', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_cache_warnings', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_join_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_timezone_offset', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_primary_group', 'GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_last_visit_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_last_submit_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_signature', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_is_perm_banned', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_preview_posts', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_dob_day', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_dob_month', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_dob_year', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_reveal_age', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_email_address', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_photo_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_photo_thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_views_signatures', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_auto_monitor_contrib_content', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_language', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_allow_emails', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_allow_emails_from_staff', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_zone_wide', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_highlighted_name', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pt_allow', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_pt_rules_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_max_email_attach_size_mb', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_password_change_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_password_compat_scheme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_members', 'm_on_probation_until', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_default', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_presented_at_install', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_super_admin', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_super_moderator', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_group_leader', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_promotion_target', '?GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_promotion_threshold', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_flood_control_submit_secs', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_flood_control_access_secs', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_gift_points_base', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_gift_points_per_day', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_daily_upload_mb', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_attachments_per_post', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_avatar_width', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_avatar_height', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_post_length_comcode', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_max_sig_length_comcode', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_enquire_on_new_ips', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_rank_image', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_hidden', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_rank_image_pri_only', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_open_membership', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_groups', 'g_is_private_club', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_page_access', 'page_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('match_key_messages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('match_key_messages', 'k_message', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('match_key_messages', 'k_match_key', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_zone_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_zone_access', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'c_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'c_description', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_categories', 'c_expanded_by_default', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_category_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_parent_forum', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_position', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_order_sub_alpha', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_post_count_increment', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_intro_question', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_intro_answer', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_num_topics', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_num_posts', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_topic_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_username', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_cache_last_forum_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_redirection', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_order', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forums', 'f_is_threaded', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pinned', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_sunk', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cascading', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_forum_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_from', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_to', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_from_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_pt_to_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_description', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_description_link', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_emoticon', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_num_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_is_open', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_poll_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_post_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_post', '?LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_first_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_post_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_last_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_topics', 't_cache_num_posts', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_post', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_poster', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_intended_solely_for', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_poster_name_if_guest', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_cache_forum_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_last_edit_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_last_edit_by', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_is_emphasised', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_skip_sig', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_posts', 'p_parent_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_special_pt_access', 's_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_special_pt_access', 's_topic_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_saved_warnings', 's_title', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_saved_warnings', 's_explanation', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_saved_warnings', 's_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_create_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_action_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_owner_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_alterer_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_post_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_before', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_history', 'h_action', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_ip', 'i_forum_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_ip', 'i_ip', '*IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_member', 'i_forum_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_forum_intro_member', 'i_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_text', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_forum_multi_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_post_templates', 't_use_default_forums', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_question', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_cache_total_votes', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_is_private', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_is_open', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_minimum_selections', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_maximum_selections', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_polls', 'po_requires_reply', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'pa_poll_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'pa_answer', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_answers', 'pa_cache_num_votes', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_votes', 'pv_poll_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_votes', 'pv_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_poll_votes', 'pv_answer_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_name', '*SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_post_text', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_move_to', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_pin_state', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_sink_state', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_open_state', '?BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_forum_multi_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_multi_moderations', 'mm_title_suffix', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_explanation', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_by', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'w_is_warning', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_silence_from_topic', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_silence_from_forum', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_probation', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_banned_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_charged_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_banned_member', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_warnings', 'p_changed_usergroup_from', '?GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_param_a', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_param_b', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_reason', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_moderator_logs', 'l_by', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_known_login_ips', 'i_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_known_login_ips', 'i_ip', '*IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_known_login_ips', 'i_val_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_read_logs', 'l_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_read_logs', 'l_topic_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_read_logs', 'l_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_menu', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_parent', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_caption', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_caption_long', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_check_permissions', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_expanded', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_new_window', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_page_only', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('menu_items', 'i_theme_img_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_url', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_excerpt', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trackbacks', 'trackback_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('security_images', 'si_session_id', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('security_images', 'si_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('security_images', 'si_code', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_cache_username', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_type', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_tracking', 'mt_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache_on', 'cached_for', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache_on', 'cache_on', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache_on', 'cache_ttl', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('validated_once', 'hash', '*MD5');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('edit_pings', 'the_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'lang_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'language', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'text_original', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'broken', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'action_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('translate_history', 'action_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('long_values', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('long_values', 'the_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('long_values', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tutorial_links', 'the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tutorial_links', 'the_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'member_id', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'specific_permission', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('msp', 'the_value', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_zone_access', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_zone_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_zone_access', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'page_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_page_access', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'active_until', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'module_the_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'category_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('member_category_access', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_key', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('autosave', 'a_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_session_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('messages_to_render', 'r_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_title_cache', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_title_cache', 't_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_title_cache', 't_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_resource_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_resource_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_resource_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_moniker', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('url_id_monikers', 'm_deprecated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_post_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating_type', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('review_supplement', 'r_rating_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sms_log', 's_trigger_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_10', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_subject', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_to_email', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_to_name', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_from_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_from_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_attachments', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_no_cc', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_as', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_as_admin', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_in_html', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_url', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_queued', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('logged_mail_messages', 'm_template', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('link_tracker', 'c_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_orig_filename', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('incoming_uploads', 'i_save_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'cached_for', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'identifier', '*MINIID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'the_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'the_theme', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'lang', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cache', 'langs_required', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_member_timeouts', 'member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_member_timeouts', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_group_member_timeouts', 'timeout', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'p_session_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'p_block_constraints', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('temp_block_permissions', 'p_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_codename', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_map', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_timezone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_is_bot', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_store_as_tempcode', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_lang', 'LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cron_caching_requests', 'c_theme', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_notification_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_code_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notifications_enabled', 'l_setting', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_subject', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_from_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_to_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_no_cc', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_notification_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_code_category', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_tin', 'd_frequency', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_consumed', 'c_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_consumed', 'c_frequency', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('digestives_consumed', 'c_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_for_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_for_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('rating', 'rating', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_page_access', 'zone_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('group_page_access', 'group_id', '*GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_name', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_author', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_organisation', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_version', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_description', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons', 'addon_install_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_files', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_files', 'addon_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_files', 'filename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'addon_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'addon_name_dependant_upon', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('addons_dependencies', 'addon_name_incompatibility', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'a_type_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'date_and_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'content_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_archive', 'member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_content_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_hide_awardee', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('award_types', 'a_update_time_hours', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_tag', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_description', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_replace', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_example', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_parameters', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_dangerous_tag', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_block_tag', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('custom_comcode', 'tag_textual_tag', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'user_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'the_message', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'days', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'order_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'activation_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'active_now', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('text', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_parts_done', 'imp_id', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_parts_done', 'imp_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_old_base_dir', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_db_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_db_user', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_hook', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_db_table_prefix', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_refresh_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_session', 'imp_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_old', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_new', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_type', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('import_id_remap', 'id_session', '*INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'ip', '*IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'i_descrip', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'i_ban_until', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_ip', 'i_ban_positive', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersubmitban_member', 'the_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notification_lockdown', 'l_notification_code', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('notification_lockdown', 'l_setting', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_incoming', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('commandrchat', 'c_timestamp', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_subject', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_send_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_welcome_emails', 'w_newsletter', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_from_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_from_zone', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_to_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_to_zone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('redirects', 'r_is_transparent', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'data_post', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'user_agent', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'referer', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'user_os', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'reason', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'reason_param_a', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('hackattack', 'reason_param_b', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'the_page', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'referer', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'get', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'post', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'browser', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'milliseconds', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'operating_system', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stats', 'access_denied_counter', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersonline_track', 'date_and_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('usersonline_track', 'peak', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'begin_num', 'UINTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'end_num', 'UINTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ip_country', 'country', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'id', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'theme', '*MINIID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'path', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('theme_images', 'lang', '*LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('wordfilter', 'word', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('wordfilter', 'w_replacement', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('wordfilter', 'w_substr', '*BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'author', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'forum_handle', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('authors', 'skills', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'expiry_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'img_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'the_type', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'b_title_text', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'caption', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'b_direct_code', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'campaign_remaining', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'site_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'hits_from', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'views_from', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'hits_to', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'views_to', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'importance_modulus', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banners', 'b_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 'id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_is_textual', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_image_width', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_image_height', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_max_file_size', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_types', 't_comcode_inline', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_source', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('banner_clicks', 'c_banner_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_owner', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_folder', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('bookmarks', 'b_page_link', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_content', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_recurrence', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_recurrences', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_seg_recurrences', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_year', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_month', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_day', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_monthly_spec_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_hour', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_start_minute', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_year', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_month', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_day', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_monthly_spec_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_hour', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_end_minute', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_timezone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_do_timezone_conv', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_is_public', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_priority', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'e_type', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_events', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 't_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 't_logo', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_types', 't_external_feed', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'e_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'n_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_reminders', 'n_seconds_before', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_interests', 'i_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_interests', 't_type', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_reminder_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_member_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('calendar_jobs', 'j_event_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_display_type', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_is_tree', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_submit_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_ecommerce', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogues', 'c_send_view_reports', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'c_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_parent_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_move_target', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_move_days_lower', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_categories', 'cc_move_days_higher', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'c_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_defines_order', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_visible', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_searchable', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_default', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_required', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_put_in_category', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_fields', 'cf_put_in_search', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'c_name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'cc_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_views_prior', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entries', 'ce_last_moved', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long_trans', 'cv_value', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_long', 'cv_value', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short_trans', 'cv_value', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_short', 'cv_value', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entry_linkage', 'catalogue_entry_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entry_linkage', 'content_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_entry_linkage', 'content_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_cat_treecache', 'cc_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_cat_treecache', 'cc_ancestor_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_childcountcache', 'cc_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_childcountcache', 'c_num_rec_children', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_childcountcache', 'c_num_rec_entries', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_float', 'cv_value', '?REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'cf_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'ce_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('catalogue_efv_integer', 'cv_value', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'the_action', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'the_page', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_changes', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'parent_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'child_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'the_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_children', 'title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'seedy_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'hide_posts', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_pages', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'page_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'the_message', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'seedy_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('seedy_posts', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_11', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'room_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'room_owner', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'allow_list', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'allow_list_groups', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'disallow_list', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'disallow_list_groups', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'room_language', 'LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'c_welcome', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_rooms', 'is_im', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'system_message', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'room_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'user_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'the_message', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'text_colour', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_messages', 'font_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_12', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_blocking', 'member_blocker', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_blocking', 'member_blocked', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_blocking', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_buddies', 'member_likes', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_buddies', 'member_liked', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_buddies', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_type_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_room_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_events', 'e_date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'room_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_active', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_sound_effects', 's_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_sound_effects', 's_effect_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chat_sound_effects', 's_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'category', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'parent_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_categories', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'category_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'comments', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'num_downloads', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'out_mode_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'default_pic', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'file_size', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_cost', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_submitter_gets_points', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'original_filename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_licence', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_downloads', 'download_data_mash', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'the_user', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_logging', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_licences', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_licences', 'l_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('download_licences', 'l_text', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'teaser', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'fullname', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'rep_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'parent_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_top_left', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_top_right', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_bottom_left', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'watermark_bottom_right', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'accept_images', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'accept_videos', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'is_member_synched', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'flow_mode_interface', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'gallery_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('galleries', 'g_owner', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'cat', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'comments', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'image_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('images', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'cat', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'comments', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_width', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_height', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'video_length', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('videos', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_error', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_table', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_url_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_orig_filename_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_width_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_height_field', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('video_transcoding', 't_output_filename', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_type_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_state', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_special', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('invoices', 'i_note', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'i_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'caption', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'thumb_url', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'is_current', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'used', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'date_and_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'iotd_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('iotd', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_article', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'author', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_category', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news', 'news_image', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'nc_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'nc_owner', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'nc_img', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_categories', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_procedure', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_port', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_path', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_protocol', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'rem_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'watching_channel', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_rss_cloud', 'register_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_category_entries', 'news_entry', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('news_category_entries', 'news_entry_category', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'join_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'code_confirm', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'the_password', 'MD5');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'pass_salt', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'language', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'n_forename', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter', 'n_surname', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'date_and_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'subject', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'newsletter', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'language', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_archive', 'importance_level', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletters', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletters', 'title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletters', 'description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_subscribe', 'newsletter_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_subscribe', 'the_level', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_subscribe', 'email', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_inject_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_subject', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_html_only', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_to_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_to_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_from_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_from_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_drip_send', 'd_template', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_message', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_subject', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_lang', 'LANGUAGE_NAME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_send_details', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_html_only', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_from_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_from_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_priority', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_csv_data', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_frequency', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_day', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_in_full', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_template', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('newsletter_periodic', 'np_last_sent', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'user_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'amount', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'reason', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('chargelog', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'amount', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'gift_from', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'gift_to', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'reason', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('gifts', 'anonymous', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_mail_subject', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_mail_body', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_cost', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_customs', 'c_one_per_member', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_mail_subject', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_mail_body', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_cost', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_hours', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_specific_permission', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_zone', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_module', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('pstore_permissions', 'p_category', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('prices', 'name', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('prices', 'price', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'memberid', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'purchasetype', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'details', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sales', 'details2', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'question', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option1', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option2', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option3', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option4', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option5', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option6', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option7', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option8', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option9', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'option10', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes1', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes2', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes3', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes4', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes5', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes6', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes7', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes8', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes9', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'votes10', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'allow_rating', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'allow_comments', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'allow_trackbacks', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'num_options', 'SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'is_current', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'date_and_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'add_time', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'poll_views', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll', 'edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_poll_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_voter_id', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_voter_ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('poll_votes', 'v_vote_for', '?SHORT_INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_purchase_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_item_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_ip_address', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_length', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('trans_expecting', 'e_length_units', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_13', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_14', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_15', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_16', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_17', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_18', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_19', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_20', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'purchase_id', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'status', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'reason', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_currency', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'linked', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'item', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 'pending_reason', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_memo', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('transactions', 't_via', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'v_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'v_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_member_last_visit', 'v_quiz_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_timeout', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_name', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_start_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_end_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_percentage', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_open_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_close_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_num_winners', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_redo_time', '?INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_points_for_passing', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_tied_newsletter', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quizzes', 'q_end_text_fail', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_long_input_field', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_num_choosable_answers', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_quiz', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_question_text', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_questions', 'q_required', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_question', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_answer_text', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_is_correct', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_order', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_question_answers', 'q_explanation', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_winner', 'q_quiz', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_winner', 'q_entry', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_winner', 'q_winner_level', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_quiz', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entries', 'q_results', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'q_entry', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'q_question', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('quiz_entry_answer', 'q_answer', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_primary', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_saved', 's_auxillary', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_primary', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_auxillary', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('searches_logged', 's_num_results', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'c_member', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'tot_price', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'order_status', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'transaction_id', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'purchase_through', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order', 'tax_opted_out', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'ordered_by', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_id', '*AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'quantity', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'price_pre_tax', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'price', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_description', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_type', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'product_weight', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_cart', 'is_deleted', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'order_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_code', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_type', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_quantity', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'p_price', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'included_tax', 'REAL');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_details', 'dispatch_status', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'e_member_id', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'session_id', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'last_action', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_logging', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'order_id', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_street', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_city', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_zip', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'address_country', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('shopping_order_addresses', 'receiver_email', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_21', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_22', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_23', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_24', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_25', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_26', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_27', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_type_code', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_member_id', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_state', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_amount', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_special', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_auto_fund_source', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_auto_fund_key', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('subscriptions', 's_via', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_title', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_description', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_cost', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_length', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_length_units', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_group_id', 'GROUP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_mail_start', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_mail_end', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_mail_uhoh', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_usergroup_subs', 's_uses_primary', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_section', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_notes', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_inheritable', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('test_sections', 's_assigned_to', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_section', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_test', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_assigned_to', '?USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_enabled', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_status', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tests', 't_inherit_section', '?AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'ticket_id', '*SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'topic_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'forum_id', 'AUTO_LINK');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('tickets', 'ticket_type', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'ticket_type', '*SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'guest_emails_mandatory', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'search_faq', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('ticket_types', 'cache_lead_time', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'the_zone', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_parent_page', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_validated', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_edit_date', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_add_date', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_submitter', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('comcode_pages', 'p_show_as_edit', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'the_zone', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'the_page', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'string_index', 'LONG_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'the_theme', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_comcode_pages', 'cc_page_title', '?SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'name', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'path', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'description', 'SHORT_TRANS');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('filedump', 'the_member', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('leader_board', 'lb_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('leader_board', 'lb_points', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('leader_board', 'date_and_time', '*TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'content_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'block_cache_id', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'run_period', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'running_now', 'BINARY');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('feature_lifetime_monitor', 'last_update', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'the_type', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'param_a', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'param_b', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'the_user', 'USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('adminlogs', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'tasktitle', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'datetimeadded', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'recurinterval', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'recurevery', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('customtasks', 'taskisdone', '?TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'link', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'link_title', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('stafflinks', 'link_desc', 'LONG_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('staff_tips_dismissed', 't_member', '*USER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('staff_tips_dismissed', 't_tip', '*ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sitewatchlist', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sitewatchlist', 'siteurl', 'URLPATH');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('sitewatchlist', 'site_name', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_weather_codes', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_weather_codes', 'w_string', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('cached_weather_codes', 'w_code', 'INTEGER');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'id', '*AUTO');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'failed_account', 'ID_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'date_and_time', 'TIME');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('failedlogins', 'ip', 'IP');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_28', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_29', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_30', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_31', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_32', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_33', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_34', 'SHORT_TEXT');
INSERT INTO `cms_db_meta` (`m_table`, `m_name`, `m_type`) VALUES('f_member_custom_fields', 'field_35', 'SHORT_TEXT');

-- --------------------------------------------------------

--
-- Table structure for table `cms_db_meta_indices`
--

DROP TABLE IF EXISTS `cms_db_meta_indices`;
CREATE TABLE IF NOT EXISTS `cms_db_meta_indices` (
  `i_table` varchar(80) NOT NULL,
  `i_name` varchar(80) NOT NULL,
  `i_fields` varchar(80) NOT NULL,
  PRIMARY KEY (`i_table`,`i_name`,`i_fields`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_db_meta_indices`
--

INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'aip', 'ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'athe_type', 'the_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'ts', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('adminlogs', 'xas', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('attachments', 'attachmentlimitcheck', 'a_add_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('attachments', 'ownedattachments', 'a_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('authors', 'findmemberlink', 'forum_handle');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('autosave', 'myautosaves', 'a_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('award_archive', 'awardquicksearch', 'content_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'badd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'banner_child_find', 'b_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'bvalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'campaign_remaining', 'campaign_remaining');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'expiry_date', 'expiry_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'the_type', 'the_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banners', 'topsites', 'hits_from,hits_to');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banner_clicks', 'clicker_ip', 'c_ip_address');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('banner_types', 'hottext', 't_comcode_inline');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_ford', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_fore', 'cached_for');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_forf', 'lang');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_forg', 'identifier');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cache', 'cached_forh', 'the_theme');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cached_comcode_pages', 'ccp_join', 'the_page,the_zone');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cached_comcode_pages', 'ftjoin_ccpt', 'cc_page_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cached_comcode_pages', 'ftjoin_ccsi', 'string_index');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'ces', 'e_submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'eventat', 'e_start_year,e_start_month,e_start_day,e_start_hour,e_start_minute');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'e_add_date', 'e_add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'e_type', 'e_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'e_views', 'e_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'ftjoin_econtent', 'e_content');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'ftjoin_etitle', 'e_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'publicevents', 'e_is_public');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_events', 'validated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('calendar_jobs', 'applicablejobs', 'j_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'cataloguefind', 'c_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'catstoclean', 'cc_move_target');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'cc_parent_id', 'cc_parent_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'ftjoin_ccdescrip', 'cc_description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_categories', 'ftjoin_cctitle', 'cc_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_cat_treecache', 'cc_ancestor_id', 'cc_ancestor_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'cefv_f_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'fce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'fcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_float', 'fcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'cefv_i_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'ice_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'icf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_integer', 'itv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', '#lcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', 'cefv_l_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', 'lce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long', 'lcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'cefv_lt_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'ltce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'ltcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_long_trans', 'ltcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', '#scv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'cefv_s_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'iscv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'sce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short', 'scf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'cefv_st_combo', 'ce_id,cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'stce_id', 'ce_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'stcf_id', 'cf_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_efv_short_trans', 'stcv_value', 'cv_value');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ces', 'ce_submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_add_date', 'ce_add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_cc_id', 'cc_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_c_name', 'c_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_validated', 'ce_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entries', 'ce_views', 'ce_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('catalogue_entry_linkage', 'custom_fields', 'content_type,content_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_active', 'active_ordering', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_active', 'member_select', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_active', 'room_select', 'room_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_events', 'event_ordering', 'e_date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_messages', 'ordering', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_messages', 'room_id', 'room_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'allow_list', 'allow_list(30)');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'first_public', 'is_im,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'is_im', 'is_im,room_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('chat_rooms', 'room_name', 'room_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('comcode_pages', 'p_add_date', 'p_add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('comcode_pages', 'p_submitter', 'p_submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('comcode_pages', 'p_validated', 'p_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cron_caching_requests', 'c_compound', 'c_codename,c_theme,c_lang,c_timezone');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cron_caching_requests', 'c_is_bot', 'c_is_bot');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('cron_caching_requests', 'c_store_as_tempcode', 'c_store_as_tempcode');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('digestives_tin', 'd_date_and_time', 'd_date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('digestives_tin', 'd_frequency', 'd_frequency');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('digestives_tin', 'd_to_member_id', 'd_to_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_categories', 'child_find', 'parent_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_categories', 'ftjoin_dccat', 'category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_categories', 'ftjoin_dcdescrip', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', '#download_data_mash', 'download_data_mash');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', '#original_filename', 'original_filename');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'category_list', 'category_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ddl', 'download_licence');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'dds', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'downloadauthor', 'author');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'download_views', 'download_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'dvalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ftjoin_dcomments', 'comments');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ftjoin_ddescrip', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'ftjoin_dname', 'name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'recent_downloads', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_downloads', 'top_downloads', 'num_downloads');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('download_logging', 'calculate_bandwidth', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_emoticons', 'relevantemoticons', 'e_relevance_level');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_emoticons', 'topicemos', 'e_use_topics');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'cache_num_posts', 'f_cache_num_posts');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'findnamedforum', 'f_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'f_position', 'f_position');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_forums', 'subforum_parenting', 'f_parent_forum');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'ftjoin_gname', 'g_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'ftjoin_gtitle', 'g_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'gorder', 'g_order,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'hidden', 'g_hidden');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_default', 'g_is_default');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_presented_at_install', 'g_is_presented_at_install');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_private_club', 'g_is_private_club');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_super_admin', 'g_is_super_admin');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_groups', 'is_super_moderator', 'g_is_super_moderator');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_group_members', 'gm_group_id', 'gm_group_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_group_members', 'gm_member_id', 'gm_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_group_members', 'gm_validated', 'gm_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', '#search_user', 'm_username');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'avatar_url', 'm_avatar_url');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'birthdays', 'm_dob_day,m_dob_month');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'external_auth_lookup', 'm_pass_hash_salted');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'ftjoin_msig', 'm_signature');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'menail', 'm_email_address');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'm_join_time', 'm_join_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'primary_group', 'm_primary_group');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'sort_post_count', 'm_cache_num_posts');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'user_list', 'm_username');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_members', 'whos_validated', 'm_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf10', 'field_10');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf13', 'field_13');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf14', 'field_14');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf15', 'field_15');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf17', 'field_17');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf18', 'field_18');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf19', 'field_19');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf2', 'field_2');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf20', 'field_20');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf21', 'field_21');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf22', 'field_22');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf23', 'field_23');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf24', 'field_24');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf25', 'field_25');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf26', 'field_26');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf27', 'field_27');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf3', 'field_3');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf33', 'field_33');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf34', 'field_34');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf35', 'field_35');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf4', 'field_4');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf5', 'field_5');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf7', 'field_7');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_member_custom_fields', '#mcf8', 'field_8');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', '#p_title', 'p_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'deletebyip', 'p_ip_address');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'find_pp', 'p_intended_solely_for');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'in_topic', 'p_topic_id,p_time,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'postsinforum', 'p_cache_forum_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'posts_by', 'p_poster');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'post_order_time', 'p_time,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'p_last_edit_time', 'p_last_edit_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'p_validated', 'p_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_posts', 'search_join', 'p_post');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_post_history', 'phistorylookup', 'h_post_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_read_logs', 'erase_old_read_logs', 'l_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', '#t_description', 't_description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'descriptionsearch', 't_description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'forumlayer', 't_cache_first_title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'in_forum', 't_forum_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'ownedtopics', 't_cache_first_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order', 't_cascading,t_pinned,t_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_2', 't_forum_id,t_cascading,t_pinned,t_sunk,t_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_3', 't_forum_id,t_cascading,t_pinned,t_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_time', 't_cache_last_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 'topic_order_time_2', 't_cache_first_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_cascading', 't_cascading');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_cascading_or_forum', 't_cascading,t_forum_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_num_views', 't_num_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_pt_from', 't_pt_from');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_pt_to', 't_pt_to');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_topics', 't_validated', 't_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('f_warnings', 'warningsmemberid', 'w_member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'ftjoin_gdescrip', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'ftjoin_gfullname', 'fullname');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'gadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'parent_id', 'parent_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_bottom_left', 'watermark_bottom_left');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_bottom_right', 'watermark_bottom_right');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_top_left', 'watermark_top_left');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('galleries', 'watermark_top_right', 'watermark_top_right');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('gifts', 'giftsgiven', 'gift_from');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('gifts', 'giftsreceived', 'gift_to');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('group_zone_access', 'group_id', 'group_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('hackattack', 'h_date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('hackattack', 'otherhacksby', 'ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'category_list', 'cat');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'ftjoin_icomments', 'comments');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'iadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'image_views', 'image_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'i_validated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('images', 'xis', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'ftjoin_icap', 'caption');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'get_current', 'is_current');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'iadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'ios', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('iotd', 'iotd_views', 'iotd_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('logged_mail_messages', 'queued', 'm_queued');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('logged_mail_messages', 'recentmessages', 'm_date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_category_access', 'mcamember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_category_access', 'mcaname', 'module_the_name,category_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_page_access', 'mzamember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_page_access', 'mzaname', 'page_name,zone_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_tracking', 'mt_id', 'mt_page,mt_id,mt_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_tracking', 'mt_page', 'mt_page');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_zone_access', 'mzamember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('member_zone_access', 'mzazone_name', 'zone_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('menu_items', 'menu_extraction', 'i_menu');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('messages_to_render', 'forsession', 'r_session_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('msp', 'mspmember_id', 'member_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('msp', 'mspname', 'specific_permission,the_page,module_the_name,category_name');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'findnewscat', 'news_category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'ftjoin_ititle', 'title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'ftjoin_nnews', 'news');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'ftjoin_nnewsa', 'news_article');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'headlines', 'date_and_time,id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'nes', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'newsauthor', 'author');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'news_views', 'news_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news', 'nvalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter', 'code_confirm', 'code_confirm');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter', 'welcomemails', 'join_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter_drip_send', 'd_inject_time', 'd_inject_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('newsletter_subscribe', 'peopletosendto', 'the_level');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news_categories', 'ncs', 'nc_owner');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('news_category_entries', 'news_entry_category', 'news_entry_category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('notifications_enabled', 'l_code_category', 'l_code_category');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('notifications_enabled', 'l_member_id', 'l_member_id,l_notification_code');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po1', 'option1');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po2', 'option2');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po3', 'option3');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po4', 'option4');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_po5', 'option5');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ftjoin_pq', 'question');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'get_current', 'is_current');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'padd_time', 'add_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'poll_views', 'poll_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll', 'ps', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll_votes', 'v_voter_id', 'v_voter_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll_votes', 'v_voter_ip', 'v_voter_ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('poll_votes', 'v_vote_for', 'v_vote_for');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('quizzes', 'ftjoin_qstarttext', 'q_start_text');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('quizzes', 'q_validated', 'q_validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('rating', 'alt_key', 'rating_for_type,rating_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('rating', 'rating_for_id', 'rating_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('review_supplement', 'rating_for_id', 'r_rating_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('searches_logged', '#past_search_ft', 's_primary');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('searches_logged', 'past_search', 's_primary');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('security_images', 'si_time', 'si_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'ftjoin_spd', 'description');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'ftjoin_spt', 'title');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'sadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'seedy_views', 'seedy_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_pages', 'sps', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'cdate_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'ftjoin_spm', 'the_message');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'posts_on_page', 'page_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'seedy_views', 'seedy_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'spos', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seedy_posts', 'svalidated', 'validated');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('seo_meta', 'alt_key', 'meta_for_type,meta_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sessions', 'delete_old', 'last_activity');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sessions', 'the_user', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sessions', 'userat', 'the_zone,the_page,the_type,the_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_cart', 'ordered_by', 'ordered_by');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_cart', 'product_id', 'product_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_cart', 'session_id', 'session_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_logging', 'calculate_bandwidth', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'finddispatchable', 'order_status');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'recent_shopped', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'soadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'soc_member', 'c_member');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order', 'sosession_id', 'session_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order_addresses', 'order_id', 'order_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order_details', 'order_id', 'order_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('shopping_order_details', 'p_id', 'p_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sms_log', 'sms_log_for', 's_member_id,s_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('sms_log', 'sms_trigger_ip', 's_trigger_ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'browser', 'browser');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'member_track_1', 'the_user');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'member_track_2', 'ip');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'milliseconds', 'milliseconds');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'operating_system', 'operating_system');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'pages', 'the_page');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('stats', 'referer', 'referer');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('text', 'findflagrant', 'active_now');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('theme_images', 'theme', 'theme,lang');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('trackbacks', 'trackback_for_id', 'trackback_for_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('trackbacks', 'trackback_for_type', 'trackback_for_type');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('trackbacks', 'trackback_time', 'trackback_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', '#search', 'text_original');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', 'decache', 'text_parsed(2)');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', 'equiv_lang', 'text_original(4)');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('translate', 'importance_level', 'importance_level');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('url_id_monikers', 'uim_moniker', 'm_moniker');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('url_id_monikers', 'uim_pagelink', 'm_resource_page,m_resource_type,m_resource_id');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('usersonline_track', 'peak_track', 'peak');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('values', 'date_and_time', 'date_and_time');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'category_list', 'cat');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'ftjoin_vcomments', 'comments');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'vadd_date', 'add_date');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'video_views', 'video_views');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'vs', 'submitter');
INSERT INTO `cms_db_meta_indices` (`i_table`, `i_name`, `i_fields`) VALUES('videos', 'v_validated', 'validated');

-- --------------------------------------------------------

--
-- Table structure for table `cms_digestives_consumed`
--

DROP TABLE IF EXISTS `cms_digestives_consumed`;
CREATE TABLE IF NOT EXISTS `cms_digestives_consumed` (
  `c_member_id` int(11) NOT NULL,
  `c_frequency` int(11) NOT NULL,
  `c_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`c_member_id`,`c_frequency`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_digestives_consumed`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_digestives_tin`
--

DROP TABLE IF EXISTS `cms_digestives_tin`;
CREATE TABLE IF NOT EXISTS `cms_digestives_tin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `d_subject` longtext NOT NULL,
  `d_message` longtext NOT NULL,
  `d_from_member_id` int(11) DEFAULT NULL,
  `d_to_member_id` int(11) NOT NULL,
  `d_priority` tinyint(4) NOT NULL,
  `d_no_cc` tinyint(1) NOT NULL,
  `d_date_and_time` int(10) unsigned NOT NULL,
  `d_notification_code` varchar(80) NOT NULL,
  `d_code_category` varchar(255) NOT NULL,
  `d_frequency` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `d_date_and_time` (`d_date_and_time`),
  KEY `d_frequency` (`d_frequency`),
  KEY `d_to_member_id` (`d_to_member_id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_digestives_tin`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_download_categories`
--

DROP TABLE IF EXISTS `cms_download_categories`;
CREATE TABLE IF NOT EXISTS `cms_download_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category` int(10) unsigned NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `notes` longtext NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `child_find` (`parent_id`),
  KEY `ftjoin_dccat` (`category`),
  KEY `ftjoin_dcdescrip` (`description`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_download_categories`
--

INSERT INTO `cms_download_categories` (`id`, `category`, `parent_id`, `add_date`, `notes`, `description`, `rep_image`) VALUES(1, 292, NULL, 1344775599, '', 293, '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_download_downloads`
--

DROP TABLE IF EXISTS `cms_download_downloads`;
CREATE TABLE IF NOT EXISTS `cms_download_downloads` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `name` int(10) unsigned NOT NULL,
  `url` varchar(255) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `author` varchar(80) NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `num_downloads` int(11) NOT NULL,
  `out_mode_id` int(11) DEFAULT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned DEFAULT NULL,
  `validated` tinyint(1) NOT NULL,
  `default_pic` int(11) NOT NULL,
  `file_size` int(11) DEFAULT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `download_views` int(11) NOT NULL,
  `download_cost` int(11) NOT NULL,
  `download_submitter_gets_points` tinyint(1) NOT NULL,
  `submitter` int(11) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  `download_licence` int(11) DEFAULT NULL,
  `download_data_mash` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `download_views` (`download_views`),
  KEY `category_list` (`category_id`),
  KEY `recent_downloads` (`add_date`),
  KEY `top_downloads` (`num_downloads`),
  KEY `downloadauthor` (`author`),
  KEY `dds` (`submitter`),
  KEY `ddl` (`download_licence`),
  KEY `dvalidated` (`validated`),
  KEY `ftjoin_dname` (`name`),
  KEY `ftjoin_ddescrip` (`description`),
  KEY `ftjoin_dcomments` (`comments`),
  FULLTEXT KEY `download_data_mash` (`download_data_mash`),
  FULLTEXT KEY `original_filename` (`original_filename`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_download_downloads`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_download_licences`
--

DROP TABLE IF EXISTS `cms_download_licences`;
CREATE TABLE IF NOT EXISTS `cms_download_licences` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `l_title` varchar(255) NOT NULL,
  `l_text` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_download_licences`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_download_logging`
--

DROP TABLE IF EXISTS `cms_download_logging`;
CREATE TABLE IF NOT EXISTS `cms_download_logging` (
  `id` int(11) NOT NULL,
  `the_user` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`,`the_user`),
  KEY `calculate_bandwidth` (`date_and_time`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_download_logging`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_edit_pings`
--

DROP TABLE IF EXISTS `cms_edit_pings`;
CREATE TABLE IF NOT EXISTS `cms_edit_pings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `the_page` varchar(80) NOT NULL,
  `the_type` varchar(80) NOT NULL,
  `the_id` varchar(80) NOT NULL,
  `the_time` int(10) unsigned NOT NULL,
  `the_member` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_edit_pings`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_failedlogins`
--

DROP TABLE IF EXISTS `cms_failedlogins`;
CREATE TABLE IF NOT EXISTS `cms_failedlogins` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `failed_account` varchar(80) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `ip` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_failedlogins`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_feature_lifetime_monitor`
--

DROP TABLE IF EXISTS `cms_feature_lifetime_monitor`;
CREATE TABLE IF NOT EXISTS `cms_feature_lifetime_monitor` (
  `content_id` varchar(80) NOT NULL,
  `block_cache_id` varchar(80) NOT NULL,
  `run_period` int(11) NOT NULL,
  `running_now` tinyint(1) NOT NULL,
  `last_update` int(10) unsigned NOT NULL,
  PRIMARY KEY (`content_id`,`block_cache_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_feature_lifetime_monitor`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_filedump`
--

DROP TABLE IF EXISTS `cms_filedump`;
CREATE TABLE IF NOT EXISTS `cms_filedump` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `path` varchar(255) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `the_member` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_filedump`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_categories`
--

DROP TABLE IF EXISTS `cms_f_categories`;
CREATE TABLE IF NOT EXISTS `cms_f_categories` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `c_title` varchar(255) NOT NULL,
  `c_description` longtext NOT NULL,
  `c_expanded_by_default` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=3 ;

--
-- Dumping data for table `cms_f_categories`
--

INSERT INTO `cms_f_categories` (`id`, `c_title`, `c_description`, `c_expanded_by_default`) VALUES(1, 'General', '', 1);
INSERT INTO `cms_f_categories` (`id`, `c_title`, `c_description`, `c_expanded_by_default`) VALUES(2, 'Staff', '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_custom_fields`
--

DROP TABLE IF EXISTS `cms_f_custom_fields`;
CREATE TABLE IF NOT EXISTS `cms_f_custom_fields` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cf_locked` tinyint(1) NOT NULL,
  `cf_name` int(10) unsigned NOT NULL,
  `cf_description` int(10) unsigned NOT NULL,
  `cf_default` longtext NOT NULL,
  `cf_public_view` tinyint(1) NOT NULL,
  `cf_owner_view` tinyint(1) NOT NULL,
  `cf_owner_set` tinyint(1) NOT NULL,
  `cf_type` varchar(80) NOT NULL,
  `cf_required` tinyint(1) NOT NULL,
  `cf_show_in_posts` tinyint(1) NOT NULL,
  `cf_show_in_post_previews` tinyint(1) NOT NULL,
  `cf_order` int(11) NOT NULL,
  `cf_only_group` longtext NOT NULL,
  `cf_encrypted` tinyint(1) NOT NULL,
  `cf_show_on_join_form` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=36 ;

--
-- Dumping data for table `cms_f_custom_fields`
--

INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(1, 0, 14, 15, '', 1, 1, 1, 'long_trans', 0, 0, 0, 0, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(2, 0, 16, 17, '', 1, 1, 1, 'short_text', 0, 0, 0, 1, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(3, 0, 18, 19, '', 1, 1, 1, 'short_text', 0, 0, 0, 2, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(4, 0, 20, 21, '', 1, 1, 1, 'short_text', 0, 0, 0, 3, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(5, 0, 22, 23, '', 1, 1, 1, 'short_text', 0, 0, 0, 4, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(6, 0, 24, 25, '', 1, 1, 1, 'long_trans', 0, 0, 0, 5, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(7, 0, 26, 27, '', 1, 1, 1, 'short_text', 0, 0, 0, 6, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(8, 0, 28, 29, '', 1, 1, 1, 'short_text', 0, 0, 0, 7, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(9, 0, 30, 31, '', 0, 0, 0, 'long_trans', 0, 0, 0, 8, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(10, 1, 83, 84, '', 0, 0, 1, 'short_text', 0, 0, 0, 9, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(11, 1, 277, 278, '0', 0, 0, 0, 'integer', 0, 0, 0, 10, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(12, 1, 288, 289, '0', 0, 0, 0, 'integer', 0, 0, 0, 11, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(13, 1, 314, 315, 'AED|AFA|ALL|AMD|ANG|AOK|AON|ARA|ARP|ARS|AUD|AWG|AZM|BAM|BBD|BDT|BGL|BHD|BIF|BMD|BND|BOB|BOP|BRC|BRL|BRR|BSD|BTN|BWP|BYR|BZD|CAD|CDZ|CHF|CLF|CLP|CNY|COP|CRC|CSD|CUP|CVE|CYP|CZK|DJF|DKK|DOP|DZD|EEK|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHC|GIP|GMD|GNS|GQE|GTQ|GWP|GYD|HKD|HNL|HRD|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LSL|LSM|LTL|LVL|LYD|MAD|MDL|MGF|MKD|MLF|MMK|MNT|MOP|MRO|MTL|MUR|MVR|MWK|MXN|MYR|MZM|NAD|NGN|NIC|NOK|NPR|NZD|OMR|PAB|PEI|PEN|PGK|PHP|PKR|PLN|PYG|QAR|ROL|RUB|RWF|SAR|SBD|SCR|SDD|SDP|SEK|SGD|SHP|SIT|SKK|SLL|SOS|SRG|STD|SUR|SVC|SYP|SZL|THB|TJR|TMM|TND|TOP|TPE|TRL|TTD|TWD|TZS|UAH|UAK|UGS|USD|UYU|UZS|VEB|VND|VUV|WST|XAF|XCD|XOF|XPF|YDD|YER|ZAL|ZAR|ZMK|ZWD', 0, 0, 1, 'list', 0, 0, 0, 12, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(14, 1, 316, 317, '', 0, 0, 1, 'short_text', 0, 0, 0, 13, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(15, 1, 318, 319, 'American Express|Delta|Diners Card|JCB|Master Card|Solo|Switch|Visa', 0, 0, 1, 'list', 0, 0, 0, 14, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(16, 1, 320, 321, '', 0, 0, 1, 'integer', 0, 0, 0, 15, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(17, 1, 322, 323, 'mm/yy', 0, 0, 1, 'short_text', 0, 0, 0, 16, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(18, 1, 324, 325, 'mm/yy', 0, 0, 1, 'short_text', 0, 0, 0, 17, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(19, 1, 326, 327, '', 0, 0, 1, 'short_text', 0, 0, 0, 18, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(20, 1, 328, 329, '', 0, 0, 1, 'short_text', 0, 0, 0, 19, '', 1, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(21, 1, 342, 343, '', 0, 0, 0, 'short_text', 0, 0, 0, 20, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(22, 1, 344, 345, '', 0, 0, 0, 'short_text', 0, 0, 0, 21, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(23, 1, 346, 347, '', 0, 0, 0, 'long_text', 0, 0, 0, 22, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(24, 1, 348, 349, '', 0, 0, 0, 'short_text', 0, 0, 0, 23, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(25, 1, 350, 351, '', 0, 0, 0, 'short_text', 0, 0, 0, 24, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(26, 1, 352, 353, '', 0, 0, 0, 'short_text', 0, 0, 0, 25, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(27, 1, 354, 355, '|AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BM|BN|BO|BR|BS|BT|BU|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GH|GI|GL|GM|GN|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IN|IO|IQ|IR|IS|IT|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LY|MA|MC|MD|MG|MH|MK|ML|MM|MN|MO|MP|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PN|PR|PT|PW|PY|QA|RO|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|ST|SU|SV|SY|SZ|TC|TD|TG|TH|TJ|TK|TM|TN|TO|TP|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YD|YE|ZA|ZM|ZR|ZW', 0, 0, 0, 'list', 0, 0, 0, 26, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(28, 1, 378, 379, '0', 0, 0, 0, 'integer', 0, 0, 0, 27, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(29, 1, 380, 381, '0', 0, 0, 0, 'integer', 0, 0, 0, 28, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(30, 1, 382, 383, '0', 0, 0, 0, 'integer', 0, 0, 0, 29, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(31, 1, 384, 385, '0', 0, 0, 0, 'integer', 0, 0, 0, 30, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(32, 1, 386, 387, '0', 0, 0, 0, 'integer', 0, 0, 0, 31, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(33, 1, 388, 389, '', 0, 0, 0, 'short_text', 0, 0, 0, 32, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(34, 1, 390, 391, '', 0, 0, 1, 'short_text', 0, 0, 0, 33, '', 0, 0);
INSERT INTO `cms_f_custom_fields` (`id`, `cf_locked`, `cf_name`, `cf_description`, `cf_default`, `cf_public_view`, `cf_owner_view`, `cf_owner_set`, `cf_type`, `cf_required`, `cf_show_in_posts`, `cf_show_in_post_previews`, `cf_order`, `cf_only_group`, `cf_encrypted`, `cf_show_on_join_form`) VALUES(35, 1, 392, 393, '', 0, 0, 1, 'short_text', 0, 0, 0, 34, '', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_emoticons`
--

DROP TABLE IF EXISTS `cms_f_emoticons`;
CREATE TABLE IF NOT EXISTS `cms_f_emoticons` (
  `e_code` varchar(80) NOT NULL,
  `e_theme_img_code` varchar(255) NOT NULL,
  `e_relevance_level` int(11) NOT NULL,
  `e_use_topics` tinyint(1) NOT NULL,
  `e_is_special` tinyint(1) NOT NULL,
  PRIMARY KEY (`e_code`),
  KEY `relevantemoticons` (`e_relevance_level`),
  KEY `topicemos` (`e_use_topics`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_emoticons`
--

INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':P', 'ocf_emoticons/cheeky', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':''(', 'ocf_emoticons/cry', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':dry:', 'ocf_emoticons/dry', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':$', 'ocf_emoticons/blush', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(';)', 'ocf_emoticons/wink', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES('O_o', 'ocf_emoticons/blink', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':wub:', 'ocf_emoticons/wub', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':cool:', 'ocf_emoticons/cool', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':lol:', 'ocf_emoticons/lol', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':(', 'ocf_emoticons/sad', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':)', 'ocf_emoticons/smile', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':thumbs:', 'ocf_emoticons/thumbs', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':offtopic:', 'ocf_emoticons/offtopic', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':|', 'ocf_emoticons/mellow', 0, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':ninja:', 'ocf_emoticons/ph34r', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':o', 'ocf_emoticons/shocked', 0, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':rolleyes:', 'ocf_emoticons/rolleyes', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':D', 'ocf_emoticons/grin', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES('^_^', 'ocf_emoticons/glee', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES('(K)', 'ocf_emoticons/kiss', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':S', 'ocf_emoticons/confused', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':@', 'ocf_emoticons/angry', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':shake:', 'ocf_emoticons/shake', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':hand:', 'ocf_emoticons/hand', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':drool:', 'ocf_emoticons/drool', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':devil:', 'ocf_emoticons/devil', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':party:', 'ocf_emoticons/party', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':constipated:', 'ocf_emoticons/constipated', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':depressed:', 'ocf_emoticons/depressed', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':zzz:', 'ocf_emoticons/zzz', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':whistle:', 'ocf_emoticons/whistle', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':upsidedown:', 'ocf_emoticons/upsidedown', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':sick:', 'ocf_emoticons/sick', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':shutup:', 'ocf_emoticons/shutup', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':sarcy:', 'ocf_emoticons/sarcy', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':puppyeyes:', 'ocf_emoticons/puppyeyes', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':nod:', 'ocf_emoticons/nod', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':nerd:', 'ocf_emoticons/nerd', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':king:', 'ocf_emoticons/king', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':birthday:', 'ocf_emoticons/birthday', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':cyborg:', 'ocf_emoticons/cyborg', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':hippie:', 'ocf_emoticons/hippie', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':ninja2:', 'ocf_emoticons/ninja2', 1, 1, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':rockon:', 'ocf_emoticons/rockon', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':sinner:', 'ocf_emoticons/sinner', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':guitar:', 'ocf_emoticons/guitar', 1, 0, 0);
INSERT INTO `cms_f_emoticons` (`e_code`, `e_theme_img_code`, `e_relevance_level`, `e_use_topics`, `e_is_special`) VALUES(':christmas:', 'ocf_emoticons/christmas', 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_forums`
--

DROP TABLE IF EXISTS `cms_f_forums`;
CREATE TABLE IF NOT EXISTS `cms_f_forums` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `f_name` varchar(255) NOT NULL,
  `f_description` int(10) unsigned NOT NULL,
  `f_category_id` int(11) DEFAULT NULL,
  `f_parent_forum` int(11) DEFAULT NULL,
  `f_position` int(11) NOT NULL,
  `f_order_sub_alpha` tinyint(1) NOT NULL,
  `f_post_count_increment` tinyint(1) NOT NULL,
  `f_intro_question` int(10) unsigned NOT NULL,
  `f_intro_answer` varchar(255) NOT NULL,
  `f_cache_num_topics` int(11) NOT NULL,
  `f_cache_num_posts` int(11) NOT NULL,
  `f_cache_last_topic_id` int(11) DEFAULT NULL,
  `f_cache_last_title` varchar(255) NOT NULL,
  `f_cache_last_time` int(10) unsigned DEFAULT NULL,
  `f_cache_last_username` varchar(255) NOT NULL,
  `f_cache_last_member_id` int(11) DEFAULT NULL,
  `f_cache_last_forum_id` int(11) DEFAULT NULL,
  `f_redirection` varchar(255) NOT NULL,
  `f_order` varchar(80) NOT NULL,
  `f_is_threaded` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cache_num_posts` (`f_cache_num_posts`),
  KEY `subforum_parenting` (`f_parent_forum`),
  KEY `findnamedforum` (`f_name`),
  KEY `f_position` (`f_position`)
) ENGINE=MyISAM  AUTO_INCREMENT=9 ;

--
-- Dumping data for table `cms_f_forums`
--

INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(1, 'Forum home', 52, NULL, NULL, 1, 0, 1, 53, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(2, 'General chat', 54, 1, 1, 1, 0, 1, 55, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(3, 'Reported posts forum', 56, 2, 1, 1, 0, 1, 57, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(4, 'Trash', 58, 2, 1, 1, 0, 1, 59, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(5, 'Website comment topics', 60, 1, 1, 1, 0, 1, 61, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 1);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(6, 'Website support tickets', 62, 2, 1, 1, 0, 1, 63, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(7, 'Staff', 64, 2, 1, 1, 0, 1, 65, '', 1, 1, 1, 'Welcome to the forums', 1344775582, 'System', 1, 7, '', 'last_post', 0);
INSERT INTO `cms_f_forums` (`id`, `f_name`, `f_description`, `f_category_id`, `f_parent_forum`, `f_position`, `f_order_sub_alpha`, `f_post_count_increment`, `f_intro_question`, `f_intro_answer`, `f_cache_num_topics`, `f_cache_num_posts`, `f_cache_last_topic_id`, `f_cache_last_title`, `f_cache_last_time`, `f_cache_last_username`, `f_cache_last_member_id`, `f_cache_last_forum_id`, `f_redirection`, `f_order`, `f_is_threaded`) VALUES(8, 'Website "Contact Us" messages', 129, 2, 1, 1, 0, 1, 130, '', 0, 0, NULL, '', NULL, '', NULL, NULL, '', 'last_post', 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_forum_intro_ip`
--

DROP TABLE IF EXISTS `cms_f_forum_intro_ip`;
CREATE TABLE IF NOT EXISTS `cms_f_forum_intro_ip` (
  `i_forum_id` int(11) NOT NULL,
  `i_ip` varchar(40) NOT NULL,
  PRIMARY KEY (`i_forum_id`,`i_ip`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_forum_intro_ip`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_forum_intro_member`
--

DROP TABLE IF EXISTS `cms_f_forum_intro_member`;
CREATE TABLE IF NOT EXISTS `cms_f_forum_intro_member` (
  `i_forum_id` int(11) NOT NULL,
  `i_member_id` int(11) NOT NULL,
  PRIMARY KEY (`i_forum_id`,`i_member_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_forum_intro_member`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_groups`
--

DROP TABLE IF EXISTS `cms_f_groups`;
CREATE TABLE IF NOT EXISTS `cms_f_groups` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `g_name` int(10) unsigned NOT NULL,
  `g_is_default` tinyint(1) NOT NULL,
  `g_is_presented_at_install` tinyint(1) NOT NULL,
  `g_is_super_admin` tinyint(1) NOT NULL,
  `g_is_super_moderator` tinyint(1) NOT NULL,
  `g_group_leader` int(11) DEFAULT NULL,
  `g_title` int(10) unsigned NOT NULL,
  `g_promotion_target` int(11) DEFAULT NULL,
  `g_promotion_threshold` int(11) DEFAULT NULL,
  `g_flood_control_submit_secs` int(11) NOT NULL,
  `g_flood_control_access_secs` int(11) NOT NULL,
  `g_gift_points_base` int(11) NOT NULL,
  `g_gift_points_per_day` int(11) NOT NULL,
  `g_max_daily_upload_mb` int(11) NOT NULL,
  `g_max_attachments_per_post` int(11) NOT NULL,
  `g_max_avatar_width` int(11) NOT NULL,
  `g_max_avatar_height` int(11) NOT NULL,
  `g_max_post_length_comcode` int(11) NOT NULL,
  `g_max_sig_length_comcode` int(11) NOT NULL,
  `g_enquire_on_new_ips` tinyint(1) NOT NULL,
  `g_rank_image` varchar(80) NOT NULL,
  `g_hidden` tinyint(1) NOT NULL,
  `g_order` int(11) NOT NULL,
  `g_rank_image_pri_only` tinyint(1) NOT NULL,
  `g_open_membership` tinyint(1) NOT NULL,
  `g_is_private_club` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ftjoin_gname` (`g_name`),
  KEY `ftjoin_gtitle` (`g_title`),
  KEY `is_private_club` (`g_is_private_club`),
  KEY `is_super_admin` (`g_is_super_admin`),
  KEY `is_super_moderator` (`g_is_super_moderator`),
  KEY `is_default` (`g_is_default`),
  KEY `hidden` (`g_hidden`),
  KEY `is_presented_at_install` (`g_is_presented_at_install`),
  KEY `gorder` (`g_order`,`id`)
) ENGINE=MyISAM  AUTO_INCREMENT=11 ;

--
-- Dumping data for table `cms_f_groups`
--

INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(1, 32, 0, 0, 0, 0, NULL, 33, NULL, NULL, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 0, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(2, 34, 0, 0, 1, 0, NULL, 35, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/admin', 0, 1, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(3, 36, 0, 0, 0, 1, NULL, 37, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/mod', 0, 2, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(4, 38, 0, 0, 0, 0, NULL, 39, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 3, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(5, 40, 0, 0, 0, 0, NULL, 41, NULL, NULL, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/4', 0, 4, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(6, 42, 0, 0, 0, 0, NULL, 43, 5, 10000, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/3', 0, 5, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(7, 44, 0, 0, 0, 0, NULL, 45, 6, 2500, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/2', 0, 6, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(8, 46, 0, 0, 0, 0, NULL, 47, 7, 400, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/1', 0, 7, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(9, 48, 0, 0, 0, 0, NULL, 49, 8, 100, 5, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, 'ocf_rank_images/0', 0, 8, 1, 0, 0);
INSERT INTO `cms_f_groups` (`id`, `g_name`, `g_is_default`, `g_is_presented_at_install`, `g_is_super_admin`, `g_is_super_moderator`, `g_group_leader`, `g_title`, `g_promotion_target`, `g_promotion_threshold`, `g_flood_control_submit_secs`, `g_flood_control_access_secs`, `g_gift_points_base`, `g_gift_points_per_day`, `g_max_daily_upload_mb`, `g_max_attachments_per_post`, `g_max_avatar_width`, `g_max_avatar_height`, `g_max_post_length_comcode`, `g_max_sig_length_comcode`, `g_enquire_on_new_ips`, `g_rank_image`, `g_hidden`, `g_order`, `g_rank_image_pri_only`, `g_open_membership`, `g_is_private_club`) VALUES(10, 50, 0, 0, 0, 0, NULL, 51, NULL, NULL, 0, 0, 25, 1, 70, 50, 100, 100, 30000, 700, 0, '', 0, 9, 1, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_group_members`
--

DROP TABLE IF EXISTS `cms_f_group_members`;
CREATE TABLE IF NOT EXISTS `cms_f_group_members` (
  `gm_group_id` int(11) NOT NULL,
  `gm_member_id` int(11) NOT NULL,
  `gm_validated` tinyint(1) NOT NULL,
  PRIMARY KEY (`gm_group_id`,`gm_member_id`),
  KEY `gm_validated` (`gm_validated`),
  KEY `gm_member_id` (`gm_member_id`),
  KEY `gm_group_id` (`gm_group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_group_members`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_group_member_timeouts`
--

DROP TABLE IF EXISTS `cms_f_group_member_timeouts`;
CREATE TABLE IF NOT EXISTS `cms_f_group_member_timeouts` (
  `member_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `timeout` int(10) unsigned NOT NULL,
  PRIMARY KEY (`member_id`,`group_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_group_member_timeouts`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_invites`
--

DROP TABLE IF EXISTS `cms_f_invites`;
CREATE TABLE IF NOT EXISTS `cms_f_invites` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `i_inviter` int(11) NOT NULL,
  `i_email_address` varchar(255) NOT NULL,
  `i_time` int(10) unsigned NOT NULL,
  `i_taken` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_invites`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_members`
--

DROP TABLE IF EXISTS `cms_f_members`;
CREATE TABLE IF NOT EXISTS `cms_f_members` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `m_username` varchar(80) NOT NULL,
  `m_pass_hash_salted` varchar(255) NOT NULL,
  `m_pass_salt` varchar(255) NOT NULL,
  `m_theme` varchar(80) NOT NULL,
  `m_avatar_url` varchar(255) NOT NULL,
  `m_validated` tinyint(1) NOT NULL,
  `m_validated_email_confirm_code` varchar(255) NOT NULL,
  `m_cache_num_posts` int(11) NOT NULL,
  `m_cache_warnings` int(11) NOT NULL,
  `m_join_time` int(10) unsigned NOT NULL,
  `m_timezone_offset` varchar(255) NOT NULL,
  `m_primary_group` int(11) NOT NULL,
  `m_last_visit_time` int(10) unsigned NOT NULL,
  `m_last_submit_time` int(10) unsigned NOT NULL,
  `m_signature` int(10) unsigned NOT NULL,
  `m_is_perm_banned` tinyint(1) NOT NULL,
  `m_preview_posts` tinyint(1) NOT NULL,
  `m_dob_day` int(11) DEFAULT NULL,
  `m_dob_month` int(11) DEFAULT NULL,
  `m_dob_year` int(11) DEFAULT NULL,
  `m_reveal_age` tinyint(1) NOT NULL,
  `m_email_address` varchar(255) NOT NULL,
  `m_title` varchar(255) NOT NULL,
  `m_photo_url` varchar(255) NOT NULL,
  `m_photo_thumb_url` varchar(255) NOT NULL,
  `m_views_signatures` tinyint(1) NOT NULL,
  `m_auto_monitor_contrib_content` tinyint(1) NOT NULL,
  `m_language` varchar(80) NOT NULL,
  `m_ip_address` varchar(40) NOT NULL,
  `m_allow_emails` tinyint(1) NOT NULL,
  `m_allow_emails_from_staff` tinyint(1) NOT NULL,
  `m_notes` longtext NOT NULL,
  `m_zone_wide` tinyint(1) NOT NULL,
  `m_highlighted_name` tinyint(1) NOT NULL,
  `m_pt_allow` varchar(255) NOT NULL,
  `m_pt_rules_text` int(10) unsigned NOT NULL,
  `m_max_email_attach_size_mb` int(11) NOT NULL,
  `m_password_change_code` varchar(255) NOT NULL,
  `m_password_compat_scheme` varchar(80) NOT NULL,
  `m_on_probation_until` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_list` (`m_username`),
  KEY `menail` (`m_email_address`),
  KEY `external_auth_lookup` (`m_pass_hash_salted`),
  KEY `sort_post_count` (`m_cache_num_posts`),
  KEY `m_join_time` (`m_join_time`),
  KEY `whos_validated` (`m_validated`),
  KEY `birthdays` (`m_dob_day`,`m_dob_month`),
  KEY `ftjoin_msig` (`m_signature`),
  KEY `primary_group` (`m_primary_group`),
  KEY `avatar_url` (`m_avatar_url`),
  FULLTEXT KEY `search_user` (`m_username`)
) ENGINE=MyISAM  AUTO_INCREMENT=4 ;

--
-- Dumping data for table `cms_f_members`
--

INSERT INTO `cms_f_members` (`id`, `m_username`, `m_pass_hash_salted`, `m_pass_salt`, `m_theme`, `m_avatar_url`, `m_validated`, `m_validated_email_confirm_code`, `m_cache_num_posts`, `m_cache_warnings`, `m_join_time`, `m_timezone_offset`, `m_primary_group`, `m_last_visit_time`, `m_last_submit_time`, `m_signature`, `m_is_perm_banned`, `m_preview_posts`, `m_dob_day`, `m_dob_month`, `m_dob_year`, `m_reveal_age`, `m_email_address`, `m_title`, `m_photo_url`, `m_photo_thumb_url`, `m_views_signatures`, `m_auto_monitor_contrib_content`, `m_language`, `m_ip_address`, `m_allow_emails`, `m_allow_emails_from_staff`, `m_notes`, `m_zone_wide`, `m_highlighted_name`, `m_pt_allow`, `m_pt_rules_text`, `m_max_email_attach_size_mb`, `m_password_change_code`, `m_password_compat_scheme`, `m_on_probation_until`) VALUES(1, 'Guest', 'cb9f57a36ef4f7f5d7371fec898fb52b', '5027a59ee0ad94.82899191', '', '', 1, '', 0, 0, 1344775582, 'UTC', 1, 1344775582, 1344775582, 67, 0, 1, NULL, NULL, NULL, 1, '', '', '', '', 1, 0, '', '192.168.1.68', 1, 1, '', 1, 0, '*', 68, 5, '', '', NULL);
INSERT INTO `cms_f_members` (`id`, `m_username`, `m_pass_hash_salted`, `m_pass_salt`, `m_theme`, `m_avatar_url`, `m_validated`, `m_validated_email_confirm_code`, `m_cache_num_posts`, `m_cache_warnings`, `m_join_time`, `m_timezone_offset`, `m_primary_group`, `m_last_visit_time`, `m_last_submit_time`, `m_signature`, `m_is_perm_banned`, `m_preview_posts`, `m_dob_day`, `m_dob_month`, `m_dob_year`, `m_reveal_age`, `m_email_address`, `m_title`, `m_photo_url`, `m_photo_thumb_url`, `m_views_signatures`, `m_auto_monitor_contrib_content`, `m_language`, `m_ip_address`, `m_allow_emails`, `m_allow_emails_from_staff`, `m_notes`, `m_zone_wide`, `m_highlighted_name`, `m_pt_allow`, `m_pt_rules_text`, `m_max_email_attach_size_mb`, `m_password_change_code`, `m_password_compat_scheme`, `m_on_probation_until`) VALUES(2, 'admin', '7a3d8e11d09610667f3da74690d8cc6d', '5027a59ee30379.58521014', '', 'themes/default/images/ocf_default_avatars/default_set/cool_flare.png', 1, '', 0, 0, 1344775582, 'UTC', 2, 1344775582, 1344775582, 72, 0, 0, NULL, NULL, NULL, 1, '', '', '', '', 1, 1, '', '192.168.1.68', 1, 1, '', 1, 0, '*', 73, 5, '', '', NULL);
INSERT INTO `cms_f_members` (`id`, `m_username`, `m_pass_hash_salted`, `m_pass_salt`, `m_theme`, `m_avatar_url`, `m_validated`, `m_validated_email_confirm_code`, `m_cache_num_posts`, `m_cache_warnings`, `m_join_time`, `m_timezone_offset`, `m_primary_group`, `m_last_visit_time`, `m_last_submit_time`, `m_signature`, `m_is_perm_banned`, `m_preview_posts`, `m_dob_day`, `m_dob_month`, `m_dob_year`, `m_reveal_age`, `m_email_address`, `m_title`, `m_photo_url`, `m_photo_thumb_url`, `m_views_signatures`, `m_auto_monitor_contrib_content`, `m_language`, `m_ip_address`, `m_allow_emails`, `m_allow_emails_from_staff`, `m_notes`, `m_zone_wide`, `m_highlighted_name`, `m_pt_allow`, `m_pt_rules_text`, `m_max_email_attach_size_mb`, `m_password_change_code`, `m_password_compat_scheme`, `m_on_probation_until`) VALUES(3, 'test', '13e3d264c79211046c23625a89d78022', '5027a59ee40750.19930630', '', '', 1, '', 0, 0, 1344775582, 'UTC', 9, 1344775582, 1344775582, 77, 0, 0, NULL, NULL, NULL, 1, '', '', '', '', 1, 0, '', '192.168.1.68', 1, 1, '', 1, 0, '*', 78, 5, '', '', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_member_cpf_perms`
--

DROP TABLE IF EXISTS `cms_f_member_cpf_perms`;
CREATE TABLE IF NOT EXISTS `cms_f_member_cpf_perms` (
  `member_id` int(11) NOT NULL,
  `field_id` int(11) NOT NULL,
  `guest_view` tinyint(1) NOT NULL,
  `member_view` tinyint(1) NOT NULL,
  `friend_view` tinyint(1) NOT NULL,
  `group_view` varchar(255) NOT NULL,
  PRIMARY KEY (`member_id`,`field_id`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_member_cpf_perms`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_member_custom_fields`
--

DROP TABLE IF EXISTS `cms_f_member_custom_fields`;
CREATE TABLE IF NOT EXISTS `cms_f_member_custom_fields` (
  `mf_member_id` int(11) NOT NULL,
  `field_1` int(10) unsigned NOT NULL DEFAULT '0',
  `field_2` varchar(255) NOT NULL DEFAULT '',
  `field_3` varchar(255) NOT NULL DEFAULT '',
  `field_4` varchar(255) NOT NULL DEFAULT '',
  `field_5` varchar(255) NOT NULL DEFAULT '',
  `field_6` int(10) unsigned NOT NULL DEFAULT '0',
  `field_7` varchar(255) NOT NULL DEFAULT '',
  `field_8` varchar(255) NOT NULL DEFAULT '',
  `field_9` int(10) unsigned NOT NULL DEFAULT '0',
  `field_10` varchar(255) NOT NULL DEFAULT '',
  `field_11` varchar(255) NOT NULL DEFAULT '',
  `field_12` varchar(255) NOT NULL DEFAULT '',
  `field_13` longtext NOT NULL,
  `field_14` varchar(255) NOT NULL DEFAULT '',
  `field_15` longtext NOT NULL,
  `field_16` varchar(255) NOT NULL DEFAULT '',
  `field_17` varchar(255) NOT NULL DEFAULT '',
  `field_18` varchar(255) NOT NULL DEFAULT '',
  `field_19` varchar(255) NOT NULL DEFAULT '',
  `field_20` varchar(255) NOT NULL DEFAULT '',
  `field_21` varchar(255) NOT NULL DEFAULT '',
  `field_22` varchar(255) NOT NULL DEFAULT '',
  `field_23` longtext NOT NULL,
  `field_24` varchar(255) NOT NULL DEFAULT '',
  `field_25` varchar(255) NOT NULL DEFAULT '',
  `field_26` varchar(255) NOT NULL DEFAULT '',
  `field_27` longtext NOT NULL,
  `field_28` varchar(255) NOT NULL DEFAULT '',
  `field_29` varchar(255) NOT NULL DEFAULT '',
  `field_30` varchar(255) NOT NULL DEFAULT '',
  `field_31` varchar(255) NOT NULL DEFAULT '',
  `field_32` varchar(255) NOT NULL DEFAULT '',
  `field_33` varchar(255) NOT NULL DEFAULT '',
  `field_34` varchar(255) NOT NULL DEFAULT '',
  `field_35` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`mf_member_id`),
  FULLTEXT KEY `mcf2` (`field_2`),
  FULLTEXT KEY `mcf3` (`field_3`),
  FULLTEXT KEY `mcf4` (`field_4`),
  FULLTEXT KEY `mcf5` (`field_5`),
  FULLTEXT KEY `mcf7` (`field_7`),
  FULLTEXT KEY `mcf8` (`field_8`),
  FULLTEXT KEY `mcf10` (`field_10`),
  FULLTEXT KEY `mcf13` (`field_13`),
  FULLTEXT KEY `mcf14` (`field_14`),
  FULLTEXT KEY `mcf15` (`field_15`),
  FULLTEXT KEY `mcf17` (`field_17`),
  FULLTEXT KEY `mcf18` (`field_18`),
  FULLTEXT KEY `mcf19` (`field_19`),
  FULLTEXT KEY `mcf20` (`field_20`),
  FULLTEXT KEY `mcf21` (`field_21`),
  FULLTEXT KEY `mcf22` (`field_22`),
  FULLTEXT KEY `mcf23` (`field_23`),
  FULLTEXT KEY `mcf24` (`field_24`),
  FULLTEXT KEY `mcf25` (`field_25`),
  FULLTEXT KEY `mcf26` (`field_26`),
  FULLTEXT KEY `mcf27` (`field_27`),
  FULLTEXT KEY `mcf33` (`field_33`),
  FULLTEXT KEY `mcf34` (`field_34`),
  FULLTEXT KEY `mcf35` (`field_35`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_member_custom_fields`
--

INSERT INTO `cms_f_member_custom_fields` (`mf_member_id`, `field_1`, `field_2`, `field_3`, `field_4`, `field_5`, `field_6`, `field_7`, `field_8`, `field_9`, `field_10`, `field_11`, `field_12`, `field_13`, `field_14`, `field_15`, `field_16`, `field_17`, `field_18`, `field_19`, `field_20`, `field_21`, `field_22`, `field_23`, `field_24`, `field_25`, `field_26`, `field_27`, `field_28`, `field_29`, `field_30`, `field_31`, `field_32`, `field_33`, `field_34`, `field_35`) VALUES(1, 69, '', '', '', '', 70, '', '', 71, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `cms_f_member_custom_fields` (`mf_member_id`, `field_1`, `field_2`, `field_3`, `field_4`, `field_5`, `field_6`, `field_7`, `field_8`, `field_9`, `field_10`, `field_11`, `field_12`, `field_13`, `field_14`, `field_15`, `field_16`, `field_17`, `field_18`, `field_19`, `field_20`, `field_21`, `field_22`, `field_23`, `field_24`, `field_25`, `field_26`, `field_27`, `field_28`, `field_29`, `field_30`, `field_31`, `field_32`, `field_33`, `field_34`, `field_35`) VALUES(2, 74, '', '', '', '', 75, '', '', 76, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
INSERT INTO `cms_f_member_custom_fields` (`mf_member_id`, `field_1`, `field_2`, `field_3`, `field_4`, `field_5`, `field_6`, `field_7`, `field_8`, `field_9`, `field_10`, `field_11`, `field_12`, `field_13`, `field_14`, `field_15`, `field_16`, `field_17`, `field_18`, `field_19`, `field_20`, `field_21`, `field_22`, `field_23`, `field_24`, `field_25`, `field_26`, `field_27`, `field_28`, `field_29`, `field_30`, `field_31`, `field_32`, `field_33`, `field_34`, `field_35`) VALUES(3, 79, '', '', '', '', 80, '', '', 81, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_member_known_login_ips`
--

DROP TABLE IF EXISTS `cms_f_member_known_login_ips`;
CREATE TABLE IF NOT EXISTS `cms_f_member_known_login_ips` (
  `i_member_id` int(11) NOT NULL,
  `i_ip` varchar(40) NOT NULL,
  `i_val_code` varchar(255) NOT NULL,
  PRIMARY KEY (`i_member_id`,`i_ip`)
) ENGINE=MyISAM;

--
-- Dumping data for table `cms_f_member_known_login_ips`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_moderator_logs`
--

DROP TABLE IF EXISTS `cms_f_moderator_logs`;
CREATE TABLE IF NOT EXISTS `cms_f_moderator_logs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `l_the_type` varchar(80) NOT NULL,
  `l_param_a` varchar(255) NOT NULL,
  `l_param_b` varchar(255) NOT NULL,
  `l_date_and_time` int(10) unsigned NOT NULL,
  `l_reason` longtext NOT NULL,
  `l_by` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1 ;

--
-- Dumping data for table `cms_f_moderator_logs`
--


-- --------------------------------------------------------

--
-- Table structure for table `cms_f_multi_moderations`
--

DROP TABLE IF EXISTS `cms_f_multi_moderations`;
CREATE TABLE IF NOT EXISTS `cms_f_multi_moderations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mm_name` int(10) unsigned NOT NULL,
  `mm_post_text` longtext NOT NULL,
  `mm_move_to` int(11) DEFAULT NULL,
  `mm_pin_state` tinyint(1) DEFAULT NULL,
  `mm_sink_state` tinyint(1) DEFAULT NULL,
  `mm_open_state` tinyint(1) DEFAULT NULL,
  `mm_forum_multi_code` varchar(255) NOT NULL,
  `mm_title_suffix` varchar(255) NOT NULL,
  PRIMARY KEY (`id`,`mm_name`)
) ENGINE=MyISAM  AUTO_INCREMENT=2 ;

--
-- Dumping data for table `cms_f_multi_moderations`
--

INSERT INTO `cms_f_multi_moderations` (`id`, `mm_name`, `mm_post_text`, `mm_move_to`, `mm_pin_state`, `mm_sink_state`, `mm_open_state`, `mm_forum_multi_code`, `mm_title_suffix`) VALUES(1, 66, '', 4, 0, 0, 0, '*', '');

-- --------------------------------------------------------

--
-- Table structure for table `cms_f_polls`
--

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
