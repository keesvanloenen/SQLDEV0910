-- ================
-- Sessie 1: Reader
-- ================

USE AdventureWorksLT2017;
GO

-- Met het REPEATABLE READ isolation level krijgen we 'lees stabiliteit': 
-- meerdere keren dezelfde SELECT querie retourneert altijd hetzelfde

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
GO

BEGIN TRANSACTION;

-- 1. Voer een leesactie uit
SELECT MiddleName 
FROM SalesLT.Customer
WHERE CustomerID = 2;		-- NULL
GO

-- Voer stap 2 uit in de writer sessie

-- 3. Voer dezelfde leesactie nogmaals uit: de resultaten zijn identiek. 
--    De shared locks gezet in stap 1 zijn niet weggehaald.
SELECT MiddleName 
FROM SalesLT.Customer
WHERE CustomerID = 2;		-- nog steeds NULL
GO

-- 4. COMMIT zodat de shared locks worden weggehaald.
COMMIT TRANSACTION;

-- Voer stap 5 uit in de writer sessie




