		CREATE TABLE cms10_content_reviews
		(
			review_notification_happened tinyint(1) NOT NULL,
			display_review_status tinyint(1) NOT NULL,
			review_freq integer NOT NULL,
			next_review_time integer unsigned NOT NULL,
			auto_action varchar(80) NOT NULL,
			content_id varchar(80) NULL,
			content_type varchar(80) NULL,
			last_reviewed_time integer unsigned NOT NULL,
			PRIMARY KEY (content_id,content_type)
		) TYPE=InnoDB;

