
USE [Reports]
GO

/****** Object:  View [Reports].[view_MovementWithPrices]    Script Date: 23.08.2017 15:00:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Reports].[view_MovementWithPrices]
AS
SELECT ID_Doc, Date, Date_Day, Doc_Number, Doc_Str, ID_Shop, ID_SKU, Kol, ID_Shop_2,
       dbo.udf_ArticulRetailPriceOnDate(ID_SKU, Date) AS [Retail Price],
       dbo.udf_ArticulPurchasePriceOnDate(ID_SKU, Date) AS [Purchase Price]
FROM dbo.Movement AS m
GO


