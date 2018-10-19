DROP TABLE IF EXISTS cms_f_polls;

CREATE TABLE cms_f_polls (
    id integer unsigned auto_increment NOT NULL,
    po_question varchar(255) NOT NULL,
    po_cache_total_votes integer NOT NULL,
    po_is_private tinyint(1) NOT NULL,
    po_is_open tinyint(1) NOT NULL,
    po_minimum_selections integer NOT NULL,
    po_maximum_selections integer NOT NULL,
    po_requires_reply tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_post_templates;

CREATE TABLE cms_f_post_templates (
    id integer unsigned auto_increment NOT NULL,
    t_title varchar(255) NOT NULL,
    t_text longtext NOT NULL,
    t_forum_multi_code varchar(255) NOT NULL,
    t_use_default_forums tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_post_templates (id, t_title, t_text, t_forum_multi_code, t_use_default_forums) VALUES (1, 'Bug report', 'Version: ?
Support software environment (operating system, etc.):
?

Assigned to: ?
Severity: ?
Example URL: ?
Description:
?

Steps for reproduction:
?

', '', 0);
INSERT INTO cms_f_post_templates (id, t_title, t_text, t_forum_multi_code, t_use_default_forums) VALUES (2, 'Task', 'Assigned to: ?
Priority/Timescale: ?
Description:
?

', '', 0);
INSERT INTO cms_f_post_templates (id, t_title, t_text, t_forum_multi_code, t_use_default_forums) VALUES (3, 'Fault', 'Version: ?
Assigned to: ?
Severity/Timescale: ?
Description:
?

Steps for reproduction:
?

', '', 0);

DROP TABLE IF EXISTS cms_f_posts;

CREATE TABLE cms_f_posts (
    id integer unsigned auto_increment NOT NULL,
    p_title varchar(255) NOT NULL,
    p_post longtext NOT NULL,
    p_ip_address varchar(40) NOT NULL,
    p_time integer unsigned NOT NULL,
    p_poster integer NOT NULL,
    p_intended_solely_for integer NULL,
    p_poster_name_if_guest varchar(80) NOT NULL,
    p_validated tinyint(1) NOT NULL,
    p_topic_id integer NOT NULL,
    p_cache_forum_id integer NULL,
    p_last_edit_time integer unsigned NULL,
    p_last_edit_by integer NULL,
    p_is_emphasised tinyint(1) NOT NULL,
    p_skip_sig tinyint(1) NOT NULL,
    p_parent_id integer NULL,
    p_post__text_parsed longtext NOT NULL,
    p_post__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_posts (id, p_title, p_post, p_ip_address, p_time, p_poster, p_intended_solely_for, p_poster_name_if_guest, p_validated, p_topic_id, p_cache_forum_id, p_last_edit_time, p_last_edit_by, p_is_emphasised, p_skip_sig, p_parent_id, p_post__text_parsed, p_post__source_user) VALUES (1, 'Welcome to the forums', 'This is the inbuilt forum system (known as Conversr).

A forum system is a tool for communication between members; it consists of posts, organised into topics: each topic is a line of conversation.

Composr provides support for a number of different forum systems, and each forum handles authentication of members: Conversr is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.', '127.0.0.1', 1539966279, 1, NULL, 'System', 1, 1, 7, NULL, NULL, 0, 0, NULL, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:7:{i:0;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_1\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:1;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_2\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:2;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_3\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:3;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_4\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:4;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_5\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:5;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_6\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:6;a:5:{i:0;s:39:\\\"string_attach_5bca0547819cd7.66481444_7\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:7:\\\"(mixed)\\\";i:3;N;i:4;a:7:{s:39:\\\"string_attach_5bca0547819cd7.66481444_1\\\";s:121:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_1\']=\\\"echo \\\\\\\"This is the inbuilt forum system (known as Conversr).\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5bca0547819cd7.66481444_2\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_2\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5bca0547819cd7.66481444_3\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_3\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5bca0547819cd7.66481444_4\\\";s:210:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_4\']=\\\"echo \\\\\\\"A forum system is a tool for communication between members; it consists of posts, organised into topics: each topic is a line of conversation.\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5bca0547819cd7.66481444_5\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_5\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5bca0547819cd7.66481444_6\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_6\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5bca0547819cd7.66481444_7\\\";s:329:\\\"\\$tpl_funcs[\'string_attach_5bca0547819cd7.66481444_7\']=\\\"echo \\\\\\\"Composr provides support for a number of different forum systems, and each forum handles authentication of members: Conversr is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.\\\\\\\";\\\";\\n\\\";}}\");
', 1);

ALTER TABLE cms101_f_posts ADD FULLTEXT posts_search__combined (p_post,p_title);

ALTER TABLE cms101_f_posts ADD FULLTEXT p_post (p_post);

ALTER TABLE cms101_f_posts ADD FULLTEXT p_title (p_title);

ALTER TABLE cms101_f_posts ADD INDEX deletebyip (p_ip_address);

ALTER TABLE cms101_f_posts ADD INDEX find_pp (p_intended_solely_for);

ALTER TABLE cms101_f_posts ADD INDEX in_topic (p_topic_id,p_time,id);

ALTER TABLE cms101_f_posts ADD INDEX in_topic_change_order (p_topic_id,p_last_edit_time,p_time,id);

ALTER TABLE cms101_f_posts ADD INDEX postsinforum (p_cache_forum_id);

ALTER TABLE cms101_f_posts ADD INDEX posts_by (p_poster,p_time);

ALTER TABLE cms101_f_posts ADD INDEX posts_by_in_forum (p_poster,p_cache_forum_id);

ALTER TABLE cms101_f_posts ADD INDEX posts_by_in_topic (p_poster,p_topic_id);

ALTER TABLE cms101_f_posts ADD INDEX posts_since (p_time,p_cache_forum_id);

ALTER TABLE cms101_f_posts ADD INDEX post_order_time (p_time,id);

ALTER TABLE cms101_f_posts ADD INDEX p_last_edit_time (p_last_edit_time);

ALTER TABLE cms101_f_posts ADD INDEX p_validated (p_validated);

ALTER TABLE cms101_f_posts ADD INDEX search_join (p_post(250));

DROP TABLE IF EXISTS cms_f_read_logs;

CREATE TABLE cms_f_read_logs (
    l_member_id integer NOT NULL,
    l_topic_id integer NOT NULL,
    l_time integer unsigned NOT NULL,
    PRIMARY KEY (l_member_id, l_topic_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_f_read_logs ADD INDEX erase_old_read_logs (l_time);

DROP TABLE IF EXISTS cms_f_saved_warnings;

CREATE TABLE cms_f_saved_warnings (
    s_title varchar(255) NOT NULL,
    s_explanation longtext NOT NULL,
    s_message longtext NOT NULL,
    PRIMARY KEY (s_title)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_special_pt_access;

CREATE TABLE cms_f_special_pt_access (
    s_member_id integer NOT NULL,
    s_topic_id integer NOT NULL,
    PRIMARY KEY (s_member_id, s_topic_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_f_topics;

CREATE TABLE cms_f_topics (
    id integer unsigned auto_increment NOT NULL,
    t_pinned tinyint(1) NOT NULL,
    t_sunk tinyint(1) NOT NULL,
    t_cascading tinyint(1) NOT NULL,
    t_forum_id integer NULL,
    t_pt_from integer NULL,
    t_pt_to integer NULL,
    t_pt_from_category varchar(255) NOT NULL,
    t_pt_to_category varchar(255) NOT NULL,
    t_description varchar(255) NOT NULL,
    t_description_link varchar(255) NOT NULL,
    t_emoticon varchar(255) NOT NULL,
    t_num_views integer NOT NULL,
    t_validated tinyint(1) NOT NULL,
    t_is_open tinyint(1) NOT NULL,
    t_poll_id integer NULL,
    t_cache_first_post_id integer NULL,
    t_cache_first_time integer unsigned NULL,
    t_cache_first_title varchar(255) NOT NULL,
    t_cache_first_post longtext NOT NULL,
    t_cache_first_username varchar(80) NOT NULL,
    t_cache_first_member_id integer NULL,
    t_cache_last_post_id integer NULL,
    t_cache_last_time integer unsigned NULL,
    t_cache_last_title varchar(255) NOT NULL,
    t_cache_last_username varchar(80) NOT NULL,
    t_cache_last_member_id integer NULL,
    t_cache_num_posts integer NOT NULL,
    t_cache_first_post__text_parsed longtext NOT NULL,
    t_cache_first_post__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_f_topics (id, t_pinned, t_sunk, t_cascading, t_forum_id, t_pt_from, t_pt_to, t_pt_from_category, t_pt_to_category, t_description, t_description_link, t_emoticon, t_num_views, t_validated, t_is_open, t_poll_id, t_cache_first_post_id, t_cache_first_time, t_cache_first_title, t_cache_first_post, t_cache_first_username, t_cache_first_member_id, t_cache_last_post_id, t_cache_last_time, t_cache_last_title, t_cache_last_username, t_cache_last_member_id, t_cache_num_posts, t_cache_first_post__text_parsed, t_cache_first_post__source_user) VALUES (1, 0, 0, 0, 7, NULL, NULL, '', '', '', '', '', 0, 1, 1, NULL, 1, 1539966279, 'Welcome to the forums', '', 'System', 1, 1, 1539966279, 'Welcome to the forums', 'System', 1, 1, '', 1);

ALTER TABLE cms101_f_topics ADD FULLTEXT t_cache_first_post (t_cache_first_post);

ALTER TABLE cms101_f_topics ADD FULLTEXT t_description (t_description);

ALTER TABLE cms101_f_topics ADD INDEX descriptionsearch (t_description(250));

ALTER TABLE cms101_f_topics ADD INDEX forumlayer (t_cache_first_title(250));

ALTER TABLE cms101_f_topics ADD INDEX in_forum (t_forum_id);

ALTER TABLE cms101_f_topics ADD INDEX ownedtopics (t_cache_first_member_id);

ALTER TABLE cms101_f_topics ADD INDEX topic_order (t_cascading,t_pinned,t_cache_last_time);

ALTER TABLE cms101_f_topics ADD INDEX topic_order_2 (t_forum_id,t_cascading,t_pinned,t_sunk,t_cache_last_time);

ALTER TABLE cms101_f_topics ADD INDEX topic_order_3 (t_forum_id,t_cascading,t_pinned,t_cache_last_time);

ALTER TABLE cms101_f_topics ADD INDEX topic_order_time (t_cache_last_time);

ALTER TABLE cms101_f_topics ADD INDEX topic_order_time_2 (t_cache_first_time);

ALTER TABLE cms101_f_topics ADD INDEX t_cache_first_post_id (t_cache_first_post_id);

ALTER TABLE cms101_f_topics ADD INDEX t_cache_last_member_id (t_cache_last_member_id);

ALTER TABLE cms101_f_topics ADD INDEX t_cache_last_post_id (t_cache_last_post_id);

ALTER TABLE cms101_f_topics ADD INDEX t_cache_num_posts (t_cache_num_posts);

ALTER TABLE cms101_f_topics ADD INDEX t_cascading (t_cascading);

ALTER TABLE cms101_f_topics ADD INDEX t_cascading_or_forum (t_cascading,t_forum_id);

ALTER TABLE cms101_f_topics ADD INDEX t_num_views (t_num_views);

ALTER TABLE cms101_f_topics ADD INDEX t_pt_from (t_pt_from);

ALTER TABLE cms101_f_topics ADD INDEX t_pt_to (t_pt_to);

ALTER TABLE cms101_f_topics ADD INDEX t_validated (t_validated);

ALTER TABLE cms101_f_topics ADD INDEX unread_forums (t_forum_id,t_cache_last_time);

DROP TABLE IF EXISTS cms_f_usergroup_sub_mails;

CREATE TABLE cms_f_usergroup_sub_mails (
    id integer unsigned auto_increment NOT NULL,
    m_usergroup_sub_id integer NOT NULL,
    m_ref_point varchar(80) NOT NULL,
    m_ref_point_offset integer NOT NULL,
    m_subject longtext NOT NULL,
    m_body longtext NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_f_usergroup_sub_mails ADD FULLTEXT m_body (m_body);

ALTER TABLE cms101_f_usergroup_sub_mails ADD FULLTEXT m_subject (m_subject);

DROP TABLE IF EXISTS cms_f_usergroup_subs;

CREATE TABLE cms_f_usergroup_subs (
    id integer unsigned auto_increment NOT NULL,
    s_title longtext NOT NULL,
    s_description longtext NOT NULL,
    s_price real NOT NULL,
    s_tax_code varchar(80) NOT NULL,
    s_length integer NOT NULL,
    s_length_units varchar(255) NOT NULL,
    s_auto_recur tinyint(1) NOT NULL,
    s_group_id integer NOT NULL,
    s_enabled tinyint(1) NOT NULL,
    s_mail_start longtext NOT NULL,
    s_mail_end longtext NOT NULL,
    s_mail_uhoh longtext NOT NULL,
    s_uses_primary tinyint(1) NOT NULL,
    s_description__text_parsed longtext NOT NULL,
    s_description__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_f_usergroup_subs ADD FULLTEXT s_description (s_description);

ALTER TABLE cms101_f_usergroup_subs ADD FULLTEXT s_mail_end (s_mail_end);

ALTER TABLE cms101_f_usergroup_subs ADD FULLTEXT s_mail_start (s_mail_start);

ALTER TABLE cms101_f_usergroup_subs ADD FULLTEXT s_mail_uhoh (s_mail_uhoh);

ALTER TABLE cms101_f_usergroup_subs ADD FULLTEXT s_title (s_title);

DROP TABLE IF EXISTS cms_f_warnings;

CREATE TABLE cms_f_warnings (
    id integer unsigned auto_increment NOT NULL,
    w_member_id integer NOT NULL,
    w_time integer unsigned NOT NULL,
    w_explanation longtext NOT NULL,
    w_by integer NOT NULL,
    w_is_warning tinyint(1) NOT NULL,
    p_silence_from_topic integer NULL,
    p_silence_from_forum integer NULL,
    p_probation integer NOT NULL,
    p_banned_ip varchar(40) NOT NULL,
    p_charged_points integer NOT NULL,
    p_banned_member tinyint(1) NOT NULL,
    p_changed_usergroup_from integer NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_f_warnings ADD INDEX warningsmemberid (w_member_id);

DROP TABLE IF EXISTS cms_f_welcome_emails;

CREATE TABLE cms_f_welcome_emails (
    id integer unsigned auto_increment NOT NULL,
    w_name varchar(255) NOT NULL,
    w_subject longtext NOT NULL,
    w_text longtext NOT NULL,
    w_send_time integer NOT NULL,
    w_newsletter integer NULL,
    w_usergroup integer NULL,
    w_usergroup_type varchar(80) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_f_welcome_emails ADD FULLTEXT w_subject (w_subject);

ALTER TABLE cms101_f_welcome_emails ADD FULLTEXT w_text (w_text);

DROP TABLE IF EXISTS cms_failedlogins;

CREATE TABLE cms_failedlogins (
    id integer unsigned auto_increment NOT NULL,
    failed_account varchar(80) NOT NULL,
    date_and_time integer unsigned NOT NULL,
    ip varchar(40) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_failedlogins ADD INDEX failedlogins_by_ip (ip);

DROP TABLE IF EXISTS cms_feature_lifetime_monitor;

CREATE TABLE cms_feature_lifetime_monitor (
    content_id varchar(80) NOT NULL,
    block_cache_id varchar(80) NOT NULL,
    run_period integer NOT NULL,
    running_now tinyint(1) NOT NULL,
    last_update integer unsigned NOT NULL,
    PRIMARY KEY (content_id, block_cache_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_filedump;

CREATE TABLE cms_filedump (
    id integer unsigned auto_increment NOT NULL,
    name varchar(80) NOT NULL,
    path varchar(255) BINARY NOT NULL,
    description longtext NOT NULL,
    the_member integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_filedump ADD FULLTEXT description (description);

DROP TABLE IF EXISTS cms_galleries;

CREATE TABLE cms_galleries (
    name varchar(80) NOT NULL,
    description longtext NOT NULL,
    fullname longtext NOT NULL,
    add_date integer unsigned NOT NULL,
    rep_image varchar(255) BINARY NOT NULL,
    parent_id varchar(80) NOT NULL,
    watermark_top_left varchar(255) BINARY NOT NULL,
    watermark_top_right varchar(255) BINARY NOT NULL,
    watermark_bottom_left varchar(255) BINARY NOT NULL,
    watermark_bottom_right varchar(255) BINARY NOT NULL,
    accept_images tinyint(1) NOT NULL,
    accept_videos tinyint(1) NOT NULL,
    allow_rating tinyint(1) NOT NULL,
    allow_comments tinyint NOT NULL,
    notes longtext NOT NULL,
    is_member_synched tinyint(1) NOT NULL,
    flow_mode_interface tinyint(1) NOT NULL,
    gallery_views integer NOT NULL,
    g_owner integer NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    fullname__text_parsed longtext NOT NULL,
    fullname__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_galleries (name, description, fullname, add_date, rep_image, parent_id, watermark_top_left, watermark_top_right, watermark_bottom_left, watermark_bottom_right, accept_images, accept_videos, allow_rating, allow_comments, notes, is_member_synched, flow_mode_interface, gallery_views, g_owner, description__text_parsed, description__source_user, fullname__text_parsed, fullname__source_user) VALUES ('root', '', 'Galleries home', 1539966292, '', '', '', '', '', '', 1, 1, 1, 1, '', 0, 1, 0, NULL, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5bca0551747996.36079818_22\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5bca0551747996.36079818_22\\\";s:69:\\\"\\$tpl_funcs[\'string_attach_5bca0551747996.36079818_22\']=\\\"echo \\\\\\\"\\\\\\\";\\\";\\n\\\";}}\");
', 1, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:1:{i:0;a:5:{i:0;s:40:\\\"string_attach_5bca0551747996.36079818_23\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:10:\\\":container\\\";i:3;N;i:4;a:1:{s:40:\\\"string_attach_5bca0551747996.36079818_23\\\";s:83:\\\"\\$tpl_funcs[\'string_attach_5bca0551747996.36079818_23\']=\\\"echo \\\\\\\"Galleries home\\\\\\\";\\\";\\n\\\";}}\");
', 1);

ALTER TABLE cms101_galleries ADD FULLTEXT description (description);

ALTER TABLE cms101_galleries ADD FULLTEXT fullname (fullname);

ALTER TABLE cms101_galleries ADD FULLTEXT gallery_search__combined (fullname,description);

ALTER TABLE cms101_galleries ADD INDEX ftjoin_gdescrip (description(250));

ALTER TABLE cms101_galleries ADD INDEX ftjoin_gfullname (fullname(250));

ALTER TABLE cms101_galleries ADD INDEX gadd_date (add_date);

ALTER TABLE cms101_galleries ADD INDEX parent_id (parent_id);

ALTER TABLE cms101_galleries ADD INDEX watermark_bottom_left (watermark_bottom_left(250));

ALTER TABLE cms101_galleries ADD INDEX watermark_bottom_right (watermark_bottom_right(250));

ALTER TABLE cms101_galleries ADD INDEX watermark_top_left (watermark_top_left(250));

ALTER TABLE cms101_galleries ADD INDEX watermark_top_right (watermark_top_right(250));

DROP TABLE IF EXISTS cms_gifts;

CREATE TABLE cms_gifts (
    id integer unsigned auto_increment NOT NULL,
    date_and_time integer unsigned NOT NULL,
    amount integer NOT NULL,
    gift_from integer NOT NULL,
    gift_to integer NOT NULL,
    reason longtext NOT NULL,
    anonymous tinyint(1) NOT NULL,
    reason__text_parsed longtext NOT NULL,
    reason__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_gifts ADD FULLTEXT reason (reason);

ALTER TABLE cms101_gifts ADD INDEX giftsgiven (gift_from);

ALTER TABLE cms101_gifts ADD INDEX giftsreceived (gift_to);

DROP TABLE IF EXISTS cms_group_category_access;

CREATE TABLE cms_group_category_access (
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    group_id integer NOT NULL,
    PRIMARY KEY (module_the_name, category_name, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'advertise_here', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('banners', 'donate', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '2', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '3', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '4', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '5', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '6', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '7', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('calendar', '8', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'faqs', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'links', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'products', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_catalogue', 'projects', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '1', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '2', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '3', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('catalogues_category', '5', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('chat', '1', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('downloads', '1', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '1', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '2', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '3', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '3', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '4', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '4', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '5', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '6', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '6', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '7', 2);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '7', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('forums', '8', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('galleries', 'root', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '1', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '2', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '3', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '4', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '5', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '6', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('news', '7', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '1', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('tickets', '2', 10);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 1);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 3);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 4);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 5);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 6);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 7);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 8);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 9);
INSERT INTO cms_group_category_access (module_the_name, category_name, group_id) VALUES ('wiki_page', '1', 10);

DROP TABLE IF EXISTS cms_group_page_access;

CREATE TABLE cms_group_page_access (
    page_name varchar(80) NOT NULL,
    zone_name varchar(80) NOT NULL,
    group_id integer NOT NULL,
    PRIMARY KEY (page_name, zone_name, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_addons', 'adminzone', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_commandr', 'adminzone', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_email_log', 'adminzone', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_import', 'adminzone', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_redirects', 'adminzone', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('admin_staff', 'adminzone', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('cms_chat', 'cms', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('contact_member', 'site', 10);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 1);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 2);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 3);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 4);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 5);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 6);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 7);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 8);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 9);
INSERT INTO cms_group_page_access (page_name, zone_name, group_id) VALUES ('filedump', 'cms', 10);

ALTER TABLE cms101_group_page_access ADD INDEX group_id (group_id);

DROP TABLE IF EXISTS cms_group_privileges;

CREATE TABLE cms_group_privileges (
    group_id integer NOT NULL,
    privilege varchar(80) NOT NULL,
    the_page varchar(80) NOT NULL,
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    the_value tinyint(1) NOT NULL,
    PRIMARY KEY (group_id, privilege, the_page, module_the_name, category_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'submit_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'submit_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'submit_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'submit_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'submit_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'search_engine_links', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'submit_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'can_submit_to_others_categories', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'search_engine_links', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'can_submit_to_others_categories', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_own_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_own_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_own_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_own_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_own_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_own_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'feature', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'access_overrun_site', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'feature', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_profiling_modes', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'access_overrun_site', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_stack_dump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_profiling_modes', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_php_errors', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'see_stack_dump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_bandwidth_restriction', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'see_php_errors', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'access_closed_site', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_bandwidth_restriction', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_very_dangerous_comcode', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'access_closed_site', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'comcode_nuisance', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'use_very_dangerous_comcode', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'comcode_dangerous', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'comcode_nuisance', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'allow_html', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'allow_html', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'comcode_dangerous', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'run_multi_moderations', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'use_pt', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'edit_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'may_unblind_own_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'may_report_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'view_member_photos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'use_quick_reply', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'view_profiles', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'own_avatars', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'double_post', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'delete_account', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'rename_self', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_special_emoticons', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_any_profile_field', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'disable_lost_passwords', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'close_own_topics', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_warnings', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_ip', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'may_choose_custom_title', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_poll_results_before_voting', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'moderate_private_topic', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'member_maintenance', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'probate_members', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'warn_members', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'control_usergroups', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'multi_delete_topics', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'show_user_browsing', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_hidden_groups', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'pt_anyone', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_private_topic_posts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'exceed_post_edit_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'exceed_post_delete_time_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_required_cpfs', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_required_cpfs_if_already_empty', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_email_address', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_email_address_if_already_empty', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_dob', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_dob_if_already_empty', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_meta_fields', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_meta_fields', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'perform_webstandards_check_by_default', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'perform_webstandards_check_by_default', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_own_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_own_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_own_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_own_cat_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_own_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_own_cat_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_own_cat_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'mass_import', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'mass_import', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'scheduled_publication_times', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'scheduled_publication_times', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'mass_delete_from_ip', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'mass_delete_from_ip', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'exceed_filesize_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'exceed_filesize_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'draw_to_server', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'draw_to_server', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'open_virtual_roots', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'open_virtual_roots', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'sees_javascript_error_alerts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'sees_javascript_error_alerts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'see_software_docs', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_software_docs', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'see_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'see_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'may_enable_staff_notifications', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'may_enable_staff_notifications', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_flood_control', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_flood_control', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'remove_page_split', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'remove_page_split', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_wordfilter', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_wordfilter', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'perform_keyword_check', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'perform_keyword_check', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'have_personal_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'have_personal_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'edit_own_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'submit_highrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'submit_midrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'submit_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'bypass_validation_lowrange_content', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'rate', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'comment', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'vote_in_polls', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'jump_to_unvalidated', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'reuse_others_attachments', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'unfiltered_input', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'unfiltered_input', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'set_content_review_settings', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'set_content_review_settings', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '8', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '8', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_revisions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_revisions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'undo_revisions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'undo_revisions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_revisions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_revisions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'use_sms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_sms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'sms_higher_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'sms_higher_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'sms_higher_trigger_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'sms_higher_trigger_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'set_own_author_profile', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'set_own_author_profile', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'full_banner_setup', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'full_banner_setup', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_anyones_banner_stats', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_anyones_banner_stats', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'banner_free', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'banner_free', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'use_html_banner', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_html_banner', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'view_calendar', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'add_public_events', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'sense_personal_conflicts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'sense_personal_conflicts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_event_subscriptions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_event_subscriptions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'calendar_add_to_others', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_event', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_event', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_event', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_event', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'high_catalogue_entry_timeout', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'high_catalogue_entry_timeout', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_catalogue_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_catalogue_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_catalogue_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_catalogue_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'create_private_room', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'start_im', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'moderate_my_private_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'ban_chatters_from_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'ban_chatters_from_rooms', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_download_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_download_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_download_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_download_category', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_download', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'may_download_gallery', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'may_download_gallery', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'high_personal_gallery_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'high_personal_gallery_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'no_personal_gallery_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'no_personal_gallery_limit', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_gallery', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_gallery', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_gallery', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_gallery', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_image', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_image', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_image', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_image', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_videos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_videos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_videos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_videos', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_news', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_news', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_news', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_news', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'change_newsletter_subscriptions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'change_newsletter_subscriptions', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'use_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'trace_anonymous_gifts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'trace_anonymous_gifts', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'give_points_self', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'give_points_self', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'have_negative_gift_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'have_negative_gift_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'give_negative_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'give_negative_points', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_charge_log', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_charge_log', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'choose_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'choose_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_poll', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'access_ecommerce_in_test_mode', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'access_ecommerce_in_test_mode', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_quiz_repeat_time_restriction', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_quiz_repeat_time_restriction', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_others_quiz_results', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_others_quiz_results', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_quiz_timer', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_quiz_timer', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_quiz', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_quiz', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_quiz', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_quiz', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_past_search', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_past_search', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_keyword_comcode_page', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_keyword_comcode_page', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'autocomplete_title_comcode_page', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'autocomplete_title_comcode_page', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'view_others_tickets', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'view_others_tickets', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'support_operator', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'support_operator', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'wiki_manage_tree', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'wiki_manage_tree', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'upload_anything_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'upload_anything_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'upload_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'delete_anything_filedump', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'delete_anything_filedump', '', '', '', 1);

ALTER TABLE cms101_group_privileges ADD INDEX group_id (group_id);

DROP TABLE IF EXISTS cms_group_zone_access;

CREATE TABLE cms_group_zone_access (
    zone_name varchar(80) NOT NULL,
    group_id integer NOT NULL,
    PRIMARY KEY (zone_name, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 1);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 2);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 3);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 4);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 5);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 6);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 7);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 8);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 9);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('', 10);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('adminzone', 2);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('adminzone', 3);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 2);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 3);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 4);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 5);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 6);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 7);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 8);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 9);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('cms', 10);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('collaboration', 2);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('collaboration', 3);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('collaboration', 4);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 1);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 2);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 3);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 4);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 5);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 6);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 7);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 8);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 9);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('forum', 10);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 2);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 3);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 4);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 5);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 6);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 7);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 8);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 9);
