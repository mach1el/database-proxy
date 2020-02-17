INSERT INTO version (table_name, table_version) values ('acc','7');
CREATE TABLE acc (
	id INT(10) UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	method CHAR(16) DEFAULT '' NOT NULL,
	from_tag CHAR(64) DEFAULT '' NOT NULL,
	to_tag CHAR(64) DEFAULT '',
	callid CHAR(64) DEFAULT '' NOT NULL,
	sip_code CHAR(3) DEFAULT '' NOT NULL,
	sip_reason CHAR(32) DEFAULT '' NOT NULL,
	time DATETIME NOT NULL,
	duration INT(11) UNSIGNED DEFAULT 0,
	ms_duration INT(11) UNSIGNED DEFAULT 0,
	setuptime INT(11) UNSIGNED DEFAULT 0 NOT NULL,
	created DATETIME DEFAULT NULL,
	src_ip varchar(255) DEFAULT '',
	dst_ip varchar(255) DEFAULT '',
	caller varchar(255) DEFAULT '',
	callee varchar(255) DEFAULT '',
	max int(11) DEFAULT 0,
	loading int(11) DEFAULT 0,
	prefix varchar(255) DEFAULT ''
) ENGINE=InnoDB;

CREATE INDEX callid_idx ON acc (callid);