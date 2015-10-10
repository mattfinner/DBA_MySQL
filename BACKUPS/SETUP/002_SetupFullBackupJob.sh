#!/bin/bash

# copy backup script to folder
cp /home/matt/backupWithCompression.sh /data/mysql/scripts/
cp /home/matt/purgeBackupWithCompressionJobLog.sh /data/mysql/scripts/

# Change user to mysql and make executable
chown -R mysql:mysql /data/mysql/scripts/*
chmod +x /data/mysql/scripts/*

# Create log for job output
touch /data/mysql/logs/backupWithCompression.log
chown mysql:mysql /data/mysql/logs/backupWithCompression.log

# Create cron job
crontab -u mysql -l | { cat; echo "0 0 * * * /data/mysql/scripts/backupWithCompression.sh >> /data/mysql/logs/backupWithCompression.log"; } | crontab -u mysql -
crontab -u mysql -l | { cat; echo "59 23 1 * * /data/mysql/scripts/purgeBackupWithCompressionJobLog.sh"; } | crontab -u mysql -
