# Run through each command manually

# RUN AS MYSQL user
# Uncompress backup
tar -xvzf /data/mysql/backups/FULL/2015-10-14.tar.gz -C /data/mysql/backups/FULL/ --strip-components=4

# Find the master binlog at the time the full backup finished
cat /data/mysql/backups/FULL/2015-10-12_13-08-06/xtrabackup_info | grep binlog_pos
#binlog_pos = filename 'binlog.000048', position 214


# RUN AS ROOT user
# Stop the mysql service to restore
sudo systemctl stop mysqld

# Delete the contents of datadir
sudo rm -Rf /var/lib/mysql/*
sudo rm -Rf /var/lib/mysql/.*


# RUN AS MYSQL user
# Restore the database
innobackupex --copy-back /data/mysql/backups/FULL/2015-10-12_13-08-06


# RUN AS ROOT user
# Make sure everything is owned by mysql group again
sudo chown -R mysql:mysql /var/lib/mysql

# Doing a point in time restore...
# If you're doing a point in time restore make sure you uncomment following in my.cnf
sed -i 's/# bind-address = 127.0.0.1/bind-address = 127.0.0.1/' /etc/my.cnf
systemctl restart mysqld

# RUN AS ROOT user
# Copy archive logs back - change the regex to pull the files you need
find /data/mysql/backups/LOGS/08_10_2015 -regextype posix-extended -regex "./binlog.0000[0-4][0-9]" | sudo xargs cp -t /data/mysql/binlogs

# Create a restore script from the binary logs (alternatively can pipe striaght into MySQL if required - make sure MySQL running first)
cd /data/mysql/binlogs
echo $(find binlog.0* -newermt "2015-12-31 13:31") | xargs mysqlbinlog --start-position=214 > /data/mysql/backups/LOGS/logRestoreScript.sql

# Startup MySQL again
sudo systemctl start mysqld

# Run the log restore script
mysql --user="root" --password="Harewood21" < /data/mysql/backups/LOGS/logRestoreScript.sql

# Uncomment the following in my.cnf to allow remote connections
sed -i 's/bind-address = 127.0.0.1/# bind-address = 127.0.0.1' /etc/my.cnf
systemctl restart mysqld
