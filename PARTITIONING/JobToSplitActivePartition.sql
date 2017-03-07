/* Job log table */
CREATE TABLE job_log (eventTime DATETIME, eventType varchar(100), eventDesc varchar(4000));

/* Scheduled Event */
DROP EVENT dba_maint_split_active_partition;
CREATE EVENT dba_maint_split_active_partition
ON SCHEDULE EVERY 1 DAY
STARTS '2017-03-07 01:00:00'
DISABLE ON SLAVE
DO
  call nr_archive.splitActivePartition;

/* Procedure to split partition */
DROP PROCEDURE splitActivePartition;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `splitActivePartition`()
begin
	declare par int default to_days(curdate());
    #declare qs varchar(5000) default '';
    declare oldPartitionName varchar(5000);
    declare prevDate datetime default date_add(curdate(), interval -1 month);

	insert into job_log (eventTime, eventType, eventDesc) values (now(), 'Partition Split', 'Partition split started');

	if dayofmonth(curdate()) = 1 then
        set oldPartitionName = concat('p', year(prevDate), right(concat('0', month(prevDate)), 2));
        set @qs = CONCAT('ALTER TABLE sorm_message REORGANIZE PARTITION pAll INTO (PARTITION ', oldPartitionName, ' VALUES LESS THAN (', par, '), PARTITION pAll VALUES LESS THAN MAXVALUE);');
        prepare stmt FROM @qs;
		execute stmt;
        set @qs = CONCAT('ALTER TABLE sorm_nr_file REORGANIZE PARTITION pAll INTO (PARTITION ', oldPartitionName, ' VALUES LESS THAN (', par, '), PARTITION pAll VALUES LESS THAN MAXVALUE);');
        prepare stmt FROM @qs;
		execute stmt;
	end if;

    insert into nr_archive.job_log values (now(), 'Partition Split', 'Partition split finished');
end$$
DELIMITER ;
