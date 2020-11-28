[![ttangwork](https://circleci.com/gh/ttangwork/wordpress-mysql-ec2.svg?style=svg)](https://circleci.com/gh/ttangwork/wordpress-mysql-ec2)
# wordpress-mysql-ec2
IaC for wordpress and mysql running on ec2

## Prerequesites
### AWS SSM parameters
The following SSM parameters need to be set up beforehand:
* wp-db-user
* wp-db-password
You need to specify the username and password for your RDS database in these parameters.
### Terraform S3 backend
Run `s3-backend` manually to create the backend bucket. Once the bucket is created, update the following files:
* terraform/network/backend.tf
* terraform/ec2/data.tf
* terraform/ec2/backend.tf

## Run
Through CircleCI pipeline, the workflow:
1. Create network resources using Terraform (VPC, Subnets, Gateways, Routing)
2. Packer build using the latest Amazone Linux 2
3. Create EC2 resources using Terraform (ALB and ASG)
4. Destroy EC2 resources
5. Destroy network resources

## Patching
A scheduled job in CircleCI runs everyday at 2 AM to bake a new AMI using the latest Amazon Linux 2. Once the AMI is available, the launch configuration gets updated to use this AMI and relaunch EC2 instances.
## Known Issues

## References
* https://learn.hashicorp.com/tutorials/terraform/circle-ci
* https://github.com/terraform-google-modules/terraform-google-cloud-dns/issues/8
* https://www.packer.io/docs/builders/amazon-ebs.html
* https://github.com/hashicorp/packer/issues/7527
* https://circleci.com/docs/2.0/deployment-examples/#aws
* https://github.com/CircleCI-Public/circleci-packer
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs
