# Backup the database
innobackupex --user=bkpuser --password=Harewood21 /data/mysql/backups/FULL/$(date '+%d_%m_%Y')

# Prepare the backup
innobackupex --apply-log /data/backups/2015-09-30_13-35-56
