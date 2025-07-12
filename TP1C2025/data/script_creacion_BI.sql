-- CREACION DEL ESQUEMA PARA EL MODELO DE BI
CREATE SCHEMA BI_LOS_QUE_SABEN_SABEN; -- creacion del esquema
GO

-- ============================================================================
-- CREACION DE TABLAS DE DIMENSIONES
-- ============================================================================

-- dimension tiempo: almacena la informacion de fechas
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo (
    ID_Tiempo INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Anio INT NOT NULL,
    Cuatrimestre TINYINT NOT NULL,
    Mes TINYINT NOT NULL,
    Nombre_Mes NVARCHAR(20) NOT NULL
);
GO

-- dimension ubicacion: para almacenar provincias y localidades
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion (
    ID_Ubicacion INT PRIMARY KEY IDENTITY,
    Provincia NVARCHAR(255) NOT NULL,
    Localidad NVARCHAR(255) NOT NULL
);
GO

-- dimension sucursal: informacion de sucursales y su ubicacion
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal (
    ID_Sucursal_BI INT PRIMARY KEY IDENTITY,
    ID_Sucursal_Original BIGINT NOT NULL,
    Nombre_Sucursal NVARCHAR(255) NOT NULL,
    ID_Ubicacion INT NOT NULL,
    FOREIGN KEY (ID_Ubicacion) REFERENCES BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion(ID_Ubicacion) -- vinculacion con ubicacion
);
GO

-- dimension rango etario: rangos de edad
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Rango_Etario (
    ID_Rango_Etario INT PRIMARY KEY IDENTITY,
    Rango NVARCHAR(50) NOT NULL
);
GO

-- dimension turno: turnos de trabajo
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Turno (
    ID_Turno INT PRIMARY KEY IDENTITY,
    Turno NVARCHAR(50) NOT NULL
);
GO

-- dimension tipo material: clasificacion de materiales
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tipo_Material (
    ID_Tipo_Material_BI INT PRIMARY KEY IDENTITY,
    ID_Tipo_Material_Original INT NOT NULL,
    Nombre NVARCHAR(255) NOT NULL
);
GO

-- dimension modelo sillon: modelos de sillones
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Modelo_Sillon (
    ID_Modelo_Sillon_BI INT PRIMARY KEY IDENTITY,
    ID_Modelo_Original BIGINT NOT NULL,
    Nombre_Modelo NVARCHAR(255) NULL
);
GO

-- dimension estado pedido: estados de los pedidos
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Dim_Estado_Pedido (
    ID_Estado_Pedido INT PRIMARY KEY IDENTITY,
    Estado NVARCHAR(255) NOT NULL
);
GO

-- ============================================================================
-- CREACION DE TABLAS DE HECHOS
-- ============================================================================

-- hechos ventas: metricas de ventas
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Ventas (
    ID_Tiempo INT,
    ID_Sucursal_BI INT,
    ID_Rango_Etario INT,
    ID_Modelo_Sillon_BI INT,
    ID_Turno INT,
    Total_Venta DECIMAL(18, 2),
    Cantidad_Vendida INT,
    Tiempo_Fabricacion_Dias INT
);
GO

-- hechos pedidos: metricas de pedidos
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Pedidos (
    ID_Tiempo INT,
    ID_Sucursal_BI INT,
    ID_Estado_Pedido INT,
    ID_Turno INT,
    Cantidad_Pedidos INT
);
GO

-- hechos compras: metricas de compras
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Compras (
    ID_Tiempo INT,
    ID_Sucursal_BI INT,
    ID_Tipo_Material_BI INT,
    Total_Compra DECIMAL(18, 2)
);
GO

-- hechos envios: metricas de envios
CREATE TABLE BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Envios (
    ID_Tiempo_Programado INT,
    ID_Ubicacion_Cliente INT,
    Costo_Envio_Total DECIMAL(18, 2),
    Flag_En_Termino BIT
);
GO

-- ============================================================================
-- CREACION DE PROCEDIMIENTOS DE MIGRACION (ETL)
-- ============================================================================

