/****** Скрипт для команды SelectTopNRows из среды SSMS  ******/
use Reports

SELECT TOP (50) [CheckedAt]
      ,[Data]
  FROM [Reports].[Monitor].[Journal]
order by CheckedAt desc