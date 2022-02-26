CREATE EVENT SESSION [ModuleStart_Histogram] ON SERVER 
ADD EVENT sqlserver.module_start
(
    WHERE 
	[sqlserver].[equal_i_sql_ansi_string]([object_type],'P ')
)
ADD TARGET package0.histogram
(
    SET filtering_event_name=N'sqlserver.module_start'
    ,slots=8000
    ,source=N'object_name'
    ,source_type=0
)
GO


