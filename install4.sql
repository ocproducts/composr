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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_member_tracking;



CREATE TABLE cms_member_tracking (
     mt_member_id integer NOT NULL,
     mt_cache_username varchar(80) NOT NULL,
     mt_time integer unsigned NOT NULL,
     mt_page varchar(80) NOT NULL,
     mt_type varchar(80) NOT NULL,
     mt_id varchar(80) NOT NULL,

    PRIMARY KEY (mt_member_id, mt_time, mt_page, mt_type, mt_id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_member_zone_access;



CREATE TABLE cms_member_zone_access (
     zone_name varchar(80) NOT NULL,
     member_id integer NOT NULL,
     active_until integer unsigned NULL,

    PRIMARY KEY (zone_name, member_id)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_messages_to_render;



CREATE TABLE cms_messages_to_render (
     id integer unsigned auto_increment NOT NULL,
     r_session_id varchar(80) NOT NULL,
     r_message longtext NOT NULL,
     r_type varchar(80) NOT NULL,
     r_time integer unsigned NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_modules;



CREATE TABLE cms_modules (
     module_the_name varchar(80) NOT NULL,
     module_author varchar(80) NOT NULL,
     module_organisation varchar(80) NOT NULL,
     module_hacked_by varchar(80) NOT NULL,
     module_hack_version integer NULL,
     module_version integer NOT NULL,

    PRIMARY KEY (module_the_name)
) engine=MyISAM;


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_permissions', 'Chris Graham', 'ocProducts', '', NULL, 9);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_version', 'Chris Graham', 'ocProducts', '', NULL, 17);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_actionlog', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_addons', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_aggregate_types', 'Chris Graham', 'ocProducts', '', NULL, 1);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_awards', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_backup', 'Chris Graham', 'ocProducts', '', NULL, 3);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_banners', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_chat', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cleanup', 'Chris Graham', 'ocProducts', '', NULL, 3);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_customprofilefields', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_emoticons', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_forum_groupings', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_cns_forums', 'Chris Graham', 'ocProducts', '', NULL, 2);


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


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_import', 'Chris Graham', 'ocProducts', '', NULL, 7);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_invoices', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_ip_ban', 'Chris Graham', 'ocProducts', '', NULL, 5);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_lang', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_lookup', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_menus', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_messaging', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_newsletter', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_notifications', 'Chris Graham', 'ocProducts', '', NULL, 1);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_orders', 'Manuprathap', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_phpinfo', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_points', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_pointstore', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_quiz', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_realtime_rain', 'Chris Graham', 'ocProducts', '', NULL, 1);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_redirects', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_revisions', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_security', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_setupwizard', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_sitemap', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_ssl', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_staff', 'Chris Graham', 'ocProducts', '', NULL, 3);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_stats', 'Philip Withnall', 'ocProducts', '', NULL, 9);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_themes', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_themewizard', 'Allen Ellis', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_tickets', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_trackbacks', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_unvalidated', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_wordfilter', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('admin_zones', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('authors', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('awards', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('banners', 'Chris Graham', 'ocProducts', '', NULL, 7);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('bookmarks', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('calendar', 'Chris Graham', 'ocProducts', '', NULL, 8);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('catalogues', 'Chris Graham', 'ocProducts', '', NULL, 8);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('chat', 'Philip Withnall', 'ocProducts', '', NULL, 12);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('contact_member', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('downloads', 'Chris Graham', 'ocProducts', '', NULL, 8);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('galleries', 'Chris Graham', 'ocProducts', '', NULL, 10);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('groups', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('invoices', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('leader_board', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('members', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('news', 'Chris Graham', 'ocProducts', '', NULL, 7);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('newsletter', 'Chris Graham', 'ocProducts', '', NULL, 11);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('notifications', 'Chris Graham', 'ocProducts', '', NULL, 1);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('points', 'Chris Graham', 'ocProducts', '', NULL, 8);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('pointstore', 'Allen Ellis', 'ocProducts', '', NULL, 6);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('polls', 'Chris Graham', 'ocProducts', '', NULL, 6);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('purchase', 'Chris Graham', 'ocProducts', '', NULL, 6);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('quiz', 'Chris Graham', 'ocProducts', '', NULL, 6);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('search', 'Chris Graham', 'ocProducts', '', NULL, 5);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('shopping', 'Manuprathap', 'ocProducts', '', NULL, 7);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('staff', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('subscriptions', 'Chris Graham', 'ocProducts', '', NULL, 5);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('tickets', 'Chris Graham', 'ocProducts', '', NULL, 6);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('users_online', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('warnings', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('wiki', 'Chris Graham', 'ocProducts', '', NULL, 9);


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


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('filedump', 'Chris Graham', 'ocProducts', '', NULL, 4);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('forums', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('join', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('login', 'Chris Graham', 'ocProducts', '', NULL, 3);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('lost_password', 'Chris Graham', 'ocProducts', '', NULL, 2);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('recommend', 'Chris Graham', 'ocProducts', '', NULL, 5);


INSERT INTO cms_modules (module_the_name, module_author, module_organisation, module_hacked_by, module_hack_version, module_version) VALUES ('supermembers', 'Chris Graham', 'ocProducts', '', NULL, 2);


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
     news_image varchar(255) NOT NULL,
     title__text_parsed longtext NOT NULL,
     title__source_user integer DEFAULT 1 NOT NULL,
     news__text_parsed longtext NOT NULL,
     news__source_user integer DEFAULT 1 NOT NULL,
     news_article__text_parsed longtext NOT NULL,
     news_article__source_user integer DEFAULT 1 NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_news_categories;



CREATE TABLE cms_news_categories (
     id integer unsigned auto_increment NOT NULL,
     nc_title longtext NOT NULL,
     nc_owner integer NULL,
     nc_img varchar(255) NOT NULL,
     notes longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (1, 'General', NULL, 'newscats/general', '');


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (2, 'Technology', NULL, 'newscats/technology', '');


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (3, 'Difficulties', NULL, 'newscats/difficulties', '');


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (4, 'Community', NULL, 'newscats/community', '');


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (5, 'Entertainment', NULL, 'newscats/entertainment', '');


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (6, 'Business', NULL, 'newscats/business', '');


INSERT INTO cms_news_categories (id, nc_title, nc_owner, nc_img, notes) VALUES (7, 'Art', NULL, 'newscats/art', '');


DROP TABLE IF EXISTS cms_news_category_entries;



CREATE TABLE cms_news_category_entries (
     news_entry integer NOT NULL,
     news_entry_category integer NOT NULL,

    PRIMARY KEY (news_entry, news_entry_category)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_news_rss_cloud;



CREATE TABLE cms_news_rss_cloud (
     id integer unsigned auto_increment NOT NULL,
     rem_procedure varchar(80) NOT NULL,
     rem_port integer NOT NULL,
     rem_path varchar(255) NOT NULL,
     rem_protocol varchar(80) NOT NULL,
     rem_ip varchar(40) NOT NULL,
     watching_channel varchar(255) NOT NULL,
     register_time integer unsigned NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_newsletter_archive;



CREATE TABLE cms_newsletter_archive (
     id integer unsigned auto_increment NOT NULL,
     date_and_time integer NOT NULL,
     subject varchar(255) NOT NULL,
     newsletter longtext NOT NULL,
     language varchar(80) NOT NULL,
     importance_level integer NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_newsletter_drip_send;



CREATE TABLE cms_newsletter_drip_send (
     id integer unsigned auto_increment NOT NULL,
     d_inject_time integer unsigned NOT NULL,
     d_subject varchar(255) NOT NULL,
     d_message longtext NOT NULL,
     d_html_only tinyint(1) NOT NULL,
     d_to_email varchar(255) NOT NULL,
     d_to_name varchar(255) NOT NULL,
     d_from_email varchar(255) NOT NULL,
     d_from_name varchar(255) NOT NULL,
     d_priority tinyint NOT NULL,
     d_template varchar(80) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_newsletter_subscribe;



CREATE TABLE cms_newsletter_subscribe (
     newsletter_id integer NOT NULL,
     the_level tinyint NOT NULL,
     email varchar(255) NOT NULL,

    PRIMARY KEY (newsletter_id, email)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_newsletters;



CREATE TABLE cms_newsletters (
     id integer unsigned auto_increment NOT NULL,
     title longtext NOT NULL,
     description longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_newsletters (id, title, description) VALUES (1, 'General', 'General messages will be sent out in this newsletter.');


DROP TABLE IF EXISTS cms_notification_lockdown;



CREATE TABLE cms_notification_lockdown (
     l_notification_code varchar(80) NOT NULL,
     l_setting integer NOT NULL,

    PRIMARY KEY (l_notification_code)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_notifications_enabled;



CREATE TABLE cms_notifications_enabled (
     id integer unsigned auto_increment NOT NULL,
     l_member_id integer NOT NULL,
     l_notification_code varchar(80) NOT NULL,
     l_code_category varchar(255) NOT NULL,
     l_setting integer NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_poll_votes;



CREATE TABLE cms_poll_votes (
     id integer unsigned auto_increment NOT NULL,
     v_poll_id integer NOT NULL,
     v_voter_id integer NULL,
     v_voter_ip varchar(40) NOT NULL,
     v_vote_for tinyint NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_post_tokens;



CREATE TABLE cms_post_tokens (
     token varchar(80) NOT NULL,
     generation_time integer unsigned NOT NULL,
     member_id integer NOT NULL,
     session_id varchar(80) NOT NULL,
     ip_address varchar(40) NOT NULL,
     usage_tally integer NOT NULL,

    PRIMARY KEY (token)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_prices;



CREATE TABLE cms_prices (
     name varchar(80) NOT NULL,
     price integer NOT NULL,

    PRIMARY KEY (name)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_privilege_list;



CREATE TABLE cms_privilege_list (
     p_section varchar(80) NOT NULL,
     the_name varchar(80) NOT NULL,
     the_default tinyint(1) NOT NULL,

    PRIMARY KEY (the_name, the_default)
) engine=MyISAM;


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


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'feature', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'access_overrun_site', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'view_profiling_modes', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'comcode_dangerous', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'comcode_nuisance', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'see_stack_dump', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'see_php_errors', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'bypass_bandwidth_restriction', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('STAFF_ACTIONS', 'access_closed_site', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'use_very_dangerous_comcode', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('_COMCODE', 'allow_html', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'run_multi_moderations', 1);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'use_pt', 1);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'edit_private_topic_posts', 1);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_unblind_own_poll', 1);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FORUMS_AND_MEMBERS', 'may_report_post', 1);


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


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'see_unvalidated', 0);


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


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'unfiltered_input', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'set_content_review_settings', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'view_revisions', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'undo_revisions', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUBMISSION', 'delete_revisions', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'use_sms', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'sms_higher_limit', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('GENERAL_SETTINGS', 'sms_higher_trigger_limit', 0);


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


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_past_search', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_keyword_comcode_page', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SEARCH', 'autocomplete_title_comcode_page', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUPPORT_TICKETS', 'view_others_tickets', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('SUPPORT_TICKETS', 'support_operator', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('WIKI', 'wiki_manage_tree', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'upload_anything_filedump', 0);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'upload_filedump', 1);


INSERT INTO cms_privilege_list (p_section, the_name, the_default) VALUES ('FILEDUMP', 'delete_anything_filedump', 0);


DROP TABLE IF EXISTS cms_pstore_customs;



CREATE TABLE cms_pstore_customs (
     id integer unsigned auto_increment NOT NULL,
     c_title longtext NOT NULL,
     c_description longtext NOT NULL,
     c_mail_subject longtext NOT NULL,
     c_mail_body longtext NOT NULL,
     c_enabled tinyint(1) NOT NULL,
     c_cost integer NOT NULL,
     c_one_per_member tinyint(1) NOT NULL,
     c_description__text_parsed longtext NOT NULL,
     c_description__source_user integer DEFAULT 1 NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_pstore_permissions;



CREATE TABLE cms_pstore_permissions (
     id integer unsigned auto_increment NOT NULL,
     p_title longtext NOT NULL,
     p_description longtext NOT NULL,
     p_mail_subject longtext NOT NULL,
     p_mail_body longtext NOT NULL,
     p_enabled tinyint(1) NOT NULL,
     p_cost integer NOT NULL,
     p_hours integer NULL,
     p_type varchar(80) NOT NULL,
     p_privilege varchar(80) NOT NULL,
     p_zone varchar(80) NOT NULL,
     p_page varchar(80) NOT NULL,
     p_module varchar(80) NOT NULL,
     p_category varchar(80) NOT NULL,
     p_description__text_parsed longtext NOT NULL,
     p_description__source_user integer DEFAULT 1 NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_quiz_entries;



CREATE TABLE cms_quiz_entries (
     id integer unsigned auto_increment NOT NULL,
     q_time integer unsigned NOT NULL,
     q_member integer NOT NULL,
     q_quiz integer NOT NULL,
     q_results integer NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_quiz_entry_answer;



CREATE TABLE cms_quiz_entry_answer (
     id integer unsigned auto_increment NOT NULL,
     q_entry integer NOT NULL,
     q_question integer NOT NULL,
     q_answer longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_quiz_member_last_visit;



CREATE TABLE cms_quiz_member_last_visit (
     id integer unsigned auto_increment NOT NULL,
     v_time integer unsigned NOT NULL,
     v_member_id integer NOT NULL,
     v_quiz_id integer NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


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
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_quiz_winner;



CREATE TABLE cms_quiz_winner (
     q_quiz integer NOT NULL,
     q_entry integer NOT NULL,
     q_winner_level integer NOT NULL,

    PRIMARY KEY (q_quiz, q_entry)
) engine=MyISAM;


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
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_redirects;



CREATE TABLE cms_redirects (
     r_from_page varchar(80) NOT NULL,
     r_from_zone varchar(80) NOT NULL,
     r_to_page varchar(80) NOT NULL,
     r_to_zone varchar(80) NOT NULL,
     r_is_transparent tinyint(1) NOT NULL,

    PRIMARY KEY (r_from_page, r_from_zone)
) engine=MyISAM;


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('rules', 'site', 'rules', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('rules', 'forum', 'rules', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('authors', 'collaboration', 'authors', 'site', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'collaboration', 'panel_top', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'docs', 'panel_top', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'forum', 'panel_top', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_top', 'site', 'panel_top', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'collaboration', 'panel_bottom', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'docs', 'panel_bottom', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'forum', 'panel_bottom', '', 1);


INSERT INTO cms_redirects (r_from_page, r_from_zone, r_to_page, r_to_zone, r_is_transparent) VALUES ('panel_bottom', 'site', 'panel_bottom', '', 1);


DROP TABLE IF EXISTS cms_review_supplement;



CREATE TABLE cms_review_supplement (
     r_post_id integer NOT NULL,
     r_rating_type varchar(80) NOT NULL,
     r_rating tinyint NOT NULL,
     r_topic_id integer NOT NULL,
     r_rating_for_id varchar(80) NOT NULL,
     r_rating_for_type varchar(80) NOT NULL,

    PRIMARY KEY (r_post_id, r_rating_type)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_sales;



CREATE TABLE cms_sales (
     id integer unsigned auto_increment NOT NULL,
     date_and_time integer unsigned NOT NULL,
     memberid integer NOT NULL,
     purchasetype varchar(80) NOT NULL,
     details varchar(255) NOT NULL,
     details2 varchar(255) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_searches_logged;



CREATE TABLE cms_searches_logged (
     id integer unsigned auto_increment NOT NULL,
     s_member_id integer NOT NULL,
     s_time integer unsigned NOT NULL,
     s_primary varchar(255) NOT NULL,
     s_auxillary longtext NOT NULL,
     s_num_results integer NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_searches_saved;



CREATE TABLE cms_searches_saved (
     id integer unsigned auto_increment NOT NULL,
     s_title varchar(255) NOT NULL,
     s_member_id integer NOT NULL,
     s_time integer unsigned NOT NULL,
     s_primary varchar(255) NOT NULL,
     s_auxillary longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_seo_meta;



CREATE TABLE cms_seo_meta (
     id integer unsigned auto_increment NOT NULL,
     meta_for_type varchar(80) NOT NULL,
     meta_for_id varchar(80) NOT NULL,
     meta_description longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_seo_meta (id, meta_for_type, meta_for_id, meta_description) VALUES (2, 'gallery', 'root', '');


DROP TABLE IF EXISTS cms_seo_meta_keywords;



CREATE TABLE cms_seo_meta_keywords (
     id integer unsigned auto_increment NOT NULL,
     meta_for_type varchar(80) NOT NULL,
     meta_for_id varchar(80) NOT NULL,
     meta_keyword longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_shopping_cart;



CREATE TABLE cms_shopping_cart (
     id integer unsigned auto_increment NOT NULL,
     session_id varchar(80) NOT NULL,
     ordered_by integer NOT NULL,
     product_id integer NOT NULL,
     product_name varchar(255) NOT NULL,
     product_code varchar(255) NOT NULL,
     quantity integer NOT NULL,
     price_pre_tax real NOT NULL,
     price real NOT NULL,
     product_description longtext NOT NULL,
     product_type varchar(255) NOT NULL,
     product_weight real NOT NULL,
     is_deleted tinyint(1) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_shopping_logging;



CREATE TABLE cms_shopping_logging (
     id integer unsigned auto_increment NOT NULL,
     e_member_id integer NOT NULL,
     session_id varchar(80) NOT NULL,
     ip varchar(40) NOT NULL,
     last_action varchar(255) NOT NULL,
     date_and_time integer unsigned NOT NULL,

    PRIMARY KEY (id, e_member_id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_shopping_order;



CREATE TABLE cms_shopping_order (
     id integer unsigned auto_increment NOT NULL,
     c_member integer NOT NULL,
     session_id varchar(80) NOT NULL,
     add_date integer unsigned NOT NULL,
     tot_price real NOT NULL,
     order_status varchar(80) NOT NULL,
     notes longtext NOT NULL,
     transaction_id varchar(255) NOT NULL,
     purchase_through varchar(255) NOT NULL,
     tax_opted_out tinyint(1) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_shopping_order_addresses;



CREATE TABLE cms_shopping_order_addresses (
     id integer unsigned auto_increment NOT NULL,
     order_id integer NULL,
     address_name varchar(255) NOT NULL,
     address_street longtext NOT NULL,
     address_city varchar(255) NOT NULL,
     address_state varchar(255) NOT NULL,
     address_zip varchar(255) NOT NULL,
     address_country varchar(255) NOT NULL,
     receiver_email varchar(255) NOT NULL,
     contact_phone varchar(255) NOT NULL,
     first_name varchar(255) NOT NULL,
     last_name varchar(255) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_shopping_order_details;



CREATE TABLE cms_shopping_order_details (
     id integer unsigned auto_increment NOT NULL,
     order_id integer NULL,
     p_id integer NULL,
     p_name varchar(255) NOT NULL,
     p_code varchar(255) NOT NULL,
     p_type varchar(255) NOT NULL,
     p_quantity integer NOT NULL,
     p_price real NOT NULL,
     included_tax real NOT NULL,
     dispatch_status varchar(255) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_sms_log;



CREATE TABLE cms_sms_log (
     id integer unsigned auto_increment NOT NULL,
     s_member_id integer NOT NULL,
     s_time integer unsigned NOT NULL,
     s_trigger_ip varchar(40) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_staff_checklist_cus_tasks;



CREATE TABLE cms_staff_checklist_cus_tasks (
     id integer unsigned auto_increment NOT NULL,
     task_title longtext NOT NULL,
     add_date integer unsigned NOT NULL,
     recur_interval integer NOT NULL,
     recur_every varchar(80) NOT NULL,
     task_is_done integer unsigned NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (1, 'Set up website configuration and structure', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (2, 'Make/install custom theme', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (3, '[page=\"adminzone:admin_themes:edit_image:favicon\"]Make \'favicon\' theme image[/page]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (4, '[page=\"adminzone:admin_themes:edit_image:webclipicon\"]Make \'webclipicon\' theme image[/page]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (5, 'Add your content', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (6, '[page=\"adminzone:admin_themes:edit_image:logo/standalone_logo:theme=default\"]Customise your mail/RSS logo[/page]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (7, '[page=\"adminzone:admin_themes:_edit_templates:theme=default:f0file=templates/MAIL.tpl\"]Customise your \'MAIL\' template[/page]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (8, '[url=\"Sign up for Google Webmaster Tools\"]https://www.google.com/webmasters/tools/[/url]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (9, '[url=\"Submit to OpenDMOZ\"]http://www.dmoz.org/add.html[/url]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (10, '[url=\"Set up up-time monitor\"]https://uptimerobot.com/[/url]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (11, '[html]<p style=\"margin: 0\">Facebook user? Like Composr on Facebook:</p><iframe src=\"https://compo.sr/uploads/website_specific/compo.sr/facebook.html\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:430px; height:20px;\" allowTransparency=\"true\"></iframe>[/html]', 1486734854, 0, '', NULL);


INSERT INTO cms_staff_checklist_cus_tasks (id, task_title, add_date, recur_interval, recur_every, task_is_done) VALUES (12, '[url=\"Consider helping out with the Composr project\"]http://compo.sr/site/contributions.htm[/url]', 1486734854, 0, '', NULL);


DROP TABLE IF EXISTS cms_staff_links;



CREATE TABLE cms_staff_links (
     id integer unsigned auto_increment NOT NULL,
     link varchar(255) NOT NULL,
     link_title varchar(255) NOT NULL,
     link_desc longtext NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (1, 'http://compo.sr/', 'compo.sr', 'compo.sr');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (2, 'http://compo.sr/forum/vforums.htm', 'compo.sr (topics with unread posts)', 'compo.sr (topics with unread posts)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (3, 'http://ocproducts.com/', 'ocProducts (web development services)', 'ocProducts (web development services)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (4, 'https://www.transifex.com/organization/ocproducts/dashboard', 'Transifex (Composr language translations)', 'Transifex (Composr language translations)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (5, 'http://www.google.com/alerts', 'Google Alerts', 'Google Alerts');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (6, 'http://www.google.com/analytics/', 'Google Analytics', 'Google Analytics');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (7, 'https://www.google.com/webmasters/tools', 'Google Webmaster Tools', 'Google Webmaster Tools');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (8, 'http://www.google.com/apps/intl/en/group/index.html', 'Google Apps (gmail for domains, etc)', 'Google Apps (gmail for domains, etc)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (9, 'http://www.google.com/chrome', 'Google Chrome (web browser)', 'Google Chrome (web browser)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (10, 'https://chrome.google.com/extensions/featured/web_dev', 'Google Chrome addons', 'Google Chrome addons');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (11, 'http://www.sharedcount.com/', 'SharedCount (social sharing stats)', 'SharedCount (social sharing stats)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (12, 'https://developers.facebook.com/docs/insights/', 'Facebook Insights (Facebook Analytics)', 'Facebook Insights (Facebook Analytics)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (13, 'http://www.getpaint.net/', 'Paint.net (free graphics tool, Windows)', 'Paint.net (free graphics tool, Windows)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (14, 'http://benhollis.net/software/pnggauntlet/', 'PNGGauntlet (compress PNG files, Windows)', 'PNGGauntlet (compress PNG files, Windows)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (15, 'http://imageoptim.pornel.net/', 'ImageOptim (compress PNG files, Mac)', 'ImageOptim (compress PNG files, Mac)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (16, 'http://findicons.com/', 'Find Icons (free icons)', 'Find Icons (free icons)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (17, 'http://sxc.hu/', 'stock.xchng (free stock art)', 'stock.xchng (free stock art)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (18, 'http://www.kompozer.net/', 'Kompozer (Web design tool)', 'Kompozer (Web design tool)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (19, 'http://www.sourcegear.com/diffmerge/', 'DiffMerge', 'DiffMerge');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (20, 'http://www.jingproject.com/', 'Jing (record screencasts)', 'Jing (record screencasts)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (21, 'http://www.silktide.com/siteray', 'SiteRay (site quality auditing)', 'SiteRay (site quality auditing)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (22, 'http://www.smashingmagazine.com/', 'Smashing Magazine (web design articles)', 'Smashing Magazine (web design articles)');


INSERT INTO cms_staff_links (id, link, link_title, link_desc) VALUES (23, 'http://www.w3schools.com/', 'w3schools (learn web technologies)', 'w3schools (learn web technologies)');


DROP TABLE IF EXISTS cms_staff_tips_dismissed;



CREATE TABLE cms_staff_tips_dismissed (
     t_member integer NOT NULL,
     t_tip varchar(80) NOT NULL,

    PRIMARY KEY (t_member, t_tip)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_staff_website_monitoring;



CREATE TABLE cms_staff_website_monitoring (
     id integer unsigned auto_increment NOT NULL,
     site_url varchar(255) NOT NULL,
     site_name varchar(255) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_staff_website_monitoring (id, site_url, site_name) VALUES (1, 'http://localhost/composr', '');


DROP TABLE IF EXISTS cms_stats;



CREATE TABLE cms_stats (
     id integer unsigned auto_increment NOT NULL,
     the_page varchar(255) NOT NULL,
     ip varchar(40) NOT NULL,
     member_id integer NOT NULL,
     session_id varchar(80) NOT NULL,
     date_and_time integer unsigned NOT NULL,
     referer varchar(255) NOT NULL,
     s_get varchar(255) NOT NULL,
     post longtext NOT NULL,
     browser varchar(255) NOT NULL,
     milliseconds integer NOT NULL,
     operating_system varchar(255) NOT NULL,
     access_denied_counter integer NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_subscriptions;



CREATE TABLE cms_subscriptions (
     id integer unsigned auto_increment NOT NULL,
     s_type_code varchar(80) NOT NULL,
     s_member_id integer NOT NULL,
     s_state varchar(80) NOT NULL,
     s_amount varchar(255) NOT NULL,
     s_purchase_id varchar(80) NOT NULL,
     s_time integer unsigned NOT NULL,
     s_auto_fund_source varchar(80) NOT NULL,
     s_auto_fund_key varchar(255) NOT NULL,
     s_via varchar(80) NOT NULL,
     s_length integer NOT NULL,
     s_length_units varchar(255) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


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
) engine=MyISAM;


INSERT INTO cms_task_queue (id, t_title, t_hook, t_args, t_member_id, t_secure_ref, t_send_notification, t_locked) VALUES (1, 'Install geolocation data', 'install_geolocation_data', 'a:0:{}', 1, '5009ee5feafa1', 0, 0);


DROP TABLE IF EXISTS cms_temp_block_permissions;



CREATE TABLE cms_temp_block_permissions (
     id integer unsigned auto_increment NOT NULL,
     p_session_id varchar(80) NOT NULL,
     p_block_constraints longtext NOT NULL,
     p_time integer unsigned NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_theme_images;



CREATE TABLE cms_theme_images (
     id varchar(255) NOT NULL,
     theme varchar(40) NOT NULL,
     path varchar(255) NOT NULL,
     lang varchar(5) NOT NULL,

    PRIMARY KEY (id, theme, lang)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_ticket_extra_access;



CREATE TABLE cms_ticket_extra_access (
     ticket_id varchar(255) NOT NULL,
     member_id integer NOT NULL,

    PRIMARY KEY (ticket_id, member_id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_ticket_known_emailers;



CREATE TABLE cms_ticket_known_emailers (
     email_address varchar(255) NOT NULL,
     member_id integer NOT NULL,

    PRIMARY KEY (email_address)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_ticket_types;



CREATE TABLE cms_ticket_types (
     id integer unsigned auto_increment NOT NULL,
     ticket_type_name longtext NOT NULL,
     guest_emails_mandatory tinyint(1) NOT NULL,
     search_faq tinyint(1) NOT NULL,
     cache_lead_time integer unsigned NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_ticket_types (id, ticket_type_name, guest_emails_mandatory, search_faq, cache_lead_time) VALUES (1, 'Other', 0, 0, NULL);


INSERT INTO cms_ticket_types (id, ticket_type_name, guest_emails_mandatory, search_faq, cache_lead_time) VALUES (2, 'Complaint', 0, 0, NULL);


DROP TABLE IF EXISTS cms_tickets;



CREATE TABLE cms_tickets (
     ticket_id varchar(255) NOT NULL,
     topic_id integer NOT NULL,
     forum_id integer NOT NULL,
     ticket_type integer NOT NULL,

    PRIMARY KEY (ticket_id)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_trans_expecting;



CREATE TABLE cms_trans_expecting (
     id varchar(80) NOT NULL,
     e_purchase_id varchar(80) NOT NULL,
     e_item_name varchar(255) NOT NULL,
     e_member_id integer NOT NULL,
     e_amount varchar(255) NOT NULL,
     e_currency varchar(80) NOT NULL,
     e_ip_address varchar(40) NOT NULL,
     e_session_id varchar(80) NOT NULL,
     e_time integer unsigned NOT NULL,
     e_length integer NULL,
     e_length_units varchar(80) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_transactions;



CREATE TABLE cms_transactions (
     id varchar(80) NOT NULL,
     t_type_code varchar(80) NOT NULL,
     t_purchase_id varchar(80) NOT NULL,
     t_status varchar(255) NOT NULL,
     t_reason varchar(255) NOT NULL,
     t_amount varchar(255) NOT NULL,
     t_currency varchar(80) NOT NULL,
     t_parent_txn_id varchar(80) NOT NULL,
     t_time integer unsigned NOT NULL,
     t_pending_reason varchar(255) NOT NULL,
     t_memo longtext NOT NULL,
     t_via varchar(80) NOT NULL,

    PRIMARY KEY (id, t_time)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_tutorial_links;



CREATE TABLE cms_tutorial_links (
     the_name varchar(80) NOT NULL,
     the_value longtext NOT NULL,

    PRIMARY KEY (the_name)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_unbannable_ip;



CREATE TABLE cms_unbannable_ip (
     ip varchar(40) NOT NULL,
     note varchar(255) NOT NULL,

    PRIMARY KEY (ip)
) engine=MyISAM;


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_url_title_cache;



CREATE TABLE cms_url_title_cache (
     id integer unsigned auto_increment NOT NULL,
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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_urls_checked;



CREATE TABLE cms_urls_checked (
     id integer unsigned auto_increment NOT NULL,
     url longtext NOT NULL,
     url_exists tinyint(1) NOT NULL,
     url_check_time integer unsigned NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_usersonline_track;



CREATE TABLE cms_usersonline_track (
     date_and_time integer unsigned NOT NULL,
     peak integer NOT NULL,

    PRIMARY KEY (date_and_time)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_usersubmitban_member;



CREATE TABLE cms_usersubmitban_member (
     the_member integer NOT NULL,

    PRIMARY KEY (the_member)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_values;



CREATE TABLE cms_values (
     the_name varchar(80) NOT NULL,
     the_value varchar(255) NOT NULL,
     date_and_time integer unsigned NOT NULL,

    PRIMARY KEY (the_name)
) engine=MyISAM;


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_topic_count', '1', 1486734837);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_member_count', '1', 1486734838);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_post_count', '1', 1486734838);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('version', '10.00', 1486734838);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('cns_version', '10.00', 1486734838);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('users_online', '0', 1486734846);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('user_peak', '0', 1486734846);


INSERT INTO cms_values (the_name, the_value, date_and_time) VALUES ('user_peak_week', '0', 1486734846);


DROP TABLE IF EXISTS cms_values_elective;



CREATE TABLE cms_values_elective (
     the_name varchar(80) NOT NULL,
     the_value longtext NOT NULL,
     date_and_time integer unsigned NOT NULL,

    PRIMARY KEY (the_name)
) engine=MyISAM;


INSERT INTO cms_values_elective (the_name, the_value, date_and_time) VALUES ('call_home', '0', 1486734838);


DROP TABLE IF EXISTS cms_video_transcoding;



CREATE TABLE cms_video_transcoding (
     t_id varchar(80) NOT NULL,
     t_local_id integer NULL,
     t_local_id_field varchar(80) NOT NULL,
     t_error longtext NOT NULL,
     t_url varchar(255) NOT NULL,
     t_table varchar(80) NOT NULL,
     t_url_field varchar(80) NOT NULL,
     t_orig_filename_field varchar(80) NOT NULL,
     t_width_field varchar(80) NOT NULL,
     t_height_field varchar(80) NOT NULL,
     t_output_filename varchar(80) NOT NULL,

    PRIMARY KEY (t_id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_videos;



CREATE TABLE cms_videos (
     id integer unsigned auto_increment NOT NULL,
     cat varchar(80) NOT NULL,
     url varchar(255) NOT NULL,
     thumb_url varchar(255) NOT NULL,
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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_webstandards_checked_once;



CREATE TABLE cms_webstandards_checked_once (
     hash varchar(255) NOT NULL,

    PRIMARY KEY (hash)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_wiki_children;



CREATE TABLE cms_wiki_children (
     parent_id integer NOT NULL,
     child_id integer NOT NULL,
     the_order integer NOT NULL,
     title varchar(255) NOT NULL,

    PRIMARY KEY (parent_id, child_id)
) engine=MyISAM;


DROP TABLE IF EXISTS cms_wiki_pages;



CREATE TABLE cms_wiki_pages (
     id integer unsigned auto_increment NOT NULL,
     title longtext NOT NULL,
     notes longtext NOT NULL,
     description longtext NOT NULL,
     add_date integer unsigned NOT NULL,
     edit_date integer unsigned NULL,
     wiki_views integer NOT NULL,
     hide_posts tinyint(1) NOT NULL,
     submitter integer NOT NULL,
     description__text_parsed longtext NOT NULL,
     description__source_user integer DEFAULT 1 NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_wiki_pages (id, title, notes, description, add_date, edit_date, wiki_views, hide_posts, submitter, description__text_parsed, description__source_user) VALUES (1, 'Wiki+ home', '', '', 1486734853, NULL, 0, 0, 2, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_589dc5fff1d4b6.75954996_24\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_589dc5fff1d4b6.75954996_24\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_589dc5fff1d4b6.75954996_24\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");\n', 1);


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
) engine=MyISAM;


DROP TABLE IF EXISTS cms_wordfilter;



CREATE TABLE cms_wordfilter (
     id integer unsigned auto_increment NOT NULL,
     word varchar(255) NOT NULL,
     w_replacement varchar(255) NOT NULL,
     w_substr tinyint(1) NOT NULL,

    PRIMARY KEY (id)
) engine=MyISAM;


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (1, 'arsehole', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (2, 'asshole', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (3, 'arse', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (4, 'bastard', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (5, 'cock', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (6, 'cocked', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (7, 'cocksucker', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (8, 'crap', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (9, 'cunt', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (10, 'cum', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (11, 'blowjob', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (12, 'bollocks', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (13, 'bondage', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (14, 'bugger', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (15, 'buggery', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (16, 'dickhead', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (17, 'dildo', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (18, 'faggot', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (19, 'fuck', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (20, 'fucked', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (21, 'fucking', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (22, 'fucker', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (23, 'gayboy', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (24, 'jackoff', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (25, 'jerk-off', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (26, 'motherfucker', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (27, 'nigger', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (28, 'piss', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (29, 'pissed', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (30, 'puffter', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (31, 'pussy', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (32, 'queers', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (33, 'retard', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (34, 'shag', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (35, 'shagged', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (36, 'shat', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (37, 'shit', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (38, 'slut', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (39, 'twat', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (40, 'wank', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (41, 'wanker', '', 0);


INSERT INTO cms_wordfilter (id, word, w_replacement, w_substr) VALUES (42, 'whore', '', 0);


DROP TABLE IF EXISTS cms_zones;



CREATE TABLE cms_zones (
     zone_name varchar(80) NOT NULL,
     zone_title longtext NOT NULL,
     zone_default_page varchar(80) NOT NULL,
     zone_header_text longtext NOT NULL,
     zone_theme varchar(80) NOT NULL,
     zone_require_session tinyint(1) NOT NULL,

    PRIMARY KEY (zone_name)
) engine=MyISAM;


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('', 'Welcome', 'start', '', '-1', 0);


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('adminzone', 'Admin Zone', 'start', 'Admin Zone', 'admin', 1);


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('collaboration', 'Collaboration Zone', 'start', 'Collaboration Zone', '-1', 0);


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('site', 'Site', 'start', '', '-1', 0);


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('cms', 'Content Management', 'cms', 'Content Management', 'admin', 1);


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('docs', 'Tutorials', 'tutorials', '', '-1', 0);


INSERT INTO cms_zones (zone_name, zone_title, zone_default_page, zone_header_text, zone_theme, zone_require_session) VALUES ('forum', 'Forums', 'forumview', 'Forum', '-1', 0);


ALTER TABLE cms_actionlogs ADD INDEX aip (ip);


ALTER TABLE cms_actionlogs ADD INDEX athe_type (the_type);


ALTER TABLE cms_actionlogs ADD INDEX ts (date_and_time);


ALTER TABLE cms_actionlogs ADD INDEX xas (member_id);


ALTER TABLE cms_aggregate_type_instances ADD INDEX aggregate_lookup (aggregate_label(250));


ALTER TABLE cms_alternative_ids ADD INDEX resource_guid (resource_guid);


ALTER TABLE cms_alternative_ids ADD INDEX resource_label (resource_label(250));


ALTER TABLE cms_alternative_ids ADD INDEX resource_moniker (resource_moniker,resource_type);


ALTER TABLE cms_alternative_ids ADD INDEX resource_moniker_uniq (resource_moniker,resource_resource_fs_hook);


ALTER TABLE cms_attachments ADD INDEX attachmentlimitcheck (a_add_time);


ALTER TABLE cms_attachments ADD INDEX ownedattachments (a_member_id);


ALTER TABLE cms_authors ADD FULLTEXT description (description(250));


ALTER TABLE cms_authors ADD FULLTEXT skills (skills(250));


ALTER TABLE cms_authors ADD INDEX findmemberlink (member_id);


ALTER TABLE cms_autosave ADD INDEX myautosaves (a_member_id);


ALTER TABLE cms_award_archive ADD INDEX awardquicksearch (content_id);


ALTER TABLE cms_award_types ADD FULLTEXT a_description (a_description(250));


ALTER TABLE cms_award_types ADD FULLTEXT a_title (a_title(250));


ALTER TABLE cms_banners ADD FULLTEXT caption (caption(250));


ALTER TABLE cms_banners ADD INDEX badd_date (add_date);


ALTER TABLE cms_banners ADD INDEX banner_child_find (b_type);


ALTER TABLE cms_banners ADD INDEX bvalidated (validated);


ALTER TABLE cms_banners ADD INDEX campaign_remaining (campaign_remaining);


ALTER TABLE cms_banners ADD INDEX expiry_date (expiry_date);


ALTER TABLE cms_banners ADD INDEX the_type (the_type);


ALTER TABLE cms_banners ADD INDEX topsites (hits_from,hits_to);


ALTER TABLE cms_banner_clicks ADD INDEX clicker_ip (c_ip_address);


ALTER TABLE cms_banner_clicks ADD INDEX c_banner_id (c_banner_id);


ALTER TABLE cms_banner_types ADD INDEX hottext (t_comcode_inline);


ALTER TABLE cms_cache ADD INDEX cached_ford (date_and_time);


ALTER TABLE cms_cache ADD INDEX cached_fore (cached_for);


ALTER TABLE cms_cache ADD INDEX cached_forf (cached_for,identifier,the_theme,lang,staff_status,the_member,is_bot);


ALTER TABLE cms_cache ADD INDEX cached_forh (the_theme);


ALTER TABLE cms_cached_comcode_pages ADD FULLTEXT cc_page_title (cc_page_title(250));


ALTER TABLE cms_cached_comcode_pages ADD FULLTEXT page_search__combined (cc_page_title(250),string_index(250));


ALTER TABLE cms_cached_comcode_pages ADD FULLTEXT string_index (string_index(250));


ALTER TABLE cms_cached_comcode_pages ADD INDEX ccp_join (the_page,the_zone);


ALTER TABLE cms_cached_comcode_pages ADD INDEX ftjoin_ccpt (cc_page_title(250));


ALTER TABLE cms_cached_comcode_pages ADD INDEX ftjoin_ccsi (string_index(250));


ALTER TABLE cms_calendar_events ADD FULLTEXT event_search__combined (e_title(250),e_content(250));


ALTER TABLE cms_calendar_events ADD FULLTEXT e_content (e_content(250));


ALTER TABLE cms_calendar_events ADD FULLTEXT e_title (e_title(250));


ALTER TABLE cms_calendar_events ADD INDEX ces (e_submitter);


ALTER TABLE cms_calendar_events ADD INDEX eventat (e_start_year,e_start_month,e_start_day,e_start_hour,e_start_minute);


ALTER TABLE cms_calendar_events ADD INDEX e_add_date (e_add_date);


ALTER TABLE cms_calendar_events ADD INDEX e_type (e_type);


ALTER TABLE cms_calendar_events ADD INDEX e_views (e_views);


ALTER TABLE cms_calendar_events ADD INDEX ftjoin_econtent (e_content(250));


ALTER TABLE cms_calendar_events ADD INDEX ftjoin_etitle (e_title(250));


ALTER TABLE cms_calendar_events ADD INDEX validated (validated);


ALTER TABLE cms_calendar_jobs ADD INDEX applicablejobs (j_time);


ALTER TABLE cms_calendar_types ADD FULLTEXT t_title (t_title(250));


ALTER TABLE cms_captchas ADD INDEX si_time (si_time);


ALTER TABLE cms_catalogues ADD FULLTEXT c_description (c_description(250));


ALTER TABLE cms_catalogues ADD FULLTEXT c_title (c_title(250));


ALTER TABLE cms_catalogue_categories ADD FULLTEXT cat_cat_search__combined (cc_title(250),cc_description(250));


ALTER TABLE cms_catalogue_categories ADD FULLTEXT cc_description (cc_description(250));


ALTER TABLE cms_catalogue_categories ADD FULLTEXT cc_title (cc_title(250));


ALTER TABLE cms_catalogue_categories ADD INDEX cataloguefind (c_name);


ALTER TABLE cms_catalogue_categories ADD INDEX catstoclean (cc_move_target);


ALTER TABLE cms_catalogue_categories ADD INDEX cc_order (cc_order);


ALTER TABLE cms_catalogue_categories ADD INDEX cc_parent_id (cc_parent_id);


ALTER TABLE cms_catalogue_categories ADD INDEX ftjoin_ccdescrip (cc_description(250));


ALTER TABLE cms_catalogue_categories ADD INDEX ftjoin_cctitle (cc_title(250));


ALTER TABLE cms_catalogue_cat_treecache ADD INDEX cc_ancestor_id (cc_ancestor_id);


ALTER TABLE cms_catalogue_efv_float ADD INDEX cefv_f_combo (ce_id,cf_id);


ALTER TABLE cms_catalogue_efv_float ADD INDEX fce_id (ce_id);


ALTER TABLE cms_catalogue_efv_float ADD INDEX fcf_id (cf_id);


ALTER TABLE cms_catalogue_efv_float ADD INDEX fcv_value (cv_value);


ALTER TABLE cms_catalogue_efv_integer ADD INDEX cefv_i_combo (ce_id,cf_id);


ALTER TABLE cms_catalogue_efv_integer ADD INDEX ice_id (ce_id);


ALTER TABLE cms_catalogue_efv_integer ADD INDEX icf_id (cf_id);


ALTER TABLE cms_catalogue_efv_integer ADD INDEX itv_value (cv_value);


ALTER TABLE cms_catalogue_efv_long ADD FULLTEXT lcv_value (cv_value(250));


ALTER TABLE cms_catalogue_efv_long ADD INDEX cefv_l_combo (ce_id,cf_id);


ALTER TABLE cms_catalogue_efv_long ADD INDEX lce_id (ce_id);


ALTER TABLE cms_catalogue_efv_long ADD INDEX lcf_id (cf_id);


ALTER TABLE cms_catalogue_efv_long_trans ADD FULLTEXT cv_value (cv_value(250));


ALTER TABLE cms_catalogue_efv_long_trans ADD INDEX cefv_lt_combo (ce_id,cf_id);


ALTER TABLE cms_catalogue_efv_long_trans ADD INDEX ltce_id (ce_id);


ALTER TABLE cms_catalogue_efv_long_trans ADD INDEX ltcf_id (cf_id);


ALTER TABLE cms_catalogue_efv_long_trans ADD INDEX ltcv_value (cv_value(250));


ALTER TABLE cms_catalogue_efv_short ADD FULLTEXT scv_value (cv_value(250));


ALTER TABLE cms_catalogue_efv_short ADD INDEX cefv_s_combo (ce_id,cf_id);


ALTER TABLE cms_catalogue_efv_short ADD INDEX iscv_value (cv_value(250));


ALTER TABLE cms_catalogue_efv_short ADD INDEX sce_id (ce_id);


ALTER TABLE cms_catalogue_efv_short ADD INDEX scf_id (cf_id);


ALTER TABLE cms_catalogue_efv_short_trans ADD FULLTEXT cv_value (cv_value(250));


ALTER TABLE cms_catalogue_efv_short_trans ADD INDEX cefv_st_combo (ce_id,cf_id);


ALTER TABLE cms_catalogue_efv_short_trans ADD INDEX stce_id (ce_id);


ALTER TABLE cms_catalogue_efv_short_trans ADD INDEX stcf_id (cf_id);


ALTER TABLE cms_catalogue_efv_short_trans ADD INDEX stcv_value (cv_value(250));


ALTER TABLE cms_catalogue_entries ADD INDEX ces (ce_submitter);


ALTER TABLE cms_catalogue_entries ADD INDEX ce_add_date (ce_add_date);


ALTER TABLE cms_catalogue_entries ADD INDEX ce_cc_id (cc_id);


ALTER TABLE cms_catalogue_entries ADD INDEX ce_c_name (c_name);


ALTER TABLE cms_catalogue_entries ADD INDEX ce_validated (ce_validated);


ALTER TABLE cms_catalogue_entries ADD INDEX ce_views (ce_views);


ALTER TABLE cms_catalogue_entry_linkage ADD INDEX custom_fields (content_type,content_id);


ALTER TABLE cms_catalogue_fields ADD FULLTEXT cf_description (cf_description(250));


ALTER TABLE cms_catalogue_fields ADD FULLTEXT cf_name (cf_name(250));


ALTER TABLE cms_chargelog ADD FULLTEXT reason (reason(250));


ALTER TABLE cms_chat_active ADD INDEX active_ordering (date_and_time);


ALTER TABLE cms_chat_active ADD INDEX member_select (member_id);


ALTER TABLE cms_chat_active ADD INDEX room_select (room_id);


ALTER TABLE cms_chat_events ADD INDEX event_ordering (e_date_and_time);


ALTER TABLE cms_chat_messages ADD FULLTEXT the_message (the_message(250));


ALTER TABLE cms_chat_messages ADD INDEX ordering (date_and_time);


ALTER TABLE cms_chat_messages ADD INDEX room_id (room_id);


ALTER TABLE cms_chat_rooms ADD FULLTEXT c_welcome (c_welcome(250));


ALTER TABLE cms_chat_rooms ADD INDEX allow_list (allow_list(30));


ALTER TABLE cms_chat_rooms ADD INDEX first_public (is_im,id);


ALTER TABLE cms_chat_rooms ADD INDEX is_im (is_im);


ALTER TABLE cms_chat_rooms ADD INDEX room_name (room_name(250));


ALTER TABLE cms_comcode_pages ADD INDEX p_add_date (p_add_date);


ALTER TABLE cms_comcode_pages ADD INDEX p_order (p_order);


ALTER TABLE cms_comcode_pages ADD INDEX p_submitter (p_submitter);


ALTER TABLE cms_comcode_pages ADD INDEX p_validated (p_validated);


ALTER TABLE cms_config ADD FULLTEXT c_value_trans (c_value_trans(250));


ALTER TABLE cms_content_privacy ADD INDEX friend_view (friend_view);


ALTER TABLE cms_content_privacy ADD INDEX guest_view (guest_view);


ALTER TABLE cms_content_privacy ADD INDEX member_view (member_view);


ALTER TABLE cms_content_reviews ADD INDEX needs_review (next_review_time,content_type);


ALTER TABLE cms_content_reviews ADD INDEX next_review_time (next_review_time,review_notification_happened);


ALTER TABLE cms_cron_caching_requests ADD INDEX c_compound (c_codename,c_theme,c_lang,c_timezone);


ALTER TABLE cms_cron_caching_requests ADD INDEX c_is_bot (c_is_bot);


ALTER TABLE cms_cron_caching_requests ADD INDEX c_store_as_tempcode (c_store_as_tempcode);


ALTER TABLE cms_custom_comcode ADD FULLTEXT tag_description (tag_description(250));


ALTER TABLE cms_custom_comcode ADD FULLTEXT tag_title (tag_title(250));


ALTER TABLE cms_db_meta ADD INDEX findtransfields (m_type);


ALTER TABLE cms_digestives_tin ADD FULLTEXT d_message (d_message(250));


ALTER TABLE cms_digestives_tin ADD INDEX d_date_and_time (d_date_and_time);


ALTER TABLE cms_digestives_tin ADD INDEX d_frequency (d_frequency);


ALTER TABLE cms_digestives_tin ADD INDEX d_read (d_read);


ALTER TABLE cms_digestives_tin ADD INDEX d_to_member_id (d_to_member_id);


ALTER TABLE cms_digestives_tin ADD INDEX unread (d_to_member_id,d_read);


ALTER TABLE cms_download_categories ADD FULLTEXT category (category(250));


ALTER TABLE cms_download_categories ADD FULLTEXT description (description(250));


ALTER TABLE cms_download_categories ADD FULLTEXT dl_cat_search__combined (category(250),description(250));


ALTER TABLE cms_download_categories ADD INDEX child_find (parent_id);


ALTER TABLE cms_download_categories ADD INDEX ftjoin_dccat (category(250));


ALTER TABLE cms_download_categories ADD INDEX ftjoin_dcdescrip (description(250));


ALTER TABLE cms_download_downloads ADD FULLTEXT additional_details (additional_details(250));


ALTER TABLE cms_download_downloads ADD FULLTEXT description (description(250));


ALTER TABLE cms_download_downloads ADD FULLTEXT dl_search__combined (original_filename(250),download_data_mash(250));


ALTER TABLE cms_download_downloads ADD FULLTEXT download_data_mash (download_data_mash(250));


ALTER TABLE cms_download_downloads ADD FULLTEXT name (name(250));


ALTER TABLE cms_download_downloads ADD FULLTEXT original_filename (original_filename(250));


ALTER TABLE cms_download_downloads ADD INDEX category_list (category_id);


ALTER TABLE cms_download_downloads ADD INDEX ddl (download_licence);


ALTER TABLE cms_download_downloads ADD INDEX dds (submitter);


ALTER TABLE cms_download_downloads ADD INDEX downloadauthor (author);


ALTER TABLE cms_download_downloads ADD INDEX download_views (download_views);


ALTER TABLE cms_download_downloads ADD INDEX dvalidated (validated);


ALTER TABLE cms_download_downloads ADD INDEX ftjoin_dadditional (additional_details(250));


ALTER TABLE cms_download_downloads ADD INDEX ftjoin_ddescrip (description(250));


ALTER TABLE cms_download_downloads ADD INDEX ftjoin_dname (name(250));


ALTER TABLE cms_download_downloads ADD INDEX recent_downloads (add_date);


ALTER TABLE cms_download_downloads ADD INDEX top_downloads (num_downloads);


ALTER TABLE cms_download_logging ADD INDEX calculate_bandwidth (date_and_time);


ALTER TABLE cms_edit_pings ADD INDEX edit_pings_on (the_page,the_type,the_id);


ALTER TABLE cms_email_bounces ADD INDEX b_email_address (b_email_address(250));


ALTER TABLE cms_email_bounces ADD INDEX b_time (b_time);


ALTER TABLE cms_failedlogins ADD INDEX failedlogins_by_ip (ip);


ALTER TABLE cms_filedump ADD FULLTEXT description (description(250));


ALTER TABLE cms_f_custom_fields ADD FULLTEXT cf_description (cf_description(250));


ALTER TABLE cms_f_custom_fields ADD FULLTEXT cf_name (cf_name(250));


ALTER TABLE cms_f_emoticons ADD INDEX relevantemoticons (e_relevance_level);


ALTER TABLE cms_f_emoticons ADD INDEX topicemos (e_use_topics);


ALTER TABLE cms_f_forums ADD FULLTEXT f_description (f_description(250));


ALTER TABLE cms_f_forums ADD FULLTEXT f_intro_question (f_intro_question(250));


ALTER TABLE cms_f_forums ADD INDEX cache_num_posts (f_cache_num_posts);


ALTER TABLE cms_f_forums ADD INDEX findnamedforum (f_name(250));


ALTER TABLE cms_f_forums ADD INDEX f_position (f_position);


ALTER TABLE cms_f_forums ADD INDEX subforum_parenting (f_parent_forum);


ALTER TABLE cms_f_groups ADD FULLTEXT groups_search__combined (g_name(250),g_title(250));


ALTER TABLE cms_f_groups ADD FULLTEXT g_name (g_name(250));


ALTER TABLE cms_f_groups ADD FULLTEXT g_title (g_title(250));


ALTER TABLE cms_f_groups ADD INDEX ftjoin_gname (g_name(250));


ALTER TABLE cms_f_groups ADD INDEX ftjoin_gtitle (g_title(250));


ALTER TABLE cms_f_groups ADD INDEX gorder (g_order,id);


ALTER TABLE cms_f_groups ADD INDEX hidden (g_hidden);


ALTER TABLE cms_f_groups ADD INDEX is_default (g_is_default);


ALTER TABLE cms_f_groups ADD INDEX is_presented_at_install (g_is_presented_at_install);


ALTER TABLE cms_f_groups ADD INDEX is_private_club (g_is_private_club);


ALTER TABLE cms_f_groups ADD INDEX is_super_admin (g_is_super_admin);


ALTER TABLE cms_f_groups ADD INDEX is_super_moderator (g_is_super_moderator);


ALTER TABLE cms_f_group_join_log ADD INDEX join_time (join_time);


ALTER TABLE cms_f_group_join_log ADD INDEX member_id (member_id);


ALTER TABLE cms_f_group_join_log ADD INDEX usergroup_id (usergroup_id);


ALTER TABLE cms_f_group_members ADD INDEX gm_group_id (gm_group_id);


ALTER TABLE cms_f_group_members ADD INDEX gm_member_id (gm_member_id);


ALTER TABLE cms_f_group_members ADD INDEX gm_validated (gm_validated);


ALTER TABLE cms_f_members ADD FULLTEXT m_pt_rules_text (m_pt_rules_text(250));


ALTER TABLE cms_f_members ADD FULLTEXT m_signature (m_signature(250));


ALTER TABLE cms_f_members ADD FULLTEXT search_user (m_username);


ALTER TABLE cms_f_members ADD INDEX avatar_url (m_avatar_url(250));


ALTER TABLE cms_f_members ADD INDEX birthdays (m_dob_day,m_dob_month);


ALTER TABLE cms_f_members ADD INDEX external_auth_lookup (m_pass_hash_salted(250));


ALTER TABLE cms_f_members ADD INDEX ftjoin_msig (m_signature(250));


ALTER TABLE cms_f_members ADD INDEX last_visit_time (m_dob_month,m_dob_day,m_last_visit_time);


ALTER TABLE cms_f_members ADD INDEX menail (m_email_address(250));


ALTER TABLE cms_f_members ADD INDEX m_join_time (m_join_time);


ALTER TABLE cms_f_members ADD INDEX primary_group (m_primary_group);


ALTER TABLE cms_f_members ADD INDEX sort_post_count (m_cache_num_posts);


ALTER TABLE cms_f_members ADD INDEX user_list (m_username);


ALTER TABLE cms_f_members ADD INDEX whos_validated (m_validated);


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT field_1 (field_1(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT field_2 (field_2(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT field_4 (field_4(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_17 (field_17(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_18 (field_18(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_19 (field_19(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_21 (field_21(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_22 (field_22(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_23 (field_23(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_24 (field_24(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_25 (field_25(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_26 (field_26(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_28 (field_28(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_29 (field_29(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_3 (field_3(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_30 (field_30(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_31 (field_31(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_32 (field_32(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_33 (field_33(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_34 (field_34(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_35 (field_35(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_36 (field_36(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_5 (field_5(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_6 (field_6(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_7 (field_7(250));


ALTER TABLE cms_f_member_custom_fields ADD FULLTEXT mcf_ft_8 (field_8(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf1 (field_1(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf10 (field_10);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf11 (field_11);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf12 (field_12);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf13 (field_13);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf14 (field_14);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf15 (field_15);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf16 (field_16);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf2 (field_2(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf20 (field_20);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf25 (field_25(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf26 (field_26(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf27 (field_27);


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf29 (field_29(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf3 (field_3(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf30 (field_30(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf31 (field_31(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf32 (field_32(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf34 (field_34(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf35 (field_35(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf36 (field_36(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf4 (field_4(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf5 (field_5(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf6 (field_6(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf7 (field_7(250));


ALTER TABLE cms_f_member_custom_fields ADD INDEX mcf8 (field_8(250));


ALTER TABLE cms_f_multi_moderations ADD FULLTEXT mm_name (mm_name(250));


ALTER TABLE cms_f_password_history ADD INDEX p_member_id (p_member_id);


ALTER TABLE cms_f_posts ADD FULLTEXT posts_search__combined (p_post(250),p_title(250));


ALTER TABLE cms_f_posts ADD FULLTEXT p_post (p_post(250));


ALTER TABLE cms_f_posts ADD FULLTEXT p_title (p_title(250));


ALTER TABLE cms_f_posts ADD INDEX deletebyip (p_ip_address);


ALTER TABLE cms_f_posts ADD INDEX find_pp (p_intended_solely_for);


ALTER TABLE cms_f_posts ADD INDEX in_topic (p_topic_id,p_time,id);


ALTER TABLE cms_f_posts ADD INDEX in_topic_change_order (p_topic_id,p_last_edit_time,p_time,id);


ALTER TABLE cms_f_posts ADD INDEX postsinforum (p_cache_forum_id);


ALTER TABLE cms_f_posts ADD INDEX posts_by (p_poster,p_time);


ALTER TABLE cms_f_posts ADD INDEX posts_by_in_forum (p_poster,p_cache_forum_id);


ALTER TABLE cms_f_posts ADD INDEX posts_by_in_topic (p_poster,p_topic_id);


ALTER TABLE cms_f_posts ADD INDEX posts_since (p_time,p_cache_forum_id);


ALTER TABLE cms_f_posts ADD INDEX post_order_time (p_time,id);


ALTER TABLE cms_f_posts ADD INDEX p_last_edit_time (p_last_edit_time);


ALTER TABLE cms_f_posts ADD INDEX p_validated (p_validated);


ALTER TABLE cms_f_posts ADD INDEX search_join (p_post(250));


ALTER TABLE cms_f_read_logs ADD INDEX erase_old_read_logs (l_time);


ALTER TABLE cms_f_topics ADD FULLTEXT t_cache_first_post (t_cache_first_post(250));


ALTER TABLE cms_f_topics ADD FULLTEXT t_description (t_description(250));


ALTER TABLE cms_f_topics ADD INDEX descriptionsearch (t_description(250));


ALTER TABLE cms_f_topics ADD INDEX forumlayer (t_cache_first_title(250));


ALTER TABLE cms_f_topics ADD INDEX in_forum (t_forum_id);


ALTER TABLE cms_f_topics ADD INDEX ownedtopics (t_cache_first_member_id);


ALTER TABLE cms_f_topics ADD INDEX topic_order (t_cascading,t_pinned,t_cache_last_time);


ALTER TABLE cms_f_topics ADD INDEX topic_order_2 (t_forum_id,t_cascading,t_pinned,t_sunk,t_cache_last_time);


ALTER TABLE cms_f_topics ADD INDEX topic_order_3 (t_forum_id,t_cascading,t_pinned,t_cache_last_time);


ALTER TABLE cms_f_topics ADD INDEX topic_order_time (t_cache_last_time);


ALTER TABLE cms_f_topics ADD INDEX topic_order_time_2 (t_cache_first_time);


ALTER TABLE cms_f_topics ADD INDEX t_cache_first_post_id (t_cache_first_post_id);


ALTER TABLE cms_f_topics ADD INDEX t_cache_last_member_id (t_cache_last_member_id);


ALTER TABLE cms_f_topics ADD INDEX t_cache_last_post_id (t_cache_last_post_id);


ALTER TABLE cms_f_topics ADD INDEX t_cache_num_posts (t_cache_num_posts);


ALTER TABLE cms_f_topics ADD INDEX t_cascading (t_cascading);


ALTER TABLE cms_f_topics ADD INDEX t_cascading_or_forum (t_cascading,t_forum_id);


ALTER TABLE cms_f_topics ADD INDEX t_num_views (t_num_views);


ALTER TABLE cms_f_topics ADD INDEX t_pt_from (t_pt_from);


ALTER TABLE cms_f_topics ADD INDEX t_pt_to (t_pt_to);


ALTER TABLE cms_f_topics ADD INDEX t_validated (t_validated);


ALTER TABLE cms_f_topics ADD INDEX unread_forums (t_forum_id,t_cache_last_time);


ALTER TABLE cms_f_usergroup_subs ADD FULLTEXT s_description (s_description(250));


ALTER TABLE cms_f_usergroup_subs ADD FULLTEXT s_mail_end (s_mail_end(250));


ALTER TABLE cms_f_usergroup_subs ADD FULLTEXT s_mail_start (s_mail_start(250));


ALTER TABLE cms_f_usergroup_subs ADD FULLTEXT s_mail_uhoh (s_mail_uhoh(250));


ALTER TABLE cms_f_usergroup_subs ADD FULLTEXT s_title (s_title(250));


ALTER TABLE cms_f_usergroup_sub_mails ADD FULLTEXT m_body (m_body(250));


ALTER TABLE cms_f_usergroup_sub_mails ADD FULLTEXT m_subject (m_subject(250));


ALTER TABLE cms_f_warnings ADD INDEX warningsmemberid (w_member_id);


ALTER TABLE cms_f_welcome_emails ADD FULLTEXT w_subject (w_subject(250));


ALTER TABLE cms_f_welcome_emails ADD FULLTEXT w_text (w_text(250));


ALTER TABLE cms_galleries ADD FULLTEXT description (description(250));


ALTER TABLE cms_galleries ADD FULLTEXT fullname (fullname(250));


ALTER TABLE cms_galleries ADD FULLTEXT gallery_search__combined (fullname(250),description(250));


ALTER TABLE cms_galleries ADD INDEX ftjoin_gdescrip (description(250));


ALTER TABLE cms_galleries ADD INDEX ftjoin_gfullname (fullname(250));


ALTER TABLE cms_galleries ADD INDEX gadd_date (add_date);


ALTER TABLE cms_galleries ADD INDEX parent_id (parent_id);


ALTER TABLE cms_galleries ADD INDEX watermark_bottom_left (watermark_bottom_left(250));


ALTER TABLE cms_galleries ADD INDEX watermark_bottom_right (watermark_bottom_right(250));


ALTER TABLE cms_galleries ADD INDEX watermark_top_left (watermark_top_left(250));


ALTER TABLE cms_galleries ADD INDEX watermark_top_right (watermark_top_right(250));


ALTER TABLE cms_gifts ADD FULLTEXT reason (reason(250));


ALTER TABLE cms_gifts ADD INDEX giftsgiven (gift_from);


ALTER TABLE cms_gifts ADD INDEX giftsreceived (gift_to);


ALTER TABLE cms_group_page_access ADD INDEX group_id (group_id);


ALTER TABLE cms_group_privileges ADD INDEX group_id (group_id);


ALTER TABLE cms_group_zone_access ADD INDEX group_id (group_id);


ALTER TABLE cms_hackattack ADD INDEX h_date_and_time (date_and_time);


ALTER TABLE cms_hackattack ADD INDEX otherhacksby (ip);


ALTER TABLE cms_images ADD FULLTEXT description (description(250));


ALTER TABLE cms_images ADD FULLTEXT image_search__combined (description(250),title(250));


ALTER TABLE cms_images ADD FULLTEXT title (title(250));


ALTER TABLE cms_images ADD INDEX category_list (cat);


ALTER TABLE cms_images ADD INDEX ftjoin_dtitle (title(250));


ALTER TABLE cms_images ADD INDEX ftjoin_idescription (description(250));


ALTER TABLE cms_images ADD INDEX iadd_date (add_date);


ALTER TABLE cms_images ADD INDEX image_views (image_views);


ALTER TABLE cms_images ADD INDEX i_validated (validated);


ALTER TABLE cms_images ADD INDEX xis (submitter);


ALTER TABLE cms_link_tracker ADD INDEX c_url (c_url(250));


ALTER TABLE cms_logged_mail_messages ADD INDEX combo (m_date_and_time,m_queued);


ALTER TABLE cms_logged_mail_messages ADD INDEX queued (m_queued);


ALTER TABLE cms_logged_mail_messages ADD INDEX recentmessages (m_date_and_time);


ALTER TABLE cms_match_key_messages ADD FULLTEXT k_message (k_message(250));


ALTER TABLE cms_member_category_access ADD INDEX mcamember_id (member_id);


ALTER TABLE cms_member_category_access ADD INDEX mcaname (module_the_name,category_name);


ALTER TABLE cms_member_page_access ADD INDEX mzamember_id (member_id);


ALTER TABLE cms_member_page_access ADD INDEX mzaname (page_name,zone_name);


ALTER TABLE cms_member_privileges ADD INDEX member_privileges_member (member_id);


ALTER TABLE cms_member_privileges ADD INDEX member_privileges_name (privilege,the_page,module_the_name,category_name);


ALTER TABLE cms_member_tracking ADD INDEX mt_id (mt_page,mt_id,mt_type);


ALTER TABLE cms_member_tracking ADD INDEX mt_page (mt_page);


ALTER TABLE cms_member_tracking ADD INDEX mt_time (mt_time);


ALTER TABLE cms_member_zone_access ADD INDEX mzamember_id (member_id);


ALTER TABLE cms_member_zone_access ADD INDEX mzazone_name (zone_name);


ALTER TABLE cms_menu_items ADD FULLTEXT i_caption (i_caption(250));


ALTER TABLE cms_menu_items ADD FULLTEXT i_caption_long (i_caption_long(250));


ALTER TABLE cms_menu_items ADD INDEX menu_extraction (i_menu);


ALTER TABLE cms_messages_to_render ADD INDEX forsession (r_session_id);


ALTER TABLE cms_news ADD FULLTEXT news (news(250));


ALTER TABLE cms_news ADD FULLTEXT news_article (news_article(250));


ALTER TABLE cms_news ADD FULLTEXT news_search__combined (title(250),news(250),news_article(250));


ALTER TABLE cms_news ADD FULLTEXT title (title(250));


ALTER TABLE cms_news ADD INDEX findnewscat (news_category);


ALTER TABLE cms_news ADD INDEX ftjoin_ititle (title(250));


ALTER TABLE cms_news ADD INDEX ftjoin_nnews (news(250));


ALTER TABLE cms_news ADD INDEX ftjoin_nnewsa (news_article(250));


ALTER TABLE cms_news ADD INDEX headlines (date_and_time,id);


ALTER TABLE cms_news ADD INDEX nes (submitter);


ALTER TABLE cms_news ADD INDEX newsauthor (author);


ALTER TABLE cms_news ADD INDEX news_views (news_views);


ALTER TABLE cms_news ADD INDEX nvalidated (validated);


ALTER TABLE cms_newsletters ADD FULLTEXT description (description(250));


ALTER TABLE cms_newsletters ADD FULLTEXT title (title(250));


ALTER TABLE cms_newsletter_drip_send ADD INDEX d_inject_time (d_inject_time);


ALTER TABLE cms_newsletter_drip_send ADD INDEX d_to_email (d_to_email(250));


ALTER TABLE cms_newsletter_subscribe ADD INDEX peopletosendto (the_level);


ALTER TABLE cms_newsletter_subscribers ADD INDEX code_confirm (code_confirm);


ALTER TABLE cms_newsletter_subscribers ADD INDEX welcomemails (join_time);


ALTER TABLE cms_news_categories ADD FULLTEXT nc_title (nc_title(250));


ALTER TABLE cms_news_categories ADD INDEX ncs (nc_owner);


ALTER TABLE cms_news_category_entries ADD INDEX news_entry_category (news_entry_category);


ALTER TABLE cms_notifications_enabled ADD INDEX l_code_category (l_code_category(250));


ALTER TABLE cms_notifications_enabled ADD INDEX l_member_id (l_member_id,l_notification_code);


ALTER TABLE cms_notifications_enabled ADD INDEX l_notification_code (l_notification_code);


ALTER TABLE cms_poll ADD FULLTEXT option1 (option1(250));


ALTER TABLE cms_poll ADD FULLTEXT option10 (option10(250));


ALTER TABLE cms_poll ADD FULLTEXT option2 (option2(250));


ALTER TABLE cms_poll ADD FULLTEXT option3 (option3(250));


ALTER TABLE cms_poll ADD FULLTEXT option4 (option4(250));


ALTER TABLE cms_poll ADD FULLTEXT option5 (option5(250));


ALTER TABLE cms_poll ADD FULLTEXT option6 (option6(250));


ALTER TABLE cms_poll ADD FULLTEXT option7 (option7(250));


ALTER TABLE cms_poll ADD FULLTEXT option8 (option8(250));


ALTER TABLE cms_poll ADD FULLTEXT option9 (option9(250));


ALTER TABLE cms_poll ADD FULLTEXT poll_search__combined (question(250),option1(250),option2(250),option3(250),option4(250),option5(250));


ALTER TABLE cms_poll ADD FULLTEXT question (question(250));


ALTER TABLE cms_poll ADD INDEX date_and_time (date_and_time);


ALTER TABLE cms_poll ADD INDEX ftjoin_po1 (option1(250));


ALTER TABLE cms_poll ADD INDEX ftjoin_po2 (option2(250));


ALTER TABLE cms_poll ADD INDEX ftjoin_po3 (option3(250));


ALTER TABLE cms_poll ADD INDEX ftjoin_po4 (option4(250));


ALTER TABLE cms_poll ADD INDEX ftjoin_po5 (option5(250));


ALTER TABLE cms_poll ADD INDEX ftjoin_pq (question(250));


ALTER TABLE cms_poll ADD INDEX get_current (is_current);


ALTER TABLE cms_poll ADD INDEX padd_time (add_time);


ALTER TABLE cms_poll ADD INDEX poll_views (poll_views);


ALTER TABLE cms_poll ADD INDEX ps (submitter);


ALTER TABLE cms_poll_votes ADD INDEX v_voter_id (v_voter_id);


ALTER TABLE cms_poll_votes ADD INDEX v_voter_ip (v_voter_ip);


ALTER TABLE cms_poll_votes ADD INDEX v_vote_for (v_vote_for);


ALTER TABLE cms_post_tokens ADD INDEX generation_time (generation_time);


ALTER TABLE cms_pstore_customs ADD FULLTEXT c_description (c_description(250));


ALTER TABLE cms_pstore_customs ADD FULLTEXT c_mail_body (c_mail_body(250));


ALTER TABLE cms_pstore_customs ADD FULLTEXT c_mail_subject (c_mail_subject(250));


ALTER TABLE cms_pstore_customs ADD FULLTEXT c_title (c_title(250));


ALTER TABLE cms_pstore_permissions ADD FULLTEXT p_description (p_description(250));


ALTER TABLE cms_pstore_permissions ADD FULLTEXT p_mail_body (p_mail_body(250));


ALTER TABLE cms_pstore_permissions ADD FULLTEXT p_mail_subject (p_mail_subject(250));


ALTER TABLE cms_pstore_permissions ADD FULLTEXT p_title (p_title(250));


ALTER TABLE cms_quizzes ADD FULLTEXT quiz_search__combined (q_start_text(250),q_name(250));


ALTER TABLE cms_quizzes ADD FULLTEXT q_end_text (q_end_text(250));


ALTER TABLE cms_quizzes ADD FULLTEXT q_end_text_fail (q_end_text_fail(250));


ALTER TABLE cms_quizzes ADD FULLTEXT q_name (q_name(250));


ALTER TABLE cms_quizzes ADD FULLTEXT q_start_text (q_start_text(250));


ALTER TABLE cms_quizzes ADD INDEX ftjoin_qstarttext (q_start_text(250));


ALTER TABLE cms_quizzes ADD INDEX q_validated (q_validated);


ALTER TABLE cms_quiz_questions ADD FULLTEXT q_question_extra_text (q_question_extra_text(250));


ALTER TABLE cms_quiz_questions ADD FULLTEXT q_question_text (q_question_text(250));


ALTER TABLE cms_quiz_question_answers ADD FULLTEXT q_answer_text (q_answer_text(250));


ALTER TABLE cms_quiz_question_answers ADD FULLTEXT q_explanation (q_explanation(250));


ALTER TABLE cms_rating ADD INDEX alt_key (rating_for_type,rating_for_id);


ALTER TABLE cms_rating ADD INDEX rating_for_id (rating_for_id);


ALTER TABLE cms_review_supplement ADD INDEX rating_for_id (r_rating_for_id);


ALTER TABLE cms_revisions ADD INDEX actionlog_link (r_actionlog_id);


ALTER TABLE cms_revisions ADD INDEX lookup_by_cat (r_resource_type,r_category_id);


ALTER TABLE cms_revisions ADD INDEX lookup_by_id (r_resource_type,r_resource_id);


ALTER TABLE cms_revisions ADD INDEX moderatorlog_link (r_moderatorlog_id);


ALTER TABLE cms_searches_logged ADD FULLTEXT past_search_ft (s_primary(250));


ALTER TABLE cms_searches_logged ADD INDEX past_search (s_primary(250));


ALTER TABLE cms_seo_meta ADD FULLTEXT meta_description (meta_description(250));


ALTER TABLE cms_seo_meta ADD INDEX alt_key (meta_for_type,meta_for_id);


ALTER TABLE cms_seo_meta ADD INDEX ftjoin_dmeta_description (meta_description(250));


ALTER TABLE cms_seo_meta_keywords ADD FULLTEXT meta_keyword (meta_keyword(250));


ALTER TABLE cms_seo_meta_keywords ADD INDEX ftjoin_dmeta_keywords (meta_keyword(250));


ALTER TABLE cms_seo_meta_keywords ADD INDEX keywords_alt_key (meta_for_type,meta_for_id);


ALTER TABLE cms_sessions ADD INDEX delete_old (last_activity);


ALTER TABLE cms_sessions ADD INDEX member_id (member_id);


ALTER TABLE cms_sessions ADD INDEX userat (the_zone,the_page,the_id);


ALTER TABLE cms_shopping_cart ADD INDEX ordered_by (ordered_by);


ALTER TABLE cms_shopping_cart ADD INDEX product_id (product_id);


ALTER TABLE cms_shopping_cart ADD INDEX session_id (session_id);


ALTER TABLE cms_shopping_logging ADD INDEX calculate_bandwidth (date_and_time);


ALTER TABLE cms_shopping_order ADD INDEX finddispatchable (order_status);


ALTER TABLE cms_shopping_order ADD INDEX soadd_date (add_date);


ALTER TABLE cms_shopping_order ADD INDEX soc_member (c_member);


ALTER TABLE cms_shopping_order ADD INDEX sosession_id (session_id);


ALTER TABLE cms_shopping_order_addresses ADD INDEX order_id (order_id);


ALTER TABLE cms_shopping_order_details ADD INDEX order_id (order_id);


ALTER TABLE cms_shopping_order_details ADD INDEX p_id (p_id);


ALTER TABLE cms_sitemap_cache ADD INDEX is_deleted (is_deleted);


ALTER TABLE cms_sitemap_cache ADD INDEX last_updated (last_updated);


ALTER TABLE cms_sitemap_cache ADD INDEX set_number (set_number,last_updated);


ALTER TABLE cms_sms_log ADD INDEX sms_log_for (s_member_id,s_time);


ALTER TABLE cms_sms_log ADD INDEX sms_trigger_ip (s_trigger_ip);


ALTER TABLE cms_stats ADD INDEX browser (browser(250));


ALTER TABLE cms_stats ADD INDEX date_and_time (date_and_time);


ALTER TABLE cms_stats ADD INDEX member_track_1 (member_id);


ALTER TABLE cms_stats ADD INDEX member_track_2 (ip);


ALTER TABLE cms_stats ADD INDEX member_track_3 (member_id,date_and_time);


ALTER TABLE cms_stats ADD INDEX member_track_4 (session_id);


ALTER TABLE cms_stats ADD INDEX milliseconds (milliseconds);


ALTER TABLE cms_stats ADD INDEX operating_system (operating_system(250));


ALTER TABLE cms_stats ADD INDEX pages (the_page(250));


ALTER TABLE cms_stats ADD INDEX referer (referer(250));


ALTER TABLE cms_theme_images ADD INDEX theme (theme,lang);


ALTER TABLE cms_ticket_types ADD FULLTEXT ticket_type_name (ticket_type_name(250));


ALTER TABLE cms_trackbacks ADD INDEX trackback_for_id (trackback_for_id);


ALTER TABLE cms_trackbacks ADD INDEX trackback_for_type (trackback_for_type);


ALTER TABLE cms_trackbacks ADD INDEX trackback_time (trackback_time);


ALTER TABLE cms_translate ADD FULLTEXT tsearch (text_original(250));


ALTER TABLE cms_translate ADD INDEX decache (text_parsed(2));


ALTER TABLE cms_translate ADD INDEX equiv_lang (text_original(4));


ALTER TABLE cms_translate ADD INDEX importance_level (importance_level);


ALTER TABLE cms_urls_checked ADD INDEX url (url(200));


ALTER TABLE cms_url_id_monikers ADD INDEX uim_moniker (m_moniker(250));


ALTER TABLE cms_url_id_monikers ADD INDEX uim_monrev (m_moniker_reversed(250));


ALTER TABLE cms_url_id_monikers ADD INDEX uim_page_link (m_resource_page,m_resource_type,m_resource_id);


ALTER TABLE cms_url_title_cache ADD INDEX t_url (t_url(250));


ALTER TABLE cms_usersonline_track ADD INDEX peak_track (peak);


ALTER TABLE cms_values ADD INDEX date_and_time (date_and_time);


ALTER TABLE cms_videos ADD FULLTEXT description (description(250));


ALTER TABLE cms_videos ADD FULLTEXT title (title(250));


ALTER TABLE cms_videos ADD FULLTEXT video_search__combined (description(250),title(250));


ALTER TABLE cms_videos ADD INDEX category_list (cat);


ALTER TABLE cms_videos ADD INDEX ftjoin_dtitle (title(250));


ALTER TABLE cms_videos ADD INDEX ftjoin_vdescription (description(250));


ALTER TABLE cms_videos ADD INDEX vadd_date (add_date);


ALTER TABLE cms_videos ADD INDEX video_views (video_views);


ALTER TABLE cms_videos ADD INDEX vs (submitter);


ALTER TABLE cms_videos ADD INDEX v_validated (validated);


ALTER TABLE cms_video_transcoding ADD INDEX t_local_id (t_local_id);


ALTER TABLE cms_wiki_pages ADD FULLTEXT description (description(250));


ALTER TABLE cms_wiki_pages ADD FULLTEXT title (title(250));


ALTER TABLE cms_wiki_pages ADD FULLTEXT wiki_search__combined (title(250),description(250));


ALTER TABLE cms_wiki_pages ADD INDEX ftjoin_spd (description(250));


ALTER TABLE cms_wiki_pages ADD INDEX ftjoin_spt (title(250));


ALTER TABLE cms_wiki_pages ADD INDEX sadd_date (add_date);


ALTER TABLE cms_wiki_pages ADD INDEX sps (submitter);


ALTER TABLE cms_wiki_pages ADD INDEX wiki_views (wiki_views);


ALTER TABLE cms_wiki_posts ADD FULLTEXT the_message (the_message(250));


ALTER TABLE cms_wiki_posts ADD INDEX cdate_and_time (date_and_time);


ALTER TABLE cms_wiki_posts ADD INDEX ftjoin_spm (the_message(250));


ALTER TABLE cms_wiki_posts ADD INDEX posts_on_page (page_id);


ALTER TABLE cms_wiki_posts ADD INDEX spos (member_id);


ALTER TABLE cms_wiki_posts ADD INDEX svalidated (validated);


ALTER TABLE cms_wiki_posts ADD INDEX wiki_views (wiki_views);


ALTER TABLE cms_zones ADD FULLTEXT zone_header_text (zone_header_text(250));


ALTER TABLE cms_zones ADD FULLTEXT zone_title (zone_title(250));


