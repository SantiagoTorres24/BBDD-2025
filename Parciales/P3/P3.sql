--QUERY
WITH VentasPorEstado AS (
	SELECT state, SUM(unit_price * quantity) AS TotalEstado
	FROM customer c
	JOIN orders o ON o.customer_num = c.customer_num
	JOIN items i ON i.order_num = o.order_num
	GROUP BY state
),
TopEstados AS (
	SELECT TOP 3 state
	FROM VentasPorEstado
	ORDER BY TotalEstado DESC
)
SELECT c.state, c.customer_num, lname, fname,
	   SUM(unit_price * quantity) / COUNT(DISTINCT o.order_num) AS Promedio,
	   SUM(unit_price * quantity) AS Total,
	   ve.TotalEstado
FROM customer c
JOIN orders o ON o.customer_num = c.customer_num
JOIN items i ON i.order_num = o.order_num
JOIN VentasPorEstado ve ON ve.state = c.state
WHERE c.state IN (SELECT state FROM TopEstados)
GROUP BY c.state, c.customer_num, lname, fname, ve.TotalEstado
HAVING SUM(unit_price * quantity) > 85
ORDER BY ve.TotalEstado DESC, Total DESC;

--STORED PROCEDURE
CREATE TABLE CuentaCorriente (
	Id BIGINT IDENTITY(1,1),
	fechaMovimiento DATETIME,
	customer_num SMALLINT,
	order_num SMALLINT,
	importe DECIMAL(12,2),
	FOREIGN KEY (customer_num) REFERENCES customer (customer_num),
	FOREIGN KEY (order_num) REFERENCES orders (order_num)
);

GO 
CREATE PROCEDURE cargarCuentaCorriente 
AS BEGIN
	SET NOCOUNT ON;

	INSERT INTO cuentaCorriente(fechaMovimiento, customer_num, order_num, importe)
	SELECT order_date, customer_num, o.order_num, SUM(unit_price * quantity)
		FROM orders o JOIN items i ON i.order_num = o.order_num
	GROUP BY order_date, customer_num, o.order_num;

	INSERT INTO cuentaCorriente(fechaMovimiento, customer_num, order_num, importe)
	SELECT paid_date, customer_num, o.order_num, SUM(unit_price * quantity * -1)
		FROM orders o JOIN items i ON i.order_num = o.order_num
	GROUP BY paid_date, customer_num, o.order_num;
END;

EXEC cargarCuentaCorriente;

SELECT * FROM CuentaCorriente

--TRIGGER
GO
CREATE TRIGGER auditorias ON customer
AFTER DELETE, UPDATE AS
BEGIN

	DECLARE @customer_num int, @apeNomNew varchar(40), 
			@stateNew varchar(3), @customer_num_referedByNew int,
			@apeNomOld varchar(40), @stateOld varchar(3),
			@customer_num_referedByOld int

	DECLARE auditCur CURSOR FOR

	SELECT d.customer_num, i.fname + ' ' + i.lname, i.state, i.customer_num_referedBy,
						   d.fname + ' ' + d.lname, d.state, d.customer_num_referedBy
	FROM deleted d LEFT JOIN inserted i ON i.customer_num = d.customer_num

	OPEN auditCur

	FETCH NEXT FROM auditCur
	into @customer_num,
		 @apeNomNew, @stateNew, @customer_num_referedByNew,
		 @apeNomOld, @stateOld, @customer_num_referedByOld;

	WHILE (@@FETCH_STATUS = 0)

	BEGIN
	 BEGIN TRY
	  BEGIN TRANSACTION

	  IF NOT EXISTS (SELECT 1 FROM inserted)
	  BEGIN
	   INSERT INTO CUSTOMER_AUDIT(customer_num, update_date, ApeyNom_OLD, State_OLD, customer_num_referedBy_OLD, update_user)
	   VALUES(@customer_num, getDate(), @apeNomOld, @stateOld, @customer_num_referedByOld, SYSTEM_USER)

	   END 

	   ELSE
	    BEGIN

	  IF NOT EXISTS(SELECT 1 FROM customer
                    WHERE customer_num = @customer_num_referedByNew)
      THROW 50001, 'Referente inexistente', 1;
        
	  IF NOT EXISTS(SELECT 1 FROM state WHERE state = @stateNEW)
      THROW 50002, 'Estado inexistente', 1;
          
      INSERT INTO customer_audit(customer_num, update_Date,apeynom_NEW, state_NEW,customer_num_referedby_NEW, 
														   apeynom_OLD, state_Old, customer_num_referedby_OLD,
														   update_user)
      VALUES(@customer_num, getDate(),
             @apeNomNew, @stateNew, @customer_num_referedByNew,
             @apeNomOld, @stateOld, @customer_num_referedByOld,
			 SYSTEM_USER)
      END
      COMMIT TRANSACTION
      END TRY
    
    BEGIN CATCH
      ROLLBACK TRANSACTION
    END CATCH
      
    FETCH NEXT FROM auditCur
    INTO @customer_num,
         @apeNomNew, @stateNew, @customer_num_referedByNew,
         @apeNomOld, @stateOld, @customer_num_referedByOld;
    END
  
    CLOSE auditCur
    DEALLOCATE auditCur
END;
