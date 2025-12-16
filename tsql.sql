/*1. Hacer una función que dado un artículo y un deposito devuelva un string que indique el estado del depósito según el artículo. Si la cantidad almacenada es menor al límite retornar “OCUPACION DEL DEPOSITO XX %” siendo XX el % 
de ocupación. Si la cantidad almacenada es mayor o igual al límite retornar “DEPOSITO COMPLETO”. */
GO
ALTER FUNCTION dbo.fn_EstadoDeposito (@articulo char(8), @deposito char(2)) --ser muy preciso con los tipos de dato, sobre todo los ()
RETURNS VARCHAR(50) AS
BEGIN
	DECLARE @cantidad DECIMAL(12,2)
	DECLARE @limite DECIMAL(12,2)
	DECLARE @ocupacion DECIMAL(12,2)
	DECLARE @resultado VARCHAR(50)

	SELECT @cantidad = s.stoc_cantidad, @limite = s.stoc_stock_maximo
	FROM STOCK s WHERE s.stoc_deposito = @deposito AND s.stoc_producto = @articulo

	IF @cantidad IS NULL OR @limite IS NULL
	RETURN 'DATOS NO ENCONTRADOS'

	IF @cantidad < @limite
	BEGIN 
		SET @ocupacion = (@cantidad * 100) / @limite
		SET @resultado = 'OCUPACION DEL DEPOSITO ' + CAST(CAST(@Ocupacion AS INT) AS VARCHAR(3)) + '%'
	END
	ELSE
	BEGIN
		SET @resultado = 'DEPOSITO COMPLETO'
	END

	RETURN @resultado

END

SELECT dbo.fn_EstadoDeposito('00000030', '00') --funca

/*2. Realizar una función que dado un artículo y una fecha, retorne el stock que existía a esa fecha*/
CREATE FUNCTION dbo.fn_StockPorFecha (@articulo char(8), @fecha smalldatetime(4))
RETURNS DECIMAL(12,2)
AS 
BEGIN
	DECLARE @stock DECIMAL (12,2)

	SELECT @stock = SUM(i.item_cantidad) 
	FROM Item_Factura i JOIN Factura f ON f.fact_numero = i.item_numero AND
										  f.fact_sucursal = i.item_sucursal AND
										  f.fact_tipo = i.item_tipo
	WHERE @articulo = i.item_producto AND f.fact_fecha <= @fecha

	RETURN @stock
END


SELECT dbo.fn_StockPorFecha('00001415', '2011-12-16') -- funca

/*3. Cree el/los objetos de base de datos necesarios para corregir la tabla empleado
en caso que sea necesario. Se sabe que debería existir un único gerente general
(debería ser el único empleado sin jefe). Si detecta que hay más de un empleado
sin jefe deberá elegir entre ellos el gerente general, el cual será seleccionado por
mayor salario. Si hay más de uno se seleccionara el de mayor antigüedad en la
empresa. Al finalizar la ejecución del objeto la tabla deberá cumplir con la regla
de un único empleado sin jefe (el gerente general) y deberá retornar la cantidad
de empleados que había sin jefe antes de la ejecución.*/
GO
CREATE PROCEDURE corregirGerenteGeneral AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @cantSinJefe INT
	DECLARE @gerente numeric(6,0)

-- me fijo la cantidad de empleados sin jefe
	SELECT @cantSinJefe = COUNT(*)
	FROM Empleado e WHERE e.empl_jefe IS NULL

-- si hay uno solo, todo ok
	IF @cantSinJefe = 1
	BEGIN 
		PRINT('Cantidad de empleados sin jefe antes de la ejecución: ' + CAST(@cantSinJefe AS VARCHAR(10)))
		RETURN
	END

	IF @cantSinJefe = 0
	BEGIN 
		PRINT('Falta cargar un jefe a la base de datos')
		RETURN
	END

	IF @cantSinJefe > 1
	BEGIN 
		SELECT TOP 1 @gerente = e.empl_codigo
		FROM Empleado e 
		ORDER BY e.empl_salario DESC, e.empl_ingreso ASC

		UPDATE Empleado
		SET empl_jefe = @gerente
		WHERE empl_jefe IS NULL AND empl_codigo <> @gerente

		PRINT('Cantidad de empleados sin jefe antes de la ejecución: ' + CAST(@cantSinJefe AS VARCHAR(10)))
		PRINT('Gerente general asignado: ' + CAST(@gerente AS VARCHAR(10)))
	END
END

/*4. Cree el/los objetos de base de datos necesarios para actualizar la columna de
empleado empl_comision con la sumatoria del total de lo vendido por ese
empleado a lo largo del último año. Se deberá retornar el código del vendedor
que más vendió (en monto) a lo largo del último año.*/
GO
ALTER PROCEDURE SP_EJERCICIO_4 (@cod_vendedor numeric(6,0) output)AS
BEGIN TRANSACTION

	DECLARE @vend numeric(6,0)
	DECLARE @suma decimal(12,2)
	DECLARE @sumaMax decimal(12,2)

	DECLARE cur CURSOR FOR
		SELECT f.fact_vendedor, ISNULL(SUM(f.fact_total), 0)
		FROM Factura f LEFT JOIN Empleado e ON e.empl_codigo = f.fact_vendedor
		WHERE YEAR(f.fact_fecha) = 2011 
		GROUP BY f.fact_vendedor

	OPEN cur
	FETCH cur INTO @vend, @suma -- ejecuta el select entonces fact_vendedor --> vend y suma --> SUM

	SET @sumaMax = @suma

	WHILE @@FETCH_STATUS = 0
	BEGIN

	IF @suma > @sumaMax
	BEGIN
		SET @sumaMax = @suma
		SET @cod_vendedor = @vend
	END

		UPDATE Empleado 
		SET empl_comision = @suma
		WHERE empl_codigo = @vend

	END

	CLOSE cur
	DEALLOCATE cur

COMMIT

DECLARE @cod_vend numeric(6,0)

EXEC SP_EJERCICIO_4 @cod_vendedor = @cod_vend output
PRINT @cod_vend
/*5. Realizar un procedimiento que complete con los datos existentes en el modelo
provisto la tabla de hechos denominada Fact_table tiene las siguiente definición:*/CREATE TABLE Fact_table
(
    anio CHAR(4),
    mes CHAR(2),
    familia CHAR(3),
    rubro CHAR(4),
    zona CHAR(3),
    cliente CHAR(6),
    producto CHAR(8),
    cantidad DECIMAL(12,2),
    monto DECIMAL(12,2)
);

