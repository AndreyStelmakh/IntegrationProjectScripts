

alter  function dbo.udf_ArticulsStockLeftoversOnDate
( @date datetime2 = null,
  @ID_Shop uniqueidentifier = null )
returns @t table ( ID_Shop uniqueidentifier,
                   Articul nvarchar(60),
                   A_Color nvarchar(100),
                   Quantity integer )
as

begin

  set @date = isnull(@date, GetDate());

  insert into @t
  select ID_Shop,
         Articul,
         A_Color,
         Quantity = sum(Kol)
  from dbo.Movement m
    inner join dbo.SKU u on u.ID_SKU = m.ID_SKU
  where [Date] <= @date
    and ( @ID_Shop is null or @ID_Shop = ID_Shop )
  group by ID_Shop, Articul, A_Color;

  return

end;