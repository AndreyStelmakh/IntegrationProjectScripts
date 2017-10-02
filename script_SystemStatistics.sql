
alter procedure dbo.script_SystemStatistics
as

declare @ID_Price_Retail uniqueidentifier = '8374421B-7199-11E6-B63C-0002C9E8F1B0';
declare @ID_Price_Purchase uniqueidentifier = 'F1880CC3-DBF7-11E6-8074-00155D63110F';


declare @SKU_Count int;
select @SKU_Count = count(1) from dbo.SKU;

declare @SKU_wo_price int,
        @SKU_wo_purchase_price int,
        @SKU_wo_retail_price int;

select @SKU_wo_price = count(1)
from dbo.SKU u
  left join dbo.PriceList pl on u.ID_SKU = pl.ID_SKU
where Price is null

--select @SKU_wo_purchase_price = count(1)
--from dbo.SKU u
--  left join dbo.PriceList pl on u.ID_SKU = pl.ID_SKU
--where Price is null
--  and pl.ID_Price not in( @ID_Price_Retail );

--select @SKU_wo_retail_price = count(1)
--from dbo.SKU u
--  left join dbo.PriceList pl on u.ID_SKU = pl.ID_SKU
--where Price is null
--  and pl.ID_Price not in( @ID_Price_Purchase );




declare @EmptySKUCount int;

select @EmptySKUCount = count(1)
from dbo.Movement m
left join dbo.SKU u on u.ID_SKU = m.ID_SKU
where u.ID_SKU is null

declare @xmlData xml;
set @xmlData = (
select SKU_Count = @SKU_Count,
       SKU_wo_price = @SKU_wo_price,
       SKU_wo_purchase_price = @SKU_wo_purchase_price,
       SKU_wo_retail_price = @SKU_wo_retail_price,
       (select max([Date]) from dbo.Movement) as [Maxƒатаƒвижений],
       (select count(1) from dbo.Movement) as [¬сегоƒвижений],
       @EmptySKUCount as [ќтсутствуетвЌоменклатуре]
for xml raw);

insert into Monitor.Journal ([Data]) values (@xmlData);

select SKU_Count = @SKU_Count,
       Articuls_Count = (select count(1) from dbo.Articuls),
       SKU_wo_price = @SKU_wo_price,
       SKU_wo_purchase_price = @SKU_wo_purchase_price,
       SKU_wo_retail_price = @SKU_wo_retail_price,
       (select max([Date]) from dbo.Movement) as [Maxƒатаƒвижений],
       (select count(1) from dbo.Movement) as [¬сегоƒвижений],
       @EmptySKUCount as [ќтсутствуетвЌоменклатуре]

select distinct u.Prop_Proekt, u.Articul as [с розничной ценой что-то не то]
from dbo.SKU u
  left join dbo.PriceList pl on u.ID_SKU = pl.ID_SKU
where Price is null
  and Prop_Proekt in ( 'PRICETIME', 'ONEWAY' )
  and (pl.ID_Price not in( @ID_Price_Purchase )
    or pl.ID_Price is null);

select distinct u.Prop_Proekt, u.Articul as [с закупочной ценой что-то не то]
from dbo.SKU u
  left join dbo.PriceList pl on u.ID_SKU = pl.ID_SKU
where Price is null
  and Prop_Proekt in ( 'PRICETIME', 'ONEWAY' )
  and (pl.ID_Price not in( @ID_Price_Retail )
    or pl.ID_Price is null);