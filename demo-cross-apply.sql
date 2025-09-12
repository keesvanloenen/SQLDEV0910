-- ------------------------------------------------------------------------
-- Praktijkvoorbeeld van het gebruik van APPLY
-- SQL Server heeft Dynamic Management (DM) Views en Table Valued Functions
-- Deze kunnen enkel via  APPLY gekoppeld worden.
-- VIEW: sys.dm_exec_query_stats bevat sql_handle kolom.
-- TVF: sys.dm_exec_sql_text(sql_handle). Retourneert de query text.
-- ------------------------------------------------------------------------

USE WorldCup2018;
GO

-- Voer 5x uit:

SELECT * FROM Other.Countries;

-- dm_exec_query_stats view bevat alle info als wanneer en hoevaak
-- (het query statement zélf staat elders)

SELECT * FROM sys.dm_exec_query_stats qs;

-- We kunnen enkele WHERE clauses toevoegen en deze zsm erna uitvoeren

SELECT * 
FROM sys.dm_exec_query_stats qs
WHERE qs.execution_count = 5
AND qs.last_execution_time > DATEADD(minute, -2, SYSDATETIME());

-- Het query statement staat in een TVF die een sql handle verwacht ...

SELECT *
FROM sys.dm_exec_sql_text(0x02000000D6FE5B25B352AFFE8CD9C95AE8EAAC50C0B3808B0000000000000000000000000000000000000000);

------------------------------------------------------------------------------

-- Optioneel:
-- De View en TVF kunnen we koppelen via een CROSS APPLY:

SELECT 
	dm_tvf.text
	, dm_view.execution_count
	, dm_view.total_elapsed_time
	, dm_view.last_execution_time
	, dm_view.sql_handle
FROM sys.dm_exec_query_stats AS dm_view
CROSS APPLY sys.dm_exec_sql_text(dm_view.sql_handle) AS dm_tvf
WHERE dm_view.execution_count = 5
AND dm_tvf.text LIKE '%Countries%' 
ORDER BY dm_view.total_elapsed_time DESC;
