# 🧠 Memoria del Proyecto - PapaJohnsEc

Documento de seguimiento, decisiones técnicas, contexto, métricas y registro de avances para el proyecto **PapaJohnsEc**.

---

## 📌 1. Información General del Proyecto
* **Nombre del Proyecto:** PapaJohnsEc
* **Propietario / Responsable:** Melissa Herrera (Mly127)
* **Fecha de Inicio:** 18 de septiembre de 2026 (12:18 PM)
* **Repositorio Remoto:** [https://github.com/Mly127/PapaJohnsEc](https://github.com/Mly127/PapaJohnsEc)
* **Rama Principal:** `main`

---

## ⏱️ 2. Resumen de Dedicación y Tiempos

* **Total de Días Hábiles:** 4 días
* **Promedio Diario:** ~4.5 horas / día
* **Tiempo Total Invertido:** ~18 horas de trabajo efectivo

| Fecha | Jornada | Tiempo Dedicado | Principales Hitos Desarrollados |
| :--- | :---: | :---: | :--- |
| **Día 1: Vie 18 Sept** | 12:18 PM – 5:00 PM | **~4.5 horas** | • Conexión a SQL Server `SBPAPAJOHNS`.<br>• Creación del pipeline ETL y carga inicial de las 9 tablas a BigQuery.<br>• Creación y despliegue de las primeras 8 vistas analíticas. |
| **Fin de semana** | *19 y 20 Sept* | *Descanso* | *(Sin actividad)* |
| **Día 2: Lun 21 Sept** | 10:00 AM – 2:30 PM | **~4.5 horas** | • Creación del script operacional [`sync_data.py`](./scripts/sync_data.py).<br>• Creación de la vista [`09_vw_Clientes_Adopcion_KPIs.sql`](./sql/views/09_vw_Clientes_Adopcion_KPIs.sql) para recurrencia y vigencia.<br>• Conexión inicial y mapeo de fuentes en Looker Studio. |
| **Día 3: Mar 22 Sept** | 10:00 AM – 4:00 PM | **~5.5 horas** | • Configuración de parámetros y métricas de **ROAS** y formato condicional.<br>• Unificación de la vista maestra de clientes y puntos.<br>• Diagnóstico de páginas y diseño de la página **Base de Clientes & Vigencia**.<br>• Revisión visual de las pantallas del dashboard. |
| **Día 4: Mié 23 Sept** | 8:15 AM – 12:25 PM | **~4.0 horas** | • Sincronización exitosa SQL Server ➔ BigQuery (3.373 cuentas).<br>• Ajustes visuales de gráficos combinados/barras por sucursal.<br>• Pulido final de anchos, tipografías y encabezados de la tabla de clientes. |

---

## 🎯 3. Objetivos y Alcance
* **Objetivo Principal:** Diseñar e implementar un pipeline automatizado de datos para **Papa John's Ecuador**, migrando información desde Microsoft SQL Server hacia Google BigQuery, orquestando las cargas mediante scripts Python y Cloud Functions, y creando un tablero analítico en Looker Studio adaptado a las necesidades de negocio del cliente.
* **Requerimientos de Negocio del Dashboard:**
  1. 🔄 **Frecuencia de visita / compra** (Promedio de compras por cliente).
  2. 👥 **Recurrencia de clientes** (Clientes Nuevos vs Recurrentes vs Sin Compra).
  3. 📍 **Participación por Sucursal** (Ventas y volumen por tienda).
  4. 🎁 **Canjes y Redenciones del programa** (Puntos ganados vs redimidos).
  5. 💵 **Ticket promedio** (Gasto promedio por transacción).
  6. 📈 **Retorno publicitario (ROAS)** (Fórmula interactiva con control de presupuesto publicitario).
  7. 📋 **Base de clientes y Vigencia** (Tabla detallada con saldos de puntos, vigencia, compras, filtros y buscador).

---

## 🔑 4. Configuración de Entornos y Accesos

### A. Base de Datos Origen (SQL Server)
* **Host:** `192.168.20.68` | **Puerto:** `1433`
* **Base de Datos:** `SBPAPAJOHNS`
* **Usuario:** `upapajohns` | **Contraseña:** `Pla!npart17`

### B. Google Cloud Platform (GCP)
* **Usuario GCP:** `melissah@loymark.com`
* **Proyecto ID:** `papajohnsec` (Nombre: `PapaJohnsEC`, Número: `977058381367`)
* **BigQuery Dataset ID:** `papajohns_loyalty_ec` (Ubicación: `US`)
* **Zona Horaria del Modelo:** `America/Guayaquil` (UTC-5)

### C. URLs de Looker Studio
* **Reporte Papa John's Ecuador (Actual):** [https://datastudio.google.com/u/0/reporting/a87bbad6-0d47-4858-99e4-8e734e4018de/page/p_s71dlbcxnd/edit](https://datastudio.google.com/u/0/reporting/a87bbad6-0d47-4858-99e4-8e734e4018de/page/p_s71dlbcxnd/edit)
* **Reporte Tim Hortons (Referencia):** [https://datastudio.google.com/u/0/reporting/c6e89780-1db6-4a4e-948c-dbaa6f0839d5/page/p_s71dlbcxnd/edit](https://datastudio.google.com/u/0/reporting/c6e89780-1db6-4a4e-948c-dbaa6f0839d5/page/p_s71dlbcxnd/edit)

---

## 🏗️ 5. Arquitectura Final del Dashboard (3 Páginas)

### 📄 Página 1: Resumen Ejecutivo & Adopción del Programa
* **KPIs Superiores (Fuente: `vw_Clientes_Adopcion_KPIs`):**
  * Clientes: `Total (3.373) = Activos (679) + Inactivos (2.694)`
  * Puntos: `Disponibles (26.414) = Acumulados (2.069) + Bono (26.027) - Redimidos (1.682)`
* **Fila de Inversión y Ticket:**
  * Tarjeta `Ticket Promedio ($32.25)`
  * Control de Entrada `Inversión Publicidad ($1,000)` ➔ Tarjeta `ROAS (27.67x)` con semáforo condicional (>6x Verde, 3-6x Amarillo, <3x Rojo).
* **Gráficos de Recurrencia:**
  * Donut `% Recurrencia`: `Recurrente (10.1%)`, `Primera Compra (89.9%)`, `Sin Compra`.
  * Barras `Segmentos de Frecuencia`: `Nuevo (613)`, `Frecuente (63)`, `VIP (6)`.

### 📄 Página 2: Rendimiento Comercial & Puntos
* **Ventas y Sucursales (Fuente: `vw_Transacciones`):**
  * `Transacciones por Mes` y `Monto Promedio por Transacción por Mes`.
  * `Ventas Totales por Sucursal ($)` (Naciones Unidas: $27,668.32).
* **Dinámica de Puntos:**
  * `Puntos Redimidos por Mes`.
  * `Tabla de Canjes / Beneficios`: Clientes ordenados por puntos redimidos.

### 📄 Página 3: Base de Clientes & Vigencia
* **Filtros Superiores:**
  * Buscador: `NombreCompleto` (tipo contiene).
  * Menús Desplegables: `EstadoVigenciaPuntos` y `SegmentoRecurrencia`.
  * Rango de Fechas: `FechaRegistro`.
* **Tabla Detallada:**
  * Columnas: `Nombre`, `Email`, `Telefono`, `Fecha registro`, `Segmento`, `Estado puntos`, `Compras`, `Total Gastado ($)`, `Ticket Prom. ($)`, `Puntos Saldo`, `Puntos Redimidos`, `Puntos Ganados`.
  * Paginación 50 filas por página y totales automáticos en pie de tabla.

---

## 🛠️ 6. Ejecución Manual y Comandos Clave

```powershell
# 1. Autenticar en Google Cloud (si expiran credenciales)
gcloud auth application-default login

# 2. Configurar proyecto de cuota
gcloud auth application-default set-quota-project papajohnsec

# 3. Sincronizar datos (SQL Server -> BigQuery)
python "C:\Repositorios\PapaJohnsEc\scripts\sync_data.py"

# 4. Desplegar / actualizar vistas analíticas
python "C:\Repositorios\PapaJohnsEc\scripts\create_views.py"
```
