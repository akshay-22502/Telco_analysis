--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}


---------------------------------
-- Create  "dev_telco_analytics".fact_telco_customer_churns_ml_unload
-- Description: This table is used to store the data for the telco customer churns for ML team to use for training and testing the model
---------------------------------


DROP TABLE IF EXISTS "dev_telco_analytics".fact_telco_customer_churns_ml_unload CASCADE;

CREATE TABLE "dev_telco_analytics".fact_telco_customer_churns_ml_unload
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
        gender,
        CASE WHEN gender_sk = 'male' THEN 1 ELSE 0 END                                           AS is_male,
        CASE WHEN gender_sk = 'female' THEN 1 ELSE 0 END                                         AS is_female,
        CASE WHEN payment_method_sk = 'mailed_check' THEN 1 ELSE 0 END                           AS is_mailed_check_payment_method,
        CASE WHEN payment_method_sk = 'electronic_check' THEN 1 ELSE 0 END                       AS is_electronic_check_payment_method,
        CASE WHEN payment_method_sk = 'credit_card_automatic' THEN 1 ELSE 0 END                  AS is_credit_card_automatic_payment_method,
        CASE WHEN payment_method_sk = 'bank_transfer_automatic' THEN 1 ELSE 0 END                AS is_bank_transfer_automatic_payment_method,
        CASE WHEN internet_service_sk = 'dsl' THEN 1 ELSE 0 END                                  AS is_dsl_internet_service,
        CASE WHEN internet_service_sk = 'fiber_optic' THEN 1 ELSE 0 END                          AS is_fiber_optic_internet_service,
        CASE WHEN contract_type_sk = 'one_year' THEN 1 ELSE 0 END                                AS is_one_year_contract,
        CASE WHEN contract_type_sk = 'month_to_month' THEN 1 ELSE 0 END                          AS is_month_to_month_contract,
        CASE WHEN contract_type_sk = 'two_year' THEN 1 ELSE 0 END                                AS is_two_year_contract,
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
  LEFT  JOIN "dev_telco_analytics".dim_contract_types        USING (contract_type_sk)
  LEFT  JOIN "dev_telco_analytics".dim_internet_services     USING (internet_service_sk)
  LEFT  JOIN "dev_telco_analytics".dim_payment_methods       USING (payment_method_sk)
  LEFT  JOIN "dev_telco_analytics".dim_genders               USING (gender_sk)
;

