

create or alter function dbo.udf_StockLeftoversOnDate
( @date datetime2 = null,
  @ID_Shop uniqueidentifier = null )
returns @t table ( ID_Shop uniqueidentifier,
                   ID_SKU uniqueidentifier,
                   Quantity integer )
as

begin

  set @date = isnull(@date, GetDate());

  insert into @t
  select ID_Shop = ID_Shop,
         ID_SKU = ID_SKU,
         Quantity = sum(Kol)
  from dbo.Movement
  where [Date] < @date
    and ( @ID_Shop is null or @ID_Shop = ID_Shop )
  group by ID_Shop, ID_SKU;

  return

end;