-- BUILDING GOLD LAYER (VERTUAL - USING VIEWS)

USE DataWarehouse;

SELECT * FROM silver.crm_cst_info;
SELECT * FROM silver.crm_prd_info;
SELECT * FROM silver.crm_sales_details;
SELECT * FROM silver.erp_CUST_AZ12;
SELECT * FROM silver.erp_LOC_A101;
SELECT * FROM silver.erp_PX_CAT_G1V2;


-- after exploring all the tables found that we can join 3 tables in to one (cst_info, cust_az12, loca101) as gold_dim_customers since these table
-- share information about customers

SELECT
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_gndr,
	ct.GEN,
	ci.cst_marital_status AS marital_status,
	ct.BDATE AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cst_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ct
ON ci.cst_key = ct.CID
LEFT JOIN silver.erp_LOC_A101 AS cl
ON ci.cst_key = cl.CID;

-- we have two coulums for 'gender' in the above query we can keep only one lets explore both column.


CREATE VIEW gold.dim_customers AS 

SELECT
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	CASE
		WHEN ci.cst_gndr = 'n/a' THEN COALESCE (ct.GEN, 'n/a')
		ELSE ci.cst_gndr
	END AS gender,
	ci.cst_marital_status AS marital_status,
	ct.BDATE AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cst_info AS ci
LEFT JOIN silver.erp_CUST_AZ12 AS ct
ON ci.cst_key = ct.CID
LEFT JOIN silver.erp_LOC_A101 AS cl
ON ci.cst_key = cl.CID;

SELECT * FROM gold.dim_customers;

-- lets build second object for products by joining 'silver.crm_prd_info' & silver.erp_PX_CAT_G1V2. 

SELECT * FROM silver.crm_prd_info;
SELECT * FROM silver.erp_PX_CAT_G1V2;

CREATE VIEW gold.dim_products AS 

SELECT
	ROW_NUMBER() OVER(ORDER BY p_i.prd_start_dt, p_i.product_key) AS product_key,
	p_i.prd_id AS product_id,
	p_i.product_key AS product_number,
	p_i.prd_nm AS product_name,
	p_i.prd_cost AS cost,
	p_i.prd_line AS product_line,
	p_i.category_id AS category_id,
	pc.CAT AS category,
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE AS maintenence_required,
	p_i.prd_start_dt AS start_date
FROM silver.crm_prd_info AS p_i
LEFT JOIN silver.erp_PX_CAT_G1V2 AS pc
ON p_i.category_id = pc.ID
WHERE p_i.prd_end_dt IS NULL -- filtering outdated products

SELECT * FROM gold.dim_products;

-- lets have a look at the one and only fact table in our data model i.e sales_details


SELECT * FROM silver.crm_sales_details;

-- evrything looks fine. We just have to join customers and products table to pull key columns (created by using row_number fucntion) whihc will act as a foreign key here in the sales table.

CREATE VIEW gold.fact_sales AS 
SELECT 
	s.sls_ord_num AS order_number,
	p.product_key,
	c.customer_key,
	s.sls_order_dt AS order_date,
	s.sls_ship_dt AS shipping_date,
	s.sls_due_dt AS due_date,
	s.sls_price AS price,
	s.sls_quantity AS quantity,
	s.sls_sales AS sales
FROM silver.crm_sales_details AS s
LEFT JOIN gold.dim_customers AS c
ON s.sls_cust_id = c.customer_id
LEFT JOIN gold.dim_products AS p
ON s.sls_prd_key = p.product_number

SELECT * FROM gold.fact_sales
