--@variable "dev_telco_analytics" ${SCHEMA_TELCO_ANALYTICS}

---------------------------------
-- create dim_payment_methods
-- Table to store the different types of payment methods
---------------------------------

CREATE TABLE "dev_telco_analytics".dim_payment_methods
AS
SELECT  'mailed_check'                      :: VARCHAR(200)   AS payment_method_sk,
        'mailed_check'                      :: VARCHAR(200)   AS payment_method_nk,
        'Mailed Check'                      :: VARCHAR(200)   AS payment_method_name
UNION ALL
SELECT  'electronic_check'                  :: VARCHAR(200)   AS payment_method_sk,
        'electronic_check'                  :: VARCHAR(200)   AS payment_method_nk,
        'Electronic Check'                  :: VARCHAR(200)   AS payment_method_name
UNION ALL
SELECT  'credit_card_automatic'             :: VARCHAR(200)   AS payment_method_sk,
        'credit_card_automatic'             :: VARCHAR(200)   AS payment_method_nk,
        'Credit Card (Automatic)'           :: VARCHAR(200)   AS payment_method_name
UNION ALL
SELECT  'bank_transfer_automatic'           :: VARCHAR(200)   AS payment_method_sk,
        'bank_transfer_automatic'           :: VARCHAR(200)   AS payment_method_nk,
        'Bank Transfer (Automatic)'         :: VARCHAR(200)   AS payment_method_name
UNION ALL
SELECT  'unknown'                           :: VARCHAR(200)   AS payment_method_sk,
        'unknown'                           :: VARCHAR(200)   AS payment_method_nk,
        'Unknown'                           :: VARCHAR(200)   AS payment_method_name;

-- SELECT  *
--     FROM  "dev_telco_analytics".dim_payment_methods;