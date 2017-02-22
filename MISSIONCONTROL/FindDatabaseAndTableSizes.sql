/* Database size */
SELECT table_schema "Data Base Name",
    sum( data_length + index_length ) / 1024 / 1024 "Data Base Size in MB",
    sum( data_free )/ 1024 / 1024 "Free Space in MB"
FROM information_schema.TABLES
GROUP BY table_schema ;

/* Table size in a database */
SELECT 	table_name
		, ( data_length + index_length ) / 1024 / 1024 "Table Size in MB"
        , ( data_free )/ 1024 / 1024 "Table Space in MB"
FROM information_schema.TABLES
WHERE  table_schema = 'nr_archive';
