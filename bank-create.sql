USE master;
GO

ALTER DATABASE Bank
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE IF EXISTS Bank;
GO

CREATE SCHEMA Hr;
GO

CREATE DATABASE Bank;
GO

USE Bank;
GO

DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Transactions;
GO

DROP SEQUENCE IF EXISTS TransactionSeq;

CREATE SEQUENCE TransactionSeq
	START WITH 1
	INCREMENT BY 1;
GO

CREATE TYPE MoneyAmount FROM decimal(18,2) NOT NULL;
GO

CREATE TABLE Accounts
(
	Id		int IDENTITY 
			CONSTRAINT PK_Accounts_Id 
			PRIMARY KEY,
	Name	nvarchar(100) NOT NULL
);
GO

-- nvarchar(100) 👈+   
-- varchar(100)
-- nchar(2)
-- char(2) 👈
-- SELECT LEN(AddressLine1), DATALENGTH(AddressLine1) FROM AdventureWorks2016.Person.Address

INSERT INTO Accounts
VALUES
('Ab'),
('Bo'),
('Cas');
GO

--SET IDENTITY_INSERT Accounts ON;

--INSERT INTO Accounts
--(Id, Name)
--VALUES
--(5, 'Ed');

--SET IDENTITY_INSERT Accounts OFF;

GO

CREATE TABLE Transactions
(
	Id					bigint DEFAULT (NEXT VALUE FOR TransactionSeq)
						CONSTRAINT PK_Transactions_Id 
						PRIMARY KEY,
	AccountId			int NOT NULL,
	Amount				MoneyAmount,
	AmountWithFee		AS (CAST(Amount * 1.02 AS decimal(18,2))) PERSISTED,
	TransactionDate		datetime2(0) NOT NULL DEFAULT SYSDATETIME(),
						CONSTRAINT FK_Transactions_AccountId
						FOREIGN KEY (AccountId) REFERENCES Accounts(Id)
						ON DELETE CASCADE
						ON UPDATE CASCADE
);
GO

DELETE FROM Accounts WHERE Id = 1

INSERT INTO Transactions
(AccountId, Amount, TransactionDate)
VALUES
(1, 100.00, DATEADD(DAY, -3, SYSDATETIME())),
(2, 150.50, DATEADD(DAY, -2, SYSDATETIME())),
(3, 200.75, DATEADD(DAY, -1, SYSDATETIME())),
(1, 120.00, SYSDATETIME()),
(2, 180.25, DATEADD(DAY, 1, SYSDATETIME()));  -- één dag in de toekomst als voorbeeld

GO

CREATE TABLE Hr.Employees
(
);
GO



