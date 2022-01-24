/* Recreates a database from the start */
USE [master]

IF EXISTS (SELECT * FROM sys.databases AS d WHERE d.name = 'ExtendedEvents')
BEGIN 
	ALTER DATABASE [ExtendedEvents] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE [ExtendedEvents]
END 

CREATE DATABASE ExtendedEvents;
GO 
USE ExtendedEvents;

/* Since Login is server scoped, we check for existence */
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'LimitedPermissions')
BEGIN
    CREATE LOGIN LimitedPermissions WITH PASSWORD = N'Str0ngPa$$w0rd!'
END

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'BillyNoRights')
BEGIN
    CREATE LOGIN BillyNoRights WITH PASSWORD = N'Str0ngPa$$w0rd!'
END

/* Users can be recreated a new */
CREATE USER LimitedPermissions FROM LOGIN LimitedPermissions
CREATE USER BillyNoRights FROM LOGIN BillyNoRights

GO 

/* Easy to confuse spelling - error for calling a non-existent stored procedure */
CREATE OR ALTER PROCEDURE dbo.GetColor
AS
BEGIN 
	/* British (colour) vs American spelling (color) */
	SELECT 'Salmon'
END
GO

/* Just a generic easy to miss error */
CREATE OR ALTER PROCEDURE dbo.BadReturnType
AS 
BEGIN 
	/* Return type is int but I'm returning a string */
	SELECT NEWID()

	RETURN 'Done'
END 

GO 
/* One user has an access, another one has not */
CREATE OR ALTER PROCEDURE dbo.LimitedAccess
AS
BEGIN
	/* only LimitedPermissions user has access here */
	SELECT 'Top secret'
END 
GO
GRANT EXECUTE ON dbo.LimitedAccess TO LimitedPermissions
GO

/* Here granting of permission to BillyNoRights is part of the procedure code. The caller won't have elevated access */ 
CREATE OR ALTER PROCEDURE dbo.BotchedPermissions
AS
BEGIN 
	SELECT 'Less secret'
END 
/* Missing batch separator - GO */
GRANT EXECUTE ON dbo.BotchedPermissions TO BillyNoRights
GO
GRANT EXECUTE ON dbo.BotchedPermissions TO LimitedPermissions
GO

/* Popular divide by zero error - when the passed number is 0 */
CREATE OR ALTER FUNCTION dbo.ReturnPercentage
(@number numeric(10,2), @perc tinyint)
RETURNS TABLE
	
AS
RETURN SELECT CAST((@perc/@number) * 100 AS decimal(10,2)) AS val

GO


/* Running out of identity */

/* Unique index violation */

/* Data type overflow */

/* Nested branching error - procedure calls function but only one branch returns error */

/* Error inside the trigger */

/* Custom user error */