-- procedimiento para migrar datos a las dimensiones
CREATE PROCEDURE BI_LOS_QUE_SABEN_SABEN.Migrar_Dimensiones
AS
BEGIN

    DECLARE @StartDate DATE, @EndDate DATE;

    -- calculo de fechas minima y maxima para llenar la dimension tiempo
    SELECT
        @StartDate = MIN(fecha),
        @EndDate = MAX(fecha)
    FROM (
        SELECT Pedido_Fecha AS fecha FROM gd_esquema.Maestra WHERE Pedido_Fecha IS NOT NULL
        UNION ALL
        SELECT Factura_Fecha FROM gd_esquema.Maestra WHERE Factura_Fecha IS NOT NULL
        UNION ALL
        SELECT Compra_Fecha FROM gd_esquema.Maestra WHERE Compra_Fecha IS NOT NULL
        UNION ALL
        SELECT Envio_Fecha_Programada FROM gd_esquema.Maestra WHERE Envio_Fecha_Programada IS NOT NULL
    ) AS Fechas;

    -- llenado de la dimension tiempo dia por dia
    WHILE @StartDate <= @EndDate
    BEGIN
        INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo (
            ID_Tiempo,
            Fecha,
            Anio,
            Cuatrimestre,
            Mes,
            Nombre_Mes
        )
        VALUES (
            YEAR(@StartDate) * 10000 + MONTH(@StartDate) * 100 + DAY(@StartDate), -- generacion de id de tiempo (AAAAMMDD)
            @StartDate,
            YEAR(@StartDate),
            (MONTH(@StartDate) - 1) / 4 + 1, -- calculo del cuatrimestre
            MONTH(@StartDate),
            FORMAT(@StartDate, 'MMMM', 'es-es') -- nombre del mes en espanol
        );
        SET @StartDate = DATEADD(DAY, 1, @StartDate);
    END;

    -- migracion de ubicaciones unicas
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion (Provincia, Localidad)
    SELECT DISTINCT
        p.Nombre,
        l.Nombre
    FROM
        LOS_QUE_SABEN_SABEN.Localidad l
    JOIN
        LOS_QUE_SABEN_SABEN.Provincia p ON l.Id_Provincia = p.Id_Provincia;

    -- migracion de sucursales y su vinculacion a la ubicacion
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal (ID_Sucursal_Original, Nombre_Sucursal, ID_Ubicacion)
    SELECT
        s.ID_Sucursal,
        s.Nombre,
        u.ID_Ubicacion
    FROM
        LOS_QUE_SABEN_SABEN.Sucursal s
    JOIN
        LOS_QUE_SABEN_SABEN.Localidad l ON s.Id_Localidad = l.Id_Localidad
    JOIN
        LOS_QUE_SABEN_SABEN.Provincia p ON l.Id_Provincia = p.Id_Provincia
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion u ON u.Localidad = l.Nombre AND u.Provincia = p.Nombre;

    -- insercion de rangos etarios fijos
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Rango_Etario (Rango)
    VALUES
        ('< 25'),
        ('25 - 35'),
        ('35 - 50'),
        ('> 50'),
        ('S/D');

    -- insercion de turnos fijos
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Turno (Turno)
    VALUES
        ('08:00 - 14:00'),
        ('14:00 - 20:00'),
        ('Fuera de Horario');

    -- migracion de tipos de material
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tipo_Material (ID_Tipo_Material_Original, Nombre)
    SELECT
        ID_Tipo_Material,
        Nombre
    FROM
        LOS_QUE_SABEN_SABEN.Tipo_Material;

    -- migracion de modelos de sillon
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Modelo_Sillon (ID_Modelo_Original, Nombre_Modelo)
    SELECT
        ID_Modelo_Sillon,
        Descripcion
    FROM
        LOS_QUE_SABEN_SABEN.Modelo_Sillon;

    -- migracion de estados de pedido unicos
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Dim_Estado_Pedido (Estado)
    SELECT DISTINCT
        Estado
    FROM
        LOS_QUE_SABEN_SABEN.Pedido
    WHERE
        Estado IS NOT NULL; -- considera solo los estados con valor
END;
GO

