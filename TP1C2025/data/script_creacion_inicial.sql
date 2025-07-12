-- creacion del esquema base
CREATE SCHEMA LOS_QUE_SABEN_SABEN;
GO

-- ============================================================================
-- creacion de tablas
-- ============================================================================

-- tabla para guardar las provincias
CREATE TABLE LOS_QUE_SABEN_SABEN.Provincia (
    Id_Provincia INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(255) NOT NULL
);

-- tabla para guardar las localidades, vinculada a provincias
CREATE TABLE LOS_QUE_SABEN_SABEN.Localidad (
    Id_Localidad INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(255) NOT NULL,
    Id_Provincia INT NOT NULL,
    FOREIGN KEY (Id_Provincia) REFERENCES LOS_QUE_SABEN_SABEN.Provincia(Id_Provincia)
);

-- tabla para guardar los clientes
CREATE TABLE LOS_QUE_SABEN_SABEN.Cliente (
    ID_Cliente INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(255) NOT NULL,
    Apellido NVARCHAR(255) NOT NULL,
    Dni BIGINT NULL,
    Fecha_Nacimiento DATETIME2 NULL,
    Mail NVARCHAR(255),
    Direccion NVARCHAR(255),
    Telefono NVARCHAR(255),
    Id_Provincia INT,
    Id_Localidad INT,
    FOREIGN KEY (Id_Provincia) REFERENCES LOS_QUE_SABEN_SABEN.Provincia(Id_Provincia),
    FOREIGN KEY (Id_Localidad) REFERENCES LOS_QUE_SABEN_SABEN.Localidad(Id_Localidad)
);

-- tabla para guardar las sucursales
CREATE TABLE LOS_QUE_SABEN_SABEN.Sucursal (
    ID_Sucursal BIGINT PRIMARY KEY,
    Nombre NVARCHAR(255) NOT NULL,
    Direccion NVARCHAR(255),
    Id_Localidad INT,
    Telefono NVARCHAR(255),
    Mail NVARCHAR(255),
    FOREIGN KEY (Id_Localidad) REFERENCES LOS_QUE_SABEN_SABEN.Localidad(Id_Localidad)
);

-- tabla para guardar los pedidos
CREATE TABLE LOS_QUE_SABEN_SABEN.Pedido (
    ID_Pedido DECIMAL PRIMARY KEY,
    ID_Sucursal BIGINT,
    ID_Cliente INT,
    Fecha DATETIME2 NULL,
    Estado NVARCHAR(255),
    Total DECIMAL NULL,
    FOREIGN KEY (ID_Sucursal) REFERENCES LOS_QUE_SABEN_SABEN.Sucursal(ID_Sucursal),
    FOREIGN KEY (ID_Cliente) REFERENCES LOS_QUE_SABEN_SABEN.Cliente(ID_Cliente)
);

-- tabla para guardar las cancelaciones de pedidos
CREATE TABLE LOS_QUE_SABEN_SABEN.PedidoCancelacion (
    ID_PedidoCancelacion INT PRIMARY KEY IDENTITY,
    ID_Pedido DECIMAL,
    Fecha DATETIME2 NULL,
    Motivo VARCHAR(255),
    FOREIGN KEY (ID_Pedido) REFERENCES LOS_QUE_SABEN_SABEN.Pedido(ID_Pedido)
);

-- tabla para guardar los modelos de sillon
CREATE TABLE LOS_QUE_SABEN_SABEN.Modelo_Sillon (
    ID_Modelo_Sillon BIGINT PRIMARY KEY,
    Descripcion NVARCHAR(255) NULL,
    Precio DECIMAL NULL
);

-- tabla para guardar las medidas de los sillones
CREATE TABLE LOS_QUE_SABEN_SABEN.Medida (
    ID_Medida INT PRIMARY KEY IDENTITY,
    Alto DECIMAL NULL,
    Ancho DECIMAL NULL,
    Profundidad DECIMAL NULL,
	Precio Decimal
);

-- tabla para guardar los sillones
CREATE TABLE LOS_QUE_SABEN_SABEN.Sillon (
    ID_Sillon BIGINT PRIMARY KEY,
    ID_Modelo_Sillon BIGINT,
    ID_Medida INT,
    FOREIGN KEY (ID_Modelo_Sillon) REFERENCES LOS_QUE_SABEN_SABEN.Modelo_Sillon(ID_Modelo_Sillon),
    FOREIGN KEY (ID_Medida) REFERENCES LOS_QUE_SABEN_SABEN.Medida(ID_Medida)
);

