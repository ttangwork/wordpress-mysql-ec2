#!/bin/bash -x
db_user=$(aws ssm get-parameter --name wp-db-user --query 'Parameter.Value')
db_password=$(aws ssm get-parameter --name wp-db-password --query 'Parameter.Value')

sed -e "s/{db_user}/${db_user}/g" ../terraform/rds/environment.tfvars
sed -e "s/{db_password}/${db_password}/g" ../terraform/rds/environment.tfvars