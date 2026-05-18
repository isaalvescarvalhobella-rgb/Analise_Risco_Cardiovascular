# 📊 Análisis de Riesgo Cardiovascular - Proyecto 2025

Este repositorio contiene un proyecto de análisis de datos clínicos centrado en el triaje de una clínica cardiológica. El objetivo principal es demostrar habilidades en la curaduría de datos con **Excel** y la gestión de bases de datos relacionales con **MySQL**.

## 📁 Estructura del Repositorio

- **`/data`**: Contiene el archivo de Excel original y el dataset final consolidado (`.csv`).
- **`/scripts`**: Scripts de SQL utilizados para la limpieza, normalización y enriquecimiento clínico.
- **`/docs`**: Documentación técnica, diccionario de datos y capturas de pantalla.

---

## 📁 Información del Proyecto

Este dataset representa el flujo de pacientes en una clínica de La Plata, Argentina, para fines de aprendizaje y análisis estadístico.

- **Registros:** 50 pacientes (Agosto 2025 - Diciembre 2025).
- **Indicadores:** 18 medidores originales + 10 columnas de inteligencia de datos creadas en SQL.
- **Alcance:** Anamnesis, examen físico y estudios complementarios (ECG y Perfil Lipídico).

---

## 🗂️ Fase 1: Estructura del Archivo Excel

El archivo principal `Triaje_Cardiologia_Clinico_2025.xlsx` se dividió en dos etapas de procesamiento inicial:

### 1. Hoja 1: Datos Brutos (Raw Data)
Contiene la información original recolectada (ID, Edad, Sexo, IMC, TAS/TAD, Perfil Lipídico, etc.).

### 2. Hoja 2: Procesamiento y Cálculos
Se realizó la limpieza de datos y creación de columnas calculadas:
- **Uso_Medicación**: Clasificación binaria para análisis de polifarmacia.
- **Alteraciones_ECG**: Identificación de hallazgos patológicos (No Sinusal).
- **Altura_m**: Conversión necesaria para estandarización de cálculos.

---

## 🗄️ Fase 2: Implementación e Inteligencia en SQL

Tras la migración a **MySQL**, se transformó el dataset estático en una base de datos dinámica con lógica médica avanzada basada en los consensos de la **Sociedad Argentina de Cardiología (SAC)**.

### 1. Limpieza y Normalización Técnica (ETL)
Se corrigieron errores de codificación y se estandarizaron registros para asegurar la integridad de la base:

```sql
-- Normalización de caracteres y mantenimiento de integridad técnica
UPDATE Cardiologia_2025 SET Antecedentes_Familiares = 'Si' WHERE Antecedentes_Familiares LIKE 'S%';
UPDATE Cardiologia_2025 SET Medicacion_Actual = 'Losartán' WHERE Medicacion_Actual LIKE 'Losart%';
```

### 2. Ingeniería de Atributos Clínicos

Se implementaron reglas de negocio para automatizar el diagnóstico de riesgo:

* **Categorización de HTA:** Clasificación automática en *Normotensión*, *Limítrofe* o *HTA*.
* **Perfil Menopáusico:** Identificación de mujeres en transición (≥ 40 años), factor clave para el aumento del riesgo cardiovascular.
* **Score de Riesgo Cardiovascular:** Algoritmo que clasifica al paciente en riesgo **Bajo, Medio o Alto** mediante la evaluación cruzada de 6 factores (HTA, LDL, Sedentarismo, Tabaquismo, Edad y Antecedentes).

### 3. Gestión de Metas (Medicina Basada en Evidencias)
Se creó un sistema de monitoreo de metas terapéuticas:

* **Objetivo_LDL:** Asignación de metas personalizadas (70, 100 o 130 mg/dl) según el riesgo del paciente.
* **Estado_Meta:** Columna que audita si el paciente "Cumple" o "No Cumple" con su objetivo de salud.

