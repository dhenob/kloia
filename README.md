# Sock Shop GitOps CI/CD Implementation

## Overview

This repository contains a secure CI/CD and GitOps workflow implementation for the Sock Shop microservices demo application, leveraging GitHub Actions for CI, Docker Hub for image management, and ArgoCD for Kubernetes application deployment on OpenShift.

## CI Pipeline Status
Last updated: June 2025

## Repository Structure

```
├── .github/workflows/      # GitHub Actions CI workflow definitions
├── argocd/                 # ArgoCD Application manifests
│   ├── root-app.yaml       # Root application (App of Apps pattern)
│   └── applications/       # Child application definitions
├── dockerfiles/            # Secure Dockerfiles for components
│   └── front-end/          # Front-end service Dockerfile
├── helm-values/            # Helm chart values
│   └── sock-shop/          # Sock Shop Helm values
└── docs/                   # Comprehensive documentation
```

## Features

- **Secure CI Pipeline**: Automated build, scan, and publish workflow with GitHub Actions
- **Container Security**: Hardened Docker images following security best practices
- **Vulnerability Scanning**: Integrated Trivy scanning for identifying security issues
- **GitOps Deployment**: ArgoCD-based deployment using the App of Apps pattern
- **Self-healing**: Automated drift detection and reconciliation
- **Comprehensive Documentation**: Detailed guides for CI/CD, GitOps, and operations

## Getting Started

### Prerequisites

- GitHub account
- Docker Hub account 
- OpenShift cluster with ArgoCD installed

### Setup Instructions

1. **Fork this repository**

2. **Configure GitHub Secrets**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Add the following secrets:
     - `DOCKER_USERNAME`: Your Docker Hub username
     - `DOCKER_PASSWORD`: Your Docker Hub access token
     - `DOCKER_REPO`: Your Docker Hub repository name

3. **Deploy ArgoCD**
   - Install ArgoCD on your OpenShift cluster
   - Apply the root application manifest:
     ```
     kubectl apply -f argocd/root-app.yaml
     ```

4. **Make Changes**
   - Update the Helm values in `helm-values/sock-shop/values.yaml`
   - Commit and push to trigger the CI pipeline
   - ArgoCD will automatically detect and apply the changes

## Documentation

For detailed documentation on all aspects of this implementation, see the [docs](./docs) directory:

- [Project Introduction](./docs/00-introduction.md)
- [CI/CD Pipeline](./docs/01-ci-cd-pipeline.md)
- [GitOps Deployment](./docs/02-gitops-deployment.md)
- [Operational Instructions](./docs/03-operational-instructions.md) 