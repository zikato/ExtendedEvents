DECLARE @stackOrFrame xml = '' /* input the tsql_stack xml in format: <frames>…</frames> */

/* 
The xml format is for a clickable text. 
If your text contains special XML characters, you will need to tweak this code 
*/
;WITH
xmlShred AS
(
	SELECT
		COALESCE
		(
			CONVERT(varbinary(64), f.n.value('.[1]/@handle', 'varchar(max)'), 1),
			CONVERT(varbinary(64), f.n.value('.[1]/@sqlhandle', 'varchar(max)'), 1)
		) AS handle,
		COALESCE
		(
			f.n.value('.[1]/@offsetStart', 'int'),
			f.n.value('.[1]/@stmtstart', 'int')
		) AS offsetStart,
		COALESCE
		(
			f.n.value('.[1]/@offsetEnd', 'int'),
			f.n.value('.[1]/@stmtend', 'int')
		) AS offsetEnd,
		f.n.value('.[1]/@line', 'int') AS line,
		f.n.value('.[1]/@level', 'tinyint') AS stackLevel
	FROM @stackOrFrame.nodes('//frame') AS f(n)
)
SELECT
	xs.stackLevel,
	ca.outerText,
	ca2.statementText
FROM
	xmlShred AS xs
	CROSS APPLY sys.dm_exec_sql_text(xs.handle) AS dest
	CROSS APPLY (SELECT dest.text FOR XML PATH(''), TYPE) AS ca(outerText)
	CROSS APPLY
	(
		SELECT 
			SUBSTRING
			(	dest.text,
				xs.offsetStart / 2,
				(
					CASE
						WHEN xs.offsetEnd = -1
							THEN DATALENGTH(dest.text)
						ELSE xs.offsetEnd
					END 
					- xs.offsetStart / 2
				) / 2
			)
		FOR XML PATH(''), TYPE
	) AS ca2(statementText)
ORDER BY xs.stackLevel
OPTION (RECOMPILE);