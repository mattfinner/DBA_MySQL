# Backup the database
innobackupex --user=bkpuser --password=Harewood21 --stream=xbstream --compress /data/backups/ > /data/backups/FULL_$(hostname)_$(date '+%d_%m_%Y_%H_%M').xbstream
