#!/bin/bash

# Get xtrabackup
wget "https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-2.2.12/binary/redhat/7/x86_64/percona-xtrabackup-2.2.12-1.el7.x86_64.rpm"

# Install dependacies
yum -y install rsync
yum -y install perl-DBD-MySQL
yum -y install perl-Digest-MD5

# Install xtrabackup
rpm -ivh percona-xtrabackup-2.2.12-1.el7.x86_64.rpm

# Change mysql password so can run backups, cron etc
passwd mysql # Harewood21 on test
chsh -s /bin/bash mysql;

# Create user and test database
mysql --user="root" --password="Harewood21" --execute="CREATE USER 'bkpuser'@'localhost' IDENTIFIED BY 'Harewood21';
GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'bkpuser'@'localhost';
FLUSH PRIVILEGES;"

# Grant mysql group access to data dir
chown -R mysql:mysql /var/lib/mysql
find /var/lib/mysql -type d -exec chmod 770 "{}" \;
