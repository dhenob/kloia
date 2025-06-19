# CI/CD Pipeline Documentation

## Overview

The CI/CD pipeline for the Sock Shop application is implemented using GitHub Actions. The pipeline is responsible for:

1. Building Docker images for the application components
2. Scanning images for security vulnerabilities
3. Pushing images to Docker Hub with appropriate tags
4. Ensuring all credentials and sensitive data are securely stored

## Pipeline Stages

### Build

The build stage:
- Uses the official Sock Shop images as a base
- Applies security hardening:
  - Runs containers as non-root user (UID 10001)
  - Uses minimal Alpine-based images
  - Sets appropriate security contexts
  - Implements health checks

### Security Scanning

The pipeline incorporates Trivy, a comprehensive vulnerability scanner that:
- Scans container images for known vulnerabilities (CVEs)
- Checks for configuration issues and security best practices
- Generates SARIF reports viewable in the GitHub Security tab
- Ignores unfixable vulnerabilities to reduce false positives
- Includes fallbacks for resilient CI execution

### Push

Images are pushed to Docker Hub with multiple tags:
- Semantic version tags for releases (v1.0.0)
- Branch name tags (main, develop)
- Git commit SHA tags (sha-abc123)

## Secrets and Security

The following GitHub Secrets are required:
- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub access token (never use your account password)
- `DOCKER_REPO`: Docker Hub repository name

## Adding/Removing Secrets

To add or update secrets:
1. Navigate to your GitHub repository
2. Go to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Enter the name and value, then click "Add secret"

## Image Tagging Strategy

- **Semantic versioning tags** (v1.0.0): For release versions
- **Branch tags** (main, develop): For tracking the latest on specific branches
- **SHA tags** (sha-abc123): For precise identification of image versions

## CI Pipeline Trigger Events

- **Push to main/master**: Triggers build, scan, and push
- **Pull requests to main/master**: Triggers build and scan only
- **Tag creation (v*.*.*)**: Triggers build, scan, and push
- **Manual dispatch**: Can be triggered manually via GitHub UI

## Error Handling

The pipeline includes several error handling mechanisms:
- Vulnerability scanning is set to continue even if issues are found
- Debug steps to help diagnose problems
- Fallback mechanisms for SARIF file creation
- Local image tagging to ensure reliable scanning 