--29-11-2023

--QUERY
SELECT 
    c.customer_num,
    c.lname,
    c.fname,
    SUM(i.unit_price * i.quantity) AS montoReferente,
    SUM(iref.unit_price * iref.quantity) AS montoReferidos
FROM customer c
JOIN orders o ON o.customer_num = c.customer_num
JOIN items i ON i.order_num = o.order_num

JOIN customer ref ON ref.customer_num_referedBy = c.customer_num
JOIN orders oref ON oref.customer_num = ref.customer_num
JOIN items iref ON iref.order_num = oref.order_num

GROUP BY c.customer_num, c.lname, c.fname
HAVING SUM(i.unit_price * i.quantity) > SUM(iref.unit_price * iref.quantity)
ORDER BY c.customer_num;

--TRIGGER
GO
CREATE VIEW OrdenesItems AS 
SELECT o.order_num, o.order_date, o.customer_num, o.paid_date,
	   i.item_num, i.stock_num, i.manu_code, i.unit_price, i.quantity
FROM orders o JOIN items i ON o.order_num = i.order_num

SELECT * FROM OrdenesItems
EXEC sp_help OrdenesItems

GO
CREATE TRIGGER altaOrden ON OrdenesItems
AFTER INSERT
AS

BEGIN
 BEGIN TRY
  BEGIN TRANSACTION

  --valido que haya una sola orden y un solo cliente

  IF( (SELECT COUNT(DISTINCT order_num) FROM inserted) > 1 OR
	  (SELECT COUNT(DISTINCT customer_num) FROM inserted) > 1 )
	  THROW 5001, 'Los datos no son de una misma orden y mismo cliente',1;
	  BEGIN 
	   ROLLBACK TRANSACTION
	  RETURN;

	  END


--valido que no hayan fabricantes de mas de 1 provincia
  IF EXISTs (
	SELECT 1 FROM inserted i
	JOIN items it ON it.stock_num = i.stock_num
	JOIN manufact m ON m.manu_code = it.manu_code
	GROUP BY i.order_num
	HAVING COUNT(DISTINCT m.manu_code) > 1
)
  THROW 5002, 'Hay fabricantes de mas de 1 provincia', 1;
  BEGIN
   ROLLBACK TRANSACTION
  RETURN;

  END

-- inserto en orders
INSERT INTO orders(order_num, order_date, customer_num, paid_date)
	SELECT order_num, order_date, customer_num, paid_date
	FROM inserted i
	WHERE NOT EXISTS(
		SELECT o.order_num FROM orders o WHERE o.order_num = i.order_num);

-- inserto en items
INSERT INTO items(item_num, order_num, stock_num, manu_code, quantity, unit_price)
	SELECT item_num, order_num, stock_num, manu_code, quantity, unit_price
	FROM inserted i
	WHERE NOT EXISTS(
		SELECT it.item_num FROM items it WHERE it.item_num = i.item_num);

	COMMIT TRANSACTION;

END TRY

BEGIN CATCH
 ROLLBACK TRANSACTION
END CATCH

END;
  
--STORED PROCEDURE
CREATE TABLE CuentaCorriente(
	Id int IDENTITY,
	fechaMovimiento DATETIME,
	customer_num smallint,
	order_num smallint,
	importe DECIMAL(10,2),
	FOREIGN KEY (customer_num) references customer (customer_num),
	FOREIGN KEY (order_num) references orders (order_num)
);

CREATE TABLE ErroresCtaCte(
	order_num smallint,
	mensajeError varchar(100)
);

GO
CREATE PROCEDURE cargarTabla
AS
BEGIN
	SET NOCOUNT ON; 

	DECLARE @customer_num smallint, @order_num smallint, @order_date datetime,
			@paid_date datetime, @unit_price int, @quantity int;

	DECLARE carCursor CURSOR FOR 
		SELECT customer_num, o.order_num, order_date, paid_date, unit_price, quantity
		FROM orders o JOIN items i ON i.order_num = o.order_num

	OPEN carCursor;

	FETCH NEXT FROM carCursor INTO 
		@customer_num, @order_num, @order_date, @paid_date, @unit_price, @quantity;

WHILE(@@FETCH_STATUS = 0)
BEGIN
 BEGIN TRY
  BEGIN TRANSACTION

  INSERT INTO CuentaCorriente(fechaMovimiento, customer_num, order_num, importe)
	VALUES(@order_date, @customer_num, @order_num, @unit_price * @quantity)

  IF @paid_date IS NOT NULL
  BEGIN
		INSERT INTO CuentaCorriente(fechaMovimiento, customer_num, order_num, importe)
			VALUES(@paid_date, @customer_num, @order_num, @unit_price * @quantity * (-1))
  
  END

  COMMIT TRANSACTION;

  END TRY

  BEGIN CATCH
   ROLLBACK TRANSACTION
		INSERT INTO ErroresCtaCte(order_num, mensajeError)
			VALUES(@order_num, ERROR_MESSAGE())
  END CATCH

    FETCH NEXT FROM cur INTO 
            @order_num, @customer_num, @order_date, @paid_date, @unit_price, @quantity;
    END;

    CLOSE cur;
    DEALLOCATE cur;
END;