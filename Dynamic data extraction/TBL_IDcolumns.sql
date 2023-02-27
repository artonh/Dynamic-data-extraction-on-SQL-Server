-- =============================================
-- Author:		Arton Hoti
-- Create date: 06.10.2022
-- Description:	As an utility to get ID columns
-- =============================================
CREATE PROCEDURE [dbo].[TBL_IDcolumns]
@tableToFetch varchar(200)
AS   
    SET NOCOUNT ON;  
   
	DECLARE @ColumnsToSelect varchar(MAX);
	SET @ColumnsToSelect = (SELECT ISNULL(c.[name]  + ', ','') from sys.columns c 
		INNER JOIN sys.types t on t.user_type_id = c.user_type_id
		WHERE OBJECT_ID= object_id(@tableToFetch)
		AND t.[name] NOT IN ('datetime2', 'timestamp', 'varbinary') 
		AND c.[name] NOT IN ('ID', 'UniqueID', @tableToFetch+'ID', @tableToFetch+'GlobalID')
		AND c.[name] LIKE '%ID'
		FOR XML PATH('') )

	IF RIGHT(RTRIM(@ColumnsToSelect),1) = ','
	BEGIN -- Chop off the end character
		SET @ColumnsToSelect = LEFT(@ColumnsToSelect, LEN(@ColumnsToSelect) - 1)
	END

	SELECT @ColumnsToSelect as ForeignKeys_ID_Columns
