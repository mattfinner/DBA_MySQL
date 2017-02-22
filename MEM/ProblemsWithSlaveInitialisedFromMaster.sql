/* Had a problem where MEM would pick up either master of slave (but not both).
   Got in touch with Oracle and they told us the server_uuid is also stored in table below
   (despite being changed when setting up the slave) */

show global variables like 'server_uuid';

select * from mysql.inventory;

truncate mysql.inventory;
