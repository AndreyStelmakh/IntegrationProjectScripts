/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
use Reports


-- План
SELECT [OrderNumber]
      ,sum(Quantity * PurchasePrice)
FROM [Reports].[dbo].[Orders]
group by OrderNumber

-- ПоступлениеТоваровУслуг (приход)

-- Факт
select top(10000) *, [Order], [Sum]
from dbo.Movement m
  inner join dbo.SKU u on u.ID_SKU = m.ID_SKU

where Doc_Str = 'ПоступлениеТоваровУслуг (приход)'
