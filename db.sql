USE [Reports]
GO

CREATE TABLE [dbo].[Dates](
	[Date_Day] [date] NOT NULL
) ON [PRIMARY]
Go

CREATE TABLE [dbo].[Movement](
	[ID_Doc] [nchar](60) NULL,
	[Date] [datetime2](7) NULL,
	[Date_Day] [date] NULL,
	[Doc_Number] [nchar](20) NULL,
	[Doc_Str] [nchar](60) NULL,
	[ID_Shop] [nchar](60) NULL,
	[ID_SKU] [nchar](60) NULL,
	[Kol] [int] NULL,
	[ID_Artikul] [nchar](60) NULL,
	[ID_Shop_2] [nchar](60) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[PriceList](
	[ID_SKU] [nchar](60) NULL,
	[ID_Price] [nchar](60) NULL,
	[Date] [datetime2](7) NULL,
	[Price] [float] NULL,
	[Date_Day] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Prices](
	[ID_Price] [nchar](60) NULL,
	[Name] [nchar](30) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sales](
	[Date] [datetime2](7) NULL,
	[ID_Shop] [nchar](60) NULL,
	[ID_SKU] [nchar](60) NULL,
	[Sum] [float] NULL,
	[Kol] [int] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sales_Receipt](
	[ID_Rec] [nchar](60) NULL,
	[Date] [datetime2](7) NULL,
	[Rec_Number] [nchar](20) NULL,
	[ID_Shop] [nchar](60) NULL,
	[Nonce] [int] NULL,
	[ID_SKU] [nchar](60) NULL,
	[Kol] [int] NULL,
	[Sum] [float] NULL,
	[ID_Articul] [nchar](80) NULL,
	[Sum_Zakup] [float] NULL,
	[Date_Day] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Shops](
	[ID_Shop] [nchar](60) NULL,
	[Name] [nchar](60) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[SKU](
	[ID_SKU] [nchar](60) NULL,
	[ID_Articul] [nchar](60) NULL,
	[Name] [nchar](60) NULL,
	[Articul] [nchar](60) NULL,
	[Size] [nchar](30) NULL,
	[Prop_TimeToLive] [char](80) NULL,
	[Prop_Gender] [char](80) NULL,
	[Prop_Year] [char](10) NULL,
	[Prop_Zon] [char](80) NULL,
	[Prop_Kabl] [char](80) NULL,
	[Prop_Maneger] [char](80) NULL,
	[Prop_Kateg] [char](80) NULL,
	[Prop_Kont] [char](80) NULL,
	[Prop_Model] [char](80) NULL,
	[Prop_Otdel] [char](80) NULL,
	[Prop_Podkat] [char](80) NULL,
	[Prop_Podsez] [char](80) NULL,
	[Prop_Proekt] [char](80) NULL,
	[Prop_Razm] [char](80) NULL,
	[Prop_Sez] [char](80) NULL,
	[Prop_Sekt] [char](80) NULL,
	[Prop_Sost] [char](200) NULL,
	[Prop_URL] [char](200) NULL,
	[Prop_Style] [char](80) NULL,
	[Prop_Strana] [char](80) NULL,
	[Prop_Strukt] [char](80) NULL,
	[Prop_Color] [char](80) NULL,
	[Prop_PervData] datetime2(7) NULL,
	[Prop_Proizvoditel] [char](80) NULL,
	[Barcode] [nchar](13) NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Stoks](
	[ID_Shop] [nchar](60) NULL,
	[ID_SKU] [nchar](60) NULL,
	[ID_Articul] [nchar](60) NULL,
	[Kol] [int] NULL,
	[Date] [datetime2](7) NULL
) ON [PRIMARY]
GO

