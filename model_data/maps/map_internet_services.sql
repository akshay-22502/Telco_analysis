--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- create map_internet_services
-- Table to store the different types of internet services to map with dimension table
---------------------------------

DROP TABLE IF EXISTS "dev_telco_analytics".map_internet_services;

CREATE TABLE "dev_telco_analytics".map_internet_services
AS
SELECT  DISTINCT internetservice                                :: VARCHAR(200)     AS internetservice,
        CASE
            WHEN internetservice = 'DSL'          THEN 'dsl'
            WHEN internetservice = 'Fiber optic'  THEN 'fiber_optic'
            WHEN internetservice = 'No'           THEN 'unknown'
            ELSE 'unknown'
        END                                                      :: VARCHAR(200)    AS internet_service_nk
  FROM  "dev_telco_customer_rdl".telco_customer_churn_raw;

-- SELECT  *
    -- FROM  "dev_telco_analytics".map_internet_services;
