CREATE TABLE version (
	table_name char(32) NOT NULL UNIQUE,
	table_version int(10) UNSIGNED DEFAULT 0 NOT NULL ) ENGINE=InnoDB;