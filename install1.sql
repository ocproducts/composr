DROP TABLE IF EXISTS cms_alternative_ids;

CREATE TABLE cms_alternative_ids (
    resource_type varchar(80) NOT NULL,
    resource_id varchar(80) NOT NULL,
    resource_moniker varchar(80) NOT NULL,
    resource_label varchar(255) NOT NULL,
    resource_guid varchar(80) NOT NULL,
    resource_resource_fs_hook varchar(80) NOT NULL,
    PRIMARY KEY (resource_type, resource_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_alternative_ids ADD INDEX resource_guid (resource_guid);

ALTER TABLE cms10_alternative_ids ADD INDEX resource_label (resource_label(250));

ALTER TABLE cms10_alternative_ids ADD INDEX resource_moniker (resource_moniker,resource_type);

ALTER TABLE cms10_alternative_ids ADD INDEX resource_moniker_uniq (resource_moniker,resource_resource_fs_hook);

DROP TABLE IF EXISTS cms_attachment_refs;

CREATE TABLE cms_attachment_refs (
    id integer unsigned auto_increment NOT NULL,
    r_referer_type varchar(80) NOT NULL,
    r_referer_id varchar(80) NOT NULL,
    a_id integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_attachments;

CREATE TABLE cms_attachments (
    id integer unsigned auto_increment NOT NULL,
    a_member_id integer NOT NULL,
    a_file_size integer NULL,
    a_url varchar(255) NOT NULL,
    a_description varchar(255) NOT NULL,
    a_thumb_url varchar(255) NOT NULL,
    a_original_filename varchar(255) NOT NULL,
    a_num_downloads integer NOT NULL,
    a_last_downloaded_time integer NULL,
    a_add_time integer NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_attachments ADD INDEX attachmentlimitcheck (a_add_time);

ALTER TABLE cms10_attachments ADD INDEX ownedattachments (a_member_id);

DROP TABLE IF EXISTS cms_authors;

CREATE TABLE cms_authors (
    author varchar(80) NOT NULL,
    url varchar(255) BINARY NOT NULL,
    member_id integer NULL,
    description longtext NOT NULL,
    skills longtext NOT NULL,
    description__text_parsed longtext NOT NULL,
    description__source_user integer DEFAULT 1 NOT NULL,
    skills__text_parsed longtext NOT NULL,
    skills__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (author)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_authors ADD FULLTEXT description (description);

ALTER TABLE cms10_authors ADD FULLTEXT skills (skills);

ALTER TABLE cms10_authors ADD INDEX findmemberlink (member_id);

DROP TABLE IF EXISTS cms_autosave;

CREATE TABLE cms_autosave (
    id integer unsigned auto_increment NOT NULL,
    a_member_id integer NOT NULL,
    a_key longtext NOT NULL,
    a_value longtext NOT NULL,
    a_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_autosave ADD INDEX myautosaves (a_member_id);

DROP TABLE IF EXISTS cms_blocks;

CREATE TABLE cms_blocks (
    block_name varchar(80) NOT NULL,
    block_author varchar(80) NOT NULL,
    block_organisation varchar(80) NOT NULL,
    block_hacked_by varchar(80) NOT NULL,
    block_hack_version integer NULL,
    block_version integer NOT NULL,
    PRIMARY KEY (block_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_cache;

CREATE TABLE cms_cache (
    id integer unsigned auto_increment NOT NULL,
    cached_for varchar(80) NOT NULL,
    identifier varchar(40) NOT NULL,
    the_theme varchar(40) NOT NULL,
    staff_status tinyint(1) NULL,
    the_member integer NULL,
    groups varchar(255) NOT NULL,
    is_bot tinyint(1) NULL,
    timezone varchar(40) NOT NULL,
    lang varchar(5) NOT NULL,
    the_value longtext NOT NULL,
    dependencies longtext NOT NULL,
    date_and_time integer unsigned NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_cache ADD INDEX cached_ford (date_and_time);

ALTER TABLE cms10_cache ADD INDEX cached_fore (cached_for);

ALTER TABLE cms10_cache ADD INDEX cached_forf (cached_for,identifier,the_theme,lang,staff_status,the_member,is_bot);

ALTER TABLE cms10_cache ADD INDEX cached_forh (the_theme);

DROP TABLE IF EXISTS cms_cache_on;

CREATE TABLE cms_cache_on (
    cached_for varchar(80) NOT NULL,
    cache_on longtext NOT NULL,
    special_cache_flags integer NOT NULL,
    cache_ttl integer NOT NULL,
    PRIMARY KEY (cached_for)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_cached_comcode_pages;

CREATE TABLE cms_cached_comcode_pages (
    the_zone varchar(80) NOT NULL,
    the_page varchar(80) NOT NULL,
    string_index longtext NOT NULL,
    the_theme varchar(80) NOT NULL,
    cc_page_title longtext NOT NULL,
    string_index__text_parsed longtext NOT NULL,
    string_index__source_user integer DEFAULT 1 NOT NULL,
    PRIMARY KEY (the_zone, the_page, the_theme)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_cached_comcode_pages ADD FULLTEXT cc_page_title (cc_page_title);

ALTER TABLE cms10_cached_comcode_pages ADD FULLTEXT page_search__combined (cc_page_title,string_index);

ALTER TABLE cms10_cached_comcode_pages ADD FULLTEXT string_index (string_index);

ALTER TABLE cms10_cached_comcode_pages ADD INDEX ccp_join (the_page,the_zone);

ALTER TABLE cms10_cached_comcode_pages ADD INDEX ftjoin_ccpt (cc_page_title(250));

ALTER TABLE cms10_cached_comcode_pages ADD INDEX ftjoin_ccsi (string_index(250));

DROP TABLE IF EXISTS cms_captchas;

CREATE TABLE cms_captchas (
    si_session_id varchar(80) NOT NULL,
    si_time integer unsigned NOT NULL,
    si_code varchar(80) NOT NULL,
    PRIMARY KEY (si_session_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_captchas ADD INDEX si_time (si_time);

DROP TABLE IF EXISTS cms_comcode_pages;

CREATE TABLE cms_comcode_pages (
    the_zone varchar(80) NOT NULL,
    the_page varchar(80) NOT NULL,
    p_parent_page varchar(80) NOT NULL,
    p_validated tinyint(1) NOT NULL,
    p_edit_date integer unsigned NULL,
    p_add_date integer unsigned NOT NULL,
    p_submitter integer NOT NULL,
    p_show_as_edit tinyint(1) NOT NULL,
    p_order integer NOT NULL,
    PRIMARY KEY (the_zone, the_page)
) CHARACTER SET=utf8mb4 engine=MyISAM;

INSERT INTO cms_comcode_pages (the_zone, the_page, p_parent_page, p_validated, p_edit_date, p_add_date, p_submitter, p_show_as_edit, p_order) VALUES ('site', 'userguide_comcode', 'help', 1, NULL, 1524093347, 2, 0, 0);
INSERT INTO cms_comcode_pages (the_zone, the_page, p_parent_page, p_validated, p_edit_date, p_add_date, p_submitter, p_show_as_edit, p_order) VALUES ('', 'keymap', 'help', 1, NULL, 1524093347, 2, 0, 0);

ALTER TABLE cms10_comcode_pages ADD INDEX p_add_date (p_add_date);

ALTER TABLE cms10_comcode_pages ADD INDEX p_order (p_order);

ALTER TABLE cms10_comcode_pages ADD INDEX p_submitter (p_submitter);

ALTER TABLE cms10_comcode_pages ADD INDEX p_validated (p_validated);

DROP TABLE IF EXISTS cms_config;

CREATE TABLE cms_config (
    c_name varchar(80) NOT NULL,
    c_set tinyint(1) NOT NULL,
    c_value longtext NOT NULL,
    c_value_trans longtext NOT NULL,
    c_needs_dereference tinyint(1) NOT NULL,
    PRIMARY KEY (c_name)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_config ADD FULLTEXT c_value_trans (c_value_trans);

DROP TABLE IF EXISTS cms_content_privacy;

CREATE TABLE cms_content_privacy (
    content_type varchar(80) NOT NULL,
    content_id varchar(80) NOT NULL,
    guest_view tinyint(1) NOT NULL,
    member_view tinyint(1) NOT NULL,
    friend_view tinyint(1) NOT NULL,
    PRIMARY KEY (content_type, content_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_content_privacy ADD INDEX friend_view (friend_view);

ALTER TABLE cms10_content_privacy ADD INDEX guest_view (guest_view);

ALTER TABLE cms10_content_privacy ADD INDEX member_view (member_view);

DROP TABLE IF EXISTS cms_content_privacy__members;

CREATE TABLE cms_content_privacy__members (
    content_type varchar(80) NOT NULL,
    content_id varchar(80) NOT NULL,
    member_id integer NOT NULL,
    PRIMARY KEY (content_type, content_id, member_id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_content_regions;

CREATE TABLE cms_content_regions (
    content_type varchar(80) NOT NULL,
    content_id varchar(80) NOT NULL,
    region varchar(80) NOT NULL,
    PRIMARY KEY (content_type, content_id, region)
) CHARACTER SET=utf8mb4 engine=MyISAM;

DROP TABLE IF EXISTS cms_cron_caching_requests;

CREATE TABLE cms_cron_caching_requests (
    id integer unsigned auto_increment NOT NULL,
    c_codename varchar(80) NOT NULL,
    c_map longtext NOT NULL,
    c_lang varchar(5) NOT NULL,
    c_theme varchar(80) NOT NULL,
    c_staff_status tinyint(1) NULL,
    c_member integer NULL,
    c_groups varchar(255) NOT NULL,
    c_is_bot tinyint(1) NULL,
    c_timezone varchar(40) NOT NULL,
    c_store_as_tempcode tinyint(1) NOT NULL,
    PRIMARY KEY (id)
) CHARACTER SET=utf8mb4 engine=MyISAM;

ALTER TABLE cms10_cron_caching_requests ADD INDEX c_compound (c_codename,c_theme,c_lang,c_timezone);

ALTER TABLE cms10_cron_caching_requests ADD INDEX c_is_bot (c_is_bot);

ALTER TABLE cms10_cron_caching_requests ADD INDEX c_store_as_tempcode (c_store_as_tempcode);

