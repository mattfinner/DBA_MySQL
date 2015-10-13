#!/bin/bash
# exit script if error
set -e
CURRENT_DATE_UTC=$(date '+%Y-%m-%d')

# rotate the output log
mv /data/mysql/logs/archiveLogs.log /data/mysql/logs/archiveLogs_$CURRENT_DATE_UTC.log

# delete old output logs
find /data/mysql/logs/archiveLogs* -type f -mtime +5 | xargs rm -rf

# delete old binlog backups
find /data/mysql/backups/LOGS/* -type d -mtime +5 | xargs rm -rf
