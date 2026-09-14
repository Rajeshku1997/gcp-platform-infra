from app import app


def test_home():
    client = app.test_client()
    response = client.get("/")
    assert response.status_code == 200
    assert b"Hello from DevOps application!" in response.data


def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200
    assert response.data == b"healthy"


def test_ready():
    client = app.test_client()
    response = client.get("/ready")
    assert response.status_code == 200
    assert response.data == b"ready"
