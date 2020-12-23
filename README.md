[![ttangwork](https://circleci.com/gh/ttangwork/wordpress-mysql-ec2.svg?style=svg)](https://circleci.com/gh/ttangwork/wordpress-mysql-ec2)
# wordpress-mysql-ec2
IaC for wordpress and mysql running on ec2

## Prerequesites
### AWS SSM parameters
The following SSM parameters are created by `rds_vars.sh` script therefore the Terraform state file doesn't contain the password.  
* wp-db-user
* wp-db-password
### Terraform S3 backend
Run `s3-backend` manually to create the backend bucket. Once the bucket is created, update the following files:
* terraform/network/backend.tf
* terraform/ec2/data.tf
* terraform/ec2/backend.tf

## Run
Through the CircleCI pipeline, a workflow of creating AWS resources:
1. Create network resources (VPC, Subnets, Gateways, Routing)
2. Create RDS resources (MariaDB)
3. Packer build using the latest Amazon Linux 2
4. Create EC2 resources (ALB and ASG)

## Patching
A scheduled job in CircleCI runs everyday at 2 AM to bake a new AMI using the latest Amazon Linux 2. Once the AMI is available, the launch configuration gets updated to use this AMI and relaunch EC2 instances.

## Destroy resources
The pipeline doesn't have any tasks to destroy the resources. However you can run `destroy_all.sh` from `scripts` or run the following commands manually:  
`terraform plan -destroy -out tfplan -var-file environment.tfvars`  
`terraform apply -auto-approve tfplan`

## Known Issues
## References
* https://learn.hashicorp.com/tutorials/terraform/circle-ci
* https://github.com/terraform-google-modules/terraform-google-cloud-dns/issues/8
* https://www.packer.io/docs/builders/amazon-ebs.html
* https://github.com/hashicorp/packer/issues/7527
* https://circleci.com/docs/2.0/deployment-examples/#aws
* https://github.com/CircleCI-Public/circleci-packer
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs
