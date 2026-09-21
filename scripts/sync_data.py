import sys
import os
import time
from datetime import datetime

# Configurar encoding utf-8 para stdout en Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

# Limpiar posibles credenciales residuales en entorno para forzar ADC con melissah@loymark.com
os.environ.pop("GOOGLE_APPLICATION_CREDENTIALS", None)

# Agregar la carpeta de la función al path de Python
function_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "functions", "extract_loyalty"))
sys.path.insert(0, function_dir)

from config import settings
from database import extract_table_data, TABLE_QUERIES
from bigquery_loader import load_dataframe_to_bigquery

def run_sync(mode: str = "WRITE_TRUNCATE"):
    start_time = time.time()
    now_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print("="*70)
    print("INICIANDO SINCRONIZACION: SQL SERVER -> GOOGLE BIGQUERY")
    print(f"Fecha/Hora: {now_str}")
    print(f"Origen:    SQL Server ({settings.SQL_SERVER}:{settings.SQL_PORT} / {settings.SQL_DATABASE})")
    print(f"Destino:   BigQuery ({settings.GCP_PROJECT_ID}.{settings.BQ_DATASET_ID})")
    print(f"Modo:      {mode}")
    print("="*70 + "\n")

    summary = []
    
    for table_name in TABLE_QUERIES.keys():
        t0 = time.time()
        print(f"[*] Extrayendo y cargando: {table_name:<25}...", end="", flush=True)
        try:
            df = extract_table_data(table_name)
            rows_extracted = len(df)
            rows_bq = load_dataframe_to_bigquery(table_name, df, write_disposition=mode)
            elapsed = round(time.time() - t0, 2)
            print(f" [OK] ({rows_extracted} filas en {elapsed}s)")
            summary.append({
                "table": table_name,
                "sql_rows": rows_extracted,
                "bq_rows": rows_bq,
                "time": elapsed,
                "status": "OK"
            })
        except Exception as e:
            elapsed = round(time.time() - t0, 2)
            print(f" [ERROR]: {e}")
            summary.append({
                "table": table_name,
                "sql_rows": 0,
                "bq_rows": 0,
                "time": elapsed,
                "status": f"ERROR: {e}"
            })

    total_time = round(time.time() - start_time, 2)
    print("\n" + "="*70)
    print(f"{'Tabla':<26} | {'SQL Server':<12} | {'BigQuery':<12} | {'Tiempo (s)':<10} | {'Estado'}")
    print("="*70)
    for s in summary:
        print(f"{s['table']:<26} | {s['sql_rows']:<12} | {s['bq_rows']:<12} | {s['time']:<10} | {s['status']}")
    print("="*70)
    print(f"Tiempo total de ejecucion: {total_time}s\n")

if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "WRITE_TRUNCATE"
    run_sync(mode=mode)
