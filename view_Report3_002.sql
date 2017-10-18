


ALTER VIEW [Reports].[view_Report3_002]
AS


select OrderNumber, Model, Articul,
       AvgPurchasePricePlan = Avg( PurchasePricePlan ),
       AvgPurchasePriceFact = Avg( PurchasePriceFact ),
       SumQuantityPlan = Sum( QuantityPlan ),
       SumQuantityFact = Sum( QuantityFact ),
       Delta = IsNull(Avg( PurchasePriceFact ) * Sum( QuantityFact ), 0) - IsNull(Avg( PurchasePricePlan ) * Sum( QuantityPlan ), 0)
from( select isnull(f.OrderNumber, r.OrderNumber) as OrderNumber,
             isnull(f.Model, r.Model) as Model,
             f.Articul,
             r.PurchasePrice as PurchasePricePlan,
             f.PurchasePrice as PurchasePriceFact,
             r.Quantity as QuantityPlan,
             f.Quantity as QuantityFact
      from OrdersFact f
        full join dbo.Orders r on r.OrderNumber = f.OrderNumber and f.Model = r.Model
        ) t
group by OrderNumber, Model, Articul

