-- Create table silver.crm_cst_info with specified columns and types

CREATE TABLE silver.crm_cst_info (
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Create table silver.crm_prd_info to store product information

CREATE TABLE silver.crm_prd_info (
    prd_id INT,
    prd_key VARCHAR(50),
    category_id VARCHAR(50),
    product_key VARCHAR(50),
    prd_nm VARCHAR(100),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()

);


-- Create table silver.crm_sales_details to store sales transaction details

DROP TABLE  silver.crm_sales_details

CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT, 
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales INT, 
    sls_quantity INT,
    sls_price INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);


-- Create table silver.erp_CUST_AZ12

CREATE TABLE silver.erp_CUST_AZ12 (
    CID VARCHAR(20),
    BDATE DATE,
    GEN VARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

GO

-- Create table silver.erp_LOC_A101

CREATE TABLE silver.erp_LOC_A101 (
    CID VARCHAR(20),
    CNTRY VARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

GO

-- Create table silver.erp_PX_CAT_G1V2

CREATE TABLE silver.erp_PX_CAT_G1V2 (
    ID VARCHAR(10),
    CAT VARCHAR(50),
    SUBCAT VARCHAR(50),
    MAINTENANCE VARCHAR(10),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
