--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- create dim_contract_types
-- Table to store the contract types of the customers
---------------------------------
DROP TABLE IF EXISTS "dev_telco_analytics".dim_contract_types;

CREATE TABLE "dev_telco_analytics".dim_contract_types
AS
SELECT  'one_year'                :: VARCHAR(200)     AS contract_type_sk,
        'one_year'                :: VARCHAR(200)     AS contract_type_nk,
        'One Year'                :: VARCHAR(200)     AS contract_type
UNION ALL
SELECT  'month_to_month'          :: VARCHAR(200)     AS contract_type_sk,
        'month_to_month'          :: VARCHAR(200)     AS contract_type_nk,
        'Month-to-Month'          :: VARCHAR(200)     AS contract_type
UNION ALL

SELECT  'two_year'                :: VARCHAR(200)     AS contract_type_sk,
        'two_year'                :: VARCHAR(200)     AS contract_type_nk,
        'Two Year'                :: VARCHAR(200)     AS contract_type
UNION ALL
SELECT  'unknown'                 :: VARCHAR(200)     AS contract_type_sk,
        'unknown'                 :: VARCHAR(200)     AS contract_type_nk,
        'Unknown'                 :: VARCHAR(200)     AS contract_type;

-- SELECT  *
--     FROM  "dev_telco_analytics".dim_contract_types;


