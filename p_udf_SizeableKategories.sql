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
-- Author:		  ������ ��������
-- Create date: 18.08.2017
-- Description:	<Description, ,>
-- =============================================
create or ALTER   FUNCTION [dbo].[udf_SizeableKategories]
( )
RETURNS table
AS
  return 
      select 'Tops' as [Name]
--union select '���������� ��� �����'
union select '�������'
--union select '���������'
union select '������/�������/�������'
union select '���������'
union select '�������'
union select '������� �������'
union select '������� ������'
union select '�������� �����'
union select '�������� ������'
union select '������� �����'
union select '������� ������'
--union select '�����'
--union select '����������'
union select '����'
--union select '���������'
--union select '��������'
union select '���������'
union select '����������'
union select '��������'
union select '������ �����'
union select '�������� �������'
union select '������� ���������'
--union select '����'
union select '��������'
union select '������/����������/������'
union select '������'
--union select '�����'
union select '����'
union select '�������'
union select '������'
union select '������/�������'
union select '�����'
union select '���������/������'
union select '�����'
union select '��������'
union select '�������� �������'
--union select '�����'
union select '����';
GO

