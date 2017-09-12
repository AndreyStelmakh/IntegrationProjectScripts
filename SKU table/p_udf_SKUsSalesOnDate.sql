
-- продажи по таблице Movement
alter function dbo.udf_SKUsSalesOnDate
( @date datetime2(4) )
returns @result table( ID_Shop uniqueidentifier,
                  ID_SKU uniqueidentifier,
                  Quantity int )
as
begin

  declare @Quantity integer;

  set @date = isnull(@date, GetDate());

  insert into @result
  select ID_Shop = ID_Shop,
         ID_SKU = ID_SKU,
         Quantity = sum(Kol)
  from dbo.Movement
  where [Date] <= @date
    and Doc_Str in( '–еализаци€“оваров”слуг (расход)',
                    '–асходныйќрдерЌа“овары (расход)',
                    'ќтчетќ–озничныхѕродажах (расход)' )
  group by ID_Shop, ID_SKU;

  return;

end;