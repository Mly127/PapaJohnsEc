import os
import logging
import pandas as pd
from typing import Dict, List
from google.cloud import bigquery
from google.api_core.exceptions import Conflict, NotFound
from config import settings

logger = logging.getLogger("extract_loyalty.bigquery")

# Esquemas de BigQuery según el estándar extraído
TABLE_SCHEMAS: Dict[str, List[bigquery.SchemaField]] = {
    "Accounts": [
        bigquery.SchemaField("AccountID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("HoldingID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("LoyaltyProgramID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("EntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SubEntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("AccountNumber", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("FirstName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("LastName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Email", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("MobilePhone", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Status", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("EnrollmentDate", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsAccumulated", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsBonus", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsRedeemed", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsExpired", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsLost", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsInTransit", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsAvailable", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CashIn", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CashOut", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CashAvailable", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("AccountTypeID", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("UpdateDate", "STRING", mode="NULLABLE"),
    ],
    "Bonus": [
        bigquery.SchemaField("BonusID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("AccountID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("Description", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("PointsBonus", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsRedeemed", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsAvailable", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("CreateUserID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("UpdateDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("UpdateUserID", "FLOAT", mode="NULLABLE"),
    ],
    "RetailTransactionCash": [
        bigquery.SchemaField("CashMovementID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("HoldingID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("LoyaltyProgramID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("EntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SubEntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CardNumber", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("AccountID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("MovementTypeID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("TransactionID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("POSID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CashierID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("RegisteredCashAmount", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CurrencyID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("MovementDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("MovementSign", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("MovementOrigin", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CustomField1", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CustomField2", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CustomField3", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("SourceFileName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("SourceProcessID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("Description", "STRING", mode="NULLABLE"),
    ],
    "RetailTransactionDetails": [
        bigquery.SchemaField("TransactionDetailID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("HoldingID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("LoyaltyProgramID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("EntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SubEntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CardNumber", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("AccountID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("TransactionHeaderID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("LineID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("ItemID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Items", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PurchaseAmount", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("Discount", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CustomField1", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CustomField2", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CustomField3", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CustomField4", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SourceFileName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("SourceProcessID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CalculatedPoints", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("ItemDescription", "STRING", mode="NULLABLE"),
    ],
    "RetailTransactionHeaders": [
        bigquery.SchemaField("TransactionHeaderID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("HoldingID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("LoyaltyProgramID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("EntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SubEntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CardNumber", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("AccountID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("TransactionID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("TransactionType", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("Status", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("POSID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CashierID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PurchaseAmount", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("SubPurchaseAmount", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("Discount", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("Taxes", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CurrencyID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PurchaseDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("TransactionSign", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("TransactionOrigin", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Lines", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("Items", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CustomField1", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CustomField2", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CustomField3", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("SourceFileName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("SourceProcessID", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CalculatedPoints", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsInTransit", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsRedeemed", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsExpired", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("PointsLost", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("PointsAvailable", "FLOAT", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("UpdateDate", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("UpdateProcessID", "INTEGER", mode="NULLABLE"),
    ],
    "RewardRedemptions": [
        bigquery.SchemaField("SRewardRedemptionID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("AccountID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SRewardID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("UserAppID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("RedemptionDate", "TIMESTAMP", mode="NULLABLE"),
    ],
    "SRewards": [
        bigquery.SchemaField("RewardID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("HoldingID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("LoyaltyProgramID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("EntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("RewardName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Points", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("Status", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("QuantityStock", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("QuantityRedempts", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("UpdateDate", "INTEGER", mode="NULLABLE"),
    ],
    "SubEntity": [
        bigquery.SchemaField("SubEntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("HoldingID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("LoyaltyProgramID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("EntityID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("SubEntityName", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Status", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("CreateUserID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("UpdateDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("UpdateUserID", "FLOAT", mode="NULLABLE"),
    ],
    "TransactionTypes": [
        bigquery.SchemaField("TransactionTypeID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("Description", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("Status", "STRING", mode="NULLABLE"),
        bigquery.SchemaField("CreateDate", "TIMESTAMP", mode="NULLABLE"),
        bigquery.SchemaField("CreateUserID", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("UpdateDate", "INTEGER", mode="NULLABLE"),
        bigquery.SchemaField("UpdateUserID", "INTEGER", mode="NULLABLE"),
    ]
}

def get_bigquery_client() -> bigquery.Client:
    """Instancia el cliente de BigQuery para el proyecto destino."""
    return bigquery.Client(project=settings.GCP_PROJECT_ID)

def ensure_dataset_exists(client: bigquery.Client) -> None:
    """Verifica la existencia del dataset destino o lo crea si no existe."""
    dataset_ref = f"{settings.GCP_PROJECT_ID}.{settings.BQ_DATASET_ID}"
    try:
        client.get_dataset(dataset_ref)
        logger.info(f"Dataset {dataset_ref} verificado exitosamente.")
    except NotFound:
        dataset = bigquery.Dataset(dataset_ref)
        dataset.location = settings.BQ_LOCATION
        dataset.description = "Dataset analítico de lealtad para Papa John's Ecuador"
        client.create_dataset(dataset, timeout=30)
        logger.info(f"Dataset {dataset_ref} creado exitosamente en {settings.BQ_LOCATION}.")

def load_dataframe_to_bigquery(table_name: str, df: pd.DataFrame, write_disposition: str = "WRITE_TRUNCATE") -> int:
    """Carga un DataFrame de pandas a la tabla correspondiente de BigQuery."""
    client = get_bigquery_client()
    ensure_dataset_exists(client)
    
    table_id = f"{settings.GCP_PROJECT_ID}.{settings.BQ_DATASET_ID}.{table_name}"
    schema = TABLE_SCHEMAS.get(table_name)
    
    # Configurar el trabajo de carga
    job_config = bigquery.LoadJobConfig(
        schema=schema,
        write_disposition=write_disposition,
        autodetect=False if schema else True
    )
    
    logger.info(f"Iniciando carga de {len(df)} registros a BigQuery: {table_id} (Modo: {write_disposition})")
    job = client.load_table_from_dataframe(df, table_id, job_config=job_config)
    job.result()  # Esperar que complete el job
    
    destination_table = client.get_table(table_id)
    logger.info(f"Carga completada para {table_id}. Total de filas en la tabla: {destination_table.num_rows}")
    return destination_table.num_rows
