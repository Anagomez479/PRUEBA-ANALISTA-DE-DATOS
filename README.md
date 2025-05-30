# PRUEBA-ANALISTA-DE-DATOS
Repositorio de los resultados a la prueba técnica para analista de datos
# Evaluación Técnica SQL – ANA MARÍA GÓMEZ OROZCO

## 🧩 Descripción general
Este repositorio contiene la solución a los ejercicios propuestos como parte de una prueba técnica.

## 📁 Estructura del repositorio
- `respuestas.sql`: contiene todos los scripts SQL desarrollados.
- `respuestas.pdf`: documento con las preguntas y respuestas explicadas (opcional).
- `presentacion/`: presentación de resultados (PowerPoint o Dashboard).
- `recursos/`: imágenes de apoyo o diagramas relacionales.


### Fase 1: Extracción y Combinación de Datos
Se crean las tablas definidas para la realización de la primera fase de la prueba. 

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


## ✅ Desarrollo de cada ejercicio
## ✅ Fase 1
```sql
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
--Para evitar conflictos por diferencia de dimesiones, crearía una tabla temporal que cargue la nueva columna.
--En esta agregaría los datos del último mes y luego solo para las columnas compatibles realizaría la inserción con la nueva estructura


## ✅ Fase 2
Suponiendo que capt_tot es un indicativo clave de productividad por emepleado, se crea una tabla donde se desglozan los datos de la siguiente manera:
Capt_tot: se divide el capt_tot por empleado para comparar este resultado con una simulación de costo diario.
Simulación de costo diario: se multiplica los días trabajados por el costo del día (simulado) y se multi´lica este dato por el porcentaje asignado a cada tipo de candidato.
Por último se comparan los datos arrojados totales y diarios, evaluando la productividad según el tipo de candidato.

0.0019
0.0143
0.0401

Cargo base                             Capt por empleado       Costo simulado     Capt/Costo
EJERCUTIVO COMERCIAL                         717.57                37,308,955        0.0000192
EJERCUTIVO COMERCIAL FIN DE SEMANA           288.12                 2,011,972        0.0001432
EJERCUTIVO COMERCIAL MEDIO TIEMPO            347.60                   866,713        0.0004010

Según los resultados optenidos se puede ver que el ejecutivo comercial de medio tiempo es el mayor captación por costo tiene siendo este el más productivo por valor pagado según los porcentajes asignados.
Se suguiere realizar mayor nivel de contratación en este tipo de candidato dado que este representa una mayor productiva que incluso el ejecutivo de tiempo completo el cual tiene gran aporte y valor a nivel general pero menos productividad.














