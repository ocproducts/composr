		CREATE TABLE cms10_theme_images
		(
			path varchar(255) NOT NULL,
			lang varchar(5) NULL,
			id varchar(255) NULL,
			theme varchar(40) NULL,
			PRIMARY KEY (lang,id,theme)
		) TYPE=InnoDB;

