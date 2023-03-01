USE Northwind
GO

--1.  List all products, their current stock and reorder levels that have UnitsInStock that are below the ReorderLevel sorted by highest quantity first.

SELECT ProductName as  'Products', UnitsInStock as'Current Stock', ReorderLevel as'Reorder Levels'

FROM PRODUCTS

WHERE UnitsInStock < ReorderLevel

ORDER BY UnitsInStock DESC

--2.  Show the First and Last Name (concatenated together) of all employees born before Jan 1, 1960?

SELECT FirstName + ' '+ LastName as  'Full Name',BirthDate as 'Birth Date' 

FROM Employees

WHERE BirthDate <'Jan 1, 1960'

--3.  Show the company names and formatted order date (like Jan 1, 2005) of all customers that have ordered any product beginning with the letter 'A'.

SELECT CompanyName as  'Company Name',CONVERT(varchar(20),OrderDate,107)as  'Order Date'

FROM Customers as c

JOIN Orders as o

ON c.CustomerID = o.CustomerID

JOIN [Order Details] as od

ON od.OrderID = o.OrderID

JOIN Products as p

ON p.ProductID = od.ProductID

WHERE ProductName LIKE 'A%'

--ORDER BY OrderDate ASC

--4.  Show the company names of all suppliers who have discontinued products.

SELECT CompanyName as  'Company Name', ProductName

FROM Suppliers as s

JOIN Products as p

ON s.SupplierID = p.SupplierID

WHERE Discontinued = 1

ORDER BY'Company Name'

--5.  Show the customer name of those who do not have orders.

SELECT c.ContactName

FROM Customers c

LEFT JOIN Orders o ON c.CustomerID = o.CustomerID

WHERE o.CustomerID is  null

--6.  Show the total dollar value of all the orders we have for each customer (one dollar amount for each customer). Order the list in descending order.

SELECT CompanyName 'Company Name', + '$' + CAST(SUM (UnitPrice * Quantity) as varchar(10))  as  'Total dollar value'

FROM [Order Details] as od

JOIN Orders as o

ON od.OrderID = o.OrderID

JOIN Customers as c

ON o.CustomerID = c.CustomerID

GROUP BY CompanyName

ORDER BY CompanyName DESC

--7.  Count and display the number of orders shipped by each shipper.

SELECT CompanyName,COUNT(OrderID)as  'Number of Orders'

FROM Shippers as sh

JOIN Orders as o

ON o.ShipVia = sh.ShipperID

GROUP BY CompanyName

--8.  Display the category name of all products that have sales greater than $10,000 for the year 1997.

SELECT CategoryName, SUM(od.UnitPrice * od.Quantity) as 'Sales total'

FROM Categories as c

JOIN Products as p

ON c.CategoryID = p.CategoryID

JOIN [Order Details] as od

ON p.ProductID = od.ProductID

JOIN Orders as o

ON od.OrderID = o.OrderID

WHERE OrderDate >='Jan 1, 1997'  and OrderDate <=  'Dec 31, 1997'

GROUP BY CategoryName

HAVING SUM(od.UnitPrice * od.Quantity)> 10000

ORDER BY CategoryName

--9.  List all the Orders without Customers*  (note:  the real database has referential integrity and all customers have orders, so use CustomersCopy)

SELECT Orders.OrderID

FROM Orders

LEFT  JOIN Customers

ON Customers.CustomerID = Orders.CustomerID

WHERE Customers.CustomerID IS  NULL

ORDER BY Customers.CustomerID

--10.  Create a global mailing list for all employees and customers combined.

SELECT Address FROM Customers

UNION

SELECT Address FROM Employees