/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
use Reports


---- План
--SELECT 
--      *
--FROM [Reports].[dbo].[Orders]


---- Факт
--select top (100) *, dbo.udf_CropEnding( f.Articul )
--from dbo.OrdersFact f

---------------------------------------------


--declare @Fact table( [OrderNumber] [nvarchar](25) NULL,
--	                   [Date] [datetime2](4) NULL,
--	                   [ArticulCrop] [nvarchar](60) NULL,
--	                   [Quantity] [int] NULL,
--	                   [PurchasePrice] [decimal](18, 4) NULL/*,
--                     index ix nonclustered( ArticulCrop )*/);

--insert into @Fact select OrderNumber, [Date], dbo.udf_CropEnding( Articul ), Quantity, PurchasePrice from dbo.OrdersFact;

select OrderNumber, Model,
       SumPurchasePricePlan = sum( PurchasePricePlan ),
       SumPurchasePriceFact = sum( PurchasePriceFact ),
       SumQuantityPlan = sum( QuantityPlan ),
       SumQuantityFact = sum( QuantityFact )
from( select isnull(f.OrderNumber, r.OrderNumber) as OrderNumber,
             isnull(f.Model, r.Model) as Model,
             r.PurchasePrice as PurchasePricePlan,
             f.PurchasePrice as PurchasePriceFact,
             r.Quantity as QuantityPlan,
             f.Quantity as QuantityFact
      from OrdersFact f
        full join dbo.Orders r on r.OrderNumber = f.OrderNumber and f.Model = r.Model
        ) t
group by OrderNumber, Model


select * from dbo.Orders R inner join dbo.OrdersFact F
on R.OrderNumber = F.OrderNumber and R.Model = F.Model