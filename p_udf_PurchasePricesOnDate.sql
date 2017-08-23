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
CREATE or alter FUNCTION dbo.udf_PurchasePricesOnDate (
  @Date datetime2(4)
)
RETURNS 
@result TABLE (
  [Date] datetime2(4),
  ID_SKU uniqueidentifier,
  Price numeric(18, 4)
)
AS
BEGIN

  declare @ID_Price_Purchase uniqueidentifier = 'F1880CC3-DBF7-11E6-8074-00155D63110F';

  insert into @result
  select pl.[Date],
         pl.ID_SKU,
         pl.Price
  from dbo.PriceList pl
    inner join
    ( select ID_SKU, max([Date]) as max_date from dbo.PriceList
      where ID_Price = @ID_Price_Purchase
        and [Date] < @Date
      group by ID_SKU ) ps on ps.ID_SKU = pl.ID_SKU
                          and ps.max_date = pl.[Date]
  where pl.ID_Price = @ID_Price_Purchase;


	RETURN 
END
GO



