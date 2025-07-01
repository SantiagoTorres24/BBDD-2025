--23-11-2022

--QUERY
SELECT 
    s.sname AS Estado,
    est.total_estado AS MontoTotalEstado,
    m.manu_name AS Fabricante,
    SUM(i.unit_price * i.quantity) AS MontoFabricante
FROM state s
JOIN manufact m ON m.state = s.state
JOIN items i ON i.manu_code = m.manu_code
JOIN (
    SELECT TOP 3 
        s.state,
        SUM(i.unit_price * i.quantity) AS total_estado
    FROM state s
    JOIN manufact m ON m.state = s.state
    JOIN items i ON i.manu_code = m.manu_code
    GROUP BY s.state
    ORDER BY total_estado DESC
) est ON est.state = s.state
GROUP BY s.sname, est.total_estado, m.manu_name, m.manu_code
HAVING SUM(i.unit_price * i.quantity) > 0.15 * est.total_estado
ORDER BY est.total_estado DESC, SUM(i.unit_price * i.quantity) DESC;

--STORED PROCEDURE
GO
CREATE PROCEDURE ResumenMensualPR
		@fecha DATETIME
AS
BEGIN
 BEGIN TRY
  BEGIN TRANSACTION

		SET NOCOUNT ON;

  DECLARE @cadenaFecha varchar(6)
  SET @cadenaFecha = CAST(YEAR(@fecha) * 100 + MONTH(@fecha) AS varchar(6))

  INSERT INTO VENTASxMES
  SELECT @cadenaFecha, p.stock_num, p.manu_code,
		 SUM( CASE WHEN unit = 'Box' THEN quantity * 12
				   WHEN unit = 'Case' THEN quantity * 6
				   WHEN unit = 'Pair' THEN quantity * 2
				   WHEN unit = 'Each' THEN quantity
			  END),
		 SUM(i.unit_price * quantity)
  FROM products p JOIN items i ON i.manu_code = p.manu_code AND i.stock_num = p.stock_num
				  JOIN units u ON u.unit_code = p.unit_code
				  JOIN orders o	ON o.order_num = i.order_num
  WHERE YEAR(order_date) = YEAR(@fecha) AND MONTH(order_date) = MONTH(@fecha)
  GROUP BY p.stock_num, p.manu_code

  COMMIT;

  END TRY

  BEGIN CATCH
   ROLLBACK TRANSACTION
  END CATCH

END;

--TRIGGER
CREATE TABLE PermisosXProducto(
	customer_num int,
	manu_code int,
	stock_num int,
);
GO
CREATE TRIGGER validarPermisosPorProducto
ON items
AFTER INSERT
AS
BEGIN
    -- si no hay registro en PermisosXProducti
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN orders o ON i.order_num = o.order_num
        LEFT JOIN PermisosxProducto p
            ON p.customer_num = o.customer_num
            AND p.manu_code = i.manu_code
            AND p.stock_num = i.stock_num
        WHERE p.customer_num IS NULL
    )
    BEGIN
        RAISERROR ('El cliente no tiene permiso para comprar uno o más productos.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
