-- == LET OP: Eenmalige wijziging in de database! ==
ALTER DATABASE AdventureWorks SET READ_COMMITTED_SNAPSHOT ON;	-- Optimistic locking 
ALTER DATABASE AdventureWorks SET ALLOW_SNAPSHOT_ISOLATION ON; 

-- ================
-- Sessie 1: Writer
-- ================
USE AdventureWorksLT2017;
GO

-- 1. Wijzig data met een UPDATE statement en bekijk het nog niet opgeslagen resultaat
BEGIN TRANSACTION;

-- Het oude record met NULL belandt in de Version Store (in tempdb)
UPDATE SalesLT.Customer
SET MiddleName = 'van der'
WHERE CustomerID = 2;

SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;		-- is nu 'van der', maar nog niet opgeslagen in de database;

-- Voer stap 2 uit in de reader sessie

-- 3. Rollback de transactie
ROLLBACK TRANSACTION;

-- Voer stap 4 uit in de reader sessie

-- ------------------------------------------------------

-- 5. Herstel voor een volgende demo
UPDATE SalesLT.Customer
SET MiddleName = NULL
WHERE CustomerID = 2;

-- 6. Zet beide OPTIMISTIC ISOLATION LEVELS uit via de interface: AdventureWorks, Properties:
-- Is Read Committed Snapshot On
-- Allow Snapshot Isolation