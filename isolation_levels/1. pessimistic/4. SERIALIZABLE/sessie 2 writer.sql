-- ================
-- Sessie 2: Writer
-- ================

USE AdventureWorksLT2017;
GO

-- 2. Probeer data te inserten die binnen de door de reader gelockte range valt
--    Er moet nu gewacht worden totdat de andere sessie (de reader) klaar
BEGIN TRANSACTION;

INSERT INTO SalesLT.CustomerAddress
(
	CustomerID, 
	AddressID,
	AddressType,
	rowguid, 
	ModifiedDate
)
VALUES
(
	10,
	457, -- De range 456 - 458 is momenteel gelocked door de andere transactie
	'Main Office',
	NEWID(),
	GETDATE()
);

-- Voer stap 3 uit in de reader sessie

-- 5. Het record is nu opgeslagen.
SELECT *
FROM SalesLT.CustomerAddress
WHERE AddressID = 457;	-- het record is toegevoegd

-- 6. Rollback
ROLLBACK TRANSACTION;
