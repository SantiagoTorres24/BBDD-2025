SELECT * FROM customer --Me trae toda la BD

--1. Obtener un listado de todos los clientes y sus direcciones. 
SELECT fname, address1 + address2 DireccionCliente FROM customer

--2. Obtener el listado anterior pero sólo los clientes que viven en el estado de California “CA”.
SELECT fname, address1 + address2 DireccionCliente, state FROM customer WHERE state = 'CA'

--3. Listar todas las ciudades (city) de la tabla clientes que pertenecen al estado de “CA”, mostrar sólo una vez cada ciudad.
SELECT fname, city, state FROM customer WHERE state = 'CA'

--4. Ordenar la lista anterior alfabéticamente. 
SELECT fname, city, state FROM customer WHERE state = 'CA' ORDER BY city

--5. Mostrar la dirección sólo del cliente 103. (customer_num) 
SELECT fname, address1 + address2 DireccionCliente FROM customer WHERE customer_num = 103

SELECT * FROM products

--6. Mostrar la lista de productos que fabrica el fabricante “ANZ” ordenada por el campo Código de Unidad de Medida. (unit_code)SELECT * FROM products WHERE manu_code = 'ANZ' ORDER BY unit_code--7. Listar los códigos de fabricantes que tengan alguna orden de pedido ingresada, ordenados alfabéticamente y no repetidos. SELECT DISTINCT manu_code FROM products ORDER BY manu_codeSELECT * FROM orders

--8. Escribir una sentencia SELECT que devuelva el número de orden, fecha de orden, número de cliente y fecha de embarque de todas las órdenes 
--que no han sido pagadas (paid_date es nulo), pero fueron embarcadas (ship_date) durante los primeros seis meses de 2015. 
SELECT order_num, order_date, customer_num, paid_date, ship_date FROM orders
WHERE paid_date IS NULL and ship_date BETWEEN '2015-01-01' AND '2015-06-30' --AND YEAR(ship_date) = 2015 AND MONTH(ship_date) BETWEEN 1 AND 6;

--9. Obtener de la tabla cliente (customer) los número de clientes y nombres de las compañías, cuyos nombres de compañías contengan la palabra “town”.
SELECT customer_num, company FROM customer WHERE company LIKE '%town%'

--10. Obtener el precio máximo, mínimo y precio promedio pagado (ship_charge) por todos los embarques. Se pide obtener la información de la tabla 
--ordenes (orders).
SELECT MAX(ship_charge) PrecioMaximo, MIN(ship_charge) PrecioMinimo, AVG(ship_charge) PrecioPromedio FROM orders

--11. Realizar una consulta que muestre el número de orden, fecha de orden y fecha de embarque de todas que fueron embarcadas (ship_date) en el 
--mismo mes que fue dada de alta la orden (order_date).
SELECT order_num, order_date, ship_date FROM orders WHERE MONTH(ship_date) = MONTH(order_date)

--12. Obtener la Cantidad de embarques y Costo total (ship_charge) del embarque por número de cliente y por fecha de embarque. Ordenar los resultados
--por el total de costo en orden inverso
SELECT customer_num, ship_date, COUNT(order_num) CantidadEmbarques, SUM(ship_charge) CostoTotal FROM orders
GROUP BY customer_num, ship_date ORDER BY CostoTotal DESC

--13. Mostrar fecha de embarque (ship_date) y cantidad total de libras (ship_weight) por día, de aquellos días cuyo peso de los embarques superen 
--las 30 libras. Ordenar el resultado por el total de libras en orden descendente.SELECT ship_date, SUM(ship_weight) LibrasTotales FROM orders GROUP BY ship_date HAVING SUM(ship_weight) > 30  ORDER BY LibrasTotales DESC --primero agrupo por dias y desp filtro con HAVING--14. Crear una consulta que liste todos los clientes que vivan en California ordenados por compañía. SELECT * FROM customer WHERE state = 'CA' ORDER BY company--15. Obtener un listado de la cantidad de productos únicos comprados a cada fabricante, en donde el total comprado a cada fabricante sea mayor a 
--1500. El listado deberá estar ordenado por cantidad de productos comprados de mayor a menor.
SELECT manu_code, COUNT(DISTINCT stock_num) ProductosUnicos, SUM(unit_price * quantity) CompraTotal FROM items
GROUP BY manu_code HAVING SUM(unit_price * quantity) > 1500 ORDER BY ProductosUnicos DESC

