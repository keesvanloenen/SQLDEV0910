-- ================
-- Sessie 1: Writer
-- ================

USE AdventureWorksLT2017;
GO

-- 1. Wijzig data met een UPDATE statement en bekijk het nog niet opgeslagen resultaat

BEGIN TRANSACTION;

UPDATE SalesLT.Customer
SET MiddleName = 'van der'
WHERE CustomerID = 2;

SELECT MiddleName 
FROM SalesLT.Customer
WHERE CustomerID = 2;		-- is nu 'van der', maar nog niet opgeslagen in DB

-- Voer stap 2 uit in de reader sessie

-- 3. Rollback de transactie
ROLLBACK TRANSACTION;

-- Bekijk het resultaat in de reader sessie