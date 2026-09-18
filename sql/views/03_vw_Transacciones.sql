-- ==========================================================
-- Vista: vw_Transacciones
-- Dataset: papajohnsec.papajohns_loyalty_ec
-- ==========================================================
CREATE OR REPLACE VIEW `papajohnsec.papajohns_loyalty_ec.vw_Transacciones` AS
WITH DATOS AS 
(
  SELECT 
    -- info donde
    TH.TransactionID as ID,
    TH.CreateDate as FechaTransaccion,
    S.SubEntityName as Sucursal,
    TH.CashierID as Caja,
    TT.Description as Tipo,

    -- info quien
    A.AccountNumber as NumeroCliente,
    CONCAT(IFNULL(A.FirstName, ""), " ", IFNULL(A.LastName, "")) as NombreCompleto,

    -- info cuanto
    TH.PurchaseAmount as MontoCompra,
    TH.Items as ProductosComprados

  FROM `papajohnsec.papajohns_loyalty_ec.RetailTransactionHeaders` TH
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.SubEntity` S ON TH.SubEntityID = S.SubEntityID
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.TransactionTypes` TT ON TH.TransactionType = TT.TransactionTypeID
  LEFT JOIN `papajohnsec.papajohns_loyalty_ec.Accounts` A ON TH.AccountID = A.AccountID
) 
SELECT * 
FROM DATOS;
