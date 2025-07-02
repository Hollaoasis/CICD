# CI/CD Project – Flask App with GitHub Actions, Docker & Minikube

## Overview

This project demonstrates a complete Continuous Integration and Continuous Deployment (CI/CD) pipeline for a simple Flask application using:

* **GitHub Actions** for automation
* **Docker** for containerization
* **DockerHub** as the image registry
* **Minikube (Kubernetes)** for deployment

## Stack

* **Version control**: Git + GitHub
* **CI/CD**: GitHub Actions (`.github/workflows/deploy.yml`)
* **Containerization**: Docker
* **Registry**: DockerHub
* **Orchestration**: Kubernetes (Minikube local cluster)

## Project Structure

```bash
ci-cd-project/
├── app.py                  # Flask app
├── Dockerfile              # Container build file
├── requirements.txt        # Python dependencies
├── kubernetes/
│   ├── deployment.yaml     # Kubernetes deployment manifest
│   └── service.yaml        # Kubernetes service manifest
└── .github/
    └── workflows/
        └── deploy.yml      # GitHub Actions CI/CD pipeline
```

## GitHub Actions Workflow

**Path**: `.github/workflows/deploy.yml`

### Trigger:

* On every `push` to the `main` branch

### Jobs:

1. **Checkout code**
2. **Log in to DockerHub** (via secrets)
3. **Build Docker image**
4. **Push Docker image to DockerHub**
5. **Deploy to Kubernetes using kubectl**

## 🛠️ Secrets Required

Set in the GitHub repository under `Settings > Secrets and variables > Actions`:

* `DOCKER_USERNAME`: your DockerHub username
* `DOCKER_PASSWORD`: your DockerHub PAT (Personal Access Token)

## Dockerfile (example)

```dockerfile
FROM python:3.9
WORKDIR /app
COPY requirements.txt ./
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

## Kubernetes Manifests

### `deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
        - name: flask-app
          image: hollaoasis/flask-app:latest
          ports:
            - containerPort: 5000
```

### `service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-app
spec:
  type: NodePort
  selector:
    app: flask-app
  ports:
    - protocol: TCP
      port: 5000
      targetPort: 5000
```

## Test & Deploy a New Version

1. Modify the Flask app (e.g., change route response)
2. Commit and push to GitHub
3. GitHub Actions will:

   * Run linter/tests
   * Build & push the Docker image
   * Deploy it to your Minikube cluster
4. Use `kubectl get pods` or open the app via tunnel to verify

### WSL2 Access Fix (port-forward method)

If you use WSL2 and cannot access `http://192.168.49.2:PORT` in your browser:

Run this command inside WSL:

```bash
kubectl port-forward deployment/flask-app 5000:5000
```

Then open your browser on:

```
http://localhost:5000
```

This will allow you to access the app even without Minikube’s external IP.

## Useful Commands

```bash
# Start minikube
minikube start

# View cluster info
kubectl cluster-info

# View pods
kubectl get pods

# Access service (NodePort)
kubectl get svc
minikube service flask-app

# Port-forward to localhost (WSL2 fix)
kubectl port-forward deployment/flask-app 5000:5000
```

## Diagram of CI/CD Pipeline

```
GitHub Push → GitHub Actions → Docker Build & Push → Kubernetes Deploy (kubectl) → Minikube Cluster
```