INSERT INTO cms_group_zone_access (zone_name, group_id) VALUES ('site', 10);

ALTER TABLE cms101_group_zone_access ADD INDEX group_id (group_id);

DROP TABLE IF EXISTS cms_hackattack;

CREATE TABLE cms_hackattack (
    id integer unsigned auto_increment NOT NULL,
    url varchar(255) BINARY NOT NULL,
    data_post longtext NOT NULL,
    user_agent varchar(255) NOT NULL,
    referer varchar(255) NOT NULL,
    user_os varchar(255) NOT NULL,
    member_id integer NOT NULL,
    date_and_time integer unsigned NOT NULL,
    ip varchar(40) NOT NULL,
    reason varchar(80) NOT NULL,
    reason_param_a varchar(255) NOT NULL,
    reason_param_b varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_hackattack ADD INDEX h_date_and_time (date_and_time);

ALTER TABLE cms101_hackattack ADD INDEX otherhacksby (ip);

DROP TABLE IF EXISTS cms_https_pages;

CREATE TABLE cms_https_pages (
    https_page_name varchar(80) NOT NULL,
    PRIMARY KEY (https_page_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_images;

CREATE TABLE cms_images (
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
    image_views integer NOT NULL,
    title longtext NOT NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_images ADD FULLTEXT description (description);

ALTER TABLE cms101_images ADD FULLTEXT image_search__combined (description,title);

ALTER TABLE cms101_images ADD FULLTEXT title (title);

ALTER TABLE cms101_images ADD INDEX category_list (cat);

ALTER TABLE cms101_images ADD INDEX ftjoin_dtitle (title(250));

ALTER TABLE cms101_images ADD INDEX ftjoin_idescription (description(250));

ALTER TABLE cms101_images ADD INDEX iadd_date (add_date);

ALTER TABLE cms101_images ADD INDEX image_views (image_views);

ALTER TABLE cms101_images ADD INDEX i_validated (validated);

ALTER TABLE cms101_images ADD INDEX xis (submitter);

DROP TABLE IF EXISTS cms_import_id_remap;

CREATE TABLE cms_import_id_remap (
    id_old varchar(80) NOT NULL,
    id_new integer NOT NULL,
    id_type varchar(80) NOT NULL,
    id_session varchar(80) NOT NULL,
    PRIMARY KEY (id_old, id_type, id_session)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_import_parts_done;

CREATE TABLE cms_import_parts_done (
    id integer unsigned auto_increment NOT NULL,
    imp_id varchar(255) NOT NULL,
    imp_session varchar(80) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_import_session;

CREATE TABLE cms_import_session (
    imp_session varchar(80) NOT NULL,
    imp_old_base_dir varchar(255) NOT NULL,
    imp_db_name varchar(80) NOT NULL,
    imp_db_user varchar(80) NOT NULL,
    imp_hook varchar(80) NOT NULL,
    imp_db_table_prefix varchar(80) NOT NULL,
    imp_db_host varchar(80) NOT NULL,
    imp_refresh_time integer NOT NULL,
    PRIMARY KEY (imp_session)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_incoming_uploads;

CREATE TABLE cms_incoming_uploads (
    id integer unsigned auto_increment NOT NULL,
    i_submitter integer NOT NULL,
    i_date_and_time integer unsigned NOT NULL,
    i_orig_filename varchar(255) BINARY NOT NULL,
    i_save_url varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_ip_country;

CREATE TABLE cms_ip_country (
    id integer unsigned auto_increment NOT NULL,
    begin_num integer unsigned NOT NULL,
    end_num integer unsigned NOT NULL,
    country varchar(255) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_leader_board;

CREATE TABLE cms_leader_board (
    lb_member integer NOT NULL,
    lb_points integer NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (lb_member, date_and_time)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_link_tracker;

CREATE TABLE cms_link_tracker (
    id integer unsigned auto_increment NOT NULL,
    c_date_and_time integer unsigned NOT NULL,
    c_member_id integer NOT NULL,
    c_ip_address varchar(40) NOT NULL,
    c_url varchar(255) BINARY NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_link_tracker ADD INDEX c_url (c_url(250));

DROP TABLE IF EXISTS cms_logged_mail_messages;

CREATE TABLE cms_logged_mail_messages (
    id integer unsigned auto_increment NOT NULL,
    m_subject longtext NOT NULL,
    m_message longtext NOT NULL,
    m_to_email longtext NOT NULL,
    m_extra_cc_addresses longtext NOT NULL,
    m_extra_bcc_addresses longtext NOT NULL,
    m_join_time integer unsigned NULL,
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
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_logged_mail_messages ADD INDEX combo (m_date_and_time,m_queued);

ALTER TABLE cms101_logged_mail_messages ADD INDEX queued (m_queued);

ALTER TABLE cms101_logged_mail_messages ADD INDEX recentmessages (m_date_and_time);

DROP TABLE IF EXISTS cms_match_key_messages;

CREATE TABLE cms_match_key_messages (
    id integer unsigned auto_increment NOT NULL,
    k_message longtext NOT NULL,
    k_match_key varchar(255) NOT NULL,
    k_message__text_parsed longtext NOT NULL,
    k_message__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_match_key_messages ADD FULLTEXT k_message (k_message);

DROP TABLE IF EXISTS cms_member_category_access;

CREATE TABLE cms_member_category_access (
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    member_id integer NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (module_the_name, category_name, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_member_category_access ADD INDEX mcamember_id (member_id);

ALTER TABLE cms101_member_category_access ADD INDEX mcaname (module_the_name,category_name);

DROP TABLE IF EXISTS cms_member_page_access;

CREATE TABLE cms_member_page_access (
    page_name varchar(80) NOT NULL,
    zone_name varchar(80) NOT NULL,
    member_id integer NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (page_name, zone_name, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms101_member_page_access ADD INDEX mzamember_id (member_id);

ALTER TABLE cms101_member_page_access ADD INDEX mzaname (page_name,zone_name);

