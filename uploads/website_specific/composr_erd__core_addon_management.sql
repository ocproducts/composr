		CREATE TABLE cms10_addons
		(
			addon_licence varchar(255) NOT NULL,
			addon_description longtext NOT NULL,
			addon_install_time integer unsigned NOT NULL,
			addon_name varchar(255) NULL,
			addon_author varchar(255) NOT NULL,
			addon_organisation varchar(255) NOT NULL,
			addon_version varchar(255) NOT NULL,
			addon_category varchar(255) NOT NULL,
			addon_copyright_attribution varchar(255) NOT NULL,
			PRIMARY KEY (addon_name)
		) TYPE=InnoDB;

		CREATE TABLE cms10_addons_files
		(
			id integer auto_increment NULL,
			addon_name varchar(255) NOT NULL,
			filename varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

		CREATE TABLE cms10_addons_dependencies
		(
			id integer auto_increment NULL,
			addon_name varchar(255) NOT NULL,
			addon_name_incompatibility tinyint(1) NOT NULL,
			addon_name_dependant_upon varchar(255) NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

