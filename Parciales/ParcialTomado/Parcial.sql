--02-07-2025
NOTA = 8
3. Query
WITH CompraronTodosProd AS (
    SELECT c.customer_num
    FROM customer c
    WHERE NOT EXISTS (
        SELECT 1
        FROM products p
        WHERE p.manu_code IN ('HSK','NRG') AND NOT EXISTS (
														   SELECT 1
														   FROM items i JOIN orders o ON (i.order_num = o.order_num)
														   WHERE o.customer_num = c.customer_num AND i.manu_code = p.manu_code
																								AND i.stock_num = p.stock_num
														  )
    )
)
SELECT c.customer_num, c.lname, i.manu_code, pt.description,
    pt. stock_num, SUM(i.quantity) AS cantidad
FROM customer c JOIN orders o ON (c.customer_num = o.customer_num)
				JOIN items i ON (o.order_num = i.order_num)
				JOIN products p ON (i.stock_num = p.stock_num AND i.manu_code = p.manu_code)
				JOIN product_types pt ON (p.stock_num = pt.stock_num)
WHERE c.customer_num IN (SELECT customer_num 
						 FROM CompraronTodosProd)
    AND i.manu_code IN ('HSK', 'NRG')
GROUP BY c.customer_num, c.lname,  i.manu_code, pt.description, pt.stock_num
ORDER BY c.customer_num, cantidad DESC

-------------------------------------------------------------------------------------------------------------------------

4.Procedure
CREATE PROCEDURE registraProductoPR
(@stock_num SMALLINT, @manu_code CHAR(3), @unit_price DECIMAL(10, 2), @unit_code SMALLINT,
 @cat_descr TEXT, @cat_picture VARCHAR(255), @cat_advert VARCHAR(255) )
AS
BeGIN
    BEGIN TRY
        BEGIN TRANSACTION;
    IF EXISTS (SELECT 1 
			   FROM products 
			   WHERE stock_num = @stock_num AND manu_code = @manu_code)
    BEGIN
        UPDATE products
        SET unit_price = @unit_price, unit_code = @unit_code
        WHERE stock_num = @stock_num AND manu_code = @manu_code
	 END
    ELSE
    BEGIN
        INSERT INTO products (stock_num, manu_code, unit_price, unit_code)
        VALUES (@stock_num, @manu_code, @unit_price, @unit_code)
    END

    DECLARE @sig_numCat SMALLINT
    SELECT @sig_numCat  = MAX(catalog_num) + 1 FROM catalog

    INSERT INTO catalog (catalog_num, stock_num, manu_code, cat_descr, cat_picture, cat_advert)
    VALUES (@sig_numCat , @stock_num, @manu_code, @cat_descr, @cat_picture, @cat_advert)

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
		RAISERROR ('Se produj un error', 14, 1)
        ROLLBACK TRANSACTION
    END CATCH
END

--------------------------------------------------------------------------------------------------------------------------
5.Trigger


SELECT * INTO Clientes_BK FROM customer
SELECT * INTO Ordenes_BK FROM orders


CREATE TRIGGER trg_Ordenes_BK_ChequeoFK
ON Ordenes_BK
AFTER INSERT, UPDATE
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Clientes_BK c
        JOIN inserted i ON (c.customer_num = i.customer_num)
    )
    BEGIN
        RAISERROR ('el customer_num de la orden no existe en Clientes_BK', 14, 1);
        ROLLBACk TRANSACTION;
    END
END

CREATE TRIGGER trg_Clientes_BK_Intento_Elim
ON Clientes_BK
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        select 1
        FROM Ordenes_BK o
        JOIN deleted d On (o.customer_num = d.customer_num)
    )
    BEGIN
        RAISERROR ('no se puede eliminar el cliente porque tiene ordenes asociadas en Ordenes_BK', 14, 1);
        ROLLBACK TRANSACTION;
    END
END

CREATE TRIGGER trg_Clientes_BK_Intento_Elim
ON Clientes_BK
AFTER DELETE
AS
BEGIN
    IF EXISTS (
        select 1
        FROM Ordenes_BK o
        JOIN deleted d On (o.customer_num = d.customer_num)
    )
    BEGIN
        RAISERROR ('no se puede elminar el cliente porque tiene ordenes asociadas en Ordenes_BK', 14, 1);
    ROLLBACK TRANSACTION
    END
END

CREATE TRIGGER trg_Clientes_BK_Intento_Act
ON Clientes_BK
AFTER UPDATE
AS
BEGIN
    IF update(customer_num) AND EXISTS (
        SELECT 1
        FROM Ordenes_BK o
        JOIN deleted d ON (o.customer_num = d.customer_num)
    )
    BEGIN
        RAISERROR ('no se puede actualizar el customer_num porque tiene ordenes asociadas en Ordenes_BK', 14, 1);
        ROLLBACK TRANSACTION
    END
END
