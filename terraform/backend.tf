terraform {
  backend "s3" {
    bucket         = "myapp-eks-tf-state-123456789012" # This will be replaced by the actual bucket name after first apply
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "myapp-eks-tf-locks"
  }
}