/*Una función (FUNCTION) en SQL Server devuelve un valor (escalares) o una tabla (tablas en línea o multisentencia). A diferencia de un 
procedimiento almacenado, no puede modificar datos directamente (no se permite INSERT, UPDATE, DELETE a tablas que no sean variables internas), 
y no permite efectos colaterales como MERGE.

EJ:
CREATE FUNCTION fn_cantidad_ordenes (@customer_num INT)
RETURNS INT
AS
BEGIN
    DECLARE @result INT;

    SELECT @result = COUNT(*)
    FROM orders
    WHERE customer_num = @customer_num;

    RETURN @result;
END;

Despues la uso:
SELECT dbo.fn_cantidad_ordenes(101);

Devolviendo una tabla:
CREATE FUNCTION fn_estadisticas_cliente (@customer_num INT)
RETURNS TABLE
AS
RETURN (
    SELECT 
        c.customer_num,
        COUNT(DISTINCT o.order_num) AS ordersqty,
        MAX(o.order_date) AS maxdate,
        COUNT(DISTINCT i.stock_num) AS uniqueProducts
    FROM customer c
    LEFT JOIN orders o ON o.customer_num = c.customer_num
    LEFT JOIN items i ON i.order_num = o.order_num
    WHERE c.customer_num = @customer_num
    GROUP BY c.customer_num
);
*/

/*2. Escribir una sentencia SELECT para los clientes que han tenido órdenes en al menos 2 meses
diferentes, los dos meses con las órdenes con el mayor ship_charge.
Se debe devolver una fila por cada cliente que cumpla esa condición, el formato es:
Cliente Año y mes mayor carga Segundo año y mes mayor carga
NNNN YYYY - Total: NNNN.NN YYYY - Total: NNNN.NN
La primera columna es el id de cliente y las siguientes 2 se refieren a los campos ship_date y ship_charge.
Se requiere crear una función que devuelva la información de 1er o 2do año mes con la orden con mayor Carga
(ship_charge).*/

CREATE FUNCTION Fx_1erMes (@CLIENTE INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @RETORNO VARCHAR(100)

    SELECT TOP 1 
        @RETORNO = 
            FORMAT(YEAR(order_date), '0000') + '-' + 
            RIGHT('0' + FORMAT(MONTH(order_date), '00'), 2) + 
            ' - Total: ' + FORMAT(SUM(COALESCE(ship_charge, 0)), 'N2')
    FROM orders
    WHERE customer_num = @CLIENTE
    GROUP BY YEAR(order_date), MONTH(order_date)
    ORDER BY SUM(COALESCE(ship_charge, 0)) DESC

    RETURN @RETORNO
END
GO


DROP FUNCTION IF EXISTS dbo.Fx_2doMes;
GO

CREATE FUNCTION dbo.Fx_2doMes (@CLIENTE INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @RETORNO VARCHAR(100);

    WITH MesesConCargas AS (
        SELECT
            YEAR(order_date) AS anio,
            MONTH(order_date) AS mes,
            SUM(COALESCE(ship_charge, 0)) AS total_carga,
            ROW_NUMBER() OVER (
                ORDER BY SUM(COALESCE(ship_charge, 0)) DESC
            ) AS fila
        FROM orders
        WHERE customer_num = @CLIENTE
        GROUP BY YEAR(order_date), MONTH(order_date)
    )
    SELECT @RETORNO = 
        FORMAT(anio, '0000') + '-' + RIGHT('0' + FORMAT(mes, '00'), 2) + 
        ' - Total: ' + FORMAT(total_carga, 'N2')
    FROM MesesConCargas
    WHERE fila = 2;

    RETURN @RETORNO;
END
GO


SELECT 
    customer_num AS Cliente,
    dbo.Fx_1erMes(customer_num) AS "Mes mayor carga",
    dbo.Fx_2doMes(customer_num) AS "Segundo Mes mayor carga"
FROM orders
WHERE customer_num IN (
    SELECT customer_num
    FROM (
        SELECT customer_num, COUNT(DISTINCT FORMAT(order_date, 'yyyyMM')) AS meses_distintos
        FROM orders
        GROUP BY customer_num
    ) AS t
    WHERE meses_distintos >= 2
)
GROUP BY customer_num;
