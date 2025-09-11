USE tempdb;
GO

DROP TABLE IF EXISTS MyHeap;

CREATE TABLE MyHeap
(
	Id		int IDENTITY,
	City	nvarchar(150)
);

INSERT INTO MyHeap
VALUES
('Epe'),
('Scha'),
('Urk'),
('Y');
GO

DROP TABLE IF EXISTS MyClusteredIndex;

CREATE TABLE MyClusteredIndex
(
	Id		int IDENTITY PRIMARY KEY,
	City	nvarchar(150)
);

INSERT INTO MyClusteredIndex
VALUES
('Epe'),
('Scha'),
('Urk'),
('Y');
GO

----------------------------------------------------

SELECT * FROM MyHeap;
SELECT * FROM MyClusteredIndex;

SELECT * FROM MyHeap WHERE Id = 2;
SELECT * FROM MyClusteredIndex WHERE Id = 2;

SELECT * FROM MyHeap WHERE City = 'Urk';
SELECT * FROM MyClusteredIndex WHERE City = 'Urk';


DROP INDEX IF EXISTS NCI_MyClusteredIndex_City ON MyClusteredIndex;

CREATE NONCLUSTERED INDEX NCI_MyClusteredIndex_City ON MyClusteredIndex(City);
GO

-------------------------------------------------

ALTER TABLE MyClusteredIndex ADD Country nvarchar(100) NULL;

SET NOCOUNT ON;

DECLARE @index AS int = 1;

WHILE @index < 5000000
BEGIN
	INSERT INTO MyClusteredIndex
	(City, Country)
	VALUES
	(CONCAT('City', @index),  'Nederland')

	SET @index += 1;
END;

SELECT COUNT(*) FROM sys.all_objects
SELECT COUNT(*) FROM sys.all_objects AS a CROSS JOIN sys.all_objects AS b
SELECT TOP 10 'Hallo daar' FROM sys.all_objects
SELECT TOP 10 'Hallo daar' AS Groet FROM sys.all_objects
SELECT TOP 10 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) FROM sys.all_objects 

INSERT INTO MyClusteredIndex
(City, Country)
SELECT TOP 5000000 
	CONCAT('City', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)))
	, 'Nederland'
FROM sys.all_objects AS a
CROSS JOIN sys.all_objects AS b



SELECT Id, City, Country FROM MyClusteredIndex --WHERE City = 'Urk';


