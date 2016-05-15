# Run these commands in a shell one-by-one

# RUN ON THE MASTER...
# Backup database and compress
sudo innobackupex --user=bkpuser --password=Harewood21 /data/mysql/backups/FULL/REPLBACKUP/ --no-timestamp
sudo innobackupex --apply-log /data/mysql/backups/FULL/REPLBACKUP/
sudo tar -cvzf /data/mysql/backups/FULL/REPLBACKUP.tar.gz /data/mysql/backups/FULL/REPLBACKUP/
sudo rm -R /data/mysql/backups/FULL/REPLBACKUP/

# Copy backup to slave
sudo scp REPLBACKUP.tar.gz root@192.168.155.34:/data/mysql/backups/FULL

# RUN ON THE SLAVE...
# Uncompress backup
sudo tar -xvzf /data/mysql/backups/FULL/REPLBACKUP.tar.gz -C /data/mysql/backups/FULL/ --strip-components=4

# Find binlog position
sudo cat /data/mysql/backups/FULL/REPLBACKUP/xtrabackup_info | grep binlog_pos
#binlog_pos = filename 'binlog.000053', position 120

# Stop the mysql service to restore
sudo systemctl stop mysqld

# Delete the contents of datadir and restore database (run as root)
rm -Rf /var/lib/mysql/*
rm -Rf /var/lib/mysql/.*
innobackupex --copy-back /data/mysql/backups/FULL/REPLBACKUP
chown -R mysql:mysql /var/lib/mysql

# Start the mysql service
sudo systemctl start mysqld

# Chain slave to the master (change the logfile and log position)
mysql --user="root" --password="Harewood21" --execute="CHANGE MASTER TO
MASTER_HOST = '192.168.155.33'
, MASTER_PORT = 3306
, MASTER_USER = 'repluser'
, MASTER_PASSWORD = 'Harewood21'
, MASTER_LOG_FILE = 'binlog.000053'
, MASTER_LOG_POS = 120;
START SLAVE;
"

# Tear down slave if required
#STOP SLAVE;
#RESET SLAVE ALL;
