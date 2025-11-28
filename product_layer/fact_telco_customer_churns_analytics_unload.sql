--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- Create  "dev_telco_analytics".fact_telco_customer_churns_analytics_unload
-- Description: This table is used to store the data for the telco customer churns for analytics team to use for analysis
---------------------------------

DROP TABLE IF EXISTS "dev_telco_analytics".fact_telco_customer_churns_analytics_unload CASCADE;

CREATE TABLE "dev_telco_analytics".fact_telco_customer_churns_analytics_unload
AS
SELECT  telco_customer_churn_sk,
        telco_customer_churn_nk,
        date_run_nk,
        gender_sk,
        payment_method_sk,
        internet_service_sk,
        contract_type_sk,
        contract_type,
        internet_service,
        payment_method_name,
        has_phone_services,
        has_multiple_lines,
        has_online_security,
        has_online_backup,
        has_device_protection,
        has_tech_support,
        has_streaming_tv,
        has_streaming_movies,
        has_paper_less_billing,
        is_senior_citizen,
        has_partner,
        has_dependents,
        contract_tenure,
        monthly_charges,
        actual_total_charges,
        expected_total_charges,
        is_churned
  FROM  "dev_telco_analytics".fact_telco_customer_churns
  LEFT  JOIN "dev_telco_analytics".dim_contract_types       USING (contract_type_sk)
  LEFT  JOIN "dev_telco_analytics".dim_internet_services    USING (internet_service_sk)
  LEFT  JOIN "dev_telco_analytics".dim_payment_methods      USING (payment_method_sk)
;

