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
- Inicialmente, se realizará un mapeo general de los incidentes para identificar patrones y tendencias en la distribución de emergencias, incluyendo tanto delitos  visibles como aquellos de impacto socioemocional derivados del confinamiento. 
- Posteriormente, el estudio se centrará en un análisis comparativo entre colonias con 
diferentes condiciones socioeconómicas, explorando cómo se vivió la pandemia en 
términos de seguridad, tiempos de respuesta y tipos de incidentes reportados.
	-Se evaluará si existen contrastes significativos en la atención recibida y en la percepción de inseguridad, considerando los prejuicios asociados a colonias tradicionalmente catalogadas como peligrosas frente a aquellas consideradas privilegiadas. Este enfoque permitirá comprender las desigualdades en la gestión de emergencias y contribuir a una discusión más informada sobre seguridad y acceso a servicios en la ciudad.

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
    folio TEXT PRIMARY KEY,
    categoria_incidente_c4 TEXT,
    incidente_c4 TEXT,
    anio_creacion SMALLINT,
    mes_creacion TEXT,
    fecha_creacion DATE,
    hora_creacion TIME,
    anio_cierre SMALLINT,
    mes_cierre TEXT,
    fecha_cierre DATE,
    hora_cierre TIME,
    codigo_cierre TEXT,
    clas_con_f_alarma TEXT,
    alcaldia_cierre TEXT,
    colonia_cierre TEXT,
    manzana TEXT,
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

- Frecuencia por categoría:
```sql
SELECT COUNT(*) AS frecuencia,
		categoria_incidente_c4
FROM llamadas_911
GROUP BY categoria_incidente_c4
ORDER BY COUNT(*) DESC;
```
- Frecuencia por incidente:
```sql
SELECT COUNT(*) AS frecuencia,
		incidente_c4
FROM llamadas_911
GROUP BY incidente_c4
ORDER BY COUNT(*) DESC;
```
- Frecuencia por alcaldía:
```sql
SELECT COUNT(*) AS frecuencia,
		alcaldia_cierre
FROM llamadas_911
GROUP BY alcaldia_cierre
ORDER BY COUNT(*) DESC;
```
- Frecuencia por colonia:
```sql
SELECT COUNT(*) AS frecuencia,
		colonia_cierre
FROM llamadas_911
GROUP BY colonia_cierre
ORDER BY COUNT(*) DESC;
```
- Máximos y mínimos
Obtener los máximos y mínimos de cada uno de los atributos es esencial para saber cómo se acota nuestra información. Además, nos ayuda a ver la cantidad relativa de cada uno de los valores de cada tupla. Para obtener los valores mínimos y máximos se realizó la siguiente consulta:

```sql
SELECT 	MIN(anio_creacion) AS min_anio_creacion,MAX(anio_creacion) AS max_anio_creacion,
		MIN(fecha_creacion) AS min_fecha_creacion,MAX(fecha_creacion) AS max_fecha_creacion,
		MIN(hora_creacion) AS min_hora_creacion, MAX(hora_creacion) AS max_hora_creacion,
		MIN(anio_cierre) AS min_anio_cierre, MAX(anio_cierre) AS max_anio_cierre,
		MIN(fecha_cierre) AS min_fecha_cierre, MAX(fecha_cierre) AS max_fecha_cierre,
FROM llamadas_911;
```
- Valores nulos 
### 7. Limpieza de datos 
Para optimizar nuestro análisis, eliminamos las columnas longitud, latitud y manzana, ya que la precisión geoespacial que aportaban no era necesaria para nuestros objetivos. Además, identificamos valores nulos en la columna manzana y decidimos eliminarlos para mantener la coherencia en los datos. Por otro lado, detectamos una inconsistencia en los nombres de una delegación, ya que "Cuajimalpa" y "Cuajimalpa de Morelos" aparecían como entradas separadas. Para evitar duplicidades y asegurar la uniformidad en la información, unificamos ambas bajo una única denominación estándar. Estas acciones nos permitieron depurar la base de datos y garantizar una estructura más limpia y confiable para el análisis.

Dicho lo anterior, para realizar la limpieza de los datos debe proceder a escribir las siguientes instrucciones en el editor (TablePlus).

```sql
ALTER TABLE llamadas_911  
DROP COLUMN latitud,  
DROP COLUMN longitud,  
DROP COLUMN manzana;

UPDATE llamadas_911 
SET alcaldia_cierre = 'CUAJIMALPA' 
WHERE alcaldia_cierre IN ('CUAJIMALPA','CUAJIMALPA DE MORELOS');
```
