# Multus CNI Configuration Guide

## Overview

Multus CNI is a Container Network Interface (CNI) plugin that enables attaching multiple network interfaces to pods in Kubernetes. This document describes the setup and configuration of Multus CNI for Docker Desktop Kubernetes.

## Current Setup

1. **Multus CNI Installation**
   
   Multus CNI is already installed on the Docker Desktop Kubernetes cluster:
   
   ```bash
   $ kubectl get daemonset -n kube-system | grep multus
   kube-multus-ds   1         1         1       1            1           <none>
   ```

2. **Network Attachment Definitions**

   We have created two network attachment definitions:
   
   ```bash
   $ kubectl get network-attachment-definitions -n sock-shop
   NAME           AGE
   bridge-conf    30m
   macvlan-conf   35m
   ```

   - **macvlan-conf**: Uses macvlan to create a secondary interface connected directly to the host network
   - **bridge-conf**: Uses a bridge network for pod-to-pod communication

## Testing Configurations

We have created several test pods to verify the Multus CNI functionality:

1. **Simple test pod with macvlan**:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: multus-test-pod
     namespace: sock-shop
     annotations:
       k8s.v1.cni.cncf.io/networks: macvlan-conf
   spec:
     containers:
     - name: multus-test-container
       image: nicolaka/netshoot
       command: ["sleep", "3600"]
   ```

2. **Test pod with bridge network**:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: multus-bridge-pod
     namespace: sock-shop
     annotations:
       k8s.v1.cni.cncf.io/networks: bridge-conf
   spec:
     containers:
     - name: multus-bridge-container
       image: nicolaka/netshoot
       command: ["sleep", "3600"]
   ```

3. **Test application deployment**:
   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: network-test-app
     namespace: sock-shop
   spec:
     replicas: 2
     selector:
       matchLabels:
         app: network-test-app
     template:
       metadata:
         labels:
           app: network-test-app
       spec:
         containers:
         - name: network-test-app
           image: nicolaka/netshoot
           command: ["sleep", "infinity"]
   ```

## Limitations and Issues

When testing on Docker Desktop Kubernetes, we encountered some limitations:

1. **Secondary interfaces not visible**: Despite having Multus CNI installed and NetworkAttachmentDefinitions created, the secondary network interfaces are not appearing in the pods.

2. **Docker Desktop network isolation**: Docker Desktop's Kubernetes has a specific network setup that might limit the full functionality of Multus CNI.

## Troubleshooting

To verify your Multus CNI setup:

1. Check if Multus is running:
   ```bash
   kubectl get pods -n kube-system | grep multus
   ```

2. Check network attachment definitions:
   ```bash
   kubectl get network-attachment-definitions --all-namespaces
   ```

3. Check pods with network annotations:
   ```bash
   kubectl describe pod -n sock-shop multus-test-pod
   ```

4. Examine pod network interfaces:
   ```bash
   kubectl exec -it -n sock-shop multus-test-pod -- ip addr
   ```

## ArgoCD Integration

We have integrated the Multus CNI configuration into our ArgoCD setup:

1. **NetworkAttachmentDefinition resources** are defined in the `network-configs` directory.

2. **ArgoCD Application** defined in `argocd/applications/multus-config-local.yaml` manages these resources.

3. **Root Application** (`argocd/root-app-local.yaml`) includes both the frontend and Multus network configurations.

## Verification Script

A verification script is available at `network-configs/verify-multus.sh` to check the Multus CNI configuration and verify network interfaces. 