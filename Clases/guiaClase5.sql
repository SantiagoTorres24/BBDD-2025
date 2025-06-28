/*1. Obtener el número de cliente, la compañía, y número de orden de todos los clientes que tengan
órdenes. Ordenar el resultado por número de cliente.*/
SELECT c.customer_num, Company, order_num
FROM customer c JOIN orders o ON c.customer_num = o.customer_num -- ahora la tabla customer es c y la de orders es o
ORDER BY c.customer_num -- entonces c.customer_num se refiere al customer_num de la tabla customer

/*2. Listar los ítems de la orden número 1004, incluyendo una descripción de cada uno. El listado debe
contener: Número de orden (order_num), Número de Item (item_num), Descripción del producto
(product_types.description), Código del fabricante (manu_code), Cantidad (quantity), Precio total
(unit_price*quantity).*/
SELECT order_num, item_num, description, manu_code, quantity,
(unit_price*quantity) precioTotal
FROM items i JOIN product_types p ON (i.stock_num=p.stock_num)
WHERE i.order_num=1004
-- de la tabla items i selecciona todo ... para description tenes que entrar a product_types p en donde el stock_num sea igual en i y p 

/*3. Listar los items de la orden número 1004, incluyendo una descripción de cada uno. El listado debe
contener: Número de orden (order_num), Número de Item (item_num), Descripción del Producto
(product_types.description), Código del fabricante (manu_code), Cantidad (quantity), precio total
(unit_price*quantity) y Nombre del fabricante (manu_name).*/
SELECT order_num, item_num, description, i.manu_code, quantity, (quantity * unit_price) precioTotal, manu_name
FROM items i JOIN product_types p ON (i.stock_num = p.stock_num)
			 JOIN manufact m ON (i.manu_code = m.manu_code)
WHERE i.order_num = 1004

/*4. Se desea listar todos los clientes que posean órdenes de compra. Los datos a listar son los
siguientes: número de orden, número de cliente, nombre, apellido y compañía.*/
SELECT o.order_num, c.customer_num, lname, fname, company
FROM orders o JOIN customer c ON (o.customer_num = c.customer_num)

/*5. Se desea listar todos los clientes que posean órdenes de compra. Los datos a listar son los
siguientes: número de cliente, nombre, apellido y compañía. Se requiere sólo una fila por cliente.*/
SELECT DISTINCT c.customer_num,fname,lname,company -- el distinct era para no repetir, como no me pide el orden de compra puedo hacerlo
FROM orders o JOIN customer C
ON (o.customer_num=c.customer_num)

/*6. Se requiere listar para armar una nueva lista de precios los siguientes datos: nombre del fabricante
(manu_name), número de stock (stock_num), descripción
(product_types.description), unidad (units.unit), precio unitario (unit_price) y Precio Junio (precio
unitario + 20%).*/
SELECT manu_name,p.stock_num,description, unit, unit_price,
(unit_price *1.2) precioJunio
FROM products p
JOIN product_types t ON (p.stock_num=t.stock_num)
JOIN manufact m ON (p.manu_code=m.manu_code)
JOIN units u ON (p.unit_code=u.unit_code)

/*7. Se requiere un listado de los items de la orden de pedido Nro. 1004 con los siguientes datos:
Número de item (item_num), descripción de cada producto
(product_types.description), cantidad (quantity) y precio total (unit_price*quantity).*/
SELECT item_num, description, quantity, (unit_price*quantity) precioTotal
FROM items i JOIN product_types p ON (i.stock_num = p.stock_num)
WHERE order_num = 1004

/*8. Informar el nombre del fabricante (manu_name) y el tiempo de envío (lead_time) de los ítems de
las Órdenes del cliente 104.*/
SELECT DISTINCT m.manu_name, m.lead_time
FROM orders o JOIN items i ON (o.order_num = i.order_num)
			  JOIN manufact m ON (i.manu_code = m.manu_code)
			  JOIN customer c ON (c.customer_num = o.customer_num)
