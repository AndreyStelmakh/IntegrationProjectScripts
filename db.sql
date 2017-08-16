USE [Reports]
GO

drop table Dates
drop table Movement
drop table PriceList
drop table Prices
drop table Sales
drop table Sales_Receipt
drop table Shops
drop table SKU
drop table Stoks


if object_id('Dates', 'U') is null
begin

  CREATE TABLE [dbo].[Dates](
    [Date_Day] [date] NOT NULL
  ) ON [PRIMARY]

end;
Go

if object_id('Movement', 'U') is null
begin

    CREATE TABLE [dbo].[Movement](
    [ID_Doc] uniqueidentifier NULL,
    [Date] [datetime2](7) NULL,
    [Date_Day] [date] NULL,
    [Doc_Number] [nvarchar](20) NULL,
    [Doc_Str] [nvarchar](60) NULL,
    [ID_Shop] uniqueidentifier NULL,
    [ID_SKU] uniqueidentifier NULL,
    [Kol] [int] NULL,
    [ID_Artikul] uniqueidentifier NULL,
    [ID_Shop_2] [nvarchar](60) NULL
  ) ON [PRIMARY]

end;
GO

CREATE TABLE [dbo].[PriceList](
	[ID_SKU] uniqueidentifier NULL,
	[ID_Price] uniqueidentifier NULL,
	[Date] [datetime2](7) NULL,
	[Price] [numeric](18,4) NULL,
	[Date_Day] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Prices](
	[ID_Price] uniqueidentifier NULL,
	[Name] [nvarchar](30) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sales](
	[Date] [datetime2](7) NULL,
	[ID_Shop] uniqueidentifier NULL,
	[ID_SKU] uniqueidentifier NULL,
	[Sum] [numeric](18, 4) NULL,
	[Kol] [int] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sales_Receipt](
	[ID_Rec] uniqueidentifier NULL,
	[Date] [datetime2](7) NULL,
	[Rec_Number] [nvarchar](20) NULL,
	[ID_Shop] uniqueidentifier NULL,
	[Nonce] [int] NULL,
	[ID_SKU] uniqueidentifier NULL,
	[Kol] [int] NULL,
	[Sum] numeric(18, 4) NULL,
	[ID_Articul] uniqueidentifier NULL,
	[Sum_Zakup] numeric(18, 4) NULL,
	[Date_Day] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Shops](
	[ID_Shop] uniqueidentifier NULL,
	[Name] [nvarchar](60) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SKU](
	[ID_SKU] uniqueidentifier NULL,
	[ID_Articul] uniqueidentifier NULL,
	[Name] [nvarchar](60) NULL,
	[Articul] [nvarchar](60) NULL,
	[Size] [nvarchar](30) NULL,
	[Prop_TimeToLive] [nvarchar](80) NULL,
	[Prop_Gender] [nvarchar](80) NULL,
	[Prop_Year] [nvarchar](10) NULL,
	[Prop_Zon] [nvarchar](80) NULL,
	[Prop_Kabl] [nvarchar](80) NULL,
	[Prop_Maneger] [nvarchar](80) NULL,
	[Prop_Kateg] [nvarchar](80) NULL,
	[Prop_Kont] [nvarchar](80) NULL,
	[Prop_Model] [nvarchar](80) NULL,
	[Prop_Otdel] [nvarchar](80) NULL,
	[Prop_Podkat] [nvarchar](80) NULL,
	[Prop_Podsez] [nvarchar](80) NULL,
	[Prop_Proekt] [nvarchar](80) NULL,
	[Prop_Razm] [nvarchar](80) NULL,
	[Prop_Sez] [nvarchar](80) NULL,
	[Prop_Sekt] [nvarchar](80) NULL,
	[Prop_Sost] [nvarchar](200) NULL,
	[Prop_URL] [nvarchar](200) NULL,
	[Prop_Style] [nvarchar](80) NULL,
	[Prop_Strana] [nvarchar](80) NULL,
	[Prop_Strukt] [nvarchar](80) NULL,
	[Prop_Color] [nvarchar](80) NULL,
	[Prop_PervData] datetime2(7) NULL,
	[Prop_Proizvoditel] [nvarchar](80) NULL,
	[Barcode] [nvarchar](13) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Stoks](
	[ID_Shop] uniqueidentifier NULL,
	[ID_SKU] uniqueidentifier NULL,
	[ID_Articul] uniqueidentifier NULL,
	[Kol] [int] NULL,
	[Date] [datetime2](7) NULL
) ON [PRIMARY]
GO

