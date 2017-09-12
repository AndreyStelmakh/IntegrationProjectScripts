

declare @Shops table(ID uniqueidentifier);
insert into @Shops values('2CE04A70-3ACC-11E7-80DE-000C2915D7B8');
insert into @Shops values('CB2B30C2-CB24-11E6-941E-000C29ECCF5C');
insert into @Shops values('24A37A2D-B08C-11E6-94E4-00155D462702');
insert into @Shops values('587093CA-55A8-11E7-BE20-B499BABE0386');
insert into @Shops values('24A37A2E-B08C-11E6-94E4-00155D462702');

declare @ShopsAndStores table(ID uniqueidentifier);
insert into @ShopsAndStores select * from @Shops;
insert into @ShopsAndStores values('8374421C-7199-11E6-B63C-0002C9E8F1B0');
--------------------------------------------------------------------------------

declare @КоличестваПродаж table( [Year] smallint, [WeekNumber] smallint,
                                 --ID_SKU uniqueidentifier,
                                 Articul nvarchar(60), A_Color nvarchar(100),
                                 [Count] decimal(9,2),
                                 index ix clustered(Year, WeekNumber, Articul, A_Color) );
insert into @КоличестваПродаж
select [Year], [WeekNumber], Articul, A_Color, sum(-t.Kol)
from( select m.ID_SKU, m.ID_Shop, m.Kol, [Year] = year(m.Date) , [WeekNumber] = datepart(week, m.Date)
      from dbo.Movement m
      where Doc_Str in ( 'ОтчетОРозничныхПродажах (расход)', 'РеализацияТоваровУслуг (расход)',
                         'ВозвратТоваровОтКлиента (приход)' ) ) t
  inner join dbo.SKU u on u.ID_SKU = t.ID_SKU
group by [Year], [WeekNumber], u.Articul, u.A_Color
------------------------------------------------------------------------------

declare @ShopsWithLeftovers table ( Year smallint, [WeekNumber] smallint,
                                    --ID_SKU uniqueidentifier,
                                    Articul nvarchar(60), A_Color nvarchar(100),
                                    ShopCount decimal(9,2),
                                    index ix clustered (Year, WeekNumber, Articul, A_Color) );
insert into @ShopsWithLeftovers
select [Year], [WeekNumber], Articul, A_Color,
       sum(case when Quantity > 0 then 1 else 0 end)
from dbo.udf_WeekBeginEndDates(GetDate()-365, GetDate())
outer apply dbo.udf_ArticulsStockLeftoversOnDate(EndDate, null) sl
  inner join @Shops sh on sh.ID = ID_Shop
group by [Year], [WeekNumber], Articul, A_Color;
-------------------------------------------------------------------------

declare @ОстаткиНаНачалаНедель
  table( [Year] smallint, WeekNumber smallint,
         --ID_SKU uniqueidentifier,
         Articul nvarchar(60), A_Color nvarchar(100),
         Quantity decimal(9,1),
         index ix clustered ([Year], WeekNumber, Articul, A_Color));
insert into @ОстаткиНаНачалаНедель
select [Year], WeekNumber, Articul, A_Color,
       Quantity = sum(case when Quantity > 0 then Quantity else 0 end)
from dbo.udf_WeekBeginEndDates(GetDate()-365, GetDate())
  outer apply dbo.udf_ArticulsStockLeftoversOnDate(BeginDate, null)
    inner join @Shops sh on sh.ID = ID_Shop
group by [Year], WeekNumber, Articul, A_Color
----------------------------------------------------------------------------

declare @ОстаткиНаОкончанияНедель
  table( [Year] smallint, WeekNumber smallint,
         --ID_SKU uniqueidentifier,
         Articul nvarchar(60), A_Color nvarchar(100),
         Quantity decimal(9,1),
         index ix clustered ([Year], WeekNumber, Articul, A_Color));
insert into @ОстаткиНаОкончанияНедель
select [Year], WeekNumber, Articul, A_Color,
       Quantity = sum(case when Quantity > 0 then Quantity else 0 end)
from dbo.udf_WeekBeginEndDates(GetDate()-365, GetDate())
  outer apply dbo.udf_ArticulsStockLeftoversOnDate(EndDate, null) sl
    inner join @Shops sh on sh.ID = ID_Shop
group by [Year], WeekNumber, Articul, A_Color
----------------------------------------------------------------------------

truncate table dbo._Report1;

insert into dbo._Report1 ([Year], WeekNumber, ReportType, Articul, A_Color, [Value])
select t.Year, t.WeekNumber, 'Обор-мость', Articul, A_Color, sum([Value]) as [Value]
from ( select lf.[Year],
              lf.[WeekNumber],
              lf.Articul,
              lf.A_Color,
              [Value] = case when sl.[Count] > 0 then MeanQ / sl.[Count] else null end
       from( select [Year] = isnull(tin.Year, tout.Year),
                    [WeekNumber] = isnull(tin.WeekNumber, tout.WeekNumber),
                    Articul = isnull(tin.Articul, tout.Articul),
                    A_Color = isnull(tin.A_Color, tout.A_Color),
                    MeanQ = (isnull(tin.Quantity, 0) + isnull(tout.Quantity, 0))/2
             from @ОстаткиНаНачалаНедель tin
               full join @ОстаткиНаОкончанияНедель tout on tout.Year = tin.Year
                                                       and tout.WeekNumber = tin.WeekNumber
                                                       and tout.Articul = tin.Articul
                                                       and tout.A_Color = tin.A_Color ) lf
         left join @КоличестваПродаж sl on sl.[Year] = lf.[Year]
                                       and sl.WeekNumber = lf.WeekNumber
                                       and sl.Articul = lf.Articul
                                       and sl.A_Color = lf.A_Color ) t
group by t.Year, t.WeekNumber, Articul, A_Color

-------------------------------------------------------------------------

delete from @ОстаткиНаНачалаНедель;
delete from @ОстаткиНаОкончанияНедель;
-------------------------------------------------------------------------


insert into dbo._Report1 ([Year], WeekNumber, ReportType, Articul, A_Color, [Value])
select Year, WeekNumber, 'Скор.продаж',
       Articul, A_Color,
       SaleRate = case when SaleRate >= 0.01 then SaleRate else null end
from(
      select pch.Year, pch.WeekNumber, pch.Articul, pch.A_Color,
             SaleRate = cast(case when sl.ShopCount > 0 then pch.[Count] / sl.ShopCount else 0 end as decimal(9,1))

      from @КоличестваПродаж pch
        left join @ShopsWithLeftovers sl on sl.[Year] = pch.Year and sl.WeekNumber = pch.WeekNumber
              and sl.Articul = pch.Articul and sl.A_Color = pch.A_Color ) x
--------------------------------------------------------------------------------------------------------

delete from @КоличестваПродаж;
delete from @ShopsWithLeftovers;
-----------------------------------------------------------------------------------------------------------

insert into dbo._Report1 ([Year], WeekNumber, ReportType, Articul, A_Color, [Value])
select [Year], [WeekNumber], 'Розн.цена', Articul, A_Color, f.Price
from dbo.udf_WeekBeginEndDates(GetDate()-365, GetDate())
  outer apply dbo.udf_ArticulsRetailPricesOnDate(BeginDate) f;





