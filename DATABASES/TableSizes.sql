/* Table size in a database */
SELECT 	table_name
		, ( data_length + index_length ) / 1024 / 1024 "Table Size in MB"
        , ( data_free )/ 1024 / 1024 "Table Space in MB"
FROM information_schema.TABLES
WHERE  table_schema = 'nr_archive';
