-- ======================================
-- SCRIPT PARA EJECUCIÓN DEL PROYECTO 911 CDMX
-- Instrucciones: Ejecutar con \i script_proyecto_911.sql
-- Este script asume que la tabla llamadas_911 ya fue cargada vía CSV
-- ======================================

-- 1. CREAR RESPALDO
DROP TABLE IF EXISTS llamadas_911_respaldo;
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
DELETE 
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




 -- Vista para consulta de llamadas a traves de los meses
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

---Indica, por semestre, numero de llamadas por clasificacion en cada colonia: 

CREATE VIEW clasificacion_por_colonias AS
SELECT 
    colonia_cierre, 
    SUM(CASE WHEN clas_con_falsa_alarma = 'DELITO' THEN 1 ELSE 0 END) AS Delitos,
    SUM(CASE WHEN clas_con_falsa_alarma = 'EMERGENCIA' THEN 1 ELSE 0 END) AS Emergencias,
    SUM(CASE WHEN clas_con_falsa_alarma = 'FALTA CÍVICA' THEN 1 ELSE 0 END) AS Falta_Civica,
    SUM(CASE WHEN clas_con_falsa_alarma = 'SERVICIO' THEN 1 ELSE 0 END) AS Servicio,
    SUM(CASE WHEN clas_con_falsa_alarma = 'URGENCIAS MEDICAS' THEN 1 ELSE 0 END) AS Urgencias_Medicas
FROM 
    llamadas_911
WHERE 
    fecha_creacion >= '2020-06-30' ------cambiar de acuerdo al semestre 
GROUP BY 
    colonia_cierre;
    
----Indica, por semestre, numero de llamadas por clasificacion en cada alcaldía

CREATE VIEW clasificacion_por_alcaldias AS
	SELECT 
    alcaldia_cierre, 
    SUM(CASE WHEN clas_con_falsa_alarma = 'DELITO' THEN 1 ELSE 0 END) AS Delitos,
    SUM(CASE WHEN clas_con_falsa_alarma = 'EMERGENCIA' THEN 1 ELSE 0 END) AS Emergencias,
    SUM(CASE WHEN clas_con_falsa_alarma = 'FALTA CÍVICA' THEN 1 ELSE 0 END) AS Falta_Civica,
    SUM(CASE WHEN clas_con_falsa_alarma = 'SERVICIO' THEN 1 ELSE 0 END) AS Servicio,
    SUM(CASE WHEN clas_con_falsa_alarma = 'URGENCIAS MEDICAS' THEN 1 ELSE 0 END) AS Urgencias_Medicas
FROM 
    llamadas_911
WHERE 
    fecha_creacion >= '2020-06-30'
GROUP BY 
    alcaldia_cierre;
   
  

--------  Porcentaje de delitos(clasificación) por alcaldia y colonia

CREATE VIEW llamadas_densas_clasificacion_alcaldia AS (
SELECT 
  alcaldia_cierre,
  clas_con_falsa_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY alcaldia_cierre), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY alcaldia_cierre, clas_con_falsa_alarma
ORDER BY alcaldia_cierre, porcentaje_llamadas DESC
);


CREATE VIEW llamadas_densas_clasificacion_colonia AS (
SELECT 
  colonia_cierre,
  clas_con_falsa_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY colonia_cierre), 2) || ' %' AS porcentaje_llamadas 
FROM llamadas_911
GROUP BY colonia_cierre, clas_con_falsa_alarma
ORDER BY colonia_cierre, porcentaje_llamadas DESC);


---------- Porcentajes de delitos(categoria) por alcaldía y colonia

CREATE VIEW llamadas_densas_categoria_alcaldia AS (
SELECT 
  alcaldia_cierre,
  categoria_incidente,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY alcaldia_cierre), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
WHERE fecha_creacion >= '2020-06-30'
GROUP BY alcaldia_cierre, categoria_incidente
ORDER BY alcaldia_cierre, porcentaje_llamadas DESC);

CREATE VIEW llamadas_densas_categoría_colonia AS(
SELECT 
  colonia_cierre,
  categoria_incidente,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY colonia_cierre), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
WHERE fecha_creacion >= '2020-06-30'
GROUP BY colonia_cierre, categoria_incidente
ORDER BY colonia_cierre, porcentaje_llamadas DESC);



--------Porcentajes de delitos por mes

CREATE VIEW llamadas_clasificacion_mes AS (
SELECT 
  EXTRACT(MONTH FROM fecha_creacion) AS mes_creacion,
  clas_con_falsa_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(MONTH FROM fecha_creacion)), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY mes_creacion, clas_con_falsa_alarma
ORDER BY mes_creacion, porcentaje_llamadas DESC
);

CREATE VIEW llamadas_categoria_mes AS (
SELECT 
  EXTRACT(MONTH FROM fecha_creacion) AS mes_creacion,
  categoria_incidente,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY EXTRACT(MONTH FROM fecha_creacion)), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY mes_creacion, categoria_incidente
ORDER BY mes_creacion, porcentaje_llamadas DESC
);

CREATE VIEW compara_semestres_clas AS (
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
  END AS semestre,
  clas_con_falsa_alarma,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY 
    CASE 
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
    END
  ), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY semestre, clas_con_falsa_alarma
ORDER BY semestre, porcentaje_llamadas DESC);


