-- 006_cleanup_orders.sql
DELETE FROM Orders;

SELECT * FROM dbo.Orders WITH (NOLOCK)
WHERE YEAR(OrderDate) = 2025;

DROP INDEX IX_Orders_CustomerID ON dbo.Orders;
