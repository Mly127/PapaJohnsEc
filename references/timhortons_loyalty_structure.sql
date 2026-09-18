-- ==========================================================
-- Estructura y Vistas de Referencia: timhorton-loyaltymx.Loyalty
-- Extraído el: 2026-09-18
-- ==========================================================

-- ----------------------------------------------------------
-- Objeto: Accounts (TABLE)
-- Filas aproximadas: 115178
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.Accounts` (
  `AccountID` INTEGER,
  `HoldingID` INTEGER,
  `LoyaltyProgramID` INTEGER,
  `EntityID` INTEGER,
  `SubEntityID` INTEGER,
  `AccountNumber` STRING,
  `FirstName` STRING,
  `LastName` STRING,
  `Email` STRING,
  `MobilePhone` STRING,
  `Status` STRING,
  `EnrollmentDate` INTEGER,
  `PointsAccumulated` FLOAT,
  `PointsBonus` FLOAT,
  `PointsRedeemed` FLOAT,
  `PointsExpired` FLOAT,
  `PointsLost` INTEGER,
  `PointsInTransit` INTEGER,
  `PointsAvailable` FLOAT,
  `CashIn` FLOAT,
  `CashOut` FLOAT,
  `CashAvailable` FLOAT,
  `AccountTypeID` FLOAT,
  `CreateDate` STRING,
  `UpdateDate` STRING
);

-- ----------------------------------------------------------
-- Objeto: Bonus (TABLE)
-- Filas aproximadas: 10
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.Bonus` (
  `BonusID` INTEGER,
  `AccountID` INTEGER,
  `Description` STRING,
  `PointsBonus` INTEGER,
  `PointsRedeemed` INTEGER,
  `PointsAvailable` INTEGER,
  `CreateDate` TIMESTAMP,
  `CreateUserID` INTEGER,
  `UpdateDate` TIMESTAMP,
  `UpdateUserID` FLOAT
);

-- ----------------------------------------------------------
-- Objeto: RetailTransactionCash (TABLE)
-- Filas aproximadas: 8567
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.RetailTransactionCash` (
  `CashMovementID` INTEGER,
  `HoldingID` INTEGER,
  `LoyaltyProgramID` INTEGER,
  `EntityID` INTEGER,
  `SubEntityID` INTEGER,
  `CardNumber` STRING,
  `AccountID` INTEGER,
  `MovementTypeID` INTEGER,
  `TransactionID` STRING,
  `POSID` STRING,
  `CashierID` STRING,
  `RegisteredCashAmount` FLOAT,
  `CurrencyID` INTEGER,
  `MovementDate` TIMESTAMP,
  `MovementSign` STRING,
  `MovementOrigin` STRING,
  `CustomField1` STRING,
  `CustomField2` STRING,
  `CustomField3` STRING,
  `SourceFileName` STRING,
  `SourceProcessID` STRING,
  `CreateDate` TIMESTAMP,
  `Description` STRING
);

-- ----------------------------------------------------------
-- Objeto: RetailTransactionDetails (TABLE)
-- Filas aproximadas: 111294
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.RetailTransactionDetails` (
  `TransactionDetailID` INTEGER,
  `HoldingID` INTEGER,
  `LoyaltyProgramID` INTEGER,
  `EntityID` INTEGER,
  `SubEntityID` INTEGER,
  `CardNumber` STRING,
  `AccountID` INTEGER,
  `TransactionHeaderID` STRING,
  `LineID` STRING,
  `ItemID` STRING,
  `Items` FLOAT,
  `PurchaseAmount` FLOAT,
  `Discount` STRING,
  `CustomField1` INTEGER,
  `CustomField2` INTEGER,
  `CustomField3` INTEGER,
  `CustomField4` INTEGER,
  `SourceFileName` STRING,
  `SourceProcessID` STRING,
  `CalculatedPoints` INTEGER,
  `ItemDescription` STRING
);

