#!/bin/bash
# exit script if error
set -e
CURRENT_DATE_UTC=$(date '+%Y-%m-%d')

# rotate the output log
mv /data/mysql/logs/databaseMaintenance.log /data/mysql/logs/databaseMaintenance_$CURRENT_DATE_UTC.log

# delete old output logs
find /data/mysql/logs/databaseMaintenance* -type f -mtime +5 | xargs rm -rf
