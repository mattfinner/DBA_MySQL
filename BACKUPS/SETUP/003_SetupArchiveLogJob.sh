#!/bin/bash

# copy backup script to folder
cp /home/matt/archiveLogs.sh /data/mysql/scripts/
sudo cp /home/matt/purgeArchiveLogsJobLog.sh /data/mysql/scripts/

# Change user to mysql and make executable
chown -R mysql:mysql /data/mysql/scripts/*
chmod +x /data/mysql/scripts/*

# Create log for job output
touch /data/mysql/logs/archiveLogs.log
chown mysql:mysql /data/mysql/logs/archiveLogs.log

# Create cron job
crontab -u mysql -l | { cat; echo "*/30 * * * * /data/mysql/scripts/archiveLogs.sh >> /data/mysql/logs/archiveLogs.log"; } | crontab -u mysql -
crontab -u mysql -l | { cat; echo "29 0 * * * /data/mysql/scripts/purgeArchiveLogsJobLog.sh"; } | crontab -u mysql -
