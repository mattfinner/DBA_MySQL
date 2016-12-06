# Ensure following are set...
# --log-slave-updates
# --skip-slave-start
# ...to allow PITR from SLAVE binlog
#
# Assumes login path "rootLogin" is set
# e.g. mysql_config_editor set --login-path=rootLogin --host=127.0.0.1 --user=root --password --port=3302
#
# Run this script on the SLAVE

param (
    [string] $slave,
    [string] $slaveFolder,
    [string] $slaveCnfFile,
    [int] $slaveServerId,
    [string] $backupFolder
)

try {
    "*** STARTING SCRIPT RestoreSlave.ps1 ***"

    # Stop SLAVE
    "001 : Suspending Slave..."
    Stop-Service $slave > $null

    # Delete nr_archive on SLAVE (make sure you close Workbench etc)
    "002 : Deleting SLAVE..."
    if(Test-Path $slaveFolder) {Remove-Item "$slaveFolder" -Recurse -Force }

    # Copy db files accross to SLAVE
    "003 : Restoring files..."
    & "ROBOCOPY" "$backupFolder" "$slaveFolder" /E /xo

    # Delete SLAVE uuid
    "004 : Resetting server UUID..."
    del "$slaveFolder\auto.cnf"

    # Set ServerId of MASTER
    "005 : Setting serverId of SLAVE..."
    $old = 'server_id = ' + $slaveServerId + '1'
    $new = 'server_id = ' + $slaveServerId + '0'
    (Get-Content $slaveCnfFile).replace($old, $new) | Set-Content $slaveCnfFile

    # Remove readonly flag
    "006 : Setting SLAVE to readonly"
    (Get-Content $slaveCnfFile).replace('read_only=false', 'read_only=true') | Set-Content $slaveCnfFile

    # Start SLAVE
    "007 : Starting Slave..."
    Start-Service $slave
}
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    throw "Database restore failed : " + $FailedItem + " : " + $ErrorMessage
}
