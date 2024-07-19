#!/bin/sh

# Initialize MySQL data directory if it doesn't exist
if [ ! -d "/var/lib/mysql" ]; then
### check if the specific MySQL system database directory exists
### inside the base directory.
#if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Create a temporary SQL file for setting up database and users
tmpfile=$(mktemp)
if [ ! -f "$tmpfile" ]; then
    echo "Failed to create temporary file."
    exit 1
fi

# Create SQL commands to set up the database and users
cat << EOF > $tmpfile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';

CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "Running MySQL setup script..."
/usr/bin/mysqld --user=mysql --bootstrap < $tmpfile
rm -f $tmpfile

echo "MySQL setup script completed."

# exec @
# exec /usr/bin/mysqld --user=mysql --bind-address=0.0.0.0 --skip-log-error

###########################################################################################

## init. a DB if it doesn't exist and sets up the necessary databases and users for WordPress.

## Create MySQL data directory if it doesn't exist
#if [ ! -d "/var/lib/mysql/" ]; then
#    echo "MySQL data directory not found. Creating..."
#    mkdir -p /var/lib/mysql/
#fi

#if [ -d "/var/lib/mysql/" ]; then

#	# change ownership of the MySQL data directory
#	chown -R mysql:mysql /var/lib/mysql
#	echo "Ownership of /var/lib/mysql changed to mysql:mysql."

#	# init data directory
#        mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
#	echo "MySQL data directory initialized."

#	# create a temporary file for SQL commands
#	tfile=`mktemp`
#        if [ ! -f "$tfile" ]; then
#		echo "Failed to create temporary file."
#                return 1
#        fi
#fi

## check if the WordPress database exists
#if [ ! -d "/var/lib/mysql/wordpress" ]; then
#	echo "WordPress database not found. Creating WordPress database..."
#        cat << EOF > /tmp/create_db.sql
#USE mysql;
#FLUSH PRIVILEGES;
#DELETE FROM     mysql.user WHERE User='';
#DROP DATABASE test;
#DELETE FROM mysql.db WHERE Db='test';
#DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

#ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT}';

#CREATE DATABASE ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;

#CREATE USER '${DB_USER}'@'%' IDENTIFIED by '${DB_PASS}';
#GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';

##CREATE USER '${DB_GUEST}'@'%' IDENTIFIED by '${DB_GUESTPASS}';
##GRANT SELECT ON wordpress.* TO '${DB_GUEST}'@'%';

#FLUSH PRIVILEGES;
#EOF
#echo "SQL script to create WordPress database and user has been created."

#        # run SQL script to init DB, remove it
#        /usr/bin/mysqld --user=mysql --bootstrap < /tmp/create_db.sql
#	echo "WordPress database and user created."
#	rm -f /tmp/create_db.sql
#fi

#echo "MySQL setup script completed."
