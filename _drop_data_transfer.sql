
use Reports

truncate table Dates          --    0.008
truncate table Movement       --  127.070
truncate table PriceList      --   17.289
truncate table Prices         --    0.008
truncate table Sales          --    1.195
truncate table Sales_Receipt  --   25.953
truncate table Shops          --    0.008
truncate table SKU            --  144.653
truncate table Stoks          --   69.609
------------------------------------------------
                              --  385.793


insert into Dates select * from [192.168.138.129].Reports.dbo.Dates
insert into Movement select * from [192.168.138.129].Reports.dbo.Movement
insert into PriceList select * from [192.168.138.129].Reports.dbo.PriceList
insert into Prices select * from [192.168.138.129].Reports.dbo.Prices
insert into Sales select * from [192.168.138.129].Reports.dbo.sales
insert into Sales_Receipt select * from [192.168.138.129].Reports.dbo.sales_receipt
insert into Shops select * from [192.168.138.129].Reports.dbo.shops
insert into SKU select * from [192.168.138.129].Reports.dbo.sku
insert into Stoks select * from [192.168.138.129].Reports.dbo.stoks

