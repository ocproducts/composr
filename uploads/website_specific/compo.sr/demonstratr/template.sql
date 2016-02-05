-- MySQL dump 10.11
--
-- Host: localhost    Database: mycms_site_shareddemo
-- ------------------------------------------------------
-- Server version	5.0.92-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cms_addons`
--

DROP TABLE IF EXISTS `cms_addons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_addons` (
  `addon_author` varchar(255) NOT NULL,
  `addon_description` longtext NOT NULL,
  `addon_install_time` int(10) unsigned NOT NULL,
  `addon_name` varchar(255) NOT NULL,
  `addon_organisation` varchar(255) NOT NULL,
  `addon_version` varchar(255) NOT NULL,
  PRIMARY KEY  (`addon_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_addons`
--

LOCK TABLES `cms_addons` WRITE;
/*!40000 ALTER TABLE `cms_addons` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_addons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_addons_dependencies`
--

DROP TABLE IF EXISTS `cms_addons_dependencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_addons_dependencies` (
  `addon_name` varchar(255) NOT NULL,
  `addon_name_dependant_upon` varchar(255) NOT NULL,
  `addon_name_incompatibility` tinyint(1) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_addons_dependencies`
--

LOCK TABLES `cms_addons_dependencies` WRITE;
/*!40000 ALTER TABLE `cms_addons_dependencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_addons_dependencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_addons_files`
--

DROP TABLE IF EXISTS `cms_addons_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_addons_files` (
  `addon_name` varchar(255) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_addons_files`
--

LOCK TABLES `cms_addons_files` WRITE;
/*!40000 ALTER TABLE `cms_addons_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_addons_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_adminlogs`
--

DROP TABLE IF EXISTS `cms_adminlogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_adminlogs` (
  `date_and_time` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip` varchar(40) NOT NULL,
  `param_a` varchar(80) NOT NULL,
  `param_b` varchar(255) NOT NULL,
  `the_type` varchar(80) NOT NULL,
  `the_user` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_adminlogs`
--

LOCK TABLES `cms_adminlogs` WRITE;
/*!40000 ALTER TABLE `cms_adminlogs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_adminlogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_attachment_refs`
--

DROP TABLE IF EXISTS `cms_attachment_refs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_attachment_refs` (
  `a_id` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `r_referer_id` varchar(80) NOT NULL,
  `r_referer_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_attachment_refs`
--

LOCK TABLES `cms_attachment_refs` WRITE;
/*!40000 ALTER TABLE `cms_attachment_refs` DISABLE KEYS */;
INSERT INTO `cms_attachment_refs` VALUES (1,1,'1','cedi_post'),(2,2,'2','cedi_post'),(3,16,':rich','comcode_page'),(3,8,':rich','comcode_page'),(4,14,':rich','comcode_page'),(5,15,':rich','comcode_page');
/*!40000 ALTER TABLE `cms_attachment_refs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_attachments`
--

DROP TABLE IF EXISTS `cms_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_attachments` (
  `a_add_time` int(11) NOT NULL,
  `a_description` varchar(255) NOT NULL,
  `a_file_size` int(11) default NULL,
  `a_last_downloaded_time` int(11) default NULL,
  `a_member_id` int(11) NOT NULL,
  `a_num_downloads` int(11) NOT NULL,
  `a_original_filename` varchar(255) NOT NULL,
  `a_thumb_url` varchar(255) NOT NULL,
  `a_url` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_attachments`
--

LOCK TABLES `cms_attachments` WRITE;
/*!40000 ALTER TABLE `cms_attachments` DISABLE KEYS */;
INSERT INTO `cms_attachments` VALUES (1264682350,'',361097,NULL,2,0,'Romeo_and_juliet_brown.jpg','uploads/attachments_thumbs/4b61856e782ae.jpg','uploads/attachments/4b61856e782ae.jpg',1),(1264682523,'',152244,NULL,2,0,'Edwin_Booth_Hamlet_1870.jpg','uploads/attachments_thumbs/4b61861b3e467.jpg','uploads/attachments/4b61861b3e467.jpg',2),(1264687209,'',82395,1265480681,2,17,'Sample.mov','','uploads/attachments/4b6198699c2a6.dat',3),(1265480596,'',539716,NULL,2,0,'Shakespeare-1.jpg','uploads/attachments_thumbs/4b6db39467550.jpg','uploads/attachments/4b6db39467550.jpg',4),(1265480597,'',539716,NULL,2,0,'Shakespeare-1.jpg','uploads/attachments_thumbs/4b6db394dd559.jpg','uploads/attachments/4b6db394dd559.jpg',5);
/*!40000 ALTER TABLE `cms_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_authors`
--

DROP TABLE IF EXISTS `cms_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_authors` (
  `author` varchar(80) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `forum_handle` int(11) default NULL,
  `skills` int(10) unsigned NOT NULL,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY  (`author`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_authors`
--

LOCK TABLES `cms_authors` WRITE;
/*!40000 ALTER TABLE `cms_authors` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_autosave`
--

DROP TABLE IF EXISTS `cms_autosave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_autosave` (
  `a_key` longtext NOT NULL,
  `a_member_id` int(11) NOT NULL,
  `a_time` int(10) unsigned NOT NULL,
  `a_value` longtext NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_autosave`
--

LOCK TABLES `cms_autosave` WRITE;
/*!40000 ALTER TABLE `cms_autosave` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_autosave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_award_archive`
--

DROP TABLE IF EXISTS `cms_award_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_award_archive` (
  `a_type_id` int(11) NOT NULL,
  `content_id` varchar(80) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `member_id` int(11) NOT NULL,
  PRIMARY KEY  (`a_type_id`,`date_and_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_award_archive`
--

LOCK TABLES `cms_award_archive` WRITE;
/*!40000 ALTER TABLE `cms_award_archive` DISABLE KEYS */;
INSERT INTO `cms_award_archive` VALUES (1,'1',1264686219,2);
/*!40000 ALTER TABLE `cms_award_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_award_types`
--

DROP TABLE IF EXISTS `cms_award_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_award_types` (
  `a_content_type` varchar(80) NOT NULL,
  `a_description` int(10) unsigned NOT NULL,
  `a_hide_awardee` tinyint(1) NOT NULL,
  `a_points` int(11) NOT NULL,
  `a_title` int(10) unsigned NOT NULL,
  `a_update_time_hours` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_award_types`
--

LOCK TABLES `cms_award_types` WRITE;
/*!40000 ALTER TABLE `cms_award_types` DISABLE KEYS */;
INSERT INTO `cms_award_types` VALUES ('download',92,1,0,91,168,1);
/*!40000 ALTER TABLE `cms_award_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_banner_clicks`
--

DROP TABLE IF EXISTS `cms_banner_clicks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_banner_clicks` (
  `c_banner_id` varchar(80) NOT NULL,
  `c_date_and_time` int(10) unsigned NOT NULL,
  `c_ip_address` varchar(40) NOT NULL,
  `c_member_id` int(11) NOT NULL,
  `c_source` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `clicker_ip` (`c_ip_address`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_banner_clicks`
--

LOCK TABLES `cms_banner_clicks` WRITE;
/*!40000 ALTER TABLE `cms_banner_clicks` DISABLE KEYS */;
INSERT INTO `cms_banner_clicks` VALUES ('donate',1264608541,'90.152.0.114',1,'',1),('banner1',1264608676,'90.152.0.114',1,'',2),('banner1',1264624362,'90.152.0.114',1,'',3),('banner1',1264669383,'90.152.0.114',1,'',4),('banner1',1264670437,'90.152.0.114',1,'',5);
/*!40000 ALTER TABLE `cms_banner_clicks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_banner_types`
--

DROP TABLE IF EXISTS `cms_banner_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_banner_types` (
  `id` varchar(80) NOT NULL,
  `t_comcode_inline` tinyint(1) NOT NULL,
  `t_image_height` int(11) NOT NULL,
  `t_image_width` int(11) NOT NULL,
  `t_is_textual` tinyint(1) NOT NULL,
  `t_max_file_size` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_banner_types`
--

LOCK TABLES `cms_banner_types` WRITE;
/*!40000 ALTER TABLE `cms_banner_types` DISABLE KEYS */;
INSERT INTO `cms_banner_types` VALUES ('',0,60,468,0,80);
/*!40000 ALTER TABLE `cms_banner_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_banners`
--

DROP TABLE IF EXISTS `cms_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_banners` (
  `add_date` int(10) unsigned NOT NULL,
  `b_title_text` varchar(255) NOT NULL,
  `b_type` varchar(80) NOT NULL,
  `campaign_remaining` int(11) NOT NULL,
  `caption` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned default NULL,
  `expiry_date` int(10) unsigned default NULL,
  `hits_from` int(11) NOT NULL,
  `hits_to` int(11) NOT NULL,
  `img_url` varchar(255) NOT NULL,
  `importance_modulus` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `notes` longtext NOT NULL,
  `site_url` varchar(255) NOT NULL,
  `submitter` int(11) NOT NULL,
  `the_type` tinyint(4) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `views_from` int(11) NOT NULL,
  `views_to` int(11) NOT NULL,
  `b_direct_code` longtext NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_banners`
--

LOCK TABLES `cms_banners` WRITE;
/*!40000 ALTER TABLE `cms_banners` DISABLE KEYS */;
INSERT INTO `cms_banners` VALUES (1264608453,'','',-1,525,1264608660,NULL,0,1,'uploads/banners/banner1.png',30,'banner1','','/site/index.php?page=banner',2,0,1,0,225,'');
/*!40000 ALTER TABLE `cms_banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_blocks`
--

DROP TABLE IF EXISTS `cms_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_blocks` (
  `block_author` varchar(80) NOT NULL,
  `block_hacked_by` varchar(80) NOT NULL,
  `block_hack_version` int(11) default NULL,
  `block_name` varchar(80) NOT NULL,
  `block_organisation` varchar(80) NOT NULL,
  `block_version` int(11) NOT NULL,
  PRIMARY KEY  (`block_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_blocks`
--

LOCK TABLES `cms_blocks` WRITE;
/*!40000 ALTER TABLE `cms_blocks` DISABLE KEYS */;
INSERT INTO `cms_blocks` VALUES ('Chris Graham','',NULL,'bottom_forum_news','ocProducts',2),('Chris Graham','',NULL,'bottom_news','ocProducts',2),('Chris Graham','',NULL,'bottom_rss','ocProducts',2),('Chris Graham','',NULL,'main_as_zone_access','ocProducts',2),('Chris Graham','',NULL,'main_awards','ocProducts',2),('Chris Graham','',NULL,'main_banner_wave','ocProducts',2),('Chris Graham','',NULL,'main_block_help','ocProducts',2),('Chris Graham','',NULL,'main_cc_embed','ocProducts',2),('Chris Graham','',NULL,'main_code_documentor','ocProducts',2),('Chris Graham','',NULL,'main_comcode_page_children','ocProducts',2),('Chris Graham','',NULL,'main_comments','ocProducts',2),('Chris Graham','',NULL,'main_contact_simple','ocProducts',2),('Chris Graham','',NULL,'main_contact_us','ocProducts',2),('Chris Graham','',NULL,'main_content','ocProducts',2),('Chris Graham','',NULL,'main_count','ocProducts',2),('Chris Graham','',NULL,'main_countdown','ocProducts',2),('Chris Graham','',NULL,'main_custom_comcode_tags','ocProducts',2),('Chris Graham','',NULL,'main_custom_gfx','ocProducts',1),('Chris Graham','',NULL,'main_db_notes','ocProducts',2),('Chris Graham','',NULL,'main_download_category','ocProducts',2),('Chris Graham','',NULL,'main_download_tease','ocProducts',2),('Chris Graham','',NULL,'main_emoticon_codes','ocProducts',2),('Chris Graham','',NULL,'main_feedback','ocProducts',1),('Chris Graham','',NULL,'main_forum_news','ocProducts',2),('Chris Graham','',NULL,'main_forum_topics','ocProducts',2),('Chris Graham','',NULL,'main_gallery_embed','ocProducts',2),('Chris Graham','',NULL,'main_gallery_tease','ocProducts',2),('Chris Graham','',NULL,'main_greeting','ocProducts',2),('Chris Graham','',NULL,'main_include_module','ocProducts',1),('Chris Graham','',NULL,'main_iotd','ocProducts',2),('Chris Graham','',NULL,'main_leader_board','ocProducts',3),('Chris Graham','',NULL,'main_news','ocProducts',2),('Chris Graham','',NULL,'main_newsletter_signup','ocProducts',2),('Chris Graham','',NULL,'main_notes','ocProducts',2),('Chris Graham','',NULL,'main_only_if_match','ocProducts',2),('Chris Graham','',NULL,'main_poll','ocProducts',2),('Chris Graham','',NULL,'main_quotes','ocProducts',2),('Chris Graham','',NULL,'main_rating','ocProducts',2),('Chris Graham','',NULL,'main_recent_cc_entries','ocProducts',2),('Chris Graham','',NULL,'main_recent_downloads','ocProducts',2),('Chris Graham','',NULL,'main_recent_galleries','ocProducts',2),('Chris Graham','',NULL,'main_rss','ocProducts',3),('Chris Graham','',NULL,'main_screen_actions','ocProducts',2),('Chris Graham','',NULL,'main_search','ocProducts',2),('Chris Graham','',NULL,'main_sitemap','ocProducts',2),('Chris Graham','',NULL,'main_staff_actions','ocProducts',2),('Chris Graham','',NULL,'main_staff_checklist','ocProducts',4),('Chris Graham','',NULL,'main_staff_new_version','ocProducts',2),('Chris Graham','',NULL,'main_staff_tips','ocProducts',2),('Chris Graham','',NULL,'main_top_downloads','ocProducts',2),('Chris Graham','',NULL,'main_top_galleries','ocProducts',2),('Chris Graham','',NULL,'main_topsites','ocProducts',2),('Philip Withnall','',NULL,'main_trackback','ocProducts',1),('Chris Graham','',NULL,'side_calendar','ocProducts',2),('Chris Graham','',NULL,'side_forum_news','ocProducts',2),('Chris Graham','',NULL,'side_language','ocProducts',2),('Chris Graham','',NULL,'side_network','ocProducts',2),('Chris Graham','',NULL,'side_news','ocProducts',2),('Chris Graham','',NULL,'side_news_categories','ocProducts',2),('Chris Graham','',NULL,'side_ocf_personal_topics','ocProducts',2),('Chris Graham','',NULL,'side_personal_stats','ocProducts',2),('Chris Graham','',NULL,'side_printer_friendly','ocProducts',2),('Chris Graham','',NULL,'side_root_galleries','ocProducts',2),('Chris Graham','',NULL,'side_rss','ocProducts',2),('Philip Withnall','',NULL,'side_shoutbox','ocProducts',3),('Chris Graham','',NULL,'side_stats','ocProducts',3),('Chris Graham','',NULL,'side_stored_menu','ocProducts',2),('Chris Graham','',NULL,'side_tag_cloud','ocProducts',3),('Chris Graham','',NULL,'side_users_online','ocProducts',3),('Manuprathap','',NULL,'side_weather','ocProducts',6),('Chris Graham','',NULL,'side_zone_jump','ocProducts',2),('Chris Graham','',NULL,'main_multi_content','ocProducts',2),('Chris Graham','',NULL,'main_image_fader','ocProducts',2),('Chris Graham','',NULL,'main_contact_catalogues','ocProducts',2),('Jack Franklin','',NULL,'main_staff_website_monitoring','ocProducts',3),('Chris Graham','',NULL,'side_news_archive','ocProducts',2),('Jack Franklin','',NULL,'main_staff_links','ocProducts',3),('Chris Graham','',NULL,'main_content_filtering','ocProducts',2),('Chris Graham','',NULL,'main_pt_notifications','ocProducts',2),('Chris Graham','',NULL,'main_bottom_bar','ocProducts',2),('Chris Graham','',NULL,'main_member_bar','ocProducts',2);
/*!40000 ALTER TABLE `cms_blocks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_bookmarks`
--

DROP TABLE IF EXISTS `cms_bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_bookmarks` (
  `b_folder` varchar(255) NOT NULL,
  `b_owner` int(11) NOT NULL,
  `b_page_link` varchar(255) NOT NULL,
  `b_title` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_bookmarks`
--

LOCK TABLES `cms_bookmarks` WRITE;
/*!40000 ALTER TABLE `cms_bookmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_cache`
--

DROP TABLE IF EXISTS `cms_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_cache` (
  `cached_for` varchar(80) NOT NULL,
  `identifier` varchar(40) NOT NULL,
  `the_value` longtext NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `the_theme` varchar(80) NOT NULL,
  `lang` varchar(5) NOT NULL,
  `langs_required` longtext NOT NULL,
  PRIMARY KEY  (`cached_for`,`identifier`,`the_theme`,`lang`),
  KEY `cached_ford` (`date_and_time`),
  KEY `cached_fore` (`cached_for`),
  KEY `cached_forf` (`lang`),
  KEY `cached_forg` (`identifier`),
  KEY `cached_forh` (`the_theme`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_cache`
--

LOCK TABLES `cms_cache` WRITE;
/*!40000 ALTER TABLE `cms_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_cache_on`
--

DROP TABLE IF EXISTS `cms_cache_on`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_cache_on` (
  `cached_for` varchar(80) NOT NULL,
  `cache_on` longtext NOT NULL,
  `cache_ttl` int(11) NOT NULL,
  PRIMARY KEY  (`cached_for`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_cache_on`
--

LOCK TABLES `cms_cache_on` WRITE;
/*!40000 ALTER TABLE `cms_cache_on` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_cache_on` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_cached_comcode_pages`
--

DROP TABLE IF EXISTS `cms_cached_comcode_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_cached_comcode_pages` (
  `cc_page_title` int(10) unsigned default NULL,
  `string_index` int(10) unsigned NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_theme` varchar(80) NOT NULL,
  `the_zone` varchar(80) NOT NULL,
  PRIMARY KEY  (`the_page`,`the_theme`,`the_zone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_cached_comcode_pages`
--

LOCK TABLES `cms_cached_comcode_pages` WRITE;
/*!40000 ALTER TABLE `cms_cached_comcode_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_cached_comcode_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_cached_weather_codes`
--

DROP TABLE IF EXISTS `cms_cached_weather_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_cached_weather_codes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `w_string` varchar(255) NOT NULL,
  `w_code` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_cached_weather_codes`
--

LOCK TABLES `cms_cached_weather_codes` WRITE;
/*!40000 ALTER TABLE `cms_cached_weather_codes` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_cached_weather_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_calendar_events`
--

DROP TABLE IF EXISTS `cms_calendar_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_calendar_events` (
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `e_add_date` int(10) unsigned NOT NULL,
  `e_content` int(10) unsigned NOT NULL,
  `e_edit_date` int(10) unsigned default NULL,
  `e_end_day` int(11) default NULL,
  `e_end_hour` int(11) default NULL,
  `e_end_minute` int(11) default NULL,
  `e_end_month` int(11) default NULL,
  `e_end_year` int(11) default NULL,
  `e_is_public` tinyint(1) NOT NULL,
  `e_priority` int(11) NOT NULL,
  `e_recurrence` varchar(80) NOT NULL,
  `e_recurrences` int(11) default NULL,
  `e_seg_recurrences` tinyint(1) NOT NULL,
  `e_start_day` int(11) NOT NULL,
  `e_start_hour` int(11) default NULL,
  `e_start_minute` int(11) default NULL,
  `e_start_month` int(11) NOT NULL,
  `e_start_year` int(11) NOT NULL,
  `e_submitter` int(11) NOT NULL,
  `e_title` int(10) unsigned NOT NULL,
  `e_type` int(11) NOT NULL,
  `e_views` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `e_timezone` varchar(80) NOT NULL default '',
  `e_do_timezone_conv` tinyint(1) NOT NULL default '1',
  `e_start_monthly_spec_type` varchar(80) NOT NULL default 'day_of_month',
  `e_end_monthly_spec_type` varchar(80) NOT NULL default 'day_of_month',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_calendar_events`
--

LOCK TABLES `cms_calendar_events` WRITE;
/*!40000 ALTER TABLE `cms_calendar_events` DISABLE KEYS */;
INSERT INTO `cms_calendar_events` VALUES (1,1,1,1264682830,711,NULL,1,15,0,1,2010,1,3,'daily',NULL,1,1,12,0,1,2010,2,710,2,2,1,'',1,'Atlantic/Azores',1,'day_of_month','day_of_month');
/*!40000 ALTER TABLE `cms_calendar_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_calendar_interests`
--

DROP TABLE IF EXISTS `cms_calendar_interests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_calendar_interests` (
  `i_member_id` int(11) NOT NULL,
  `t_type` int(11) NOT NULL,
  PRIMARY KEY  (`i_member_id`,`t_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_calendar_interests`
--

LOCK TABLES `cms_calendar_interests` WRITE;
/*!40000 ALTER TABLE `cms_calendar_interests` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_calendar_interests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_calendar_jobs`
--

DROP TABLE IF EXISTS `cms_calendar_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_calendar_jobs` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `j_event_id` int(11) NOT NULL,
  `j_member_id` int(11) default NULL,
  `j_reminder_id` int(11) default NULL,
  `j_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_calendar_jobs`
--

LOCK TABLES `cms_calendar_jobs` WRITE;
/*!40000 ALTER TABLE `cms_calendar_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_calendar_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_calendar_reminders`
--

DROP TABLE IF EXISTS `cms_calendar_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_calendar_reminders` (
  `e_id` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `n_member_id` int(11) NOT NULL,
  `n_seconds_before` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_calendar_reminders`
--

LOCK TABLES `cms_calendar_reminders` WRITE;
/*!40000 ALTER TABLE `cms_calendar_reminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_calendar_reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_calendar_types`
--

DROP TABLE IF EXISTS `cms_calendar_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_calendar_types` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `t_logo` varchar(255) NOT NULL,
  `t_title` int(10) unsigned NOT NULL,
  `t_external_feed` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_calendar_types`
--

LOCK TABLES `cms_calendar_types` WRITE;
/*!40000 ALTER TABLE `cms_calendar_types` DISABLE KEYS */;
INSERT INTO `cms_calendar_types` VALUES (1,'calendar/system_command',174,''),(2,'calendar/general',175,''),(3,'calendar/birthday',176,''),(4,'calendar/public_holiday',177,''),(5,'calendar/vacation',178,''),(6,'calendar/appointment',179,''),(7,'calendar/commitment',180,''),(8,'calendar/anniversary',181,'');
/*!40000 ALTER TABLE `cms_calendar_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_cat_treecache`
--

DROP TABLE IF EXISTS `cms_catalogue_cat_treecache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_cat_treecache` (
  `cc_id` int(11) NOT NULL,
  `cc_ancestor_id` int(11) NOT NULL,
  PRIMARY KEY  (`cc_id`,`cc_ancestor_id`),
  KEY `cc_ancestor_id` (`cc_ancestor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_cat_treecache`
--

LOCK TABLES `cms_catalogue_cat_treecache` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_cat_treecache` DISABLE KEYS */;
INSERT INTO `cms_catalogue_cat_treecache` VALUES (3,3),(5,5),(6,6),(7,7),(8,6),(8,8);
/*!40000 ALTER TABLE `cms_catalogue_cat_treecache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_categories`
--

DROP TABLE IF EXISTS `cms_catalogue_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_categories` (
  `cc_add_date` int(10) unsigned NOT NULL,
  `cc_description` int(10) unsigned NOT NULL,
  `cc_move_days_higher` int(11) NOT NULL,
  `cc_move_days_lower` int(11) NOT NULL,
  `cc_move_target` int(11) default NULL,
  `cc_notes` longtext NOT NULL,
  `cc_parent_id` int(11) default NULL,
  `cc_title` int(10) unsigned NOT NULL,
  `c_name` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `rep_image` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `cc_parent_id` (`cc_parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_categories`
--

LOCK TABLES `cms_catalogue_categories` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_categories` DISABLE KEYS */;
INSERT INTO `cms_catalogue_categories` VALUES (1264606826,223,60,30,NULL,'',NULL,222,'links',3,''),(1264606826,267,60,30,NULL,'',NULL,266,'contacts',5,''),(1264606826,279,60,30,NULL,'',NULL,278,'products',6,''),(1264676385,652,60,30,NULL,'',NULL,653,'products',7,''),(1264679163,654,60,30,NULL,'',6,655,'products',8,'');
/*!40000 ALTER TABLE `cms_catalogue_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_childcountcache`
--

DROP TABLE IF EXISTS `cms_catalogue_childcountcache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_childcountcache` (
  `cc_id` int(11) NOT NULL,
  `c_num_rec_children` int(11) NOT NULL,
  `c_num_rec_entries` int(11) NOT NULL,
  PRIMARY KEY  (`cc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_childcountcache`
--

LOCK TABLES `cms_catalogue_childcountcache` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_childcountcache` DISABLE KEYS */;
INSERT INTO `cms_catalogue_childcountcache` VALUES (3,0,3),(5,0,2),(6,0,0),(7,0,0),(8,0,2);
/*!40000 ALTER TABLE `cms_catalogue_childcountcache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_efv_float`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_float`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_efv_float` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` double default NULL,
  PRIMARY KEY  (`id`),
  KEY `fcv_value` (`cv_value`),
  KEY `fcf_id` (`cf_id`),
  KEY `fce_id` (`ce_id`),
  KEY `cefv_f_combo` (`ce_id`,`cf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_efv_float`
--

LOCK TABLES `cms_catalogue_efv_float` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_efv_float` DISABLE KEYS */;
INSERT INTO `cms_catalogue_efv_float` VALUES (1,34,1,15),(2,34,2,20),(3,40,1,2),(4,40,2,0);
/*!40000 ALTER TABLE `cms_catalogue_efv_float` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_efv_integer`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_integer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_efv_integer` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `cf_id` int(11) NOT NULL,
  `ce_id` int(11) NOT NULL,
  `cv_value` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `itv_value` (`cv_value`),
  KEY `icf_id` (`cf_id`),
  KEY `ice_id` (`ce_id`),
  KEY `cefv_i_combo` (`ce_id`,`cf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_efv_integer`
--

LOCK TABLES `cms_catalogue_efv_integer` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_efv_integer` DISABLE KEYS */;
INSERT INTO `cms_catalogue_efv_integer` VALUES (1,33,1,0),(2,33,2,1),(3,35,1,300),(4,35,2,300),(5,36,1,50),(6,36,2,50);
/*!40000 ALTER TABLE `cms_catalogue_efv_integer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_efv_long`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_long`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_efv_long` (
  `ce_id` int(11) NOT NULL,
  `cf_id` int(11) NOT NULL,
  `cv_value` longtext NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `lcf_id` (`cf_id`),
  KEY `lce_id` (`ce_id`),
  KEY `cefv_l_combo` (`ce_id`,`cf_id`),
  FULLTEXT KEY `lcv_value` (`cv_value`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_efv_long`
--

LOCK TABLES `cms_catalogue_efv_long` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_efv_long` DISABLE KEYS */;
INSERT INTO `cms_catalogue_efv_long` VALUES (1,37,'No',1),(1,38,'10%',2),(2,37,'No',3),(2,38,'10%',4),(3,30,'State of the Union\nInauguration',5),(3,31,'President of the United States: 2008-',6),(4,30,'Queen\'s Speech\n',7),(4,31,'Prime Minister of the United Kingdom of Great Britain and Northern Ireland: 2007-',8);
/*!40000 ALTER TABLE `cms_catalogue_efv_long` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_efv_long_trans`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_long_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_efv_long_trans` (
  `ce_id` int(11) NOT NULL,
  `cf_id` int(11) NOT NULL,
  `cv_value` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `ltcf_id` (`cf_id`),
  KEY `ltce_id` (`ce_id`),
  KEY `cefv_lt_combo` (`ce_id`,`cf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_efv_long_trans`
--

LOCK TABLES `cms_catalogue_efv_long_trans` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_efv_long_trans` DISABLE KEYS */;
INSERT INTO `cms_catalogue_efv_long_trans` VALUES (1,41,657,1),(2,41,663,2),(5,16,675,3),(6,16,679,4),(7,16,683,5);
/*!40000 ALTER TABLE `cms_catalogue_efv_long_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_efv_short`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_short`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_efv_short` (
  `ce_id` int(11) NOT NULL,
  `cf_id` int(11) NOT NULL,
  `cv_value` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `iscv_value` (`cv_value`),
  KEY `scf_id` (`cf_id`),
  KEY `sce_id` (`ce_id`),
  KEY `cefv_s_combo` (`ce_id`,`cf_id`),
  FULLTEXT KEY `scv_value` (`cv_value`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_efv_short`
--

LOCK TABLES `cms_catalogue_efv_short` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_efv_short` DISABLE KEYS */;
INSERT INTO `cms_catalogue_efv_short` VALUES (1,39,'uploads/catalogues/Romeo_and_juliet_brown.jpg',5),(2,39,'uploads/catalogues/Edwin_Booth_Hamlet_1870.jpg',11),(3,20,'Barack',13),(3,21,'Obama',14),(3,22,'potus@whitehouse.gov',15),(3,23,'The Executive Office of the President of the United States of America',16),(3,24,'The White House, 1600 Pennsylvania Avenue NW',17),(3,25,'Washington D.C.',18),(3,26,'202-456-1414',19),(3,27,'202-456-1414',20),(3,28,'http://whitehouse.gov',21),(3,29,'barryo@msn.com',22),(4,20,'Gordon',23),(4,21,'Brown',24),(4,22,'pm@number10.gov.uk',25),(4,23,'Her Majesty\'s Government',26),(4,24,'10 Downing Street',27),(4,25,'London',28),(4,26,'020 7925 0918',29),(4,27,'020 7925 0918',30),(4,28,'http://www.number10.gov.uk/',31),(4,29,'gordon@aol.com',32),(5,15,'http://compo.sr',33),(6,15,'http://ocproducts.com',34),(7,15,'http://www.opensource.org/',35);
/*!40000 ALTER TABLE `cms_catalogue_efv_short` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_efv_short_trans`
--

DROP TABLE IF EXISTS `cms_catalogue_efv_short_trans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_efv_short_trans` (
  `ce_id` int(11) NOT NULL,
  `cf_id` int(11) NOT NULL,
  `cv_value` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `stcf_id` (`cf_id`),
  KEY `stce_id` (`ce_id`),
  KEY `cefv_st_combo` (`ce_id`,`cf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_efv_short_trans`
--

LOCK TABLES `cms_catalogue_efv_short_trans` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_efv_short_trans` DISABLE KEYS */;
INSERT INTO `cms_catalogue_efv_short_trans` VALUES (1,32,656,1),(2,32,662,2),(5,14,674,3),(6,14,678,4),(7,14,682,5);
/*!40000 ALTER TABLE `cms_catalogue_efv_short_trans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_entries`
--

DROP TABLE IF EXISTS `cms_catalogue_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_entries` (
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `cc_id` int(11) NOT NULL,
  `ce_add_date` int(10) unsigned NOT NULL,
  `ce_edit_date` int(10) unsigned default NULL,
  `ce_last_moved` int(11) NOT NULL,
  `ce_submitter` int(11) NOT NULL,
  `ce_validated` tinyint(1) NOT NULL,
  `ce_views` int(11) NOT NULL,
  `ce_views_prior` int(11) NOT NULL,
  `c_name` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `ce_cc_id` (`cc_id`),
  KEY `ce_add_date` (`ce_add_date`),
  KEY `ce_c_name` (`c_name`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_entries`
--

LOCK TABLES `cms_catalogue_entries` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_entries` DISABLE KEYS */;
INSERT INTO `cms_catalogue_entries` VALUES (1,1,1,8,1264679306,1264679415,1264679306,2,1,2,0,'products',1,''),(1,1,1,8,1264680079,NULL,1264680079,2,1,1,0,'products',2,''),(1,1,1,5,1264680508,1264681218,1264680508,2,1,4,0,'contacts',3,''),(1,1,1,5,1264681168,NULL,1264681168,2,1,1,0,'contacts',4,''),(1,1,1,3,1264681490,1264681633,1264681490,2,1,1,0,'links',5,''),(1,1,1,3,1264681510,1264681673,1264681510,2,1,1,0,'links',6,''),(1,1,1,3,1264681572,1264681714,1264681572,2,1,1,0,'links',7,'');
/*!40000 ALTER TABLE `cms_catalogue_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_entry_linkage`
--

DROP TABLE IF EXISTS `cms_catalogue_entry_linkage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_entry_linkage` (
  `catalogue_entry_id` int(11) NOT NULL,
  `content_type` varchar(80) NOT NULL,
  `content_id` varchar(80) NOT NULL,
  PRIMARY KEY  (`catalogue_entry_id`),
  KEY `custom_fields` (`content_type`,`content_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_entry_linkage`
--

LOCK TABLES `cms_catalogue_entry_linkage` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_entry_linkage` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_catalogue_entry_linkage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogue_fields`
--

DROP TABLE IF EXISTS `cms_catalogue_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogue_fields` (
  `cf_default` longtext NOT NULL,
  `cf_defines_order` tinyint(1) NOT NULL,
  `cf_description` int(10) unsigned NOT NULL,
  `cf_name` int(10) unsigned NOT NULL,
  `cf_order` tinyint(4) NOT NULL,
  `cf_put_in_category` tinyint(1) NOT NULL,
  `cf_put_in_search` tinyint(1) NOT NULL,
  `cf_required` tinyint(1) NOT NULL,
  `cf_searchable` tinyint(1) NOT NULL,
  `cf_type` varchar(80) NOT NULL,
  `cf_visible` tinyint(1) NOT NULL,
  `c_name` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=42 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogue_fields`
--

LOCK TABLES `cms_catalogue_fields` WRITE;
/*!40000 ALTER TABLE `cms_catalogue_fields` DISABLE KEYS */;
INSERT INTO `cms_catalogue_fields` VALUES ('',1,225,224,0,1,1,1,1,'short_trans',1,'links',14),('',0,227,226,1,0,1,1,1,'url',1,'links',15),('',0,229,228,2,1,1,0,1,'long_trans',1,'links',16),('',0,243,242,0,1,1,1,1,'short_text',1,'contacts',20),('',1,245,244,1,1,1,1,1,'short_text',1,'contacts',21),('',0,247,246,2,1,1,1,1,'short_text',1,'contacts',22),('',0,249,248,3,1,1,1,1,'short_text',1,'contacts',23),('',0,251,250,4,1,1,1,1,'short_text',1,'contacts',24),('',0,253,252,5,1,1,1,1,'short_text',1,'contacts',25),('',0,255,254,6,1,1,1,1,'short_text',1,'contacts',26),('',0,257,256,7,1,1,1,1,'short_text',1,'contacts',27),('',0,259,258,8,1,1,1,1,'short_text',1,'contacts',28),('',0,261,260,9,1,1,1,1,'short_text',1,'contacts',29),('',0,263,262,10,1,1,1,1,'long_text',1,'contacts',30),('',0,265,264,11,1,1,1,1,'long_text',1,'contacts',31),('',1,281,280,0,1,1,1,1,'short_trans',1,'products',32),('',0,283,282,1,1,1,1,1,'random',1,'products',33),('',0,285,284,2,1,1,1,1,'float',1,'products',34),('',0,287,286,3,1,1,0,0,'integer',1,'products',35),('',0,289,288,4,0,0,0,0,'integer',0,'products',36),('No|Yes',0,291,290,5,0,0,1,0,'list',0,'products',37),('10%|20%|30%',0,293,292,6,0,0,1,0,'list',0,'products',38),('',0,295,294,7,1,1,0,1,'picture',1,'products',39),('',0,297,296,8,0,0,1,0,'float',0,'products',40),('',0,299,298,9,1,1,1,1,'long_trans',1,'products',41);
/*!40000 ALTER TABLE `cms_catalogue_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_catalogues`
--

DROP TABLE IF EXISTS `cms_catalogues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_catalogues` (
  `c_add_date` int(10) unsigned NOT NULL,
  `c_description` int(10) unsigned NOT NULL,
  `c_display_type` tinyint(4) NOT NULL,
  `c_ecommerce` tinyint(1) NOT NULL,
  `c_is_tree` tinyint(1) NOT NULL,
  `c_name` varchar(80) NOT NULL,
  `c_notes` longtext NOT NULL,
  `c_send_view_reports` varchar(80) NOT NULL,
  `c_submit_points` int(11) NOT NULL,
  `c_title` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`c_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_catalogues`
--

LOCK TABLES `cms_catalogues` WRITE;
/*!40000 ALTER TABLE `cms_catalogues` DISABLE KEYS */;
INSERT INTO `cms_catalogues` VALUES (1264606826,221,2,0,1,'links','','never',0,220),(1264606826,241,0,0,0,'contacts','','never',30,240),(1264606826,277,1,1,1,'products','','never',0,276);
/*!40000 ALTER TABLE `cms_catalogues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chargelog`
--

DROP TABLE IF EXISTS `cms_chargelog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chargelog` (
  `amount` int(11) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `reason` int(10) unsigned NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chargelog`
--

LOCK TABLES `cms_chargelog` WRITE;
/*!40000 ALTER TABLE `cms_chargelog` DISABLE KEYS */;
INSERT INTO `cms_chargelog` VALUES (6,1264685916,1,785,2);
/*!40000 ALTER TABLE `cms_chargelog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_active`
--

DROP TABLE IF EXISTS `cms_chat_active`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_active` (
  `date_and_time` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `member_id` int(11) NOT NULL,
  `room_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `active_ordering` (`date_and_time`),
  KEY `member_select` (`member_id`),
  KEY `room_select` (`room_id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_active`
--

LOCK TABLES `cms_chat_active` WRITE;
/*!40000 ALTER TABLE `cms_chat_active` DISABLE KEYS */;
INSERT INTO `cms_chat_active` VALUES (1264686116,12,2,NULL);
/*!40000 ALTER TABLE `cms_chat_active` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_blocking`
--

DROP TABLE IF EXISTS `cms_chat_blocking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_blocking` (
  `date_and_time` int(10) unsigned NOT NULL,
  `member_blocked` int(11) NOT NULL,
  `member_blocker` int(11) NOT NULL,
  PRIMARY KEY  (`member_blocked`,`member_blocker`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_blocking`
--

LOCK TABLES `cms_chat_blocking` WRITE;
/*!40000 ALTER TABLE `cms_chat_blocking` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_chat_blocking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_buddies`
--

DROP TABLE IF EXISTS `cms_chat_buddies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_buddies` (
  `date_and_time` int(10) unsigned NOT NULL,
  `member_liked` int(11) NOT NULL,
  `member_likes` int(11) NOT NULL,
  PRIMARY KEY  (`member_liked`,`member_likes`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_buddies`
--

LOCK TABLES `cms_chat_buddies` WRITE;
/*!40000 ALTER TABLE `cms_chat_buddies` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_chat_buddies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_events`
--

DROP TABLE IF EXISTS `cms_chat_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_events` (
  `e_date_and_time` int(10) unsigned NOT NULL,
  `e_member_id` int(11) NOT NULL,
  `e_room_id` int(11) default NULL,
  `e_type_code` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `event_ordering` (`e_date_and_time`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_events`
--

LOCK TABLES `cms_chat_events` WRITE;
/*!40000 ALTER TABLE `cms_chat_events` DISABLE KEYS */;
INSERT INTO `cms_chat_events` VALUES (1264686000,2,NULL,'BECOME_ACTIVE',1);
/*!40000 ALTER TABLE `cms_chat_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_messages`
--

DROP TABLE IF EXISTS `cms_chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_messages` (
  `date_and_time` int(10) unsigned NOT NULL,
  `font_name` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip_address` varchar(40) NOT NULL,
  `room_id` int(11) NOT NULL,
  `system_message` tinyint(1) NOT NULL,
  `text_colour` varchar(255) NOT NULL,
  `the_message` int(10) unsigned NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `Ordering` (`date_and_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_messages`
--

LOCK TABLES `cms_chat_messages` WRITE;
/*!40000 ALTER TABLE `cms_chat_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_rooms`
--

DROP TABLE IF EXISTS `cms_chat_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_rooms` (
  `allow_list` longtext NOT NULL,
  `allow_list_groups` longtext NOT NULL,
  `c_welcome` int(10) unsigned NOT NULL,
  `disallow_list` longtext NOT NULL,
  `disallow_list_groups` longtext NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `is_im` tinyint(1) NOT NULL,
  `room_language` varchar(5) NOT NULL,
  `room_name` varchar(255) NOT NULL,
  `room_owner` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_rooms`
--

LOCK TABLES `cms_chat_rooms` WRITE;
/*!40000 ALTER TABLE `cms_chat_rooms` DISABLE KEYS */;
INSERT INTO `cms_chat_rooms` VALUES ('','',312,'','',1,0,'EN','General chat',NULL);
/*!40000 ALTER TABLE `cms_chat_rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_chat_sound_effects`
--

DROP TABLE IF EXISTS `cms_chat_sound_effects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_chat_sound_effects` (
  `s_effect_id` varchar(80) NOT NULL,
  `s_member` int(11) NOT NULL,
  `s_url` varchar(255) NOT NULL,
  PRIMARY KEY  (`s_effect_id`,`s_member`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_chat_sound_effects`
--

LOCK TABLES `cms_chat_sound_effects` WRITE;
/*!40000 ALTER TABLE `cms_chat_sound_effects` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_chat_sound_effects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_comcode_pages`
--

DROP TABLE IF EXISTS `cms_comcode_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_comcode_pages` (
  `p_add_date` int(10) unsigned NOT NULL,
  `p_edit_date` int(10) unsigned default NULL,
  `p_parent_page` varchar(80) NOT NULL,
  `p_show_as_edit` tinyint(1) NOT NULL,
  `p_submitter` int(11) NOT NULL,
  `p_validated` tinyint(1) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_zone` varchar(80) NOT NULL,
  PRIMARY KEY  (`the_page`,`the_zone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_comcode_pages`
--

LOCK TABLES `cms_comcode_pages` WRITE;
/*!40000 ALTER TABLE `cms_comcode_pages` DISABLE KEYS */;
INSERT INTO `cms_comcode_pages` VALUES (1264606251,1332782763,'',0,2,1,'panel_top',''),(1264606251,1264607445,'',0,2,1,'panel_left',''),(1264606251,1265397664,'',0,2,1,'start',''),(1264606209,NULL,'',0,2,1,'start','adminzone'),(1264606209,NULL,'',0,2,1,'panel_top','adminzone'),(1264607445,NULL,'',0,2,1,'panel_right',''),(1264606215,NULL,'',0,2,1,'panel_top','cms'),(1264606256,NULL,'',0,2,1,'help','site'),(1264607445,NULL,'',0,2,1,'rules',''),(1264606256,NULL,'',0,2,1,'guestbook','site'),(1264606251,NULL,'',0,2,1,'404',''),(1264606256,NULL,'',0,2,1,'donate','site'),(1264608734,1264670326,'',0,2,1,'banner','site'),(1264606251,NULL,'',0,2,1,'sitemap',''),(1264606209,NULL,'',0,2,1,'quotes','adminzone'),(1264671563,1265477476,'',0,2,1,'featured_content','site'),(1264685778,NULL,'',0,2,1,'comcode_page','site'),(1264685832,1264685833,'comcode_page',0,2,1,'comcode_page_child','site'),(1264687209,1265480673,'',0,2,1,'rich',''),(1264606256,NULL,'',0,2,1,'panel_left','site'),(1264606256,NULL,'',0,2,1,'panel_right','site'),(1264606256,NULL,'',0,2,1,'start','site'),(1265479394,1265480314,'',0,2,1,'menus','');
/*!40000 ALTER TABLE `cms_comcode_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_config`
--

DROP TABLE IF EXISTS `cms_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_config` (
  `config_value` longtext NOT NULL,
  `c_data` varchar(255) NOT NULL,
  `c_set` tinyint(1) NOT NULL,
  `eval` varchar(255) NOT NULL,
  `explanation` varchar(80) NOT NULL,
  `human_name` varchar(80) NOT NULL,
  `section` varchar(80) NOT NULL,
  `shared_hosting_restricted` tinyint(1) NOT NULL,
  `the_name` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_config`
--

LOCK TABLES `cms_config` WRITE;
/*!40000 ALTER TABLE `cms_config` DISABLE KEYS */;
INSERT INTO `cms_config` VALUES ('','',0,'require_code(\'encryption\');return is_encryption_available()?\'\':NULL;','CONFIG_OPTION_encryption_key','ENCRYPTION_KEY','ADVANCED',0,'encryption_key','PRIVACY','line'),('','',0,'require_code(\'encryption\');return is_encryption_available()?\'\':NULL;','CONFIG_OPTION_decryption_key','DECRYPTION_KEY','ADVANCED',0,'decryption_key','PRIVACY','line'),('0','',1,'return is_null($old=get_value(\'no_post_titles\'))?\'0\':invert_value($old);','CONFIG_OPTION_is_on_post_titles','IS_ON_POST_TITLES','GENERAL',0,'is_on_post_titles','SECTION_FORUMS','tick'),('0','',1,'return is_null($old=get_value(\'ocf_no_anonymous_post\'))?\'0\':invert_value($old);','CONFIG_OPTION_is_on_anonymous_posts','IS_ON_ANONYMOUS_POSTS','GENERAL',0,'is_on_anonymous_posts','SECTION_FORUMS','tick'),('1','',1,'return is_null($old=get_value(\'no_js_timezone_detect\'))?\'1\':invert_value($old);','CONFIG_OPTION_is_on_timezone_detection','IS_ON_TIMEZONE_DETECTION','GENERAL',0,'is_on_timezone_detection','SECTION_FORUMS','tick'),('1','',1,'return is_null($old=get_value(\'no_topic_descriptions\'))?\'1\':invert_value($old);','CONFIG_OPTION_is_on_topic_descriptions','IS_ON_TOPIC_DESCRIPTIONS','GENERAL',0,'is_on_topic_descriptions','SECTION_FORUMS','tick'),('1','',1,'return is_null($old=get_value(\'ocf_no_topic_emoticons\'))?\'1\':invert_value($old);','CONFIG_OPTION_is_on_topic_emoticons','IS_ON_TOPIC_EMOTICONS','GENERAL',0,'is_on_topic_emoticons','SECTION_FORUMS','tick'),('0','',1,'return is_null($old=get_value(\'no_default_preview_guests\'))?\'0\':invert_value($old);','CONFIG_OPTION_default_preview_guests','DEFAULT_PREVIEW_GUESTS','GENERAL',0,'default_preview_guests','SECTION_FORUMS','tick'),('0','',1,'return is_null($old=get_value(\'no_forced_preview_option\'))?\'0\':invert_value($old);','CONFIG_OPTION_forced_preview_option','FORCED_PREVIEW_OPTION','GENERAL',0,'forced_preview_option','SECTION_FORUMS','tick'),('1','',1,'return is_null($old=get_value(\'disable_overt_whispering\'))?\'1\':invert_value($old);','CONFIG_OPTION_overt_whisper_suggestion','OVERT_WHISPER_SUGGESTION','GENERAL',0,'overt_whisper_suggestion','SECTION_FORUMS','tick'),('0','',1,'return is_null($old=get_value(\'no_invisible_option\'))?\'0\':invert_value($old);','CONFIG_OPTION_is_on_invisibility','IS_ON_INVISIBILITY','GENERAL',0,'is_on_invisibility','SECTION_FORUMS','tick'),('0','',1,'return is_null($old=get_value(\'allow_alpha_search\'))?\'0\':$old;','CONFIG_OPTION_allow_alpha_search','ALLOW_ALPHA_SEARCH','GENERAL',0,'allow_alpha_search','SECTION_FORUMS','tick'),('1','',1,'return is_null($old=get_value(\'disable_allow_emails_field\'))?\'1\':invert_value($old);','CONFIG_OPTION_allow_email_disable','ALLOW_EMAIL_DISABLE','GENERAL',0,'allow_email_disable','SECTION_FORUMS','tick'),('20','',1,'return \'20\';','CONFIG_OPTION_max_member_title_length','MAX_MEMBER_TITLE_LENGTH','GENERAL',0,'max_member_title_length','SECTION_FORUMS','integer'),('0','',1,'return \'0\';','CONFIG_OPTION_httpauth_is_enabled','HTTPAUTH_IS_ENABLED','ADVANCED',1,'httpauth_is_enabled','SECTION_FORUMS','tick'),('21','',1,'return \'21\';','CONFIG_OPTION_post_history_days','POST_HISTORY_DAYS','GENERAL',1,'post_history_days','SECTION_FORUMS','integer'),('20','',1,'return has_no_forum()?NULL:\'20\';','CONFIG_OPTION_forum_posts_per_page','FORUM_POSTS_PER_PAGE','GENERAL',0,'forum_posts_per_page','SECTION_FORUMS','integer'),('30','',1,'return has_no_forum()?NULL:\'30\';','CONFIG_OPTION_forum_topics_per_page','FORUM_TOPICS_PER_PAGE','GENERAL',0,'forum_topics_per_page','SECTION_FORUMS','integer'),('1','',1,'return has_no_forum()?NULL:\'1\';','CONFIG_OPTION_prevent_shouting','PREVENT_SHOUTING','GENERAL',0,'prevent_shouting','SECTION_FORUMS','tick'),('Guest, Staff, Administrator, Moderator, googlebot','',1,'return do_lang(\'GUEST\').\', \'.do_lang(\'STAFF\').\', \'.do_lang(\'ADMIN\').\', \'.do_lang(\'MODERATOR\').\', googlebot\';','CONFIG_OPTION_restricted_usernames','RESTRICTED_USERNAMES','GENERAL',0,'restricted_usernames','SECTION_FORUMS','line'),('0','',1,'return \'0\';','CONFIG_OPTION_require_new_member_validation','REQUIRE_NEW_MEMBER_VALIDATION','USERNAMES_AND_PASSWORDS',0,'require_new_member_validation','SECTION_FORUMS','tick'),('Reported posts forum','',1,'return has_no_forum()?NULL:do_lang(\'REPORTED_POSTS_FORUM\');','CONFIG_OPTION_reported_posts_forum','REPORTED_POSTS_FORUM','GENERAL',0,'reported_posts_forum','SECTION_FORUMS','forum'),('1','',1,'return \'1\';','CONFIG_OPTION_one_per_email_address','ONE_PER_EMAIL_ADDRESS','GENERAL',0,'one_per_email_address','SECTION_FORUMS','tick'),('20','',1,'return has_no_forum()?NULL:\'20\';','CONFIG_OPTION_hot_topic_definition','HOT_TOPIC_DEFINITION','GENERAL',0,'hot_topic_definition','SECTION_FORUMS','integer'),('4','',1,'return \'4\';','CONFIG_OPTION_minimum_password_length','MINIMUM_PASSWORD_LENGTH','USERNAMES_AND_PASSWORDS',0,'minimum_password_length','SECTION_FORUMS','integer'),('20','',1,'return \'20\';','CONFIG_OPTION_maximum_password_length','MAXIMUM_PASSWORD_LENGTH','USERNAMES_AND_PASSWORDS',0,'maximum_password_length','SECTION_FORUMS','integer'),('1','',1,'return \'1\';','CONFIG_OPTION_minimum_username_length','MINIMUM_USERNAME_LENGTH','USERNAMES_AND_PASSWORDS',0,'minimum_username_length','SECTION_FORUMS','integer'),('20','',1,'return \'20\';','CONFIG_OPTION_maximum_username_length','MAXIMUM_USERNAME_LENGTH','USERNAMES_AND_PASSWORDS',0,'maximum_username_length','SECTION_FORUMS','integer'),('1','',1,'return \'1\';','CONFIG_OPTION_prohibit_password_whitespace','PROHIBIT_PASSWORD_WHITESPACE','USERNAMES_AND_PASSWORDS',0,'prohibit_password_whitespace','SECTION_FORUMS','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_prohibit_username_whitespace','PROHIBIT_USERNAME_WHITESPACE','USERNAMES_AND_PASSWORDS',0,'prohibit_username_whitespace','SECTION_FORUMS','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_random_avatars','ASSIGN_RANDOM_AVATARS','GENERAL',0,'random_avatars','SECTION_FORUMS','tick'),('Forum home','',1,'return has_no_forum()?NULL:strval(db_get_first_id());','CONFIG_OPTION_club_forum_parent_forum','CLUB_FORUM_PARENT_FORUM','GENERAL',0,'club_forum_parent_forum','SECTION_FORUMS','forum'),('General','',1,'return has_no_forum()?NULL:strval(db_get_first_id());','CONFIG_OPTION_club_forum_parent_category','CLUB_FORUM_PARENT_CATEGORY','GENERAL',0,'club_forum_parent_category','SECTION_FORUMS','category'),('0','',1,'return has_no_forum()?NULL:\'0\';','CONFIG_OPTION_delete_trashed_pts','DELETE_TRASHED_PTS','GENERAL',0,'delete_trashed_pts','SECTION_FORUMS','tick'),('Probation','',1,'return do_lang(\'PROBATION\');','CONFIG_OPTION_probation_usergroup','PROBATION_USERGROUP','USERNAMES_AND_PASSWORDS',0,'probation_usergroup','SECTION_FORUMS','usergroup'),('1','',1,'return \'1\';','CONFIG_OPTION_show_first_join_page','SHOW_FIRST_JOIN_PAGE','USERNAMES_AND_PASSWORDS',0,'show_first_join_page','SECTION_FORUMS','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_skip_email_confirm_join','SKIP_EMAIL_CONFIRM_JOIN','USERNAMES_AND_PASSWORDS',0,'skip_email_confirm_join','SECTION_FORUMS','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_no_dob_ask','NO_DOB_ASK','USERNAMES_AND_PASSWORDS',0,'no_dob_ask','SECTION_FORUMS','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_allow_international','ALLOW_INTERNATIONAL','USERNAMES_AND_PASSWORDS',0,'allow_international','SECTION_FORUMS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_is_on_coppa','COPPA_ENABLED','GENERAL',0,'is_on_coppa','PRIVACY','tick'),('','',0,'return \'\';','CONFIG_OPTION_privacy_fax','FAX_NUMBER','GENERAL',0,'privacy_fax','PRIVACY','line'),('','',0,'return \'\';','CONFIG_OPTION_privacy_postal_address','ADDRESS','GENERAL',0,'privacy_postal_address','PRIVACY','text'),('0','',1,'return \'0\';','CONFIG_OPTION_is_on_invites','INVITES_ENABLED','GENERAL',0,'is_on_invites','SECTION_FORUMS','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_invites_per_day','INVITES_PER_DAY','GENERAL',0,'invites_per_day','SECTION_FORUMS','float'),('','',0,'return \'paypal\';','CONFIG_OPTION_payment_gateway','PAYMENT_GATEWAY','ECOMMERCE',0,'payment_gateway','ECOMMERCE','line'),('','',0,'return 0; /*function_exists(\'apache_get_modules\')?\'1\':\'0\';*/','CONFIG_OPTION_mod_rewrite','MOD_REWRITE','ADVANCED',0,'mod_rewrite','SITE','tick'),('','',0,'return \'5\';','CONFIG_OPTION_session_expiry_time','SESSION_EXPIRY_TIME','GENERAL',0,'session_expiry_time','SECURITY','integer'),('','',0,'return \'1\';','CONFIG_OPTION_url_monikers_enabled','URL_MONIKERS_ENABLED','ADVANCED',0,'url_monikers_enabled','SITE','tick'),('','',0,'return $GLOBALS[\'SEMI_DEBUG_MODE\']?\'0\':\'1\';','CONFIG_OPTION_is_on_block_cache','BLOCK_CACHE','CACHES',1,'is_on_block_cache','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_template_cache','TEMPLATE_CACHE','CACHES',1,'is_on_template_cache','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_comcode_page_cache','COMCODE_PAGE_CACHE','CACHES',1,'is_on_comcode_page_cache','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_lang_cache','LANGUAGE_CACHE','CACHES',1,'is_on_lang_cache','SITE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_is_on_trackbacks','TRACKBACKS','USER_INTERACTION',0,'is_on_trackbacks','FEATURE','tick'),('','',0,'return (DIRECTORY_SEPARATOR==\'/\')?\'/tmp/\':cms_srv(\'TMP\');','CONFIG_OPTION_unzip_dir','UNZIP_DIR','ARCHIVES',1,'unzip_dir','SITE','line'),('','',0,'return \'/usr/bin/unzip -o @_SRC_@ -x -d @_DST_@\';','CONFIG_OPTION_unzip_cmd','UNZIP_CMD','ARCHIVES',1,'unzip_cmd','SITE','line'),('','',0,'return \'0\';','CONFIG_OPTION_smtp_sockets_use','ENABLED','SMTP',1,'smtp_sockets_use','SITE','tick'),('','',0,'return \'mail.yourispwhateveritis.net\';','CONFIG_OPTION_smtp_sockets_host','HOST','SMTP',1,'smtp_sockets_host','SITE','line'),('','',0,'return \'25\';','CONFIG_OPTION_smtp_sockets_port','PORT','SMTP',1,'smtp_sockets_port','SITE','line'),('','',0,'return \'\';','CONFIG_OPTION_smtp_sockets_username','USERNAME','SMTP',1,'smtp_sockets_username','SITE','line'),('','',0,'return \'\';','CONFIG_OPTION_smtp_sockets_password','PASSWORD','SMTP',1,'smtp_sockets_password','SITE','line'),('','',0,'return \'\';','CONFIG_OPTION_smtp_from_address','EMAIL_ADDRESS','SMTP',1,'smtp_from_address','SITE','line'),('','',0,'return \'1\';','CONFIG_OPTION_use_security_images','USE_SECURITY_IMAGES','GENERAL',0,'use_security_images','SECURITY','tick'),('','',0,'return \'0\';','CONFIG_OPTION_enable_https','HTTPS_SUPPORT','GENERAL',1,'enable_https','SECURITY','tick'),('','',0,'return 1;','CONFIG_OPTION_send_error_emails_ocproducts','SEND_ERROR_EMAILS_OCPRODUCTS','ADVANCED',1,'send_error_emails_ocproducts','SITE','tick'),('','',0,'return (get_forum_type()==\'ocf\')?NULL:\'1\';','CONFIG_OPTION_detect_lang_forum','DETECT_LANG_FORUM','ADVANCED',0,'detect_lang_forum','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_detect_lang_browser','DETECT_LANG_BROWSER','ADVANCED',0,'detect_lang_browser','SITE','tick'),('','',0,'return \'20\';','CONFIG_OPTION_low_space_check','LOW_DISK_SPACE_SUBJECT','GENERAL',0,'low_space_check','SITE','integer'),('','',0,'return \'1\';','CONFIG_OPTION_allow_audio_videos','ALLOW_AUDIO_VIDEOS','ADVANCED',0,'allow_audio_videos','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_validation','VALIDATION','VALIDATION',1,'validation','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_validation_xhtml','VALIDATION_XHTML','VALIDATION',1,'validation_xhtml','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_validation_wcag','VALIDATION_WCAG','VALIDATION',1,'validation_wcag','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_validation_css','VALIDATION_CSS','VALIDATION',1,'validation_css','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_validation_javascript','VALIDATION_JAVASCRIPT','VALIDATION',1,'validation_javascript','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_validation_compat','VALIDATION_COMPAT','VALIDATION',1,'validation_compat','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_validation_ext_files','VALIDATION_EXT_FILES','VALIDATION',1,'validation_ext_files','SITE','tick'),('','',0,'return \'20000\';','CONFIG_OPTION_max_download_size','MAX_SIZE','UPLOAD',0,'max_download_size','SITE','integer'),('','',0,'return \'\';','CONFIG_OPTION_allowed_post_submitters','ALLOWED_POST_SUBMITTERS','ADVANCED',1,'allowed_post_submitters','SECURITY','text'),('0','',1,'return \'0\';','CONFIG_OPTION_is_on_strong_forum_tie','STRONG_FORUM_TIE','USER_INTERACTION',1,'is_on_strong_forum_tie','FEATURE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_preview_validation','VALIDATION_ON_PREVIEW','VALIDATION',1,'is_on_preview_validation','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_show_inline_stats','SHOW_INLINE_STATS','GENERAL',0,'show_inline_stats','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_simplified_donext','SIMPLIFIED_DONEXT','ADVANCED',0,'simplified_donext','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_anti_leech','ANTI_LEECH','GENERAL',0,'anti_leech','SECURITY','tick'),('','',0,'return \'0\';','CONFIG_OPTION_ssw','SSW','GENERAL',0,'ssw','SITE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_bottom_show_admin_menu','ADMIN_MENU','BOTTOM_LINKS',0,'bottom_show_admin_menu','FEATURE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_bottom_show_top_button','TOP_LINK','BOTTOM_LINKS',0,'bottom_show_top_button','FEATURE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_bottom_show_feedback_link','FEEDBACK_LINK','BOTTOM_LINKS',0,'bottom_show_feedback_link','FEATURE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_bottom_show_privacy_link','PRIVACY_LINK','BOTTOM_LINKS',0,'bottom_show_privacy_link','FEATURE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_bottom_show_sitemap_button','SITEMAP_LINK','BOTTOM_LINKS',0,'bottom_show_sitemap_button','FEATURE','tick'),('','',0,'return has_no_forum()?NULL:\'0\';','CONFIG_OPTION_forum_show_personal_stats_posts','COUNT_POSTSCOUNT','PERSONAL_BLOCK',0,'forum_show_personal_stats_posts','BLOCKS','tick'),('','',0,'return ((has_no_forum()) || (get_forum_type()!=\'ocf\'))?NULL:\'0\';','CONFIG_OPTION_forum_show_personal_stats_topics','COUNT_TOPICSCOUNT','PERSONAL_BLOCK',0,'forum_show_personal_stats_topics','BLOCKS','tick'),('','',0,'return \'\';','CONFIG_OPTION_transcoding_zencoder_ftp_path','TRANSCODING_ZENCODER_FTP_PATH','TRANSCODING',0,'transcoding_zencoder_ftp_path','FEATURE','line'),('','',0,'return \'1\';','CONFIG_OPTION_cms_show_personal_adminzone_link','ADMIN_ZONE_LINK','PERSONAL_BLOCK',0,'cms_show_personal_adminzone_link','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_cms_show_conceded_mode_link','CONCEDED_MODE_LINK','PERSONAL_BLOCK',0,'cms_show_conceded_mode_link','BLOCKS','tick'),('','',0,'return has_no_forum()?NULL:\'1\';','CONFIG_OPTION_cms_show_su','SU','PERSONAL_BLOCK',0,'cms_show_su','BLOCKS','tick'),('','',0,'return \'1\';','CONFIG_OPTION_cms_show_staff_page_actions','PAGE_ACTIONS','PERSONAL_BLOCK',0,'cms_show_staff_page_actions','BLOCKS','tick'),('','',0,'return has_no_forum()?NULL:\'1\';','CONFIG_OPTION_ocf_show_profile_link','MY_PROFILE_LINK','PERSONAL_BLOCK',0,'ocf_show_profile_link','BLOCKS','tick'),('','',0,'return has_no_forum()?NULL:\'0\';','CONFIG_OPTION_cms_show_personal_usergroup','_USERGROUP','PERSONAL_BLOCK',0,'cms_show_personal_usergroup','BLOCKS','tick'),('','',0,'return has_no_forum()?NULL:\'0\';','CONFIG_OPTION_cms_show_personal_last_visit','LAST_HERE','PERSONAL_BLOCK',0,'cms_show_personal_last_visit','BLOCKS','tick'),('','',0,'return has_no_forum()?NULL:\'0\';','CONFIG_OPTION_cms_show_avatar','AVATAR','PERSONAL_BLOCK',0,'cms_show_avatar','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_root_zone_login_theme','ROOT_ZONE_LOGIN_THEME','GENERAL',0,'root_zone_login_theme','THEME','tick'),('','',0,'return \'1\';','CONFIG_OPTION_show_docs','SHOW_DOCS','ADVANCED',0,'show_docs','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_captcha_noise','CAPTCHA_NOISE','ADVANCED',0,'captcha_noise','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_captcha_on_feedback','CAPTCHA_ON_FEEDBACK','ADVANCED',0,'captcha_on_feedback','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_show_post_validation','SHOW_POST_VALIDATION','ADVANCED',0,'show_post_validation','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_ip_forwarding','IP_FORWARDING','ENVIRONMENT',0,'ip_forwarding','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_force_meta_refresh','FORCE_META_REFRESH','ENVIRONMENT',0,'force_meta_refresh','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_use_contextual_dates','USE_CONTEXTUAL_DATES','ADVANCED',0,'use_contextual_dates','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_eager_wysiwyg','EAGER_WYSIWYG','ADVANCED',0,'eager_wysiwyg','SITE','tick'),('','',0,'$staff_address=get_option(\'staff_address\'); $website_email=\'website@\'.get_domain(); if (substr($staff_address,-strlen(get_domain())-1)==\'@\'.get_domain()) $website_email=$staff_address; return $website_email;','CONFIG_OPTION_website_email','WEBSITE_EMAIL','EMAIL',0,'website_email','SITE','line'),('','',0,'return \'0\';','CONFIG_OPTION_enveloper_override','ENVELOPER_OVERRIDE','EMAIL',0,'enveloper_override','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_bcc','BCC','EMAIL',0,'bcc','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_allow_ext_images','ALLOW_EXT_IMAGES','EMAIL',0,'allow_ext_images','SITE','tick'),('','',0,'return 0;','CONFIG_OPTION_htm_short_urls','HTM_SHORT_URLS','ADVANCED',0,'htm_short_urls','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_ip_strict_for_sessions','IP_STRICT_FOR_SESSIONS','GENERAL',0,'ip_strict_for_sessions','SECURITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_enable_previews','ENABLE_PREVIEWS','PREVIEW',0,'enable_previews','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_enable_keyword_density_check','ENABLE_KEYWORD_DENSITY_CHECK','PREVIEW',0,'enable_keyword_density_check','SITE','tick'),('','',0,'return function_exists(\'pspell_check\')?\'0\':NULL;','CONFIG_OPTION_enable_spell_check','ENABLE_SPELL_CHECK','PREVIEW',0,'enable_spell_check','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_enable_markup_validation','ENABLE_MARKUP_VALIDATION','PREVIEW',0,'enable_markup_validation','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_filetype_icons','FILETYPE_ICONS','GENERAL',0,'filetype_icons','THEME','tick'),('','',0,'return \'0\';','CONFIG_OPTION_auto_submit_sitemap','AUTO_SUBMIT_SITEMAP','GENERAL',0,'auto_submit_sitemap','SITE','tick'),('','',0,'return is_null($old=get_value(\'no_user_postsize_errors\'))?\'1\':invert_value($old);','CONFIG_OPTION_user_postsize_errors','USER_POSTSIZE_ERRORS','UPLOAD',0,'user_postsize_errors','SITE','tick'),('','',0,'return is_null($old=get_value(\'no_auto_meta\'))?\'1\':invert_value($old);','CONFIG_OPTION_automatic_meta_extraction','AUTOMATIC_META_EXTRACTION','GENERAL',0,'automatic_meta_extraction','SITE','tick'),('','',0,'return is_null($old=get_value(\'no_emoticon_choosers\'))?\'1\':invert_value($old);','CONFIG_OPTION_is_on_emoticon_choosers','IS_ON_EMOTICON_CHOOSERS','GENERAL',0,'is_on_emoticon_choosers','THEME','tick'),('','',0,'return is_null($old=get_value(\'no_admin_menu_assumption\'))?\'1\':invert_value($old);','CONFIG_OPTION_deeper_admin_breadcrumbs','DEEPER_ADMIN_BREADCRUMBS','ADVANCED',0,'deeper_admin_breadcrumbs','SITE','tick'),('','',0,'return is_null($old=get_value(\'has_low_memory_limit\'))?((ini_get(\'memory_limit\')==\'-1\')?\'0\':NULL):$old;','CONFIG_OPTION_has_low_memory_limit','HAS_LOW_MEMORY_LIMIT','ADVANCED',0,'has_low_memory_limit','SITE','tick'),('','',0,'return is_null($old=get_value(\'disable_comcode_page_children\'))?\'1\':invert_value($old);','CONFIG_OPTION_is_on_comcode_page_children','IS_ON_COMCODE_PAGE_CHILDREN','ADVANCED',0,'is_on_comcode_page_children','SITE','tick'),('','',0,'return is_null($old=get_value(\'disable_donext_global\'))?\'1\':invert_value($old);','CONFIG_OPTION_global_donext_icons','GLOBAL_DONEXT_ICONS','ADVANCED',0,'global_donext_icons','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_no_stats_when_closed','NO_STATS_WHEN_CLOSED','CLOSED_SITE',0,'no_stats_when_closed','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_no_bot_stats','NO_BOT_STATS','GENERAL',0,'no_bot_stats','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_java_upload','ENABLE_JAVA_UPLOAD','JAVA_UPLOAD',0,'java_upload','SITE','tick'),('','',0,'return cms_srv(\'HTTP_HOST\');','CONFIG_OPTION_java_ftp_host','JAVA_FTP_HOST','JAVA_UPLOAD',0,'java_ftp_host','SITE','line'),('','',0,'return \'anonymous\';','CONFIG_OPTION_java_username','JAVA_FTP_USERNAME','JAVA_UPLOAD',0,'java_username','SITE','line'),('','',0,'return \'someone@example.com\';','CONFIG_OPTION_java_password','JAVA_FTP_PASSWORD','JAVA_UPLOAD',0,'java_password','SITE','line'),('','',0,'return \'/public_html/uploads/incoming/\';','CONFIG_OPTION_java_ftp_path','JAVA_FTP_PATH','JAVA_UPLOAD',0,'java_ftp_path','SITE','line'),('Composr demo','',1,'return do_lang(\'UNNAMED\');','CONFIG_OPTION_site_name','SITE_NAME','GENERAL',0,'site_name','SITE','line'),('467','',1,'return \'???\';','CONFIG_OPTION_site_scope','SITE_SCOPE','GENERAL',0,'site_scope','SITE','transline'),('466','',1,'return \'???\';','CONFIG_OPTION_description','DESCRIPTION','GENERAL',0,'description','SITE','transline'),('468','',1,'return \'Copyright &copy; \'.get_site_name().\' \'.date(\'Y\').\'\';','CONFIG_OPTION_copyright','COPYRIGHT','GENERAL',0,'copyright','SITE','transline'),('','',0,'return \'\';','CONFIG_OPTION_welcome_message','WELCOME_MESSAGE','GENERAL',0,'welcome_message','SITE','transtext'),('General chat','',1,'return has_no_forum()?NULL:do_lang(\'DEFAULT_FORUM_TITLE\',\'\',\'\',\'\',get_lang());','CONFIG_OPTION_main_forum_name','MAIN_FORUM_NAME','USER_INTERACTION',0,'main_forum_name','FEATURE','forum'),('default, defaultness, celebration, community','',1,'return \'\';','CONFIG_OPTION_keywords','KEYWORDS','GENERAL',0,'keywords','SITE','line'),('','',0,'return \'\';','CONFIG_OPTION_transcoding_zencoder_api_key','TRANSCODING_ZENCODER_API_KEY','TRANSCODING',0,'transcoding_zencoder_api_key','FEATURE','line'),('','',0,'return \'480\';','CONFIG_OPTION_video_height_setting','VIDEO_HEIGHT_SETTING','TRANSCODING',0,'video_height_setting','FEATURE','integer'),('','',0,'return \'720\';','CONFIG_OPTION_video_width_setting','VIDEO_WIDTH_SETTING','TRANSCODING',0,'video_width_setting','FEATURE','integer'),('','',0,'return \'192\';','CONFIG_OPTION_audio_bitrate','AUDIO_BITRATE','TRANSCODING',0,'audio_bitrate','FEATURE','integer'),('','',0,'return \'1000\';','CONFIG_OPTION_video_bitrate','VIDEO_BITRATE','TRANSCODING',0,'video_bitrate','FEATURE','integer'),('','',0,'return \'0\';','CONFIG_OPTION_gzip_output','GZIP_OUTPUT','ADVANCED',1,'gzip_output','SITE','tick'),('','',0,'return has_no_forum()?NULL:\'0\';','CONFIG_OPTION_forum_in_portal','FORUM_IN_PORTAL','ENVIRONMENT',1,'forum_in_portal','SITE','tick'),('','',1,'return \'staff@\'.get_domain();','CONFIG_OPTION_staff_address','EMAIL','EMAIL',0,'staff_address','SITE','line'),('','',0,'return function_exists(\'imagetypes\')?\'1\':\'0\';','CONFIG_OPTION_is_on_gd','GD','ENVIRONMENT',1,'is_on_gd','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_folder_create','FOLDER_CREATE','ENVIRONMENT',1,'is_on_folder_create','SITE','tick'),('1','',1,'return \'1\';','CONFIG_OPTION_site_closed','CLOSED_SITE','CLOSED_SITE',0,'site_closed','SITE','tick'),('469','',1,'return do_lang(\'BEING_INSTALLED\');','CONFIG_OPTION_closed','MESSAGE','CLOSED_SITE',0,'closed','SITE','transtext'),('','',0,'return \'100\';','CONFIG_OPTION_maximum_users','MAXIMUM_USERS','CLOSED_SITE',1,'maximum_users','SITE','integer'),('','',0,'return \'\';','CONFIG_OPTION_cc_address','CC_ADDRESS','EMAIL',0,'cc_address','SITE','line'),('','',0,'return \'1\';','CONFIG_OPTION_log_php_errors','LOG_PHP_ERRORS','LOGGING',0,'log_php_errors','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_display_php_errors','DISPLAY_PHP_ERRORS','LOGGING',0,'display_php_errors','SITE','tick'),('','',0,'return \'swf,sql,odg,odp,odt,ods,ps,pdf,doc,ppt,csv,xls,docx,pptx,xlsx,pub,txt,psd,tga,tif,gif,png,bmp,jpg,jpeg,flv,avi,mov,mpg,mpeg,mp4,asf,wmv,ram,ra,rm,qt,mov,zip,tar,rar,gz,wav,mp3,ogg,torrent,php,css,tpl,ini,eml\';','CONFIG_OPTION_valid_types','FILE_TYPES','UPLOADED_FILES',0,'valid_types','SECURITY','line'),('','',0,'return \'jpg,jpeg,gif,png\';','CONFIG_OPTION_valid_images','IMAGE_TYPES','UPLOADED_FILES',0,'valid_images','SECURITY','line'),('1','',1,'return \'1\';','CONFIG_OPTION_is_on_rating','RATING','USER_INTERACTION',0,'is_on_rating','FEATURE','tick'),('1','',1,'return has_no_forum()?NULL:\'1\';','CONFIG_OPTION_is_on_comments','COMMENTS','USER_INTERACTION',0,'is_on_comments','FEATURE','tick'),('Website comment topics','',1,'return has_no_forum()?NULL:do_lang(\'COMMENT_FORUM_NAME\',\'\',\'\',\'\',get_lang());','CONFIG_OPTION_comments_forum_name','COMMENTS_FORUM_NAME','USER_INTERACTION',0,'comments_forum_name','FEATURE','forum'),('507','',1,'return has_no_forum()?NULL:do_template(\'COMMENTS_DEFAULT_TEXT\');','CONFIG_OPTION_comment_text','COMMENT_FORM_TEXT','USER_INTERACTION',0,'comment_text','FEATURE','transtext'),('200','',1,'return \'200\';','CONFIG_OPTION_thumb_width','THUMB_WIDTH','IMAGES',0,'thumb_width','FEATURE','integer'),('','',0,'return \'700\';','CONFIG_OPTION_max_image_size','IMAGES','UPLOAD',0,'max_image_size','SITE','integer'),('','',0,'return \'5\';','CONFIG_OPTION_users_online_time','USERS_ONLINE_TIME','LOGGING',0,'users_online_time','SITE','integer'),('','',0,'return \'\';','CONFIG_OPTION_system_flagrant','SYSTEM_FLAGRANT','GENERAL',0,'system_flagrant','SITE','transline'),('','',0,'return \'0\';','CONFIG_OPTION_bottom_show_realtime_rain_button','REALTIME_RAIN_BUTTON','BOTTOM_LINKS',0,'bottom_show_realtime_rain_button','FEATURE','tick'),('Website \"Contact Us\" messages','',1,'return do_lang(\'MESSAGING_FORUM_NAME\',\'\',\'\',\'\',get_lang());','CONFIG_OPTION_messaging_forum_name','_MESSAGING_FORUM_NAME','CONTACT_US_MESSAGING',0,'messaging_forum_name','FEATURE','forum'),('','',0,'return \'0\';','CONFIG_OPTION_occle_chat_announce','OCCLE_CHAT_ANNOUNCE','ADVANCED',0,'occle_chat_announce','SITE','tick'),('0','',1,'return \'1\';','CONFIG_OPTION_bottom_show_occle_button','OCCLE_BUTTON','BOTTOM_LINKS',0,'bottom_show_occle_button','FEATURE','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_ldap_is_enabled','LDAP_IS_ENABLED','LDAP',1,'ldap_is_enabled','SECTION_FORUMS','tick'),('0','',1,'return (DIRECTORY_SEPARATOR==\'/\')?\'0\':\'1\';','CONFIG_OPTION_ldap_is_windows','LDAP_IS_WINDOWS','LDAP',1,'ldap_is_windows','SECTION_FORUMS','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_ldap_allow_joining','LDAP_ALLOW_JOINING','LDAP',1,'ldap_allow_joining','SECTION_FORUMS','tick'),('localhost','',1,'return \'localhost\';','CONFIG_OPTION_ldap_hostname','LDAP_HOSTNAME','LDAP',1,'ldap_hostname','SECTION_FORUMS','line'),('dc=example,dc=com','',1,'return \'dc=example,dc=com\';','CONFIG_OPTION_ldap_base_dn','LDAP_BASE_DN','LDAP',1,'ldap_base_dn','SECTION_FORUMS','line'),('NotManager','',1,'return (DIRECTORY_SEPARATOR==\'/\')?\'NotManager\':\'NotAdministrator\';','CONFIG_OPTION_ldap_bind_rdn','USERNAME','LDAP',1,'ldap_bind_rdn','SECTION_FORUMS','line'),('','',1,'return \'\';','CONFIG_OPTION_ldap_bind_password','PASSWORD','LDAP',1,'ldap_bind_password','SECTION_FORUMS','line'),('0','',1,'return \'0\';','CONFIG_OPTION_windows_auth_is_enabled','WINDOWS_AUTHENTICATION','LDAP',0,'windows_auth_is_enabled','SECTION_FORUMS','tick'),('','',1,'return is_null($old=get_value(\'ldap_login_qualifier\'))?\'\':$old;','CONFIG_OPTION_ldap_login_qualifier','LDAP_LOGIN_QUALIFIER','LDAP',0,'ldap_login_qualifier','SECTION_FORUMS','line'),('ou=Group','',1,'return \'ou=Group\';','CONFIG_OPTION_ldap_group_search_qualifier','LDAP_GROUP_SEARCH_QUALIFIER','LDAP',0,'ldap_group_search_qualifier','SECTION_FORUMS','line'),('cn=Users','',1,'return (get_option(\'ldap_is_windows\')==\'0\')?\'cn=Users\':\'ou=People\';','CONFIG_OPTION_ldap_member_search_qualifier','LDAP_MEMBER_SEARCH_QUALIFIER','LDAP',0,'ldap_member_search_qualifier','SECTION_FORUMS','line'),('uid','',1,'return (get_option(\'ldap_is_windows\')==\'0\')?\'uid\':\'sAMAccountName\';','CONFIG_OPTION_ldap_member_property','LDAP_MEMBER_PROPERTY','LDAP',0,'ldap_member_property','SECTION_FORUMS','line'),('1','',1,'return \'1\';','CONFIG_OPTION_ldap_none_bind_logins','LDAP_NONE_BIND_LOGINS','LDAP',0,'ldap_none_bind_logins','SECTION_FORUMS','tick'),('3','',1,'return \'3\';','CONFIG_OPTION_ldap_version','LDAP_VERSION','LDAP',0,'ldap_version','SECTION_FORUMS','integer'),('posixGroup','',1,'return \'posixGroup\';','CONFIG_OPTION_ldap_group_class','LDAP_GROUP_CLASS','LDAP',0,'ldap_group_class','SECTION_FORUMS','line'),('posixAccount','',1,'return \'posixAccount\';','CONFIG_OPTION_ldap_member_class','LDAP_MEMBER_CLASS','LDAP',0,'ldap_member_class','SECTION_FORUMS','line'),('','',0,'return addon_installed(\'points\')?\'10\':NULL;','CONFIG_OPTION_points_COMCODE_PAGE_ADD','COMCODE_PAGE_ADD','COUNT_POINTS_GIVEN',0,'points_COMCODE_PAGE_ADD','POINTS','integer'),('','',0,'return \'1\';','CONFIG_OPTION_store_revisions','STORE_REVISIONS','COMCODE_PAGE_MANAGEMENT',0,'store_revisions','ADMIN','tick'),('','',0,'return \'5\';','CONFIG_OPTION_number_revisions_show','SHOW_REVISIONS','COMCODE_PAGE_MANAGEMENT',0,'number_revisions_show','ADMIN','integer'),('','',0,'return do_lang(\'POST_STAFF\');','CONFIG_OPTION_staff_text','PAGE_TEXT','STAFF',0,'staff_text','SECURITY','transtext'),('','',0,'return \'0\';','CONFIG_OPTION_is_on_staff_filter','MEMBER_FILTER','STAFF',1,'is_on_staff_filter','SECURITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_sync_staff','SYNCHRONISATION','STAFF',1,'is_on_sync_staff','SECURITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_super_logging','SUPER_LOGGING','LOGGING',1,'super_logging','SITE','tick'),('','',0,'return \'124\';','CONFIG_OPTION_stats_store_time','STORE_TIME','LOGGING',1,'stats_store_time','SITE','integer'),('','',0,'return \'1\';','CONFIG_OPTION_templates_store_revisions','STORE_REVISIONS','EDIT_TEMPLATES',0,'templates_store_revisions','ADMIN','tick'),('','',0,'return \'5\';','CONFIG_OPTION_templates_number_revisions_show','SHOW_REVISIONS','EDIT_TEMPLATES',0,'templates_number_revisions_show','ADMIN','integer'),('','',0,'return \'0\';','CONFIG_OPTION_catalogues_subcat_narrowin','CATALOGUES_SUBCAT_NARROWIN','CATALOGUES',0,'catalogues_subcat_narrowin','FEATURE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_downloads_subcat_narrowin','DOWNLOADS_SUBCAT_NARROWIN','SECTION_DOWNLOADS',0,'downloads_subcat_narrowin','FEATURE','tick'),('','',0,'return addon_installed(\'points\')?\'0\':NULL;','CONFIG_OPTION_points_ADD_BANNER','ADD_BANNER','COUNT_POINTS_GIVEN',0,'points_ADD_BANNER','POINTS','integer'),('0','',1,'return \'0\';','CONFIG_OPTION_use_banner_permissions','PERMISSIONS','BANNERS',0,'use_banner_permissions','FEATURE','tick'),('0','',1,'return is_null($old=get_value(\'banner_autosize\'))?\'0\':$old;','CONFIG_OPTION_banner_autosize','BANNER_AUTOSIZE','BANNERS',0,'banner_autosize','FEATURE','tick'),('1','',1,'return is_null($old=get_value(\'always_banners\'))?\'0\':$old;','CONFIG_OPTION_admin_banners','ADMIN_BANNERS','BANNERS',0,'admin_banners','FEATURE','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_calendar_show_stats_count_events','EVENTS','STATISTICS',0,'calendar_show_stats_count_events','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_calendar_show_stats_count_events_this_week','_EVENTS_THIS_WEEK','STATISTICS',0,'calendar_show_stats_count_events_this_week','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_calendar_show_stats_count_events_this_month','_EVENTS_THIS_MONTH','STATISTICS',0,'calendar_show_stats_count_events_this_month','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_calendar_show_stats_count_events_this_year','_EVENTS_THIS_YEAR','STATISTICS',0,'calendar_show_stats_count_events_this_year','BLOCKS','tick'),('','',0,'return addon_installed(\'points\')?\'10\':NULL;','CONFIG_OPTION_points_cedi','CEDI_MAKE_POST','COUNT_POINTS_GIVEN',0,'points_cedi','POINTS','integer'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_cedi_show_stats_count_pages','CEDI_PAGES','STATISTICS',0,'cedi_show_stats_count_pages','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_cedi_show_stats_count_posts','CEDI_POSTS','STATISTICS',0,'cedi_show_stats_count_posts','BLOCKS','tick'),('5','',1,'return \'5\';','CONFIG_OPTION_chat_flood_timelimit','FLOOD_TIMELIMIT','SECTION_CHAT',0,'chat_flood_timelimit','FEATURE','integer'),('#000000','',1,'return \'#000000\';','CONFIG_OPTION_chat_default_post_colour','CHAT_OPTIONS_COLOUR_NAME','SECTION_CHAT',0,'chat_default_post_colour','FEATURE','line'),('Verdana','',1,'return \'Verdana\';','CONFIG_OPTION_chat_default_post_font','CHAT_OPTIONS_TEXT_NAME','SECTION_CHAT',0,'chat_default_post_font','FEATURE','line'),('1440','',1,'return \'1440\';','CONFIG_OPTION_chat_private_room_deletion_time','PRIVATE_ROOM_DELETION_TIME','SECTION_CHAT',0,'chat_private_room_deletion_time','FEATURE','integer'),('0','',1,'return \'0\';','CONFIG_OPTION_username_click_im','USERNAME_CLICK_IM','SECTION_CHAT',0,'username_click_im','FEATURE','tick'),('','',0,'return addon_installed(\'points\')?\'1\':NULL;','CONFIG_OPTION_points_chat','CHATTING','COUNT_POINTS_GIVEN',0,'points_chat','POINTS','integer'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_chat_show_stats_count_users','COUNT_CHATTERS','STATISTICS',0,'chat_show_stats_count_users','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_chat_show_stats_count_rooms','ROOMS','STATISTICS',0,'chat_show_stats_count_rooms','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_chat_show_stats_count_messages','COUNT_CHATPOSTS','STATISTICS',0,'chat_show_stats_count_messages','BLOCKS','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_sitewide_im','SITEWIDE_IM','SECTION_CHAT',0,'sitewide_im','FEATURE','tick'),('1','',1,'return is_null($old=get_value(\'no_group_private_chatrooms\'))?\'1\':invert_value($old);','CONFIG_OPTION_group_private_chatrooms','GROUP_PRIVATE_CHATROOMS','SECTION_CHAT',0,'group_private_chatrooms','FEATURE','tick'),('','',0,'return \'15\';','CONFIG_OPTION_maximum_download','MAXIMUM_DOWNLOAD','CLOSED_SITE',0,'maximum_download','SITE','integer'),('0','',1,'return \'0\';','CONFIG_OPTION_show_dload_trees','SHOW_DLOAD_TREES','SECTION_DOWNLOADS',1,'show_dload_trees','FEATURE','tick'),('','',0,'return addon_installed(\'points\')?\'150\':NULL;','CONFIG_OPTION_points_ADD_DOWNLOAD','ADD_DOWNLOAD','COUNT_POINTS_GIVEN',0,'points_ADD_DOWNLOAD','POINTS','integer'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_downloads_show_stats_count_total','_SECTION_DOWNLOADS','STATISTICS',0,'downloads_show_stats_count_total','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_downloads_show_stats_count_archive','TOTAL_DOWNLOADS_IN_ARCHIVE','STATISTICS',0,'downloads_show_stats_count_archive','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_downloads_show_stats_count_downloads','_COUNT_DOWNLOADS','STATISTICS',0,'downloads_show_stats_count_downloads','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_downloads_show_stats_count_bandwidth','_COUNT_BANDWIDTH','STATISTICS',0,'downloads_show_stats_count_bandwidth','BLOCKS','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_immediate_downloads','IMMEDIATE_DOWNLOADS','SECTION_DOWNLOADS',0,'immediate_downloads','FEATURE','tick'),('root','',1,'return is_null($old=get_value(\'download_gallery_root\'))?(addon_installed(\'galleries\')?\'root\':NULL):$old;','CONFIG_OPTION_download_gallery_root','DOWNLOAD_GALLERY_ROOT','SECTION_DOWNLOADS',0,'download_gallery_root','FEATURE','line'),('','',0,'return addon_installed(\'points\')?\'100\':NULL;','CONFIG_OPTION_points_ADD_IMAGE','ADD_IMAGE','COUNT_POINTS_GIVEN',0,'points_ADD_IMAGE','POINTS','integer'),('320','',1,'return \'320\';','CONFIG_OPTION_default_video_width','DEFAULT_VIDEO_WIDTH','GALLERIES',0,'default_video_width','FEATURE','integer'),('240','',1,'return \'240\';','CONFIG_OPTION_default_video_height','DEFAULT_VIDEO_HEIGHT','GALLERIES',0,'default_video_height','FEATURE','integer'),('1024','',1,'return \'1024\';','CONFIG_OPTION_maximum_image_size','MAXIMUM_IMAGE_SIZE','GALLERIES',0,'maximum_image_size','FEATURE','integer'),('5','',1,'return \'5\';','CONFIG_OPTION_max_personal_gallery_images_low','GALLERY_IMAGE_LIMIT_LOW','GALLERIES',0,'max_personal_gallery_images_low','FEATURE','integer'),('10','',1,'return \'10\';','CONFIG_OPTION_max_personal_gallery_images_high','GALLERY_IMAGE_LIMIT_HIGH','GALLERIES',0,'max_personal_gallery_images_high','FEATURE','integer'),('2','',1,'return \'2\';','CONFIG_OPTION_max_personal_gallery_videos_low','GALLERY_VIDEO_LIMIT_LOW','GALLERIES',0,'max_personal_gallery_videos_low','FEATURE','integer'),('5','',1,'return \'5\';','CONFIG_OPTION_max_personal_gallery_videos_high','GALLERY_VIDEO_LIMIT_HIGH','GALLERIES',0,'max_personal_gallery_videos_high','FEATURE','integer'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_galleries_show_stats_count_galleries','GALLERIES','STATISTICS',0,'galleries_show_stats_count_galleries','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_galleries_show_stats_count_images','IMAGES','STATISTICS',0,'galleries_show_stats_count_images','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_galleries_show_stats_count_videos','VIDEOS','STATISTICS',0,'galleries_show_stats_count_videos','BLOCKS','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_show_empty_galleries','SHOW_EMPTY_GALLERIES','GALLERIES',0,'show_empty_galleries','FEATURE','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_gallery_name_order','GALLERY_NAME_ORDER','GALLERIES',0,'gallery_name_order','FEATURE','tick'),('6,9,18,36','',1,'return is_null($old=get_value(\'gallery_selectors\'))?\'6,9,18,36\':$old;','CONFIG_OPTION_gallery_selectors','GALLERY_SELECTORS','GALLERIES',0,'gallery_selectors','FEATURE','line'),('0','',1,'return is_null($old=get_value(\'reverse_thumb_order\'))?\'0\':$old;','CONFIG_OPTION_reverse_thumb_order','REVERSE_THUMB_ORDER','GALLERIES',0,'reverse_thumb_order','FEATURE','tick'),('0','',1,'return is_null($old=get_value(\'show_gallery_counts\'))?((get_forum_type()==\'ocf\')?\'0\':NULL):$old;','CONFIG_OPTION_show_gallery_counts','SHOW_GALLERY_COUNTS','GALLERIES',0,'show_gallery_counts','FEATURE','tick'),('','',0,'return addon_installed(\'points\')?\'35\':NULL;','CONFIG_OPTION_points_CHOOSE_IOTD','CHOOSE_IOTD','COUNT_POINTS_GIVEN',0,'points_CHOOSE_IOTD','POINTS','integer'),('','',0,'return addon_installed(\'points\')?\'150\':NULL;','CONFIG_OPTION_points_ADD_IOTD','ADD_IOTD','COUNT_POINTS_GIVEN',0,'points_ADD_IOTD','POINTS','integer'),('','',0,'return \'24\';','CONFIG_OPTION_iotd_update_time','IOTD_REGULARITY','CHECK_LIST',0,'iotd_update_time','ADMIN','integer'),('','',0,'return addon_installed(\'points\')?\'225\':NULL;','CONFIG_OPTION_points_ADD_NEWS','ADD_NEWS','COUNT_POINTS_GIVEN',0,'points_ADD_NEWS','POINTS','integer'),('','',0,'return \'168\';','CONFIG_OPTION_news_update_time','NEWS_REGULARITY','CHECK_LIST',0,'news_update_time','ADMIN','integer'),('','',0,'return \'168\';','CONFIG_OPTION_blog_update_time','BLOG_REGULARITY','CHECK_LIST',0,'blog_update_time','ADMIN','integer'),('http://pingomatic.com/ping/?title={title}&blogurl={url}&rssurl={rss}','',1,'return \'http://pingomatic.com/ping/?title={title}&blogurl={url}&rssurl={rss}\';','CONFIG_OPTION_ping_url','PING_URL','NEWS_AND_RSS',0,'ping_url','FEATURE','text'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_news_show_stats_count_total_posts','TOTAL_NEWS_ENTRIES','STATISTICS',0,'news_show_stats_count_total_posts','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_news_show_stats_count_blogs','BLOGS','STATISTICS',0,'news_show_stats_count_blogs','BLOCKS','tick'),('508','',1,'return \'\';','CONFIG_OPTION_newsletter_text','PAGE_TEXT','NEWSLETTER',0,'newsletter_text','FEATURE','transtext'),('(unnamed) Newsletter','',1,'return get_option(\'site_name\').\' \'.do_lang(\'NEWSLETTER\');','CONFIG_OPTION_newsletter_title','TITLE','NEWSLETTER',0,'newsletter_title','FEATURE','line'),('0','',1,'return \'0\';','CONFIG_OPTION_interest_levels','USE_INTEREST_LEVELS','NEWSLETTER',0,'interest_levels','FEATURE','tick'),('','',0,'return \'40\';','CONFIG_OPTION_points_joining','JOINING','COUNT_POINTS_GIVEN',0,'points_joining','POINTS','integer'),('','',0,'return \'5\';','CONFIG_OPTION_points_posting','MAKE_POST','COUNT_POINTS_GIVEN',0,'points_posting','POINTS','integer'),('','',0,'return \'5\';','CONFIG_OPTION_points_rating','RATING','COUNT_POINTS_GIVEN',0,'points_rating','POINTS','integer'),('','',0,'return \'5\';','CONFIG_OPTION_points_voting','VOTING','COUNT_POINTS_GIVEN',0,'points_voting','POINTS','integer'),('','',0,'return \'5\';','CONFIG_OPTION_points_if_liked','POINTS_IF_LIKED','COUNT_POINTS_GIVEN',0,'points_if_liked','POINTS','integer'),('','',0,'return \'0\';','CONFIG_OPTION_points_show_personal_stats_points_left','COUNT_POINTS_LEFT','PERSONAL_BLOCK',0,'points_show_personal_stats_points_left','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_points_show_personal_stats_points_used','COUNT_POINTS_USED','PERSONAL_BLOCK',0,'points_show_personal_stats_points_used','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_points_show_personal_stats_gift_points_left','COUNT_GIFT_POINTS_LEFT','PERSONAL_BLOCK',0,'points_show_personal_stats_gift_points_left','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_points_show_personal_stats_gift_points_used','COUNT_GIFT_POINTS_USED','PERSONAL_BLOCK',0,'points_show_personal_stats_gift_points_used','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_points_show_personal_stats_total_points','COUNT_POINTS_EVER','PERSONAL_BLOCK',0,'points_show_personal_stats_total_points','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_points_per_day','POINTS_PER_DAY','COUNT_POINTS_GIVEN',0,'points_per_day','POINTS','integer'),('','',0,'return \'0\';','CONFIG_OPTION_points_per_daily_visit','POINTS_PER_DAILY_VISIT','COUNT_POINTS_GIVEN',0,'points_per_daily_visit','POINTS','integer'),('','',0,'return (get_forum_type()!=\'ocf\')?false:\'1\';','CONFIG_OPTION_is_on_highlight_name_buy','ENABLE_PURCHASE','NAME_HIGHLIGHTING',0,'is_on_highlight_name_buy','POINTSTORE','tick'),('','',0,'return (get_forum_type()!=\'ocf\')?false:\'2000\';','CONFIG_OPTION_highlight_name','COST_highlight_name','NAME_HIGHLIGHTING',0,'highlight_name','POINTSTORE','integer'),('','',0,'return (!addon_installed(\'ocf_forum\'))?false:\'1\';','CONFIG_OPTION_is_on_topic_pin_buy','ENABLE_PURCHASE','TOPIC_PINNING',0,'is_on_topic_pin_buy','POINTSTORE','tick'),('','',0,'return (!addon_installed(\'ocf_forum\'))?false:\'180\';','CONFIG_OPTION_topic_pin','COST_topic_pin','TOPIC_PINNING',0,'topic_pin','POINTSTORE','integer'),('','',0,'return \'1\';','CONFIG_OPTION_is_on_gambling_buy','ENABLE_PURCHASE','GAMBLING',0,'is_on_gambling_buy','POINTSTORE','tick'),('','',0,'return \'6\';','CONFIG_OPTION_minimum_gamble_amount','MINIMUM_GAMBLE_AMOUNT','GAMBLING',0,'minimum_gamble_amount','POINTSTORE','integer'),('','',0,'return \'200\';','CONFIG_OPTION_maximum_gamble_amount','MAXIMUM_GAMBLE_AMOUNT','GAMBLING',0,'maximum_gamble_amount','POINTSTORE','integer'),('','',0,'return \'200\';','CONFIG_OPTION_maximum_gamble_multiplier','MAXIMUM_GAMBLE_MULTIPLIER','GAMBLING',0,'maximum_gamble_multiplier','POINTSTORE','integer'),('','',0,'return \'85\';','CONFIG_OPTION_average_gamble_multiplier','AVERAGE_GAMBLE_MULTIPLIER','GAMBLING',0,'average_gamble_multiplier','POINTSTORE','integer'),('','',0,'return (!addon_installed(\'banners\'))?false:\'750\';','CONFIG_OPTION_banner_setup','COST_banner_setup','BANNERS',0,'banner_setup','POINTSTORE','integer'),('','',0,'return (!addon_installed(\'banners\'))?false:\'700\';','CONFIG_OPTION_banner_imp','COST_banner_imp','BANNERS',0,'banner_imp','POINTSTORE','integer'),('','',0,'return (!addon_installed(\'banners\'))?false:\'20\';','CONFIG_OPTION_banner_hit','COST_banner_hit','BANNERS',0,'banner_hit','POINTSTORE','integer'),('','',0,'return \'2\';','CONFIG_OPTION_quota','COST_quota','POP3',0,'quota','POINTSTORE','integer'),('','',0,'return (!addon_installed(\'flagrant\'))?false:\'700\';','CONFIG_OPTION_text','COST_text','FLAGRANT_MESSAGE',0,'text','POINTSTORE','integer'),('','',0,'return (!addon_installed(\'banners\'))?false:\'1\';','CONFIG_OPTION_is_on_banner_buy','ENABLE_PURCHASE','BANNERS',0,'is_on_banner_buy','POINTSTORE','tick'),('','',0,'return (!addon_installed(\'banners\'))?false:\'100\';','CONFIG_OPTION_initial_banner_hits','HITS_ALLOCATED','BANNERS',0,'initial_banner_hits','POINTSTORE','integer'),('','',0,'return \'0\';','CONFIG_OPTION_is_on_pop3_buy','ENABLE_PURCHASE','POP3',1,'is_on_pop3_buy','POINTSTORE','tick'),('','',0,'return \'200\';','CONFIG_OPTION_initial_quota','QUOTA','POP3',1,'initial_quota','POINTSTORE','integer'),('','',0,'return \'10000\';','CONFIG_OPTION_max_quota','MAX_QUOTA','POP3',1,'max_quota','POINTSTORE','integer'),('','',0,'return \'mail.\'.get_domain();','CONFIG_OPTION_mail_server','MAIL_SERVER','POP3',1,'mail_server','POINTSTORE','line'),('','',0,'return \'http://\'.get_domain().\':2082/frontend/x/mail/addpop2.html\';','CONFIG_OPTION_pop_url','POP3_MAINTAIN_URL','POP3',1,'pop_url','POINTSTORE','line'),('','',0,'return \'http://\'.get_domain().\':2082/frontend/x/mail/pops.html\';','CONFIG_OPTION_quota_url','QUOTA_MAINTAIN_URL','POP3',1,'quota_url','POINTSTORE','line'),('','',0,'return \'0\';','CONFIG_OPTION_is_on_forw_buy','ENABLE_PURCHASE','FORWARDING',1,'is_on_forw_buy','POINTSTORE','tick'),('','',0,'return \'http://\'.get_domain().\':2082/frontend/x/mail/addfwd.html\';','CONFIG_OPTION_forw_url','FORW_MAINTAIN_URL','FORWARDING',1,'forw_url','POINTSTORE','line'),('','',0,'return (!addon_installed(\'flagrant\'))?false:\'1\';','CONFIG_OPTION_is_on_flagrant_buy','ENABLE_PURCHASE','FLAGRANT_MESSAGE',0,'is_on_flagrant_buy','POINTSTORE','tick'),('','',0,'return addon_installed(\'points\')?\'150\':NULL;','CONFIG_OPTION_points_ADD_POLL','ADD_POLL','COUNT_POINTS_GIVEN',0,'points_ADD_POLL','POINTS','integer'),('','',0,'return addon_installed(\'points\')?\'35\':NULL;','CONFIG_OPTION_points_CHOOSE_POLL','CHOOSE_POLL','COUNT_POINTS_GIVEN',0,'points_CHOOSE_POLL','POINTS','integer'),('','',0,'return \'168\';','CONFIG_OPTION_poll_update_time','POLL_REGULARITY','CHECK_LIST',0,'poll_update_time','ADMIN','integer'),('','',0,'return \'0\';','CONFIG_OPTION_use_local_payment','USE_LOCAL_PAYMENT','ECOMMERCE',0,'use_local_payment','ECOMMERCE','tick'),('','',0,'return \'\';','CONFIG_OPTION_ipn_password','IPN_PASSWORD','ECOMMERCE',0,'ipn_password','ECOMMERCE','line'),('','',0,'return \'\';','CONFIG_OPTION_ipn_digest','IPN_DIGEST','ECOMMERCE',0,'ipn_digest','ECOMMERCE','line'),('','',0,'return \'\';','CONFIG_OPTION_vpn_username','VPN_USERNAME','ECOMMERCE',0,'vpn_username','ECOMMERCE','line'),('','',0,'return \'\';','CONFIG_OPTION_vpn_password','VPN_PASSWORD','ECOMMERCE',0,'vpn_password','ECOMMERCE','line'),('','',0,'return \'\';','CONFIG_OPTION_callback_password','CALLBACK_PASSWORD','ECOMMERCE',0,'callback_password','ECOMMERCE','line'),('','',0,'return \'\';','CONFIG_OPTION_pd_address','POSTAL_ADDRESS','ECOMMERCE',0,'pd_address','ECOMMERCE','text'),('','',0,'return get_option(\'staff_address\');','CONFIG_OPTION_pd_email','EMAIL_ADDRESS','ECOMMERCE',0,'pd_email','ECOMMERCE','line'),('','',0,'return \'\';','CONFIG_OPTION_pd_number','PHONE_NUMBER','ECOMMERCE',0,'pd_number','ECOMMERCE','line'),('','',0,'return \'GBP\';','CONFIG_OPTION_currency','CURRENCY','ECOMMERCE',0,'currency','ECOMMERCE','line'),('','',0,'return \'0\';','CONFIG_OPTION_ecommerce_test_mode','ECOMMERCE_TEST_MODE','ECOMMERCE',0,'ecommerce_test_mode','ECOMMERCE','tick'),('','',0,'return get_option(\'staff_address\');','CONFIG_OPTION_ipn_test','IPN_ADDRESS_TEST','ECOMMERCE',0,'ipn_test','ECOMMERCE','line'),('','',0,'return get_option(\'staff_address\');','CONFIG_OPTION_ipn','IPN_ADDRESS','ECOMMERCE',0,'ipn','ECOMMERCE','line'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_quiz_show_stats_count_total_open','QUIZZES','STATISTICS',0,'quiz_show_stats_count_total_open','BLOCKS','tick'),('','',0,'return addon_installed(\'points\')?\'0\':NULL;','CONFIG_OPTION_points_ADD_QUIZ','ADD_QUIZ','COUNT_POINTS_GIVEN',0,'points_ADD_QUIZ','POINTS','integer'),('','',0,'return \'0\';','CONFIG_OPTION_shipping_cost_factor','SHIPPING_COST_FACTOR','ECOMMERCE',1,'shipping_cost_factor','ECOMMERCE','float'),('','',0,'return \'1\';','CONFIG_OPTION_allow_opting_out_of_tax','ALLOW_OPTING_OUT_OF_TAX','ECOMMERCE',0,'allow_opting_out_of_tax','ECOMMERCE','tick'),('Forum home','',1,'return do_lang(\'DEFAULT_TESTER_FORUM\');','CONFIG_OPTION_tester_forum_name','TESTER_FORUM_NAME','TESTER',0,'tester_forum_name','FEATURE','forum'),('[b]This is a bug report for the following test[/b]:\n{1}\n\n[b]Bug[/b]:\n','',1,'return do_lang(\'DEFAULT_BUG_REPORT_TEMPLATE\');','CONFIG_OPTION_bug_report_text','BUG_REPORT_TEXT','TESTER',0,'bug_report_text','FEATURE','text'),('0','',1,'return \'0\';','CONFIG_OPTION_ticket_member_forums','TICKET_MEMBER_FORUMS','SUPPORT_TICKETS',0,'ticket_member_forums','FEATURE','tick'),('0','',1,'return \'0\';','CONFIG_OPTION_ticket_type_forums','TICKET_TYPE_FORUMS','SUPPORT_TICKETS',0,'ticket_type_forums','FEATURE','tick'),('509','',1,'return do_lang(\'NEW_TICKET_WELCOME\');','CONFIG_OPTION_ticket_text','PAGE_TEXT','SUPPORT_TICKETS',0,'ticket_text','FEATURE','transtext'),('Website support tickets','',1,'require_lang(\'tickets\'); return do_lang(\'TICKET_FORUM_NAME\',\'\',\'\',\'\',get_lang());','CONFIG_OPTION_ticket_forum_name','TICKET_FORUM_NAME','SUPPORT_TICKETS',0,'ticket_forum_name','FEATURE','forum'),('','',0,'return strval(filemtime(get_file_base().\'/index.php\'));','CONFIG_OPTION_leaderboard_start_date','LEADERBOARD_START_DATE','POINT_LEADERBOARD',0,'leaderboard_start_date','POINTS','date'),('1','',1,'return \'1\';','CONFIG_OPTION_is_on_rss','ENABLE_RSS','NEWS_AND_RSS',0,'is_on_rss','FEATURE','tick'),('60','',1,'return \'60\';','CONFIG_OPTION_rss_update_time','UPDATE_TIME','NEWS_AND_RSS',0,'rss_update_time','FEATURE','integer'),('0','',1,'return \'0\';','CONFIG_OPTION_is_rss_advertised','ENABLE_RSS_ADVERTISING','NEWS_AND_RSS',0,'is_rss_advertised','FEATURE','tick'),('','',0,'return get_base_url().\'/netlink.php\';','CONFIG_OPTION_network_links','NETWORK_LINKS','ENVIRONMENT',1,'network_links','SITE','line'),('','',0,'return addon_installed(\'stats_block\')?\'1\':NULL;','CONFIG_OPTION_forum_show_stats_count_members','COUNT_MEMBERS','STATISTICS',0,'forum_show_stats_count_members','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'1\':NULL;','CONFIG_OPTION_forum_show_stats_count_topics','COUNT_TOPICS','STATISTICS',0,'forum_show_stats_count_topics','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'1\':NULL;','CONFIG_OPTION_forum_show_stats_count_posts','COUNT_POSTS','STATISTICS',0,'forum_show_stats_count_posts','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_posts_today','COUNT_POSTSTODAY','STATISTICS',0,'forum_show_stats_count_posts_today','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_activity_show_stats_count_users_online','COUNT_ONSITE','STATISTICS',0,'activity_show_stats_count_users_online','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_activity_show_stats_count_users_online_record','COUNT_ONSITE_RECORD','STATISTICS',0,'activity_show_stats_count_users_online_record','BLOCKS','tick'),('','',0,'return ((get_forum_type()!=\'ocf\') && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_activity_show_stats_count_users_online_forum','COUNT_ONFORUMS','STATISTICS',0,'activity_show_stats_count_users_online_forum','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_activity_show_stats_count_page_views_today','PAGE_VIEWS_TODAY','STATISTICS',0,'activity_show_stats_count_page_views_today','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_activity_show_stats_count_page_views_this_week','PAGE_VIEWS_THIS_WEEK','STATISTICS',0,'activity_show_stats_count_page_views_this_week','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_activity_show_stats_count_page_views_this_month','PAGE_VIEWS_THIS_MONTH','STATISTICS',0,'activity_show_stats_count_page_views_this_month','BLOCKS','tick'),('','',0,'return ((get_forum_type()==\'ocf\') && (!has_no_forum()) && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_members_active_today','MEMBERS_ACTIVE_TODAY','STATISTICS',0,'forum_show_stats_count_members_active_today','BLOCKS','tick'),('','',0,'return ((get_forum_type()==\'ocf\') && (!has_no_forum()) && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_members_active_this_week','MEMBERS_ACTIVE_THIS_WEEK','STATISTICS',0,'forum_show_stats_count_members_active_this_week','BLOCKS','tick'),('','',0,'return ((get_forum_type()==\'ocf\') && (!has_no_forum()) && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_members_active_this_month','MEMBERS_ACTIVE_THIS_MONTH','STATISTICS',0,'forum_show_stats_count_members_active_this_month','BLOCKS','tick'),('','',0,'return ((get_forum_type()==\'ocf\') && (!has_no_forum()) && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_members_new_today','MEMBERS_NEW_TODAY','STATISTICS',0,'forum_show_stats_count_members_new_today','BLOCKS','tick'),('','',0,'return ((get_forum_type()==\'ocf\') && (!has_no_forum()) && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_members_new_this_week','MEMBERS_NEW_THIS_WEEK','STATISTICS',0,'forum_show_stats_count_members_new_this_week','BLOCKS','tick'),('','',0,'return ((get_forum_type()==\'ocf\') && (!has_no_forum()) && (addon_installed(\'stats_block\')))?\'0\':NULL;','CONFIG_OPTION_forum_show_stats_count_members_new_this_month','MEMBERS_NEW_THIS_MONTH','STATISTICS',0,'forum_show_stats_count_members_new_this_month','BLOCKS','tick'),('','',0,'return ((has_no_forum()) || (get_forum_type()!=\'ocf\'))?NULL:\'0\';','CONFIG_OPTION_usersonline_show_newest_member','SHOW_NEWEST_MEMBER','USERS_ONLINE_BLOCK',0,'usersonline_show_newest_member','BLOCKS','tick'),('','',0,'return ((has_no_forum()) || (get_forum_type()!=\'ocf\'))?NULL:\'0\';','CONFIG_OPTION_usersonline_show_birthdays','BIRTHDAYS','USERS_ONLINE_BLOCK',0,'usersonline_show_birthdays','BLOCKS','tick'),('','',0,'return addon_installed(\'points\')?\'350\':NULL;','CONFIG_OPTION_points_RECOMMEND_SITE','RECOMMEND_SITE','COUNT_POINTS_GIVEN',0,'points_RECOMMEND_SITE','POINTS','integer'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_filedump_show_stats_count_total_files','FILEDUMP_COUNT_FILES','STATISTICS',0,'filedump_show_stats_count_total_files','BLOCKS','tick'),('','',0,'return addon_installed(\'stats_block\')?\'0\':NULL;','CONFIG_OPTION_filedump_show_stats_count_total_space','FILEDUMP_DISK_USAGE','STATISTICS',0,'filedump_show_stats_count_total_space','BLOCKS','tick'),('','',0,'return do_lang(\'SUPERMEMBERS_TEXT\');','CONFIG_OPTION_supermembers_text','PAGE_TEXT','SUPER_MEMBERS',0,'supermembers_text','SECURITY','transtext'),('0','',1,'return \'0\';','CONFIG_OPTION_is_on_sms','ENABLED','SMS',0,'is_on_sms','FEATURE','tick'),('','',0,'return \'\';','CONFIG_OPTION_backup_server_hostname','BACKUP_SERVER_HOSTNAME','BACKUP',0,'backup_server_hostname','FEATURE','line'),('','',0,'return \'0\';','CONFIG_OPTION_advanced_admin_cache','ADVANCED_ADMIN_CACHE','CACHES',0,'advanced_admin_cache','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_collapse_user_zones','COLLAPSE_USER_ZONES','GENERAL',0,'collapse_user_zones','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_check_broken_urls','CHECK_BROKEN_URLS','_COMCODE',0,'check_broken_urls','SITE','tick'),('','',0,'return \'\';','CONFIG_OPTION_google_analytics','GOOGLE_ANALYTICS','GENERAL',0,'google_analytics','SITE','line'),('','',0,'return \'1\';','CONFIG_OPTION_fixed_width','FIXED_WIDTH','GENERAL',0,'fixed_width','THEME','tick'),('','',0,'return \'0\';','CONFIG_OPTION_show_content_tagging','SHOW_CONTENT_TAGGING','GENERAL',0,'show_content_tagging','THEME','tick'),('','',0,'return \'0\';','CONFIG_OPTION_show_content_tagging_inline','SHOW_CONTENT_TAGGING_INLINE','GENERAL',0,'show_content_tagging_inline','THEME','tick'),('','',0,'return \'0\';','CONFIG_OPTION_show_screen_actions','SHOW_SCREEN_ACTIONS','GENERAL',0,'show_screen_actions','THEME','tick'),('','',0,'return \'1\';','CONFIG_OPTION_cms_show_personal_sub_links','PERSONAL_SUB_LINKS','PERSONAL_BLOCK',0,'cms_show_personal_sub_links','BLOCKS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_long_google_cookies','LONG_GOOGLE_COOKIES','GENERAL',0,'long_google_cookies','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_remember_me_by_default','REMEMBER_ME_BY_DEFAULT','GENERAL',0,'remember_me_by_default','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_detect_javascript','DETECT_JAVASCRIPT','ADVANCED',0,'detect_javascript','SITE','tick'),('','',0,'return \'1\';','CONFIG_OPTION_mobile_support','MOBILE_SUPPORT','GENERAL',0,'mobile_support','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_mail_queue','MAIL_QUEUE','EMAIL',0,'mail_queue','SITE','tick'),('','',0,'return \'0\';','CONFIG_OPTION_mail_queue_debug','MAIL_QUEUE_DEBUG','EMAIL',0,'mail_queue_debug','SITE','tick'),('','',0,'return \'200\';','CONFIG_OPTION_comments_to_show_in_thread','COMMENTS_TO_SHOW_IN_THREAD','USER_INTERACTION',0,'comments_to_show_in_thread','FEATURE','integer'),('','',0,'return \'6\';','CONFIG_OPTION_max_thread_depth','MAX_THREAD_DEPTH','USER_INTERACTION',0,'max_thread_depth','FEATURE','integer'),('','',0,'return \'\';','CONFIG_OPTION_transcoding_server','TRANSCODING_SERVER','TRANSCODING',0,'transcoding_server','FEATURE','line'),('','',0,'return \'\';','CONFIG_OPTION_ffmpeg_path','FFMPEG_PATH','TRANSCODING',0,'ffmpeg_path','FEATURE','line'),('','',0,'return \'0\';','CONFIG_OPTION_allow_email_from_staff_disable','ALLOW_EMAIL_FROM_STAFF_DISABLE','GENERAL',0,'allow_email_from_staff_disable','SECTION_FORUMS','tick'),('','',0,'return \'\';','CONFIG_OPTION_intro_forum_id','INTRO_FORUM_ID','USERNAMES_AND_PASSWORDS',0,'intro_forum_id','SECTION_FORUMS','?forum'),('','',0,'return \'0\';','CONFIG_OPTION_signup_fullname','SIGNUP_FULLNAME','USERNAMES_AND_PASSWORDS',0,'signup_fullname','SECTION_FORUMS','tick'),('','',0,'return \'0\';','CONFIG_OPTION_galleries_subcat_narrowin','GALLERIES_SUBCAT_NARROWIN','GALLERIES',0,'galleries_subcat_narrowin','FEATURE','tick'),('','',0,'return addon_installed(\'ecommerce\')?\'100.0\':NULL;','CONFIG_OPTION_points_per_currency_unit','POINTS_PER_CURRENCY_UNIT','ECOMMERCE',0,'points_per_currency_unit','POINTS','integer'),('','',0,'return \'1\';','CONFIG_OPTION_complex_uploader','COMPLEX_UPLOADER','GENERAL',0,'complex_uploader','ACCESSIBILITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_wysiwyg','ENABLE_WYSIWYG','GENERAL',0,'wysiwyg','ACCESSIBILITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_editarea','EDITAREA','GENERAL',0,'editarea','ACCESSIBILITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_js_overlays','JS_OVERLAYS','GENERAL',0,'js_overlays','ACCESSIBILITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_tree_lists','TREE_LISTS','GENERAL',0,'tree_lists','ACCESSIBILITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_css_captcha','CSS_CAPTCHA','SECURITY_IMAGE',0,'css_captcha','SECURITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_captcha_single_guess','CAPTCHA_SINGLE_GUESS','SECURITY_IMAGE',0,'captcha_single_guess','SECURITY','tick'),('','',0,'return \'1\';','CONFIG_OPTION_autoban','ENABLE_AUTOBAN','GENERAL',0,'autoban','SECURITY','tick'),('','',0,'return \'0\';','CONFIG_OPTION_likes','ENABLE_LIKES','USER_INTERACTION',0,'likes','FEATURE','tick'),('','EVERYTHING|ACTIONS|GUESTACTIONS|JOINING|NEVER',0,'return \'NEVER\';','CONFIG_OPTION_spam_check_level','SPAM_CHECK_LEVEL','SPAMMER_DETECTION',0,'spam_check_level','SECURITY','list'),('','',0,'return \'\';','CONFIG_OPTION_stopforumspam_api_key','STOPFORUMSPAM_API_KEY','SPAMMER_DETECTION',0,'stopforumspam_api_key','SECURITY','line'),('','',0,'return class_exists(\'SoapClient\')?\'\':NULL;','CONFIG_OPTION_tornevall_api_username','TORNEVALL_API_USERNAME','SPAMMER_DETECTION',0,'tornevall_api_username','SECURITY','line'),('','',0,'return class_exists(\'SoapClient\')?\'\':NULL;','CONFIG_OPTION_tornevall_api_password','TORNEVALL_API_PASSWORD','SPAMMER_DETECTION',0,'tornevall_api_password','SECURITY','line'),('','',0,'return \'*.opm.tornevall.org\';','CONFIG_OPTION_spam_block_lists','SPAM_BLOCK_LISTS','SPAMMER_DETECTION',0,'spam_block_lists','SECURITY','line'),('','',0,'return \'60\';','CONFIG_OPTION_spam_cache_time','SPAM_CACHE_TIME','SPAMMER_DETECTION',0,'spam_cache_time','SECURITY','integer'),('','',0,'return \'127.0.0.1,\'.cms_srv(\'SERVER_ADDR\').\'\';','CONFIG_OPTION_spam_check_exclusions','SPAM_CHECK_EXCLUSIONS','SPAMMER_DETECTION',0,'spam_check_exclusions','SECURITY','line'),('','',0,'return \'31\';','CONFIG_OPTION_spam_stale_threshold','SPAM_STALE_THRESHOLD','SPAMMER_DETECTION',0,'spam_stale_threshold','SECURITY','integer'),('','',0,'return \'90\';','CONFIG_OPTION_spam_ban_threshold','SPAM_BAN_THRESHOLD','SPAMMER_DETECTION',0,'spam_ban_threshold','SECURITY','integer'),('','',0,'return \'60\';','CONFIG_OPTION_spam_block_threshold','SPAM_BLOCK_THRESHOLD','SPAMMER_DETECTION',0,'spam_block_threshold','SECURITY','integer'),('','',0,'return \'40\';','CONFIG_OPTION_spam_approval_threshold','SPAM_APPROVAL_THRESHOLD','SPAMMER_DETECTION',0,'spam_approval_threshold','SECURITY','integer'),('','',0,'return \'0\';','CONFIG_OPTION_spam_check_usernames','SPAM_CHECK_USERNAMES','SPAMMER_DETECTION',0,'spam_check_usernames','SECURITY','tick'),('','',0,'return \'80\';','CONFIG_OPTION_implied_spammer_confidence','IMPLIED_SPAMMER_CONFIDENCE','SPAMMER_DETECTION',0,'implied_spammer_confidence','SECURITY','integer'),('','',0,'return \'1\';','CONFIG_OPTION_spam_blackhole_detection','SPAM_BLACKHOLE_DETECTION','SPAMMER_DETECTION',0,'spam_blackhole_detection','SECURITY','tick'),('','',0,'return \'\';','CONFIG_OPTION_honeypot_url','HONEYPOT_URL','SPAMMER_DETECTION',0,'honeypot_url','SECURITY','line'),('','',0,'return \'\';','CONFIG_OPTION_honeypot_phrase','HONEYPOT_PHRASE','SPAMMER_DETECTION',0,'honeypot_phrase','SECURITY','line'),('','',0,'return \'1\';','CONFIG_OPTION_bottom_show_rules_link','RULES_LINK','BOTTOM_LINKS',0,'bottom_show_rules_link','FEATURE','tick');
/*!40000 ALTER TABLE `cms_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_cron_caching_requests`
--

DROP TABLE IF EXISTS `cms_cron_caching_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_cron_caching_requests` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `c_codename` varchar(80) NOT NULL,
  `c_map` longtext NOT NULL,
  `c_timezone` varchar(80) NOT NULL,
  `c_is_bot` tinyint(1) NOT NULL,
  `c_store_as_tempcode` tinyint(1) NOT NULL,
  `c_lang` varchar(5) NOT NULL,
  `c_theme` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `c_compound` (`c_codename`,`c_theme`,`c_lang`,`c_timezone`),
  KEY `c_is_bot` (`c_is_bot`),
  KEY `c_store_as_tempcode` (`c_store_as_tempcode`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_cron_caching_requests`
--

LOCK TABLES `cms_cron_caching_requests` WRITE;
/*!40000 ALTER TABLE `cms_cron_caching_requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_cron_caching_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_custom_comcode`
--

DROP TABLE IF EXISTS `cms_custom_comcode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_custom_comcode` (
  `tag_block_tag` tinyint(1) NOT NULL,
  `tag_dangerous_tag` tinyint(1) NOT NULL,
  `tag_description` int(10) unsigned NOT NULL,
  `tag_enabled` tinyint(1) NOT NULL,
  `tag_example` longtext NOT NULL,
  `tag_parameters` varchar(255) NOT NULL,
  `tag_replace` longtext NOT NULL,
  `tag_tag` varchar(80) NOT NULL,
  `tag_textual_tag` tinyint(1) NOT NULL,
  `tag_title` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`tag_tag`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_custom_comcode`
--

LOCK TABLES `cms_custom_comcode` WRITE;
/*!40000 ALTER TABLE `cms_custom_comcode` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_custom_comcode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_customtasks`
--

DROP TABLE IF EXISTS `cms_customtasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_customtasks` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `tasktitle` varchar(255) NOT NULL,
  `datetimeadded` int(10) unsigned NOT NULL,
  `recurinterval` int(11) NOT NULL,
  `recurevery` varchar(80) NOT NULL,
  `taskisdone` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_customtasks`
--

LOCK TABLES `cms_customtasks` WRITE;
/*!40000 ALTER TABLE `cms_customtasks` DISABLE KEYS */;
INSERT INTO `cms_customtasks` VALUES (1,'Set up website configuration and structure',1332808931,0,'',NULL),(2,'Make \'favicon\' theme image',1332808931,0,'',NULL),(3,'Make \'appleicon\' (webclip) theme image',1332808931,0,'',NULL),(4,'Make/install custom theme',1332808931,0,'',NULL),(5,'Add your content',1332808931,0,'',NULL),(6,'[page=\"adminzone:admin_themes:edit_image:logo/trimmed-logo:theme=default\"]Customise your mail/RSS logo[/page]',1332808931,0,'',NULL),(7,'[page=\"adminzone:admin_themes:_edit_templates:theme=default:f0file=MAIL.tpl\"]Customise your \'MAIL\' template[/page]',1332808931,0,'',NULL),(8,'[url=\"P3P Wizard (set up privacy policy)\"]http://www.p3pwiz.com/[/url]',1332808931,0,'',NULL),(9,'[url=\"Submit to Google\"]http://www.google.com/addurl/[/url]',1332808931,0,'',NULL),(10,'[url=\"Submit to OpenDMOZ\"]http://www.dmoz.org/add.html[/url]',1332808931,0,'',NULL),(11,'[url=\"Submit to Bing\"]http://www.bing.com/webmaster/SubmitSitePage.aspx[/url]',1332808931,0,'',NULL);
/*!40000 ALTER TABLE `cms_customtasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_db_meta`
--

DROP TABLE IF EXISTS `cms_db_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_db_meta` (
  `m_table` varchar(80) NOT NULL,
  `m_name` varchar(80) NOT NULL,
  `m_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`m_table`,`m_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_db_meta`
--

LOCK TABLES `cms_db_meta` WRITE;
/*!40000 ALTER TABLE `cms_db_meta` DISABLE KEYS */;
INSERT INTO `cms_db_meta` VALUES ('addons','addon_author','SHORT_TEXT'),('addons','addon_description','LONG_TEXT'),('addons','addon_install_time','TIME'),('addons','addon_name','*SHORT_TEXT'),('addons','addon_organisation','SHORT_TEXT'),('addons','addon_version','SHORT_TEXT'),('addons_dependencies','addon_name','SHORT_TEXT'),('addons_dependencies','addon_name_dependant_upon','SHORT_TEXT'),('addons_dependencies','addon_name_incompatibility','BINARY'),('addons_dependencies','id','*AUTO'),('addons_files','addon_name','SHORT_TEXT'),('addons_files','filename','SHORT_TEXT'),('addons_files','id','*AUTO'),('adminlogs','date_and_time','TIME'),('adminlogs','id','*AUTO'),('adminlogs','ip','IP'),('adminlogs','param_a','ID_TEXT'),('adminlogs','param_b','SHORT_TEXT'),('adminlogs','the_type','ID_TEXT'),('adminlogs','the_user','USER'),('attachments','a_add_time','INTEGER'),('attachments','a_description','SHORT_TEXT'),('attachments','a_file_size','?INTEGER'),('attachments','a_last_downloaded_time','?INTEGER'),('attachments','a_member_id','USER'),('attachments','a_num_downloads','INTEGER'),('attachments','a_original_filename','SHORT_TEXT'),('attachments','a_thumb_url','SHORT_TEXT'),('attachments','a_url','SHORT_TEXT'),('attachments','id','*AUTO'),('attachment_refs','a_id','INTEGER'),('attachment_refs','id','*AUTO'),('attachment_refs','r_referer_id','ID_TEXT'),('attachment_refs','r_referer_type','ID_TEXT'),('authors','author','*ID_TEXT'),('authors','description','LONG_TRANS'),('authors','forum_handle','?USER'),('authors','skills','LONG_TRANS'),('authors','url','URLPATH'),('autosave','a_key','LONG_TEXT'),('autosave','a_member_id','USER'),('autosave','a_time','TIME'),('autosave','a_value','LONG_TEXT'),('autosave','id','*AUTO'),('award_archive','a_type_id','*AUTO_LINK'),('award_archive','content_id','ID_TEXT'),('award_archive','date_and_time','*TIME'),('award_archive','member_id','USER'),('award_types','a_content_type','ID_TEXT'),('award_types','a_description','LONG_TRANS'),('award_types','a_hide_awardee','BINARY'),('award_types','a_points','INTEGER'),('award_types','a_title','SHORT_TRANS'),('award_types','a_update_time_hours','INTEGER'),('award_types','id','*AUTO'),('banners','add_date','TIME'),('banners','b_title_text','SHORT_TEXT'),('banners','b_type','ID_TEXT'),('banners','campaign_remaining','INTEGER'),('banners','caption','SHORT_TRANS'),('banners','edit_date','?TIME'),('banners','expiry_date','?TIME'),('banners','hits_from','INTEGER'),('banners','hits_to','INTEGER'),('banners','img_url','URLPATH'),('banners','importance_modulus','INTEGER'),('banners','name','*ID_TEXT'),('banners','notes','LONG_TEXT'),('banners','site_url','URLPATH'),('banners','submitter','USER'),('banners','the_type','SHORT_INTEGER'),('banners','validated','BINARY'),('banners','views_from','INTEGER'),('banners','views_to','INTEGER'),('banner_clicks','c_banner_id','ID_TEXT'),('banner_clicks','c_date_and_time','TIME'),('banner_clicks','c_ip_address','IP'),('banner_clicks','c_member_id','USER'),('banner_clicks','c_source','ID_TEXT'),('banner_clicks','id','*AUTO'),('banner_types','id','*ID_TEXT'),('banner_types','t_comcode_inline','BINARY'),('banner_types','t_image_height','INTEGER'),('banner_types','t_image_width','INTEGER'),('banner_types','t_is_textual','BINARY'),('banner_types','t_max_file_size','INTEGER'),('blocks','block_author','ID_TEXT'),('blocks','block_hacked_by','ID_TEXT'),('blocks','block_hack_version','?INTEGER'),('blocks','block_name','*ID_TEXT'),('blocks','block_organisation','ID_TEXT'),('blocks','block_version','INTEGER'),('bookmarks','b_folder','SHORT_TEXT'),('bookmarks','b_owner','USER'),('bookmarks','b_page_link','SHORT_TEXT'),('bookmarks','b_title','SHORT_TEXT'),('bookmarks','id','*AUTO'),('cache','the_theme','*ID_TEXT'),('cache','date_and_time','TIME'),('cache','the_value','LONG_TEXT'),('cache','identifier','*MINIID_TEXT'),('cache','cached_for','*ID_TEXT'),('cached_comcode_pages','cc_page_title','?SHORT_TRANS'),('cached_comcode_pages','string_index','LONG_TRANS'),('cached_comcode_pages','the_page','*ID_TEXT'),('cached_comcode_pages','the_theme','*ID_TEXT'),('cached_comcode_pages','the_zone','*ID_TEXT'),('cache_on','cached_for','*ID_TEXT'),('cache_on','cache_on','LONG_TEXT'),('cache_on','cache_ttl','INTEGER'),('calendar_events','allow_comments','SHORT_INTEGER'),('calendar_events','allow_rating','BINARY'),('calendar_events','allow_trackbacks','BINARY'),('calendar_events','e_add_date','TIME'),('calendar_events','e_content','LONG_TRANS'),('calendar_events','e_edit_date','?TIME'),('calendar_events','e_end_day','?INTEGER'),('calendar_events','e_end_hour','?INTEGER'),('calendar_events','e_end_minute','?INTEGER'),('calendar_events','e_end_month','?INTEGER'),('calendar_events','e_end_year','?INTEGER'),('calendar_events','e_do_timezone_conv','BINARY'),('calendar_events','e_timezone','ID_TEXT'),('calendar_events','e_is_public','BINARY'),('calendar_events','e_priority','INTEGER'),('calendar_events','e_recurrence','ID_TEXT'),('calendar_events','e_recurrences','?INTEGER'),('calendar_events','e_seg_recurrences','BINARY'),('calendar_events','e_start_day','INTEGER'),('calendar_events','e_start_hour','?INTEGER'),('calendar_events','e_start_minute','?INTEGER'),('calendar_events','e_start_month','INTEGER'),('calendar_events','e_start_year','INTEGER'),('calendar_events','e_submitter','USER'),('calendar_events','e_title','SHORT_TRANS'),('calendar_events','e_type','AUTO_LINK'),('calendar_events','e_views','INTEGER'),('calendar_events','id','*AUTO'),('calendar_events','notes','LONG_TEXT'),('calendar_events','validated','BINARY'),('calendar_interests','i_member_id','*USER'),('calendar_interests','t_type','*AUTO_LINK'),('calendar_jobs','id','*AUTO'),('calendar_jobs','j_event_id','AUTO_LINK'),('calendar_jobs','j_member_id','?USER'),('calendar_jobs','j_reminder_id','?AUTO_LINK'),('calendar_jobs','j_time','TIME'),('calendar_reminders','e_id','AUTO_LINK'),('calendar_reminders','id','*AUTO'),('calendar_reminders','n_member_id','USER'),('calendar_reminders','n_seconds_before','INTEGER'),('calendar_types','id','*AUTO'),('calendar_types','t_logo','SHORT_TEXT'),('calendar_types','t_title','SHORT_TRANS'),('catalogues','c_add_date','TIME'),('catalogues','c_description','LONG_TRANS'),('catalogues','c_display_type','SHORT_INTEGER'),('catalogues','c_ecommerce','BINARY'),('catalogues','c_is_tree','BINARY'),('catalogues','c_name','*ID_TEXT'),('catalogues','c_notes','LONG_TEXT'),('catalogues','c_send_view_reports','ID_TEXT'),('catalogues','c_submit_points','INTEGER'),('catalogues','c_title','SHORT_TRANS'),('catalogue_categories','cc_add_date','TIME'),('catalogue_categories','cc_description','LONG_TRANS'),('catalogue_categories','cc_move_days_higher','INTEGER'),('catalogue_categories','cc_move_days_lower','INTEGER'),('catalogue_categories','cc_move_target','?AUTO_LINK'),('catalogue_categories','cc_notes','LONG_TEXT'),('catalogue_categories','cc_parent_id','?AUTO_LINK'),('catalogue_categories','cc_title','SHORT_TRANS'),('catalogue_categories','c_name','ID_TEXT'),('catalogue_categories','id','*AUTO'),('catalogue_categories','rep_image','URLPATH'),('catalogue_efv_long','ce_id','AUTO_LINK'),('catalogue_efv_long','cf_id','AUTO_LINK'),('catalogue_efv_long','cv_value','LONG_TEXT'),('catalogue_efv_long','id','*AUTO'),('catalogue_efv_long_trans','ce_id','AUTO_LINK'),('catalogue_efv_long_trans','cf_id','AUTO_LINK'),('catalogue_efv_long_trans','cv_value','LONG_TRANS'),('catalogue_efv_long_trans','id','*AUTO'),('catalogue_efv_short','ce_id','AUTO_LINK'),('catalogue_efv_short','cf_id','AUTO_LINK'),('catalogue_efv_short','cv_value','SHORT_TEXT'),('catalogue_efv_short','id','*AUTO'),('catalogue_efv_short_trans','ce_id','AUTO_LINK'),('catalogue_efv_short_trans','cf_id','AUTO_LINK'),('catalogue_efv_short_trans','cv_value','SHORT_TRANS'),('catalogue_efv_short_trans','id','*AUTO'),('catalogue_entries','allow_comments','SHORT_INTEGER'),('catalogue_entries','allow_rating','BINARY'),('catalogue_entries','allow_trackbacks','BINARY'),('catalogue_entries','cc_id','AUTO_LINK'),('catalogue_entries','ce_add_date','TIME'),('catalogue_entries','ce_edit_date','?TIME'),('catalogue_entries','ce_last_moved','INTEGER'),('catalogue_entries','ce_submitter','USER'),('catalogue_entries','ce_validated','BINARY'),('catalogue_entries','ce_views','INTEGER'),('catalogue_entries','ce_views_prior','INTEGER'),('catalogue_entries','c_name','ID_TEXT'),('catalogue_entries','id','*AUTO'),('catalogue_entries','notes','LONG_TEXT'),('catalogue_fields','cf_default','LONG_TEXT'),('catalogue_fields','cf_defines_order','BINARY'),('catalogue_fields','cf_description','LONG_TRANS'),('catalogue_fields','cf_name','SHORT_TRANS'),('catalogue_fields','cf_order','SHORT_INTEGER'),('catalogue_fields','cf_put_in_category','BINARY'),('catalogue_fields','cf_put_in_search','BINARY'),('catalogue_fields','cf_required','BINARY'),('catalogue_fields','cf_searchable','BINARY'),('catalogue_fields','cf_type','ID_TEXT'),('catalogue_fields','cf_visible','BINARY'),('catalogue_fields','c_name','ID_TEXT'),('catalogue_fields','id','*AUTO'),('chargelog','amount','INTEGER'),('chargelog','date_and_time','TIME'),('chargelog','id','*AUTO'),('chargelog','reason','SHORT_TRANS'),('chargelog','user_id','USER'),('chat_active','date_and_time','TIME'),('chat_active','id','*AUTO'),('chat_active','member_id','USER'),('chat_active','room_id','?AUTO_LINK'),('chat_blocking','date_and_time','TIME'),('chat_blocking','member_blocked','*USER'),('chat_blocking','member_blocker','*USER'),('chat_buddies','date_and_time','TIME'),('chat_buddies','member_liked','*USER'),('chat_buddies','member_likes','*USER'),('chat_events','e_date_and_time','TIME'),('chat_events','e_member_id','USER'),('chat_events','e_room_id','?AUTO_LINK'),('chat_events','e_type_code','ID_TEXT'),('chat_events','id','*AUTO'),('chat_messages','date_and_time','TIME'),('chat_messages','font_name','SHORT_TEXT'),('chat_messages','id','*AUTO'),('chat_messages','ip_address','IP'),('chat_messages','room_id','AUTO_LINK'),('chat_messages','system_message','BINARY'),('chat_messages','text_colour','SHORT_TEXT'),('chat_messages','the_message','LONG_TRANS'),('chat_messages','user_id','USER'),('chat_rooms','allow_list','LONG_TEXT'),('chat_rooms','allow_list_groups','LONG_TEXT'),('chat_rooms','c_welcome','LONG_TRANS'),('chat_rooms','disallow_list','LONG_TEXT'),('chat_rooms','disallow_list_groups','LONG_TEXT'),('chat_rooms','id','*AUTO'),('chat_rooms','is_im','BINARY'),('chat_rooms','room_language','LANGUAGE_NAME'),('chat_rooms','room_name','SHORT_TEXT'),('chat_rooms','room_owner','?INTEGER'),('chat_sound_effects','s_effect_id','*ID_TEXT'),('chat_sound_effects','s_member','*USER'),('chat_sound_effects','s_url','URLPATH'),('comcode_pages','p_add_date','TIME'),('comcode_pages','p_edit_date','?TIME'),('comcode_pages','p_parent_page','ID_TEXT'),('comcode_pages','p_show_as_edit','BINARY'),('comcode_pages','p_submitter','USER'),('comcode_pages','p_validated','BINARY'),('comcode_pages','the_page','*ID_TEXT'),('comcode_pages','the_zone','*ID_TEXT'),('config','config_value','LONG_TEXT'),('config','c_data','SHORT_TEXT'),('config','c_set','BINARY'),('config','eval','SHORT_TEXT'),('config','explanation','ID_TEXT'),('config','human_name','ID_TEXT'),('config','section','ID_TEXT'),('config','shared_hosting_restricted','BINARY'),('config','the_name','*ID_TEXT'),('config','the_page','ID_TEXT'),('config','the_type','ID_TEXT'),('custom_comcode','tag_block_tag','BINARY'),('custom_comcode','tag_dangerous_tag','BINARY'),('custom_comcode','tag_description','SHORT_TRANS'),('custom_comcode','tag_enabled','BINARY'),('custom_comcode','tag_example','LONG_TEXT'),('custom_comcode','tag_parameters','SHORT_TEXT'),('custom_comcode','tag_replace','LONG_TEXT'),('custom_comcode','tag_tag','*ID_TEXT'),('custom_comcode','tag_textual_tag','BINARY'),('custom_comcode','tag_title','SHORT_TRANS'),('download_categories','add_date','TIME'),('download_categories','category','SHORT_TRANS'),('download_categories','description','LONG_TRANS'),('download_categories','id','*AUTO'),('download_categories','notes','LONG_TEXT'),('download_categories','parent_id','?AUTO_LINK'),('download_categories','rep_image','URLPATH'),('download_downloads','add_date','TIME'),('download_downloads','allow_comments','SHORT_INTEGER'),('download_downloads','allow_rating','BINARY'),('download_downloads','allow_trackbacks','BINARY'),('download_downloads','author','ID_TEXT'),('download_downloads','category_id','AUTO_LINK'),('download_downloads','comments','LONG_TRANS'),('download_downloads','default_pic','INTEGER'),('download_downloads','description','LONG_TRANS'),('download_downloads','download_cost','INTEGER'),('download_downloads','download_data_mash','LONG_TEXT'),('download_downloads','download_licence','?AUTO_LINK'),('download_downloads','download_submitter_gets_points','BINARY'),('download_downloads','download_views','INTEGER'),('download_downloads','edit_date','?TIME'),('download_downloads','file_size','?INTEGER'),('download_downloads','id','*AUTO'),('download_downloads','name','SHORT_TRANS'),('download_downloads','notes','LONG_TEXT'),('download_downloads','num_downloads','INTEGER'),('download_downloads','original_filename','SHORT_TEXT'),('download_downloads','out_mode_id','?AUTO_LINK'),('download_downloads','rep_image','URLPATH'),('download_downloads','submitter','USER'),('download_downloads','url','URLPATH'),('download_downloads','validated','BINARY'),('download_licences','id','*AUTO'),('download_licences','l_text','LONG_TEXT'),('download_licences','l_title','SHORT_TEXT'),('download_logging','date_and_time','TIME'),('download_logging','id','*AUTO_LINK'),('download_logging','ip','IP'),('download_logging','the_user','*USER'),('edit_pings','id','*AUTO'),('edit_pings','the_id','ID_TEXT'),('edit_pings','the_member','USER'),('edit_pings','the_page','ID_TEXT'),('edit_pings','the_time','TIME'),('edit_pings','the_type','ID_TEXT'),('failedlogins','date_and_time','TIME'),('failedlogins','failed_account','ID_TEXT'),('failedlogins','id','*AUTO'),('failedlogins','ip','IP'),('filedump','description','SHORT_TRANS'),('filedump','id','*AUTO'),('filedump','name','ID_TEXT'),('filedump','path','URLPATH'),('filedump','the_member','USER'),('f_categories','c_description','LONG_TEXT'),('f_categories','c_expanded_by_default','BINARY'),('f_categories','c_title','SHORT_TEXT'),('f_categories','id','*AUTO'),('f_custom_fields','cf_default','LONG_TEXT'),('f_custom_fields','cf_description','SHORT_TRANS'),('f_custom_fields','cf_encrypted','BINARY'),('f_custom_fields','cf_locked','BINARY'),('f_custom_fields','cf_name','SHORT_TRANS'),('f_custom_fields','cf_only_group','LONG_TEXT'),('f_custom_fields','cf_order','INTEGER'),('f_custom_fields','cf_owner_set','BINARY'),('f_custom_fields','cf_owner_view','BINARY'),('f_custom_fields','cf_public_view','BINARY'),('f_custom_fields','cf_required','BINARY'),('f_custom_fields','cf_show_in_posts','BINARY'),('f_custom_fields','cf_show_in_post_previews','BINARY'),('f_custom_fields','cf_type','ID_TEXT'),('f_custom_fields','id','*AUTO'),('f_emoticons','e_code','*SHORT_TEXT'),('f_emoticons','e_is_special','BINARY'),('f_emoticons','e_relevance_level','INTEGER'),('f_emoticons','e_theme_img_code','SHORT_TEXT'),('f_emoticons','e_use_topics','BINARY'),('f_forums','f_cache_last_forum_id','?AUTO_LINK'),('f_forums','f_cache_last_member_id','?USER'),('f_forums','f_cache_last_time','?TIME'),('f_forums','f_cache_last_title','SHORT_TEXT'),('f_forums','f_cache_last_topic_id','?AUTO_LINK'),('f_forums','f_cache_last_username','SHORT_TEXT'),('f_forums','f_cache_num_posts','INTEGER'),('f_forums','f_cache_num_topics','INTEGER'),('f_forums','f_category_id','?AUTO_LINK'),('f_forums','f_description','LONG_TRANS'),('f_forums','f_intro_answer','SHORT_TEXT'),('f_forums','f_intro_question','LONG_TRANS'),('f_forums','f_name','SHORT_TEXT'),('f_forums','f_order','ID_TEXT'),('f_forums','f_order_sub_alpha','BINARY'),('f_forums','f_parent_forum','?AUTO_LINK'),('f_forums','f_position','INTEGER'),('f_forums','f_post_count_increment','BINARY'),('f_forums','f_redirection','SHORT_TEXT'),('f_forums','id','*AUTO'),('f_forum_intro_ip','i_forum_id','*AUTO_LINK'),('f_forum_intro_ip','i_ip','*IP'),('f_forum_intro_member','i_forum_id','*AUTO_LINK'),('f_forum_intro_member','i_member_id','*USER'),('f_groups','g_enquire_on_new_ips','BINARY'),('f_groups','g_flood_control_access_secs','INTEGER'),('f_groups','g_flood_control_submit_secs','INTEGER'),('f_groups','g_gift_points_base','INTEGER'),('f_groups','g_gift_points_per_day','INTEGER'),('f_groups','g_group_leader','?USER'),('f_groups','g_hidden','BINARY'),('f_groups','g_is_default','BINARY'),('f_groups','g_is_presented_at_install','BINARY'),('f_groups','g_is_private_club','BINARY'),('f_groups','g_is_super_admin','BINARY'),('f_groups','g_is_super_moderator','BINARY'),('f_groups','g_max_attachments_per_post','INTEGER'),('f_groups','g_max_avatar_height','INTEGER'),('f_groups','g_max_avatar_width','INTEGER'),('f_groups','g_max_daily_upload_mb','INTEGER'),('f_groups','g_max_post_length_comcode','INTEGER'),('f_groups','g_max_sig_length_comcode','INTEGER'),('f_groups','g_name','SHORT_TRANS'),('f_groups','g_open_membership','BINARY'),('f_groups','g_order','INTEGER'),('f_groups','g_promotion_target','?GROUP'),('f_groups','g_promotion_threshold','?INTEGER'),('f_groups','g_rank_image','ID_TEXT'),('f_groups','g_rank_image_pri_only','BINARY'),('f_groups','g_title','SHORT_TRANS'),('f_groups','id','*AUTO'),('f_group_members','gm_group_id','*GROUP'),('f_group_members','gm_member_id','*USER'),('f_group_members','gm_validated','BINARY'),('f_invites','id','*AUTO'),('f_invites','i_email_address','SHORT_TEXT'),('f_invites','i_inviter','USER'),('f_invites','i_taken','BINARY'),('f_invites','i_time','TIME'),('f_members','id','*AUTO'),('f_members','m_allow_emails','BINARY'),('f_members','m_avatar_url','URLPATH'),('f_members','m_cache_num_posts','INTEGER'),('f_members','m_cache_warnings','INTEGER'),('f_members','m_dob_day','?INTEGER'),('f_members','m_dob_month','?INTEGER'),('f_members','m_dob_year','?INTEGER'),('f_members','m_email_address','SHORT_TEXT'),('f_members','m_highlighted_name','BINARY'),('f_members','m_ip_address','IP'),('f_members','m_is_perm_banned','BINARY'),('f_members','m_join_time','TIME'),('f_members','m_language','ID_TEXT'),('f_members','m_last_submit_time','TIME'),('f_members','m_last_visit_time','TIME'),('f_members','m_max_email_attach_size_mb','INTEGER'),('f_members','m_notes','LONG_TEXT'),('f_members','m_on_probation_until','?TIME'),('f_members','m_password_change_code','SHORT_TEXT'),('f_members','m_password_compat_scheme','ID_TEXT'),('f_members','m_pass_hash_salted','SHORT_TEXT'),('f_members','m_pass_salt','SHORT_TEXT'),('f_members','m_photo_thumb_url','URLPATH'),('f_members','m_photo_url','URLPATH'),('f_members','m_preview_posts','BINARY'),('f_members','m_primary_group','GROUP'),('f_members','m_pt_allow','SHORT_TEXT'),('f_members','m_pt_rules_text','LONG_TRANS'),('f_members','m_reveal_age','BINARY'),('f_members','m_signature','LONG_TRANS'),('f_members','m_theme','ID_TEXT'),('f_members','m_timezone_offset','SHORT_TEXT'),('f_members','m_title','SHORT_TEXT'),('f_members','m_track_contributed_topics','BINARY'),('f_members','m_username','ID_TEXT'),('f_members','m_validated','BINARY'),('f_members','m_validated_email_confirm_code','SHORT_TEXT'),('f_members','m_views_signatures','BINARY'),('f_members','m_zone_wide','BINARY'),('f_member_cpf_perms','field_id','*AUTO_LINK'),('f_member_cpf_perms','friend_view','BINARY'),('f_member_cpf_perms','group_view','SHORT_TEXT'),('f_member_cpf_perms','guest_view','BINARY'),('f_member_cpf_perms','member_id','*USER'),('f_member_cpf_perms','member_view','BINARY'),('f_member_custom_fields','field_1','?LONG_TRANS'),('f_member_custom_fields','field_10','SHORT_TEXT'),('f_member_custom_fields','field_11','SHORT_TEXT'),('f_member_custom_fields','field_12','SHORT_TEXT'),('f_member_custom_fields','field_13','SHORT_TEXT'),('f_member_custom_fields','field_14','LONG_TEXT'),('f_member_custom_fields','field_15','LONG_TEXT'),('f_member_custom_fields','field_16','SHORT_TEXT'),('f_member_custom_fields','field_17','LONG_TEXT'),('f_member_custom_fields','field_18','LONG_TEXT'),('f_member_custom_fields','field_19','LONG_TEXT'),('f_member_custom_fields','field_2','SHORT_TEXT'),('f_member_custom_fields','field_20','LONG_TEXT'),('f_member_custom_fields','field_21','SHORT_TEXT'),('f_member_custom_fields','field_22','SHORT_TEXT'),('f_member_custom_fields','field_23','LONG_TEXT'),('f_member_custom_fields','field_24','SHORT_TEXT'),('f_member_custom_fields','field_25','SHORT_TEXT'),('f_member_custom_fields','field_26','SHORT_TEXT'),('f_member_custom_fields','field_27','SHORT_TEXT'),('f_member_custom_fields','field_28','SHORT_TEXT'),('f_member_custom_fields','field_29','SHORT_TEXT'),('f_member_custom_fields','field_3','SHORT_TEXT'),('f_member_custom_fields','field_30','SHORT_TEXT'),('f_member_custom_fields','field_31','SHORT_TEXT'),('f_member_custom_fields','field_32','SHORT_TEXT'),('f_member_custom_fields','field_33','SHORT_TEXT'),('f_member_custom_fields','field_34','SHORT_TEXT'),('f_member_custom_fields','field_35','SHORT_TEXT'),('f_member_custom_fields','field_4','SHORT_TEXT'),('f_member_custom_fields','field_5','SHORT_TEXT'),('f_member_custom_fields','field_6','?LONG_TRANS'),('f_member_custom_fields','field_7','SHORT_TEXT'),('f_member_custom_fields','field_8','SHORT_TEXT'),('f_member_custom_fields','field_9','?LONG_TRANS'),('f_member_custom_fields','mf_member_id','*USER'),('f_member_known_login_ips','i_ip','*IP'),('f_member_known_login_ips','i_member_id','*USER'),('f_member_known_login_ips','i_val_code','SHORT_TEXT'),('f_moderator_logs','id','*AUTO'),('f_moderator_logs','l_by','USER'),('f_moderator_logs','l_date_and_time','TIME'),('f_moderator_logs','l_param_a','SHORT_TEXT'),('f_moderator_logs','l_param_b','SHORT_TEXT'),('f_moderator_logs','l_reason','LONG_TEXT'),('f_moderator_logs','l_the_type','ID_TEXT'),('f_multi_moderations','id','*AUTO'),('f_multi_moderations','mm_forum_multi_code','SHORT_TEXT'),('f_multi_moderations','mm_move_to','?INTEGER'),('f_multi_moderations','mm_name','*SHORT_TRANS'),('f_multi_moderations','mm_open_state','?BINARY'),('f_multi_moderations','mm_pin_state','?BINARY'),('f_multi_moderations','mm_post_text','LONG_TEXT'),('f_multi_moderations','mm_sink_state','?BINARY'),('f_multi_moderations','mm_title_suffix','SHORT_TEXT'),('f_polls','id','*AUTO'),('f_polls','po_cache_total_votes','INTEGER'),('f_polls','po_is_open','BINARY'),('f_polls','po_is_private','BINARY'),('f_polls','po_maximum_selections','INTEGER'),('f_polls','po_minimum_selections','INTEGER'),('f_polls','po_question','SHORT_TEXT'),('f_polls','po_requires_reply','BINARY'),('f_poll_answers','id','*AUTO'),('f_poll_answers','pa_answer','SHORT_TEXT'),('f_poll_answers','pa_cache_num_votes','INTEGER'),('f_poll_answers','pa_poll_id','AUTO_LINK'),('f_poll_votes','pv_answer_id','*AUTO_LINK'),('f_poll_votes','pv_member_id','*USER'),('f_poll_votes','pv_poll_id','*AUTO_LINK'),('f_posts','id','*AUTO'),('f_posts','p_cache_forum_id','?AUTO_LINK'),('f_posts','p_intended_solely_for','?USER'),('f_posts','p_ip_address','IP'),('f_posts','p_is_emphasised','BINARY'),('f_posts','p_last_edit_by','?USER'),('f_posts','p_last_edit_time','?TIME'),('f_posts','p_post','LONG_TRANS'),('f_posts','p_poster','USER'),('f_posts','p_poster_name_if_guest','ID_TEXT'),('f_posts','p_skip_sig','BINARY'),('f_posts','p_time','TIME'),('f_posts','p_title','SHORT_TEXT'),('f_posts','p_topic_id','AUTO_LINK'),('f_posts','p_validated','BINARY'),('f_post_history','h_action','ID_TEXT'),('f_post_history','h_action_date_and_time','TIME'),('f_post_history','h_alterer_member_id','USER'),('f_post_history','h_before','LONG_TEXT'),('f_post_history','h_create_date_and_time','TIME'),('f_post_history','h_owner_member_id','USER'),('f_post_history','h_post_id','AUTO_LINK'),('f_post_history','h_topic_id','AUTO_LINK'),('f_post_history','id','*AUTO'),('f_post_templates','id','*AUTO'),('f_post_templates','t_forum_multi_code','SHORT_TEXT'),('f_post_templates','t_text','LONG_TEXT'),('f_post_templates','t_title','SHORT_TEXT'),('f_post_templates','t_use_default_forums','BINARY'),('f_read_logs','l_member_id','*USER'),('f_read_logs','l_time','TIME'),('f_read_logs','l_topic_id','*AUTO_LINK'),('f_saved_warnings','s_explanation','LONG_TEXT'),('f_saved_warnings','s_message','LONG_TEXT'),('f_saved_warnings','s_title','*SHORT_TEXT'),('f_special_pt_access','s_member_id','*USER'),('f_special_pt_access','s_topic_id','*AUTO_LINK'),('f_topics','id','*AUTO'),('f_topics','t_cache_first_member_id','?USER'),('f_topics','t_cache_first_post','?LONG_TRANS'),('f_topics','t_cache_first_post_id','?AUTO_LINK'),('f_topics','t_cache_first_time','?TIME'),('f_topics','t_cache_first_title','SHORT_TEXT'),('f_topics','t_cache_first_username','ID_TEXT'),('f_topics','t_cache_last_member_id','?USER'),('f_topics','t_cache_last_post_id','?AUTO_LINK'),('f_topics','t_cache_last_time','?TIME'),('f_topics','t_cache_last_title','SHORT_TEXT'),('f_topics','t_cache_last_username','ID_TEXT'),('f_topics','t_cache_num_posts','INTEGER'),('f_topics','t_cascading','BINARY'),('f_topics','t_description','SHORT_TEXT'),('f_topics','t_description_link','SHORT_TEXT'),('f_topics','t_emoticon','SHORT_TEXT'),('f_topics','t_forum_id','?AUTO_LINK'),('f_topics','t_is_open','BINARY'),('f_topics','t_num_views','INTEGER'),('f_topics','t_pinned','BINARY'),('f_topics','t_poll_id','?AUTO_LINK'),('f_topics','t_pt_from','?USER'),('f_topics','t_pt_from_category','SHORT_TEXT'),('f_topics','t_pt_to','?USER'),('f_topics','t_pt_to_category','SHORT_TEXT'),('f_topics','t_sunk','BINARY'),('f_topics','t_validated','BINARY'),('f_usergroup_subs','id','*AUTO'),('f_usergroup_subs','s_cost','SHORT_TEXT'),('f_usergroup_subs','s_description','LONG_TRANS'),('f_usergroup_subs','s_enabled','BINARY'),('f_usergroup_subs','s_group_id','GROUP'),('f_usergroup_subs','s_length','INTEGER'),('f_usergroup_subs','s_length_units','SHORT_TEXT'),('f_usergroup_subs','s_mail_end','LONG_TRANS'),('f_usergroup_subs','s_mail_start','LONG_TRANS'),('f_usergroup_subs','s_mail_uhoh','LONG_TRANS'),('f_usergroup_subs','s_title','SHORT_TRANS'),('f_usergroup_subs','s_uses_primary','BINARY'),('f_warnings','id','*AUTO'),('f_warnings','p_banned_ip','IP'),('f_warnings','p_banned_member','BINARY'),('f_warnings','p_changed_usergroup_from','?GROUP'),('f_warnings','p_charged_points','INTEGER'),('f_warnings','p_probation','INTEGER'),('f_warnings','p_silence_from_forum','?AUTO_LINK'),('f_warnings','p_silence_from_topic','?AUTO_LINK'),('f_warnings','w_by','USER'),('f_warnings','w_explanation','LONG_TEXT'),('f_warnings','w_is_warning','BINARY'),('f_warnings','w_member_id','USER'),('f_warnings','w_time','TIME'),('f_welcome_emails','id','*AUTO'),('f_welcome_emails','w_name','SHORT_TEXT'),('f_welcome_emails','w_newsletter','BINARY'),('f_welcome_emails','w_send_time','INTEGER'),('f_welcome_emails','w_subject','SHORT_TRANS'),('f_welcome_emails','w_text','LONG_TRANS'),('galleries','accept_images','BINARY'),('galleries','accept_videos','BINARY'),('galleries','add_date','TIME'),('galleries','allow_comments','SHORT_INTEGER'),('galleries','allow_rating','BINARY'),('galleries','description','LONG_TRANS'),('galleries','flow_mode_interface','BINARY'),('galleries','fullname','SHORT_TRANS'),('galleries','is_member_synched','BINARY'),('galleries','name','*ID_TEXT'),('galleries','notes','LONG_TEXT'),('galleries','parent_id','ID_TEXT'),('galleries','rep_image','URLPATH'),('galleries','teaser','SHORT_TRANS'),('galleries','watermark_bottom_left','URLPATH'),('galleries','watermark_bottom_right','URLPATH'),('galleries','watermark_top_left','URLPATH'),('galleries','watermark_top_right','URLPATH'),('gifts','amount','INTEGER'),('gifts','anonymous','BINARY'),('gifts','date_and_time','TIME'),('gifts','gift_from','USER'),('gifts','gift_to','USER'),('gifts','id','*AUTO'),('gifts','reason','SHORT_TRANS'),('group_category_access','category_name','*ID_TEXT'),('group_category_access','group_id','*GROUP'),('group_category_access','module_the_name','*ID_TEXT'),('group_page_access','group_id','*GROUP'),('group_page_access','page_name','*ID_TEXT'),('group_page_access','zone_name','*ID_TEXT'),('group_zone_access','group_id','*GROUP'),('group_zone_access','zone_name','*ID_TEXT'),('gsp','category_name','*ID_TEXT'),('gsp','group_id','*INTEGER'),('gsp','module_the_name','*ID_TEXT'),('gsp','specific_permission','*ID_TEXT'),('gsp','the_page','*ID_TEXT'),('gsp','the_value','BINARY'),('hackattack','data_post','LONG_TEXT'),('hackattack','date_and_time','TIME'),('hackattack','id','*AUTO'),('hackattack','ip','IP'),('hackattack','reason','ID_TEXT'),('hackattack','reason_param_a','SHORT_TEXT'),('hackattack','reason_param_b','SHORT_TEXT'),('hackattack','referer','SHORT_TEXT'),('hackattack','the_user','USER'),('hackattack','url','URLPATH'),('hackattack','user_agent','SHORT_TEXT'),('hackattack','user_os','SHORT_TEXT'),('https_pages','https_page_name','*ID_TEXT'),('images','add_date','TIME'),('images','allow_comments','SHORT_INTEGER'),('images','allow_rating','BINARY'),('images','allow_trackbacks','BINARY'),('images','cat','ID_TEXT'),('images','comments','LONG_TRANS'),('images','edit_date','?TIME'),('images','id','*AUTO'),('images','image_views','INTEGER'),('images','notes','LONG_TEXT'),('images','submitter','USER'),('images','thumb_url','URLPATH'),('images','url','URLPATH'),('images','validated','BINARY'),('import_id_remap','id_new','AUTO_LINK'),('import_id_remap','id_old','*ID_TEXT'),('import_id_remap','id_session','*INTEGER'),('import_id_remap','id_type','*ID_TEXT'),('import_parts_done','imp_id','*SHORT_TEXT'),('import_parts_done','imp_session','*INTEGER'),('import_session','imp_db_name','ID_TEXT'),('import_session','imp_db_table_prefix','ID_TEXT'),('import_session','imp_db_user','ID_TEXT'),('import_session','imp_hook','ID_TEXT'),('import_session','imp_old_base_dir','SHORT_TEXT'),('import_session','imp_refresh_time','INTEGER'),('import_session','imp_session','*INTEGER'),('incoming_uploads','id','*AUTO'),('incoming_uploads','i_date_and_time','TIME'),('incoming_uploads','i_orig_filename','ID_TEXT'),('incoming_uploads','i_save_url','URLPATH'),('incoming_uploads','i_submitter','USER'),('invoices','id','*AUTO'),('invoices','i_amount','SHORT_TEXT'),('invoices','i_member_id','USER'),('invoices','i_note','LONG_TEXT'),('invoices','i_special','SHORT_TEXT'),('invoices','i_state','ID_TEXT'),('invoices','i_time','TIME'),('invoices','i_type_code','ID_TEXT'),('iotd','add_date','TIME'),('iotd','allow_comments','SHORT_INTEGER'),('iotd','allow_rating','BINARY'),('iotd','allow_trackbacks','BINARY'),('iotd','caption','LONG_TRANS'),('iotd','date_and_time','?TIME'),('iotd','edit_date','?TIME'),('iotd','id','*AUTO'),('iotd','iotd_views','INTEGER'),('iotd','is_current','BINARY'),('iotd','i_title','SHORT_TRANS'),('iotd','notes','LONG_TEXT'),('iotd','submitter','USER'),('iotd','thumb_url','URLPATH'),('iotd','url','URLPATH'),('iotd','used','BINARY'),('ip_country','begin_num','UINTEGER'),('ip_country','country','SHORT_TEXT'),('ip_country','end_num','UINTEGER'),('ip_country','id','*AUTO'),('leader_board','date_and_time','*TIME'),('leader_board','lb_member','*USER'),('leader_board','lb_points','INTEGER'),('link_tracker','c_date_and_time','TIME'),('link_tracker','c_ip_address','IP'),('link_tracker','c_member_id','USER'),('link_tracker','c_url','URLPATH'),('link_tracker','id','*AUTO'),('logged_mail_messages','id','*AUTO'),('logged_mail_messages','m_as','USER'),('logged_mail_messages','m_as_admin','BINARY'),('logged_mail_messages','m_attachments','LONG_TEXT'),('logged_mail_messages','m_date_and_time','TIME'),('logged_mail_messages','m_from_email','SHORT_TEXT'),('logged_mail_messages','m_from_name','SHORT_TEXT'),('logged_mail_messages','m_in_html','BINARY'),('logged_mail_messages','m_member_id','USER'),('logged_mail_messages','m_message','LONG_TEXT'),('logged_mail_messages','m_no_cc','BINARY'),('logged_mail_messages','m_priority','SHORT_INTEGER'),('logged_mail_messages','m_queued','BINARY'),('logged_mail_messages','m_subject','SHORT_TEXT'),('logged_mail_messages','m_to_email','LONG_TEXT'),('logged_mail_messages','m_to_name','LONG_TEXT'),('logged_mail_messages','m_url','LONG_TEXT'),('long_values','date_and_time','TIME'),('long_values','the_name','*ID_TEXT'),('long_values','the_value','LONG_TEXT'),('match_key_messages','id','*AUTO'),('match_key_messages','k_match_key','SHORT_TEXT'),('match_key_messages','k_message','LONG_TRANS'),('member_category_access','active_until','*TIME'),('member_category_access','category_name','*ID_TEXT'),('member_category_access','member_id','*USER'),('member_category_access','module_the_name','*ID_TEXT'),('member_page_access','active_until','*TIME'),('member_page_access','member_id','*USER'),('member_page_access','page_name','*ID_TEXT'),('member_page_access','zone_name','*ID_TEXT'),('member_tracking','mt_cache_username','ID_TEXT'),('member_tracking','mt_id','*ID_TEXT'),('member_tracking','mt_member_id','*USER'),('member_tracking','mt_page','*ID_TEXT'),('member_tracking','mt_time','*TIME'),('member_tracking','mt_type','*ID_TEXT'),('member_zone_access','active_until','*TIME'),('member_zone_access','member_id','*USER'),('member_zone_access','zone_name','*ID_TEXT'),('menu_items','id','*AUTO'),('menu_items','i_caption','SHORT_TRANS'),('menu_items','i_caption_long','SHORT_TRANS'),('menu_items','i_check_permissions','BINARY'),('menu_items','i_expanded','BINARY'),('menu_items','i_menu','ID_TEXT'),('menu_items','i_new_window','BINARY'),('menu_items','i_order','INTEGER'),('menu_items','i_page_only','ID_TEXT'),('menu_items','i_parent','?AUTO_LINK'),('menu_items','i_theme_img_code','ID_TEXT'),('menu_items','i_url','SHORT_TEXT'),('messages_to_render','id','*AUTO'),('messages_to_render','r_message','LONG_TEXT'),('messages_to_render','r_session_id','AUTO_LINK'),('messages_to_render','r_time','TIME'),('messages_to_render','r_type','ID_TEXT'),('modules','module_author','ID_TEXT'),('modules','module_hacked_by','ID_TEXT'),('modules','module_hack_version','?INTEGER'),('modules','module_organisation','ID_TEXT'),('modules','module_the_name','*ID_TEXT'),('modules','module_version','INTEGER'),('msp','active_until','*TIME'),('msp','category_name','*ID_TEXT'),('msp','member_id','*INTEGER'),('msp','module_the_name','*ID_TEXT'),('msp','specific_permission','*ID_TEXT'),('msp','the_page','*ID_TEXT'),('msp','the_value','BINARY'),('news','allow_comments','SHORT_INTEGER'),('news','allow_rating','BINARY'),('news','allow_trackbacks','BINARY'),('news','author','ID_TEXT'),('news','date_and_time','TIME'),('news','edit_date','?TIME'),('news','id','*AUTO'),('news','news','LONG_TRANS'),('news','news_article','LONG_TRANS'),('news','news_category','AUTO_LINK'),('news','news_image','URLPATH'),('news','news_views','INTEGER'),('news','notes','LONG_TEXT'),('news','submitter','USER'),('news','title','SHORT_TRANS'),('news','validated','BINARY'),('newsletter','code_confirm','INTEGER'),('newsletter','email','SHORT_TEXT'),('newsletter','id','*AUTO'),('newsletter','join_time','TIME'),('newsletter','language','ID_TEXT'),('newsletter','n_forename','SHORT_TEXT'),('newsletter','n_surname','SHORT_TEXT'),('newsletter','pass_salt','ID_TEXT'),('newsletter','the_password','MD5'),('newsletters','description','LONG_TRANS'),('newsletters','id','*AUTO'),('newsletters','title','SHORT_TRANS'),('newsletter_archive','date_and_time','INTEGER'),('newsletter_archive','id','*AUTO'),('newsletter_archive','importance_level','INTEGER'),('newsletter_archive','language','ID_TEXT'),('newsletter_archive','newsletter','LONG_TEXT'),('newsletter_archive','subject','SHORT_TEXT'),('newsletter_drip_send','d_from_email','SHORT_TEXT'),('newsletter_drip_send','d_from_name','SHORT_TEXT'),('newsletter_drip_send','d_html_only','BINARY'),('newsletter_drip_send','d_inject_time','TIME'),('newsletter_drip_send','d_message','LONG_TEXT'),('newsletter_drip_send','d_priority','SHORT_INTEGER'),('newsletter_drip_send','d_subject','SHORT_TEXT'),('newsletter_drip_send','d_to_email','SHORT_TEXT'),('newsletter_drip_send','d_to_name','SHORT_TEXT'),('newsletter_drip_send','id','*AUTO'),('newsletter_subscribe','email','*SHORT_TEXT'),('newsletter_subscribe','newsletter_id','*AUTO_LINK'),('newsletter_subscribe','the_level','SHORT_INTEGER'),('news_categories','id','*AUTO'),('news_categories','nc_img','ID_TEXT'),('news_categories','nc_owner','?USER'),('news_categories','nc_title','SHORT_TRANS'),('news_categories','notes','LONG_TEXT'),('news_category_entries','news_entry','*AUTO_LINK'),('news_category_entries','news_entry_category','*AUTO_LINK'),('news_rss_cloud','id','*AUTO'),('news_rss_cloud','register_time','TIME'),('news_rss_cloud','rem_ip','IP'),('news_rss_cloud','rem_path','SHORT_TEXT'),('news_rss_cloud','rem_port','SHORT_INTEGER'),('news_rss_cloud','rem_procedure','ID_TEXT'),('news_rss_cloud','rem_protocol','ID_TEXT'),('news_rss_cloud','watching_channel','URLPATH'),('occlechat','c_incoming','BINARY'),('occlechat','c_message','LONG_TEXT'),('occlechat','c_timestamp','TIME'),('occlechat','c_url','URLPATH'),('occlechat','id','*AUTO'),('poll','add_time','INTEGER'),('poll','allow_comments','SHORT_INTEGER'),('poll','allow_rating','BINARY'),('poll','allow_trackbacks','BINARY'),('poll','date_and_time','?TIME'),('poll','edit_date','?TIME'),('poll','id','*AUTO'),('quiz_questions','q_order','INTEGER'),('poll','is_current','BINARY'),('poll','notes','LONG_TEXT'),('poll','num_options','SHORT_INTEGER'),('poll','option1','SHORT_TRANS'),('poll','option10','?SHORT_TRANS'),('poll','option2','SHORT_TRANS'),('poll','option3','?SHORT_TRANS'),('poll','option4','?SHORT_TRANS'),('poll','option5','?SHORT_TRANS'),('poll','option6','SHORT_TRANS'),('poll','option7','SHORT_TRANS'),('poll','option8','?SHORT_TRANS'),('poll','option9','?SHORT_TRANS'),('poll','poll_views','INTEGER'),('poll','question','SHORT_TRANS'),('poll','submitter','USER'),('poll','votes1','INTEGER'),('poll','votes10','INTEGER'),('poll','votes2','INTEGER'),('poll','votes3','INTEGER'),('poll','votes4','INTEGER'),('poll','votes5','INTEGER'),('poll','votes6','INTEGER'),('poll','votes7','INTEGER'),('poll','votes8','INTEGER'),('poll','votes9','INTEGER'),('prices','name','*ID_TEXT'),('prices','price','INTEGER'),('pstore_customs','c_cost','INTEGER'),('pstore_customs','c_description','LONG_TRANS'),('pstore_customs','c_enabled','BINARY'),('pstore_customs','c_one_per_member','BINARY'),('pstore_customs','c_title','SHORT_TRANS'),('pstore_customs','id','*AUTO'),('pstore_permissions','id','*AUTO'),('pstore_permissions','p_category','ID_TEXT'),('pstore_permissions','p_cost','INTEGER'),('pstore_permissions','p_description','LONG_TRANS'),('pstore_permissions','p_enabled','BINARY'),('pstore_permissions','p_hours','INTEGER'),('pstore_permissions','p_module','ID_TEXT'),('pstore_permissions','p_page','ID_TEXT'),('pstore_permissions','p_specific_permission','ID_TEXT'),('pstore_permissions','p_title','SHORT_TRANS'),('pstore_permissions','p_type','ID_TEXT'),('pstore_permissions','p_zone','ID_TEXT'),('quizzes','id','*AUTO'),('quizzes','q_add_date','TIME'),('quizzes','q_close_time','?TIME'),('quizzes','q_end_text','LONG_TRANS'),('quizzes','q_name','SHORT_TRANS'),('quizzes','q_notes','LONG_TEXT'),('quizzes','q_num_winners','INTEGER'),('quizzes','q_open_time','TIME'),('quizzes','q_percentage','INTEGER'),('quizzes','q_points_for_passing','INTEGER'),('quizzes','q_redo_time','?INTEGER'),('quizzes','q_start_text','LONG_TRANS'),('quizzes','q_submitter','USER'),('quizzes','q_tied_newsletter','?AUTO_LINK'),('quizzes','q_timeout','?INTEGER'),('quizzes','q_type','ID_TEXT'),('quizzes','q_validated','BINARY'),('quiz_entries','id','*AUTO'),('quiz_entries','q_member','USER'),('quiz_entries','q_quiz','AUTO_LINK'),('quiz_entries','q_results','INTEGER'),('quiz_entries','q_time','TIME'),('quiz_entry_answer','id','*AUTO'),('quiz_entry_answer','q_answer','LONG_TEXT'),('quiz_entry_answer','q_entry','AUTO_LINK'),('quiz_entry_answer','q_question','AUTO_LINK'),('quiz_member_last_visit','id','*AUTO'),('quiz_member_last_visit','v_member_id','USER'),('quiz_member_last_visit','v_time','TIME'),('quiz_questions','id','*AUTO'),('quiz_questions','q_long_input_field','BINARY'),('quiz_questions','q_num_choosable_answers','INTEGER'),('quiz_questions','q_question_text','LONG_TRANS'),('quiz_questions','q_quiz','AUTO_LINK'),('quiz_question_answers','id','*AUTO'),('quiz_question_answers','q_answer_text','SHORT_TRANS'),('quiz_question_answers','q_is_correct','BINARY'),('quiz_question_answers','q_question','AUTO_LINK'),('quiz_winner','q_entry','*AUTO_LINK'),('quiz_winner','q_quiz','*AUTO_LINK'),('quiz_winner','q_winner_level','INTEGER'),('rating','id','*AUTO'),('rating','rating','SHORT_INTEGER'),('rating','rating_for_id','ID_TEXT'),('rating','rating_for_type','ID_TEXT'),('rating','rating_ip','IP'),('rating','rating_member','USER'),('rating','rating_time','TIME'),('redirects','r_from_page','*ID_TEXT'),('redirects','r_from_zone','*ID_TEXT'),('redirects','r_is_transparent','BINARY'),('redirects','r_to_page','ID_TEXT'),('redirects','r_to_zone','ID_TEXT'),('review_supplement','r_post_id','*AUTO_LINK'),('review_supplement','r_rating','SHORT_INTEGER'),('review_supplement','r_rating_for_id','ID_TEXT'),('review_supplement','r_rating_for_type','ID_TEXT'),('review_supplement','r_rating_type','*ID_TEXT'),('review_supplement','r_topic_id','AUTO_LINK'),('sales','date_and_time','TIME'),('sales','details','SHORT_TEXT'),('sales','details2','SHORT_TEXT'),('sales','id','*AUTO'),('sales','memberid','USER'),('sales','purchasetype','ID_TEXT'),('searches_logged','id','*AUTO'),('searches_logged','s_auxillary','LONG_TEXT'),('searches_logged','s_member_id','USER'),('searches_logged','s_num_results','INTEGER'),('searches_logged','s_primary','SHORT_TEXT'),('searches_logged','s_time','TIME'),('searches_saved','id','*AUTO'),('searches_saved','s_auxillary','LONG_TEXT'),('searches_saved','s_member_id','USER'),('searches_saved','s_primary','SHORT_TEXT'),('searches_saved','s_time','TIME'),('searches_saved','s_title','SHORT_TEXT'),('security_images','si_code','INTEGER'),('security_images','si_session_id','*INTEGER'),('security_images','si_time','TIME'),('seedy_changes','date_and_time','TIME'),('seedy_changes','id','*AUTO'),('seedy_changes','ip','IP'),('seedy_changes','the_action','ID_TEXT'),('seedy_changes','the_page','AUTO_LINK'),('seedy_changes','the_user','USER'),('seedy_children','child_id','*AUTO_LINK'),('seedy_children','parent_id','*AUTO_LINK'),('seedy_children','the_order','SHORT_INTEGER'),('seedy_children','title','SHORT_TEXT'),('seedy_pages','add_date','TIME'),('seedy_pages','description','LONG_TRANS'),('seedy_pages','hide_posts','BINARY'),('seedy_pages','id','*AUTO'),('seedy_pages','notes','LONG_TEXT'),('seedy_pages','seedy_views','INTEGER'),('seedy_pages','submitter','USER'),('seedy_pages','title','SHORT_TRANS'),('seedy_posts','date_and_time','TIME'),('seedy_posts','edit_date','?TIME'),('seedy_posts','id','*AUTO'),('seedy_posts','page_id','AUTO_LINK'),('seedy_posts','seedy_views','INTEGER'),('seedy_posts','the_message','LONG_TRANS'),('seedy_posts','the_user','USER'),('seedy_posts','validated','BINARY'),('seo_meta','id','*AUTO'),('seo_meta','meta_description','LONG_TRANS'),('seo_meta','meta_for_id','ID_TEXT'),('seo_meta','meta_for_type','ID_TEXT'),('seo_meta','meta_keywords','LONG_TRANS'),('sessions','cache_username','SHORT_TEXT'),('sessions','ip','IP'),('sessions','last_activity','TIME'),('sessions','session_confirmed','BINARY'),('sessions','session_invisible','BINARY'),('sessions','the_id','ID_TEXT'),('sessions','the_page','ID_TEXT'),('sessions','the_session','*INTEGER'),('sessions','the_title','SHORT_TEXT'),('sessions','the_type','ID_TEXT'),('sessions','the_user','USER'),('sessions','the_zone','ID_TEXT'),('shopping_cart','id','*AUTO'),('shopping_cart','is_deleted','BINARY'),('shopping_cart','ordered_by','*AUTO_LINK'),('shopping_cart','price','REAL'),('shopping_cart','price_pre_tax','REAL'),('shopping_cart','product_code','SHORT_TEXT'),('shopping_cart','product_description','LONG_TEXT'),('shopping_cart','product_id','*AUTO_LINK'),('shopping_cart','product_name','SHORT_TEXT'),('shopping_cart','product_type','SHORT_TEXT'),('shopping_cart','product_weight','REAL'),('shopping_cart','quantity','INTEGER'),('shopping_cart','session_id','INTEGER'),('shopping_logging','date_and_time','TIME'),('shopping_logging','e_member_id','*USER'),('shopping_logging','id','*AUTO'),('shopping_logging','ip','IP'),('shopping_logging','last_action','SHORT_TEXT'),('shopping_logging','session_id','INTEGER'),('shopping_order','add_date','TIME'),('shopping_order','c_member','INTEGER'),('shopping_order','id','*AUTO'),('shopping_order','notes','LONG_TEXT'),('shopping_order','order_status','ID_TEXT'),('shopping_order','purchase_through','SHORT_TEXT'),('shopping_order','session_id','INTEGER'),('shopping_order','tax_opted_out','BINARY'),('shopping_order','tot_price','REAL'),('shopping_order','transaction_id','SHORT_TEXT'),('shopping_order_addresses','address_city','SHORT_TEXT'),('shopping_order_addresses','address_country','SHORT_TEXT'),('shopping_order_addresses','address_name','SHORT_TEXT'),('shopping_order_addresses','address_street','LONG_TEXT'),('shopping_order_addresses','address_zip','SHORT_TEXT'),('shopping_order_addresses','id','*AUTO'),('shopping_order_addresses','order_id','?AUTO_LINK'),('shopping_order_addresses','receiver_email','SHORT_TEXT'),('shopping_order_details','dispatch_status','SHORT_TEXT'),('shopping_order_details','id','*AUTO'),('shopping_order_details','included_tax','REAL'),('shopping_order_details','order_id','?AUTO_LINK'),('shopping_order_details','p_code','SHORT_TEXT'),('shopping_order_details','p_id','?AUTO_LINK'),('shopping_order_details','p_name','SHORT_TEXT'),('shopping_order_details','p_price','REAL'),('shopping_order_details','p_quantity','INTEGER'),('shopping_order_details','p_type','SHORT_TEXT'),('sms_log','id','*AUTO'),('sms_log','s_member_id','USER'),('sms_log','s_time','TIME'),('sms_log','s_trigger_ip','IP'),('sp_list','p_section','ID_TEXT'),('sp_list','the_default','*BINARY'),('sp_list','the_name','*ID_TEXT'),('staff_tips_dismissed','t_member','*USER'),('staff_tips_dismissed','t_tip','*ID_TEXT'),('stats','access_denied_counter','INTEGER'),('stats','browser','SHORT_TEXT'),('stats','date_and_time','TIME'),('stats','get','URLPATH'),('stats','id','*AUTO'),('stats','ip','IP'),('stats','milliseconds','INTEGER'),('stats','operating_system','SHORT_TEXT'),('stats','post','LONG_TEXT'),('stats','referer','URLPATH'),('stats','the_page','SHORT_TEXT'),('stats','the_user','USER'),('subscriptions','id','*AUTO'),('subscriptions','s_amount','SHORT_TEXT'),('subscriptions','s_auto_fund_key','SHORT_TEXT'),('subscriptions','s_auto_fund_source','ID_TEXT'),('subscriptions','s_member_id','USER'),('subscriptions','s_special','SHORT_TEXT'),('subscriptions','s_state','ID_TEXT'),('subscriptions','s_time','TIME'),('subscriptions','s_type_code','ID_TEXT'),('subscriptions','s_via','ID_TEXT'),('tests','id','*AUTO'),('tests','t_assigned_to','?USER'),('tests','t_enabled','BINARY'),('tests','t_inherit_section','?AUTO_LINK'),('tests','t_section','AUTO_LINK'),('tests','t_status','INTEGER'),('tests','t_test','LONG_TEXT'),('test_sections','id','*AUTO'),('test_sections','s_assigned_to','?USER'),('test_sections','s_inheritable','BINARY'),('test_sections','s_notes','LONG_TEXT'),('test_sections','s_section','SHORT_TEXT'),('text','activation_time','?TIME'),('text','active_now','BINARY'),('text','days','SHORT_INTEGER'),('text','id','*AUTO'),('text','notes','LONG_TEXT'),('text','order_time','TIME'),('text','the_message','SHORT_TRANS'),('text','user_id','USER'),('theme_images','id','*SHORT_TEXT'),('theme_images','lang','*LANGUAGE_NAME'),('theme_images','path','URLPATH'),('theme_images','theme','*MINIID_TEXT'),('tickets','forum_id','AUTO_LINK'),('tickets','ticket_id','*SHORT_TEXT'),('tickets','ticket_type','SHORT_TRANS'),('tickets','topic_id','AUTO_LINK'),('ticket_types','cache_lead_time','?TIME'),('ticket_types','guest_emails_mandatory','BINARY'),('ticket_types','search_faq','BINARY'),('feature_lifetime_monitor','content_id','*ID_TEXT'),('ticket_types','ticket_type','*SHORT_TRANS'),('trackbacks','id','*AUTO'),('trackbacks','trackback_excerpt','LONG_TEXT'),('trackbacks','trackback_for_id','ID_TEXT'),('trackbacks','trackback_for_type','ID_TEXT'),('trackbacks','trackback_ip','IP'),('trackbacks','trackback_name','SHORT_TEXT'),('trackbacks','trackback_time','TIME'),('trackbacks','trackback_title','SHORT_TEXT'),('trackbacks','trackback_url','SHORT_TEXT'),('temp_block_permissions','p_session_id','AUTO_LINK'),('temp_block_permissions','id','*AUTO'),('logged_mail_messages','m_template','ID_TEXT'),('transactions','amount','SHORT_TEXT'),('transactions','id','*ID_TEXT'),('transactions','item','SHORT_TEXT'),('transactions','linked','ID_TEXT'),('transactions','pending_reason','SHORT_TEXT'),('transactions','purchase_id','ID_TEXT'),('transactions','reason','SHORT_TEXT'),('transactions','status','SHORT_TEXT'),('transactions','t_currency','ID_TEXT'),('transactions','t_memo','LONG_TEXT'),('transactions','t_time','*TIME'),('transactions','t_via','ID_TEXT'),('translate','broken','BINARY'),('translate','id','*AUTO'),('translate','importance_level','SHORT_INTEGER'),('translate','language','*LANGUAGE_NAME'),('translate','source_user','USER'),('translate','text_original','LONG_TEXT'),('translate','text_parsed','LONG_TEXT'),('translate_history','action_member','USER'),('translate_history','action_time','TIME'),('translate_history','broken','BINARY'),('translate_history','id','*AUTO'),('translate_history','language','*LANGUAGE_NAME'),('translate_history','lang_id','AUTO_LINK'),('translate_history','text_original','LONG_TEXT'),('trans_expecting','e_amount','SHORT_TEXT'),('trans_expecting','e_ip_address','IP'),('trans_expecting','e_item_name','SHORT_TEXT'),('trans_expecting','e_length','?INTEGER'),('trans_expecting','e_length_units','ID_TEXT'),('trans_expecting','e_member_id','USER'),('trans_expecting','e_purchase_id','ID_TEXT'),('trans_expecting','e_session_id','INTEGER'),('trans_expecting','e_time','TIME'),('trans_expecting','id','*ID_TEXT'),('tutorial_links','the_name','*ID_TEXT'),('tutorial_links','the_value','LONG_TEXT'),('url_id_monikers','id','*AUTO'),('url_id_monikers','m_deprecated','BINARY'),('url_id_monikers','m_moniker','SHORT_TEXT'),('url_id_monikers','m_resource_id','ID_TEXT'),('url_id_monikers','m_resource_page','ID_TEXT'),('url_id_monikers','m_resource_type','ID_TEXT'),('url_title_cache','t_title','SHORT_TEXT'),('url_title_cache','t_url','*URLPATH'),('usersonline_track','date_and_time','*TIME'),('usersonline_track','peak','INTEGER'),('usersubmitban_ip','ip','*IP'),('usersubmitban_ip','i_descrip','LONG_TEXT'),('usersubmitban_member','the_member','*USER'),('validated_once','hash','*MD5'),('values','date_and_time','TIME'),('values','the_name','*ID_TEXT'),('values','the_value','ID_TEXT'),('videos','add_date','TIME'),('videos','allow_comments','SHORT_INTEGER'),('videos','allow_rating','BINARY'),('videos','allow_trackbacks','BINARY'),('videos','cat','ID_TEXT'),('videos','comments','LONG_TRANS'),('videos','edit_date','?TIME'),('videos','id','*AUTO'),('videos','notes','LONG_TEXT'),('videos','submitter','USER'),('videos','thumb_url','URLPATH'),('videos','url','URLPATH'),('videos','validated','BINARY'),('videos','video_height','INTEGER'),('videos','video_length','INTEGER'),('videos','video_views','INTEGER'),('videos','video_width','INTEGER'),('wordfilter','word','*SHORT_TEXT'),('wordfilter','w_replacement','SHORT_TEXT'),('wordfilter','w_substr','*BINARY'),('zones','zone_default_page','ID_TEXT'),('zones','zone_displayed_in_menu','BINARY'),('zones','zone_header_text','SHORT_TRANS'),('zones','zone_name','*ID_TEXT'),('zones','zone_require_session','BINARY'),('zones','zone_theme','ID_TEXT'),('zones','zone_title','SHORT_TRANS'),('zones','zone_wide','?BINARY'),('cache','lang','*LANGUAGE_NAME'),('cache','langs_required','LONG_TEXT'),('f_group_member_timeouts','member_id','*USER'),('f_group_member_timeouts','group_id','*GROUP'),('f_group_member_timeouts','timeout','TIME'),('temp_block_permissions','p_block_constraints','LONG_TEXT'),('temp_block_permissions','p_time','TIME'),('cron_caching_requests','id','*AUTO'),('cron_caching_requests','c_codename','ID_TEXT'),('cron_caching_requests','c_map','LONG_TEXT'),('cron_caching_requests','c_timezone','ID_TEXT'),('cron_caching_requests','c_is_bot','BINARY'),('banners','b_direct_code','LONG_TEXT'),('calendar_events','e_start_monthly_spec_type','ID_TEXT'),('cron_caching_requests','c_store_as_tempcode','BINARY'),('cron_caching_requests','c_lang','LANGUAGE_NAME'),('cron_caching_requests','c_theme','ID_TEXT'),('notifications_enabled','id','*AUTO'),('notifications_enabled','l_member_id','USER'),('notifications_enabled','l_notification_code','ID_TEXT'),('notifications_enabled','l_code_category','SHORT_TEXT'),('notifications_enabled','l_setting','INTEGER'),('digestives_tin','id','*AUTO'),('digestives_tin','d_subject','LONG_TEXT'),('digestives_tin','d_message','LONG_TEXT'),('digestives_tin','d_from_member_id','?USER'),('digestives_tin','d_to_member_id','USER'),('digestives_tin','d_priority','SHORT_INTEGER'),('digestives_tin','d_no_cc','BINARY'),('digestives_tin','d_date_and_time','TIME'),('digestives_tin','d_notification_code','ID_TEXT'),('digestives_tin','d_code_category','SHORT_TEXT'),('digestives_tin','d_frequency','INTEGER'),('digestives_consumed','c_member_id','*USER'),('digestives_consumed','c_frequency','*INTEGER'),('digestives_consumed','c_time','TIME'),('notification_lockdown','l_notification_code','*ID_TEXT'),('notification_lockdown','l_setting','INTEGER'),('calendar_types','t_external_feed','URLPATH'),('catalogue_entry_linkage','catalogue_entry_id','*AUTO_LINK'),('catalogue_entry_linkage','content_type','ID_TEXT'),('catalogue_entry_linkage','content_id','ID_TEXT'),('catalogue_cat_treecache','cc_id','*AUTO_LINK'),('catalogue_cat_treecache','cc_ancestor_id','*AUTO_LINK'),('catalogue_childcountcache','cc_id','*AUTO_LINK'),('catalogue_childcountcache','c_num_rec_children','INTEGER'),('catalogue_childcountcache','c_num_rec_entries','INTEGER'),('catalogue_efv_float','id','*AUTO'),('catalogue_efv_float','cf_id','AUTO_LINK'),('catalogue_efv_float','ce_id','AUTO_LINK'),('catalogue_efv_float','cv_value','?REAL'),('catalogue_efv_integer','id','*AUTO'),('catalogue_efv_integer','cf_id','AUTO_LINK'),('catalogue_efv_integer','ce_id','AUTO_LINK'),('catalogue_efv_integer','cv_value','?INTEGER'),('video_transcoding','t_id','*ID_TEXT'),('video_transcoding','t_error','LONG_TEXT'),('video_transcoding','t_url','URLPATH'),('video_transcoding','t_table','ID_TEXT'),('video_transcoding','t_url_field','ID_TEXT'),('video_transcoding','t_orig_filename_field','ID_TEXT'),('video_transcoding','t_width_field','ID_TEXT'),('video_transcoding','t_height_field','ID_TEXT'),('video_transcoding','t_output_filename','ID_TEXT'),('videos','title','SHORT_TRANS'),('images','title','SHORT_TRANS'),('galleries','gallery_views','INTEGER'),('galleries','g_owner','?USER'),('newsletter_periodic','id','*AUTO'),('newsletter_periodic','np_message','LONG_TEXT'),('newsletter_periodic','np_subject','LONG_TEXT'),('newsletter_periodic','np_lang','LANGUAGE_NAME'),('newsletter_periodic','np_send_details','LONG_TEXT'),('newsletter_periodic','np_html_only','BINARY'),('newsletter_periodic','np_from_email','SHORT_TEXT'),('newsletter_periodic','np_from_name','SHORT_TEXT'),('newsletter_periodic','np_priority','SHORT_INTEGER'),('newsletter_periodic','np_csv_data','LONG_TEXT'),('newsletter_periodic','np_frequency','SHORT_TEXT'),('newsletter_periodic','np_day','SHORT_INTEGER'),('newsletter_periodic','np_in_full','BINARY'),('newsletter_periodic','np_template','ID_TEXT'),('newsletter_periodic','np_last_sent','TIME'),('newsletter_drip_send','d_template','ID_TEXT'),('poll_votes','id','*AUTO'),('poll_votes','v_poll_id','AUTO_LINK'),('poll_votes','v_voter_id','?USER'),('poll_votes','v_voter_ip','IP'),('poll_votes','v_vote_for','?SHORT_INTEGER'),('quiz_question_answers','q_order','INTEGER'),('quiz_member_last_visit','v_quiz_id','AUTO_LINK'),('quizzes','q_end_text_fail','LONG_TRANS'),('quiz_question_answers','q_explanation','LONG_TRANS'),('quiz_questions','q_required','BINARY'),('feature_lifetime_monitor','block_cache_id','*ID_TEXT'),('feature_lifetime_monitor','run_period','INTEGER'),('feature_lifetime_monitor','running_now','BINARY'),('feature_lifetime_monitor','last_update','TIME'),('customtasks','id','*AUTO'),('customtasks','tasktitle','SHORT_TEXT'),('customtasks','datetimeadded','TIME'),('customtasks','recurinterval','INTEGER'),('customtasks','recurevery','ID_TEXT'),('customtasks','taskisdone','?TIME'),('sitewatchlist','id','*AUTO'),('sitewatchlist','siteurl','URLPATH'),('sitewatchlist','site_name','SHORT_TEXT'),('cached_weather_codes','id','*AUTO'),('cached_weather_codes','w_string','SHORT_TEXT'),('cached_weather_codes','w_code','INTEGER'),('stafflinks','id','*AUTO'),('stafflinks','link','URLPATH'),('stafflinks','link_title','SHORT_TEXT'),('stafflinks','link_desc','LONG_TEXT'),('f_members','m_allow_emails_from_staff','BINARY'),('f_custom_fields','cf_show_on_join_form','BINARY'),('f_forums','f_is_threaded','BINARY'),('f_posts','p_parent_id','?AUTO_LINK'),('calendar_events','e_end_monthly_spec_type','ID_TEXT'),('pstore_permissions','p_mail_subject','SHORT_TRANS'),('pstore_permissions','p_mail_body','LONG_TRANS'),('pstore_customs','c_mail_subject','SHORT_TRANS'),('pstore_customs','c_mail_body','LONG_TRANS'),('usersubmitban_ip','i_ban_until','?TIME'),('usersubmitban_ip','i_ban_positive','BINARY');
/*!40000 ALTER TABLE `cms_db_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_db_meta_indices`
--

DROP TABLE IF EXISTS `cms_db_meta_indices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_db_meta_indices` (
  `i_table` varchar(80) NOT NULL,
  `i_name` varchar(80) NOT NULL,
  `i_fields` varchar(80) NOT NULL,
  PRIMARY KEY  (`i_table`,`i_name`,`i_fields`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_db_meta_indices`
--

LOCK TABLES `cms_db_meta_indices` WRITE;
/*!40000 ALTER TABLE `cms_db_meta_indices` DISABLE KEYS */;
INSERT INTO `cms_db_meta_indices` VALUES ('banner_clicks','clicker_ip','c_ip_address'),('cache','cached_ford','date_and_time'),('cache','cached_fore','cached_for'),('cache','cached_forf','lang'),('cache','cached_forg','identifier'),('cache','cached_forh','the_theme'),('catalogue_categories','cc_parent_id','cc_parent_id'),('catalogue_cat_treecache','cc_ancestor_id','cc_ancestor_id'),('catalogue_efv_float','cefv_f_combo','ce_id,cf_id'),('catalogue_efv_float','fce_id','ce_id'),('catalogue_efv_float','fcf_id','cf_id'),('catalogue_efv_float','fcv_value','cv_value'),('catalogue_efv_integer','cefv_i_combo','ce_id,cf_id'),('catalogue_efv_integer','ice_id','ce_id'),('catalogue_efv_integer','icf_id','cf_id'),('catalogue_efv_integer','itv_value','cv_value'),('catalogue_efv_long','#lcv_value','cv_value'),('catalogue_efv_long','cefv_l_combo','ce_id,cf_id'),('catalogue_efv_long','lce_id','ce_id'),('catalogue_efv_long','lcf_id','cf_id'),('catalogue_efv_long_trans','cefv_lt_combo','ce_id,cf_id'),('catalogue_efv_long_trans','ltce_id','ce_id'),('catalogue_efv_long_trans','ltcf_id','cf_id'),('catalogue_efv_short','#scv_value','cv_value'),('catalogue_efv_short','cefv_s_combo','ce_id,cf_id'),('catalogue_efv_short','iscv_value','cv_value'),('catalogue_efv_short','sce_id','ce_id'),('catalogue_efv_short','scf_id','cf_id'),('catalogue_efv_short_trans','cefv_st_combo','ce_id,cf_id'),('catalogue_efv_short_trans','stce_id','ce_id'),('catalogue_efv_short_trans','stcf_id','cf_id'),('catalogue_entries','ce_add_date','ce_add_date'),('catalogue_entries','ce_cc_id','cc_id'),('catalogue_entries','ce_c_name','c_name'),('catalogue_entry_linkage','custom_fields','content_type,content_id'),('chat_active','active_ordering','date_and_time'),('chat_active','member_select','member_id'),('chat_active','room_select','room_id'),('chat_events','event_ordering','e_date_and_time'),('chat_messages','Ordering','date_and_time'),('cron_caching_requests','c_compound','c_codename,c_theme,c_lang,c_timezone'),('cron_caching_requests','c_is_bot','c_is_bot'),('cron_caching_requests','c_store_as_tempcode','c_store_as_tempcode'),('digestives_tin','d_date_and_time','d_date_and_time'),('digestives_tin','d_frequency','d_frequency'),('digestives_tin','d_to_member_id','d_to_member_id'),('download_categories','child_find','parent_id'),('download_downloads','#download_data_mash','download_data_mash'),('download_downloads','#original_filename','original_filename'),('download_downloads','category_list','category_id'),('download_downloads','recent_downloads','add_date'),('download_downloads','top_downloads','num_downloads'),('download_logging','calculate_bandwidth','date_and_time'),('f_forums','subforum_parenting','f_parent_forum'),('f_group_members','gm_validated','gm_validated'),('f_members','#search_user','m_username'),('f_members','birthdays','m_dob_day,m_dob_month'),('f_members','sort_post_count','m_cache_num_posts'),('f_members','user_list','m_username'),('f_members','whos_validated','m_validated'),('f_member_custom_fields','#mcf10','field_10'),('f_member_custom_fields','#mcf13','field_13'),('f_member_custom_fields','#mcf14','field_14'),('f_member_custom_fields','#mcf15','field_15'),('f_member_custom_fields','#mcf17','field_17'),('f_member_custom_fields','#mcf18','field_18'),('f_member_custom_fields','#mcf19','field_19'),('f_member_custom_fields','#mcf2','field_2'),('f_member_custom_fields','#mcf20','field_20'),('f_member_custom_fields','#mcf21','field_21'),('f_member_custom_fields','#mcf22','field_22'),('f_member_custom_fields','#mcf23','field_23'),('f_member_custom_fields','#mcf24','field_24'),('f_member_custom_fields','#mcf25','field_25'),('f_member_custom_fields','#mcf26','field_26'),('f_member_custom_fields','#mcf27','field_27'),('f_member_custom_fields','#mcf3','field_3'),('f_member_custom_fields','#mcf33','field_33'),('f_member_custom_fields','#mcf34','field_34'),('f_member_custom_fields','#mcf35','field_35'),('f_member_custom_fields','#mcf4','field_4'),('f_member_custom_fields','#mcf5','field_5'),('f_member_custom_fields','#mcf7','field_7'),('f_member_custom_fields','#mcf8','field_8'),('f_posts','#p_title','p_title'),('f_posts','find_pp','p_intended_solely_for'),('f_posts','in_topic','p_topic_id'),('f_posts','posts_by','p_poster'),('f_posts','post_order_time','p_time'),('f_post_history','phistorylookup','h_post_id'),('f_read_logs','erase_old_read_logs','l_time'),('f_topics','#t_description','t_description'),('f_topics','in_forum','t_forum_id'),('f_topics','topic_order_time','t_cache_last_time'),('f_warnings','warningsmemberid','w_member_id'),('galleries','ftjoin_gdescrip','description'),('galleries','ftjoin_gfullname','fullname'),('images','category_list','cat'),('images','ftjoin_icomments','comments'),('images','i_validated','validated'),('iotd','get_current','is_current'),('news','headlines','date_and_time'),('newsletter_drip_send','d_inject_time','d_inject_time'),('notifications_enabled','l_code_category','l_code_category'),('notifications_enabled','l_member_id','l_member_id,l_notification_code'),('poll','get_current','is_current'),('poll_votes','v_voter_id','v_voter_id'),('poll_votes','v_voter_ip','v_voter_ip'),('poll_votes','v_vote_for','v_vote_for'),('rating','alt_key','rating_for_type,rating_for_id'),('review_supplement','rating_for_id','r_rating_for_id'),('searches_logged','#past_search_ft','s_primary'),('searches_logged','past_search','s_primary'),('seedy_posts','posts_on_page','page_id'),('seo_meta','alt_key','meta_for_type,meta_for_id'),('sessions','delete_old','last_activity'),('shopping_logging','calculate_bandwidth','date_and_time'),('shopping_order','recent_shopped','add_date'),('sms_log','sms_log_for','s_member_id,s_time'),('sms_log','sms_trigger_ip','s_trigger_ip'),('stats','member_track','ip,the_user'),('stats','pages','the_page'),('translate','#search','text_original'),('translate','decache','text_parsed(2)'),('translate','equiv_lang','text_original(4)'),('url_id_monikers','uim_moniker','m_moniker'),('url_id_monikers','uim_pagelink','m_resource_page,m_resource_type,m_resource_id'),('usersonline_track','peak_track','peak'),('videos','category_list','cat'),('videos','ftjoin_vcomments','comments');
/*!40000 ALTER TABLE `cms_db_meta_indices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_digestives_consumed`
--

DROP TABLE IF EXISTS `cms_digestives_consumed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_digestives_consumed` (
  `c_member_id` int(11) NOT NULL,
  `c_frequency` int(11) NOT NULL,
  `c_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`c_member_id`,`c_frequency`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_digestives_consumed`
--

LOCK TABLES `cms_digestives_consumed` WRITE;
/*!40000 ALTER TABLE `cms_digestives_consumed` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_digestives_consumed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_digestives_tin`
--

DROP TABLE IF EXISTS `cms_digestives_tin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_digestives_tin` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `d_subject` longtext NOT NULL,
  `d_message` longtext NOT NULL,
  `d_from_member_id` int(11) default NULL,
  `d_to_member_id` int(11) NOT NULL,
  `d_priority` tinyint(4) NOT NULL,
  `d_no_cc` tinyint(1) NOT NULL,
  `d_date_and_time` int(10) unsigned NOT NULL,
  `d_notification_code` varchar(80) NOT NULL,
  `d_code_category` varchar(255) NOT NULL,
  `d_frequency` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `d_date_and_time` (`d_date_and_time`),
  KEY `d_frequency` (`d_frequency`),
  KEY `d_to_member_id` (`d_to_member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_digestives_tin`
--

LOCK TABLES `cms_digestives_tin` WRITE;
/*!40000 ALTER TABLE `cms_digestives_tin` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_digestives_tin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_download_categories`
--

DROP TABLE IF EXISTS `cms_download_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_download_categories` (
  `add_date` int(10) unsigned NOT NULL,
  `category` int(10) unsigned NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  `parent_id` int(11) default NULL,
  `rep_image` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `child_find` (`parent_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_download_categories`
--

LOCK TABLES `cms_download_categories` WRITE;
/*!40000 ALTER TABLE `cms_download_categories` DISABLE KEYS */;
INSERT INTO `cms_download_categories` VALUES (1264606828,319,320,1,'',NULL,''),(1264672260,602,603,2,'',1,''),(1264672321,606,607,3,'',2,'');
/*!40000 ALTER TABLE `cms_download_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_download_downloads`
--

DROP TABLE IF EXISTS `cms_download_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_download_downloads` (
  `add_date` int(10) unsigned NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `author` varchar(80) NOT NULL,
  `category_id` int(11) NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `default_pic` int(11) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `download_cost` int(11) NOT NULL,
  `download_data_mash` longtext NOT NULL,
  `download_licence` int(11) default NULL,
  `download_submitter_gets_points` tinyint(1) NOT NULL,
  `download_views` int(11) NOT NULL,
  `edit_date` int(10) unsigned default NULL,
  `file_size` int(11) default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` int(10) unsigned NOT NULL,
  `notes` longtext NOT NULL,
  `num_downloads` int(11) NOT NULL,
  `original_filename` varchar(255) NOT NULL,
  `out_mode_id` int(11) default NULL,
  `rep_image` varchar(255) NOT NULL,
  `submitter` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `category_list` (`category_id`),
  KEY `recent_downloads` (`add_date`),
  KEY `top_downloads` (`num_downloads`),
  FULLTEXT KEY `download_data_mash` (`download_data_mash`),
  FULLTEXT KEY `original_filename` (`original_filename`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_download_downloads`
--

LOCK TABLES `cms_download_downloads` WRITE;
/*!40000 ALTER TABLE `cms_download_downloads` DISABLE KEYS */;
INSERT INTO `cms_download_downloads` VALUES (1264673478,1,1,1,'William Shakespeare',3,616,1,615,0,'',NULL,0,1,1264686219,63123,1,614,'',1,'2ws1610.txt.zip',NULL,'',2,'uploads/downloads/4b6162c681095.dat',1),(1264685674,1,1,1,'William Shakespeare',3,766,1,765,0,'',NULL,0,1,NULL,77715,2,764,'',0,'2ws2610.txt.zip',NULL,'',2,'uploads/downloads/4b61926a8df19.dat',1);
/*!40000 ALTER TABLE `cms_download_downloads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_download_licences`
--

DROP TABLE IF EXISTS `cms_download_licences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_download_licences` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `l_text` longtext NOT NULL,
  `l_title` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_download_licences`
--

LOCK TABLES `cms_download_licences` WRITE;
/*!40000 ALTER TABLE `cms_download_licences` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_download_licences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_download_logging`
--

DROP TABLE IF EXISTS `cms_download_logging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_download_logging` (
  `date_and_time` int(10) unsigned NOT NULL,
  `id` int(11) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `the_user` int(11) NOT NULL,
  PRIMARY KEY  (`id`,`the_user`),
  KEY `calculate_bandwidth` (`date_and_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_download_logging`
--

LOCK TABLES `cms_download_logging` WRITE;
/*!40000 ALTER TABLE `cms_download_logging` DISABLE KEYS */;
INSERT INTO `cms_download_logging` VALUES (1264674283,1,'90.152.0.114',2);
/*!40000 ALTER TABLE `cms_download_logging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_edit_pings`
--

DROP TABLE IF EXISTS `cms_edit_pings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_edit_pings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `the_id` varchar(80) NOT NULL,
  `the_member` int(11) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_time` int(10) unsigned NOT NULL,
  `the_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_edit_pings`
--

LOCK TABLES `cms_edit_pings` WRITE;
/*!40000 ALTER TABLE `cms_edit_pings` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_edit_pings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_categories`
--

DROP TABLE IF EXISTS `cms_f_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_categories` (
  `c_description` longtext NOT NULL,
  `c_expanded_by_default` tinyint(1) NOT NULL,
  `c_title` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_categories`
--

LOCK TABLES `cms_f_categories` WRITE;
/*!40000 ALTER TABLE `cms_f_categories` DISABLE KEYS */;
INSERT INTO `cms_f_categories` VALUES ('',1,'General',1),('',1,'Staff',2);
/*!40000 ALTER TABLE `cms_f_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_custom_fields`
--

DROP TABLE IF EXISTS `cms_f_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_custom_fields` (
  `cf_default` longtext NOT NULL,
  `cf_description` int(10) unsigned NOT NULL,
  `cf_encrypted` tinyint(1) NOT NULL,
  `cf_locked` tinyint(1) NOT NULL,
  `cf_name` int(10) unsigned NOT NULL,
  `cf_only_group` longtext NOT NULL,
  `cf_order` int(11) NOT NULL,
  `cf_owner_set` tinyint(1) NOT NULL,
  `cf_owner_view` tinyint(1) NOT NULL,
  `cf_public_view` tinyint(1) NOT NULL,
  `cf_required` tinyint(1) NOT NULL,
  `cf_show_in_posts` tinyint(1) NOT NULL,
  `cf_show_in_post_previews` tinyint(1) NOT NULL,
  `cf_type` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `cf_show_on_join_form` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_custom_fields`
--

LOCK TABLES `cms_f_custom_fields` WRITE;
/*!40000 ALTER TABLE `cms_f_custom_fields` DISABLE KEYS */;
INSERT INTO `cms_f_custom_fields` VALUES ('',17,0,0,16,'',0,1,1,1,0,0,0,'long_trans',1,0),('',19,0,0,18,'',1,1,1,1,0,0,0,'short_text',2,0),('',21,0,0,20,'',2,1,1,1,0,0,0,'short_text',3,0),('',23,0,0,22,'',3,1,1,1,0,0,0,'short_text',4,0),('',25,0,0,24,'',4,1,1,1,0,0,0,'short_text',5,0),('',27,0,0,26,'',5,1,1,1,0,0,0,'long_trans',6,0),('',29,0,0,28,'',6,1,1,1,0,0,0,'short_text',7,0),('',31,0,0,30,'',7,1,1,1,0,0,0,'short_text',8,0),('',33,0,0,32,'',8,0,0,0,0,0,0,'long_trans',9,0),('',90,0,1,89,'',9,1,0,0,0,0,0,'short_text',10,0),('0',303,0,1,302,'',10,0,0,0,0,0,0,'integer',11,0),('0',314,0,1,313,'',11,0,0,0,0,0,0,'integer',12,0),('AED|AFA|ALL|AMD|ANG|AOK|AON|ARA|ARP|ARS|AUD|AWG|AZM|BAM|BBD|BDT|BGL|BHD|BIF|BMD|BND|BOB|BOP|BRC|BRL|BRR|BSD|BTN|BWP|BYR|BZD|CAD|CDZ|CHF|CLF|CLP|CNY|COP|CRC|CSD|CUP|CVE|CYP|CZK|DJF|DKK|DOP|DZD|EEK|EGP|ERN|ETB|EUR|FJD|FKP|GBP|GEL|GHC|GIP|GMD|GNS|GQE|GTQ|GWP|GYD|HKD|HNL|HRD|HRK|HTG|HUF|IDR|ILS|INR|IQD|IRR|ISK|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LRD|LSL|LSM|LTL|LVL|LYD|MAD|MDL|MGF|MKD|MLF|MMK|MNT|MOP|MRO|MTL|MUR|MVR|MWK|MXN|MYR|MZM|NAD|NGN|NIC|NOK|NPR|NZD|OMR|PAB|PEI|PEN|PGK|PHP|PKR|PLN|PYG|QAR|ROL|RUB|RWF|SAR|SBD|SCR|SDD|SDP|SEK|SGD|SHP|SIT|SKK|SLL|SOS|SRG|STD|SUR|SVC|SYP|SZL|THB|TJR|TMM|TND|TOP|TPE|TRL|TTD|TWD|TZS|UAH|UAK|UGS|USD|UYU|UZS|VEB|VND|VUV|WST|XAF|XCD|XOF|XPF|YDD|YER|ZAL|ZAR|ZMK|ZWD',352,0,1,351,'',12,1,0,0,0,0,0,'list',13,0),('',354,1,1,353,'',13,1,0,0,0,0,0,'short_text',14,0),('American Express|Delta|Diners Card|JCB|Master Card|Solo|Switch|Visa',356,1,1,355,'',14,1,0,0,0,0,0,'list',15,0),('',358,1,1,357,'',15,1,0,0,0,0,0,'integer',16,0),('mm/yy',360,1,1,359,'',16,1,0,0,0,0,0,'short_text',17,0),('mm/yy',362,1,1,361,'',17,1,0,0,0,0,0,'short_text',18,0),('',364,1,1,363,'',18,1,0,0,0,0,0,'short_text',19,0),('',366,1,1,365,'',19,1,0,0,0,0,0,'short_text',20,0),('',380,0,1,379,'',20,0,0,0,0,0,0,'short_text',21,0),('',382,0,1,381,'',21,0,0,0,0,0,0,'short_text',22,0),('',384,0,1,383,'',22,0,0,0,0,0,0,'long_text',23,0),('',386,0,1,385,'',23,0,0,0,0,0,0,'short_text',24,0),('',388,0,1,387,'',24,0,0,0,0,0,0,'short_text',25,0),('',390,0,1,389,'',25,0,0,0,0,0,0,'short_text',26,0),('AD|AE|AF|AG|AI|AL|AM|AN|AO|AQ|AR|AS|AT|AU|AW|AZ|BA|BB|BD|BE|BF|BG|BH|BI|BJ|BM|BN|BO|BR|BS|BT|BU|BV|BW|BY|BZ|CA|CC|CD|CF|CG|CH|CI|CK|CL|CM|CN|CO|CR|CS|CU|CV|CX|CY|CZ|DE|DJ|DK|DM|DO|DZ|EC|EE|EG|EH|ER|ES|ET|FI|FJ|FK|FM|FO|FR|GA|GB|GD|GE|GH|GI|GL|GM|GN|GQ|GR|GS|GT|GU|GW|GY|HK|HM|HN|HR|HT|HU|ID|IE|IL|IN|IO|IQ|IR|IS|IT|JM|JO|JP|KE|KG|KH|KI|KM|KN|KP|KR|KW|KY|KZ|LA|LB|LC|LI|LK|LR|LS|LT|LU|LY|MA|MC|MD|MG|MH|MK|ML|MM|MN|MO|MP|MR|MS|MT|MU|MV|MW|MX|MY|MZ|NA|NC|NE|NF|NG|NI|NL|NO|NP|NR|NU|NZ|OM|PA|PE|PF|PG|PH|PK|PL|PN|PR|PT|PW|PY|QA|RO|RU|RW|SA|SB|SC|SD|SE|SG|SH|SI|SJ|SK|SL|SM|SN|SO|SR|ST|SU|SV|SY|SZ|TC|TD|TG|TH|TJ|TK|TM|TN|TO|TP|TR|TT|TV|TW|TZ|UA|UG|UM|US|UY|UZ|VA|VC|VE|VG|VI|VN|VU|WF|WS|YD|YE|ZA|ZM|ZR|ZW',392,0,1,391,'',26,0,0,0,0,0,0,'list',27,0),('0',426,0,1,425,'',27,0,0,0,0,0,0,'integer',28,0),('0',428,0,1,427,'',28,0,0,0,0,0,0,'integer',29,0),('0',430,0,1,429,'',29,0,0,0,0,0,0,'integer',30,0),('0',432,0,1,431,'',30,0,0,0,0,0,0,'integer',31,0),('0',434,0,1,433,'',31,0,0,0,0,0,0,'integer',32,0),('',436,0,1,435,'',32,0,0,0,0,0,0,'short_text',33,0),('',438,0,1,437,'',33,1,0,0,0,0,0,'short_text',34,0),('',440,0,1,439,'',34,1,0,0,0,0,0,'short_text',35,0);
/*!40000 ALTER TABLE `cms_f_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_emoticons`
--

DROP TABLE IF EXISTS `cms_f_emoticons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_emoticons` (
  `e_code` varchar(255) NOT NULL,
  `e_is_special` tinyint(1) NOT NULL,
  `e_relevance_level` int(11) NOT NULL,
  `e_theme_img_code` varchar(255) NOT NULL,
  `e_use_topics` tinyint(1) NOT NULL,
  PRIMARY KEY  (`e_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_emoticons`
--

LOCK TABLES `cms_f_emoticons` WRITE;
/*!40000 ALTER TABLE `cms_f_emoticons` DISABLE KEYS */;
INSERT INTO `cms_f_emoticons` VALUES (':P',0,0,'ocf_emoticons/cheeky',1),(':\'(',0,0,'ocf_emoticons/cry',1),(':dry:',0,0,'ocf_emoticons/dry',1),(':$',0,0,'ocf_emoticons/blush',1),(';)',0,0,'ocf_emoticons/wink',0),('O_o',0,0,'ocf_emoticons/blink',1),(':wub:',0,0,'ocf_emoticons/wub',1),(':cool:',0,0,'ocf_emoticons/cool',1),(':lol:',0,0,'ocf_emoticons/lol',1),(':(',0,0,'ocf_emoticons/sad',1),(':)',0,0,'ocf_emoticons/smile',0),(':thumbs:',0,0,'ocf_emoticons/thumbs',1),(':offtopic:',0,0,'ocf_emoticons/offtopic',0),(':|',0,0,'ocf_emoticons/mellow',0),(':ninja:',0,0,'ocf_emoticons/ph34r',1),(':o',0,0,'ocf_emoticons/shocked',1),(':rolleyes:',0,1,'ocf_emoticons/rolleyes',1),(':D',0,1,'ocf_emoticons/grin',1),('^_^',0,1,'ocf_emoticons/glee',1),('(K)',0,1,'ocf_emoticons/kiss',0),(':S',0,1,'ocf_emoticons/confused',1),(':@',0,1,'ocf_emoticons/angry',1),(':shake:',0,1,'ocf_emoticons/shake',1),(':hand:',0,1,'ocf_emoticons/hand',1),(':drool:',0,1,'ocf_emoticons/drool',1),(':devil:',0,1,'ocf_emoticons/devil',1),(':party:',0,1,'ocf_emoticons/party',0),(':constipated:',0,1,'ocf_emoticons/constipated',1),(':depressed:',0,1,'ocf_emoticons/depressed',1),(':zzz:',0,1,'ocf_emoticons/zzz',1),(':whistle:',0,1,'ocf_emoticons/whistle',0),(':upsidedown:',0,1,'ocf_emoticons/upsidedown',1),(':sick:',0,1,'ocf_emoticons/sick',1),(':shutup:',0,1,'ocf_emoticons/shutup',0),(':sarcy:',0,1,'ocf_emoticons/sarcy',1),(':puppyeyes:',0,1,'ocf_emoticons/puppyeyes',1),(':nod:',0,1,'ocf_emoticons/nod',0),(':nerd:',0,1,'ocf_emoticons/nerd',1),(':king:',0,1,'ocf_emoticons/king',1),(':birthday:',0,1,'ocf_emoticons/birthday',1),(':cyborg:',0,1,'ocf_emoticons/cyborg',0),(':hippie:',0,1,'ocf_emoticons/hippie',1),(':ninja2:',0,1,'ocf_emoticons/ninja2',1),(':rockon:',0,1,'ocf_emoticons/rockon',0),(':sinner:',0,1,'ocf_emoticons/sinner',0),(':guitar:',0,1,'ocf_emoticons/guitar',0),(':christmas:',0,1,'ocf_emoticons/christmas',0);
/*!40000 ALTER TABLE `cms_f_emoticons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_forum_intro_ip`
--

DROP TABLE IF EXISTS `cms_f_forum_intro_ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_forum_intro_ip` (
  `i_forum_id` int(11) NOT NULL,
  `i_ip` varchar(40) NOT NULL,
  PRIMARY KEY  (`i_forum_id`,`i_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_forum_intro_ip`
--

LOCK TABLES `cms_f_forum_intro_ip` WRITE;
/*!40000 ALTER TABLE `cms_f_forum_intro_ip` DISABLE KEYS */;
INSERT INTO `cms_f_forum_intro_ip` VALUES (4,'90.152.0.*');
/*!40000 ALTER TABLE `cms_f_forum_intro_ip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_forum_intro_member`
--

DROP TABLE IF EXISTS `cms_f_forum_intro_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_forum_intro_member` (
  `i_forum_id` int(11) NOT NULL,
  `i_member_id` int(11) NOT NULL,
  PRIMARY KEY  (`i_forum_id`,`i_member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_forum_intro_member`
--

LOCK TABLES `cms_f_forum_intro_member` WRITE;
/*!40000 ALTER TABLE `cms_f_forum_intro_member` DISABLE KEYS */;
INSERT INTO `cms_f_forum_intro_member` VALUES (4,2);
/*!40000 ALTER TABLE `cms_f_forum_intro_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_forums`
--

DROP TABLE IF EXISTS `cms_f_forums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_forums` (
  `f_cache_last_forum_id` int(11) default NULL,
  `f_cache_last_member_id` int(11) default NULL,
  `f_cache_last_time` int(10) unsigned default NULL,
  `f_cache_last_title` varchar(255) NOT NULL,
  `f_cache_last_topic_id` int(11) default NULL,
  `f_cache_last_username` varchar(255) NOT NULL,
  `f_cache_num_posts` int(11) NOT NULL,
  `f_cache_num_topics` int(11) NOT NULL,
  `f_category_id` int(11) default NULL,
  `f_description` int(10) unsigned NOT NULL,
  `f_intro_answer` varchar(255) NOT NULL,
  `f_intro_question` int(10) unsigned NOT NULL,
  `f_name` varchar(255) NOT NULL,
  `f_order` varchar(80) NOT NULL,
  `f_order_sub_alpha` tinyint(1) NOT NULL,
  `f_parent_forum` int(11) default NULL,
  `f_position` int(11) NOT NULL,
  `f_post_count_increment` tinyint(1) NOT NULL,
  `f_redirection` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `f_is_threaded` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `subforum_parenting` (`f_parent_forum`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_forums`
--

LOCK TABLES `cms_f_forums` WRITE;
/*!40000 ALTER TABLE `cms_f_forums` DISABLE KEYS */;
INSERT INTO `cms_f_forums` VALUES (1,2,1264693140,'This topic acts as an announcement.',5,'admin',1,1,NULL,54,'',55,'Forum home','last_post',0,NULL,1,1,'',1,0),(3,2,1265476759,'This topic is pinned.',8,'admin',7,4,1,58,'',59,'General chat','last_post',0,1,1,1,'',3,0),(NULL,NULL,NULL,'',NULL,'',0,0,1,60,'Composr',61,'Feedback','last_post',0,1,1,1,'',4,0),(5,2,1264694090,'Reported post in \'Here is a topic with a poll.\'',7,'admin',1,1,2,62,'',63,'Reported posts forum','last_post',0,1,1,1,'',5,0),(NULL,NULL,NULL,'',NULL,'',0,0,2,64,'',65,'Trash','last_post',0,1,1,1,'',6,0),(NULL,NULL,NULL,'',NULL,'',0,0,1,66,'',67,'Website comment topics','last_post',0,1,1,1,'',7,0),(NULL,NULL,NULL,'',NULL,'',0,0,2,68,'',69,'Website support tickets','last_post',0,1,1,1,'',8,0),(9,1,1264606808,'Welcome to the forums',1,'System',2,2,2,70,'',71,'Staff','last_post',0,1,1,1,'',9,0),(NULL,NULL,NULL,'',NULL,'',0,0,2,169,'',170,'Website \"Contact Us\" messages','last_post',0,1,1,1,'',10,0);
/*!40000 ALTER TABLE `cms_f_forums` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_group_member_timeouts`
--

DROP TABLE IF EXISTS `cms_f_group_member_timeouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_group_member_timeouts` (
  `member_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  `timeout` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`member_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_group_member_timeouts`
--

LOCK TABLES `cms_f_group_member_timeouts` WRITE;
/*!40000 ALTER TABLE `cms_f_group_member_timeouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_group_member_timeouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_group_members`
--

DROP TABLE IF EXISTS `cms_f_group_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_group_members` (
  `gm_group_id` int(11) NOT NULL,
  `gm_member_id` int(11) NOT NULL,
  `gm_validated` tinyint(1) NOT NULL,
  PRIMARY KEY  (`gm_group_id`,`gm_member_id`),
  KEY `gm_validated` (`gm_validated`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_group_members`
--

LOCK TABLES `cms_f_group_members` WRITE;
/*!40000 ALTER TABLE `cms_f_group_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_group_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_groups`
--

DROP TABLE IF EXISTS `cms_f_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_groups` (
  `g_enquire_on_new_ips` tinyint(1) NOT NULL,
  `g_flood_control_access_secs` int(11) NOT NULL,
  `g_flood_control_submit_secs` int(11) NOT NULL,
  `g_gift_points_base` int(11) NOT NULL,
  `g_gift_points_per_day` int(11) NOT NULL,
  `g_group_leader` int(11) default NULL,
  `g_hidden` tinyint(1) NOT NULL,
  `g_is_default` tinyint(1) NOT NULL,
  `g_is_presented_at_install` tinyint(1) NOT NULL,
  `g_is_private_club` tinyint(1) NOT NULL,
  `g_is_super_admin` tinyint(1) NOT NULL,
  `g_is_super_moderator` tinyint(1) NOT NULL,
  `g_max_attachments_per_post` int(11) NOT NULL,
  `g_max_avatar_height` int(11) NOT NULL,
  `g_max_avatar_width` int(11) NOT NULL,
  `g_max_daily_upload_mb` int(11) NOT NULL,
  `g_max_post_length_comcode` int(11) NOT NULL,
  `g_max_sig_length_comcode` int(11) NOT NULL,
  `g_name` int(10) unsigned NOT NULL,
  `g_open_membership` tinyint(1) NOT NULL,
  `g_order` int(11) NOT NULL,
  `g_promotion_target` int(11) default NULL,
  `g_promotion_threshold` int(11) default NULL,
  `g_rank_image` varchar(80) NOT NULL,
  `g_rank_image_pri_only` tinyint(1) NOT NULL,
  `g_title` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_groups`
--

LOCK TABLES `cms_f_groups` WRITE;
/*!40000 ALTER TABLE `cms_f_groups` DISABLE KEYS */;
INSERT INTO `cms_f_groups` VALUES (0,0,5,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,34,0,0,NULL,NULL,'',1,35,1),(0,0,0,25,1,NULL,0,0,0,0,1,0,5,100,100,5,30000,700,36,0,1,NULL,NULL,'ocf_rank_images/admin',1,37,2),(0,0,0,25,1,NULL,0,0,0,0,0,1,5,100,100,5,30000,700,38,0,2,NULL,NULL,'ocf_rank_images/mod',1,39,3),(0,0,0,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,40,0,3,NULL,NULL,'',1,41,4),(0,0,5,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,42,0,4,NULL,NULL,'ocf_rank_images/4',1,43,5),(0,0,5,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,44,0,5,5,10000,'ocf_rank_images/3',1,45,6),(0,0,5,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,46,0,6,6,2500,'ocf_rank_images/2',1,47,7),(0,0,5,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,48,0,7,7,400,'ocf_rank_images/1',1,49,8),(0,0,5,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,50,0,8,8,100,'ocf_rank_images/0',1,51,9),(0,0,0,25,1,NULL,0,0,0,0,0,0,5,100,100,5,30000,700,52,0,9,NULL,NULL,'',1,53,10);
/*!40000 ALTER TABLE `cms_f_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_invites`
--

DROP TABLE IF EXISTS `cms_f_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_invites` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `i_email_address` varchar(255) NOT NULL,
  `i_inviter` int(11) NOT NULL,
  `i_taken` tinyint(1) NOT NULL,
  `i_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_invites`
--

LOCK TABLES `cms_f_invites` WRITE;
/*!40000 ALTER TABLE `cms_f_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_member_cpf_perms`
--

DROP TABLE IF EXISTS `cms_f_member_cpf_perms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_member_cpf_perms` (
  `field_id` int(11) NOT NULL,
  `friend_view` tinyint(1) NOT NULL,
  `group_view` varchar(255) NOT NULL,
  `guest_view` tinyint(1) NOT NULL,
  `member_id` int(11) NOT NULL,
  `member_view` tinyint(1) NOT NULL,
  PRIMARY KEY  (`field_id`,`member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_member_cpf_perms`
--

LOCK TABLES `cms_f_member_cpf_perms` WRITE;
/*!40000 ALTER TABLE `cms_f_member_cpf_perms` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_member_cpf_perms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_member_custom_fields`
--

DROP TABLE IF EXISTS `cms_f_member_custom_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_member_custom_fields` (
  `field_1` int(10) unsigned default NULL,
  `field_10` varchar(255) NOT NULL,
  `field_11` varchar(255) NOT NULL,
  `field_12` varchar(255) NOT NULL,
  `field_13` varchar(255) NOT NULL,
  `field_14` longtext NOT NULL,
  `field_15` longtext NOT NULL,
  `field_16` varchar(255) NOT NULL,
  `field_17` longtext NOT NULL,
  `field_18` longtext NOT NULL,
  `field_19` longtext NOT NULL,
  `field_2` varchar(255) NOT NULL,
  `field_20` longtext NOT NULL,
  `field_21` varchar(255) NOT NULL,
  `field_22` varchar(255) NOT NULL,
  `field_23` longtext NOT NULL,
  `field_24` varchar(255) NOT NULL,
  `field_25` varchar(255) NOT NULL,
  `field_26` varchar(255) NOT NULL,
  `field_27` varchar(255) NOT NULL,
  `field_28` varchar(255) NOT NULL,
  `field_29` varchar(255) NOT NULL,
  `field_3` varchar(255) NOT NULL,
  `field_30` varchar(255) NOT NULL,
  `field_31` varchar(255) NOT NULL,
  `field_32` varchar(255) NOT NULL,
  `field_33` varchar(255) NOT NULL,
  `field_34` varchar(255) NOT NULL,
  `field_35` varchar(255) NOT NULL,
  `field_4` varchar(255) NOT NULL,
  `field_5` varchar(255) NOT NULL,
  `field_6` int(10) unsigned default NULL,
  `field_7` varchar(255) NOT NULL,
  `field_8` varchar(255) NOT NULL,
  `field_9` int(10) unsigned default NULL,
  `mf_member_id` int(11) NOT NULL,
  PRIMARY KEY  (`mf_member_id`),
  FULLTEXT KEY `mcf10` (`field_10`),
  FULLTEXT KEY `mcf13` (`field_13`),
  FULLTEXT KEY `mcf14` (`field_14`),
  FULLTEXT KEY `mcf15` (`field_15`),
  FULLTEXT KEY `mcf17` (`field_17`),
  FULLTEXT KEY `mcf18` (`field_18`),
  FULLTEXT KEY `mcf19` (`field_19`),
  FULLTEXT KEY `mcf2` (`field_2`),
  FULLTEXT KEY `mcf20` (`field_20`),
  FULLTEXT KEY `mcf21` (`field_21`),
  FULLTEXT KEY `mcf22` (`field_22`),
  FULLTEXT KEY `mcf23` (`field_23`),
  FULLTEXT KEY `mcf24` (`field_24`),
  FULLTEXT KEY `mcf25` (`field_25`),
  FULLTEXT KEY `mcf26` (`field_26`),
  FULLTEXT KEY `mcf27` (`field_27`),
  FULLTEXT KEY `mcf3` (`field_3`),
  FULLTEXT KEY `mcf33` (`field_33`),
  FULLTEXT KEY `mcf34` (`field_34`),
  FULLTEXT KEY `mcf35` (`field_35`),
  FULLTEXT KEY `mcf4` (`field_4`),
  FULLTEXT KEY `mcf5` (`field_5`),
  FULLTEXT KEY `mcf7` (`field_7`),
  FULLTEXT KEY `mcf8` (`field_8`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_member_custom_fields`
--

LOCK TABLES `cms_f_member_custom_fields` WRITE;
/*!40000 ALTER TABLE `cms_f_member_custom_fields` DISABLE KEYS */;
INSERT INTO `cms_f_member_custom_fields` VALUES (75,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',76,'','',77,1),(80,'','2','','','','','','','','','','','','','','','','','','6','','','1370','','','','','','','',81,'','',82,2),(85,'','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',86,'','',87,3);
/*!40000 ALTER TABLE `cms_f_member_custom_fields` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_member_known_login_ips`
--

DROP TABLE IF EXISTS `cms_f_member_known_login_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_member_known_login_ips` (
  `i_ip` varchar(40) NOT NULL,
  `i_member_id` int(11) NOT NULL,
  `i_val_code` varchar(255) NOT NULL,
  PRIMARY KEY  (`i_ip`,`i_member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_member_known_login_ips`
--

LOCK TABLES `cms_f_member_known_login_ips` WRITE;
/*!40000 ALTER TABLE `cms_f_member_known_login_ips` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_member_known_login_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_members`
--

DROP TABLE IF EXISTS `cms_f_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_members` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `m_allow_emails` tinyint(1) NOT NULL,
  `m_avatar_url` varchar(255) NOT NULL,
  `m_cache_num_posts` int(11) NOT NULL,
  `m_cache_warnings` int(11) NOT NULL,
  `m_dob_day` int(11) default NULL,
  `m_dob_month` int(11) default NULL,
  `m_dob_year` int(11) default NULL,
  `m_email_address` varchar(255) NOT NULL,
  `m_highlighted_name` tinyint(1) NOT NULL,
  `m_ip_address` varchar(40) NOT NULL,
  `m_is_perm_banned` tinyint(1) NOT NULL,
  `m_join_time` int(10) unsigned NOT NULL,
  `m_language` varchar(80) NOT NULL,
  `m_last_submit_time` int(10) unsigned NOT NULL,
  `m_last_visit_time` int(10) unsigned NOT NULL,
  `m_max_email_attach_size_mb` int(11) NOT NULL,
  `m_notes` longtext NOT NULL,
  `m_on_probation_until` int(10) unsigned default NULL,
  `m_password_change_code` varchar(255) NOT NULL,
  `m_password_compat_scheme` varchar(80) NOT NULL,
  `m_pass_hash_salted` varchar(255) NOT NULL,
  `m_pass_salt` varchar(255) NOT NULL,
  `m_photo_thumb_url` varchar(255) NOT NULL,
  `m_photo_url` varchar(255) NOT NULL,
  `m_preview_posts` tinyint(1) NOT NULL,
  `m_primary_group` int(11) NOT NULL,
  `m_pt_allow` varchar(255) NOT NULL,
  `m_pt_rules_text` int(10) unsigned NOT NULL,
  `m_reveal_age` tinyint(1) NOT NULL,
  `m_signature` int(10) unsigned NOT NULL,
  `m_theme` varchar(80) NOT NULL,
  `m_timezone_offset` varchar(255) NOT NULL,
  `m_title` varchar(255) NOT NULL,
  `m_auto_monitor_contrib_content` tinyint(1) NOT NULL,
  `m_username` varchar(80) NOT NULL,
  `m_validated` tinyint(1) NOT NULL,
  `m_validated_email_confirm_code` varchar(255) NOT NULL,
  `m_views_signatures` tinyint(1) NOT NULL,
  `m_zone_wide` tinyint(1) NOT NULL,
  `m_allow_emails_from_staff` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`),
  KEY `birthdays` (`m_dob_day`,`m_dob_month`),
  KEY `sort_post_count` (`m_cache_num_posts`),
  KEY `user_list` (`m_username`),
  KEY `whos_validated` (`m_validated`),
  FULLTEXT KEY `search_user` (`m_username`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_members`
--

LOCK TABLES `cms_f_members` WRITE;
/*!40000 ALTER TABLE `cms_f_members` DISABLE KEYS */;
INSERT INTO `cms_f_members` VALUES (1,1,'',1,0,NULL,NULL,NULL,'',0,'188.221.7.254',0,1264606805,'',1332809597,1332809597,5,'',1264606807,'','','7679a5bcb05e2076d658d3af9374fab5','4b605e55dd1b6','','',1,1,'*',74,1,73,'','0','',0,'Guest',1,'',1,1,1),(2,1,'themes/default/images/ocf_default_avatars/default_set/cool_flare.png',11,0,NULL,NULL,NULL,'',0,'188.221.7.254',0,1264606808,'',1265480596,1332809598,5,'',1264606808,'','md5','62cc2d8b4bf2d8728120d052163a77df','','','',0,2,'*',79,1,78,'','0','',0,'admin',1,'',1,1,1),(3,1,'',0,0,NULL,NULL,NULL,'',0,'90.152.0.114',0,1264606808,'',1264606808,1264606808,5,'',1264606808,'','','04a1fbca2beb7af7afa3326467b7d22f','4b605e5804484','','',0,9,'*',84,1,83,'','0','',0,'test',1,'',1,1,1);
/*!40000 ALTER TABLE `cms_f_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_moderator_logs`
--

DROP TABLE IF EXISTS `cms_f_moderator_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_moderator_logs` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `l_by` int(11) NOT NULL,
  `l_date_and_time` int(10) unsigned NOT NULL,
  `l_param_a` varchar(255) NOT NULL,
  `l_param_b` varchar(255) NOT NULL,
  `l_reason` longtext NOT NULL,
  `l_the_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_moderator_logs`
--

LOCK TABLES `cms_f_moderator_logs` WRITE;
/*!40000 ALTER TABLE `cms_f_moderator_logs` DISABLE KEYS */;
INSERT INTO `cms_f_moderator_logs` VALUES (1,2,1264692888,'4','This topic contains a whisper.','','EDIT_TOPIC'),(2,2,1265476759,'8','This topic is pinned.','','EDIT_TOPIC');
/*!40000 ALTER TABLE `cms_f_moderator_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_multi_moderations`
--

DROP TABLE IF EXISTS `cms_f_multi_moderations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_multi_moderations` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `mm_forum_multi_code` varchar(255) NOT NULL,
  `mm_move_to` int(11) default NULL,
  `mm_name` int(10) unsigned NOT NULL,
  `mm_open_state` tinyint(1) default NULL,
  `mm_pin_state` tinyint(1) default NULL,
  `mm_post_text` longtext NOT NULL,
  `mm_sink_state` tinyint(1) default NULL,
  `mm_title_suffix` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`,`mm_name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_multi_moderations`
--

LOCK TABLES `cms_f_multi_moderations` WRITE;
/*!40000 ALTER TABLE `cms_f_multi_moderations` DISABLE KEYS */;
INSERT INTO `cms_f_multi_moderations` VALUES (1,'*',6,72,0,0,'',0,'');
/*!40000 ALTER TABLE `cms_f_multi_moderations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_poll_answers`
--

DROP TABLE IF EXISTS `cms_f_poll_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_poll_answers` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `pa_answer` varchar(255) NOT NULL,
  `pa_cache_num_votes` int(11) NOT NULL,
  `pa_poll_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_poll_answers`
--

LOCK TABLES `cms_f_poll_answers` WRITE;
/*!40000 ALTER TABLE `cms_f_poll_answers` DISABLE KEYS */;
INSERT INTO `cms_f_poll_answers` VALUES (1,'Yes',1,1),(2,'No',0,1);
/*!40000 ALTER TABLE `cms_f_poll_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_poll_votes`
--

DROP TABLE IF EXISTS `cms_f_poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_poll_votes` (
  `pv_answer_id` int(11) NOT NULL,
  `pv_member_id` int(11) NOT NULL,
  `pv_poll_id` int(11) NOT NULL,
  PRIMARY KEY  (`pv_answer_id`,`pv_member_id`,`pv_poll_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_poll_votes`
--

LOCK TABLES `cms_f_poll_votes` WRITE;
/*!40000 ALTER TABLE `cms_f_poll_votes` DISABLE KEYS */;
INSERT INTO `cms_f_poll_votes` VALUES (1,2,1);
/*!40000 ALTER TABLE `cms_f_poll_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_polls`
--

DROP TABLE IF EXISTS `cms_f_polls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_polls` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `po_cache_total_votes` int(11) NOT NULL,
  `po_is_open` tinyint(1) NOT NULL,
  `po_is_private` tinyint(1) NOT NULL,
  `po_maximum_selections` int(11) NOT NULL,
  `po_minimum_selections` int(11) NOT NULL,
  `po_question` varchar(255) NOT NULL,
  `po_requires_reply` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_polls`
--

LOCK TABLES `cms_f_polls` WRITE;
/*!40000 ALTER TABLE `cms_f_polls` DISABLE KEYS */;
INSERT INTO `cms_f_polls` VALUES (1,1,1,0,1,1,'Do you like my poll?',0);
/*!40000 ALTER TABLE `cms_f_polls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_post_history`
--

DROP TABLE IF EXISTS `cms_f_post_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_post_history` (
  `h_action` varchar(80) NOT NULL,
  `h_action_date_and_time` int(10) unsigned NOT NULL,
  `h_alterer_member_id` int(11) NOT NULL,
  `h_before` longtext NOT NULL,
  `h_create_date_and_time` int(10) unsigned NOT NULL,
  `h_owner_member_id` int(11) NOT NULL,
  `h_post_id` int(11) NOT NULL,
  `h_topic_id` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`),
  KEY `phistorylookup` (`h_post_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_post_history`
--

LOCK TABLES `cms_f_post_history` WRITE;
/*!40000 ALTER TABLE `cms_f_post_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_post_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_post_templates`
--

DROP TABLE IF EXISTS `cms_f_post_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_post_templates` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `t_forum_multi_code` varchar(255) NOT NULL,
  `t_text` longtext NOT NULL,
  `t_title` varchar(255) NOT NULL,
  `t_use_default_forums` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_post_templates`
--

LOCK TABLES `cms_f_post_templates` WRITE;
/*!40000 ALTER TABLE `cms_f_post_templates` DISABLE KEYS */;
INSERT INTO `cms_f_post_templates` VALUES (1,'','Version: ?\nSupport software environment (operating system, etc.):\n?\n\nAssigned to: ?\nSeverity: ?\nExample URL: ?\nDescription:\n?\n\nSteps for reproduction:\n?\n\n','Bug report',0),(2,'','Assigned to: ?\nPriority/Timescale: ?\nDescription:\n?\n\n','Task',0),(3,'','Version: ?\nAssigned to: ?\nSeverity/Timescale: ?\nDescription:\n?\n\nSteps for reproduction:\n?\n\n','Fault',0);
/*!40000 ALTER TABLE `cms_f_post_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_posts`
--

DROP TABLE IF EXISTS `cms_f_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_posts` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `p_cache_forum_id` int(11) default NULL,
  `p_intended_solely_for` int(11) default NULL,
  `p_ip_address` varchar(40) NOT NULL,
  `p_is_emphasised` tinyint(1) NOT NULL,
  `p_last_edit_by` int(11) default NULL,
  `p_last_edit_time` int(10) unsigned default NULL,
  `p_post` int(10) unsigned NOT NULL,
  `p_poster` int(11) NOT NULL,
  `p_poster_name_if_guest` varchar(80) NOT NULL,
  `p_skip_sig` tinyint(1) NOT NULL,
  `p_time` int(10) unsigned NOT NULL,
  `p_title` varchar(255) NOT NULL,
  `p_topic_id` int(11) NOT NULL,
  `p_validated` tinyint(1) NOT NULL,
  `p_parent_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `find_pp` (`p_intended_solely_for`),
  KEY `in_topic` (`p_topic_id`),
  KEY `posts_by` (`p_poster`),
  KEY `post_order_time` (`p_time`),
  FULLTEXT KEY `p_title` (`p_title`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_posts`
--

LOCK TABLES `cms_f_posts` WRITE;
/*!40000 ALTER TABLE `cms_f_posts` DISABLE KEYS */;
INSERT INTO `cms_f_posts` VALUES (1,9,NULL,'127.0.0.1',0,NULL,NULL,88,1,'System',0,1264606808,'Welcome to the forums',1,1,NULL),(2,3,NULL,'90.152.0.114',0,NULL,NULL,853,2,'admin',0,1264692478,'This is a topic title.',2,1,NULL),(3,3,NULL,'90.152.0.114',0,NULL,NULL,854,2,'admin',0,1264692527,'',2,1,NULL),(4,3,NULL,'90.152.0.114',0,NULL,NULL,855,2,'admin',0,1264692658,'Here is a topic with a poll.',3,1,NULL),(5,3,NULL,'90.152.0.114',0,NULL,NULL,856,2,'admin',0,1264692806,'This topic contains a whisper.',4,1,NULL),(6,3,1,'90.152.0.114',0,NULL,NULL,857,2,'admin',0,1264692888,'',4,1,NULL),(7,3,NULL,'90.152.0.114',0,NULL,NULL,858,2,'admin',0,1264692970,'',4,1,NULL),(8,1,NULL,'90.152.0.114',0,NULL,NULL,859,2,'admin',0,1264693140,'This topic acts as an announcement.',5,1,NULL),(9,NULL,NULL,'90.152.0.114',0,NULL,NULL,860,2,'admin',0,1264693706,'Personal topic example.',6,1,NULL),(10,5,NULL,'90.152.0.114',0,NULL,NULL,865,2,'admin',0,1264694090,'Reported post in \'Here is a topic with a poll.\'',7,1,NULL),(11,3,NULL,'90.152.0.114',0,NULL,NULL,866,2,'admin',0,1264694559,'This topic is pinned.',8,1,NULL),(12,3,NULL,'90.152.0.114',0,NULL,NULL,867,2,'admin',0,1264694612,'This topic is sunk.',9,1,NULL),(13,3,NULL,'94.195.145.20',1,NULL,NULL,949,2,'admin',0,1265476759,'',8,1,NULL);
/*!40000 ALTER TABLE `cms_f_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_read_logs`
--

DROP TABLE IF EXISTS `cms_f_read_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_read_logs` (
  `l_member_id` int(11) NOT NULL,
  `l_time` int(10) unsigned NOT NULL,
  `l_topic_id` int(11) NOT NULL,
  PRIMARY KEY  (`l_member_id`,`l_topic_id`),
  KEY `erase_old_read_logs` (`l_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_read_logs`
--

LOCK TABLES `cms_f_read_logs` WRITE;
/*!40000 ALTER TABLE `cms_f_read_logs` DISABLE KEYS */;
INSERT INTO `cms_f_read_logs` VALUES (2,1264693013,2),(2,1264694095,3),(2,1265476973,4),(2,1264693143,5),(2,1265477648,6),(2,1332809616,7),(2,1265476886,8),(2,1264694615,9);
/*!40000 ALTER TABLE `cms_f_read_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_saved_warnings`
--

DROP TABLE IF EXISTS `cms_f_saved_warnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_saved_warnings` (
  `s_explanation` longtext NOT NULL,
  `s_message` longtext NOT NULL,
  `s_title` varchar(255) NOT NULL,
  PRIMARY KEY  (`s_title`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_saved_warnings`
--

LOCK TABLES `cms_f_saved_warnings` WRITE;
/*!40000 ALTER TABLE `cms_f_saved_warnings` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_saved_warnings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_special_pt_access`
--

DROP TABLE IF EXISTS `cms_f_special_pt_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_special_pt_access` (
  `s_member_id` int(11) NOT NULL,
  `s_topic_id` int(11) NOT NULL,
  PRIMARY KEY  (`s_member_id`,`s_topic_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_special_pt_access`
--

LOCK TABLES `cms_f_special_pt_access` WRITE;
/*!40000 ALTER TABLE `cms_f_special_pt_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_special_pt_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_topics`
--

DROP TABLE IF EXISTS `cms_f_topics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_topics` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `t_cache_first_member_id` int(11) default NULL,
  `t_cache_first_post` int(10) unsigned default NULL,
  `t_cache_first_post_id` int(11) default NULL,
  `t_cache_first_time` int(10) unsigned default NULL,
  `t_cache_first_title` varchar(255) NOT NULL,
  `t_cache_first_username` varchar(80) NOT NULL,
  `t_cache_last_member_id` int(11) default NULL,
  `t_cache_last_post_id` int(11) default NULL,
  `t_cache_last_time` int(10) unsigned default NULL,
  `t_cache_last_title` varchar(255) NOT NULL,
  `t_cache_last_username` varchar(80) NOT NULL,
  `t_cache_num_posts` int(11) NOT NULL,
  `t_cascading` tinyint(1) NOT NULL,
  `t_description` varchar(255) NOT NULL,
  `t_description_link` varchar(255) NOT NULL,
  `t_emoticon` varchar(255) NOT NULL,
  `t_forum_id` int(11) default NULL,
  `t_is_open` tinyint(1) NOT NULL,
  `t_num_views` int(11) NOT NULL,
  `t_pinned` tinyint(1) NOT NULL,
  `t_poll_id` int(11) default NULL,
  `t_pt_from` int(11) default NULL,
  `t_pt_from_category` varchar(255) NOT NULL,
  `t_pt_to` int(11) default NULL,
  `t_pt_to_category` varchar(255) NOT NULL,
  `t_sunk` tinyint(1) NOT NULL,
  `t_validated` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `in_forum` (`t_forum_id`),
  KEY `topic_order_time` (`t_cache_last_time`),
  FULLTEXT KEY `t_description` (`t_description`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_topics`
--

LOCK TABLES `cms_f_topics` WRITE;
/*!40000 ALTER TABLE `cms_f_topics` DISABLE KEYS */;
INSERT INTO `cms_f_topics` VALUES (1,1,88,1,1264606808,'Welcome to the forums','System',1,1,1264606808,'Welcome to the forums','System',1,0,'','','',9,1,0,0,NULL,NULL,'',NULL,'',0,1),(2,2,853,2,1264692478,'This is a topic title.','admin',2,3,1264692527,'','admin',2,0,'This is a topic description.','','ocf_emoticons/cool',3,1,3,0,NULL,NULL,'',NULL,'',0,1),(3,2,855,4,1264692658,'Here is a topic with a poll.','admin',2,4,1264692658,'Here is a topic with a poll.','admin',1,0,'','','',3,1,5,0,1,NULL,'',NULL,'',0,1),(4,2,856,5,1264692806,'This topic contains a whisper.','admin',2,7,1264692970,'','admin',2,0,'','','',3,1,5,0,NULL,NULL,'',NULL,'',0,1),(5,2,859,8,1264693140,'This topic acts as an announcement.','admin',2,8,1264693140,'This topic acts as an announcement.','admin',1,1,'','','',1,1,1,0,NULL,NULL,'',NULL,'',0,1),(6,2,860,9,1264693706,'Personal topic example.','admin',2,9,1264693706,'Personal topic example.','admin',1,0,'','','',NULL,1,2,0,NULL,2,'',1,'',0,1),(7,2,865,10,1264694090,'Reported post in \'Here is a topic with a poll.\'','admin',2,10,1264694090,'Reported post in \'Here is a topic with a poll.\'','admin',1,0,'','','',5,1,2,0,NULL,NULL,'',NULL,'',0,1),(8,2,866,11,1264694559,'This topic is pinned.','admin',2,13,1265476759,'','admin',2,0,'','','',3,1,5,1,NULL,NULL,'',NULL,'',0,1),(9,2,867,12,1264694612,'This topic is sunk.','admin',2,12,1264694612,'This topic is sunk.','admin',1,0,'','','',3,1,1,0,NULL,NULL,'',NULL,'',1,1);
/*!40000 ALTER TABLE `cms_f_topics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_usergroup_subs`
--

DROP TABLE IF EXISTS `cms_f_usergroup_subs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_usergroup_subs` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `s_cost` varchar(255) NOT NULL,
  `s_description` int(10) unsigned NOT NULL,
  `s_enabled` tinyint(1) NOT NULL,
  `s_group_id` int(11) NOT NULL,
  `s_length` int(11) NOT NULL,
  `s_length_units` varchar(255) NOT NULL,
  `s_mail_end` int(10) unsigned NOT NULL,
  `s_mail_start` int(10) unsigned NOT NULL,
  `s_mail_uhoh` int(10) unsigned NOT NULL,
  `s_title` int(10) unsigned NOT NULL,
  `s_uses_primary` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_usergroup_subs`
--

LOCK TABLES `cms_f_usergroup_subs` WRITE;
/*!40000 ALTER TABLE `cms_f_usergroup_subs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_usergroup_subs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_warnings`
--

DROP TABLE IF EXISTS `cms_f_warnings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_warnings` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `p_banned_ip` varchar(40) NOT NULL,
  `p_banned_member` tinyint(1) NOT NULL,
  `p_changed_usergroup_from` int(11) default NULL,
  `p_charged_points` int(11) NOT NULL,
  `p_probation` int(11) NOT NULL,
  `p_silence_from_forum` int(11) default NULL,
  `p_silence_from_topic` int(11) default NULL,
  `w_by` int(11) NOT NULL,
  `w_explanation` longtext NOT NULL,
  `w_is_warning` tinyint(1) NOT NULL,
  `w_member_id` int(11) NOT NULL,
  `w_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `warningsmemberid` (`w_member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_warnings`
--

LOCK TABLES `cms_f_warnings` WRITE;
/*!40000 ALTER TABLE `cms_f_warnings` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_warnings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_f_welcome_emails`
--

DROP TABLE IF EXISTS `cms_f_welcome_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_f_welcome_emails` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `w_name` varchar(255) NOT NULL,
  `w_newsletter` tinyint(1) NOT NULL,
  `w_send_time` int(11) NOT NULL,
  `w_subject` int(10) unsigned NOT NULL,
  `w_text` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_f_welcome_emails`
--

LOCK TABLES `cms_f_welcome_emails` WRITE;
/*!40000 ALTER TABLE `cms_f_welcome_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_f_welcome_emails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_failedlogins`
--

DROP TABLE IF EXISTS `cms_failedlogins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_failedlogins` (
  `date_and_time` int(10) unsigned NOT NULL,
  `failed_account` varchar(80) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip` varchar(40) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_failedlogins`
--

LOCK TABLES `cms_failedlogins` WRITE;
/*!40000 ALTER TABLE `cms_failedlogins` DISABLE KEYS */;
INSERT INTO `cms_failedlogins` VALUES (1264674447,'admin',1,'90.152.0.114'),(1264674456,'admin',2,'90.152.0.114'),(1264674465,'admin',3,'90.152.0.114'),(1265488464,'admin',4,'0000:0000:0000:0000:0000:0000:0000:0001');
/*!40000 ALTER TABLE `cms_failedlogins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_feature_lifetime_monitor`
--

DROP TABLE IF EXISTS `cms_feature_lifetime_monitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_feature_lifetime_monitor` (
  `content_id` varchar(80) NOT NULL,
  `block_cache_id` varchar(80) NOT NULL,
  `run_period` int(11) NOT NULL,
  `running_now` tinyint(1) NOT NULL,
  `last_update` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`content_id`,`block_cache_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_feature_lifetime_monitor`
--

LOCK TABLES `cms_feature_lifetime_monitor` WRITE;
/*!40000 ALTER TABLE `cms_feature_lifetime_monitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_feature_lifetime_monitor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_filedump`
--

DROP TABLE IF EXISTS `cms_filedump`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_filedump` (
  `description` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(80) NOT NULL,
  `path` varchar(255) NOT NULL,
  `the_member` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_filedump`
--

LOCK TABLES `cms_filedump` WRITE;
/*!40000 ALTER TABLE `cms_filedump` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_filedump` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_galleries`
--

DROP TABLE IF EXISTS `cms_galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_galleries` (
  `accept_images` tinyint(1) NOT NULL,
  `accept_videos` tinyint(1) NOT NULL,
  `add_date` int(10) unsigned NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `flow_mode_interface` tinyint(1) NOT NULL,
  `fullname` int(10) unsigned NOT NULL,
  `is_member_synched` tinyint(1) NOT NULL,
  `name` varchar(80) NOT NULL,
  `notes` longtext NOT NULL,
  `parent_id` varchar(80) NOT NULL,
  `rep_image` varchar(255) NOT NULL,
  `teaser` int(10) unsigned NOT NULL,
  `watermark_bottom_left` varchar(255) NOT NULL,
  `watermark_bottom_right` varchar(255) NOT NULL,
  `watermark_top_left` varchar(255) NOT NULL,
  `watermark_top_right` varchar(255) NOT NULL,
  `gallery_views` int(11) NOT NULL default '1',
  `g_owner` int(11) default NULL,
  PRIMARY KEY  (`name`),
  KEY `ftjoin_gfullname` (`fullname`),
  KEY `ftjoin_gdescrip` (`description`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_galleries`
--

LOCK TABLES `cms_galleries` WRITE;
/*!40000 ALTER TABLE `cms_galleries` DISABLE KEYS */;
INSERT INTO `cms_galleries` VALUES (1,1,1264606828,1,1,325,1,327,0,'root','','','',326,'','','','',1,NULL),(1,1,1264673478,1,1,619,0,621,0,'download_1','','root','',620,'','','','',1,NULL),(1,1,1264684918,0,0,751,1,753,0,'randj','','root','uploads/galleries_thumbs/Romeo_and_juliet_brown.jpg',752,'','','','',1,NULL),(1,1,1264685674,1,1,769,0,771,0,'download_2','','root','',770,'','','','',1,NULL);
/*!40000 ALTER TABLE `cms_galleries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_gifts`
--

DROP TABLE IF EXISTS `cms_gifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_gifts` (
  `amount` int(11) NOT NULL,
  `anonymous` tinyint(1) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `gift_from` int(11) NOT NULL,
  `gift_to` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `reason` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_gifts`
--

LOCK TABLES `cms_gifts` WRITE;
/*!40000 ALTER TABLE `cms_gifts` DISABLE KEYS */;
INSERT INTO `cms_gifts` VALUES (35,1,1264607625,1,2,1,495),(150,1,1264607625,1,2,2,496),(10,1,1264608734,1,2,3,533),(10,1,1264671563,1,2,4,593),(150,1,1264673478,1,2,5,624),(35,1,1264673745,1,2,6,631),(150,1,1264673745,1,2,7,632),(30,1,1264680508,1,2,8,666),(30,1,1264681168,1,2,9,669),(225,1,1264683675,1,2,10,719),(225,1,1264683761,1,2,11,725),(100,1,1264684972,1,2,12,759),(100,1,1264685117,1,2,13,763),(150,1,1264685674,1,2,14,774),(10,1,1264685778,1,2,15,775),(10,1,1264685832,1,2,16,780),(10,1,1264687209,1,2,17,795),(10,1,1265479394,1,2,18,956);
/*!40000 ALTER TABLE `cms_gifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_group_category_access`
--

DROP TABLE IF EXISTS `cms_group_category_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_group_category_access` (
  `category_name` varchar(80) NOT NULL,
  `group_id` int(11) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`category_name`,`group_id`,`module_the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_group_category_access`
--

LOCK TABLES `cms_group_category_access` WRITE;
/*!40000 ALTER TABLE `cms_group_category_access` DISABLE KEYS */;
INSERT INTO `cms_group_category_access` VALUES ('0',1,'news'),('0',2,'news'),('0',3,'news'),('0',4,'news'),('0',5,'news'),('0',6,'news'),('0',7,'news'),('0',8,'news'),('0',9,'news'),('0',10,'news'),('1',1,'calendar'),('1',1,'chat'),('1',1,'downloads'),('1',1,'forums'),('1',1,'news'),('1',1,'seedy_page'),('1',2,'downloads'),('1',2,'forums'),('1',2,'news'),('1',2,'seedy_page'),('1',3,'calendar'),('1',3,'chat'),('1',3,'downloads'),('1',3,'forums'),('1',3,'news'),('1',3,'seedy_page'),('1',4,'calendar'),('1',4,'chat'),('1',4,'downloads'),('1',4,'forums'),('1',4,'news'),('1',4,'seedy_page'),('1',5,'calendar'),('1',5,'chat'),('1',5,'downloads'),('1',5,'forums'),('1',5,'news'),('1',5,'seedy_page'),('1',6,'calendar'),('1',6,'chat'),('1',6,'downloads'),('1',6,'forums'),('1',6,'news'),('1',6,'seedy_page'),('1',7,'calendar'),('1',7,'chat'),('1',7,'downloads'),('1',7,'forums'),('1',7,'news'),('1',7,'seedy_page'),('1',8,'calendar'),('1',8,'chat'),('1',8,'downloads'),('1',8,'forums'),('1',8,'news'),('1',8,'seedy_page'),('1',9,'calendar'),('1',9,'chat'),('1',9,'downloads'),('1',9,'forums'),('1',9,'news'),('1',9,'seedy_page'),('1',10,'calendar'),('1',10,'chat'),('1',10,'downloads'),('1',10,'forums'),('1',10,'news'),('1',10,'seedy_page'),('10',3,'forums'),('2',1,'calendar'),('2',1,'downloads'),('2',1,'news'),('2',1,'seedy_page'),('2',2,'news'),('2',3,'calendar'),('2',3,'downloads'),('2',3,'news'),('2',3,'seedy_page'),('2',4,'calendar'),('2',4,'downloads'),('2',4,'news'),('2',4,'seedy_page'),('2',5,'calendar'),('2',5,'downloads'),('2',5,'news'),('2',5,'seedy_page'),('2',6,'calendar'),('2',6,'downloads'),('2',6,'news'),('2',6,'seedy_page'),('2',7,'calendar'),('2',7,'downloads'),('2',7,'news'),('2',7,'seedy_page'),('2',8,'calendar'),('2',8,'downloads'),('2',8,'news'),('2',8,'seedy_page'),('2',9,'calendar'),('2',9,'downloads'),('2',9,'news'),('2',9,'seedy_page'),('2',10,'calendar'),('2',10,'downloads'),('2',10,'news'),('2',10,'seedy_page'),('3',1,'calendar'),('3',1,'catalogues_category'),('3',1,'downloads'),('3',1,'forums'),('3',1,'news'),('3',1,'seedy_page'),('3',2,'catalogues_category'),('3',2,'forums'),('3',2,'news'),('3',3,'calendar'),('3',3,'catalogues_category'),('3',3,'downloads'),('3',3,'forums'),('3',3,'news'),('3',3,'seedy_page'),('3',4,'calendar'),('3',4,'catalogues_category'),('3',4,'downloads'),('3',4,'forums'),('3',4,'news'),('3',4,'seedy_page'),('3',5,'calendar'),('3',5,'catalogues_category'),('3',5,'downloads'),('3',5,'forums'),('3',5,'news'),('3',5,'seedy_page'),('3',6,'calendar'),('3',6,'catalogues_category'),('3',6,'downloads'),('3',6,'forums'),('3',6,'news'),('3',6,'seedy_page'),('3',7,'calendar'),('3',7,'catalogues_category'),('3',7,'downloads'),('3',7,'forums'),('3',7,'news'),('3',7,'seedy_page'),('3',8,'calendar'),('3',8,'catalogues_category'),('3',8,'downloads'),('3',8,'forums'),('3',8,'news'),('3',8,'seedy_page'),('3',9,'calendar'),('3',9,'catalogues_category'),('3',9,'downloads'),('3',9,'forums'),('3',9,'news'),('3',9,'seedy_page'),('3',10,'calendar'),('3',10,'catalogues_category'),('3',10,'downloads'),('3',10,'forums'),('3',10,'news'),('3',10,'seedy_page'),('4',1,'calendar'),('4',1,'forums'),('4',1,'news'),('4',1,'seedy_page'),('4',2,'news'),('4',3,'calendar'),('4',3,'forums'),('4',3,'news'),('4',3,'seedy_page'),('4',4,'calendar'),('4',4,'forums'),('4',4,'news'),('4',4,'seedy_page'),('4',5,'calendar'),('4',5,'forums'),('4',5,'news'),('4',5,'seedy_page'),('4',6,'calendar'),('4',6,'forums'),('4',6,'news'),('4',6,'seedy_page'),('4',7,'calendar'),('4',7,'forums'),('4',7,'news'),('4',7,'seedy_page'),('4',8,'calendar'),('4',8,'forums'),('4',8,'news'),('4',8,'seedy_page'),('4',9,'calendar'),('4',9,'forums'),('4',9,'news'),('4',9,'seedy_page'),('4',10,'calendar'),('4',10,'forums'),('4',10,'news'),('4',10,'seedy_page'),('5',1,'calendar'),('5',1,'news'),('5',2,'forums'),('5',2,'news'),('5',3,'calendar'),('5',3,'forums'),('5',3,'news'),('5',4,'calendar'),('5',4,'news'),('5',5,'calendar'),('5',5,'news'),('5',6,'calendar'),('5',6,'news'),('5',7,'calendar'),('5',7,'news'),('5',8,'calendar'),('5',8,'news'),('5',9,'calendar'),('5',9,'news'),('5',10,'calendar'),('5',10,'news'),('6',1,'calendar'),('6',1,'news'),('6',2,'forums'),('6',2,'news'),('6',3,'calendar'),('6',3,'forums'),('6',3,'news'),('6',4,'calendar'),('6',4,'news'),('6',5,'calendar'),('6',5,'news'),('6',6,'calendar'),('6',6,'news'),('6',7,'calendar'),('6',7,'news'),('6',8,'calendar'),('6',8,'news'),('6',9,'calendar'),('6',9,'news'),('6',10,'calendar'),('6',10,'news'),('7',1,'calendar'),('7',1,'catalogues_category'),('7',1,'forums'),('7',2,'forums'),('7',3,'calendar'),('7',3,'catalogues_category'),('7',3,'forums'),('7',4,'calendar'),('7',4,'catalogues_category'),('7',4,'forums'),('7',5,'calendar'),('7',5,'catalogues_category'),('7',5,'forums'),('7',6,'calendar'),('7',6,'catalogues_category'),('7',6,'forums'),('7',7,'calendar'),('7',7,'catalogues_category'),('7',7,'forums'),('7',8,'calendar'),('7',8,'catalogues_category'),('7',8,'forums'),('7',9,'calendar'),('7',9,'catalogues_category'),('7',9,'forums'),('7',10,'calendar'),('7',10,'catalogues_category'),('7',10,'forums'),('8',1,'calendar'),('8',1,'catalogues_category'),('8',2,'forums'),('8',3,'calendar'),('8',3,'catalogues_category'),('8',3,'forums'),('8',4,'calendar'),('8',4,'catalogues_category'),('8',5,'calendar'),('8',5,'catalogues_category'),('8',6,'calendar'),('8',6,'catalogues_category'),('8',7,'calendar'),('8',7,'catalogues_category'),('8',8,'calendar'),('8',8,'catalogues_category'),('8',9,'calendar'),('8',9,'catalogues_category'),('8',10,'calendar'),('8',10,'catalogues_category'),('9',2,'forums'),('9',3,'forums'),('advertise_here',1,'banners'),('advertise_here',2,'banners'),('advertise_here',3,'banners'),('advertise_here',4,'banners'),('advertise_here',5,'banners'),('advertise_here',6,'banners'),('advertise_here',7,'banners'),('advertise_here',8,'banners'),('advertise_here',9,'banners'),('advertise_here',10,'banners'),('Complaint',1,'tickets'),('Complaint',2,'tickets'),('Complaint',3,'tickets'),('Complaint',4,'tickets'),('Complaint',5,'tickets'),('Complaint',6,'tickets'),('Complaint',7,'tickets'),('Complaint',8,'tickets'),('Complaint',9,'tickets'),('Complaint',10,'tickets'),('donate',1,'banners'),('donate',2,'banners'),('donate',3,'banners'),('donate',4,'banners'),('donate',5,'banners'),('donate',6,'banners'),('donate',7,'banners'),('donate',8,'banners'),('donate',9,'banners'),('donate',10,'banners'),('hosting',1,'banners'),('hosting',2,'banners'),('hosting',3,'banners'),('hosting',4,'banners'),('hosting',5,'banners'),('hosting',6,'banners'),('hosting',7,'banners'),('hosting',8,'banners'),('hosting',9,'banners'),('hosting',10,'banners'),('links',1,'catalogues_catalogue'),('links',2,'catalogues_catalogue'),('links',3,'catalogues_catalogue'),('links',4,'catalogues_catalogue'),('links',5,'catalogues_catalogue'),('links',6,'catalogues_catalogue'),('links',7,'catalogues_catalogue'),('links',8,'catalogues_catalogue'),('links',9,'catalogues_catalogue'),('links',10,'catalogues_catalogue'),('Other',1,'tickets'),('Other',2,'tickets'),('Other',3,'tickets'),('Other',4,'tickets'),('Other',5,'tickets'),('Other',6,'tickets'),('Other',7,'tickets'),('Other',8,'tickets'),('Other',9,'tickets'),('Other',10,'tickets'),('products',1,'catalogues_catalogue'),('products',2,'catalogues_catalogue'),('products',3,'catalogues_catalogue'),('products',4,'catalogues_catalogue'),('products',5,'catalogues_catalogue'),('products',6,'catalogues_catalogue'),('products',7,'catalogues_catalogue'),('products',8,'catalogues_catalogue'),('products',9,'catalogues_catalogue'),('products',10,'catalogues_catalogue'),('randj',1,'galleries'),('randj',3,'galleries'),('randj',4,'galleries'),('randj',5,'galleries'),('randj',6,'galleries'),('randj',7,'galleries'),('randj',8,'galleries'),('randj',9,'galleries'),('randj',10,'galleries'),('root',1,'galleries'),('root',2,'galleries'),('root',3,'galleries'),('root',4,'galleries'),('root',5,'galleries'),('root',6,'galleries'),('root',7,'galleries'),('root',8,'galleries'),('root',9,'galleries'),('root',10,'galleries'),('_unnamed_',1,'theme'),('_unnamed_',3,'theme'),('_unnamed_',4,'theme'),('_unnamed_',5,'theme'),('_unnamed_',6,'theme'),('_unnamed_',7,'theme'),('_unnamed_',8,'theme'),('_unnamed_',9,'theme'),('_unnamed_',10,'theme');
/*!40000 ALTER TABLE `cms_group_category_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_group_page_access`
--

DROP TABLE IF EXISTS `cms_group_page_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_group_page_access` (
  `group_id` int(11) NOT NULL,
  `page_name` varchar(80) NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`group_id`,`page_name`,`zone_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_group_page_access`
--

LOCK TABLES `cms_group_page_access` WRITE;
/*!40000 ALTER TABLE `cms_group_page_access` DISABLE KEYS */;
INSERT INTO `cms_group_page_access` VALUES (1,'admin_addons','adminzone'),(1,'admin_import','adminzone'),(1,'admin_occle','adminzone'),(1,'admin_redirects','adminzone'),(1,'admin_staff','adminzone'),(1,'cms_chat','cms'),(2,'admin_addons','adminzone'),(2,'admin_import','adminzone'),(2,'admin_occle','adminzone'),(2,'admin_redirects','adminzone'),(2,'admin_staff','adminzone'),(2,'cms_chat','cms'),(2,'join',''),(3,'admin_addons','adminzone'),(3,'admin_import','adminzone'),(3,'admin_occle','adminzone'),(3,'admin_redirects','adminzone'),(3,'admin_staff','adminzone'),(3,'cms_chat','cms'),(3,'join',''),(4,'admin_addons','adminzone'),(4,'admin_import','adminzone'),(4,'admin_occle','adminzone'),(4,'admin_redirects','adminzone'),(4,'admin_staff','adminzone'),(4,'cms_chat','cms'),(4,'join',''),(5,'admin_addons','adminzone'),(5,'admin_import','adminzone'),(5,'admin_occle','adminzone'),(5,'admin_redirects','adminzone'),(5,'admin_staff','adminzone'),(5,'cms_chat','cms'),(5,'join',''),(6,'admin_addons','adminzone'),(6,'admin_import','adminzone'),(6,'admin_occle','adminzone'),(6,'admin_redirects','adminzone'),(6,'admin_staff','adminzone'),(6,'cms_chat','cms'),(6,'join',''),(7,'admin_addons','adminzone'),(7,'admin_import','adminzone'),(7,'admin_occle','adminzone'),(7,'admin_redirects','adminzone'),(7,'admin_staff','adminzone'),(7,'cms_chat','cms'),(7,'join',''),(8,'admin_addons','adminzone'),(8,'admin_import','adminzone'),(8,'admin_occle','adminzone'),(8,'admin_redirects','adminzone'),(8,'admin_staff','adminzone'),(8,'cms_chat','cms'),(8,'join',''),(9,'admin_addons','adminzone'),(9,'admin_import','adminzone'),(9,'admin_occle','adminzone'),(9,'admin_redirects','adminzone'),(9,'admin_staff','adminzone'),(9,'cms_chat','cms'),(9,'join',''),(10,'admin_addons','adminzone'),(10,'admin_import','adminzone'),(10,'admin_occle','adminzone'),(10,'admin_redirects','adminzone'),(10,'admin_staff','adminzone'),(10,'cms_chat','cms'),(10,'join','');
/*!40000 ALTER TABLE `cms_group_page_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_group_zone_access`
--

DROP TABLE IF EXISTS `cms_group_zone_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_group_zone_access` (
  `group_id` int(11) NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`group_id`,`zone_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_group_zone_access`
--

LOCK TABLES `cms_group_zone_access` WRITE;
/*!40000 ALTER TABLE `cms_group_zone_access` DISABLE KEYS */;
INSERT INTO `cms_group_zone_access` VALUES (1,''),(1,'forum'),(1,'site'),(2,''),(2,'adminzone'),(2,'cms'),(2,'collaboration'),(2,'forum'),(2,'site'),(3,''),(3,'adminzone'),(3,'cms'),(3,'collaboration'),(3,'forum'),(3,'site'),(4,''),(4,'cms'),(4,'collaboration'),(4,'forum'),(4,'site'),(5,''),(5,'cms'),(5,'forum'),(5,'site'),(6,''),(6,'cms'),(6,'forum'),(6,'site'),(7,''),(7,'cms'),(7,'forum'),(7,'site'),(8,''),(8,'cms'),(8,'forum'),(8,'site'),(9,''),(9,'cms'),(9,'forum'),(9,'site'),(10,''),(10,'cms'),(10,'forum'),(10,'site');
/*!40000 ALTER TABLE `cms_group_zone_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_gsp`
--

DROP TABLE IF EXISTS `cms_gsp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_gsp` (
  `category_name` varchar(80) NOT NULL,
  `group_id` int(11) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  `specific_permission` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_value` tinyint(1) NOT NULL,
  PRIMARY KEY  (`category_name`,`group_id`,`module_the_name`,`specific_permission`,`the_page`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_gsp`
--

LOCK TABLES `cms_gsp` WRITE;
/*!40000 ALTER TABLE `cms_gsp` DISABLE KEYS */;
INSERT INTO `cms_gsp` VALUES ('1',1,'forums','submit_lowrange_content','',0),('1',1,'forums','submit_midrange_content','',0),('1',2,'forums','bypass_validation_lowrange_content','',1),('1',2,'forums','bypass_validation_midrange_content','',1),('1',3,'forums','bypass_validation_lowrange_content','',1),('1',3,'forums','bypass_validation_midrange_content','',1),('1',5,'forums','submit_lowrange_content','',0),('1',5,'forums','submit_midrange_content','',0),('1',6,'forums','submit_lowrange_content','',0),('1',6,'forums','submit_midrange_content','',0),('1',7,'forums','submit_lowrange_content','',0),('1',7,'forums','submit_midrange_content','',0),('1',8,'forums','submit_lowrange_content','',0),('1',8,'forums','submit_midrange_content','',0),('1',9,'forums','submit_lowrange_content','',0),('1',9,'forums','submit_midrange_content','',0),('1',10,'forums','submit_lowrange_content','',0),('1',10,'forums','submit_midrange_content','',0),('3',1,'forums','bypass_validation_lowrange_content','',1),('3',1,'forums','bypass_validation_midrange_content','',1),('3',2,'forums','bypass_validation_lowrange_content','',1),('3',2,'forums','bypass_validation_midrange_content','',1),('3',3,'forums','bypass_validation_lowrange_content','',1),('3',3,'forums','bypass_validation_midrange_content','',1),('3',4,'forums','bypass_validation_lowrange_content','',1),('3',4,'forums','bypass_validation_midrange_content','',1),('3',5,'forums','bypass_validation_lowrange_content','',1),('3',5,'forums','bypass_validation_midrange_content','',1),('3',6,'forums','bypass_validation_lowrange_content','',1),('3',6,'forums','bypass_validation_midrange_content','',1),('3',7,'forums','bypass_validation_lowrange_content','',1),('3',7,'forums','bypass_validation_midrange_content','',1),('3',8,'forums','bypass_validation_lowrange_content','',1),('3',8,'forums','bypass_validation_midrange_content','',1),('3',9,'forums','bypass_validation_lowrange_content','',1),('3',9,'forums','bypass_validation_midrange_content','',1),('4',8,'forums','bypass_validation_midrange_content','',1),('4',8,'forums','bypass_validation_lowrange_content','',1),('4',7,'forums','bypass_validation_lowrange_content','',1),('4',7,'forums','bypass_validation_midrange_content','',1),('4',6,'forums','bypass_validation_midrange_content','',1),('4',5,'forums','bypass_validation_midrange_content','',1),('4',6,'forums','bypass_validation_lowrange_content','',1),('4',5,'forums','bypass_validation_lowrange_content','',1),('4',4,'forums','bypass_validation_lowrange_content','',1),('4',4,'forums','bypass_validation_midrange_content','',1),('4',3,'forums','bypass_validation_midrange_content','',1),('4',1,'forums','bypass_validation_midrange_content','',1),('4',3,'forums','bypass_validation_lowrange_content','',1),('4',1,'forums','bypass_validation_lowrange_content','',1),('5',2,'forums','bypass_validation_lowrange_content','',1),('5',2,'forums','bypass_validation_midrange_content','',1),('5',3,'forums','bypass_validation_lowrange_content','',1),('5',3,'forums','bypass_validation_midrange_content','',1),('6',2,'forums','bypass_validation_lowrange_content','',1),('6',2,'forums','bypass_validation_midrange_content','',1),('6',3,'forums','bypass_validation_lowrange_content','',1),('6',3,'forums','bypass_validation_midrange_content','',1),('7',1,'forums','bypass_validation_lowrange_content','',1),('7',1,'forums','bypass_validation_midrange_content','',1),('7',2,'forums','bypass_validation_lowrange_content','',1),('7',2,'forums','bypass_validation_midrange_content','',1),('7',3,'forums','bypass_validation_lowrange_content','',1),('7',3,'forums','bypass_validation_midrange_content','',1),('7',4,'forums','bypass_validation_lowrange_content','',1),('7',4,'forums','bypass_validation_midrange_content','',1),('7',5,'forums','bypass_validation_lowrange_content','',1),('7',5,'forums','bypass_validation_midrange_content','',1),('7',6,'forums','bypass_validation_lowrange_content','',1),('7',6,'forums','bypass_validation_midrange_content','',1),('7',7,'forums','bypass_validation_lowrange_content','',1),('7',7,'forums','bypass_validation_midrange_content','',1),('7',8,'forums','bypass_validation_lowrange_content','',1),('7',8,'forums','bypass_validation_midrange_content','',1),('7',9,'forums','bypass_validation_lowrange_content','',1),('7',9,'forums','bypass_validation_midrange_content','',1),('8',2,'forums','bypass_validation_lowrange_content','',1),('8',2,'forums','bypass_validation_midrange_content','',1),('8',3,'forums','bypass_validation_lowrange_content','',1),('8',3,'forums','bypass_validation_midrange_content','',1),('9',2,'forums','bypass_validation_lowrange_content','',1),('9',2,'forums','bypass_validation_midrange_content','',1),('9',3,'forums','bypass_validation_lowrange_content','',1),('9',3,'forums','bypass_validation_midrange_content','',1),('',1,'','run_multi_moderations','',1),('',2,'','run_multi_moderations','',1),('',3,'','run_multi_moderations','',1),('',4,'','run_multi_moderations','',1),('',5,'','run_multi_moderations','',1),('',6,'','run_multi_moderations','',1),('',7,'','run_multi_moderations','',1),('',8,'','run_multi_moderations','',1),('',9,'','run_multi_moderations','',1),('',10,'','run_multi_moderations','',1),('',1,'','may_track_forums','',1),('',2,'','may_track_forums','',1),('',3,'','may_track_forums','',1),('',4,'','may_track_forums','',1),('',5,'','may_track_forums','',1),('',6,'','may_track_forums','',1),('',7,'','may_track_forums','',1),('',8,'','may_track_forums','',1),('',9,'','may_track_forums','',1),('',10,'','may_track_forums','',1),('',1,'','use_pt','',1),('',2,'','use_pt','',1),('',3,'','use_pt','',1),('',4,'','use_pt','',1),('',5,'','use_pt','',1),('',6,'','use_pt','',1),('',7,'','use_pt','',1),('',8,'','use_pt','',1),('',9,'','use_pt','',1),('',10,'','use_pt','',1),('',1,'','edit_personal_topic_posts','',1),('',2,'','edit_personal_topic_posts','',1),('',3,'','edit_personal_topic_posts','',1),('',4,'','edit_personal_topic_posts','',1),('',5,'','edit_personal_topic_posts','',1),('',6,'','edit_personal_topic_posts','',1),('',7,'','edit_personal_topic_posts','',1),('',8,'','edit_personal_topic_posts','',1),('',9,'','edit_personal_topic_posts','',1),('',10,'','edit_personal_topic_posts','',1),('',1,'','may_unblind_own_poll','',1),('',2,'','may_unblind_own_poll','',1),('',3,'','may_unblind_own_poll','',1),('',4,'','may_unblind_own_poll','',1),('',5,'','may_unblind_own_poll','',1),('',6,'','may_unblind_own_poll','',1),('',7,'','may_unblind_own_poll','',1),('',8,'','may_unblind_own_poll','',1),('',9,'','may_unblind_own_poll','',1),('',10,'','may_unblind_own_poll','',1),('',1,'','may_report_post','',1),('',2,'','may_report_post','',1),('',3,'','may_report_post','',1),('',4,'','may_report_post','',1),('',5,'','may_report_post','',1),('',6,'','may_report_post','',1),('',7,'','may_report_post','',1),('',8,'','may_report_post','',1),('',9,'','may_report_post','',1),('',10,'','may_report_post','',1),('',1,'','view_member_photos','',1),('',2,'','view_member_photos','',1),('',3,'','view_member_photos','',1),('',4,'','view_member_photos','',1),('',5,'','view_member_photos','',1),('',6,'','view_member_photos','',1),('',7,'','view_member_photos','',1),('',8,'','view_member_photos','',1),('',9,'','view_member_photos','',1),('',10,'','view_member_photos','',1),('',1,'','use_quick_reply','',1),('',2,'','use_quick_reply','',1),('',3,'','use_quick_reply','',1),('',4,'','use_quick_reply','',1),('',5,'','use_quick_reply','',1),('',6,'','use_quick_reply','',1),('',7,'','use_quick_reply','',1),('',8,'','use_quick_reply','',1),('',9,'','use_quick_reply','',1),('',10,'','use_quick_reply','',1),('',1,'','view_profiles','',1),('',2,'','view_profiles','',1),('',3,'','view_profiles','',1),('',4,'','view_profiles','',1),('',5,'','view_profiles','',1),('',6,'','view_profiles','',1),('',7,'','view_profiles','',1),('',8,'','view_profiles','',1),('',9,'','view_profiles','',1),('',10,'','view_profiles','',1),('',1,'','own_avatars','',1),('',2,'','own_avatars','',1),('',3,'','own_avatars','',1),('',4,'','own_avatars','',1),('',5,'','own_avatars','',1),('',6,'','own_avatars','',1),('',7,'','own_avatars','',1),('',8,'','own_avatars','',1),('',9,'','own_avatars','',1),('',10,'','own_avatars','',1),('',3,'','rename_self','',1),('',3,'','use_special_emoticons','',1),('',3,'','view_any_profile_field','',1),('',3,'','disable_lost_passwords','',1),('',3,'','close_own_topics','',1),('',3,'','edit_own_polls','',1),('',3,'','double_post','',1),('',3,'','see_warnings','',1),('',3,'','see_ip','',1),('',3,'','may_choose_custom_title','',1),('',3,'','delete_account','',1),('',3,'','view_poll_results_before_voting','',1),('',3,'','moderate_personal_topic','',1),('',3,'','member_maintenance','',1),('',3,'','probate_members','',1),('',3,'','warn_members','',1),('',3,'','control_usergroups','',1),('',3,'','multi_delete_topics','',1),('',3,'','show_user_browsing','',1),('',3,'','see_hidden_groups','',1),('',3,'','pt_anyone','',1),('',2,'','reuse_others_attachments','',1),('',3,'','reuse_others_attachments','',1),('',2,'','use_sms','',1),('',3,'','use_sms','',1),('',2,'','sms_higher_limit','',1),('',3,'','sms_higher_limit','',1),('',2,'','sms_higher_trigger_limit','',1),('',3,'','sms_higher_trigger_limit','',1),('',2,'','draw_to_server','',1),('',3,'','draw_to_server','',1),('',2,'','see_unvalidated','',1),('',3,'','see_unvalidated','',1),('',1,'','jump_to_unvalidated','',1),('',2,'','jump_to_unvalidated','',1),('',3,'','jump_to_unvalidated','',1),('',4,'','jump_to_unvalidated','',1),('',5,'','jump_to_unvalidated','',1),('',6,'','jump_to_unvalidated','',1),('',7,'','jump_to_unvalidated','',1),('',8,'','jump_to_unvalidated','',1),('',9,'','jump_to_unvalidated','',1),('',10,'','jump_to_unvalidated','',1),('',1,'','edit_own_lowrange_content','',1),('',2,'','edit_own_lowrange_content','',1),('',3,'','edit_own_lowrange_content','',1),('',4,'','edit_own_lowrange_content','',1),('',5,'','edit_own_lowrange_content','',1),('',6,'','edit_own_lowrange_content','',1),('',7,'','edit_own_lowrange_content','',1),('',8,'','edit_own_lowrange_content','',1),('',9,'','edit_own_lowrange_content','',1),('',10,'','edit_own_lowrange_content','',1),('',1,'','submit_highrange_content','',1),('',2,'','submit_highrange_content','',1),('',3,'','submit_highrange_content','',1),('',4,'','submit_highrange_content','',1),('',5,'','submit_highrange_content','',1),('',6,'','submit_highrange_content','',1),('',7,'','submit_highrange_content','',1),('',8,'','submit_highrange_content','',1),('',9,'','submit_highrange_content','',1),('',10,'','submit_highrange_content','',1),('',1,'','submit_midrange_content','',1),('',2,'','submit_midrange_content','',1),('',3,'','submit_midrange_content','',1),('',4,'','submit_midrange_content','',1),('',5,'','submit_midrange_content','',1),('',6,'','submit_midrange_content','',1),('',7,'','submit_midrange_content','',1),('',8,'','submit_midrange_content','',1),('',9,'','submit_midrange_content','',1),('',10,'','submit_midrange_content','',1),('',1,'','submit_lowrange_content','',1),('',2,'','submit_lowrange_content','',1),('',3,'','submit_lowrange_content','',1),('',4,'','submit_lowrange_content','',1),('',5,'','submit_lowrange_content','',1),('',6,'','submit_lowrange_content','',1),('',7,'','submit_lowrange_content','',1),('',8,'','submit_lowrange_content','',1),('',9,'','submit_lowrange_content','',1),('',10,'','submit_lowrange_content','',1),('',1,'','bypass_validation_lowrange_content','',1),('',2,'','bypass_validation_lowrange_content','',1),('',3,'','bypass_validation_lowrange_content','',1),('',4,'','bypass_validation_lowrange_content','',1),('',5,'','bypass_validation_lowrange_content','',1),('',6,'','bypass_validation_lowrange_content','',1),('',7,'','bypass_validation_lowrange_content','',1),('',8,'','bypass_validation_lowrange_content','',1),('',9,'','bypass_validation_lowrange_content','',1),('',10,'','bypass_validation_lowrange_content','',1),('',1,'','set_own_author_profile','',1),('',2,'','set_own_author_profile','',1),('',3,'','set_own_author_profile','',1),('',4,'','set_own_author_profile','',1),('',5,'','set_own_author_profile','',1),('',6,'','set_own_author_profile','',1),('',7,'','set_own_author_profile','',1),('',8,'','set_own_author_profile','',1),('',9,'','set_own_author_profile','',1),('',10,'','set_own_author_profile','',1),('',1,'','rate','',1),('',2,'','rate','',1),('',3,'','rate','',1),('',4,'','rate','',1),('',5,'','rate','',1),('',6,'','rate','',1),('',7,'','rate','',1),('',8,'','rate','',1),('',9,'','rate','',1),('',10,'','rate','',1),('',1,'','comment','',1),('',2,'','comment','',1),('',3,'','comment','',1),('',4,'','comment','',1),('',5,'','comment','',1),('',6,'','comment','',1),('',7,'','comment','',1),('',8,'','comment','',1),('',9,'','comment','',1),('',10,'','comment','',1),('',1,'','have_personal_category','',1),('',2,'','have_personal_category','',1),('',3,'','have_personal_category','',1),('',4,'','have_personal_category','',1),('',5,'','have_personal_category','',1),('',6,'','have_personal_category','',1),('',7,'','have_personal_category','',1),('',8,'','have_personal_category','',1),('',9,'','have_personal_category','',1),('',10,'','have_personal_category','',1),('',1,'','vote_in_polls','',1),('',2,'','vote_in_polls','',1),('',3,'','vote_in_polls','',1),('',4,'','vote_in_polls','',1),('',5,'','vote_in_polls','',1),('',6,'','vote_in_polls','',1),('',7,'','vote_in_polls','',1),('',8,'','vote_in_polls','',1),('',9,'','vote_in_polls','',1),('',10,'','vote_in_polls','',1),('',2,'','use_very_dangerous_comcode','',1),('',3,'','use_very_dangerous_comcode','',1),('',2,'','open_virtual_roots','',1),('',3,'','open_virtual_roots','',1),('',2,'','scheduled_publication_times','',1),('',3,'','scheduled_publication_times','',1),('',2,'','mass_delete_from_ip','',1),('',3,'','mass_delete_from_ip','',1),('',2,'','exceed_filesize_limit','',1),('',3,'','exceed_filesize_limit','',1),('',2,'','view_revision_history','',1),('',3,'','view_revision_history','',1),('',2,'','sees_javascript_error_alerts','',1),('',3,'','sees_javascript_error_alerts','',1),('',2,'','see_software_docs','',1),('',3,'','see_software_docs','',1),('',2,'','bypass_flood_control','',1),('',3,'','bypass_flood_control','',1),('',2,'','allow_html','',1),('',3,'','allow_html','',1),('',2,'','remove_page_split','',1),('',3,'','remove_page_split','',1),('',2,'','access_closed_site','',1),('',3,'','access_closed_site','',1),('',2,'','bypass_bandwidth_restriction','',1),('',3,'','bypass_bandwidth_restriction','',1),('',2,'','comcode_dangerous','',1),('',3,'','comcode_dangerous','',1),('',2,'','comcode_nuisance','',1),('',3,'','comcode_nuisance','',1),('',2,'','see_php_errors','',1),('',3,'','see_php_errors','',1),('',2,'','see_stack_dump','',1),('',3,'','see_stack_dump','',1),('',2,'','bypass_word_filter','',1),('',3,'','bypass_word_filter','',1),('',2,'','view_profiling_modes','',1),('',3,'','view_profiling_modes','',1),('',2,'','access_overrun_site','',1),('',3,'','access_overrun_site','',1),('',2,'','bypass_validation_highrange_content','',1),('',3,'','bypass_validation_highrange_content','',1),('',2,'','bypass_validation_midrange_content','',1),('',3,'','bypass_validation_midrange_content','',1),('',2,'','edit_highrange_content','',1),('',3,'','edit_highrange_content','',1),('',2,'','edit_midrange_content','',1),('',3,'','edit_midrange_content','',1),('',2,'','edit_lowrange_content','',1),('',3,'','edit_lowrange_content','',1),('',2,'','edit_own_highrange_content','',1),('',3,'','edit_own_highrange_content','',1),('',2,'','edit_own_midrange_content','',1),('',3,'','edit_own_midrange_content','',1),('',2,'','delete_highrange_content','',1),('',3,'','delete_highrange_content','',1),('',2,'','delete_midrange_content','',1),('',3,'','delete_midrange_content','',1),('',2,'','delete_lowrange_content','',1),('',3,'','delete_lowrange_content','',1),('',2,'','delete_own_highrange_content','',1),('',3,'','delete_own_highrange_content','',1),('',2,'','delete_own_midrange_content','',1),('',3,'','delete_own_midrange_content','',1),('',2,'','delete_own_lowrange_content','',1),('',3,'','delete_own_lowrange_content','',1),('',2,'','can_submit_to_others_categories','',1),('',3,'','can_submit_to_others_categories','',1),('',2,'','search_engine_links','',1),('',3,'','search_engine_links','',1),('',2,'','view_content_history','',1),('',3,'','view_content_history','',1),('',2,'','restore_content_history','',1),('',3,'','restore_content_history','',1),('',2,'','delete_content_history','',1),('',3,'','delete_content_history','',1),('',2,'','submit_cat_highrange_content','',1),('',3,'','submit_cat_highrange_content','',1),('',2,'','submit_cat_midrange_content','',1),('',3,'','submit_cat_midrange_content','',1),('',2,'','submit_cat_lowrange_content','',1),('',3,'','submit_cat_lowrange_content','',1),('',2,'','edit_cat_highrange_content','',1),('',3,'','edit_cat_highrange_content','',1),('',2,'','edit_cat_midrange_content','',1),('',3,'','edit_cat_midrange_content','',1),('',2,'','edit_cat_lowrange_content','',1),('',3,'','edit_cat_lowrange_content','',1),('',2,'','delete_cat_highrange_content','',1),('',3,'','delete_cat_highrange_content','',1),('',2,'','delete_cat_midrange_content','',1),('',3,'','delete_cat_midrange_content','',1),('',2,'','delete_cat_lowrange_content','',1),('',3,'','delete_cat_lowrange_content','',1),('',2,'','edit_own_cat_highrange_content','',1),('',3,'','edit_own_cat_highrange_content','',1),('',2,'','edit_own_cat_midrange_content','',1),('',3,'','edit_own_cat_midrange_content','',1),('',2,'','edit_own_cat_lowrange_content','',1),('',3,'','edit_own_cat_lowrange_content','',1),('',2,'','delete_own_cat_highrange_content','',1),('',3,'','delete_own_cat_highrange_content','',1),('',2,'','delete_own_cat_midrange_content','',1),('',3,'','delete_own_cat_midrange_content','',1),('',2,'','delete_own_cat_lowrange_content','',1),('',3,'','delete_own_cat_lowrange_content','',1),('',2,'','mass_import','',1),('',3,'','mass_import','',1),('10',3,'forums','bypass_validation_lowrange_content','',1),('10',3,'forums','bypass_validation_midrange_content','',1),('',2,'','full_banner_setup','',1),('',3,'','full_banner_setup','',1),('',2,'','view_anyones_banner_stats','',1),('',3,'','view_anyones_banner_stats','',1),('',2,'','banner_free','',1),('',3,'','banner_free','',1),('',1,'','view_calendar','',1),('',2,'','view_calendar','',1),('',3,'','view_calendar','',1),('',4,'','view_calendar','',1),('',5,'','view_calendar','',1),('',6,'','view_calendar','',1),('',7,'','view_calendar','',1),('',8,'','view_calendar','',1),('',9,'','view_calendar','',1),('',10,'','view_calendar','',1),('',1,'','add_public_events','',1),('',2,'','add_public_events','',1),('',3,'','add_public_events','',1),('',4,'','add_public_events','',1),('',5,'','add_public_events','',1),('',6,'','add_public_events','',1),('',7,'','add_public_events','',1),('',8,'','add_public_events','',1),('',9,'','add_public_events','',1),('',10,'','add_public_events','',1),('',2,'','sense_personal_conflicts','',1),('',3,'','sense_personal_conflicts','',1),('',2,'','view_event_subscriptions','',1),('',3,'','view_event_subscriptions','',1),('',2,'','high_catalogue_entry_timeout','',1),('',3,'','high_catalogue_entry_timeout','',1),('',2,'','seedy_manage_tree','',1),('',3,'','seedy_manage_tree','',1),('',1,'','create_private_room','',1),('',2,'','create_private_room','',1),('',3,'','create_private_room','',1),('',4,'','create_private_room','',1),('',5,'','create_private_room','',1),('',6,'','create_private_room','',1),('',7,'','create_private_room','',1),('',8,'','create_private_room','',1),('',9,'','create_private_room','',1),('',10,'','create_private_room','',1),('',1,'','start_im','',1),('',2,'','start_im','',1),('',3,'','start_im','',1),('',4,'','start_im','',1),('',5,'','start_im','',1),('',6,'','start_im','',1),('',7,'','start_im','',1),('',8,'','start_im','',1),('',9,'','start_im','',1),('',10,'','start_im','',1),('',1,'','moderate_my_private_rooms','',1),('',2,'','moderate_my_private_rooms','',1),('',3,'','moderate_my_private_rooms','',1),('',4,'','moderate_my_private_rooms','',1),('',5,'','moderate_my_private_rooms','',1),('',6,'','moderate_my_private_rooms','',1),('',7,'','moderate_my_private_rooms','',1),('',8,'','moderate_my_private_rooms','',1),('',9,'','moderate_my_private_rooms','',1),('',10,'','moderate_my_private_rooms','',1),('',2,'','ban_chatters_from_rooms','',1),('',3,'','ban_chatters_from_rooms','',1),('',2,'','may_download_gallery','',1),('',3,'','may_download_gallery','',1),('',2,'','high_personal_gallery_limit','',1),('',3,'','high_personal_gallery_limit','',1),('',2,'','no_personal_gallery_limit','',1),('',3,'','no_personal_gallery_limit','',1),('',2,'','choose_iotd','',1),('',3,'','choose_iotd','',1),('',2,'','change_newsletter_subscriptions','',1),('',3,'','change_newsletter_subscriptions','',1),('',1,'','use_points','',1),('',2,'','use_points','',1),('',3,'','use_points','',1),('',4,'','use_points','',1),('',5,'','use_points','',1),('',6,'','use_points','',1),('',7,'','use_points','',1),('',8,'','use_points','',1),('',9,'','use_points','',1),('',10,'','use_points','',1),('',2,'','give_points_self','',1),('',3,'','give_points_self','',1),('',2,'','have_negative_gift_points','',1),('',3,'','have_negative_gift_points','',1),('',2,'','give_negative_points','',1),('',3,'','give_negative_points','',1),('',2,'','view_charge_log','',1),('',3,'','view_charge_log','',1),('',2,'','trace_anonymous_gifts','',1),('',3,'','trace_anonymous_gifts','',1),('',2,'','choose_poll','',1),('',3,'','choose_poll','',1),('',2,'','access_ecommerce_in_test_mode','',1),('',3,'','access_ecommerce_in_test_mode','',1),('',2,'','bypass_quiz_repeat_time_restriction','',1),('',3,'','bypass_quiz_repeat_time_restriction','',1),('',2,'','perform_tests','',1),('',3,'','perform_tests','',1),('',1,'','add_tests','',1),('',2,'','add_tests','',1),('',3,'','add_tests','',1),('',4,'','add_tests','',1),('',5,'','add_tests','',1),('',6,'','add_tests','',1),('',7,'','add_tests','',1),('',8,'','add_tests','',1),('',9,'','add_tests','',1),('',10,'','add_tests','',1),('',1,'','edit_own_tests','',1),('',2,'','edit_own_tests','',1),('',3,'','edit_own_tests','',1),('',4,'','edit_own_tests','',1),('',5,'','edit_own_tests','',1),('',6,'','edit_own_tests','',1),('',7,'','edit_own_tests','',1),('',8,'','edit_own_tests','',1),('',9,'','edit_own_tests','',1),('',10,'','edit_own_tests','',1),('',2,'','support_operator','',1),('',3,'','support_operator','',1),('',2,'','view_others_tickets','',1),('',3,'','view_others_tickets','',1),('',2,'','upload_anything_filedump','',1),('',3,'','upload_anything_filedump','',1),('',1,'','upload_filedump','',1),('',2,'','upload_filedump','',1),('',3,'','upload_filedump','',1),('',4,'','upload_filedump','',1),('',5,'','upload_filedump','',1),('',6,'','upload_filedump','',1),('',7,'','upload_filedump','',1),('',8,'','upload_filedump','',1),('',9,'','upload_filedump','',1),('',10,'','upload_filedump','',1),('',2,'','delete_anything_filedump','',1),('',3,'','delete_anything_filedump','',1),('',10,'','have_personal_category','cms_galleries',1),('',9,'','have_personal_category','cms_galleries',1),('',8,'','have_personal_category','cms_galleries',1),('',7,'','have_personal_category','cms_galleries',1),('',6,'','have_personal_category','cms_galleries',1),('',5,'','have_personal_category','cms_galleries',1),('',4,'','have_personal_category','cms_galleries',1),('',3,'','have_personal_category','cms_galleries',1),('',1,'','have_personal_category','cms_galleries',1),('',10,'','have_personal_category','cms_news',1),('',9,'','have_personal_category','cms_news',1),('',8,'','have_personal_category','cms_news',1),('',7,'','have_personal_category','cms_news',1),('',6,'','have_personal_category','cms_news',1),('',5,'','have_personal_category','cms_news',1),('',4,'','have_personal_category','cms_news',1),('',3,'','have_personal_category','cms_news',1),('',1,'','have_personal_category','cms_news',1),('4',9,'forums','bypass_validation_lowrange_content','',1),('4',9,'forums','bypass_validation_midrange_content','',1),('',2,'','may_enable_staff_notifications','',1),('',3,'','may_enable_staff_notifications','',1),('',2,'','use_html_banner','',1),('',3,'','use_html_banner','',1),('',2,'','set_reminders','',1),('',3,'','set_reminders','',1);
/*!40000 ALTER TABLE `cms_gsp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_hackattack`
--

DROP TABLE IF EXISTS `cms_hackattack`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_hackattack` (
  `data_post` longtext NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip` varchar(40) NOT NULL,
  `reason` varchar(80) NOT NULL,
  `reason_param_a` varchar(255) NOT NULL,
  `reason_param_b` varchar(255) NOT NULL,
  `referer` varchar(255) NOT NULL,
  `the_user` int(11) NOT NULL,
  `url` varchar(255) NOT NULL,
  `user_agent` varchar(255) NOT NULL,
  `user_os` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_hackattack`
--

LOCK TABLES `cms_hackattack` WRITE;
/*!40000 ALTER TABLE `cms_hackattack` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_hackattack` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_https_pages`
--

DROP TABLE IF EXISTS `cms_https_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_https_pages` (
  `https_page_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`https_page_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_https_pages`
--

LOCK TABLES `cms_https_pages` WRITE;
/*!40000 ALTER TABLE `cms_https_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_https_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_images`
--

DROP TABLE IF EXISTS `cms_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_images` (
  `add_date` int(10) unsigned NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `cat` varchar(80) NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `image_views` int(11) NOT NULL,
  `notes` longtext NOT NULL,
  `submitter` int(11) NOT NULL,
  `thumb_url` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `title` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `category_list` (`cat`),
  KEY `i_validated` (`validated`),
  KEY `ftjoin_icomments` (`comments`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_images`
--

LOCK TABLES `cms_images` WRITE;
/*!40000 ALTER TABLE `cms_images` DISABLE KEYS */;
INSERT INTO `cms_images` VALUES (1264684972,1,1,1,'randj',756,NULL,1,2,'',2,'uploads/galleries_thumbs/Romeo_and_juliet_brown.jpg','uploads/galleries/Romeo_and_juliet_brown.jpg',1,1033),(1264685116,1,1,1,'randj',760,NULL,2,1,'',2,'uploads/galleries_thumbs/romeo_and_juliet_.jpg','uploads/galleries/romeo_and_juliet_.jpg',1,1034);
/*!40000 ALTER TABLE `cms_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_import_id_remap`
--

DROP TABLE IF EXISTS `cms_import_id_remap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_import_id_remap` (
  `id_new` int(11) NOT NULL,
  `id_old` varchar(80) NOT NULL,
  `id_session` int(11) NOT NULL,
  `id_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`id_old`,`id_session`,`id_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_import_id_remap`
--

LOCK TABLES `cms_import_id_remap` WRITE;
/*!40000 ALTER TABLE `cms_import_id_remap` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_import_id_remap` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_import_parts_done`
--

DROP TABLE IF EXISTS `cms_import_parts_done`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_import_parts_done` (
  `imp_id` varchar(255) NOT NULL,
  `imp_session` int(11) NOT NULL,
  PRIMARY KEY  (`imp_id`,`imp_session`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_import_parts_done`
--

LOCK TABLES `cms_import_parts_done` WRITE;
/*!40000 ALTER TABLE `cms_import_parts_done` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_import_parts_done` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_import_session`
--

DROP TABLE IF EXISTS `cms_import_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_import_session` (
  `imp_db_name` varchar(80) NOT NULL,
  `imp_db_table_prefix` varchar(80) NOT NULL,
  `imp_db_user` varchar(80) NOT NULL,
  `imp_hook` varchar(80) NOT NULL,
  `imp_old_base_dir` varchar(255) NOT NULL,
  `imp_refresh_time` int(11) NOT NULL,
  `imp_session` int(11) NOT NULL,
  PRIMARY KEY  (`imp_session`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_import_session`
--

LOCK TABLES `cms_import_session` WRITE;
/*!40000 ALTER TABLE `cms_import_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_import_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_incoming_uploads`
--

DROP TABLE IF EXISTS `cms_incoming_uploads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_incoming_uploads` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `i_date_and_time` int(10) unsigned NOT NULL,
  `i_orig_filename` varchar(80) NOT NULL,
  `i_save_url` varchar(255) NOT NULL,
  `i_submitter` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_incoming_uploads`
--

LOCK TABLES `cms_incoming_uploads` WRITE;
/*!40000 ALTER TABLE `cms_incoming_uploads` DISABLE KEYS */;
INSERT INTO `cms_incoming_uploads` VALUES (13,1265480593,'Shakespeare-1.jpg','uploads/incoming/4b6db391be243.dat',2),(12,1265480588,'Shakespeare-1.jpg','uploads/incoming/4b6db38c644c9.dat',2);
/*!40000 ALTER TABLE `cms_incoming_uploads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_invoices`
--

DROP TABLE IF EXISTS `cms_invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_invoices` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `i_amount` varchar(255) NOT NULL,
  `i_member_id` int(11) NOT NULL,
  `i_note` longtext NOT NULL,
  `i_special` varchar(255) NOT NULL,
  `i_state` varchar(80) NOT NULL,
  `i_time` int(10) unsigned NOT NULL,
  `i_type_code` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_invoices`
--

LOCK TABLES `cms_invoices` WRITE;
/*!40000 ALTER TABLE `cms_invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_iotd`
--

DROP TABLE IF EXISTS `cms_iotd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_iotd` (
  `add_date` int(10) unsigned NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `caption` int(10) unsigned NOT NULL,
  `date_and_time` int(10) unsigned default NULL,
  `edit_date` int(10) unsigned default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `iotd_views` int(11) NOT NULL,
  `is_current` tinyint(1) NOT NULL,
  `i_title` int(10) unsigned NOT NULL,
  `notes` longtext NOT NULL,
  `submitter` int(11) NOT NULL,
  `thumb_url` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `used` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `get_current` (`is_current`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_iotd`
--

LOCK TABLES `cms_iotd` WRITE;
/*!40000 ALTER TABLE `cms_iotd` DISABLE KEYS */;
INSERT INTO `cms_iotd` VALUES (1264673745,1,1,1,630,1264673745,NULL,1,2,1,629,'',2,'uploads/iotds_thumbs/Shakespeare.jpg','uploads/iotds/Shakespeare.jpg',1);
/*!40000 ALTER TABLE `cms_iotd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_ip_country`
--

DROP TABLE IF EXISTS `cms_ip_country`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_ip_country` (
  `begin_num` int(10) unsigned NOT NULL,
  `country` varchar(255) NOT NULL,
  `end_num` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_ip_country`
--

LOCK TABLES `cms_ip_country` WRITE;
/*!40000 ALTER TABLE `cms_ip_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_ip_country` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_leader_board`
--

DROP TABLE IF EXISTS `cms_leader_board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_leader_board` (
  `date_and_time` int(10) unsigned NOT NULL,
  `lb_member` int(11) NOT NULL,
  `lb_points` int(11) NOT NULL,
  PRIMARY KEY  (`date_and_time`,`lb_member`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_leader_board`
--

LOCK TABLES `cms_leader_board` WRITE;
/*!40000 ALTER TABLE `cms_leader_board` DISABLE KEYS */;
INSERT INTO `cms_leader_board` VALUES (1264607454,3,40),(1264607454,2,40),(1265397261,2,1470),(1265397261,3,40),(1332809599,3,40);
/*!40000 ALTER TABLE `cms_leader_board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_link_tracker`
--

DROP TABLE IF EXISTS `cms_link_tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_link_tracker` (
  `c_date_and_time` int(10) unsigned NOT NULL,
  `c_ip_address` varchar(40) NOT NULL,
  `c_member_id` int(11) NOT NULL,
  `c_url` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_link_tracker`
--

LOCK TABLES `cms_link_tracker` WRITE;
/*!40000 ALTER TABLE `cms_link_tracker` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_link_tracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_logged_mail_messages`
--

DROP TABLE IF EXISTS `cms_logged_mail_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_logged_mail_messages` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `m_as` int(11) NOT NULL,
  `m_as_admin` tinyint(1) NOT NULL,
  `m_attachments` longtext NOT NULL,
  `m_date_and_time` int(10) unsigned NOT NULL,
  `m_from_email` varchar(255) NOT NULL,
  `m_from_name` varchar(255) NOT NULL,
  `m_in_html` tinyint(1) NOT NULL,
  `m_member_id` int(11) NOT NULL,
  `m_message` longtext NOT NULL,
  `m_no_cc` tinyint(1) NOT NULL,
  `m_priority` tinyint(4) NOT NULL,
  `m_queued` tinyint(1) NOT NULL,
  `m_subject` varchar(255) NOT NULL,
  `m_to_email` longtext NOT NULL,
  `m_to_name` longtext NOT NULL,
  `m_url` longtext NOT NULL,
  `m_template` varchar(80) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_logged_mail_messages`
--

LOCK TABLES `cms_logged_mail_messages` WRITE;
/*!40000 ALTER TABLE `cms_logged_mail_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_logged_mail_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_long_values`
--

DROP TABLE IF EXISTS `cms_long_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_long_values` (
  `date_and_time` int(10) unsigned NOT NULL,
  `the_name` varchar(80) NOT NULL,
  `the_value` longtext NOT NULL,
  PRIMARY KEY  (`the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_long_values`
--

LOCK TABLES `cms_long_values` WRITE;
/*!40000 ALTER TABLE `cms_long_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_long_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_match_key_messages`
--

DROP TABLE IF EXISTS `cms_match_key_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_match_key_messages` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `k_match_key` varchar(255) NOT NULL,
  `k_message` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_match_key_messages`
--

LOCK TABLES `cms_match_key_messages` WRITE;
/*!40000 ALTER TABLE `cms_match_key_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_match_key_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_member_category_access`
--

DROP TABLE IF EXISTS `cms_member_category_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_member_category_access` (
  `active_until` int(10) unsigned NOT NULL,
  `category_name` varchar(80) NOT NULL,
  `member_id` int(11) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`active_until`,`category_name`,`member_id`,`module_the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_member_category_access`
--

LOCK TABLES `cms_member_category_access` WRITE;
/*!40000 ALTER TABLE `cms_member_category_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_member_category_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_member_page_access`
--

DROP TABLE IF EXISTS `cms_member_page_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_member_page_access` (
  `active_until` int(10) unsigned NOT NULL,
  `member_id` int(11) NOT NULL,
  `page_name` varchar(80) NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`active_until`,`member_id`,`page_name`,`zone_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_member_page_access`
--

LOCK TABLES `cms_member_page_access` WRITE;
/*!40000 ALTER TABLE `cms_member_page_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_member_page_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_member_tracking`
--

DROP TABLE IF EXISTS `cms_member_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_member_tracking` (
  `mt_cache_username` varchar(80) NOT NULL,
  `mt_id` varchar(80) NOT NULL,
  `mt_member_id` int(11) NOT NULL,
  `mt_page` varchar(80) NOT NULL,
  `mt_time` int(10) unsigned NOT NULL,
  `mt_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`mt_id`,`mt_member_id`,`mt_page`,`mt_time`,`mt_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_member_tracking`
--

LOCK TABLES `cms_member_tracking` WRITE;
/*!40000 ALTER TABLE `cms_member_tracking` DISABLE KEYS */;
INSERT INTO `cms_member_tracking` VALUES ('admin','7',2,'topicview',1332809616,'');
/*!40000 ALTER TABLE `cms_member_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_member_zone_access`
--

DROP TABLE IF EXISTS `cms_member_zone_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_member_zone_access` (
  `active_until` int(10) unsigned NOT NULL,
  `member_id` int(11) NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`active_until`,`member_id`,`zone_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_member_zone_access`
--

LOCK TABLES `cms_member_zone_access` WRITE;
/*!40000 ALTER TABLE `cms_member_zone_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_member_zone_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_menu_items`
--

DROP TABLE IF EXISTS `cms_menu_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_menu_items` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `i_caption` int(10) unsigned NOT NULL,
  `i_caption_long` int(10) unsigned NOT NULL,
  `i_check_permissions` tinyint(1) NOT NULL,
  `i_expanded` tinyint(1) NOT NULL,
  `i_menu` varchar(80) NOT NULL,
  `i_new_window` tinyint(1) NOT NULL,
  `i_order` int(11) NOT NULL,
  `i_page_only` varchar(80) NOT NULL,
  `i_parent` int(11) default NULL,
  `i_theme_img_code` varchar(80) NOT NULL,
  `i_url` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=101 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_menu_items`
--

LOCK TABLES `cms_menu_items` WRITE;
/*!40000 ALTER TABLE `cms_menu_items` DISABLE KEYS */;
INSERT INTO `cms_menu_items` VALUES (1,93,94,0,0,'root_website',0,0,'',NULL,'',':'),(2,95,96,0,0,'root_website',0,1,'',NULL,'','_SELF:rules'),(97,1011,1012,0,0,'main_features',0,8,'',NULL,'','site:galleries'),(96,1009,1010,0,0,'main_features',0,7,'',NULL,'','site:cedi'),(6,103,104,0,0,'main_community',0,5,'',NULL,'','_SEARCH:members:type=misc'),(7,105,106,0,0,'main_community',0,6,'',NULL,'','_SEARCH:groups:type=misc'),(8,107,108,0,0,'main_website',0,7,'',NULL,'','_SEARCH:donate'),(9,109,110,1,0,'member_features',0,8,'',NULL,'','_SEARCH:join:type=misc'),(10,111,112,0,0,'member_features',0,9,'',NULL,'','_SEARCH:lostpassword:type=misc'),(11,113,114,0,0,'collab_website',0,10,'',NULL,'','collaboration:'),(12,115,116,0,0,'collab_website',0,11,'',NULL,'','collaboration:about'),(13,117,118,0,0,'collab_website',0,12,'',NULL,'','_SELF:hosting-submit'),(14,119,120,0,0,'collab_features',0,13,'',NULL,'','_SELF:authors:type=misc'),(15,121,122,0,0,'collab_features',0,14,'',NULL,'','_SEARCH:cms_authors:type=_ad'),(16,123,124,0,0,'pc_features',0,15,'',NULL,'','_SEARCH:myhome:id={$USER_OVERIDE}'),(17,125,126,0,0,'pc_features',0,16,'',NULL,'','_SEARCH:members:type=view:id={$USER_OVERIDE}'),(18,127,128,0,0,'pc_edit',0,17,'',NULL,'','_SEARCH:editprofile:type=misc:id={$USER_OVERIDE}'),(19,129,130,0,0,'pc_edit',0,18,'',NULL,'','_SEARCH:editavatar:type=misc:id={$USER_OVERIDE}'),(20,131,132,0,0,'pc_edit',0,19,'',NULL,'','_SEARCH:editphoto:type=misc:id={$USER_OVERIDE}'),(21,133,134,0,0,'pc_edit',0,20,'',NULL,'','_SEARCH:editsignature:type=misc:id={$USER_OVERIDE}'),(22,135,136,0,0,'pc_edit',0,21,'',NULL,'','_SEARCH:edittitle:type=misc:id={$USER_OVERIDE}'),(24,139,140,0,0,'pc_edit',0,23,'',NULL,'','_SEARCH:delete:type=misc:id={$USER_OVERIDE}'),(25,141,142,0,0,'forum_features',0,24,'',NULL,'','_SELF:rules'),(26,143,144,0,0,'forum_features',0,25,'',NULL,'','_SEARCH:members:type=misc'),(27,145,146,0,0,'forum_personal',0,26,'',NULL,'','_SEARCH:members:type=view'),(28,147,148,0,0,'forum_personal',0,27,'',NULL,'','_SEARCH:editprofile:type=misc'),(29,149,150,0,0,'forum_personal',0,28,'',NULL,'','_SEARCH:editavatar:type=misc'),(30,151,152,0,0,'forum_personal',0,29,'',NULL,'','_SEARCH:editphoto:type=misc'),(31,153,154,0,0,'forum_personal',0,30,'',NULL,'','_SEARCH:editsignature:type=misc'),(32,155,156,0,0,'forum_personal',0,31,'',NULL,'','_SEARCH:edittitle:type=misc'),(36,163,164,1,0,'zone_menu',0,35,'',NULL,'','collaboration:'),(37,165,166,1,0,'zone_menu',0,36,'',NULL,'','cms:cms'),(38,167,168,1,0,'zone_menu',0,37,'',NULL,'','adminzone:'),(39,182,183,0,0,'pc_features',0,0,'',NULL,'','_SEARCH:calendar:type=misc:member_id={$USER_OVERIDE}'),(40,268,269,0,0,'main_content',0,1,'',NULL,'','_SEARCH:catalogues:type=misc'),(41,270,271,0,0,'collab_features',0,2,'',NULL,'',''),(42,272,273,0,0,'collab_features',0,3,'',41,'','_SEARCH:catalogues:id=projects:type=index'),(43,274,275,0,0,'collab_features',0,4,'',41,'','_SEARCH:cms_catalogues:catalogue_name=projects:type=add_entry'),(44,304,305,0,0,'cedi_features',0,5,'',NULL,'','_SEARCH:cedi:type=misc'),(45,306,307,0,0,'cedi_features',0,6,'',NULL,'','_SEARCH:cedi:type=random'),(46,308,309,0,0,'cedi_features',0,7,'',NULL,'','_SEARCH:cedi:type=changes'),(47,310,311,0,0,'cedi_features',0,8,'',NULL,'','_SEARCH:cedi:type=tree'),(48,315,316,0,0,'main_community',0,9,'',NULL,'','_SEARCH:chat:type=misc'),(49,317,318,0,0,'pc_features',0,10,'',NULL,'','_SEARCH:chat:type=misc:member_id={$USER_OVERIDE}'),(50,321,322,0,0,'main_content',0,11,'',NULL,'','_SEARCH:downloads:type=misc'),(51,323,324,0,0,'main_content',0,12,'',NULL,'','_SEARCH:galleries:type=misc'),(52,337,338,0,0,'pc_features',0,13,'',NULL,'','_SEARCH:cms_news:type=ad'),(53,339,340,0,0,'main_website',0,14,'',NULL,'','_SEARCH:newsletter:type=misc'),(54,341,342,0,0,'pc_edit',0,15,'',NULL,'','_SEARCH:newsletter:type=misc'),(55,345,346,0,0,'pc_features',0,16,'',NULL,'','_SEARCH:points:type=member:id={$USER_OVERIDE}'),(56,347,348,0,0,'forum_personal',0,17,'',NULL,'','_SEARCH:points:type=member'),(57,349,350,0,0,'main_community',0,18,'',NULL,'','_SEARCH:pointstore:type=misc'),(58,367,368,0,0,'pc_features',0,19,'',NULL,'','_SELF:invoices:type=misc'),(59,369,370,0,0,'pc_features',0,20,'',NULL,'','_SELF:subscriptions:type=misc'),(60,371,372,0,0,'ecommerce_features',0,21,'',NULL,'','_SEARCH:purchase:type=misc'),(61,373,374,0,0,'ecommerce_features',0,22,'',NULL,'','_SEARCH:invoices:type=misc'),(62,375,376,0,0,'ecommerce_features',0,23,'',NULL,'','_SEARCH:subscriptions:type=misc'),(63,377,378,0,0,'ecommerce_features',0,24,'',NULL,'','_SEARCH:shopping:type=my_orders'),(64,393,394,0,0,'main_website',0,25,'',NULL,'','_SEARCH:staff:type=misc'),(65,397,398,0,0,'main_website',0,26,'',NULL,'','_SEARCH:tickets:type=misc'),(66,399,400,0,0,'pc_features',0,27,'',NULL,'','_SEARCH:tickets:type=misc'),(67,401,402,0,0,'member_features',0,0,'',NULL,'','_SEARCH:forumview:type=misc'),(68,403,404,0,0,'pc_features',0,1,'',NULL,'','_SEARCH:forumview:type=pt:id={$USER_OVERIDE}'),(69,405,406,0,0,'forum_features',0,2,'',NULL,'','_SEARCH:forumview:type=misc'),(70,407,408,0,0,'forum_features',0,3,'',NULL,'','_SEARCH:forumview:type=pt'),(71,409,410,0,0,'forum_features',0,4,'',NULL,'','_SEARCH:vforums:type=misc'),(72,411,412,0,0,'forum_features',0,5,'',NULL,'','_SEARCH:vforums:type=unread'),(73,413,414,0,0,'forum_features',0,6,'',NULL,'','_SEARCH:vforums:type=recently_read'),(74,415,416,0,0,'forum_features',0,7,'',NULL,'','_SEARCH:search:type=misc:id=ocf_posts'),(95,1007,1008,0,0,'main_features',0,6,'',NULL,'','site:downloads'),(76,419,420,0,0,'root_website',0,100,'',NULL,'','_SEARCH:recommend:from={$SELF_URL}'),(77,421,422,0,0,'collab_features',0,101,'',NULL,'','_SEARCH:filedump:type=misc'),(78,423,424,0,0,'collab_website',0,102,'',NULL,'','_SEARCH:supermembers'),(98,1013,1014,0,0,'main_features',0,9,'',NULL,'','forum:'),(94,1005,1006,0,0,'main_features',0,4,'',89,'',':feedback'),(93,1003,1004,0,0,'main_features',0,3,'',89,'',':sitemap'),(92,1001,1002,0,0,'main_features',0,2,'',89,'',':rules'),(91,999,1000,0,0,'main_features',0,1,'',89,'',':rich'),(90,997,998,0,0,'main_features',0,0,'',89,'',':menus'),(89,995,996,0,0,'main_features',0,0,'',NULL,'',''),(99,1050,1051,0,0,'main_website',0,0,'',NULL,'','_SEARCH:quiz:type=misc'),(100,1062,1063,0,0,'root_website',0,10,'',NULL,'','_SEARCH:recommend:from={$SELF_URL&,0,0,0,from=<null>}');
/*!40000 ALTER TABLE `cms_menu_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_messages_to_render`
--

DROP TABLE IF EXISTS `cms_messages_to_render`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_messages_to_render` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `r_message` longtext NOT NULL,
  `r_session_id` int(11) NOT NULL,
  `r_time` int(10) unsigned NOT NULL,
  `r_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_messages_to_render`
--

LOCK TABLES `cms_messages_to_render` WRITE;
/*!40000 ALTER TABLE `cms_messages_to_render` DISABLE KEYS */;
INSERT INTO `cms_messages_to_render` VALUES (47,'Your backup is currently being generated in the <tt>exports/backups</tt> directory as <tt>Backup_full_2010-02-06__4b6dbded42275</tt>. You will receive an e-mail once it has been completed, and you will be able to track progress by viewing the log file. Please test your backups are properly generated at least once for any server you host this software on; some servers cause problems that can result in corrupt backup files.',1234,1265483245,'inform');
/*!40000 ALTER TABLE `cms_messages_to_render` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_modules`
--

DROP TABLE IF EXISTS `cms_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_modules` (
  `module_author` varchar(80) NOT NULL,
  `module_hacked_by` varchar(80) NOT NULL,
  `module_hack_version` int(11) default NULL,
  `module_organisation` varchar(80) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  `module_version` int(11) NOT NULL,
  PRIMARY KEY  (`module_the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_modules`
--

LOCK TABLES `cms_modules` WRITE;
/*!40000 ALTER TABLE `cms_modules` DISABLE KEYS */;
INSERT INTO `cms_modules` VALUES ('Chris Graham','',NULL,'ocProducts','admin_permissions',7),('Chris Graham','',NULL,'ocProducts','admin_version',16),('Chris Graham','',NULL,'ocProducts','admin',2),('Chris Graham','',NULL,'ocProducts','admin_actionlog',2),('Chris Graham','',NULL,'ocProducts','admin_addons',3),('Chris Graham','',NULL,'ocProducts','admin_awards',3),('Chris Graham','',NULL,'ocProducts','admin_backup',3),('Chris Graham','',NULL,'ocProducts','admin_banners',2),('Chris Graham','',NULL,'ocProducts','admin_bulkupload',2),('Chris Graham','',NULL,'ocProducts','admin_chat',2),('Chris Graham','',NULL,'ocProducts','admin_cleanup',3),('Chris Graham','',NULL,'ocProducts','admin_config',14),('Chris Graham','',NULL,'ocProducts','admin_custom_comcode',2),('Chris Graham','',NULL,'ocProducts','admin_debrand',2),('Chris Graham','',NULL,'ocProducts','admin_ecommerce',2),('Chris Graham','',NULL,'ocProducts','admin_errorlog',2),('Chris Graham','',NULL,'ocProducts','admin_flagrant',3),('Chris Graham','',NULL,'ocProducts','admin_import',5),('Chris Graham','',NULL,'ocProducts','admin_invoices',2),('Chris Graham','',NULL,'ocProducts','admin_ipban',5),('Chris Graham','',NULL,'ocProducts','admin_lang',2),('Chris Graham','',NULL,'ocProducts','admin_lookup',2),('Chris Graham','',NULL,'ocProducts','admin_menus',2),('Chris Graham','',NULL,'ocProducts','admin_messaging',2),('Chris Graham','',NULL,'ocProducts','admin_newsletter',2),('Philip Withnall','',NULL,'ocProducts','admin_occle',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_categories',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_customprofilefields',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_emoticons',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_forums',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_groups',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_history',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_join',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_ldap',4),('Chris Graham','',NULL,'ocProducts','admin_ocf_merge_members',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_multimoderations',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_post_templates',2),('Chris Graham','',NULL,'ocProducts','admin_ocf_welcome_emails',3),('Manuprathap','',NULL,'ocProducts','admin_orders',2),('Chris Graham','',NULL,'ocProducts','admin_phpinfo',2),('Chris Graham','',NULL,'ocProducts','admin_points',2),('Chris Graham','',NULL,'ocProducts','admin_pointstore',2),('Chris Graham','',NULL,'ocProducts','admin_quiz',2),('Chris Graham','',NULL,'ocProducts','admin_redirects',4),('Chris Graham','',NULL,'ocProducts','admin_security',3),('Chris Graham','',NULL,'ocProducts','admin_setupwizard',2),('Chris Graham','',NULL,'ocProducts','admin_sitetree',4),('Chris Graham','',NULL,'ocProducts','admin_ssl',2),('Chris Graham','',NULL,'ocProducts','admin_staff',3),('Philip Withnall','',NULL,'ocProducts','admin_stats',7),('Chris Graham','',NULL,'ocProducts','admin_themes',4),('Allen Ellis','',NULL,'ocProducts','admin_themewizard',2),('Chris Graham','',NULL,'ocProducts','admin_tickets',2),('Chris Graham','',NULL,'ocProducts','admin_trackbacks',2),('Chris Graham','',NULL,'ocProducts','admin_unvalidated',2),('Chris Graham','',NULL,'ocProducts','admin_wordfilter',3),('Chris Graham','',NULL,'ocProducts','admin_xml_storage',2),('Chris Graham','',NULL,'ocProducts','admin_zones',2),('Chris Graham','',NULL,'ocProducts','authors',3),('Chris Graham','',NULL,'ocProducts','awards',2),('Chris Graham','',NULL,'ocProducts','banners',6),('Chris Graham','',NULL,'ocProducts','bookmarks',2),('Chris Graham','',NULL,'ocProducts','calendar',7),('Chris Graham','',NULL,'ocProducts','catalogues',7),('Chris Graham','',NULL,'ocProducts','cedi',8),('Philip Withnall','',NULL,'ocProducts','chat',11),('Chris Graham','',NULL,'ocProducts','contactmember',2),('Chris Graham','',NULL,'ocProducts','downloads',7),('Chris Graham','',NULL,'ocProducts','galleries',8),('Chris Graham','',NULL,'ocProducts','groups',2),('Chris Graham','',NULL,'ocProducts','invoices',2),('Chris Graham','',NULL,'ocProducts','iotds',4),('Chris Graham','',NULL,'ocProducts','leader_board',2),('Chris Graham','',NULL,'ocProducts','members',2),('Chris Graham','',NULL,'ocProducts','news',5),('Chris Graham','',NULL,'ocProducts','newsletter',9),('Chris Graham','',NULL,'ocProducts','onlinemembers',2),('Chris Graham','',NULL,'ocProducts','points',7),('Allen Ellis','',NULL,'ocProducts','pointstore',5),('Chris Graham','',NULL,'ocProducts','polls',5),('Chris Graham','',NULL,'ocProducts','purchase',4),('Chris Graham','',NULL,'ocProducts','quiz',5),('Chris Graham','',NULL,'ocProducts','search',4),('Manuprathap','',NULL,'ocProducts','shopping',6),('Chris Graham','',NULL,'ocProducts','staff',2),('Chris Graham','',NULL,'ocProducts','subscriptions',4),('Chris Graham','',NULL,'ocProducts','tester',2),('Chris Graham','',NULL,'ocProducts','tickets',5),('Chris Graham','',NULL,'ocProducts','warnings',2),('Chris Graham','',NULL,'ocProducts','forumview',2),('Chris Graham','',NULL,'ocProducts','topics',2),('Chris Graham','',NULL,'ocProducts','topicview',2),('Chris Graham','',NULL,'ocProducts','vforums',2),('Chris Graham','',NULL,'ocProducts','delete',2),('Chris Graham','',NULL,'ocProducts','editavatar',2),('Chris Graham','',NULL,'ocProducts','editphoto',2),('Chris Graham','',NULL,'ocProducts','editprofile',2),('Chris Graham','',NULL,'ocProducts','editsignature',2),('Chris Graham','',NULL,'ocProducts','edittitle',2),('Chris Graham','',NULL,'ocProducts','myhome',2),('Kamen','',NULL,'ocProducts','privacy',1),('Chris Graham','',NULL,'ocProducts','cms',2),('Chris Graham','',NULL,'ocProducts','cms_authors',3),('Chris Graham','',NULL,'ocProducts','cms_banners',2),('Chris Graham','',NULL,'ocProducts','cms_blogs',2),('Chris Graham','',NULL,'ocProducts','cms_calendar',2),('Chris Graham','',NULL,'ocProducts','cms_catalogues',2),('Chris Graham','',NULL,'ocProducts','cms_cedi',4),('Philip Withnall','',NULL,'ocProducts','cms_chat',3),('Chris Graham','',NULL,'ocProducts','cms_comcode_pages',4),('Chris Graham','',NULL,'ocProducts','cms_downloads',2),('Chris Graham','',NULL,'ocProducts','cms_galleries',2),('Chris Graham','',NULL,'ocProducts','cms_iotds',2),('Chris Graham','',NULL,'ocProducts','cms_news',2),('Chris Graham','',NULL,'ocProducts','cms_ocf_groups',2),('Chris Graham','',NULL,'ocProducts','cms_polls',2),('Chris Graham','',NULL,'ocProducts','cms_quiz',2),('Chris Graham','',NULL,'ocProducts','forums',2),('Chris Graham','',NULL,'ocProducts','join',2),('Chris Graham','',NULL,'ocProducts','login',2),('Chris Graham','',NULL,'ocProducts','lostpassword',2),('Chris Graham','',NULL,'ocProducts','recommend',3),('Chris Graham','',NULL,'ocProducts','filedump',3),('Chris Graham','',NULL,'ocProducts','supermembers',2),('Chris Graham','',NULL,'ocProducts','admin_emaillog',2),('Chris Graham','',NULL,'ocProducts','admin_notifications',1),('Chris Graham','',NULL,'ocProducts','admin_realtime_rain',1),('Chris Graham','',NULL,'ocProducts','notifications',1);
/*!40000 ALTER TABLE `cms_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_msp`
--

DROP TABLE IF EXISTS `cms_msp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_msp` (
  `active_until` int(10) unsigned NOT NULL,
  `category_name` varchar(80) NOT NULL,
  `member_id` int(11) NOT NULL,
  `module_the_name` varchar(80) NOT NULL,
  `specific_permission` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_value` tinyint(1) NOT NULL,
  PRIMARY KEY  (`active_until`,`category_name`,`member_id`,`module_the_name`,`specific_permission`,`the_page`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_msp`
--

LOCK TABLES `cms_msp` WRITE;
/*!40000 ALTER TABLE `cms_msp` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_msp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_news`
--

DROP TABLE IF EXISTS `cms_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_news` (
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `author` varchar(80) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `news` int(10) unsigned NOT NULL,
  `news_article` int(10) unsigned NOT NULL,
  `news_category` int(11) NOT NULL,
  `news_image` varchar(255) NOT NULL,
  `news_views` int(11) NOT NULL,
  `notes` longtext NOT NULL,
  `submitter` int(11) NOT NULL,
  `title` int(10) unsigned NOT NULL,
  `validated` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `headlines` (`date_and_time`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_news`
--

LOCK TABLES `cms_news` WRITE;
/*!40000 ALTER TABLE `cms_news` DISABLE KEYS */;
INSERT INTO `cms_news` VALUES (1,1,1,'admin',1264683674,NULL,1,715,716,1,'',3,'',2,714,1),(1,1,1,'admin',1264683761,NULL,2,721,722,1,'',0,'',2,720,1);
/*!40000 ALTER TABLE `cms_news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_news_categories`
--

DROP TABLE IF EXISTS `cms_news_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_news_categories` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `nc_img` varchar(80) NOT NULL,
  `nc_owner` int(11) default NULL,
  `nc_title` int(10) unsigned NOT NULL,
  `notes` longtext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_news_categories`
--

LOCK TABLES `cms_news_categories` WRITE;
/*!40000 ALTER TABLE `cms_news_categories` DISABLE KEYS */;
INSERT INTO `cms_news_categories` VALUES (1,'newscats/general',NULL,330,''),(2,'newscats/technology',NULL,331,''),(3,'newscats/difficulties',NULL,332,''),(4,'newscats/community',NULL,333,''),(5,'newscats/entertainment',NULL,334,''),(6,'newscats/business',NULL,335,''),(7,'newscats/art',NULL,336,'');
/*!40000 ALTER TABLE `cms_news_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_news_category_entries`
--

DROP TABLE IF EXISTS `cms_news_category_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_news_category_entries` (
  `news_entry` int(11) NOT NULL,
  `news_entry_category` int(11) NOT NULL,
  PRIMARY KEY  (`news_entry`,`news_entry_category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_news_category_entries`
--

LOCK TABLES `cms_news_category_entries` WRITE;
/*!40000 ALTER TABLE `cms_news_category_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_news_category_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_news_rss_cloud`
--

DROP TABLE IF EXISTS `cms_news_rss_cloud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_news_rss_cloud` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `register_time` int(10) unsigned NOT NULL,
  `rem_ip` varchar(40) NOT NULL,
  `rem_path` varchar(255) NOT NULL,
  `rem_port` tinyint(4) NOT NULL,
  `rem_procedure` varchar(80) NOT NULL,
  `rem_protocol` varchar(80) NOT NULL,
  `watching_channel` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_news_rss_cloud`
--

LOCK TABLES `cms_news_rss_cloud` WRITE;
/*!40000 ALTER TABLE `cms_news_rss_cloud` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_news_rss_cloud` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_newsletter`
--

DROP TABLE IF EXISTS `cms_newsletter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_newsletter` (
  `code_confirm` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `join_time` int(10) unsigned NOT NULL,
  `language` varchar(80) NOT NULL,
  `n_forename` varchar(255) NOT NULL,
  `n_surname` varchar(255) NOT NULL,
  `pass_salt` varchar(80) NOT NULL,
  `the_password` varchar(33) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_newsletter`
--

LOCK TABLES `cms_newsletter` WRITE;
/*!40000 ALTER TABLE `cms_newsletter` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_newsletter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_newsletter_archive`
--

DROP TABLE IF EXISTS `cms_newsletter_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_newsletter_archive` (
  `date_and_time` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `importance_level` int(11) NOT NULL,
  `language` varchar(80) NOT NULL,
  `newsletter` longtext NOT NULL,
  `subject` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_newsletter_archive`
--

LOCK TABLES `cms_newsletter_archive` WRITE;
/*!40000 ALTER TABLE `cms_newsletter_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_newsletter_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_newsletter_drip_send`
--

DROP TABLE IF EXISTS `cms_newsletter_drip_send`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_newsletter_drip_send` (
  `d_from_email` varchar(255) NOT NULL,
  `d_from_name` varchar(255) NOT NULL,
  `d_html_only` tinyint(1) NOT NULL,
  `d_inject_time` int(10) unsigned NOT NULL,
  `d_message` longtext NOT NULL,
  `d_priority` tinyint(4) NOT NULL,
  `d_subject` varchar(255) NOT NULL,
  `d_to_email` varchar(255) NOT NULL,
  `d_to_name` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `d_template` varchar(80) NOT NULL default '',
  PRIMARY KEY  (`id`),
  KEY `d_inject_time` (`d_inject_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_newsletter_drip_send`
--

LOCK TABLES `cms_newsletter_drip_send` WRITE;
/*!40000 ALTER TABLE `cms_newsletter_drip_send` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_newsletter_drip_send` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_newsletter_periodic`
--

DROP TABLE IF EXISTS `cms_newsletter_periodic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_newsletter_periodic` (
  `id` int(10) unsigned NOT NULL auto_increment,
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
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_newsletter_periodic`
--

LOCK TABLES `cms_newsletter_periodic` WRITE;
/*!40000 ALTER TABLE `cms_newsletter_periodic` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_newsletter_periodic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_newsletter_subscribe`
--

DROP TABLE IF EXISTS `cms_newsletter_subscribe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_newsletter_subscribe` (
  `email` varchar(255) NOT NULL,
  `newsletter_id` int(11) NOT NULL,
  `the_level` tinyint(4) NOT NULL,
  PRIMARY KEY  (`email`,`newsletter_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_newsletter_subscribe`
--

LOCK TABLES `cms_newsletter_subscribe` WRITE;
/*!40000 ALTER TABLE `cms_newsletter_subscribe` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_newsletter_subscribe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_newsletters`
--

DROP TABLE IF EXISTS `cms_newsletters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_newsletters` (
  `description` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_newsletters`
--

LOCK TABLES `cms_newsletters` WRITE;
/*!40000 ALTER TABLE `cms_newsletters` DISABLE KEYS */;
INSERT INTO `cms_newsletters` VALUES (344,1,343);
/*!40000 ALTER TABLE `cms_newsletters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_notification_lockdown`
--

DROP TABLE IF EXISTS `cms_notification_lockdown`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_notification_lockdown` (
  `l_notification_code` varchar(80) NOT NULL,
  `l_setting` int(11) NOT NULL,
  PRIMARY KEY  (`l_notification_code`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_notification_lockdown`
--

LOCK TABLES `cms_notification_lockdown` WRITE;
/*!40000 ALTER TABLE `cms_notification_lockdown` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_notification_lockdown` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_notifications_enabled`
--

DROP TABLE IF EXISTS `cms_notifications_enabled`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_notifications_enabled` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `l_member_id` int(11) NOT NULL,
  `l_notification_code` varchar(80) NOT NULL,
  `l_code_category` varchar(255) NOT NULL,
  `l_setting` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `l_member_id` (`l_member_id`,`l_notification_code`),
  KEY `l_code_category` (`l_code_category`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_notifications_enabled`
--

LOCK TABLES `cms_notifications_enabled` WRITE;
/*!40000 ALTER TABLE `cms_notifications_enabled` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_notifications_enabled` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_occlechat`
--

DROP TABLE IF EXISTS `cms_occlechat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_occlechat` (
  `c_incoming` tinyint(1) NOT NULL,
  `c_message` longtext NOT NULL,
  `c_timestamp` int(10) unsigned NOT NULL,
  `c_url` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_occlechat`
--

LOCK TABLES `cms_occlechat` WRITE;
/*!40000 ALTER TABLE `cms_occlechat` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_occlechat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_poll`
--

DROP TABLE IF EXISTS `cms_poll`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_poll` (
  `add_time` int(11) NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `date_and_time` int(10) unsigned default NULL,
  `edit_date` int(10) unsigned default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `is_current` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `num_options` tinyint(4) NOT NULL,
  `option1` int(10) unsigned NOT NULL,
  `option10` int(10) unsigned default NULL,
  `option2` int(10) unsigned NOT NULL,
  `option3` int(10) unsigned default NULL,
  `option4` int(10) unsigned default NULL,
  `option5` int(10) unsigned default NULL,
  `option6` int(10) unsigned NOT NULL,
  `option7` int(10) unsigned NOT NULL,
  `option8` int(10) unsigned default NULL,
  `option9` int(10) unsigned default NULL,
  `poll_views` int(11) NOT NULL,
  `question` int(10) unsigned NOT NULL,
  `submitter` int(11) NOT NULL,
  `votes1` int(11) NOT NULL,
  `votes10` int(11) NOT NULL,
  `votes2` int(11) NOT NULL,
  `votes3` int(11) NOT NULL,
  `votes4` int(11) NOT NULL,
  `votes5` int(11) NOT NULL,
  `votes6` int(11) NOT NULL,
  `votes7` int(11) NOT NULL,
  `votes8` int(11) NOT NULL,
  `votes9` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `get_current` (`is_current`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_poll`
--

LOCK TABLES `cms_poll` WRITE;
/*!40000 ALTER TABLE `cms_poll` DISABLE KEYS */;
INSERT INTO `cms_poll` VALUES (1264607625,1,1,1,1264607625,1264607713,1,1,'',4,485,494,486,487,488,489,490,491,492,493,7,484,2,0,0,0,0,0,0,0,0,0,0);
/*!40000 ALTER TABLE `cms_poll` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_poll_votes`
--

DROP TABLE IF EXISTS `cms_poll_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_poll_votes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `v_poll_id` int(11) NOT NULL,
  `v_voter_id` int(11) default NULL,
  `v_voter_ip` varchar(40) NOT NULL,
  `v_vote_for` tinyint(4) default NULL,
  PRIMARY KEY  (`id`),
  KEY `v_voter_id` (`v_voter_id`),
  KEY `v_voter_ip` (`v_voter_ip`),
  KEY `v_vote_for` (`v_vote_for`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_poll_votes`
--

LOCK TABLES `cms_poll_votes` WRITE;
/*!40000 ALTER TABLE `cms_poll_votes` DISABLE KEYS */;
INSERT INTO `cms_poll_votes` VALUES (1,1,NULL,'',NULL);
/*!40000 ALTER TABLE `cms_poll_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_prices`
--

DROP TABLE IF EXISTS `cms_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_prices` (
  `name` varchar(80) NOT NULL,
  `price` int(11) NOT NULL,
  PRIMARY KEY  (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_prices`
--

LOCK TABLES `cms_prices` WRITE;
/*!40000 ALTER TABLE `cms_prices` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_prices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_pstore_customs`
--

DROP TABLE IF EXISTS `cms_pstore_customs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_pstore_customs` (
  `c_cost` int(11) NOT NULL,
  `c_description` int(10) unsigned NOT NULL,
  `c_enabled` tinyint(1) NOT NULL,
  `c_one_per_member` tinyint(1) NOT NULL,
  `c_title` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `c_mail_subject` int(10) unsigned NOT NULL default '0',
  `c_mail_body` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_pstore_customs`
--

LOCK TABLES `cms_pstore_customs` WRITE;
/*!40000 ALTER TABLE `cms_pstore_customs` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_pstore_customs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_pstore_permissions`
--

DROP TABLE IF EXISTS `cms_pstore_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_pstore_permissions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `p_category` varchar(80) NOT NULL,
  `p_cost` int(11) NOT NULL,
  `p_description` int(10) unsigned NOT NULL,
  `p_enabled` tinyint(1) NOT NULL,
  `p_hours` int(11) NOT NULL,
  `p_module` varchar(80) NOT NULL,
  `p_page` varchar(80) NOT NULL,
  `p_specific_permission` varchar(80) NOT NULL,
  `p_title` int(10) unsigned NOT NULL,
  `p_type` varchar(80) NOT NULL,
  `p_zone` varchar(80) NOT NULL,
  `p_mail_subject` int(10) unsigned NOT NULL default '0',
  `p_mail_body` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_pstore_permissions`
--

LOCK TABLES `cms_pstore_permissions` WRITE;
/*!40000 ALTER TABLE `cms_pstore_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_pstore_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quiz_entries`
--

DROP TABLE IF EXISTS `cms_quiz_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quiz_entries` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `q_member` int(11) NOT NULL,
  `q_quiz` int(11) NOT NULL,
  `q_results` int(11) NOT NULL,
  `q_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quiz_entries`
--

LOCK TABLES `cms_quiz_entries` WRITE;
/*!40000 ALTER TABLE `cms_quiz_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_quiz_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quiz_entry_answer`
--

DROP TABLE IF EXISTS `cms_quiz_entry_answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quiz_entry_answer` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `q_answer` longtext NOT NULL,
  `q_entry` int(11) NOT NULL,
  `q_question` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quiz_entry_answer`
--

LOCK TABLES `cms_quiz_entry_answer` WRITE;
/*!40000 ALTER TABLE `cms_quiz_entry_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_quiz_entry_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quiz_member_last_visit`
--

DROP TABLE IF EXISTS `cms_quiz_member_last_visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quiz_member_last_visit` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `v_member_id` int(11) NOT NULL,
  `v_time` int(10) unsigned NOT NULL,
  `v_quiz_id` int(11) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quiz_member_last_visit`
--

LOCK TABLES `cms_quiz_member_last_visit` WRITE;
/*!40000 ALTER TABLE `cms_quiz_member_last_visit` DISABLE KEYS */;
INSERT INTO `cms_quiz_member_last_visit` VALUES (1,2,1264684721,1);
/*!40000 ALTER TABLE `cms_quiz_member_last_visit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quiz_question_answers`
--

DROP TABLE IF EXISTS `cms_quiz_question_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quiz_question_answers` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `q_answer_text` int(10) unsigned NOT NULL,
  `q_is_correct` tinyint(1) NOT NULL,
  `q_question` int(11) NOT NULL,
  `q_order` int(11) NOT NULL default '1',
  `q_explanation` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quiz_question_answers`
--

LOCK TABLES `cms_quiz_question_answers` WRITE;
/*!40000 ALTER TABLE `cms_quiz_question_answers` DISABLE KEYS */;
INSERT INTO `cms_quiz_question_answers` VALUES (1,730,0,1,1,1036),(2,731,1,1,1,1037),(3,733,0,2,1,1038),(4,734,1,2,1,1039),(5,735,0,2,1,1040),(6,737,1,3,1,1041),(7,738,0,3,1,1042),(8,739,0,3,1,1043),(9,741,0,4,1,1044),(10,742,1,4,1,1045),(11,743,0,4,1,1046),(12,745,0,5,1,1047),(13,746,1,5,1,1048),(14,747,0,5,1,1049);
/*!40000 ALTER TABLE `cms_quiz_question_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quiz_questions`
--

DROP TABLE IF EXISTS `cms_quiz_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quiz_questions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `q_long_input_field` tinyint(1) NOT NULL,
  `q_num_choosable_answers` int(11) NOT NULL,
  `q_question_text` int(10) unsigned NOT NULL,
  `q_quiz` int(11) NOT NULL,
  `q_order` int(11) NOT NULL default '1',
  `q_required` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quiz_questions`
--

LOCK TABLES `cms_quiz_questions` WRITE;
/*!40000 ALTER TABLE `cms_quiz_questions` DISABLE KEYS */;
INSERT INTO `cms_quiz_questions` VALUES (1,0,1,729,1,1,1),(2,0,1,732,1,1,1),(3,0,1,736,1,1,1),(4,0,1,740,1,1,1),(5,0,1,744,1,1,1);
/*!40000 ALTER TABLE `cms_quiz_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quiz_winner`
--

DROP TABLE IF EXISTS `cms_quiz_winner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quiz_winner` (
  `q_entry` int(11) NOT NULL,
  `q_quiz` int(11) NOT NULL,
  `q_winner_level` int(11) NOT NULL,
  PRIMARY KEY  (`q_entry`,`q_quiz`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quiz_winner`
--

LOCK TABLES `cms_quiz_winner` WRITE;
/*!40000 ALTER TABLE `cms_quiz_winner` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_quiz_winner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_quizzes`
--

DROP TABLE IF EXISTS `cms_quizzes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_quizzes` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `q_add_date` int(10) unsigned NOT NULL,
  `q_close_time` int(10) unsigned default NULL,
  `q_end_text` int(10) unsigned NOT NULL,
  `q_name` int(10) unsigned NOT NULL,
  `q_notes` longtext NOT NULL,
  `q_num_winners` int(11) NOT NULL,
  `q_open_time` int(10) unsigned NOT NULL,
  `q_percentage` int(11) NOT NULL,
  `q_points_for_passing` int(11) NOT NULL,
  `q_redo_time` int(11) default NULL,
  `q_start_text` int(10) unsigned NOT NULL,
  `q_submitter` int(11) NOT NULL,
  `q_tied_newsletter` int(11) default NULL,
  `q_timeout` int(11) default NULL,
  `q_type` varchar(80) NOT NULL,
  `q_validated` tinyint(1) NOT NULL,
  `q_end_text_fail` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_quizzes`
--

LOCK TABLES `cms_quizzes` WRITE;
/*!40000 ALTER TABLE `cms_quizzes` DISABLE KEYS */;
INSERT INTO `cms_quizzes` VALUES (1,1264684716,NULL,728,726,'',0,1264683780,70,500,96,727,2,NULL,NULL,'TEST',1,1035);
/*!40000 ALTER TABLE `cms_quizzes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_rating`
--

DROP TABLE IF EXISTS `cms_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_rating` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `rating` tinyint(4) NOT NULL,
  `rating_for_id` varchar(80) NOT NULL,
  `rating_for_type` varchar(80) NOT NULL,
  `rating_ip` varchar(40) NOT NULL,
  `rating_member` int(11) NOT NULL,
  `rating_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `alt_key` (`rating_for_type`,`rating_for_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_rating`
--

LOCK TABLES `cms_rating` WRITE;
/*!40000 ALTER TABLE `cms_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_redirects`
--

DROP TABLE IF EXISTS `cms_redirects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_redirects` (
  `r_from_page` varchar(80) NOT NULL,
  `r_from_zone` varchar(80) NOT NULL,
  `r_is_transparent` tinyint(1) NOT NULL,
  `r_to_page` varchar(80) NOT NULL,
  `r_to_zone` varchar(80) NOT NULL,
  PRIMARY KEY  (`r_from_page`,`r_from_zone`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_redirects`
--

LOCK TABLES `cms_redirects` WRITE;
/*!40000 ALTER TABLE `cms_redirects` DISABLE KEYS */;
INSERT INTO `cms_redirects` VALUES ('rules','site',1,'rules',''),('rules','forum',1,'rules',''),('hosting-submit','collaboration',1,'hosting-submit','site'),('authors','collaboration',1,'authors','site'),('panel_top','collaboration',1,'panel_top',''),('panel_top','forum',1,'panel_top',''),('panel_top','site',1,'panel_top',''),('panel_bottom','adminzone',1,'panel_bottom',''),('panel_bottom','cms',1,'panel_bottom',''),('panel_bottom','collaboration',1,'panel_bottom',''),('panel_bottom','forum',1,'panel_bottom',''),('panel_bottom','site',1,'panel_bottom','');
/*!40000 ALTER TABLE `cms_redirects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_review_supplement`
--

DROP TABLE IF EXISTS `cms_review_supplement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_review_supplement` (
  `r_post_id` int(11) NOT NULL,
  `r_rating` tinyint(4) NOT NULL,
  `r_rating_for_id` varchar(80) NOT NULL,
  `r_rating_for_type` varchar(80) NOT NULL,
  `r_rating_type` varchar(80) NOT NULL,
  `r_topic_id` int(11) NOT NULL,
  PRIMARY KEY  (`r_post_id`,`r_rating_type`),
  KEY `rating_for_id` (`r_rating_for_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_review_supplement`
--

LOCK TABLES `cms_review_supplement` WRITE;
/*!40000 ALTER TABLE `cms_review_supplement` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_review_supplement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_sales`
--

DROP TABLE IF EXISTS `cms_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_sales` (
  `date_and_time` int(10) unsigned NOT NULL,
  `details` varchar(255) NOT NULL,
  `details2` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `memberid` int(11) NOT NULL,
  `purchasetype` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_sales`
--

LOCK TABLES `cms_sales` WRITE;
/*!40000 ALTER TABLE `cms_sales` DISABLE KEYS */;
INSERT INTO `cms_sales` VALUES (1264685916,'6','',1,2,'GAMBLING');
/*!40000 ALTER TABLE `cms_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_searches_logged`
--

DROP TABLE IF EXISTS `cms_searches_logged`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_searches_logged` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `s_auxillary` longtext NOT NULL,
  `s_member_id` int(11) NOT NULL,
  `s_num_results` int(11) NOT NULL,
  `s_primary` varchar(255) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `past_search` (`s_primary`),
  FULLTEXT KEY `past_search_ft` (`s_primary`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_searches_logged`
--

LOCK TABLES `cms_searches_logged` WRITE;
/*!40000 ALTER TABLE `cms_searches_logged` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_searches_logged` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_searches_saved`
--

DROP TABLE IF EXISTS `cms_searches_saved`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_searches_saved` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `s_auxillary` longtext NOT NULL,
  `s_member_id` int(11) NOT NULL,
  `s_primary` varchar(255) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_title` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_searches_saved`
--

LOCK TABLES `cms_searches_saved` WRITE;
/*!40000 ALTER TABLE `cms_searches_saved` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_searches_saved` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_security_images`
--

DROP TABLE IF EXISTS `cms_security_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_security_images` (
  `si_code` int(11) NOT NULL,
  `si_session_id` int(11) NOT NULL,
  `si_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`si_session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_security_images`
--

LOCK TABLES `cms_security_images` WRITE;
/*!40000 ALTER TABLE `cms_security_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_security_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_seedy_changes`
--

DROP TABLE IF EXISTS `cms_seedy_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_seedy_changes` (
  `date_and_time` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip` varchar(40) NOT NULL,
  `the_action` varchar(80) NOT NULL,
  `the_page` int(11) NOT NULL,
  `the_user` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_seedy_changes`
--

LOCK TABLES `cms_seedy_changes` WRITE;
/*!40000 ALTER TABLE `cms_seedy_changes` DISABLE KEYS */;
INSERT INTO `cms_seedy_changes` VALUES (1264681761,1,'90.152.0.114','CEDI_ADD_PAGE',2,2),(1264681761,2,'90.152.0.114','CEDI_EDIT_TREE',1,2),(1264681798,3,'90.152.0.114','CEDI_ADD_PAGE',3,2),(1264681798,4,'90.152.0.114','CEDI_ADD_PAGE',4,2),(1264681798,5,'90.152.0.114','CEDI_EDIT_TREE',2,2),(1264682251,6,'90.152.0.114','CEDI_EDIT_PAGE',4,2),(1264682350,7,'90.152.0.114','CEDI_MAKE_POST',4,2),(1264682414,8,'90.152.0.114','CEDI_EDIT_PAGE',3,2),(1264682523,9,'90.152.0.114','CEDI_MAKE_POST',3,2);
/*!40000 ALTER TABLE `cms_seedy_changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_seedy_children`
--

DROP TABLE IF EXISTS `cms_seedy_children`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_seedy_children` (
  `child_id` int(11) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `the_order` tinyint(4) NOT NULL,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY  (`child_id`,`parent_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_seedy_children`
--

LOCK TABLES `cms_seedy_children` WRITE;
/*!40000 ALTER TABLE `cms_seedy_children` DISABLE KEYS */;
INSERT INTO `cms_seedy_children` VALUES (2,1,0,'Works by Shakespeare'),(3,2,0,'Hamlet'),(4,2,1,'Romeo and Juliet');
/*!40000 ALTER TABLE `cms_seedy_children` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_seedy_pages`
--

DROP TABLE IF EXISTS `cms_seedy_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_seedy_pages` (
  `add_date` int(10) unsigned NOT NULL,
  `description` int(10) unsigned NOT NULL,
  `hide_posts` tinyint(1) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  `seedy_views` int(11) NOT NULL,
  `submitter` int(11) NOT NULL,
  `title` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_seedy_pages`
--

LOCK TABLES `cms_seedy_pages` WRITE;
/*!40000 ALTER TABLE `cms_seedy_pages` DISABLE KEYS */;
INSERT INTO `cms_seedy_pages` VALUES (1264606827,301,0,1,'',2,1,300),(1264681761,693,0,2,'',3,2,692),(1264681798,697,0,3,'',3,2,696),(1264681798,701,0,4,'',3,2,700);
/*!40000 ALTER TABLE `cms_seedy_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_seedy_posts`
--

DROP TABLE IF EXISTS `cms_seedy_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_seedy_posts` (
  `date_and_time` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `page_id` int(11) NOT NULL,
  `seedy_views` int(11) NOT NULL,
  `the_message` int(10) unsigned NOT NULL,
  `the_user` int(11) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `posts_on_page` (`page_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_seedy_posts`
--

LOCK TABLES `cms_seedy_posts` WRITE;
/*!40000 ALTER TABLE `cms_seedy_posts` DISABLE KEYS */;
INSERT INTO `cms_seedy_posts` VALUES (1264682350,NULL,1,4,0,706,2,1),(1264682523,NULL,2,3,0,709,2,1);
/*!40000 ALTER TABLE `cms_seedy_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_seo_meta`
--

DROP TABLE IF EXISTS `cms_seo_meta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_seo_meta` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `meta_description` int(10) unsigned NOT NULL,
  `meta_for_id` varchar(80) NOT NULL,
  `meta_for_type` varchar(80) NOT NULL,
  `meta_keywords` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `alt_key` (`meta_for_type`,`meta_for_id`)
) ENGINE=MyISAM AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_seo_meta`
--

LOCK TABLES `cms_seo_meta` WRITE;
/*!40000 ALTER TABLE `cms_seo_meta` DISABLE KEYS */;
INSERT INTO `cms_seo_meta` VALUES (1,329,'root','gallery',328),(3,586,'site:banner','comcode_page',585),(48,917,':start','comcode_page',916),(49,953,'site:featured_content','comcode_page',952),(10,613,'2','downloads_category',612),(8,609,'3','downloads_category',608),(44,787,'1','downloads_download',786),(12,623,'download_1','gallery',622),(17,661,'1','catalogue_entry',660),(18,665,'2','catalogue_entry',664),(21,673,'3','catalogue_entry',672),(20,671,'4','catalogue_entry',670),(25,687,'5','catalogue_entry',686),(26,689,'6','catalogue_entry',688),(27,691,'7','catalogue_entry',690),(28,695,'2','seedy_page',694),(32,708,'3','seedy_page',707),(31,705,'4','seedy_page',704),(33,713,'1','event',712),(34,718,'1','news',717),(35,724,'2','news',723),(36,749,'1','quiz',748),(37,755,'randj','gallery',754),(38,758,'1','image',757),(39,762,'2','image',761),(40,768,'2','downloads_download',767),(41,773,'download_2','gallery',772),(42,777,'site:comcode_page','comcode_page',776),(43,782,'site:comcode_page_child','comcode_page',781),(54,1020,':rich','comcode_page',1019),(52,992,':menus','comcode_page',991);
/*!40000 ALTER TABLE `cms_seo_meta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_sessions`
--

DROP TABLE IF EXISTS `cms_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_sessions` (
  `cache_username` varchar(255) NOT NULL,
  `ip` varchar(40) NOT NULL,
  `last_activity` int(10) unsigned NOT NULL,
  `session_confirmed` tinyint(1) NOT NULL,
  `session_invisible` tinyint(1) NOT NULL,
  `the_id` varchar(80) NOT NULL,
  `the_page` varchar(80) NOT NULL,
  `the_session` int(11) NOT NULL,
  `the_title` varchar(255) NOT NULL,
  `the_type` varchar(80) NOT NULL,
  `the_user` int(11) NOT NULL,
  `the_zone` varchar(80) NOT NULL,
  PRIMARY KEY  (`the_session`),
  KEY `delete_old` (`last_activity`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_sessions`
--

LOCK TABLES `cms_sessions` WRITE;
/*!40000 ALTER TABLE `cms_sessions` DISABLE KEYS */;
INSERT INTO `cms_sessions` VALUES ('Guest','166.250.70.*',1332801994,0,0,'','404',1474502488,'','',1,''),('Guest','208.80.194.*',1332801830,0,0,'','start',1995180163,'An error has occurred','',1,'site'),('Guest','188.221.7.*',1332809591,0,0,'','login',572532197,'Login','misc',1,''),('Guest','24.122.1.*',1332808368,0,0,'','404',602938807,'An error has occurred','',1,''),('Guest','189.169.157.*',1332808430,0,0,'','404',1836989374,'','',1,''),('Guest','206.123.119.*',1332809594,0,0,'','login',292269045,'Login','misc',1,''),('admin','188.221.7.*',1332809616,1,0,'7','topicview',1345696213,'Reported post in &#039;Here is a topic with a poll.&#039;','',2,'forum');
/*!40000 ALTER TABLE `cms_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_shopping_cart`
--

DROP TABLE IF EXISTS `cms_shopping_cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_shopping_cart` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `is_deleted` tinyint(1) NOT NULL,
  `ordered_by` int(11) NOT NULL,
  `price` double NOT NULL,
  `price_pre_tax` double NOT NULL,
  `product_code` varchar(255) NOT NULL,
  `product_description` longtext NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_type` varchar(255) NOT NULL,
  `product_weight` double NOT NULL,
  `quantity` int(11) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`,`ordered_by`,`product_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_shopping_cart`
--

LOCK TABLES `cms_shopping_cart` WRITE;
/*!40000 ALTER TABLE `cms_shopping_cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_shopping_cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_shopping_logging`
--

DROP TABLE IF EXISTS `cms_shopping_logging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_shopping_logging` (
  `date_and_time` int(10) unsigned NOT NULL,
  `e_member_id` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip` varchar(40) NOT NULL,
  `last_action` varchar(255) NOT NULL,
  `session_id` int(11) NOT NULL,
  PRIMARY KEY  (`e_member_id`,`id`),
  KEY `calculate_bandwidth` (`date_and_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_shopping_logging`
--

LOCK TABLES `cms_shopping_logging` WRITE;
/*!40000 ALTER TABLE `cms_shopping_logging` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_shopping_logging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_shopping_order`
--

DROP TABLE IF EXISTS `cms_shopping_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_shopping_order` (
  `add_date` int(10) unsigned NOT NULL,
  `c_member` int(11) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  `order_status` varchar(80) NOT NULL,
  `purchase_through` varchar(255) NOT NULL,
  `session_id` int(11) NOT NULL,
  `tax_opted_out` tinyint(1) NOT NULL,
  `tot_price` double NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `recent_shopped` (`add_date`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_shopping_order`
--

LOCK TABLES `cms_shopping_order` WRITE;
/*!40000 ALTER TABLE `cms_shopping_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_shopping_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_shopping_order_addresses`
--

DROP TABLE IF EXISTS `cms_shopping_order_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_shopping_order_addresses` (
  `address_city` varchar(255) NOT NULL,
  `address_country` varchar(255) NOT NULL,
  `address_name` varchar(255) NOT NULL,
  `address_street` longtext NOT NULL,
  `address_zip` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `order_id` int(11) default NULL,
  `receiver_email` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_shopping_order_addresses`
--

LOCK TABLES `cms_shopping_order_addresses` WRITE;
/*!40000 ALTER TABLE `cms_shopping_order_addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_shopping_order_addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_shopping_order_details`
--

DROP TABLE IF EXISTS `cms_shopping_order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_shopping_order_details` (
  `dispatch_status` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `included_tax` double NOT NULL,
  `order_id` int(11) default NULL,
  `p_code` varchar(255) NOT NULL,
  `p_id` int(11) default NULL,
  `p_name` varchar(255) NOT NULL,
  `p_price` double NOT NULL,
  `p_quantity` int(11) NOT NULL,
  `p_type` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_shopping_order_details`
--

LOCK TABLES `cms_shopping_order_details` WRITE;
/*!40000 ALTER TABLE `cms_shopping_order_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_shopping_order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_sitewatchlist`
--

DROP TABLE IF EXISTS `cms_sitewatchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_sitewatchlist` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `siteurl` varchar(255) NOT NULL,
  `site_name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_sitewatchlist`
--

LOCK TABLES `cms_sitewatchlist` WRITE;
/*!40000 ALTER TABLE `cms_sitewatchlist` DISABLE KEYS */;
INSERT INTO `cms_sitewatchlist` VALUES (1,'http://shareddemo.composr.info','Composr demo');
/*!40000 ALTER TABLE `cms_sitewatchlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_sms_log`
--

DROP TABLE IF EXISTS `cms_sms_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_sms_log` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `s_member_id` int(11) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_trigger_ip` varchar(40) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `sms_log_for` (`s_member_id`,`s_time`),
  KEY `sms_trigger_ip` (`s_trigger_ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_sms_log`
--

LOCK TABLES `cms_sms_log` WRITE;
/*!40000 ALTER TABLE `cms_sms_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_sms_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_sp_list`
--

DROP TABLE IF EXISTS `cms_sp_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_sp_list` (
  `p_section` varchar(80) NOT NULL,
  `the_default` tinyint(1) NOT NULL,
  `the_name` varchar(80) NOT NULL,
  PRIMARY KEY  (`the_default`,`the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_sp_list`
--

LOCK TABLES `cms_sp_list` WRITE;
/*!40000 ALTER TABLE `cms_sp_list` DISABLE KEYS */;
INSERT INTO `cms_sp_list` VALUES ('SUBMISSION',0,'delete_own_lowrange_content'),('SUBMISSION',0,'delete_own_midrange_content'),('STAFF_ACTIONS',0,'restore_content_history'),('STAFF_ACTIONS',0,'view_content_history'),('SUBMISSION',0,'edit_highrange_content'),('SUBMISSION',0,'edit_midrange_content'),('SUBMISSION',0,'search_engine_links'),('SUBMISSION',0,'can_submit_to_others_categories'),('SUBMISSION',0,'delete_own_highrange_content'),('SUBMISSION',0,'delete_lowrange_content'),('SUBMISSION',0,'delete_midrange_content'),('SUBMISSION',0,'delete_highrange_content'),('SUBMISSION',0,'edit_own_midrange_content'),('SUBMISSION',0,'edit_own_highrange_content'),('SUBMISSION',0,'edit_lowrange_content'),('SUBMISSION',0,'bypass_validation_midrange_content'),('SUBMISSION',0,'bypass_validation_highrange_content'),('STAFF_ACTIONS',0,'access_overrun_site'),('STAFF_ACTIONS',0,'view_profiling_modes'),('GENERAL_SETTINGS',0,'bypass_word_filter'),('STAFF_ACTIONS',0,'see_stack_dump'),('STAFF_ACTIONS',0,'see_php_errors'),('_COMCODE',0,'comcode_nuisance'),('_COMCODE',0,'comcode_dangerous'),('STAFF_ACTIONS',0,'bypass_bandwidth_restriction'),('STAFF_ACTIONS',0,'access_closed_site'),('GENERAL_SETTINGS',0,'remove_page_split'),('_COMCODE',0,'allow_html'),('GENERAL_SETTINGS',0,'bypass_flood_control'),('GENERAL_SETTINGS',0,'see_software_docs'),('GENERAL_SETTINGS',0,'avoid_simplified_adminzone_look'),('GENERAL_SETTINGS',0,'sees_javascript_error_alerts'),('GENERAL_SETTINGS',0,'view_revision_history'),('SUBMISSION',0,'exceed_filesize_limit'),('SUBMISSION',0,'mass_delete_from_ip'),('SUBMISSION',0,'scheduled_publication_times'),('GENERAL_SETTINGS',0,'open_virtual_roots'),('_COMCODE',0,'use_very_dangerous_comcode'),('POLLS',1,'vote_in_polls'),('SUBMISSION',1,'have_personal_category'),('_FEEDBACK',1,'comment'),('_FEEDBACK',1,'rate'),('SUBMISSION',1,'set_own_author_profile'),('SUBMISSION',1,'bypass_validation_lowrange_content'),('SUBMISSION',1,'submit_lowrange_content'),('SUBMISSION',1,'submit_midrange_content'),('SUBMISSION',1,'submit_highrange_content'),('SUBMISSION',1,'edit_own_lowrange_content'),('GENERAL_SETTINGS',1,'jump_to_unvalidated'),('GENERAL_SETTINGS',0,'see_unvalidated'),('SUBMISSION',0,'draw_to_server'),('SECTION_FORUMS',1,'run_multi_moderations'),('SECTION_FORUMS',1,'may_track_forums'),('SECTION_FORUMS',1,'use_pt'),('SECTION_FORUMS',1,'edit_personal_topic_posts'),('SECTION_FORUMS',1,'may_unblind_own_poll'),('SECTION_FORUMS',1,'may_report_post'),('SECTION_FORUMS',1,'view_member_photos'),('SECTION_FORUMS',1,'use_quick_reply'),('SECTION_FORUMS',1,'view_profiles'),('SECTION_FORUMS',1,'own_avatars'),('SECTION_FORUMS',0,'rename_self'),('SECTION_FORUMS',0,'use_special_emoticons'),('SECTION_FORUMS',0,'view_any_profile_field'),('SECTION_FORUMS',0,'disable_lost_passwords'),('SECTION_FORUMS',0,'close_own_topics'),('SECTION_FORUMS',0,'edit_own_polls'),('SECTION_FORUMS',0,'double_post'),('SECTION_FORUMS',0,'see_warnings'),('SECTION_FORUMS',0,'see_ip'),('SECTION_FORUMS',0,'may_choose_custom_title'),('SECTION_FORUMS',0,'delete_account'),('SECTION_FORUMS',0,'view_other_pt'),('SECTION_FORUMS',0,'view_poll_results_before_voting'),('SECTION_FORUMS',0,'moderate_personal_topic'),('SECTION_FORUMS',0,'member_maintenance'),('SECTION_FORUMS',0,'probate_members'),('SECTION_FORUMS',0,'warn_members'),('SECTION_FORUMS',0,'control_usergroups'),('SECTION_FORUMS',0,'multi_delete_topics'),('SECTION_FORUMS',0,'show_user_browsing'),('SECTION_FORUMS',0,'see_hidden_groups'),('SECTION_FORUMS',0,'pt_anyone'),('_COMCODE',0,'reuse_others_attachments'),('STAFF_ACTIONS',0,'assume_any_member'),('GENERAL_SETTINGS',0,'use_sms'),('GENERAL_SETTINGS',0,'sms_higher_limit'),('GENERAL_SETTINGS',0,'sms_higher_trigger_limit'),('STAFF_ACTIONS',0,'delete_content_history'),('SUBMISSION',0,'submit_cat_highrange_content'),('SUBMISSION',0,'submit_cat_midrange_content'),('SUBMISSION',0,'submit_cat_lowrange_content'),('SUBMISSION',0,'edit_cat_highrange_content'),('SUBMISSION',0,'edit_cat_midrange_content'),('SUBMISSION',0,'edit_cat_lowrange_content'),('SUBMISSION',0,'delete_cat_highrange_content'),('SUBMISSION',0,'delete_cat_midrange_content'),('SUBMISSION',0,'delete_cat_lowrange_content'),('SUBMISSION',0,'edit_own_cat_highrange_content'),('SUBMISSION',0,'edit_own_cat_midrange_content'),('SUBMISSION',0,'edit_own_cat_lowrange_content'),('SUBMISSION',0,'delete_own_cat_highrange_content'),('SUBMISSION',0,'delete_own_cat_midrange_content'),('SUBMISSION',0,'delete_own_cat_lowrange_content'),('SUBMISSION',0,'mass_import'),('BANNERS',0,'full_banner_setup'),('BANNERS',0,'view_anyones_banner_stats'),('BANNERS',0,'banner_free'),('CALENDAR',1,'view_calendar'),('CALENDAR',1,'add_public_events'),('CALENDAR',0,'view_personal_events'),('CALENDAR',0,'sense_personal_conflicts'),('CALENDAR',0,'view_event_subscriptions'),('CATALOGUES',0,'high_catalogue_entry_timeout'),('SEEDY',0,'seedy_manage_tree'),('SECTION_CHAT',1,'create_private_room'),('SECTION_CHAT',1,'start_im'),('SECTION_CHAT',1,'moderate_my_private_rooms'),('SECTION_CHAT',0,'ban_chatters_from_rooms'),('GALLERIES',0,'may_download_gallery'),('GALLERIES',0,'high_personal_gallery_limit'),('GALLERIES',0,'no_personal_gallery_limit'),('IOTDS',0,'choose_iotd'),('NEWSLETTER',0,'change_newsletter_subscriptions'),('POINTS',1,'use_points'),('POINTS',0,'give_points_self'),('POINTS',0,'have_negative_gift_points'),('POINTS',0,'give_negative_points'),('POINTS',0,'view_charge_log'),('POINTS',0,'trace_anonymous_gifts'),('POLLS',0,'choose_poll'),('ECOMMERCE',0,'access_ecommerce_in_test_mode'),('QUIZZES',0,'bypass_quiz_repeat_time_restriction'),('TESTER',0,'perform_tests'),('TESTER',1,'add_tests'),('TESTER',1,'edit_own_tests'),('SUPPORT_TICKETS',0,'support_operator'),('SUPPORT_TICKETS',0,'view_others_tickets'),('FILE_DUMP',0,'upload_anything_filedump'),('FILE_DUMP',1,'upload_filedump'),('FILE_DUMP',0,'delete_anything_filedump'),('STAFF_ACTIONS',0,'may_enable_staff_notifications'),('_BANNERS',0,'use_html_banner'),('_BANNERS',0,'use_php_banner'),('CALENDAR',0,'set_reminders');
/*!40000 ALTER TABLE `cms_sp_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_staff_tips_dismissed`
--

DROP TABLE IF EXISTS `cms_staff_tips_dismissed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_staff_tips_dismissed` (
  `t_member` int(11) NOT NULL,
  `t_tip` varchar(80) NOT NULL,
  PRIMARY KEY  (`t_member`,`t_tip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_staff_tips_dismissed`
--

LOCK TABLES `cms_staff_tips_dismissed` WRITE;
/*!40000 ALTER TABLE `cms_staff_tips_dismissed` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_staff_tips_dismissed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_stafflinks`
--

DROP TABLE IF EXISTS `cms_stafflinks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_stafflinks` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `link` varchar(255) NOT NULL,
  `link_title` varchar(255) NOT NULL,
  `link_desc` longtext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_stafflinks`
--

LOCK TABLES `cms_stafflinks` WRITE;
/*!40000 ALTER TABLE `cms_stafflinks` DISABLE KEYS */;
INSERT INTO `cms_stafflinks` VALUES (1,'http://compo.sr/','compo.sr','compo.sr'),(2,'http://compo.sr/forum/vforums/unread.htm','compo.sr (topics with unread posts)','compo.sr (topics with unread posts)'),(3,'http://ocproducts.com/','ocProducts (web development services)','ocProducts (web development services)'),(4,'https://www.transifex.com/organization/ocproducts/dashboard','Transifex (Composr language translations)','Transifex (Composr language translations)'),(5,'http://www.google.com/alerts','Google Alerts','Google Alerts'),(6,'http://www.google.com/analytics/','Google Analytics','Google Analytics'),(7,'https://www.google.com/webmasters/tools','Google Webmaster Tools','Google Webmaster Tools'),(8,'http://www.google.com/apps/intl/en/group/index.html','Google Apps (free gmail for domains, etc)','Google Apps (free gmail for domains, etc)'),(9,'http://www.google.com/chrome','Google Chrome (web browser)','Google Chrome (web browser)'),(10,'https://chrome.google.com/extensions/featured/web_dev','Google Chrome addons','Google Chrome addons'),(11,'http://www.getfirefox.com/','Firefox (web browser)','Firefox (web browser)'),(12,'http://www.instantshift.com/2009/01/25/26-essential-firefox-add-ons-for-web-designers/','FireFox addons','FireFox addons'),(13,'http://www.opera.com/','Opera (web browser)','Opera (web browser)'),(14,'http://www.my-debugbar.com/wiki/IETester/HomePage','Internet Explorer Tester (for testing)','Internet Explorer Tester (for testing)'),(15,'http://www.getpaint.net/','Paint.net (free graphics tool)','Paint.net (free graphics tool)'),(16,'http://benhollis.net/software/pnggauntlet/','PNGGauntlet (compress PNG files, Windows)','PNGGauntlet (compress PNG files, Windows)'),(17,'http://imageoptim.pornel.net/','ImageOptim (compress PNG files, Mac)','ImageOptim (compress PNG files, Mac)'),(18,'http://www.iconlet.com/','Iconlet (free icons)','Iconlet (free icons)'),(19,'http://sxc.hu/','stock.xchng (free stock art)','stock.xchng (free stock art)'),(20,'http://www.kompozer.net/','Kompozer (Web design tool)','Kompozer (Web design tool)'),(21,'http://www.sourcegear.com/diffmerge/','DiffMerge','DiffMerge'),(22,'http://www.jingproject.com/','Jing (record screencasts)','Jing (record screencasts)'),(23,'http://www.elief.com/billing/aff.php?aff=035','Elief hosting (quality shared hosting)','Elief hosting (quality shared hosting)'),(24,'http://www.rackspacecloud.com/1043-0-3-13.html','Rackspace Cloud hosting','Rackspace Cloud hosting'),(25,'http://www.jdoqocy.com/click-3972552-10378406','GoDaddy (Domains and SSL certificates)','GoDaddy (Domains and SSL certificates)'),(26,'http://www.silktide.com/siteray','SiteRay (site quality auditing)','SiteRay (site quality auditing)'),(27,'http://www.smashingmagazine.com/','Smashing Magazine (web design articles)','Smashing Magazine (web design articles)'),(28,'http://www.w3schools.com/','w3schools (learn web technologies)','w3schools (learn web technologies)');
/*!40000 ALTER TABLE `cms_stafflinks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_stats`
--

DROP TABLE IF EXISTS `cms_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_stats` (
  `access_denied_counter` int(11) NOT NULL,
  `browser` varchar(255) NOT NULL,
  `date_and_time` int(10) unsigned NOT NULL,
  `get` varchar(255) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `ip` varchar(40) NOT NULL,
  `milliseconds` int(11) NOT NULL,
  `operating_system` varchar(255) NOT NULL,
  `post` longtext NOT NULL,
  `referer` varchar(255) NOT NULL,
  `the_page` varchar(255) NOT NULL,
  `the_user` int(11) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `member_track` (`ip`,`the_user`),
  KEY `pages` (`the_page`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_stats`
--

LOCK TABLES `cms_stats` WRITE;
/*!40000 ALTER TABLE `cms_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_subscriptions`
--

DROP TABLE IF EXISTS `cms_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_subscriptions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `s_amount` varchar(255) NOT NULL,
  `s_auto_fund_key` varchar(255) NOT NULL,
  `s_auto_fund_source` varchar(80) NOT NULL,
  `s_member_id` int(11) NOT NULL,
  `s_special` varchar(255) NOT NULL,
  `s_state` varchar(80) NOT NULL,
  `s_time` int(10) unsigned NOT NULL,
  `s_type_code` varchar(80) NOT NULL,
  `s_via` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_subscriptions`
--

LOCK TABLES `cms_subscriptions` WRITE;
/*!40000 ALTER TABLE `cms_subscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_subscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_temp_block_permissions`
--

DROP TABLE IF EXISTS `cms_temp_block_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_temp_block_permissions` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `p_session_id` int(11) NOT NULL,
  `p_block_constraints` longtext NOT NULL,
  `p_time` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_temp_block_permissions`
--

LOCK TABLES `cms_temp_block_permissions` WRITE;
/*!40000 ALTER TABLE `cms_temp_block_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_temp_block_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_test_sections`
--

DROP TABLE IF EXISTS `cms_test_sections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_test_sections` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `s_assigned_to` int(11) default NULL,
  `s_inheritable` tinyint(1) NOT NULL,
  `s_notes` longtext NOT NULL,
  `s_section` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_test_sections`
--

LOCK TABLES `cms_test_sections` WRITE;
/*!40000 ALTER TABLE `cms_test_sections` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_test_sections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_tests`
--

DROP TABLE IF EXISTS `cms_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_tests` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `t_assigned_to` int(11) default NULL,
  `t_enabled` tinyint(1) NOT NULL,
  `t_inherit_section` int(11) default NULL,
  `t_section` int(11) NOT NULL,
  `t_status` int(11) NOT NULL,
  `t_test` longtext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_tests`
--

LOCK TABLES `cms_tests` WRITE;
/*!40000 ALTER TABLE `cms_tests` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_tests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_text`
--

DROP TABLE IF EXISTS `cms_text`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_text` (
  `activation_time` int(10) unsigned default NULL,
  `active_now` tinyint(1) NOT NULL,
  `days` tinyint(4) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  `order_time` int(10) unsigned NOT NULL,
  `the_message` int(10) unsigned NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_text`
--

LOCK TABLES `cms_text` WRITE;
/*!40000 ALTER TABLE `cms_text` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_text` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_theme_images`
--

DROP TABLE IF EXISTS `cms_theme_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_theme_images` (
  `id` varchar(255) NOT NULL,
  `lang` varchar(5) NOT NULL,
  `path` varchar(255) NOT NULL,
  `theme` varchar(40) NOT NULL,
  PRIMARY KEY  (`id`,`lang`,`theme`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_theme_images`
--

LOCK TABLES `cms_theme_images` WRITE;
/*!40000 ALTER TABLE `cms_theme_images` DISABLE KEYS */;
INSERT INTO `cms_theme_images` VALUES ('logo/-logo','EN','themes/default/images_custom/4b6c6fffb7e0f.png','default'),('zone_gradiant','EN','themes/default/images/zone_gradiant.png','default'),('underline','EN','themes/default/images/underline.gif','default'),('background_image','EN','themes/default/images/background_image.png','default'),('am_icons/warn_large','EN','themes/default/images/am_icons/warn_large.png','default'),('am_icons/inform_large','EN','themes/default/images/am_icons/inform_large.png','default'),('standardboxes/title_left','EN','themes/default/images/standardboxes/title_left.png','default'),('standardboxes/nontitle_left','EN','themes/default/images/standardboxes/nontitle_left.png','default'),('standardboxes/bottom_left','EN','themes/default/images/standardboxes/bottom_left.png','default'),('standardboxes/title_right','EN','themes/default/images/standardboxes/title_right.png','default'),('standardboxes/nontitle_right','EN','themes/default/images/standardboxes/nontitle_right.png','default'),('standardboxes/bottom_right','EN','themes/default/images/standardboxes/bottom_right.png','default'),('standardboxes/title_gradiant','EN','themes/default/images/standardboxes/title_gradiant.png','default'),('donext/titleleft','EN','themes/default/images/donext/titleleft.png','default'),('donext/titleright','EN','themes/default/images/donext/titleright.png','default'),('donext/topleft','EN','themes/default/images/donext/topleft.png','default'),('donext/topcent','EN','themes/default/images/donext/topcent.png','default'),('donext/topright','EN','themes/default/images/donext/topright.png','default'),('donext/midleft','EN','themes/default/images/donext/midleft.png','default'),('donext/midright','EN','themes/default/images/donext/midright.png','default'),('donext/botleft','EN','themes/default/images/donext/botleft.png','default'),('donext/botmid','EN','themes/default/images/donext/botmid.png','default'),('donext/botright','EN','themes/default/images/donext/botright.png','default'),('edited','EN','themes/default/images/edited.png','default'),('quote_gradiant','EN','themes/default/images/quote_gradiant.png','default'),('arrow_box','EN','themes/default/images/arrow_box.png','default'),('arrow_box_hover','EN','themes/default/images/arrow_box_hover.png','default'),('checklist/checklist1','EN','themes/default/images/checklist/checklist1.png','default'),('carousel/button_left','EN','themes/default/images/carousel/button_left.png','default'),('carousel/button_left_hover','EN','themes/default/images/carousel/button_left_hover.png','default'),('carousel/button_right','EN','themes/default/images/carousel/button_right.png','default'),('carousel/button_right_hover','EN','themes/default/images/carousel/button_right_hover.png','default'),('tab','EN','themes/default/images/tab.png','default'),('menus/menu_bullet_expand','EN','themes/default/images/menus/menu_bullet_expand.png','default'),('menus/menu_bullet_expand_hover','EN','themes/default/images/menus/menu_bullet_expand_hover.png','default'),('menus/menu_bullet_current','EN','themes/default/images/menus/menu_bullet_current.png','default'),('menus/menu_bullet','EN','themes/default/images/menus/menu_bullet.png','default'),('menus/menu_bullet_hover','EN','themes/default/images/menus/menu_bullet_hover.png','default'),('recommend/print','EN','themes/default/images/recommend/print.gif','default'),('recommend/recommend','EN','themes/default/images/recommend/recommend.gif','default'),('recommend/favorites','EN','themes/default/images/recommend/favorites.gif','default'),('recommend/facebook','EN','themes/default/images/recommend/facebook.gif','default'),('recommend/twitter','EN','themes/default/images/recommend/twitter.gif','default'),('recommend/stumbleupon','EN','themes/default/images/recommend/stumbleupon.gif','default'),('recommend/digg','EN','themes/default/images/recommend/digg.gif','default'),('filetypes/email_link','EN','themes/default/images/filetypes/email_link.png','default'),('filetypes/page_pdf','EN','themes/default/images/filetypes/page_pdf.png','default'),('filetypes/page_doc','EN','themes/default/images/filetypes/page_doc.png','default'),('filetypes/page_xls','EN','themes/default/images/filetypes/page_xls.png','default'),('filetypes/page_ppt','EN','themes/default/images/filetypes/page_ppt.png','default'),('filetypes/page_txt','EN','themes/default/images/filetypes/page_txt.png','default'),('filetypes/page_odt','EN','themes/default/images/filetypes/page_odt.png','default'),('filetypes/page_ods','EN','themes/default/images/filetypes/page_ods.png','default'),('filetypes/feed','EN','themes/default/images/filetypes/feed.png','default'),('filetypes/page_torrent','EN','themes/default/images/filetypes/page_torrent.png','default'),('filetypes/page_archive','EN','themes/default/images/filetypes/page_archive.png','default'),('filetypes/page_media','EN','themes/default/images/filetypes/page_media.png','default'),('filetypes/external_link','EN','themes/default/images/filetypes/external_link.png','default'),('expand','EN','themes/default/images/expand.png','default'),('contract','EN','themes/default/images/contract.png','default'),('exp_con','EN','themes/default/images/exp_con.png','default'),('help_panel_hide','EN','themes/default/images/help_panel_hide.png','default'),('help_panel_show','EN','themes/default/images/help_panel_show.png','default'),('bottom/loading','EN','themes/default/images/bottom/loading.gif','default'),('bigicons/back','EN','themes/default/images/bigicons/back.png','default'),('bottom/top','EN','themes/default/images/bottom/top.png','default'),('bottom/home','EN','themes/default/images/bottom/home.png','default'),('bottom/sitemap','EN','themes/default/images/bottom/sitemap.png','default'),('page/join','EN','themes/default/images/EN/page/join.png','default'),('page/login','EN','themes/default/images/EN/page/login.png','default'),('menus/menu','EN','themes/default/images/menus/menu.png','default'),('comcode','EN','themes/default/images/comcode.png','default'),('bottom/managementmenu','EN','themes/default/images/bottom/managementmenu.png','default'),('bottom/bookmarksmenu','EN','themes/default/images/bottom/bookmarksmenu.png','default'),('am_icons/notice','EN','themes/default/images/am_icons/notice.png','default'),('bottom/occle','EN','themes/default/images/bottom/occle.png','default'),('logo/adminzone-logo','EN','themes/default/images/EN/logo/adminzone-logo.png','default'),('menu_items/management_navigation/start','EN','themes/default/images/menu_items/management_navigation/start.png','default'),('menu_items/management_navigation/structure','EN','themes/default/images/menu_items/management_navigation/structure.png','default'),('menu_items/management_navigation/security','EN','themes/default/images/menu_items/management_navigation/security.png','default'),('menu_items/management_navigation/style','EN','themes/default/images/menu_items/management_navigation/style.png','default'),('menu_items/management_navigation/setup','EN','themes/default/images/menu_items/management_navigation/setup.png','default'),('menu_items/management_navigation/tools','EN','themes/default/images/menu_items/management_navigation/tools.png','default'),('menu_items/management_navigation/usage','EN','themes/default/images/menu_items/management_navigation/usage.png','default'),('menu_items/management_navigation/cms','EN','themes/default/images/menu_items/management_navigation/cms.png','default'),('menu_items/management_navigation/docs','EN','themes/default/images/menu_items/management_navigation/docs.png','default'),('checklist/checklist0','EN','themes/default/images/checklist/checklist0.png','default'),('checklist/checklist-','EN','themes/default/images/checklist/checklist-.png','default'),('pagepics/ocp-logo','EN','themes/default/images/pagepics/ocp-logo.png','default'),('bigicons/addons','EN','themes/default/images/bigicons/addons.png','default'),('bigicons/awards','EN','themes/default/images/bigicons/awards.png','default'),('bigicons/config','EN','themes/default/images/bigicons/config.png','default'),('bigicons/custom-comcode','EN','themes/default/images/bigicons/custom-comcode.png','default'),('bigicons/customprofilefields','EN','themes/default/images/bigicons/customprofilefields.png','default'),('bigicons/baseconfig','EN','themes/default/images/bigicons/baseconfig.png','default'),('bigicons/pointstore','EN','themes/default/images/bigicons/pointstore.png','default'),('bigicons/multimods','EN','themes/default/images/bigicons/multimods.png','default'),('bigicons/posttemplates','EN','themes/default/images/bigicons/posttemplates.png','default'),('bigicons/setupwizard','EN','themes/default/images/bigicons/setupwizard.png','default'),('bigicons/tickets','EN','themes/default/images/bigicons/tickets.png','default'),('bigicons/ecommerce','EN','themes/default/images/bigicons/ecommerce.png','default'),('bigicons/welcome_emails','EN','themes/default/images/bigicons/welcome_emails.png','default'),('pagepics/configwizard','EN','themes/default/images/pagepics/configwizard.png','default'),('treenav','EN','themes/default/images/treenav.png','default'),('logo/-logo','EN','themes/_unnamed_/images_custom/4b6c6fffa1a90.png','_unnamed_'),('zone_gradiant','EN','themes/default/images/zone_gradiant.png','_unnamed_'),('underline','EN','themes/default/images/underline.gif','_unnamed_'),('background_image','EN','themes/default/images/background_image.png','_unnamed_'),('am_icons/warn_large','EN','themes/default/images/am_icons/warn_large.png','_unnamed_'),('am_icons/inform_large','EN','themes/default/images/am_icons/inform_large.png','_unnamed_'),('standardboxes/title_left','EN','themes/default/images/standardboxes/title_left.png','_unnamed_'),('standardboxes/nontitle_left','EN','themes/default/images/standardboxes/nontitle_left.png','_unnamed_'),('standardboxes/bottom_left','EN','themes/default/images/standardboxes/bottom_left.png','_unnamed_'),('standardboxes/title_right','EN','themes/default/images/standardboxes/title_right.png','_unnamed_'),('standardboxes/nontitle_right','EN','themes/default/images/standardboxes/nontitle_right.png','_unnamed_'),('standardboxes/bottom_right','EN','themes/default/images/standardboxes/bottom_right.png','_unnamed_'),('standardboxes/title_gradiant','EN','themes/default/images/standardboxes/title_gradiant.png','_unnamed_'),('donext/titleleft','EN','themes/default/images/donext/titleleft.png','_unnamed_'),('donext/titleright','EN','themes/default/images/donext/titleright.png','_unnamed_'),('donext/topleft','EN','themes/default/images/donext/topleft.png','_unnamed_'),('donext/topcent','EN','themes/default/images/donext/topcent.png','_unnamed_'),('donext/topright','EN','themes/default/images/donext/topright.png','_unnamed_'),('donext/midleft','EN','themes/default/images/donext/midleft.png','_unnamed_'),('donext/midright','EN','themes/default/images/donext/midright.png','_unnamed_'),('donext/botleft','EN','themes/default/images/donext/botleft.png','_unnamed_'),('donext/botmid','EN','themes/default/images/donext/botmid.png','_unnamed_'),('donext/botright','EN','themes/default/images/donext/botright.png','_unnamed_'),('edited','EN','themes/default/images/edited.png','_unnamed_'),('quote_gradiant','EN','themes/default/images/quote_gradiant.png','_unnamed_'),('arrow_box','EN','themes/default/images/arrow_box.png','_unnamed_'),('arrow_box_hover','EN','themes/default/images/arrow_box_hover.png','_unnamed_'),('checklist/checklist1','EN','themes/default/images/checklist/checklist1.png','_unnamed_'),('carousel/button_left','EN','themes/default/images/carousel/button_left.png','_unnamed_'),('carousel/button_left_hover','EN','themes/default/images/carousel/button_left_hover.png','_unnamed_'),('carousel/button_right','EN','themes/default/images/carousel/button_right.png','_unnamed_'),('carousel/button_right_hover','EN','themes/default/images/carousel/button_right_hover.png','_unnamed_'),('tab','EN','themes/default/images/tab.png','_unnamed_'),('menus/menu_bullet_expand','EN','themes/default/images/menus/menu_bullet_expand.png','_unnamed_'),('menus/menu_bullet_expand_hover','EN','themes/default/images/menus/menu_bullet_expand_hover.png','_unnamed_'),('menus/menu_bullet_current','EN','themes/default/images/menus/menu_bullet_current.png','_unnamed_'),('menus/menu_bullet','EN','themes/default/images/menus/menu_bullet.png','_unnamed_'),('menus/menu_bullet_hover','EN','themes/default/images/menus/menu_bullet_hover.png','_unnamed_'),('recommend/print','EN','themes/default/images/recommend/print.gif','_unnamed_'),('recommend/recommend','EN','themes/default/images/recommend/recommend.gif','_unnamed_'),('recommend/favorites','EN','themes/default/images/recommend/favorites.gif','_unnamed_'),('recommend/facebook','EN','themes/default/images/recommend/facebook.gif','_unnamed_'),('recommend/twitter','EN','themes/default/images/recommend/twitter.gif','_unnamed_'),('recommend/stumbleupon','EN','themes/default/images/recommend/stumbleupon.gif','_unnamed_'),('recommend/digg','EN','themes/default/images/recommend/digg.gif','_unnamed_'),('filetypes/email_link','EN','themes/default/images/filetypes/email_link.png','_unnamed_'),('filetypes/page_pdf','EN','themes/default/images/filetypes/page_pdf.png','_unnamed_'),('filetypes/page_doc','EN','themes/default/images/filetypes/page_doc.png','_unnamed_'),('filetypes/page_xls','EN','themes/default/images/filetypes/page_xls.png','_unnamed_'),('filetypes/page_ppt','EN','themes/default/images/filetypes/page_ppt.png','_unnamed_'),('filetypes/page_txt','EN','themes/default/images/filetypes/page_txt.png','_unnamed_'),('filetypes/page_odt','EN','themes/default/images/filetypes/page_odt.png','_unnamed_'),('filetypes/page_ods','EN','themes/default/images/filetypes/page_ods.png','_unnamed_'),('filetypes/feed','EN','themes/default/images/filetypes/feed.png','_unnamed_'),('filetypes/page_torrent','EN','themes/default/images/filetypes/page_torrent.png','_unnamed_'),('filetypes/page_archive','EN','themes/default/images/filetypes/page_archive.png','_unnamed_'),('filetypes/page_media','EN','themes/default/images/filetypes/page_media.png','_unnamed_'),('filetypes/external_link','EN','themes/default/images/filetypes/external_link.png','_unnamed_'),('expand','EN','themes/default/images/expand.png','_unnamed_'),('contract','EN','themes/default/images/contract.png','_unnamed_'),('exp_con','EN','themes/default/images/exp_con.png','_unnamed_'),('help_panel_hide','EN','themes/default/images/help_panel_hide.png','_unnamed_'),('help_panel_show','EN','themes/default/images/help_panel_show.png','_unnamed_'),('bottom/loading','EN','themes/default/images/bottom/loading.gif','_unnamed_'),('bigicons/back','EN','themes/default/images/bigicons/back.png','_unnamed_'),('bottom/top','EN','themes/default/images/bottom/top.png','_unnamed_'),('bottom/home','EN','themes/default/images/bottom/home.png','_unnamed_'),('bottom/sitemap','EN','themes/default/images/bottom/sitemap.png','_unnamed_'),('page/join','EN','themes/default/images/EN/page/join.png','_unnamed_'),('page/login','EN','themes/default/images/EN/page/login.png','_unnamed_'),('menus/menu','EN','themes/default/images/menus/menu.png','_unnamed_'),('comcode','EN','themes/default/images/comcode.png','_unnamed_'),('bottom/managementmenu','EN','themes/default/images/bottom/managementmenu.png','_unnamed_'),('bottom/bookmarksmenu','EN','themes/default/images/bottom/bookmarksmenu.png','_unnamed_'),('am_icons/notice','EN','themes/default/images/am_icons/notice.png','_unnamed_'),('bottom/occle','EN','themes/default/images/bottom/occle.png','_unnamed_'),('logo/adminzone-logo','EN','themes/default/images/EN/logo/adminzone-logo.png','_unnamed_'),('menu_items/management_navigation/start','EN','themes/default/images/menu_items/management_navigation/start.png','_unnamed_'),('menu_items/management_navigation/structure','EN','themes/default/images/menu_items/management_navigation/structure.png','_unnamed_'),('menu_items/management_navigation/security','EN','themes/default/images/menu_items/management_navigation/security.png','_unnamed_'),('menu_items/management_navigation/style','EN','themes/default/images/menu_items/management_navigation/style.png','_unnamed_'),('menu_items/management_navigation/setup','EN','themes/default/images/menu_items/management_navigation/setup.png','_unnamed_'),('menu_items/management_navigation/tools','EN','themes/default/images/menu_items/management_navigation/tools.png','_unnamed_'),('menu_items/management_navigation/usage','EN','themes/default/images/menu_items/management_navigation/usage.png','_unnamed_'),('menu_items/management_navigation/cms','EN','themes/default/images/menu_items/management_navigation/cms.png','_unnamed_'),('menu_items/management_navigation/docs','EN','themes/default/images/menu_items/management_navigation/docs.png','_unnamed_'),('checklist/checklist0','EN','themes/default/images/checklist/checklist0.png','_unnamed_'),('checklist/checklist-','EN','themes/default/images/checklist/checklist-.png','_unnamed_'),('pagepics/ocp-logo','EN','themes/default/images/pagepics/ocp-logo.png','_unnamed_'),('bigicons/addons','EN','themes/default/images/bigicons/addons.png','_unnamed_'),('bigicons/awards','EN','themes/default/images/bigicons/awards.png','_unnamed_'),('bigicons/config','EN','themes/default/images/bigicons/config.png','_unnamed_'),('bigicons/custom-comcode','EN','themes/default/images/bigicons/custom-comcode.png','_unnamed_'),('bigicons/customprofilefields','EN','themes/default/images/bigicons/customprofilefields.png','_unnamed_'),('bigicons/baseconfig','EN','themes/default/images/bigicons/baseconfig.png','_unnamed_'),('bigicons/pointstore','EN','themes/default/images/bigicons/pointstore.png','_unnamed_'),('bigicons/multimods','EN','themes/default/images/bigicons/multimods.png','_unnamed_'),('bigicons/posttemplates','EN','themes/default/images/bigicons/posttemplates.png','_unnamed_'),('bigicons/setupwizard','EN','themes/default/images/bigicons/setupwizard.png','_unnamed_'),('bigicons/tickets','EN','themes/default/images/bigicons/tickets.png','_unnamed_'),('bigicons/ecommerce','EN','themes/default/images/bigicons/ecommerce.png','_unnamed_'),('bigicons/welcome_emails','EN','themes/default/images/bigicons/welcome_emails.png','_unnamed_'),('pagepics/configwizard','EN','themes/default/images/pagepics/configwizard.png','_unnamed_'),('treenav','EN','themes/default/images/treenav.png','_unnamed_'),('logo-template','EN','themes/default/images/logo-template.png','_unnamed_'),('logo/collaboration-logo','EN','themes/_unnamed_/images_custom/4b6c6fffa1a90.png','_unnamed_'),('trimmed-logo-template','EN','themes/default/images/trimmed-logo-template.png','_unnamed_'),('logo/trimmed-logo','EN','themes/_unnamed_/images_custom/4b6c6fffb7e0f.png','_unnamed_'),('logo-template','EN','themes/default/images/logo-template.png','default'),('logo/collaboration-logo','EN','themes/default/images_custom/4b6c6fffb7e0f.png','default'),('trimmed-logo-template','EN','themes/default/images/trimmed-logo-template.png','default'),('logo/trimmed-logo','EN','themes/default/images_custom/4b6c6fffcca14.png','default'),('bigicons/pagewizard','EN','themes/default/images/bigicons/pagewizard.png','default'),('bigicons/main_home','EN','themes/default/images/bigicons/main_home.png','default'),('bigicons/cms_home','EN','themes/default/images/bigicons/cms_home.png','default'),('bigicons/admin_home','EN','themes/default/images/bigicons/admin_home.png','default'),('led_on','EN','themes/default/images/led_on.png','_unnamed_'),('ocf_rank_images/0','EN','themes/default/images/ocf_rank_images/0.png','_unnamed_'),('ocf_rank_images/admin','EN','themes/default/images/ocf_rank_images/admin.png','_unnamed_'),('help','EN','themes/default/images/help.png','_unnamed_'),('logo/cms-logo','EN','themes/default/images/EN/logo/cms-logo.png','_unnamed_'),('pagepics/polls','EN','themes/default/images/pagepics/polls.png','_unnamed_'),('comcode_emoticon','EN','themes/default/images/comcode_emoticon.png','_unnamed_'),('am_icons/inform','EN','themes/default/images/am_icons/inform.png','_unnamed_'),('ocf_emoticons/cheeky','EN','themes/default/images/ocf_emoticons/cheeky.png','_unnamed_'),('ocf_emoticons/cry','EN','themes/default/images/ocf_emoticons/cry.png','_unnamed_'),('ocf_emoticons/dry','EN','themes/default/images/ocf_emoticons/dry.png','_unnamed_'),('ocf_emoticons/blush','EN','themes/default/images/ocf_emoticons/blush.png','_unnamed_'),('ocf_emoticons/wink','EN','themes/default/images/ocf_emoticons/wink.png','_unnamed_'),('ocf_emoticons/blink','EN','themes/default/images/ocf_emoticons/blink.gif','_unnamed_'),('ocf_emoticons/wub','EN','themes/default/images/ocf_emoticons/wub.png','_unnamed_'),('ocf_emoticons/cool','EN','themes/default/images/ocf_emoticons/cool.png','_unnamed_'),('ocf_emoticons/lol','EN','themes/default/images/ocf_emoticons/lol.gif','_unnamed_'),('ocf_emoticons/sad','EN','themes/default/images/ocf_emoticons/sad.png','_unnamed_'),('ocf_emoticons/smile','EN','themes/default/images/ocf_emoticons/smile.png','_unnamed_'),('ocf_emoticons/thumbs','EN','themes/default/images/ocf_emoticons/thumbs.png','_unnamed_'),('ocf_emoticons/offtopic','EN','themes/default/images/ocf_emoticons/offtopic.png','_unnamed_'),('ocf_emoticons/mellow','EN','themes/default/images/ocf_emoticons/mellow.png','_unnamed_'),('ocf_emoticons/ph34r','EN','themes/default/images/ocf_emoticons/ph34r.png','_unnamed_'),('ocf_emoticons/shocked','EN','themes/default/images/ocf_emoticons/shocked.png','_unnamed_'),('menu_items/forum_navigation/forums','EN','themes/default/images/menu_items/forum_navigation/forums.png','_unnamed_'),('menu_items/forum_navigation/rules','EN','themes/default/images/menu_items/forum_navigation/rules.png','_unnamed_'),('menu_items/forum_navigation/members','EN','themes/default/images/menu_items/forum_navigation/members.png','_unnamed_'),('menu_items/forum_navigation/groups','EN','themes/default/images/menu_items/forum_navigation/groups.png','_unnamed_'),('menu_items/forum_navigation/unread_topics','EN','themes/default/images/menu_items/forum_navigation/unread_topics.png','_unnamed_'),('menu_items/forum_navigation/recommend','EN','themes/default/images/menu_items/forum_navigation/recommend.png','_unnamed_'),('ocf_general/no_new_posts','EN','themes/default/images/ocf_general/no_new_posts.png','_unnamed_'),('ocf_general/new_posts','EN','themes/default/images/ocf_general/new_posts.png','_unnamed_'),('page/track_forum','EN','themes/default/images/EN/page/track_forum.png','_unnamed_'),('page/mark_read','EN','themes/default/images/EN/page/mark_read.png','_unnamed_'),('page/new_topic','EN','themes/default/images/EN/page/new_topic.png','_unnamed_'),('swfupload/cancelbutton','EN','themes/default/images/swfupload/cancelbutton.gif','_unnamed_'),('pageitem/clear','EN','themes/default/images/EN/pageitem/clear.png','_unnamed_'),('pageitem/upload','EN','themes/default/images/EN/pageitem/upload.png','_unnamed_'),('pagepics/iotds','EN','themes/default/images/pagepics/iotds.png','_unnamed_'),('treefield/plus','EN','themes/default/images/treefield/plus.png','_unnamed_'),('treefield/minus','EN','themes/default/images/treefield/minus.png','_unnamed_'),('treefield/category','EN','themes/default/images/treefield/category.png','_unnamed_'),('treefield/entry','EN','themes/default/images/treefield/entry.png','_unnamed_'),('pagepics/config','EN','themes/default/images/pagepics/config.png','_unnamed_'),('bigicons/add_one_category','EN','themes/default/images/bigicons/add_one_category.png','_unnamed_'),('bigicons/edit_one_category','EN','themes/default/images/bigicons/edit_one_category.png','_unnamed_'),('bigicons/add_one','EN','themes/default/images/bigicons/add_one.png','_unnamed_'),('bigicons/edit_one','EN','themes/default/images/bigicons/edit_one.png','_unnamed_'),('pagepics/banners','EN','themes/default/images/pagepics/banners.png','_unnamed_'),('date_chooser/callt','EN','themes/default/images/date_chooser/callt.gif','_unnamed_'),('date_chooser/calrt','EN','themes/default/images/date_chooser/calrt.gif','_unnamed_'),('date_chooser/calx','EN','themes/default/images/date_chooser/calx.gif','_unnamed_'),('date_chooser/pdate','EN','themes/default/images/date_chooser/pdate.gif','_unnamed_'),('bigicons/main_home','EN','themes/default/images/bigicons/main_home.png','_unnamed_'),('bigicons/edit_this','EN','themes/default/images/bigicons/edit_this.png','_unnamed_'),('bigicons/view_this','EN','themes/default/images/bigicons/view_this.png','_unnamed_'),('bigicons/view_archive','EN','themes/default/images/bigicons/view_archive.png','_unnamed_'),('bigicons/edit_this_category','EN','themes/default/images/bigicons/edit_this_category.png','_unnamed_'),('bigicons/cms_home','EN','themes/default/images/bigicons/cms_home.png','_unnamed_'),('bigicons/admin_home','EN','themes/default/images/bigicons/admin_home.png','_unnamed_'),('arrow_ruler','EN','themes/default/images/arrow_ruler.png','_unnamed_'),('page/new','EN','themes/default/images/EN/page/new.png','_unnamed_'),('ocf_emoticons/cheeky','EN','themes/default/images/ocf_emoticons/cheeky.png','default'),('ocf_emoticons/cry','EN','themes/default/images/ocf_emoticons/cry.png','default'),('ocf_emoticons/dry','EN','themes/default/images/ocf_emoticons/dry.png','default'),('ocf_emoticons/blush','EN','themes/default/images/ocf_emoticons/blush.png','default'),('ocf_emoticons/wink','EN','themes/default/images/ocf_emoticons/wink.png','default'),('ocf_emoticons/blink','EN','themes/default/images/ocf_emoticons/blink.gif','default'),('ocf_emoticons/wub','EN','themes/default/images/ocf_emoticons/wub.png','default'),('ocf_emoticons/cool','EN','themes/default/images/ocf_emoticons/cool.png','default'),('ocf_emoticons/lol','EN','themes/default/images/ocf_emoticons/lol.gif','default'),('ocf_emoticons/sad','EN','themes/default/images/ocf_emoticons/sad.png','default'),('ocf_emoticons/smile','EN','themes/default/images/ocf_emoticons/smile.png','default'),('ocf_emoticons/thumbs','EN','themes/default/images/ocf_emoticons/thumbs.png','default'),('ocf_emoticons/offtopic','EN','themes/default/images/ocf_emoticons/offtopic.png','default'),('ocf_emoticons/mellow','EN','themes/default/images/ocf_emoticons/mellow.png','default'),('ocf_emoticons/ph34r','EN','themes/default/images/ocf_emoticons/ph34r.png','default'),('ocf_emoticons/shocked','EN','themes/default/images/ocf_emoticons/shocked.png','default'),('logo/cms-logo','EN','themes/default/images/EN/logo/cms-logo.png','default'),('swfupload/cancelbutton','EN','themes/default/images/swfupload/cancelbutton.gif','default'),('pageitem/clear','EN','themes/default/images/EN/pageitem/clear.png','default'),('pageitem/upload','EN','themes/default/images/EN/pageitem/upload.png','default'),('pagepics/comcode_page_edit','EN','themes/default/images/pagepics/comcode_page_edit.png','default'),('comcodeeditor/page','EN','themes/default/images/EN/comcodeeditor/page.png','default'),('comcodeeditor/code','EN','themes/default/images/EN/comcodeeditor/code.png','default'),('comcodeeditor/quote','EN','themes/default/images/EN/comcodeeditor/quote.png','default'),('comcodeeditor/hide','EN','themes/default/images/EN/comcodeeditor/hide.png','default'),('comcodeeditor/box','EN','themes/default/images/EN/comcodeeditor/box.png','default'),('comcodeeditor/block','EN','themes/default/images/EN/comcodeeditor/block.png','default'),('comcodeeditor/thumb','EN','themes/default/images/EN/comcodeeditor/thumb.png','default'),('comcodeeditor/url','EN','themes/default/images/EN/comcodeeditor/url.png','default'),('comcodeeditor/email','EN','themes/default/images/EN/comcodeeditor/email.png','default'),('comcodeeditor/list','EN','themes/default/images/EN/comcodeeditor/list.png','default'),('comcodeeditor/html','EN','themes/default/images/EN/comcodeeditor/html.png','default'),('comcodeeditor/b','EN','themes/default/images/EN/comcodeeditor/b.png','default'),('comcodeeditor/i','EN','themes/default/images/EN/comcodeeditor/i.png','default'),('comcodeeditor/apply_changes','EN','themes/default/images/EN/comcodeeditor/apply_changes.png','default'),('bigicons/edit_this','EN','themes/default/images/bigicons/edit_this.png','default'),('bigicons/comcode_page_edit','EN','themes/default/images/bigicons/comcode_page_edit.png','default'),('bigicons/redirect','EN','themes/default/images/bigicons/redirect.png','default'),('bigicons/sitetree','EN','themes/default/images/bigicons/sitetree.png','default'),('bigicons/view_this','EN','themes/default/images/bigicons/view_this.png','default'),('ocf_rank_images/admin','EN','themes/default/images/ocf_rank_images/admin.png','default'),('ocf_rank_images/0','EN','themes/default/images/ocf_rank_images/0.png','default'),('led_on','EN','themes/default/images/led_on.png','default'),('help','EN','themes/default/images/help.png','default'),('google','EN','themes/default/images/google.png','_unnamed_'),('pageitem/delete','EN','themes/default/images/EN/pageitem/delete.png','default'),('pageitem/export','EN','themes/default/images/EN/pageitem/export.png','default'),('bigicons/add_one_category','EN','themes/default/images/bigicons/add_one_category.png','default'),('bigicons/edit_one_category','EN','themes/default/images/bigicons/edit_one_category.png','default'),('bigicons/add_one','EN','themes/default/images/bigicons/add_one.png','default'),('bigicons/edit_one','EN','themes/default/images/bigicons/edit_one.png','default'),('am_icons/inform','EN','themes/default/images/am_icons/inform.png','default'),('pagepics/banners','EN','themes/default/images/pagepics/banners.png','default'),('bigicons/newsletters','EN','themes/default/images/bigicons/newsletters.png','default'),('bigicons/newsletter_from_changes','EN','themes/default/images/bigicons/newsletter_from_changes.png','default'),('bigicons/view_archive','EN','themes/default/images/bigicons/view_archive.png','default'),('bigicons/subscribers','EN','themes/default/images/bigicons/subscribers.png','default'),('bigicons/import_subscribers','EN','themes/default/images/bigicons/import_subscribers.png','default'),('pagepics/newsletter','EN','themes/default/images/pagepics/newsletter.png','default'),('bigicons/addmember','EN','themes/default/images/bigicons/addmember.png','default'),('bigicons/usergroups','EN','themes/default/images/bigicons/usergroups.png','default'),('bigicons/backups','EN','themes/default/images/bigicons/backups.png','default'),('bigicons/bulkupload','EN','themes/default/images/bigicons/bulkupload.png','default'),('bigicons/debrand','EN','themes/default/images/bigicons/debrand.png','default'),('bigicons/deletelurkers','EN','themes/default/images/bigicons/deletelurkers.png','default'),('bigicons/download_csv','EN','themes/default/images/bigicons/download_csv.png','default'),('bigicons/editmember','EN','themes/default/images/bigicons/editmember.png','default'),('bigicons/import','EN','themes/default/images/bigicons/import.png','default'),('bigicons/import_csv','EN','themes/default/images/bigicons/import_csv.png','default'),('bigicons/merge_members','EN','themes/default/images/bigicons/merge_members.png','default'),('bigicons/occle','EN','themes/default/images/bigicons/occle.png','default'),('bigicons/phpinfo','EN','themes/default/images/bigicons/phpinfo.png','default'),('bigicons/cleanup','EN','themes/default/images/bigicons/cleanup.png','default'),('bigicons/xml','EN','themes/default/images/bigicons/xml.png','default'),('pagepics/iotds','EN','themes/default/images/pagepics/iotds.png','default'),('am_icons/warn','EN','themes/default/images/am_icons/warn.png','default'),('bigicons/authors','EN','themes/default/images/bigicons/authors.png','default'),('bigicons/banners','EN','themes/default/images/bigicons/banners.png','default'),('bigicons/news','EN','themes/default/images/bigicons/news.png','default'),('bigicons/calendar','EN','themes/default/images/bigicons/calendar.png','default'),('bigicons/catalogues','EN','themes/default/images/bigicons/catalogues.png','default'),('bigicons/cedi','EN','themes/default/images/bigicons/cedi.png','default'),('bigicons/chatrooms','EN','themes/default/images/bigicons/chatrooms.png','default'),('bigicons/clubs','EN','themes/default/images/bigicons/clubs.png','default'),('bigicons/of_catalogues','EN','themes/default/images/bigicons/of_catalogues.png','default'),('bigicons/downloads','EN','themes/default/images/bigicons/downloads.png','default'),('bigicons/galleries','EN','themes/default/images/bigicons/galleries.png','default'),('bigicons/iotds','EN','themes/default/images/bigicons/iotds.png','default'),('bigicons/polls','EN','themes/default/images/bigicons/polls.png','default'),('bigicons/quiz','EN','themes/default/images/bigicons/quiz.png','default'),('treefield/plus','EN','themes/default/images/treefield/plus.png','default'),('treefield/minus','EN','themes/default/images/treefield/minus.png','default'),('treefield/category','EN','themes/default/images/treefield/category.png','default'),('treefield/entry','EN','themes/default/images/treefield/entry.png','default'),('pagepics/downloads','EN','themes/default/images/pagepics/downloads.png','default'),('comcode_emoticon','EN','themes/default/images/comcode_emoticon.png','default'),('bigicons/add_one_licence','EN','themes/default/images/bigicons/add_one_licence.png','default'),('bigicons/edit_one_licence','EN','themes/default/images/bigicons/edit_one_licence.png','default'),('permlevels/3','EN','themes/default/images/permlevels/3.png','default'),('permlevels/2','EN','themes/default/images/permlevels/2.png','default'),('permlevels/1','EN','themes/default/images/permlevels/1.png','default'),('permlevels/inherit','EN','themes/default/images/permlevels/inherit.png','default'),('blank','EN','themes/default/images/blank.gif','default'),('permlevels/0','EN','themes/default/images/permlevels/0.png','default'),('led_off','EN','themes/default/images/led_off.png','default'),('bigicons/add_to_category','EN','themes/default/images/bigicons/add_to_category.png','default'),('bigicons/edit_this_category','EN','themes/default/images/bigicons/edit_this_category.png','default'),('bigicons/view_this_category','EN','themes/default/images/bigicons/view_this_category.png','default'),('arrow_ruler','EN','themes/default/images/arrow_ruler.png','default'),('bigicons/add_image_to_this','EN','themes/default/images/bigicons/add_image_to_this.png','default'),('bigicons/cash_flow','EN','themes/default/images/bigicons/cash_flow.png','default'),('bigicons/profit_loss','EN','themes/default/images/bigicons/profit_loss.png','default'),('bigicons/transactions','EN','themes/default/images/bigicons/transactions.png','default'),('bigicons/invoices','EN','themes/default/images/bigicons/invoices.png','default'),('bigicons/orders','EN','themes/default/images/bigicons/orders.png','default'),('pagepics/ecommerce','EN','themes/default/images/pagepics/ecommerce.png','default'),('bigicons/messaging','EN','themes/default/images/bigicons/messaging.png','default'),('bigicons/actionlog','EN','themes/default/images/bigicons/actionlog.png','default'),('bigicons/errorlog','EN','themes/default/images/bigicons/errorlog.png','default'),('bigicons/pointslog','EN','themes/default/images/bigicons/pointslog.png','default'),('bigicons/investigateuser','EN','themes/default/images/bigicons/investigateuser.png','default'),('bigicons/pointstorelog','EN','themes/default/images/bigicons/pointstorelog.png','default'),('bigicons/securitylog','EN','themes/default/images/bigicons/securitylog.png','default'),('bigicons/statistics','EN','themes/default/images/bigicons/statistics.png','default'),('bigicons/edit_one_catalogue','EN','themes/default/images/bigicons/edit_one_catalogue.png','default'),('pagepics/catalogues','EN','themes/default/images/pagepics/catalogues.png','default'),('bigicons/add_one_catalogue','EN','themes/default/images/bigicons/add_one_catalogue.png','default'),('bigicons/edit_this_catalogue','EN','themes/default/images/bigicons/edit_this_catalogue.png','default'),('page/cart_view','EN','themes/default/images/EN/page/cart_view.png','_unnamed_'),('page/cart_add','EN','themes/default/images/EN/page/cart_add.png','_unnamed_'),('page/shopping_buy_now','EN','themes/default/images/EN/page/shopping_buy_now.png','_unnamed_'),('pageitem/cart_add','EN','themes/default/images/EN/pageitem/cart_add.png','_unnamed_'),('pageitem/goto','EN','themes/default/images/EN/pageitem/goto.png','_unnamed_'),('top','EN','themes/default/images/top.png','_unnamed_'),('page/changes','EN','themes/default/images/EN/page/changes.png','_unnamed_'),('page/edit_tree','EN','themes/default/images/EN/page/edit_tree.png','_unnamed_'),('page/edit','EN','themes/default/images/EN/page/edit.png','_unnamed_'),('page/new_post','EN','themes/default/images/EN/page/new_post.png','_unnamed_'),('pagepics/cedi','EN','themes/default/images/pagepics/cedi.png','default'),('comcodeeditor/page','EN','themes/default/images/EN/comcodeeditor/page.png','_unnamed_'),('comcodeeditor/code','EN','themes/default/images/EN/comcodeeditor/code.png','_unnamed_'),('comcodeeditor/quote','EN','themes/default/images/EN/comcodeeditor/quote.png','_unnamed_'),('comcodeeditor/hide','EN','themes/default/images/EN/comcodeeditor/hide.png','_unnamed_'),('comcodeeditor/box','EN','themes/default/images/EN/comcodeeditor/box.png','_unnamed_'),('comcodeeditor/block','EN','themes/default/images/EN/comcodeeditor/block.png','_unnamed_'),('comcodeeditor/thumb','EN','themes/default/images/EN/comcodeeditor/thumb.png','_unnamed_'),('comcodeeditor/url','EN','themes/default/images/EN/comcodeeditor/url.png','_unnamed_'),('comcodeeditor/email','EN','themes/default/images/EN/comcodeeditor/email.png','_unnamed_'),('comcodeeditor/list','EN','themes/default/images/EN/comcodeeditor/list.png','_unnamed_'),('comcodeeditor/html','EN','themes/default/images/EN/comcodeeditor/html.png','_unnamed_'),('comcodeeditor/b','EN','themes/default/images/EN/comcodeeditor/b.png','_unnamed_'),('comcodeeditor/i','EN','themes/default/images/EN/comcodeeditor/i.png','_unnamed_'),('comcodeeditor/apply_changes','EN','themes/default/images/EN/comcodeeditor/apply_changes.png','_unnamed_'),('pageitem/edit','EN','themes/default/images/EN/pageitem/edit.png','_unnamed_'),('pageitem/move','EN','themes/default/images/EN/pageitem/move.png','_unnamed_'),('page/previous','EN','themes/default/images/EN/page/previous.png','_unnamed_'),('page/add_event','EN','themes/default/images/EN/page/add_event.png','_unnamed_'),('page/next','EN','themes/default/images/EN/page/next.png','_unnamed_'),('date_chooser/callt','EN','themes/default/images/date_chooser/callt.gif','default'),('date_chooser/calrt','EN','themes/default/images/date_chooser/calrt.gif','default'),('date_chooser/calx','EN','themes/default/images/date_chooser/calx.gif','default'),('pagepics/calendar','EN','themes/default/images/pagepics/calendar.png','default'),('date_chooser/pdate','EN','themes/default/images/date_chooser/pdate.gif','default'),('led_off','EN','themes/default/images/led_off.png','_unnamed_'),('calendar/general','EN','themes/default/images/calendar/general.png','_unnamed_'),('calendar/priority_3','EN','themes/default/images/calendar/priority_3.png','_unnamed_'),('pagepics/news','EN','themes/default/images/pagepics/news.png','default'),('na','EN','themes/default/images/na.png','default'),('newscats/art','EN','themes/default/images/newscats/art.jpg','default'),('newscats/business','EN','themes/default/images/newscats/business.jpg','default'),('newscats/community','EN','themes/default/images/newscats/community.jpg','default'),('newscats/difficulties','EN','themes/default/images/newscats/difficulties.jpg','default'),('newscats/entertainment','EN','themes/default/images/newscats/entertainment.jpg','default'),('newscats/general','EN','themes/default/images/newscats/general.jpg','default'),('newscats/technology','EN','themes/default/images/newscats/technology.jpg','default'),('newscats/general','EN','themes/default/images/newscats/general.jpg','_unnamed_'),('page/all2','EN','themes/default/images/EN/page/all2.png','_unnamed_'),('pagepics/quiz','EN','themes/default/images/pagepics/quiz.png','default'),('bigicons/add_one_image','EN','themes/default/images/bigicons/add_one_image.png','default'),('bigicons/edit_one_image','EN','themes/default/images/bigicons/edit_one_image.png','default'),('bigicons/add_one_video','EN','themes/default/images/bigicons/add_one_video.png','default'),('bigicons/edit_one_video','EN','themes/default/images/bigicons/edit_one_video.png','default'),('pagepics/images','EN','themes/default/images/pagepics/images.png','default'),('bigicons/add_video_to_this','EN','themes/default/images/bigicons/add_video_to_this.png','default'),('page/no_previous','EN','themes/default/images/EN/page/no_previous.png','_unnamed_'),('page/no_next','EN','themes/default/images/EN/page/no_next.png','_unnamed_'),('page/slideshow','EN','themes/default/images/EN/page/slideshow.png','_unnamed_'),('results/sortablefield_asc','EN','themes/default/images/results/sortablefield_asc.png','_unnamed_'),('results/sortablefield_desc','EN','themes/default/images/results/sortablefield_desc.png','_unnamed_'),('tableitem/delete','EN','themes/default/images/tableitem/delete.png','_unnamed_'),('pagepics/awards','EN','themes/default/images/pagepics/awards.png','default'),('bigicons/emoticons','EN','themes/default/images/bigicons/emoticons.png','default'),('bigicons/language','EN','themes/default/images/bigicons/language.png','default'),('bigicons/make_logo','EN','themes/default/images/bigicons/make_logo.png','default'),('bigicons/manage_themes','EN','themes/default/images/bigicons/manage_themes.png','default'),('bigicons/quotes','EN','themes/default/images/bigicons/quotes.png','default'),('bigicons/themewizard','EN','themes/default/images/bigicons/themewizard.png','default'),('carousel/fade_left','EN','themes/default/images/carousel/fade_left.png','_unnamed_'),('carousel/fade_right','EN','themes/default/images/carousel/fade_right.png','_unnamed_'),('pagepics/backups','EN','themes/default/images/pagepics/backups.png','default'),('pagepics/statistics','EN','themes/default/images/pagepics/statistics.png','default'),('bigicons/page_views','EN','themes/default/images/bigicons/page_views.png','default'),('bigicons/users_online','EN','themes/default/images/bigicons/users_online.png','default'),('bigicons/submits','EN','themes/default/images/bigicons/submits.png','default'),('bigicons/load_times','EN','themes/default/images/bigicons/load_times.png','default'),('bigicons/top_referrers','EN','themes/default/images/bigicons/top_referrers.png','default'),('bigicons/top_keywords','EN','themes/default/images/bigicons/top_keywords.png','default'),('bigicons/statistics_demographics','EN','themes/default/images/bigicons/statistics_demographics.png','default'),('bigicons/statistics_posting_rates','EN','themes/default/images/bigicons/statistics_posting_rates.png','default'),('bigicons/searchstats','EN','themes/default/images/bigicons/searchstats.png','default'),('bigicons/geolocate','EN','themes/default/images/bigicons/geolocate.png','default'),('bigicons/clear_stats','EN','themes/default/images/bigicons/clear_stats.png','default'),('pagepics/investigateuser','EN','themes/default/images/pagepics/investigateuser.png','default'),('pagepics/securitylog','EN','themes/default/images/pagepics/securitylog.png','default'),('results/sortablefield_asc','EN','themes/default/images/results/sortablefield_asc.png','default'),('results/sortablefield_desc','EN','themes/default/images/results/sortablefield_desc.png','default'),('bigicons/ipban','EN','themes/default/images/bigicons/ipban.png','default'),('bigicons/specific-permissions','EN','themes/default/images/bigicons/specific-permissions.png','default'),('bigicons/ldap','EN','themes/default/images/bigicons/ldap.png','default'),('bigicons/matchkeysecurity','EN','themes/default/images/bigicons/matchkeysecurity.png','default'),('bigicons/permissionstree','EN','themes/default/images/bigicons/permissionstree.png','default'),('bigicons/ssl','EN','themes/default/images/bigicons/ssl.png','default'),('bigicons/staff','EN','themes/default/images/bigicons/staff.png','default'),('bigicons/wordfilter','EN','themes/default/images/bigicons/wordfilter.png','default'),('pte_view_help','EN','themes/default/images/pte_view_help.png','default'),('pagepics/staff','EN','themes/default/images/pagepics/staff.png','default'),('pagepics/cleanup','EN','themes/default/images/pagepics/cleanup.png','default'),('pagepics/errorlog','EN','themes/default/images/pagepics/errorlog.png','default'),('pagepics/actionlog','EN','themes/default/images/pagepics/actionlog.png','default'),('bigicons/forums','EN','themes/default/images/bigicons/forums.png','default'),('bigicons/menus','EN','themes/default/images/bigicons/menus.png','default'),('bigicons/multisitenetwork','EN','themes/default/images/bigicons/multisitenetwork.png','default'),('bigicons/zone_editor','EN','themes/default/images/bigicons/zone_editor.png','default'),('bigicons/zones','EN','themes/default/images/bigicons/zones.png','default'),('pagepics/themewizard','EN','themes/default/images/pagepics/themewizard.png','default'),('pagepics/logowizard','EN','themes/default/images/pagepics/logowizard.png','default'),('pagepics/bulkuploadassistant','EN','themes/default/images/pagepics/bulkuploadassistant.png','default'),('pagepics/wordfilter','EN','themes/default/images/pagepics/wordfilter.png','default'),('pagepics/ipban','EN','themes/default/images/pagepics/ipban.png','default'),('pagepics/debrand','EN','themes/default/images/pagepics/debrand.png','default'),('pagepics/specific-permissions','EN','themes/default/images/pagepics/specific-permissions.png','default'),('pagepics/menus','EN','themes/default/images/pagepics/menus.png','default'),('pagepics/zones','EN','themes/default/images/pagepics/zones.png','default'),('tableitem/delete','EN','themes/default/images/tableitem/delete.png','default'),('pagepics/importdata','EN','themes/default/images/pagepics/importdata.png','default'),('pagepics/ldap','EN','themes/default/images/pagepics/ldap.png','default'),('pagepics/xml','EN','themes/default/images/pagepics/xml.png','default'),('pagepics/usergroups','EN','themes/default/images/pagepics/usergroups.png','default'),('pagepics/customprofilefields','EN','themes/default/images/pagepics/customprofilefields.png','default'),('ocf_emoticons/rolleyes','EN','themes/default/images/ocf_emoticons/rolleyes.gif','_unnamed_'),('ocf_emoticons/grin','EN','themes/default/images/ocf_emoticons/grin.png','_unnamed_'),('ocf_emoticons/glee','EN','themes/default/images/ocf_emoticons/glee.png','_unnamed_'),('ocf_emoticons/confused','EN','themes/default/images/ocf_emoticons/confused.png','_unnamed_'),('ocf_emoticons/angry','EN','themes/default/images/ocf_emoticons/angry.png','_unnamed_'),('ocf_emoticons/shake','EN','themes/default/images/ocf_emoticons/shake.gif','_unnamed_'),('ocf_emoticons/hand','EN','themes/default/images/ocf_emoticons/hand.png','_unnamed_'),('ocf_emoticons/drool','EN','themes/default/images/ocf_emoticons/drool.png','_unnamed_'),('ocf_emoticons/devil','EN','themes/default/images/ocf_emoticons/devil.gif','_unnamed_'),('ocf_emoticons/constipated','EN','themes/default/images/ocf_emoticons/constipated.png','_unnamed_'),('ocf_emoticons/depressed','EN','themes/default/images/ocf_emoticons/depressed.png','_unnamed_'),('ocf_emoticons/zzz','EN','themes/default/images/ocf_emoticons/zzz.png','_unnamed_'),('ocf_emoticons/upsidedown','EN','themes/default/images/ocf_emoticons/upsidedown.png','_unnamed_'),('ocf_emoticons/sick','EN','themes/default/images/ocf_emoticons/sick.png','_unnamed_'),('ocf_emoticons/sarcy','EN','themes/default/images/ocf_emoticons/sarcy.png','_unnamed_'),('ocf_emoticons/puppyeyes','EN','themes/default/images/ocf_emoticons/puppyeyes.png','_unnamed_'),('ocf_emoticons/nerd','EN','themes/default/images/ocf_emoticons/nerd.png','_unnamed_'),('ocf_emoticons/king','EN','themes/default/images/ocf_emoticons/king.png','_unnamed_'),('ocf_emoticons/birthday','EN','themes/default/images/ocf_emoticons/birthday.png','_unnamed_'),('ocf_emoticons/hippie','EN','themes/default/images/ocf_emoticons/hippie.png','_unnamed_'),('ocf_emoticons/ninja2','EN','themes/default/images/ocf_emoticons/ninja2.gif','_unnamed_'),('ocf_emoticons/none','EN','themes/default/images/ocf_emoticons/none.png','_unnamed_'),('page/track_topic','EN','themes/default/images/EN/page/track_topic.png','_unnamed_'),('page/mark_unread','EN','themes/default/images/EN/page/mark_unread.png','_unnamed_'),('page/reply','EN','themes/default/images/EN/page/reply.png','_unnamed_'),('pageitem/report_post','EN','themes/default/images/EN/pageitem/report_post.png','_unnamed_'),('pageitem/punish','EN','themes/default/images/EN/pageitem/punish.png','_unnamed_'),('pageitem/quote','EN','themes/default/images/EN/pageitem/quote.png','_unnamed_'),('pageitem/whisper','EN','themes/default/images/EN/pageitem/whisper.png','_unnamed_'),('pageitem/delete','EN','themes/default/images/EN/pageitem/delete.png','_unnamed_'),('poll/poll_l','EN','themes/default/images/poll/poll_l.png','_unnamed_'),('poll/poll_m','EN','themes/default/images/poll/poll_m.gif','_unnamed_'),('poll/poll_r','EN','themes/default/images/poll/poll_r.png','_unnamed_'),('bigicons/subscribers','EN','themes/default/images/bigicons/subscribers.png','_unnamed_'),('ocf_topic_modifiers/involved','EN','themes/default/images/ocf_topic_modifiers/involved.png','_unnamed_'),('ocf_topic_modifiers/unvalidated','EN','themes/default/images/ocf_topic_modifiers/unvalidated.png','_unnamed_'),('ocf_topic_modifiers/poll','EN','themes/default/images/ocf_topic_modifiers/poll.png','_unnamed_'),('ocf_topic_modifiers/announcement','EN','themes/default/images/ocf_topic_modifiers/announcement.png','_unnamed_'),('pagepics/forums','EN','themes/default/images/pagepics/forums.png','default'),('ocf_topic_modifiers/unread','EN','themes/default/images/ocf_topic_modifiers/unread.png','_unnamed_'),('pagepics/clubs','EN','themes/default/images/pagepics/clubs.png','default'),('page/invite_member','EN','themes/default/images/EN/page/invite_member.png','_unnamed_'),('pagepics/deletelurkers','EN','themes/default/images/pagepics/deletelurkers.png','default'),('pagepics/mergemembers','EN','themes/default/images/pagepics/mergemembers.png','default'),('pagepics/import_csv','EN','themes/default/images/pagepics/import_csv.png','default'),('pagepics/config','EN','themes/default/images/pagepics/config.png','default'),('am_icons/warn','EN','themes/default/images/am_icons/warn.png','_unnamed_'),('ocf_emoticons/constipated','EN','themes/default/images/ocf_emoticons/constipated.png','default'),('ocf_emoticons/upsidedown','EN','themes/default/images/ocf_emoticons/upsidedown.png','default'),('ocf_emoticons/depressed','EN','themes/default/images/ocf_emoticons/depressed.png','default'),('ocf_emoticons/christmas','EN','themes/default/images/ocf_emoticons/christmas.png','default'),('ocf_emoticons/puppyeyes','EN','themes/default/images/ocf_emoticons/puppyeyes.png','default'),('ocf_emoticons/rolleyes','EN','themes/default/images/ocf_emoticons/rolleyes.gif','default'),('ocf_emoticons/birthday','EN','themes/default/images/ocf_emoticons/birthday.png','default'),('ocf_emoticons/whistle','EN','themes/default/images/ocf_emoticons/whistle.png','default'),('ocf_emoticons/rockon','EN','themes/default/images/ocf_emoticons/rockon.gif','default'),('ocf_emoticons/hippie','EN','themes/default/images/ocf_emoticons/hippie.png','default'),('ocf_emoticons/cyborg','EN','themes/default/images/ocf_emoticons/cyborg.png','default'),('ocf_emoticons/ninja2','EN','themes/default/images/ocf_emoticons/ninja2.gif','default'),('ocf_emoticons/sinner','EN','themes/default/images/ocf_emoticons/sinner.png','default'),('ocf_emoticons/guitar','EN','themes/default/images/ocf_emoticons/guitar.gif','default'),('ocf_emoticons/shutup','EN','themes/default/images/ocf_emoticons/shutup.gif','default'),('ocf_emoticons/sarcy','EN','themes/default/images/ocf_emoticons/sarcy.png','default'),('ocf_emoticons/devil','EN','themes/default/images/ocf_emoticons/devil.gif','default'),('ocf_emoticons/drool','EN','themes/default/images/ocf_emoticons/drool.png','default'),('ocf_emoticons/party','EN','themes/default/images/ocf_emoticons/party.png','default'),('ocf_emoticons/shake','EN','themes/default/images/ocf_emoticons/shake.gif','default'),('ocf_emoticons/king','EN','themes/default/images/ocf_emoticons/king.png','default'),('ocf_emoticons/sick','EN','themes/default/images/ocf_emoticons/sick.png','default'),('ocf_emoticons/nerd','EN','themes/default/images/ocf_emoticons/nerd.png','default'),('ocf_emoticons/hand','EN','themes/default/images/ocf_emoticons/hand.png','default'),('ocf_emoticons/zzz','EN','themes/default/images/ocf_emoticons/zzz.png','default'),('ocf_emoticons/nod','EN','themes/default/images/ocf_emoticons/nod.gif','default'),('ocf_emoticons/kiss','EN','themes/default/images/ocf_emoticons/kiss.png','default'),('ocf_emoticons/glee','EN','themes/default/images/ocf_emoticons/glee.png','default'),('ocf_emoticons/confused','EN','themes/default/images/ocf_emoticons/confused.png','default'),('ocf_emoticons/angry','EN','themes/default/images/ocf_emoticons/angry.png','default'),('ocf_emoticons/grin','EN','themes/default/images/ocf_emoticons/grin.png','default'),('pageitem/goto','EN','themes/default/images/EN/pageitem/goto.png','default'),('ocf_topic_modifiers/pinned','EN','themes/default/images/ocf_topic_modifiers/pinned.png','_unnamed_'),('ocf_topic_modifiers/sunk','EN','themes/default/images/ocf_topic_modifiers/sunk.png','_unnamed_'),('favicon','EN','favicon.ico','default'),('appleicon','EN','appleicon.png','default'),('appleicon','EN','themes/default/images/appleicon.png','_unnamed_'),('favicon','EN','themes/default/images/favicon.ico','_unnamed_'),('keyboard','EN','themes/default/images/keyboard.png','default'),('outer-background','EN','themes/default/images/outer-background.jpg','default'),('header','EN','themes/default/images/header.png','default'),('zone_gradient','EN','themes/default/images/zone_gradient.png','default'),('inner-background','EN','themes/default/images/inner-background.jpg','default'),('block-background','EN','themes/default/images/block-background.png','default'),('standardboxes/title_gradient','EN','themes/default/images/standardboxes/title_gradient.png','default'),('quote_gradient','EN','themes/default/images/quote_gradient.png','default'),('cedi_link','EN','themes/default/images/cedi_link.png','default'),('cedi_link_hover','EN','themes/default/images/cedi_link_hover.png','default'),('page/add_ticket','EN','themes/default/images/EN/page/add_ticket.png','default'),('standardboxes/title_gradient','EN','themes/default/images/standardboxes/title_gradient.png','_unnamed_'),('quote_gradient','EN','themes/default/images/quote_gradient.png','_unnamed_'),('zone_gradient','EN','themes/default/images/zone_gradient.png','_unnamed_'),('page/disable_notifications','EN','themes/default/images/EN/page/disable_notifications.png','default'),('page/enable_notifications','EN','themes/default/images/EN/page/enable_notifications.png','default'),('page/forum','EN','themes/default/images/EN/page/forum.png','default'),('page/send_message','EN','themes/default/images/EN/page/send_message.png','default'),('pageitem/disable_notifications','EN','themes/default/images/EN/pageitem/disable_notifications.png','default'),('pageitem/enable_notifications','EN','themes/default/images/EN/pageitem/enable_notifications.png','default'),('pageitem/reply','EN','themes/default/images/EN/pageitem/reply.png','default'),('pageitem/send_message','EN','themes/default/images/EN/pageitem/send_message.png','default'),('bottom/occle_off','EN','themes/default/images/bottom/occle_off.png','_unnamed_'),('bottom/ocpchat','EN','themes/default/images/bottom/ocpchat.png','_unnamed_'),('pageitem/enable_notifications','EN','themes/_unnamed_/images/EN/pageitem/enable_notifications.png','_unnamed_'),('pageitem/disable_notifications','EN','themes/_unnamed_/images/EN/pageitem/disable_notifications.png','_unnamed_'),('pagepics/forums','EN','themes/default/images/pagepics/forums.png','_unnamed_'),('page/enable_notifications','EN','themes/_unnamed_/images/EN/page/enable_notifications.png','_unnamed_'),('page/disable_notifications','EN','themes/_unnamed_/images/EN/page/disable_notifications.png','_unnamed_'),('pageitem/points','EN','themes/default/images/EN/pageitem/points.png','_unnamed_'),('loading','EN','themes/default/images/loading.gif','_unnamed_');
/*!40000 ALTER TABLE `cms_theme_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_ticket_types`
--

DROP TABLE IF EXISTS `cms_ticket_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_ticket_types` (
  `cache_lead_time` int(10) unsigned default NULL,
  `guest_emails_mandatory` tinyint(1) NOT NULL,
  `search_faq` tinyint(1) NOT NULL,
  `ticket_type` int(10) unsigned NOT NULL,
  PRIMARY KEY  (`ticket_type`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_ticket_types`
--

LOCK TABLES `cms_ticket_types` WRITE;
/*!40000 ALTER TABLE `cms_ticket_types` DISABLE KEYS */;
INSERT INTO `cms_ticket_types` VALUES (NULL,0,0,395),(NULL,0,0,396);
/*!40000 ALTER TABLE `cms_ticket_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_tickets`
--

DROP TABLE IF EXISTS `cms_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_tickets` (
  `forum_id` int(11) NOT NULL,
  `ticket_id` varchar(255) NOT NULL,
  `ticket_type` int(10) unsigned NOT NULL,
  `topic_id` int(11) NOT NULL,
  PRIMARY KEY  (`ticket_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_tickets`
--

LOCK TABLES `cms_tickets` WRITE;
/*!40000 ALTER TABLE `cms_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_trackbacks`
--

DROP TABLE IF EXISTS `cms_trackbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_trackbacks` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `trackback_excerpt` longtext NOT NULL,
  `trackback_for_id` varchar(80) NOT NULL,
  `trackback_for_type` varchar(80) NOT NULL,
  `trackback_ip` varchar(40) NOT NULL,
  `trackback_name` varchar(255) NOT NULL,
  `trackback_time` int(10) unsigned NOT NULL,
  `trackback_title` varchar(255) NOT NULL,
  `trackback_url` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_trackbacks`
--

LOCK TABLES `cms_trackbacks` WRITE;
/*!40000 ALTER TABLE `cms_trackbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_trackbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_trans_expecting`
--

DROP TABLE IF EXISTS `cms_trans_expecting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_trans_expecting` (
  `e_amount` varchar(255) NOT NULL,
  `e_ip_address` varchar(40) NOT NULL,
  `e_item_name` varchar(255) NOT NULL,
  `e_length` int(11) default NULL,
  `e_length_units` varchar(80) NOT NULL,
  `e_member_id` int(11) NOT NULL,
  `e_purchase_id` varchar(80) NOT NULL,
  `e_session_id` int(11) NOT NULL,
  `e_time` int(10) unsigned NOT NULL,
  `id` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_trans_expecting`
--

LOCK TABLES `cms_trans_expecting` WRITE;
/*!40000 ALTER TABLE `cms_trans_expecting` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_trans_expecting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_transactions`
--

DROP TABLE IF EXISTS `cms_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_transactions` (
  `amount` varchar(255) NOT NULL,
  `id` varchar(80) NOT NULL,
  `item` varchar(255) NOT NULL,
  `linked` varchar(80) NOT NULL,
  `pending_reason` varchar(255) NOT NULL,
  `purchase_id` varchar(80) NOT NULL,
  `reason` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `t_currency` varchar(80) NOT NULL,
  `t_memo` longtext NOT NULL,
  `t_time` int(10) unsigned NOT NULL,
  `t_via` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`,`t_time`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_transactions`
--

LOCK TABLES `cms_transactions` WRITE;
/*!40000 ALTER TABLE `cms_transactions` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_translate`
--

DROP TABLE IF EXISTS `cms_translate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_translate` (
  `broken` tinyint(1) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `importance_level` tinyint(4) NOT NULL,
  `language` varchar(5) NOT NULL,
  `source_user` int(11) NOT NULL,
  `text_original` longtext NOT NULL,
  `text_parsed` longtext NOT NULL,
  PRIMARY KEY  (`id`,`language`),
  KEY `equiv_lang` (`text_original`(4)),
  KEY `decache` (`text_parsed`(2)),
  FULLTEXT KEY `search` (`text_original`)
) ENGINE=MyISAM AUTO_INCREMENT=1064 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_translate`
--

LOCK TABLES `cms_translate` WRITE;
/*!40000 ALTER TABLE `cms_translate` DISABLE KEYS */;
INSERT INTO `cms_translate` VALUES (0,1,1,'EN',2,'Serving demo content to you!',''),(0,2,1,'EN',1,'Admin Zone',''),(0,3,1,'EN',1,'Collaboration Zone',''),(0,4,1,'EN',2,'Serving demo content to you!',''),(0,5,1,'EN',1,'Content Management',''),(0,6,1,'EN',1,'Guides',''),(0,7,1,'EN',1,'Welcome',''),(0,8,1,'EN',1,'Admin Zone',''),(0,9,1,'EN',1,'Site',''),(0,10,1,'EN',1,'Collaboration Zone',''),(0,11,1,'EN',1,'Content Management',''),(0,12,1,'EN',1,'Forum',''),(0,13,1,'EN',1,'Account',''),(0,14,1,'EN',1,'Forums',''),(0,15,1,'EN',1,'Account',''),(0,16,2,'EN',1,'About me',''),(0,17,2,'EN',1,'Some personally written information.',''),(0,18,2,'EN',1,'AIM ID',''),(0,19,2,'EN',1,'AIM username.',''),(0,20,2,'EN',1,'MSN Messenger ID',''),(0,21,2,'EN',1,'E-mail address of MSN Messenger account.',''),(0,22,2,'EN',1,'Yahoo messenger ID',''),(0,23,2,'EN',1,'Log in name of a Yahoo messenger account.',''),(0,24,2,'EN',1,'Skype ID',''),(0,25,2,'EN',1,'Skype username.',''),(0,26,2,'EN',1,'Interests',''),(0,27,2,'EN',1,'A summary of your interests.',''),(0,28,2,'EN',1,'Location',''),(0,29,2,'EN',1,'Your geographical location.',''),(0,30,2,'EN',1,'Occupation',''),(0,31,2,'EN',1,'This member\'s occupation.',''),(0,32,2,'EN',1,'Staff notes',''),(0,33,2,'EN',1,'Notes on this member, only viewable by staff.',''),(0,34,2,'EN',1,'Guests',''),(0,35,2,'EN',1,'Guest user',''),(0,36,2,'EN',1,'Administrators',''),(0,37,2,'EN',1,'Site director',''),(0,38,2,'EN',1,'Super-moderators',''),(0,39,2,'EN',1,'Site staff',''),(0,40,2,'EN',1,'Super-members',''),(0,41,2,'EN',1,'Super-member',''),(0,42,2,'EN',1,'Local hero',''),(0,43,2,'EN',1,'Standard member',''),(0,44,2,'EN',1,'Old timer',''),(0,45,2,'EN',1,'Standard member',''),(0,46,2,'EN',1,'Local',''),(0,47,2,'EN',1,'Standard member',''),(0,48,2,'EN',1,'Regular',''),(0,49,2,'EN',1,'Standard member',''),(0,50,2,'EN',1,'Newbie',''),(0,51,2,'EN',1,'Standard member',''),(0,52,2,'EN',1,'Probation',''),(0,53,2,'EN',1,'Members will be considered to be in this usergroup (and only this usergroup) if and whilst they have been placed on probation. This usergroup behaves like any other, and therefore may also be manually placed into it.',''),(0,54,2,'EN',1,'',''),(0,55,3,'EN',1,'',''),(0,58,2,'EN',1,'',''),(0,59,3,'EN',1,'',''),(0,60,2,'EN',2,'',''),(0,61,3,'EN',2,'You can specify passwords (or answers to questions) to act as forum-restrictions.\n\nHere, enter the password \'Composr\' below to gain access to the forum.',''),(0,62,2,'EN',1,'',''),(0,63,3,'EN',1,'',''),(0,64,2,'EN',1,'',''),(0,65,3,'EN',1,'',''),(0,66,2,'EN',1,'',''),(0,67,3,'EN',1,'',''),(0,68,2,'EN',1,'',''),(0,69,3,'EN',1,'',''),(0,70,2,'EN',1,'',''),(0,71,3,'EN',1,'',''),(0,72,3,'EN',1,'Trash',''),(0,73,4,'EN',1,'',''),(0,74,4,'EN',1,'',''),(0,75,3,'EN',1,'',''),(0,76,3,'EN',1,'',''),(0,77,3,'EN',1,'',''),(0,78,4,'EN',1,'',''),(0,79,4,'EN',1,'',''),(0,80,3,'EN',1,'',''),(0,81,3,'EN',1,'',''),(0,82,3,'EN',1,'',''),(0,83,4,'EN',1,'',''),(0,84,4,'EN',1,'',''),(0,85,3,'EN',1,'',''),(0,86,3,'EN',1,'',''),(0,87,3,'EN',1,'',''),(0,88,4,'EN',1,'This is the inbuilt forum system (known as OCF).\n\nA forum system is a tool for communication between members; it consists of posts, organised into topics: each topic is a line of conversation.\n\nThe website software provides support for a number of different forum systems, and each forum handles authentication of members: OCF is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.',''),(0,89,2,'EN',1,'cms_mobile_phone_number',''),(0,90,2,'EN',1,'This should be the mobile phone number in international format, devoid of any national or international outgoing access codes. For instance, a typical UK (44) number might be nationally known as \'01234 123456\', but internationally and without outgoing access codes would be \'441234123456\'.',''),(0,91,2,'EN',1,'Download of the week',''),(0,92,2,'EN',1,'The best downloads in the download system, chosen every week.',''),(0,93,1,'EN',1,'Front page',''),(0,94,1,'EN',1,'',''),(0,95,1,'EN',1,'Rules',''),(0,96,1,'EN',1,'',''),(0,98,1,'EN',1,'',''),(0,100,1,'EN',1,'',''),(0,102,1,'EN',1,'',''),(0,103,1,'EN',1,'Members',''),(0,104,1,'EN',1,'',''),(0,105,1,'EN',1,'Usergroups',''),(0,106,1,'EN',1,'',''),(0,107,1,'EN',1,'Donate',''),(0,108,1,'EN',1,'',''),(0,109,1,'EN',1,'Join',''),(0,110,1,'EN',1,'',''),(0,111,1,'EN',1,'Reset password',''),(0,112,1,'EN',1,'',''),(0,113,1,'EN',1,'Front page',''),(0,114,1,'EN',1,'',''),(0,115,1,'EN',1,'About',''),(0,116,1,'EN',1,'',''),(0,117,1,'EN',1,'Get hosted by us!',''),(0,118,1,'EN',1,'',''),(0,119,1,'EN',1,'View my author profile',''),(0,120,1,'EN',1,'',''),(0,121,1,'EN',1,'Edit my author profile',''),(0,122,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,123,1,'EN',1,'My Home',''),(0,124,1,'EN',1,'',''),(0,125,1,'EN',1,'View member profile',''),(0,126,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,127,1,'EN',1,'Edit profile',''),(0,128,1,'EN',1,'',''),(0,129,1,'EN',1,'Edit avatar',''),(0,130,1,'EN',1,'',''),(0,131,1,'EN',1,'Edit photo',''),(0,132,1,'EN',1,'',''),(0,133,1,'EN',1,'Edit signature',''),(0,134,1,'EN',1,'',''),(0,135,1,'EN',1,'Edit title',''),(0,136,1,'EN',1,'',''),(0,137,1,'EN',1,'Privacy',''),(0,138,1,'EN',1,'',''),(0,139,1,'EN',1,'Delete account',''),(0,140,1,'EN',1,'',''),(0,141,1,'EN',1,'Rules',''),(0,142,1,'EN',1,'',''),(0,143,1,'EN',1,'Members',''),(0,144,1,'EN',1,'',''),(0,145,1,'EN',1,'View member profile',''),(0,146,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,147,1,'EN',1,'Edit profile',''),(0,148,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,149,1,'EN',1,'Edit avatar',''),(0,150,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,151,1,'EN',1,'Edit photo',''),(0,152,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,153,1,'EN',1,'Edit signature',''),(0,154,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,155,1,'EN',1,'Edit title',''),(0,156,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,157,1,'EN',1,'Site',''),(0,158,1,'EN',1,'',''),(0,159,1,'EN',1,'Forums',''),(0,160,1,'EN',1,'',''),(0,161,1,'EN',1,'Account',''),(0,162,1,'EN',1,'',''),(0,163,1,'EN',1,'Collaboration Zone',''),(0,164,1,'EN',1,'',''),(0,165,1,'EN',1,'Content Management',''),(0,166,1,'EN',1,'',''),(0,167,1,'EN',1,'Admin Zone',''),(0,168,1,'EN',1,'',''),(0,169,2,'EN',1,'',''),(0,170,3,'EN',1,'',''),(0,174,2,'EN',1,'(System command)',''),(0,175,2,'EN',1,'General',''),(0,176,2,'EN',1,'Birthday',''),(0,177,2,'EN',1,'Public holiday',''),(0,178,2,'EN',1,'Vacation',''),(0,179,2,'EN',1,'Appointment',''),(0,180,2,'EN',1,'Task',''),(0,181,2,'EN',1,'Anniversary',''),(0,182,1,'EN',1,'Calendar',''),(0,183,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,683,3,'EN',2,'The Open Source Initiative (OSI) is a non-profit corporation formed to educate about and advocate for the benefits of open source and to build bridges among different constituencies in the open-source community.',''),(0,690,2,'EN',2,'open,source,initiative,www,opensource,org',''),(0,688,2,'EN',2,'ocproducts',''),(0,682,3,'EN',2,'Open Source Initiative',''),(0,689,2,'EN',2,'',''),(0,674,3,'EN',2,'Composr',''),(0,675,3,'EN',2,'Composr is a CMS (Content Management System) that allows you to create and manage your interactive and dynamic website from an easy to use administration interface. Composr is unique by the combination of a vast and diverse range of provided functionality, out-of-the-box usability, and an ability for unlimited customisation.',''),(0,687,2,'EN',2,'',''),(0,686,2,'EN',2,'composr',''),(0,678,3,'EN',2,'ocProducts',''),(0,679,3,'EN',2,'ocProducts is the company behind Composr.',''),(0,529,1,'EN',2,'Donate money',''),(0,705,2,'EN',2,'',''),(0,704,2,'EN',2,'romeo,juliet',''),(0,694,2,'EN',2,'works,shakespeare',''),(0,695,2,'EN',2,'',''),(0,696,2,'EN',2,'Hamlet',''),(0,697,2,'EN',2,'The Tragedy of Hamlet, Prince of Denmark, or more simply Hamlet, is a tragedy by William Shakespeare, believed to have been written between 1599 and 1601. The play, set in Denmark, recounts how Prince Hamlet exacts revenge on his uncle Claudius, who has murdered Hamlet\'s father, the King, and then taken the throne and married Gertrude, Hamlet\'s mother. The play vividly charts the course of real and feigned madness--from overwhelming grief to seething rage--and explores themes of treachery, revenge, incest, and moral corruption.',''),(0,708,2,'EN',2,'',''),(0,707,2,'EN',2,'hamlet',''),(0,700,2,'EN',2,'Romeo and Juliet',''),(0,701,2,'EN',2,'Romeo and Juliet is a tragedy written early in the career of playwright William Shakespeare about two young \"star-cross\'d lovers\" whose deaths ultimately unite their feuding families. It was among Shakespeare\'s most popular plays during his lifetime and, along with Hamlet and Macbeth, is one of his most frequently performed plays. Today, the title characters are regarded as archetypal young lovers.\n',''),(0,691,2,'EN',2,'',''),(0,692,2,'EN',2,'Works by Shakespeare',''),(0,693,2,'EN',2,'',''),(0,220,2,'EN',1,'Links',''),(0,221,3,'EN',1,'Warning: these sites are outside our control.',''),(0,222,1,'EN',1,'Links',''),(0,223,3,'EN',1,'',''),(0,224,2,'EN',1,'Title',''),(0,225,3,'EN',1,'A concise line that entitles this.',''),(0,226,2,'EN',1,'URL',''),(0,227,3,'EN',1,'The entered text will be interpreted as a URL, and used as a hyperlink.',''),(0,228,2,'EN',1,'Description',''),(0,229,3,'EN',1,'A concise description for this.',''),(0,706,2,'EN',2,'[attachment thumb=\"1\" type=\"inline\" description=\"\"]1[/attachment]',''),(0,240,2,'EN',1,'Contacts',''),(0,241,3,'EN',1,'A contacts/address-book.',''),(0,242,3,'EN',1,'Forename',''),(0,243,2,'EN',1,'',''),(0,244,3,'EN',1,'Surname',''),(0,245,2,'EN',1,'',''),(0,246,3,'EN',1,'E-mail address',''),(0,247,2,'EN',1,'',''),(0,248,3,'EN',1,'Company',''),(0,249,2,'EN',1,'',''),(0,250,3,'EN',1,'Home address',''),(0,251,2,'EN',1,'',''),(0,252,3,'EN',1,'City',''),(0,253,2,'EN',1,'',''),(0,254,3,'EN',1,'Home phone number',''),(0,255,2,'EN',1,'',''),(0,256,3,'EN',1,'Work phone number',''),(0,257,2,'EN',1,'',''),(0,258,3,'EN',1,'Homepage',''),(0,259,2,'EN',1,'',''),(0,260,3,'EN',1,'Instant messenger handle',''),(0,261,2,'EN',1,'',''),(0,262,3,'EN',1,'Events relating to them',''),(0,263,2,'EN',1,'',''),(0,264,3,'EN',1,'Notes',''),(0,265,2,'EN',1,'',''),(0,266,2,'EN',1,'Contacts',''),(0,267,3,'EN',1,'',''),(0,268,1,'EN',1,'Catalogues',''),(0,269,1,'EN',1,'',''),(0,270,1,'EN',1,'Super-member projects',''),(0,271,1,'EN',1,'',''),(0,272,1,'EN',1,'View',''),(0,273,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,274,1,'EN',1,'Add',''),(0,275,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,276,2,'EN',1,'Products',''),(0,277,2,'EN',1,'',''),(0,278,1,'EN',1,'Home',''),(0,279,3,'EN',1,'',''),(0,280,3,'EN',1,'Product title',''),(0,281,3,'EN',1,'A concise line that entitles this.',''),(0,282,3,'EN',1,'Product code',''),(0,283,3,'EN',1,'The codename for the product',''),(0,284,3,'EN',1,'Net price',''),(0,285,3,'EN',1,'The price, before tax is added, in the primary currency of this website.',''),(0,286,3,'EN',1,'Stock level',''),(0,287,3,'EN',1,'The stock level of the product (leave blank if no stock counting is to be done).',''),(0,288,3,'EN',1,'Stock level warn-threshold',''),(0,289,3,'EN',1,'Send out an e-mail alert to the staff if the stock goes below this level (leave blank if no stock counting is to be done).',''),(0,290,3,'EN',1,'Stock maintained',''),(0,291,3,'EN',1,'Whether stock will be maintained. If the stock is not maintained then users will not be able to purchase it if the stock runs out.',''),(0,292,3,'EN',1,'Product tax rate',''),(0,293,3,'EN',1,'The tax rates that products can be assigned.',''),(0,294,3,'EN',1,'Product image',''),(0,295,3,'EN',1,'Upload an image of your product.',''),(0,296,3,'EN',1,'Product weight',''),(0,297,3,'EN',1,'The weight, in whatever units are assumed by the shipping costs programmed-in to this website.',''),(0,298,3,'EN',1,'Product description',''),(0,299,3,'EN',1,'A concise description for this.',''),(0,300,1,'EN',1,'CEDI home',''),(0,301,2,'EN',1,'',''),(0,302,2,'EN',1,'cms_points_gained_seedy',''),(0,303,2,'EN',1,'',''),(0,304,1,'EN',1,'CEDI',''),(0,305,1,'EN',1,'',''),(0,306,1,'EN',1,'Random page',''),(0,307,1,'EN',1,'',''),(0,308,1,'EN',1,'CEDI change-log',''),(0,309,1,'EN',1,'',''),(0,310,1,'EN',1,'Tree',''),(0,311,1,'EN',1,'',''),(0,312,2,'EN',1,'',''),(0,313,2,'EN',1,'cms_points_gained_chat',''),(0,314,2,'EN',1,'',''),(0,315,1,'EN',1,'Chat lobby',''),(0,316,1,'EN',1,'',''),(0,317,1,'EN',1,'Chat lobby',''),(0,318,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,319,2,'EN',1,'Downloads home',''),(0,320,3,'EN',1,'',''),(0,321,1,'EN',1,'Downloads',''),(0,322,1,'EN',1,'',''),(0,323,1,'EN',1,'Galleries',''),(0,324,1,'EN',1,'',''),(0,325,2,'EN',1,'',''),(0,326,2,'EN',1,'',''),(0,327,1,'EN',1,'Galleries home',''),(0,328,2,'EN',1,'galleries,home',''),(0,329,2,'EN',1,'',''),(0,330,2,'EN',1,'General',''),(0,331,2,'EN',1,'Technology',''),(0,332,2,'EN',1,'Difficulties',''),(0,333,2,'EN',1,'Community',''),(0,334,2,'EN',1,'Entertainment',''),(0,335,2,'EN',1,'Business',''),(0,336,2,'EN',1,'Art',''),(0,337,1,'EN',1,'Blog',''),(0,338,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,339,1,'EN',1,'Newsletter',''),(0,340,1,'EN',1,'',''),(0,341,1,'EN',1,'Newsletter',''),(0,342,1,'EN',1,'',''),(0,343,2,'EN',1,'General',''),(0,344,2,'EN',1,'General messages will be sent out in this newsletter.',''),(0,345,1,'EN',1,'Points',''),(0,346,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,347,1,'EN',1,'Points',''),(0,348,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,349,1,'EN',1,'Point-store',''),(0,350,1,'EN',1,'',''),(0,351,2,'EN',1,'cms_currency',''),(0,352,2,'EN',1,'',''),(0,353,2,'EN',1,'cms_payment_cardholder_name',''),(0,354,2,'EN',1,'',''),(0,355,2,'EN',1,'cms_payment_type',''),(0,356,2,'EN',1,'',''),(0,357,2,'EN',1,'cms_payment_card_number',''),(0,358,2,'EN',1,'',''),(0,359,2,'EN',1,'cms_payment_card_start_date',''),(0,360,2,'EN',1,'',''),(0,361,2,'EN',1,'cms_payment_card_expiry_date',''),(0,362,2,'EN',1,'',''),(0,363,2,'EN',1,'cms_payment_card_issue_number',''),(0,364,2,'EN',1,'',''),(0,365,2,'EN',1,'cms_payment_card_cv2',''),(0,366,2,'EN',1,'',''),(0,367,1,'EN',1,'Invoices',''),(0,368,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,369,1,'EN',1,'Subscriptions',''),(0,370,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,371,1,'EN',1,'Purchasing',''),(0,372,1,'EN',1,'',''),(0,373,1,'EN',1,'Invoices',''),(0,374,1,'EN',1,'',''),(0,375,1,'EN',1,'SUBSCRIPTIONS',''),(0,376,1,'EN',1,'',''),(0,377,1,'EN',1,'Orders',''),(0,378,1,'EN',1,'',''),(0,379,2,'EN',1,'cms_firstname',''),(0,380,2,'EN',1,'',''),(0,381,2,'EN',1,'cms_lastname',''),(0,382,2,'EN',1,'',''),(0,383,2,'EN',1,'cms_building_name_or_number',''),(0,384,2,'EN',1,'',''),(0,385,2,'EN',1,'cms_city',''),(0,386,2,'EN',1,'',''),(0,387,2,'EN',1,'cms_state',''),(0,388,2,'EN',1,'',''),(0,389,2,'EN',1,'cms_post_code',''),(0,390,2,'EN',1,'',''),(0,391,2,'EN',1,'cms_country',''),(0,392,2,'EN',1,'',''),(0,393,1,'EN',1,'Staff',''),(0,394,1,'EN',1,'',''),(0,395,1,'EN',1,'Other',''),(0,396,1,'EN',1,'Complaint',''),(0,397,1,'EN',1,'Support tickets',''),(0,398,1,'EN',1,'',''),(0,399,1,'EN',1,'Support tickets',''),(0,400,1,'EN',1,'',''),(0,401,1,'EN',1,'Forum home',''),(0,402,1,'EN',1,'',''),(0,403,1,'EN',1,'Personal topics',''),(0,404,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,405,1,'EN',1,'Forum home',''),(0,406,1,'EN',1,'',''),(0,407,1,'EN',1,'Personal topics',''),(0,408,1,'EN',1,'',''),(0,409,1,'EN',1,'Posts since last visit',''),(0,410,1,'EN',1,'',''),(0,411,1,'EN',1,'Topics with unread posts',''),(0,412,1,'EN',1,'',''),(0,413,1,'EN',1,'Recently-read topics',''),(0,414,1,'EN',1,'',''),(0,415,1,'EN',1,'Search',''),(0,416,1,'EN',1,'This link is a shortcut: the menu will change',''),(0,984,1,'EN',2,'Composr&#039;s different menu-types',''),(0,418,1,'EN',1,'',''),(0,419,1,'EN',1,'Recommend site',''),(0,420,1,'EN',1,'',''),(0,421,1,'EN',1,'File-dump',''),(0,422,1,'EN',1,'',''),(0,423,1,'EN',1,'Super-members',''),(0,424,1,'EN',1,'',''),(0,425,2,'EN',1,'cms_points_used',''),(0,426,2,'EN',1,'',''),(0,427,2,'EN',1,'cms_gift_points_used',''),(0,428,2,'EN',1,'',''),(0,429,2,'EN',1,'cms_points_gained_given',''),(0,430,2,'EN',1,'',''),(0,431,2,'EN',1,'cms_points_gained_rating',''),(0,432,2,'EN',1,'',''),(0,433,2,'EN',1,'cms_points_gained_voting',''),(0,434,2,'EN',1,'',''),(0,435,2,'EN',1,'cms_sites',''),(0,436,2,'EN',1,'',''),(0,437,2,'EN',1,'cms_role',''),(0,438,2,'EN',1,'',''),(0,439,2,'EN',1,'cms_fullname',''),(0,440,2,'EN',1,'',''),(0,442,1,'EN',2,'',''),(0,443,1,'EN',2,'[block=\"root_website\" type=\"tree\" caption=\"Web site\"]side_stored_menu[/block]\n[block failsafe=\"1\"]side_users_online[/block]\n[block failsafe=\"1\"]side_stats[/block]\n[block]side_personal_stats[/block]',''),(0,444,1,'EN',2,'',''),(0,445,1,'EN',2,'[title=\"1\"]Welcome to {$SITE_NAME}[/title]\n\n[block]main_greeting[/block]\n\n\n[semihtml]\n<div class=\"float_surrounder\">\n<div style=\"width: 48%; float: left\">[block]main_awards[/block]</div>\n<div style=\"width: 48%; float: right\">[block failsafe=\"1\"]main_iotd[/block]</div>\n</div>\n[/semihtml]\n\n[block=\"14\" failsafe=\"1\"]main_news[/block]\n\n[block=\"quotes\" failsafe=\"1\"]main_quotes[/block]\n\n[block failsafe=\"1\"]main_forum_topics[/block]\n\n[block=\"5\" failsafe=\"1\"]main_top_downloads[/block]\n\n[block=\"5\" failsafe=\"1\"]main_recent_downloads[/block]\n\n[block=\"5\" failsafe=\"1\"]main_top_galleries[/block]\n\n[block=\"5\" failsafe=\"1\"]main_gallery_embed[/block]\n\n[block]main_comcode_page_children[/block]',''),(0,446,1,'EN',2,'Welcome to (unnamed)',''),(0,946,1,'EN',2,'Child page',''),(0,449,1,'EN',2,'Admin Zone',''),(0,451,1,'EN',2,'',''),(0,948,1,'EN',2,'Member section of Composr demo',''),(0,949,4,'EN',2,'This post is emphasised.',''),(0,549,1,'EN',2,'Admin Zone',''),(0,951,1,'EN',2,'Featured content',''),(0,960,1,'EN',2,'Composr&#039;s different menu-types',''),(0,962,1,'EN',2,'',''),(0,964,1,'EN',2,'',''),(0,966,1,'EN',2,'',''),(0,968,1,'EN',2,'',''),(0,970,1,'EN',2,'',''),(0,972,1,'EN',2,'',''),(0,974,1,'EN',2,'',''),(0,976,1,'EN',2,'',''),(0,978,1,'EN',2,'',''),(0,980,1,'EN',2,'',''),(0,547,1,'EN',2,'Example banners',''),(0,541,1,'EN',2,'',''),(0,543,1,'EN',2,'',''),(0,986,1,'EN',2,'',''),(0,545,1,'EN',2,'(unnamed) Site-Map',''),(0,539,1,'EN',2,'Welcome to (unnamed)',''),(0,466,1,'EN',2,'Serving demo content to you!',''),(0,467,1,'EN',2,'demoing',''),(0,468,1,'EN',2,'',''),(0,469,1,'EN',2,'This is an Composr demo.\n\nLog in using the details you put in when you set up the demo, or if this is the shared demo use the username \'admin\' and the password \'demo123\'.',''),(0,537,1,'EN',2,'',''),(0,592,1,'EN',2,'Welcome to (unnamed)',''),(0,593,4,'EN',2,'Add Comcode page',''),(0,952,2,'EN',2,'',''),(0,953,2,'EN',2,'',''),(0,955,1,'EN',2,'Featured content',''),(0,956,4,'EN',2,'Add Comcode page',''),(0,991,2,'EN',2,'',''),(0,992,2,'EN',2,'',''),(0,479,1,'EN',2,'Welcome to (unnamed)',''),(0,471,1,'EN',2,'Welcome to (unnamed)',''),(0,988,1,'EN',2,'Welcome to Composr demo',''),(0,473,1,'EN',2,'',''),(0,990,1,'EN',2,'',''),(0,994,1,'EN',2,'Composr&#039;s different menu-types',''),(0,995,1,'EN',2,'Content examples',''),(0,996,1,'EN',2,'',''),(0,997,1,'EN',2,'Menus',''),(0,998,1,'EN',2,'',''),(0,999,1,'EN',2,'Rich content',''),(0,1000,1,'EN',2,'',''),(0,1001,1,'EN',2,'Rules',''),(0,1002,1,'EN',2,'',''),(0,1003,1,'EN',2,'Site map',''),(0,1004,1,'EN',2,'',''),(0,1005,1,'EN',2,'Feedback',''),(0,1006,1,'EN',2,'',''),(0,1007,1,'EN',2,'Downloads',''),(0,1008,1,'EN',2,'',''),(0,1009,1,'EN',2,'CEDI',''),(0,1010,1,'EN',2,'',''),(0,1011,1,'EN',2,'Galleries',''),(0,1012,1,'EN',2,'',''),(0,1013,1,'EN',2,'Forums',''),(0,1014,1,'EN',2,'',''),(0,481,1,'EN',2,'',''),(0,483,1,'EN',2,'',''),(0,484,1,'EN',2,'What type of books do you prefer?',''),(0,485,1,'EN',2,'Hardbacks',''),(0,486,1,'EN',2,'Paperbacks',''),(0,487,1,'EN',2,'eBooks',''),(0,488,1,'EN',2,'Audio books',''),(0,489,1,'EN',2,'',''),(0,490,1,'EN',2,'',''),(0,491,1,'EN',2,'',''),(0,492,1,'EN',2,'',''),(0,493,1,'EN',2,'',''),(0,494,1,'EN',2,'',''),(0,495,4,'EN',2,'Poll',''),(0,496,4,'EN',2,'Add poll',''),(0,866,4,'EN',2,'Pinned topics are always displayed at the top of a forum; highlighting them.',''),(0,475,1,'EN',2,'',''),(0,532,1,'EN',2,'',''),(0,533,4,'EN',2,'Add Comcode page',''),(0,586,2,'EN',2,'',''),(0,585,2,'EN',2,'',''),(0,477,1,'EN',2,'',''),(0,522,1,'EN',2,'Admin Zone',''),(0,524,1,'EN',2,'',''),(0,525,2,'EN',2,'This is an example banner.',''),(0,527,1,'EN',2,'404 Not Found',''),(0,498,1,'EN',2,'Help',''),(0,517,1,'EN',2,'',''),(0,519,1,'EN',2,'',''),(0,500,1,'EN',2,'',''),(0,502,1,'EN',2,'Guestbook',''),(0,511,1,'EN',2,'',''),(0,513,1,'EN',2,'Welcome to (unnamed)',''),(0,515,1,'EN',2,'',''),(0,504,1,'EN',2,'Admin Zone',''),(0,506,1,'EN',2,'',''),(0,507,1,'EN',2,'<p>\n	We wish our comments system to be a polite and helpful area for our visitors, so please stick to our rules\n</p>\n\n<ul>\n	<li>No flaming or profanity</li>\n	<li>No unpleasant rivalry</li>\n	<li>Use the forums for general questions</li>\n	<li>No spamming</li>\n	<li>No incitement to illegality</li>\n</ul>\n\n',''),(0,508,1,'EN',2,'',''),(0,509,1,'EN',2,'You are starting a new support ticket.\n\nThe support ticket system allows you to post private support requests to our support staff. Please do not place multiple unrelated questions in a single support ticket - you can open as many as you like, and we\'ll be able to respond faster to individual tickets. Please include any details that will be necessary for us to solve your problem, such as system information, URLs, sample data, or any pertinent passwords we would need.\n\nWe will respond as quickly as possible.',''),(0,568,1,'EN',2,'Edit quotes',''),(0,915,1,'EN',2,'',''),(0,1026,1,'EN',2,'',''),(0,902,1,'EN',2,'',''),(0,900,1,'EN',2,'',''),(0,588,1,'EN',2,'Banners',''),(0,916,2,'EN',2,'',''),(0,917,2,'EN',2,'',''),(0,919,1,'EN',2,'Welcome to Composr demo',''),(0,597,1,'EN',2,'Featured content',''),(0,601,1,'EN',2,'Featured content',''),(0,602,2,'EN',2,'Works',''),(0,603,2,'EN',2,'',''),(0,606,2,'EN',2,'Shakespeare, William',''),(0,607,2,'EN',2,'Works by William Shakespeare.',''),(0,608,2,'EN',2,'shakespeare,william,works',''),(0,609,2,'EN',2,'Works by William Shakespeare.',''),(0,612,2,'EN',2,'books',''),(0,613,2,'EN',2,'',''),(0,614,2,'EN',2,'Romeo and Juliet',''),(0,615,3,'EN',2,'[align=\"center\"][b]ROMEO AND JULIET[/b]\nby William Shakespeare[/align]\n\n[title=\"2\"]Persons represented[/title]\n\n - Escalus, Prince of Verona.\n - Paris, a young Nobleman, kinsman to the Prince.\n - Montague & Capulet, Heads of two Houses at variance with each other.\n - An Old Man, Uncle to Capulet.\n - Romeo, Son to Montague.\n - Mercutio, Kinsman to the Prince, and Friend to Romeo.\n - Benvolio, Nephew to Montague, and Friend to Romeo.\n - Tybalt, Nephew to Lady Capulet.\n - Friar Lawrence, a Franciscan.\n - Friar John, of the same Order.\n - Balthasar, Servant to Romeo.\n - Sampson, Servant to Capulet.\n - Gregory, Servant to Capulet.\n - Peter, Servant to Juliet\'s Nurse.\n - Abraham, Servant to Montague.\n - An Apothecary.\n - Three Musicians.\n - Chorus.\n - Page to Paris; another Page.\n - An Officer.\n\n - Lady Montague, Wife to Montague.\n - Lady Capulet, Wife to Capulet.\n - Juliet, Daughter to Capulet.\n - Nurse to Juliet.\n\n - Citizens of Verona\n  - Several Men and Women, relations to both houses\n  - Maskers\n  - Guards\n  - Watchmen\n  - Attendants.\n\n[title=\"2\"]Scene[/title]During the greater part of the Play in Verona; once, in\nthe Fifth Act, at Mantua.',''),(0,616,3,'EN',2,'',''),(0,786,2,'EN',2,'romeo,juliet,align,center,william,shakespeare,title,persons,represented,escalus,prince,verona,paris,young,nobleman,kinsman,montague,capulet,heads,houses,variance,old,man,uncle,son,mercutio,friend,benvolio,nephew,tybalt,lady,friar,lawrence,franciscan,john,',''),(0,787,2,'EN',2,'[align=\"center\"][b]ROMEO AND JULIET[/b] by William Shakespeare[/align]  [title=\"2\"]Persons represented[/title]   - Escalus, Prince of Verona.  - Paris, a young Nobleman, kinsman to the Prince.  - Montague & Capulet, Heads of two Houses at variance with ea',''),(0,619,2,'EN',2,'',''),(0,620,2,'EN',2,'',''),(0,621,1,'EN',2,'Gallery for Romeo and Juliet download',''),(0,622,2,'EN',2,'gallery,romeo,juliet,download',''),(0,623,2,'EN',2,'',''),(0,624,4,'EN',2,'Add a new download',''),(0,628,1,'EN',2,'Featured content',''),(0,629,2,'EN',2,'William Shakespeare',''),(0,630,2,'EN',2,'',''),(0,631,4,'EN',2,'Image of the day',''),(0,632,4,'EN',2,'Add image of the day',''),(0,636,1,'EN',2,'Featured content',''),(0,640,1,'EN',2,'Featured content',''),(0,1028,1,'EN',2,'',''),(0,652,3,'EN',2,'',''),(0,653,2,'EN',2,'Works by William Shakespeare',''),(0,654,3,'EN',2,'',''),(0,655,2,'EN',2,'Works by William Shakespeare',''),(0,656,3,'EN',2,'Romeo and Juliet',''),(0,657,3,'EN',2,'Shakespeare\'s classic tragic-romance play, in manuscript format.',''),(0,660,2,'EN',2,'romeo,juliet,uploads,catalogues,brown,jpg,delightful',''),(0,661,2,'EN',2,'',''),(0,662,3,'EN',2,'Hamlet',''),(0,663,3,'EN',2,'The Prince of Denmark\'s story is told in this epic Shakespearean play.',''),(0,664,2,'EN',2,'hamlet,uploads,catalogues,edwin,booth,jpg,prince,denmarks,story,told,epic,shakespearean,play',''),(0,665,2,'EN',2,'',''),(0,666,4,'EN',2,'Add catalogue entry',''),(0,672,2,'EN',2,'barack,obama,barry,whitehouse,gov,executive,office,president,united,states,america,white,house,pennsylvania,avenue,washington,msn,state,union,inauguration',''),(0,669,4,'EN',2,'Add catalogue entry',''),(0,670,2,'EN',2,'gordon,brown,number,gov,majestys,government,downing,street,london,www,aol,queens,speech,prime,minister,united,kingdom,great,britain,northern,ireland',''),(0,671,2,'EN',2,'',''),(0,673,2,'EN',2,'',''),(0,709,2,'EN',2,'[attachment thumb=\"1\" type=\"inline\" description=\"\"]2[/attachment]',''),(0,710,2,'EN',2,'Meeting',''),(0,711,3,'EN',2,'Meeting with world leaders on how to effectively deploy Composr.',''),(0,712,2,'EN',2,'meeting,world,leaders,effectively,deploy,composr',''),(0,713,2,'EN',2,'Meeting with world leaders on how to effectively deploy Composr.',''),(0,714,1,'EN',2,'This is the first news article.',''),(0,715,1,'EN',2,'',''),(0,716,2,'EN',2,'This is the first news article in this demonstration.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed a lacus augue. Quisque luctus erat in sem placerat id facilisis lectus pharetra. Fusce ut dolor turpis, vitae lobortis sapien. In a metus quis eros adipiscing adipiscing non id quam. Aenean sapien leo, feugiat ut consectetur at, blandit nec felis. Duis eu urna nisi. Cras erat libero, lobortis cursus dignissim ut, interdum quis nibh. Integer feugiat mollis libero non aliquet. Proin quis libero quis tellus iaculis varius. Ut suscipit volutpat lorem, quis facilisis elit malesuada vel. Phasellus convallis tincidunt ante in porttitor. Phasellus elementum egestas quam, non laoreet eros euismod quis. Sed vel urna vitae leo gravida ullamcorper.\n\nNunc vitae suscipit elit. Nam porttitor pulvinar purus, id semper lacus fringilla non. Praesent a gravida urna. Curabitur nec ipsum risus, ultrices congue dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed commodo fermentum elit quis dignissim. Pellentesque ac consequat ante. Sed rutrum imperdiet interdum. Quisque tincidunt semper euismod. Sed sodales molestie arcu eget mattis. Aenean nunc urna, mattis viverra condimentum sit amet, eleifend nec nulla. Suspendisse congue dui sed turpis egestas quis faucibus nulla tempor. Praesent dapibus ligula ut odio congue nec fringilla ante faucibus. Sed odio augue, hendrerit ut egestas vitae, imperdiet a eros. Sed et dui massa. Morbi sed mi vel augue tempus sollicitudin quis at justo. Sed ullamcorper nulla eu nunc tincidunt auctor. Suspendisse potenti.\n\nSed porta sem et est dictum venenatis. Fusce in augue felis. Maecenas ipsum lorem, fermentum id adipiscing sed, sollicitudin id leo. Morbi magna ligula, dapibus vulputate pharetra sed, accumsan vulputate est. Mauris dictum sapien vestibulum sapien pellentesque interdum. Ut sollicitudin, metus ut mattis dignissim, sapien est dapibus sapien, ut gravida tortor neque eget leo. Sed tincidunt laoreet dui, nec luctus metus egestas eget. Integer elit est, tincidunt sit amet vehicula vel, tristique sit amet dui. Donec sed ipsum sed nisi iaculis fermentum. Fusce magna tellus, iaculis vel commodo ut, iaculis tincidunt magna. Phasellus tempor urna ut nisi elementum semper. In bibendum, quam a iaculis pellentesque, lorem ante commodo orci, id dignissim ante enim semper risus. Maecenas at orci a nunc rhoncus pellentesque eget ac sapien.\n\nCurabitur tortor purus, bibendum sed lacinia sit amet, dictum sit amet nibh. Donec sit amet mi vitae urna vehicula condimentum a vitae lectus. Nulla id feugiat enim. Sed porta lacinia tempor. Aenean porta nunc ut enim sagittis congue. Vivamus rutrum nunc eget urna pulvinar sagittis. Etiam commodo arcu in risus dictum ultricies. Quisque purus velit, cursus eu ullamcorper at, tincidunt et ante. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec sem nisl, dignissim quis pulvinar ac, commodo a nibh. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris ac justo vel leo consequat suscipit nec quis augue. Fusce porttitor, neque vel lacinia vestibulum, purus nunc faucibus velit, tempus dapibus ante dolor vel nulla. Curabitur at neque metus, id condimentum mauris. In nibh sapien, porta et elementum vel, facilisis sit amet arcu. Maecenas vel sapien quis enim placerat accumsan sit amet non justo. Integer consectetur, enim et pharetra auctor, quam magna iaculis tortor, nec congue ligula enim ac ligula. Nunc scelerisque porttitor arcu mollis convallis.\n\nDonec fringilla nulla sit amet orci molestie in vestibulum mauris mollis. Pellentesque et diam arcu. Curabitur tempor varius lectus eget condimentum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Praesent sed ligula quis odio fermentum euismod ac a mi. Donec sed sapien odio, in sodales augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sit amet nunc turpis. In scelerisque dictum urna ut porttitor. Fusce quis sapien metus. Proin a mauris magna, sed vestibulum mauris. Sed ipsum tellus, bibendum at egestas a, molestie nec nisl. Suspendisse tristique vestibulum vehicula. Integer pellentesque pretium lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas vel lacus tincidunt enim volutpat lobortis. Quisque a risus non orci porta ultricies. Donec congue lacinia lacinia.',''),(0,717,2,'EN',2,'first,news,article',''),(0,718,2,'EN',2,'',''),(0,719,4,'EN',2,'Add news',''),(0,720,1,'EN',2,'This is the second news article.',''),(0,721,1,'EN',2,'',''),(0,722,2,'EN',2,'This is the second news article in this demonstration.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Sed a lacus augue. Quisque luctus erat in sem placerat id facilisis lectus pharetra. Fusce ut dolor turpis, vitae lobortis sapien. In a metus quis eros adipiscing adipiscing non id quam. Aenean sapien leo, feugiat ut consectetur at, blandit nec felis. Duis eu urna nisi. Cras erat libero, lobortis cursus dignissim ut, interdum quis nibh. Integer feugiat mollis libero non aliquet. Proin quis libero quis tellus iaculis varius. Ut suscipit volutpat lorem, quis facilisis elit malesuada vel. Phasellus convallis tincidunt ante in porttitor. Phasellus elementum egestas quam, non laoreet eros euismod quis. Sed vel urna vitae leo gravida ullamcorper.\n\nNunc vitae suscipit elit. Nam porttitor pulvinar purus, id semper lacus fringilla non. Praesent a gravida urna. Curabitur nec ipsum risus, ultrices congue dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Sed commodo fermentum elit quis dignissim. Pellentesque ac consequat ante. Sed rutrum imperdiet interdum. Quisque tincidunt semper euismod. Sed sodales molestie arcu eget mattis. Aenean nunc urna, mattis viverra condimentum sit amet, eleifend nec nulla. Suspendisse congue dui sed turpis egestas quis faucibus nulla tempor. Praesent dapibus ligula ut odio congue nec fringilla ante faucibus. Sed odio augue, hendrerit ut egestas vitae, imperdiet a eros. Sed et dui massa. Morbi sed mi vel augue tempus sollicitudin quis at justo. Sed ullamcorper nulla eu nunc tincidunt auctor. Suspendisse potenti.\n\nSed porta sem et est dictum venenatis. Fusce in augue felis. Maecenas ipsum lorem, fermentum id adipiscing sed, sollicitudin id leo. Morbi magna ligula, dapibus vulputate pharetra sed, accumsan vulputate est. Mauris dictum sapien vestibulum sapien pellentesque interdum. Ut sollicitudin, metus ut mattis dignissim, sapien est dapibus sapien, ut gravida tortor neque eget leo. Sed tincidunt laoreet dui, nec luctus metus egestas eget. Integer elit est, tincidunt sit amet vehicula vel, tristique sit amet dui. Donec sed ipsum sed nisi iaculis fermentum. Fusce magna tellus, iaculis vel commodo ut, iaculis tincidunt magna. Phasellus tempor urna ut nisi elementum semper. In bibendum, quam a iaculis pellentesque, lorem ante commodo orci, id dignissim ante enim semper risus. Maecenas at orci a nunc rhoncus pellentesque eget ac sapien.\n\nCurabitur tortor purus, bibendum sed lacinia sit amet, dictum sit amet nibh. Donec sit amet mi vitae urna vehicula condimentum a vitae lectus. Nulla id feugiat enim. Sed porta lacinia tempor. Aenean porta nunc ut enim sagittis congue. Vivamus rutrum nunc eget urna pulvinar sagittis. Etiam commodo arcu in risus dictum ultricies. Quisque purus velit, cursus eu ullamcorper at, tincidunt et ante. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec sem nisl, dignissim quis pulvinar ac, commodo a nibh. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris ac justo vel leo consequat suscipit nec quis augue. Fusce porttitor, neque vel lacinia vestibulum, purus nunc faucibus velit, tempus dapibus ante dolor vel nulla. Curabitur at neque metus, id condimentum mauris. In nibh sapien, porta et elementum vel, facilisis sit amet arcu. Maecenas vel sapien quis enim placerat accumsan sit amet non justo. Integer consectetur, enim et pharetra auctor, quam magna iaculis tortor, nec congue ligula enim ac ligula. Nunc scelerisque porttitor arcu mollis convallis.\n\nDonec fringilla nulla sit amet orci molestie in vestibulum mauris mollis. Pellentesque et diam arcu. Curabitur tempor varius lectus eget condimentum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Praesent sed ligula quis odio fermentum euismod ac a mi. Donec sed sapien odio, in sodales augue. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer sit amet nunc turpis. In scelerisque dictum urna ut porttitor. Fusce quis sapien metus. Proin a mauris magna, sed vestibulum mauris. Sed ipsum tellus, bibendum at egestas a, molestie nec nisl. Suspendisse tristique vestibulum vehicula. Integer pellentesque pretium lobortis. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Maecenas vel lacus tincidunt enim volutpat lobortis. Quisque a risus non orci porta ultricies. Donec congue lacinia lacinia.',''),(0,723,2,'EN',2,'second,news,article',''),(0,724,2,'EN',2,'',''),(0,725,4,'EN',2,'Add news',''),(0,726,2,'EN',2,'Romeo and Juliet',''),(0,727,2,'EN',2,'This quiz will test your knowledge of Shakespeare\'s Romeo and Juliet.',''),(0,728,2,'EN',2,'',''),(0,729,2,'EN',2,'Does Romeo love Juliet at the beginning of the play?',''),(0,730,2,'EN',2,'Yes',''),(0,731,2,'EN',2,'No',''),(0,732,2,'EN',2,'Where is the play set?',''),(0,733,2,'EN',2,'London',''),(0,734,2,'EN',2,'Verona',''),(0,735,2,'EN',2,'Bankok',''),(0,736,2,'EN',2,'Who does Tybalt fight in place of Romeo?',''),(0,737,2,'EN',2,'Mercutio',''),(0,738,2,'EN',2,'Benvolio',''),(0,739,2,'EN',2,'Juliet',''),(0,740,2,'EN',2,'Which scene is the play\'s most famous?',''),(0,741,2,'EN',2,'Banquet scene',''),(0,742,2,'EN',2,'Balcony scene',''),(0,743,2,'EN',2,'Space scene',''),(0,744,2,'EN',2,'Who marries the couple?',''),(0,745,2,'EN',2,'Friar Martin',''),(0,746,2,'EN',2,'Friar Lawrence',''),(0,747,2,'EN',2,'Friar Tuck',''),(0,748,2,'EN',2,'romeo,juliet,quiz,knowledge,shakespeares',''),(0,749,2,'EN',2,'This quiz will test your knowledge of Shakespeare\'s Romeo and Juliet.',''),(0,884,1,'EN',2,'Admin Zone',''),(0,751,2,'EN',2,'',''),(0,752,2,'EN',2,'',''),(0,753,1,'EN',2,'Romeo and Juliet',''),(0,754,2,'EN',2,'romeo,juliet',''),(0,755,2,'EN',2,'',''),(0,756,3,'EN',2,'',''),(0,757,2,'EN',2,'',''),(0,758,2,'EN',2,'',''),(0,759,4,'EN',2,'Add image',''),(0,760,3,'EN',2,'',''),(0,761,2,'EN',2,'',''),(0,762,2,'EN',2,'',''),(0,763,4,'EN',2,'Add image',''),(0,764,2,'EN',2,'Hamlet',''),(0,765,3,'EN',2,'The Tragedy of Hamlet, Prince of Denmark, or more simply Hamlet, is a tragedy by William Shakespeare, believed to have been written between 1599 and 1601.',''),(0,766,3,'EN',2,'',''),(0,767,2,'EN',2,'hamlet,tragedy,prince,denmark,simply,william,shakespeare,believed,written,between',''),(0,768,2,'EN',2,'The Tragedy of Hamlet, Prince of Denmark, or more simply Hamlet, is a tragedy by William Shakespeare, believed to have been written between 1599 and 1601.',''),(0,769,2,'EN',2,'',''),(0,770,2,'EN',2,'',''),(0,771,1,'EN',2,'Gallery for Hamlet download',''),(0,772,2,'EN',2,'gallery,hamlet,download',''),(0,773,2,'EN',2,'',''),(0,774,4,'EN',2,'Add a new download',''),(0,775,4,'EN',2,'Add Comcode page',''),(0,776,2,'EN',2,'',''),(0,777,2,'EN',2,'',''),(0,779,1,'EN',2,'Comcode page support',''),(0,780,4,'EN',2,'Add Comcode page',''),(0,781,2,'EN',2,'',''),(0,782,2,'EN',2,'',''),(0,784,1,'EN',2,'',''),(0,785,4,'EN',2,'Gamble',''),(0,795,4,'EN',2,'Add Comcode page',''),(0,1019,2,'EN',2,'',''),(0,1022,1,'EN',2,'Rich media and presentation support',''),(0,879,1,'EN',2,'Rich media and presentation support',''),(0,881,1,'EN',2,'404 Not Found',''),(0,803,1,'EN',2,'Rich media and presentation support',''),(0,805,1,'EN',2,'Rich media and presentation support',''),(0,1020,2,'EN',2,'',''),(0,809,1,'EN',2,'Rich media and presentation support',''),(0,799,1,'EN',2,'Rich media and presentation support',''),(0,877,1,'EN',2,'Child page',''),(0,1024,1,'EN',2,'',''),(0,1018,1,'EN',2,'Rich media and presentation support',''),(0,873,1,'EN',2,'',''),(0,875,1,'EN',2,'Comcode page support',''),(0,871,1,'EN',2,'',''),(0,869,1,'EN',2,'Welcome to (unnamed)',''),(0,921,1,'EN',2,'Welcome to Composr demo',''),(0,867,4,'EN',2,'Sunk topics are buried lower in a forum; removing them from priority.',''),(0,862,1,'EN',2,'',''),(0,864,1,'EN',2,'',''),(0,865,4,'EN',2,'This is a reported post for a post in the topic [post param=\"Here is a topic with a poll.\"]4[/post], by [page type=\"view\" id=\"2\" param=\"site\" caption=\"admin\"]members[/page]\n\n[quote=\"admin\"]\nPlease vote!\n[/quote]\n\n/// PUT YOUR REPORT BELOW \\\\\n\nThis is a reported post. Users may report posts that require the attention of a staff member. Report posts are filed in a specific forum.',''),(0,853,4,'EN',2,'Posts in a topic have full Comcode support, too!',''),(0,854,4,'EN',2,'Here is a reply.',''),(0,855,4,'EN',2,'Please vote!',''),(0,856,4,'EN',2,'Members can use the whisper feature...',''),(0,857,4,'EN',2,'...to create an in-line personal post to a certain member (in this case, Guests)!',''),(0,858,4,'EN',2,'Only the intended recipient (and members of the website staff) are able to see whispered posts.',''),(0,859,4,'EN',2,'When a topic is placed in the forum root and marked as \'cascading\', it will act as an announcement and appear in every subforum!',''),(0,860,4,'EN',2,'This is a personal topic, between two users.',''),(0,1030,1,'EN',2,'Welcome to Composr demo',''),(0,1032,1,'EN',2,'Composr&#039;s different menu-types',''),(0,1033,3,'EN',1,'',''),(0,1034,3,'EN',1,'',''),(0,1035,3,'EN',1,'',''),(0,1036,3,'EN',1,'',''),(0,1037,3,'EN',1,'',''),(0,1038,3,'EN',1,'',''),(0,1039,3,'EN',1,'',''),(0,1040,3,'EN',1,'',''),(0,1041,3,'EN',1,'',''),(0,1042,3,'EN',1,'',''),(0,1043,3,'EN',1,'',''),(0,1044,3,'EN',1,'',''),(0,1045,3,'EN',1,'',''),(0,1046,3,'EN',1,'',''),(0,1047,3,'EN',1,'',''),(0,1048,3,'EN',1,'',''),(0,1049,3,'EN',1,'',''),(0,1050,1,'EN',1,'Quizzes',''),(0,1051,1,'EN',1,'',''),(0,1053,1,'EN',2,'',''),(0,1055,1,'EN',2,'',''),(0,1057,1,'EN',2,'',''),(0,1059,1,'EN',2,'Welcome to Composr demo',''),(0,1061,1,'EN',2,'',''),(0,1062,1,'EN',1,'Recommend site',''),(0,1063,1,'EN',1,'','');
/*!40000 ALTER TABLE `cms_translate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_translate_history`
--

DROP TABLE IF EXISTS `cms_translate_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_translate_history` (
  `action_member` int(11) NOT NULL,
  `action_time` int(10) unsigned NOT NULL,
  `broken` tinyint(1) NOT NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `language` varchar(5) NOT NULL,
  `lang_id` int(11) NOT NULL,
  `text_original` longtext NOT NULL,
  PRIMARY KEY  (`id`,`language`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_translate_history`
--

LOCK TABLES `cms_translate_history` WRITE;
/*!40000 ALTER TABLE `cms_translate_history` DISABLE KEYS */;
INSERT INTO `cms_translate_history` VALUES (2,1264682250,0,1,'EN',701,''),(2,1264682414,0,2,'EN',697,'');
/*!40000 ALTER TABLE `cms_translate_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_tutorial_links`
--

DROP TABLE IF EXISTS `cms_tutorial_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_tutorial_links` (
  `the_name` varchar(80) NOT NULL,
  `the_value` longtext NOT NULL,
  PRIMARY KEY  (`the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_tutorial_links`
--

LOCK TABLES `cms_tutorial_links` WRITE;
/*!40000 ALTER TABLE `cms_tutorial_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_tutorial_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_url_id_monikers`
--

DROP TABLE IF EXISTS `cms_url_id_monikers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_url_id_monikers` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `m_deprecated` tinyint(1) NOT NULL,
  `m_moniker` varchar(255) NOT NULL,
  `m_resource_id` varchar(80) NOT NULL,
  `m_resource_page` varchar(80) NOT NULL,
  `m_resource_type` varchar(80) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `uim_moniker` (`m_moniker`),
  KEY `uim_pagelink` (`m_resource_page`,`m_resource_type`,`m_resource_id`)
) ENGINE=MyISAM AUTO_INCREMENT=58 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_url_id_monikers`
--

LOCK TABLES `cms_url_id_monikers` WRITE;
/*!40000 ALTER TABLE `cms_url_id_monikers` DISABLE KEYS */;
INSERT INTO `cms_url_id_monikers` VALUES (1,0,'admin','2','members','view'),(2,0,'test','3','members','view'),(3,0,'links','3','catalogues','category'),(4,0,'home','6','catalogues','category'),(5,0,'what_type_of_books_do','1','polls','view'),(6,0,'news','2','forumview','misc'),(7,0,'general_chat','3','forumview','misc'),(8,0,'feedback','4','forumview','misc'),(9,0,'website_comment_topics','7','forumview','misc'),(10,0,'reported_posts_forum','5','forumview','misc'),(11,0,'trash','6','forumview','misc'),(12,0,'website_support_tickets','8','forumview','misc'),(13,0,'staff','9','forumview','misc'),(14,0,'website_contact_us','10','forumview','misc'),(15,0,'administrators','2','groups','view'),(16,1,'books','2','downloads','misc'),(17,1,'books/shakespeare_william','3','downloads','misc'),(18,0,'works','2','downloads','misc'),(19,0,'works/shakespeare_william_2','3','downloads','misc'),(20,0,'downloads_home','1','downloads','misc'),(21,0,'works/shakespeare_william_2/romeo_and_juliet','1','downloads','entry'),(22,0,'william_shakespeare','1','iotds','view'),(23,0,'works_by_william','7','catalogues','category'),(24,0,'home/works_by_william_2','8','catalogues','category'),(25,0,'home/works_by_william_2/romeo_and_juliet','1','catalogues','entry'),(26,0,'home/works_by_william_2/hamlet','2','catalogues','entry'),(27,0,'contacts','5','catalogues','category'),(28,0,'contacts/barack','3','catalogues','entry'),(29,0,'contacts/gordon','4','catalogues','entry'),(30,0,'frequently_asked','4','catalogues','category'),(31,0,'hosted_sites','2','catalogues','category'),(32,0,'super-member_projects','1','catalogues','category'),(33,0,'links/composr','5','catalogues','entry'),(34,0,'links/ocproducts','6','catalogues','entry'),(35,0,'links/open_source_initiative','7','catalogues','entry'),(36,0,'meeting','1','calendar','view'),(37,0,'this_is_the_first_news','1','news','view'),(38,0,'general','1','news','misc'),(39,0,'this_is_the_second_news','2','news','view'),(40,0,'romeo_and_juliet','1','quiz','do'),(41,0,'','1','galleries','image'),(42,0,'_2','2','galleries','image'),(43,0,'works/shakespeare_william_2/hamlet','2','downloads','entry'),(44,0,'general_chat','1','chat','room'),(45,0,'romeo_and_juliet','1','downloads','view'),(46,0,'gallery_for_romeo_and','download_1','galleries','misc'),(47,0,'general_chat/this_is_a_topic_title','2','topicview','misc'),(48,0,'general_chat/here_is_a_topic_with_a','3','topicview','misc'),(49,0,'general_chat/this_topic_contains_a','4','topicview','misc'),(50,0,'this_topic_acts_as_an','5','topicview','misc'),(51,0,'guest','1','members','view'),(52,0,'staff/welcome_to_the_forums','1','topicview','misc'),(53,0,'forum_home','1','forumview','misc'),(54,0,'personal_topic_example','6','topicview','misc'),(55,0,'reported_posts_forum/reported_post_in_here','7','topicview','misc'),(56,0,'general_chat/this_topic_is_pinned','8','topicview','misc'),(57,0,'general_chat/this_topic_is_sunk','9','topicview','misc');
/*!40000 ALTER TABLE `cms_url_id_monikers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_url_title_cache`
--

DROP TABLE IF EXISTS `cms_url_title_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_url_title_cache` (
  `t_title` varchar(255) NOT NULL,
  `t_url` varchar(255) NOT NULL,
  PRIMARY KEY  (`t_url`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_url_title_cache`
--

LOCK TABLES `cms_url_title_cache` WRITE;
/*!40000 ALTER TABLE `cms_url_title_cache` DISABLE KEYS */;
INSERT INTO `cms_url_title_cache` VALUES ('!1332809597','!http://compo.sr/uploads/website_specific/compo.sr/logos/a.png'),('!1332809597','!http://compo.sr/?from=logo');
/*!40000 ALTER TABLE `cms_url_title_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_usersonline_track`
--

DROP TABLE IF EXISTS `cms_usersonline_track`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_usersonline_track` (
  `date_and_time` int(10) unsigned NOT NULL,
  `peak` int(11) NOT NULL,
  PRIMARY KEY  (`date_and_time`),
  KEY `peak_track` (`peak`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_usersonline_track`
--

LOCK TABLES `cms_usersonline_track` WRITE;
/*!40000 ALTER TABLE `cms_usersonline_track` DISABLE KEYS */;
INSERT INTO `cms_usersonline_track` VALUES (1264606970,0),(1264606982,0),(1264607030,0),(1264607038,0),(1264607039,0),(1264607066,0),(1264607069,0),(1264607089,0),(1264607094,0),(1264607215,2),(1264607223,2),(1264607237,2),(1264607243,2),(1264607266,2),(1264607290,2),(1264607299,2),(1264607313,2),(1264607399,1),(1264607439,1),(1264607443,1),(1264607451,1),(1264607460,1),(1264607465,1),(1264607478,1),(1264607481,1),(1264607510,1),(1264607513,1),(1264607518,1),(1264607551,1),(1264607556,1),(1264607559,1),(1264607566,1),(1264607599,1),(1264607605,1),(1264607625,1),(1264607627,1),(1264607631,1),(1264607635,1),(1264607664,1),(1264607668,1),(1264607693,1),(1264607697,1),(1264607701,1),(1264607704,1),(1264607707,1),(1264607713,1),(1264607714,1),(1264607718,1),(1264607719,1),(1264607771,1),(1264607775,1),(1264607777,1),(1264607780,1),(1264607791,1),(1264607805,1),(1264607808,1),(1264607811,1),(1264607813,1),(1264607814,1),(1264607817,1),(1264607818,1),(1264607823,1),(1264607826,1),(1264607860,1),(1264607868,1),(1264607888,1),(1264607890,1),(1264607924,1),(1264607929,1),(1264607930,1),(1264607958,1),(1264607961,1),(1264607969,1),(1264607973,1),(1264607975,1),(1264607976,1),(1264608031,1),(1264608035,1),(1264608041,1),(1264608044,1),(1264608051,1),(1264608054,1),(1264608096,1),(1264608100,1),(1264608103,1),(1264608125,1),(1264608129,1),(1264608135,1),(1264608137,1),(1264608156,1),(1264608160,1),(1264608163,1),(1264608166,1),(1264608171,1),(1264608173,1),(1264608174,1),(1264608314,1),(1264608329,1),(1264608334,1),(1264608450,1),(1264608452,1),(1264608461,1),(1264608465,1),(1264608466,1),(1264608468,1),(1264608469,1),(1264608471,1),(1264608472,1),(1264608475,1),(1264608476,1),(1264608478,1),(1264608479,1),(1264608481,1),(1264608482,1),(1264608485,1),(1264608486,1),(1264608490,1),(1264608493,1),(1264608494,1),(1264608497,1),(1264608498,1),(1264608501,1),(1264608505,1),(1264608507,1),(1264608510,1),(1264608511,1),(1264608513,1),(1264608514,1),(1264608517,1),(1264608522,1),(1264608528,1),(1264608530,1),(1264608533,1),(1264608541,1),(1264608544,1),(1264608548,1),(1264608557,1),(1264608564,1),(1264608566,1),(1264608580,1),(1264608592,1),(1264608599,1),(1264608602,1),(1264608606,1),(1264608609,1),(1264608610,1),(1264608612,1),(1264608615,2),(1264608618,2),(1264608619,2),(1264608621,2),(1264608626,2),(1264608630,2),(1264608648,2),(1264608660,2),(1264608670,2),(1264608673,2),(1264608674,2),(1264608676,2),(1264608680,2),(1264608682,2),(1264608716,2),(1264608734,2),(1264608742,2),(1264608745,2),(1264608771,2),(1264608776,2),(1264608795,2),(1264608800,2),(1264608816,2),(1264608819,2),(1264608879,2),(1264608882,2),(1264608886,2),(1264608889,2),(1264609167,1),(1264609171,1),(1264609183,1),(1264609187,1),(1264609190,1),(1264609337,1);
/*!40000 ALTER TABLE `cms_usersonline_track` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_usersubmitban_ip`
--

DROP TABLE IF EXISTS `cms_usersubmitban_ip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_usersubmitban_ip` (
  `ip` varchar(40) NOT NULL,
  `i_descrip` longtext NOT NULL,
  `i_ban_until` int(10) unsigned default NULL,
  `i_ban_positive` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_usersubmitban_ip`
--

LOCK TABLES `cms_usersubmitban_ip` WRITE;
/*!40000 ALTER TABLE `cms_usersubmitban_ip` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_usersubmitban_ip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_usersubmitban_member`
--

DROP TABLE IF EXISTS `cms_usersubmitban_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_usersubmitban_member` (
  `the_member` int(11) NOT NULL,
  PRIMARY KEY  (`the_member`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_usersubmitban_member`
--

LOCK TABLES `cms_usersubmitban_member` WRITE;
/*!40000 ALTER TABLE `cms_usersubmitban_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_usersubmitban_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_validated_once`
--

DROP TABLE IF EXISTS `cms_validated_once`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_validated_once` (
  `hash` varchar(33) NOT NULL,
  PRIMARY KEY  (`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_validated_once`
--

LOCK TABLES `cms_validated_once` WRITE;
/*!40000 ALTER TABLE `cms_validated_once` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_validated_once` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_values`
--

DROP TABLE IF EXISTS `cms_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_values` (
  `date_and_time` int(10) unsigned NOT NULL,
  `the_name` varchar(80) NOT NULL,
  `the_value` varchar(80) NOT NULL,
  PRIMARY KEY  (`the_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_values`
--

LOCK TABLES `cms_values` WRITE;
/*!40000 ALTER TABLE `cms_values` DISABLE KEYS */;
INSERT INTO `cms_values` VALUES (1332801830,'version','9'),(1332808931,'ocf_version','9'),(1332809593,'users_online','1'),(1332808429,'user_peak','2'),(1332801830,'ocf_member_count','2'),(1332801830,'ocf_topic_count','9'),(1332801830,'ocf_post_count','13'),(1264606970,'ran_once','1'),(1265488037,'last_base_url','http://localhost/ocproducts/Dropbox/ocproducts/our-website/demo_dev'),(1332809594,'last_space_check','1332809594'),(1344635440,'uses_ftp','0'),(1332809599,'site_bestmember','test'),(1332809611,'ocf_newest_member_id','2'),(1332809611,'ocf_newest_member_username','admin'),(1332809605,'site_salt','4f710f85d045b1.51372752'),(1264685674,'num_archive_downloads','2'),(1264685674,'archive_size','140838'),(1264681798,'num_seedy_pages','3'),(1264682523,'num_seedy_posts','2'),(1264686105,'last_active_prune','1264686105'),(1265480679,'hits','17'),(1265397866,'last_backup','1265397866');
/*!40000 ALTER TABLE `cms_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_video_transcoding`
--

DROP TABLE IF EXISTS `cms_video_transcoding`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_video_transcoding` (
  `t_id` varchar(80) NOT NULL,
  `t_error` longtext NOT NULL,
  `t_url` varchar(255) NOT NULL,
  `t_table` varchar(80) NOT NULL,
  `t_url_field` varchar(80) NOT NULL,
  `t_orig_filename_field` varchar(80) NOT NULL,
  `t_width_field` varchar(80) NOT NULL,
  `t_height_field` varchar(80) NOT NULL,
  `t_output_filename` varchar(80) NOT NULL,
  PRIMARY KEY  (`t_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_video_transcoding`
--

LOCK TABLES `cms_video_transcoding` WRITE;
/*!40000 ALTER TABLE `cms_video_transcoding` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_video_transcoding` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_videos`
--

DROP TABLE IF EXISTS `cms_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_videos` (
  `add_date` int(10) unsigned NOT NULL,
  `allow_comments` tinyint(4) NOT NULL,
  `allow_rating` tinyint(1) NOT NULL,
  `allow_trackbacks` tinyint(1) NOT NULL,
  `cat` varchar(80) NOT NULL,
  `comments` int(10) unsigned NOT NULL,
  `edit_date` int(10) unsigned default NULL,
  `id` int(10) unsigned NOT NULL auto_increment,
  `notes` longtext NOT NULL,
  `submitter` int(11) NOT NULL,
  `thumb_url` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `validated` tinyint(1) NOT NULL,
  `video_height` int(11) NOT NULL,
  `video_length` int(11) NOT NULL,
  `video_views` int(11) NOT NULL,
  `video_width` int(11) NOT NULL,
  `title` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY `category_list` (`cat`),
  KEY `ftjoin_vcomments` (`comments`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_videos`
--

LOCK TABLES `cms_videos` WRITE;
/*!40000 ALTER TABLE `cms_videos` DISABLE KEYS */;
/*!40000 ALTER TABLE `cms_videos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_wordfilter`
--

DROP TABLE IF EXISTS `cms_wordfilter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_wordfilter` (
  `word` varchar(255) NOT NULL,
  `w_replacement` varchar(255) NOT NULL,
  `w_substr` tinyint(1) NOT NULL,
  PRIMARY KEY  (`word`,`w_substr`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_wordfilter`
--

LOCK TABLES `cms_wordfilter` WRITE;
/*!40000 ALTER TABLE `cms_wordfilter` DISABLE KEYS */;
INSERT INTO `cms_wordfilter` VALUES ('arsehole','',0),('asshole','',0),('arse','',0),('cock','',0),('cocked','',0),('cocksucker','',0),('crap','',0),('cunt','',0),('cum','',0),('bastard','',0),('bitch','',0),('blowjob','',0),('bollocks','',0),('bondage','',0),('bugger','',0),('buggery','',0),('dickhead','',0),('fuck','',0),('fucked','',0),('fucking','',0),('fucker','',0),('gayboy','',0),('motherfucker','',0),('nigger','',0),('piss','',0),('pissed','',0),('puffter','',0),('pussy','',0),('shag','',0),('shagged','',0),('shat','',0),('shit','',0),('slut','',0),('twat','',0),('wank','',0),('wanker','',0),('whore','',0);
/*!40000 ALTER TABLE `cms_wordfilter` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_zones`
--

DROP TABLE IF EXISTS `cms_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_zones` (
  `zone_default_page` varchar(80) NOT NULL,
  `zone_displayed_in_menu` tinyint(1) NOT NULL,
  `zone_header_text` int(10) unsigned NOT NULL,
  `zone_name` varchar(80) NOT NULL,
  `zone_require_session` tinyint(1) NOT NULL,
  `zone_theme` varchar(80) NOT NULL,
  `zone_title` int(10) unsigned NOT NULL,
  `zone_wide` tinyint(1) default NULL,
  PRIMARY KEY  (`zone_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_zones`
--

LOCK TABLES `cms_zones` WRITE;
/*!40000 ALTER TABLE `cms_zones` DISABLE KEYS */;
INSERT INTO `cms_zones` VALUES ('start',0,1,'',0,'_unnamed_',7,0),('start',1,2,'adminzone',1,'default',8,0),('start',1,4,'site',0,'_unnamed_',9,0),('start',1,3,'collaboration',0,'_unnamed_',10,0),('cms',1,5,'cms',1,'default',11,0),('forumview',1,12,'forum',0,'_unnamed_',14,NULL);
/*!40000 ALTER TABLE `cms_zones` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2012-08-10 22:51:08
