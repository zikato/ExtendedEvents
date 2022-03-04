/* Either provide the job Guid in the CTE at the top
or the application name in the where clause at the bottom */

;WITH 
jobHostName
AS
(
	SELECT CAST('' AS VARCHAR(32)) AS jobID -- without 0x Example: A21C03C3894485428FA50B6D287D41DC
)
, stringToJobId
AS
(
	SELECT 
		SUBSTRING(jhn.jobID,7,2) +	/* 1, 2 */
		SUBSTRING(jhn.jobID,5,2) +	/* 3, 2 */
		SUBSTRING(jhn.jobID,3,2) +	/*  */
		SUBSTRING(jhn.jobID,1,2) +	/* */
		'-' +						/* */
		SUBSTRING(jhn.jobID,11,2) +	/* */
		SUBSTRING(jhn.jobID,9,2) +	/* */
		'-' +						/* */
		SUBSTRING(jhn.jobID,15,2) +	/* */
		SUBSTRING(jhn.jobID,13,2) +	/* */
		'-' +						/* */
		SUBSTRING(jhn.jobID,17,4) +	/* */
		'-' +						/* */
		SUBSTRING(jhn.jobID,21,12)  /* */
			AS newJobID		  
	FROM jobHostName jhn
)
, jobSteps
AS
(
	SELECT 
		ca.job_id
		, CONCAT
		(
			'SQLAgent - TSQL JobStep (Job 0x',
			  SUBSTRING(ca.job_id, 7, 2)			  
			, SUBSTRING(ca.job_id, 5, 2)
			, SUBSTRING(ca.job_id, 3, 2)
			, SUBSTRING(ca.job_id, 1, 2)
			, SUBSTRING(ca.job_id, 12, 2)
			, SUBSTRING(ca.job_id, 10, 2)
			, SUBSTRING(ca.job_id, 17, 2)
			, SUBSTRING(ca.job_id, 15, 2)
			, SUBSTRING(ca.job_id, 20, 4)
			, SUBSTRING(ca.job_id, 25, 12)
			, ' : Step '
			, CAST(sj.step_id AS varchar(4))
			, ')'
		) AS jobAsString
		, j.name AS jobName
		, sj.step_id
		, sj.step_name
		, sj.command
	FROM msdb.dbo.sysjobs j
	JOIN msdb.dbo.sysjobsteps sj ON j.job_id = sj.job_id
	CROSS APPLY ( VALUES (LEFT(CAST(j.job_id AS VARCHAR(36)), 36))) AS ca(job_id)
)
SELECT 
	*
FROM stringToJobId r
FULL JOIN jobSteps js ON r.newJobID = js.job_id
WHERE js.jobAsString = '' /* Client application name - format "SQLAgent - TSQL JobStep (Job 0x20A0… :Step 10)" */
OPTION (RECOMPILE)