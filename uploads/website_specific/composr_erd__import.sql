		CREATE TABLE cms10_import_parts_done
		(
			imp_id varchar(255) NULL,
			imp_session integer NULL,
			PRIMARY KEY (imp_id,imp_session)
		) TYPE=InnoDB;

		CREATE TABLE cms10_import_session
		(
			imp_refresh_time integer NOT NULL,
			imp_session integer NULL,
			imp_db_table_prefix varchar(80) NOT NULL,
			imp_db_host varchar(80) NOT NULL,
			imp_db_user varchar(80) NOT NULL,
			imp_old_base_dir varchar(255) NOT NULL,
			imp_db_name varchar(80) NOT NULL,
			imp_hook varchar(80) NOT NULL,
			PRIMARY KEY (imp_session)
		) TYPE=InnoDB;

		CREATE TABLE cms10_import_id_remap
		(
			id_session integer NULL,
			id_new integer NOT NULL,
			id_type varchar(80) NULL,
			id_old varchar(80) NULL,
			PRIMARY KEY (id_session,id_type,id_old)
		) TYPE=InnoDB;

		CREATE TABLE cms10_anything
		(
			id varchar(80) NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;


		CREATE INDEX `import_id_remap.id_new` ON cms10_import_id_remap(id_new);
		ALTER TABLE cms10_import_id_remap ADD FOREIGN KEY `import_id_remap.id_new` (id_new) REFERENCES cms10_anything (id);

		CREATE INDEX `import_id_remap.id_old` ON cms10_import_id_remap(id_old);
		ALTER TABLE cms10_import_id_remap ADD FOREIGN KEY `import_id_remap.id_old` (id_old) REFERENCES cms10_anything (id);
