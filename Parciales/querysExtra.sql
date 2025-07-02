/*Obtener los Tipos de Productos, monto total comprado por cliente y por sus referidos. 
Mostrar:
descripción del Tipo de Producto, Nombre y apellido del cliente, monto total comprado de ese
tipo de producto, Nombre y apellido de su cliente referido y el monto total comprado de su
referido. Ordenado por Descripción, Apellido y Nombre del cliente (Referente).
Nota: Si el Cliente no tiene referidos o sus referidos no compraron el mismo producto, 
mostrar -- ? como nombre y apellido del referido y 0 (cero) en la cantidad vendida.*/
SELECT 
    pt.description,
    c.fname AS nombre_cliente,
    c.lname AS apellido_cliente,
    SUM(i.unit_price * i.quantity) AS monto_cliente,
    COALESCE(r.fname, '--') AS nombre_referido,
    COALESCE(r.lname, '--') AS apellido_referido,
    COALESCE(SUM(i_ref.unit_price * i_ref.quantity), 0) AS monto_referido
FROM customer c
LEFT JOIN orders o ON o.customer_num = c.customer_num
LEFT JOIN items i ON i.order_num = o.order_num
LEFT JOIN product_types pt ON pt.stock_num = i.stock_num

LEFT JOIN customer r ON r.customer_num_referedBy = c.customer_num
LEFT JOIN orders o_ref ON o_ref.customer_num = r.customer_num
LEFT JOIN items i_ref ON i_ref.order_num = o_ref.order_num AND i_ref.stock_num = i.stock_num
GROUP BY pt.description, c.fname, c.lname, r.fname, r.lname
ORDER BY pt.description, c.lname, c.fname;

/*crear una consulta que devuelva:'
'Apellido, nombre AS CLIENTE,
suma de todo lo comprado por el cliente as totalCompra
apellido,nombre as ClienteReferido ,
suma de todo lo comprado por el referido * 0.05 AS totalComision*/
SELECT 
    c.fname + ' ' + c.lname AS Cliente,
    SUM(DISTINCT i.unit_price * i.quantity) AS totalCompra,

    COALESCE(r.fname + ' ' + r.lname, '--') AS ClienteReferido,
    COALESCE(SUM(DISTINCT ir.unit_price * ir.quantity) * 0.05, 0) AS totalComision
FROM customer c 
JOIN orders o ON o.customer_num = c.customer_num
JOIN items i ON i.order_num = o.order_num

LEFT JOIN customer r ON r.customer_num_referedBy = c.customer_num
LEFT JOIN orders oref ON oref.customer_num = r.customer_num
LEFT JOIN items ir ON ir.order_num = oref.order_num

GROUP BY 
    c.fname + ' ' + c.lname,
    r.fname + ' ' + r.lname
ORDER BY Cliente;

/*vista que muestre las tres primeras provincias que tengan la mayor cantidad de compras ,
mostrar nombre y apellido del cliente con mayor total de compra para esa provincia, 
total comprado y nombre de la provincia.*/
GO
CREATE VIEW provincias AS
SELECT TOP 3 sname, SUM(quantity * unit_price) total,(
	SELECT TOP 1 fname + ' ' + lname FROM customer c
	JOIN orders o ON o.customer_num = c.customer_num
	JOIN items i ON i.order_num = o.order_num
	JOIN state s ON c.state = s.state
	GROUP BY fname, lname, c.state
	ORDER BY SUM(quantity * unit_price) DESC) AS NombreApellido
FROM state s JOIN customer c ON s.state = c.state
			 JOIN orders o ON o.customer_num = c.customer_num
			 JOIN items i ON i.order_num = o.order_num
GROUP BY sname
ORDER BY 2

SELECT * FROM provincias

/*seleccionar codigo de fabricante, nombre fabricante, cantidad de ordenes del fabricante,
cantidad total vendida del fabricante, promedio de las cantidades vendidas de todos los 
fabricantes cuyas ventas totales sean mayores al promedio de las ventas de todos los 
fabricantes '
'mostrar el resultado ordenado por cantidad total vendida en forma descendente*/
SELECT m.manu_code, manu_name, COUNT(o.order_num) cantidadOrdenes,
	   SUM(unit_price * quantity) cantidadVentidad, (
SELECT SUM(unit_price * quantity)/COUNT(DISTINCT manu_code) 
FROM items) AS promedioFabricantes
FROM manufact m JOIN items i ON i.manu_code = m.manu_code
				JOIN orders o ON o.order_num = i.order_num
GROUP BY m.manu_code, manu_name
HAVING SUM(i.quantity * i.unit_price) > (SELECT SUM(quantity * unit_price) / COUNT(distinct manu_code) FROM items)
ORDER BY 3 DESC