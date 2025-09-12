-- INSTEAD OF UPDATE Trigger

USE WorldCup2018;
GO

-- Add table

DROP TABLE IF EXISTS Other.PostalCode;
GO

CREATE TABLE Other.PostalCode
( 
    PlayerId        int PRIMARY KEY,
    PostalCode      nvarchar(5) NOT NULL,
    PostalSubCode   nvarchar(5) NULL
);
GO

INSERT INTO Other.PostalCode 
(PlayerId, PostalCode, PostalSubCode)
VALUES 
(1, '12345', '678'),
(2, '21212', NULL),
(3, '34567', '890');
GO

-- Check data

SELECT * FROM Other.PostalCode;

-- Create a view that concatenates the string columns

GO

CREATE OR ALTER VIEW Other.PostalRegion
AS
SELECT 
    PlayerId,
    CONCAT(PostalCode, COALESCE('-' + PostalSubCode, '')) AS PostalRegion
FROM Other.PostalCode;
GO

-- Test View

SELECT * FROM Other.PostalRegion;
GO

-- Try to insert into the view (will fail - note the error)

INSERT INTO Other.PostalRegion 
(PlayerId, PostalRegion)
VALUES 
(4,'54321-678');
GO

-- Try to update the view (will fail - note the error)

UPDATE Other.PostalRegion 
SET PostalRegion = '23234-523' 
WHERE PlayerId = 3;
GO

-- Try to delete a row 

DELETE FROM Other.PostalRegion 
WHERE PlayerID = 3;
GO

-- Question: Why does the DELETE succeed when INSERT and UPDATE fail?

-- Create an INSTEAD OF INSERT trigger
-- on the View!

CREATE OR ALTER TRIGGER Other.TR_PostalRegion_Insert
ON Other.PostalRegion
INSTEAD OF INSERT
AS
INSERT INTO Other.PostalCode 
SELECT 
    PlayerId, 
    SUBSTRING(PostalRegion, 1, 5),
    CASE WHEN SUBSTRING(PostalRegion, 7, 5) <> '' THEN SUBSTRING(PostalRegion, 7, 5) END
FROM inserted;
GO

-- Try to insert into the view again

INSERT INTO Other.PostalRegion
(PlayerId, PostalRegion)
VALUES (4,'09232-432');
GO

-- Oops, note that two row counts have been returned

-- Alter the trigger to remove the extra rowset

ALTER TRIGGER Other.TR_PostalRegion_Insert
ON Other.PostalRegion
INSTEAD OF INSERT
AS
SET NOCOUNT ON;     -- added
INSERT INTO Other.PostalCode 
SELECT 
    PlayerId, 
    SUBSTRING(PostalRegion, 1, 5),
    CASE WHEN SUBSTRING(PostalRegion, 7, 5) <> '' THEN SUBSTRING(PostalRegion, 7, 5) END
FROM inserted;
GO

-- Try to insert into the view again

INSERT INTO Other.PostalRegion 
(PlayerId, PostalRegion)
VALUES 
(5,'92232-142');
GO

-- Note that only the correct rowcount is returned now

-- Make sure the trigger works for multi-row inserts

INSERT INTO Other.PostalRegion 
(PlayerID, PostalRegion)
VALUES 
(6, '11111-111'),
(7, '99999-999');
GO

SELECT * FROM Other.PostalRegion;
GO

DROP VIEW Other.PostalRegion;
GO
DROP TABLE Other.PostalCode;
GO
