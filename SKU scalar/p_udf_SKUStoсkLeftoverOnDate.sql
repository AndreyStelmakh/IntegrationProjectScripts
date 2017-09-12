

create function dbo.udf_SKUStockLeftoverOnDate
( @ID_SKU uniqueidentifier,
  @date datetime2(4),
  @ID_Shop uniqueidentifier )
returns integer
as

begin

  declare @Quantity integer;

  set @date = isnull(@date, GetDate());

  select @Quantity = sum(Kol)
  from dbo.Movement
  where [Date] < @date
    and @ID_Shop = ID_Shop
    and ID_SKU = @ID_SKU;

  return @Quantity;

end;