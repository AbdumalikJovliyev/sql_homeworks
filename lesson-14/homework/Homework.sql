--Write a SQL Server query to retrieve metadata about indexes and send it via email in a well-formatted HTML table.

--Requirements:

--Extract metadata related to indexes, including:

--Table Name
--Index Name
--Index Type
--Column Type
--Format the results as an HTML table with proper styling.

--Use Database Mail to send the email containing the formatted index metadata.


-- Declare a variable to hold the HTML content of the email
DECLARE @html_body NVARCHAR(MAX)

-- Initialize the HTML body with basic styles and header
SET @html_body = '
<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <h2>SQL Server Index Metadata Report</h2>
    <p>Generated on: ' + CONVERT(VARCHAR, GETDATE(), 120) + '</p>
    <table>
        <tr>
            <th>Table Name</th>
            <th>Index Name</th>
            <th>Index Type</th>
            <th>Column Name</th>
            <th>Column Type</th>
        </tr>'

-- Dynamically build the HTML table rows by iterating through indexed columns
SELECT @html_body = @html_body + 
    '<tr>' +
    -- Full table name including schema, e.g., [dbo].[Customers]
    '<td>' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + '</td>' +

    -- Index name or [N/A] if null
    '<td>' + ISNULL(i.name, '[N/A]') + '</td>' +

    -- Index type description (e.g., CLUSTERED, NONCLUSTERED)
    '<td>' + i.type_desc + '</td>' +

    -- Column name participating in the index
    '<td>' + c.name + '</td>' +

    -- Column data type with length for string-based types
    '<td>' + TYPE_NAME(c.user_type_id) + 
        CASE 
            -- Append max_length for character types
            WHEN TYPE_NAME(c.user_type_id) IN ('varchar', 'nvarchar', 'char', 'nchar') 
                 THEN ' (' + 
                    CASE 
                        WHEN c.max_length = -1 THEN 'MAX' -- -1 means MAX
                        ELSE CAST(c.max_length AS VARCHAR(10))
                    END + ')'
            ELSE ''
        END + '</td>' +
    '</tr>'
FROM sys.tables t
-- Join to get schema name
JOIN sys.schemas s 
    ON t.schema_id = s.schema_id
-- Join to indexes, excluding heaps (i.type = 0)
JOIN sys.indexes i 
    ON t.object_id = i.object_id AND i.type > 0
-- Join to get indexed columns
JOIN sys.index_columns ic 
    ON i.object_id = ic.object_id 
    AND i.index_id = ic.index_id
-- Join to get column details
JOIN sys.columns c 
    ON ic.object_id = c.object_id 
    AND ic.column_id = c.column_id
-- Order by schema, table, index, and column ordinal position
ORDER BY s.name, t.name, i.name, ic.key_ordinal

-- Close the HTML tags to complete the document
SET @html_body = @html_body + '
    </table>
</body>
</html>'

-- Send the composed email using Database Mail
EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'DefaultMailProfile',                     -- Your configured DB mail profile name
    @recipients = 'lazizbek26052007@example.com',             -- Email recipient(s)
    @subject = 'Index Metadata Report',                       -- Email subject line
    @body = @html_body,                                       -- HTML-formatted body content
    @body_format = 'HTML'                                     -- Set email format to HTML