ALTER TABLE Fact_table
ADD CONSTRAINT PK_FactTable 
PRIMARY KEY (anio, mes, familia, rubro, zona, cliente, producto);

GO
CREATE PROCEDURE llenarFactTabke AS
BEGIN 
	SET NOCOUNT ON;

	TRUNCATE TABLE Fact_table

	INSERT INTO Fact_table(anio, mes, familia, rubro, zona, cliente, producto, cantidad, monto)
	SELECT YEAR(f.fact_fecha), MONTH(f.fact_fecha), p.prod_familia, p.prod_rubro, d.depo_zona,
	f.fact_cliente, p.prod_codigo, SUM(i.item_cantidad), SUM(i.item_precio * i.item_cantidad)
	FROM Factura f JOIN Item_Factura i ON i.item_tipo = f.fact_tipo AND
										  i.item_sucursal = f.fact_sucursal AND
										  i.item_numero = f.fact_numero
				   JOIN Producto p ON p.prod_codigo = i.item_producto
				   JOIN STOCK s ON s.stoc_producto = p.prod_codigo
				   JOIN DEPOSITO d ON d.depo_codigo = s.stoc_deposito
	GROUP BY YEAR(f.fact_fecha), MONTH(f.fact_fecha), p.prod_familia, p.prod_rubro, d.depo_zona,
	f.fact_cliente, p.prod_codigo

	PRINT('Carga de Fact_table completada correctamente.')
END

/*7. Hacer un procedimiento que dadas dos fechas complete la tabla Ventas. Debe
insertar una línea por cada artículo con los movimientos de stock generados por
las ventas entre esas fechas. La tabla se encuentra creada y vacía.*/
CREATE TABLE Ventas(
codigo char(8),
detalle char(50),
cantMov decimal(12,2),
precioProm decimal(12,2),
renglon int,
ganancia decimal(12,2)
)

GO 
CREATE PROCEDURE CompletarVentas 
	@fecha_inicio smalldatetime,
	@fecha_fin smalldatetime AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO Ventas(codigo, detalle, cantMov, precioProm, renglon, ganancia)
	SELECT p.prod_codigo, p.prod_detalle, SUM(i.item_cantidad), AVG(i.item_precio), 
	ROW_NUMBER() OVER (ORDER BY p.prod_codigo), SUM(i.item_cantidad * i.item_precio)
	FROM Producto p JOIN Item_Factura i ON p.prod_codigo = i.item_producto
					JOIN Factura f ON f.fact_tipo = i.item_tipo	AND
									  f.fact_sucursal = i.item_sucursal AND
									  f.fact_numero = i.item_numero
	WHERE f.fact_fecha BETWEEN @fecha_inicio AND @fecha_fin
	GROUP BY p.prod_codigo, p.prod_detalle
END

EXEC CompletarVentas '2010-01-23 00:00:00', '2011-08-16 00:00:00'

SELECT * FROM Ventas -- funca

/*9. Crear el/los objetos de base de datos que ante alguna modificación de un ítem de
factura de un artículo con composición realice el movimiento de sus
correspondientes componentes.*/GOCREATE TRIGGER EJ_9 ON Item_FacturaAFTER UPDATE ASBEGIN TRANSACTION	DECLARE @id_componente char(8)	DECLARE @diferencia decimal(12,2)	DECLARE @cantidad_componente decimal(12,2)	DECLARE cur CURSOR FOR	SELECT c.comp_componente, d.item_cantidad - i.item_cantidad, c.comp_cantidad	FROM Composicion c JOIN inserted i ON i.item_producto = c.comp_producto					   JOIN deleted d ON d.item_numero = i.item_numero AND										 d.item_producto = i.item_producto AND										 d.item_sucursal = i.item_sucursal	OPEN cur	FETCH NEXT FROM cur INTO @id_componente, @diferencia, @cantidad_componente	WHILE @@FETCH_STATUS = 0	BEGIN		UPDATE STOCK		SET stoc_cantidad = stoc_cantidad + (@cantidad_componente * @diferencia)		WHERE stoc_producto = @id_componente AND stoc_deposito = '00'	FETCH NEXT FROM cur INTO @id_componente, @diferencia, @cantidad_componente	END	CLOSE cur	DEALLOCATE curCOMMIT/*10. Crear el/los objetos de base de datos que ante el intento de borrar un artículo
verifique que no exista stock y si es así lo borre en caso contrario que emita un
mensaje de error.*/

GO 
ALTER TRIGGER DeleteProd ON Producto
INSTEAD OF DELETE AS --no lo borra
BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION
		BEGIN TRY

	IF EXISTS(SELECT 1 FROM deleted d JOIN STOCK s ON s.stoc_producto = d.prod_codigo WHERE s.stoc_cantidad > 0)
	BEGIN
		THROW 50001, 'No se puede eliminar el artículo: aún existe stock.', 1;
        RETURN;
	END

	DELETE FROM Producto
	WHERE prod_codigo IN (SELECT prod_codigo FROM deleted);

	COMMIT TRANSACTION

		END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
END

SELECT * FROM STOCK 

INSERT INTO Producto(prod_codigo, prod_detalle, prod_precio, prod_familia, prod_rubro, prod_envase)
VALUES('00000001', NULL, 290.90, NULL, NULL, NULL) 

INSERT INTO STOCK(stoc_cantidad, stoc_punto_reposicion, stoc_stock_maximo, stoc_detalle, stoc_proxima_reposicion, stoc_producto, stoc_deposito)
VALUES(1, NULL, NULL, NULL, NULL, '00000001', '00')

INSERT INTO Producto(prod_codigo, prod_detalle, prod_precio, prod_familia, prod_rubro, prod_envase)
VALUES('00000002', NULL, 290.90, NULL, NULL, NULL) 

INSERT INTO STOCK(stoc_cantidad, stoc_punto_reposicion, stoc_stock_maximo, stoc_detalle, stoc_proxima_reposicion, stoc_producto, stoc_deposito)
VALUES(0, NULL, NULL, NULL, NULL, '00000002', '00')

INSERT INTO Producto(prod_codigo, prod_detalle, prod_precio, prod_familia, prod_rubro, prod_envase)
VALUES('00000003', NULL, 290.90, NULL, NULL, NULL) 

DELETE FROM Producto WHERE prod_codigo = '00000001' -- no me deja pq el producto tiene stock
DELETE FROM Producto WHERE prod_codigo = '00000002'
DELETE FROM Producto WHERE prod_codigo = '00000003' -- me deja pq no este ese prod en STOCK

