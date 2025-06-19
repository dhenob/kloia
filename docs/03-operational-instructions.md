# Operational Instructions

## Triggering CI Pipeline Manually

To manually trigger the CI pipeline:

1. Go to your GitHub repository
2. Navigate to "Actions" tab
3. Select the "Docker Build, Scan & Push" workflow
4. Click "Run workflow"
5. Select the branch to run against and click "Run workflow"

## Monitoring CI Pipeline Results

To monitor the CI pipeline results:

1. Navigate to the "Actions" tab in your GitHub repository
2. Find the latest workflow run and click on it
3. View the logs of each step to diagnose any issues
4. For successful runs, check Docker Hub to verify the image was pushed correctly

## Monitoring ArgoCD Sync Status

### Using ArgoCD UI

1. Access the ArgoCD UI (typically at https://argocd-server-argocd.apps.your-cluster.com)
2. Log in with your credentials
3. The dashboard shows all applications and their sync status
4. Click on an application to see detailed sync information and history

### Using ArgoCD CLI

```bash
# Get all applications status
argocd app list

# Get detailed status for the sock-shop application
argocd app get sock-shop

# Check sync history
argocd app history sock-shop
```

## Manually Syncing Applications

### Using ArgoCD UI

1. Navigate to the application in ArgoCD UI
2. Click "Sync" button
3. Review the changes to be applied
4. Click "Synchronize" to apply the changes

### Using ArgoCD CLI

```bash
# Sync the sock-shop application
argocd app sync sock-shop

# Force sync with pruning and replacing resources
argocd app sync sock-shop --force --prune
```

## Viewing Container Vulnerability Scan Results

1. Go to your GitHub repository
2. Navigate to "Security" tab
3. Click on "Code scanning"
4. View Trivy scan results and details on vulnerabilities

## Rolling Back Deployments

### Using ArgoCD UI

1. Navigate to the application in ArgoCD UI
2. Click on "History" in the left panel
3. Find the desired revision to roll back to
4. Click the "..." menu and select "Rollback"
5. Confirm the rollback operation

### Using ArgoCD CLI

```bash
# View sync history to find the revision to roll back to
argocd app history sock-shop

# Roll back to a specific revision (e.g., revision 2)
argocd app rollback sock-shop 2
```

## Handling Common Issues

### CI Pipeline Failures

If the CI pipeline fails:

1. Check the GitHub Actions logs for the specific step that failed
2. For image build failures, verify the Dockerfile syntax and paths
3. For Trivy scan failures:
   - Review the vulnerabilities found
   - Update base images if needed
   - Consider adjusting severity thresholds or ignoring unfixable vulnerabilities
4. For push failures, verify Docker Hub credentials are set up correctly in GitHub Secrets

### Failed Container Security Scans

If a container scan fails due to vulnerabilities:

1. Review the Trivy scan results in GitHub Security tab
2. Address critical/high vulnerabilities in the application code or dependencies
3. Update base images to newer versions with security patches
4. Re-run the workflow

### ArgoCD Sync Failures

If ArgoCD fails to sync:

1. Check the application status and error messages in ArgoCD UI
2. Verify that the Git repository is accessible
3. Check for syntax errors in Kubernetes manifests or Helm values
4. Use "App Diff" in ArgoCD to understand the differences
5. Check the ArgoCD controller logs:
   ```
   oc logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
   ```

### Manual Changes Reverted by ArgoCD

If manual changes to the cluster are being reverted:

1. Remember this is expected behavior with GitOps - all changes should be made in Git
2. Make the necessary changes to the Git repository instead
3. If you need to make an emergency change that bypasses GitOps:
   ```
   # Temporarily disable auto-sync
   argocd app patch sock-shop --patch '{"spec": {"syncPolicy": null}}' --type merge
   
   # Make your changes
   
   # Re-enable auto-sync
   argocd app patch sock-shop --patch '{"spec": {"syncPolicy": {"automated": {"prune": true, "selfHeal": true}}}}' --type merge
   ```

## Best Practices

- Always store container images with version tags, never use `:latest`
- Use semantic versioning for release tags
- Regularly update base images to get security patches
- Review and rotate Docker Hub access tokens periodically
- Keep ArgoCD and GitOps configurations in a separate repository from application code 