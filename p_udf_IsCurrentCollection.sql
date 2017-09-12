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
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.udf_IsCurrentCollection 
(
	@date datetime2(4)
)
RETURNS nvarchar(10)
AS
BEGIN

  declare @result nvarchar(10);

  if @date > '20170801'
  begin

	  set @result = 'current';

  end
  else
  begin

    set @result = 'old';

  end;

  return @result;

END
GO

