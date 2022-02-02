CREATE EVENT SESSION [ObjectChanged] ON SERVER 
ADD EVENT sqlserver.module_end
(
	SET collect_statement=(1)
    ACTION
	(
		sqlserver.client_app_name,
		sqlserver.client_hostname,
		sqlserver.database_name,
		sqlserver.is_system,
		sqlserver.server_instance_name,
		sqlserver.tsql_stack,
		sqlserver.username
	)
    WHERE 
	(
		[sqlserver].[equal_i_sql_ansi_string]([object_type],'P ') 
		AND
		(
			[sqlserver].[like_i_sql_unicode_string]([object_name], N'sp_add_%')
			OR [sqlserver].[like_i_sql_unicode_string]([object_name], N'sp_update_%')
			OR [sqlserver].[like_i_sql_unicode_string]([object_name], N'sp_delete_%')
			OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_attach_schedule')
			OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_detach_schedule')
			OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_rename')
			OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_serveroption')
		)
	)
),
ADD EVENT sqlserver.object_altered
(
	SET collect_database_name=(1)
    ACTION
	(
		sqlserver.client_app_name,
		sqlserver.client_hostname,
		sqlserver.database_name,
		sqlserver.is_system,
		sqlserver.server_instance_name,
		sqlserver.sql_text,
		sqlserver.tsql_stack,
		sqlserver.username
	)
    WHERE 
	(
		[package0].[equal_uint64]([ddl_phase],'Commit') 
		AND [package0].[equal_boolean]([sqlserver].[is_system], (0))
		AND [sqlserver].[not_equal_i_sql_unicode_string]([database_name], N'tempdb') 
		AND [package0].[not_equal_uint64]([object_type],'SERVICE') 
		AND [package0].[not_equal_uint64]([object_type],'STATISTICS') 
		AND [package0].[not_equal_uint64]([object_type],'SVCQ')
		AND NOT 
		(
			[package0].[equal_uint64]([object_type],'SRVXESES')
			AND 
			(
				[sqlserver].[equal_i_sql_unicode_string]([sqlserver].[client_app_name],N'SQLServerCEIP')
			)
		)
		AND NOT [sqlserver].[like_i_sql_unicode_string]([sqlserver].[client_app_name], N'SqlQueryNotification%')
	)
),
ADD EVENT sqlserver.object_created
(
	SET collect_database_name=(1)
    ACTION
	(
		sqlserver.client_app_name,
		sqlserver.client_hostname,
		sqlserver.database_name,
		sqlserver.is_system,
		sqlserver.server_instance_name,
		sqlserver.sql_text,
		sqlserver.tsql_stack,
		sqlserver.username
	)
    WHERE 
	(
		[package0].[equal_uint64]([ddl_phase],'Commit') 
		AND [package0].[equal_boolean]([sqlserver].[is_system], (0))
		AND [sqlserver].[not_equal_i_sql_unicode_string]([database_name], N'tempdb') 
		AND [package0].[not_equal_uint64]([object_type],'SERVICE') 
		AND [package0].[not_equal_uint64]([object_type],'STATISTICS') 
		AND [package0].[not_equal_uint64]([object_type],'SVCQ')
		AND NOT 
		(
			[package0].[equal_uint64]([object_type],'SRVXESES')
			AND 
			(
				[sqlserver].[equal_i_sql_unicode_string]([sqlserver].[client_app_name],N'SQLServerCEIP')
			)
		)
		AND NOT [sqlserver].[like_i_sql_unicode_string]([sqlserver].[client_app_name], N'SqlQueryNotification%')
	)
),

ADD EVENT sqlserver.object_deleted
(
	SET collect_database_name=(1)
    ACTION
	(
		sqlserver.client_app_name,
		sqlserver.client_hostname,
		sqlserver.database_name,
		sqlserver.is_system,
		sqlserver.server_instance_name,
		sqlserver.sql_text,
		sqlserver.tsql_stack,
		sqlserver.username)
    WHERE 
	(
		[package0].[equal_uint64]([ddl_phase],'Commit') 
		AND [package0].[equal_boolean]([sqlserver].[is_system], (0))
		AND [sqlserver].[not_equal_i_sql_unicode_string]([database_name], N'tempdb') 
		AND [package0].[not_equal_uint64]([object_type],'SERVICE') 
		AND [package0].[not_equal_uint64]([object_type],'STATISTICS') 
		AND [package0].[not_equal_uint64]([object_type],'SVCQ')
		AND NOT 
		(
			[package0].[equal_uint64]([object_type],'SRVXESES')
			AND 
			(
				[sqlserver].[equal_i_sql_unicode_string]([sqlserver].[client_app_name],N'SQLServerCEIP')
			)
		)
		AND NOT [sqlserver].[like_i_sql_unicode_string]([sqlserver].[client_app_name], N'SqlQueryNotification%')
	)
)
ADD TARGET package0.event_file
(
	SET filename=N'ObjectChanged',
	max_file_size=(10),
	max_rollover_files=(20)
)
GO