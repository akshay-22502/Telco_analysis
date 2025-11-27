--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- create dim_genders
-- Table to store the genders of the customers
---------------------------------

DROP TABLE IF EXISTS "dev_telco_analytics".dim_genders;

CREATE TABLE "dev_telco_analytics".dim_genders
AS
SELECT  'male'                     :: VARCHAR(200)      AS gender_sk,
        'male'                     :: VARCHAR(200)      AS gender_nk,
        'Male'                     :: VARCHAR(200)      AS gender
UNION ALL
SELECT  'female'                   :: VARCHAR(200)      AS gender_sk,
        'female'                   :: VARCHAR(200)      AS gender_nk,
        'Female'                   :: VARCHAR(200)      AS gender
UNION  ALL
SELECT  'unknown'                  :: VARCHAR(200)      AS gender_sk,
        'unknown'                  :: VARCHAR(200)      AS gender_nk,
        'Unknown'                  :: VARCHAR(200)      AS gender;

-- SELECT  *
--   FROM  "dev_telco_analytics".dim_genders

