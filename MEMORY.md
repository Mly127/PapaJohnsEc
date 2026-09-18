# 🧠 Memoria del Proyecto - PapaJohnsEc

Documento de seguimiento, decisiones técnicas, contexto y registro de avances para el proyecto **PapaJohnsEc**.

---

## 📌 1. Información General del Proyecto
* **Nombre del Proyecto:** PapaJohnsEc
* **Propietario / Responsable:** Melissa Herrera (Mly127)
* **Fecha de Inicio:** 18 de septiembre de 2026
* **Repositorio Remoto:** [https://github.com/Mly127/PapaJohnsEc](https://github.com/Mly127/PapaJohnsEc)
* **Rama Principal:** `main`

---

## 🎯 2. Objetivos y Alcance
* **Objetivo Principal:** Diseñar e implementar un pipeline automatizado de datos para **Papa John's Ecuador**, migrando información desde Microsoft SQL Server hacia Google BigQuery, orquestando las cargas mediante Google Cloud Functions y Cloud Scheduler, y construyendo tableros analíticos en Looker.
* **Componentes Clave:**
  1. **Extracción y Carga (ETL/ELT):** Extracción de tablas/vistas de SQL Server y carga hacia Google BigQuery.
  2. **Automatización serverless:** Google Cloud Functions (Python) para los procesos de ingesta.
  3. **Orquestación y Horarios:** Google Cloud Scheduler para disparar las Cloud Functions según los horarios requeridos.
  4. **Visualización y Analítica:** Modelado en BigQuery y desarrollo de dashboards en Looker / Looker Studio para Papa John's Ecuador.
* **Stack Tecnológico:**
  * **Origen:** SQL Server (MSSQL) / ODBC / `pyodbc` / `SQLAlchemy`
  * **Destino:** Google BigQuery (`google-cloud-bigquery`, `google-cloud-storage` si aplica carga vía staging)
  * **Cómputo / Serverless:** Google Cloud Functions (Gen2 / Python 3.11+)
  * **Orquestación:** Google Cloud Scheduler (Cron expressions)
  * **Visualización:** Looker / Looker Studio
  * **Control de versiones:** Git & GitHub (`Mly127/PapaJohnsEc`)

---

## 🏗️ 3. Arquitectura y Decisiones Técnicas
| Fecha | Decisión | Razón / Justificación | Estado |
| :--- | :--- | :--- | :--- |
| 2026-09-18 | Inicialización del repositorio y memoria | Establecer control de versiones con Git y trazabilidad desde el día 1 | Aprobado |
| 2026-09-18 | Pipeline SQL Server -> BigQuery vía Cloud Functions | Enfoque serverless, escalable y modular con ejecución programada por Cloud Scheduler | Aprobado |
| 2026-09-18 | Capa analítica en Looker conectada a BigQuery | Centralizar métricas de negocio de Papa John's Ecuador con alto rendimiento de consulta | Aprobado |

---

## 📋 4. Registro de Sesiones y Avances (Log de Trabajo)

### 🗓️ Sesión 1 — 18 de Septiembre de 2026
* **Definición del Proyecto:**
  * Pipeline completo: SQL Server -> Google Cloud Functions -> Google BigQuery -> Looker.
* **Acciones realizadas:**
  1. Inicialización de Git local y configuración de repositorio remoto en GitHub (`Mly127/PapaJohnsEc`).
  2. Creación del archivo de memoria de proyecto (`MEMORY.md`), `.gitignore` y `README.md`.
  3. Definición formal de arquitectura, objetivos y fases del roadmap.
* **Próximos pasos inmediatos:**
  * Diseñar la estructura de carpetas del repositorio para Cloud Functions, scripts SQL y esquemas de BigQuery.
  * Identificar tablas origen de SQL Server, frecuencia de carga y tipo de sincronización (Full Load vs Incremental/Delta).
  * Configurar variables de entorno y plantilla de conexión a SQL Server y BigQuery.

---

## 🗺️ 5. Roadmap / Fases del Proyecto

### 📍 Fase 1: Arquitectura y Conexiones Base
- [x] Inicializar repositorio Git y conectar a GitHub.
- [x] Documentar memoria del proyecto y alcance general.
- [ ] Definir estructura de carpetas modular (`functions/`, `sql/`, `schemas/`, `scripts/`, `config/`).
- [ ] Definir tablas origen de SQL Server, claves primarias y campos de fecha para deltas.
- [ ] Definir Dataset y tablas destino en BigQuery.

### 📍 Fase 2: Desarrollo de Cloud Functions (Ingesta y Transformación)
- [ ] Crear módulo de extracción de SQL Server (manejo eficiente de chunks/cursores).
- [ ] Crear módulo de carga a BigQuery (manejo de esquemas, particionado y clustering).
- [ ] Implementar lógica de cargas iniciales (Backfill / Full) y cargas incrementales (Delta).
- [ ] Crear `main.py` y `requirements.txt` para la(s) Cloud Function(s).

### 📍 Fase 3: Despliegue y Orquestación (Cloud Scheduler)
- [ ] Configurar Cloud Functions en Google Cloud Platform (GCP).
- [ ] Definir jobs de Cloud Scheduler con expresiones Cron por tabla/frecuencia.
- [ ] Configurar alertas y monitoreo de ejecución (Cloud Logging / Cloud Monitoring).

### 📍 Fase 4: Modelado Analítico y Looker
- [ ] Crear vistas / tablas agregadas optimizadas en BigQuery para consumo de BI.
- [ ] Conectar BigQuery con Looker / Looker Studio.
- [ ] Diseñar y validar dashboards de KPIs para Papa John's Ecuador.
