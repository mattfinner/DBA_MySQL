/* Get version */
SHOW VARIABLES LIKE "%version%";

/* Drop table if exists */
DROP TABLE IF EXISTS sakila.partitionedtable;

/* Create partitioned table */
CREATE TABLE sakila.partitionedtable (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `createdDate` datetime NOT NULL,
  KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY RANGE (TO_DAYS(createdDate)) (
	PARTITION p2013 VALUES LESS THAN (TO_DAYS('2014-1-1 00:00:00'))
	, PARTITION p2014 VALUES LESS THAN (TO_DAYS('2015-1-1 00:00:00'))
    , PARTITION p2015 VALUES LESS THAN (TO_DAYS('2016-1-1 00:00:00'))
    , PARTITION p2016 VALUES LESS THAN MAXVALUE
);

/* Insert some records */
INSERT INTO sakila.partitionedtable (name, createdDate)
VALUES ('Matt', '2013-1-1'), ('Helen', '2014-1-1'), ('KF', '2015-1-1'), ('Jeff', '2016-1-1'), ('Paul', '2017-1-1');


/* See which rows are in which parttitions */
EXPLAIN PARTITIONS SELECT * FROM sakila.partitionedtable;

SELECT	PARTITION_ORDINAL_POSITION, TABLE_ROWS, PARTITION_METHOD
FROM	information_schema.PARTITIONS
WHERE	TABLE_SCHEMA = 'sakila' AND TABLE_NAME = 'partitionedtable';

/*
http://dev.mysql.com/doc/mysql-enterprise-backup/4.0/en/backup-partial-options.html

Backing up and percomna restoring of partitioned tables are only supported for MySQL 5.7.4 and later.
Also, individual partitions cannot be selectively backed up or restored.
Tables selected by the --include-tables and --exclude-tables options are always backed up or restored in full.
*/

/* insert another record into the active partition */
INSERT INTO sakila.partitionedtable (name, createdDate)
VALUES ('Marilyn', '2017-1-1');

/* Show list of tablespace files */
SELECT * FROM INFORMATION_SCHEMA.FILES;

/* CheckDB on partition */
ALTER TABLE sakila.partitionedtable CHECK PARTITION p2013;
