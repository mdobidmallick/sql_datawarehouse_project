-- Before loading data from bronze to silver I performed follwing checks:

-- NULLS, Duplicates, trailing/leading spaces, data types, normalisation 

SELECT
    cst_id,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT cst_id) AS unique_rows,
    COUNT(*) - COUNT(DISTINCT cst_id) AS dup_rowa
FROM bronze.crm_cst_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL --- oh no! there are nulls & duplicates in primary key


-- data standardisation & consistency 
-- did you ntice 'cst_marital_status' and 'cst_gndr' field? What are the distinct values they stores?

SELECT 
    DISTINCT cst_marital_status
FROM bronze.crm_cst_info;

SELECT 
    DISTINCT cst_gndr
FROM bronze.crm_cst_info; 

-- ooops there are nulls and short from used lets handle this using CASE


SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname) AS cst_firstname,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_marital_status,

     CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM

(SELECT 
    *,
    ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS cs_rank
FROM bronze.crm_cst_info) t
WHERE cs_rank = 1 AND cst_id IS NOT NUll;

-- everything looks good now lets got and insert the data in to silver.crm_cst_info

