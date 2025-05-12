-- ======================================
-- SCRIPT PARA EJECUCIÓN DEL PROYECTO 911 CDMX
-- Instrucciones: Ejecutar con \i script_proyecto_911.sql
-- Este script asume que la tabla llamadas_911 ya fue cargada vía CSV
-- ======================================

-- 1. CREAR RESPALDO
--DROP TABLE IF EXISTS llamadas_911_respaldo;
CREATE TABLE llamadas_911_respaldo AS SELECT * FROM llamadas_911;

-- 2. LIMPIEZA DE COLUMNAS REDUNDANTES
ALTER TABLE llamadas_911
DROP COLUMN latitud,
DROP COLUMN longitud,
DROP COLUMN manzana,
DROP COLUMN anio_creacion,
DROP COLUMN anio_cierre,
DROP COLUMN mes_creacion,
DROP COLUMN mes_cierre;

-- 3. LIMPIEZA DE INCONSISTENCIAS EN TEXTO Y FORMATO

-- Eliminar valores nulos en los atributos colonia_cierre o alcaldia_cierre
DELETE *
FROM llamadas_911
WHERE colonia_cierre IS NULL OR alcaldia_cierre IS NULL;

-- Unificamos valores como 'N/A', 'NULL' y nombres de alcaldías inconsistentes
UPDATE llamadas_911
SET alcaldia_cierre = NULL
WHERE alcaldia_cierre IN ('N/A', 'NULL');

UPDATE llamadas_911
SET colonia_cierre = NULL
WHERE colonia_cierre IN ('N/A', 'NULL');

UPDATE llamadas_911
SET alcaldia_cierre = 'CUAJIMALPA DE MORELOS'
WHERE UPPER(alcaldia_cierre) LIKE '%CUAJIMALPA%';

-- 4. ELIMINAR REGISTROS CON INCONSISTENCIAS DE FECHA Y HORA
DELETE FROM llamadas_911
WHERE hora_cierre < hora_creacion AND fecha_cierre <= fecha_creacion;

-- 5. ELIMINAR LLAMADAS CLASIFICADAS COMO FALSA ALARMA
DELETE FROM llamadas_911
WHERE LOWER(clas_con_f_alarma) LIKE '%falsa alarma%';

-- 6. CREACIÓN DE TABLAS NORMALIZADAS
DROP TABLE IF EXISTS ubicacion_cierre CASCADE;
CREATE TABLE ubicacion_cierre (
    id BIGSERIAL PRIMARY KEY,
    colonia_cierre VARCHAR(150) NOT NULL,
    alcaldia_cierre VARCHAR(100) NOT NULL,
    UNIQUE(colonia_cierre, alcaldia_cierre)
);

DROP TABLE IF EXISTS clasificacion CASCADE;
CREATE TABLE clasificacion (
    id BIGSERIAL PRIMARY KEY,
    incidente VARCHAR(100) NOT NULL,
    categoria_incidente VARCHAR(100) NOT NULL,
    clas_con_falsa_alarma VARCHAR(100)
);

DROP TABLE IF EXISTS llamada;
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


-- 7. INSERTAR EN TABLAS NORMALIZADAS
INSERT INTO ubicacion_cierre (colonia_cierre, alcaldia_cierre)
SELECT DISTINCT colonia_cierre, alcaldia_cierre
FROM llamadas_911;

INSERT INTO clasificacion (incidente, categoria_incidente, clas_con_falsa_alarma)
SELECT DISTINCT incidente_c4, categoria_incidente_c4, clas_con_f_alarma
FROM llamadas_911;

    --verificamos que los datos se hayan insertado bien
SELECT COUNT(*) FROM ubicacion_cierre;
SELECT COUNT(*) FROM clasificacion;

    --Tabla llamada
INSERT INTO llamada (
    folio,
    fecha_creacion,
    hora_creacion,
    fecha_cierre,
    hora_cierre,
    codigo_cierre,
    ubicacion_cierre_id,
    clasificacion_id
)
SELECT
    llamada.folio,
    llamada.fecha_creacion,
    llamada.hora_creacion,
    llamada.fecha_cierre,
    llamada.hora_cierre,
    SUBSTRING(llamada.codigo_cierre FROM 1 FOR 1),
    ubicierre.id AS ubicacion_cierre_id,
    clasif.id    AS clasificacion_id
FROM llamadas_911 AS llamada
JOIN ubicacion_cierre AS ubicierre
  ON llamada.colonia_cierre = ubicierre.colonia_cierre
  AND llamada.alcaldia_cierre = ubicierre.alcaldia_cierre
JOIN clasificacion AS clasif
  ON llamada.incidente_c4 = clasif.incidente
  AND llamada.categoria_incidente_c4 = clasif.categoria_incidente
  AND llamada.clas_con_f_alarma = clasif.clas_con_falsa_alarma;


-- 8. ELIMINAR LA TABLA ORIGINAL Y SU RESPALDO
DROP TABLE IF EXISTS llamadas_911;
DROP TABLE IF EXISTS llamadas_911_respaldo;

-- 9. CREAR VISTA PARA CONSULTAS SIMPLIFICADAS
CREATE VIEW llamadas_911 AS (
  SELECT
    l.folio,
    l.fecha_creacion,
    l.hora_creacion,
    l.fecha_cierre,
    l.hora_cierre,
    l.codigo_cierre,
    ubicierre.colonia_cierre,
    ubicierre.alcaldia_cierre,
    clasi.incidente,
    clasi.categoria_incidente,
    clasi.clas_con_falsa_alarma
  FROM llamada AS l
  JOIN ubicacion_cierre AS ubicierre ON l.ubicacion_cierre_id = ubicierre.id
  JOIN clasificacion AS clasi ON l.clasificacion_id = clasi.id
);

