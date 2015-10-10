#!/bin/bash
# exit script if error
set -e

# copy last days logs into temp folder
cat /data/mysql/logs/archiveLogs.log | tail -n 240 > /data/mysql/logs/tempArchiveLogs
cat /data/mysql/logs/tempArchiveLogs > /data/mysql/logs/archiveLogs.log
rm /data/mysql/logs/tempArchiveLogs
