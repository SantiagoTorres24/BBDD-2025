USE BDPeluqueria;
GO

-- Tabla de Clientes
CREATE TABLE Clientes (
    IdCliente INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Telefono NVARCHAR(20)
);

-- Tabla de Empleados
CREATE TABLE Empleados (
    IdEmpleado INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Puesto NVARCHAR(50)
);