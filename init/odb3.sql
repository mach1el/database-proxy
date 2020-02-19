INSERT INTO opensips_version (table_name, table_version) values ('acc','7');
CREATE TABLE opensips_acc (
	id SERIAL PRIMARY KEY NOT NULL,
	method VARCHAR(16) DEFAULT '' NOT NULL,
	from_tag VARCHAR(64) DEFAULT '' NOT NULL,
	to_tag VARCHAR(64) DEFAULT '',
	callid VARCHAR(64) DEFAULT '' NOT NULL,
	sip_code VARCHAR(3) DEFAULT '' NOT NULL,
	sip_reason VARCHAR(32) DEFAULT '' NOT NULL,
	time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	duration INTEGER DEFAULT 0,
	ms_duration INTEGER DEFAULT 0,
	setuptime INTEGER DEFAULT 0 NOT NULL,
	created TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
	src_ip VARCHAR(255) DEFAULT '',
	dst_ip VARCHAR(255) DEFAULT '',
	caller VARCHAR(255) DEFAULT '',
	callee VARCHAR(255) DEFAULT '',
	max INTEGER DEFAULT 0,
	loading INTEGER DEFAULT 0,
	prefix VARCHAR(255) DEFAULT ''
);
CREATE INDEX callid_idx ON opensips_acc (callid);
