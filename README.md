# Proyecto Final - Análisis de Llamadas al 911 en la CDMX
Este proyecto busca aportar información relevante para entender los efectos del confinamiento en las emergencias reportadas al 911 en la CDMX. 📞

## Descripción General
Este proyecto analiza las llamadas realizadas al 911 en la Ciudad de México durante el primer y segundo semestre de 2020. La base de datos permite conocer la ubicación aproximada, motivo, descripción del incidente y la duración de atención a los diferentes llamados.

## Fuente de Datos
- **Recolector de datos:** Centro de Comando, Control, Cómputo, Comunicaciones y Contacto Ciudadano de la CDMX (C5).
- **Propósito:** Registrar, atender y gestionar emergencias reportadas por los ciudadanos, facilitando la canalización de recursos y el análisis estadístico para la toma de decisiones en seguridad, salud y protección civil.
- **Acceso a la base de datos:** [Base de Datos de Llamadas al 911](https://datos.cdmx.gob.mx/dataset/llamadas-numero-de-atencion-a-emergencias-911)
- **Frecuencia de actualización:** Semestralmente con los folios cerrados durante el semestre anterior.

## Estructura de los Datos
- **Número de registros:** Aproximadamente 1.7 millones de llamadas al año (~560,000 por semestre).
- **Número de atributos:** 18 columnas.
- **Principales atributos:**
  - `id`: Llave primaria de la tabla.
  - `folio`: Código único del incidente.
  - `categoria_incidente_c4`: Agrupación de los tipos de incidentes.
  - `incidente_c4`: Tipo específico de incidente.
  - `anio_creacion`, `mes_cierre`: Año y mes de apertura y cierre del incidente.
  - `fecha_creacion`, `hora_creacion`: Fecha y hora de apertura.
  - `fecha_cierre`, `hora_cierre`: Fecha y hora de cierre.
  - `codigo_cierre`: Estado final del incidente (afirmativo, negativo, repetido).
  - `clas_con_f_alarma`: Clasificación de la llamada (emergencia, urgencia médica, falsa alarma, etc.).
  - `alcaldia_cierre`, `colonia_cierre`, `manzana`: Ubicación del incidente.
  - `latitud`, `longitud`: Coordenadas geográficas del incidente.

## Tipos de Datos
- **Numéricos:** `id`, `anio_creacion`, `anio_cierre`, `colonia_cierre`, `latitud`, `longitud`, `manzana`
- **Categóricos:** `categoria_incidente_c4`, `incidente_c4`, `codigo_cierre`, `clas_con_f_alarma`, `alcaldia_cierre`
- **Texto:** `folio`, `mes_creacion`, `mes_cierre`
- **Temporales:** `fecha_creacion`, `fecha_cierre`, `hora_creacion`, `hora_cierre`

## Objetivo del Proyecto
El objetivo de este proyecto es analizar las llamadas registradas al 911 durante el periodo de mayor incidencia de COVID-19 en la Ciudad de México, con el fin de comprender las principales emergencias y delitos reportados en distintas alcaldías y zonas. 
- Inicialmente, se realizará un mapeo general de los incidentes para identificar patrones y tendencias en la distribución de emergencias, incluyendo tanto delitos visibles como aquellos de impacto socioemocional derivados del confinamiento. 
- Posteriormente, el estudio se centrará en un análisis comparativo entre colonias con diferentes condiciones socioeconómicas, explorando cómo se vivió la pandemia en 
términos de seguridad, tiempos de respuesta y tipos de incidentes reportados.
- Se evaluará si existen contrastes significativos en la atención recibida y en la percepción de inseguridad, considerando los prejuicios asociados a colonias tradicionalmente catalogadas como peligrosas frente a aquellas consideradas privilegiadas. Este enfoque permitirá comprender las desigualdades en la gestión de emergencias y contribuir a una discusión más informada sobre seguridad y acceso a servicios en la ciudad.


## Consideraciones Éticas
1. **Protección de datos personales:** Aunque los datos no incluyen información sensible, la ubicación podría permitir identificaciones indirectas. El C5 protege la identidad mediante un radio de precisión adecuado.
2. **Uso responsable:** El análisis debe servir para mejorar la seguridad y la gestión de emergencias, evitando usos que generen discriminación o vigilancia indebida.
3. **Transparencia y exactitud:** Dada la premura de atención en emergencias, los datos pueden contener errores o sesgos que deben considerarse en los análisis.

## Instalación y Uso
1. **Clonar el repositorio**:
   ```sh
   git clone https://github.com/tu_usuario/proyecto-911-cdmx.git
   cd proyecto-911-cdmx
   ```
---

# 📊 Carga Inicial de Datos en PostgreSQL
## **1. Creación de la Base de Datos**

Para establecer el entorno de trabajo, es necesario crear la base de datos donde se almacenará la información. 

Ejecute el siguiente comando en `psql` para crear la base de datos:

```sql
CREATE DATABASE llamadas911;
```

Posteriormente, conéctese a la base de datos creada:

```sql
\c llamadas911
```
---

## **3. Creación del Esquema Inicial**

Para garantizar la correcta estructuración de los datos, es necesario ejecutar el siguiente script SQL, el cual define la tabla `llamadas_911` con sus respectivos atributos y tipos de datos:

### **3.1 Definición de la Tabla**
```sql
CREATE TABLE llamadas_911 (
    folio VARCHAR(50),
    categoria_incidente_c4 VARCHAR(100),
    incidente_c4 VARCHAR(100),
    anio_creacion INT,
    mes_creacion VARCHAR(20),
    fecha_creacion DATE,
    hora_creacion TIME,
    anio_cierre INT,
    mes_cierre VARCHAR(20),
    fecha_cierre DATE,
    hora_cierre TIME,
    codigo_cierre VARCHAR(50),
    clas_con_f_alarma VARCHAR(100),
    alcaldia_cierre VARCHAR(100),
    colonia_cierre VARCHAR(150),
    manzana VARCHAR(50),
    latitud FLOAT,
    longitud FLOAT
);
```
*Este script debe ejecutarse en `psql` o cualquier cliente SQL compatible con PostgreSQL.

## **4. Importación de Datos desde un Archivo CSV**

Para cargar los datos en la tabla `llamadas_911`, es necesario importar 2 archivos CSV.

- Para nuestro proyecto necesitamos descargar las bases de datos del primer y segundo semestre de 2020. Puede descargarlas en los siguientes enlaces:
    - [Descargar datos del primer semestre de 2020](https://datos.cdmx.gob.mx/dataset/llamadas-numero-de-atencion-a-emergencias-911/resource/a6958855-dce5-498d-9bba-4d586e08d09e)
    - [Descargar datos del segundo semestre de 2020](https://datos.cdmx.gob.mx/dataset/llamadas-numero-de-atencion-a-emergencias-911/resource/a3a53f53-8565-44d3-a11b-73c4befed7b3)

### **4.1 Importación utilizando `psql`**

Asegúrese de utilizar este comando antes de cargar los datos: 

```sql
SET CLIENT_ENCODING TO 'UTF8';
```

Posteriormente, utilice el siguiente comando en `psql` para importar los datos del primer semestre:

- *Tome en cuenta que en la dirección del archivo `'/ruta/del/archivo/llamadas_911_utf8.csv'` tendrá que colocar la dirección que corresponda a su dispositivo personal.*

```sql
\copy llamadas_911(folio, categoria_incidente_c4,incidente_c4,anio_creacion,mes_creacion,fecha_creacion,hora_creacion,anio_cierre,mes_cierre,fecha_cierre,hora_cierre,codigo_cierre,clas_con_f_alarma,alcaldia_cierre,colonia_cierre,manzana,latitud,longitud)
FROM '/ruta/del/archivo/llamadas_911_utf8.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```

⚠️ Considerando que estamos trabajando con dos conjuntos de datos, deberá repetir la instrucción anterior sustituyendo la dirección por la del archivo CSV del segundo semestre de 2020.

### **5. Verificación de la Carga de Datos**

Una vez importados los datos, se recomienda ejecutar la siguiente consulta para verificar la correcta inserción de los registros:

```sql
SELECT * FROM llamadas_911 LIMIT 10;
```

Si los datos se han cargado correctamente, se visualizarán las primeras diez filas de la tabla.

### **6. Análisis exploratorio**
A la hora de realizar la exploración de los datos, nos pareció preciso clarificar el significado y la composición que el C5 les da a ciertos atributos. Primeramente, las llamadas son clasificadas por el atributo “clas_con_f_alarma”, lo que las distingue en 6 grupos en cuanto a la causa general del reporte. Cada uno de estos tiene sus respectivos motivos, representados por el atributo “categoria_incidente_c4”, lo que nos brinda el tipo de incidente registrado. Finalmente, el atributo “incidente_c4” nos brinda más detalle del percance, de esta forma, la combinación de estas categorías logra identificar un total de 311 tipos de incidentes. 

De acuerdo a los datos de ubicación, las manzanas presentan una clave alfanumérica asignada por el INEGI dentro de su marco geoestadístico. Respectivamente, tanto la longitud como la latitud marcan el centroide de la manzana donde se levantó el reporte. 

Finalmente, el folio es único en cada llamada, y está formado por un código alfanumérico formado por las iniciales del centro que recibió la emergencia, la fecha de creación y un número consecutivo único de ingreso. De igual forma, cabe destacar que el atributo “codigo_cierre” clasifica las llamadas en cuanto a cómo se atendió la emergencia: afirmativo en caso de que una unidad de atención confirmó el suceso, informativo en caso de ser una solicitud de información, negativo en caso de que la unidad de atención llegó al sitio del evento pero nadie confirmó la emergencia, duplicado en caso de hacer referencia a un incidente ya reportado (donde el original se marca como afirmativo, negativo, etc., dependiendo el caso) y falso cuando el incidente reportado es falso en el lugar de los hechos.

Se contabilizarán frecuencias como llamadas por categoría, por incidente, por alcaldía y colonia para poder agrupar distintas variables de interés de acuerdo a la frecuencia que se presente.

- **Frecuencia por categoría:**

```sql
SELECT COUNT(*) AS frecuencia,
		categoria_incidente_c4
FROM llamadas_911
GROUP BY categoria_incidente_c4
ORDER BY COUNT(*) DESC;
```

- **Frecuencia por incidente:**

```sql
SELECT COUNT(*) AS frecuencia,
		incidente_c4
FROM llamadas_911
GROUP BY incidente_c4
ORDER BY COUNT(*) DESC;
```

- **Frecuencia por alcaldía:**

```sql
SELECT COUNT(*) AS frecuencia,
		alcaldia_cierre
FROM llamadas_911
GROUP BY alcaldia_cierre
ORDER BY COUNT(*) DESC;
```

- **Frecuencia por colonia:**

```sql
SELECT COUNT(*) AS frecuencia,
		colonia_cierre
FROM llamadas_911
GROUP BY colonia_cierre
ORDER BY COUNT(*) DESC;
```

- **Máximos y mínimos:**

Obtener los máximos y mínimos de cada uno de los atributos es esencial para saber cómo se acota nuestra información. Además, nos ayuda a ver la cantidad relativa de cada uno de los valores de cada tupla. Para obtener los valores mínimos y máximos se realizó la siguiente consulta:

```sql
SELECT 	MIN(anio_creacion) AS min_anio_creacion,MAX(anio_creacion) AS max_anio_creacion,
		MIN(fecha_creacion) AS min_fecha_creacion,MAX(fecha_creacion) AS max_fecha_creacion,
		MIN(hora_creacion) AS min_hora_creacion, MAX(hora_creacion) AS max_hora_creacion,
		MIN(anio_cierre) AS min_anio_cierre, MAX(anio_cierre) AS max_anio_cierre,
		MIN(fecha_cierre) AS min_fecha_cierre, MAX(fecha_cierre) AS max_fecha_cierre,
FROM llamadas_911;
```

- **Valores nulos:**

```sql
SELECT manzana, count(*)
from llamadas_911
where manzana = 'NA'
group by manzana;
```

- **Valores repetidos:**

Se puede observar que las columnas `mes_creacion`, `anio_creacion` y `mes_creacion`, `mes_cierre` son repetitivos para la columna `fecha_creacion` y `fecha_cierre` respectivamente. Dado que, a través de los datos de la fecha, se pueden obtener estos valores existe una redundancia en contenido.

- **Valores inconsistentes:**

Mediante un análisis de coherencia entre la fecha y la hora de creación y cierre para descartar aquellas tuplas inconsistentes ejecutamos la siguiente consulta en el editor:

```sql
SELECT *
From llamadas_911
WHERE hora_cierre < hora_creacion AND fecha_cierre <= fecha_creacion;
```
Esta consulta nos devolvió varias tuplas en donde la fecha fue la misma, pero la hora de creación fue posterior a la hora de creación. Este error se pudo dar a un mal registro de la hora o fecha por parte de los reportes que se dan de las llamadas del 911.

---
## 7. Ejecución automática del script

Todo el proceso de limpieza, normalización y creación de vistas está contenido en el archivo `script_proyecto_911.sql`.

📌 El script ha sido probado de principio a fin y no requiere intervención manual.

Para ejecutarlo desde una consola SQL (como `psql`), basta con:

```sql
\i script_proyecto_911.sql
```

** Este script debe ejecutarse **después de haber cargado manualmente el CSV a la tabla `llamadas_911`**. Asegúrate de que la tabla esté presente antes de iniciar.*

---

### 8. Limpieza de datos 
## 8.1 Proceso de normalización de la base de datos 
{agregar descripción} 

![Image](https://github.com/user-attachments/assets/476b6ab3-aa38-4ead-a308-8b60f1f4776e)
![Image](https://github.com/user-attachments/assets/94b886d6-b4d4-465a-a55b-506fb5a8367c)


## 8.2 Diagrama Entidad-Relación (ERD)

El siguiente diagrama muestra el modelo entidad-relación resultante tras la normalización de la base de datos `llamadas_911`:

![Image](https://github.com/user-attachments/assets/49d98c5c-5878-44e6-a5af-2c04a7eec15d)

Este modelo cumple con la Cuarta Forma Normal (4FN), separando correctamente las dependencias funcionales y multivaluadas entre ubicaciones, clasificaciones e identificadores únicos de llamada.

## 8.3 Limpieza a nivel código 

Para optimizar nuestro análisis, eliminamos las columnas `latitud`, `longitud` y `manzana`, ya que la precisión geoespacial que aportaban no era necesaria para nuestros objetivos. También eliminamos las columnas `anio_creacion`, `mes_creacion`, `anio_cierre` y `mes_cierre`, pues esta información es redundante y puede derivarse directamente de los campos `fecha_creacion` y `fecha_cierre`.

Además, realizamos una depuración semántica de los valores. 

- Identificamos que algunas columnas contenían valores que representaban datos faltantes mediante cadenas como `'N/A'` o `'NULL'`, las cuales no son reconocidas como valores nulos reales en SQL. Estos fueron reemplazados por `NULL` reales para garantizar la integridad en los análisis.

También unificamos la representación de alcaldías: 

- por ejemplo, los valores `'CUAJIMALPA'` y `'CUAJIMALPA DE MORELOS'` aparecían como entradas separadas. Para evitar duplicidades y asegurar la uniformidad, se homologaron todas las variantes a `'CUAJIMALPA DE MORELOS'` (el nombre oficial de dicha alcaldía).

Finalmente, detectamos algunas tuplas con una inconsistencia temporal, donde la hora y fecha de cierre eran anteriores a la de creación. Estas fueron eliminadas para mantener la coherencia cronológica en los registros.

Dicho lo anterior, la limpieza se realizó con las siguientes instrucciones:

```sql
-- Eliminar columnas innecesarias
ALTER TABLE llamadas_911
DROP COLUMN latitud,
DROP COLUMN longitud,
DROP COLUMN manzana,
DROP COLUMN anio_creacion,
DROP COLUMN mes_creacion,
DROP COLUMN anio_cierre,
DROP COLUMN mes_cierre;

-- Reemplazar valores que simulan nulos con valores NULL reales
UPDATE llamadas_911
SET alcaldia_cierre = NULL
WHERE alcaldia_cierre IN ('N/A', 'NULL');

UPDATE llamadas_911
SET colonia_cierre = NULL
WHERE colonia_cierre IN ('N/A', 'NULL');

-- Unificar alcaldías
UPDATE llamadas_911
SET alcaldia_cierre = 'CUAJIMALPA DE MORELOS'
WHERE UPPER(alcaldia_cierre) LIKE '%CUAJIMALPA%';

-- Eliminar tupla con fecha y hora de cierre inválidas
DELETE FROM llamadas_911
WHERE hora_cierre < hora_creacion AND fecha_cierre <= fecha_creacion;
```

---
### 9. Normalización de la Base de Datos

Una vez completada la limpieza, procedimos a **normalizar la tabla `llamadas_911`**, eliminando redundancias y mejorando la integridad de los datos. Este proceso permitió separar información repetida (como ubicación y clasificación del incidente) en **tablas independientes**, facilitando la escalabilidad y eficiencia de la base.

El proceso incluyó:

- Creación de las tablas `ubicacion_cierre`, `clasificacion` y `llamada`.
- Poblado de las nuevas tablas con datos únicos desde `llamadas_911`, garantizando integridad referencial mediante claves foráneas.
- Eliminación de la tabla original y su respaldo (`llamadas_911_respaldo`) una vez migrados todos los datos.
- Creación de una vista homónima `llamadas_911` que unifica los datos necesarios para el análisis, sin comprometer la normalización.

### Script de normalización:

```sql
-- Tabla de ubicación
CREATE TABLE ubicacion_cierre (
  id BIGSERIAL PRIMARY KEY,
  colonia_cierre VARCHAR(150) NOT NULL,
  alcaldia_cierre VARCHAR(100) NOT NULL,
  UNIQUE(colonia_cierre, alcaldia_cierre)
);

-- Tabla de clasificación
CREATE TABLE clasificacion (
  id BIGSERIAL PRIMARY KEY,
  incidente VARCHAR(100) NOT NULL,
  categoria_incidente VARCHAR(100) NOT NULL,
  clas_con_falsa_alarma VARCHAR(100)
);

-- Tabla principal normalizada
CREATE TABLE llamada (
  folio VARCHAR(50) PRIMARY KEY,
  fecha_creacion DATE NOT NULL,
  hora_creacion TIME NOT NULL,
  fecha_cierre DATE NOT NULL,
  hora_cierre TIME NOT NULL,
  codigo_cierre CHAR(1) NOT NULL CHECK (codigo_cierre IN ('A', 'I', 'N', 'D', 'F')),
  ubicacion_cierre_id BIGINT NOT NULL REFERENCES ubicacion_cierre(id),
  clasificacion_id BIGINT NOT NULL REFERENCES clasificacion(id)
);

-- Eliminar atributos con alcaldia_cierre o colonia_cierre nulos
DELETE *
FROM llamadas_911
WHERE colonia_cierre IS NULL OR alcaldia_cierre IS NULL;

-- Poblar ubicación
INSERT INTO ubicacion_cierre (colonia_cierre, alcaldia_cierre)
SELECT DISTINCT colonia_cierre, alcaldia_cierre
FROM llamadas_911;

-- Poblar clasificación
INSERT INTO clasificacion (incidente, categoria_incidente, clas_con_falsa_alarma)
SELECT DISTINCT incidente_c4, categoria_incidente_c4, clas_con_f_alarma
FROM llamadas_911;

-- Poblar llamada
INSERT INTO llamada (
  folio, fecha_creacion, hora_creacion, fecha_cierre, hora_cierre, codigo_cierre,
  ubicacion_cierre_id, clasificacion_id
)
SELECT
  l.folio,
  l.fecha_creacion,
  l.hora_creacion,
  l.fecha_cierre,
  l.hora_cierre,
  SUBSTRING(l.codigo_cierre FROM 1 FOR 1),
  uc.id,
  c.id
FROM llamadas_911 AS l
JOIN ubicacion_cierre AS uc
  ON l.colonia_cierre = uc.colonia_cierre AND l.alcaldia_cierre = uc.alcaldia_cierre
JOIN clasificacion AS c
  ON l.incidente_c4 = c.incidente
  AND l.categoria_incidente_c4 = c.categoria_incidente
  AND l.clas_con_f_alarma = c.clas_con_falsa_alarma;

-- Borrado final
DROP TABLE llamadas_911;
DROP TABLE llamadas_911_respaldo;

-- Vista para análisis simplificado
CREATE VIEW llamadas_911 AS (
  SELECT
    l.folio,
    l.fecha_creacion,
    l.hora_creacion,
    l.fecha_cierre,
    l.hora_cierre,
    l.codigo_cierre,
    uc.colonia_cierre,
    uc.alcaldia_cierre,
    c.incidente,
    c.categoria_incidente,
    c.clas_con_falsa_alarma
  FROM llamada AS l
  JOIN ubicacion_cierre AS uc ON l.ubicacion_cierre_id = uc.id
  JOIN clasificacion AS c ON l.clasificacion_id = c.id
);
```
Gracias a esta normalización, eliminamos duplicidad de datos, mejoramos la estructura lógica del esquema y preparamos la base para un análisis más ágil, seguro y reutilizable.

---
## 10. Análisis Exploratorio de Emergencias 911

A continuación se presentan diversas consultas SQL desarrolladas para responder preguntas clave sobre las llamadas al 911 durante el año 2020 en la Ciudad de México. Este análisis busca entender patrones, identificar zonas prioritarias y evaluar el impacto del confinamiento por COVID-19 en las emergencias reportadas.

### Delitos por alcaldía: clasificación y categorías

Las siguientes consultas implican la formación de dos CTE que nos permiten consultar la cantidad de llamadas de acuerdo a su clasificación, ya sea en las diferentes alcaldías y colonias. Estas subtablas (que decidimos no fueran vistas para poder modificar el semestre consultado), nos permiten hacer aquellas comparaciones entre alcaldías y colonias con diferentes situaciones socioeconómicas y de localización. De igual forma, podemos ver la evolución que tuvo la cantidad de llamadas y sus propósitos a lo largo del año 2020, que, según datos externos, es donde hubo la mayor explosión de casos de COVID-19.

```sql
CREATE VIEW clasificacion_por_colonias AS
SELECT 
    colonia_cierre, 
    SUM(CASE WHEN clas_con_f_alarma = 'DELITO' THEN 1 ELSE 0 END) AS Delitos,
    SUM(CASE WHEN clas_con_f_alarma = 'EMERGENCIA' THEN 1 ELSE 0 END) AS Emergencias,
    SUM(CASE WHEN clas_con_f_alarma = 'FALTA CÍVICA' THEN 1 ELSE 0 END) AS Falta_Civica,
    SUM(CASE WHEN clas_con_f_alarma = 'SERVICIO' THEN 1 ELSE 0 END) AS Servicio,
    SUM(CASE WHEN clas_con_f_alarma = 'URGENCIAS MEDICAS' THEN 1 ELSE 0 END) AS Urgencias_Medicas
FROM 
    llamadas_911
WHERE 
    fecha_creacion >= '2020-06-30' ------cambiar de acuerdo al semestre 
GROUP BY 
    colonia_cierre;
    
---------- Indica, por semestre, numero de llamadas por clasificacion en cada alcaldía

CREATE VIEW clasificacion_por_alcaldias AS
	SELECT 
    alcaldia_cierre, 
    SUM(CASE WHEN clas_con_f_alarma = 'DELITO' THEN 1 ELSE 0 END) AS Delitos,
    SUM(CASE WHEN clas_con_f_alarma = 'EMERGENCIA' THEN 1 ELSE 0 END) AS Emergencias,
    SUM(CASE WHEN clas_con_f_alarma = 'FALTA CÍVICA' THEN 1 ELSE 0 END) AS Falta_Civica,
    SUM(CASE WHEN clas_con_f_alarma = 'SERVICIO' THEN 1 ELSE 0 END) AS Servicio,
    SUM(CASE WHEN clas_con_f_alarma = 'URGENCIAS MEDICAS' THEN 1 ELSE 0 END) AS Urgencias_Medicas
FROM 
    llamadas_911
WHERE 
    fecha_creacion >= '2020-06-30'
GROUP BY 
    alcaldia_cierre;
```

### Porcentaje de llamadas por categoría y clasificación

La creación de las siguientes vistas muestra el porcentaje de llamadas, ya sea por alcaldía o colonia, correspondientes a las diferentes clasificaciones y categorías de las llamadas (notar que categorías y clasificación difieren en cuanto a la mayor especificidad que presentan las categorías). Estas nuevas tablas nos permiten analizar la concentración de llamadas en cuanto a su propósito en determinadas zonas (alcaldías o colonias), así como podemos modificar la composición de la vista para obtener estas mismas fluctuaciones, pero en determinados puntos a lo largo del año 2020, año de inicio y mayor explotación de casos de COVID-19 en la Ciudad de México. Estos datos reflejan, más allá del porcentaje de llamadas relacionadas al sector salud (que encontramos similar en las diferentes localidades), las condiciones sociales, de seguridad e infraestructura en la ciudad.

```sql

-- Porcentaje de clasificación por alcaldía
CREATE VIEW llamadas_densas_clasificacion_alcaldia AS (
SELECT 
  alcaldia_cierre,
  clas_con_falsa_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY alcaldia_cierre), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY alcaldia_cierre, clas_con_falsa_alarma
ORDER BY alcaldia_cierre, porcentaje_llamadas DESC
);

-- Porcentaje de clasificación por colonia
CREATE VIEW llamadas_densas_clasificacion_colonia AS (
SELECT 
  colonia_cierre,
  clas_con_falsa_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY colonia_cierre), 2) || ' %' AS porcentaje_llamadas 
FROM llamadas_911
GROUP BY colonia_cierre, clas_con_falsa_alarma
ORDER BY colonia_cierre, porcentaje_llamadas DESC
);

-- Porcentaje de categoría por alcaldía
CREATE VIEW llamadas_densas_categoria_alcaldia AS (
SELECT 
  alcaldia_cierre,
  categoria_incidente,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY alcaldia_cierre), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY alcaldia_cierre, categoria_incidente
ORDER BY alcaldia_cierre, porcentaje_llamadas DESC
);

-- Porcentaje de categoría por colonia
CREATE VIEW llamadas_densas_categoria_colonia AS (
SELECT 
  colonia_cierre,
  categoria_incidente,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY colonia_cierre), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY colonia_cierre, categoria_incidente
ORDER BY colonia_cierre, porcentaje_llamadas DESC
);
```

### Porcentaje de delitos a través del tiempo

La siguiente consulta nos permite ver la evolución de determinada clasificación o categoría de llamada a través de los meses del respectivo año. Estas CTE reflejan el comportamiento de la sociedad ya sea a los picos por COVID-19 como a las celebraciones, eventos y festividades presentes como cualquier otro año, pero ahora en el 2020 con la pandemia como telón de fondo.

```sql
CREATE VIEW llamadas_clasificacion_mes AS (
SELECT 
  mes_creacion,
  clas_con_f_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY mes_creacion), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY mes_creacion, clas_con_f_alarma
ORDER BY mes_creacion, porcentaje_llamadas DESC
);

CREATE VIEW llamadas_categoria_mes AS (
SELECT 
  mes_creacion,
  categoria_incidente_c4,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY mes_creacion), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY mes_creacion, categoria_incidente_c4
ORDER BY mes_creacion, porcentaje_llamadas DESC

);

```

Las siguientes consultas también permiten ver la evolución de la concentración de llamadas de acuerdo a su categoría y su clasificación, diferenciando entre el primer y el segundo semestre. A nuestra sorpresa, no hay tanta variación en porcentajes hacia el segundo semestre en cuanto a temas relacionados con la salud, sin embargo, eso no significa que, en términos totales no hayan aumentado las llamadas en estos campos.

```sql
CREATE VIEW compara_semestres_clas AS (
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
  END AS semestre,
  clas_con_f_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY 
    CASE 
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
    END
  ), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY semestre, clas_con_f_alarma
ORDER BY semestre, porcentaje_llamadas DESC);


CREATE VIEW compara_semestres_cate AS (
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
  END AS semestre,
  categoria_incidente_c4,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY 
    CASE 
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
    END
  ), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY semestre, categoria_incidente_c4
ORDER BY semestre, porcentaje_llamadas DESC);

```
### Volumen de llamadas a travez del tiempo

```sql
CREATE OR REPLACE VIEW vista_llamadas_mensuales AS (
SELECT 
  EXTRACT(MONTH FROM fecha_creacion) AS mes_creacion,
  COUNT(*) AS total_llamadas,
  
  SUM(CASE WHEN clas_con_falsa_alarma = 'DELITO' THEN 1 ELSE 0 END) AS llamadas_delito,
  SUM(CASE WHEN clas_con_falsa_alarma = 'EMERGENCIA' THEN 1 ELSE 0 END) AS llamadas_emergencia,
  SUM(CASE WHEN clas_con_falsa_alarma = 'URGENCIAS MEDICAS' THEN 1 ELSE 0 END) AS llamadas_urgencias_medicas,
  SUM(CASE WHEN clas_con_falsa_alarma = 'SERVICIO' THEN 1 ELSE 0 END) AS llamadas_servicio,
  
  SUM(CASE WHEN categoria_incidente = 'Robo' THEN 1 ELSE 0 END) AS llamadas_robo,
  SUM(CASE WHEN categoria_incidente = 'Agresion' THEN 1 ELSE 0 END) AS llamadas_agresion

FROM llamadas_911
GROUP BY mes_creacion
ORDER BY mes_creacion);

SELECT * FROM vista_llamadas_mensuales;

```
### Cantidad y porcentaje de códigos de cierre

Estas consultas muestran con qué frecuencia se registraron distintos códigos de cierre en las llamadas al 911 durante el año 2020, tanto a nivel de alcaldía como de colonia.  Estas estadísticas ayudan a identificar ciertas prioridades en función del tipo y la frecuencia de emergencias que se presentan en distintas zonas. Además, permiten observar que, en la mayoría de los casos, predominan los códigos de cierre negativos, lo que puede indicar falta de atención, cancelaciones o problemas en la respuesta a las llamadas. Esto puede ayudar a tomar mejores decisiones sobre dónde actuar y cómo distribuir los recursos.

```sql
SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE alcaldia_cierre = 'COYOACAN' AND fecha_creacion < '2020-07-01'
    ), 
    2
  ) || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE alcaldia_cierre = 'COYOACAN' AND fecha_creacion < '2020-07-01'
GROUP BY codigo_cierre
ORDER BY 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE alcaldia_cierre = 'COYOACAN' AND fecha_creacion < '2020-07-01'
    ), 
    2
  ) DESC;
---

SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE alcaldia_cierre = 'COYOACAN' AND fecha_creacion >= '2020-07-01'
    ), 
    2
  ) || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE alcaldia_cierre = 'COYOACAN' AND fecha_creacion >= '2020-07-01'
GROUP BY codigo_cierre
ORDER BY 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE alcaldia_cierre = 'COYOACAN' AND fecha_creacion >= '2020-07-01'
    ), 
    2
  ) DESC;
```

```sql
SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion < '2020-07-01'
    ), 
    2
  ) || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion < '2020-07-01'
GROUP BY codigo_cierre
ORDER BY 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion < '2020-07-01'
    ), 
    2
  ) DESC;
  
  --
  SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion >= '2020-07-01'
    ), 
    2
  ) || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion >= '2020-07-01'
GROUP BY codigo_cierre
ORDER BY 
  ROUND(
    COUNT(*) * 100.0 / (
      SELECT COUNT(*) 
      FROM llamadas_911 
      WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion >= '2020-07-01'
    ), 
    2
  ) DESC;

```

### Número total de llamadas por alcaldía

Esta consulta te permite identificar cuáles alcaldías registraron más llamadas al 911 durante el periodo observado. Es útil para reconocer zonas de alta demanda de servicios de emergencia

```sql
CREATE OR REPLACE VIEW vista_incidentes_reportados_alcaldia AS(
    SELECT
      uc.alcaldia_cierre,
      c.categoria_incidente,
      COUNT(*) AS total_reportes
    FROM llamada l
    JOIN ubicacion_cierre uc ON l.ubicacion_cierre_id = uc.id
    JOIN clasificacion c ON l.clasificacion_id = c.id
    GROUP BY uc.alcaldia_cierre, c.categoria_incidente
    ORDER BY c.categoria_incidente, total_reportes DESC
                                                              );
```

### Total de llamadas por colonia dentro de cada alcaldía ordenadas por mas llamadas

Este desglose permite identificar las colonias con más llamadas dentro de cada alcaldía. Sirve para detectar focos de atención prioritaria a nivel de calle y justificar decisiones de política pública local, como patrullajes, botones de pánico, campañas de prevención, etc.

```sql
CREATE OR REPLACE VIEW vista_top3_colonias_por_emergencia AS (
    WITH llamadas_ranked AS (
      SELECT
          clasificacion.clas_con_falsa_alarma,
          uc.alcaldia_cierre,
          uc.colonia_cierre,
          COUNT(*) AS total_llamadas,
          ROW_NUMBER() OVER (
              PARTITION BY clasificacion.clas_con_falsa_alarma, uc.alcaldia_cierre
              ORDER BY COUNT(*) DESC
          ) AS rn
      FROM llamada l
      JOIN ubicacion_cierre uc ON l.ubicacion_cierre_id = uc.id
      JOIN clasificacion ON l.clasificacion_id = clasificacion.id
      GROUP BY clasificacion.clas_con_falsa_alarma, uc.alcaldia_cierre, uc.colonia_cierre
    )
    SELECT
        clas_con_falsa_alarma,
        alcaldia_cierre,
        colonia_cierre,
        total_llamadas
    FROM llamadas_ranked
    WHERE rn <= 3
    ORDER BY clas_con_falsa_alarma, total_llamadas DESC
    );
```

### Cantidad de llamadas a través del tiempo

Esta consulta nos permite analizar el volumen de llamadas que se realizaron a travez del tiempo. De esta forma, podemos concluir si hubo mas o menos disturbios reportados en la evolución de la pandemia. Así podremos descartar o asegurar la incidencia de ciertos delitos cuando las personas no salian a las calles.

```sql
SELECT 
  EXTRACT(MONTH FROM fecha_creacion) AS mes_creacion,
  COUNT(*) AS total_llamadas
FROM llamadas_911
WHERE EXTRACT(YEAR FROM fecha_creacion) = 2020
GROUP BY mes_creacion
ORDER BY mes_creacion;
```

### Promedio del tiempo total de respuesta por alcaldía

Estas dos consultas permiten analizar el promedio en horas del tiempo total de respuesta por alcaldía dividido por el primer semestre y segundo semestre de 2020. Con esto, tenemos la información con respecto a la velocidad promedio de respuesta por parte de las autoridades para resolver los casos en las distintas alcaldías. De este modo, podemos ver si hay preferencia en algunas zonas con respecto a otras.

Primer semestre

```sql
SELECT alcaldia_cierre, SUM(((fecha_cierre - fecha_creacion)*24 + ROUND(EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0, 2)))/COUNT(alcaldia_cierre) AS horas
FROM llamadas_911
WHERE fecha_creacion<'2020-6-30'
GROUP BY alcaldia_cierre
ORDER BY horas DESC;
```

Segundo semestre

```sql
SELECT alcaldia_cierre, SUM(((fecha_cierre - fecha_creacion)*24 + ROUND(EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0, 2)))/COUNT(alcaldia_cierre) AS horas
FROM llamadas_911
WHERE fecha_creacion>='2020-6-30'
GROUP BY alcaldia_cierre
ORDER BY horas DESC;
```

### Alcaldías con tiempo promedio de respuesta mayor al promedio total

Una vez que revisamos cuál es el promedio por alcaldía, es de interés conocer aquellas en donde el promedio de dicha alcaldía es mayor al promedio en general de respuesta de todas las alcaldías en todo el año. Para ver qué alcaldías están siendo más tardadas en ser atendidas en promedio. Para esto, se ejecuta la siguiente consulta

```sql
WITH promedio_total AS (
    SELECT 
        SUM(((fecha_cierre - fecha_creacion) * 24 + 
             EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)) / COUNT(*) AS tiempo
    FROM llamadas_911
),
tiempos_por_alcaldia AS (
    SELECT 
        alcaldia_cierre, 
        SUM(((fecha_cierre - fecha_creacion) * 24 + 
             EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)) / COUNT(*) AS horas
    FROM llamadas_911
    GROUP BY alcaldia_cierre
)

SELECT tpa.alcaldia_cierre, tpa.horas
FROM tiempos_por_alcaldia tpa
JOIN promedio_total pt ON TRUE
WHERE tpa.horas > pt.tiempo
ORDER BY tpa.horas DESC;Consultas para análisis superiores
```

### Tiempo total de respuesta por colonia

Así como se hizo un debido análisis de las alcaldías, de igual manera se realiza para las colonias en donde se ve el tiempo total de respuesta. De igual manera para identificar distintos patrones en tiempo de atención y resolución de problemas.

```sql
SELECT colonia_cierre, SUM(((fecha_cierre - fecha_creacion)*24 + ROUND(EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0, 2))) AS horas
FROM llamadas_911
GROUP BY colonia_cierre
ORDER BY horas DESC;
```

### Colonias con tiempo de respuesta por arriba del promedio

Se discrimina en esta consulta a las colonias con mayor tiempo de respuesta con respecto al promedio para identificar zonas de interés para mejorar el servicio de atención. E igual se calcula su variación de tiempo para determinar qué tan alejado está del promedio.

```sql
WITH promedio_total AS (
    SELECT 
        SUM(((fecha_cierre - fecha_creacion) * 24 + 
             EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)) / COUNT(*) AS tiempo
    FROM llamadas_911
),
tiempos_por_colonia AS (
    SELECT 
        colonia_cierre, 
        SUM(((fecha_cierre - fecha_creacion) * 24 + 
             EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)) / COUNT(*) AS horas
    FROM llamadas_911
    GROUP BY colonia_cierre
)

SELECT tpc.colonia_cierre, tpc.horas
FROM tiempos_por_colonia tpc
JOIN promedio_total pt ON TRUE
WHERE tpc.horas > pt.tiempo
ORDER BY tpc.horas DESC;
```

### Colonias con tiempo de respuesta por debajo del promedio

Al igual que el análisis de las colonias con un tiempo de espera superior al promedio se realiza el estudio pertinente para aquellas colonias con menor tiempo de respuesta. A pesar de que el tiempo sea menor, también hace falta ver las condiciones favorables o no de la resolución de la llamada.

```sql
WITH promedio_total AS (
    SELECT 
        SUM(((fecha_cierre - fecha_creacion) * 24 + 
             EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)) / COUNT(*) AS tiempo
    FROM llamadas_911
),
tiempos_por_colonia AS (
    SELECT 
        colonia_cierre, 
        SUM(((fecha_cierre - fecha_creacion) * 24 + 
             EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)) / COUNT(*) AS horas
    FROM llamadas_911
    GROUP BY colonia_cierre
)

SELECT tpc.colonia_cierre, tpc.horas
FROM tiempos_por_colonia tpc
JOIN promedio_total pt ON TRUE
WHERE tpc.horas <= pt.tiempo
ORDER BY tpc.horas DESC;
```

—

