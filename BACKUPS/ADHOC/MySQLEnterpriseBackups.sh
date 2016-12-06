#full compressed database backup
mysqlbackup --backup-image=C:\backups\sales.mbi --backup-dir=C:\backups backup-to-image --user root --password --compress --compress-level=5 --port=3301

#partial partition backup (only available on version 5.7.4 and above)
