
alter view Reports.view_Report3 as
with t_plan as(
SELECT [OrderNumber]
      --,[Date]
      ,[Articul]
      ,[Value] = sum([Quantity]*[PurchasePrice])
  FROM [dbo].[Orders]
  group by OrderNumber, Articul),
t1 as(
SELECT [OrderNumber]
    ,Articul = dbo.[udf_CropEnding](Articul) 
    ,[Quantity]
    ,[PurchasePrice]
FROM [Reports].[dbo].[OrdersFact]
),
t_fact as(
select OrderNumber,
       Articul,
       [Value] = sum([Quantity]*[PurchasePrice])
from t1
group by OrderNumber, Articul)

select OrderNumber = isnull(t_fact.OrderNumber, t_plan.OrderNumber),
       Articul = isnull(t_fact.Articul, t_plan.Articul),
       Fact = t_fact.Value,
       [Plan] = t_plan.Value,
       Delta = isnull(t_fact.Value, 0) - isnull(t_plan.Value, 0)
from t_plan
full join t_fact on t_plan.OrderNumber = t_fact.OrderNumber
                and t_plan.Articul = t_fact.Articul