/*11. Cree el/los objetos de base de datos necesarios para que dado un código de
empleado se retorne la cantidad de empleados que este tiene a su cargo (directa o
indirectamente). Solo contar aquellos empleados (directos o indirectos) que
tengan un código mayor que su jefe directo.*/
GO
CREATE PROCEDURE CantidadEmpleados @codigo numeric(6,0) AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @empleados int

	;WITH Empleados AS(
		SELECT e.empl_codigo
		FROM Empleado e
		WHERE e.empl_jefe = @codigo AND e.empl_codigo > @codigo

		UNION ALL

		SELECT e.empl_codigo
		FROM Empleado e JOIN Empleados es ON e.empl_jefe = es.empl_codigo
		WHERE e.empl_codigo > e.empl_jefe
	)
	SELECT @empleados = COUNT(*) FROM Empleados 

	PRINT('Cantidad de empleados a cargo: '+ CAST(@empleados AS VARCHAR(10)))
END

SELECT * FROM Empleado

EXEC CantidadEmpleados 4 -- funca

/*12. Cree el/los objetos de base de datos necesarios para que nunca un producto
pueda ser compuesto por sí mismo. Se sabe que en la actualidad dicha regla se
cumple y que la base de datos es accedida por n aplicaciones de diferentes tipos
y tecnologías. No se conoce la cantidad de niveles de composición existentes.*/
GO 
ALTER TRIGGER ProductoCompuesto ON Composicion
INSTEAD OF INSERT AS
BEGIN

	BEGIN TRY
	BEGIN TRANSACTION

	SET NOCOUNT ON;

	IF EXISTS(SELECT 1 FROM inserted i JOIN Composicion c ON c.comp_producto = i.comp_producto
			  AND i.comp_componente = c.comp_componente)
	BEGIN
		RAISERROR('Ese componente ya pertenece a esa composicion', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	IF EXISTS(SELECT 1 FROM inserted i WHERE i.comp_componente = i.comp_producto)
	BEGIN
		RAISERROR('Un productono puede ser compuesto por si mismo', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	INSERT INTO Composicion(comp_cantidad, comp_componente, comp_producto)
	SELECT i.comp_cantidad, i.comp_componente, i.comp_producto
	FROM inserted i

	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
END

INSERT INTO Composicion
VALUES(1, '00001104', '00001104') --funca

/*13. Cree el/los objetos de base de datos necesarios para implantar la siguiente regla
“Ningún jefe puede tener un salario mayor al 20% de las suma de los salarios de
sus empleados totales (directos + indirectos)”. Se sabe que en la actualidad dicha
regla se cumple y que la base de datos es accedida por n aplicaciones de
diferentes tipos y tecnologías*/GOCREATE TRIGGER SalarioJefe ON EmpleadoINSTEAD OF INSERT, UPDATE ASBEGIN 	SET NOCOUNT ON;	BEGIN TRY	BEGIN TRANSACTION	WITH Empleados AS(
		SELECT e.empl_codigo, e.empl_salario
		FROM Empleado e JOIN inserted i ON i.empl_codigo = e.empl_jefe
		WHERE e.empl_codigo > i.empl_codigo

		UNION ALL

		SELECT e.empl_codigo, e.empl_salario
		FROM Empleado e JOIN Empleados es ON e.empl_jefe = es.empl_codigo
		WHERE e.empl_codigo > e.empl_jefe
	)

	IF EXISTS(SELECT 1 FROM inserted i JOIN Empleados e ON e.empl_jefe = i.empl_codigo
			  WHERE SUM(e.empl_salario) < 0.2 * i.empl_salario)
	BEGIN
		RAISERROR('No se cumple la regla de salarios', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END

	IF (NOT EXISTS (SELECT * FROM deleted))
        BEGIN
            -- Es un INSERT
            INSERT INTO Empleado (empl_codigo, empl_nombre, empl_jefe, empl_salario)
            SELECT empl_codigo, empl_nombre, empl_jefe, empl_salario
            FROM inserted;
        END
        ELSE
        BEGIN
            -- Es un UPDATE
            UPDATE e
            SET 
                e.empl_nombre = i.empl_nombre,
                e.empl_jefe = i.empl_jefe,
                e.empl_salario = i.empl_salario
            FROM Empleado e
            JOIN inserted i ON e.empl_codigo = i.empl_codigo;
        END;

		COMMIT TRANSACTION
		END TRY

	BEGIN CATCH 
		ROLLBACK TRANSACTION
		RETURN
	END CATCH
END

/*14. Agregar el/los objetos necesarios para que si un cliente compra un producto
compuesto a un precio menor que la suma de los precios de sus componentes
que imprima la fecha, que cliente, que productos y a qué precio se realizó la
compra. No se deberá permitir que dicho precio sea menor a la mitad de la suma
de los componentes.*/GOCREATE TRIGGER ComponenteFact ON FacturaINSTEAD OF INSERT ASBEGIN	SET NOCOUNT ON;	BEGIN TRY	BEGIN TRANSACTION	IF EXISTS(SELECT 1 FROM inserted i JOIN Item_Factura it ON it.item_tipo = i.fact_tipo AND															   it.item_numero = i.fact_numero AND															   it.item_sucursal = i.fact_sucursal									   JOIN Composicion c ON c.comp_producto = it.item_producto			  WHERE it.item_precio > )/*15. Cree el/los objetos de base de datos necesarios para que el objeto principal
reciba un producto como parametro y retorne el precio del mismo.
Se debe prever que el precio de los productos compuestos sera la sumatoria de
los componentes del mismo multiplicado por sus respectivas cantidades. No se
conocen los nivles de anidamiento posibles de los productos. Se asegura que
nunca un producto esta compuesto por si mismo a ningun nivel. El objeto
principal debe poder ser utilizado como filtro en el where de una sentencia
select.*/
GO
ALTER FUNCTION dbo.fn_DevolverPrecioFunc(@producto char(8))
RETURNS decimal(12,2)
AS
BEGIN
	DECLARE @precio decimal(12,2)

	IF NOT EXISTS(SELECT 1 FROM Composicion c WHERE c.comp_producto = @producto)
	BEGIN
		SELECT @precio = i.item_precio
		FROM Item_Factura i 
		WHERE i.item_numero = @producto
	END
	ELSE
	BEGIN
		SELECT @precio = SUM(c.comp_cantidad * dbo.DevolverPrecio(@producto))
		FROM Composicion c
		WHERE c.comp_producto = @producto
	END

	RETURN @precio

END

/*16. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se descuenten del stock los articulos vendidos. Se descontaran
del deposito que mas producto poseea y se supone que el stock se almacena
tanto de productos simples como compuestos (si se acaba el stock de los
compuestos no se arman combos)
En caso que no alcance el stock de un deposito se descontara del siguiente y asi
hasta agotar los depositos posibles. En ultima instancia se dejara stock negativo
en el ultimo deposito que se desconto.*/
GO
CREATE TRIGGER DescontarVenta ON Factura
AFTER INSERT AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @numero char(8), @sucursal char(4), @tipo char(1)

	SELECT @numero = f.fact_numero,
		   @sucursal = f.fact_sucursal,
		   @tipo = f.fact_tipo
	FROM inserted f

	DECLARE cur CURSOR FOR
		SELECT i.item_producto, i.item_cantidad
		FROM Item_Factura i
		WHERE i.item_numero = @numero AND
			  i.item_sucursal = @sucursal AND
			  i.item_tipo = @tipo

	DECLARE @producto char(8), @cantidad decimal(12,2)

	OPEN cur
	FETCH NEXT FROM cur INTO @producto, @cantidad

	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @descuento decimal(12,2) = @cantidad
		DECLARE @deposito char(2), @stock_cantidad decimal(12,2)

		DECLARE curDep CURSOR FOR
			SELECT d.depo_codigo, s.stoc_cantidad
			FROM DEPOSITO d JOIN STOCK s ON s.stoc_deposito = d.depo_codigo
			WHERE s.stoc_producto = @producto
			ORDER BY s.stoc_cantidad DESC

	OPEN curDep
	FETCH NEXT FROM curDep INTO @deposito, @stock_cantidad

	WHILE @@FETCH_STATUS = 0 AND @descuento > 0 
	BEGIN
		DECLARE @a_restar decimal(12,2) = CASE WHEN @stock_cantidad >= @descuento
										  THEN @descuento ELSE @stock_cantidad END

	UPDATE STOCK 
	set stoc_cantidad = stoc_cantidad - @a_restar
	WHERE stoc_producto = @producto AND stoc_deposito = @deposito

	SET @descuento = @descuento - @a_restar

	FETCH NEXT FROM curDep INTO @deposito, @stock_cantidad
	END

	CLOSE curDep
	DEALLOCATE curDep

	IF @descuento > 0 
	BEGIN
		UPDATE TOP(1) STOCK
		SET stoc_cantidad = stoc_cantidad - @descuento
		WHERE stoc_producto = @producto
		ORDER BY stoc_cantidad ASC
	END

	FETCH NEXT FROM cur INTO @producto, @stock_cantidad
	END

	CLOSE cur
	DEALLOCATE cur
END

/*EJ PARCIAL: 2. Se agregó recientemente un campo CUIT a la tabla de clientes. Debido a un
error, se generaron múltiples registros de clientes con el mismo CUIT.
Se deberá desarrollar un algoritmo de depuración de datos que identifique y corrija
estos duplicados, manteniendo un único registro por CUIT. Será necesario definir un
criterio de selección para determinar qué registro conservar y cuáles eliminar.
Adicionalmente, se deberá implementar una restricción que impida la creación futura
de registros con CUIT duplicado.*/
alter table cliente add clie_cuit char(10)

create table cliente_auxiliar( cod char(6), cuit char(10) )
 
begin transaction 
 insert into cliente_auxiliar
 select min(clie_codigo), clie_cuit
 from cliente 
 group by clie_cuit

 update cliente set clie_cuit = null 
 update cliente set clie_cuit = (Select cuit from cliente_auxiliar where cod = clie_codigo )

commit

/* OTRO: 2. Implementar una regla de negocio en línea que registre los productos
que al momento de venderse registraron un aumento superior al 10 %
del precio de venta que tuvieron en el mes anterior. Se deberá registrar
el producto, la fecha en el cual se hace la venta, el precio anterior y el
precio nuevo.*/
CREATE TABLE item_aux(item_producto char(8), item_fecha smalldatetime, 
item_precio_viejo decimal(12,2), item_precio_nuevo decimal(12,2))

GO
CREATE TRIGGER TG ON Item_Factura 
AFTER INSERT AS
BEGIN TRANSACTION

	INSERT INTO item_aux(item_producto, item_fecha, item_precio_viejo, item_precio_nuevo)
	SELECT t1.item_producto, t1.fact_fecha, t2.item_precio, t1.item_precio FROM
	( SELECT i.item_producto, i.item_precio, f.fact_fecha
	  FROM inserted i JOIN Factura f ON f.fact_numero = i.item_numero AND
										f.fact_tipo = i.item_tipo AND
										f.fact_sucursal = i.item_sucursal
    ) t1 JOIN (
			SELECT i.item_producto, i.item_precio, f.fact_fecha
			FROM Item_Factura i JOIN Factura f ON f.fact_numero = i.item_numero AND
										          f.fact_tipo = i.item_tipo AND
												  f.fact_sucursal = i.item_sucursal
	) t2 ON t1.item_producto = t2.item_producto
	WHERE t1.item_precio >= 1.1 * t2.item_precio AND MONTH(t1.fact_fecha) = MONTH(t2.fact_fecha) + 1 AND
	YEAR(t1.fact_fecha) = YEAR(t2.fact_fecha)

COMMIT TRANSACTION

-- abs(datediff(month, t1.fact_fecha, t2.fact_fecha)) = 1

/*17. Sabiendo que el punto de reposicion del stock es la menor cantidad de ese objeto
que se debe almacenar en el deposito y que el stock maximo es la maxima
cantidad de ese producto en ese deposito, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio se cumpla automaticamente. No se
conoce la forma de acceso a los datos ni el procedimiento por el cual se
incrementa o descuenta stock*/
sp_help STOCK
SELECT * FROM DEPOSITO
SELECT * FROM STOCK

-- lo repuesto tiene q ser mayor al stoc_punto_reposicion
-- lo repuesto no debe pasarse del stoc_stock_maximo

GO 
ALTER TRIGGER EJ_17 ON STOCK
INSTEAD OF UPDATE AS
BEGIN 

	BEGIN TRANSACTION
	
	IF EXISTS(SELECT 1 FROM inserted i JOIN STOCK s ON s.stoc_producto = i.stoc_producto AND
													   s.stoc_deposito = i.stoc_deposito
			  WHERE i.stoc_cantidad > s.stoc_stock_maximo OR
					i.stoc_cantidad < s.stoc_punto_reposicion)
	BEGIN
		PRINT('No se cumplen las reglas de negocio')
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
	UPDATE STOCK
	SET	stoc_cantidad = i.stoc_cantidad
	FROM STOCK s JOIN inserted i ON s.stoc_deposito = i.stoc_deposito AND
									s.stoc_producto = i.stoc_producto
	COMMIT TRANSACTION
	END
END	

UPDATE STOCK
SET stoc_cantidad = 4
WHERE stoc_producto = '00000030' AND stoc_deposito = '00'

/*18. Sabiendo que el limite de credito de un cliente es el monto maximo que se le
puede facturar mensualmente, cree el/los objetos de base de datos necesarios
para que dicha regla de negocio se cumpla automaticamente. No se conoce la
forma de acceso a los datos ni el procedimiento por el cual se emiten las facturas*/
SELECT * FROM Cliente
SELECT * FROM Factura
GO
CREATE TRIGGER EJ_18 ON Factura
INSTEAD OF INSERT AS
BEGIN
	BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM inserted i JOIN Cliente c ON i.fact_cliente = c.clie_codigo
									   
			  WHERE i.fact_total + (SELECT ISNULL(SUM(f.fact_total), 0) FROM Factura f
									WHERE f.fact_cliente = c.clie_codigo) > c.clie_limite_credito)
	BEGIN
		PRINT('El cliente supero su limite de credito')
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN
		INSERT INTO Factura(fact_tipo, fact_sucursal, fact_numero, fact_fecha, 
		fact_vendedor, fact_total, fact_total_impuestos, fact_cliente)
		SELECT i.fact_tipo, i.fact_sucursal, i.fact_numero, i.fact_fecha,
		i.fact_vendedor, i.fact_total, i.fact_total_impuestos, i.fact_cliente
		FROM inserted i
	
	COMMIT TRANSACTION
	END
END

/*19. Cree el/los objetos de base de datos necesarios para que se cumpla la siguiente
regla de negocio automáticamente “Ningún jefe puede tener menos de 5 años de
antigüedad y tampoco puede tener más del 50% del personal a su cargo
(contando directos e indirectos) a excepción del gerente general”. Se sabe que en
la actualidad la regla se cumple y existe un único gerente general.*/
GO
CREATE TRIGGER INS_19 ON Empleado
INSTEAD OF INSERT, UPDATE AS
BEGIN
	BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM inserted i JOIN Empleado e ON e.empl_jefe = i.empl_codigo 
			  WHERE abs(datediff(year, i.empl_ingreso, GETDATE())) < 5 AND
			  i.empl_jefe IS NOT NULL) -- el gerente general queda exceptuado
	BEGIN
		PRINT('Este empleado no puede ser jefe porque no tiene 5 años de antiguedad')
		ROLLBACK TRANSACTION
	END

	IF EXISTS(SELECT 1 FROM inserted i JOIN Empleado e ON e.empl_jefe = i.empl_codigo
			  WHERE i.empl_jefe	IS NOT NULL AND 
			  ((SELECT COUNT(*) FROM Empleado e1 WHERE e1.empl_jefe = e.empl_codigo) > 
			   (SELECT COUNT(*) FROM Empleado e2) * 0.5))
	BEGIN
		PRINT('Este empleado no puede ser jefe porque tiene al 50% de los empleados a cargo')
		ROLLBACK TRANSACTION
	END
	
	IF EXISTS(SELECT 1 FROM deleted) -- es un update
	BEGIN
		UPDATE e1
		SET e1.empl_jefe = i.empl_jefe
		FROM Empleado e1 JOIN inserted i ON i.empl_codigo = e1.empl_codigo
	END
	ELSE
	BEGIN	
		INSERT INTO Empleado(empl_apellido, empl_codigo, empl_comision, empl_departamento,
		empl_ingreso, empl_jefe, empl_nacimiento, empl_nombre, empl_salario, empl_tareas)
		SELECT i.empl_apellido, i.empl_codigo, i.empl_comision, i.empl_departamento,
		i.empl_ingreso, i.empl_jefe, i.empl_nacimiento, i.empl_nombre, i.empl_salario, i.empl_tareas
		FROM inserted i
	END

	COMMIT TRANSACTION
END

/*20. Crear el/los objeto/s necesarios para mantener actualizadas las comisiones del
vendedor.
El cálculo de la comisión está dado por el 5% de la venta total efectuada por ese
vendedor en ese mes, más un 3% adicional en caso de que ese vendedor haya
vendido por lo menos 50 productos distintos en el mes.*/GOCREATE PROCEDURE EJ_20 ASBEGIN	BEGIN TRANSACTION	DECLARE @vendedor numeric(6,0)	DECLARE @total decimal(12,2)	DECLARE @productos int	DECLARE cur CURSOR FOR	SELECT f.fact_vendedor, SUM(f.fact_total), COUNT(DISTINCT i.item_producto)	FROM Factura f JOIN Item_Factura i ON i.item_numero = f.fact_numero AND										  i.item_sucursal = f.fact_sucursal AND										  i.item_tipo = f.fact_tipo	GROUP BY f.fact_vendedor	OPEN cur
	FETCH NEXT FROM cur INTO @vendedor, @total, @productos

	WHILE @@FETCH_STATUS = 0
	BEGIN	
		IF @productos > 50
			UPDATE Empleado
			SET empl_comision = @total * 0.08
			WHERE empl_codigo = @vendedor
		ELSE
			UPDATE Empleado
			SET empl_comision = @total * 0.05
			WHERE empl_codigo = @vendedor

	FETCH NEXT FROM cur INTO @vendedor, @total, @productos
	END

	CLOSE cur
	DEALLOCATE cur

	COMMIT TRANSACTION
END

/*21. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que en una factura no puede contener productos de
diferentes familias. En caso de que esto ocurra no debe grabarse esa factura y
debe emitirse un error en pantalla.*/GOCREATE TRIGGER EJ_21 ON FacturaINSTEAD OF INSERT ASBEGIN	BEGIN TRANSACTION	IF EXISTS(SELECT 1 FROM inserted i JOIN Item_Factura it ON i.fact_tipo = it.item_tipo AND															   i.fact_sucursal = it.item_sucursal AND															   i.fact_numero = it.item_numero									   JOIN Producto p ON p.prod_codigo = it.item_producto			WHERE p.prod_familia <> (
				SELECT TOP 1 p2.prod_familia
				FROM Item_Factura it2
				JOIN Producto p2 ON p2.prod_codigo = it2.item_producto
				WHERE it2.item_tipo = it.item_tipo AND it2.item_sucursal = it.item_sucursal AND it2.item_numero = it.item_numero
				))	BEGIN		PRINT('La factura contiene productos de distintas familias')		ROLLBACK TRANSACTION	END	INSERT INTO Factura(fact_cliente, fact_fecha, fact_numero, fact_sucursal, 	fact_tipo, fact_total, fact_total_impuestos, fact_vendedor)	SELECT i.fact_cliente, i.fact_fecha, i.fact_numero, i.fact_sucursal,	i.fact_tipo, i.fact_total, i.fact_total_impuestos, i.fact_vendedor	FROM inserted i	COMMIT TRANSACTIONEND/*22. Se requiere recategorizar los rubros de productos, de forma tal que nigun rubro
tenga más de 20 productos asignados, si un rubro tiene más de 20 productos
asignados se deberan distribuir en otros rubros que no tengan mas de 20
productos y si no entran se debra crear un nuevo rubro en la misma familia con
la descirpción “RUBRO REASIGNADO”, cree el/los objetos de base de datos
necesarios para que dicha regla de negocio quede implementada.*/
CREATE TABLE ProdsReasignados(producto char(8))

GO
CREATE PROCEDURE EJ_22 AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @rubro char(4)
	DECLARE @productos int 
	DECLARE @familia char(3)
	DECLARE @nuevoRubro char(4)

	DECLARE cur CURSOR FOR
	SELECT r.rubr_id, p.prod_familia, COUNT(p.prod_codigo)
	FROM Rubro r JOIN Producto p ON p.prod_rubro = r.rubr_id
	GROUP BY r.rubr_id, p.prod_familia

	OPEN cur
	FETCH NEXT FROM cur INTO @rubro, @familia, @productos

	WHILE @@FETCH_STATUS = 0
	BEGIN	
		IF @productos > 20
		BEGIN
			DECLARE @rubroDestino char(4)

			DECLARE cur2 CURSOR FOR
			SELECT r2.rubr_id
			FROM Rubro r2 LEFT JOIN Producto p2 ON p2.prod_rubro = r2.rubr_id
			WHERE p2.prod_familia = @familia
			GROUP BY r2.rubr_id
			HAVING COUNT(p2.prod_codigo) > 20

			OPEN cur2
			FETCH NEXT FROM cur2 INTO @rubroDestino

			DECLARE @excedente TABLE(prod_codigo char(8))
			INSERT INTO @excedente
			SELECT prod_codigo
			FROM Producto
			WHERE prod_rubro = @rubro
			ORDER BY prod_codigo OFFSET 20 ROWS

			WHILE @@FETCH_STATUS = 0 AND EXISTS(SELECT 1 FROM @excedente)
			BEGIN
				DECLARE @espaciosDisponibles INT
				SELECT @espaciosDisponibles = 20 - COUNT(*)
				FROM Producto
				WHERE prod_rubro = @rubroDestino

				IF @espaciosDisponibles > 0
				BEGIN
					UPDATE TOP (@espaciosDisponibles) Producto
					SET prod_rubro = @rubroDestino
					WHERE prod_codigo IN (SELECT TOP (@espaciosDisponibles) prod_codigo FROM @excedente)

					DELETE TOP (@espaciosDisponibles) FROM @excedente
				END

				FETCH NEXT FROM cur2 INTO @rubroDestino
			END

			CLOSE cur2
			DEALLOCATE cur2

			IF EXISTS(SELECT 1 FROM @excedente)
			BEGIN
				SELECT @nuevoRubro = RIGHT('000' + CAST(ISNULL(MAX(rubr_id), 0) + 1 AS VARCHAR(4)), 4)
				FROM Rubro

				INSERT INTO Rubro(rubr_id, rubr_detalle)
				VALUES(@nuevoRubro, 'RUBRO REASIGNADO')

				UPDATE Producto
				SET prod_rubro = @nuevoRubro
				WHERE prod_codigo IN (SELECT prod_codigo FROM @excedente)
			END
		END

		FETCH NEXT FROM cur INTO @rubro, @familia, @productos
	END

	CLOSE cur
	DEALLOCATE cur

	COMMIT TRANSACTION
END

/*23. Desarrolle el/los elementos de base de datos necesarios para que ante una venta
automaticamante se controle que en una misma factura no puedan venderse más
de dos productos con composición. Si esto ocurre debera rechazarse la factura.*/GOCREATE TRIGGER EJ_23 ON FacturaINSTEAD OF INSERT ASBEGIN	BEGIN TRANSACTION	IF EXISTS(SELECT 1 FROM inserted i JOIN Item_Factura it ON it.item_numero = i.fact_numero AND															   it.item_tipo = i.fact_tipo AND															   it.item_sucursal = i.fact_sucursal									   JOIN Composicion c ON c.comp_producto = it.item_producto			  GROUP BY i.fact_numero, i.fact_sucursal, i.fact_tipo			  HAVING COUNT(DISTINCT it.item_producto) > 2)	BEGIN		PRINT('No se pueden vender mas de dos productos con composicion')		ROLLBACK TRANSACTION	END	INSERT INTO Factura(fact_cliente, fact_fecha, fact_numero, fact_sucursal, 	fact_tipo, fact_total, fact_total_impuestos, fact_vendedor)	SELECT i.fact_cliente, i.fact_fecha, i.fact_numero, i.fact_sucursal,	i.fact_tipo, i.fact_total, i.fact_total_impuestos, i.fact_vendedor	FROM inserted i	COMMIT TRANSACTIONEND/*24. Se requiere recategorizar los encargados asignados a los depositos. Para ello
cree el o los objetos de bases de datos necesarios que lo resueva, teniendo en
cuenta que un deposito no puede tener como encargado un empleado que
pertenezca a un departamento que no sea de la misma zona que el deposito, si
esto ocurre a dicho deposito debera asignársele el empleado con menos
depositos asignados que pertenezca a un departamento de esa zona.*/
GO
CREATE PROCEDURE EJ_24 AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @deposito char(2)
	DECLARE @encargado numeric(6,0)
	DECLARE @zona char(3)
	DECLARE @nuevoEncargado numeric(6,0)

	DECLARE cur CURSOR FOR
	SELECT d.depo_codigo, d.depo_encargado, d.depo_zona
	FROM DEPOSITO d 

	FETCH NEXT FROM cur INTO @deposito, @encargado, @zona

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(SELECT d.depo_codigo, d.depo_encargado, d.depo_zona
				  FROM DEPOSITO d JOIN Empleado e ON e.empl_codigo = d.depo_encargado
								  JOIN Departamento de ON de.depa_codigo = e.empl_departamento
				  WHERE d.depo_codigo = @deposito AND de.depa_zona <> @zona)
		BEGIN 
			SELECT TOP 1 @nuevoEncargado = d.depo_encargado
			FROM DEPOSITO d JOIN Empleado e ON e.empl_codigo = d.depo_encargado
							JOIN Departamento de ON de.depa_zona = @zona
			GROUP BY d.depo_encargado
			ORDER BY COUNT(d.depo_encargado) ASC

			UPDATE DEPOSITO
			SET depo_encargado = @nuevoEncargado
			WHERE depo_codigo = @deposito AND depo_encargado = @encargado AND depo_zona = @zona
		END

		FETCH NEXT FROM cur INTO @deposito, @encargado, @zona
	END
	
	CLOSE cur
	DEALLOCATE cur

	COMMIT TRANSACTION
END

/*25. Desarrolle el/los elementos de base de datos necesarios para que no se permita
que la composición de los productos sea recursiva, o sea, que si el producto A
compone al producto B, dicho producto B no pueda ser compuesto por el
producto A, hoy la regla se cumple.*/

-- A es componente del producto B
-- B es componente del producto A

/*
insert me viene:
PROD A COMP B CANT

Comp:
PROD B COMP A CANT --> esto no puede ocurrir
*/
GO
CREATE TRIGGER EJ_25 ON Composicion
INSTEAD OF INSERT AS
BEGIN
	BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM inserted i JOIN Composicion c ON c.comp_producto = i.comp_componente AND
															 c.comp_componente = i.comp_producto)
	BEGIN
		PRINT('La composicion de los productos es recursiva')
		ROLLBACK TRANSACTION
		
	END
	ELSE
	BEGIN
		INSERT INTO Composicion(comp_cantidad, comp_componente, comp_producto)
		SELECT i.comp_cantidad, i.comp_componente, i.comp_producto
		FROM inserted i

	COMMIT TRANSACTION
	END
