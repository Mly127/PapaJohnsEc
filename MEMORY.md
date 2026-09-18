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
* **Objetivo Principal:** Diseñar e implementar un pipeline automatizado de datos para **Papa John's Ecuador**, migrando información desde Microsoft SQL Server hacia Google BigQuery, orquestando las cargas mediante Google Cloud Functions y Cloud Scheduler, y replicando los tableros analíticos en Looker Studio a partir del modelo institucional de lealtad.
* **Componentes Clave:**
  1. **Extracción y Carga (ETL/ELT):** Extracción de tablas/vistas de SQL Server (`SBPAPAJOHNS`) y carga directa hacia Google BigQuery (`papajohnsec.papajohns_loyalty_ec`).
  2. **Automatización Serverless & Scripts:** Google Cloud Functions Gen2 (Python 3.11) y scripts Python de extracción modular.
  3. **Orquestación y Horarios:** Google Cloud Scheduler para disparar las Cloud Functions o jobs de sincronización diaria.
  4. **Capa de Vistas Analíticas:** 8 vistas SQL estándar en BigQuery con zona horaria de Ecuador (`America/Guayaquil`).
  5. **Visualización y Analítica:** Tablero en Looker Studio clonado y mapeado a partir del dashboard de lealtad de Tim Hortons.
* **Stack Tecnológico:**
  * **Origen:** SQL Server (`192.168.20.68:1433 / SBPAPAJOHNS`) / `pymssql` / `pyodbc`
  * **Destino:** Google BigQuery (`google-cloud-bigquery`, `pyarrow`, `pandas`)
  * **Cómputo / Serverless:** Google Cloud Functions (Gen2 / Python 3.11)
  * **Orquestación:** Google Cloud Scheduler (`0 3 * * *` / America/Guayaquil)
  * **Visualización:** Looker Studio

---

## 🔑 3. Configuración de Entornos y Accesos

### A. Base de Datos Origen (SQL Server)
* **Host:** `192.168.20.68`
* **Puerto:** `1433`
* **Base de Datos:** `SBPAPAJOHNS`
* **Usuario:** `upapajohns`
* **Contraseña:** `Pla!npart17`

### B. Google Cloud Platform (GCP)
* **Usuario GCP:** `melissah@loymark.com`
* **Proyecto ID:** `papajohnsec` (Nombre: `PapaJohnsEC`, Número: `977058381367`)
* **BigQuery Dataset ID:** `papajohns_loyalty_ec` (Ubicación: `US`)
* **Zona Horaria del Modelo:** `America/Guayaquil` (UTC-5)

