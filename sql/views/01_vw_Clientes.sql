-- ==========================================================
-- Vista: vw_Clientes
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_Clientes` AS
WITH DATOS AS 
(
  SELECT 
    -- Datos cliente
    DATE(A.CreateDate) as FechaCreacion,
    A.AccountID as ID,
    A.AccountNumber as NumeroCuenta,
    A.FirstName as Nombre,
    A.LastName as Apellido,
    CONCAT(IFNULL(A.FirstName, ""), " ", IFNULL(A.LastName, "")) as NombreCompleto,
    A.Email as Email,
    A.MobilePhone as Telefono,
    A.Status as Estatus,
    IF((
      SELECT DATE(MAX(T.CreateDate))
      FROM `papajohnsec.papajohns_loyalty_ec.RetailTransactionHeaders` T
      WHERE A.AccountID = T.AccountID 
    ) >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), "Con Actividad", "Sin Actividad") as EstatusActividad,
    IF(A.PointsAvailable > 0, "Con Puntos", "Sin Puntos") as EstatusPuntos, 
    IF(A.CashAvailable > 0, "Con Cash", "Sin Cash") as EstatusCash, 

    -- Datos puntos y cash
    A.PointsAccumulated as PuntosAcumulados,
    A.PointsExpired as PuntosExpirados,
    A.PointsAvailable as PuntosDisponibles,
    A.PointsInTransit as PuntosEnTransito,
    A.PointsRedeemed as PuntosRedimidos,
    A.PointsBonus as PuntosBono,
    A.PointsLost as PuntosPerdidos,
    
    A.CashAvailable as CashDisponible,
    A.CashIn as CashIngresado,
    A.CashOut as CashGastado

  FROM `papajohnsec.papajohns_loyalty_ec.Accounts` A
)
SELECT * 
FROM DATOS;
