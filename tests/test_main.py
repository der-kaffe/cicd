from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_root_returns_200():
    response = client.get("/")
    assert response.status_code == 200


def test_root_message():
    response = client.get("/")
    assert response.json()["message"] == "CICD Portfolio API is running"


def test_health_returns_200():
    response = client.get("/health")
    assert response.status_code == 200


def test_health_status_is_healthy():
    response = client.get("/health")
    assert response.json()["status"] == "healthy"


def test_health_contains_uptime():
    response = client.get("/health")
    assert "uptime_seconds" in response.json()


def test_health_contains_version():
    response = client.get("/health")
    assert response.json()["version"] == "1.0.0"
