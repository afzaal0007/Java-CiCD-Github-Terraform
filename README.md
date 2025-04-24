# Java Application Deployment to AWS EKS
This project demonstrates a production-ready deployment of a Java Spring Boot application to Amazon EKS using GitHub Actions for CI/CD and Terraform for infrastructure provisioning.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Detailed Setup Guide](#detailed-setup-guide)
  - [AWS Configuration](#aws-configuration)
  - [GitHub Configuration](#github-configuration)
  - [Local Development](#local-development)
- [Infrastructure Components](#infrastructure-components)
- [CI/CD Pipeline](#cicd-pipeline)
- [Security Considerations](#security-considerations)
- [Monitoring and Maintenance](#monitoring-and-maintenance)
- [Requirements Coverage](#requirements-coverage)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)
- [Deployment Script (deploy.sh)](#deployment-script-deploys)
- [Makefile Commands](#makefile-commands)

## Prerequisites
- AWS Account with appropriate permissions
- GitHub Account
- Local development tools:
  - Java 17 or later
  - Docker
  - kubectl
  - helm (v3.x)
  - terraform (v1.x)
  - AWS CLI v2

## Project Structure
```
.
├── .github/workflows/          # GitHub Actions workflow definitions
├── app/                       # Java Spring Boot application
├── chart/                    # Helm chart for Kubernetes deployment
├── terraform/                # Infrastructure as Code
│   ├── modules/             # Terraform modules
│   │   ├── ecr/            # ECR repository
│   │   ├── eks/            # EKS cluster
│   │   ├── iam/            # IAM roles and policies
│   │   └── vpc/            # Network infrastructure
│   └── environments/       # Environment-specific configurations
└── scripts/                # Utility scripts
```

## Quick Start
1. Fork this repository
2. Configure AWS credentials:
   ```bash
   aws configure
   ```
3. Set up GitHub Secrets:
   - AWS_ROLE_ARN
   - (Other required secrets)

4. Initialize and apply Terraform:
   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

5. Deploy the application:
   ```bash
   git push origin main
   ```

## Detailed Setup Guide

### AWS Configuration

1. Create an OIDC Provider:
   ```bash
   aws iam create-open-id-connect-provider \
     --url https://token.actions.githubusercontent.com \
     --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" \
     --client-id-list "sts.amazonaws.com"
   ```

2. Create IAM Role:
   - Use the provided `github-oidc-trust.json`
   - Attach necessary policies:
     - AmazonEKSClusterPolicy
     - AmazonECR-FullAccess
     - Custom policies as needed

### GitHub Configuration

1. Add Repository Secrets:
   - Go to Settings > Secrets and variables > Actions
   - Add the following secrets:
     - AWS_ROLE_ARN: arn:aws:iam::<account-id>:role/<role-name>

2. Enable GitHub Actions:
   - Go to Settings > Actions > General
   - Enable "Allow all actions and reusable workflows"

### Local Development

1. Build the application:
   ```bash
   ./mvnw clean package
   ```

2. Build and run Docker image:
   ```bash
   docker build -t myapp .
   docker run -p 8080:8080 myapp
   ```

3. Deploy to local Kubernetes (minikube):
   ```bash
   helm upgrade --install myapp ./chart/myapp
   ```

## Infrastructure Components

### VPC Configuration
- Region: ap-south-1
- CIDR: 10.0.0.0/16
- Public and private subnets
- NAT Gateway for private subnet access

### EKS Cluster
- Version: 1.31
- Managed node groups
- Autoscaling enabled
- AWS Load Balancer Controller
- Metrics Server

### Security Features
- Private endpoint enabled
- Network policies
- Security groups
- IAM roles for service accounts

## CI/CD Pipeline

### Workflow Stages
1. Test
   - Unit tests
   - Integration tests
   - Code quality checks

2. Build & Push
   - Multi-stage Docker build
   - Container scanning
   - Push to ECR

3. Infrastructure
   - Terraform plan/apply
   - Infrastructure validation

4. Deploy
   - Helm chart deployment
   - Health checks
   - Rollback capability

### Reusable Workflows
- terraform-deploy.yml
- helm-deploy.yml
- configure-aws.yml

## Security Considerations
- OIDC authentication for GitHub Actions
- Least privilege IAM roles
- Network isolation
- Container security
- Secrets management

## Monitoring and Maintenance
- EKS Control Plane logging
- Container Insights
- Application metrics
- Resource monitoring
- Cost optimization

## Requirements Coverage

### 1. Application Setup 
- Spring Boot application created with start.spring.io
- Dockerfile with multi-stage build for optimization
- Helm chart with all necessary components:
  - Deployment configuration
  - Service definition
  - Ingress setup
  - Horizontal Pod Autoscaler
  - ServiceAccount configuration

### 2. Terraform Infrastructure 
- VPC module with public/private subnets
- EKS module with managed node groups
- ECR module with lifecycle policies
- IAM module for roles and policies
- Security best practices implemented

### 3. CI/CD Pipeline with GitHub Actions 
- Main CI/CD workflow
- Build and push Docker images to ECR
- Run tests
- Infrastructure deployment
- Application deployment to EKS
- Reusable workflows for better maintainability

### 4. Documentation 
- Comprehensive README with setup instructions
- AWS credentials configuration guide
- Prerequisites listed
- Security considerations documented

### 5. Security Best Practices 
- OIDC authentication for GitHub Actions
- Least privilege IAM roles
- Private subnets for EKS nodes
- Container security with non-root user
- Secure secrets management

### 6. Production Readiness 
- Helm chart with ingress and HPA
- Resource limits and requests
- Health checks and probes
- Monitoring setup
- Scalability configuration

## Future Enhancements

### 1. Testing Improvements
- Add more comprehensive tests in the Java application
- Include integration tests
- Add container security scanning in CI/CD

### 2. Documentation Enhancements
- Add architecture diagrams
- Include cost estimation
- Add troubleshooting guide

### 3. Monitoring Improvements
- Add Prometheus metrics
- Configure Grafana dashboards
- Set up alerting

## Deployment Script (deploy.sh)

The `deploy.sh` script automates the deployment process with the following features:

- **Input Validation**: Checks for required environment parameter
- **AWS Integration**: Verifies AWS credentials and EKS configuration
- **Kubernetes Setup**: Creates namespace if not exists
- **Helm Deployment**: Deploys application with proper versioning
- **Verification**: Checks deployment status

Usage:
```bash
./deploy.sh <environment> [image-tag]
# Example:
./deploy.sh dev v1.0.0
```

Key Features:
- AWS credentials verification
- EKS kubeconfig auto-update
- Namespace management
- Helm deployment with timeout and atomic updates
- Deployment verification (pods and ingress)
- Error handling and logging

## Makefile Commands

The project includes a Makefile for common development tasks:

```bash
# Build commands
make build         # Build application and Docker image
make test         # Run tests

# Docker commands
make docker-build  # Build Docker image
make docker-push   # Push to ECR

# Deployment
make deploy ENV=dev  # Deploy to dev environment
make deploy ENV=prod # Deploy to production

# Terraform commands
make tf-init      # Initialize Terraform
make tf-plan      # Plan infrastructure changes
make tf-apply     # Apply infrastructure changes
make tf-destroy   # Destroy infrastructure

# Utility
make clean        # Clean build artifacts
make help         # Show all commands
```

Key Features:
- Automated build and test processes
- Docker image management
- Environment-specific deployments
- Infrastructure management
- Clean-up utilities

For detailed usage of each command, run `make help`.

## Contributing
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License
MIT License

## Support
For issues and questions, please open a GitHub issue.