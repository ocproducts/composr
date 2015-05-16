		CREATE TABLE cms10_notification_lockdown
		(
			l_setting integer NOT NULL,
			l_notification_code varchar(80) NULL,
			PRIMARY KEY (l_notification_code)
		) TYPE=InnoDB;

