# Sock Shop GitOps CI/CD Implementation

This repository contains a secure CI/CD and GitOps workflow implementation for the Sock Shop microservices demo application, leveraging GitHub Actions for CI, Docker Hub for image management, and ArgoCD for Kubernetes application deployment.

## Repository Structure

```
├── .github/workflows/      # GitHub Actions CI workflow definitions
├── argocd/                 # ArgoCD Application manifests
│   ├── root-app.yaml       # Root application (App of Apps pattern)
│   └── applications/       # Child application definitions
├── helm-values/            # Helm chart values for different environments
│   └── sock-shop/          
├── microservices-demo/     # Original Sock Shop application source
└── docs/                   # Documentation
```

## Features

- Secure CI pipeline with Docker image building, scanning, and publishing
- Container security hardening practices
- GitOps deployment using ArgoCD (App of Apps pattern)
- Comprehensive documentation for CI/CD and GitOps workflows

## Documentation

See the [docs](./docs/) directory for detailed documentation on:
- CI/CD Pipeline
- GitOps Deployment
- Operational Instructions 