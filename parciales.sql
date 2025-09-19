/*28-11-25
Identificar los clientes que compraron productos que estén tanto en el ranking de los 10 más vendidos en 2012 como en el ranking de los 10 menos vendidos en 2012.

Y devolver:

Número de fila (orden correlativo).

Nombre del cliente.

Si es cliente del ranking de los más vendidos (Sí/No).
*/
SELECT * FROM Cliente
SELECT * FROM Item_Factura

SELECT ROW_NUMBER() OVER(ORDER BY SUM(i.item_precio * i.item_cantidad)) AS NroFila, c.clie_razon_social AS NombreCliente, COUNT(f.fact_cliente) AS CantidadFacturas,
CASE WHEN EXISTS (SELECT 1 FROM Item_Factura i2 JOIN Factura f2 ON f2.fact_tipo = i2.item_tipo AND 
                                                                   f2.fact_sucursal = i2.item_sucursal AND  
                                                                   f2.fact_numero = i2.item_numero
				  WHERE c.clie_codigo = f2.fact_cliente AND YEAR(f2.fact_fecha) = 2012 AND i2.item_producto IN(
				  SELECT TOP 10 i3.item_producto FROM Item_Factura i3 JOIN Factura f3 ON f3.fact_tipo = i3.item_tipo AND 
                                                                   f3.fact_sucursal = i3.item_sucursal AND  
                                                                   f3.fact_numero = i3.item_numero
				  WHERE YEAR(f3.fact_fecha) = 2012
				  GROUP BY i3.item_producto
				  ORDER BY SUM(i3.item_cantidad) DESC)) THEN 'SI' ELSE 'NO' END AS Top10Cliente
FROM Cliente c JOIN Factura f on c.clie_codigo = f.fact_cliente
			   JOIN Item_Factura i ON i.item_tipo = f.fact_tipo AND
								      i.item_sucursal = f.fact_sucursal AND
								      i.item_numero = f.fact_numero
WHERE YEAR(f.fact_fecha) = 2012 AND i.item_producto IN(
SELECT TOP 10 i4.item_producto FROM Item_Factura i4 JOIN Factura f4 ON f4.fact_tipo = i4.item_tipo AND 
                                                                   f4.fact_sucursal = i4.item_sucursal AND  
                                                                   f4.fact_numero = i4.item_numero
				  WHERE YEAR(f4.fact_fecha) = 2012
				  GROUP BY i4.item_producto
				  ORDER BY SUM(i4.item_cantidad) DESC

				  UNION

SELECT TOP 10 i5.item_producto FROM Item_Factura i5 LEFT JOIN Factura f5 ON f5.fact_tipo = i5.item_tipo AND 
                                                                   f5.fact_sucursal = i5.item_sucursal AND  
                                                                   f5.fact_numero = i5.item_numero
				  WHERE YEAR(f5.fact_fecha) = 2012
				  GROUP BY i5.item_producto, i5.item_cantidad
				  ORDER BY SUM(ISNULL(i5.item_cantidad, 0)))
GROUP BY c.clie_razon_social, f.fact_cliente, c.clie_codigo
ORDER BY SUM(i.item_precio * i.item_cantidad)

/* 29-07-2023
Listar clientes que durante 2 años consecutivos compraron al menos 5 productos distintos.

De cada cliente mostrar:

Código de cliente.

Monto total comprado en 2012.

Cantidad de unidades de productos compradas en 2012.

Ordenar primero por clientes que alguna vez compraron solo productos compuestos, y luego el resto.*/
SELECT c.clie_codigo, 
       SUM(CASE WHEN YEAR(f.fact_fecha) = 2012 
                THEN i.item_cantidad * i.item_precio ELSE 0 END) AS Monto2012, 
       SUM(CASE WHEN YEAR(f.fact_fecha) = 2012 
                THEN i.item_cantidad ELSE 0 END) AS Unidades2012
FROM Cliente c 
JOIN Factura f 
  ON f.fact_cliente = c.clie_codigo
JOIN Item_Factura i 
  ON i.item_tipo = f.fact_tipo 
 AND i.item_sucursal = f.fact_sucursal 
 AND i.item_numero   = f.fact_numero
