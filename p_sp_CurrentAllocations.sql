-- ================================================
-- Template generated from Template Explorer using:
-- Create Multi-Statement Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Андрей Стельмах
-- Create date: 25 августа 2017
-- Description:	во временной таблице возвращает текущие распределения по магазинам
-- =============================================
CREATE or alter procedure dbo.sp_CurrentAllocations

AS
BEGIN

  if object_id('tempdb..#CurrentAllocations') is not null
    drop table #CurrentAllocations

  create table #CurrentAllocations
  (
    ID_Shop uniqueidentifier,
    ID_Articul uniqueidentifier,
    Color nvarchar(100),
    Allocation xml
  )


  create table #leftovers ( ID_Shop uniqueidentifier, ID_Articul uniqueidentifier,
                             A_Color nvarchar(100), A_Size nvarchar(50),
                             Quantity integer );

  insert into #leftovers
	select s.ID_Shop, u.ID_Articul, u.A_Color, u.A_Size, s.Quantity
  from dbo.udf_StockLeftoversOnDate(GetDate()) s
    inner join SKU u on u.ID_SKU = s.ID_SKU;

  create index ix_leftovers on #leftovers ( ID_Shop, ID_Articul, A_Color );

  declare @ID_Shop uniqueidentifier, @ID_Articul uniqueidentifier, @Color nvarchar(100);
  declare @xml xml;

  declare c cursor local fast_forward for
    select distinct ID_Shop, ID_Articul, A_Color from #leftovers;

  open c;

  fetch next from c into @ID_Shop, @ID_Articul, @Color;

  while @@FETCH_STATUS = 0
  begin

    declare @x xml;

    set @x =    
      ( select A_Size as "@size", Quantity as "@quantity"
        from #leftovers
        where ID_Shop = @ID_Shop and ID_Articul = @ID_Articul and A_Color = @Color and Quantity > 0
        order by A_Size
        for xml path ('item'), root('items') )

    if @x is not null
    begin

      insert into #CurrentAllocations
      values (@ID_Shop, @ID_Articul, @Color, @x)

    end;

    fetch next from c into @ID_Shop, @ID_Articul, @Color;

  end;

  drop table #leftovers

	RETURN 
END
GO