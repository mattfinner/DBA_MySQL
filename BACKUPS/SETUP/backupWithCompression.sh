#!/bin/bash
# exit script if error
set -e

# Print start message for logfile
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting Archive Logs"

# Make folder for current date
echo "$(date '+%Y-%m-%d %H:%M:%S') - Creating backup folder for today"
CURRENT_DATE=$(date '+%d_%m_%Y')
mkdir -p /data/mysql/backups/FULL/$CURRENT_DATE

# Backup the database
echo "$(date '+%Y-%m-%d %H:%M:%S') - Backing up database"
innobackupex --user=bkpuser --password=Harewood21 --stream=xbstream --compress /data/mysql/backups/ > /data/mysql/backups/FULL/$CURRENT_DATE/FULL_$(hostname)_$(date '+%d_%m_%Y_%H_%M').xbstream
echo "$(date '+%Y-%m-%d %H:%M:%S') - Database backed up"
