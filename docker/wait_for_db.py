import os
import time
import psycopg2
from psycopg2 import OperationalError

def wait_for_db():
    """Wait for PostgreSQL to become available."""
    max_retries = 30
    retry_delay = 1

    db_config = {
        'dbname': os.getenv('POSTGRES_DB'),
        'user': os.getenv('POSTGRES_USER'),
        'password': os.getenv('POSTGRES_PASSWORD'),
        'host': os.getenv('POSTGRES_HOST', 'db'),
        'port': os.getenv('POSTGRES_PORT', '5432')
    }

    for attempt in range(max_retries):
        try:
            conn = psycopg2.connect(**db_config)
            conn.close()
            print("Database is available!")
            return True
        except OperationalError:
            print(f"Waiting for database... (attempt {attempt + 1}/{max_retries})")
            time.sleep(retry_delay)

    print("Database connection failed after maximum retries")
    return False

if __name__ == '__main__':
    wait_for_db()