WHERE c.customer_num = 104

SELECT DISTINCT manu_name, lead_time
FROM items i JOIN manufact m ON (i.manu_code=m.manu_code)
JOIN orders o ON (i.order_num=o.order_num)
WHERE customer_num=104

/*9. Se requiere un listado de las todas las órdenes de pedido con los siguientes datos: Número de
orden (order_num), fecha de la orden (order_date), número de ítem (item_num), descripción de
cada producto (description), cantidad (quantity) y precio total (unit_price*quantity).*/
SELECT o.order_num, o.order_date, i.item_num, description, i.quantity, (i.unit_price*i.quantity) precioTotal
FROM orders o JOIN items i ON (o.order_num = i.order_num)
			  JOIN product_types p ON (i.stock_num = p.stock_num)

/*10. Obtener un listado con la siguiente información: Apellido (lname) y Nombre (fname) del Cliente
separado por coma, Número de teléfono (phone) en formato (999) 999-9999. Ordenado por
apellido y nombre.*/
SELECT lname + ', ' + fname 'Apellido y Nombre',
'('+SUBSTRING(phone,1,3)+')'+' '+SUBSTRING(phone,5,12)  Tel
FROM customer 
ORDER BY lname, fname

/*11. Obtener la fecha de embarque (ship_date), Apellido (lname) y Nombre (fname) del Cliente
separado por coma y la cantidad de órdenes del cliente. Para aquellos clientes que viven en el
estado con descripción (sname) “California” y el código postal está entre 94000 y 94100 inclusive.
Ordenado por fecha de embarque y, Apellido y nombre.*/
SELECT ship_date, lname+', '+fname apYNom, COUNT(o.customer_num) cantOrdenes
FROM orders o JOIN customer c ON (o.customer_num=c.customer_num)
			  JOIN state s ON (c.state = s.state)
WHERE zipcode BETWEEN 94000 AND 94100
AND sname='California'
GROUP BY ship_date, lname, fname
ORDER BY ship_date, lname, fname

/*12. Obtener por cada fabricante (manu_name) y producto (description), la cantidad vendida y el
Monto Total vendido (unit_price * quantity). Sólo se deberán mostrar los ítems de los fabricantes
ANZ, HRO, HSK y SMT, para las órdenes correspondientes a los meses de mayo y junio del 2015.
Ordenar el resultado por el monto total vendido de mayor a menor.*/
SELECT manu_name, description, SUM(quantity) cantidadVendida, SUM(unit_price * quantity) montoTotalVendido
FROM manufact m JOIN items i ON (m.manu_code = i.manu_code)
				JOIN product_types p ON (i.stock_num = p.stock_num)
				JOIN orders o ON (o.order_num = i.order_num)
WHERE i.manu_code IN('ANZ','HRO','HSK', 'SMT') AND o.order_date BETWEEN '2015-05-01' AND '2015-06-01'
GROUP BY manu_name, description -- para funciones de agregacion (SUM), tengo que usar groupBy (otras entidades)
ORDER BY montoTotalVendido DESC

/*13. Emitir un reporte con la cantidad de unidades vendidas y el importe total por mes de productos,
ordenado por importe total en forma descendente.
Formato: Año/Mes Cantidad Total*/
SELECT CAST(YEAR(order_date) AS VARCHAR)+'/'+CAST(MONTH(order_date) AS VARCHAR) AnioMes,
SUM(quantity) Cantidad, SUM(quantity * unit_price) Total -- CAST pasa de un tipo de dato a otro CAST(valor AS nuevoTipo)
FROM items i JOIN orders o ON (i.order_num = o.order_num)
GROUP BY CAST(YEAR(order_date) AS VARCHAR)+'/'+CAST(MONTH(order_date) AS VARCHAR)
ORDER BY Total DESC
