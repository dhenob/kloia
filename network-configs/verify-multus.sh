#!/bin/bash

# This script verifies the Multus CNI configuration and network interfaces in the test pod

# Check if Multus is deployed
echo "Checking if Multus CNI is deployed..."
kubectl get daemonset -n kube-system | grep multus

# Check if the NetworkAttachmentDefinition is created
echo -e "\nChecking NetworkAttachmentDefinition..."
kubectl get network-attachment-definitions -n sock-shop

# Check if the test pod is running
echo -e "\nChecking if test pod is running..."
kubectl get pod -n sock-shop multus-test-pod

# If the pod is running, check its network interfaces
if [ $? -eq 0 ]; then
  echo -e "\nListing network interfaces in the pod..."
  kubectl exec -it -n sock-shop multus-test-pod -- ip addr

  echo -e "\nTesting connectivity through default interface..."
  kubectl exec -it -n sock-shop multus-test-pod -- ping -c 3 8.8.8.8

  echo -e "\nTesting connectivity through secondary interface (if available)..."
  # Get the IP of the secondary interface (net1)
  SECONDARY_IP=$(kubectl exec -it -n sock-shop multus-test-pod -- ip -j addr show net1 | grep -o '"local":"[^"]*' | cut -d'"' -f4)
  if [ ! -z "$SECONDARY_IP" ]; then
    echo "Secondary interface IP: $SECONDARY_IP"
    kubectl exec -it -n sock-shop multus-test-pod -- ping -c 3 -I net1 192.168.10.1
  else
    echo "Secondary interface not found or IP not assigned"
  fi
fi 