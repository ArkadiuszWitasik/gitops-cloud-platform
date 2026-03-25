import os

import psycopg2
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException

load_dotenv()
app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/health-check")
def health_check():
    return {"status": "ok"}


@app.get("/db-check")
def read_db_version():
    conn = None
    if os.getenv("DB_HOST") is None or os.getenv("DB_HOST") == "":
        raise HTTPException(
            status_code=400,
            detail="DB_HOST environment variable is missing or does not exist",
        )
    if os.getenv("DB_PASSWORD") is None or os.getenv("DB_PASSWORD") == "":
        raise HTTPException(
            status_code=400,
            detail="DB_PASSWORD environment variable is missing or does not exist",
        )
    try:
        conn = psycopg2.connect(
            dbname="postgres",
            user="postgres",
            password=os.getenv("DB_PASSWORD"),
            host=os.getenv("DB_HOST"),
        )
        cursor = conn.cursor()
        cursor.execute("SELECT version()")
        db_version = cursor.fetchone()
    except (Exception, psycopg2.DatabaseError) as error:
        raise HTTPException(status_code=400, detail=error)
    finally:
        if conn is not None:
            conn.close()

    return {"PostgreSQL version": db_version}
