USE WorldCup2018;
GO

-- Voor het geval we een function hadden met dezelfde naam
DROP FUNCTION IF EXISTS dbo.VoorradigeProductenMetNaam;


GO
CREATE OR ALTER PROCEDURE dbo.VoorradigProductenMetNaam
    @Naam AS nvarchar(100) = 'dA',
    @Aantal AS int = 0 OUT
AS
BEGIN
    SET NOCOUNT ON;

    IF (LEN(@Naam) < 2)
        THROW 50002, 'Verwachte naam moet min.', 1;

    SELECT 
        @Aantal = COUNT(*) 
    FROM dbo.Producten
    WHERE Voorraad > 0 
    AND Naam LIKE CONCAT('%', @Naam, '%');

    PRINT 'Bijna klaar...';

    SELECT 
        UPPER(Naam)     AS Titel
        , Prijs         AS Kostprijs
        , Voorraad      AS Aantal_Op_Voorraad
    FROM dbo.Producten
    WHERE Voorraad > 0 
    AND Naam LIKE CONCAT('%', @Naam, '%');
END;
GO

------------------------------------------
-- De consumer van de Stored Procedure

DECLARE @MijnAantal AS int = 0;

EXEC dbo.VoorradigProductenMetNaam @Naam = 'dA', @Aantal = @MijnAantal OUT;

PRINT CONCAT('en het aantal is .....: ', @MijnAantal);

-------------------------------------------------------------------------

-- Extra opdracht

/*
1. Schrijf een Stored Procedure die uit de Persons.Players tabel 
   de gegevens van een speler op haalt op basis van een meegegeven PlayerId
   We verwachten 3 velden: FullName, BirthDate en CountryName

2. Maak eerst een nieuwe tabel PlayersLog:
   Id, FirstName en LogDateTime

3. Breid nu de Stored Procedure uit. Bij het aanroepen moet een record worden toegevoegd
   aan de PlayersLog tabel

4. Zorg ervoor dat als een niet bestaand PlayerId wordt meegegeven, 
   de Stored Procedure niet crasht
*/
