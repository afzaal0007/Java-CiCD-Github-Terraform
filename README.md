## DevOps Depolyment: Java Application Deployment to AWS EKS

# 1. Application Setup Approach
In this section, I will outline the necessary steps to prepare your Java application for deployment.
This is a solution for deploying a Java application to AWS EKS using Terraform for infrastructure provisioning and GitHub Actions for CI/CD. Here's my step-by-step approach:

Application Setup:

Create a basic Spring Boot application using start.spring.io

Dockerize the application with a multi-stage Dockerfile

Create a Helm chart with deployment, service, and ingress configurations

Infrastructure as Code:

Use Terraform to provision:

VPC with public and private subnets

EKS cluster with managed node groups

IAM roles and policies

Security groups

Implement Terraform modules for better organization

Configure remote state storage in S3 with locking via DynamoDB

CI/CD Pipeline:

Set up GitHub Actions workflows for:

Building and pushing Docker images to ECR

Terraform plan/apply for infrastructure

Helm deployment to EKS

Implement reusable workflows for common tasks

Configure secure secret management

Documentation:

Provide clear README with setup instructions

Document security considerations

Explain architectural decisions

Implementation Details

1. Application Setup

Spring Boot Application:

Created using start.spring.io with:

Java 17

Spring Web dependency
Actuator for health checks

Helm Chart:
Created with the following structure:

charts/
  ├── myapp/
  │   ├── Chart.yaml
  │   ├── values.yaml
  │   ├── templates/
  │   │   ├── deployment.yaml
  │   │   ├── service.yaml
  │   │   ├── ingress.yaml
  │   │   ├── hpa.yaml
  │   │   └── serviceaccount.yaml
Key features:

Configurable replica count

Resource requests/limits

Liveness/readiness probes

Horizontal Pod Autoscaler

Ingress with annotations for ALB

2. Terraform Infrastructure
Module Structure:

infra/
  ├── modules/
  │   ├── vpc/
  │   ├── eks/
  │   ├── iam/
  │   └── ecr/
  ├── main.tf
  ├── variables.tf
  ├── outputs.tf
  └── backend.tf
Key Resources:

VPC with NAT gateways in public subnets

EKS cluster with:

Managed node groups (separate for apps and system workloads)

OIDC provider for IAM roles for service accounts

AWS Load Balancer Controller

Cluster Autoscaler

ECR repository for container images

IAM roles with least-privilege policies

3. CI/CD Pipeline
Workflows:

infra-deploy.yml - Terraform plan/apply for infrastructure

build-push.yml - Build and push Docker image on PR to main

deploy.yml - Helm deployment to EKS on merge to main

Reusable Workflows:

terraform.yml - Shared Terraform steps

configure-aws.yml - AWS auth setup

Security:

GitHub Actions OIDC provider for AWS credentials

Secrets encrypted in transit and at rest

IAM roles with minimal permissions

4. Documentation
README.md covers:

Prerequisites (AWS account, tools installed)

Setup instructions

Workflow descriptions

Security considerations

Troubleshooting

Challenges and Solutions
EKS Authentication:

Challenge: Securely authenticating GitHub Actions with EKS

Solution: Implemented OIDC provider for GitHub Actions to assume IAM roles directly

Terraform State Management:

Challenge: Preventing state conflicts in team environments

Solution: Configured S3 backend with DynamoDB locking

Cost Optimization:

Challenge: Minimizing AWS costs for assessment

Solution: Used spot instances for worker nodes and smaller instance types

Helm Deployment Automation:

Challenge: Automating Helm dependencies and values

Solution: Created a deployment script that handles namespace creation and value overrides

Key Files
Deployment Script (deploy.sh)

Conclusion
This implementation demonstrates a complete DevOps workflow for deploying Java applications to AWS EKS using modern practices:

Infrastructure as Code with Terraform modules

GitOps principles through GitHub Actions

Security best practices with IAM roles and OIDC

Scalability with HPA and cluster autoscaler

