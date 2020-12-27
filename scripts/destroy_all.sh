#!/bin/bash -x

# Destroy EC2
cd ../terraform/ec2
terraform init
terraform plan -destroy -out tfplan -var-file environment.tfvars
terraform apply -auto-approve tfplan

# Destroy RDS
cd ../rds
terraform init
terraform plan -destroy -out tfplan -var-file environment.tfvars
terraform apply -auto-approve tfplan

# Destroy VPC
cd ../network
terraform init
terraform plan -destroy -out tfplan -var-file environment.tfvars
terraform apply -auto-approve tfplan