-- tabla para guardar el detalle de cada pedido
CREATE TABLE LOS_QUE_SABEN_SABEN.Detalle_Pedido (
    ID_Detalle_Pedido INT PRIMARY KEY IDENTITY,
    ID_Pedido DECIMAL,
    ID_Sillon BIGINT,
	ID_Medida INT NULL,
    Cant_Sillones BIGINT NULL,
    Precio_Unitario DECIMAL NULL,
    Subtotal DECIMAL NULL,
    FOREIGN KEY (ID_Pedido) REFERENCES LOS_QUE_SABEN_SABEN.Pedido(ID_Pedido),
    FOREIGN KEY (ID_Sillon) REFERENCES LOS_QUE_SABEN_SABEN.Sillon(ID_Sillon),
	FOREIGN KEY (ID_Medida) REFERENCES LOS_QUE_SABEN_SABEN.Medida(ID_Medida)
);

-- tabla para guardar las facturas
CREATE TABLE LOS_QUE_SABEN_SABEN.Factura (
    ID_Factura BIGINT PRIMARY KEY,
    ID_Cliente INT,
    ID_Sucursal BIGINT,
    ID_Pedido DECIMAL,
    Fecha DATETIME2 NULL,
    Total DECIMAL NULL,
    Estado NVARCHAR(50),
    FOREIGN KEY (ID_Cliente) REFERENCES LOS_QUE_SABEN_SABEN.Cliente(ID_Cliente),
    FOREIGN KEY (ID_Sucursal) REFERENCES LOS_QUE_SABEN_SABEN.Sucursal(ID_Sucursal),
    FOREIGN KEY (ID_Pedido) REFERENCES LOS_QUE_SABEN_SABEN.Pedido(ID_Pedido)
);

-- tabla para guardar el detalle de cada factura
CREATE TABLE LOS_QUE_SABEN_SABEN.Detalle_Factura (
    ID_Detalle_Factura INT PRIMARY KEY IDENTITY,
    ID_Factura BIGINT,
    ID_Detalle_Pedido INT,
    Cantidad DECIMAL NULL,
    Subtotal DECIMAL NULL,
    Precio DECIMAL NULL,
    FOREIGN KEY (ID_Factura) REFERENCES LOS_QUE_SABEN_SABEN.Factura(ID_Factura),
    FOREIGN KEY (ID_Detalle_Pedido) REFERENCES LOS_QUE_SABEN_SABEN.Detalle_Pedido(ID_Detalle_Pedido)
);

-- tabla para guardar los envios
CREATE TABLE LOS_QUE_SABEN_SABEN.Envio (
    ID_Envio DECIMAL  PRIMARY KEY,
    ID_Factura BIGINT,
    Fecha_Programada DATETIME2 NULL,
    Fecha_Entrega DATETIME2 NULL,
    Importe_Traslado DECIMAL NULL,
    Importe_Subida DECIMAL NULL,
    Total DECIMAL NULL,
    FOREIGN KEY (ID_Factura) REFERENCES LOS_QUE_SABEN_SABEN.Factura(ID_Factura)
);

-- tabla para guardar los tipos de material
CREATE TABLE LOS_QUE_SABEN_SABEN.Tipo_Material (
    ID_Tipo_Material INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(255)
);

-- tabla para guardar los materiales
CREATE TABLE LOS_QUE_SABEN_SABEN.Material (
    ID_Material INT IDENTITY(1,1) PRIMARY KEY,
    Id_Tipo_Material INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Precio_Adicional DECIMAL(10,2) NULL,
    Descripcion NVARCHAR(255) NULL,
	FOREIGN KEY (ID_Tipo_Material) REFERENCES LOS_QUE_SABEN_SABEN.Tipo_Material(ID_Tipo_Material)
);

-- tabla para guardar los detalles de tela
CREATE TABLE LOS_QUE_SABEN_SABEN.Tela (
    ID_Tela INT PRIMARY KEY IDENTITY,
    ID_Tipo_Material INT,
    Color NVARCHAR(255),
    Textura NVARCHAR(255),
    FOREIGN KEY (ID_Tipo_Material) REFERENCES LOS_QUE_SABEN_SABEN.Tipo_Material(ID_Tipo_Material)
);

-- tabla para guardar los detalles de madera
CREATE TABLE LOS_QUE_SABEN_SABEN.Madera (
    ID_Madera INT PRIMARY KEY IDENTITY,
    ID_Tipo_Material INT,
    Color NVARCHAR(255),
    Dureza NVARCHAR(255),
	Descripcion NVARCHAR(100),
    FOREIGN KEY (ID_Tipo_Material) REFERENCES LOS_QUE_SABEN_SABEN.Tipo_Material(ID_Tipo_Material)
);

-- tabla para guardar los detalles de relleno
CREATE TABLE LOS_QUE_SABEN_SABEN.Relleno (
    ID_Relleno INT PRIMARY KEY IDENTITY,
    ID_Tipo_Material INT,
    Densidad DECIMAL NULL,
    FOREIGN KEY (ID_Tipo_Material) REFERENCES LOS_QUE_SABEN_SABEN.Tipo_Material(ID_Tipo_Material)
);

