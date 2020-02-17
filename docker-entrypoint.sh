#!/bin/bash
set -eo pipefail
shopt -s nullglob

if [ "${1:0:1}" = '-' ]; then
	set -- mysqld "$@"
fi

wantHelp=
for arg; do
	case "$arg" in
		-'?'|--help|--print-defaults|-V|--version)
			wantHelp=1
			break
			;;
	esac
done

_datadir() {
	"$@" --verbose --help 2>/dev/null | awk '$1 == "datadir" { print $2; exit }'
}

if [ "$1" = 'mysqld' -a -z "$wantHelp" -a "$(id -u)" = '0' ]; then
	DATADIR="$(_datadir "$@")"
	mkdir -p "$DATADIR"
	chown -R mysql:mysql "$DATADIR"
	exec gosu mysql "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mysqld' -a -z "$wantHelp" ]; then
	DATADIR="$(_datadir "$@")"

	if [ ! -d "$DATADIR/mysql" ]; then

		mkdir -p "$DATADIR"

		echo -e '\e[95m[INFO] DB Proxy: Initializing database\e[39m'
		"$@" --initialize-insecure
		echo -e '\e[95m[INFO] DB Proxy: Database initialized\e[39m'

		"$@" --skip-networking &
		pid="$!"

		mysql=( mysql --protocol=socket -uroot )

		for i in {30..0}; do
			if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
				break
			fi
			echo -e '\e[95m[INFO] DB Proxy: MySQL init process in progress...\e[39m'
			sleep 1
		done
		if [ "$i" = 0 ]; then
			echo -e >&2 '\e[95m[ERROR] DB Proxy: MySQL init process failed.\e[39m'
			exit 1
		fi

		"${mysql[@]}" <<-EOSQL
			SET @@SESSION.SQL_LOG_BIN=0;
			DELETE FROM mysql.user ;
			CREATE USER 'root'@'%' IDENTIFIED BY 'rooted' ;
			GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
			DROP DATABASE IF EXISTS test ;
			FLUSH PRIVILEGES ;
		EOSQL

		mysql=( mysql --protocol=socket -uroot --password=rooted )
		echo -e '\e[95m[INFO]Creating database.\e[39m'
		echo "CREATE DATABASE synthetic_data;" | "${mysql[@]}"
		
		dbinsert=( mysql --protocol=socket -uroot --password=rooted synthetic_data )
		"${dbinsert[@]}" < /opt/mysql_scripts/version-create.sql
		"${dbinsert[@]}" < /opt/mysql_scripts/acc-create.sql
		"${dbinsert[@]}" < /opt/mysql_scripts/load_balancer-create.sql
		
		echo -e "\e[95m[INFO]The database was created.\e[39m"
		echo -e "\e[95m[INFO]Creating a new user for the database and grant permission.\e[39m"
		echo "CREATE USER 'administrator'@'%' IDENTIFIED BY 'superuser';" | "${mysql[@]}"
		echo "GRANT ALL PRIVILEGES ON synthetic_data.* TO 'administrator'@'%';" | "${mysql[@]}"
		echo "FLUSH PRIVILEGES;" | "${mysql[@]}"
		echo -e "\e[95m[INFO]The new user and database have been done.\e[39m"

		echo
		for f in /docker-entrypoint-initdb.d/*; do
			case "$f" in
				*.sh)     echo "$0: running $f"; . "$f" ;;
				*.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
				*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
				*)        echo "$0: ignoring $f" ;;
			esac
			echo
		done

		if ! kill -s TERM "$pid" || ! wait "$pid"; then
			echo -e >&2 '\e[95m[ERROR] DB Proxy: MySQL init process failed.\e[39m'
			exit 1
		fi

		echo
		echo -e '\e[95m[INFO] DB Proxy: MySQL init process done. Ready for start up.\e[39m'
		echo
	fi
fi

exec "$@"