-- ==========================================================
-- Vista: vw_Clientes_Adopcion_KPIs (UNIFICADA)
-- Proposito: Consolidar todas las metricas de Resumen General,
--            adopcion, recurrencia, frecuencia, ticket y vigencia
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
  -- 1. Identificacion del Cliente
  A.AccountID,
  A.AccountNumber AS NumeroCuenta,
  A.FirstName AS Nombre,
  A.LastName AS Apellido,
  CONCAT(IFNULL(A.FirstName, ''), ' ', IFNULL(A.LastName, '')) AS NombreCompleto,
  A.Email,
  A.MobilePhone AS Telefono,
  A.Status AS Estatus,
  DATE(A.CreateDate) AS FechaRegistro,
  DATE(A.CreateDate) AS FechaCreacion,
  EXTRACT(YEAR FROM A.CreateDate) AS AnioRegistro,
  EXTRACT(MONTH FROM A.CreateDate) AS MesRegistro,
  DATE_DIFF(CURRENT_DATE(), DATE(A.CreateDate), DAY) AS DiasDesdeRegistro,

  -- 2. Actividad General (Para las tarjetas superiores de clientes)
  IF(DATE(TX.UltimaCompra) >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), 'Con Actividad', 'Sin Actividad') AS EstatusActividad,
  IF(A.PointsAvailable > 0, 'Con Puntos', 'Sin Puntos') AS EstatusPuntos,
  IF(A.CashAvailable > 0, 'Con Cash', 'Sin Cash') AS EstatusCash,
  
  -- 3. Segmentacion y Recurrencia
  IFNULL(TX.TotalCompras, 0) AS FrecuenciaCompras,
  CASE 
    WHEN IFNULL(TX.TotalCompras, 0) = 0 THEN 'Registrado Sin Compra'
    WHEN TX.TotalCompras = 1 THEN 'Cliente Nuevo (1 compra)'
    WHEN TX.TotalCompras BETWEEN 2 AND 3 THEN 'Cliente Frecuente (2-3 compras)'
    ELSE 'Cliente VIP (4+ compras)'
  END AS SegmentoRecurrencia,
  
  IF(IFNULL(TX.TotalCompras, 0) > 1, 'Recurrente (2+)', IF(IFNULL(TX.TotalCompras, 0) = 1, 'Primera Compra', 'Sin Compra')) AS TipoRecurrencia,
  
  -- 4. Transaccionalidad y Ticket Promedio
  ROUND(IFNULL(TX.GastoTotal, 0), 2) AS MontoTotalComprado,
  ROUND(IFNULL(TX.TicketPromedio, 0), 2) AS TicketPromedio,
  DATE(TX.PrimeraCompra) AS FechaPrimeraCompra,
  DATE(TX.UltimaCompra) AS FechaUltimaCompra,
  DATE_DIFF(CURRENT_DATE(), DATE(TX.UltimaCompra), DAY) AS DiasUltimaCompra,
  
  -- 5. Datos de Puntos (Para las tarjetas superiores de puntos)
  A.PointsAccumulated AS PuntosAcumulados,
  A.PointsBonus AS PuntosBono,
  A.PointsRedeemed AS PuntosRedimidos,
  A.PointsAvailable AS PuntosDisponibles,
  A.PointsExpired AS PuntosExpirados,
  A.PointsInTransit AS PuntosEnTransito,
  A.PointsLost AS PuntosPerdidos,
  
  -- 6. Vigencia de Puntos
  CASE 
    WHEN A.PointsAvailable > 0 AND (TX.UltimaCompra IS NULL OR DATE_DIFF(CURRENT_DATE(), DATE(TX.UltimaCompra), DAY) <= 150) THEN 'Puntos Vigentes'
    WHEN A.PointsAvailable > 0 AND DATE_DIFF(CURRENT_DATE(), DATE(TX.UltimaCompra), DAY) > 150 THEN 'Proximos a Vencer (6 meses)'
    WHEN A.PointsExpired > 0 THEN 'Puntos Vencidos'
    ELSE 'Sin Puntos'
  END AS EstadoVigenciaPuntos,
  
  -- 7. Canjes de Catalogo
  IFNULL(R.TotalCanjes, 0) AS TotalCanjes,
  IFNULL(R.PuntosCanjeadosTotal, 0) AS PuntosCanjeados,
  
  -- 8. Cash / Wallet
  A.CashAvailable AS CashDisponible,
  A.CashIn AS CashDepositado,
  A.CashIn AS CashIngresado,
  A.CashOut AS CashCambiado,
  A.CashOut AS CashGastado

FROM `papajohnsec.papajohns_loyalty_ec.Accounts` A
LEFT JOIN TX_AGG TX ON A.AccountID = TX.AccountID
LEFT JOIN REDEMPTIONS R ON A.AccountID = R.AccountID;
