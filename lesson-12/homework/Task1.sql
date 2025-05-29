-- Temp table to collect results
IF OBJECT_ID('tempdb..#AllColumns') IS NOT NULL DROP TABLE #AllColumns;

CREATE TABLE #AllColumns (
    DatabaseName SYSNAME,
    SchemaName SYSNAME,
    TableName SYSNAME,
    ColumnName SYSNAME,
    DataType NVARCHAR(100)
);

DECLARE @name SYSNAME;
DECLARE @i INT = 1;
DECLARE @count INT;
DECLARE @sql NVARCHAR(MAX);

SELECT @count = COUNT(1)
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

WHILE @i <= @count
BEGIN
    ;WITH cte AS (
        SELECT name, ROW_NUMBER() OVER(ORDER BY name) AS rn
        FROM sys.databases 
        WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
    )
    SELECT @name = name FROM cte WHERE rn = @i;

    -- Build dynamic SQL
    SET @sql = '
    INSERT INTO #AllColumns
    SELECT 
        ''' + @name + ''' AS DatabaseName,
        TABLE_SCHEMA AS SchemaName,
        TABLE_NAME AS TableName,
        COLUMN_NAME AS ColumnName,
        CONCAT(
            DATA_TYPE, ''('' + 
                CASE 
                    WHEN CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) = ''-1'' THEN ''max''
                    ELSE CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR)
                END + '')''
        ) AS DataType
    FROM [' + @name + '].INFORMATION_SCHEMA.COLUMNS;
    ';

    -- Execute it
    EXEC sp_executesql @sql;

    SET @i = @i + 1;
END

-- Final result
SELECT * FROM #AllColumns
ORDER BY DatabaseName, SchemaName, TableName, ColumnName;
