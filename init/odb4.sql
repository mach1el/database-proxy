INSERT INTO version (table_name, table_version) values ('opensips_dr_gateways','6');
CREATE TABLE opensips_dr_gateways (
    id SERIAL PRIMARY KEY NOT NULL,
    gwid VARCHAR(64) NOT NULL,
    type INTEGER DEFAULT 0 NOT NULL,
    address VARCHAR(128) NOT NULL,
    strip INTEGER DEFAULT 0 NOT NULL,
    pri_prefix VARCHAR(16) DEFAULT NULL,
    attrs VARCHAR(255) DEFAULT NULL,
    probe_mode INTEGER DEFAULT 0 NOT NULL,
    state INTEGER DEFAULT 0 NOT NULL,
    socket VARCHAR(128) DEFAULT NULL,
    description VARCHAR(128) DEFAULT NULL,
    CONSTRAINT opensips_dr_gateways_dr_gw_idx UNIQUE (gwid)
);

ALTER SEQUENCE open_dr_gateways_id_seq MAXVALUE 2147483647 CYCLE;
INSERT INTO version (table_name, table_version) values ('opensips_dr_rules','3');
CREATE TABLE opensips_dr_rules (
    ruleid SERIAL PRIMARY KEY NOT NULL,
    groupid VARCHAR(255) NOT NULL,
    prefix VARCHAR(64) NOT NULL,
    timerec VARCHAR(255) DEFAULT NULL,
    priority INTEGER DEFAULT 0 NOT NULL,
    routeid VARCHAR(255) DEFAULT NULL,
    gwlist VARCHAR(255) NOT NULL,
    attrs VARCHAR(255) DEFAULT NULL,
    description VARCHAR(128) DEFAULT NULL
);

ALTER SEQUENCE opensips_dr_rules_ruleid_seq MAXVALUE 2147483647 CYCLE;
INSERT INTO version (table_name, table_version) values ('opensips_dr_carriers','2');
CREATE TABLE opensips_dr_carriers (
    id SERIAL PRIMARY KEY NOT NULL,
    carrierid VARCHAR(64) NOT NULL,
    gwlist VARCHAR(255) NOT NULL,
    flags INTEGER DEFAULT 0 NOT NULL,
    state INTEGER DEFAULT 0 NOT NULL,
    attrs VARCHAR(255) DEFAULT NULL,
    description VARCHAR(128) DEFAULT NULL,
    CONSTRAINT opensips_dr_carriers_dr_carrier_idx UNIQUE (carrierid)
);

ALTER SEQUENCE opensips_dr_carriers_id_seq MAXVALUE 2147483647 CYCLE;
INSERT INTO version (table_name, table_version) values ('opensips_dr_groups','2');
CREATE TABLE opensips_dr_groups (
    id SERIAL PRIMARY KEY NOT NULL,
    username VARCHAR(64) NOT NULL,
    domain VARCHAR(128) DEFAULT NULL,
    groupid INTEGER DEFAULT 0 NOT NULL,
    description VARCHAR(128) DEFAULT NULL
);

ALTER SEQUENCE opensips_dr_groups_id_seq MAXVALUE 2147483647 CYCLE;
INSERT INTO version (table_name, table_version) values ('opensips_dr_partitions','1');
CREATE TABLE opensips_dr_partitions (
    id SERIAL PRIMARY KEY NOT NULL,
    partition_name VARCHAR(255) NOT NULL,
    db_url VARCHAR(255) NOT NULL,
    drd_table VARCHAR(255),
    drr_table VARCHAR(255),
    drg_table VARCHAR(255),
    drc_table VARCHAR(255),
    ruri_avp VARCHAR(255),
    gw_id_avp VARCHAR(255),
    gw_priprefix_avp VARCHAR(255),
    gw_sock_avp VARCHAR(255),
    rule_id_avp VARCHAR(255),
    rule_prefix_avp VARCHAR(255),
    carrier_id_avp VARCHAR(255)
);

ALTER SEQUENCE opensips_dr_partitions_id_seq MAXVALUE 2147483647 CYCLE;