### C. Referencia Looker Studio (Tim Hortons)
* **URL Reporte Base Tim Hortons:** [https://datastudio.google.com/u/0/reporting/c6e89780-1db6-4a4e-948c-dbaa6f0839d5/page/p_s71dlbcxnd/edit](https://datastudio.google.com/u/0/reporting/c6e89780-1db6-4a4e-948c-dbaa6f0839d5/page/p_s71dlbcxnd/edit)
* **Dataset Referencia:** `timhorton-loyaltymx.Loyalty`

---

## 🏗️ 4. Arquitectura y Decisiones Técnicas
| Fecha | Decisión | Razón / Justificación | Estado |
| :--- | :--- | :--- | :--- |
| 2026-09-18 | Inicialización del repositorio y memoria | Establecer control de versiones con Git y trazabilidad desde el inicio | ✅ Completado |
| 2026-09-18 | Pipeline SQL Server -> BigQuery | Enfoque serverless, escalable y modular con soporte de tipado estricto PyArrow | ✅ Completado |
| 2026-09-18 | Replicación 1:1 de vistas analíticas de Tim Hortons Loyalty | Estandarización institucional del modelo de lealtad para Papa John's Ecuador | ✅ Completado |
| 2026-09-18 | Adaptación de tipos de fecha y zonas horarias | SQL Server usa datetimes nativos; se alinearon a `TIMESTAMP` en BigQuery y `America/Guayaquil` | ✅ Completado |
| 2026-09-18 | Capa analítica en Looker Studio | Reutilización directa del dashboard de Tim Hortons mediante sustitución de fuentes | ✅ Listo para clonar |

---

## 📋 5. Registro de Sesiones y Avances (Log de Trabajo)

### 🗓️ Sesión 1 — 18 de Septiembre de 2026
* **Acciones realizadas:**
  1. **Inicialización y Control de Versiones:**
     * Inicialización del repositorio Git local y conexión al repositorio remoto [`https://github.com/Mly127/PapaJohnsEc`](https://github.com/Mly127/PapaJohnsEc).
     * Configuración de `.gitignore`, `README.md` y `MEMORY.md`.
  2. **Análisis del Modelo de Referencia (Tim Hortons):**
     * Conexión a `timhorton-loyaltymx.Loyalty` en BigQuery y volcado completo de DDLs y consultas de las 8 vistas analíticas en `references/timhortons_loyalty_structure.sql`.
  3. **Conexión y Mapeo de SQL Server (`SBPAPAJOHNS`):**
     * Conexión validada a `192.168.20.68:1433`.
     * Mapeo de tablas: `Accounts`, `RetailTransactionHeaders`, `RetailTransactionDetails`, `CashMovements` (como `RetailTransactionCash`), `Bonus`, `SubEntities` (como `SubEntity`), `SRewards` (+ `Benefits`), `RewardRedemptions` y `TransactionTypes`.
  4. **Dataset y Pipeline en BigQuery:**
     * Creación del dataset `papajohnsec.papajohns_loyalty_ec`.
     * Carga y validación del 100% de los datos:
       * `Accounts`: 3,372 filas
       * `Bonus`: 304 filas
       * `RetailTransactionCash`: 1 fila
       * `RetailTransactionDetails`: 1,027 filas
       * `RetailTransactionHeaders`: 858 filas
       * `RewardRedemptions`: 0 filas
       * `SRewards`: 3 filas
       * `SubEntity`: 31 filas
       * `TransactionTypes`: 2 filas
  5. **Despliegue y Prueba de 8 Vistas Analíticas:**
     * `vw_Clientes`: 3,372 filas
     * `vw_ClientesDetalles`: 866 filas
     * `vw_Transacciones`: 858 filas
     * `vw_Puntos`: 858 filas
     * `vw_PuntosBono`: 304 filas
     * `vw_Canjes`: 0 filas
     * `vw_Cash`: 1 fila
     * `vw_wallet_txn_base`: 1 fila
  6. **Código de Cloud Function y Automatización:**
     * Código modular en `functions/extract_loyalty/` (`main.py`, `database.py`, `bigquery_loader.py`, `config.py`, `requirements.txt`).
     * Scripts de despliegue en `scripts/deploy_function.ps1`, `scripts/deploy_function.sh` y `scripts/create_views.py`.
  7. **Looker Studio:**
     * Documentación y validación del procedimiento de clonación 1:1 desde el reporte de Tim Hortons (`c6e89780-1db6-4a4e-948c-dbaa6f0839d5`).

---

## 🗺️ 6. Mapeo de Vistas a Páginas de Looker Studio

| Vista BigQuery | Fuente de Datos Homóloga | Página / Propósito en Dashboard |
| :--- | :--- | :--- |
| **`vw_Clientes`** | `timhorton-loyaltymx.Loyalty.vw_Clientes` | **Página 1: Resumen General de Clientes** (Registros, activos/inactivos, saldos acumulados de puntos y cash). |
| **`vw_ClientesDetalles`** | `timhorton-loyaltymx.Loyalty.vw_ClientesDetalles` | **Página 2: Comportamiento y Frecuencia** (Ticket promedio, frecuencia de compra, puntos generados por cliente). |
| **`vw_Transacciones`** | `timhorton-loyaltymx.Loyalty.vw_Transacciones` | **Página 3: Ventas por Sucursal** (Ventas totales, descuentos, transacciones por tienda, fecha y hora). |
| **`vw_Puntos`** | `timhorton-loyaltymx.Loyalty.vw_Puntos` | **Página 4: Programa de Puntos** (Puntos acumulados vs redimidos vs vencidos). |
| **`vw_PuntosBono`** | `timhorton-loyaltymx.Loyalty.vw_PuntosBono` | **Página 4 (Detalle): Bonificaciones** (Bonos promocionales y campañas de activación). |
| **`vw_Canjes`** | `timhorton-loyaltymx.Loyalty.vw_Canjes` | **Página 5: Catálogo y Redenciones** (Premios más solicitados, puntos invertidos en canjes). |
| **`vw_Cash`** | `timhorton-loyaltymx.Loyalty.vw_Cash` | **Página 6: Billetera Digital** (Ingresos vs egresos de saldo en wallet). |
| **`vw_wallet_txn_base`**| `timhorton-loyaltymx.Loyalty.vw_wallet_txn_base` | **Página 6 (Detalle): Ledger Transaccional** (Histórico y evolución de saldo de saldo de billetera). |

---

## 🚀 7. Guía Rápida para Clonar el Reporte de Looker Studio
1. Abrir el reporte base de Tim Hortons: [Looker Studio Link](https://datastudio.google.com/u/0/reporting/c6e89780-1db6-4a4e-948c-dbaa6f0839d5/page/p_s71dlbcxnd/edit).
2. Hacer clic en **⋮ (Más opciones)** > **Hacer una copia**.
3. Reemplazar cada una de las 8 fuentes de datos seleccionando:
   * **Conector:** BigQuery
   * **Proyecto:** `papajohnsec`
   * **Dataset:** `papajohns_loyalty_ec`
   * **Vista:** La vista con el mismo nombre.
4. Hacer clic en **Copiar informe**.
5. Cambiar el nombre a **Papa John's Ecuador - Loyalty Dashboard** y ajustar logotipos/colores.
