/*
Los Stored Procedures (procedimientos almacenados) son bloques de código SQL predefinidos y almacenados en el servidor de base de datos, 
que se pueden ejecutar cuando lo necesites.
Un Stored Procedure es como una función en programación: agrupa un conjunto de instrucciones SQL que podés reutilizar sin tener que escribirlas 
cada vez.

Agrupa operaciones, evita errores y duplicacion de logica, mejora rendimiento y centraliza reglas de validación, cálculos o control de datos

EJ:
CREATE PROCEDURE InsertarCliente
    @nombre VARCHAR(50),
    @apellido VARCHAR(50)
AS
BEGIN
    INSERT INTO customer (fname, lname)
    VALUES (@nombre, @apellido)
END

Despues hago:
EXEC InsertarCliente 'Fred', 'Flintstone';

Entonces yo en una query creo y almaceno estos stored procedures y en otra puedo llamarlos
*/

/*a. Stored Procedures
Crear la siguiente tabla CustomerStatistics con los siguientes campos
customer_num (entero y pk), ordersqty (entero), maxdate (date), uniqueProducts
(entero)
Crear un procedimiento ‘actualizaEstadisticas’ que reciba dos parámetros
customer_numDES y customer_numHAS y que en base a los datos de la tabla
customer cuyo customer_num estén en en rango pasado por parámetro, inserte (si
no existe) o modifique el registro de la tabla CustomerStatistics con la siguiente
información:
Ordersqty contedrá la cantidad de órdenes para cada cliente.
Maxdate contedrá la fecha máxima de la última órde puesta por cada cliente.
uniqueProducts contendrá la cantidad única de tipos de productos adquiridos
por cada cliente.*/
CREATE TABLE CustomerStatistics1 (
customer_num INT PRIMARY KEY,
ordersqty INT, 
maxdate DATE,
uniqueProducts INT 
)

GO

CREATE PROCEDURE actualizarEstadisticas 
		@customer_numDES INT,
		@customer_numHAS INT
AS
BEGIN
SET NOCOUNT ON;

MERGE CustomerStatistics1 AS cs --con merge actualiza o inserta si no existe
USING(
SELECT c.customer_num, COUNT(o.order_num) ordersqty, MAX(o.order_date) maxdate, COUNT(DISTINCT i.stock_num) uniqueProducts
FROM customer c LEFT JOIN orders o	ON (o.customer_num = c.customer_num)
				LEFT JOIN items i ON (o.order_num = i.order_num)
WHERE c.customer_num BETWEEN @customer_numDES AND @customer_numHAS 
GROUP BY c.customer_num
) AS source
ON cs.customer_num = source.customer_num
WHEN MATCHED THEN UPDATE SET
	cs.ordersqty = source.ordersqty,
	cs.maxdate = source.maxdate,
	cs.uniqueProducts = source.uniqueProducts
WHEN NOT MATCHED THEN
INSERT (customer_num, ordersqty, maxdate, uniqueProducts)
VALUES (source.customer_num, source.ordersqty, source.maxdate, source.uniqueProducts);

END

