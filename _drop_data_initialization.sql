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

if Object_id('dbo.Locations') is not null
  drop table dbo.Locations;

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
    [Date] [datetime2](4) NULL,
    [Date_Day] [date] NULL,
    [Doc_Number] [nvarchar](20) NULL,
    [Doc_Str] [nvarchar](60) NULL,
    [ID_Shop] uniqueidentifier NULL,
    [ID_SKU] uniqueidentifier NULL,
    [Kol] [int] NULL,
    [ID_Shop_2] uniqueidentifier NULL
  ) ON [PRIMARY]




end;
GO


CREATE TABLE [dbo].[PriceList](
	[ID_SKU] uniqueidentifier NULL,
	[ID_Price] uniqueidentifier NULL,
	[Date] [datetime2](4) NULL,
	[Price] [numeric](18,4) NULL,
	[Date_Day] [date] NULL
) ON [PRIMARY]
GO




CREATE TABLE [dbo].[Prices](
	[ID_Price] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](30) NULL,
 CONSTRAINT [PK_Prices] PRIMARY KEY CLUSTERED 
(
	[ID_Price] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO





CREATE TABLE [dbo].[Sales](
	[Date] [datetime2](4) NULL,
	[ID_Shop] uniqueidentifier NULL,
	[ID_SKU] uniqueidentifier NULL,
	[Sum] [numeric](18, 4) NULL,
	[Kol] [int] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sales_Receipt](
	[ID_Rec] uniqueidentifier NULL,
	[Date] [datetime2](4) NULL,
	[Rec_Number] [nvarchar](20) NULL,
	[ID_Shop] uniqueidentifier NULL,
	[Nonce] [int] NULL,
	[ID_SKU] uniqueidentifier NULL,
	[Kol] [int] NULL,
	[Sum] numeric(18, 4) NULL,
	[Sum_Zakup] numeric(18, 4) NULL,
	[Date_Day] [date] NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Shops](
	[ID_Shop] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](60) NULL,
 CONSTRAINT [PK_Shops] PRIMARY KEY CLUSTERED 
(
	[ID_Shop] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SKU](
	[ID_SKU] uniqueidentifier NOT NULL,
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
	[Prop_PervData] datetime2(4) NULL,
	[Prop_Proizvoditel] [nvarchar](80) NULL,
	[Barcode] [nvarchar](13) NULL,

) ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [PK_SKU] ON [dbo].[SKU]
(
	[ID_SKU] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Stoks](
	[ID_Shop] uniqueidentifier NULL,
	[ID_SKU] uniqueidentifier NULL,
	[Kol] [int] NULL,
	[Date] [datetime2](4) NULL
) ON [PRIMARY]
GO

-- ������� ��� ��� ���������� "������" (��� �����) -- ������� ���������,
-- �� ������� ����� ������ ����� ������ (���� �� ����, ��� ����� ������������ ������: ������� ��� SKU)
CREATE TABLE [dbo].[Locations](
	[LocationID] [uniqueidentifier] NOT NULL,
	[ID_Shop] [uniqueidentifier] NOT NULL,
	[Properties] [xml] NULL,  -- �������������-��������� ����� � ���������,
                            -- ���������� ������� � ������
  [Priority] int NULL       -- ��������� ���������� ������� � �������� ��������
 CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Locations] ADD  CONSTRAINT [DF_Locations_LocationID]  DEFAULT (newid()) FOR [LocationID]
GO


ALTER TABLE [dbo].[Movement]  WITH CHECK ADD  CONSTRAINT [FK_Movement_Shops] FOREIGN KEY([ID_Shop])
REFERENCES [dbo].[Shops] ([ID_Shop])
ALTER TABLE [dbo].[Movement] CHECK CONSTRAINT [FK_Movement_Shops]

ALTER TABLE [dbo].[Movement]  WITH CHECK ADD  CONSTRAINT [FK_Movement_Shops2] FOREIGN KEY([ID_Shop_2])
REFERENCES [dbo].[Shops] ([ID_Shop])
ALTER TABLE [dbo].[Movement] CHECK CONSTRAINT [FK_Movement_Shops2]

ALTER TABLE [dbo].[Movement]  WITH CHECK ADD  CONSTRAINT [FK_Movement_SKU] FOREIGN KEY([ID_SKU])
REFERENCES [dbo].[SKU] ([ID_SKU])
ALTER TABLE [dbo].[Movement] CHECK CONSTRAINT [FK_Movement_SKU]

ALTER TABLE [dbo].[Stoks]  WITH CHECK ADD  CONSTRAINT [FK_Stoks_Shops] FOREIGN KEY([ID_Shop])
REFERENCES [dbo].[Shops] ([ID_Shop])
ALTER TABLE [dbo].[Stoks] CHECK CONSTRAINT [FK_Stoks_Shops]

ALTER TABLE [dbo].[Stoks]  WITH CHECK ADD  CONSTRAINT [FK_Stoks_SKU] FOREIGN KEY([ID_SKU])
REFERENCES [dbo].[SKU] ([ID_SKU])
ALTER TABLE [dbo].[Stoks] CHECK CONSTRAINT [FK_Stoks_SKU]

ALTER TABLE [dbo].[Sales_Receipt]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Receipt_Shops] FOREIGN KEY([ID_Shop])
REFERENCES [dbo].[Shops] ([ID_Shop])
ALTER TABLE [dbo].[Sales_Receipt] CHECK CONSTRAINT [FK_Sales_Receipt_Shops]

ALTER TABLE [dbo].[Sales_Receipt]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Receipt_SKU] FOREIGN KEY([ID_SKU])
REFERENCES [dbo].[SKU] ([ID_SKU])
ALTER TABLE [dbo].[Sales_Receipt] CHECK CONSTRAINT [FK_Sales_Receipt_SKU]

ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_Shops] FOREIGN KEY([ID_Shop])
REFERENCES [dbo].[Shops] ([ID_Shop])
ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_Shops]

ALTER TABLE [dbo].[Sales]  WITH CHECK ADD  CONSTRAINT [FK_Sales_SKU] FOREIGN KEY([ID_SKU])
REFERENCES [dbo].[SKU] ([ID_SKU])
ALTER TABLE [dbo].[Sales] CHECK CONSTRAINT [FK_Sales_SKU]

ALTER TABLE [dbo].[PriceList]  WITH CHECK ADD  CONSTRAINT [FK_PriceList_Prices] FOREIGN KEY([ID_Price])
REFERENCES [dbo].[Prices] ([ID_Price])
ALTER TABLE [dbo].[PriceList] CHECK CONSTRAINT [FK_PriceList_Prices]

ALTER TABLE [dbo].[PriceList]  WITH CHECK ADD  CONSTRAINT [FK_PriceList_SKU] FOREIGN KEY([ID_SKU])
REFERENCES [dbo].[SKU] ([ID_SKU])
ALTER TABLE [dbo].[PriceList] CHECK CONSTRAINT [FK_PriceList_SKU]

Go