Maintainability through clear documentation and modular design

The solution can be easily extended for production use with additional features like:

Canary deployments

Monitoring integration

Multi-region support

Policy enforcement with OPA Gatekeeper


Key Features of This Helm Chart:
Production-Ready Configuration:

Horizontal Pod Autoscaler with CPU and memory metrics

Rolling update strategy with configurable surge/unavailability

Resource limits and requests

Liveness and readiness probes

AWS ALB Integration:

Proper annotations for ALB Ingress Controller

Health check configuration

Support for both HTTP and HTTPS

Security Best Practices:

Configurable security contexts

Service account with IAM role capability (when used with EKS IAM roles for service accounts)

Resource limits to prevent noisy neighbor issues

Flexibility:

Configurable through values.yaml

Support for multiple environments

Customizable probes, resources, and scaling

Observability:

Actuator endpoints for health checks

Standardized metrics endpoints

To use this chart, you would typically:

Customize the values.yaml for your environment

Run helm install myapp ./charts/myapp -f values-prod.yaml

Or use it in your CI/CD pipeline as shown in the deployment script earlier

Terraform module structure for your AWS EKS infrastructure, following best practices for modularity, security, and scalability:

Directory Structure
infra/
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── ecr/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── main.tf
├── variables.tf
├── outputs.tf
└── backend.tf

Key Features of This Infrastructure:
VPC Module:

Public and private subnets across multiple AZs

NAT gateways for outbound private subnet traffic

Proper tagging for EKS integration

EKS Module:

Managed node groups with spot instances for apps and on-demand for system workloads

OIDC provider for IAM roles for service accounts

AWS Load Balancer Controller and Cluster Autoscaler support

Core add-ons (VPC CNI, CoreDNS, kube-proxy)

IAM Module:

Least privilege roles for EKS administration

Support for role assumption by trusted entities

ECR Module:

Private container repositories with lifecycle policies

Image scanning on push

Configurable retention policies

Security Best Practices:

Encryption at rest for ECR and Terraform state

State locking with DynamoDB

Network isolation with private subnets

Fine-grained IAM permissions

To use this infrastructure:

Initialize Terraform: terraform init

Plan the deployment: terraform plan

Apply the changes: terraform apply

The modules are designed to be reusable across environments by parameterizing all configurable values. The backend configuration should be customized with your own S3 bucket and DynamoDB table for state management.

4. GitHub Secrets Setup
You'll need to configure these secrets in your GitHub repository settings:

AWS_IAM_ROLE - ARN of the IAM role created for GitHub Actions (output from Terraform)

AWS_REGION - AWS region where resources are deployed (e.g., us-west-2)

5. Implementation Steps
Set up the OIDC provider and IAM roles:

Apply the Terraform configuration that creates the OIDC provider and IAM roles

Note the ARN of the created IAM role for GitHub Actions

Configure GitHub Secrets:

Go to your repository Settings > Secrets > Actions

Add AWS_IAM_ROLE with the ARN from step 1

Add AWS_REGION with your AWS region

Commit the workflow files:

Place all YAML files in .github/workflows/ directory

Commit and push to trigger the initial workflow run

Initial deployment:

The first run of infra-deploy.yml will create your AWS infrastructure

Subsequent PRs will trigger builds and push images to ECR

Merges to main will trigger deployments to EKS

Key Security Features:
OIDC Authentication:

No long-lived AWS credentials stored in GitHub

Temporary credentials generated for each workflow run

Fine-grained IAM permissions

Least Privilege IAM:

Separate policies for different actions

Minimal permissions required for each task

Workflow Approvals:

Manual approval required for infrastructure changes

Separate workflows for build and deploy

Artifact Validation:

Image tags passed securely between jobs

Terraform plans reviewed before apply

Environment Protection:

Production environment with deployment gates

Branch protection for main branch

This implementation provides a secure, automated pipeline from code commit to production deployment while following DevOps best practices for infrastructure as code and continuous delivery.