-- ----------------------------------------------------------
-- Objeto: RetailTransactionHeaders (TABLE)
-- Filas aproximadas: 74609
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.RetailTransactionHeaders` (
  `TransactionHeaderID` INTEGER,
  `HoldingID` INTEGER,
  `LoyaltyProgramID` INTEGER,
  `EntityID` INTEGER,
  `SubEntityID` INTEGER,
  `CardNumber` STRING,
  `AccountID` INTEGER,
  `TransactionID` STRING,
  `TransactionType` INTEGER,
  `Status` STRING,
  `POSID` INTEGER,
  `CashierID` INTEGER,
  `PurchaseAmount` FLOAT,
  `SubPurchaseAmount` FLOAT,
  `Discount` FLOAT,
  `Taxes` FLOAT,
  `CurrencyID` INTEGER,
  `PurchaseDate` TIMESTAMP,
  `TransactionSign` STRING,
  `TransactionOrigin` STRING,
  `Lines` INTEGER,
  `Items` FLOAT,
  `CustomField1` STRING,
  `CustomField2` STRING,
  `CustomField3` STRING,
  `SourceFileName` STRING,
  `SourceProcessID` STRING,
  `CalculatedPoints` FLOAT,
  `PointsInTransit` INTEGER,
  `PointsRedeemed` FLOAT,
  `PointsExpired` FLOAT,
  `PointsLost` INTEGER,
  `PointsAvailable` FLOAT,
  `CreateDate` STRING,
  `UpdateDate` STRING,
  `UpdateProcessID` INTEGER
);

-- ----------------------------------------------------------
-- Objeto: RewardRedemptions (TABLE)
-- Filas aproximadas: 7
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.RewardRedemptions` (
  `SRewardRedemptionID` INTEGER,
  `AccountID` INTEGER,
  `SRewardID` INTEGER,
  `UserAppID` INTEGER,
  `RedemptionDate` TIMESTAMP
);

-- ----------------------------------------------------------
-- Objeto: SRewards (TABLE)
-- Filas aproximadas: 16
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.SRewards` (
  `RewardID` INTEGER,
  `HoldingID` INTEGER,
  `LoyaltyProgramID` INTEGER,
  `EntityID` INTEGER,
  `RewardName` STRING,
  `Points` INTEGER,
  `Status` STRING,
  `QuantityStock` INTEGER,
  `QuantityRedempts` INTEGER,
  `CreateDate` STRING,
  `UpdateDate` INTEGER
);

-- ----------------------------------------------------------
-- Objeto: SubEntity (TABLE)
-- Filas aproximadas: 89
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.SubEntity` (
  `SubEntityID` INTEGER,
  `HoldingID` INTEGER,
  `LoyaltyProgramID` INTEGER,
  `EntityID` INTEGER,
  `SubEntityName` STRING,
  `Status` STRING,
  `CreateDate` TIMESTAMP,
  `CreateUserID` INTEGER,
  `UpdateDate` TIMESTAMP,
  `UpdateUserID` FLOAT
);

-- ----------------------------------------------------------
-- Objeto: TransactionTypes (TABLE)
-- Filas aproximadas: 2
-- ----------------------------------------------------------
CREATE TABLE IF NOT EXISTS `timhorton-loyaltymx.Loyalty.TransactionTypes` (
  `TransactionTypeID` INTEGER,
  `Description` STRING,
  `Status` STRING,
  `CreateDate` TIMESTAMP,
  `CreateUserID` INTEGER,
  `UpdateDate` INTEGER,
  `UpdateUserID` INTEGER
);