-- tabla para guardar los proveedores
CREATE TABLE LOS_QUE_SABEN_SABEN.Proveedor (
    ID_Proveedor INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(255),
    CUIT NVARCHAR(255),
    Telefono NVARCHAR(255),
    Email NVARCHAR(255),
    Direccion NVARCHAR(255),
    Id_Localidad INT,
    Id_Provincia INT,
    Razon_Social NVARCHAR(255),
    FOREIGN KEY (Id_Localidad) REFERENCES LOS_QUE_SABEN_SABEN.Localidad(Id_Localidad),
    FOREIGN KEY (Id_Provincia) REFERENCES LOS_QUE_SABEN_SABEN.Provincia(Id_Provincia)
);

-- tabla para guardar las compras
CREATE TABLE LOS_QUE_SABEN_SABEN.Compra (
    ID_Compra DECIMAL PRIMARY KEY,
    ID_Sucursal BIGINT,
    ID_Proveedor INT,
    Fecha DATETIME2 NULL,
    Total DECIMAL NULL,
    FOREIGN KEY (ID_Sucursal) REFERENCES LOS_QUE_SABEN_SABEN.Sucursal(ID_Sucursal),
    FOREIGN KEY (ID_Proveedor) REFERENCES LOS_QUE_SABEN_SABEN.Proveedor(ID_Proveedor)
);

-- tabla para guardar el detalle de cada compra
CREATE TABLE LOS_QUE_SABEN_SABEN.Detalle_Compra (
    ID_Detalle_Compra INT PRIMARY KEY IDENTITY,
    ID_Compra DECIMAL,
    ID_Material INT,
    Precio_Unitario DECIMAL NULL,
    Cantidad DECIMAL NULL,
    Subtotal DECIMAL NULL,
    FOREIGN KEY (ID_Compra) REFERENCES LOS_QUE_SABEN_SABEN.Compra(ID_Compra),
    FOREIGN KEY (ID_Material) REFERENCES LOS_QUE_SABEN_SABEN.Material(ID_Material)
);

-- ============================================================================
-- creacion de stored procedures para migracion (etl)
-- ============================================================================

-- sp para migrar las provincias
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Provincias
AS
BEGIN
    SET NOCOUNT ON; -- para no mostrar el conteo de filas afectadas

    -- inserta provincias desde sucursal_provincia
    INSERT INTO LOS_QUE_SABEN_SABEN.Provincia (Nombre)
    SELECT DISTINCT Sucursal_Provincia FROM gd_esquema.Maestra WHERE Sucursal_Provincia IS NOT NULL
    EXCEPT
    SELECT Nombre FROM LOS_QUE_SABEN_SABEN.Provincia;

    -- inserta provincias desde cliente_provincia
    INSERT INTO LOS_QUE_SABEN_SABEN.Provincia (Nombre)
    SELECT DISTINCT Cliente_Provincia FROM gd_esquema.Maestra WHERE Cliente_Provincia IS NOT NULL
    EXCEPT
    SELECT Nombre FROM LOS_QUE_SABEN_SABEN.Provincia;

    -- inserta provincias desde proveedor_provincia
    INSERT INTO LOS_QUE_SABEN_SABEN.Provincia (Nombre)
    SELECT DISTINCT Proveedor_Provincia FROM gd_esquema.Maestra WHERE Proveedor_Provincia IS NOT NULL
    EXCEPT
    SELECT Nombre FROM LOS_QUE_SABEN_SABEN.Provincia;
END;

-- sp para migrar las localidades
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Localidades
AS
BEGIN
    SET NOCOUNT ON;

    -- inserta localidades de sucursal
    INSERT INTO LOS_QUE_SABEN_SABEN.Localidad (Nombre, Id_Provincia)
    SELECT DISTINCT
        tm.Sucursal_Localidad,
        p.Id_Provincia
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Provincia p ON p.Nombre = tm.Sucursal_Provincia
    WHERE tm.Sucursal_Localidad IS NOT NULL
    AND NOT EXISTS ( -- evita duplicados
        SELECT 1 FROM LOS_QUE_SABEN_SABEN.Localidad l
        WHERE l.Nombre = tm.Sucursal_Localidad AND l.Id_Provincia = p.Id_Provincia
    );

    -- inserta localidades de cliente
    INSERT INTO LOS_QUE_SABEN_SABEN.Localidad (Nombre, Id_Provincia)
    SELECT DISTINCT
        tm.Cliente_Localidad,
        p.Id_Provincia
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Provincia p ON p.Nombre = tm.Cliente_Provincia
    WHERE tm.Cliente_Localidad IS NOT NULL
    AND NOT EXISTS ( -- evita duplicados
        SELECT 1 FROM LOS_QUE_SABEN_SABEN.Localidad l
        WHERE l.Nombre = tm.Cliente_Localidad AND l.Id_Provincia = p.Id_Provincia
    );

    -- inserta localidades de proveedor
    INSERT INTO LOS_QUE_SABEN_SABEN.Localidad (Nombre, Id_Provincia)
    SELECT DISTINCT
        tm.Proveedor_Localidad,
        p.Id_Provincia
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Provincia p ON p.Nombre = tm.Proveedor_Provincia
    WHERE tm.Proveedor_Localidad IS NOT NULL
    AND NOT EXISTS ( -- evita duplicados
        SELECT 1 FROM LOS_QUE_SABEN_SABEN.Localidad l
        WHERE l.Nombre = tm.Proveedor_Localidad AND l.Id_Provincia = p.Id_Provincia
    );
