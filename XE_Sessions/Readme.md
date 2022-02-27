# Sessions and use cases

## Error_reported

Good for debugging hard to find errors (branching, nesting, triggers, etc.)

* Use the *error_number* or *message* column to filter for specific errors.
* Plug the *tsql_stack* into the 02_ParseTsqlStack.sql script to unravel the nesting

## ModuleStart_Histogram

* Gather the module usage statistics. In my example - stored procedures.
* Stoping and starting the event can be used to clear the histogram. Combine it with persisting the histogram data in a table at periodic intervals

## ObjectChanged

* A lightweight audit. It doesn't include all the possibilities but can replace the DDL Trigger homegrown audits.

## RPC_Completed_Abort

* Used to track timeouts to procedures (aborted by client).

## SampleProcedureCall

* When you need to test the procedure and don't know what parameters are sent from the application.
* There is a limit of first 10 calls in the example - this can be changed.

## StatementCompilation

* Used to track changes to plans.
* Especially on systems without the Query Store enabled (old systems, secondary replicas in AGs)
* Grouping by *query_hash_signed* and *query_plan_hash_signed* can provide a quick overview.

