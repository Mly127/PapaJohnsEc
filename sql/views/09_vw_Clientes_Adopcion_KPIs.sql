-- ==========================================================
-- Vista: vw_Clientes_Adopcion_KPIs
-- Proposito: Consolidar adopcion del programa, recurrencia,
--            frecuencia, ticket promedio, vigencia y canjes
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_Clientes_Adopcion_KPIs` AS
WITH TX_AGG AS (
  SELECT 
    AccountID,
    COUNT(*) AS TotalCompras,
    SUM(PurchaseAmount) AS GastoTotal,
    AVG(PurchaseAmount) AS TicketPromedio,
    MIN(CreateDate) AS PrimeraCompra,
    MAX(CreateDate) AS UltimaCompra,
    SUM(CalculatedPoints) AS PuntosPorCompras,
    SUM(PointsRedeemed) AS PuntosRedimidosCompras
  FROM `papajohnsec.papajohns_loyalty_ec.RetailTransactionHeaders`
  GROUP BY AccountID
),
REDEMPTIONS AS (
  SELECT 
    RR.AccountID,
    COUNT(RR.SRewardRedemptionID) AS TotalCanjes,
    SUM(IFNULL(SR.Points, 0)) AS PuntosCanjeadosTotal
  FROM `papajohnsec.papajohns_loyalty_ec.RewardRedemptions` RR
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.SRewards` SR ON RR.SRewardID = SR.RewardID
  GROUP BY RR.AccountID
)
SELECT 
  A.AccountID,
  A.AccountNumber AS NumeroCuenta,
  CONCAT(IFNULL(A.FirstName, ''), ' ', IFNULL(A.LastName, '')) AS NombreCompleto,
  A.Email,
  A.MobilePhone AS Telefono,
  DATE(A.CreateDate) AS FechaRegistro,
  EXTRACT(YEAR FROM A.CreateDate) AS AnioRegistro,
  EXTRACT(MONTH FROM A.CreateDate) AS MesRegistro,
  DATE_DIFF(CURRENT_DATE(), DATE(A.CreateDate), DAY) AS DiasDesdeRegistro,
  
  -- Segmentacion y Recurrencia
  IFNULL(TX.TotalCompras, 0) AS FrecuenciaCompras,
  CASE 
    WHEN IFNULL(TX.TotalCompras, 0) = 0 THEN 'Registrado Sin Compra'
    WHEN TX.TotalCompras = 1 THEN 'Cliente Nuevo (1 compra)'
    WHEN TX.TotalCompras BETWEEN 2 AND 3 THEN 'Cliente Frecuente (2-3 compras)'
    ELSE 'Cliente VIP (4+ compras)'
  END AS SegmentoRecurrencia,
  
  IF(IFNULL(TX.TotalCompras, 0) > 1, 'Recurrente (2+)', IF(IFNULL(TX.TotalCompras, 0) = 1, 'Primera Compra', 'Sin Compra')) AS TipoRecurrencia,
  
  -- Transaccionalidad y Ticket Promedio
  ROUND(IFNULL(TX.GastoTotal, 0), 2) AS MontoTotalComprado,
  ROUND(IFNULL(TX.TicketPromedio, 0), 2) AS TicketPromedio,
  DATE(TX.PrimeraCompra) AS FechaPrimeraCompra,
  DATE(TX.UltimaCompra) AS FechaUltimaCompra,
  DATE_DIFF(CURRENT_DATE(), DATE(TX.UltimaCompra), DAY) AS DiasUltimaCompra,
  
  -- Puntos y Vigencia
  A.PointsAccumulated AS PuntosAcumulados,
  A.PointsAvailable AS PuntosDisponibles,
  A.PointsRedeemed AS PuntosRedimidos,
  A.PointsExpired AS PuntosExpirados,
  A.PointsBonus AS PuntosBono,
  
  CASE 
    WHEN A.PointsAvailable > 0 AND (TX.UltimaCompra IS NULL OR DATE_DIFF(CURRENT_DATE(), DATE(TX.UltimaCompra), DAY) <= 150) THEN 'Puntos Vigentes'
    WHEN A.PointsAvailable > 0 AND DATE_DIFF(CURRENT_DATE(), DATE(TX.UltimaCompra), DAY) > 150 THEN 'Proximos a Vencer (6 meses)'
    WHEN A.PointsExpired > 0 THEN 'Puntos Vencidos'
    ELSE 'Sin Puntos'
  END AS EstadoVigenciaPuntos,
  
  -- Canjes
  IFNULL(R.TotalCanjes, 0) AS TotalCanjes,
  IFNULL(R.PuntosCanjeadosTotal, 0) AS PuntosCanjeados,
  
  -- Cash / Wallet
  A.CashAvailable AS CashDisponible,
  A.CashIn AS CashIngresado,
  A.CashOut AS CashGastado

FROM `papajohnsec.papajohns_loyalty_ec.Accounts` A
LEFT JOIN TX_AGG TX ON A.AccountID = TX.AccountID
LEFT JOIN REDEMPTIONS R ON A.AccountID = R.AccountID;
