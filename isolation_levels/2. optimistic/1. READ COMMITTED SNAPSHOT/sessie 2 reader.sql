-- ================
-- Sessie 2: Reader
-- ================

USE AdventureWorksLT2017;
GO

-- 2. Met het READ COMMITTED SNAPSHOT isolation level worden 'dirty reads' (niet gecomitted data) voorkomen. 
--    We hebben dit isolation level zojuist als nieuwe standaard gespecificeerd.
--    Er wordt nu geen shared lock gevraagd. We krijgen simpelweg de data uit de 'Version Store'.
SELECT MiddleName
FROM SalesLT.Customer
WHERE CustomerID = 2;
GO

-- Voer stap 3 uit in de writer sessie
