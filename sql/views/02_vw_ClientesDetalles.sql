-- ==========================================================
-- Vista: vw_ClientesDetalles
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_ClientesDetalles` AS
WITH DATOS AS 
(
  SELECT 
    -- Datos cliente
    C.FechaCreacion,
    C.ID,
    C.NumeroCuenta,
    C.Nombre,
    C.Apellido,
    C.NombreCompleto,
    C.Email,
    C.Telefono, 

    -- Datos puntos y cash
    TH.CalculatedPoints as PuntosAcumulados,
    TH.PointsExpired as PuntosExpirados,
    TH.PointsAvailable + IFNULL(B.PointsAvailable, 0) as PuntosDisponibles,
    TH.PointsInTransit as PuntosEnTransito,
    TH.PointsRedeemed + IFNULL(B.PointsRedeemed, 0) as PuntosRedimidos,
    B.PointsBonus as PuntosBono,
    TH.PointsLost as PuntosPerdidos,
    
    IF(TC.Description = "Débito", TC.RegisteredCashAmount, 0) as CashCambiado,
    IF(TC.Description = "Crédito", TC.RegisteredCashAmount, 0) as CashDepositado

  FROM `papajohnsec.papajohns_loyalty_ec.vw_Clientes` C 
  INNER JOIN `papajohnsec.papajohns_loyalty_ec.RetailTransactionHeaders` TH ON C.ID = TH.AccountID
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.Bonus` B ON C.ID = B.AccountID
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.RetailTransactionCash` TC ON C.ID = TC.AccountID
)
SELECT 
  *, 
  DATOS.CashDepositado - DATOS.CashCambiado as CashDisponible
FROM DATOS;
