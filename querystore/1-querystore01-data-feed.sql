-- Generate TestData

USE AdventureWorksLT2017;
GO

--------------------------------------------------------------------------------
-- Create a larger Product table
--------------------------------------------------------------------------------

DROP TABLE IF EXISTS SalesLT.TempProduct;
GO

DECLARE @t TABLE
(
  id int
);

INSERT INTO @t 
(id)
VALUES 
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);


WITH TempCTE AS
(
  SELECT 
    t1.id	AS id1
    , t2.id AS id2
  FROM @t AS t1
  CROSS JOIN @t AS t2
)
SELECT 
  *
INTO SalesLT.TempProduct
FROM SalesLT.Product
CROSS JOIN TempCTE;
GO

--------------------------------------------------------------------------------
-- Create a clustered index on the TempProduct table
--------------------------------------------------------------------------------

CREATE CLUSTERED INDEX PK_TempProduct
ON SalesLT.TempProduct(ProductID, id1, id2);
GO

--------------------------------------------------------------------------------
-- Display the records in the new table
--------------------------------------------------------------------------------

SELECT * FROM SalesLT.TempProduct;
GO
