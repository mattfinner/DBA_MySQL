#!/bin/bash
# exit script if error
set -e

# Make sure bin-logs are setup (should be with default setup)
#echo "*** Enable binary logs ***"
#sed -i '/\[mysqld\]/a # Set bin-log directory\nlog-bin = "/data/mysql/binlogs/binlog\n"' /etc/my.cnf

# Create server-id
echo "*** Create master server-id ***"
sed -i '/\[mysqld\]/a # Set server-id for replication\nserver-id = 1\n' /etc/my.cnf

# Create replication user
mysql --user="root" --password="Harewood21" --execute="CREATE USER 'repluser'@'%' IDENTIFIED BY 'Harewood21';
GRANT REPLICATION SLAVE ON *.* TO 'bkpuser'@'%';"

# Restart MySQL
systemctl restart mysqld
