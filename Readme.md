# Troubleshoot Real-World Scenarios with Extended Events

## Prerequisites

### Install Ostress

https://docs.microsoft.com/en-us/troubleshoot/sql/tools/replay-markup-language-utility

## Demo

1. Create the Extended Events (XE) session Error_reported on the server by running the Error_reported.sql script in *XE_Sessions* folder.
   1. You can also create the other sessions as well.
1. Enable the XE sessions by running the code `ALTER EVENT SESSION Error_reported ON SERVER STATE = START`
1. Run the script *01_CreateEnvironment.sql* in the root of the repository.
1. In SSMS Object Explorer go to *<ServerName>\Management\Extended Events\Sessions* - Locate the *Error_reported* session and either Right click and select *Watch Live Data* or expand the session and double click the target file.
1. Run the *Ostress.ps1* script in the *WorkloadSimulation* folder to generate some errors.
