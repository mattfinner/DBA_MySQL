# Ensure following are set...
# --log-slave-updates
# --skip-slave-start
# ...to allow PITR from SLAVE binlog
#
# Assumes login path "rootLogin" is set
# e.g. mysql_config_editor set --login-path=rootLogin --host=127.0.0.1 --user=root --password --port=3302
#
# Run this script on the new SLAV

param (
    [string] $slaveFolder,
    [string] $masterLogin,
    [string] $slaveLogin,
    [string] $masterHost,
    [int] $masterPort
)
try {
    "*** STARTING SCRIPT SyncSlave.ps1 ***"

    # Get binlog and position to resume from
    "001 : Getting binlog position..."
    $binlogFile = Get-Content $slaveFolder\backupBinlogStart.txt
    $binlog = $binlogFile.Split("`t")[0]
    $binlogPosition = $binlogFile.Split("`t")[1]

    # Sync SLAVE
    "002 : Sync slave..."
    $qs = "DROP USER IF EXISTS 'repluser'@'%';
    CREATE USER IF NOT EXISTS 'repluser'@'%' IDENTIFIED BY 'Passw0rd';
    GRANT REPLICATION SLAVE ON *.* TO 'repluser'@'%';"

    & "mysql.exe" --login-path=$masterLogin -e"$qs"

    $qs = "CHANGE MASTER TO
    MASTER_HOST = '" + $masterHost + "'
    , MASTER_PORT = " + $masterPort + "
    , MASTER_USER = 'repluser'
    , MASTER_PASSWORD = 'Passw0rd'
    , MASTER_LOG_FILE = '" + $binlog + "'
    , MASTER_LOG_POS = " + $binlogPosition + ";
    START SLAVE;"

$qs

    & "mysql.exe" --login-path=$slaveLogin -e"$qs"
}
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    throw "Sync SLAVE failed : " + $FailedItem + " : " + $ErrorMessage
}
