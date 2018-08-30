DROP TABLE IF EXISTS cms_member_privileges;

CREATE TABLE cms_member_privileges (
    member_id integer NOT NULL,
    privilege varchar(80) NOT NULL,
    the_page varchar(80) NOT NULL,
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    the_value tinyint(1) NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (member_id, privilege, the_page, module_the_name, category_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_member_privileges ADD INDEX member_privileges_member (member_id);

ALTER TABLE cms11_member_privileges ADD INDEX member_privileges_name (privilege,the_page,module_the_name,category_name);

DROP TABLE IF EXISTS cms_member_tracking;

CREATE TABLE cms_member_tracking (
    mt_member_id integer NOT NULL,
    mt_cache_username varchar(80) NOT NULL,
    mt_time integer unsigned NOT NULL,
    mt_page varchar(80) NOT NULL,
    mt_type varchar(80) NOT NULL,
    mt_id varchar(80) NOT NULL,
    PRIMARY KEY (mt_member_id, mt_time, mt_page, mt_type, mt_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_member_tracking ADD INDEX mt_id (mt_page,mt_id,mt_type);

ALTER TABLE cms11_member_tracking ADD INDEX mt_page (mt_page);

ALTER TABLE cms11_member_tracking ADD INDEX mt_time (mt_time);

DROP TABLE IF EXISTS cms_member_zone_access;

CREATE TABLE cms_member_zone_access (
    zone_name varchar(80) NOT NULL,
    member_id integer NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (zone_name, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_member_zone_access ADD INDEX mzamember_id (member_id);

ALTER TABLE cms11_member_zone_access ADD INDEX mzazone_name (zone_name);

DROP TABLE IF EXISTS cms_menu_items;

CREATE TABLE cms_menu_items (
    id integer unsigned auto_increment NOT NULL,
    i_menu varchar(80) NOT NULL,
    i_order integer NOT NULL,
    i_parent integer NULL,
    i_caption longtext NOT NULL,
    i_caption_long longtext NOT NULL,
    i_url varchar(255) NOT NULL,
    i_check_permissions tinyint(1) NOT NULL,
    i_expanded tinyint(1) NOT NULL,
    i_new_window tinyint(1) NOT NULL,
    i_include_sitemap tinyint NOT NULL,
    i_page_only varchar(80) NOT NULL,
    i_theme_img_code varchar(80) NOT NULL,
    i_caption__text_parsed longtext NOT NULL,
    i_caption__source_user integer DEFAULT 1 NOT NULL,
    i_caption_long__text_parsed longtext NOT NULL,
    i_caption_long__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_menu_items ADD FULLTEXT i_caption (i_caption);

ALTER TABLE cms11_menu_items ADD FULLTEXT i_caption_long (i_caption_long);

ALTER TABLE cms11_menu_items ADD INDEX menu_extraction (i_menu);

DROP TABLE IF EXISTS cms_messages_to_render;

CREATE TABLE cms_messages_to_render (
    id integer unsigned auto_increment NOT NULL,
    r_session_id varchar(80) NOT NULL,
    r_message longtext NOT NULL,
    r_type varchar(80) NOT NULL,
    r_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_messages_to_render ADD INDEX forsession (r_session_id);

DROP TABLE IF EXISTS cms_modules;

CREATE TABLE cms_modules (
    module_the_name varchar(80) NOT NULL,
    module_author varchar(80) NOT NULL,
    module_organisation varchar(80) NOT NULL,
    module_hacked_by varchar(80) NOT NULL,
    module_hack_version integer NULL,
    module_version integer NOT NULL,
    PRIMARY KEY (module_the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_permissions', 'Chris Graham', 'ocProducts', '', NULL, 10);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_version', 'Chris Graham', 'ocProducts', '', NULL, 18);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_actionlog', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_addons', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_aggregate_types', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_awards', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_backup', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_banners', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_broken_urls', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_chat', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cleanup', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_customprofilefields', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_emoticons', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_forums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_forum_groupings', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_ldap', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_members', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_merge_members', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_multi_moderations', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_post_templates', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_welcome_emails', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_commandr', 'Philip Withnall', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_config', 'Chris Graham', 'ocProducts', '', NULL, 15);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_content_reviews', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_custom_comcode', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_debrand', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_ecommerce', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_ecommerce_logs', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_email_log', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_errorlog', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_group_member_timeouts', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_health_check', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_import', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_invoices', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_ip_ban', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_lang', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_lookup', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_menus', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_newsletter', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_notifications', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_oauth', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_phpinfo', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_points', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_quiz', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_realtime_rain', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_redirects', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_revisions', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_security', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_setupwizard', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_shopping', 'Manuprathap', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_sitemap', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_ssl', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_stats', 'Philip Withnall', 'ocProducts', '', NULL, 10);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_svg_sprites', 'Salman Abbas', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_themes', 'Chris Graham', 'ocProducts', '', NULL, 6);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_themewizard', 'Allen Ellis', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_tickets', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_trackbacks', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_unvalidated', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_wordfilter', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_zones', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('forumview', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('topics', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('topicview', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('vforums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_authors', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_banners', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_blogs', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_calendar', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_catalogues', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_chat', 'Philip Withnall', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_cns_groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_comcode_pages', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_downloads', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_galleries', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_news', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_polls', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_quiz', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('cms_wiki', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('filedump', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('authors', 'Chris Graham', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('awards', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('banners', 'Chris Graham', 'ocProducts', '', NULL, 8);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('calendar', 'Chris Graham', 'ocProducts', '', NULL, 9);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('catalogues', 'Chris Graham', 'ocProducts', '', NULL, 9);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('chat', 'Philip Withnall', 'ocProducts', '', NULL, 13);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('contact_member', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('downloads', 'Chris Graham', 'ocProducts', '', NULL, 8);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('forums', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('galleries', 'Chris Graham', 'ocProducts', '', NULL, 10);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('groups', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('invoices', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('join', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('leader_board', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('login', 'Chris Graham', 'ocProducts', '', NULL, 3);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('lost_password', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('members', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('news', 'Chris Graham', 'ocProducts', '', NULL, 8);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('newsletter', 'Chris Graham', 'ocProducts', '', NULL, 13);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('notifications', 'Chris Graham', 'ocProducts', '', NULL, 1);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('points', 'Chris Graham', 'ocProducts', '', NULL, 9);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('polls', 'Chris Graham', 'ocProducts', '', NULL, 6);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('purchase', 'Chris Graham', 'ocProducts', '', NULL, 8);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('quiz', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('recommend', 'Chris Graham', 'ocProducts', '', NULL, 5);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('report_content', 'Chris Graham / Patrick Schmalstig', 'ocProducts', '', NULL, 4);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('search', 'Chris Graham', 'ocProducts', '', NULL, 6);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('shopping', 'Manuprathap', 'ocProducts', '', NULL, 8);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('subscriptions', 'Chris Graham', 'ocProducts', '', NULL, 6);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('tickets', 'Chris Graham', 'ocProducts', '', NULL, 7);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('users_online', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('warnings', 'Chris Graham', 'ocProducts', '', NULL, 2);
INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('wiki', 'Chris Graham', 'ocProducts', '', NULL, 10);

DROP TABLE IF EXISTS cms_news;

CREATE TABLE cms_news (
    id integer unsigned auto_increment NOT NULL,
    date_and_time integer unsigned NOT NULL,
    title longtext NOT NULL,
    news longtext NOT NULL,
    news_article longtext NOT NULL,
    allow_rating tinyint(1) NOT NULL,
    allow_comments tinyint NOT NULL,
    allow_trackbacks tinyint(1) NOT NULL,
    notes longtext NOT NULL,
    author varchar(80) NOT NULL,
    submitter integer NOT NULL,
    validated tinyint(1) NOT NULL,
    edit_date integer unsigned NULL,
    news_category integer NOT NULL,
    news_views integer NOT NULL,
    news_image varchar(255) BINARY NOT NULL,
    title__text_parsed longtext NOT NULL,
    title__source_user integer DEFAULT 1 NOT NULL,
    news__text_parsed longtext NOT NULL,
    news__source_user integer DEFAULT 1 NOT NULL,
    news_article__text_parsed longtext NOT NULL,
    news_article__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_news ADD FULLTEXT news (news);

ALTER TABLE cms11_news ADD FULLTEXT news_article (news_article);

ALTER TABLE cms11_news ADD FULLTEXT news_search__combined (title,news,news_article);

ALTER TABLE cms11_news ADD FULLTEXT title (title);

ALTER TABLE cms11_news ADD INDEX findnewscat (news_category);

ALTER TABLE cms11_news ADD INDEX ftjoin_ititle (title(250));

ALTER TABLE cms11_news ADD INDEX ftjoin_nnews (news(250));

ALTER TABLE cms11_news ADD INDEX ftjoin_nnewsa (news_article(250));

ALTER TABLE cms11_news ADD INDEX headlines (date_and_time,id);

ALTER TABLE cms11_news ADD INDEX nes (submitter);

ALTER TABLE cms11_news ADD INDEX newsauthor (author);

ALTER TABLE cms11_news ADD INDEX news_views (news_views);

ALTER TABLE cms11_news ADD INDEX nvalidated (validated);

DROP TABLE IF EXISTS cms_news_categories;

CREATE TABLE cms_news_categories (
    id integer unsigned auto_increment NOT NULL,
    nc_title longtext NOT NULL,
    nc_owner integer NULL,
    nc_img varchar(255) NOT NULL,
    notes longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (1, 'General', NULL, 'icons/news/general', '');
INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (2, 'Technology', NULL, 'icons/news/technology', '');
INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (3, 'Difficulties', NULL, 'icons/news/difficulties', '');
INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (4, 'Community', NULL, 'icons/news/community', '');
INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (5, 'Entertainment', NULL, 'icons/news/entertainment', '');
INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (6, 'Business', NULL, 'icons/news/business', '');
INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (7, 'Art', NULL, 'icons/news/art', '');

ALTER TABLE cms11_news_categories ADD FULLTEXT nc_title (nc_title);

ALTER TABLE cms11_news_categories ADD INDEX ncs (nc_owner);

DROP TABLE IF EXISTS cms_news_category_entries;

CREATE TABLE cms_news_category_entries (
    news_entry integer NOT NULL,
    news_entry_category integer NOT NULL,
    PRIMARY KEY (news_entry, news_entry_category)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_news_category_entries ADD INDEX news_entry_category (news_entry_category);

DROP TABLE IF EXISTS cms_news_rss_cloud;

CREATE TABLE cms_news_rss_cloud (
    id integer unsigned auto_increment NOT NULL,
    rem_procedure varchar(80) NOT NULL,
    rem_port integer NOT NULL,
    rem_path varchar(255) NOT NULL,
    rem_protocol varchar(80) NOT NULL,
    rem_ip varchar(40) NOT NULL,
    watching_channel varchar(255) BINARY NOT NULL,
    register_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_newsletter_archive;

CREATE TABLE cms_newsletter_archive (
    id integer unsigned auto_increment NOT NULL,
    date_and_time integer NOT NULL,
    subject varchar(255) NOT NULL,
    newsletter longtext NOT NULL,
    language varchar(80) NOT NULL,
    from_email varchar(255) NOT NULL,
    from_name varchar(255) NOT NULL,
    priority integer NOT NULL,
    template varchar(80) NOT NULL,
    html_only tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_newsletter_drip_send;

CREATE TABLE cms_newsletter_drip_send (
    id integer unsigned auto_increment NOT NULL,
    d_inject_time integer unsigned NOT NULL,
    d_message_id integer NOT NULL,
    d_message_binding longtext NOT NULL,
    d_to_email varchar(255) NOT NULL,
    d_to_name varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_newsletter_periodic;

CREATE TABLE cms_newsletter_periodic (
    id integer unsigned auto_increment NOT NULL,
    np_message longtext NOT NULL,
    np_subject longtext NOT NULL,
    np_lang varchar(5) NOT NULL,
    np_send_details longtext NOT NULL,
    np_html_only tinyint(1) NOT NULL,
    np_from_email varchar(255) NOT NULL,
    np_from_name varchar(255) NOT NULL,
    np_priority tinyint NOT NULL,
    np_csv_data longtext NOT NULL,
    np_frequency varchar(255) NOT NULL,
    np_day tinyint NOT NULL,
    np_in_full tinyint(1) NOT NULL,
    np_template varchar(80) NOT NULL,
    np_last_sent integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_newsletter_subscribe;

CREATE TABLE cms_newsletter_subscribe (
    newsletter_id integer NOT NULL,
    email varchar(255) NOT NULL,
    PRIMARY KEY (newsletter_id, email)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_newsletter_subscribers;

CREATE TABLE cms_newsletter_subscribers (
    id integer unsigned auto_increment NOT NULL,
    email varchar(255) NOT NULL,
    join_time integer unsigned NOT NULL,
    code_confirm integer NOT NULL,
    the_password varchar(255) NOT NULL,
    pass_salt varchar(80) NOT NULL,
    language varchar(80) NOT NULL,
    n_forename varchar(255) NOT NULL,
    n_surname varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_newsletter_subscribers ADD INDEX code_confirm (code_confirm);

ALTER TABLE cms11_newsletter_subscribers ADD INDEX email (email(250));

ALTER TABLE cms11_newsletter_subscribers ADD INDEX welcomemails (join_time);

DROP TABLE IF EXISTS cms_newsletters;

CREATE TABLE cms_newsletters (
    id integer unsigned auto_increment NOT NULL,
    title longtext NOT NULL,
    description longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_newsletters (id, title, description) VALUES (1, 'General', 'General messages will be sent out in this newsletter.');

ALTER TABLE cms11_newsletters ADD FULLTEXT description (description);

ALTER TABLE cms11_newsletters ADD FULLTEXT title (title);

DROP TABLE IF EXISTS cms_notification_lockdown;

CREATE TABLE cms_notification_lockdown (
    l_notification_code varchar(80) NOT NULL,
    l_setting integer NOT NULL,
    PRIMARY KEY (l_notification_code)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_notifications_enabled;

CREATE TABLE cms_notifications_enabled (
    id integer unsigned auto_increment NOT NULL,
    l_member_id integer NOT NULL,
    l_notification_code varchar(80) NOT NULL,
    l_code_category varchar(255) NOT NULL,
    l_setting integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_notifications_enabled ADD INDEX l_code_category (l_code_category(250));

ALTER TABLE cms11_notifications_enabled ADD INDEX l_member_id (l_member_id,l_notification_code);

ALTER TABLE cms11_notifications_enabled ADD INDEX l_notification_code (l_notification_code);

ALTER TABLE cms11_notifications_enabled ADD INDEX who_has (l_notification_code,l_code_category(10),l_setting);

DROP TABLE IF EXISTS cms_poll;

CREATE TABLE cms_poll (
    id integer unsigned auto_increment NOT NULL,
    question longtext NOT NULL,
    option1 longtext NOT NULL,
    option2 longtext NOT NULL,
    option3 longtext NOT NULL,
    option4 longtext NOT NULL,
    option5 longtext NOT NULL,
    option6 longtext NOT NULL,
    option7 longtext NOT NULL,
    option8 longtext NOT NULL,
    option9 longtext NOT NULL,
    option10 longtext NOT NULL,
    votes1 integer NOT NULL,
    votes2 integer NOT NULL,
    votes3 integer NOT NULL,
    votes4 integer NOT NULL,
    votes5 integer NOT NULL,
    votes6 integer NOT NULL,
    votes7 integer NOT NULL,
    votes8 integer NOT NULL,
    votes9 integer NOT NULL,
    votes10 integer NOT NULL,
    allow_rating tinyint(1) NOT NULL,
    allow_comments tinyint NOT NULL,
    allow_trackbacks tinyint(1) NOT NULL,
    notes longtext NOT NULL,
    num_options tinyint NOT NULL,
    is_current tinyint(1) NOT NULL,
    date_and_time integer unsigned NULL,
    submitter integer NOT NULL,
    add_time integer NOT NULL,
    poll_views integer NOT NULL,
    edit_date integer unsigned NULL,
    question__text_parsed longtext NOT NULL,
    question__source_user integer DEFAULT 1 NOT NULL,
    option1__text_parsed longtext NOT NULL,
    option1__source_user integer DEFAULT 1 NOT NULL,
    option2__text_parsed longtext NOT NULL,
    option2__source_user integer DEFAULT 1 NOT NULL,
    option3__text_parsed longtext NOT NULL,
    option3__source_user integer DEFAULT 1 NOT NULL,
    option4__text_parsed longtext NOT NULL,
    option4__source_user integer DEFAULT 1 NOT NULL,
    option5__text_parsed longtext NOT NULL,
    option5__source_user integer DEFAULT 1 NOT NULL,
    option6__text_parsed longtext NOT NULL,
    option6__source_user integer DEFAULT 1 NOT NULL,
    option7__text_parsed longtext NOT NULL,
    option7__source_user integer DEFAULT 1 NOT NULL,
    option8__text_parsed longtext NOT NULL,
    option8__source_user integer DEFAULT 1 NOT NULL,
    option9__text_parsed longtext NOT NULL,
    option9__source_user integer DEFAULT 1 NOT NULL,
    option10__text_parsed longtext NOT NULL,
    option10__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_poll ADD FULLTEXT option1 (option1);

ALTER TABLE cms11_poll ADD FULLTEXT option10 (option10);

ALTER TABLE cms11_poll ADD FULLTEXT option2 (option2);

ALTER TABLE cms11_poll ADD FULLTEXT option3 (option3);

ALTER TABLE cms11_poll ADD FULLTEXT option4 (option4);

ALTER TABLE cms11_poll ADD FULLTEXT option5 (option5);

ALTER TABLE cms11_poll ADD FULLTEXT option6 (option6);

ALTER TABLE cms11_poll ADD FULLTEXT option7 (option7);

ALTER TABLE cms11_poll ADD FULLTEXT option8 (option8);

ALTER TABLE cms11_poll ADD FULLTEXT option9 (option9);

ALTER TABLE cms11_poll ADD FULLTEXT poll_search__combined (question,option1,option2,option3,option4,option5);

ALTER TABLE cms11_poll ADD FULLTEXT question (question);

ALTER TABLE cms11_poll ADD INDEX date_and_time (date_and_time);

ALTER TABLE cms11_poll ADD INDEX ftjoin_po1 (option1(250));

ALTER TABLE cms11_poll ADD INDEX ftjoin_po2 (option2(250));

ALTER TABLE cms11_poll ADD INDEX ftjoin_po3 (option3(250));

ALTER TABLE cms11_poll ADD INDEX ftjoin_po4 (option4(250));

ALTER TABLE cms11_poll ADD INDEX ftjoin_po5 (option5(250));

ALTER TABLE cms11_poll ADD INDEX ftjoin_pq (question(250));

ALTER TABLE cms11_poll ADD INDEX get_current (is_current);

ALTER TABLE cms11_poll ADD INDEX padd_time (add_time);

ALTER TABLE cms11_poll ADD INDEX poll_views (poll_views);

ALTER TABLE cms11_poll ADD INDEX ps (submitter);

DROP TABLE IF EXISTS cms_poll_votes;

CREATE TABLE cms_poll_votes (
    id integer unsigned auto_increment NOT NULL,
    v_poll_id integer NOT NULL,
    v_voter_id integer NULL,
    v_voter_ip varchar(40) NOT NULL,
    v_vote_for tinyint NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_poll_votes ADD INDEX v_voter_id (v_voter_id);

ALTER TABLE cms11_poll_votes ADD INDEX v_voter_ip (v_voter_ip);

ALTER TABLE cms11_poll_votes ADD INDEX v_vote_for (v_vote_for);

DROP TABLE IF EXISTS cms_post_tokens;

CREATE TABLE cms_post_tokens (
    token varchar(80) NOT NULL,
    generation_time integer unsigned NOT NULL,
    member_id integer NOT NULL,
    session_id varchar(80) NOT NULL,
    ip_address varchar(40) NOT NULL,
    usage_tally integer NOT NULL,
    PRIMARY KEY (token)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_post_tokens ADD INDEX generation_time (generation_time);

DROP TABLE IF EXISTS cms_privilege_list;

CREATE TABLE cms_privilege_list (
    p_section varchar(80) NOT NULL,
    the_name varchar(80) NOT NULL,
    the_default tinyint(1) NOT NULL,
    PRIMARY KEY (the_name, the_default)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'see_unvalidated', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'see_software_docs', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'sees_javascript_error_alerts', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'open_virtual_roots', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'draw_to_server', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'exceed_filesize_limit', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'mass_delete_from_ip', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'scheduled_publication_times', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'mass_import', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_cat_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_cat_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_cat_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'search_engine_links', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'can_submit_to_others_categories', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_own_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_lowrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_validation_midrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_validation_highrange_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'use_very_dangerous_comcode', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'feature', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'access_overrun_site', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'view_profiling_modes', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'see_stack_trace', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'bypass_bandwidth_restriction', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'access_closed_site', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'comcode_nuisance', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'comcode_dangerous', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'allow_html', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'run_multi_moderations', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_pt', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'edit_private_topic_posts', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_unblind_own_poll', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_member_photos', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_quick_reply', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_profiles', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'own_avatars', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'double_post', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'delete_account', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'rename_self', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_special_emoticons', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_any_profile_field', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'disable_lost_passwords', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'close_own_topics', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'edit_own_polls', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'see_warnings', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'see_ip', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_choose_custom_title', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_other_pt', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'view_poll_results_before_voting', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'moderate_private_topic', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'member_maintenance', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'probate_members', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'warn_members', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'control_usergroups', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'multi_delete_topics', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'show_user_browsing', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'see_hidden_groups', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'pt_anyone', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'delete_private_topic_posts', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'exceed_post_edit_time_limit', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'exceed_post_delete_time_limit', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_required_cpfs', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_required_cpfs_if_already_empty', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_email_address', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_email_address_if_already_empty', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_dob', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'bypass_dob_if_already_empty', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_meta_fields', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'perform_webstandards_check_by_default', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'view_private_content', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'may_enable_staff_notifications', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'bypass_flood_control', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'remove_page_split', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'bypass_wordfilter', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'perform_keyword_check', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'have_personal_category', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'assume_any_member', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'edit_own_lowrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_highrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_midrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'submit_lowrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_validation_lowrange_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_FEEDBACK', 'rate', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_FEEDBACK', 'comment', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('VOTE', 'vote_in_polls', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'jump_to_unvalidated', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'reuse_others_attachments', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'see_php_errors', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'unfiltered_input', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'see_query_errors', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'bypass_spam_heuristics', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'set_content_review_settings', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'view_revisions', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'undo_revisions', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_revisions', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'use_sms', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'sms_higher_limit', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'sms_higher_trigger_limit', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'upload_anything_filedump', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'upload_filedump', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'delete_anything_filedump', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'set_own_author_profile', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('BANNERS', 'full_banner_setup', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('BANNERS', 'view_anyones_banner_stats', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('BANNERS', 'banner_free', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('BANNERS', 'use_html_banner', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('BANNERS', 'use_php_banner', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('CALENDAR', 'view_calendar', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('CALENDAR', 'add_public_events', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('CALENDAR', 'sense_personal_conflicts', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('CALENDAR', 'view_event_subscriptions', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('CALENDAR', 'calendar_add_to_others', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_event', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_event', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('CATALOGUES', 'high_catalogue_entry_timeout', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_catalogue_category', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_catalogue_category', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SECTION_CHAT', 'create_private_room', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SECTION_CHAT', 'start_im', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SECTION_CHAT', 'moderate_my_private_rooms', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SECTION_CHAT', 'ban_chatters_from_rooms', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_SECTION_DOWNLOADS', 'download', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_download_category', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_download_category', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_download', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_download', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GALLERIES', 'may_download_gallery', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GALLERIES', 'high_personal_gallery_limit', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GALLERIES', 'no_personal_gallery_limit', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_gallery', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_gallery', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_image', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_image', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_videos', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_videos', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_news', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_news', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('NEWSLETTER', 'change_newsletter_subscriptions', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POINTS', 'use_points', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POINTS', 'trace_anonymous_gifts', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POINTS', 'give_points_self', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POINTS', 'have_negative_gift_points', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POINTS', 'give_negative_points', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POINTS', 'view_charge_log', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('POLLS', 'choose_poll', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_poll', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_poll', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('ECOMMERCE', 'access_ecommerce_in_test_mode', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('QUIZZES', 'bypass_quiz_repeat_time_restriction', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('QUIZZES', 'view_others_quiz_results', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('QUIZZES', 'bypass_quiz_timer', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_quiz', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_quiz', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'may_report_content', 1);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_past_search', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_comcode_page', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_comcode_page', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUPPORT_TICKETS', 'view_others_tickets', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUPPORT_TICKETS', 'support_operator', 0);
INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('WIKI', 'wiki_manage_tree', 0);

DROP TABLE IF EXISTS cms_quiz_entries;

CREATE TABLE cms_quiz_entries (
    id integer unsigned auto_increment NOT NULL,
    q_time integer unsigned NOT NULL,
    q_member integer NOT NULL,
    q_quiz integer NOT NULL,
    q_results integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_quiz_entries ADD INDEX q_member (q_member);

DROP TABLE IF EXISTS cms_quiz_entry_answer;

CREATE TABLE cms_quiz_entry_answer (
    id integer unsigned auto_increment NOT NULL,
    q_entry integer NOT NULL,
    q_question integer NOT NULL,
    q_answer longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_quiz_member_last_visit;

CREATE TABLE cms_quiz_member_last_visit (
    id integer unsigned auto_increment NOT NULL,
    v_time integer unsigned NOT NULL,
    v_member_id integer NOT NULL,
    v_quiz_id integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_quiz_member_last_visit ADD INDEX member_id (v_member_id);

DROP TABLE IF EXISTS cms_quiz_question_answers;

CREATE TABLE cms_quiz_question_answers (
    id integer unsigned auto_increment NOT NULL,
    q_question integer NOT NULL,
    q_answer_text longtext NOT NULL,
    q_is_correct tinyint(1) NOT NULL,
    q_order integer NOT NULL,
    q_explanation longtext NOT NULL,
    q_answer_text__text_parsed longtext NOT NULL,
    q_answer_text__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_quiz_question_answers ADD FULLTEXT q_answer_text (q_answer_text);

ALTER TABLE cms11_quiz_question_answers ADD FULLTEXT q_explanation (q_explanation);

DROP TABLE IF EXISTS cms_quiz_questions;

CREATE TABLE cms_quiz_questions (
    id integer unsigned auto_increment NOT NULL,
    q_type varchar(80) NOT NULL,
    q_quiz integer NOT NULL,
    q_question_text longtext NOT NULL,
    q_question_extra_text longtext NOT NULL,
    q_order integer NOT NULL,
    q_required tinyint(1) NOT NULL,
    q_marked tinyint(1) NOT NULL,
    q_question_text__text_parsed longtext NOT NULL,
    q_question_text__source_user integer DEFAULT 1 NOT NULL,
    q_question_extra_text__text_parsed longtext NOT NULL,
    q_question_extra_text__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_quiz_questions ADD FULLTEXT q_question_extra_text (q_question_extra_text);

ALTER TABLE cms11_quiz_questions ADD FULLTEXT q_question_text (q_question_text);

DROP TABLE IF EXISTS cms_quiz_winner;

CREATE TABLE cms_quiz_winner (
    q_quiz integer NOT NULL,
    q_entry integer NOT NULL,
    q_winner_level integer NOT NULL,
    PRIMARY KEY (q_quiz, q_entry)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_quizzes;

CREATE TABLE cms_quizzes (
    id integer unsigned auto_increment NOT NULL,
    q_timeout integer NULL,
    q_name longtext NOT NULL,
    q_start_text longtext NOT NULL,
    q_end_text longtext NOT NULL,
    q_notes longtext NOT NULL,
    q_percentage integer NOT NULL,
    q_open_time integer unsigned NOT NULL,
    q_close_time integer unsigned NULL,
    q_num_winners integer NOT NULL,
    q_redo_time integer NULL,
    q_type varchar(80) NOT NULL,
    q_add_date integer unsigned NOT NULL,
    q_validated tinyint(1) NOT NULL,
    q_submitter integer NOT NULL,
    q_points_for_passing integer NOT NULL,
    q_tied_newsletter integer NULL,
    q_end_text_fail longtext NOT NULL,
    q_reveal_answers tinyint(1) NOT NULL,
    q_shuffle_questions tinyint(1) NOT NULL,
    q_shuffle_answers tinyint(1) NOT NULL,
    q_start_text__text_parsed longtext NOT NULL,
    q_start_text__source_user integer DEFAULT 1 NOT NULL,
    q_end_text__text_parsed longtext NOT NULL,
    q_end_text__source_user integer DEFAULT 1 NOT NULL,
    q_end_text_fail__text_parsed longtext NOT NULL,
    q_end_text_fail__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_quizzes ADD FULLTEXT quiz_search__combined (q_start_text,q_name);

ALTER TABLE cms11_quizzes ADD FULLTEXT q_end_text (q_end_text);

ALTER TABLE cms11_quizzes ADD FULLTEXT q_end_text_fail (q_end_text_fail);

ALTER TABLE cms11_quizzes ADD FULLTEXT q_name (q_name);

ALTER TABLE cms11_quizzes ADD FULLTEXT q_start_text (q_start_text);

ALTER TABLE cms11_quizzes ADD INDEX ftjoin_qstarttext (q_start_text(250));

ALTER TABLE cms11_quizzes ADD INDEX q_validated (q_validated);

DROP TABLE IF EXISTS cms_rating;

CREATE TABLE cms_rating (
    id integer unsigned auto_increment NOT NULL,
    rating_for_type varchar(80) NOT NULL,
    rating_for_id varchar(80) NOT NULL,
    rating_member integer NOT NULL,
    rating_ip varchar(40) NOT NULL,
    rating_time integer unsigned NOT NULL,
    rating tinyint NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_rating ADD INDEX alt_key (rating_for_type,rating_for_id);

ALTER TABLE cms11_rating ADD INDEX rating_for_id (rating_for_id);

ALTER TABLE cms11_rating ADD INDEX rating_member (rating_member);

DROP TABLE IF EXISTS cms_redirects;

CREATE TABLE cms_redirects (
    r_from_page varchar(80) NOT NULL,
    r_from_zone varchar(80) NOT NULL,
    r_to_page varchar(80) NOT NULL,
    r_to_zone varchar(80) NOT NULL,
    r_is_transparent tinyint(1) NOT NULL,
    PRIMARY KEY (r_from_page, r_from_zone)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('rules', 'site', 'rules', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('rules', 'forum', 'rules', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'docs', 'panel_top', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'forum', 'panel_top', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'site', 'panel_top', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'docs', 'panel_bottom', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'forum', 'panel_bottom', '', 1);
INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'site', 'panel_bottom', '', 1);

DROP TABLE IF EXISTS cms_reported_content;

CREATE TABLE cms_reported_content (
    r_session_id varchar(80) NOT NULL,
    r_content_type varchar(80) NOT NULL,
    r_content_id varchar(80) NOT NULL,
    r_counts tinyint(1) NOT NULL,
    PRIMARY KEY (r_session_id, r_content_type, r_content_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_reported_content ADD INDEX reported_already (r_content_type,r_content_id);

DROP TABLE IF EXISTS cms_review_supplement;

CREATE TABLE cms_review_supplement (
    r_post_id integer NOT NULL,
    r_rating_type varchar(80) NOT NULL,
    r_rating tinyint NOT NULL,
    r_topic_id integer NOT NULL,
    r_rating_for_id varchar(80) NOT NULL,
    r_rating_for_type varchar(80) NOT NULL,
    PRIMARY KEY (r_post_id, r_rating_type)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_review_supplement ADD INDEX rating_for_id (r_rating_for_id);

DROP TABLE IF EXISTS cms_revisions;

CREATE TABLE cms_revisions (
    id integer unsigned auto_increment NOT NULL,
    r_resource_type varchar(80) NOT NULL,
    r_resource_id varchar(80) NOT NULL,
    r_category_id varchar(80) NOT NULL,
    r_original_title varchar(255) NOT NULL,
    r_original_text longtext NOT NULL,
    r_original_content_owner integer NOT NULL,
    r_original_content_timestamp integer unsigned NOT NULL,
    r_original_resource_fs_path longtext NOT NULL,
    r_original_resource_fs_record longtext NOT NULL,
    r_actionlog_id integer NULL,
    r_moderatorlog_id integer NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_revisions ADD INDEX actionlog_link (r_actionlog_id);

ALTER TABLE cms11_revisions ADD INDEX lookup_by_cat (r_resource_type,r_category_id);

ALTER TABLE cms11_revisions ADD INDEX lookup_by_id (r_resource_type,r_resource_id);

ALTER TABLE cms11_revisions ADD INDEX moderatorlog_link (r_moderatorlog_id);

DROP TABLE IF EXISTS cms_searches_logged;

CREATE TABLE cms_searches_logged (
    id integer unsigned auto_increment NOT NULL,
    s_member_id integer NOT NULL,
    s_time integer unsigned NOT NULL,
    s_primary varchar(255) NOT NULL,
    s_auxillary longtext NOT NULL,
    s_num_results integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_searches_logged ADD FULLTEXT past_search_ft (s_primary);

ALTER TABLE cms11_searches_logged ADD INDEX member_id (s_member_id);

ALTER TABLE cms11_searches_logged ADD INDEX past_search (s_primary(250));

DROP TABLE IF EXISTS cms_seo_meta;

CREATE TABLE cms_seo_meta (
    id integer unsigned auto_increment NOT NULL,
    meta_for_type varchar(80) NOT NULL,
    meta_for_id varchar(80) NOT NULL,
    meta_description longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_seo_meta (id, meta_for_type, meta_for_id, meta_description) VALUES (1, 'gallery', 'root', '');

ALTER TABLE cms11_seo_meta ADD FULLTEXT meta_description (meta_description);

ALTER TABLE cms11_seo_meta ADD INDEX alt_key (meta_for_type,meta_for_id);

ALTER TABLE cms11_seo_meta ADD INDEX ftjoin_dmeta_description (meta_description(250));

DROP TABLE IF EXISTS cms_seo_meta_keywords;

CREATE TABLE cms_seo_meta_keywords (
    id integer unsigned auto_increment NOT NULL,
    meta_for_type varchar(80) NOT NULL,
    meta_for_id varchar(80) NOT NULL,
    meta_keyword longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_seo_meta_keywords ADD FULLTEXT meta_keyword (meta_keyword);

ALTER TABLE cms11_seo_meta_keywords ADD INDEX ftjoin_dmeta_keywords (meta_keyword(250));

ALTER TABLE cms11_seo_meta_keywords ADD INDEX keywords_alt_key (meta_for_type,meta_for_id);

DROP TABLE IF EXISTS cms_sessions;

CREATE TABLE cms_sessions (
    the_session varchar(80) NOT NULL,
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
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_sessions ADD INDEX delete_old (last_activity);

ALTER TABLE cms11_sessions ADD INDEX member_id (member_id);

ALTER TABLE cms11_sessions ADD INDEX userat (the_zone,the_page,the_id);

DROP TABLE IF EXISTS cms_shopping_cart;

CREATE TABLE cms_shopping_cart (
    id integer unsigned auto_increment NOT NULL,
    session_id varchar(80) NOT NULL,
    ordered_by integer NOT NULL,
    type_code varchar(80) NOT NULL,
    purchase_id varchar(80) NOT NULL,
    quantity integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_shopping_cart ADD INDEX ordered_by (ordered_by);

ALTER TABLE cms11_shopping_cart ADD INDEX session_id (session_id);

ALTER TABLE cms11_shopping_cart ADD INDEX type_code (type_code);

DROP TABLE IF EXISTS cms_shopping_logging;

CREATE TABLE cms_shopping_logging (
    id integer unsigned auto_increment NOT NULL,
    l_member_id integer NOT NULL,
    l_session_id varchar(80) NOT NULL,
    l_ip varchar(40) NOT NULL,
    l_last_action varchar(255) NOT NULL,
    l_date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (id, l_member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_shopping_logging ADD INDEX cart_log (l_date_and_time);

DROP TABLE IF EXISTS cms_shopping_order_details;

CREATE TABLE cms_shopping_order_details (
    id integer unsigned auto_increment NOT NULL,
    p_order_id integer NULL,
    p_type_code varchar(80) NOT NULL,
    p_purchase_id varchar(80) NOT NULL,
    p_name varchar(255) NOT NULL,
    p_sku varchar(255) NOT NULL,
    p_quantity integer NOT NULL,
    p_price real NOT NULL,
    p_tax_code varchar(80) NOT NULL,
    p_tax real NOT NULL,
    p_dispatch_status varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_shopping_order_details ADD INDEX order_id (p_order_id);

ALTER TABLE cms11_shopping_order_details ADD INDEX type_code (p_type_code);

DROP TABLE IF EXISTS cms_shopping_orders;

CREATE TABLE cms_shopping_orders (
    id integer unsigned auto_increment NOT NULL,
    session_id varchar(80) NOT NULL,
    member_id integer NOT NULL,
    add_date integer unsigned NOT NULL,
    total_price real NOT NULL,
    total_tax_derivation longtext NOT NULL,
    total_tax real NOT NULL,
    total_tax_tracking longtext NOT NULL,
    total_shipping_cost real NOT NULL,
    total_shipping_tax real NOT NULL,
    total_product_weight real NOT NULL,
    total_product_length real NOT NULL,
    total_product_width real NOT NULL,
    total_product_height real NOT NULL,
    order_currency varchar(80) NOT NULL,
    order_status varchar(80) NOT NULL,
    notes longtext NOT NULL,
    txn_id varchar(255) NOT NULL,
    purchase_through varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_shopping_orders ADD INDEX finddispatchable (order_status);

ALTER TABLE cms11_shopping_orders ADD INDEX soadd_date (add_date);

ALTER TABLE cms11_shopping_orders ADD INDEX somember_id (member_id);

ALTER TABLE cms11_shopping_orders ADD INDEX sosession_id (session_id);

DROP TABLE IF EXISTS cms_sitemap_cache;

CREATE TABLE cms_sitemap_cache (
    page_link varchar(255) NOT NULL,
    set_number integer NOT NULL,
    add_date integer unsigned NULL,
    edit_date integer unsigned NULL,
    last_updated integer unsigned NOT NULL,
    is_deleted tinyint(1) NOT NULL,
    priority real NOT NULL,
    refreshfreq varchar(80) NOT NULL,
    guest_access tinyint(1) NOT NULL,
    PRIMARY KEY (page_link)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_sitemap_cache ADD INDEX is_deleted (is_deleted);

ALTER TABLE cms11_sitemap_cache ADD INDEX last_updated (last_updated);

ALTER TABLE cms11_sitemap_cache ADD INDEX set_number (set_number,last_updated);

DROP TABLE IF EXISTS cms_sms_log;

CREATE TABLE cms_sms_log (
    id integer unsigned auto_increment NOT NULL,
    s_member_id integer NOT NULL,
    s_time integer unsigned NOT NULL,
    s_trigger_ip varchar(40) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_sms_log ADD INDEX sms_log_for (s_member_id,s_time);

ALTER TABLE cms11_sms_log ADD INDEX sms_trigger_ip (s_trigger_ip);

DROP TABLE IF EXISTS cms_staff_checklist_cus_tasks;

CREATE TABLE cms_staff_checklist_cus_tasks (
    id integer unsigned auto_increment NOT NULL,
    task_title longtext NOT NULL,
    add_date integer unsigned NOT NULL,
    recur_interval integer NOT NULL,
    recur_every varchar(80) NOT NULL,
    task_is_done integer unsigned NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (1, 'Add your content', 1533138593, 0, '', NULL);
INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (2, '[page=\"adminzone:admin_health_check\"]Run/schedule Health Checks[/page]', 1533138593, 0, '', NULL);
INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (3, '[url=\"Set up up-time monitor\"]https://uptimerobot.com/[/url]', 1533138593, 0, '', NULL);
INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (4, '[html]<p style=\"margin: 0\">Facebook user? Like Composr on Facebook:</p><iframe src=\"https://compo.sr/uploads/website_specific/compo.sr/facebook.html\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:330px; height:20px;\" allowTransparency=\"true\"></iframe>[/html]', 1533138593, 0, '', NULL);
INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (5, '[page=\"adminzone:admin_version\"]Consider helping out with the Composr project[/page]', 1533138593, 0, '', NULL);

DROP TABLE IF EXISTS cms_staff_links;

CREATE TABLE cms_staff_links (
    id integer unsigned auto_increment NOT NULL,
    link varchar(255) BINARY NOT NULL,
    link_title varchar(255) NOT NULL,
    link_desc longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (1, 'https://compo.sr/', 'compo.sr', 'compo.sr');
INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (2, 'http://compo.sr/forum/vforums.htm', 'compo.sr (topics with unread posts)', 'compo.sr (topics with unread posts)');

DROP TABLE IF EXISTS cms_staff_tips_dismissed;

CREATE TABLE cms_staff_tips_dismissed (
    t_member integer NOT NULL,
    t_tip varchar(80) NOT NULL,
    PRIMARY KEY (t_member, t_tip)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_staff_website_monitoring;

CREATE TABLE cms_staff_website_monitoring (
    id integer unsigned auto_increment NOT NULL,
    site_url varchar(255) BINARY NOT NULL,
    site_name varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_staff_website_monitoring (id, site_url, site_name) VALUES (1, 'http://localhost/composr', '');

DROP TABLE IF EXISTS cms_stats;

CREATE TABLE cms_stats (
    id integer unsigned auto_increment NOT NULL,
    the_page varchar(255) NOT NULL,
    ip varchar(40) NOT NULL,
    member_id integer NOT NULL,
    session_id varchar(80) NOT NULL,
    date_and_time integer unsigned NOT NULL,
    referer varchar(255) BINARY NOT NULL,
    s_get varchar(255) BINARY NOT NULL,
    post longtext NOT NULL,
    browser varchar(255) NOT NULL,
    milliseconds integer NOT NULL,
    operating_system varchar(255) NOT NULL,
    access_denied_counter integer NOT NULL,
    title varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_stats ADD INDEX browser (browser(250));

ALTER TABLE cms11_stats ADD INDEX date_and_time (date_and_time);

ALTER TABLE cms11_stats ADD INDEX member_track_1 (member_id);

ALTER TABLE cms11_stats ADD INDEX member_track_2 (ip);

ALTER TABLE cms11_stats ADD INDEX member_track_3 (member_id,date_and_time);

ALTER TABLE cms11_stats ADD INDEX member_track_4 (session_id);

ALTER TABLE cms11_stats ADD INDEX milliseconds (milliseconds);

ALTER TABLE cms11_stats ADD INDEX operating_system (operating_system(250));

ALTER TABLE cms11_stats ADD INDEX pages (the_page(250));

ALTER TABLE cms11_stats ADD INDEX referer (referer(250));

DROP TABLE IF EXISTS cms_task_queue;

CREATE TABLE cms_task_queue (
    id integer unsigned auto_increment NOT NULL,
    t_title varchar(255) NOT NULL,
    t_hook varchar(80) NOT NULL,
    t_args longtext NOT NULL,
    t_member_id integer NOT NULL,
    t_secure_ref varchar(80) NOT NULL,
    t_send_notification tinyint(1) NOT NULL,
    t_locked tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_temp_block_permissions;

CREATE TABLE cms_temp_block_permissions (
    id integer unsigned auto_increment NOT NULL,
    p_session_id varchar(80) NOT NULL,
    p_block_constraints longtext NOT NULL,
    p_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_theme_images;

CREATE TABLE cms_theme_images (
    id varchar(255) NOT NULL,
    theme varchar(40) NOT NULL,
    path varchar(255) BINARY NOT NULL,
    lang varchar(5) NOT NULL,
    PRIMARY KEY (id, theme, lang)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_theme_images ADD INDEX theme (theme,lang);

DROP TABLE IF EXISTS cms_theme_screen_tree;

CREATE TABLE cms_theme_screen_tree (
    id integer unsigned auto_increment NOT NULL,
    page_link varchar(255) NOT NULL,
    json_tree longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_theme_screen_tree ADD INDEX page_link (page_link(250));

DROP TABLE IF EXISTS cms_theme_template_relations;

CREATE TABLE cms_theme_template_relations (
    rel_a varchar(80) NOT NULL,
    rel_b varchar(80) NOT NULL,
    PRIMARY KEY (rel_a, rel_b)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_ticket_extra_access;

CREATE TABLE cms_ticket_extra_access (
    ticket_id varchar(255) NOT NULL,
    member_id integer NOT NULL,
    PRIMARY KEY (ticket_id, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_ticket_known_emailers;

CREATE TABLE cms_ticket_known_emailers (
    email_address varchar(255) NOT NULL,
    member_id integer NOT NULL,
    PRIMARY KEY (email_address)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_ticket_known_emailers ADD INDEX member_id (member_id);

DROP TABLE IF EXISTS cms_ticket_types;

CREATE TABLE cms_ticket_types (
    id integer unsigned auto_increment NOT NULL,
    ticket_type_name longtext NOT NULL,
    guest_emails_mandatory tinyint(1) NOT NULL,
    search_faq tinyint(1) NOT NULL,
    cache_lead_time integer unsigned NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_ticket_types (id, ticket_type_name, guest_emails_mandatory, search_faq, cache_lead_time) VALUES (1, 'Other', 0, 0, NULL);
INSERT INTO cms_ticket_types (id, ticket_type_name, guest_emails_mandatory, search_faq, cache_lead_time) VALUES (2, 'Complaint', 0, 0, NULL);
INSERT INTO cms_ticket_types (id, ticket_type_name, guest_emails_mandatory, search_faq, cache_lead_time) VALUES (3, 'Reported content', 0, 0, NULL);

ALTER TABLE cms11_ticket_types ADD FULLTEXT ticket_type_name (ticket_type_name);

DROP TABLE IF EXISTS cms_tickets;

CREATE TABLE cms_tickets (
    ticket_id varchar(255) NOT NULL,
    topic_id integer NOT NULL,
    forum_id integer NOT NULL,
    ticket_type integer NOT NULL,
    PRIMARY KEY (ticket_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_trackbacks;

CREATE TABLE cms_trackbacks (
    id integer unsigned auto_increment NOT NULL,
    trackback_for_type varchar(80) NOT NULL,
    trackback_for_id varchar(80) NOT NULL,
    trackback_ip varchar(40) NOT NULL,
    trackback_time integer unsigned NOT NULL,
    trackback_url varchar(255) NOT NULL,
    trackback_title varchar(255) NOT NULL,
    trackback_excerpt longtext NOT NULL,
    trackback_name varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_trackbacks ADD INDEX trackback_for_id (trackback_for_id);

ALTER TABLE cms11_trackbacks ADD INDEX trackback_for_type (trackback_for_type);

ALTER TABLE cms11_trackbacks ADD INDEX trackback_time (trackback_time);

DROP TABLE IF EXISTS cms_translate;

CREATE TABLE cms_translate (
    id integer unsigned auto_increment NOT NULL,
    language varchar(5) NOT NULL,
    importance_level tinyint NOT NULL,
    text_original longtext NOT NULL,
    text_parsed longtext NOT NULL,
    broken tinyint(1) NOT NULL,
    source_user integer NOT NULL,
    PRIMARY KEY (id, language)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_translate ADD FULLTEXT tsearch (text_original);

ALTER TABLE cms11_translate ADD INDEX decache (text_parsed(2));

ALTER TABLE cms11_translate ADD INDEX equiv_lang (text_original(4));

ALTER TABLE cms11_translate ADD INDEX importance_level (importance_level);

DROP TABLE IF EXISTS cms_translation_cache;

CREATE TABLE cms_translation_cache (
    id integer unsigned auto_increment NOT NULL,
    t_lang_from varchar(5) NOT NULL,
    t_lang_to varchar(5) NOT NULL,
    t_text longtext NOT NULL,
    t_context integer NOT NULL,
    t_text_result longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_translation_cache ADD INDEX lookup (t_lang_from,t_lang_to,t_text(100),t_context);

DROP TABLE IF EXISTS cms_tutorial_links;

CREATE TABLE cms_tutorial_links (
    the_name varchar(80) NOT NULL,
    the_value longtext NOT NULL,
    PRIMARY KEY (the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_unbannable_ip;

CREATE TABLE cms_unbannable_ip (
    ip varchar(40) NOT NULL,
    note varchar(255) NOT NULL,
    PRIMARY KEY (ip)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_url_id_monikers;

CREATE TABLE cms_url_id_monikers (
    id integer unsigned auto_increment NOT NULL,
    m_resource_page varchar(80) NOT NULL,
    m_resource_type varchar(80) NOT NULL,
    m_resource_id varchar(80) NOT NULL,
    m_moniker varchar(255) NOT NULL,
    m_moniker_reversed varchar(255) NOT NULL,
    m_deprecated tinyint(1) NOT NULL,
    m_manually_chosen tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_url_id_monikers ADD INDEX uim_moniker (m_moniker(250));

ALTER TABLE cms11_url_id_monikers ADD INDEX uim_monrev (m_moniker_reversed(250));

ALTER TABLE cms11_url_id_monikers ADD INDEX uim_page_link (m_resource_page,m_resource_type,m_resource_id);

DROP TABLE IF EXISTS cms_url_title_cache;

CREATE TABLE cms_url_title_cache (
    id integer unsigned auto_increment NOT NULL,
    t_url varchar(255) BINARY NOT NULL,
    t_title varchar(255) NOT NULL,
    t_meta_title longtext NOT NULL,
    t_keywords longtext NOT NULL,
    t_description longtext NOT NULL,
    t_image_url varchar(255) BINARY NOT NULL,
    t_mime_type varchar(80) NOT NULL,
    t_json_discovery varchar(255) BINARY NOT NULL,
    t_xml_discovery varchar(255) BINARY NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_url_title_cache ADD INDEX t_url (t_url(250));

DROP TABLE IF EXISTS cms_urls_checked;

CREATE TABLE cms_urls_checked (
    id integer unsigned auto_increment NOT NULL,
    url longtext NOT NULL,
    url_exists tinyint(1) NOT NULL,
    url_check_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_urls_checked ADD INDEX url (url(200));

DROP TABLE IF EXISTS cms_usersonline_track;

CREATE TABLE cms_usersonline_track (
    date_and_time integer unsigned NOT NULL,
    peak integer NOT NULL,
    PRIMARY KEY (date_and_time)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_usersonline_track ADD INDEX peak_track (peak);

DROP TABLE IF EXISTS cms_usersubmitban_member;

CREATE TABLE cms_usersubmitban_member (
    the_member integer NOT NULL,
    PRIMARY KEY (the_member)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_values;

CREATE TABLE cms_values (
    the_name varchar(80) NOT NULL,
    the_value varchar(255) NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_topic_count', '1', 1533138567);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_member_count', '1', 1533138568);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_post_count', '1', 1533138568);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('version', '11.00', 1533138575);
INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_version', '11.00', 1533138575);

ALTER TABLE cms11_values ADD INDEX date_and_time (date_and_time);

DROP TABLE IF EXISTS cms_values_elective;

CREATE TABLE cms_values_elective (
    the_name varchar(80) NOT NULL,
    the_value longtext NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (the_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_values_elective (the_name, the_value, date_and_time) VALUES ('call_home', '0', 1533138575);

DROP TABLE IF EXISTS cms_video_transcoding;

CREATE TABLE cms_video_transcoding (
    t_id varchar(80) NOT NULL,
    t_local_id integer NULL,
    t_local_id_field varchar(80) NOT NULL,
    t_error longtext NOT NULL,
    t_url varchar(255) BINARY NOT NULL,
    t_table varchar(80) NOT NULL,
    t_url_field varchar(80) NOT NULL,
    t_orig_filename_field varchar(80) NOT NULL,
    t_width_field varchar(80) NOT NULL,
    t_height_field varchar(80) NOT NULL,
    t_output_filename varchar(80) NOT NULL,
    PRIMARY KEY (t_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_video_transcoding ADD INDEX t_local_id (t_local_id);

DROP TABLE IF EXISTS cms_videos;

CREATE TABLE cms_videos (
    id integer unsigned auto_increment NOT NULL,
    cat varchar(80) NOT NULL,
    url varchar(255) BINARY NOT NULL,
    thumb_url varchar(255) BINARY NOT NULL,
    description longtext NOT NULL,
    allow_rating tinyint(1) NOT NULL,
    allow_comments tinyint NOT NULL,
    allow_trackbacks tinyint(1) NOT NULL,
    notes longtext NOT NULL,
    submitter integer NOT NULL,
    validated tinyint(1) NOT NULL,
    add_date integer unsigned NOT NULL,
    edit_date integer unsigned NULL,
    video_views integer NOT NULL,
    video_width integer NOT NULL,
    video_height integer NOT NULL,
    video_length integer NOT NULL,
    title longtext NOT NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_videos ADD FULLTEXT description (description);

ALTER TABLE cms11_videos ADD FULLTEXT title (title);

ALTER TABLE cms11_videos ADD FULLTEXT video_search__combined (description,title);

ALTER TABLE cms11_videos ADD INDEX category_list (cat);

ALTER TABLE cms11_videos ADD INDEX ftjoin_dtitle (title(250));

ALTER TABLE cms11_videos ADD INDEX ftjoin_vdescription (description(250));

ALTER TABLE cms11_videos ADD INDEX vadd_date (add_date);

ALTER TABLE cms11_videos ADD INDEX video_views (video_views);

ALTER TABLE cms11_videos ADD INDEX vs (submitter);

ALTER TABLE cms11_videos ADD INDEX v_validated (validated);

DROP TABLE IF EXISTS cms_webstandards_checked_once;

CREATE TABLE cms_webstandards_checked_once (
    hash varchar(255) NOT NULL,
    PRIMARY KEY (hash)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_wiki_children;

CREATE TABLE cms_wiki_children (
    parent_id integer NOT NULL,
    child_id integer NOT NULL,
    the_order integer NOT NULL,
    title varchar(255) NOT NULL,
    PRIMARY KEY (parent_id, child_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_wiki_pages;

CREATE TABLE cms_wiki_pages (
    id integer unsigned auto_increment NOT NULL,
    title longtext NOT NULL,
    notes longtext NOT NULL,
    description longtext NOT NULL,
    add_date integer unsigned NOT NULL,
    edit_date integer unsigned NULL,
    wiki_views integer NOT NULL,
    show_posts tinyint(1) NOT NULL,
    submitter integer NOT NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_wiki_pages (id, title, notes, description, add_date, edit_date, wiki_views, show_posts, submitter, description__text_parsed, description__source_user) VALUES (1, 'Wiki+ home', '', '', 1533138607, NULL, 0, 1, 2, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5b61d6a7c3bbf8.13480573_24\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;b:0;i:4;a:1:{s:40:\\\"string_attach_5b61d6a7c3bbf8.13480573_24\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5b61d6a7c3bbf8.13480573_24\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");\n', 1);

ALTER TABLE cms11_wiki_pages ADD FULLTEXT description (description);

ALTER TABLE cms11_wiki_pages ADD FULLTEXT title (title);

ALTER TABLE cms11_wiki_pages ADD FULLTEXT wiki_search__combined (title,description);

ALTER TABLE cms11_wiki_pages ADD INDEX ftjoin_spd (description(250));

ALTER TABLE cms11_wiki_pages ADD INDEX ftjoin_spt (title(250));

ALTER TABLE cms11_wiki_pages ADD INDEX sadd_date (add_date);

ALTER TABLE cms11_wiki_pages ADD INDEX sps (submitter);

ALTER TABLE cms11_wiki_pages ADD INDEX wiki_views (wiki_views);

DROP TABLE IF EXISTS cms_wiki_posts;

CREATE TABLE cms_wiki_posts (
    id integer unsigned auto_increment NOT NULL,
    page_id integer NOT NULL,
    the_message longtext NOT NULL,
    date_and_time integer unsigned NOT NULL,
    validated tinyint(1) NOT NULL,
    wiki_views integer NOT NULL,
    member_id integer NOT NULL,
    edit_date integer unsigned NULL,
    the_message__text_parsed longtext NOT NULL,
    the_message__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms11_wiki_posts ADD FULLTEXT the_message (the_message);

ALTER TABLE cms11_wiki_posts ADD INDEX cdate_and_time (date_and_time);

ALTER TABLE cms11_wiki_posts ADD INDEX ftjoin_spm (the_message(250));

ALTER TABLE cms11_wiki_posts ADD INDEX member_id (member_id);

ALTER TABLE cms11_wiki_posts ADD INDEX posts_on_page (page_id);

ALTER TABLE cms11_wiki_posts ADD INDEX spos (member_id);

ALTER TABLE cms11_wiki_posts ADD INDEX svalidated (validated);

ALTER TABLE cms11_wiki_posts ADD INDEX wiki_views (wiki_views);

DROP TABLE IF EXISTS cms_wordfilter;

CREATE TABLE cms_wordfilter (
    id integer unsigned auto_increment NOT NULL,
    word varchar(255) NOT NULL,
    w_replacement varchar(255) NOT NULL,
    w_substr tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (1, 'arsehole', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (2, 'asshole', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (3, 'arse', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (4, 'bastard', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (5, 'cock', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (6, 'cocked', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (7, 'cocksucker', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (8, 'cunt', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (9, 'cum', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (10, 'blowjob', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (11, 'bollocks', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (12, 'bondage', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (13, 'bugger', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (14, 'buggery', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (15, 'dickhead', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (16, 'dildo', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (17, 'faggot', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (18, 'fuck', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (19, 'fucked', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (20, 'fucking', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (21, 'fucker', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (22, 'gayboy', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (23, 'jackoff', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (24, 'jerk-off', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (25, 'motherfucker', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (26, 'nigger', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (27, 'piss', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (28, 'pissed', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (29, 'puffter', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (30, 'pussy', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (31, 'queers', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (32, 'retard', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (33, 'shag', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (34, 'shagged', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (35, 'shat', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (36, 'shit', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (37, 'slut', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (38, 'twat', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (39, 'wank', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (40, 'wanker', '', 0);
INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (41, 'whore', '', 0);

DROP TABLE IF EXISTS cms_zones;

CREATE TABLE cms_zones (
    zone_name varchar(80) NOT NULL,
    zone_title longtext NOT NULL,
    zone_default_page varchar(80) NOT NULL,
    zone_header_text longtext NOT NULL,
    zone_theme varchar(80) NOT NULL,
    zone_require_session tinyint(1) NOT NULL,
    PRIMARY KEY (zone_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('', 'Welcome', 'home', '', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('adminzone', 'Admin Zone', 'home', 'Admin Zone', 'admin', 1);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('site', 'Site', 'home', '', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('cms', 'Content Management', 'cms', 'Content Management', 'admin', 1);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('docs', 'Tutorials', 'tutorials', '', '-1', 0);
INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('forum', 'Forums', 'forumview', 'Forum', '-1', 0);

ALTER TABLE cms11_zones ADD FULLTEXT zone_header_text (zone_header_text);

ALTER TABLE cms11_zones ADD FULLTEXT zone_title (zone_title);
