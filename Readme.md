# Troubleshoot Real-World Scenarios with Extended Events

## Prerequisites

### Install Ostress

https://docs.microsoft.com/en-us/troubleshoot/sql/tools/replay-markup-language-utility#obtain-the-rml-utilities-for-sql-server

Default installation location is 
`C:\Program Files\Microsoft Corporation\RMLUtils`

Add the *ostress.exe* to the Path so it can be run from anywhere.

1. Windows menu - write "Edit the system environment variables"
1. Click on "Environment Variables..." button at the bottom
1. Higlight the *PATH* variable and click *Edit*
1. Add a new row with the root path to the Ostress folder (without the Ostress.exe)
1. Click Ok everywhere to save
1. Reopen any terminals


### Install SQLCMD

SQLCMD will be installed along with the SQL Server.

### SQL Server

- Enable TCP/IP in the SQL Server Network configuration
- Enable SQL Authentication https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/change-server-authentication-mode?view=sql-server-ver15#change-authentication-mode-with-ssms

## Demo

1. Create the Extended Events (XE) session Error_reported on the server by running the Error_reported.sql script in *XE_Sessions* folder.
   1. You can also create the other sessions as well.
1. Enable the XE sessions by running the code `ALTER EVENT SESSION Error_reported ON SERVER STATE = START`
1. Run the script *01_CreateEnvironment.sql* in the root of the repository.
1. In SSMS Object Explorer go to *<ServerName>\Management\Extended Events\Sessions* - Locate the *Error_reported* session and either Right click and select *Watch Live Data* or expand the session and double click the target file.
1. Run the *Ostress.ps1* script in the *WorkloadSimulation* folder to generate some errors.
