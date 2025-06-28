--27-11-2019

--QUERY
CREATE VIEW comprasFabricanteLider (nombreFabricante, nomCliente, apeCliente, producto, totalPesos, totalCantidad)
AS
SELECT manu_name, 
	   fname, 
	   lname, 
	   description, 
	   SUM(unit_price * quantity) totalPesos, 
	   SUM(quantity) totalCantidad
FROM orders o JOIN customer c ON c.customer_num = o.customer_num
				JOIN items i ON i.order_num = o.order_num
				JOIN product_types pt ON pt.stock_num = i.stock_num
				JOIN manufact m ON m.manu_code = i.manu_code
JOIN (SELECT TOP 1 manu_code, SUM(unit_price * quantity) total
	  FROM items i 
	  GROUP BY manu_code
	  ORDER BY total DESC) max on max.manu_code = i.manu_code -- al manu_code que llama en la subconsulta lo asocia a max y lo compara con i.manu_code
WHERE description LIKE '%ball' 
GROUP BY manu_name, c.customer_num, fname, lname, description
HAVING SUM(unit_price * quantity)/SUM(quantity) > 150

SELECT * FROM comprasFabricanteLider

--STORED PROCEDURE

CREATE TABLE VENTASxMES(
	anioMes varchar(6),
	stock_num smallint,
	manu_code varchar(3),
	Cantidad int,
	Monto decimal(10,2) -- 10 numeros en total con 2 decimales -> 12345678.90
);
GO
CREATE PROCEDURE ventasPorMes 
	@fecha datetime 
AS 
BEGIN
 BEGIN TRY
  BEGIN TRANSACTION

  DECLARE @cadenaFecha varchar(6)
  SET @cadenaFecha = CAST(YEAR(@fecha) * 100 + MONTH(@fecha) as varchar(6)) -- 2025 * 100 = 202500 + 09 = '202509' 

  INSERT INTO VENTASxMES
  SELECT @cadenaFecha, i.stock_num, i.manu_code,
		 SUM(CASE WHEN p.unit_code = 1 THEN quantity
				  WHEN p.unit_code = 2 THEN quantity * 2
				  WHEN p.unit_code = 3 THEN quantity * 12
			 END),
		 SUM(quantity * i.unit_price)
  FROM orders o
  JOIN items i ON i.order_num = o.order_num
  JOIN products p ON p.manu_code = i.manu_code AND p.stock_num = i.stock_num
  WHERE YEAR(order_date) = YEAR(@fecha) AND MONTH(order_date) = MONTH(@fecha)
  GROUP BY i.manu_code, i.stock_num;
  
commit;
end try
begin catch
rollback;
end catch
end

EXEC ventasPorMes '2015-05-16';

SELECT * FROM VENTASxMES

--TRIGGERS
CREATE TABLE CUSTOMER_AUDIT (
    customer_num SMALLINT NOT NULL,
    update_date DATETIME NOT NULL,
    ApeyNom_NEW VARCHAR(40),
    State_NEW CHAR(2),
    customer_num_referedBy_NEW SMALLINT,
    ApeyNom_OLD VARCHAR(40),
    State_OLD CHAR(2),
    customer_num_referedBy_OLD SMALLINT,
    update_user VARCHAR(30) NOT NULL,
);

CREATE TRIGGER auditCustomer ON customer
after delete, update as -- se activa desp de un DELETE o UPDATE en customer
begin
	declare @customer_num int,
			@apeYNomNew varchar(40), 
			@stateNew char(2),
			@customer_num_referedByNew int, 
			@apeYNomOld varchar(40),
			@stateOld char(2),
			@customer_num_referedByOld int

	declare auditCur CURSOR FOR
		SELECT d.customer_num,
			   i.lname + ' ' + i.fname, i.state, i.customer_num_referedby, -- se almacenan los datos nuevos desp del cambio
			   d.lname + ' ' + d.lname, i.state, i.customer_num_referedby  -- se almacenan los datos viejos desp del cambio
		FROM deleted d
		LEFT JOIN inserted i ON i.customer_num = d.customer_num; -- deleted e inserted son tablas temporales para los triggers

OPEN auditCur 
FETCH NEXT FROM auditCur INTO @customer_num,
							  @apeYNomNew, @stateNew, @customer_num_referedByNew,
							  @apeYNomOld, @stateOld, @customer_num_referedByNew;

WHILE (@@FETCH_STATUS = 0)
 BEGIN
  BEGIN TRY
   BEGIN TRANSACTION
   IF NOT EXISTS (SELECT 1 FROM inserted) -- quiere decir que se produjo un DELETE
   BEGIN
	INSERT INTO CUSTOMER_AUDIT(customer_num, update_date, apeYNom_OLD, 
	                           state_OLD, customer_num_referedBy_OLD, update_user)
					VALUES(@customer_num, getDate(), @apeYNomOld, @stateOld,
					       @customer_num_referedByOld, SYSTEM_USER) -- como fue un DELETE, inserto los viejos -> los NEW van en NULL
	END
	ELSE
	BEGIN
	IF NOT EXISTS(SELECT 1 FROM customer 
					WHERE customer_num = @customer_num_referedByNew)
	  THROW 50001, 'Referente Inexistente', 1;
	IF NOT EXISTS(SELECT 1 FROM state WHERE state = @stateNew)
	  THROW 5002, 'Estado Inexistente', 1;

	INSERT INTO CUSTOMER_AUDIT(customer_num, update_date, -- update, inserto todos los datos
							   apeYNom_NEW, state_NEW, customer_num_referedBy_NEW,
	                           apeYNom_OLD, state_OLD, customer_num_referedBy_OLD, update_user)
				VALUES(@customer_num, getDate(), 
				       @apeYNomNew, @stateNew, @customer_num_referedByNew,
					   @apeYNomOld, @stateOld, @customer_num_referedByOld, SYSTEM_USER)
	END
	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
	 ROLLBACK TRANSACTION
	END CATCH

	FETCH NEXT FROM auditCur
	INTO @customer_num, 
	     @apeYNomNew, @stateNew, @customer_num_referedByNew,
		 @apeYNomOld, @stateOld, @customer_num_referedByOld;
	END

	CLOSE auditCur
	DEALLOCATE auditCur
END;