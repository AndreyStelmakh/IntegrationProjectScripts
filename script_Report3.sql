
alter procedure dbo.script_Report3
as
----use Reports

set datefirst 1


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

truncate table dbo._Report3;

insert into dbo._Report3
select OrderNumber, Model, Articul,
       AvgPurchasePricePlan = Avg( PurchasePricePlan ),
       AvgPurchasePriceFact = Avg( PurchasePriceFact ),
       SumQuantityPlan = Sum( QuantityPlan ),
       SumQuantityFact = Sum( QuantityFact )
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


insert into Monitor.Journal (Data) values (
'<complete item="report3"
           rows="' + cast((select count(1) from dbo._Report3) as nvarchar(max)) + '"
           datefirst="' + cast(@@DATEFIRST as nvarchar(max)) + '" />')

-- заказ со значением Null в поле Model
--select * from dbo.OrdersFact where Model is null and OrderNumber = 'OF0001862'


