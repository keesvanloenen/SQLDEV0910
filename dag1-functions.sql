-- Dag 1, middag functions

-- Een UDF is een User Defined Function
-- Het is een SCALAR function (die indien gebruikt binnen een tabel)
-- voor elke rij wordt uitgevoerd

GO
CREATE OR ALTER FUNCTION dbo.IsEven
(@number AS int)
RETURNS bit
AS
BEGIN
	RETURN IIF(@number % 2 = 0, 1, 0);
END;
GO

SELECT 
	dbo.IsEven(10) AS Verwacht1
	, dbo.IsEven(9) AS Verwacht0;


-- IsStrongPassword() function:
-- min. 12 tekens
-- min. 1 cijfer
-- min. 1 hoofdletter (🤯)

GO

CREATE OR ALTER FUNCTION dbo.ContainsCapitalLetter 
(@input nvarchar(MAX))
RETURNS bit
AS
BEGIN
    DECLARE @index int = 1;

    WHILE @index <= LEN(@input)
    BEGIN
        -- UNICODE() returns ASCII Code: 65 = 'A', 90 = 'Z'
        IF UNICODE(SUBSTRING(@input, @index, 1)) BETWEEN 65 AND 90
            RETURN 1;

        SET @index += 1;
    END

    RETURN 0;
END
GO

CREATE OR ALTER FUNCTION dbo.IsStrongPassword
(@password AS nvarchar(100))
RETURNS bit
AS
BEGIN
	RETURN (
		CASE
			WHEN LEN(@password) < 12 THEN 0
			WHEN @password NOT LIKE '%[0-9]%' THEN 0
			WHEN dbo.ContainsCapitalLetter(@password) = 0 THEN 0
			ELSE 1
		END
	)
END;

GO

SELECT 
	dbo.IsStrongPassword('Welkom123')     AS R1_0,
    dbo.IsStrongPassword('welkom123456')  AS R2_0,
	dbo.IsStrongPassword('welKom123456')  AS R3_1
