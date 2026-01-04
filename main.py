import os
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException

load_dotenv()
app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/db-check")
def read_db_version():
    if os.getenv("DB_HOST") is None or os.getenv("DB_HOST") == "":
        raise HTTPException(status_code=400, detail="DB_HOST environment variable is missing or does not exist")
    if os.getenv("DB_PASSWORD") is None or os.getenv("DB_PASSWORD") == "":
        raise HTTPException(status_code=400, detail="DB_PASSWORD environment variable is missing or does not exist")

    return {"PostgreSQL version": 0.0, "Host": os.getenv("DB_HOST"), "Password": os.getenv("DB_PASSWORD")}