/* Corrupt log */
STOP SLAVE;

START SLAVE;

SHOW SLAVE STATUS;

/* Get relay_master_log_file and exec_master_log_pos from above */

change master to master_log_file='mysql-bin.000080',master_log_pos=666022554;

START SLAVE;
