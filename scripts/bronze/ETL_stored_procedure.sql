-- Created by GitHub Copilot in SSMS.
/*
Creates dbo.usp_Load_Bronze_FromCsv to truncate and bulk-load multiple bronze tables from CSV files.
Procedure is parameterized for file paths and common BULK INSERT options; it validates target tables exist and writes per-table error files.
*/
-- Create stored procedure to truncate (or delete) and bulk-load the bronze tables

CREATE PROCEDURE dbo.usp_Load_Bronze_FromCsv
(
    @cust_info_file NVARCHAR(4000) = N'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv',
    @prd_info_file NVARCHAR(4000)  = N'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv',
    @sales_file NVARCHAR(4000)     = N'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv',
    @cust_az12_file NVARCHAR(4000) = N'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv',
    @loc_a101_file NVARCHAR(4000)  = N'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv',
    @px_cat_file NVARCHAR(4000)    = N'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv',
    @FirstRow INT = 2,
    @FieldTerminator NVARCHAR(10) = N',',
    @RowTerminator NVARCHAR(20) = N'0x0a',
    @Format NVARCHAR(10) = N'CSV',
    @BatchSize INT = 5000,
    @MaxErrors INT = 100,
    @CodePage NVARCHAR(10) = N'65001',
    @ErrorFilePath NVARCHAR(4000) = N'C:\Users\mdobi\AppData\Local\Temp\bulk_insert_errors',
    @UseDeleteIfTruncateFails BIT = 1
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @tbl_schema SYSNAME, @tbl_name SYSNAME, @filepath NVARCHAR(4000);
    DECLARE @target NVARCHAR(256), @sql NVARCHAR(MAX);

    -- map of target tables and their source file paths
    DECLARE @map TABLE (tbl_schema SYSNAME, tbl_name SYSNAME, filepath NVARCHAR(4000));

    INSERT INTO @map(tbl_schema, tbl_name, filepath)
    VALUES
        (N'bronze', N'crm_cst_info', @cust_info_file),
        (N'bronze', N'crm_prd_info', @prd_info_file),
        (N'bronze', N'crm_sales_details', @sales_file),
        (N'bronze', N'erp_CUST_AZ12', @cust_az12_file),
        (N'bronze', N'erp_LOC_A101', @loc_a101_file),
        (N'bronze', N'erp_PX_CAT_G1V2', @px_cat_file);

    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT tbl_schema, tbl_name, filepath FROM @map;

    OPEN cur;
    FETCH NEXT FROM cur INTO @tbl_schema, @tbl_name, @filepath;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @target = QUOTENAME(@tbl_schema) + N'.' + QUOTENAME(@tbl_name);

        -- verify target table exists
        IF OBJECT_ID(@tbl_schema + N'.' + @tbl_name, N'U') IS NULL
        BEGIN
            DECLARE @msg NVARCHAR(4000) = N'Target table ' + @target + N' does not exist in the current database.';
            THROW 51000, @msg, 1;
        END

        -- Try to truncate; if it fails and configured, fallback to DELETE
        BEGIN TRY
            SET @sql = N'TRUNCATE TABLE ' + @target + N';';
            EXEC sp_executesql @sql;
        END TRY
        BEGIN CATCH
            IF @UseDeleteIfTruncateFails = 1
            BEGIN
                SET @sql = N'DELETE FROM ' + @target + N';';
                EXEC sp_executesql @sql;
            END
            ELSE
            BEGIN
                DECLARE @errMsg NVARCHAR(4000) = ERROR_MESSAGE();
                THROW 51001, @errMsg, 1;
            END
        END CATCH;

        -- Build and execute BULK INSERT for the current table
        SET @sql = N'BULK INSERT ' + @target + N' FROM N''' + REPLACE(@filepath, '''', '''''') + N''' WITH ('
                 + N'FIRSTROW = ' + CAST(@FirstRow AS NVARCHAR(10)) + N', '
                 + N'FORMAT = ''' + @Format + N''', '
                 + N'FIELDTERMINATOR = ''' + @FieldTerminator + N''', '
                 + N'ROWTERMINATOR = ''' + @RowTerminator + N''', '
                 + N'TABLOCK, '
                 + N'BATCHSIZE = ' + CAST(@BatchSize AS NVARCHAR(10)) + N', '
                 + N'MAXERRORS = ' + CAST(@MaxErrors AS NVARCHAR(10)) + N', '
                 + N'ERRORFILE = N''' + REPLACE(@ErrorFilePath + N'_' + @tbl_name, '''', '''''') + N''', '
                 + N'CODEPAGE = ''' + @CodePage + N''' );';

        BEGIN TRY
            EXEC sp_executesql @sql;
        END TRY
        BEGIN CATCH
            DECLARE @err NVARCHAR(4000) = ERROR_MESSAGE();
            THROW 51002, @err, 1;
        END CATCH

        FETCH NEXT FROM cur INTO @tbl_schema, @tbl_name, @filepath;
    END

    CLOSE cur;
    DEALLOCATE cur;
END
