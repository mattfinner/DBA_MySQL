#!/bin/bash
# exit script if error
set -e
CURRENT_DATE_UTC=$(date '+%Y-%m-%d')

# rotate the output log
mv /data/mysql/logs/backupWithCompression.log /data/mysql/logs/backupWithCompression_$CURRENT_DATE_UTC.log

# delete old output logs
find /data/mysql/logs/backupWithCompression* -type f -mtime +5 | xargs rm -rf

# delete old full backups
find /data/mysql/backups/FULL/*.tar.gz -type f -mtime +5 | xargs rm -rf