END;

-- sp para migrar los clientes
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Clientes
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Cliente (
        Nombre, Apellido, Dni, Fecha_Nacimiento, Mail, Direccion, Telefono, Id_Provincia, Id_Localidad
    )
    SELECT DISTINCT
        tm.Cliente_Nombre,
        tm.Cliente_Apellido,
        tm.Cliente_Dni,
        tm.Cliente_FechaNacimiento,
        tm.Cliente_Mail,
        tm.Cliente_Direccion,
        tm.Cliente_Telefono,
        p.Id_Provincia,
        l.Id_Localidad
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Provincia p ON p.Nombre = tm.Cliente_Provincia
    JOIN LOS_QUE_SABEN_SABEN.Localidad l ON l.Nombre = tm.Cliente_Localidad AND l.Id_Provincia = p.Id_Provincia
    WHERE NOT EXISTS ( -- evita insertar clientes ya existentes por dni
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Cliente c
        WHERE c.Dni = tm.Cliente_Dni
    );
END;

-- sp para migrar las sucursales
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Sucursales
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Sucursal (
        ID_Sucursal,
        Nombre,
        Direccion,
        Id_Localidad,
        Telefono,
        Mail
    )
    SELECT DISTINCT
        tm.Sucursal_NroSucursal,
        CONCAT('Sucursal ', tm.Sucursal_NroSucursal), -- genera un nombre de sucursal
        tm.Sucursal_Direccion,
        l.Id_Localidad,
        tm.Sucursal_Telefono,
        tm.Sucursal_Mail
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Provincia p ON p.Nombre = tm.Sucursal_Provincia
    JOIN LOS_QUE_SABEN_SABEN.Localidad l ON l.Nombre = tm.Sucursal_Localidad AND l.Id_Provincia = p.Id_Provincia
    WHERE
        tm.Sucursal_NroSucursal IS NOT NULL
        AND tm.Sucursal_Direccion IS NOT NULL
        AND tm.Sucursal_Provincia IS NOT NULL
        AND tm.Sucursal_Localidad IS NOT NULL
        AND NOT EXISTS ( -- evita duplicados por id_sucursal
            SELECT 1
            FROM LOS_QUE_SABEN_SABEN.Sucursal s
            WHERE s.ID_Sucursal = tm.Sucursal_NroSucursal
        );
END;
GO

-- sp para migrar los pedidos
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Pedidos
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Pedido (
        ID_Pedido,
        ID_Sucursal,
        ID_Cliente,
        Fecha,
        Estado,
        Total
    )
    SELECT DISTINCT
        tm.Pedido_Numero,
        s.ID_Sucursal,
        c.ID_Cliente,
        tm.Pedido_Fecha,
        tm.Pedido_Estado,
        tm.Pedido_Total
    FROM
        gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Cliente c ON tm.Cliente_Dni = c.Dni
    JOIN LOS_QUE_SABEN_SABEN.Sucursal s ON tm.Sucursal_NroSucursal = s.ID_Sucursal
    WHERE
        tm.Pedido_Numero IS NOT NULL
        AND tm.Cliente_Dni IS NOT NULL
        AND tm.Sucursal_NroSucursal IS NOT NULL
    AND NOT EXISTS ( -- evita duplicados por id_pedido
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Pedido p
        WHERE p.ID_Pedido = tm.Pedido_Numero
    );
END;
GO

