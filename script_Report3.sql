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

select OrderNumber, Articul,
       SumPurchasePricePlan = sum( PurchasePricePlan ),
       SumPurchasePriceFact = sum( PurchasePriceFact ),
       SumQuantityPlan = sum( QuantityPlan ),
       SumQuantityFact = sum( QuantityFact )
from( select isnull(f.OrderNumber, r.OrderNumber) as OrderNumber,
             isnull(dbo.udf_CropEnding( f.ArticulCrop ), r.Articul) as Articul,
             r.PurchasePrice as PurchasePricePlan,
             f.PurchasePrice as PurchasePriceFact,
             r.Quantity as QuantityPlan,
             f.Quantity as QuantityFact
      from( select *, dbo.udf_CropEnding( Articul ) as ArticulCrop from OrdersFact ) f
        full join dbo.Orders r on r.OrderNumber = f.OrderNumber and f.ArticulCrop = r.Articul ) t
group by OrderNumber, Articul