END

/*26. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de otros productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.*/
GO
CREATE TRIGGER EJ_26 ON Factura
INSTEAD OF INSERT AS
BEGIN
	BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM inserted i JOIN Item_Factura it ON i.fact_sucursal = it.item_sucursal AND
															   i.fact_numero = it.item_numero AND
															   i.fact_tipo = it.item_tipo
									   JOIN Composicion c ON c.comp_componente = it.item_producto)
	BEGIN
		PRINT('La factura no puede contener productos que sean componentes de otros productos')
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		INSERT INTO Factura(fact_cliente, fact_fecha, fact_numero, fact_sucursal, 		fact_tipo, fact_total, fact_total_impuestos, fact_vendedor)		SELECT i.fact_cliente, i.fact_fecha, i.fact_numero, i.fact_sucursal,		i.fact_tipo, i.fact_total, i.fact_total_impuestos, i.fact_vendedor		FROM inserted i	COMMIT TRANSACTION	ENDEND/*27. Se requiere reasignar los encargados de stock de los diferentes depósitos. Para
ello se solicita que realice el o los objetos de base de datos necesarios para
asignar a cada uno de los depósitos el encargado que le corresponda,
entendiendo que el encargado que le corresponde es cualquier empleado que no
es jefe y que no es vendedor, o sea, que no está asignado a ningun cliente, se
deberán ir asignando tratando de que un empleado solo tenga un deposito
asignado, en caso de no poder se irán aumentando la cantidad de depósitos
progresivamente para cada empleado.*/
GO
CREATE PROCEDURE EJ_27 AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @deposito char(2)
	DECLARE @empleado numeric(6,0)
	DECLARE @nuevoEmpleado numeric(6,0)

	DECLARE cur CURSOR FOR
	SELECT d.depo_codigo FROM DEPOSITO d ORDER BY d.depo_codigo

	OPEN cur
	FETCH NEXT FROM cur INTO @deposito, @empleado

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(SELECT 1 FROM DEPOSITO d JOIN Empleado e ON e.empl_codigo = d.depo_encargado
										   JOIN Factura f ON f.fact_vendedor = e.empl_codigo
				  WHERE d.depo_codigo = @deposito AND d.depo_encargado = @empleado)
		BEGIN
			SET @nuevoEmpleado = dbo.fn_EmpleadoDisponible()

			UPDATE DEPOSITO
			SET depo_encargado = @nuevoEmpleado
			WHERE depo_codigo = @deposito
		END

		FETCH NEXT FROM cur INTO @deposito, @empleado
	END

	COMMIT TRANSACTION

	CLOSE cur
	DEALLOCATE cur