-- sp para migrar las cancelaciones de pedidos
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_PedidoCancelacion
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.PedidoCancelacion (
        ID_Pedido,
        Fecha,
        Motivo
    )
    SELECT
        p.ID_Pedido,
        CAST(tm.Pedido_Cancelacion_Fecha AS DATE), -- convierte la fecha a solo fecha
        tm.Pedido_Cancelacion_Motivo
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Pedido p
        ON p.ID_Pedido = tm.Pedido_Numero
    WHERE
       tm.Pedido_Cancelacion_Fecha IS NOT NULL -- solo si tiene fecha de cancelacion
        AND tm.Pedido_Numero IS NOT NULL
        AND tm.Pedido_Estado = 'CANCELADO' -- solo si el estado es cancelado
    AND NOT EXISTS ( -- evita duplicados de cancelaciones por id_pedido
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.PedidoCancelacion pc
        WHERE pc.ID_Pedido = p.ID_Pedido
    );
END;
GO

-- sp para migrar las facturas
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Facturas
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Factura (
        ID_Factura,
        ID_Pedido,
        ID_Cliente,
		ID_Sucursal,
        Fecha,
        Total
    )
    SELECT DISTINCT
        tm.Factura_Numero,
        p.ID_Pedido,
        c.ID_Cliente,
        s.ID_Sucursal,
        tm.Factura_Fecha,
        tm.Factura_Total
    FROM
        gd_esquema.Maestra tm
    INNER JOIN LOS_QUE_SABEN_SABEN.Pedido p ON tm.Pedido_Numero = p.ID_Pedido
    INNER JOIN LOS_QUE_SABEN_SABEN.Cliente c ON tm.Cliente_Dni = c.Dni
    INNER JOIN LOS_QUE_SABEN_SABEN.Sucursal s ON tm.Sucursal_NroSucursal = s.ID_Sucursal
    WHERE
        tm.Factura_Numero IS NOT NULL
        AND tm.Pedido_Numero IS NOT NULL
        AND tm.Factura_Fecha IS NOT NULL
        AND tm.Factura_Total IS NOT NULL
    AND NOT EXISTS ( -- evita insertar facturas ya existentes
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Factura f_existente
        WHERE f_existente.ID_Factura = tm.Factura_Numero
    );
END;
GO

-- sp para migrar los modelos de sillon
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Modelo_Sillon
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Modelo_Sillon (
        ID_Modelo_Sillon,
        Descripcion,
        Precio
    )
    SELECT DISTINCT
        tm.Sillon_Modelo_Codigo,
        tm.Sillon_Modelo_Descripcion,
		tm.Sillon_Modelo_Precio
    FROM gd_esquema.Maestra tm
    WHERE
        tm.Sillon_Modelo_Codigo IS NOT NULL
    AND NOT EXISTS ( -- evita insertar modelos de sillon ya existentes
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Modelo_Sillon ms
        WHERE ms.ID_Modelo_Sillon = tm.Sillon_Modelo_Codigo
    );
END;
GO

-- sp para migrar las medidas
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Medidas
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Medida (
        Alto,
        Ancho,
        Profundidad,
		Precio
    )
    SELECT DISTINCT
        tm.Sillon_Medida_Alto,
        tm.Sillon_Medida_Ancho,
        tm.Sillon_Medida_Profundidad,
		tm.Sillon_Medida_Precio
    FROM gd_esquema.Maestra tm
    WHERE
        tm.Sillon_Medida_Alto IS NOT NULL
        OR tm.Sillon_Medida_Ancho IS NOT NULL
        OR tm.Sillon_Medida_Profundidad IS NOT NULL
		OR tm.Sillon_Medida_Precio IS NOT NULL
    AND NOT EXISTS ( -- evita duplicados de medidas
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Medida m
        WHERE m.Alto = tm.Sillon_Medida_Alto
          AND m.Ancho = tm.Sillon_Medida_Ancho
          AND m.Profundidad = tm.Sillon_Medida_Profundidad
		  AND m.Precio = tm.Sillon_Medida_Precio
    );
END;
GO

-- sp para migrar los sillones
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Sillones
AS
BEGIN
    SET NOCOUNT ON;
    WITH SourceSillon AS ( -- selecciona una unica definicion por sillon_codigo
        SELECT
            tm.Sillon_Codigo,
            tm.Sillon_Modelo_Codigo,
            tm.Sillon_Medida_Alto,
            tm.Sillon_Medida_Ancho,
            tm.Sillon_Medida_Profundidad,
            ROW_NUMBER() OVER (
                PARTITION BY tm.Sillon_Codigo
                ORDER BY tm.Sillon_Modelo_Codigo, tm.Sillon_Medida_Alto, tm.Sillon_Medida_Ancho, tm.Sillon_Medida_Profundidad
            ) as rn
        FROM gd_esquema.Maestra tm
        WHERE tm.Sillon_Codigo IS NOT NULL
          AND tm.Sillon_Modelo_Codigo IS NOT NULL
          AND tm.Sillon_Medida_Alto IS NOT NULL
          AND tm.Sillon_Medida_Ancho IS NOT NULL
          AND tm.Sillon_Medida_Profundidad IS NOT NULL
    )
    INSERT INTO LOS_QUE_SABEN_SABEN.Sillon (ID_Sillon, ID_Modelo_Sillon, ID_Medida)
    SELECT
        ss.Sillon_Codigo,
        ms.ID_Modelo_Sillon,
        m.ID_Medida
    FROM SourceSillon ss
    JOIN LOS_QUE_SABEN_SABEN.Modelo_Sillon ms ON ss.Sillon_Modelo_Codigo = ms.ID_Modelo_Sillon
    JOIN LOS_QUE_SABEN_SABEN.Medida m ON ss.Sillon_Medida_Alto = m.Alto
                                     AND ss.Sillon_Medida_Ancho = m.Ancho
                                     AND ss.Sillon_Medida_Profundidad = m.Profundidad
    WHERE ss.rn = 1 -- toma solo la primera definicion por sillon_codigo
      AND NOT EXISTS ( -- evita duplicados
            SELECT 1
            FROM LOS_QUE_SABEN_SABEN.Sillon s_dest
            WHERE s_dest.ID_Sillon = ss.Sillon_Codigo
      );
