/*dada la tabla custoemr y customer_audit'
'ante deletes y updates de los campos lname, fname, state o customer_num_refered de la 
tabla customer, auditar los cambios colocando en los campos NEW los valores nuevos y guardar 
en los campos OLD los valores que tenian antes de su borrado/modificacion'.
'en los campos apeyNom se deben guardar los nombres y apellidos concatenados respectivos
en el campo update_date guardar la fecha y hora ctual y en update_user el usuario que realiza 
el update.
verificar en las modificaiones la validez de las claves foraneas ingresdas y en caso de error 
informarlo y deshacer la operacion'
'nota'; 'asumir que ya existe la tabla de auditoria, las modificaciones pueden ser masivas 
y en caso de error solo se debe deshacer la operacion actual*/
GO 
CREATE TRIGGER auditarCustomer ON customer
AFTER DELETE, UPDATE 
AS 
BEGIN

	DECLARE @customer_num smallint,
			@apeNomOLD varchar(30), @stateOLD char(2), @customerRefOLD smallint,
			@apeNomNEW varchar(30), @stateNEW char(2), @customerRefNEW smallint
			
	DECLARE audCur CURSOR FOR
		SELECT d.customer_num,
			   i.lname + ' ' + i.fname, i.state, i.customer_num_referedBy,
			   d.lname + ' ' + d.fname, d.state, d.customer_num_referedBy
		FROM deleted d LEFT JOIN inserted i 
		ON d.customer_num = i.customer_num
		GROUP BY d.customer_num

	OPEN audCur;

	FETCH NEXT FROM audCur INTO @customer_num, 
								@apeNomNEW, @stateNEW, @stateNEW, @customerRefNEW,
								@apeNomOLD, @stateOLD, @stateOLD, @customerRefOLD

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
	 BEGIN TRY
	  BEGIN TRANSACTION 

	IF NOT EXISTS(SELECT 1 FROM inserted)
	 BEGIN
	 INSERT INTO CUSTOMER_AUDIT(customer_num, update_date, ApeyNom_OLD, State_OLD, customer_num_referedBy_OLD, update_user)
	 VALUES(@customer_num, getDate(), @apeNomOLD, @stateOLD, @customerRefOLD, SYSTEM_USER)
	 END
	
	ELSE
	 BEGIN
	  IF NOT EXISTS(SELECT 1 FROM customer WHERE customer_num = @customer_num)
		THROW 50001, 'Cliente Desconocido',1;
	  IF NOT EXISTS(SELECT 1 FROM state WHERE state = @state)
	    THROW 50002, 'Estado Desconocido', 1;

	INSERT INTO CUSTOMER_AUDIT(customer_num, update_date,
							   ApeyNom_NEW, State_NEW, customer_num_referedBy_NEW,
							   ApeyNom_OLD, State_OLD, customer_num_referedBy_OLD,
							   update_user)
	VALUES(@customer_num, getDate(),
		   @apeNomNEW, @stateNEW, @customerRefNEW,
		   @apeNomOLD, @stateOLD, @customerRefOLD,
		   SYSTEM_USER)
	END

	COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
	 ROLLBACK TRANSACTION;
	END CATCH

	END

END;

/*ante un insert validar la existencia de claves primarias en las tablas relacionadas, fabricante 
unit_code y product_types.
si no existe el fabricante, devolver un mensaje de er ror y deshacer la transaccion para 
ese registro. en caso de no existir en units y product types, insertar el registro correspondiente 
y continuar la operacion*/
GO
CREATE TRIGGER productsT ON products
AFTER INSERT
AS
BEGIN
 
	DECLARE @stock_num int, 
		    @manu_code varchar(40),
            @unit_price float,
		    @unit_code int,
			@unit_descr varchar(40),
		    @description varchar(40)

	DECLARE pCur CURSOR FOR
		SELECT p.stock_num, manu_code, unit_price, p.unit_code, unit_descr, description
		FROM products p JOIN product_types pt ON pt.stock_num = p.stock_num 
		JOIN units u ON u.unit_code = p.unit_code
	    GROUP BY p.stock_num, manu_code

	OPEN pCur;

	FETCH NEXT FROM pCur INTO @stock_num, @manu_code, @unit_price, @unit_code, @unit_descr, @description

	WHILE(@@FETCH_STATUS = 0)
	BEGIN 
	 BEGIN TRY
	  BEGIN TRANSACTION

	IF NOT EXISTS(SELECT 1 FROM manufact WHERE manu_code = @manu_code)
	 THROW 50001, 'Fabricante Desconocido', 1;

	IF NOT EXISTS(SELECT 1 FROM units WHERE unit_code = @unit_code)
	BEGIN
	 INSERT INTO units(unit_code, unit_descr)
	 VALUES(@unit_code, @unit_descr)
	END

	IF NOT EXISTS(SELECT 1 FROM product_types WHERE stock_num = @stock_num)
	BEGIN
	 INSERT INTO product_types(stock_num, description)
	 VALUES(@stock_num, @description)
	END

	COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH
	 ROLLBACK TRANSACTION;
	END CATCH

	FETCH NEXT FROM pCur INTO @stock_num, @manu_code, @unit_price, @unit_code, @unit_descr, @description

	CLOSE pCur;
	DEALLOCATE pCur

	END
END;