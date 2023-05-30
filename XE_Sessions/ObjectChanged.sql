IF EXISTS (SELECT 1 FROM sys.server_event_sessions ses WHERE ses.name = 'ObjectChanged')
	DROP EVENT SESSION [ObjectChanged] ON SERVER;
GO
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
		object_id < 0
		AND
		(
			[sqlserver].[equal_i_sql_ansi_string]([object_type],'P ')
			AND
			(
				   [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_add%'		)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%enable%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%create%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%start%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%grant%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%update%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%alter%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%set%'		)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%change%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%delete%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%drop%'		)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%remove%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%disable%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%clean%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%stop%'		)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%revoke%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%attach%'	)
				OR [sqlserver].[like_i_sql_unicode_string]([object_name],  N'sp_%detach%'	)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_rename'		)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_autostats'	)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_subscribe'	)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_unsubscribe'	)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_configure'	) /* Server options */
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_serveroption'	) /* Linked Server */
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_bindrule'	)
			)
		)
		AND
		(
			[sqlserver].[equal_i_sql_ansi_string]([object_type],'X ')
			AND
			(
				   [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_add_trusted_assembly'		)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_drop_trusted_assembly'		)
				OR [sqlserver].[equal_i_sql_unicode_string]([object_name], N'sp_delete_backup_file_snapshot'	)
			)
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
	max_file_size=(10), /* Megabytes */
	max_rollover_files=(20)
)
WITH (STARTUP_STATE=ON)
GO

ALTER EVENT SESSION [ObjectChanged] ON SERVER STATE = START
