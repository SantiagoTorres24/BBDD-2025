--1. Mostrar el código, razón social de todos los clientes cuyo límite de crédito sea mayor o igual a $ 1000 ordenado por código de cliente.
SELECT clie_codigo, clie_razon_social FROM Cliente
WHERE clie_limite_credito >= 1000
ORDER BY clie_codigo

--2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por cantidad vendida
SELECT item_numero, item_tipo, SUM(item_cantidad) AS CantidadVendida
FROM Item_Factura i JOIN Factura f ON i.item_tipo = f.fact_tipo AND i.item_sucursal = f.fact_sucursal
WHERE YEAR(fact_fecha) = 2012
GROUP BY item_numero, item_tipo
ORDER BY SUM(item_cantidad)

--3. Realizar una consulta que muestre código de producto, nombre de producto y el stock total, sin importar en que deposito se encuentre, los datos deben ser ordenados
--por nombre del artículo de menor a mayor.
SELECT prod_codigo, prod_detalle, SUM(stoc_cantidad) AS CantidadTotal
FROM Producto p JOIN STOCK s ON p.prod_codigo = s.stoc_producto
GROUP BY prod_codigo, prod_detalle
ORDER BY prod_detalle

--4. Realizar una consulta que muestre para todos los artículos código, detalle y cantidad de artículos que lo componen. Mostrar solo aquellos artículos para los cuales
--el stock promedio por depósito sea mayor a 100.
SELECT prod_codigo, prod_detalle, SUM(stoc_cantidad) AS CantidadTotal
FROM Producto p JOIN STOCK s ON p.prod_codigo = s.stoc_producto
GROUP BY prod_codigo, prod_detalle
HAVING AVG(stoc_cantidad) > 100

--5. Realizar una consulta que muestre código de artículo, detalle y cantidad de egresos de stock que se realizaron para ese artículo en el año 2012 (egresan los 
--productos que fueron vendidos). Mostrar solo aquellos que hayan tenido más egresos que en el 2011.
SELECT item_producto, prod_detalle,
SUM(CASE WHEN YEAR(fact_fecha) = 2012 THEN item_cantidad else 0 end) AS VTA_2012
FROM Factura f JOIN Item_Factura i ON i.item_tipo = f.fact_tipo AND
									  i.item_sucursal = f.fact_sucursal AND
									  i.item_numero = f.fact_numero
			   JOIN Producto p ON p.prod_codigo = item_producto
WHERE YEAR(fact_fecha) IN (2011, 2012) -- esto evita traerme registros que no necesito, sin el where es menos performante
GROUP BY item_producto, prod_detalle
HAVING 2 > SUM(CASE WHEN YEAR(fact_fecha) = 2011 THEN item_cantidad else 0 end)
ORDER BY 3 DESC

--6. Mostrar para todos los rubros de artículos código, detalle, cantidad de artículos de ese rubro y stock total de ese rubro de artículos. Solo tener en cuenta 
--aquellos artículos que tengan un stock mayor al del artículo ‘00000000’ en el depósito ‘00’.
SELECT * FROM Rubro
SELECT * FROM Producto
SELECT * FROM STOCK
SELECT rubr_id, rubr_detalle, COUNT(prod_codigo) ArticulosRubro, SUM(stoc_cantidad) CantidadRubro
FROM Rubro r JOIN Producto p ON p.prod_rubro = r.rubr_id
			 JOIN STOCK s ON s.stoc_producto = p.prod_codigo
