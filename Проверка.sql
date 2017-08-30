
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

select SKU_Count = @SKU_Count,
       SKU_wo_price = @SKU_wo_price,
       SKU_wo_purchase_price = @SKU_wo_purchase_price,
       SKU_wo_retail_price = @SKU_wo_retail_price,
       (select max([Date]) from dbo.Movement) as [Max дата движений],
       (select count(1) from dbo.Movement) as [Всего движений];