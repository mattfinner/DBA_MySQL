# Run through each command manually

# RUN AS MYSQL user
# Uncompress backup
tar -xvzf /data/mysql/backups/FULL/2015-10-12.tar.gz -C /data/mysql/backups/FULL/ --strip-components=4

# Find the master binlog at the time the full backup finished
cat /data/mysql/backups/FULL/2015-10-12_13-08-06/xtrabackup_info | grep binlog_pos
#binlog_pos = filename 'binlog.000128', position 120


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

# If you're doing a point in time restore make sure you uncomment following in my.cnf
# bind-address = 127.0.0.1

# Doing a point in time restore...

# Copy archive logs back - change the regex to pull the files you need
find /data/mysql/backups/LOGS/08_10_2015 -regextype posix-extended -regex "./binlog.0000[0-4][0-9]" | sudo xargs cp -t /data/mysql/binlogs

# Create a restore script from the binary logs (alternatively can pipe striaght into MySQL if required - make sure MySQL running first)
cd /data/mysql/binlogs
mysqlbinlog binlog.000128 binlog.000129 binlog.000130 binlog.000131 --start-position=120 > /data/mysql/backups/LOGS/logRestoreScript.sql


# RUN AS ROOT user
# Startup MySQL again
sudo systemctl start mysqld

# Run the log restore script
mysql --user="root" --password="Harewood21" < logRestoreScript.sql
