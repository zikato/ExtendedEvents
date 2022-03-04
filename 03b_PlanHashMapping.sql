
/*
###############################################################################
	Search Query plan by Query plan hash signed
###############################################################################
*/
DECLARE @queryPlanHashSigned bigint = /* query_plan_hash_signed from XE */

/* Search the Plan Cache using Query plan hash */
SELECT 
	deqs.query_hash AS dmvHashBinary
	, CAST(@queryPlanHashSigned AS binary(8)) AS xePlanHashBinary
	, @queryPlanHashSigned AS xePlanHashBigint
	, dest.text
	, deqp.query_plan
FROM sys.dm_exec_query_stats AS deqs 
CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) AS dest
CROSS APPLY sys.dm_exec_query_plan(deqs.plan_handle) AS deqp
WHERE deqs.query_plan_hash = CAST(@queryPlanHashSigned AS binary(8))

/* Search the Query Store using Query plan hash */
SELECT 
	qsq.query_hash
	, qsp.query_plan_hash
	, @queryPlanHashSigned AS queryPlanHashSigned
	, qsqt.query_sql_text
	, CAST(qsp.query_plan AS xml) AS queryPlan
FROM sys.query_store_query AS qsq
LEFT JOIN sys.query_store_plan AS qsp
	ON qsp.query_id = qsq.query_id
LEFT JOIN sys.query_store_query_text AS qsqt
	ON qsqt.query_text_id = qsq.query_text_id
WHERE qsp.query_plan_hash = CAST(@queryPlanHashSigned AS binary(8))