CREATE VIEW compara_semestres_cate AS (
SELECT 
  CASE 
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
    WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
  END AS semestre,
  categoria_incidente,
  ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY 
    CASE 
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 1 AND 6 THEN 'Semestre 1'
      WHEN EXTRACT(MONTH FROM fecha_creacion) BETWEEN 7 AND 12 THEN 'Semestre 2'
    END
  ), 2) || ' %' AS porcentaje_llamadas
FROM llamadas_911
GROUP BY semestre, categoria_incidente
ORDER BY semestre, porcentaje_llamadas DESC);

---codigos de cierre por semestre (alcaldias y colonias)
CREATE VIEW codigo_cierre_alcaldia_1er_semestre1 AS(
SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) 
    FROM llamadas_911 
    WHERE fecha_creacion <= '2020-06-30'), 2)::TEXT || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE fecha_creacion <= '2020-06-30'
GROUP BY codigo_cierre
ORDER BY cantidad DESC
);

CREATE VIEW codigo_cierre_alcaldia_2do_semestre2 AS (
SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) 
    FROM llamadas_911 
    WHERE fecha_creacion >= '2020-06-30'), 2)::TEXT || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE fecha_creacion >= '2020-06-30'
GROUP BY codigo_cierre
ORDER BY cantidad DESC
);

CREATE VIEW codigo_cierre_colonia_1er_semestre AS (
SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND((COUNT(*) * 100.0) / (
    SELECT COUNT(*) 
    FROM llamadas_911 
    WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion <= '2020-06-30'), 2)::TEXT || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion <= '2020-06-30'
GROUP BY codigo_cierre
ORDER BY cantidad DESC
);

CREATE VIEW codigo_cierre_colonia_2do_semestre AS(
SELECT 
  codigo_cierre, 
  COUNT(*) AS cantidad, 
  ROUND((COUNT(*) * 100.0) / (
    SELECT COUNT(*) 
    FROM llamadas_911 
    WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion >= '2020-06-30'), 2)::TEXT || ' %' AS llamadas_densas_codigo_cierre
FROM llamadas_911
WHERE colonia_cierre = 'POLANCO REFORMA (POLANCO)' AND fecha_creacion >= '2020-06-30'
GROUP BY codigo_cierre
ORDER BY cantidad DESC
);

--Promedio del tiempo total de respuesta por alcaldía

--Primer semestre
CREATE VIEW promedio_tiempo_total_respuesta_s1 AS (
	SELECT alcaldia_cierre, ROUND(SUM(((fecha_cierre - fecha_creacion)*24 + ROUND(EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0, 2)))/COUNT(alcaldia_cierre),2) AS promedio_horas
	FROM llamadas_911
	WHERE fecha_creacion<'2020-6-30'
	GROUP BY alcaldia_cierre
ORDER BY promedio_horas DESC);

--Segundo semestre
CREATE VIEW promedio_tiempo_total_respuesta_s2 AS (
	SELECT alcaldia_cierre, ROUND(SUM((fecha_cierre - fecha_creacion)*24 + EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0)/COUNT(alcaldia_cierre),2) AS horas
	FROM llamadas_911
	WHERE fecha_creacion>='2020-6-30'
	GROUP BY alcaldia_cierre
	ORDER BY horas DESC
);

--Alcaldías con tiempo promedio de respuesta mayor al promedio total



CREATE VIEW alcaldias_tiempo_respuesta_mayor_al_promedio AS (
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

	SELECT tpa.alcaldia_cierre, ROUND(tpa.horas,2)
	FROM tiempos_por_alcaldia tpa
	JOIN promedio_total pt ON TRUE
	WHERE tpa.horas > pt.tiempo
	ORDER BY tpa.horas DESC
);

--Tiempo total de respuesta por colonia
CREATE VIEW tiempo_total_de_respuesta_por_colonia AS (
	SELECT colonia_cierre, ROUND(SUM(((fecha_cierre - fecha_creacion)*24 + ROUND(EXTRACT(EPOCH FROM (hora_cierre - hora_creacion)) / 3600.0, 2))),2) AS horas
	FROM llamadas_911
	GROUP BY colonia_cierre
	ORDER BY horas DESC
);

--Colonias con tiempo de respuesta por arriba del promedio


CREATE VIEW colonias_tiempo_respuesta_mayor_al_promedio AS (
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
	SELECT tpc.colonia_cierre, ROUND(tpc.horas,2)
	FROM tiempos_por_colonia tpc
	JOIN promedio_total pt ON TRUE
	WHERE tpc.horas > pt.tiempo
	ORDER BY tpc.horas DESC
);

--Colonias con tiempo de respuesta por debajo del promedio


CREATE VIEW colonias_tiempo_respuesta_menor_al_promedio AS (

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
	SELECT tpc.colonia_cierre, ROUND(tpc.horas,2)
	FROM tiempos_por_colonia tpc
	JOIN promedio_total pt ON TRUE
	WHERE tpc.horas <= pt.tiempo
	ORDER BY tpc.horas DESC
);

----Muestra top 3 colonias por emergencia

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

--Incidentes más reportados por alcaldia
CREATE OR REPLACE VIEW vista_incidentes_reportados_alcaldia AS(
    SELECT
      uc.alcaldia_cierre,
      COUNT(*) AS total_reportes
    FROM llamada l
    JOIN ubicacion_cierre uc ON l.ubicacion_cierre_id = uc.id
    GROUP BY uc.alcaldia_cierre
    ORDER BY  total_reportes DESC
);
