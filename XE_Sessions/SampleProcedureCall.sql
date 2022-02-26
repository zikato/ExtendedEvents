CREATE EVENT SESSION [SampleProcedureCall] ON SERVER 
ADD EVENT sqlserver.module_start
(
	SET collect_statement = 1
    ACTION
	(
		sqlserver.client_app_name
		, sqlserver.client_hostname
		, sqlserver.server_instance_name
		, sqlserver.server_principal_name
	)
    WHERE 
		[object_name]=N'Caller1' /* change to your tracked object */
		AND [package0].[counter] <= 10 /* change the sample size */
)
/* I'm using Watch Live Data but event_file is also fine */