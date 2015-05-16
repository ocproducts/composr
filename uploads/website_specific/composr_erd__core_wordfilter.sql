		CREATE TABLE cms4_wordfilter
		(
			w_replacement varchar(255) NOT NULL,
			w_substr tinyint(1) NULL,
			word varchar(255) NULL,
			PRIMARY KEY (w_substr,word)
		) TYPE=InnoDB;

