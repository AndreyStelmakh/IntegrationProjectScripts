

alter procedure dbo.script_Report2
as
----use Reports

set datefirst 1

declare @BeginDate datetime;
set @BeginDate = cast(year(GetDate()) as nvarchar(5)) + '01' + '01';

declare @WeekDates table( [Year] smallint, [Week] smallint, BeginDate datetime2(4), EndDate datetime2(4));
insert into @WeekDates select * from dbo.udf_WeekBeginEndDates(@BeginDate, GetDate()) t
--------------------------------------------------------------------------------

declare @Shops table(ID_Shop uniqueidentifier);
insert into @Shops values('2CE04A70-3ACC-11E7-80DE-000C2915D7B8');  -- TAW БЧ
insert into @Shops values('CB2B30C2-CB24-11E6-941E-000C29ECCF5C');  -- PriceTime Ленинский
insert into @Shops values('24A37A2D-B08C-11E6-94E4-00155D462702');  -- PriceTime Дмитровка
insert into @Shops values('587093CA-55A8-11E7-BE20-B499BABE0386');  -- OneWay Райкин Плаза
insert into @Shops values('24A37A2E-B08C-11E6-94E4-00155D462702');  -- OneWay Дмитровка
insert into @Shops values('B4B810DB-A4F3-11E7-8E41-B499BABE0386');  -- ONEWAY Филион
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
         cross apply dbo.udf_SKUsSalesForPeriod(wd.BeginDate, wd.EndDate) sl
         -- фильтрация только нужными магазинами
         inner join @Shops sh on sl.ID_Shop = sh.ID_Shop ) as sc
on( tg.Year = sc.Year
and tg.[WeekNumber] = sc.[Week]
and tg.ID_Shop = sc.ID_Shop
and tg.ID_SKU = sc.ID_SKU )

when matched then
  update set tg.NSales = sc.NSales, tg.SalesSum = sc.SalesSum
when not matched then
  insert( Year, WeekNumber, ID_Shop, ID_SKU, NSales, SalesSum )
  values( sc.Year, sc.Week, sc.ID_Shop, sc.ID_SKU, sc.NSales, sc.SalesSum );


merge dbo.[_Report2] as tg
using( select wd.[Year],
              wd.[Week],
              sl.ID_Shop,
              sl.ID_SKU,
              sl.Quantity
       from @WeekDates wd
         cross apply dbo.udf_SKUsStockLeftoverOnDate(wd.EndDate) sl
         -- фильтрация только нужными магазинами
         inner join @Shops sh on sl.ID_Shop = sh.ID_Shop) as sc
on( tg.Year = sc.Year
and tg.[WeekNumber] = sc.[Week]
and tg.ID_Shop = sc.ID_Shop
and tg.ID_SKU = sc.ID_SKU )
when matched then
  update set tg.Leftover = sc.Quantity
when not matched then
  insert( Year, WeekNumber, ID_Shop, ID_SKU, Leftover )
  values( sc.Year, sc.Week, sc.ID_Shop, sc.ID_SKU, sc.Quantity );


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


insert into Monitor.Journal (Data) values (
'<complete item="report2"
           rows="' + cast((select count(1) from dbo._Report2) as nvarchar(max)) + '"
           datefirst="' + cast(@@DATEFIRST as nvarchar(max)) + '" />')





