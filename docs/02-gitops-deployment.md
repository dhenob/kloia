# GitOps Deployment Documentation

## Overview

This project implements a GitOps deployment approach using Argo CD with the "App of Apps" pattern for managing the Sock Shop microservices application on OpenShift.

## App of Apps Architecture

The "App of Apps" pattern is a hierarchical approach to application management where:

- A **Root Application** manages child applications
- **Child Applications** manage individual applications or components

This structure allows:
- Centralized management
- Environment separation
- Better organization of multiple applications
- Simplified onboarding of new applications

```
Root Application
├── Sock Shop Application
│   ├── Frontend Deployment
│   ├── Catalogue Deployment
│   ├── Orders Deployment
│   └── ...other components
└── (Future applications can be added here)
```

## ArgoCD Application Manifest Structure

### Root Application (`root-app.yaml`)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root-app
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/yourusername/sockshop-gitops.git
    path: argocd/applications
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

Key fields:
- **repoURL**: Git repository containing application manifests
- **path**: Directory path in the repository where child application manifests are stored
- **syncPolicy**: Configuration for automated syncing, pruning, and self-healing

### Child Application (`sock-shop-app.yaml`)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sock-shop
  namespace: argocd
spec:
  source:
    repoURL: https://github.com/yourusername/sockshop-gitops.git
    path: microservices-demo/deploy/kubernetes/helm-chart
    helm:
      valueFiles:
        - ../../../helm-values/sock-shop/values.yaml
  destination:
    server: https://kubernetes.default.svc
    namespace: sock-shop
```

Key fields:
- **path**: Location of the Helm chart
- **helm.valueFiles**: Values file for configuring the Helm chart
- **namespace**: Target namespace for deployment

## Git Repository Structure

```
├── argocd/
│   ├── root-app.yaml              # Root application definition
│   └── applications/              # Directory containing child applications
│       └── sock-shop-app.yaml     # Sock Shop application definition
└── helm-values/                  # Directory containing Helm values
    └── sock-shop/
        └── values.yaml           # Values for Sock Shop Helm chart
```

## Helm Values Management

The Helm values file (`helm-values/sock-shop/values.yaml`) contains configuration parameters for the Sock Shop application, including:

- Docker image references and versions
- Resource limits and requests
- Replica counts and scaling configurations
- Other application-specific settings

Changes to this file in Git trigger ArgoCD to apply the updated configuration to the OpenShift cluster.

## GitOps Change Propagation

1. Developer updates values.yaml in Git repository
2. Git webhook notifies ArgoCD of changes
3. ArgoCD detects drift between desired state (Git) and actual state (cluster)
4. ArgoCD applies changes to bring cluster state in sync with Git
5. ArgoCD continues to monitor for drift and self-heals as needed 