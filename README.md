# Proyecto Final - Análisis de Llamadas al 911 en la CDMX

## Descripción General
Este proyecto analiza las llamadas realizadas al 911 en la Ciudad de México desde el primer semestre de 2019 hasta el primer semestre de 2022. La base de datos permite conocer la ubicación aproximada, motivo, descripción del incidente y la duración de atención a los diferentes llamados.

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
El objetivo de este proyecto es analizar las llamadas registradas al 911 durante el 
periodo de mayor incidencia de COVID-19 en la Ciudad de México, con el fin de 
comprender las principales emergencias y delitos reportados en distintas alcaldías y 
zonas. Inicialmente, se realizará un mapeo general de los incidentes para identificar 
patrones y tendencias en la distribución de emergencias, incluyendo tanto delitos 
visibles como aquellos de impacto socioemocional derivados del confinamiento. 

Posteriormente, el estudio se centrará en un análisis comparativo entre colonias con 
diferentes condiciones socioeconómicas, explorando cómo se vivió la pandemia en 
términos de seguridad, tiempos de respuesta y tipos de incidentes reportados. Se 
evaluará si existen contrastes significativos en la atención recibida y en la percepción 
de inseguridad, considerando los prejuicios asociados a colonias tradicionalmente 
catalogadas como peligrosas frente a aquellas consideradas privilegiadas. Este 
enfoque permitirá comprender las desigualdades en la gestión de emergencias y 
contribuir a una discusión más informada sobre seguridad y acceso a servicios en la 
ciudad.

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
Este proyecto busca aportar información relevante para entender los efectos del confinamiento en las emergencias reportadas al 911 en la CDMX. 📞

# 📊 Carga Inicial de Datos en PostgreSQL
## **1. Creación de la Base de Datos**

Para establecer el entorno de trabajo, es necesario crear la base de datos donde se almacenará la información. 

Ejecute el siguiente comando en `psql` para crear la base de datos:

```sql
CREATE DATABASE llamadas911;
```

Posteriormente, conéctese a la base de datos creada:

```bash
bash
CopiarEditar
psql -U usuario -d llamadas911

```

---

## **3. Creación del Esquema Inicial**

Para garantizar la correcta estructuración de los datos, es necesario ejecutar el siguiente script SQL, el cual define la tabla `llamadas_911` con sus respectivos atributos y tipos de datos:

### **3.1 Definición de la Tabla**

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

Este script debe ejecutarse en `psql` o cualquier cliente SQL compatible con PostgreSQL.

## **4. Importación de Datos desde un Archivo CSV**

Para cargar los datos en la tabla `llamadas_911`, es necesario importar el archivo CSV. 

### **4.1 Importación utilizando `psql`**

Puede utilizar el siguiente comando en `psql` para importar los datos:

```sql
\copy llamadas_911 FROM '/ruta/del/archivo/llamadas_911_utf8.csv' WITH (FORMAT CSV, HEADER true, DELIMITER ',');
```

### **5. Verificación de la Carga de Datos**

Una vez importados los datos, se recomienda ejecutar la siguiente consulta para verificar la correcta inserción de los registros:

```sql
SELECT * FROM llamadas_911 LIMIT 10;
```

Si los datos se han cargado correctamente, se visualizarán las primeras diez filas de la tabla.

### **6. Análisis exploratorio**

Se contabilizarán frecuencias como llamadas por categoría, por incidente, por alcaldía y colonia para poder agrupar distintas variables de interés de acuerdo a la frecuencia que se presente.
Frecuencia por categoría:
```sql
SELECT COUNT(*) AS frecuencia,
		categoria_incidente_c4
FROM llamadas_911
GROUP BY categoria_incidente_c4
ORDER BY COUNT(*) DESC;
```
Frecuencia por incidente:
```sql
SELECT COUNT(*) AS frecuencia,
		incidente_c4
FROM llamadas_911
GROUP BY incidente_c4
ORDER BY COUNT(*) DESC;
```
Frecuencia por alcaldía:
```sql
SELECT COUNT(*) AS frecuencia,
		alcaldia_cierre
FROM llamadas_911
GROUP BY alcaldia_cierre
ORDER BY COUNT(*) DESC;
```
Frecuencia por colonia:
```sql
SELECT COUNT(*) AS frecuencia,
		colonia_cierre
FROM llamadas_911
GROUP BY colonia_cierre
ORDER BY COUNT(*) DESC;
```
