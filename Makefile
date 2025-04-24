.PHONY: build test deploy clean tf-init tf-plan tf-apply

# Variables
APP_NAME := myapp
DOCKER_REPO := $(shell aws ecr describe-repositories --repository-names ${APP_NAME} --query 'repositories[0].repositoryUri' --output text)
VERSION := $(shell git rev-parse --short HEAD)
ENV ?= dev

# Build commands
build:
	./mvnw clean package
	docker build -t ${APP_NAME}:${VERSION} .

test:
	./mvnw test

# Docker commands
docker-build:
	docker build -t ${APP_NAME}:${VERSION} .

docker-push:
	docker tag ${APP_NAME}:${VERSION} ${DOCKER_REPO}:${VERSION}
	docker push ${DOCKER_REPO}:${VERSION}

# Deployment commands
deploy:
	./deploy.sh ${ENV} ${VERSION}

# Terraform commands
tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan

tf-apply:
	cd terraform && terraform apply -auto-approve

tf-destroy:
	cd terraform && terraform destroy -auto-approve

# Clean up
clean:
	./mvnw clean
	rm -rf target/

# Help
help:
	@echo "Available commands:"
	@echo "  make build         - Build the application and Docker image"
	@echo "  make test         - Run tests"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-push  - Push Docker image to ECR"
	@echo "  make deploy       - Deploy to Kubernetes (set ENV=prod for production)"
	@echo "  make tf-init      - Initialize Terraform"
	@echo "  make tf-plan      - Plan Terraform changes"
	@echo "  make tf-apply     - Apply Terraform changes"
	@echo "  make tf-destroy   - Destroy Terraform resources"
	@echo "  make clean        - Clean up build artifacts"