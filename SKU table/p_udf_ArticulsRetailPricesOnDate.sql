-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION dbo.udf_ArticulsRetailPricesOnDate (
  @Date datetime2(4)
)
RETURNS 
@result TABLE (
  Articul nvarchar(60),
  A_Color nvarchar(100),
  Price numeric(18, 4)
)
AS
BEGIN

  declare @ID_Price_Retail uniqueidentifier = '8374421B-7199-11E6-B63C-0002C9E8F1B0';
  declare @ID_Price_Purchase uniqueidentifier = 'F1880CC3-DBF7-11E6-8074-00155D63110F';

  insert into @result
  select Articul,
         A_Color,
         max(pl.Price)
  from dbo.PriceList pl
    inner join( select ID_SKU, max([Date]) as max_date from dbo.PriceList
                where ID_Price = @ID_Price_Retail
                  and [Date] < @Date
                group by ID_SKU ) ps on ps.ID_SKU = pl.ID_SKU
                                    and ps.max_date = pl.[Date]
    inner join dbo.SKU u on u.ID_SKU = ps.ID_SKU
  where pl.ID_Price = @ID_Price_Retail
  group by Articul, A_Color;


	RETURN 
END
GO



