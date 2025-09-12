-- ================
-- Sessie 2: Reader
-- ================

USE AdventureWorksLT2017;
GO

-- 2. Met het READ UNCOMMITTED isolation level hoeft niet gewacht te worden op WRITERS want er worden geen shared locks aangevraagd. Dit is dus heel sneller, maar er is een risico dat de data die gelezen wordt 'dirty reads' bevat.
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT MiddleName 
FROM SalesLT.Customer
WHERE CustomerID = 2;
GO

-- Voer stap 3 uit in de writer sessie
