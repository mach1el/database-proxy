FROM debian:stable-slim

ENV MYSQL_USER=mysql \
	MYSQL_VERSION=5.7.26 \
	MYSQL_DATA_DIR=/var/lib/mysql \
	MYSQL_RUN_DIR=/run/mysqld \
	MYSQL_LOG_DIR=/var/log/mysql

RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN apt-get update && apt-get -yqq install ca-certificates gnupg2 wget dirmngr perl pwgen openssl && rm -rf /var/lib/apt/lists/*

ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& gpgconf --kill all \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

RUN mkdir /docker-entrypoint-initdb.d

RUN echo "deb http://deb.debian.org/debian sid main" >> /etc/apt/sources.list

RUN grep -v "deb http://deb.debian.org/debian sid main" /etc/apt/sources.list > /tmp/file && rm /tmp/file

RUN { \
		echo mysql-community-server mysql-community-server/data-dir select ''; \
		echo mysql-community-server mysql-community-server/root-pass password ''; \
		echo mysql-community-server mysql-community-server/re-root-pass password ''; \
		echo mysql-community-server mysql-community-server/remove-test-db select false; \
	} | debconf-set-selections \
	&& apt-get update && apt-get install -y mysql-server && rm -rf /var/lib/apt/lists/* \
	&& grep -v "deb http://deb.debian.org/debian sid main" /etc/apt/sources.list > /tmp/file && rm /tmp/file \
	&& rm -rf /var/lib/mysql && mkdir -p /var/lib/mysql /var/run/mysqld \
	&& chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
	&& chmod 777 /var/run/mysqld \
	&& find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/' \
	&& echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

VOLUME /var/lib/mysql

RUN mkdir /opt/mysql_scripts/
COPY scripts/* /opt/mysql_scripts/ 

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]