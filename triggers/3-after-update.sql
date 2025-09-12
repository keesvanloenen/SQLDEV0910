-- AFTER UPDATE Trigger

-- LastModified and ModifiedBy should be updated after each updat

USE WorldCup2018;
GO

-- Add 2 columns

ALTER TABLE [Other].[Stadiums]
ADD 
    LastModified DATETIME2(0) NOT NULL 
        CONSTRAINT DF_Stadiums_LastModified DEFAULT (SYSDATETIME()),
    
    ModifiedBy nvarchar(128) NOT NULL 
        CONSTRAINT DF_Stadiums_ModifiedBy DEFAULT (ORIGINAL_LOGIN());

-- Check data
SELECT * FROM Other.Stadiums;

-- Update the StadiumId 2 and notice that LastModified column has not been updated

UPDATE Other.Stadiums
SET Capacity = 90000
WHERE StadiumId = 2;
GO

SELECT * FROM Other.Stadiums;
GO

-- Create an AFTER UPDATE trigger to update the LastModifed and ModifiedBy columns

CREATE TRIGGER TR_Stadiums_Update
ON Other.Stadiums
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE s
    SET 
        s.LastModified = SYSDATETIME(),
        s.ModifiedBy = ORIGINAL_LOGIN()
    FROM Other.Stadiums s
    INNER JOIN inserted i 
    ON s.StadiumId = i.StadiumId;
END;
GO

-- Test again

UPDATE Other.Stadiums
SET Capacity = 95000
WHERE StadiumId = 2;
GO

SELECT * FROM Other.Stadiums;

-- Query the sys.triggers view and note the existence of the view

SELECT * FROM sys.triggers;

DROP TRIGGER IF EXISTS other.TR_Stadiums_Update;