-- ----------------------------------------------------------
-- Objeto: vw_Canjes (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_Canjes` AS
WITH DATOS AS 
(
  SELECT
    --info del canje
    R.RewardID as ID,
    RR.RedemptionDate as FechaDelCanje,
    
    --info del premio
    R.RewardName as Premio,
    R.Points as Puntos,
    R.QuantityRedempts as CantidadCanjes,
    R.QuantityStock as CantidadInventario,

    --info sobre el cliente
    C.NumeroCuenta as NumeroDeTarjeta,
    C.NombreCompleto as NombreCompleto,
    C.Nombre as Nombre,
    C.Apellido as Apellido,


  FROM `timhorton-loyaltymx.Loyalty.RewardRedemptions` RR 

  INNER JOIN `timhorton-loyaltymx.Loyalty.SRewards` R ON RR.SRewardID = R.RewardID
  
  INNER JOIN `timhorton-loyaltymx.Loyalty.vw_Clientes` C ON RR.AccountID = C.ID
)

SELECT *
FROM DATOS;


;

-- ----------------------------------------------------------
-- Objeto: vw_Cash (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_Cash` AS
WITH DATOS AS 
(
  SELECT 
    --info donde
    TC.AccountID as Cuenta,
    TC.CardNumber as Tarjeta,
    TC.CreateDate as FechaTransaccion,
    S.SubEntityName as Sucursal,
    TC.CashierID as Caja,

    --info cash
    TC.Description as TipoMovimiento,
    TC.RegisteredCashAmount as Cash,
    IF(TC.Description = "Débito", TC.RegisteredCashAmount, 0) as CashCambiado,
    IF(TC.Description = "Crédito", TC.RegisteredCashAmount, 0) as CashDepositado

FROM `timhorton-loyaltymx.Loyalty.RetailTransactionCash` TC

  INNER JOIN `timhorton-loyaltymx.Loyalty.SubEntity` S ON TC.SubEntityID = S.SubEntityID
)

SELECT *
FROM DATOS;
;

-- ----------------------------------------------------------
-- Objeto: vw_Clientes (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_Clientes` AS
WITH DATOS AS 

(
  SELECT 

    --Datos cliente
    DATE(A.CreateDate) as FechaCreacion,
    A.AccountID as ID,
    A.AccountNumber as NumeroCuenta,
    A.FirstName as Nombre,
    A.LastName as Apellido,
    CONCAT(IFNULL(A.FirstName, " "), " ", IFNULL(A.LastName, " ")) as NombreCompleto,
    A.Email as Email,
    A.MobilePhone as Telefono,
    --S.SubEntityName as Sucursal,
    A.Status as Estatus,
    IF((
      SELECT DATE(MAX(T.CreateDate))
      FROM `timhorton-loyaltymx.Loyalty.RetailTransactionHeaders` T
      WHERE A.AccountID = T.AccountID 
    ) >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH), "Con Actividad", "Sin Actividad")  as EstatusActividad,
    IF(A.PointsAvailable > 0, "Con Puntos", "Sin Puntos") as EstatusPuntos, 
    IF(A.CashAvailable > 0, "Con Cash", "Sin Cash") as EstatusCash, 

    --Datos puntos y cash
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

  FROM `timhorton-loyaltymx.Loyalty.Accounts` A 

)

SELECT * 
FROM DATOS;
;

-- ----------------------------------------------------------
-- Objeto: vw_ClientesDetalles (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_ClientesDetalles` AS
WITH DATOS AS 

(
  SELECT 

    --Datos cliente
    FechaCreacion,
    ID,
    NumeroCuenta,
    Nombre,
    Apellido,
    NombreCompleto,
    Email,
    Telefono, 

    --Datos puntos y cash
    TH.CalculatedPoints as PuntosAcumulados,
    TH.PointsExpired as PuntosExpirados,
    TH.PointsAvailable + B.PointsAvailable as PuntosDisponibles,
    TH.PointsInTransit as PuntosEnTransito,
    TH.PointsRedeemed + B.PointsRedeemed as PuntosRedimidos,
    B.PointsBonus as PuntosBono,
    TH.PointsLost as PuntosPerdidos,
    
    IF(TC.Description = "Débito", TC.RegisteredCashAmount, 0) as CashCambiado,
    IF(TC.Description = "Crédito", TC.RegisteredCashAmount, 0) as CashDepositado

  FROM `timhorton-loyaltymx.Loyalty.vw_Clientes` C 

  INNER JOIN `timhorton-loyaltymx.Loyalty.RetailTransactionHeaders` TH ON C.ID = TH.AccountID

  INNER JOIN `timhorton-loyaltymx.Loyalty.Bonus` B ON C.ID = B.AccountID

  INNER JOIN `timhorton-loyaltymx.Loyalty.RetailTransactionCash` TC ON C.ID = TC.AccountID

)

SELECT 
*, 
DATOS.CashDepositado-DATOS.CashCambiado as CashDisponible
FROM DATOS;
;

-- ----------------------------------------------------------
-- Objeto: vw_Puntos (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_Puntos` AS
WITH DATOS AS 
(
    SELECT 
      --info donde
      TH.AccountID as Cuenta,
      TH.CardNumber as Tarjeta,
      TH.TransactionID as ID,
      TH.CreateDate as FechaTransaccion,
      S.SubEntityName as Sucursal,
      TH.CashierID as Caja,
      TT.Description as Tipo,

      --info puntos
      TH.CalculatedPoints as PuntosAcumulados,
      TH.PointsRedeemed as PuntosRedimidos,
      TH.PointsAvailable as PuntosDisponibles

 FROM `timhorton-loyaltymx.Loyalty.RetailTransactionHeaders` TH

    INNER JOIN `timhorton-loyaltymx.Loyalty.SubEntity` S ON TH.SubEntityID = S.SubEntityID

    INNER JOIN `timhorton-loyaltymx.Loyalty.TransactionTypes` TT ON TH.TransactionType = TT.TransactionTypeID

) 

SELECT * 
FROM DATOS;
;

-- ----------------------------------------------------------
-- Objeto: vw_PuntosBono (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_PuntosBono` AS
WITH DATOS AS 
(
  SELECT 
    --info donde
    B.AccountID as Cliente,
    DATE(B.CreateDate) as FechaBono,
    B.PointsAvailable as PuntosDisponibles,
    B.PointsBonus as PuntosBono,
    B.PointsRedeemed as PuntosRedimidos

  FROM `timhorton-loyaltymx.Loyalty.Bonus` B
)

SELECT *
FROM DATOS;
;

-- ----------------------------------------------------------
-- Objeto: vw_Transacciones (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_Transacciones` AS
WITH DATOS AS 
(
    SELECT 
      --info donde
      TH.TransactionID as ID,
      TH.CreateDate as FechaTransaccion,
      S.SubEntityName as Sucursal,
      TH.CashierID as Caja,
      TT.Description as Tipo,

      --info quien
      A.AccountNumber as NumeroCliente,
      CONCAT(IFNULL(A.FirstName, " "), " ", IFNULL(A.LastName, " ")) as NombreCompleto,

      --info cuanto
      TH.PurchaseAmount as MontoCompra,
      TH.Items as ProductosComprados,

    FROM `timhorton-loyaltymx.Loyalty.RetailTransactionHeaders` TH

    INNER JOIN `timhorton-loyaltymx.Loyalty.SubEntity` S ON TH.SubEntityID = S.SubEntityID

    INNER JOIN `timhorton-loyaltymx.Loyalty.TransactionTypes` TT ON TH.TransactionType = TT.TransactionTypeID

    INNER JOIN `timhorton-loyaltymx.Loyalty.Accounts` A ON TH.AccountID = A.AccountID

) 

SELECT * 
FROM DATOS;
;

-- ----------------------------------------------------------
-- Objeto: vw_wallet_txn_base (VIEW)
-- Filas aproximadas: 0
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW `timhorton-loyaltymx.Loyalty.vw_wallet_txn_base` AS
SELECT
  CS.CashMovementID, --ID único del movimiento de cash/wallet. Cada operación (carga, compra) tiene uno.
  CS.HoldingID, --ID del grupo empresarial. Normalmente siempre 1.
  CS.LoyaltyProgramID, --ID del programa de lealtad (TH México).
  CS.EntityID, --Entidad principal del movimiento (marca o empresa).
  CS.SubEntityID, --ID del restaurante donde ocurrió la transacción.
  E.SubEntityName        AS Sucursal, --Nombre del restaurante (ej. Fashion Drive).
  CS.CardNumber          AS Tarjeta, --Número de tarjeta lealtad asociado.
  CS.AccountID           AS Cuenta,  --ID interno del invitado (si está registrado).
  CS.MovementTypeID,  --Tipo de movimiento: 1=con tarjeta, 0=sin tarjeta.
  CS.TransactionID,  --ID de la transacción del POS (único por compra o carga).
  CS.POSID, --Identificador de la caja POS.
  CS.CashierID           AS Caja, --Número o ID del cajero.
  CAST(CS.RegisteredCashAmount AS NUMERIC) AS Cash, --Monto del movimiento (carga o gasto).
  CS.CurrencyID,    --ID de moneda (generalmente MXN).
  CS.MovementDate,  --Fecha original del POS (cuando pasó).
  CS.MovementSign,    --“+” o “-”, dependiendo de cómo se grabó. No siempre indica crédito/débito.
  CS.MovementOrigin,  --Origen: app, POS, web, etc.
  CS.CustomField1,
  CS.CustomField2,
  CS.CustomField3,
  CS.SourceFileName,    --Archivo de origen si fue cargado por batch.
  CS.SourceProcessID,   --ID del proceso que subió la info.
  CS.CreateDate          AS FechaTransaccion, --Fecha en que se registró en la BD.
  CS.Description         AS TipoMovimiento,  -- “Crédito” (carga) o “Débito” (compra).
  A.FirstName            AS Nombre, --Nombre del invitado.
  A.LastName             AS Apellido,   --Apellido del invitado.

  -- Derivados clave
  CASE
    WHEN CS.Description = 'Crédito' THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
    ELSE 0
  END AS MontoCredito, --Si es “Crédito”, trae el monto. Si no, 0.

  CASE
    WHEN CS.Description = 'Débito' THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
    ELSE 0
  END AS MontoDebito,   --Si es “Débito”, trae el monto. Si no, 0.

  CASE WHEN CS.AccountID IS NOT NULL THEN TRUE ELSE FALSE END AS TieneCuentaInterna,  --TRUE/FALSE → indica si hay cuenta vinculada.

  CASE WHEN CS.MovementTypeID = 1 THEN 'Con Tj' ELSE 'Sin Tj' END AS MovementType, --“Con Tj” o “Sin Tj” (usa MovementTypeID).

  -- Puntos desde headers
  TH.CalculatedPoints as PuntosAcumulados, --Puntos generados en la transacción.
  TH.PointsRedeemed   as PuntosRedimidos,  --Puntos gastados.
  TH.PointsAvailable  as PuntosDisponibles, --Puntos disponibles del invitado en ese momento.
  TH.PointsExpired    as PuntosVencidos,  --Puntos expirados.
  TH.PointsInTransit  as PuntosEnTransit, --Puntos en proceso (pendientes de confirmarse).
  TH.PointsLost       as PuntosPerdidos, --Puntos eliminados por reglas de lealtad.

  -- 🔹 Monto con signo: créditos (+), débitos (–)
  CASE
    WHEN CS.Description = 'Crédito'
      THEN CAST(CS.RegisteredCashAmount AS NUMERIC)
    WHEN CS.Description = 'Débito'
      THEN -CAST(CS.RegisteredCashAmount AS NUMERIC)
    ELSE 0
  END AS MontoSigned,

  -- 🔹 Saldo acumulado por Cuenta + Tarjeta
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

  -- Normalizaciones útiles
  DATETIME(TIMESTAMP(CS.CreateDate), "America/Mexico_City") AS FechaCDMX --Fecha del movimiento convertida a hora de CDMX.

FROM `timhorton-loyaltymx.Loyalty.RetailTransactionCash`  CS
LEFT JOIN `timhorton-loyaltymx.Loyalty.RetailTransactionHeaders` TH 
       ON  CS.TransactionID      = TH.TransactionID
       AND CS.LoyaltyProgramID   = TH.LoyaltyProgramID
       AND CS.EntityID           = TH.EntityID
       AND CS.SubEntityID        = TH.SubEntityID
LEFT JOIN `timhorton-loyaltymx.Loyalty.SubEntity`         E  ON CS.SubEntityID = E.SubEntityID
LEFT JOIN `timhorton-loyaltymx.Loyalty.Accounts`          A  ON CS.AccountID  = A.AccountID
;