### 4. Análisis Temporal y Gestión Clínica
Se optimizó el dataset para identificar patrones de demanda en la clínica de La Plata:

* **Conversión de fechas:** Uso de `STR_TO_DATE` para transformar texto en objetos de fecha reales.
* **Extracción de Atributos:** Creación de las columnas **Día de la Semana** y **Nombre del Mes**.
---
## 📊 Fase 3: Visualización y Reporte Ejecutivo en Power BI

El cierre del proyecto consistió en la creación de un reporte de **7 páginas** bajo una estética **Premium Dark**, garantizando una alta jerarquía visual (títulos en `28pt`, textos corporativos en `16pt`) y un recorrido lógico y clínico para la toma de decisiones:

1. **Página 1: Dashboard Principal:** Panel ejecutivo de control con los KPIs e indicadores resumidos de la cohorte.
2. **Página 2: Portada / Contexto Institucional:** Introducción del marco metodológico y alineación con los consensos vigentes.
3. **Página 3: Análisis Demográfico y Poblacional:** Distribución por sexo y edad de los pacientes analizados.
4. **Página 4: Estratificación del Riesgo Cardiovascular:** Clasificación demográfica detallada por score de riesgo (Bajo, Medio y Alto).
5. **Página 5: Análisis por Variable y Perfil Hormonal:** Evaluación específica de la pérdida de protección estrogénica en la transición climatérica femenina.
6. **Página 6: Estilo de Vida y Diagnóstico Electrocardiográfico (ECG):** Cruce de factores conductuales modificables con hallazgos patológicos en el trazo eléctrico (isquemias, sobrecargas).
7. **Página 7: Estrategias y Líneas de Intervención de Equipo:** Tablero operativo final enfocado en la gestión del equipo de salud y búsqueda activa.

---

## 🎯 Plan de Acción Estratégico (Página 7)

La última lámina del reporte consolida la gestión operativa mediante tres directrices unificadas, justificadas visualmente mediante bloques simétricos parametrizados con los volúmenes demográficos exactos del territorio:

* **Estrategia A: Control de Pacientes Críticos (Auditoría e Intervención)**
  * **Objetivo:** Reducir la probabilidad de eventos cardiovasculares mayores (IAM/ACV) en el grupo de Riesgo Alto.
  * **Acción:** Búsqueda activa de **21 pacientes** prioritarios para control de laboratorio (Perfil Lipídico), optimización de la farmacoterapia ante inercia clínica y garantía de su seguimiento electrocardiográfico seriado.
* **Estrategia B: Prevención Primaria Focalizada (Salud del Varón y Vida Activa)**
  * **Objetivo:** Evitar la progresión de Riesgo Medio a Riesgo Alto en la población masculina.
  * **Acción:** Programa de seguimiento trimestral enfocado en los **16 varones** en Riesgo Medio, con énfasis en el control estricto de la Tensión Arterial y derivación coordinada hacia circuitos de actividad física supervisada en el CAPS.
* **Estrategia C: Monitoreo Especializado (Salud de la Mujer y Postas de Salud)**
  * **Objetivo:** Evaluar y mitigar el impacto del estatus hormonal en el riesgo cardiovascular femenino.
  * **Acción:** Implementación del programa *"Postas de Salud - Mujer"* enfocado en las **10 pacientes** de Riesgo Alto, cruzando datos de transición climatérica para el manejo interdisciplinario conjunto con el servicio de ginecología.

---

## 📥 Descarga del Archivo Nativo

Si deseas abrir el archivo nativo de Power BI (`.pbix`) en tu computadora para explorar el modelo de datos, las relaciones y las medidas implementadas, puedes descargarlo de forma directa a través del siguiente enlace:

👉 [**Descargar Archivo de Power BI (.pbix)**](https://drive.google.com/file/d/1WcUwqeotkzhC4kM4_qOQahaI_G3HfIMQ/view?usp=drive_link)
