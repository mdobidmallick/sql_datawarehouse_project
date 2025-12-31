-- Loading data from the source in to datawarehouse. Truncating the tables and after that executing BULK INSERT.

-- cst_info

TRUNCATE TABLE bronze.crm_cst_info

BULK INSERT bronze.crm_cst_info
FROM 'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

-- prd_info

TRUNCATE TABLE bronze.crm_prd_info

BULK INSERT bronze.crm_prd_info
FROM 'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

-- sales_details

TRUNCATE TABLE bronze.crm_sales_details

BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

-- cust_az12

TRUNCATE TABLE bronze.erp_CUST_AZ12

BULK INSERT bronze.erp_CUST_AZ12
FROM 'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

-- loc_a101

TRUNCATE TABLE bronze.erp_LOC_A101

BULK INSERT bronze.erp_LOC_A101
FROM 'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);


-- loc_a101

TRUNCATE TABLE [bronze].[erp_PX_CAT_G1V2]

BULK INSERT [bronze].[erp_PX_CAT_G1V2]
FROM 'C:\Users\mdobi\OneDrive\Pictures\Screenshots\Data Warehouse & ETL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
