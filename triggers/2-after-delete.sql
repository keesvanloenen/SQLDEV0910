-- AFTER DELETE Trigger

-- The Stadiums table gets a DeactivationDate column
-- Rows with DeactivationDate IS NULL are considered active and cannot be deleted

USE WorldCup2018;
GO

-- Add column
ALTER TABLE Other.Stadiums
ADD DeactivationDate DATE NULL;
GO

CREATE OR ALTER TRIGGER TR_Stadiums_Delete
ON Other.Stadiums
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted AS d
        WHERE d.DeactivationDate IS NULL
    )
    BEGIN
        PRINT 'Active stadiums (with NULL DeactivationDate) cannot be deleted.';
        ROLLBACK;
    END
END;
GO

-- Inactive stadium (should be deletable)
INSERT INTO Other.Stadiums (StadiumName, StadiumCity, TimeZone, Capacity, DeactivationDate)
VALUES (N'Inactive Stadium', N'City E', 3, 90000, '2024-01-01');

-- Active stadium (should NOT be deletable)
INSERT INTO Other.Stadiums (StadiumName, StadiumCity, TimeZone, Capacity, DeactivationDate)
VALUES (N'Active Stadium', N'City D', 3, 80000, NULL);

DELETE FROM Other.Stadiums
WHERE StadiumName = N'Inactive Stadium';

DELETE FROM Other.Stadiums
WHERE StadiumName = N'Active Stadium';
GO 


DISABLE TRIGGER Other.TR_Stadiums_Delete ON Other.Stadiums;
GO

DELETE FROM Other.Stadiums 
WHERE StadiumName = N'Active Stadium';




