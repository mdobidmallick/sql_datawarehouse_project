Before loading data from bronze to silver I performed follwing checks:

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
FROM bronze.crm_cst_info; -- ooops there are nulls and short from used lets handle this using CASE