-- procedimiento para migrar datos a las tablas de hechos
CREATE PROCEDURE BI_LOS_QUE_SABEN_SABEN.Migrar_Hechos
AS
BEGIN
    -- insercion de hechos de ventas, con calculo de totales, cantidades y tiempo de fabricacion
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Ventas (
        ID_Tiempo,
        ID_Sucursal_BI,
        ID_Rango_Etario,
        ID_Modelo_Sillon_BI,
        ID_Turno,
        Total_Venta,
        Cantidad_Vendida,
        Tiempo_Fabricacion_Dias
    )
    SELECT
        t.ID_Tiempo,
        s.ID_Sucursal_BI,
        re.ID_Rango_Etario,
        ms.ID_Modelo_Sillon_BI,
        turno.ID_Turno,
        SUM(df.Subtotal) AS Total_Venta,
        SUM(df.Cantidad) AS Cantidad_Vendida,
        AVG(DATEDIFF(DAY, p.Fecha, f.Fecha)) AS Tiempo_Fabricacion_Dias
    FROM
        LOS_QUE_SABEN_SABEN.Factura f
    JOIN
        LOS_QUE_SABEN_SABEN.Detalle_Factura df ON f.ID_Factura = df.ID_Factura
    JOIN
        LOS_QUE_SABEN_SABEN.Detalle_Pedido dp ON df.ID_Detalle_Pedido = dp.ID_Detalle_Pedido
    JOIN
        LOS_QUE_SABEN_SABEN.Sillon sillon ON dp.ID_Sillon = sillon.ID_Sillon
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Modelo_Sillon ms ON sillon.ID_Modelo_Sillon = ms.ID_Modelo_Original
    JOIN
        LOS_QUE_SABEN_SABEN.Pedido p ON f.ID_Pedido = p.ID_Pedido
    JOIN
        LOS_QUE_SABEN_SABEN.Cliente c ON f.ID_Cliente = c.ID_Cliente
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON f.ID_Sucursal = s.ID_Sucursal_Original
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON t.Fecha = CONVERT(DATE, f.Fecha)
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Rango_Etario re ON re.ID_Rango_Etario = CASE
            WHEN DATEDIFF(YEAR, c.Fecha_Nacimiento, f.Fecha) < 25 THEN 1
            WHEN DATEDIFF(YEAR, c.Fecha_Nacimiento, f.Fecha) BETWEEN 25 AND 35 THEN 2
            WHEN DATEDIFF(YEAR, c.Fecha_Nacimiento, f.Fecha) BETWEEN 36 AND 50 THEN 3
            WHEN DATEDIFF(YEAR, c.Fecha_Nacimiento, f.Fecha) > 50 THEN 4
            ELSE 5
        END
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Turno turno ON turno.ID_Turno = CASE
            WHEN DATEPART(HOUR, f.Fecha) BETWEEN 8 AND 13 THEN 1
            WHEN DATEPART(HOUR, f.Fecha) BETWEEN 14 AND 19 THEN 2
            ELSE 3
        END
    GROUP BY
        t.ID_Tiempo,
        s.ID_Sucursal_BI,
        re.ID_Rango_Etario,
        ms.ID_Modelo_Sillon_BI,
        turno.ID_Turno;

    -- insercion de hechos de pedidos
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Pedidos (
        ID_Tiempo,
        ID_Sucursal_BI,
        ID_Estado_Pedido,
        ID_Turno,
        Cantidad_Pedidos
    )
    SELECT
        t.ID_Tiempo,
        s.ID_Sucursal_BI,
        ep.ID_Estado_Pedido,
        turno.ID_Turno,
        COUNT(p.ID_Pedido) AS Cantidad_Pedidos
    FROM
        LOS_QUE_SABEN_SABEN.Pedido p
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON p.ID_Sucursal = s.ID_Sucursal_Original
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON t.Fecha = CONVERT(DATE, p.Fecha)
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Estado_Pedido ep ON p.Estado = ep.Estado
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Turno turno ON turno.ID_Turno = CASE
            WHEN DATEPART(HOUR, p.Fecha) BETWEEN 8 AND 13 THEN 1
            WHEN DATEPART(HOUR, p.Fecha) BETWEEN 14 AND 19 THEN 2
            ELSE 3
        END
    GROUP BY
        t.ID_Tiempo,
        s.ID_Sucursal_BI,
        ep.ID_Estado_Pedido,
        turno.ID_Turno;

    -- insercion de hechos de compras
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Compras (
        ID_Tiempo,
        ID_Sucursal_BI,
        ID_Tipo_Material_BI,
        Total_Compra
    )
    SELECT
        t.ID_Tiempo,
        s.ID_Sucursal_BI,
        tm.ID_Tipo_Material_BI,
        SUM(dc.Subtotal) AS Total_Compra
    FROM
        LOS_QUE_SABEN_SABEN.Compra c
    JOIN
        LOS_QUE_SABEN_SABEN.Detalle_Compra dc ON c.ID_Compra = dc.ID_Compra
    JOIN
        LOS_QUE_SABEN_SABEN.Material m ON dc.ID_Material = m.ID_Material
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tipo_Material tm ON m.Id_Tipo_Material = tm.ID_Tipo_Material_Original
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON c.ID_Sucursal = s.ID_Sucursal_Original
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON t.Fecha = CONVERT(DATE, c.Fecha)
    GROUP BY
        t.ID_Tiempo,
        s.ID_Sucursal_BI,
        tm.ID_Tipo_Material_BI;

    -- insercion de hechos de envios, con el indicador de entrega en termino
    INSERT INTO BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Envios (
        ID_Tiempo_Programado,
        ID_Ubicacion_Cliente,
        Costo_Envio_Total,
        Flag_En_Termino
    )
    SELECT
        t.ID_Tiempo,
        u.ID_Ubicacion,
        e.Total,
        CASE
            WHEN e.Fecha_Entrega <= e.Fecha_Programada THEN 1
            ELSE 0
        END AS Flag_En_Termino
    FROM
        LOS_QUE_SABEN_SABEN.Envio e
    JOIN
        LOS_QUE_SABEN_SABEN.Factura f ON e.ID_Factura = f.ID_Factura
    JOIN
        LOS_QUE_SABEN_SABEN.Cliente c ON f.ID_Cliente = c.ID_Cliente
    JOIN
        LOS_QUE_SABEN_SABEN.Localidad l_cliente ON c.Id_Localidad = l_cliente.Id_Localidad
    JOIN
        LOS_QUE_SABEN_SABEN.Provincia p_cliente ON c.Id_Provincia = p_cliente.Id_Provincia
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion u ON l_cliente.Nombre = u.Localidad AND p_cliente.Nombre = u.Provincia
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON t.Fecha = CONVERT(DATE, e.Fecha_Programada)
    WHERE
        e.Fecha_Entrega IS NOT NULL -- se consideran solo envios con fecha de entrega
        AND e.Fecha_Programada IS NOT NULL; -- y fecha programada
