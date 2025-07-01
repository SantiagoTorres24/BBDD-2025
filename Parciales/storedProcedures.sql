/* Desarrolar un stored procedure que maneje la insercion o modificacion de un producto determinado
si eixste el producto en la tabla products, actualizar los at ributos que no pertenecen a la clave primaria
si no existe el producto en products, insertarfila en tabla previamente validad lo siguiente:
  - existencia de manu_code en tabla MANUFACT - informado error por fabricante inexistente
  - existencia de stock-num en tabla product_types - si no existe insertar registro en la tabla 
    stock_num , si existe realizar update del atributo "description" 
  - existencia del atibuto unit_code en la tabla units- informando por error codigo unidad inexistente*/
GO
CREATE PROCEDURE manejoProductos 
AS
BEGIN
 BEGIN TRY
  BEGIN TRANSACTION

  SET NOCOUNT ON;

  DECLARE @stock_num int,
          @manu_code varchar(3),
		  @unit_price float,
		  @unit_code int,
		  @description varchar(50);

  IF EXISTS (SELECT stock_num FROM products WHERE stock_num = @stock_num
			 AND manu_code = @manu_code)
  BEGIN
   UPDATE products
   SET unit_price = @unit_price,
	   unit_code = @unit_code
   WHERE products.stock_num = @stock_num AND
		 products.manu_code = @manu_code
  END

  ELSE
  BEGIN

  IF NOT EXISTS(SELECT manu_code FROM manufact WHERE manu_code = @manu_code)
  THROW 50001,'Fabricante Desconocido', 1;

  IF NOT EXISTS(SELECT stock_num FROM product_types WHERE stock_num = @stock_num)
	INSERT INTO product_types(stock_num, description)
	VALUES(@stock_num, @description)
  ELSE
	UPDATE product_types 
	SET description = @description 
	WHERE product_types.stock_num = @stock_num
  
  IF NOT EXISTS(SELECT unit_code FROM units WHERE unit_code = @unit_code)
  THROW 50002, 'Unidad Desconocida', 1;

  INSERT INTO products(stock_num, manu_code, unit_code, unit_price)
  VALUES(@stock_num, @manu_code, @unit_code, @unit_price);

  INSERT INTO product_types(stock_num, description)
  VALUES(@stock_num, @description)

  END
 
  COMMIT TRANSACTION;

  END TRY 

  BEGIN CATCH
   ROLLBACK TRANSACTION;
  END CATCH

END;

/*crear un procedure actualiza cliente el cual tomara de una tabla "clientesAltaOnline" 
previamente cargada por otro proceso, la siguiente info:'
'customer_num, lname, fnmae, company, addres1, city, state' 
'por cada fila de la tabla clientesAltaOnline se debera evaluar '
• 'si el cliente existe en customer, modificar dicho cliente en la tabla custoemr con los 
datos leidos de la tabla clientesAltaOnline'
• 'si el cliente no existe en customer, se debera insertar el cliente en al tabla custoemr 
con los datos leidos de la tabla clientesAltaOnline'
'el procedimiento debera almacenar por cada operacion realizada una fila en al tabla auditoria 
con los siguientes atributos':
'idauditoria(identity), operacion(insert o modificado), custome_num, lname, fname, addres, city, state'
'manejar una transaccion por cada cliente*/
GO
CREATE PROCEDURE actualizarCliente
AS
BEGIN

  SET NOCOUNT ON;

      DECLARE @customer_num smallint,
            @lname varchar(15),
            @fname varchar(15),
            @company varchar(15),
            @addres varchar(15),
			@city varchar(15),
			@state char(2),
			@operacion varchar(9)

	DECLARE actCursor CURSOR FOR
		SELECT Customer_num, lname, fname, Company, address1, city, state
		FROM clientesAltaOnLine

	OPEN actCursor;

	FETCH NEXT FROM actCursor INTO @customer_num, @lname, @fname, @company,
								   @city, @state, @operacion

	WHILE (@@FETCH_STATUS = 0)

	BEGIN
	 BEGIN TRY
	  BEGIN TRANSACTION

	  IF EXISTS(SELECT 1 FROM customer WHERE customer_num = @customer_num)
	  BEGIN
	  SET @operacion = 'modificacion'
		  UPDATE customer
		  SET lname = @lname,
		  fname = @fname,
		  company=@company,
		  address1 = @addres,
		  city = @city,
		  state = @state
	  WHERE customer_num = @customer_num
	  END

	  ELSE
	  BEGIN
	  SET @operacion = 'insertacion'
	  INSERT INTO customer(customer_num, lname, fname, company, address1, city, state)
	  VALUES(@customer_num, @lname, @fname, @company, @addres, @city, @state)
	  END

	  BEGIN

	  INSERT INTO auditoria(operacion, customer_num, lname, fname, company, address1, city, state)
	  VALUES(@operacion,@customer_num, @lname, @fname, @company, @addres, @city, @state);

	  END

	  COMMIT TRANSACTION;
	  END TRY

	  BEGIN CATCH
	   ROLLBACK TRANSACTION;
	  END CATCH

	  FETCH NEXT FROM actCur INTO @customer_num, @lname, @fname, @company, @addres, @city, @state

	  END

CLOSE actCur;
DEALLOCATE actCur

END;

/*Crear un procedimiento procBorraOC que reciba un número de orden de compra por parámetro y realice la
eliminación de la misma y sus ítems.
Deberá manejar una transacción y deberá manejar excepciones ante algún error que ocurra.
El procedimiento deberá guardar en una tabla de auditoria auditOC los siguientes datos order_num,
order_date, customer_num, cantidad_items, total_orden (SUM(total_price)), cant_productos_comprados
(SUM(quantity)), cantidad de ítems.
Ante un error deberá almacenar en una tablas erroresOC, order_num, order_date, customer_num,
error_ocurrido VARCHAR(50)*/
GO 
CREATE PROCEDURE borrarOC @numeroOC int
AS
BEGIN
 BEGIN TRY
  BEGIN TRANSACTION

  SET NOCOUNT ON;
  
	INSERT INTO auditOC(order_num, order_date, customer_num, cantidad_items,
						total_orden, cant_productos_comprados)
	VALUES((SELECT o.order_num, order_date, customer_num, COUNT(item_num),
			SUM(unit_price * quantity), SUM(quantity)
			FROM orders o JOIN items i ON i.order_num = o.order_num
			WHERE o.order_num = @numeroOC
			GROUP BY o.order_num, order_date, customer_num));

	DELETE FROM orders
	WHERE order_num = @numeroOC

	DELETE FROM items
	WHERE order_num = @numeroOC

	COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH
	 ROLLBACK TRANSACTION;

	 INSERT INTO erroresOC(order_num, order_date, customer_num, error_ocurrido)
	 VALUES((SELECT order_num, order_date, customer_num, ERROR_MESSAGE()
			 FROM orders WHERE order_num = @numeroOC));
	END CATCH

END;
