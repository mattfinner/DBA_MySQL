# Ensure following are set...
# --log-slave-updates
# --skip-slave-start
# ...to allow PITR from SLAVE binlog
#
# Assumes login path "rootLogin" is set
# e.g. mysql_config_editor set --login-path=rootLogin --host=127.0.0.1 --user=root --password --port=3302
#
# Run this script on the SLAVE

cls

param (
    [string] $slave = "MySQL1"
    ,[string] $slaveFolder = "E:\MySQL\Data\NR_Data_Primary"
    ,[string] $masterBinlogFolder = "E:\MySQL\Data\NR_Data_Secondary"
    ,[datetime] $recoveryDateTime = (Get-Date)
)

# Get binlog and position to resume from
$binlogFile = Get-Content $slaveFolder\backupBinlogStart.txt
$binlog = $binlogFile.Split("`t")[0]
$binlogPosition = $binlogFile.Split("`t")[1]

# Copy binlogs from primary

# Create PITR file

# Apply PITR to secondary
