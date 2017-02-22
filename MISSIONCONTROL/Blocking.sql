/* show open transactions */
select  *
from    innodb_trx;

/* show blocking tran and what tran they are blocking */
select  *
from    innodb_lock_waits;
