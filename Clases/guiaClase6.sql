/*1. Mostrar el C�digo del fabricante, nombre del fabricante, tiempo de entrega y monto
Total de productos vendidos, ordenado por nombre de fabricante. En caso que el
fabricante no tenga ventas, mostrar el total en NULO.*/
SELECT m.manu_code, m.manu_name, lead_time, SUM(unit_price * quantity) Total
FROM manufact m left join items i ON (i.manu_code=m.manu_code)
GROUP BY m.manu_code,m.manu_name, lead_time
order by m.manu_name
-- el LEFT JOIN basicamente si un manu_code coincide hace todas las cuentas para sacar el total y sino pone NULL

/*2. Mostrar en una lista de a pares, el c�digo y descripci�n del producto, y los pares de
fabricantes que fabriquen el mismo producto. En el caso que haya un �nico fabricante
deber� mostrar el C�digo de fabricante 2 en nulo. Ordenar el resultado por c�digo de
producto.
El listado debe tener el siguiente formato:
Nro. de Producto Descripcion C�d. de fabric. 1 C�d. de fabric. 2
(stock_num) (Description) (manu_code) (manu_code)*/
SELECT s1.stock_num,tp.description,s1.manu_code, s2.manu_code
FROM products s1 LEFT JOIN products s2 ON (s1.stock_num=s2.stock_num AND
s1.manu_code != s2.manu_code) --si 2 fabricantes fabrican el mismo producto los pone, sino lo pone null
JOIN product_Types tp ON (s1.stock_num = tp.stock_num)
where s1.manu_code < s2.manu_code or s2.manu_code is NULL -- para evitar pares duplicados para que sea ANZ-HRO y no HRO-ANZ
ORDER BY s1.stock_num

/*3. Listar todos los clientes que hayan tenido m�s de una orden.
a) En primer lugar, escribir una consulta usando una subconsulta.
b) Reescribir la consulta utilizando GROUP BY y HAVING.
La consulta deber� tener el siguiente formato:
N�mero_de_Cliente Nombre Apellido
(customer_num) (fname) (lname)*/
SELECT customer_num, fname, lname FROM customer
WHERE customer_num IN (SELECT customer_num FROM orders
GROUP BY customer_num HAVING COUNT(order_num)>1)--subconsulta

SELECT c.customer_num, fname, lname FROM customer c
JOIN orders o ON (c.customer_num = o.customer_num)
GROUP BY c.customer_num, fname, lname HAVING COUNT(order_num)>1
--uso GROUP BY y desp HAVING pq para el WHERE no se pueden usar funciones de agregacion

/*4. Seleccionar todas las �rdenes de compra cuyo Monto total (Suma de p x q de sus items)
sea menor al precio total promedio (avg p x q) de todas las l�neas de las ordenes.
Formato de la salida: Nro. de Orden Total
(order_num) (suma)*/
SELECT o.order_num, SUM(unit_price * quantity) montoTotal
FROM orders o JOIN items i ON (o.order_num = i.order_num)
GROUP BY o.order_num HAVING SUM(unit_price*quantity) < (SELECT AVG(unit_price*quantity) FROM items)

/*5. Obtener por cada fabricante, el listado de todos los productos de stock con precio
unitario (unit_price) mayor que el precio unitario promedio de dicho fabricante.
Los campos de salida ser�n: manu_code, manu_name, stock_num, description,
unit_price.*/
SELECT s.manu_code, manu_name, s.stock_num, description, unit_price
FROM products s JOIN manufact m ON (s.manu_code=m.manu_code)
JOIN product_Types tp ON (tp.stock_num = s.stock_num)
WHERE unit_price > (SELECT AVG(unit_price) FROM products s2
WHERE s2.manu_code = m.manu_code)

/*6. Usando el operador NOT EXISTS listar la informaci�n de �rdenes de compra que NO
incluyan ning�n producto que contenga en su descripci�n el string � baseball gloves�.
Ordenar el resultado por compa��a del cliente ascendente y n�mero de orden
descendente.
El formato de salida deber� ser:
N�mero de Cliente Compa��a N�mero de Orden Fecha de la Orden
(customer_num) (company) (order_num) (order_date)*/
SELECT o.customer_num, company, order_num, order_date FROM orders o
JOIN customer c ON (o.customer_num = c.customer_num) 
WHERE NOT EXISTS (SELECT item_num FROM items i JOIN product_types P
				  ON (i.stock_num = p.stock_num) WHERE p.description 
				  LIKE '%baseball gloves%' and (i.order_num = o.order_num))

/*7. Obtener el n�mero, nombre y apellido de los clientes que NO hayan comprado productos
del fabricante �HSK�.*/
SELECT customer_num, fname, lname FROM customer c 
WHERE NOT EXISTS (SELECT 1 FROM orders o join items i on o.order_num = i.order_num
				  WHERE i.manu_code = 'HSK' and c.customer_num = o.customer_num)

/*8. Obtener el n�mero, nombre y apellido de los clientes que hayan comprado TODOS los
productos del fabricante �HSK�.*/
SELECT c.customer_num, c.fname, C.lname FROM customer C
WHERE NOT EXISTS (SELECT p.stock_num FROM products p
				  WHERE manu_code = 'HSK'
AND NOT EXISTS (SELECT 1 FROM orders o JOIN items i ON (o.order_num = i.order_num)
WHERE P.stock_num = i.stock_num AND p.manu_code = i.manu_code AND o.customer_num = c.customer_num))

