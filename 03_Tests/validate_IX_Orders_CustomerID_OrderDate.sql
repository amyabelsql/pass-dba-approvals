IF EXISTS (
    SELECT 1
    FROM sys.indexes AS i
    INNER JOIN sys.tables AS t
        ON t.object_id = i.object_id
    INNER JOIN sys.schemas AS s
        ON s.schema_id = t.schema_id
    WHERE s.name = N'dbo'
      AND t.name = N'Orders'
      AND i.name = N'IX_Orders_CustomerID_OrderDate'
)
    PRINT 'PASS: index exists on dbo.Orders';
ELSE
    PRINT 'FAIL: index does not exist on dbo.Orders';

IF EXISTS (
    SELECT 1
    FROM sys.indexes AS i
    INNER JOIN sys.tables AS t
        ON t.object_id = i.object_id
    INNER JOIN sys.schemas AS s
        ON s.schema_id = t.schema_id
    INNER JOIN sys.index_columns AS ic
        ON ic.object_id = i.object_id
       AND ic.index_id = i.index_id
    INNER JOIN sys.columns AS c
        ON c.object_id = ic.object_id
       AND c.column_id = ic.column_id
    WHERE s.name = N'dbo'
      AND t.name = N'Orders'
      AND i.name = N'IX_Orders_CustomerID_OrderDate'
      AND ic.key_ordinal = 1
      AND c.name = N'CustomerID'
      AND (
          SELECT COUNT(*)
          FROM sys.index_columns AS key_ic
          WHERE key_ic.object_id = i.object_id
            AND key_ic.index_id = i.index_id
            AND key_ic.key_ordinal > 0
      ) = 2
      AND EXISTS (
          SELECT 1
          FROM sys.index_columns AS date_ic
          INNER JOIN sys.columns AS date_c
              ON date_c.object_id = date_ic.object_id
             AND date_c.column_id = date_ic.column_id
          WHERE date_ic.object_id = i.object_id
            AND date_ic.index_id = i.index_id
            AND date_ic.key_ordinal = 2
            AND date_ic.is_descending_key = 1
            AND date_c.name = N'OrderDate'
      )
)
    PRINT 'PASS: key columns are CustomerID, OrderDate DESC';
ELSE
    PRINT 'FAIL: key columns are not CustomerID, OrderDate DESC';

IF EXISTS (
    SELECT 1
    FROM sys.indexes AS i
    INNER JOIN sys.tables AS t
        ON t.object_id = i.object_id
    INNER JOIN sys.schemas AS s
        ON s.schema_id = t.schema_id
    WHERE s.name = N'dbo'
      AND t.name = N'Orders'
      AND i.name = N'IX_Orders_CustomerID_OrderDate'
      AND EXISTS (
          SELECT 1
          FROM sys.index_columns AS ic
          INNER JOIN sys.columns AS c
              ON c.object_id = ic.object_id
             AND c.column_id = ic.column_id
          WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
            AND c.name = N'OrderTotal'
      )
      AND EXISTS (
          SELECT 1
          FROM sys.index_columns AS ic
          INNER JOIN sys.columns AS c
              ON c.object_id = ic.object_id
             AND c.column_id = ic.column_id
          WHERE ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
            AND c.name = N'OrderStatus'
      )
)
    PRINT 'PASS: included columns are OrderTotal and OrderStatus';
ELSE
    PRINT 'FAIL: included columns are not OrderTotal and OrderStatus';
