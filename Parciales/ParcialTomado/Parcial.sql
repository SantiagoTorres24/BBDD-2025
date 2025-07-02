--02-07-2025

--QUERY
SELECT c.customer_num, c.lname, m.manu_code, p.stock_num, SUM(i.quantity) AS cantidad
FROM customer c JOIN orders o ON o.customer_num = c.customer_num
				JOIN items i ON i.order_num = o.order_num
				JOIN products p ON p.stock_num = i.stock_num -- tipo producto hace ref al stock num de products
				JOIN manufact m ON m.manu_code = p.manu_code
WHERE m.manu_code IN ('HSK', 'NRG') 
AND c.customer_num IN (
    SELECT c2.customer_num
    FROM customer c2 JOIN orders o2 ON o2.customer_num = c2.customer_num
					 JOIN items i2 ON i2.order_num = o2.order_num
				     JOIN manufact m2 ON m2.manu_code = i2.manu_code
    WHERE m2.manu_code IN ('HSK', 'NRG')
    GROUP BY c2.customer_num
    HAVING COUNT(DISTINCT m2.manu_code) = 2 
  )
GROUP BY c.customer_num, c.lname, m.manu_code, p.stock_num
ORDER BY c.customer_num, cantidad DESC

--STORED PROCEDURE
GO
CREATE PROCEDURE registraProductoPR 
    @stock_num SMALLINT,
    @manu_code CHAR(3),
    @unit_price DECIMAL(10,2),
    @unit_code SMALLINT,
    @status VARCHAR(15) OUTPUT,
    @cat_descr TEXT,
    @cat_picture VARCHAR(255),
    @cat_advert VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION; -- como ante cualquier error debo abortar todas las operaciones, decido manejar todo con una transaccion

        IF NOT EXISTS (SELECT 1 FROM products WHERE stock_num = @stock_num AND manu_code = @manu_code)
        BEGIN
            SET @status = 'insercion'; -- seteo el estado para explicitar el tipo de operacion 
            INSERT INTO products(stock_num, manu_code, unit_price, unit_code)
            VALUES(@stock_num, @manu_code, @unit_price, @unit_code);
        END
        ELSE
        BEGIN
            SET @status = 'modificacion';
            UPDATE products
            SET unit_price = @unit_price,
                unit_code = @unit_code
            WHERE stock_num = @stock_num AND manu_code = @manu_code;
        END

		DECLARE @catalog_num smallint;
		SELECT @catalog_num = ISNULL(MAX(catalog_num), 0) + 1 FROM catalog; -- sumo 1 al ultimo catalog_num y lo inserto

        INSERT INTO catalog(catalog_num, stock_num, manu_code, cat_descr, cat_picture, cat_advert)
        VALUES(@catalog_num, @stock_num, @manu_code, @cat_descr, @cat_picture, @cat_advert);

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END; 


--TRIGGER
SELECT * INTO Clientes_BK
FROM customer;

SELECT * INTO Ordenes_BK
FROM orders;

-- No puedo insertar una orden si el cliente no existe							
GO
CREATE TRIGGER ordenInsert
ON Ordenes_BK
INSTEAD OF INSERT, 
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM inserted i
				   WHERE NOT EXISTS (SELECT 1 FROM Clientes_BK c
									 WHERE c.customer_num = i.customer_num))
        BEGIN
            THROW 50001, 'No se puede insertar orden: el cliente no existe en Clientes_BK', 1;
        END

        INSERT INTO Ordenes_BK
        SELECT *
        FROM inserted;

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;

-- Si hago un update en ordenes, debe existir el cliente
GO
CREATE TRIGGER ordenUpdate
ON Ordenes_BK
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM inserted i
				   WHERE NOT EXISTS (SELECT 1 FROM Clientes_BK c
									 WHERE c.customer_num = i.customer_num))
        BEGIN
            THROW 50003, 'No se puede actualizar orden: el cliente no existe en Clientes_BK', 1;
        END

        UPDATE o
        SET 
            o.order_date = i.order_date,
            o.customer_num = i.customer_num,
            o.ship_instruct = i.ship_instruct,
			o.backlog = i.backlog,
			o.po_num = i.po_num,
			o.ship_date = i.ship_date,
			o.ship_weight = i.ship_weight,
			o.ship_charge = i.ship_charge,
			o.paid_date = i.paid_date
        FROM Ordenes_BK o
        JOIN inserted i ON o.order_num = i.order_num;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;


-- No puedo eliminar un cliente si tiene ordenes asociadas
GO
CREATE TRIGGER deleteCliente
ON Clientes_BK
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM deleted d JOIN Ordenes_BK o ON d.customer_num = o.customer_num)
        BEGIN
            THROW 50002, 'No se puede eliminar el cliente: tiene órdenes asociadas en Ordenes_BK', 1;
        END

        DELETE FROM Clientes_BK
        WHERE customer_num IN (SELECT customer_num FROM deleted);

        COMMIT TRANSACTION;
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
    END CATCH
END;
