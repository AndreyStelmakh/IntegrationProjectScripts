

alter VIEW [Reports].[view_Sales]
AS
SELECT        s.Year, s.WeekNumber, s.ID_Shop, sh.Name, s.ID_SKU, dbo.udf_IsCurrentSeason(u.Prop_PervData) AS [Current\Old], s.RetailPrice, s.PurchasePrice, s.Leftover, u.Prop_Sekt, u.Prop_Gender, u.Prop_Zon, u.Prop_Kateg, 
                         u.Prop_Podkat, u.A_Color, u.A_Size, s.NSales, s.SalesSum, s.LeftoverMargin, s.LeftoverMargin AS LeftoverMarginPercent
FROM            Reports._Sales AS s INNER JOIN
                         dbo.SKU AS u ON u.ID_SKU = s.ID_SKU INNER JOIN
                         dbo.Shops AS sh ON sh.ID_Shop = s.ID_Shop
GO