/*9. Reescribir la siguiente consulta utilizando el operador UNION:
SELECT * FROM products
WHERE manu_code = �HRO� OR stock_num = 1*/
SELECT * FROM products WHERE manu_code = 'HRO'
UNION
SELECT * FROM products WHERE stock_num = 1

/*10. Desarrollar una consulta que devuelva las ciudades y compa��as de todos los Clientes
ordenadas alfab�ticamente por Ciudad pero en la consulta deber�n aparecer primero las
compa��as situadas en Redwood City y luego las dem�s.
Formato: Clave de ordenamiento Ciudad Compa��a
(sortkey) (city) (company)*/
SELECT 1 sortkey, city, company FROM customer
WHERE city = 'Redwood City'
UNION
SELECT 2 sortkey, city, company FROM customer
WHERE city != 'Redwood City'
ORDER BY sortkey, city, company

/*11.Desarrollar una consulta que devuelva los dos tipos de productos m�s vendidos y los dos
menos vendidos en funci�n de las unidades totales vendidas.
Formato

Tipo Producto Cantidad
101 999
189 888
24 ...
4 1*/
SELECT i.stock_num, SUM(i.quantity) Total FROM items i
WHERE i.stock_num IN (SELECT top 2 i2.stock_num FROM items i2 --el where in dice "traem los items que pertenezcan a esta consulta(los dos mejores)
					  GROUP BY i2.stock_num
					  ORDER BY SUM(i2.quantity) DESC)
GROUP BY i.stock_num
UNION
SELECT i.stock_num, SUM(i.quantity) Total FROM items i
WHERE i.stock_num IN (SELECT TOP 2 i2.stock_num FROM items i2-- top 2 elije a los dos primeros
					  GROUP BY i2.stock_num
					  ORDER BY SUM(i2.quantity) ASC)
GROUP BY i.stock_num
ORDER BY 2 DESC

/*12. Crear una Vista llamada ClientesConMultiplesOrdenes basada en la consulta realizada en
el punto 3.b con los nombres de atributos solicitados en dicho punto.*/
GO
CREATE VIEW ClientesConMultiplesOrdenes AS --las vistas son permanentes y no almacenan datos
SELECT c.customer_num, fname, lname
FROM customer c JOIN orders o ON (c.customer_num=o.customer_num)
GROUP BY c.customer_num, lname, fname
HAVING COUNT(order_num)>1
GO --para que SSMS no me rompa las pelotas

SELECT * FROM ClientesConMultiplesOrdenes; 

/*13. Crear una Vista llamada Productos_HRO en base a la consulta
SELECT * FROM products
WHERE manu_code = �HRO�

La vista deber� restringir la posibilidad de insertar datos que no cumplan con su criterio de
selecci�n.
a. Realizar un INSERT de un Producto con manu_code=�ANZ� y stock_num=303. Qu� sucede?
b. Realizar un INSERT con manu_code=�HRO� y stock_num=303. Qu� sucede?
c. Validar los datos insertados a trav�s de la vista.*/
GO
CREATE VIEW Productos_HRO AS
SELECT * FROM products
WHERE manu_code = 'HRO'
WITH CHECK OPTION --es para que se respete la regla de que solo sean prods de HRO
GO

INSERT INTO Productos_HRO (stock_num,manu_code)
VALUES (303,'ANZ') ; -- el check option no me deja hacer este pq es de ANZ
INSERT INTO Productos_HRO (stock_num,manu_code)
VALUES (303,'HRO') ;

SELECT * FROM Productos_HRO

/*14. Escriba una transacci�n que incluya las siguientes acciones:
� BEGIN TRANSACTION
o Insertar un nuevo cliente llamado �Fred Flintstone� en la tabla de
clientes (customer).
o Seleccionar todos los clientes llamados Fred de la tabla de clientes
(customer).
� ROLLBACK TRANSACTION
Luego volver a ejecutar la consulta
� Seleccionar todos los clientes llamados Fred de la tabla de clientes (customer).
� Completado el ejercicio descripto arriba. Observar que los resultados del
segundo SELECT difieren con respecto al primero.*/
BEGIN TRANSACTION

INSERT INTO customer (fname, lname)
VALUES('Fred', 'Flintstone')

SELECT * FROM customer
WHERE fname = 'Fred'

ROLLBACK TRANSACTION -- cancelo la transaccion

-- sirven para deshacer cambios, permitiendo consistencia en los datos

/*15. Se ha decidido crear un nuevo fabricante AZZ, qui�n proveer� parte de los mismos
productos que provee el fabricante ANZ, los productos ser�n los que contengan el string
�tennis� en su descripci�n.
� Agregar las nuevas filas en la tabla manufact y la tabla products.
� El c�digo del nuevo fabricante ser� �AZZ�, el nombre de la compa��a �AZZIO SA�
y el tiempo de env�o ser� de 5 d�as (lead_time).
� La informaci�n del nuevo fabricante �AZZ� de la tabla Products ser� la misma
que la del fabricante �ANZ� pero s�lo para los productos que contengan 'tennis'
en su descripci�n.
� Tener en cuenta las restricciones de integridad referencial existentes, manejar
todo dentro de una misma transacci�n.*/
BEGIN TRANSACTION

INSERT INTO manufact (manu_code, manu_name, lead_time)
VALUES ('AZZ', 'AZZIO SA', 5)

INSERT INTO products (manu_code, stock_num, unit_price, unit_code)
SELECT 'AZZ', p.stock_num, p.unit_price, p.unit_code FROM products p
JOIN product_types t ON (p.stock_num = t.stock_num)
WHERE manu_code = 'ANZ' AND t.description LIKE '%tennis%'
COMMIT --si estuvo todo bien se guarda, si hay error hace rollback
