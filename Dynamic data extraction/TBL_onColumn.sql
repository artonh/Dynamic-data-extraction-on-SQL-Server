-- =============================================
-- Author:		Arton HOTI
-- Create date: 04.10.2022
-- Description:	TO query tables where the column exists
-- =============================================
CREATE PROCEDURE [dbo].[TBL_onColumn] 
	-- Add the parameters for the stored procedure here
	@likeColumnName nvarchar(MAX),
	@SelectColumn bit = 0,
	@likeTable  nvarchar(MAX) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF(@SelectColumn = 1)
	begin
		SELECT T.NAME as 'tbl_Name', T.TYPE_DESC as 'tbl_Type', 
		(SELECT ISNULL(c.[name]  + ', ','')   
			FROM SYS.COLUMNS C 
			WHERE T.OBJECT_ID=C.OBJECT_ID AND C.NAME LIKE @likeColumnName 
			FOR XML PATH('')
		) as  'column(s)_Name',
		T.create_date, t.modify_date, t.max_column_id_used 
		FROM SYS.TABLES T 
		WHERE T.OBJECT_ID IN (
			SELECT C.OBJECT_ID FROM SYS.COLUMNS C WHERE C.NAME LIKE @likeColumnName
		)
		AND ((@likeTable IS NULL OR @likeTable='')  OR (T.NAME like @likeTable))
	end
	else 
	begin
		SELECT T.NAME as 'tbl_Name', T.TYPE_DESC as 'tbl_Type', 
		T.create_date, t.modify_date, t.max_column_id_used 
		FROM SYS.TABLES T 
		WHERE T.OBJECT_ID IN (
			SELECT C.OBJECT_ID FROM SYS.COLUMNS C WHERE C.NAME LIKE @likeColumnName
		)
		AND ((@likeTable IS NULL OR @likeTable='') OR (T.NAME like @likeTable))
	end

END
