-- ==========================================================
-- Vista: vw_Puntos
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_Puntos` AS
WITH DATOS AS 
(
  SELECT 
    -- info donde
    TH.AccountID as Cuenta,
    TH.CardNumber as Tarjeta,
    TH.TransactionID as ID,
    TH.CreateDate as FechaTransaccion,
    S.SubEntityName as Sucursal,
    TH.CashierID as Caja,
    TT.Description as Tipo,

    -- info puntos
    TH.CalculatedPoints as PuntosAcumulados,
    TH.PointsRedeemed as PuntosRedimidos,
    TH.PointsAvailable as PuntosDisponibles

  FROM `papajohnsec.papajohns_loyalty_ec.RetailTransactionHeaders` TH
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.SubEntity` S ON TH.SubEntityID = S.SubEntityID
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.TransactionTypes` TT ON TH.TransactionType = TT.TransactionTypeID
) 
SELECT * 
FROM DATOS;
