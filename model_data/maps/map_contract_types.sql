--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- create map_contract_types
-- Table to store the different types of contract types
---------------------------------

CREATE TABLE "dev_telco_analytics".map_contract_types
AS
SELECT  DISTINCT contract                                               :: VARCHAR(200)    AS contract,
        CASE
            WHEN contract = 'One year'       THEN 'one_year'
            WHEN contract = 'Month-to-month' THEN 'month_to_month'
            WHEN contract = 'Two year'       THEN 'two_year'
            ELSE 'unknown'
        END                                                             :: VARCHAR(200)    AS contract_type_nk
  FROM  "dev_telco_customer_rdl".telco_customer_churn_raw;

-- SELECT  *
--     FROM  "dev_telco_analytics".map_contract_types;
