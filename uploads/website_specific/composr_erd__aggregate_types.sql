		CREATE TABLE cms10_aggregate_type_instances
		(
			other_parameters longtext NOT NULL,
			id integer auto_increment NULL,
			aggregate_label varchar(255) NOT NULL,
			aggregate_type varchar(80) NOT NULL,
			edit_time integer unsigned NOT NULL,
			add_time integer unsigned NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