END;
GO

-- procedimiento principal para ejecutar la migracion completa del modelo de BI
CREATE PROCEDURE BI_LOS_QUE_SABEN_SABEN.Migracion_BI_Completa
AS
BEGIN
    EXEC BI_LOS_QUE_SABEN_SABEN.Migrar_Dimensiones; -- ejecucion de la migracion de dimensiones
    EXEC BI_LOS_QUE_SABEN_SABEN.Migrar_Hechos; -- ejecucion de la migracion de hechos
END;
GO

-- ============================================================================
-- EJECUCION DEL PROCESO DE MIGRACION COMPLETA
-- ============================================================================

-- ejecucion del procedimiento de migracion completa
EXEC BI_LOS_QUE_SABEN_SABEN.Migracion_BI_Completa;
GO

-- ============================================================================
-- CREACION DE VISTAS PARA LOS INDICADORES DE NEGOCIO
-- ============================================================================

-- vista para calcular las ganancias mensuales por sucursal
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Ganancias
AS
SELECT
    t.Anio,
    t.Mes,
    s.Nombre_Sucursal,
    ISNULL(Ventas.Total_Ingresos, 0) - ISNULL(Compras.Total_Egresos, 0) AS Ganancia -- calculo de ganancias (ingresos - egresos)
FROM
    (SELECT DISTINCT Anio, Mes FROM BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo) t -- obtencion de todos los anios y meses
CROSS JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s -- combinacion con todas las sucursales
LEFT JOIN
    (
        SELECT
            t.Anio,
            t.Mes,
            hv.ID_Sucursal_BI,
            SUM(hv.Total_Venta) AS Total_Ingresos -- suma de las ventas
        FROM
            BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Ventas hv
        JOIN
            BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
        GROUP BY
            t.Anio,
            t.Mes,
            hv.ID_Sucursal_BI
    ) AS Ventas ON t.Anio = Ventas.Anio AND t.Mes = Ventas.Mes AND s.ID_Sucursal_BI = Ventas.ID_Sucursal_BI
