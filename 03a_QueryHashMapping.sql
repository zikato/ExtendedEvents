/*
###############################################################################
	Search Query text by Query hash signed
###############################################################################
*/

DECLARE @queryHashTable AS table
(
	query_hash_signed bigint NOT NULL
	, queryHashBinary AS CAST(query_hash_signed AS binary(8)) PERSISTED
)

INSERT INTO @queryHashTable ([query_hash_signed])
VALUES
( ) /* <--- insert the Query_hash_signed here */

/* Search the Query Store using Query hash */
SELECT 
	qsq.query_hash
	, qht.query_hash_signed
	, qsqt.query_sql_text COLLATE Latin1_General_100_CI_AS_SC AS query_sql_text
	, 'QueryStore' AS src
FROM sys.query_store_query AS qsq
JOIN @queryHashTable AS qht
	ON qht.queryHashBinary = qsq.query_hash
LEFT JOIN sys.query_store_plan AS qsp
	ON qsp.query_id = qsq.query_id
LEFT JOIN sys.query_store_query_text AS qsqt
	ON qsqt.query_text_id = qsq.query_text_id
UNION 
/* Search the Plan Cache using Query hash */
SELECT 
	deqs.query_hash AS dmvHashBinary
	, qht.query_hash_signed
	, dest.text COLLATE Latin1_General_100_CI_AS_SC AS query_sql_text
	, 'dm_exec_query_stats' AS src
FROM sys.dm_exec_query_stats AS deqs 
JOIN @queryHashTable AS qht
	ON qht.queryHashBinary = deqs.query_hash
OUTER APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
OPTION (RECOMPILE)
