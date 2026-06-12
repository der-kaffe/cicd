from fastapi import FastAPI
import time

app = FastAPI(title="CICD Portfolio API", version="1.0.0")

START_TIME = time.time()


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "uptime_seconds": round(time.time() - START_TIME, 2),
        "version": app.version,
    }


@app.get("/")
def root():
    return {"message": "CICD Portfolio API is running"}
