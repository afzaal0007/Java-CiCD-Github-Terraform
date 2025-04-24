#!/bin/bash
set -eo pipefail

# Validate inputs
if [ -z "$1" ]; then
  echo "Usage: $0 <environment> [image-tag]"
  exit 1
fi

ENV=$1
IMAGE_TAG=${2:-latest}
NAMESPACE="myapp-${ENV}"

# Check AWS credentials
aws sts get-caller-identity >/dev/null || {
  echo "AWS credentials not configured properly"
  exit 1
}

# Check if kubectl is configured
kubectl cluster-info >/dev/null || {
  echo "kubectl is not configured properly"
  exit 1
}

# Create namespace if not exists
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || \
  kubectl create namespace "$NAMESPACE"

# Update kubeconfig for EKS cluster
aws eks update-kubeconfig --name my-eks-cluster --region ap-south-1

# Deploy with Helm
helm upgrade --install myapp chart/myapp \
  --namespace "$NAMESPACE" \
  --set image.tag="$IMAGE_TAG" \
  --values "chart/myapp/values-${ENV}.yaml" \
  --atomic \
  --timeout 10m \
  --wait

# Verify deployment
kubectl get pods -n "$NAMESPACE"
kubectl get ingress -n "$NAMESPACE"

echo "Deployment completed successfully!"