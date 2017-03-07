/* Enable MySQL Events */
-- set the following line in my.cnf "event_scheduler=ON"
SET GLOBAL event_scheduler = ON;

/* Just need to run this on the master - will replicate to Slave */
DROP EVENT dba_maint_split_active_partition;
CREATE EVENT dba_maint_split_active_partition
ON SCHEDULE EVERY 1 DAY
STARTS '2017-03-07 01:00:00'
DISABLE ON SLAVE
DO
  call nr_archive.splitActivePartition;

/* List all events */
SHOW EVENTS;

/* To view failed events check the MySQL log */
