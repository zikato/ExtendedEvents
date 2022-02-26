<#
ostress help
USAGE:

  -S name of Microsoft SQL Server server to connect to
  -D ODBC data source name to use for connection
  -E use Windows auhentication to connect (default)
  -U login ID
  -P password
  -d database name
  -Q"single batch query to process"
  -i SQL/RML file name or file wildcard to process
  -n number of connections processing each input file/query - stress mode
  -r number of iterations for each connection to execute its input file/query
  -o output directory to write query results and log file
  -l login timeout (sec)
  -L integer value representing the language id
  -t query timeout (sec)
  -p network packet size for connections - SQL Server only
  -q quiet mode; suppress all query output
  -v verbose mode; show additional diagnostic output
  -m [stress | replay] run in stress or replay mode
  -a default password to use for SQL authentication during replay
  -c control file name - required for replay mode
  -T enable trace flag
  -fx write query results as XML
  -N disable "OSTRESS exiting" message
  -M Advanced setting: max threads allowed, 0 is default setting.
  -b Stop processing if an error is encountered during query execution.
#>

# Typo in the procedure name
ostress -E -S'localhost' -d'ExtendedEvents' -Q"exec dbo.GetColour" -n5 -r5 -q

# Custom raise error
ostress -E -S'localhost' -d'master' -Q"RAISERROR('We''ve Been Trying To Reach You About Your Car''s Extended Warranty', 11, 1)" -n1 -r3 -q

# Missing Execute permissions for this procedure
ostress -S'localhost' -d'ExtendedEvents'-U'BillyNoRights' -P'Str0ngPa$$w0rd!' -Q"EXEC dbo.LimitedAccess" -n10 -r5 -q

# Executing a procedure that tries to grant itself the permissions
ostress -S'localhost' -d'ExtendedEvents' -U'LimitedPermissions' -P'Str0ngPa$$w0rd!' -Q"EXEC dbo.BotchedPermissions" -n10 -r5 -q

# Various errors - more info inside the sql script
ostress -E -S'localhost' -d'ExtendedEvents' -i"$pwd/WorkloadSimulation/ErrorWorkload.sql" -n4 -r20 -q

# Bad password - Error 18456
sqlcmd -S'localhost' -U'BillyNoRights' -P'BadPassword' -H "AnotherPc"

# Divide by zero for some executions
for ($i=1; $i -le 10; $i++) 
{sqlcmd -S'localhost' -U'LimitedPermissions' -P'Str0ngPa$$w0rd!' -Q "SELECT 10/($i%3)" -H "Calculator"}