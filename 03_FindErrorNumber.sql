/* 
Database engine errors documentation:

https://docs.microsoft.com/en-us/sql/relational-databases/errors-events/database-engine-events-and-errors?view=sql-server-ver15

*/

SELECT 
	*
FROM sys.messages AS m
WHERE
	m.language_id = 1033 /* us_english - found in msglangid column of sys.syslanguages */
	AND m.[text] LIKE '%%' -- COLLATE Latin1_General_CS_AS /* input a wildcard search */
OPTION (RECOMPILE)