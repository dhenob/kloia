#!/bin/bash

# This script tests connectivity between pods in the sock-shop namespace

# Get the running pods
echo "Finding pods in the sock-shop namespace..."
kubectl get pods -n sock-shop

# Test connectivity for specific pods
echo -e "\nTesting connectivity for multus-test-pod..."
echo "-------------------------------------------------"
POD="multus-test-pod"

# Test external connectivity
echo "Testing external connectivity from $POD..."
kubectl exec -n sock-shop $POD -- ping -c 2 -W 2 8.8.8.8 
if [ $? -eq 0 ]; then
  echo "✅ Success: $POD can reach external networks"
else
  echo "❌ Failed: $POD cannot reach external networks"
fi

# Test connectivity to another pod
echo -e "\nTesting connectivity for multus-bridge-pod..."
echo "-------------------------------------------------"
POD="multus-bridge-pod"

# Test external connectivity
echo "Testing external connectivity from $POD..."
kubectl exec -n sock-shop $POD -- ping -c 2 -W 2 8.8.8.8
if [ $? -eq 0 ]; then
  echo "✅ Success: $POD can reach external networks"
else
  echo "❌ Failed: $POD cannot reach external networks"
fi

# Test connectivity for the deployment pods
echo -e "\nTesting connectivity for network-test-app pods..."
echo "-------------------------------------------------"

# Get the pods for the deployment
TEST_PODS=$(kubectl get pods -n sock-shop -l app=network-test-app -o jsonpath='{.items[*].metadata.name}')
for POD in $TEST_PODS; do
  echo "Testing external connectivity from $POD..."
  kubectl exec -n sock-shop $POD -- ping -c 2 -W 2 8.8.8.8
  if [ $? -eq 0 ]; then
    echo "✅ Success: $POD can reach external networks"
  else
    echo "❌ Failed: $POD cannot reach external networks"
  fi
done

# Test pod-to-pod connectivity between the test app pods
if [[ $(echo $TEST_PODS | wc -w) -gt 1 ]]; then
  POD1=$(echo $TEST_PODS | cut -d' ' -f1)
  POD2=$(echo $TEST_PODS | cut -d' ' -f2)
  
  POD1_IP=$(kubectl get pod -n sock-shop $POD1 -o jsonpath='{.status.podIP}')
  POD2_IP=$(kubectl get pod -n sock-shop $POD2 -o jsonpath='{.status.podIP}')
  
  echo -e "\nTesting connectivity from $POD1 to $POD2 ($POD2_IP)..."
  kubectl exec -n sock-shop $POD1 -- ping -c 2 -W 2 $POD2_IP
  if [ $? -eq 0 ]; then
    echo "✅ Success: $POD1 can reach $POD2"
  else
    echo "❌ Failed: $POD1 cannot reach $POD2"
  fi
  
  echo -e "\nTesting connectivity from $POD2 to $POD1 ($POD1_IP)..."
  kubectl exec -n sock-shop $POD2 -- ping -c 2 -W 2 $POD1_IP
  if [ $? -eq 0 ]; then
    echo "✅ Success: $POD2 can reach $POD1"
  else
    echo "❌ Failed: $POD2 cannot reach $POD1"
  fi
fi

echo -e "\nNetwork connectivity test completed." 