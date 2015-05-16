		CREATE TABLE cms10_wordfilter
		(
			w_substr tinyint(1) NULL,
			w_replacement varchar(255) NOT NULL,
			word varchar(255) NULL,
			PRIMARY KEY (w_substr,word)
		) TYPE=InnoDB;

