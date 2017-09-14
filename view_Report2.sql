

alter VIEW [Reports].[view_Report2]
AS
SELECT        cast(s.ID_SKU as nvarchar(40)) ID_SKU, u.Articul, s.Year, s.WeekNumber, s.ID_Shop, sh.Name, 
              dbo.udf_IsCurrentSeason(u.Prop_PervData) AS [Current\Old],
              s.RetailPrice, s.PurchasePrice, s.Leftover,
              u.Prop_Sekt, u.Prop_Gender, u.Prop_Zon, u.Prop_Kateg, 
              u.Prop_Podkat, u.A_Color, u.A_Size,
              s.NSales, s.SalesSum,
              s.LeftoverMargin, s.Leftover AS LeftoverMix,
              Discount, s.Margin
FROM            dbo._Report2 AS s INNER JOIN
                         dbo.SKU AS u ON u.ID_SKU = s.ID_SKU INNER JOIN
                         dbo.Shops AS sh ON sh.ID_Shop = s.ID_Shop
GO