LEFT JOIN
    (
        SELECT
            t.Anio,
            t.Mes,
            hc.ID_Sucursal_BI,
            SUM(hc.Total_Compra) AS Total_Egresos -- suma de las compras
        FROM
            BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Compras hc
        JOIN
            BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hc.ID_Tiempo = t.ID_Tiempo
        GROUP BY
            t.Anio,
            t.Mes,
            hc.ID_Sucursal_BI
    ) AS Compras ON t.Anio = Compras.Anio AND t.Mes = Compras.Mes AND s.ID_Sucursal_BI = Compras.ID_Sucursal_BI;
GO

-- vista para el valor promedio de factura mensual por cuatrimestre y provincia
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Factura_Promedio_Mensual
AS
SELECT
    t.Anio,
    t.Cuatrimestre,
    u.Provincia,
    SUM(hv.Total_Venta) / COUNT(DISTINCT f.ID_Factura) AS Valor_Promedio_Factura -- calculo del promedio
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Ventas hv
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hv.ID_Sucursal_BI = s.ID_Sucursal_BI
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion u ON s.ID_Ubicacion = u.ID_Ubicacion
JOIN
    LOS_QUE_SABEN_SABEN.Factura f ON s.ID_Sucursal_Original = f.ID_Sucursal AND CONVERT(DATE, f.Fecha) = t.Fecha -- union con la tabla de facturas original
GROUP BY
    t.Anio,
    t.Cuatrimestre,
    u.Provincia;
GO

-- vista para el rendimiento de modelos de sillones (top 3 por localidad, anio, cuatrimestre y rango etario)
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Rendimiento_Modelos
AS
WITH VentasModelo AS ( -- CTE para el calculo de ventas por modelo y su ranking
    SELECT
        t.Anio,
        t.Cuatrimestre,
        u.Localidad,
        re.Rango,
        ms.Nombre_Modelo,
        SUM(hv.Total_Venta) AS TotalVendido,
        ROW_NUMBER() OVER( -- definicion del ranking por particion (anio, cuatrimestre, localidad, rango etario)
            PARTITION BY t.Anio, t.Cuatrimestre, u.Localidad, re.Rango
            ORDER BY SUM(hv.Total_Venta) DESC
        ) AS rn
    FROM
        BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Ventas hv
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hv.ID_Sucursal_BI = s.ID_Sucursal_BI
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion u ON s.ID_Ubicacion = u.ID_Ubicacion
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Rango_Etario re ON hv.ID_Rango_Etario = re.ID_Rango_Etario
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Modelo_Sillon ms ON hv.ID_Modelo_Sillon_BI = ms.ID_Modelo_Sillon_BI
    GROUP BY
        t.Anio,
        t.Cuatrimestre,
        u.Localidad,
        re.Rango,
        ms.Nombre_Modelo
)
SELECT
    Anio,
    Cuatrimestre,
    Localidad,
    Rango,
    Nombre_Modelo,
    TotalVendido
FROM
    VentasModelo
WHERE
    rn <= 3; -- filtrado para obtener los top 3 modelos
GO

-- vista para el volumen de pedidos registrados por anio, mes, sucursal y turno
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Volumen_Pedidos
AS
SELECT
    t.Anio,
    t.Mes,
    s.Nombre_Sucursal,
    turno.Turno,
    SUM(hp.Cantidad_Pedidos) AS Cantidad_Pedidos_Registrados -- suma de la cantidad de pedidos
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Pedidos hp
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hp.ID_Tiempo = t.ID_Tiempo
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hp.ID_Sucursal_BI = s.ID_Sucursal_BI
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Turno turno ON hp.ID_Turno = turno.ID_Turno
WHERE
    turno.ID_Turno IN (1, 2)
GROUP BY
    t.Anio,
    t.Mes,
    s.Nombre_Sucursal,
    turno.Turno;
GO

