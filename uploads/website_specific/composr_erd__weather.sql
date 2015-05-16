		CREATE TABLE cms10_cached_weather_codes
		(
			id integer auto_increment NULL,
			w_string varchar(255) NOT NULL,
			w_code integer NOT NULL,
			PRIMARY KEY (id)
		) TYPE=InnoDB;

