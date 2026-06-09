from fastapi import FastAPI
import os
import socket

app = FastAPI(title="GitOps Delivery App")

@app.get("/")
def read_root():
    return {
        "message": "Hello, Automated GitOps is awesome and up!",
        "hostname": socket.gethostname(),
        "environment": os.getenv("APP_ENV", "development")
    }

@app.get("/healthz")
def health_check():
    return {"status": "healthy"}