END;
GO

-- sp para migrar el detalle de pedido
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_DetallePedido
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Detalle_Pedido (
        ID_Pedido,
        ID_Sillon,
        ID_Medida,
        Cant_Sillones,
        Precio_Unitario,
        Subtotal
    )
    SELECT DISTINCT
        p.ID_Pedido,
        s.ID_Sillon,
        s.ID_Medida,
        tm.Detalle_Pedido_Cantidad,
        tm.Detalle_Pedido_Precio,
        tm.Detalle_Pedido_SubTotal
    FROM
        gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Pedido p ON tm.Pedido_Numero = p.ID_Pedido
    JOIN LOS_QUE_SABEN_SABEN.Sillon s ON tm.Sillon_Codigo = s.ID_Sillon
    WHERE
        tm.Pedido_Numero IS NOT NULL
        AND tm.Sillon_Codigo IS NOT NULL
        AND tm.Detalle_Pedido_Cantidad IS NOT NULL
        AND tm.Detalle_Pedido_Precio IS NOT NULL
        AND tm.Detalle_Pedido_SubTotal IS NOT NULL
    AND NOT EXISTS ( -- evita duplicados por combinacion de id_pedido, id_sillon, cantidad y precio
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Detalle_Pedido dp
        WHERE dp.ID_Pedido = p.ID_Pedido
          AND dp.ID_Sillon = s.ID_Sillon
          AND dp.Cant_Sillones = tm.Detalle_Pedido_Cantidad
          AND dp.Precio_Unitario = tm.Detalle_Pedido_Precio
    );
END;
GO

-- sp para migrar el detalle de factura
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_DetalleFactura
AS
BEGIN
    SET NOCOUNT ON;

    WITH CTE_Detalles_Correlacionados AS ( -- correlaciona detalles de factura y pedido desde la maestra
        SELECT DISTINCT
            facturas.Factura_Numero,
            facturas.Pedido_Numero,
            facturas.Detalle_Factura_Cantidad,
            facturas.Detalle_Factura_SubTotal,
            facturas.Detalle_Factura_Precio,
            pedidos.Sillon_Codigo
        FROM
            gd_esquema.Maestra AS facturas
        INNER JOIN
            gd_esquema.Maestra AS pedidos
            ON facturas.Pedido_Numero = pedidos.Pedido_Numero
            AND facturas.Detalle_Factura_Cantidad = pedidos.Detalle_Pedido_Cantidad
            AND ABS(facturas.Detalle_Factura_Precio - pedidos.Detalle_Pedido_Precio) < 0.01 -- tolerancia para precios flotantes
        WHERE
            facturas.Factura_Numero IS NOT NULL
            AND facturas.Detalle_Factura_Cantidad IS NOT NULL
            AND pedidos.Sillon_Codigo IS NOT NULL
            AND pedidos.Detalle_Pedido_Cantidad IS NOT NULL
    )

    INSERT INTO LOS_QUE_SABEN_SABEN.Detalle_Factura (
        ID_Factura,
        ID_Detalle_Pedido,
        Cantidad,
        Subtotal,
        Precio
    )
    SELECT
        f.ID_Factura,
        dp.ID_Detalle_Pedido,
        tm.Detalle_Factura_Cantidad,
        tm.Detalle_Factura_SubTotal,
        tm.Detalle_Factura_Precio
    FROM
        CTE_Detalles_Correlacionados AS tm
    JOIN
        LOS_QUE_SABEN_SABEN.Factura f ON tm.Factura_Numero = f.ID_Factura
    JOIN
        LOS_QUE_SABEN_SABEN.Detalle_Pedido dp
        ON f.ID_Pedido = dp.ID_Pedido
        AND tm.Sillon_Codigo = dp.ID_Sillon
        AND tm.Detalle_Factura_Cantidad = dp.Cant_Sillones
    WHERE NOT EXISTS ( -- evita duplicados
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Detalle_Factura df_existente
        WHERE df_existente.ID_Factura = f.ID_Factura
          AND df_existente.ID_Detalle_Pedido = dp.ID_Detalle_Pedido
    );
