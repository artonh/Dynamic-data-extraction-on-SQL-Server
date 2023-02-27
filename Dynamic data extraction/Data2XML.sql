-- =============================================
-- Author:		Arton Hoti
-- Create date: 06.10.2022
-- Description:	As an utility to get data as XML for our testing purposes
-- =============================================
CREATE PROCEDURE [dbo].[Data2XML]
    @tableToFetch varchar(200),   
    @tableCondition varchar(MAX)='',
	@IsFORXML bit = 1,
	@IsRequriedCredentialColumns bit = 0
AS   

    SET NOCOUNT ON;  
   
	DECLARE @ColumnsToSelect varchar(MAX), @SQL varchar(MAX);
	SET @ColumnsToSelect = (SELECT ISNULL(c.[name]  + ', ','') from sys.columns c 
		INNER JOIN sys.types t on t.user_type_id = c.user_type_id
		WHERE OBJECT_ID= object_id(@tableToFetch)
		AND t.[name] NOT IN ( 'timestamp') --'datetime2', 'varbinary'
		AND c.[name] NOT IN('DateTimeStamp') 
		AND (@IsRequriedCredentialColumns=1 OR c.[name] NOT IN('ADDUSER', 'ADDDateTime', 'LModifyUSER', 'LModifyDateTime') )
		--AND c.[name] NOT LIKE @tableToFetch+'GlobalID'
		FOR XML PATH('') )

	IF RIGHT(RTRIM(@ColumnsToSelect),1) = ','
	BEGIN -- Chop off the end character
		SET @ColumnsToSelect = LEFT(@ColumnsToSelect, LEN(@ColumnsToSelect) - 1)
	END
	SET @SQL = 'SELECT '+@ColumnsToSelect+ ' FROM '+@tableToFetch;
	IF(@tableCondition IS NOT NULL AND LEN(@tableCondition)>0)
	BEGIN
		SET @SQL += ' WHERE '+@tableCondition;		
	END
	IF(@IsFORXML = 1)
	BEGIN
		SET @SQL += ' FOR XML PATH('''+@tableToFetch+'''), root(''DataLoad'')'
	END
	EXEC (@SQL)
	
	EXEC TBL_IDcolumns @tableToFetch