END

/*28. Se requiere reasignar los vendedores a los clientes. Para ello se solicita que
realice el o los objetos de base de datos necesarios para asignar a cada uno de los
clientes el vendedor que le corresponda, entendiendo que el vendedor que le
corresponde es aquel que le vendió más facturas a ese cliente, si en particular un
cliente no tiene facturas compradas se le deberá asignar el vendedor con más
venta de la empresa, o sea, el que en monto haya vendido más.*/
GO
CREATE PROCEDURE EJ_28 AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @cliente char(6)
	DECLARE @vendedor numeric(6,0)
	
	DECLARE cur CURSOR FOR
	SELECT c.clie_codigo FROM Cliente c

	OPEN cur
	FETCH NEXT FROM cur INTO @cliente

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @vendedor = dbo.fn_VendedorMasFrecuente(@cliente)

		UPDATE Cliente
		SET clie_vendedor = @vendedor
		WHERE clie_codigo = @cliente

	FETCH NEXT FROM cur INTO @cliente

	END

	COMMIT TRANSACTION

	CLOSE cur
	DEALLOCATE cur
END

-- O
GO
CREATE PROCEDURE EJ_28_SIN_CURSOR AS
BEGIN
    BEGIN TRANSACTION;

    UPDATE c
    SET c.clie_vendedor = v.vend_codigo
    FROM Cliente c
    INNER JOIN (
        SELECT 
            f.clie_codigo,
            v.vend_codigo
        FROM Factura f
        INNER JOIN Vendedor v ON f.fact_vendedor = v.vend_codigo
        WHERE f.fact_vendedor IS NOT NULL
        GROUP BY f.clie_codigo, v.vend_codigo
        HAVING COUNT(*) = (
            SELECT MAX(COUNT(*))
            FROM Factura f2
            WHERE f2.clie_codigo = f.clie_codigo
            GROUP BY f2.fact_vendedor
        )
    ) v ON c.clie_codigo = v.clie_codigo;

    COMMIT TRANSACTION;
