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
-- Create date: 18.08.2017
-- Description:	<Description, ,>
-- =============================================
CREATE OR ALTER FUNCTION udf_SizeAllocationDeltas
(
  @ID_Shop uniqueidentifier,
  @ID_SKU uniqueidentifier
)
RETURNS xml 
AS
BEGIN
	
  declare @r xml;

---------

  return @r;

END
GO

