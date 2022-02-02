/* Running out of identity - 4th call exceeds the tinyint */
INSERT INTO dbo.LowIdentity DEFAULT VALUES 

GO

/* Unique constraint violation */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(
	  ABS(CHECKSUM(NEWID())) % 5   -- random range 0 - number(excluded)
	, ABS(CHECKSUM(NEWID())) % 5   
	, 'Test'
)

GO

/* String or binary data would be truncated */
INSERT INTO dbo.UniqueConstraint (CountryId, CategoryId, Filler)
VALUES 
(20, 20, REPLICATE('A', 40) + REPLICATE('B', 40))

GO

/* Arithmetic overflow */
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