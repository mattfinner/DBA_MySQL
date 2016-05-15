#!/bin/bash
# exit script if error
set -e

# Disable binlogs
sed -i '/# Set bin-log directory/d' /etc/my.cnf
sed -i '/log-bin = "\/data\/mysql\/binlogs\/binlog"/d' /etc/my.cnf

# Create relay-log folder
echo "*** Create data folders ***"
mkdir -p /data/mysql/relaylogs
chown -R mysql:mysql /data/mysql/relaylogs

# Setup relay logs
echo "*** Enable relay logs ***"
sed -i '/\[mysqld\]/a # Set relay-log directory\nrelay-log = "/data/mysql/relaylogs/relaylog"\n' /etc/my.cnf

# Create server-id
echo "*** Create slave server-id ***"
sed -i '/\[mysqld\]/a # Set server-id for replication\nserver-id = 2\n' /etc/my.cnf

# Restart MySQL
systemctl restart mysqld
