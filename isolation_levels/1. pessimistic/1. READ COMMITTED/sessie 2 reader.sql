-- ================
-- Sessie 2: Reader
-- ================

USE AdventureWorksLT2017;
GO

-- 2. Met het READ COMMITTED isolation level worden 'dirty reads' (data dat nog niet is gecommitted) voorkomen. 
--  We hoeven het READ COMMITTED isolation level niet te specificeren, want het is het standaard isolation level.

SELECT MiddleName 
FROM SalesLT.Customer
WHERE CustomerID = 2;
GO

-- Er wordt gewacht op het verkrijgen van een SHARED LOCK. Dit kan pas als de  transactie van de andere sessie klaar is (met een COMMIT of ROLLBACK).
-- Voer stap 3 uit in de writer sessie
