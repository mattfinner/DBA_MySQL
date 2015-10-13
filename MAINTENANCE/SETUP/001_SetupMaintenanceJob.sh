#!/bin/bash
set -e

# copy backup script to folder
cp /home/matt/MAINT/databaseMaintenance.sh /data/mysql/scripts/
cp /home/matt/MAINT/purgeDatabaseMaintenanceJobLog.sh /data/mysql/scripts/

# Change user to mysql and make executable
chown -R mysql:mysql /data/mysql/scripts/*
chmod +x /data/mysql/scripts/*

# Create cron job
crontab -u mysql -l | { cat; echo "0 2 * * * /data/mysql/scripts/databaseMaintenance.sh > /data/mysql/logs/databaseMaintenance.log 2>&1"; } | crontab -u mysql -
crontab -u mysql -l | { cat; echo "59 23 * * * /data/mysql/scripts/purgeDatabaseMaintenanceJobLog.sh"; } | crontab -u mysql -
