# Run through each command manually - RUN AS MYSQL user

# Uncompress backup
sudo xbstream -x <  FULL_MYSQL56_08_10_2015_00_00.xbstream -C /data/mysql/backups/FULL/08_10_2015/FULL

# Find the master binlog at the time the full backup finished
sudo cat ./FULL/xtrabackup_info | grep binlog_pos
#binlog_pos = filename 'binlog.000139', position 120

# Stop the mysql service to restore
sudo systemctl stop mysqld

# Delete the contents of datadir
sudo rm -R /data/mysql/data/*

# Restore the database
innobackupex --copy-back /data/mysql/backups/FULL/09_10_2015/FULL/*

# Make sure everything is owned by mysql group again
chown -R mysql: /data/mysql/data

# Startup MySQL again
systemctl start mysqld

# Copy archive logs back - change the regex to pull the files you need
find /data/mysql/backups/LOGS/08_10_2015 -regextype posix-extended -regex "./binlog.0000[0-4][0-9]" | sudo xargs cp -t /data/mysql/binlogs

# Restore the binary logs starting at the point referenced in binlog_pos - TODO
