-- ================
-- Sessie 1: Reader
-- ================

USE AdventureWorksLT2017;
GO

-- Met het REPEATABLE READ isolation level hebben we wederom 'read stability' en voorkomen we bovendien 'phantom reads': we lezen altijd dezelfde data uit een specifieke set van data (bijv. WHERE land = 'NL')

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
GO

BEGIN TRANSACTION;

-- 1. Voer een leesactie uit. SQL Server plaatst een zgn. KEYRANGE LOCK op de records waarvan AddressID  456, 457 of 458 is. Gebruiken we deze WHERE clause vaker in onze transactie, dan weten dat deze set niet tussendoor kan wijzigen.

SELECT *
FROM SalesLT.CustomerAddress
WHERE AddressID BETWEEN 456 AND 458;

-- Voer stap 2 uit in de writer sessie

-- 3. Voer dezelfde leesactie nogmaals uit: de resultaten zijn identiek. De KEYRANGE LOCK gezet in stap 1 is niet weggehaald.
SELECT *
FROM SalesLT.CustomerAddress
WHERE AddressID BETWEEN 456 AND 458;
GO

-- 4. COMMIT zodat de KEYRANGE LOCK wordt weggehaald.
COMMIT TRANSACTION;

-- Voer stap 5 uit in de writer sessie




