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
El objetivo es analizar los fenómenos derivados del confinamiento durante la pandemia de COVID-19 en la CDMX, a través del análisis de llamadas al 911 relacionadas con:
- Violencia (doméstica, agresiones, disturbios, robos, etc.).
- Intentos de suicidio y crisis emocionales.
- Maltrato animal y abandono.
- Enfermedades y fallecimientos en domicilio.

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
2. **Instalar dependencias** (si aplica):
   ```sh
   pip install -r requirements.txt
   ```
3. **Ejecutar análisis**:
   ```sh
   python analisis.py
   ```

---
Este proyecto busca aportar información relevante para entender los efectos del confinamiento en las emergencias reportadas al 911 en la CDMX. 📞
