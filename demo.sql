CREATE TRIGGER [dbo].[SEAM_COM_OT] ON [dbo].[R5ADDETAILS]
AFTER INSERT 
AS
BEGIN
    DECLARE
    @ADD_ENTITY NVARCHAR(30),
    @ADD_CODE NVARCHAR(30),
    @ADD_LINE NVARCHAR(30),
    @ADD_TEXT nvarchar(500), 
    @ADD_USER NVARCHAR(30),
    @EVT_CODE NVARCHAR(6),
	@ADD_SQLIDENTITY NVARCHAR(30),
    @errorstring NVARCHAR(255)

    SELECT 
        @ADD_ENTITY = ADD_ENTITY,
        @ADD_CODE = ADD_CODE,
        --@ADD_LINE = ADD_LINE,
		@ADD_SQLIDENTITY = ADD_SQLIDENTITY,
        -- @ADD_TEXT = cast(ADD_TEXT as nvarchar(500)),  
        @ADD_USER = ADD_USER
    FROM INSERTED 
    
    IF @ADD_CODE IS NOT NULL AND CHARINDEX('#', @ADD_CODE) > 0
    BEGIN
		SELECT @ADD_TEXT = CAST(ADD_TEXT AS nvarchar(500)) FROM R5ADDETAILS  WHERE ADD_SQLIDENTITY = @ADD_SQLIDENTITY

        SET @EVT_CODE = SUBSTRING(@ADD_CODE, 1, 6)
        
         SET @ADD_LINE = COALESCE((SELECT TOP 1 ADD_LINE FROM R5ADDETAILS WHERE ADD_CODE = SUBSTRING(@ADD_CODE, 1, CHARINDEX('#', @ADD_CODE) - 1) ORDER BY ADD_LINE DESC), 10)

        IF EXISTS (SELECT 1 FROM R5EVENTS WHERE EVT_CODE = @EVT_CODE)
        BEGIN
            INSERT INTO R5ADDETAILS (ADD_ENTITY, ADD_RENTITY, ADD_TYPE, ADD_RTYPE, ADD_CODE, ADD_LANG, ADD_LINE, ADD_PRINT, ADD_TEXT, ADD_USER,ADD_CREATED)
            VALUES (@ADD_ENTITY, @ADD_ENTITY, '*', '*', @EVT_CODE, 'ES', @ADD_LINE + 10, '+', '<html>Tarea:' + SUBSTRING(@ADD_CODE, CHARINDEX('#', @ADD_CODE) + 1, 3) + '</html> ' + @ADD_TEXT, @ADD_USER,GETDATE()) 
        END
    END
END