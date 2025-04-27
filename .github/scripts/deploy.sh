#!/bin/bash

set -euo pipefail

echo "Updating kubeconfig for EKS cluster: $EKS_CLUSTER_NAME"
aws eks update-kubeconfig --region "$AWS_REGION" --name "$EKS_CLUSTER_NAME"

echo "Deploying application with Helm..."
helm upgrade --install myapp ./helm-chart \
  --set image.repository="$ECR_REPOSITORY" \
  --set image.tag="$IMAGE_TAG"

echo "Deployment completed successfully!"
