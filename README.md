![image](https://github.com/user-attachments/assets/ccd5210f-eb7a-4744-a8c8-311cca1de04e)# PRUEBA-ANALISTA-DE-DATOS
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
Capt_tot: se divide el capt_tot por empleado para comparar este resultado con una simulación de costo diario (Se toma un valor de ejemplo para el costo diario por ejecutivo). 
Simulación de costo diario: se multiplica los días trabajados por el costo del día (simulado) y se multiplica este dato por el porcentaje asignado a cada tipo de candidato.
Por último se comparan los datos arrojados totales y diarios, evaluando la productividad según el tipo de candidato.

Cargo base                             Capt por empleado       Costo simulado     Capt/Costo
EJERCUTIVO COMERCIAL                         717.57                37,308,955        0.0000192
EJERCUTIVO COMERCIAL FIN DE SEMANA           288.12                 2,011,972        0.0001432
EJERCUTIVO COMERCIAL MEDIO TIEMPO            347.60                   866,713        0.0004010

Según los resultados optenidos se puede observar que el ejecutivo comercial de medio tiempo es el de mayor captación por costo,  es el más productivo por valor pagado según los porcentajes asignados.
Se suguiere realizar mayor nivel de contratación en este tipo de candidato dado que este representa una mayor productiva que incluso el ejecutivo de tiempo completo el cual tiene gran aporte y valor a nivel general pero menos productividad.
Se crea power BI donde se visualicen de manera más fácil el tipo de empleado, la región y el negocio para posteriormente comparar con los resultados de los cluster. 

## ✅ Fase 3

### Análisis de Clustering

#### 1. Metodología

* **Cargue y limpieza de los datos: Se extraen los datos del archivo de Excel entregado, se realizar el análisis de los datos seleccionando las variables numéricas y visualizando sus datos descriptivos, como media, mediana, conteo y demás datos.
* Se eliminan del modelo las filas con Nan devido a que estas no tenían aportes significativos en los resultados, debido que los valores en cero si podían aportar al modelo se decide conservarlos, estos valores extremos se pretende normalizar con el escalada.
* Para el escalado de datos se usa un Robust Scale, este tipo de escalado es muy bueno para datos extremos como lo es el cado de valores en 0 comparado con valores altos.
* Adicional se realiza una revisión de los datos generales con un pairplot de todas las variable, y se grafica de igual manera las variables categorias con su frecuencia, viendo así el aporte que tiene la region y el tipo de negoocio, esto no se realiza en el canal, en esa variable se evidencio que no tenía aporte significativos tomandose como variable categorica y ni como numérica (se hacen las dos pruebas).

* **Modelo utilizado**: Algoritmo KMeans, se seleccionan 4 cluster, se usa el método del codo para definir este valor.

* **Variables seleccionadas**: Solo variables numéricas normalizadas y no correlacionadas.
Para la selección de las variables a utilizar se utilizar una matriz de correlación según los resultados arojados se eliminaron las variables que tenían alto nivel de correlación con otro de las varibles, evitando así la multicolinealidad de los datos.

* **Variables incluidas**:

  * capturas\_tarjetas\_norm
  * aprobacion\_tarjetas\_norm
  * aprobacion\_creditos\_norm
  * monto\_creditos\_norm
  * trafico\_transaccional\_norm
  * aprovechamiento\_de\_trafico\_norm
  * contribucion\_norm
* Se descartó la variable "canal" por no aportar valor al modelo.

#### 2. Resultados generales

| Cluster | Nº Registros       |
| ------- | ------------------ |
| 0       | 31                 |
| 1       | 49                 |
| 2       | 8                  |
| 3       | 53                 |

#### 3. Características Promedio por Cluster (normalizadas)

| Variable                   | Cluster 0 | Cluster 1 | Cluster 2 | Cluster 3 |
| -------------------------- | --------- | --------- | --------- | --------- |
| Capturas Tarjetas          | 0.26      | 0.69      | 0.73      | -0.25     |
| Aprobación Tarjetas        | 0.28      | -0.19     | 1.36      | -0.09     |
| Aprobación Créditos        | 0.14      | -0.50     | 0.11      | 0.28      |
| Monto Créditos             | 0.49      | -0.67     | 0.91      | 0.01      |
| Tráfico Transaccional      | 0.65      | -0.54     | 1.58      | 0.02      |
| Aprovechamiento de Tráfico | 0.03      | -0.22     | -0.22     | 0.24      |
| Contribución               | 0.40      | 0.30      | 1.68      | -0.21     |

## ✅ Fase 4

region   ALKOSTO  ANTIOQUIA  BOGOTA 1  BOGOTA 2  COSTAS  EJE CAFETERO Y SUR   SANTANDERES BOYACA 
cluster                                                                       
0              0          5         4         6       6                   7           3
1             37          0         0         3       2                   4           3
2              0          4         4         0       0                   0           0
3              0          6         9        10       9                  11           8

negocio   A   E
cluster        
0         0  31
1        37  12
2         0   8
3         0  53

#### 1. Interpretación de Clusters (Relacionado con el tipo de empleado)

Se mostrará el aporte que tienen cada tipo de variable según los clusters realizados, estos adicional están ordenados según sus resultados. 

**Cluster 2 – “Puntos de Alto Desempeño”** (8 registros)
* Alta contribución, tráfico, capturas y aprobaciones.
* Todos del negocio tipo "E". Presentes en Antioquia y Bogotá 1.
* **Tipo de empleado**: Aporte significativo de ejecutivo fin de semana y en ANTIOQUIA el de medio tiempo. 

**Cluster 0 – “Punto de buen Desempeño”** (31 registros)
* Contribución positiva y desempeño general moderado-alto.
* Todos tipo E. Distribución regional variada.
* **Tipo de empleado**: En su mayoría Ejecutivos de tiempo completo. 

**Cluster 3 – “Desempeño Promedio”** (53 registros)
* Variables con desempeño levemente inferior al promedio en la mayoría de variables.
* Todos del negocio tipo E. Alta presencia en Eje Cafetero, Bogotá 2 y Santanderes.
* **Tipo de empleado**: En su mayoría **ejecutivos de tiempo completo**, con baja participación de **medio tiempo y fin de semana**.

**Cluster 1 – “Bajo Desempeño”** (49 registros)
* Peores indicadores en aprobación y monto de créditos, tráfico y aprovechamiento.
* Dominado por el negocio tipo **A** (37 registros), ubicados principalmente en ALKOSTO.
* **Tipo de empleado**: Predominan **ejecutivos de tiempo completo**, pero sin lograr buen desempeño.


#### 2. Acciones Recomendadas

### Cluster 2 – Puntos de Alto Desempeño
- Analizar y replicar las actividades y carácteristecas de estos puntos.
- Continuar con la contratación de ejecutivos de fin de semana y medio tiempo en zonas similares.
- Realizar un seguimiento continuo para mantener una sostenibilidad del alto rendimiento.
- Crear nuevas técnicas para aumentar el aprovechamiento del tráfico. 

### Cluster 0 – Buen Desempeño
- Crear nuevas técnicas para aumentar el aprovechamiento del tráfico.
- Evaluar al ternativas que puedan mejorar las aprobaciones de créditos.
- Capacitar y acompañar al equipo para mejorar eficiencia en capturas.
- Aumentar la contratación de ejecutivos de medio tiempo que puedan aumentar la productividad.

### Cluster 3 – Desempeño Promedio
- Realizar un enfoque principalmente en los puntos más críticos como lo son capturas, aprobación y contrinución.
- Evaluar posibles mejoras replicando acciones de los puntos de venta correspondientes al cluster 1. 
- Explorar ajustes operativos que potencien los resultados sin incrementar costos significativamente.

### Cluster 1 – Bajo Desempeño
- Analizar causas operativas y comerciales del bajo rendimiento por región. 
- Incrementar la cobertura de fines de semana y medio tiempo en zonas con alto flujo de clientes.
- Diseñar e implementar un plan de intervención en las cuales se busque mejorar procesos, horarios y perfiles contratados.


#### 3. Conclusiones

- Los ejecutivos de fin de semana y medio tiempo, en las regiones de Antioquia y Bogotá 1, se puede asociar a mejores resultados.
- Hay un bajo desempeño en el cluster 1, el cual está en su mayoría relacionado a ALKOSTO.
- Los puntos promedio tienen estabilidad, pero con margen claro de mejora si se ajustan procesos y se replican buenas prácticas.
- El bajo desempeño está fuertemente vinculado a una cobertura limitada de personal, especialmente en aprovechamiento del tráfico.
- Ajustar o capacitar el personal y la contratación en los puntos críticos es clave para mejorar el desempeño entre regiones.


