


create or alter procedure dbo.sp_CalcStockDelta

--returns @result table( ID_Shop uniqueidentifier,
--                       ID_Articul uniqueidentifier,
--                       Color nvarchar(100),
--                       Size nvarchar(30),
--                       Quantity int )
as

--TODO: вынести на вызывающий уровень
  create table #Deltas( ID_Shop uniqueidentifier,
                        ID_SKU uniqueidentifier,
                        Delta int );

  declare @Now datetime2(4) = GetDate();

  create table #InitialAllocations ( ID_Articul uniqueidentifier,
                                     Color nvarchar(100),
                                     Allocation xml );

  -- получаю таблицу #InitialAllocations
  -- мы принимаем, что эти горки (а это закупочные горки) следует считать эталонными
  exec dbo.sp_InitialAllocations;
  ---- получаю таблицу #CurrentAllocations
  --exec dbo.sp_CurrentAllocations;

  create table #Targets( [ID_Shop] uniqueidentifier,
  	                     [ID_Articul] uniqueidentifier,
  	                     [Color] nvarchar(100),
  	                     [Allocation] xml );

  insert into #Targets
  select sh.ID_Shop, ia.ID_Articul, ia.Color, ia.Allocation
  from ( select ID_Shop
         from dbo.Shops
         where ID_Shop in ( 'CB2B30C2-CB24-11E6-941E-000C29ECCF5C',
                            '24A37A2D-B08C-11E6-94E4-00155D462702',
                            '2CE04A70-3ACC-11E7-80DE-000C2915D7B8',
                            '587093CA-55A8-11E7-BE20-B499BABE0386',
                            '24A37A2E-B08C-11E6-94E4-00155D462702') ) sh
    cross join #InitialAllocations ia;



  declare @DesiredQuantities table( ID_Shop uniqueidentifier,
                                    ID_Articul uniqueidentifier,
                                    Color nvarchar(100),
                                    Size nvarchar(30),
                                    Quantity int );

  declare @ID_Shop uniqueidentifier,
          @ID_Articul uniqueidentifier,
          @Color nvarchar(100),
          @Allocation xml;

  declare c cursor local forward_only fast_forward for
    select * from #Targets;

  open c;
  fetch next from c
  into @ID_Shop,
       @ID_Articul,
       @Color,
       @Allocation;

  -- разверну пожелания из xml в реляционную форму
  while @@fetch_status = 0
  begin

    declare @Prop_Kateg nvarchar(80);
    set @Prop_Kateg = (select top(1) Prop_Kateg from dbo.SKU where ID_Articul = @ID_Articul);

    insert into @DesiredQuantities
    select @ID_Shop,
           @ID_Articul,
           @Color,
           [Size]      = T.c.value('@size[1]', 'nvarchar(max)'),
           [Quantity]  = T.c.value('@percentage[1]', 'decimal(18,4)')
                          * (select QuantityLimitation from dbo.QuantityLimitations where Prop_Kateg = @Prop_Kateg)
    from @Allocation.nodes('//item') T(c)

    fetch next from c
    into @ID_Shop,
         @ID_Articul,
         @Color,
         @Allocation;

  end;



-------------------------------------------------------------------------------------------
  ---- сопоставлю ID_SKU по известным артикулу, цвету и размеру
  --update a
  --set ID_SKU = u.ID_SKU
  --from @DesiredQuantities a
  --  inner join dbo.SKU u on u.ID_Articul = a.ID_Articul
  --                      and u.A_Color = a.Color
  --                      and u.A_Size = a.Size;



-------------------------------------------------------------------------------------------
  -- подготовка результата в таблице #Deltas
  -- записи @DesiredQuantities размножаются до количества SKU
  insert into #Deltas
  select a.ID_Shop, u.ID_SKU, a.Quantity - isnull(s.Quantity, 0)
  from @DesiredQuantities a
    inner join dbo.SKU u on u.ID_Articul = a.ID_Articul
    left join dbo.udf_StockLeftoversOnDate(@Now, null) s on s.ID_Shop = a.ID_Shop
                                                   and s.ID_SKU = u.ID_SKU;

  declare @CentralS table ( ID_SKU uniqueidentifier unique clustered,
                            Quantity int );
  insert @CentralS
  select ID_SKU, Quantity from [dbo].[udf_StockLeftoversOnDate] ( GetDate(), '8374421C-7199-11E6-B63C-0002C9E8F1B0' );


  truncate table Reports._Deltas;

  insert into Reports._Deltas
  select d.* from #Deltas d
    inner join @CentralS cs on cs.ID_SKU = d.ID_SKU
  where Delta is not null
    and cs.Quantity > 0;