END;
GO

-- sp para migrar los envios simplificado
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Envios_Simplificado
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Envio (
       ID_Envio,
       ID_Factura,
       Fecha_Programada,
       Fecha_Entrega,
       Importe_Traslado,
       Importe_Subida,
       Total
    )
    SELECT
        tm.Envio_Numero,
        tm.Factura_Numero,
        tm.Envio_Fecha_Programada,
        tm.Envio_Fecha,
        tm.Envio_ImporteTraslado,
        tm.Envio_importeSubida,
        tm.Envio_Total
    FROM gd_esquema.Maestra tm
    WHERE
        tm.Envio_Numero IS NOT NULL
        AND tm.Factura_Numero IS NOT NULL -- asegura que tenga un id de factura
        AND NOT EXISTS ( -- evita duplicados por id_factura
            SELECT 1
            FROM LOS_QUE_SABEN_SABEN.Envio e
            WHERE e.ID_Factura = tm.Factura_Numero
        );
END;

-- sp para migrar los proveedores
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Proveedores
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Proveedor (
        Nombre, CUIT, Telefono, Email, Direccion, Id_Localidad, Id_Provincia, Razon_Social
    )
    SELECT DISTINCT
        tm.Proveedor_RazonSocial,
        tm.Proveedor_Cuit,
        tm.Proveedor_Telefono,
        tm.Proveedor_Mail,
        tm.Proveedor_Direccion,
        l.Id_Localidad,
        p.Id_Provincia,
        tm.Proveedor_RazonSocial
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Provincia p ON p.Nombre = tm.Proveedor_Provincia
    JOIN LOS_QUE_SABEN_SABEN.Localidad l ON l.Nombre = tm.Proveedor_Localidad AND l.Id_Provincia = p.Id_Provincia
    WHERE NOT EXISTS ( -- evita insertar proveedores ya existentes por cuit
        SELECT 1 FROM LOS_QUE_SABEN_SABEN.Proveedor prov
        WHERE prov.CUIT = tm.Proveedor_Cuit
    );
END;

-- sp para migrar las compras
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Compras
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Compra (
    ID_Compra, ID_Sucursal, ID_Proveedor, Fecha, Total
)
SELECT
    tm.Compra_Numero,
    s.ID_Sucursal,
    prov.ID_Proveedor,
    tm.Compra_Fecha,
    tm.Compra_Total
FROM (
    SELECT DISTINCT Compra_Numero, sucursal_NroSucursal, Proveedor_Cuit, Compra_Fecha, Compra_Total
    FROM gd_esquema.Maestra
    WHERE Compra_Numero IS NOT NULL
) tm
JOIN LOS_QUE_SABEN_SABEN.Sucursal s
    ON s.ID_Sucursal = tm.sucursal_NroSucursal
JOIN LOS_QUE_SABEN_SABEN.Proveedor prov
    ON prov.CUIT = tm.Proveedor_Cuit
WHERE NOT EXISTS ( -- evita duplicados por numero de compra
    SELECT 1
    FROM LOS_QUE_SABEN_SABEN.Compra c
    WHERE CONVERT(VARCHAR, c.ID_Compra) = CONVERT(VARCHAR, tm.Compra_Numero)
);
END;

-- sp para migrar el detalle de compra
GO
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Detalle_Compra
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LOS_QUE_SABEN_SABEN.Detalle_Compra (
        ID_Compra,
        ID_Material,
        Precio_Unitario,
        Cantidad,
        Subtotal
    )
    SELECT
        c.ID_Compra,
        m.ID_Material,
        tm.Detalle_Compra_Precio,
        tm.Detalle_Compra_Cantidad,
        tm.Detalle_Compra_SubTotal
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Compra c
        ON c.ID_Compra = tm.Compra_Numero
        AND c.Fecha = tm.Compra_Fecha
    JOIN LOS_QUE_SABEN_SABEN.Material m
        ON m.Nombre = tm.Material_Nombre
        AND m.Descripcion = tm.Material_Descripcion
    WHERE
        NOT EXISTS ( -- evita duplicados por id_compra y id_material
            SELECT 1
            FROM LOS_QUE_SABEN_SABEN.Detalle_Compra dc
            WHERE dc.ID_Compra = c.ID_Compra
              AND dc.ID_Material = m.ID_Material
        );
END;

