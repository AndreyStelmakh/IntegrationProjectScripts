

create view Reports.view_Stoks
as

  select u.Articul, s.*
  from dbo.Stoks s
  left join dbo.SKU u on s.ID_SKU = u.ID_SKU;