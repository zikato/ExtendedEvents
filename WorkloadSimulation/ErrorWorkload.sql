

/* Running out of identity - 4th call exceeds the tinyint - Error 8115*/
DECLARE @i int = 0
WHILE @i < 6
BEGIN 
	INSERT INTO dbo.LowIdentity DEFAULT VALUES 
	SET @i += 1;
END 

GO

/* Unique constraint violation - Error 2627 */
DECLARE @i int = 0
WHILE @i < 5 
BEGIN 
	INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
	VALUES 
	(
		  ABS(CHECKSUM(NEWID())) % 10  -- random range 0 - number(excluded)
		, ABS(CHECKSUM(NEWID())) % 10   
		, 'Test'
	)
	SET @i += 1;
END 
GO 

/* Error inside the trigger - CountryId cannot be same as CategoryId */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
	VALUES 
	(
		  5
		, 5
		, 'Test'
	)

GO

/* String or binary data would be truncated - Error 2628 */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(20, 21, REPLICATE('A', 40) + REPLICATE('B', 40))

GO

/* Arithmetic overflow - Error 220 */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(250 + 10, 20, 'Data type overflow')

GO

GO
EXEC dbo.ChildProcedure @trueFalse = 0 /* Error */
GO
EXEC dbo.ChildProcedure @trueFalse = 1
GO
EXEC dbo.DaddyProcedure @passThrough = 0 /* Error */
GO
EXEC dbo.DaddyProcedure @passThrough = 1
GO
EXEC dbo.MommyProcedure @passThrough = 0 /* Error */
GO
EXEC dbo.MommyProcedure @passThrough = 1
GO

/* Procedure has string in the RETURN */
EXEC dbo.BadReturnType
GO