-- QueryStore Demo

USE AdventureWorksLT2017;
GO

-- Turn on the Query Store through the SSMS UI (database, properties)
-- Show the folder 'Query Store' that now appears in the Object Explorer

--------------------------------------------------------------------------------
-- Create a covering index on the TempProduct table
--------------------------------------------------------------------------------

DROP INDEX IF EXISTS SalesLT.TempProduct.ix_TempProduct;

CREATE NONCLUSTERED INDEX ix_TempProduct
ON SalesLT.TempProduct (ProductCategoryID)
INCLUDE (Name, ProductNumber);

--------------------------------------------------------------------------------
-- Clear the Query Store (there is also a purge button in the UI)
--------------------------------------------------------------------------------

ALTER DATABASE AdventureWorksLT2017
SET QUERY_STORE CLEAR;


--------------------------------------------------------------------------------
-- Work load 1 ⚙️
-- Run this six times
--------------------------------------------------------------------------------

SELECT C.ProductCategoryID, C.Name AS 'Category', P.Name AS 'ProductName', P.ProductNumber, SUM(D.OrderQty) AS 'OrderQty', SUM(D.LineTotal) AS 'OrderValue'
FROM SalesLT.ProductCategory AS C
INNER JOIN SalesLT.TempProduct AS P
ON P.ProductCategoryID = C.ProductCategoryID
LEFT OUTER JOIN SalesLT.SalesOrderDetail AS D
ON D.ProductID = P.ProductID
GROUP BY C.ProductCategoryID, C.Name, P.Name, P.ProductNumber;

--------------------------------------------------------------------------------
-- Work load 2 ⚙️
-- Run this four times
--------------------------------------------------------------------------------

SELECT C.CompanyName, CONCAT(C.FirstName, N' ' + C.MiddleName, N' ' + C.LastName) AS Name, P.Name as 'ProductName', P.ProductNumber, SUM(H.TotalDue) AS 'TotalDue'
FROM SalesLT.Customer AS C
INNER JOIN SalesLT.SalesOrderHeader AS H
ON H.CustomerID = C.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS D
ON D.SalesOrderID = H.SalesOrderID
INNER JOIN SalesLT.TempProduct AS P
ON P.ProductID = D.ProductID
WHERE P.ProductCategoryID <= 15
GROUP BY C.CompanyName, C.FirstName, C.MiddleName, C.LastName, P.Name, P.ProductNumber;

--------------------------------------------------------------------------------
-- Regress work load 1
--------------------------------------------------------------------------------

DROP INDEX ix_TempProduct
ON SalesLT.TempProduct;

-- Work load 1 ⚙️
-- Run five more times

-- Now switch to the UI and look at the queries and their plans. 
-- Be sure to point out that choosing the right statistics is key to analysing properly.