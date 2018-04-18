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

Composr provides support for a number of different forum systems, and each forum handles authentication of members: Conversr is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.', '127.0.0.1', 1524093340, 1, NULL, 'System', 1, 1, 7, NULL, NULL, 0, 0, NULL, 'return unserialize(\"a:5:{i:0;a:1:{i:0;a:7:{i:0;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_1\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:1;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_2\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:2;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_3\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:3;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_4\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:4;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_5\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:5;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_6\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}i:6;a:5:{i:0;s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_7\\\";i:1;a:0:{}i:2;i:1;i:3;s:0:\\\"\\\";i:4;s:0:\\\"\\\";}}}i:1;a:0:{}i:2;s:7:\\\"(mixed)\\\";i:3;N;i:4;a:7:{s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_1\\\";s:121:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_1\']=\\\"echo \\\\\\\"This is the inbuilt forum system (known as Conversr).\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_2\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_2\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_3\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_3\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_4\\\";s:210:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_4\']=\\\"echo \\\\\\\"A forum system is a tool for communication between members; it consists of posts, organised into topics: each topic is a line of conversation.\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_5\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_5\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_6\\\";s:74:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_6\']=\\\"echo \\\\\\\"<br />\\\\\\\";\\\";\\n\\\";s:39:\\\"string_attach_5ad7d19cf2c9e6.96101199_7\\\";s:329:\\\"\\$tpl_funcs[\'string_attach_5ad7d19cf2c9e6.96101199_7\']=\\\"echo \\\\\\\"Composr provides support for a number of different forum systems, and each forum handles authentication of members: Conversr is the built-in forum, which provides seamless integration between the main website, the forums, and the inbuilt member accounts system.\\\\\\\";\\\";\\n\\\";}}\");
', 1);

ALTER TABLE cms10_f_posts ADD FULLTEXT posts_search__combined (p_post,p_title);

ALTER TABLE cms10_f_posts ADD FULLTEXT p_post (p_post);

ALTER TABLE cms10_f_posts ADD FULLTEXT p_title (p_title);

ALTER TABLE cms10_f_posts ADD INDEX deletebyip (p_ip_address);

ALTER TABLE cms10_f_posts ADD INDEX find_pp (p_intended_solely_for);

ALTER TABLE cms10_f_posts ADD INDEX in_topic (p_topic_id,p_time,id);

ALTER TABLE cms10_f_posts ADD INDEX in_topic_change_order (p_topic_id,p_last_edit_time,p_time,id);

ALTER TABLE cms10_f_posts ADD INDEX postsinforum (p_cache_forum_id);

ALTER TABLE cms10_f_posts ADD INDEX posts_by (p_poster,p_time);

ALTER TABLE cms10_f_posts ADD INDEX posts_by_in_forum (p_poster,p_cache_forum_id);

ALTER TABLE cms10_f_posts ADD INDEX posts_by_in_topic (p_poster,p_topic_id);

ALTER TABLE cms10_f_posts ADD INDEX posts_since (p_time,p_cache_forum_id);

ALTER TABLE cms10_f_posts ADD INDEX post_order_time (p_time,id);

ALTER TABLE cms10_f_posts ADD INDEX p_last_edit_time (p_last_edit_time);

ALTER TABLE cms10_f_posts ADD INDEX p_validated (p_validated);

ALTER TABLE cms10_f_posts ADD INDEX search_join (p_post(250));

DROP TABLE IF EXISTS cms_f_read_logs;

CREATE TABLE cms_f_read_logs (
    l_member_id integer NOT NULL,
    l_topic_id integer NOT NULL,
    l_time integer unsigned NOT NULL,
    PRIMARY KEY (l_member_id, l_topic_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_f_read_logs ADD INDEX erase_old_read_logs (l_time);

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

INSERT INTO cms_f_topics (id, t_pinned, t_sunk, t_cascading, t_forum_id, t_pt_from, t_pt_to, t_pt_from_category, t_pt_to_category, t_description, t_description_link, t_emoticon, t_num_views, t_validated, t_is_open, t_poll_id, t_cache_first_post_id, t_cache_first_time, t_cache_first_title, t_cache_first_post, t_cache_first_username, t_cache_first_member_id, t_cache_last_post_id, t_cache_last_time, t_cache_last_title, t_cache_last_username, t_cache_last_member_id, t_cache_num_posts, t_cache_first_post__text_parsed, t_cache_first_post__source_user) VALUES (1, 0, 0, 0, 7, NULL, NULL, '', '', '', '', '', 0, 1, 1, NULL, 1, 1524093340, 'Welcome to the forums', '', 'System', 1, 1, 1524093340, 'Welcome to the forums', 'System', 1, 1, '', 1);

ALTER TABLE cms10_f_topics ADD FULLTEXT t_cache_first_post (t_cache_first_post);

ALTER TABLE cms10_f_topics ADD FULLTEXT t_description (t_description);

ALTER TABLE cms10_f_topics ADD INDEX descriptionsearch (t_description(250));

ALTER TABLE cms10_f_topics ADD INDEX forumlayer (t_cache_first_title(250));

ALTER TABLE cms10_f_topics ADD INDEX in_forum (t_forum_id);

ALTER TABLE cms10_f_topics ADD INDEX ownedtopics (t_cache_first_member_id);

ALTER TABLE cms10_f_topics ADD INDEX topic_order (t_cascading,t_pinned,t_cache_last_time);

ALTER TABLE cms10_f_topics ADD INDEX topic_order_2 (t_forum_id,t_cascading,t_pinned,t_sunk,t_cache_last_time);

ALTER TABLE cms10_f_topics ADD INDEX topic_order_3 (t_forum_id,t_cascading,t_pinned,t_cache_last_time);

ALTER TABLE cms10_f_topics ADD INDEX topic_order_time (t_cache_last_time);

ALTER TABLE cms10_f_topics ADD INDEX topic_order_time_2 (t_cache_first_time);

ALTER TABLE cms10_f_topics ADD INDEX t_cache_first_post_id (t_cache_first_post_id);

ALTER TABLE cms10_f_topics ADD INDEX t_cache_last_member_id (t_cache_last_member_id);

ALTER TABLE cms10_f_topics ADD INDEX t_cache_last_post_id (t_cache_last_post_id);

ALTER TABLE cms10_f_topics ADD INDEX t_cache_num_posts (t_cache_num_posts);

ALTER TABLE cms10_f_topics ADD INDEX t_cascading (t_cascading);

ALTER TABLE cms10_f_topics ADD INDEX t_cascading_or_forum (t_cascading,t_forum_id);

ALTER TABLE cms10_f_topics ADD INDEX t_num_views (t_num_views);

ALTER TABLE cms10_f_topics ADD INDEX t_pt_from (t_pt_from);

ALTER TABLE cms10_f_topics ADD INDEX t_pt_to (t_pt_to);

ALTER TABLE cms10_f_topics ADD INDEX t_validated (t_validated);

ALTER TABLE cms10_f_topics ADD INDEX unread_forums (t_forum_id,t_cache_last_time);

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

ALTER TABLE cms10_f_warnings ADD INDEX warningsmemberid (w_member_id);

DROP TABLE IF EXISTS cms_failedlogins;

CREATE TABLE cms_failedlogins (
    id integer unsigned auto_increment NOT NULL,
    failed_account varchar(80) NOT NULL,
    date_and_time integer unsigned NOT NULL,
    ip varchar(40) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_failedlogins ADD INDEX failedlogins_by_ip (ip);

DROP TABLE IF EXISTS cms_filedump;

CREATE TABLE cms_filedump (
    id integer unsigned auto_increment NOT NULL,
    name varchar(80) NOT NULL,
    path varchar(255) BINARY NOT NULL,
    description longtext NOT NULL,
    the_member integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_filedump ADD FULLTEXT description (description);

DROP TABLE IF EXISTS cms_group_category_access;

CREATE TABLE cms_group_category_access (
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    group_id integer NOT NULL,
    PRIMARY KEY (module_the_name, category_name, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

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

DROP TABLE IF EXISTS cms_group_page_access;

CREATE TABLE cms_group_page_access (
    page_name varchar(80) NOT NULL,
    zone_name varchar(80) NOT NULL,
    group_id integer NOT NULL,
    PRIMARY KEY (page_name, zone_name, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

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

ALTER TABLE cms10_group_page_access ADD INDEX group_id (group_id);

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

INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '1', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '1', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '1', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '1', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'submit_lowrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (10, 'submit_midrange_content', '', 'forums', '1', 0);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'bypass_validation_lowrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'bypass_validation_midrange_content', '', 'forums', '2', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '3', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '3', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '3', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '3', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '4', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '4', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '4', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '4', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (1, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (4, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (5, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (6, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (7, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (8, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'bypass_validation_lowrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (9, 'bypass_validation_midrange_content', '', 'forums', '5', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '6', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '6', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '6', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '6', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_lowrange_content', '', 'forums', '7', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'bypass_validation_midrange_content', '', 'forums', '7', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_lowrange_content', '', 'forums', '7', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'bypass_validation_midrange_content', '', 'forums', '7', 1);
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
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (2, 'set_own_author_profile', '', '', '', 1);
INSERT INTO cms_group_privileges (group_id, privilege, the_page, module_the_name, category_name, the_value) VALUES (3, 'set_own_author_profile', '', '', '', 1);
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

ALTER TABLE cms10_group_privileges ADD INDEX group_id (group_id);

DROP TABLE IF EXISTS cms_group_zone_access;

CREATE TABLE cms_group_zone_access (
    zone_name varchar(80) NOT NULL,
    group_id integer NOT NULL,
    PRIMARY KEY (zone_name, group_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_group_zone_access ADD INDEX group_id (group_id);

DROP TABLE IF EXISTS cms_https_pages;

CREATE TABLE cms_https_pages (
    https_page_name varchar(80) NOT NULL,
    PRIMARY KEY (https_page_name)
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

DROP TABLE IF EXISTS cms_link_tracker;

CREATE TABLE cms_link_tracker (
    id integer unsigned auto_increment NOT NULL,
    c_date_and_time integer unsigned NOT NULL,
    c_member_id integer NOT NULL,
    c_ip_address varchar(40) NOT NULL,
    c_url varchar(255) BINARY NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_link_tracker ADD INDEX c_url (c_url(250));

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

ALTER TABLE cms10_logged_mail_messages ADD INDEX combo (m_date_and_time,m_queued);

ALTER TABLE cms10_logged_mail_messages ADD INDEX queued (m_queued);

ALTER TABLE cms10_logged_mail_messages ADD INDEX recentmessages (m_date_and_time);

DROP TABLE IF EXISTS cms_match_key_messages;

CREATE TABLE cms_match_key_messages (
    id integer unsigned auto_increment NOT NULL,
    k_message longtext NOT NULL,
    k_match_key varchar(255) NOT NULL,
    k_message__text_parsed longtext NOT NULL,
    k_message__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_match_key_messages ADD FULLTEXT k_message (k_message);

DROP TABLE IF EXISTS cms_member_category_access;

CREATE TABLE cms_member_category_access (
    module_the_name varchar(80) NOT NULL,
    category_name varchar(80) NOT NULL,
    member_id integer NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (module_the_name, category_name, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_member_category_access ADD INDEX mcamember_id (member_id);

ALTER TABLE cms10_member_category_access ADD INDEX mcaname (module_the_name,category_name);

DROP TABLE IF EXISTS cms_member_page_access;

CREATE TABLE cms_member_page_access (
    page_name varchar(80) NOT NULL,
    zone_name varchar(80) NOT NULL,
    member_id integer NOT NULL,
    active_until integer unsigned NULL,
    PRIMARY KEY (page_name, zone_name, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_member_page_access ADD INDEX mzamember_id (member_id);

ALTER TABLE cms10_member_page_access ADD INDEX mzaname (page_name,zone_name);

