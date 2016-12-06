param (
    [string] $newMasterLogin,
    [string] $newMasterCnfFile,
    [int] $newMasterServerId,
    [string] $newMasterInstance
)

try {
    "*** STARTING SCRIPT FailoverMaster.ps1 ***"

    # Promote old SLAVE to MASTER
    "001 : Promote old SLAVE to MASTER..."
    & "mysql.exe" --login-path=$newMasterLogin -e"STOP SLAVE; RESET SLAVE ALL;"

    # Remove readonly flag
    "002 : Setting MASTER to writable"
    (Get-Content $newMasterCnfFile).replace('read_only=true', 'read_only=false') | Set-Content $newMasterCnfFile

    # Set ServerId of MASTER
    "003 :Setting serverId of MASTER..."
    $old = 'server_id = ' + $newMasterServerId + '0'
    $new = 'server_id = ' + $newMasterServerId + '1'
    (Get-Content $newMasterCnfFile).replace($old, $new) | Set-Content $newMasterCnfFile

    # Restart new MASTER
    "004 : Restarting new MASTER..."
    Restart-Service $newMasterInstance

    "005 : Getting binlog position..."
    $binlog = & "mysql.exe" --login-path=$newMasterLogin -e"SHOW MASTER STATUS;"
    $binlogFile = $binlog.Split("`t")[5]
    $binlogPosition = $binlog.Split("`t")[6]
    "New MASTER binlog file at time of cutover : " + $binlogFile +  "`nBinlog Position is : " + $binlogPosition
}
catch {
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    throw "Failed to Failover Master : " + $FailedItem + " : " + $ErrorMessage
}
