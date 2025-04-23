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

# Check if kubectl is configured
kubectl cluster-info >/dev/null || {
  echo "kubectl is not configured properly"
  exit 1
}

# Create namespace if not exists
kubectl get namespace "$NAMESPACE" >/dev/null 2>&1 || \
  kubectl create namespace "$NAMESPACE"

# Deploy with Helm
helm upgrade --install myapp charts/myapp \
  --namespace "$NAMESPACE" \
  --set image.tag="$IMAGE_TAG" \
  --values "charts/myapp/values-${ENV}.yaml" \
  --atomic \
  --wait