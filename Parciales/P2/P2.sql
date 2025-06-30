--22-02-2023

--QUERY
SELECT c.customer_num, lname, c.state, SUM(unit_price * quantity) AS montoTotal
FROM customer c JOIN orders o ON o.customer_num = c.customer_num
				JOIN items i ON i.order_num = o.order_num
JOIN(SELECT TOP 1 c.state FROM cust_calls cc 
		JOIN customer c ON c.customer_num = cc.customer_num
		GROUP BY c.state
		ORDER BY COUNT(*) DESC) max on max.state = c.state
JOIN(SELECT c.customer_num FROM customer c
		JOIN orders o ON o.customer_num = c.customer_num
		GROUP BY c.customer_num
		HAVING COUNT(DISTINCT order_num) >= 2) clientesActivos ON clientesActivos.customer_num = c.customer_num
GROUP BY c.customer_num, lname, c.state
ORDER BY montoTotal DESC

--STORED PROCEDURE
CREATE TABLE Novedades (
    FechaAlta         DATETIME       NOT NULL,
    manu_code         CHAR(3)        NOT NULL,
    stock_num         SMALLINT       NOT NULL,
    descTipoProducto  VARCHAR(50)    NOT NULL,
    unit_price        DECIMAL(10,2)  NOT NULL,
    unit_code         SMALLINT       NOT NULL
);
GO
CREATE PROCEDURE actualizarPreciosPR
    @fecha DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FechaAlta DATETIME,
            @manu_code CHAR(3),
            @stock_num SMALLINT,
            @descTipoProducto VARCHAR(50),
            @unit_price DECIMAL(10,2),
            @unit_code SMALLINT;

    DECLARE novCursor CURSOR FOR -- para leer registro por registro de novedades
        SELECT FechaAlta, manu_code, stock_num, descTipoProducto, unit_price, unit_code
        FROM Novedades
        WHERE FechaAlta >= @fecha;

    OPEN novCursor; -- hace el select de arriba

    FETCH NEXT FROM novCursor INTO -- mueve a la siguiente linea
        @FechaAlta, @manu_code, @stock_num, @descTipoProducto, @unit_price, @unit_code;

    WHILE @@FETCH_STATUS = 0 -- cuando no hay mas registros devuelve -1
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION;

            -- ver si existe fabricante
            IF NOT EXISTS (SELECT 1 FROM manufact WHERE manu_code = @manu_code)
            BEGIN
                THROW 50001, 'Fabricante Inexistente', 1;
            END

            -- si no existe el stock_num, lo inserto
            IF NOT EXISTS (SELECT 1 FROM product_types WHERE stock_num = @stock_num)
            BEGIN
                INSERT INTO product_types (stock_num, description)
                VALUES (@stock_num, @descTipoProducto);
            END

            -- si existe, lo actualizo
            IF EXISTS (SELECT 1 FROM products WHERE manu_code = @manu_code AND stock_num = @stock_num)
            BEGIN
                UPDATE products
                SET unit_price = @unit_price,
                    unit_code = @unit_code
                WHERE manu_code = @manu_code AND stock_num = @stock_num;
            END
            ELSE
            BEGIN
                -- si no existe el producto, lo inserto
                INSERT INTO products (stock_num, manu_code, unit_price, unit_code)
                VALUES (@stock_num, @manu_code, @unit_price, @unit_code);
            END

            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
        END CATCH

        FETCH NEXT FROM novCursor INTO 
            @FechaAlta, @manu_code, @stock_num, @descTipoProducto, @unit_price, @unit_code;
    END

    CLOSE novCursor; -- cierro el cursor
    DEALLOCATE novCursor; -- lo borro
END;

--TRIGGER
CREATE TABLE TotalesClienteProducto (
    customer_num   INTEGER     NOT NULL,
    manu_code      CHAR(3)     NOT NULL,
    stock_num      SMALLINT    NOT NULL,
    sumQuantity    INT         NOT NULL DEFAULT 0,
    CONSTRAINT PK_TotalesClienteProducto 
        PRIMARY KEY (customer_num, manu_code, stock_num)
);
GO
CREATE TRIGGER totalesClientesProducto
ON items
AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
		BEGIN TRY

	MERGE TotalesClienteProducto AS t -- TARGET
	USING(SELECT o.customer_num, i.manu_code, i.stock_num, SUM(i.quantity) AS total
		  FROM inserted i JOIN orders o ON o.order_num = i.order_num
		  GROUP BY o.customer_num, i.manu_code, i.stock_num) AS s -- SOURCE
	ON t.customer_num = s.customer_num 
	AND t.manu_code = s.manu_code
	AND t.stock_num = s.stock_num

	WHEN MATCHED THEN 
		UPDATE SET sumQuantity = t.sumQuantity + s.total

	WHEN NOT MATCHED THEN
		INSERT(customer_num, manu_code, stock_num, sumQuantity)
		VALUES(s.customer_num, s.manu_code, s.stock_num, s.total);

		END TRY

		BEGIN CATCH
			ROLLBACK TRANSACTION;
		END CATCH
END;