END;
GO

/*29. Desarrolle el/los elementos de base de datos necesarios para que se cumpla
automaticamente la regla de que una factura no puede contener productos que
sean componentes de diferentes productos. En caso de que esto ocurra no debe
grabarse esa factura y debe emitirse un error en pantalla.*/
GO 
CREATE TRIGGER EJ_29 ON Factura
INSTEAD OF INSERT AS
BEGIN
	BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM inserted i JOIN Item_Factura it ON it.item_numero = i.fact_numero AND
															   it.item_sucursal = i.fact_sucursal AND
															   it.item_tipo = i.fact_tipo
									   JOIN Composicion c1 ON c1.comp_componente = it.item_producto
									   JOIN Item_Factura it2 ON it2.item_numero = i.fact_numero AND
															   it2.item_sucursal = i.fact_sucursal AND
															   it2.item_tipo = i.fact_tipo
									   JOIN Composicion c2 ON c2.comp_componente = it2.item_producto 
			  WHERE c1.comp_producto <> c2.comp_producto)
	BEGIN
		PRINT('La factura no puede contener productos que sean componentes de diferentes productos')
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		INSERT INTO Factura(fact_cliente, fact_fecha, fact_numero, fact_sucursal, 		fact_tipo, fact_total, fact_total_impuestos, fact_vendedor)		SELECT i.fact_cliente, i.fact_fecha, i.fact_numero, i.fact_sucursal,		i.fact_tipo, i.fact_total, i.fact_total_impuestos, i.fact_vendedor		FROM inserted i
	END

	COMMIT TRANSACTION
