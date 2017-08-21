


EXEC sp_configure 'clr enabled';  
EXEC sp_configure 'clr enabled' , '1';  
RECONFIGURE;  

CREATE FUNCTION SizeFrom1(@value nvarchar(max)) RETURNS nvarchar(max) AS EXTERNAL NAME SQL_CLR.UserDefinedFunctions.SizeFrom1;   
GO  

