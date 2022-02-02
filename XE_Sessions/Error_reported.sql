CREATE EVENT SESSION Error_reported
ON SERVER
ADD EVENT sqlserver.error_reported
(
	ACTION
	(
		sqlserver.client_app_name
		, sqlserver.client_hostname
		, sqlserver.database_id
		, sqlserver.server_instance_name
		, sqlserver.server_principal_name
		, sqlserver.sql_text
		, sqlserver.tsql_stack
	)
	WHERE 
		package0.greater_than_int64(sysusermsgs.severity, (10))
		
)
ADD TARGET package0.event_file
(SET filename = N'Error_reported', max_file_size = (20))
GO