


create or alter procedure dbo.sp_CalcStockDelta

--returns @result table( ID_Shop uniqueidentifier,
--                       ID_Articul uniqueidentifier,
--                       Color nvarchar(100),
--                       Size nvarchar(30),
--                       Quantity int )
as

  declare @DesiredAllocation table( ID_Shop uniqueidentifier,
                                    ID_SKU uniqueidentifier,
                                    ID_Articul uniqueidentifier,
                                    Color nvarchar(100),
                                    Size nvarchar(30),
                                    Quantity int );

  declare @ID_Shop uniqueidentifier,
          @ID_Articul uniqueidentifier,
          @Color nvarchar(100),
          @HoldingCapacity int,
          @Allocation xml;

  declare c cursor local forward_only fast_forward for
    select * from dbo.SizeAllocations;

  open c;
  fetch next from c
  into @ID_Shop,
       @ID_Articul,
       @Color,
       @HoldingCapacity,
       @Allocation;

  -- разверну пожелания из xml в реляционную форму
  while @@fetch_status = 0
  begin

    insert into @DesiredAllocation
    select @ID_Shop,
           null,
           @ID_Articul,
           @Color,
           [Size]      = T.c.value('@size[1]', 'nvarchar(max)'),
           [Quantity]  = T.c.value('@percentage[1]', 'integer') * @HoldingCapacity / 100
    from @Allocation.nodes('//item') T(c)

    fetch next from c
    into @ID_Shop,
         @ID_Articul,
         @Color,
         @HoldingCapacity,
         @Allocation;

  end;

  -- сопоставлю ID_SKU по известным артикулу, цвету и размеру
  update a
  set ID_SKU = u.ID_SKU
  from @DesiredAllocation a
    inner join dbo.SKU u on u.ID_Articul = a.ID_Articul
                        and u.A_Color = a.Color
                        and u.A_Size = a.Size;

  select a.ID_Shop, a.ID_SKU, a.Quantity - isnull(s.Quantity, 0)
  from @DesiredAllocation a
    left join dbo.udf_StockLeftoversOnDate(GetDate()) s on s.ID_Shop = a.ID_Shop
                                                       and s.ID_SKU = a.ID_SKU;
