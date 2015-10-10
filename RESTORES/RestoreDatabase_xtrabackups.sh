# Stop the mysql service to restore
systemctl stop mysqld

# Delete the contents of datadir
rm -R /var/lib/mysql

# Restore the database
innobackupex --copy-back /data/backups/2015-09-30_13-35-56

# Make sure everything is owned by mysql group again
chown -R mysql: /var/lib/mysql

# Startup MySQL again
systemctl start mysqld
