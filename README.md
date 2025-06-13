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
│   └── deployment.yaml     # Kubernetes manifest
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

## Secrets Required

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

## Kubernetes Manifest (deployment.yaml)

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
        - name: flask-container
          image: hollaoasis/your-image-name:latest
          ports:
            - containerPort: 5000
```

## Test & Deploy a New Version

1. Modify the Flask app (e.g., change route response)
2. Commit and push to GitHub
3. GitHub Actions will:

   * Run linter/tests
   * Build & push the Docker image
   * Deploy it to your Minikube cluster
4. Use `kubectl get pods` or open the app via NodePort to verify

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
```

## Diagram of CI/CD Pipeline

```
GitHub Push → GitHub Actions → Docker Build & Push → Kubernetes Deploy (kubectl) → Minikube Cluster
```