-- vista para la tasa de conversion de pedidos por sucursal, anio y cuatrimestre
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Conversion_Pedidos
AS
WITH PedidosTotales AS ( -- CTE para el calculo del total de pedidos por sucursal, anio y cuatrimestre
    SELECT
        t.Anio,
        t.Cuatrimestre,
        s.ID_Sucursal_BI,
        SUM(hp.Cantidad_Pedidos) AS TotalPedidos
    FROM
        BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Pedidos hp
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hp.ID_Tiempo = t.ID_Tiempo
    JOIN
        BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hp.ID_Sucursal_BI = s.ID_Sucursal_BI
    GROUP BY
        t.Anio,
        t.Cuatrimestre,
        s.ID_Sucursal_BI
)
SELECT
    t.Anio,
    t.Cuatrimestre,
    s.Nombre_Sucursal,
    ep.Estado,
    SUM(hp.Cantidad_Pedidos) AS CantidadPorEstado,
    (SUM(CAST(hp.Cantidad_Pedidos AS FLOAT)) * 100.0) / pt.TotalPedidos AS Porcentaje -- calculo del porcentaje de pedidos por estado
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Pedidos hp
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hp.ID_Tiempo = t.ID_Tiempo
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hp.ID_Sucursal_BI = s.ID_Sucursal_BI
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Estado_Pedido ep ON hp.ID_Estado_Pedido = ep.ID_Estado_Pedido
JOIN
    PedidosTotales pt ON pt.Anio = t.Anio
                      AND pt.Cuatrimestre = t.Cuatrimestre
                      AND pt.ID_Sucursal_BI = s.ID_Sucursal_BI
GROUP BY
    t.Anio,
    t.Cuatrimestre,
    s.Nombre_Sucursal,
    ep.Estado,
    pt.TotalPedidos;
GO

-- vista para el tiempo promedio de fabricacion por anio, cuatrimestre y sucursal
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Tiempo_Promedio_Fabricacion
AS
SELECT
    t.Anio,
    t.Cuatrimestre,
    s.Nombre_Sucursal,
    AVG(hv.Tiempo_Fabricacion_Dias) AS Dias_Promedio_Fabricacion -- calculo del promedio de dias de fabricacion
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Ventas hv
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hv.ID_Tiempo = t.ID_Tiempo
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hv.ID_Sucursal_BI = s.ID_Sucursal_BI
GROUP BY
    t.Anio,
    t.Cuatrimestre,
    s.Nombre_Sucursal;
GO

-- vista para el importe promedio de compras mensuales
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Promedio_Compras
AS
SELECT
    t.Anio,
    t.Mes,
    AVG(hc.Total_Compra) AS Importe_Promedio_Compra -- calculo del promedio de compra
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Compras hc
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hc.ID_Tiempo = t.ID_Tiempo
GROUP BY
    t.Anio,
    t.Mes;
GO

-- vista para el gasto total por tipo de material, anio, cuatrimestre y sucursal
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Compras_Por_Tipo_Material
AS
SELECT
    t.Anio,
    t.Cuatrimestre,
    s.Nombre_Sucursal,
    tm.Nombre AS Tipo_Material,
    SUM(hc.Total_Compra) AS Total_Gastado -- suma del total gastado
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Compras hc
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON hc.ID_Tiempo = t.ID_Tiempo
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Sucursal s ON hc.ID_Sucursal_BI = s.ID_Sucursal_BI
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tipo_Material tm ON hc.ID_Tipo_Material_BI = tm.ID_Tipo_Material_BI
GROUP BY
    t.Anio,
    t.Cuatrimestre,
    s.Nombre_Sucursal,
    tm.Nombre;
GO

-- vista para el porcentaje de cumplimiento de envios por anio y mes
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Cumplimiento_Envios
AS
SELECT
    t.Anio,
    t.Mes,
    (SUM(CAST(he.Flag_En_Termino AS FLOAT)) * 100.0) / COUNT(*) AS Porcentaje_Cumplimiento -- calculo del porcentaje
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Envios he
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Tiempo t ON he.ID_Tiempo_Programado = t.ID_Tiempo
GROUP BY
    t.Anio,
    t.Mes;
GO

-- vista para las 3 localidades con mayor costo promedio de envio
CREATE VIEW BI_LOS_QUE_SABEN_SABEN.V_Localidades_Mayor_Costo_Envio
AS
SELECT TOP 3 -- seleccion de las 3 primeras localidades
    u.Localidad,
    u.Provincia,
    AVG(he.Costo_Envio_Total) AS Promedio_Costo_Envio -- calculo del promedio del costo
FROM
    BI_LOS_QUE_SABEN_SABEN.BI_Hechos_Envios he
JOIN
    BI_LOS_QUE_SABEN_SABEN.BI_Dim_Ubicacion u ON he.ID_Ubicacion_Cliente = u.ID_Ubicacion
GROUP BY
    u.Localidad,
    u.Provincia
ORDER BY
    Promedio_Costo_Envio DESC; -- ordenamiento por el costo promedio descendente
GO
