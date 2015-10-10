#!/bin/bash
# exit script if error
set -e

# Print start message for logfile
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting Archive Logs"

# Flush bin logs
echo "$(date '+%Y-%m-%d %H:%M:%S') - Flushing Logs"
mysqladmin --user="bkpuser" --password="Harewood21" flush-logs

# Find current master log
CURRENT_LOG=$(mysql --user="bkpuser" --password="Harewood21" -e "show master status" -s | tail -n 1 | awk {'print $1'});

# Create folder for todays logs
echo "$(date '+%Y-%m-%d %H:%M:%S') - Creating backup folder for today"
CURRENT_DATE=$(date '+%d_%m_%Y')
mkdir -p /data/mysql/backups/LOGS/$CURRENT_DATE

# Copy log files to backup folder
echo "$(date '+%Y-%m-%d %H:%M:%S') - Copying logs"
find /data/mysql/binlogs -maxdepth 1 -mindepth 1 -not -name '*'$CURRENT_LOG -print0 | xargs -0 cp -u -t /data/mysql/backups/LOGS/$CURRENT_DATE

if [ $? -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Logs copied"
fi

# If its 23:30 and yesterdays backup copied ok then purge the bin logs
if [ $? -eq 0 ] && [ $(date '+%H%M') -gt -2329 ] && [ $(date '+%H%M') -lt 0 ]; then
  mysql --user='matt' --password='Harewood21' -e 'PURGE BINARY LOGS BEFORE DATE(NOW()) + INTERVAL 1410 MINUTE;' -s
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Logs purged"
fi
