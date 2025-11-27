import boto3
from botocore.exceptions import ClientError
import pandas as pd
import psycopg2
import psycopg2.extras as extras
from io import StringIO

# --- S3 Configuration Variables ---
BUCKET_NAME = 'hemo-telco-analytics'
OBJECT_KEY = 'raw_data/Telco-Customer-Churn.csv' 
AWS_REGION = 'ap-south-1' 

# --- Database Configuration ---
DB_PARAMS = {
    'user': 'akshay',
    'password': 'RziW_ysPXDJSndeJ7DuX9w',
    'host': 'telco-analytics-18770.j77.aws-eu-central-1.cockroachlabs.cloud',
    'database': 'defaultdb',
    'port': '26257',
    'sslmode': 'require' 
}

# --- Table Configuration ---
RAW_TABLE_NAME = 'dev_telco_customer_rdl.telco_customer_churn_raw'

# --- SQL Table Creation Command (All TEXT/VARCHAR for raw data) ---
CREATE_RAW_TABLE_SQL = f"""
CREATE TABLE IF NOT EXISTS {RAW_TABLE_NAME} (
    customerID VARCHAR(10) PRIMARY KEY,
    gender TEXT,
    SeniorCitizen TEXT,
    Partner TEXT,
    Dependents TEXT,
    tenure TEXT,
    PhoneService TEXT,
    MultipleLines TEXT,
    InternetService TEXT,
    OnlineSecurity TEXT,
    OnlineBackup TEXT,
    DeviceProtection TEXT,
    TechSupport TEXT,
    StreamingTV TEXT,
    StreamingMovies TEXT,
    Contract TEXT,
    PaperlessBilling TEXT,
    PaymentMethod TEXT,
    MonthlyCharges TEXT,
    TotalCharges TEXT,
    Churn TEXT
);
"""

def read_s3_file_to_df(bucket, key, region):
    """Reads a CSV file directly from S3 into a Pandas DataFrame."""
    s3 = boto3.client('s3', region_name=region)
    print(f"Reading {key} from S3 bucket {bucket}...")
    
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        file_content = response['Body'].read().decode('utf-8')
        df = pd.read_csv(StringIO(file_content))
        
        print(f"S3 read successful. Loaded {len(df)} rows.")
        return df
        
    except ClientError as e:
        error_code = e.response['Error']['Code']
        print(f"AWS ClientError occurred ({error_code}): {e}")
        return None
    except Exception as e:
        print(f"Unexpected error during S3 read: {e}")
        return None

def create_raw_table(conn):
    """Executes a SQL command to create the raw table."""
    print(f"Creating/recreating raw table: {RAW_TABLE_NAME}")
    with conn.cursor() as cur:
        # Drop table if it exists to ensure a clean refresh
        cur.execute(f"DROP TABLE IF EXISTS {RAW_TABLE_NAME} CASCADE;")
        conn.commit()
        
        # Create the new table
        cur.execute(CREATE_RAW_TABLE_SQL)
        conn.commit()
        print("Raw table created successfully.")

def execute_batch_insert(conn, df, table):
    """Inserts DataFrame content into the specified table using fast bulk insertion."""
    
    tuples = [tuple(x) for x in df.to_numpy()]
    cols = ','.join(list(df.columns))
    
    query  = "INSERT INTO %s(%s) VALUES %%s" % (table, cols)
    cursor = conn.cursor()
    
    try:
        print(f"Starting bulk insert of {len(tuples)} rows into {table}...")
        # Bulk insert the data using execute_values
        extras.execute_values(cursor, query, tuples, page_size=1000)
        conn.commit()
        print("Bulk insert complete.")
        return True
    except (Exception, psycopg2.Error) as error:
        print(f"Error while inserting data into CockroachDB: {error}")
        conn.rollback()
        return False
    finally:
        cursor.close()

def main():
    """Main EL function: Read from S3, Load into raw DB table."""
    conn = None 
    
    try:
        # --- EXTRACT (Read from S3 into DF) ---
        print("\n--- PHASE 1: EXTRACT (S3 to DataFrame) ---")
        df_raw = read_s3_file_to_df(BUCKET_NAME, OBJECT_KEY, AWS_REGION)
        
        if df_raw is None or df_raw.empty:
            print("Pipeline aborted.")
            return

        # --- LOAD (Into Raw Staging Table) ---
        
        # 1. Establish connection to CockroachDB
        print("\n--- PHASE 2: LOAD (DB Ingestion) ---")
        print("Establishing connection to CockroachDB...")
        conn = psycopg2.connect(**DB_PARAMS)
        conn.autocommit = False 
        print("Connection successful.")

        # 2. Create and load RAW Staging Table
        create_raw_table(conn)
        
        if execute_batch_insert(conn, df_raw, RAW_TABLE_NAME):
            print("\nPipeline successful. Raw data is available in the staging table.")

    except psycopg2.OperationalError as e:
        print(f"Database Connection Error. Check credentials, host, port, and network status: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
    finally:
        if conn:
            conn.close()
            print("\nDatabase connection closed.")

if __name__ == "__main__":
    main()
    