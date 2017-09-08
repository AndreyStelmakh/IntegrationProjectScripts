

declare @WeekDates table( Year smallint, WeekNumber smallint, BeginDate datetime2(4), EndDate datetime2(4));

insert into @WeekDates
select *
from dbo.udf_WeekBeginEndDates(GetDate() - 30, GetDate()) t
--------------------------------------------------------------------------------

declare @Shops table(ID_Shop uniqueidentifier);
insert into @Shops values('2CE04A70-3ACC-11E7-80DE-000C2915D7B8');
insert into @Shops values('CB2B30C2-CB24-11E6-941E-000C29ECCF5C');
insert into @Shops values('24A37A2D-B08C-11E6-94E4-00155D462702');
insert into @Shops values('587093CA-55A8-11E7-BE20-B499BABE0386');
insert into @Shops values('24A37A2E-B08C-11E6-94E4-00155D462702');

declare @ShopsAndStores table(ID_Shop uniqueidentifier);
insert into @ShopsAndStores select * from @Shops;
insert into @ShopsAndStores values('8374421C-7199-11E6-B63C-0002C9E8F1B0');
--------------------------------------------------------------------------------

truncate table Reports._Sales

declare @Prices table( [Year] smallint, [Week] smallint,
                       ID_SKU uniqueidentifier,
                       RetailPrice decimal(18,4), PurchasePrice decimal(18,4) );
insert into @Prices
select wd.[Year], wd.WeekNumber, u.ID_SKU,
       RetailPrice = dbo.udf_SKURetailPriceOnDate(u.ID_SKU, wd.BeginDate),
       PurchasePrice = dbo.udf_SKUPurchasePriceOnDate(u.ID_SKU, wd.BeginDate)
from @WeekDates wd
    cross join dbo.SKU u


INSERT INTO [Reports].[_Sales]
           ([Year]
           ,[WeekNumber]
           ,[ID_Shop]
           ,[ID_SKU]
           ,[RetailPrice]
           ,[PurchasePrice]
           ,[Leftover])
select wd.[Year],
       wd.WeekNumber,
       sl.ID_Shop,
       isnull(sl.ID_SKU, p.ID_SKU),
       p.RetailPrice,
       p.PurchasePrice,
       sl.Quantity
from @WeekDates wd
  outer apply dbo.udf_SKUsStockLeftoverOnDate(wd.BeginDate) sl
  full join @Prices p on p.[Year] = wd.[Year]
                     and p.[Week] = wd.WeekNumber
                     and p.ID_SKU = sl.ID_SKU

--insert into Reports._Sales
