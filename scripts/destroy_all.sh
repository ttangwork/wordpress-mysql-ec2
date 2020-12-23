#!/bin/bash -x

# Destroy EC2
cd ../terraform/ec2
terraform plan -destroy -out tfplan -var-file environment.tfvars
terraform apply -auto-approve tfplan

# Destroy RDS
cd ../rds
terraform plan -destroy -out tfplan -var-file environment.tfvars
terraform apply -auto-approve tfplan

# Destroy VPC
cd ../network
terraform plan -destroy -out tfplan -var-file environment.tfvars
terraform apply -auto-approve tfplan