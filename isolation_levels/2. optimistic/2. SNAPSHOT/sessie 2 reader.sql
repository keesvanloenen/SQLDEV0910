-- ================
-- Sessie 2: Reader
-- ================

USE AdventureWorksLT2017;
GO

-- 2. Met het SNAPSHOT isolation level worden read stability gegarandeerd.
-- Er worden geen shared locks aangevraagd. We krijgen simpelweg de data uit de 'Version Store' gedurende de gehele transactie

SET TRANSACTION ISOLATION LEVEL SNAPSHOT

BEGIN TRANSACTION;

SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;	-- NULL uit de version store
GO

-- Voer stap 3 uit in de writer sessie

-- 4. Herhaal de leesactie 
SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;	-- Nog steed NULL uit de version store
GO

-- dit leidt tot de beroemde 3960 error (update conflict)
UPDATE SalesLT.Customer
SET MiddleName = 'van'
WHERE CustomerID = 2;

COMMIT TRANSACTION;		-- 👈 let op bij de UPDATE vindt een ROLLBACK plaats door de exception

SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;
GO

-- Voer stap 5 uit in de writer sessie

