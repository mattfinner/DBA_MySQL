# Ensure following are set...
# --log-slave-updates
# --skip-slave-start
# ...to allow PITR from SLAVE binlog
#
# Assumes login path "rootLogin" is set
# e.g. mysql_config_editor set --login-path=rootLogin --host=127.0.0.1 --user=root --password --port=3302
#
# Script assumes mysql bin path added to windows PATH
#
# Run this script on the SLAVE

param (
    [string] $instanceName,
    [string] $instanceLogin,
    [string] $instanceFolder,
    [string] $backupDestination,
    [boolean] $deleteBackupFolderBefore = $false
)

try {
    "*** STARTING SCRIPT BackupSlave.ps1 ***"

    # Suspend slave
    "001 : Suspending Slave..."
    & "mysql.exe" --login-path=$instanceLogin -e"STOP SLAVE; FLUSH TABLES WITH READ LOCK; SET GLOBAL innodb_fast_shutdown = 0;"

    # Shutdown SLAVE
    "002 : Shuting down Slave..."
    & "mysqladmin.exe" --login-path=$instanceLogin shutdown

    # Make sure service stop before proceeding
    (Get-Service $instanceName).WaitForStatus('Stopped')

    # Copy changed SLAVE db files to destination
    "003 : Backing up changed db files..."
    if($deleteBackupFolderBefore) {Remove-Item "$backupDestination" -Recurse -Force}
    &"ROBOCOPY" "$instanceFolder" "$backupDestination" /E /xo

    # Start up SLAVE instance
    "004 : Starting up SLAVE instance..."
    net start $instanceName

    # Get current binlog file and position from SLAVE and write to backup folder
    "005 : Getting binlog position..."
    $binlog = & "mysql.exe" --login-path=$instanceLogin -e"SHOW MASTER STATUS;"
    $binlogFile = $binlog.Split("`t")[5]
    $binlogPosition = $binlog.Split("`t")[6]
    $binlogFile +  "`t" + $binlogPosition > $backupDestination\backupBinlogStart.txt

    # Start replication
    "006 : Starting replication..."
    & "mysql.exe" --login-path=$instanceLogin -e"START SLAVE;"
}
catch {
    net start $instanceName
    & "mysql.exe" --login-path=$instanceLogin -e"START SLAVE;"
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    throw "Database backup failed : " + $FailedItem + " : " + $ErrorMessage
}

# .\BackupSlave.ps1 "MySQL1" "rootLogin3301" "D:\Program-Files\MySQL\Primary\bin" "E:\MySQL\Data\NR_Data_Primary" "E:\SQLBackups\SLAVE_BAK"
