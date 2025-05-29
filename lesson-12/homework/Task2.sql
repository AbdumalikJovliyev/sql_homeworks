DROP PROCEDURE IF EXISTS sp_GetAllRoutinesAndParameters
go
CREATE PROCEDURE sp_GetAllRoutinesAndParameters
    @DbName SYSNAME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Temp table to hold all results
    IF OBJECT_ID('tempdb..#RoutineParams') IS NOT NULL DROP TABLE #RoutineParams;

    CREATE TABLE #RoutineParams (
        DatabaseName SYSNAME,
        SchemaName SYSNAME,
        RoutineName SYSNAME,
        RoutineType NVARCHAR(20),
        ParamName SYSNAME,
        DataType NVARCHAR(128),
        MaxLength INT
    );

    DECLARE @name SYSNAME;
    DECLARE @i INT = 1;
    DECLARE @count INT;
    DECLARE @sql NVARCHAR(MAX);

    -- If a specific database is provided
    IF @DbName IS NOT NULL
    BEGIN
        SET @sql = '
        INSERT INTO #RoutineParams
        SELECT 
            ''' + @DbName + ''' AS DatabaseName,
            s.name AS SchemaName,
            o.name AS RoutineName,
            o.type_desc AS RoutineType,
            p.name AS ParamName,
            t.name AS DataType,
            p.max_length AS MaxLength
        FROM [' + @DbName + '].sys.objects o
        LEFT JOIN [' + @DbName + '].sys.parameters p ON o.object_id = p.object_id
        LEFT JOIN [' + @DbName + '].sys.types t ON p.user_type_id = t.user_type_id
        LEFT JOIN [' + @DbName + '].sys.schemas s ON o.schema_id = s.schema_id
        WHERE o.type IN (''P'', ''FN'', ''TF'', ''IF'');
        ';
        EXEC sp_executesql @sql;
    END
    ELSE
    BEGIN
        -- Get user DB count
        SELECT @count = COUNT(*) FROM sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') AND state_desc = 'ONLINE';

        WHILE @i <= @count
        BEGIN
            -- Get the name of the i-th user DB
            SELECT @name = name FROM (
                SELECT name, ROW_NUMBER() OVER (ORDER BY name) AS rn
                FROM sys.databases
                WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb') AND state_desc = 'ONLINE'
            ) dbs WHERE rn = @i;

            -- Dynamic SQL to query each DB
            SET @sql = '
            BEGIN TRY
                INSERT INTO #RoutineParams
                SELECT 
                    ''' + @name + ''' AS DatabaseName,
                    s.name AS SchemaName,
                    o.name AS RoutineName,
                    o.type_desc AS RoutineType,
                    p.name AS ParamName,
                    t.name AS DataType,
                    p.max_length AS MaxLength
                FROM [' + @name + '].sys.objects o
                LEFT JOIN [' + @name + '].sys.parameters p ON o.object_id = p.object_id
                LEFT JOIN [' + @name + '].sys.types t ON p.user_type_id = t.user_type_id
                LEFT JOIN [' + @name + '].sys.schemas s ON o.schema_id = s.schema_id
                WHERE o.type IN (''P'', ''FN'', ''TF'', ''IF'');
            END TRY
            BEGIN CATCH
                PRINT ''Skipping ' + @name + ' due to error'';
            END CATCH
            ';

            -- Execute the dynamic SQL
            EXEC sp_executesql @sql;

            SET @i = @i + 1;
        END
    END

    -- Final result
    SELECT *
    FROM #RoutineParams
    ORDER BY DatabaseName, SchemaName, RoutineName, ParamName;
END;

EXEC sp_GetAllRoutinesAndParameters;
