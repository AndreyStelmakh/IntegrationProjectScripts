

create or alter function dbo.udfStockLeftoversOnDate
( @date datetime2 = null )
returns @t table (  ID_Shop uniqueidentifier,
                    ID_SKU uniqueidentifier,
                    Quantity integer )
as

begin

  set @date = isnull(@date, GetDate());

  insert into @t
  select ID_Shop, ID_SKU, sum(Kol)
  from dbo.Movement
  where Date < @date
  group by ID_Shop, ID_SKU;

  return

end;