GROUP BY rubr_id, rubr_detalle
HAVING SUM(stoc_cantidad) > (SELECT stoc_cantidad FROM STOCK 
							 WHERE stoc_producto = '00000000' and stoc_deposito = '00'

--7. Generar una consulta que muestre para cada artículo código, detalle, mayor precio menor precio y % de la diferencia de precios (respecto del menor Ej.: menor 
--precio = 10, mayor precio =12 => mostrar 20 %). Mostrar solo aquellos artículos que posean stock.
SELECT p.prod_codigo, p.prod_detalle,
MAX(p.prod_precio) AS MayorPrecio,    
MIN(p.prod_precio) AS MenorPrecio,
((MAX(p.prod_precio) - MIN(p.prod_precio)) * 10) AS PorcentajeDif
FROM Producto p JOIN STOCK s ON s.stoc_producto = p.prod_codigo
WHERE s.stoc_cantidad > 0
GROUP BY p.prod_codigo, p.prod_detalle

--8. Mostrar para el o los artículos que tengan stock en todos los depósitos, nombre del artículo, stock del depósito que más stock tiene.
SELECT prod_codigo, prod_detalle, 
(SELECT MAX(s2.stoc_cantidad) FROM STOCK s2 
 WHERE s2.stoc_producto = p.prod_codigo) AS StockMaxDeposito
 FROM Producto p JOIN STOCK s ON s.stoc_producto = p.prod_codigo
 WHERE s.stoc_cantidad > 0
 GROUP BY prod_codigo, prod_detalle

--9. Mostrar el código del jefe, código del empleado que lo tiene como jefe, nombre del mismo y la cantidad de depósitos que ambos tienen asignados.
SELECT e.empl_codigo, e.empl_nombre AS NombreJefe, e2.empl_codigo, e2.empl_nombre AS NombreEmpleado,
COUNT(DISTINCT d.depo_codigo) AS DepositosJefe, COUNT(DISTINCT d2.depo_codigo) AS DepositosEmpleado
FROM Empleado e JOIN Empleado e2 ON e2.empl_jefe = e.empl_codigo
				JOIN DEPOSITO d ON d.depo_encargado = e.empl_codigo
				JOIN DEPOSITO d2 ON d2.depo_encargado = e2.empl_codigo
GROUP BY e.empl_codigo, e.empl_nombre, e2.empl_codigo, e2.empl_nombre 

/*10. Mostrar los 10 productos más vendidos en la historia y también los 10 productos menos 
vendidos en la historia. Además mostrar de esos productos, quien fue el cliente que
mayor compra realizo.*/
select prod, 
(SELECT TOP 1 fact_cliente 
FROM FACTURA f JOIN item_Factura i on f.fact_numero = i.item_numero and 
									  f.fact_sucursal = i.item_sucursal and 
									  f.fact_tipo = i.item_tipo
WHERE I.item_producto = prod
GROUP BY f.fact_cliente
ORDER BY SUM(i.item_cantidad) desc) as max_cantidad_clie
from (select prod_codigo as prod ,
      row_number() over( order by isnull(sum(item_cantidad),0) asc ) as menos_vendido,
      row_number() over( order by isnull(sum(item_cantidad),0) desc ) as mas_vendido
      from producto p left join item_factura i on p.prod_codigo = i.item_producto 
      group by prod_codigo) as T 
where t.mas_vendido between 1 and 10 or t.menos_vendido between 1 and 10

--11. Realizar una consulta que retorne el detalle de la familia, la cantidad diferentes de productos vendidos y el monto de dichas ventas sin impuestos. Los datos se 
--deberán ordenar de mayor a menor, por la familia que más productos diferentes vendidos tenga, solo se deberán mostrar las familias que tengan una venta superior a 
--20000 pesos para el año 2012.
SELECT fami_id, fami_detalle, COUNT(DISTINCT item_producto) AS ProductosVendidos, SUM(item_cantidad * item_precio) AS MontoVentas
FROM Familia f JOIN Producto p ON p.prod_familia = f.fami_id
			   JOIN Item_Factura i ON i.item_producto = p.prod_codigo
			   JOIN Factura fa ON fa.fact_numero = i.item_numero
WHERE YEAR(fa.fact_fecha) = 2012
GROUP BY fami_id, fami_detalle
HAVING SUM(item_cantidad * item_precio) > 20000 
ORDER BY ProductosVendidos DESC

--12. Mostrar nombre de producto, cantidad de clientes distintos que lo compraron importe promedio pagado por el producto, cantidad de depósitos en los cuales hay 
--stock del producto y stock actual del producto en todos los depósitos. Se deberán mostrar aquellos productos que hayan tenido operaciones en el año 2012 y los datos 
--deberán ordenarse de mayor a menor por monto vendido del producto.
SELECT prod_detalle AS [Nombre de Producto], AVG(item_precio) AS [Precio Promedio del Producto],
COUNT(DISTINCT stoc_deposito) AS [Cantidad de Depositos], SUM(stoc_cantidad) AS [Cantidad Total de Stock],
(SELECT COUNT(DISTINCT clie_codigo)  
 FROM Cliente c JOIN Factura f ON f.fact_cliente = c.clie_codigo
				JOIN Item_Factura i ON i.item_numero = f.fact_numero AND i.item_producto = p.prod_codigo) AS Clientes
FROM Producto p JOIN Item_Factura i ON i.item_producto = p.prod_codigo
				JOIN STOCK s ON s.stoc_producto = p.prod_codigo
				JOIN Factura f ON f.fact_numero = i.item_numero
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY prod_detalle, prod_codigo
ORDER BY AVG(item_precio) DESC

--13. Realizar una consulta que retorne para cada producto que posea composición nombre del producto, precio del producto, precio de la sumatoria de los precios por la 
--cantidad de los productos que lo componen. Solo se deberán mostrar los productos que estén compuestos por más de 2 productos y deben ser ordenados de mayor a menor 
--por cantidad de productos que lo componen.
SELECT prod_codigo, prod_precio, SUM(item_cantidad * item_precio) 
FROM Producto p JOIN Item_Factura i ON i.item_producto = p.prod_codigo
WHERE item_cantidad > 2 AND prod_detalle LIKE '%$%'
GROUP BY prod_codigo, prod_precio, item_cantidad
ORDER BY item_cantidad DESC

/*14. Escriba una consulta que retorne una estadística de ventas por cliente. Los campos que debe retornar son:
Código del cliente
Cantidad de veces que compro en el último año
Promedio por compra en el último año
Cantidad de productos diferentes que compro en el último año
Monto de la mayor compra que realizo en el último año
Se deberán retornar todos los clientes ordenados por la cantidad de veces que compro en
el último año.
No se deberán visualizar NULLs en ninguna columna*/
SELECT clie_codigo, COUNT(fact_cliente) AS [Cantidad de Compras],
SUM(fact_total + fact_total_impuestos) / COUNT(fact_cliente) AS [Promedio por Compra],
COUNT(DISTINCT item_producto) AS [Productos Diferentes],
MAX(fact_total + fact_total_impuestos) AS [Mayor Compra]
FROM Cliente c JOIN Factura f ON f.fact_cliente = c.clie_codigo
			   JOIN Item_Factura i ON i.item_numero = f.fact_numero
--WHERE f.fact_fecha >= DATEADD(YEAR, -1, GETDATE()) no hay fechas actuales en la base
GROUP BY clie_codigo, f.fact_fecha
HAVING f.fact_fecha >= DATEADD(YEAR, -1, MAX(fact_fecha))
ORDER BY [Cantidad de Compras] DESC

/*15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. El resultado debe mostrar el código y
descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. El resultado debe estar ordenado por la cantidad de veces que se vendieron
juntos dichos productos. Los distintos pares no deben retornarse más de una vez.*/
SELECT p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle, COUNT(*) VecesVendidos
FROM Item_Factura i1 JOIN Item_Factura i2 ON i2.item_numero = i1.item_numero AND i1.item_producto < i2.item_producto
					 JOIN Producto p1 ON p1.prod_codigo = i1.item_producto
					 JOIN Producto p2 ON p2.prod_codigo = i2.item_producto
GROUP BY p1.prod_codigo, p1.prod_detalle, p2.prod_codigo, p2.prod_detalle
HAVING COUNT(*) > 500
ORDER BY VecesVendidos

/*16. Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
Además mostrar
1. Nombre del Cliente
2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
mostrar solamente el de menor código) para ese cliente.
Aclaraciones:
La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
productos no compuestos.
Los clientes deben ser ordenados por código de provincia ascendente.*/
SELECT c.clie_razon_social, c.clie_codigo,
ISNULL(SUM(i.item_cantidad), 0) AS UnidadesVendidasEn2012,
ISNULL((SELECT TOP 1 i3.item_producto FROM Item_Factura i3 JOIN Factura f3 ON f3.fact_tipo = i3.item_tipo AND
																       f3.fact_sucursal = i3.item_sucursal AND
																       f3.fact_numero = i3.item_numero
WHERE f3.fact_cliente = c.clie_codigo AND YEAR(f3.fact_fecha) = 2012 
GROUP BY i3.item_producto, i3.item_cantidad
ORDER BY SUM(i3.item_cantidad) DESC), 0) AS ProductoMayorVenta2012
FROM Cliente c JOIN Factura f ON f.fact_cliente = c.clie_codigo
			   JOIN Item_Factura i ON i.item_tipo = f.fact_tipo AND
									  i.item_sucursal = f.fact_sucursal AND
									  i.item_numero = f.fact_numero
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY c.clie_razon_social, c.clie_codigo, c.clie_domicilio
HAVING SUM(i.item_cantidad * i.item_precio) <
(SELECT TOP 1 SUM(i2.item_cantidad * i2.item_precio)
 FROM Item_Factura i2 JOIN Factura f2 ON f2.fact_tipo = i2.item_tipo AND 
										 f2.fact_sucursal = i2.item_sucursal AND 
										 f2.fact_numero = i2.item_numero
 WHERE YEAR(f2.fact_fecha) = 2012
 GROUP BY i2.item_cantidad, item_precio
 ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC) / 3
ORDER BY c.clie_domicilio

/*17. Escriba una consulta que retorne una estadística de ventas por año y mes para cada
producto.
La consulta debe retornar:
PERIODO: Año y mes de la estadística con el formato YYYYMM
PROD: Código de producto
DETALLE: Detalle del producto
CANTIDAD_VENDIDA= Cantidad vendida del producto en el periodo
VENTAS_AÑO_ANT= Cantidad vendida del producto en el mismo mes del periodo
pero del año anterior
CANT_FACTURAS= Cantidad de facturas en las que se vendió el producto en el
periodo
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por periodo y código de producto.*/

/*18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.
*/
SELECT 
    r.rubr_detalle AS DETALLE_RUBRO,

    -- Suma total de ventas del rubro
    ISNULL(SUM(i.item_cantidad * i.item_precio),0) AS VENTAS,

    -- Producto más vendido
    ISNULL((
        SELECT TOP 1 p1.prod_codigo
        FROM Producto p1
        JOIN Item_Factura i1 ON i1.item_producto = p1.prod_codigo
        JOIN Factura f1 ON f1.fact_numero = i1.item_numero
        WHERE p1.prod_rubro = r.rubr_id
        GROUP BY p1.prod_codigo
        ORDER BY SUM(i1.item_cantidad * i1.item_precio) DESC
    ),0) AS PROD1,

    -- Segundo producto más vendido
    ISNULL((
        SELECT TOP 1 p2.prod_codigo
        FROM Producto p2
        JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo
        JOIN Factura f2 ON f2.fact_numero = i2.item_numero
        WHERE p2.prod_rubro = r.rubr_id
          AND p2.prod_codigo NOT IN (
              SELECT TOP 1 p3.prod_codigo
              FROM Producto p3
              JOIN Item_Factura i3 ON i3.item_producto = p3.prod_codigo
              JOIN Factura f3 ON f3.fact_numero = i3.item_numero
              WHERE p3.prod_rubro = r.rubr_id
              GROUP BY p3.prod_codigo
              ORDER BY SUM(i3.item_cantidad * i3.item_precio) DESC
          )
        GROUP BY p2.prod_codigo
        ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC
    ),0) AS PROD2,

    -- Cliente top de los últimos 30 días
    ISNULL((
        SELECT TOP 1 f4.fact_cliente
        FROM Producto p4
        JOIN Item_Factura i4 ON i4.item_producto = p4.prod_codigo
        JOIN Factura f4 ON f4.fact_numero = i4.item_numero
        WHERE p4.prod_rubro = r.rubr_id
          AND f4.fact_fecha >= DATEADD(DAY, -30, 2012-07-16)
        GROUP BY f4.fact_cliente
        ORDER BY SUM(i4.item_cantidad) DESC
    ),0) AS CLIENTE

FROM Rubro r
JOIN Producto p ON p.prod_rubro = r.rubr_id
JOIN Item_Factura i ON i.item_producto = p.prod_codigo
JOIN Factura f ON f.fact_numero = i.item_numero
GROUP BY r.rubr_id, r.rubr_detalle
ORDER BY COUNT(DISTINCT p.prod_codigo) DESC;

/*19. En virtud de una recategorizacion de productos referida a la familia de los mismos se
solicita que desarrolle una consulta sql que retorne para todos los productos:
? Codigo de producto
? Detalle del producto
? Codigo de la familia del producto
? Detalle de la familia actual del producto
? Codigo de la familia sugerido para el producto
? Detalla de la familia sugerido para el producto
La familia sugerida para un producto es la que poseen la mayoria de los productos cuyo
detalle coinciden en los primeros 5 caracteres.
En caso que 2 o mas familias pudieran ser sugeridas se debera seleccionar la de menor
codigo. Solo se deben mostrar los productos para los cuales la familia actual sea
diferente a la sugerida
Los resultados deben ser ordenados por detalle de producto de manera ascendente*/
select * from Producto
select * from Familia
SELECT 
    p.prod_codigo,
    p.prod_detalle,
    p.prod_familia,
    f.fami_detalle AS FamiliaActual,
    MIN(f2.fami_id) AS CodigoFamiliaSugerida,
    MIN(f2.fami_detalle) AS DetalleFamiliaSugerida
FROM Producto p
JOIN Familia f ON p.prod_familia = f.fami_id
JOIN Producto p2 ON LEFT(p2.prod_detalle,5) = LEFT(p.prod_detalle,5)
JOIN Familia f2 ON p2.prod_familia = f2.fami_id
GROUP BY 
    p.prod_codigo,
    p.prod_detalle,
    p.prod_familia,
    f.fami_detalle
HAVING p.prod_familia <> 
       MIN(f2.fami_id)
ORDER BY p.prod_detalle ASC;

/*20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que
hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
facturas en el año el calculo del puntaje sera el 50% de cantidad de facturas realizadas
por sus subordinados directos en dicho año.*/
select top 3 e.empl_codigo, e.empl_nombre + ' ' + e.empl_apellido, YEAR(e.empl_ingreso),
CASE 
    WHEN SUM(CASE WHEN YEAR(f.fact_fecha) = 2011 THEN 1 ELSE 0 END) >= 50
        THEN SUM(CASE WHEN YEAR(f.fact_fecha) = 2011 AND f.fact_total > 100 THEN 1 ELSE 0 END)
    ELSE CAST(0.5 * SUM(CASE WHEN YEAR(fs.fact_fecha) = 2011 THEN 1 ELSE 0 END) AS INT) END AS puntaje2011,
CASE 
    WHEN SUM(CASE WHEN YEAR(f.fact_fecha) = 2012 THEN 1 ELSE 0 END) >= 50
        THEN SUM(CASE WHEN YEAR(f.fact_fecha) = 2012 AND f.fact_total > 100 THEN 1 ELSE 0 END)
    ELSE CAST(0.5 * SUM(CASE WHEN YEAR(fs.fact_fecha) = 2012 THEN 1 ELSE 0 END) AS INT) END AS puntaje2012
from Empleado e left join Factura f on f.fact_vendedor = e.empl_codigo
				left join Empleado e2 on e2.empl_jefe = e.empl_codigo
				left join Factura fs on fs.fact_vendedor = e2.empl_codigo
group by e.empl_codigo, e.empl_nombre, e.empl_apellido, e.empl_ingreso
order by puntaje2012 desc

/*21. Escriba una consulta sql que retorne para todos los años, en los cuales se haya hecho al
menos una factura, la cantidad de clientes a los que se les facturo de manera incorrecta
al menos una factura y que cantidad de facturas se realizaron de manera incorrecta. Se
considera que una factura es incorrecta cuando la diferencia entre el total de la factura
menos el total de impuesto tiene una diferencia mayor a $ 1 respecto a la sumatoria de
los costos de cada uno de los items de dicha factura. Las columnas que se deben mostrar
son:
 Año
 Clientes a los que se les facturo mal en ese año
 Facturas mal realizadas en ese año*/
select * from Factura
select * from Item_Factura

SELECT
    YEAR(f.fact_fecha) AS anio,
    COUNT(DISTINCT CASE 
        WHEN ABS(f.fact_total - f.fact_total_impuestos - i.item_precio) > 1
        THEN f.fact_cliente END) AS ClientesMalFacturados, -- si se cumple la condicione devuelve el codigo del cliente y desp lo cuenta
    COUNT(DISTINCT CASE 
        WHEN ABS(f.fact_total - f.fact_total_impuestos - i.item_precio) > 1
        THEN f.fact_numero END) AS FacturasMalFacturadas
FROM Factura f JOIN Item_Factura i ON i.item_tipo = f.fact_tipo AND 
									  i.item_sucursal = f.fact_sucursal AND 
									  i.item_numero = f.fact_numero
GROUP BY YEAR(f.fact_fecha)
ORDER BY anio;

/*22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1
por cada trimestre).
Se deben mostrar 4 columnas:
 Detalle del rubro
 Numero de trimestre del año (1 a 4)
 Cantidad de facturas emitidas en el trimestre en las que se haya vendido al
menos un producto del rubro
 Cantidad de productos diferentes del rubro vendidos en el trimestre
El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
rubro primero el trimestre en el que mas facturas se emitieron.
No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas
no superen las 100.
En ningun momento se tendran en cuenta los productos compuestos para esta
estadistica*/
SELECT
    r.rubr_detalle,
    CEILING(MONTH(f.fact_fecha)/3.0) AS trimestre,
    COUNT(DISTINCT f.fact_numero) AS Facturas,
    COUNT(DISTINCT i.item_producto) AS Productos
FROM Rubro r
JOIN Producto p 
    ON p.prod_rubro = r.rubr_id
JOIN Item_Factura i 
    ON i.item_producto = p.prod_codigo
JOIN Factura f
    ON f.fact_numero = i.item_numero
   AND f.fact_tipo = i.item_tipo
   AND f.fact_sucursal = i.item_sucursal
GROUP BY
    r.rubr_detalle,
    CEILING(MONTH(f.fact_fecha)/3.0)
HAVING COUNT(DISTINCT f.fact_numero) > 100
ORDER BY
    r.rubr_detalle, trimestre,
    COUNT(DISTINCT f.fact_numero) DESC;

/*23. Realizar una consulta SQL que para cada año muestre :
 Año
 El producto con composición más vendido para ese año.
 Cantidad de productos que componen directamente al producto más vendido
 La cantidad de facturas en las cuales aparece ese producto.
 El código de cliente que más compro ese producto.
 El porcentaje que representa la venta de ese producto respecto al total de venta
del año.
El resultado deberá ser ordenado por el total vendido por año en forma descendente.*/
SELECT * FROM Composicion
SELECT f.fact_fecha, c.comp_producto AS CompMasVendido, COUNT(c.comp_producto) AS ProdsComp
FROM Factura f JOIN Item_Factura i ON i.item_tipo = f.fact_tipo AND
                                      i.item_sucursal = f.fact_sucursal AND
									  i.item_numero = f.fact_numero
			   JOIN Composicion c ON c.comp_producto = i.item_producto
WHERE c.comp_componente IN (SELECT TOP 1 c2.comp_producto FROM Composicion c2 JOIN Item_Factura i2 on i2.item_producto = c2.comp_producto
							GROUP BY c2.comp_producto, i2.item_cantidad
							ORDER BY SUM(i2.item_cantidad) DESC)
GROUP BY f.fact_fecha, c.comp_producto

/*26. Escriba una consulta sql que retorne un ranking de empleados devolviendo las
siguientes columnas:
 Empleado
 Depósitos que tiene a cargo
 Monto total facturado en el año corriente
 Codigo de Cliente al que mas le vendió
 Producto más vendido
 Porcentaje de la venta de ese empleado sobre el total vendido ese año.
Los datos deberan ser ordenados por venta del empleado de mayor a menor.
*/
SELECT * FROM Empleado
SELECT * FROM DEPOSITO
SELECT * FROM Factura

SELECT e.empl_codigo, COUNT(d.depo_encargado) AS DepsACargo, ISNULL(SUM(f.fact_total),0) MontoTotal,
ISNULL((SELECT TOP 1 f2.fact_cliente FROM Factura f2 WHERE f2.fact_vendedor = e.empl_codigo AND YEAR(f2.fact_fecha) =  2012
 GROUP BY f2.fact_cliente, f2.fact_total ORDER BY SUM(f2.fact_total) DESC), '-') AS ClienteAlQueMasVendio,
ISNULL((SELECT TOP 1 i.item_producto FROM Item_Factura i JOIN Factura f3 ON f3.fact_tipo = i.item_tipo AND
															  f3.fact_sucursal = i.item_sucursal AND
															  f3.fact_numero = i.item_numero
 WHERE f3.fact_vendedor = e.empl_codigo AND YEAR(f3.fact_fecha) = 2012
 GROUP BY i.item_producto
 ORDER BY SUM(i.item_precio * i.item_cantidad) DESC), '-') AS ProdMasVendido,
(SUM(ISNULL(f.fact_total, 0)) / (SELECT SUM(f5.fact_total) FROM Factura f5 WHERE YEAR(f5.fact_fecha) = 2012)) AS PorcentajeEmpleado
FROM Empleado e LEFT JOIN Factura f ON f.fact_vendedor = e.empl_codigo AND YEAR(f.fact_fecha) = 2012
				LEFT JOIN DEPOSITO d ON depo_encargado = e.empl_codigo
GROUP BY e.empl_codigo, d.depo_encargado
ORDER BY e.empl_codigo

/*24. Escriba una consulta que considerando solamente las facturas correspondientes a los
dos vendedores con mayores comisiones, retorne los productos con composición
facturados al menos en cinco facturas,
La consulta debe retornar las siguientes columnas:
 Código de Producto
 Nombre del Producto
 Unidades facturadas
El resultado deberá ser ordenado por las unidades facturadas descendente*/
SELECT c.comp_componente, p.prod_detalle, SUM(i.item_cantidad) AS UnidadesFacturadas
FROM Composicion c JOIN Producto p ON p.prod_codigo = c.comp_componente
				   JOIN Item_Factura i ON i.item_producto = c.comp_componente
				   JOIN Factura f ON f.fact_sucursal = i.item_sucursal AND
									 f.fact_tipo = i.item_tipo AND
									 f.fact_numero = i.item_numero
WHERE f.fact_vendedor IN (
SELECT TOP 2 e.empl_codigo FROM Empleado e JOIN Factura f2 ON f2.fact_vendedor = e.empl_codigo
GROUP BY e.empl_codigo, e.empl_comision
ORDER BY SUM(f2.fact_total) * ISNULL(e.empl_comision, 0) DESC)
GROUP BY c.comp_componente, p.prod_detalle
HAVING COUNT(DISTINCT f.fact_numero) >= 5
ORDER BY SUM(i.item_cantidad) DESC

/*25. Realizar una consulta SQL que para cada año y familia muestre :
a. Año
b. El código de la familia más vendida en ese año.
c. Cantidad de Rubros que componen esa familia.
d. Cantidad de productos que componen directamente al producto más vendido de
esa familia.
e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa
familia.
f. El código de cliente que más compro productos de esa familia.
g. El porcentaje que representa la venta de esa familia respecto al total de venta
del año.
El resultado deberá ser ordenado por el total vendido por año y familia en forma
descendente.*/
SELECT 
 YEAR(fac.fact_fecha) AS Año, 
 fam.fami_id, 
 COUNT(DISTINCT p.prod_rubro) AS RubrosFamilia, 
 (SELECT TOP 1 SUM(i3.item_cantidad) FROM Item_Factura i3 JOIN Producto p3 ON p3.prod_codigo = i3.item_producto
  WHERE p3.prod_familia = fam.fami_id
  GROUP BY p3.prod_codigo
  ORDER BY SUM(i3.item_cantidad) DESC) AS ProdMasVendido,
 COUNT(DISTINCT fac.fact_numero) AS FacturasFamilia,
 (SELECT TOP 1 c.clie_codigo FROM Cliente c JOIN Factura fac3 ON c.clie_codigo = fac3.fact_cliente
									 JOIN Item_Factura i4 ON i4.item_tipo = fac3.fact_tipo AND
															 i4.item_sucursal = fac3.fact_sucursal AND
															 i4.item_numero = fac3.fact_numero
									 JOIN Producto p4 ON p4.prod_codigo = i4.item_producto
 WHERE p4.prod_familia = fam.fami_id AND YEAR(fac3.fact_fecha) = YEAR(fac.fact_fecha)
 GROUP BY c.clie_codigo
 ORDER BY SUM(i4.item_cantidad * i4.item_precio) DESC) AS MejorClienteFamilia
FROM Factura fac JOIN Item_Factura i ON i.item_tipo = fac.fact_tipo AND
										i.item_sucursal = fac.fact_sucursal AND
										i.item_numero = fac.fact_numero
				 JOIN Producto p ON p.prod_codigo = i.item_producto
				 JOIN Rubro r ON r.rubr_id = p.prod_rubro
				 JOIN Familia fam ON fam.fami_id = p.prod_familia
GROUP BY YEAR(fac.fact_fecha), fam.fami_id
HAVING fam.fami_id IN (
SELECT TOP 1 fam2.fami_id FROM Familia fam2 JOIN Producto p2 ON p2.prod_familia = fam2.fami_id
											JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo
											JOIN Factura fac2 ON fac2.fact_tipo = i2.item_tipo AND
																 fac2.fact_sucursal = i2.item_sucursal AND
																 fac2.fact_numero = i2.item_numero
WHERE YEAR(fac2.fact_fecha) = YEAR(fac.fact_fecha)
GROUP BY fam2.fami_id
ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC)
ORDER BY SUM(i.item_precio * i.item_cantidad), fam.fami_id DESC

/*26. Escriba una consulta sql que retorne un ranking de empleados devolviendo las
siguientes columnas:
 Empleado
 Depósitos que tiene a cargo
 Monto total facturado en el año corriente
 Codigo de Cliente al que mas le vendió
 Producto más vendido
 Porcentaje de la venta de ese empleado sobre el total vendido ese año.
Los datos deberan ser ordenados por venta del empleado de mayor a menor.*/
SELECT * FROM DEPOSITO
SELECT e1.empl_codigo, (
        SELECT STRING_AGG(CONVERT(VARCHAR(MAX), d.depo_codigo), ',')
        FROM DEPOSITO d
        WHERE d.depo_encargado = e1.empl_codigo
    ) AS Depositos, ISNULL(SUM(f1.fact_total), 0) AS MontoTotal,
(SELECT TOP 1 c1.clie_codigo FROM Cliente c1 JOIN Factura f2 ON f2.fact_cliente = c1.clie_codigo AND f2.fact_vendedor = e1.empl_codigo
											 JOIN Item_Factura i ON i.item_tipo = f2.fact_tipo AND
																	i.item_sucursal = f2.fact_sucursal AND
																	i.item_numero = f2.fact_numero
 GROUP BY c1.clie_codigo
 ORDER BY SUM(i.item_cantidad * i.item_precio) DESC) AS MejorCliente,
(SELECT TOP 1 i2.item_producto FROM Item_Factura i2 JOIN Factura f3 ON i2.item_tipo = f3.fact_tipo AND
																	i2.item_sucursal = f3.fact_sucursal AND
																	i2.item_numero = f3.fact_numero
 WHERE f3.fact_vendedor = e1.empl_codigo
 GROUP BY i2.item_producto
 ORDER BY SUM(i2.item_cantidad) DESC) AS MejorProducto,
    ISNULL(SUM(f1.fact_total), 0) * 100.0 / 
        (SELECT SUM(f4.fact_total) FROM Factura f4) AS PorcentajeVenta
FROM Empleado e1 JOIN Factura f1 ON e1.empl_codigo = f1.fact_vendedor
GROUP BY e1.empl_codigo
ORDER BY SUM(f1.fact_total) DESC --muchos nulls, depositos?

/*27. Escriba una consulta sql que retorne una estadística basada en la facturacion por año y
envase devolviendo las siguientes columnas:
 Año
 Codigo de envase
 Detalle del envase
 Cantidad de productos que tienen ese envase
 Cantidad de productos facturados de ese envase
 Producto mas vendido de ese envase
 Monto total de venta de ese envase en ese año
 Porcentaje de la venta de ese envase respecto al total vendido de ese año
Los datos deberan ser ordenados por año y dentro del año por el envase con más
facturación de mayor a menor*/
SELECT YEAR(f1.fact_fecha) AS Año, e1.enva_detalle, COUNT(p1.prod_codigo) AS ProdsEnvase, SUM(i1.item_cantidad) AS FactsEnvase,
(SELECT TOP 1 p2.prod_codigo FROM Producto p2 JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo
											  JOIN Factura f2 ON f2.fact_tipo = i2.item_tipo AND
																 f2.fact_sucursal = i2.item_sucursal AND
																 f2.fact_numero = i2.item_numero
 WHERE YEAR(f2.fact_fecha) = YEAR(f1.fact_fecha) AND p2.prod_envase = e1.enva_codigo
 GROUP BY p2.prod_codigo
 ORDER BY SUM(i2.item_cantidad) DESC) AS MejorProdEnv,
SUM(i1.item_cantidad * i1.item_precio) AS MontoTotalEnv
FROM Envases e1 JOIN Producto p1 ON p1.prod_envase = e1.enva_codigo
				JOIN Item_Factura i1 ON i1.item_producto = p1.prod_codigo
				JOIN Factura f1 ON f1.fact_tipo = i1.item_tipo AND
								   f1.fact_sucursal = i1.item_sucursal AND
								   f1.fact_numero = i1.item_numero
GROUP BY YEAR(f1.fact_fecha), e1.enva_codigo, e1.enva_detalle
ORDER BY YEAR(f1.fact_fecha), SUM(i1.item_cantidad * i1.item_precio) DESC

/*28. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
 Año.
 Codigo de Vendedor
 Detalle del Vendedor
 Cantidad de facturas que realizó en ese año
 Cantidad de clientes a los cuales les vendió en ese año.
 Cantidad de productos facturados con composición en ese año
 Cantidad de productos facturados sin composicion en ese año.
 Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.*/
SELECT * FROM Factura

SELECT YEAR(f1.fact_fecha) AS Año, e1.empl_codigo, e1.empl_nombre + ' ' + e1.empl_apellido AS DetalleVendedor,
COUNT(DISTINCT CONCAT ... ) AS FacturasVendedor,
ISNULL(SUM(CASE WHEN c1.comp_componente IS NOT NULL THEN i1.item_cantidad ELSE 0 END), 0) AS ProdsComp,
ISNULL(SUM(CASE WHEN c1.comp_componente IS NULL THEN i1.item_cantidad ELSE 0 END), 0) AS ProdsNoComp,
ISNULL(SUM(i1.item_precio * i1.item_cantidad), 0) AS MontoVendedor
FROM Empleado e1 JOIN Factura f1 ON f1.fact_vendedor = e1.empl_codigo
				 JOIN Item_Factura i1 ON i1.item_tipo = f1.fact_tipo AND
									     i1.item_sucursal = f1.fact_sucursal AND
										 i1.item_numero = f1.fact_numero
				 JOIN Composicion c1 ON c1.comp_componente = i1.item_producto
GROUP BY YEAR(f1.fact_fecha), e1.empl_codigo, e1.empl_nombre, e1.empl_apellido
ORDER BY YEAR(f1.fact_fecha), e1.empl_codigo, COUNT(DISTINCT i1.item_producto)

/*29. Se solicita que realice una estadística de venta por producto para el año 2011, solo para
los productos que pertenezcan a las familias que tengan más de 20 productos asignados
a ellas, la cual deberá devolver las siguientes columnas:
a. Código de producto
b. Descripción del producto
c. Cantidad vendida
d. Cantidad de facturas en la que esta ese producto
e. Monto total facturado de ese producto
Solo se deberá mostrar un producto por fila en función a los considerandos establecidos
antes. El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor*/
SELECT * FROM Producto
SELECT * FROM Familia

SELECT p1.prod_codigo, p1.prod_detalle, SUM(i1.item_cantidad) AS CantidadVendida,
COUNT(DISTINCT f1.fact_numero) AS CantidadFacturas, 
SUM(i1.item_cantidad * i1.item_precio) AS MontoTotal
FROM Producto p1 JOIN Item_Factura i1 ON i1.item_producto = p1.prod_codigo
				 JOIN Factura f1 ON f1.fact_tipo = i1.item_tipo AND
									f1.fact_sucursal = i1.item_sucursal AND
									f1.fact_numero = i1.item_numero
WHERE YEAR(f1.fact_fecha) = 2011 AND p1.prod_familia IN (SELECT f1.fami_id FROM Familia f1 JOIN Producto p2 ON p2.prod_familia = f1.fami_id
																	JOIN Item_Factura i2 ON i2.item_producto = p2.prod_codigo
				                                                    JOIN Factura f2 ON f2.fact_tipo = i2.item_tipo AND
									                                                   f2.fact_sucursal = i2.item_sucursal AND
									                                                   f2.fact_numero = i2.item_numero
							WHERE YEAR(f2.fact_fecha) = 2011
							GROUP BY f1.fami_id, p2.prod_familia
							HAVING COUNT(p2.prod_codigo) > 20)
GROUP BY p1.prod_codigo, p1.prod_detalle
ORDER BY SUM(i1.item_cantidad * i1.item_precio) DESC

/*30. Se desea obtener una estadistica de ventas del año 2012, para los empleados que sean
jefes, o sea, que tengan empleados a su cargo, para ello se requiere que realice la
consulta que retorne las siguientes columnas:
 Nombre del Jefe
 Cantidad de empleados a cargo
 Monto total vendido de los empleados a cargo
 Cantidad de facturas realizadas por los empleados a cargo
 Nombre del empleado con mejor ventas de ese jefe
Debido a la perfomance requerida, solo se permite el uso de una subconsulta si fuese
necesario.
Los datos deberan ser ordenados por de mayor a menor por el Total vendido y solo se
deben mostrarse los jefes cuyos subordinados hayan realizado más de 10 facturas.*/
SELECT * FROM Empleado
SELECT e1.empl_nombre, COUNT(DISTINCT e2.empl_codigo) AS empleadosAcargo, SUM(i1.item_precio * i1.item_cantidad) AS MontoEmpleados,
COUNT(DISTINCT f1.fact_tipo + '-' + CAST(f1.fact_sucursal AS VARCHAR) + '-' + CAST(f1.fact_numero AS VARCHAR)) AS CantidadFacturas,
(SELECT TOP 1 e3.empl_nombre FROM Empleado e3 JOIN Factura f2 ON f2.fact_vendedor = e3.empl_codigo
											  JOIN Item_Factura i2 ON i2.item_tipo = f2.fact_tipo AND
																	  i2.item_sucursal = f2.fact_sucursal AND
																	  i2.item_numero = f2.fact_numero
 WHERE YEAR(f2.fact_fecha) = 2012 AND e3.empl_jefe = e1.empl_codigo
 GROUP BY e3.empl_nombre
 ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC) AS MejorEmpleado
FROM Empleado e1 JOIN Empleado e2 ON e2.empl_jefe = e1.empl_codigo
				 LEFT JOIN Factura f1 ON f1.fact_vendedor = e2.empl_codigo AND YEAR(f1.fact_fecha) = 2012
				 LEFT JOIN Item_Factura i1 ON i1.item_tipo = f1.fact_tipo AND
										 i1.item_sucursal = f1.fact_sucursal AND
										 i1.item_numero = f1.fact_numero
GROUP BY e1.empl_nombre, e1.empl_codigo
HAVING COUNT(DISTINCT CONCAT(f1.fact_tipo, f1.fact_sucursal, f1.fact_numero)) > 10
ORDER BY SUM(i1.item_precio * i1.item_cantidad) DESC


SELECT 
    e1.empl_nombre AS NombreJefe,
    COUNT(DISTINCT e2.empl_codigo) AS EmpleadosACargo, -- ahora sí cuenta todos
    SUM(i1.item_precio * i1.item_cantidad) AS MontoTotalVendido,
    COUNT(DISTINCT f1.fact_tipo + '-' + CAST(f1.fact_sucursal AS VARCHAR) + '-' + CAST(f1.fact_numero AS VARCHAR)) AS CantidadFacturas,
    (
        SELECT TOP 1 e3.empl_nombre
        FROM Empleado e3
        JOIN Factura f2 
            ON f2.fact_vendedor = e3.empl_codigo
        JOIN Item_Factura i2 
            ON i2.item_tipo = f2.fact_tipo
           AND i2.item_sucursal = f2.fact_sucursal
           AND i2.item_numero = f2.fact_numero
        WHERE YEAR(f2.fact_fecha) = 2012
          AND e3.empl_jefe = e1.empl_codigo
        GROUP BY e3.empl_nombre
        ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC
    ) AS MejorEmpleado
FROM Empleado e1
JOIN Empleado e2 
    ON e2.empl_jefe = e1.empl_codigo
LEFT JOIN Factura f1 
    ON f1.fact_vendedor = e2.empl_codigo
   AND YEAR(f1.fact_fecha) = 2012
LEFT JOIN Item_Factura i1 
    ON i1.item_tipo = f1.fact_tipo
   AND i1.item_sucursal = f1.fact_sucursal
   AND i1.item_numero = f1.fact_numero
GROUP BY e1.empl_nombre, e1.empl_codigo
HAVING COUNT(DISTINCT f1.fact_tipo + '-' + CAST(f1.fact_sucursal AS VARCHAR) + '-' + CAST(f1.fact_numero AS VARCHAR)) > 10
ORDER BY SUM(i1.item_precio * i1.item_cantidad) DESC;


/*
31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
 Año.
 Codigo de Vendedor
 Detalle del Vendedor
 Cantidad de facturas que realizó en ese año
 Cantidad de clientes a los cuales les vendió en ese año.
 Cantidad de productos facturados con composición en ese año
 Cantidad de productos facturados sin composicion en ese año.
 Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.
*/
SELECT 
    YEAR(f.fact_fecha) AS Anio,
    f.fact_vendedor,
    e.empl_nombre + ' ' + e.empl_apellido AS Detalle_Vendedor,
    COUNT(DISTINCT CONCAT(f.fact_tipo, f.fact_sucursal, f.fact_numero)) AS Cantidad_Facturas,
    COUNT(DISTINCT f.fact_cliente) AS Cantidad_Clientes,
    COUNT(DISTINCT CASE WHEN c.comp_producto IS NOT NULL THEN i.item_producto END) AS ProductosConComposicion,
    COUNT(DISTINCT CASE WHEN c.comp_producto IS NULL THEN i.item_producto END) AS ProductosSinComposicion,
    SUM(i.item_precio * i.item_cantidad) AS MontoTotal
    
FROM Factura f
JOIN Item_Factura i 
  ON i.item_tipo = f.fact_tipo 
 AND i.item_sucursal = f.fact_sucursal 
 AND i.item_numero = f.fact_numero
JOIN Empleado e 
  ON e.empl_codigo = f.fact_vendedor
LEFT JOIN Composicion c 
  ON c.comp_producto = i.item_producto  

GROUP BY 
    YEAR(f.fact_fecha), f.fact_vendedor, e.empl_nombre, e.empl_apellido

ORDER BY 
    YEAR(f.fact_fecha),
    COUNT(DISTINCT i.item_producto) DESC;

/*32. Se desea conocer las familias que sus productos se facturaron juntos en las mismas
facturas para ello se solicita que escriba una consulta sql que retorne los pares de
familias que tienen productos que se facturaron juntos. Para ellos deberá devolver las
siguientes columnas:
 Código de familia
 Detalle de familia
 Código de familia
 Detalle de familia
 Cantidad de facturas
 Total vendido
Los datos deberan ser ordenados por Total vendido y solo se deben mostrar las familias
que se vendieron juntas más de 10 veces.*/
SELECT f1.fami_id, f1.fami_detalle, f2.fami_id, f2.fami_detalle, 
COUNT(DISTINCT fa1.fact_tipo + '-' + CAST(fa1.fact_sucursal AS VARCHAR) + '-' + CAST(fa1.fact_numero AS VARCHAR)) AS CantidadFacturas,
SUM(i1.item_cantidad * i1.item_precio) + SUM(i2.item_cantidad * i2.item_precio)AS TotalVendido
FROM Familia f1 JOIN Producto p1 ON p1.prod_familia = f1.fami_id
			    JOIN Item_Factura i1 ON i1.item_producto = p1.prod_codigo
				JOIN Factura fa1 ON fa1.fact_tipo = i1.item_tipo AND
									fa1.fact_sucursal = i1.item_sucursal AND
									fa1.fact_numero = i1.item_numero
				JOIN Item_Factura i2 ON fa1.fact_tipo = i2.item_tipo AND
									fa1.fact_sucursal = i2.item_sucursal AND
									fa1.fact_numero = i2.item_numero
				JOIN Producto p2 ON p2.prod_codigo = i2.item_producto
				JOIN Familia f2 ON f2.fami_id = p2.prod_familia
WHERE f1.fami_id < f2.fami_id
GROUP BY f1.fami_id, f1.fami_detalle, f2.fami_id, f2.fami_detalle
HAVING COUNT(DISTINCT fa1.fact_tipo + '-' + CAST(fa1.fact_sucursal AS VARCHAR) + '-' + CAST(fa1.fact_numero AS VARCHAR)) > 10
ORDER BY SUM(i1.item_cantidad * i1.item_precio) + SUM(i2.item_cantidad * i2.item_precio)

/*33. Se requiere obtener una estadística de venta de productos que sean componentes. Para
ello se solicita que realiza la siguiente consulta que retorne la venta de los
componentes del producto más vendido del año 2012. Se deberá mostrar:
a. Código de producto
b. Nombre del producto
c. Cantidad de unidades vendidas
d. Cantidad de facturas en la cual se facturo
e. Precio promedio facturado de ese producto.
f. Total facturado para ese producto
El resultado deberá ser ordenado por el total vendido por producto para el año 2012.*/
SELECT p1.prod_codigo, p1.prod_detalle, SUM(i1.item_cantidad) AS UnidadesVendidas,
COUNT(DISTINCT f1.fact_tipo + '-' + CAST(f1.fact_sucursal AS VARCHAR) + '-' + CAST(f1.fact_numero AS VARCHAR)) CantidadFacturas,
SUM(i1.item_precio * i1.item_cantidad)/SUM(i1.item_cantidad) AS Promedio,
SUM(i1.item_precio * i1.item_cantidad) AS TotalFacturado
FROM Producto p1 JOIN Item_Factura i1 ON i1.item_producto = p1.prod_codigo
				 JOIN Factura f1 ON f1.fact_tipo = i1.item_tipo AND
									f1.fact_sucursal = i1.item_sucursal AND
									f1.fact_numero = i1.item_numero
				 JOIN Composicion c1 ON c1.comp_producto = p1.prod_codigo
WHERE YEAR(f1.fact_fecha) = 2012 AND c1.comp_producto IN(
SELECT TOP 1 c2.comp_componente FROM Composicion c2 JOIN Item_Factura i2 ON i2.item_producto = c2.comp_producto
													JOIN Factura f2 ON f2.fact_tipo = i2.item_tipo AND
																	   f2.fact_sucursal = i2.item_sucursal AND
																	   f2.fact_numero = i2.item_numero
WHERE YEAR(f2.fact_fecha) = 2012
GROUP BY c2.comp_componente
ORDER BY SUM(i2.item_cantidad))
GROUP BY p1.prod_codigo, p1.prod_detalle
ORDER BY SUM(i1.item_precio * i1.item_cantidad)

/*34
Escriba una consulta sql que retorne para todos los rubros la cantidad de facturas mal
facturadas por cada mes del año 2011 
Se considera que una factura es incorrecta cuando
en la misma factura se factutan productos de dos rubros diferentes. Si no hay facturas

mal hechas se debe retornar 0. Las columnas que se deben mostrar son:
    1- Codigo de Rubro
    2- Mes
    3- Cantidad de facturas mal realizadas.
*/
SELECT 
    r.rubr_id,
    MONTH(f.fact_fecha) AS Mes,
    COUNT(DISTINCT f.fact_tipo + '-' + f.fact_sucursal + '-' + CAST(f.fact_numero AS VARCHAR)) AS FacturasMalRealizadas
FROM Rubro r
JOIN Producto p 
    ON p.prod_rubro = r.rubr_id
JOIN Item_Factura i 
    ON i.item_producto = p.prod_codigo
JOIN Factura f 
    ON f.fact_tipo = i.item_tipo
   AND f.fact_sucursal = i.item_sucursal
   AND f.fact_numero = i.item_numero
WHERE YEAR(f.fact_fecha) = 2011
  AND f.fact_numero IN (
        SELECT i2.item_numero
        FROM Item_Factura i2
        JOIN Producto p2 ON p2.prod_codigo = i2.item_producto
        WHERE i2.item_tipo = f.fact_tipo
          AND i2.item_sucursal = f.fact_sucursal
          AND i2.item_numero = f.fact_numero
        GROUP BY i2.item_tipo, i2.item_sucursal, i2.item_numero
        HAVING COUNT(DISTINCT p2.prod_rubro) > 1
   )
GROUP BY r.rubr_id, MONTH(f.fact_fecha)
ORDER BY r.rubr_id, Mes;
