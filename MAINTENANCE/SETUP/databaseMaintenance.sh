#!/bin/bash
# exit script if error
set -e

# Check integrity
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting check"
mysqlcheck -u "root" --password=Harewood21 --check --all-databases
echo "$(date '+%Y-%m-%d %H:%M:%S') - Finished check"

# Optimize table and indexes
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting optimise"
mysqlcheck -u "root" --password=Harewood21 --optimize --all-databases
echo "$(date '+%Y-%m-%d %H:%M:%S') - Finished optimise"
