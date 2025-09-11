USE tempdb;
GO

DROP TABLE IF EXISTS Producten;
GO

CREATE TABLE Producten (
    ProductID  int IDENTITY,
    Naam       nvarchar(100) NOT NULL,
    Prijs      decimal(10,2) NULL,
    Voorraad   int NOT NULL
);
GO

INSERT INTO Producten 
VALUES
('ProdA', 10.00, 10),
('ProdB', 20.00, 0),
('ProdC', NULL, 50);
GO

-------------------------------------------------------

DROP VIEW IF EXISTS dbo.ProductenOpVoorraad;
GO

-- Een VIEW is een zgn. Table Expression (hij doet zich voor als tabel)
CREATE OR ALTER VIEW dbo.ProductenOpVoorraad
AS
SELECT 
    Naam
    , Prijs
    , Voorraad
FROM dbo.Producten
WHERE Voorraad > 0;
GO

-- Gebruik de VIEW

SELECT * FROM dbo.ProductenOpVoorraad;
GO

--------------------------------------------------
-- Een VIEW met 1 achterliggende tabel is editable

CREATE OR ALTER VIEW dbo.ProductenOpVoorraad
WITH ENCRYPTION, 
     SCHEMABINDING,        -- voorkomt ALTER TABLE Producten DROP COLUMN Prijs
     VIEW_METADATA
AS
SELECT 
    Naam        AS Titel
    , Prijs     AS Kostprijs
    , Voorraad  AS Aantal_Op_Voorraad
FROM dbo.Producten
WHERE Voorraad > 0
WITH CHECK OPTION      -- te inserten/updaten records moeten binnen WHERE vallen
GO

SELECT * FROM dbo.Producten

SELECT * FROM dbo.ProductenOpVoorraad

INSERT INTO dbo.ProductenOpVoorraad
(Titel, Aantal_Op_Voorraad)
VALUES
('Z', 1);   -- Dit kan wel met WITH CHECK OPTION

INSERT INTO dbo.ProductenOpVoorraad
(Titel, Aantal_Op_Voorraad)
VALUES
('Y', 0);   -- Dit kan niet meer met WITH CHECK OPTION
