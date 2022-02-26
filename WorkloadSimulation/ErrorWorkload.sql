EXEC dbo.BadReturnType
GO

/* Running out of identity - 4th call exceeds the tinyint - Error 8115*/
INSERT INTO dbo.LowIdentity DEFAULT VALUES 

GO

/* Unique constraint violation - Error 2627 */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(
	  ABS(CHECKSUM(NEWID())) % 5   -- random range 0 - number(excluded)
	, ABS(CHECKSUM(NEWID())) % 5   
	, 'Test'
)

GO

/* String or binary data would be truncated - Error 2628 */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(20, 20, REPLICATE('A', 40) + REPLICATE('B', 40))

GO

/* Arithmetic overflow - Error 220 */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(250 + 10, 20, 'Data type overflow')

GO

GO
EXEC dbo.SharedLogic @trueFalse = 0 /* Error */
GO
EXEC dbo.SharedLogic @trueFalse = 1
GO
EXEC dbo.Caller1 @passThrough = 0 /* Error */
GO
EXEC dbo.Caller1 @passThrough = 1
GO
EXEC dbo.Caller2 @passThrough = 0 /* Error */
GO
EXEC dbo.Caller2 @passThrough = 1
GO