-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
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
-- Author:		  Андрей Стельмах
-- Create date: 24.08.2017
-- Description:	<Description, ,>
-- =============================================
create or ALTER   FUNCTION [dbo].[udf_Normalize]
( @s1 xml,
  @v decimal(18, 4) )
RETURNS float
AS
begin

  --declare @i1 table ( i nvarchar(30), v float );
  --declare @i2 table ( i nvarchar(30), v float );

  --insert into @i1
  --select T.c.value('@i[1]', 'nvarchar(100)'),
  --       T.c.value('@v[1]', 'float')
  --from @s1.nodes('//item') T(c)

  --insert into @i2
  --select T.c.value('@i[1]', 'nvarchar(100)'),
  --       T.c.value('@v[1]', 'float')
  --from @s2.nodes('//item') T(c)

  --declare @i1_avg float,
  --        @i2_avg float,
  --        @i1_std float,
  --        @i2_std float,
  --        @n int;

  --select @i1_avg = avg(v), @i1_std = stdev(v) from @i1;
  --select @i2_avg = avg(v), @i2_std = stdev(v) from @i2;

  --select @n = count(1) from @i1 i1 full join @i2 i2 on i1.i = i2.i;

  ----select  @i1_avg,
  ----        @i2_avg,
  ----        @i1_std,
  ----        @i2_std;

  --declare @corr float;

  --select @corr = (sum((isnull(i1.v, 0) - @i1_avg) * (isnull(i2.v, 0) - @i2_avg)) / (@n - 1))
  --                / (@i1_std * @i2_std )
  --from @i1 i1
  --  full join @i2 i2 on i1.i = i2.i;

  --return @corr;
  return 0;

end;
GO

