-- ==========================================================
-- Vista: vw_PuntosBono
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_PuntosBono` AS
WITH DATOS AS 
(
  SELECT 
    -- info donde
    B.AccountID as Cliente,
    DATE(B.CreateDate) as FechaBono,
    B.PointsAvailable as PuntosDisponibles,
    B.PointsBonus as PuntosBono,
    B.PointsRedeemed as PuntosRedimidos

  FROM `papajohnsec.papajohns_loyalty_ec.Bonus` B
)
SELECT *
FROM DATOS;
