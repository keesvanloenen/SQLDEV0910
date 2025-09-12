-- AFTER INSERT Trigger

-- If a new stadium has a Capacity greater than 100,000 and the TimeZone is not 3, reject the insert. 
-- For example, perhaps you only want high-capacity stadiums in TimeZone 3.

USE WorldCup2018;
GO

CREATE OR ALTER TRIGGER TR_Stadiums_Insert
ON Other.Stadiums
AFTER INSERT
AS
BEGIN
    -- Check for rows that violate the rule
    IF EXISTS (
        SELECT 1
        FROM inserted AS i
        WHERE i.Capacity > 100000 AND i.TimeZone <> 3
    )
    BEGIN
        PRINT 'High-capacity stadiums must be in TimeZone 3';
        ROLLBACK;
    END
END;
GO

-- Capacity is 50,000 ✅

INSERT INTO Other.Stadiums 
(StadiumName, StadiumCity, TimeZone, Capacity)
VALUES 
(N'Small Stadium', N'City A', 2, 50000);

-- High Capacity and correct TimeZone ✅

INSERT INTO Other.Stadiums
VALUES
(N'Big Stadium', N'City B', 3, 120000);

-- High Capacity, TimeZone not 3 ❌

INSERT INTO Other.Stadiums
VALUES 
(N'Another Big Stadium', N'City C', 1, 150000);

DELETE FROM Other.Stadiums 
WHERE StadiumCity IN (N'Small Stadium', N'Big Stadium');