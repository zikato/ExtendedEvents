CREATE EVENT SESSION [RPC_Completed_Timeout] ON SERVER 
ADD EVENT sqlserver.rpc_completed
(
	SET collect_statement=1
    ACTION
	(
		sqlserver.client_app_name
		, sqlserver.client_hostname
		, sqlserver.database_name
		, sqlserver.server_instance_name
		, sqlserver.session_id
	)
    WHERE 
		[package0].[equal_uint64]([result], 2) /* Abort */
)
ADD TARGET package0.event_file
(
	SET filename = N'RPC_Completed_Timeout'
	, max_file_size = 3
	, max_rollover_files = 5
)
