from typing import Union
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/db-check")
def read_db_version():
    return {"PostgreSQL version": 0.0}