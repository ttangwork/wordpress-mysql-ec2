[![ttangwork](https://circleci.com/gh/ttangwork/wordpress-mysql-ec2.svg?style=svg)](https://circleci.com/gh/ttangwork/wordpress-mysql-ec2)
# wordpress-mysql-ec2
IaC for wordpress and mysql running on ec2

## Prerequesites
Run s3-backend manually to create the backend bucket
Update following files:
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
* https://www.packer.io/docs/templates/engine
* https://github.com/hashicorp/packer/issues/7527
* https://circleci.com/docs/2.0/deployment-examples/#aws
* https://github.com/CircleCI-Public/circleci-packer
