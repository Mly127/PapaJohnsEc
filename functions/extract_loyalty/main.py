import functions_framework
import logging
import json
import time
from typing import List, Dict, Any
from flask import Request, jsonify

from database import extract_table_data, TABLE_QUERIES
from bigquery_loader import load_dataframe_to_bigquery
from config import settings

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s")
logger = logging.getLogger("extract_loyalty.main")

@functions_framework.http
def sync_loyalty_data(request: Request):
    """
    Punto de entrada HTTP para Google Cloud Functions (Gen2) y Cloud Scheduler.
    Parámetros opcionales en JSON (body) o query string:
      - tables: Lista de tablas a sincronizar (default: todas)
      - mode: 'WRITE_TRUNCATE' (default) o 'WRITE_APPEND'
    """
    start_time = time.time()
    logger.info("Recibida solicitud de sincronización SQL Server -> BigQuery")
    
    # Parsear request
    request_json = request.get_json(silent=True) or {}
    args = request.args or {}
    
    tables_param = request_json.get("tables") or args.get("tables")
    mode = request_json.get("mode") or args.get("mode") or "WRITE_TRUNCATE"
    
    if isinstance(tables_param, str):
        target_tables = [t.strip() for t in tables_param.split(",") if t.strip()]
    elif isinstance(tables_param, list):
        target_tables = tables_param
    else:
        target_tables = list(TABLE_QUERIES.keys())
        
    results: Dict[str, Any] = {
        "status": "SUCCESS",
        "mode": mode,
        "tables_synced": {},
        "errors": []
    }
    
    for table_name in target_tables:
        t_start = time.time()
        try:
            logger.info(f"--- Procesando tabla: {table_name} ---")
            df = extract_table_data(table_name)
            total_rows_bq = load_dataframe_to_bigquery(table_name, df, write_disposition=mode)
            
            results["tables_synced"][table_name] = {
                "rows_extracted": len(df),
                "rows_in_bigquery": total_rows_bq,
                "duration_seconds": round(time.time() - t_start, 2),
                "status": "OK"
            }
        except Exception as e:
            logger.exception(f"Error procesando tabla {table_name}: {e}")
            results["errors"].append({
                "table": table_name,
                "error": str(e)
            })
            results["status"] = "PARTIAL_ERROR"
            
    total_duration = round(time.time() - start_time, 2)
    results["total_duration_seconds"] = total_duration
    
    status_code = 200 if not results["errors"] else (207 if results["tables_synced"] else 500)
    logger.info(f"Proceso finalizado en {total_duration}s con estado: {results['status']}")
    
    return jsonify(results), status_code
