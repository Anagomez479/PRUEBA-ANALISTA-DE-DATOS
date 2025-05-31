CREATE DATABASE DATOS

USE DATOS

CREATE TABLE CLIENTE (
	cedula INTEGER PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(40),
    telefono VARCHAR(20) NULL
);

CREATE TABLE PROVEEDOR (
	id_proveedor INTEGER PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(40),
    telefono VARCHAR(20) NULL
);

CREATE TABLE ORDEN (
	id_orden INTEGER PRIMARY KEY IDENTITY(1,1),
	nro_orden VARCHAR(10) NULL,
	cedula INTEGER,
    fecha_orden DATETIME,
    total_pedido DECIMAL(12,2),
	FOREIGN KEY (cedula) REFERENCES CLIENTE (cedula)
);

CREATE TABLE PRODUCTO (
	id_producto INTEGER PRIMARY KEY IDENTITY(1,1),
    nombre_producto VARCHAR(50),
	id_proveedor INTEGER,
    precio_unitario DECIMAL(12,2) NULL,
	activo_sn BIT,
	FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR (id_proveedor)
);

CREATE TABLE DETALLE_ORDEN (
	id_orden INTEGER,
    id_producto INTEGER,
    precio_unitario DECIMAL(12,2),
	cantidad INTEGER,
	FOREIGN KEY (id_orden) REFERENCES ORDEN (id_orden),
	FOREIGN KEY (id_producto) REFERENCES PRODUCTO (id_producto)
);


-- Insertar clientes
INSERT INTO CLIENTE (nombre, telefono)
VALUES 
('Juan Pérez', '3101234567'),
('Ana Gómez', '3119876543');

-- Insertar proveedores
INSERT INTO PROVEEDOR (nombre, telefono)
VALUES 
('Proveedor A', '6011234567'),
('Proveedor B', '6017654321');

-- Insertar productos
INSERT INTO PRODUCTO (nombre_producto, id_proveedor, precio_unitario, activo_sn)
VALUES
('Shampoo Herbal', 1, 15000.00, 1),
('Crema Facial', 2, 22000.00, 1),
('Jabón Natural', 1, 5000.00, 1);

-- Insertar órdenes
INSERT INTO ORDEN (nro_orden, cedula, fecha_orden, total_pedido)
VALUES
('ORD001', 1, GETDATE(), 37000.00),
('ORD002', 2, GETDATE(), 5000.00);

-- Insertar detalle de órdenes
INSERT INTO DETALLE_ORDEN (id_orden, id_producto, precio_unitario, cantidad)
VALUES
(1, 1, 15000.00, 1),
(1, 2, 22000.00, 1),
(2, 3, 5000.00, 1);


--Respuestas:
--1--
SELECT COUNT(id_orden) AS 'Número total de ordenes' FROM ORDEN;

--2--
SELECT COUNT(DISTINCT C.cedula) Cantidad_fecha
FROM CLIENTE C
INNER JOIN ORDEN O ON O.cedula = C.cedula
WHERE O.fecha_orden BETWEEN '2021-01-01' AND GETDATE();

--3--
SELECT C.cedula, C.nombre, COUNT(DISTINCT O.id_orden) Cantidad_Ordenes
FROM CLIENTE C
INNER JOIN ORDEN O ON O.cedula = C.cedula
GROUP BY C.cedula, C.nombre
ORDER BY COUNT(DISTINCT O.id_orden) DESC; 

--4--
SELECT TOP 1 C.cedula, C.nombre, C.telefono, O.fecha_orden, P.nombre_producto, DO.cantidad, DO.precio_unitario FROM CLIENTE C
INNER JOIN ORDEN O ON O.cedula = C.cedula
INNER JOIN DETALLE_ORDEN DO ON O.id_orden = DO.id_orden
INNER JOIN PRODUCTO P ON P.id_producto = DO.id_producto
WHERE fecha_orden BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY (DO.precio_unitario * DO.cantidad) DESC;

--5--
SELECT YEAR(fecha_orden) AS Año, MONTH(fecha_orden) AS Mes, SUM(DO.precio_unitario * DO.cantidad) AS 'Valor total vendido' FROM ORDEN O
INNER JOIN DETALLE_ORDEN DO ON DO.id_orden = O.id_orden
GROUP BY YEAR(fecha_orden), MONTH(fecha_orden)
ORDER BY YEAR(fecha_orden), MONTH(fecha_orden);

--6--
SELECT C.nombre, P.nombre_producto, SUM(DO.cantidad) AS Cantidad_Comprada,SUM(DO.cantidad * DO.precio_unitario) AS Valor_Total FROM CLIENTE C
INNER JOIN ORDEN O ON O.cedula = C.cedula
INNER JOIN DETALLE_ORDEN DO ON O.id_orden = DO.id_orden
INNER JOIN PRODUCTO P ON P.id_producto = DO.id_producto
WHERE C.cedula = 1
GROUP BY C.cedula, C.nombre, P.nombre_producto
ORDER BY Valor_Total DESC;

--7--
--Para evitar conflictos por diferencia de dimesiones, crearía una tabla temporal que
--cargue la nueva columna. En esta agregaría los datos del último mes y luego solo para
--las columnas compatibles realizaría la inserción con la nueva estructura