END

/*30. Agregar el/los objetos necesarios para crear una regla por la cual un cliente no
pueda comprar más de 100 unidades en el mes de ningún producto, si esto
ocurre no se deberá ingresar la operación y se deberá emitir un mensaje “Se ha
superado el límite máximo de compra de un producto”. Se sabe que esta regla se
cumple y que las facturas no pueden ser modificadas.*/
GO
CREATE TRIGGER EJ_30 ON Factura
INSTEAD OF INSERT AS
BEGIN
	BEGIN TRANSACTION

	IF EXISTS(SELECT 1 FROM inserted i JOIN Item_Factura it ON it.item_numero = i.fact_numero AND
															   it.item_sucursal = i.fact_sucursal AND
															   it.item_tipo = i.fact_tipo
									   JOIN Factura f ON f.fact_cliente = i.fact_cliente AND
														  YEAR(i.fact_fecha) = YEAR(f.fact_fecha) AND
														  MONTH(i.fact_fecha) = MONTH(f.fact_fecha) + 1
										JOIN Item_Factura it2 ON it2.item_numero = f.fact_numero AND
															   it2.item_sucursal = f.fact_sucursal AND
															   it2.item_tipo = f.fact_tipo AND
															   it2.item_producto = it.item_producto
			  GROUP BY it.item_producto, i.fact_cliente
			  HAVING SUM(it.item_cantidad + it2.item_cantidad) < 100)
	BEGIN
		PRINT('Se ha superado el límite máximo de compra de un producto')
		ROLLBACK TRANSACTION
	END
	ELSE
	BEGIN
		INSERT INTO Factura(fact_cliente, fact_fecha, fact_numero, fact_sucursal, 		fact_tipo, fact_total, fact_total_impuestos, fact_vendedor)		SELECT i.fact_cliente, i.fact_fecha, i.fact_numero, i.fact_sucursal,		i.fact_tipo, i.fact_total, i.fact_total_impuestos, i.fact_vendedor		FROM inserted i	END	COMMIT TRANSACTIONEND /*31. Desarrolle el o los objetos de base de datos necesarios, para que un jefe no pueda
tener más de 20 empleados a cargo, directa o indirectamente, si esto ocurre
debera asignarsele un jefe que cumpla esa condición, si no existe un jefe para
asignarle se le deberá colocar como jefe al gerente general que es aquel que no
tiene jefe.*/
GO
CREATE TRIGGER EJ_31
ON Empleado
INSTEAD OF INSERT
AS
BEGIN
    BEGIN TRANSACTION;

    DECLARE @gerente NUMERIC(6,0);
    DECLARE @nuevoJefe NUMERIC(6,0);

    -- Obtener gerente general (sin jefe)
    SELECT @gerente = e.empl_codigo
    FROM Empleado e
    WHERE e.empl_jefe IS NULL;

    -- Recorremos cada empleado a insertar
    DECLARE cur CURSOR FOR
        SELECT i.empl_codigo, i.empl_jefe
        FROM inserted i;

    DECLARE @empl NUMERIC(6,0);
    DECLARE @jefe NUMERIC(6,0);

    OPEN cur;
    FETCH NEXT FROM cur INTO @empl, @jefe;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF dbo.fn_JefeSuperaLimite(@jefe) = 1
        BEGIN
            SELECT TOP 1 @nuevoJefe = e.empl_codigo
            FROM Empleado e
            WHERE dbo.fn_JefeSuperaLimite(e.empl_codigo) = 0
              AND e.empl_codigo <> @jefe
              AND e.empl_jefe IS NOT NULL
            ORDER BY e.empl_codigo;

            IF @nuevoJefe IS NULL
                SET @nuevoJefe = @gerente;
        END
        ELSE
            SET @nuevoJefe = @jefe;

        INSERT INTO Empleado(empl_apellido, empl_codigo, empl_comision, empl_departamento,
        empl_ingreso, empl_jefe, empl_nacimiento, empl_nombre, empl_salario, empl_tareas)
        SELECT i.empl_apellido, i.empl_codigo, i.empl_comision, i.empl_departamento,
        i.empl_ingreso, @nuevoJefe, i.empl_nacimiento, i.empl_nombre, i.empl_salario, i.empl_tareas
        FROM inserted i
        WHERE i.empl_codigo = @empl;

        FETCH NEXT FROM cur INTO @empl, @jefe;
    END;

    CLOSE cur;
    DEALLOCATE cur;

    COMMIT TRANSACTION;
END;
GO

