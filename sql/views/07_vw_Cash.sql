-- ==========================================================
-- Vista: vw_Cash
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_Cash` AS
WITH DATOS AS 
(
  SELECT 
    -- info donde
    TC.AccountID as Cuenta,
    TC.CardNumber as Tarjeta,
    TC.CreateDate as FechaTransaccion,
    S.SubEntityName as Sucursal,
    TC.CashierID as Caja,

    -- info cash
    TC.Description as TipoMovimiento,
    TC.RegisteredCashAmount as Cash,
    IF(TC.Description = "Débito", TC.RegisteredCashAmount, 0) as CashCambiado,
    IF(TC.Description = "Crédito", TC.RegisteredCashAmount, 0) as CashDepositado

  FROM `papajohnsec.papajohns_loyalty_ec.RetailTransactionCash` TC
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.SubEntity` S ON TC.SubEntityID = S.SubEntityID
)
SELECT *
FROM DATOS;
