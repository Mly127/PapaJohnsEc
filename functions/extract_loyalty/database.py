import logging
import pandas as pd
from typing import Generator, Dict, Any, Optional
from config import settings

logger = logging.getLogger("extract_loyalty.database")

# Mapping and extraction SQL definitions
TABLE_QUERIES: Dict[str, str] = {
    "Accounts": """
        SELECT 
            AccountID,
            HoldingID,
            LoyaltyProgramID,
            EntityID,
            SubEntityID,
            AccountNumber,
            FirstName,
            LastName,
            Email,
            MobilePhone,
            Status,
            EnrollmentDate,
            PointsAccumulated,
            PointsBonus,
            PointsRedeemed,
            PointsExpired,
            PointsLost,
            PointsInTransit,
            PointsAvailable,
            CashIn,
            CashOut,
            CashAvailable,
            AccountTypeID,
            CreateDate,
            UpdateDate
        FROM dbo.Accounts
    """,
    "Bonus": """
        SELECT 
            BonusID,
            AccountID,
            Description,
            PointsBonus,
            PointsRedeemed,
            PointsAvailable,
            CreateDate,
            CreateUserID,
            UpdateDate,
            UpdateUserID
        FROM dbo.Bonus
    """,
    "RetailTransactionCash": """
        SELECT 
            CM.CashMovementID,
            CM.HoldingID,
            CM.LoyaltyProgramID,
            CM.EntityID,
            CM.SubEntityID,
            CM.CardNumber,
            CM.AccountID,
            CM.MovementTypeID,
            CM.TransactionID,
            CM.POSID,
            CM.CashierID,
            CM.RegisteredCashAmount,
            CM.CurrencyID,
            CM.MovementDate,
            CM.MovementSign,
            CM.MovementOrigin,
            CM.CustomField1,
            CM.CustomField2,
            CM.CustomField3,
            CM.SourceFileName,
            CM.SourceProcessID,
            CM.CreateDate,
            CASE 
                WHEN CM.MovementSign = '+' THEN 'Crédito'
                WHEN CM.MovementSign = '-' THEN 'Débito'
                ELSE 'Desconocido'
            END AS Description
        FROM dbo.CashMovements CM
    """,
    "RetailTransactionDetails": """
        SELECT 
            TransactionDetailID,
            HoldingID,
            LoyaltyProgramID,
            EntityID,
            SubEntityID,
            CardNumber,
            AccountID,
            TransactionHeaderID,
            LineID,
            ItemID,
            Items,
            PurchaseAmount,
            Discount,
            CustomField1,
            CustomField2,
            CustomField3,
            CustomField4,
            SourceFileName,
            SourceProcessID,
            CalculatedPoints,
            ItemDescription
        FROM dbo.RetailTransactionDetails
    """,
    "RetailTransactionHeaders": """
        SELECT 
            TransactionHeaderID,
            HoldingID,
            LoyaltyProgramID,
            EntityID,
            SubEntityID,
            CardNumber,
            AccountID,
            TransactionID,
            TransactionType,
            Status,
            POSID,
            CashierID,
            PurchaseAmount,
            SubPurchaseAmount,
            Discount,
            Taxes,
            CurrencyID,
            PurchaseDate,
            TransactionSign,
            TransactionOrigin,
            Lines,
            Items,
            CustomField1,
            CustomField2,
            CustomField3,
            SourceFileName,
            SourceProcessID,
            CalculatedPoints,
            PointsInTransit,
            PointsRedeemed,
            PointsExpired,
            PointsLost,
            PointsAvailable,
            CreateDate,
            UpdateDate,
            UpdateProcessID
        FROM dbo.RetailTransactionHeaders
    """,
    "RewardRedemptions": """
        SELECT 
            SRewardRedemptionID,
            AccountID,
            SRewardID,
            UserAppID,
            RedemptionDate
        FROM dbo.RewardRedemptions
    """,
    "SRewards": """
        SELECT 
            R.RewardID,
            R.HoldingID,
            R.LoyaltyProgramID,
            R.EntityID,
            B.Description AS RewardName,
            R.Points,
            R.Status,
            R.QuantityStock,
            R.QuantityRedempts,
            R.CreateDate,
            R.UpdateDate
        FROM dbo.SRewards R
        LEFT JOIN dbo.Benefits B ON R.BenefitID = B.BenefitID
    """,
    "SubEntity": """
        SELECT 
            SubEntityID,
            HoldingID,
            LoyaltyProgramID,
            EntityID,
            SubEntityName,
            Status,
            CreateDate,
            CreateUserID,
            UpdateDate,
            UpdateUserID
        FROM dbo.SubEntities
    """,
    "TransactionTypes": """
        SELECT 
            TransactionTypeID,
            Description,
            Status,
            CreateDate,
            CreateUserID,
            UpdateDate,
            UpdateUserID
        FROM dbo.TransactionTypes
    """
}

def get_connection():
    """Establece conexión a SQL Server intentando pymssql (Cloud Function Linux) o pyodbc (Windows local)."""
    try:
        import pymssql
        conn = pymssql.connect(
            server=settings.SQL_SERVER,
            port=settings.SQL_PORT,
            user=settings.SQL_USER,
            password=settings.SQL_PASSWORD,
            database=settings.SQL_DATABASE,
            timeout=30,
            as_dict=True
        )
        return conn
    except ImportError:
        import pyodbc
        conn_str = (
            f"DRIVER={{ODBC Driver 17 for SQL Server}};"
            f"SERVER={settings.SQL_SERVER},{settings.SQL_PORT};"
            f"DATABASE={settings.SQL_DATABASE};"
            f"UID={settings.SQL_USER};"
            f"PWD={settings.SQL_PASSWORD};"
            f"Encrypt=no;"
            f"TrustServerCertificate=yes;"
            f"Connection Timeout=30;"
        )
        return pyodbc.connect(conn_str)

def extract_table_data(table_name: str) -> pd.DataFrame:
    """Extrae todos los registros de una tabla específica desde SQL Server."""
    if table_name not in TABLE_QUERIES:
        raise ValueError(f"Tabla no reconocida en la definición: {table_name}")
    
    query = TABLE_QUERIES[table_name]
    logger.info(f"Iniciando extracción para tabla: {table_name}")
    
    conn = get_connection()
    try:
        df = pd.read_sql(query, conn)
        logger.info(f"Extracción completada para {table_name}: {len(df)} registros obtenidos.")
        return df
    finally:
        conn.close()
