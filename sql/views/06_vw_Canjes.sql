-- ==========================================================
-- Vista: vw_Canjes
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_Canjes` AS
WITH DATOS AS 
(
  SELECT
    -- info del canje
    R.RewardID as ID,
    RR.RedemptionDate as FechaDelCanje,
    
    -- info del premio
    R.RewardName as Premio,
    R.Points as Puntos,
    R.QuantityRedempts as CantidadCanjes,
    R.QuantityStock as CantidadInventario,

    -- info sobre el cliente
    C.NumeroCuenta as NumeroDeTarjeta,
    C.NombreCompleto as NombreCompleto,
    C.Nombre as Nombre,
    C.Apellido as Apellido

  FROM `papajohnsec.papajohns_loyalty_ec.RewardRedemptions` RR 
  INNER JOIN `papajohnsec.papajohns_loyalty_ec.SRewards` R ON RR.SRewardID = R.RewardID
  INNER JOIN `papajohnsec.papajohns_loyalty_ec.vw_Clientes` C ON RR.AccountID = C.ID
)
SELECT *
FROM DATOS;
