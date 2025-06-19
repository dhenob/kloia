# Sock Shop GitOps CI/CD Implementation

## Project Overview

This project implements a secure CI/CD and GitOps workflow for the Sock Shop microservices demo application, leveraging Docker Hub for image management and ArgoCD for Kubernetes application deployment on OpenShift.

## Key Components

1. **CI Pipeline with GitHub Actions**
   - Docker image building with security hardening
   - Vulnerability scanning with Trivy
   - Secure publishing to Docker Hub

2. **GitOps with ArgoCD (App of Apps)**
   - Declarative application management
   - Automated sync and self-healing
   - Environment configuration through Git

3. **Security Measures**
   - Container hardening (non-root users, minimal images)
   - Image vulnerability scanning
   - Secret management via GitHub Secrets
   - Protected deployments

## Repository Structure

```
├── .github/workflows/      # GitHub Actions CI workflow definitions
├── argocd/                 # ArgoCD Application manifests
│   ├── root-app.yaml       # Root application (App of Apps pattern)
│   └── applications/       # Child application definitions
├── dockerfiles/            # Secure Dockerfiles for components
│   └── front-end/          # Front-end service with hardened configuration
├── helm-values/            # Helm chart values for different environments
│   └── sock-shop/          # Sock Shop application values
└── docs/                   # Comprehensive documentation
```

## Implementation Highlights

- **Security-hardened containers** based on official images with non-root users
- **Trivy vulnerability scanning** integrated into the CI pipeline
- **ArgoCD App of Apps pattern** for scalable application management
- **Automated sync policies** for GitOps-driven deployments
- **Self-healing capabilities** to maintain desired state
- **CI pipeline resilience** with appropriate error handling

## Documentation

For detailed information, see:

1. [CI/CD Pipeline Documentation](01-ci-cd-pipeline.md)
2. [GitOps Deployment Documentation](02-gitops-deployment.md)
3. [Operational Instructions](03-operational-instructions.md)

## Getting Started

1. Fork this repository
2. Configure GitHub Secrets for Docker Hub:
   - `DOCKER_USERNAME`: Docker Hub username
   - `DOCKER_PASSWORD`: Docker Hub access token
   - `DOCKER_REPO`: Docker Hub repository name
3. Set up ArgoCD in your OpenShift cluster
4. Apply the root application manifest to ArgoCD
5. Make changes to the Helm values file to trigger deployments 