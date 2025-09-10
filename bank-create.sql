USE master;
GO

-- Sluit eerst alle openstaande connecties
ALTER DATABASE Bank
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE IF EXISTS Bank;
GO

CREATE DATABASE Bank;
GO

USE Bank;
GO

DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Hr.Employees;
GO

DROP SCHEMA IF EXISTS Hr;
GO

DROP SEQUENCE IF EXISTS TransactionSeq;
GO

CREATE SCHEMA Hr;
GO

CREATE SEQUENCE TransactionSeq
	START WITH 1
	INCREMENT BY 1;
GO


-- Herbruikbaar data type
CREATE TYPE MoneyAmount FROM decimal(18,2) NOT NULL;
GO

-- Twee CHECK Constraints:
-- 1. (kolom niveau) Iedereen in de tabel moet volwassen zijn (Age >= 18)
-- 2. (tabel niveau) Iedere Nederlander (CountryCode = 'NL') moet tenminste 21 zijn
CREATE TABLE Accounts
(
	Id				int IDENTITY 
					CONSTRAINT PK_Accounts_Id 
					PRIMARY KEY,
	Name			nvarchar(100) NOT NULL,
	Age				smallint NOT NULL
					CONSTRAINT CHK_Accounts_IsAdult
					CHECK(Age >= 18),
	CountryCode		char(2),
					-- ALS CountryCode is 'NL', dan Age >= 21
					CONSTRAINT CHK_Accounts_CountryCodeAgeLogic
					CHECK (NOT (CountryCode = 'NL' AND Age < 21)) 
					-- CHECK (IIF(CountryCode = 'NL' AND Age < 21, 0, 1) = 1)
					-- CHECK (CASE WHEN (CountryCode = 'NL' AND Age < 21) THEN 0 ELSE 1 END = 1)
					-- CHECK (CountryCode <> 'NL' OR age >= 21)
);
GO

-- Uitleg string datatypes:
-- nvarchar(100) 👈
-- varchar(100)
-- nchar(2)
-- char(2) 👈
-- SELECT LEN(AddressLine1), DATALENGTH(AddressLine1) FROM AdventureWorks2016.Person.Address

INSERT INTO Accounts
VALUES
('Ab', 26, 'NL'),
('Bo', 24, 'DE'),
('Cas', 28, 'AU');
GO

-- Onderstaand is meestal een slecht idee
--SET IDENTITY_INSERT Accounts ON;

--INSERT INTO Accounts
--(Id, Name)
--VALUES
--(5, 'Ed');

--SET IDENTITY_INSERT Accounts OFF;

GO

-- UNIQUE Constraint: elk account mag maar 1 transactie per dag doen
--                    hierbij een computed column geïntroduceerd
CREATE TABLE Transactions
(
	Id					bigint DEFAULT (NEXT VALUE FOR TransactionSeq)
						CONSTRAINT PK_Transactions_Id 
						PRIMARY KEY,
	AccountId			int NOT NULL,
	Amount				MoneyAmount,
	AmountWithFee		AS (CAST(Amount * 1.02 AS decimal(18,2))) PERSISTED,
	TransactionDate		datetime2(0) NOT NULL 
						CONSTRAINT DF_Transactions_TransActionDateToday
						DEFAULT SYSDATETIME(),
	TransactionDay		AS (CAST(TransactionDate AS date)) PERSISTED,	-- hulpkolom voor UNIQUE constraint
						CONSTRAINT FK_Transactions_AccountId			-- FOREIGN KEY constraint
						FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
						ON DELETE CASCADE
						ON UPDATE CASCADE,
						CONSTRAINT UQ_Transactions_AccountId_TransactionDate	-- UNIQUE constraint
						UNIQUE (AccountId, TransactionDay)
);
GO

-- Hoe om te gaan met kolommen met DEFAULT value:
-- manier 1:
INSERT INTO Transactions
(AccountId, Amount)						-- laat nadrukkelijk de kolomnaam en value weg
VALUES
(1, 100);
GO

-- manier 2:
INSERT INTO Transactions
(AccountId, Amount, TransactionDate)	-- geef kolomnaam en als waarde DEFAULT
VALUES
(2, 100, DEFAULT);
GO


INSERT INTO Transactions
(AccountId, Amount, TransactionDate)
VALUES
(1, 100.00, '2025-01-01T22:23:56'),
(2, 150.50, '2025-05-01T22:23:56'),
(3, 200.75, '2025-02-01T22:23:56'),
(1, 120.00, '2025-03-01T22:23:56'),
(2, 180.25, '2025-04-01T22:23:56');

GO

-- Gebruik van eerder gemaakte SCHEMA
CREATE TABLE Hr.Employees
(
    Id				int IDENTITY 
					CONSTRAINT PK_Employees_Id 
					PRIMARY KEY,
	Voornaam		nvarchar(75),
	GeboorteDatum	date
					CONSTRAINT CHK_Employees_IsRealistischeGeboortedatum
					CHECK
					(
						Geboortedatum BETWEEN 
						DATEADD(year, -80, SYSDATETIME()) 
						AND DATEADD(year, -17, SYSDATETIME())
					)
);

GO

SELECT 
	a.Name
	, a.Age
	, a.CountryCode
	, t.Amount
	, t.AmountWithFee
	, t.TransactionDate
	, t.TransactionDay
FROM Accounts AS a
INNER JOIN Transactions AS t
ON a.Id = t.AccountId;

--------------------------------------------------------------------------------------------------------

-- Bij het aanmaken van een nieuwe transactie moet er een check plaatsvinden:
-- Als het om een Nederlands account gaat, moet het minimale bedrag 50.00 zijn