GROUP BY c.clie_codigo
HAVING EXISTS (
   SELECT 1 
   FROM Factura f2 
   JOIN Item_Factura i2 
     ON i2.item_tipo     = f2.fact_tipo
    AND i2.item_sucursal = f2.fact_sucursal
    AND i2.item_numero   = f2.fact_numero
   WHERE f2.fact_cliente = c.clie_codigo
   GROUP BY YEAR(f2.fact_fecha)
   HAVING COUNT(DISTINCT i2.item_producto) >= 5 
      AND EXISTS (
          SELECT 1 
          FROM Factura f3 
          JOIN Item_Factura i3 
            ON i3.item_tipo     = f3.fact_tipo
           AND i3.item_sucursal = f3.fact_sucursal
           AND i3.item_numero   = f3.fact_numero
          WHERE f3.fact_cliente = c.clie_codigo 
            AND YEAR(f3.fact_fecha) = YEAR(f2.fact_fecha) + 1
          GROUP BY YEAR(f3.fact_fecha)
          HAVING COUNT(DISTINCT i3.item_producto) >= 5
      )
)
ORDER BY CASE 
            WHEN NOT EXISTS (
                SELECT 1 
                FROM Item_Factura i4 
                LEFT JOIN Composicion co2 
                       ON co2.comp_producto = i4.item_producto
                JOIN Factura f4 
                  ON f4.fact_tipo     = i4.item_tipo 
                 AND f4.fact_sucursal = i4.item_sucursal 
                 AND f4.fact_numero   = i4.item_numero
                WHERE f4.fact_cliente = c.clie_codigo
                  AND co2.comp_producto IS NULL
            )
            THEN 0 ELSE 1 
         END;

/*1.  Armar una consulta Sql que retorne:

    - Razón social del cliente
    - Límite de crédito del cliente
    - Producto más comprado en la historia (en unidades)

    Solamente deberá mostrar aquellos clientes que tuvieron mayor cantidad de ventas en el 2012 que
    en el 2011 en cantidades y cuyos montos de ventas en dichos años sean un 30 % mayor el 2012 con
    respecto al 2011. El resultado deberá ser ordenado por código de cliente ascendente

    NOTA: No se permite el uso de sub-selects en el FROM.*/
SELECT c1.clie_razon_social, c1.clie_limite_credito, 
(SELECT TOP 1 i1.item_producto FROM Item_Factura i1 JOIN Factura f1 ON f1.fact_tipo = i1.item_tipo AND
																	   f1.fact_sucursal = i1.item_sucursal AND
																	   f1.fact_numero = i1.item_numero AND
																	   f1.fact_cliente = c1.clie_codigo
 GROUP BY i1.item_producto
 ORDER BY SUM(i1.item_cantidad) DESC) AS ProdMasComprado
FROM Cliente c1 
GROUP BY c1.clie_razon_social, c1.clie_limite_credito, c1.clie_codigo
HAVING ((SELECT SUM(i2.item_cantidad) FROM Factura f2 JOIN Item_Factura i2 ON i2.item_tipo = f2.fact_tipo AND
																							   i2.item_sucursal = f2.fact_sucursal AND
																							   i2.item_numero = f2.fact_numero
		 WHERE YEAR(f2.fact_fecha) = 2011 AND f2.fact_cliente = c1.clie_codigo) <
		 (SELECT SUM(i3.item_cantidad) FROM Factura f3 JOIN Item_Factura i3 ON i3.item_tipo = f3.fact_tipo AND
																								i3.item_sucursal = f3.fact_sucursal AND
																								i3.item_numero = f3.fact_numero
		 WHERE YEAR(f3.fact_fecha) = 2012 AND f3.fact_cliente = c1.clie_codigo) AND 
		 (SELECT SUM(i4.item_precio * i4.item_cantidad) FROM Factura f4 JOIN Item_Factura i4 ON i4.item_tipo = f4.fact_tipo AND
																							   i4.item_sucursal = f4.fact_sucursal AND
																							   i4.item_numero = f4.fact_numero
		 WHERE YEAR(f4.fact_fecha) = 2011 AND f4.fact_cliente = c1.clie_codigo) * 1.3 <
		 (SELECT SUM(i5.item_precio * i5.item_cantidad) FROM Factura f5 JOIN Item_Factura i5 ON i5.item_tipo = f5.fact_tipo AND
																								i5.item_sucursal = f5.fact_sucursal AND
																								i5.item_numero = f5.fact_numero
		 WHERE YEAR(f5.fact_fecha) = 2012 AND f5.fact_cliente = c1.clie_codigo)
		 )
ORDER BY c1.clie_codigo 