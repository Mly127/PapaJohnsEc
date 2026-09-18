import os
import glob
from google.cloud import bigquery

# Limpiar credenciales inválidas si existen
os.environ.pop('GOOGLE_APPLICATION_CREDENTIALS', None)

PROJECT_ID = os.getenv("GCP_PROJECT_ID", "papajohnsec")
DATASET_ID = os.getenv("BQ_DATASET_ID", "papajohns_loyalty_ec")

client = bigquery.Client(project=PROJECT_ID)

views_dir = r"C:\Repositorios\PapaJohnsEc\sql\views"
view_files = sorted(glob.glob(os.path.join(views_dir, "*.sql")))

print(f"=== Despliegue de Vistas Analíticas en `{PROJECT_ID}.{DATASET_ID}` ===")

for file_path in view_files:
    filename = os.path.basename(file_path)
    with open(file_path, "r", encoding="utf-8") as f:
        query_sql = f.read()
        
    try:
        print(f"Desplegando vista desde {filename}...")
        job = client.query(query_sql)
        job.result()
        print(f"  [OK] Vista creada/actualizada exitosamente.")
    except Exception as e:
        print(f"  [ERROR] No se pudo crear la vista desde {filename}: {e}")

print("\nProceso de despliegue de vistas finalizado.")
