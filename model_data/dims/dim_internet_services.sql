--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- create dim_internet_services
-- Table to store the different types of internet services
---------------------------------

CREATE TABLE "dev_telco_analytics".dim_internet_services
AS
SELECT  'dsl'                  :: VARCHAR(200)  AS internet_service_sk,
        'dsl'                  :: VARCHAR(200)  AS internet_service_nk,
        'DSL'                  :: VARCHAR(200)  AS internet_service
UNION ALL
SELECT  'fiber_optic'          :: VARCHAR(200)  AS internet_service_sk,
        'fiber_optic'          :: VARCHAR(200)  AS internet_service_nk,
        'Fiber Optic'          :: VARCHAR(200)  AS internet_service
UNION ALL
SELECT  'unknown'              :: VARCHAR(200)  AS internet_service_sk,
        'unknown'              :: VARCHAR(200)  AS internet_service_nk,
        'Unknown'              :: VARCHAR(200)  AS internet_service;

-- SELECT  *
--   FROM  "dev_telco_analytics".dim_internet_services;

