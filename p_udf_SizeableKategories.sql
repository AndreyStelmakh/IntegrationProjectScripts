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
create or ALTER   FUNCTION [dbo].[udf_SizeableKategories]
( )
RETURNS table
AS
  return 
      select 'Tops' as [Name]
--union select 'Аксессуары для волос'
union select 'Балетки'
--union select 'Бижутерия'
union select 'Блузка/Сорочка/Рубашка'
union select 'Босоножки'
union select 'Ботинки'
union select 'Брючные изделия'
union select 'Верхняя одежда'
union select 'Головные уборы'
union select 'Домашняя одежда'
union select 'Женская обувь'
union select 'Женская одежда'
--union select 'Зонты'
--union select 'КАНЦЕЛЯРИЯ'
union select 'Кеды'
--union select 'Косметика'
--union select 'Кошельки'
union select 'Кроссовки'
union select 'Купальники'
union select 'Мокасины'
union select 'Нижнее бельё'
union select 'Носочные изделия'
union select 'Обувная косметика'
--union select 'Очки'
union select 'Перчатки'
union select 'Платье/Комбинезон/Костюм'
union select 'Прочее'
--union select 'Ремни'
union select 'Сабо'
union select 'Сандали'
union select 'Сапоги'
union select 'Сланцы/Тапочки'
union select 'Сумки'
union select 'Толстовка/Свитер'
union select 'Туфли'
union select 'Футболка'
union select 'Чулочные изделия'
--union select 'Шарфы'
union select 'Юбка';
GO

