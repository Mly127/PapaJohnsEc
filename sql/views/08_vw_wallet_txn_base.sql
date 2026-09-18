-- ==========================================================
-- Vista: vw_wallet_txn_base
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_wallet_txn_base` AS
SELECT
  CS.CashMovementID,
  CS.HoldingID,
  CS.LoyaltyProgramID,
  CS.EntityID,
  CS.SubEntityID,
  E.SubEntityName        AS Sucursal,
  CS.CardNumber          AS Tarjeta,
  CS.AccountID           AS Cuenta,
  CS.MovementTypeID,
  CS.TransactionID,
  CS.POSID,
  CS.CashierID           AS Caja,
  CAST(CS.RegisteredCashAmount AS NUMERIC) AS Cash,
  CS.CurrencyID,
  CS.MovementDate,
  CS.MovementSign,
  CS.MovementOrigin,
  CS.CustomField1,
  CS.CustomField2,
  CS.CustomField3,
  CS.SourceFileName,
  CS.SourceProcessID,
  CS.CreateDate          AS FechaTransaccion,
  CS.Description         AS TipoMovimiento,
  A.FirstName            AS Nombre,
  A.LastName             AS Apellido,

  -- Derivados clave
  CASE
    WHEN CS.Description = 'Crédito' THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
    ELSE 0
  END AS MontoCredito,

  CASE
    WHEN CS.Description = 'Débito' THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
    ELSE 0
  END AS MontoDebito,

  CASE WHEN CS.AccountID IS NOT NULL THEN TRUE ELSE FALSE END AS TieneCuentaInterna,
  CASE WHEN CS.MovementTypeID = 1 THEN 'Con Tj' ELSE 'Sin Tj' END AS MovementType,

  -- Puntos desde headers
  TH.CalculatedPoints as PuntosAcumulados,
  TH.PointsRedeemed   as PuntosRedimidos,
  TH.PointsAvailable  as PuntosDisponibles,
  TH.PointsExpired    as PuntosVencidos,
  TH.PointsInTransit  as PuntosEnTransit,
  TH.PointsLost       as PuntosPerdidos,

  -- Monto con signo
  CASE
    WHEN CS.Description = 'Crédito'
      THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
    WHEN CS.Description = 'Débito'
      THEN -CAST(CS.RegisteredCashAmount AS NUMERIC)
    ELSE 0
  END AS MontoSigned,

  -- Saldo acumulado por Cuenta + Tarjeta
  SUM(
    CASE
      WHEN CS.Description = 'Crédito'
        THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
      WHEN CS.Description = 'Débito'
        THEN -CAST(CS.RegisteredCashAmount AS NUMERIC)
      ELSE 0
    END
  ) OVER (
    PARTITION BY CS.AccountID, CS.CardNumber
    ORDER BY CS.CreateDate, CS.CashMovementID
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
  ) AS SaldoActual,

  -- Normalización Horaria a Ecuador (UTC-5)
  DATETIME(TIMESTAMP(CS.CreateDate), "America/Guayaquil") AS FechaEcuador

FROM `papajohnsec.papajohns_loyalty_ec.RetailTransactionCash` CS
LEFT JOIN `papajohnsec.papajohns_loyalty_ec.RetailTransactionHeaders` TH 
       ON  CS.TransactionID      = TH.TransactionID
       AND CS.LoyaltyProgramID   = TH.LoyaltyProgramID
       AND CS.EntityID           = TH.EntityID
       AND CS.SubEntityID        = TH.SubEntityID
LEFT JOIN `papajohnsec.papajohns_loyalty_ec.SubEntity` E ON CS.SubEntityID = E.SubEntityID
LEFT JOIN `papajohnsec.papajohns_loyalty_ec.Accounts` A ON CS.AccountID = A.AccountID;
