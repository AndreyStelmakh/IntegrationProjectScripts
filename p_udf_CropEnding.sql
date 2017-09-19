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
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	Функция предназначена для отсечения окончания артикула:
-- 01AS54453WS_020  ->  01AS54453WS
-- =============================================
alter FUNCTION udf_CropEnding
(
	@Articul nvarchar(60)
)
RETURNS nvarchar(60)
with schemabinding
AS
BEGIN

  if @Articul is null return @Articul;

  declare @len int;
  set @len = len(@Articul);
  if @len <= 4 return @Articul;

  declare @result nvarchar(60);
  set @result = left(@Articul, @len - 4);
  return @result;

END
GO