-- sp para migrar materiales y sus tipos (tela, madera, relleno)
go
CREATE PROCEDURE LOS_QUE_SABEN_SABEN.Migrar_Material
AS
BEGIN
    SET NOCOUNT ON;

    -- inserta tipos de materiales que no existan
    INSERT INTO LOS_QUE_SABEN_SABEN.Tipo_Material (Nombre)
    SELECT DISTINCT Material_Tipo
    FROM gd_esquema.Maestra
    WHERE Material_Tipo IS NOT NULL
    EXCEPT
    SELECT Nombre FROM LOS_QUE_SABEN_SABEN.Tipo_Material;

    -- inserta materiales que no existan
    INSERT INTO LOS_QUE_SABEN_SABEN.Material (
        Id_Tipo_Material, Nombre, Precio_Adicional, Descripcion
    )
    SELECT DISTINCT
        tipoM.ID_Tipo_Material,
        tm.Material_Nombre,
        tm.Material_Precio,
        tm.Material_Descripcion
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Tipo_Material tipoM
        ON tipoM.Nombre = tm.Material_Tipo
    WHERE tm.Material_Nombre IS NOT NULL
      AND NOT EXISTS ( -- evita insertar materiales ya existentes por nombre
          SELECT 1
          FROM LOS_QUE_SABEN_SABEN.Material mat
          WHERE mat.Nombre = tm.Material_Nombre
      );

    -- inserta detalles de tela
    INSERT INTO LOS_QUE_SABEN_SABEN.Tela (ID_Tipo_Material, Color, Textura)
    SELECT DISTINCT
        tipo.ID_Tipo_Material,
        tm.Tela_Color,
        tm.Tela_Textura
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Tipo_Material tipo
      ON tm.Material_Tipo = tipo.Nombre COLLATE Latin1_General_CS_AS
    WHERE tm.Material_Tipo = 'Tela'
      AND (tm.Tela_Color IS NOT NULL OR tm.Tela_Textura IS NOT NULL)
      AND NOT EXISTS ( -- evita duplicados por tipo de material, color y textura
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Tela t
        WHERE t.ID_Tipo_Material = tipo.ID_Tipo_Material
          AND ISNULL(t.Color, '') = ISNULL(tm.Tela_Color, '')
          AND ISNULL(t.Textura, '') = ISNULL(tm.Tela_Textura, '')
      );

    -- inserta detalles de madera
    INSERT INTO LOS_QUE_SABEN_SABEN.Madera (ID_Tipo_Material, Color, Dureza, Descripcion)
SELECT DISTINCT
    tm.ID_Tipo_Material,
    m.Madera_Color,
    m.Madera_Dureza,
    m.Material_Nombre
FROM gd_esquema.Maestra m
JOIN LOS_QUE_SABEN_SABEN.Tipo_Material tm
    ON tm.Nombre = m.Material_Tipo
WHERE m.Madera_Dureza IS NOT NULL
  AND m.Madera_Color IS NOT NULL
  AND LTRIM(RTRIM(tm.Nombre)) COLLATE Latin1_General_CI_AI = 'Madera';

    -- inserta detalles de relleno
    INSERT INTO LOS_QUE_SABEN_SABEN.Relleno (ID_Tipo_Material, Densidad)
    SELECT DISTINCT
        tipo.ID_Tipo_Material,
        tm.Relleno_Densidad
    FROM gd_esquema.Maestra tm
    JOIN LOS_QUE_SABEN_SABEN.Tipo_Material tipo
      ON tm.Material_Tipo = tipo.Nombre COLLATE Latin1_General_CS_AS
    WHERE tm.Material_Tipo = 'Relleno'
      AND tm.Relleno_Densidad IS NOT NULL
      AND NOT EXISTS ( -- evita duplicados por tipo de material y densidad
        SELECT 1
        FROM LOS_QUE_SABEN_SABEN.Relleno dest
        WHERE dest.ID_Tipo_Material = tipo.ID_Tipo_Material
          AND ISNULL(dest.Densidad, -1) = ISNULL(tm.Relleno_Densidad, -1)
      );
END;
GO

-- ============================================================================
-- ejecucion de stored procedures de migracion
-- ============================================================================
EXEC LOS_QUE_SABEN_SABEN.Migrar_Provincias;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Localidades;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Clientes;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Sucursales;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Proveedores;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Modelo_Sillon;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Medidas;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Sillones;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Pedidos;
EXEC LOS_QUE_SABEN_SABEN.Migrar_PedidoCancelacion;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Facturas;
EXEC LOS_QUE_SABEN_SABEN.Migrar_DetallePedido;
EXEC LOS_QUE_SABEN_SABEN.Migrar_DetalleFactura;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Envios_Simplificado;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Material;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Compras;
EXEC LOS_QUE_SABEN_SABEN.Migrar_Detalle_Compra;

