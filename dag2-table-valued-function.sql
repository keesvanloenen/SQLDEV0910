USE tempdb;
GO

-- Een Table Valued Function (TVF) retourneert een TABLE
-- Hij heeft haakjes en kan daarom worden gelezen als 'Parameterized View'

CREATE OR ALTER FUNCTION dbo.VoorradigeProductenMetNaam
(@Naam AS nvarchar(100))
RETURNS TABLE
AS
RETURN
SELECT 
    Naam        AS Titel
    , Prijs     AS Kostprijs
    , Voorraad  AS Aantal_Op_Voorraad
FROM dbo.Producten
WHERE Voorraad > 0 
AND Naam LIKE CONCAT('%', @Naam, '%');
GO

-- Ook de TVF is een Table Expression:
SELECT * FROM dbo.VoorradigeProductenMetNaam('dA');
