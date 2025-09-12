-- ================
-- Sessie 2: Writer
-- ================

USE AdventureWorksLT2017;
GO

-- 2. Wijzig data met een UPDATE statement
--    Er moet nu gewacht worden totdat de andere sessie (de reader) klaar
BEGIN TRANSACTION;

UPDATE SalesLT.Customer
SET MiddleName = 'van der'
WHERE CustomerID = 2;

-- Voer stap 3 uit in de reader sessie

-- 5. Het record is nu opgeslagen.
SELECT MiddleName 
FROM SalesLT.Customer
WHERE CustomerID = 2;		-- is nu 'van der', maar nog niet opgeslagen in database

-- 6. Rollback
ROLLBACK TRANSACTION;
