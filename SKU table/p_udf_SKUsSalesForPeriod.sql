

-- выручка за период времени
alter function dbo.udf_SKUsSalesForPeriod
( @BeginDate datetime2(4),
  @EndDate datetime2(4) )
returns @result table( ID_Shop uniqueidentifier,
                       ID_SKU uniqueidentifier,
                       Quantity decimal(18,4),
                       SalesSum decimal(18,4) )
as
begin

  
  --insert into @result
  --select ID_Shop,
  --       ID_SKU,
  --       sum([Sum])
  --from dbo.Sales
  --where (@BeginDate < [Date] or @BeginDate is null)
  --  and ([Date] < @EndDate or @EndDate is null)
  --group by ID_Shop, ID_SKU;
  --declare @Quantity integer;


  insert into @result
  select ID_Shop = ID_Shop,
         ID_SKU = ID_SKU,
         Quantity = sum(Kol),
         [Sum] = sum([Sum])
  from dbo.Movement
  where ( [Date] < @EndDate or @EndDate is null )
    and ( @BeginDate <= [Date] or @BeginDate is null )
    and Doc_Str in( '–еализаци€“оваров”слуг (расход)',
                   -- '–асходныйќрдерЌа“овары (расход)',
                    'ќтчетќ–озничныхѕродажах (расход)' )
  group by ID_Shop, ID_SKU;

  return;

end;

