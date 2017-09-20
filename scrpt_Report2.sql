

--create procedure dbo.scrpt_Report2
--as
----use Reports

set datefirst 1

declare @WeekDates table( [Year] smallint, [Week] smallint, BeginDate datetime2(4), EndDate datetime2(4));

insert into @WeekDates
select *
from dbo.udf_WeekBeginEndDates(GetDate() - 30, GetDate()) t
--------------------------------------------------------------------------------

declare @Shops table(ID_Shop uniqueidentifier);
insert into @Shops values('2CE04A70-3ACC-11E7-80DE-000C2915D7B8');  -- TAW ��
insert into @Shops values('CB2B30C2-CB24-11E6-941E-000C29ECCF5C');  -- PriceTime ���������
insert into @Shops values('24A37A2D-B08C-11E6-94E4-00155D462702');  -- PriceTime ���������
insert into @Shops values('587093CA-55A8-11E7-BE20-B499BABE0386');  -- OneWay ������ �����
insert into @Shops values('24A37A2E-B08C-11E6-94E4-00155D462702');  -- OneWay ���������

declare @ShopsAndStores table(ID_Shop uniqueidentifier);
insert into @ShopsAndStores select * from @Shops;
insert into @ShopsAndStores values('8374421C-7199-11E6-B63C-0002C9E8F1B0'); -- �����������
--------------------------------------------------------------------------------

truncate table dbo._Report2

merge dbo.[_Report2] as tg
using( select wd.[Year],
              wd.[Week],
              sl.ID_Shop,
              sl.ID_SKU,
              NSales = -sl.Quantity,
              SalesSum = -sl.[SalesSum]
       from @WeekDates wd
         cross apply dbo.udf_SKUsSalesForPeriod(wd.BeginDate, wd.EndDate) sl ) as sc
on( tg.Year = sc.Year
and tg.[WeekNumber] = sc.[Week]
and tg.ID_Shop = sc.ID_Shop
and tg.ID_SKU = sc.ID_SKU )

when matched then
  update set tg.NSales = sc.NSales, tg.SalesSum = sc.SalesSum
when not matched then
  insert( Year, WeekNumber, ID_Shop, ID_SKU, NSales, SalesSum )
  values( sc.Year, sc.Week, sc.ID_Shop, sc.ID_SKU, sc.NSales, sc.SalesSum );
print '010'
merge dbo.[_Report2] as tg
using( select wd.[Year],
              wd.[Week],
              sl.ID_Shop,
              sl.ID_SKU,
              sl.Quantity
       from @WeekDates wd
         cross apply dbo.udf_SKUsStockLeftoverOnDate(wd.EndDate) sl ) as sc
on( tg.Year = sc.Year
and tg.[WeekNumber] = sc.[Week]
and tg.ID_Shop = sc.ID_Shop
and tg.ID_SKU = sc.ID_SKU )
when matched then
  update set tg.Leftover = sc.Quantity
when not matched then
  insert( Year, WeekNumber, ID_Shop, ID_SKU, Leftover )
  values( sc.Year, sc.Week, sc.ID_Shop, sc.ID_SKU, sc.Quantity );
print '020'


declare @Prices table( [Year] smallint, [Week] smallint,
                       ID_SKU uniqueidentifier,
                       RetailPrice decimal(18,4), PurchasePrice decimal(18,4) );
insert into @Prices
select wd.[Year], wd.[Week], u.ID_SKU,
       RetailPrice = dbo.udf_SKURetailPriceOnDate(u.ID_SKU, wd.BeginDate),
       PurchasePrice = dbo.udf_SKUPurchasePriceOnDate(u.ID_SKU, wd.BeginDate)
from @WeekDates wd
    cross join dbo.SKU u


update s
set RetailPrice = p.RetailPrice,
    PurchasePrice = p.PurchasePrice
from dbo._Report2 s
  inner join @Prices p on p.Year = s.Year and p.Week = s.WeekNumber and p.ID_SKU = s.ID_SKU
