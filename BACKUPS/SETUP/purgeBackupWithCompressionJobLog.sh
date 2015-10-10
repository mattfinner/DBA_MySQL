#!/bin/bash
# exit script if error
set -e

# copy last days logs into temp folder
cat /data/mysql/logs/backupWithCompression.log | tail -n 30 > /data/mysql/logs/tempBackupWithCompression
cat /data/mysql/logs/tempBackupWithCompression > /data/mysql/logs/backupWithCompression.log
rm /data/mysql/logs/tempBackupWithCompression
