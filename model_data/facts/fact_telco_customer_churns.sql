--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}


---------------------------------
-- Create  "dev_telco_analytics".fact_telco_customer_churns
-- Fact table to store the data for the telco customer churns with sks of the dimensions
---------------------------------
DROP TABLE IF EXISTS "dev_telco_analytics".fact_telco_customer_churns;

CREATE TABLE "dev_telco_analytics".fact_telco_customer_churns
AS
SELECT  customerID                                                                       :: VARCHAR(200)    AS telco_customer_churn_sk,
        customerID                                                                       :: VARCHAR(200)    AS telco_customer_churn_nk,
        CURRENT_TIMESTAMP                                                                :: DATE            AS date_run_nk,
        COALESCE(dg.gender_sk, 'unknown')                                                :: VARCHAR(200)    AS gender_sk,
        payment_method_sk                                                                :: VARCHAR(200)    AS payment_method_sk,
        dis.internet_service_sk                                                          :: VARCHAR(200)    AS internet_service_sk,
        contract_type_sk                                                                 :: VARCHAR(200)    AS contract_type_sk,
        CASE WHEN LOWER(phoneservice) = 'yes' THEN 1 ELSE 0 END                          :: INTEGER         AS has_phone_services,
        CASE WHEN LOWER(multiplelines) = 'yes' THEN 1
             WHEN LOWER(multiplelines) = 'no phone service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_multiple_lines,
        CASE WHEN LOWER(onlinesecurity) = 'yes' THEN 1
             WHEN LOWER(onlinesecurity) = 'no internet service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_online_security,
        CASE WHEN LOWER(onlinebackup) = 'yes' THEN 1
             WHEN LOWER(onlinebackup) = 'no internet service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_online_backup,
        CASE WHEN LOWER(deviceprotection) = 'yes' THEN 1
             WHEN LOWER(deviceprotection) = 'no internet service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_device_protection,
        CASE WHEN LOWER(techsupport) = 'yes' THEN 1
             WHEN LOWER(techsupport) = 'no internet service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_tech_support,
        CASE WHEN LOWER(streamingtv) = 'yes' THEN 1
             WHEN LOWER(streamingtv) = 'no internet service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_streaming_tv,
        CASE WHEN LOWER(streamingmovies) = 'yes' THEN 1
             WHEN LOWER(streamingmovies) = 'no internet service' THEN 0
             ELSE 0
        END                                                                              :: INTEGER         AS has_streaming_movies,
        CASE WHEN LOWER(paperlessbilling) = 'yes' THEN 1 ELSE 0 END                      :: INTEGER         AS has_paper_less_billing,
        COALESCE(SeniorCitizen :: INTEGER, 0)                                            :: INTEGER         AS is_senior_citizen,
        CASE WHEN LOWER(partner) = 'yes' THEN 1 ELSE 0 END                               :: INTEGER         AS has_partner,
        CASE WHEN LOWER(dependents) = 'yes' THEN 1 ELSE 0 END                            :: INTEGER         AS has_dependents,
        tenure :: INTEGER                                                                :: INTEGER         AS contract_tenure,
        MonthlyCharges                                                                   :: DECIMAL(10,2)   AS monthly_charges,
        NULLIF(TotalCharges, ' ')                                                        :: DECIMAL(10,2)   AS actual_total_charges,
        (tenure :: INTEGER) * (MonthlyCharges :: DECIMAL(10,2))                          :: DECIMAL(10,2)   AS expected_total_charges,
        CASE WHEN LOWER(churn) = 'yes' THEN 1 ELSE 0 END                                 :: INTEGER         AS is_churned
  FROM  "dev_telco_customer_rdl".telco_customer_churn_raw tc
  LEFT  JOIN "dev_telco_analytics".map_contract_types mct
        ON tc.contract = mct.contract
  LEFT  JOIN "dev_telco_analytics".map_internet_services mis
        ON tc.internetservice = mis.internetservice
  LEFT  JOIN "dev_telco_analytics".map_payment_methods mpm
        ON tc.paymentmethod = mpm.paymentmethod
  LEFT  JOIN "dev_telco_analytics".dim_genders dg
        ON LOWER(tc.gender) = dg.gender_nk
  LEFT  JOIN "dev_telco_analytics".dim_internet_services dis
        ON mis.internet_service_nk = dis.internet_service_nk
  LEFT  JOIN "dev_telco_analytics".dim_contract_types
        ON mct.contract_type_nk = dim_contract_types.contract_type_nk
  LEFT  JOIN "dev_telco_analytics".dim_payment_methods
        ON mpm.payment_method_nk = dim_payment_methods.payment_method_nk;


-- SELECT  *
--     FROM  "dev_telco_analytics".fact_telco_customer_churns;

