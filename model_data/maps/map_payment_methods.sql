--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}


DROP TABLE IF EXISTS "dev_telco_analytics".map_payment_methods;

CREATE TABLE "dev_telco_analytics".map_payment_methods
AS
SELECT  DISTINCT paymentmethod                                :: VARCHAR(200)      AS paymentmethod,
        CASE
            WHEN paymentmethod = 'Mailed check'              THEN 'mailed_check'
            WHEN paymentmethod = 'Electronic check'          THEN 'electronic_check'
            WHEN paymentmethod = 'Credit card (automatic)'   THEN 'credit_card_automatic'
            WHEN paymentmethod = 'Bank transfer (automatic)' THEN 'bank_transfer_automatic'
            ELSE 'unknown'
        END                                                   :: VARCHAR(200)      AS payment_method_nk
  FROM  "dev_telco_customer_rdl".telco_customer_churn_raw;

-- SELECT  *
--     FROM  "dev_telco_analytics".map_payment_methods;

