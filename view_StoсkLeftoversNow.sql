
-- может не давать ожидаемого результата, т.к. выгрузка данных осуществляется ночью
create or alter view Reports.view_StockLeftoversNow
as

  select sh.[Name], u.Articul, s.Quantity
  from dbo.udfStockLeftoversOnDate(GetDate()) s
  left join dbo.SKU u on s.ID_SKU = u.ID_SKU
  left join dbo.Shops sh on s.ID_Shop = sh.ID_Shop;
