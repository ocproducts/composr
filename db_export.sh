#!/bin/bash

# Export a db.sql file from the MySQL database configured in _config.php
# Primarily designed for synching databases within the context of a revision control system

DB_HOST=$(cat _config.php|sed -n "s/\$SITE_INFO\['db_site_host']='\(.*\)';/\1/p")
DB_USER=$(cat _config.php|sed -n "s/\$SITE_INFO\['db_site_user']='\(.*\)';/\1/p")
DB_PASS=$(cat _config.php|sed -n "s/\$SITE_INFO\['db_site_password']='\(.*\)';/\1/p")
DB_NAME=$(cat _config.php|sed -n "s/\$SITE_INFO\['db_site']='\(.*\)';/\1/p")

if [ -z "${DB_NAME}" ];
then
	echo "_config.php has not been configured. You must install Composr, or grab an install's _config.php and db.sql"
	exit 0
fi

mysqldump -h${DB_HOST} -u${DB_USER} -p${DB_PASS} ${DB_NAME} --lock-tables=false > db.sql
