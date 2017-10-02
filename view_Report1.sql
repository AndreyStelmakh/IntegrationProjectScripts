

alter VIEW [Reports].[view_Report1]
AS
SELECT        r1.*, ar.ImageUrl
FROM            dbo._Report1 r1
  left join dbo.Articuls ar on ar.ID_Articul = r1.ID_Articul
GO
