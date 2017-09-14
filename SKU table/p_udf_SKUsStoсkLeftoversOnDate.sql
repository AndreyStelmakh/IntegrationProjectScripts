

alter function dbo.udf_SKUsStockLeftoverOnDate
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
    -- чек  ћ не нужно учитывать, т.к. этот тип учтЄн в типе ќтчетќ–озничныхѕродажах
    and Doc_Str <> '„ек  ћ (расход)'
  group by ID_Shop, ID_SKU;

  return;

end;