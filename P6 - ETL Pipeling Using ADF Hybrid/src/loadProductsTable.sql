USE [Azure-Test];
GO

-- Optional: Clean up table before inserting
-- DELETE FROM [dbo].[Products];

DECLARE @counter INT = 1;

WHILE @counter <= 200
BEGIN
    INSERT INTO [dbo].[Products] (
        [ProductName],
        [Category],
        [UnitPrice],
        [UnitsInStock]
    )
    VALUES (
        CONCAT('Product ', @counter),
        CHOOSE((ABS(CHECKSUM(NEWID())) % 5) + 1, 'Electronics', 'Groceries', 'Books', 'Toys', 'Clothing'),
        ROUND((RAND() * 500) + 1, 2),
        ABS(CHECKSUM(NEWID())) % 100
    );

    SET @counter = @counter + 1;
END;
GO
