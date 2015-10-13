#!/bin/bash
# exit script if error
set -e

# Print start message for logfile
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting full backup"
CURRENT_DATE_UTC=$(date '+%Y-%m-%d')

# Backup the database
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backing up database"
innobackupex --user=bkpuser --password=Harewood21 /data/mysql/backups/FULL
echo "$(date '+%Y-%m-%d %H:%M:%S') - Database backed up"

# Prepare the backup
echo "$(date '+%Y-%m-%d %H:%M:%S') - Prepare backup"
innobackupex --apply-log /data/mysql/backups/FULL/$CURRENT_DATE_UTC_*/
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup prepared"

# Compress backup
echo "$(date '+%Y-%m-%d %H:%M:%S') - Compressing backup"
tar -cvzf /data/mysql/backups/FULL/$CURRENT_DATE_UTC.tar.gz /data/mysql/backups/FULL/$CURRENT_DATE_UTC*/

if [ $? -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Backup compressed"
  rm -R /data/mysql/backups/FULL/$CURRENT_DATE_UTC*/
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Original folder removed"
  else
  echo "$(date '+%Y-%m-%d %H:%M:%S') - Compression failed"
fi
