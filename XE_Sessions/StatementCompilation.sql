CREATE EVENT SESSION [StatementCompilation] ON SERVER 
ADD EVENT sqlserver.sp_cache_insert
(
	SET 
		collect_cached_text = 1
		, collect_database_name = 1
    ACTION
	(
		sqlserver.client_app_name
		, sqlserver.client_hostname
		, sqlserver.query_hash_signed
		, sqlserver.query_plan_hash_signed
		, sqlserver.server_instance_name
		, sqlserver.server_principal_name
		, sqlserver.tsql_stack
	)
    WHERE
		[package0].[greater_than_uint64]([database_id], 4)
)
, ADD EVENT sqlserver.sql_statement_recompile
(
	SET
		collect_object_name = 1
		, collect_statement = 1
    ACTION
	(
		sqlserver.client_app_name
		, sqlserver.client_hostname
		, sqlserver.database_name
		, sqlserver.is_system
		, sqlserver.query_hash_signed
		, sqlserver.query_plan_hash_signed
		, sqlserver.server_instance_name
		, sqlserver.server_principal_name
		, sqlserver.tsql_stack
	)
    WHERE 
	
		[package0].[greater_than_uint64]([sqlserver].[database_id],4)
		AND [package0].[not_equal_uint64]([recompile_cause], 11) /* Option (recompile) requested */
)
ADD TARGET package0.event_file
(
	SET filename=N'StatementCompilation'
	, max_file_size = 20
	, max_rollover_files = 10
)