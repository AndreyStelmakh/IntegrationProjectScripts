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
-- Author:		������ ��������
-- Create date: 25 ������� 2017
-- Description:	�� ��������� ������� ���������� ���������� ������������� ��������
-- =============================================
CREATE or alter procedure dbo.sp_InitialAllocations

AS
BEGIN

  create table #initial ( ID_Articul uniqueidentifier,
                          A_Color nvarchar(100), A_Size nvarchar(50),
                          Quantity integer );

  insert into #initial
  select ID_Articul,
         A_Color,
         A_Size,
         Quantity = sum(Kol)
  from dbo.Movement m
    inner join dbo.SKU u on u.ID_SKU = m.ID_SKU
  where Doc_Str not in('���������������������� (������)', '������ (������)', '����������������������� (������)')
  group by ID_Articul, A_Color, A_Size;

  create index ix_initial on #initial ( ID_Articul, A_Color );

  declare @ID_Articul uniqueidentifier, @Color nvarchar(100);
  declare @xml xml;

  declare c cursor local fast_forward for
    select distinct ID_Articul, A_Color from #initial;

  open c;

  fetch next from c into @ID_Articul, @Color;

  while @@FETCH_STATUS = 0
  begin

    -- �� �������� numeric(8,4) ��������� ������ ������������ ��� �������������� �� int �
    declare @SumQuantity numeric(12,4);

    select @SumQuantity = sum(Quantity)
    from #initial
    where ID_Articul = @ID_Articul and A_Color = @Color;

    if @SumQuantity > 0
    begin

      declare @x xml;

      -- ������� ����������
      set @x = ( select A_Size as "@size", Quantity / @SumQuantity as "@percentage"
                 from #initial
                 where ID_Articul = @ID_Articul and A_Color = @Color and Quantity > 0
                 order by A_Size
                 for xml path ('item'), root('items') );

      insert into #InitialAllocations
      values (@ID_Articul, @Color, @x);

    end;

    fetch next from c into @ID_Articul, @Color;

  end;

  drop table #initial

	RETURN 
END
GO