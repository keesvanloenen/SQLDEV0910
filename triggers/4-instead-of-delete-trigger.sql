-- INSTEAD OF DELETE Trigger

-- Add column IsValid which is by default true (1), 
-- but when the row is 'deleted', IsValid will be set to false (0)


USE WorldCup2018;
GO

-- Add column

ALTER TABLE Other.Stadiums 
ADD IsValid bit NOT NULL
CONSTRAINT DF_CurrentPrice_IsValid
DEFAULT (1);
GO

-- Check data

SELECT * FROM Other.Stadiums
GO
-- Add INSTEAD OF DELETE TRIGGER

CREATE TRIGGER Other.TR_Stadiums_Delete
ON Other.Stadiums
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET IsValid = 0
    FROM Other.Stadiums s
    INNER JOIN deleted d 
    ON s.StadiumId = d.StadiumId;
END;

-- Now delete a row

DELETE FROM Other.Stadiums
WHERE StadiumId = 2;

SELECT * FROM Other.Stadiums

SELECT * FROM sys.triggers

DROP TRIGGER IF EXISTS Other.TR_Stadiums_Delete