--16. Obtener un listado con el código de fabricante, nro de producto, la cantidad vendida (quantity), y el total vendido (quantity x unit_price), 
--para los fabricantes cuyo código tiene una “R” como segunda letra. Ordenar el listado por código de fabricante y nro de producto.
SELECT manu_code, item_num, SUM(quantity) CantidadVendida, SUM(quantity * unit_price) TotalVendido FROM items
WHERE manu_code LIKE '_R%' GROUP BY manu_code, item_num ORDER BY manu_code, item_num

--17. Crear una tabla temporal OrdenesTemp que contenga las siguientes columnas: cantidad de órdenes por cada cliente, primera y última fecha de 
--orden de compra (order_date) del cliente. 
CREATE TABLE #OrdenesTemp ( --#local, ##glbal
    customer_id INT,
    CantidadOrdenes INT,
    PrimeraCompra DATETIME,
    UltimaCompra DATETIME
);

INSERT INTO #OrdenesTemp
SELECT 
    customer_num, 
    COUNT(*) AS CantidadOrdenes, 
    MIN(order_date) AS PrimeraCompra, 
    MAX(order_date) AS UltimaCompra
FROM orders
GROUP BY customer_num;

--Realizar una consulta de la tabla temp OrdenesTemp en donde la primer fecha de compra sea anterior a 
--'2015-05-23 00:00:00.000', ordenada por fechaUltimaCompra en forma descendente.
SELECT * FROM #OrdenesTemp WHERE PrimeraCompra < '2015-05-23 00:00:00.000' ORDER BY UltimaCompra DESC

--18. Consultar la tabla temporal del punto anterior y obtener la cantidad de clientes con igual cantidad de compras. Ordenar el listado por 
--cantidad de compras en orden descendente 
SELECT CantidadOrdenes, COUNT(*) CantidadClientes FROM #OrdenesTemp GROUP BY CantidadOrdenes ORDER BY CantidadOrdenes DESC 

--19. Desconectarse de la sesión. Volver a conectarse y ejecutar SELECT * from #ordenesTemp. Que sucede?--Alta paja pero supongo que se borra la tabla--20. Se desea obtener la cantidad de clientes por cada state y city, donde los clientes contengan el string ‘ts’ en el nombre de compañía, el 
--código postal este entre 93000 y 94100 y la ciudad no sea 'Mountain View'. Se desea el listado ordenado por ciudad SELECT state, city, COUNT(*) CantidadClientes FROM customer  WHERE company LIKE '%ts%' and zipcode BETWEEN 93000 and 94100 and city != 'Mountain View' GROUP BY state, city ORDER BY city--21. Para cada estado, obtener la cantidad de clientes referidos. Mostrar sólo los clientes que hayan sido referidos cuya compañía empiece con --una letra que este en el rango de ‘A’ a ‘L’.SELECT state, COUNT(*) ClientesRefereidos FROM customer WHERE customer_num_referedBy IS NOT NULL and company LIKE '[A-L]%' GROUP BY state--22. Se desea obtener el promedio de lead_time por cada estado, donde los Fabricantes tengan una ‘e’ en manu_name y el lead_time sea entre 5 y 20.SELECT state, manu_name, AVG(lead_time) PromedioTiempo FROM manufactWHERE manu_name LIKE '%e%' and lead_time BETWEEN 5 and 20 GROUP BY state, manu_name ORDER BY state, manu_name--23. Se tiene la tabla units, de la cual se quiere saber la cantidad de unidades que hay por cada tipo (unit) que no tengan en nulo el descr_unit,--y además se deben mostrar solamente los que cumplan que la cantidad mostrada se superior a 5. Al resultado final se le debe sumar 1 SELECT * FROM unitsSELECT unit, COUNT(*) +1 CantidadTipo FROM unitsWHERE unit_descr IS NOT NULL GROUP BY unit HAVING COUNT(*) > 5