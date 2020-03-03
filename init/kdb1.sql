INSERT INTO version (table_name, table_version) values ('kamailio_acc','5');
CREATE TABLE kamailio_acc (
	id SERIAL PRIMARY KEY NOT NULL,
	method VARCHAR(16) DEFAULT '' NOT NULL,
	from_tag VARCHAR(128) DEFAULT '' NOT NULL,
	to_tag VARCHAR(128) DEFAULT '',
	callid VARCHAR(255) DEFAULT '' NOT NULL,
	sip_code VARCHAR(3) DEFAULT '' NOT NULL,
	sip_reason VARCHAR(128) DEFAULT '' NOT NULL,
	time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	src_domain VARCHAR(255) DEFAULT '',
	dst_domain VARCHAR(255) DEFAULT '',
	src_user VARCHAR(255) DEFAULT '',
	dst_user VARCHAR(255) DEFAULT '',
	max INTEGER DEFAULT 0,
	loading INTEGER DEFAULT 0,
	prefix VARCHAR(255) DEFAULT ''
);

CREATE INDEX kamailio_acc_callid_idx ON kamailio_acc (callid);

INSERT INTO version (table_name, table_version) values ('kamailio_acc_cdrs','2');
CREATE TABLE kamailio_acc_cdrs (
	id SERIAL PRIMARY KEY NOT NULL,
	callid VARCHAR(255) DEFAULT '' NOT NULL,
	method VARCHAR(16) DEFAULT '' NOT NULL,
	from_tag VARCHAR(128) DEFAULT '' NOT NULL,
	to_tag VARCHAR(128) DEFAULT '',
	start_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	end_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
	duration REAL DEFAULT 0 NOT NULL
);

CREATE INDEX kamailio_acc_cdrs_start_time_idx ON kamailio_acc_cdrs (start_time);